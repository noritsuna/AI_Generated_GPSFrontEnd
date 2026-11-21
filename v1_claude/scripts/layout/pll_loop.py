"""PLL loop model with RVT/C3 VCO tap: PM, fc, and ripple attenuation C2->VT at fref harmonics."""
import numpy as np, sys
N=96; fref=16.368e6; RZ=5e3; C1=1.2e-9; C2=10e-12
CORN={"tt":(526e6,238e-6),"ss":(300e6,479e-6),"ff":(961e6,241e-6)}
def model(c, RVT, C3, delay=True):
    K,I=CORN[c]; f=np.logspace(4,9,20000); s=2j*np.pi*f
    Y=s*C2+1/(RZ+1/(s*C1))+1/(RVT+1/(s*C3)); Z=1/Y
    H=1/(1+s*RVT*C3); L=I*Z*H*K/(s*N)
    if delay: L*=np.exp(-s/(2*fref))
    k=np.argmin(abs(abs(L)-1)); pm=180+np.angle(L[k],deg=True)
    # VT ripple per unit C2 ripple at fref (C2 step ~ Q/(C2+C3) too)
    att=abs(1/(1+2j*np.pi*fref*RVT*C3))
    return f[k], pm, 20*np.log10(att*C2/(C2+C3))
for RVT,C3 in [(1e3,0.8e-12),(1e3,1e-12),(1e3,1.5e-12),(1e3,2e-12),(1e3,3e-12),(1e3,4e-12),(2e3,1.5e-12),(2e3,2e-12)]:
    print("RVT %4.0f C3 %.1fp  " % (RVT,C3*1e12) + "  ".join("%s fc %.2f PM %.1f rip %.1f dB" % ((c,)+(lambda r:(r[0]/1e6,r[1],r[2]))(model(c,RVT,C3))) for c in CORN))
