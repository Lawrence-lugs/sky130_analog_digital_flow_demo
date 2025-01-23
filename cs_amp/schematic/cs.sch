v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 200 -250 200 -220 {lab=vds_fr}
N 200 -160 200 -90 {lab=GND}
N 200 -190 270 -190 {lab=GND}
N 200 -340 200 -310 {lab=vdd}
N 150 -190 160 -190 {lab=vgs_fr}
N 270 -190 270 -120 {lab=GND}
N 205 -120 270 -120 {lab=GND}
N 200 -120 205 -120 {lab=GND}
N 120 -280 180 -280 {lab=GND}
C {gnd.sym} 200 -90 0 0 {name=l3 lab=GND}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 180 -190 0 0 {name=M2
W=30
L=0.5
nf=5
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {iopin.sym} 200 -250 0 0 {name=p5 lab=vds_fr}
C {ipin.sym} 200 -340 0 0 {name=p6 lab=vdd}
C {ipin.sym} 150 -190 0 0 {name=p7 lab=vgs_fr}
C {code_shown.sym} 315 -575 0 0 {name=NGSPICE
only_toplevel=true 
value="
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option wnflag = 1 scale=1e-6

vdd0 vdd 0 dc=1.8
vin0 vgs_fr vgs dc=0 ac=1 sin(0 10m 1MEG
vgs0 vgs 0 dc=0.707
c0 vds_fr 0 5p

.control
set wr_vecnames
save all

save @m.xm2.msky130_fd_pr__nfet_01v8_lvt[id]
dc vgs0 0 1.8 1m
let id = m.xm2.msky130_fd_pr__nfet_01v8_lvt[id]
let gm = deriv(id)
let gain = -deriv(vds_fr)
plot gain
wrdata gain_vs_vout.csv gain

ac dec 100 1 10G
plot vdb(vds_fr)
wrdata gain_fr.csv vdb(vds_fr)

tran 10n 4u
plot vgs_fr vds_fr
wrdata sc_tran.csv vgs_fr vds_fr

.endc
"}
C {sky130_fd_pr/res_xhigh_po_1p41.sym} 200 -280 0 0 {name=R2
L=2.12
model=res_xhigh_po_1p41
spiceprefix=X
mult=1}
C {gnd.sym} 120 -280 0 0 {name=l1 lab=GND}
