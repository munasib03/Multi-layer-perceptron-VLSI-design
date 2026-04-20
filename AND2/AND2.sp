
** Library name: ECE555
** Cell name: NAND2
** View name: schematic
.subckt NAND2 in0 in1 out
mp1 vdd! in1 out vdd! pmos_rvt w=81e-9 l=20e-9 nfin=3
mp0 out in0 vdd! vdd! pmos_rvt w=81e-9 l=20e-9 nfin=3
mn3 net11 in1 vss! vss! nmos_rvt w=108e-9 l=20e-9 nfin=4
mn2 out in0 net11 vss! nmos_rvt w=108e-9 l=20e-9 nfin=4
.ends NAND2
** End of subcircuit definition.

** Library name: ECE555
** Cell name: INV
** View name: schematic
.subckt INV in out
mn0 out in vss! vss! nmos_lvt w=54e-9 l=20e-9 nfin=2
mp1 out in vdd! vdd! pmos_lvt w=81e-9 l=20e-9 nfin=3
.ends INV
** End of subcircuit definition.

** Library name: ECE555
** Cell name: AND2
** View name: schematic
xi0 in0 in1 net3 NAND2
xi3 net3 out INV
.END
