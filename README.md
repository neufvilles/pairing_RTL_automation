# pairing_RTL_automation
このレポジトリは
ASICのペアリング用ハードウェアアクセラレータを最適化する自動設計ツールです。
fukuda氏の[自動設計ツール](https://github.com/wtrgjadmw/pairing_automation_design)を参考に作成されています。
より回路規模の大きい演算器を組み込んだため、
fukuda氏の自動設計ツールと比べ、レイテンシ面が2倍以上改善されています。

一部の拡大体のみ
($` \mathbb{F}_{p^2}=\mathbb{F}_{p}/(i^2+1) `$)
対応可能ですが、演算器を組み替えることにより全ての拡大方法に対応可能になる予定です。

# 使い方
## 前提
- python version >= 3.13
- sagemath version >= 10.4
- scheduler: CPLEX
## ファイル構成
```
.
├── python ... including python scripts
├── RTL_RAMBASE ... memory array is RAM-based
└── RTL_REGBASE ... Memory array is REG-based
```
RAMベースのペアリング演算を自動設計する場合は`RTL_RAMBASE`を
レジスタベースのペアリング演算を自動設計する場合は`RTL_REGBASE`を
`RTL`というディレクトリ名に変更して以下の手順を実行してください。

※ディレクトリ`img`にはRAMベースとレジスタベースのアーキテクチャの画像ファイルが保管されています。
## 手順
1.パラメータuからペアリング演算に必要なパラメータ (p, r, b, BT, Tower Extension, twist type, P, Q)を計算します。 
```
$ cd ./python/sagemath
$ path/to/sage-python bls12.py (or bls24.py) -u <unique_parameter> 
```
2.スケジューリングに必要なFp演算、Fp2演算とオペランドを列挙するCSVファイルを作成します。
```
$ cd ../
$ python export_formula/make_csv.py -c <curve_group> -p <p[bit]> -f ../parameter/param.json
```
※作成したCSVファイルは以下をコマンドプロンプト上でテストすることができます。
```
$ python export_formula/test.py -c <curve_group> -p <p[bit]> -f ../parameter/param.json
```
3.分割スケジューリングを行うpythonのスクリプトを実行し、各演算モードのスケジューリング問題を計算します。
```
$ python scheduling/all_schedule.py  -c <curve_group> -p <p[bit]> -m <number_of_multipliers: default=1> -a <number_of_adders: default=4>
```
4.スケジューリング結果をシーケンサのRTLに変換し、必要に応じて他の部分を修正します。
```
$ python makeRTL/<curve_group>_modify.py -c <curve_group> -p <p[bit]>
$ python makeRTL/write_sequence.py -c <curve_group> -p <p[bit]>
```
