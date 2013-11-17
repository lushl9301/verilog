CE3001-Project
==============

Control Signal
--------------
<table>
<tr><td>Instr</td><td>S0</td><td>S1</td><td>S2</td><td>S3</td><td>S4</td><td>S5</td><td>S6</td><td>S7</td><td>S8</td><td>S9</td><td>S10</td><td>S11</td><td>S12</td><td>S13</td><td>S14</td><td>S15</td><td>ALUOp</td><td>RFEn</td><td>MEn</td><td>MWEn</td><td>FLAG_En</td></tr>

<tr><td>ADD</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>c</td><td>c</td><td>c</td><td>c</td><td>000</td><td>1</td><td>0</td><td>1</td><td>1</td></tr>

<tr><td>SUB</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>c</td><td>c</td><td>c</td><td>c</td><td>001</td><td>1</td><td>0</td><td>1</td><td>1</td></tr>

<tr><td>AND</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>c</td><td>c</td><td>c</td><td>c</td><td>010</td><td>1</td><td>0</td><td>1</td><td>1</td></tr>

<tr><td>OR</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>c</td><td>c</td><td>c</td><td>c</td><td>011</td><td>1</td><td>0</td><td>1</td><td>1</td></tr>

<tr><td>SLL</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>x</td><td>0</td><td>0</td><td>0</td><td>c</td><td>x</td><td>c</td><td>x</td><td>100</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>SRL</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>x</td><td>0</td><td>0</td><td>0</td><td>c</td><td>x</td><td>c</td><td>x</td><td>101</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>SRA</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>x</td><td>0</td><td>0</td><td>0</td><td>c</td><td>x</td><td>c</td><td>x</td><td>110</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>
<tr><td>RL</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>x</td><td>0</td><td>0</td><td>x</td><td>0</td><td>0</td><td>0</td><td>c</td><td>x</td><td>c</td><td>x</td><td>111</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>LW</td><td>0</td><td>x</td><td>x</td><td>0</td><td>1</td><td>x</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>1</td><td>c</td><td>x</td><td>c</td><td>x</td><td>000</td><td>1</td><td>1</td><td>1</td><td>0</td></tr>

<tr><td>SW</td><td>0</td><td>x</td><td>x</td><td>x</td><td>1</td><td>x</td><td>x</td><td>x</td><td>1</td><td>0</td><td>x</td><td>1</td><td>c</td><td>x</td><td>c</td><td>x</td><td>000</td><td>0</td><td>1</td><td>0</td><td>0</td></tr>

<tr><td>LHB</td><td>0</td><td>x</td><td>x</td><td>0</td><td>x</td><td>x</td><td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td><td>x</td><td>c</td><td>x</td><td>c</td><td>xxx</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>LLB</td><td>0</td><td>x</td><td>x</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>x</td><td>c</td><td>x</td><td>c</td><td>010</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>B(S)</td><td>1</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>0</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>xxx</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>B(N)</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>xxx</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>JAL</td><td>1</td><td>0</td><td>1</td><td>1</td><td>x</td><td>x</td><td>1</td><td>0</td><td>x</td><td>0</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>xxx</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>JR</td><td>1</td><td>1</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>1</td><td>0</td><td>0</td><td>0</td><td>x</td><td>c</td><td>x</td><td>c</td><td>xxx</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>EXEC</td><td>1</td><td>1</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>1</td><td>0</td><td>0</td><td>0</td><td>x</td><td>c</td><td>x</td><td>c</td><td>xxx</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>

<tr><td>EXEC(N)</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>1</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>xxx</td><td>0</td><td>0</td><td>1</td><td>0</td></td></tr>
</table>

    S9: if (S9 == 1) pass in RAdrr2, if (S9 == 0) pass in WAdrr

    S12: between S14 and  S4;  1 means choose from MUX_6_Out; 0 means choose from RF
    S13: between S15 and  S5;  1 means choose from MUX_6_Out; 0 means choose from RF
    MUX_6_Out is ALUOut/PC+1/LHBOut


    S14: between RData1 and  S12;  1 means choose from MUX_7_Out; 0 means choose from RF
    S15: between RData2 and  S13;  1 means choose from MUX_7_Out; 0 means choose from RF
    MUX_7_Out is MUX_6_Out/MEM_Out
