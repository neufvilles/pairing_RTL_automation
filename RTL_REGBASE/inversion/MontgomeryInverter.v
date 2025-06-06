`include "./include/parameter.vh"
// Calculate Mont(mod_inverse(a,p)) from Mont(a)
// this method is based on "Ultra High-Speed Scalc_core ASIC Implementation", 2014.
module MontgomeryInverter(
	input wire clk,
	input wire rst_n,
	input wire start,
	input wire [`WORD_SIZE-1: 0]	a,
	output wire [`WORD_SIZE-1: 0]	c,
	output reg  					comp
);

reg [`WORD_SIZE-1:0]                                                 U,V,R,S;
wire [`WORD_SIZE-1:0]                                                Up, Vp, _R, _S, __R, __S;
wire [`WORD_SIZE-1:0]                                                UmV, VmU;
wire [3:0]                                                           ctrl; // current control signal; UV datapath controller
reg [3:0]                                                            ctrl_reg; // previous control signal; RS datapath controller (pipelined)
wire [4:0]                                                           aux;
reg [4:0]                                                            aux_reg;
reg                                                                  end_flag;

wire [`WORD_SIZE-1:0]                                                R_PATH_OUT, S_PATH_OUT;
reg [`WORD_SIZE-1:0]                                                 out;

reg [5:0]                                                            state;
assign c = out; // outpu soignal

// Helper functions are stored in another verilog source.
`include "./inversion/mod_InversionHelper.v"

///////////////////////////////////////////////////////////////
// Swap Logic
reg                                                                  SWp; // previous swap logic;
wire                                                                 SWc; // current swap logic
wire                                                                 NeedSwapping;
function SwapLogic;
	input [3:0]                                                       ctrl;
	begin
		SwapLogic = ctrl[0];
	end
endfunction

////////////////////////////////////////////////////////////////
// Path 1: UV data path
// Data Pre-operation
assign ctrl = UVDatapathController(U[1:0], V[1:0], U, V); // UV Control Unit
assign aux = UVDatapathController_aux(U[1:0], V[1:0], U, V);
assign Up = CalculateUp(ctrl, U); // Obtain U' from U through Data Pre-operation
assign Vp = CalculateVp(ctrl, V); // Obtain V' from V through Data Pre-operation

// UV data-path cell
// U'-V'
DW01_sub	#(`WORD_SIZE) mod_UmV( .A( Up ), .B( Vp ), .CI(1'b0), .DIFF( UmV ), .CO( ) );
// V'-U'
DW01_sub	#(`WORD_SIZE) mod_VmU( .A( Vp ), .B( Up ), .CI(1'b0), .DIFF( VmU ), .CO( ) );

// Path 2: RS data path
assign SWc = SwapLogic(ctrl_reg);
assign NeedSwapping = SWc ^ SWp; // We need to swap R and S only when SWc != SWp.

assign _R = NeedSwapping ? S : R;
assign _S = NeedSwapping ? R : S;
assign __R = aux_reg[1] ? {`WORD_SIZE{1'b0}} : _R;
assign __S = aux_reg[3] ? {`WORD_SIZE{1'b0}} : _S;

Div4 d4( .a(__R), .b(__S), .flg2x_a(aux_reg[0]), .flg2x_b(aux_reg[2]), .c(R_PATH_OUT) );
Div2 d2( .a(_S), .bypass(aux_reg[4]), .c(S_PATH_OUT) );

always @( posedge clk or negedge rst_n) begin
	if( !rst_n ) begin
		U <= 0;
		V <= 0;
		R <= 0;
		S <= 0;
		comp <= 0;
		state <= 0;
		ctrl_reg <= 0;
		aux_reg <= 0;
		SWp <= 0;
		out <= 0;
		end_flag <= 0;
	end	
	else begin
		case(state)
			0: begin
				comp <= 0;
				if(start) begin
					U <= a;
					V <= `CHAR;
					R <= `INVERSION_INITIAL_VALUE;
					S <= 0;
					state <= 1;
					ctrl_reg <= 0;
					aux_reg <= 0;
					SWp <= 0;
					out <= 0;
					end_flag <= 0;
				end
			end

			1: begin
				//R <= 0;
				//S <= `MONTGOMERY_NUMBER_INV;
				// Pipeline Stage 1: UV Datapath Operations
				if(ctrl[0] == 0) begin
					U <= UmV;
					V <= ctrl == 6 ? (V >> 1) : V;
				end else if(ctrl[0] == 1) begin
					U <= ctrl == 5 ? (U >> 1) : U;
					V <= VmU;
				end
				ctrl_reg <= ctrl;
				aux_reg <= aux;
				state <= 2;
			end

			2: begin
				// Pipeline Stage 1: UV Datapath Operations
				if(ctrl[0] == 0) begin
					U <= UmV;
					V <= ctrl == 6 ? (V >> 1) : V;
				end else if(ctrl[0] == 1) begin
					U <= ctrl == 5 ? (U >> 1) : U;
					V <= VmU;
				end

				end_flag <= !(|V);
				if(end_flag) begin
					comp <= 1;
					state <= 0;
				end

				// hand current controll signal to the ctrl_register, to delay the calculation of RS datapath into next the next cycle.
				ctrl_reg <= ctrl;
				aux_reg <= aux;

				// deteminined next SWp
				SWp <= SWc;

				// Pipeline Stage 2: RS Datapath Operations
				R <= R_PATH_OUT;
				S <= S_PATH_OUT;

				out <= S;
			end
		endcase
	end
end

endmodule
