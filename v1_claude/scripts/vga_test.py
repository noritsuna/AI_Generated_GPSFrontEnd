import sys; sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__))); import run
def vga_codes():
    t=open(run.netlist('tb_if')).read()
    hdr=t[:t.index('**.subckt tb_if')]
    models=t[t.index('**** begin user architecture code'):t.index('.control')]
    subs=t[t.index('* expanding'):].replace('.end\n','')
    top='''
VDD vdd 0 3.3
XB nb pb vdd 0 bias_gen
VIP inp 0 dc 1.2 ac 0.5
VIN inn 0 dc 1.2 ac 0.5 180
VGA ga 0 0
VGB gb 0 0
XV1 inp inn ga gb nb a1p a1n vdd 0 vga
XF1 a1p a1n pb f1p f1n vdd 0 sk_lpf1
.control
set num_threads=1
op
echo GM $&@m.xv1.xm1.m0[gm] VDS $&@m.xv1.xm1.m0[vds] VDSAT $&@m.xv1.xm1.m0[vdsat] TVDS $&@m.xv1.xmt1.m0[vds] TVDSAT $&@m.xv1.xmt1.m0[vdsat] OUT $&v(a1p)
foreach a 0 3.3
foreach b 0 3.3
alter VGA dc = $a
alter VGB dc = $b
ac lin 1 4e6 4e6
let g = db(v(a1p)-v(a1n))
echo CODE $a $b $&g
end
end
.endc
'''
    return "\n".join(l for l in run.ngspice(hdr+models+top+subs+"\n.end\n",'tmp').splitlines() if l.startswith(("GM","CODE")))
if __name__=="__main__": print(vga_codes())
