
// UV Data-Path Controller
function [3:0] UVDatapathController;
   input [1:0] c,d;
   input [`WORD_SIZE-1:0] U,V;

   begin
      if(c == 0) begin
         UVDatapathController = 4'd0;
      end else if(d == 0) begin
         UVDatapathController = 4'd1;
      end else if(c == d && U > V) begin
         UVDatapathController = 4'd2;
      end else if(c == d) begin
         UVDatapathController = 4'd3;
      end else if(c == 2 && (U >> 1) > V) begin
         UVDatapathController = 4'd4;
      end else if(c == 2) begin
         UVDatapathController = 4'd5;
      end else if(d == 2 && (U > (V >> 1))) begin
         UVDatapathController = 4'd6;
      end else if(d == 2) begin
         UVDatapathController = 4'd7;
      end else if(U > V) begin
         UVDatapathController = 4'd8;
      end else begin
         UVDatapathController = 4'd9;
      end
   end
endfunction

// determine shift and bypass flag in the next cycle for R-S paths.
function [4:0] UVDatapathController_aux;
   input [1:0] c,d;
   input [`WORD_SIZE-1:0] U,V;

   begin
      // bypass 1bit, 2bit for thru or 2x or zero
      if(c == 0) begin
         UVDatapathController_aux = {1'b1, 2'b10, 2'b00}; // path(ctrl-signal-equivalent to) 0
      end else if(d == 0) begin
         UVDatapathController_aux = {1'b1, 2'b10, 2'b00}; // path 1
      end else if(c == d && U > V) begin
         UVDatapathController_aux = {1'b1, 2'b00, 2'b00}; // path 2
      end else if(c == d) begin
         UVDatapathController_aux = {1'b1, 2'b00, 2'b00}; // path 3
      end else if(c == 2 && (U >> 1) > V) begin
         UVDatapathController_aux = {1'b1, 2'b01, 2'b00}; // path 4
      end else if(c == 2) begin
         UVDatapathController_aux = {1'b0, 2'b00, 2'b01}; // path 5
      end else if(d == 2 && (U > (V >> 1))) begin
         UVDatapathController_aux = {1'b0, 2'b00, 2'b01};
      end else if(d == 2) begin
         UVDatapathController_aux = {1'b1, 2'b01, 2'b00};
      end else if(U > V) begin
         UVDatapathController_aux = {1'b1, 2'b01, 2'b01};
      end else begin
         UVDatapathController_aux = {1'b1, 2'b01, 2'b01};
      end
   end
endfunction

// U' Pre-operation
function [`WORD_SIZE-1:0] CalculateUp;
   input [3:0] ctrl;
   input [`WORD_SIZE-1:0] U;

   begin
      if (ctrl == 0 || ctrl == 2 || ctrl == 3 || ctrl == 4 || ctrl == 5) begin
         CalculateUp = U >> 2;
      end else if(ctrl == 6 || ctrl == 7 || ctrl == 8 || ctrl == 9 ) begin
         CalculateUp = U >> 1;
      end else begin
         CalculateUp = 0;
      end
   end
endfunction

// V' Pre-operation
function [`WORD_SIZE-1:0] CalculateVp;
   input [3:0] ctrl;
   input [`WORD_SIZE-1:0] V;

   begin
      if (ctrl == 1 || ctrl == 2 || ctrl == 3 || ctrl == 6 || ctrl == 7) begin
         CalculateVp = V >> 2;
      end else if(ctrl == 4 || ctrl == 5 || ctrl == 8 || ctrl == 9 ) begin
         CalculateVp = V >> 1;
      end else begin
         CalculateVp = 0;
      end
   end
endfunction

// R' Pre-operation (for subtractor path)
// 1bit shift = WORD_SIZE + 1
function [`WORD_SIZE:0] CalculateRp;
   input [3:0] ctrl;
   input [`WORD_SIZE-1:0] R;

   begin
      // R IS SHIFTED ONLY WHEN FIRST OPERAND IS NEEDED TO SHIFT.
      // which means real R and S in the algorithm might be swapped to S and R.
      // You should regard R as just the first parameter of the subtractor, S the second one.
      // So when shifted, the register R might be S in S=2S-R, for example.
      if (ctrl == 10 || ctrl == 6 || ctrl == 7) begin
         CalculateRp = R << 1;
      end else begin
         CalculateRp = R;
      end
   end
endfunction

// S' Pre-operation (for subtractor path)
// 1bit shift and negative flag 1bit = WORD_SIZE + 1
function [`WORD_SIZE+1:0] CalculateSp;
   input [3:0] ctrl;
   input [`WORD_SIZE-1:0] S;

   begin
      if(ctrl == 4 || ctrl == 5) begin
         CalculateSp = ~{1'b0, S, 1'b0};
      end else if(ctrl == 0 || ctrl == 1 || ctrl == 10) begin
         CalculateSp = 0;
      end else begin
         CalculateSp = ~{2'b0, S};
      end
   end
endfunction
// S'' Pre-operation (for x4 path)
function [`WORD_SIZE+1:0] CalculateSpp;
   input [3:0] ctrl;
   input [`WORD_SIZE-1:0] S;

   begin
      if(ctrl == 10 || ctrl == 5 || ctrl == 6 || ctrl == 8 || ctrl == 9 ) begin
         CalculateSpp = S << 1;
      end else begin
         CalculateSpp = S << 2;
      end
   end
endfunction

// Ladder Selection for R
function [`WORD_SIZE-1:0] LadderSelectionR;
   input flag0, flag1; // flag0: is FR0 negative, flag1: is FR1 negative
   input [`WORD_SIZE-1:0] FR0, FR1, FR2;

   begin
      if(flag0==1 && flag1==1) begin
	 LadderSelectionR = FR2;
      end else if(flag0==1 && flag1 == 0) begin
	 LadderSelectionR = FR1;
      end else if(flag0==0 && flag1 == 0) begin
	 LadderSelectionR = FR0;
      end
   end
endfunction

// Ladder Selection for S
function [`WORD_SIZE-1:0] LadderSelectionS;
   input flag0, flag1, flag2;
   input [`WORD_SIZE-1:0] S, FS0, FS1, FS2;

   begin
      if         (flag2==1 && flag1==1 && flag0==1) begin
	 LadderSelectionS = S;
      end else if(flag2==1 && flag1==1 && flag0==0) begin
	 LadderSelectionS = FS0;
      end else if(flag2==1 && flag1==0 && flag0==0) begin
	 LadderSelectionS = FS1;
      end else if(flag2==0 && flag1==0 && flag0==0) begin
	 LadderSelectionS = FS2;
      end
   end
endfunction

function [`WORD_SIZE-1:0] LadderSelectionShifter;
   input [1:0] t;
   input [`WORD_SIZE-1:0] a;

   begin
      if(t == 1) begin
	 LadderSelectionShifter = a >> 1;
      end else begin
	 LadderSelectionShifter = a >> 2;
      end
   end
endfunction
