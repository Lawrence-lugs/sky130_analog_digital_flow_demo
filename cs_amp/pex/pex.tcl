gds read ../layout/cs.gds
load cs
flatten cs_flat
load cs_flat
select top cell
port makeall
extract do local
extract all # HAS to come after port makeall
ext2sim labels on
ext2sim
# extresist tolerance 10
# extresist
ext2spice lvs
ext2spice cthresh 0
ext2spice extresist on
ext2spice format ngspice
ext2spice -o cs.spice
exit
