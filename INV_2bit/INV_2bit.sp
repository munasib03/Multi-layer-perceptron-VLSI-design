** Generated for: hspiceD
** Generated on: Oct 11 13:25:46 2025
** Design library name: ECE555
** Design cell name: INV_2bit
** Design view name: schematic


** Library name: ECE555
** Cell name: INV
** View name: schematic
.subckt INV in out
mn0 out in vss! vss! nmos_lvt w=27e-9 l=20e-9 nfin=1
mp1 out in vdd! vdd! pmos_lvt w=54e-9 l=20e-9 nfin=2
.ends INV
** End of subcircuit definition.

** Library name: ECE555
** Cell name: INV_2bit
** View name: schematic
xi3 in<1> out<1> INV
xi2 in<0> out<0> INV

