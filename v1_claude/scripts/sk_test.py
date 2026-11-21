import sys; sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__))); import run
def sk_resp(extra_subckt=""):
    t=open(run.SIM + '/netlist/tb_if.spice').read()
    hdr=t[:t.index('**.subckt tb_if')]
    models=t[t.index('**** begin user architecture code'):t.index('.control')]
    subs=t[t.index('* expanding'):]
    top='''
VDD vdd 0 3.3
XB nb pb vdd 0 bias_gen
VIP inp 0 dc 1.2 ac 0.5
VIN inn 0 dc 1.2 ac 0.5 180
RSP inp ip2 2k
RSN inn in2 2k
XF2 ip2 in2 pb g1p g1n vdd 0 sk_lpf1
XF3 ip2 in2 pb h1p h1n vdd 0 sk_lpf2
XF4 g1p g1n pb k1p k1n vdd 0 sk_lpf2
.control
set num_threads=1
op
echo SFOUT $&v(g1p)
ac dec 20 1e5 1e9
let sk1 = db(v(g1p)-v(g1n))
let sk2 = db(v(h1p)-v(h1n))
let both = db(v(k1p)-v(k1n))
print sk1[20] sk2[20] both[20]
print sk1[40] sk2[40] both[40]
print sk1[47] sk2[47] both[47]
print sk1[50] sk2[50] both[50]
print sk1[52] sk2[52] both[52]
print sk1[56] sk2[56] both[56]
print frequency[47] frequency[50]
.endc
'''
    return run.ngspice(hdr+models+top+subs.replace('.end\n',''),'tmp')
if __name__=="__main__":
    print("\n".join(l for l in sk_resp().splitlines() if "=" in l or "SFOUT" in l))
