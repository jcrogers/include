; transitquick.pro is at the end of this file (this is
; so that transitquick.pro does not need to be compiled when
; running in IDL).  Please acknowledge Mandel & Agol (2002)
; if you make use of these routines.

; list of routines:
;  1) rf, rc - vectorized version

; Program for evaluating elliptic integrals: in notation of
; Gradsteyn and Rhyzik.
function rf,x,y,z
;ERRTOL=0.0025d0 & TINY=1.5d-38 & BIG=3.d37 & THIRD=1.d0/3.d0
;ERRTOL=0.08d0 & TINY=1.5d-38 & BIG=3.d37 & THIRD=1.d0/3.d0
ERRTOL=0.02d0 & TINY=1.5d-38 & BIG=3.d37 & THIRD=1.d0/3.d0
C1=1.d0/24.d0 & C2=0.1d0 & C3=3.d0/44.d0 & C4=1.d0/14.d0
nx=n_elements(x) & rff=dblarr(nx)
if(n_elements(x) ne n_elements(y) or n_elements(x) ne n_elements(z)) then begin
   print,'wrong size in rf'
   return,dblarr(n_elements(x))
endif
tog=( ((x lt 0.d0) or (y lt 0.d0) or (z lt 0.d0)) or $
      (( (x+y) lt TINY) or ((x+z) lt TINY) or ((y+z) lt TINY)) or $
      ((x gt BIG) or (y gt BIG) or (z gt BIG)) )
if(total(where(tog eq 1)) ge 0) then begin
   rff(where(tog eq 1)) = 0.d0
   print,'invalid arguments in rf'
endif
if(total(where(tog eq 0) ge 0)) then begin
  xt=x & yt=y & zt=z
  delx=dblarr(nx)+1.d0 & dely=delx & delz=delx & ave=dblarr(nx)
LAB1:
  ii=where(max([[abs(delx)],[abs(dely)],[abs(delz)]],dim=2) gt ERRTOL and (tog eq 0))
  sqrtx=sqrt(xt(ii)) & sqrty=sqrt(yt(ii)) & sqrtz=sqrt(zt(ii))
  alamb=sqrtx*(sqrty+sqrtz)+sqrty*sqrtz
  xt(ii)=0.25d0*(xt(ii)+alamb) & yt(ii)=0.25d0*(yt(ii)+alamb) & zt(ii)=0.25d0*(zt(ii)+alamb)
  ave(ii)=THIRD*(xt(ii)+yt(ii)+zt(ii))
  delx(ii)=(ave(ii)-xt(ii))/ave(ii) & dely(ii)=(ave(ii)-yt(ii))/ave(ii) & delz(ii)=(ave(ii)-zt(ii))/ave(ii)
  if(max([abs(delx(ii)),abs(dely(ii)),abs(delz(ii))]) gt ERRTOL) then goto,LAB1
  e2=delx*dely-delz*delz
  e3=delx*dely*delz
  itt=where(tog eq 0)
  rff(itt)=(1.d0+(C1*e2(itt)-C2-C3*e3(itt))*e2(itt)+C4*e3(itt))/sqrt(ave(itt))
endif
return,rff
end

function rc,x,y
;ERRTOL=.04d0 & TINY=1.69d-38 & SQRTNY=1.3d-19 & BIG=3.d37
;ERRTOL=.02d0 & TINY=1.69d-38 & SQRTNY=1.3d-19 & BIG=3.d37
ERRTOL=.005d0 & TINY=1.69d-38 & SQRTNY=1.3d-19 & BIG=3.d37
TNBG=TINY*BIG & COMP1=2.236d0/SQRTNY & COMP2=TNBG*TNBG/25.d0
THIRD=1.d0/3.d0 
C1=.3d0 & C2=1.d0/7.d0 & C3=.375d0 & C4=9.d0/22.d0
nx=n_elements(x)
rcc=dblarr(nx)
if(nx ne n_elements(y)) then begin
   print,'wrong size in rc'
   return,dblarr(nx)
endif
tog=( (x lt 0.d0) or (y eq 0.d0) or $
      ((x+abs(y)) lt TINY) or ((x+abs(y)) gt BIG) or $
      (y lt -COMP1 and x gt 0.d0 and x lt COMP2) )
indx=where(tog eq 1)
if(total(indx) ge 0) then begin
     rcc(indx)=0.d0
     print,'invalid arguments in rc'
endif
int=where(tog eq 0)
if(total(int) ge 0) then begin
  xt=dblarr(nx) & yt=dblarr(nx) & w=dblarr(nx)
  s=dblarr(nx)+1.d0 & ave=dblarr(nx)
  indx=where((tog eq 0) and y gt 0.d0)
  if(total(indx) ge 0) then begin
    xt(indx)=x(indx)
    yt(indx)=y(indx)
    w(indx)=1.d0
  endif
  indx=where((tog eq 0) and y le 0.d0)
  if(total(indx) ge 0) then begin
      xt(indx)=x(indx)-y(indx)
      yt(indx)=-y(indx)
      w(indx)=sqrt(x(indx))/sqrt(xt(indx))
  endif
LAB1:
  ii=where(abs(s) gt ERRTOL and (tog eq 0))
  alamb=2.d0*sqrt(xt(ii))*sqrt(yt(ii))+yt(ii)
  xt(ii)=.25d0*(xt(ii)+alamb)
  yt(ii)=.25d0*(yt(ii)+alamb)
  ave(ii)=THIRD*(xt(ii)+yt(ii)+yt(ii))
  s(ii)=(yt(ii)-ave(ii))/ave(ii)
  if(max(abs(s(ii))) gt ERRTOL) then goto,LAB1
  rcc(int)=w(int)*(1.d0+s(int)*s(int)*(C1+s(int)*(C2+s(int)*(C3+s(int)*C4))))/sqrt(ave(int))
endif
return,rcc
END

function rj,x,y,z,p
; This is a Numerical Recipes routine in FORTRAN modified for IDL
;ERRTOL=.05d0 & TINY=2.5d-13 & BIG=9.d11
ERRTOL=.03d0 & TINY=2.5d-13 & BIG=9.d11
;ERRTOL=.001d0 & TINY=2.5d-13 & BIG=9.d11
C1=3.d0/14.d0 & C2=1.d0/3.d0 & C3=3.d0/22.d0 & C4=3.d0/26.d0
C5=.75d0*C3 & C6=1.5d0*C4 & C7=.5d0*C2 & C8=C3+C3
nx=n_elements(x) & rjj=dblarr(nx)
if(nx ne n_elements(y) or nx ne n_elements(z) or $
      nx ne n_elements(p)) then begin
   print,'wrong size in rj'
   return,dblarr(nx)
endif
tog=((min([[x],[y],[z]],dim=2) lt 0.d0) or $
  (min([[x+y],[x+z],[y+z],[abs(p)]],dim=2) lt TINY) or $
  (min([[x],[y],[z],[abs(p)]],dim=2) gt BIG))
;if(min([x,y,z]) lt 0.d0 or min([x+y,x+z,y+z,abs(p)]) lt TINY $
;     or max([x(i),y(i),z(i),abs(p(i))]) gt BIG) then begin
if(total(where(tog eq 1)) ge 0) then begin
  rjj(where(tog eq 1)) = 0.d0
  print,'invalid arguments in rj'
endif
if(total(where(tog eq 0)) ge 0) then begin
  xt=dblarr(nx) & yt=dblarr(nx) & zt=dblarr(nx) & pt=dblarr(nx)
  sum=dblarr(nx) & fac=1.d0+sum & ave=dblarr(nx)
  ixp=where((tog eq 0) and (p gt 0.d0))
  if(total(ixp) ge 0) then begin
    xt(ixp)=x(ixp) & yt(ixp)=y(ixp) & zt(ixp)=z(ixp) & pt(ixp)=p(ixp)
  endif
  ixt=where((tog eq 1) and (p le 0.d0))
  if(total(ixt) ge 0) then begin
    sup=[[x(ixt)],[y(ixt)],[z(ixt)]]
    xt(ixt)=min(sup,dim=2) & zt(ixt)=max(sup,dim=2)
    yt(ixt)=x(ixt)+y(ixt)+z(ixt)-xt(ixt)-zt(ixt)
    a=1.d0/(yt(ixt)-p(ixt))
    b=a*(zt(ixt)-yt(ixt))*(yt(ixt)-xt(ixt))
    pt(ixt)=yt(ixt)+b
    rho=xt(ixt)*zt(ixt)/yt(ixt)
    tau=p(ixt)*pt(ixt)/yt(ixt)
    rcx=rc(rho,tau)
  endif
  delx=dblarr(nx)+1.d0 & dely=dblarr(nx)+1.d0 & delz=dblarr(nx)+1.d0 & delp=dblarr(nx)+1.d0
LAB1:
  ii=where((max([[abs(delx)],[abs(dely)],[abs(delz)],[abs(delp)]],dim=2) gt ERRTOL) and (tog eq 0))
  sqrtx=sqrt(xt(ii)) & sqrty=sqrt(yt(ii)) & sqrtz=sqrt(zt(ii))
  alamb=sqrtx*(sqrty+sqrtz)+sqrty*sqrtz
  alpha=(pt(ii)*(sqrtx+sqrty+sqrtz)+sqrtx*sqrty*sqrtz)^2
  beta=pt(ii)*(pt(ii)+alamb)^2
  sum(ii)=sum(ii)+fac(ii)*rc(alpha,beta)
  fac(ii)=.25d0*fac(ii)
  xt(ii) =.25d0*(xt(ii)+alamb)
  yt(ii) =.25d0*(yt(ii)+alamb)
  zt(ii) =.25d0*(zt(ii)+alamb)
  pt(ii) =.25d0*(pt(ii)+alamb)
  ave(ii)=.2d0*(xt(ii)+yt(ii)+zt(ii)+pt(ii)+pt(ii))
  delx(ii)=(ave(ii)-xt(ii))/ave(ii)
  dely(ii)=(ave(ii)-yt(ii))/ave(ii)
  delz(ii)=(ave(ii)-zt(ii))/ave(ii)
  delp(ii)=(ave(ii)-pt(ii))/ave(ii)
  if(max([abs(delx(ii)),abs(dely(ii)),abs(delz(ii)),abs(delp(ii))]) gt ERRTOL) $
      then goto,LAB1
  ea=delx*(dely+delz)+dely*delz
  eb=delx*dely*delz
  ec=delp^2
  ed=ea-3.d0*ec
  ee=eb+2.d0*delp*(ea-ec)
  itt=where(tog eq 0)
  rjj(itt)=3.d0*sum(itt)+fac(itt)*(1.d0+ed(itt)*(-C1+C5*ed(itt)-C6*ee(itt))+$
     eb(itt)*(C7+delp(itt)*(-C8+delp(itt)*C4))$
      +delp(itt)*ea(itt)*(C2-delp(itt)*C3)-C2*delp(itt)*ec(itt))/(ave(itt)*sqrt(ave(itt)))
  if (total(ixt) ge 0) then  $
    rjj(ixt)=a*(b*rjj(ixt)+3.d0*(rcx-rf(xt(ixt),yt(ixt),zt(ixt))))
endif
return,rjj
END

function ellpic,en,ak
enn=en
;ige1=where(en gt 1.d0)
;if(total(ige1) ge 0) then enn(ige1)=ak(ige1)*ak(ige1)/en(ige1) ; A&S 17.7.7, p. 599
zero=0.d0+dblarr(n_elements(ak))
one=zero+1.d0
q=(1.d0-ak)*(1.d0+ak)
ellpit=(rf(zero,q,one)-enn*rj(zero,q,one,1.d0+enn)/3.d0)
;if(total(ige1) ge 0) then begin
;  ellpit(ige1)=ellk(ak(ige1))-ellpit(ige1) ;A&S 17.7.9, p. 599
;endif
return,ellpit
end

function ellk,k
; Computes polynomial approximation for the complete elliptic
; integral of the first kind (Hasting's approximation):
m1=1.d0-k^2
a0=1.38629436112d0
a1=0.09666344259d0
a2=0.03590092383d0
a3=0.03742563713d0
a4=0.01451196212d0
b0=0.5d0
b1=0.12498593597d0
b2=0.06880248576d0
b3=0.03328355346d0
b4=0.00441787012d0
ek1=a0+m1*(a1+m1*(a2+m1*(a3+m1*a4)))
ek2=(b0+m1*(b1+m1*(b2+m1*(b3+m1*b4))))*alog(m1)
return,ek1-ek2
end

function ellec,k
; Computes polynomial approximation for the complete elliptic
; integral of the second kind (Hasting's approximation):
m1=1.d0-k^2
a1=0.44325141463d0
a2=0.06260601220d0
a3=0.04757383546d0
a4=0.01736506451d0
b1=0.24998368310d0
b2=0.09200180037d0
b3=0.04069697526d0
b4=0.00526449639d0
ee1=1.d0+m1*(a1+m1*(a2+m1*(a3+m1*a4)))
ee2=m1*(b1+m1*(b2+m1*(b3+m1*b4)))*alog(1.d0/m1)
return,ee1+ee2
end

pro occultunifast,z,w,muo1
if(abs(w-0.5d0) lt 1.d-3) then w=0.5d0
; This routine computes the lightcurve for occultation
; of a uniform source without microlensing  (Mandel & Agol 2002).
;Input:
;
; rs   radius of the source (set to unity)
; z    impact parameter in units of rs
; w    occulting star size in units of rs
;
;Output:
; muo1 fraction of flux at each b0 for a uniform source
;
; Now, compute pure occultation curve:
nz=n_elements(z)
muo1=dblarr(nz)
; the source is unocculted:
; Table 3, I.
indx=where(z gt 1.d0+w)
if(total(indx) ge 0) then muo1(indx)=1.d0
; the  source is completely occulted:
; Table 3, II.
; (already zero, so do nothing)
; the source is partly occulted and the occulting object crosses the limb:
; Equation (26):
indx=where(z ge abs(1.d0-w) and z le 1.d0+w)
if(total(indx) ge 0) then begin
  zt=z(indx)
  xt=(1.d0-w^2+zt^2)/2.d0/zt
  kap1=acos(xt*double(xt lt 1.d0)+1.d0*double(xt ge 1.d0))
  xt=(w^2+zt^2-1.d0)/2.d0/w/zt
  kap0=acos(xt*double(xt lt 1.d0)+1.d0*double(xt ge 1.d0))
  lambdae=w^2*kap0+kap1
  xt=4.d0*zt^2-(1.d0+zt^2-w^2)^2
  lambdae=(lambdae-0.5d0*sqrt(xt*double(xt ge 0.d0)))/!dpi
  muo1(indx)=1.d0-lambdae
endif
indx=where(z le 1.d0-w)
if(total(indx) ge 0) then muo1(indx)=1.d0-w^2
return
end
pro occultquadfast,z0,u1,u2,p,F,F0
;  This routine computes the lightcurve for occultation of a quadratically 
;  limb-darkened source.  Please cite Mandel & Agol (2002) if you make use 
;  of this routine in your research.  
;  Please report errors or bugs to agol@astro.washington.edu
;
; Input:
;
; z0   impact parameter in units of the source radius, rs (vector)
; p    occulting star/planet size in units of rs (scalar)
; (This routine has only been tested for p > 0.003)
; u1   linear    limb-darkening coefficient (gamma_1 in paper)
; u2   quadratic limb-darkening coefficient (gamma_2 in paper)
;
; Output:
;
; F   fraction of flux at each z0 for a limb-darkened source
; F0  fraction of flux at each z0 for a uniform source
;
; Limb darkening has the form:
;  I(r)=[1-u1*(1-sqrt(1-(r/rs)^2))-u2*(1-sqrt(1-(r/rs)^2))^2]/(1-u1/3-u2/6)/pi
; 
; MA02 equation (1): uniform source
occultunifast,z0,p,F0
lambdae=1.d0-F0
nz=n_elements(z0)  & pp=dblarr(nz)+p & lambdad=dblarr(nz)
etad=dblarr(nz) & F=dblarr(nz)
; substitute z=z0(i) to shorten expressions
z=z0 & etad=0.5d0*p^2*(p^2+2.d0*z^2)
; Table 1, Case 1:
indx=where((z ge 1.d0+p) or (pp lt 0.d0))
if(total(indx) ge 0) then etad(indx)=0.d0
occult=((z le 1.d0+p) and (pp gt 0.d0))
; Table 1, Case 11 (corrected typos):
indx=where((pp ge 1.d0) and (z lt p-1.d0))
if(total(indx) ge 0) then etad(indx)=0.5d0
; Table 1, Cases 2 & 8: (These are the most important cases.)
indx=where((z gt abs(1.d0-p)) and (z lt (1.d0+p)) and (z ne p) and occult)
if(total(indx) ge 0) then begin
  zz=z(indx)
  kap1=acos((1.d0-p^2+zz^2)/2.d0/zz)
  kap0=acos((p^2+zz^2-1.d0)/2.d0/p/zz)
; Equation 7 in MA02, lambda_1:
  a=(zz-p)^2 & b=(zz+p)^2 & q=p^2-zz^2
  k=sqrt((1.d0-a)/4.d0/zz/p)
  en=1.d0/a-1.d0
  lambdad(indx)=(((1.d0-b)*(2.d0*b+a-3.d0)-3.d0*q*(b-2.d0))*ellk(k)+$
      4.d0*p*zz*(zz^2+7.d0*p^2-4.d0)*ellec(k)-3.d0*q/a*ellpic(en,k))/9.d0/!dpi/sqrt(p*zz)
; Equation 7 in MA02, eta_1:
  etad(indx)=0.5d0*(kap1+2.d0*etad(indx)*kap0-0.25d0*(1.d0+5.d0*p^2+zz^2)*sqrt((1.d0-a)*(b-1.d0)))/!dpi
endif
; Table 1, Cases 3 & 9, MA02:
case3=((pp gt 0.d0) and (pp lt .5d0) and (z gt p) and (z lt 1.d0-p))
case9=((pp gt 0.d0) and (pp lt 1.d0) and (z gt 0.d0) and (z lt .5d0-abs(p-.5d0)))
indx=where((case3 or case9) and occult)
if(total(indx) ge 0) then begin
  zz=z(indx)
  a=(zz-p)^2 & b=(zz+p)^2 & q=p^2-zz^2
  kinv=2.d0*sqrt(p*zz/(1.d0-a))
; Equation 7 in MA02, lambda_2:
  en=b/a-1.d0
  lambdad(indx)=2.d0/9.d0/!dpi/sqrt(1.d0-a)*((1.d0-5.d0*zz^2+p^2+q^2)*$
     ellk(kinv)+(1.d0-a)*(zz^2+7.d0*p^2-4.d0)*ellec(kinv)-3.d0*q/a*$
     ellpic(en,kinv))
endif
; Table 1, Case 4 (corrected typo in equation 7 & include p > 0.5d0):
indx=where((pp gt 0.d0) and (pp lt 1.d0) and (z eq (1.d0-p)) and occult)
if(total(indx) ge 0) then lambdad(indx)=2.d0/3.d0/!dpi*acos(1.d0-2.d0*p)-$
   4.d0/9.d0/!dpi*(3.d0+2.d0*p-8.d0*p^2)*sqrt(p*(1.d0-p))-2.d0/3.d0*(p gt 0.5d0)
; Table 1, Case 5:
indx=where((pp gt 0.d0) and (pp lt 0.5d0) and (z eq p) and occult)
; lambda_4, equation 7 (corrected 2k -> 2p):
if(total(indx) ge 0) then lambdad(indx)=1.d0/3.d0+2.d0/9.d0/!dpi*$
     (4.d0*(2.d0*p^2-1)*ellec(2.d0*p)+(1.d0-4.d0*p^2)*ellk(2.d0*p))
; Table 1, Case 6:
indx=where((pp eq 0.5d0) and (z eq 0.5d0) and occult)
if(total(indx) ge 0) then lambdad(indx)=1.d0/3.d0-4.d0/9.d0/!dpi
; Table 1, Case 7:
indx=where((pp gt 0.5d0) and (z eq p) and occult)
if(total(indx) ge 0) then begin
  kap1=acos(0.5d0/p) & kap0=acos(1.d0-0.5d0/p^2)
; lambda_3, equation 7 (corrected typo 1/2k -> 1/2p):
  lambdad(indx)=1.d0/3.d0+16.d0*p/9.d0/!dpi*(2.d0*p^2-1.d0)*$
     ellec(0.5d0/p)-(1.d0-4.d0*p^2)*(3.d0-8.d0*p^2)/9.d0/!dpi/p*$
     ellk(0.5d0/p)
  etad(indx)=0.5d0*(kap1+2.d0*etad(indx)*kap0-0.25d0*(1.d0+6.d0*p^2)*$
     sqrt(4.d0*p^2-1.d0))/!dpi
endif
; Table 1, Case 10:
indx=where((z eq 0.d0) and (p lt 1.d0) and occult)
if(total(indx) ge 0) then lambdad(indx)=-2.d0/3.d0*(1.d0-p^2)^1.5d0
; Now, using equation (33):
omega=1.d0-u1/3.d0-u2/6.d0
F=1.d0-((1.d0-u1-2.d0*u2)*lambdae+(u1+2.d0*u2)*(lambdad+2.d0/3.d0*(p gt z))+u2*etad)/omega
iflag=where((finite(F) eq 0) or (F lt 0.d0))
if(total(iflag) ge 0) then F(iflag)=0.5d0*(F(iflag-1)+F(iflag+1))
return
end

pro transitquick,t,x,flux
; Computes a transit lightcurve, normalized to unity, as a
; function of time, t, usually in HJD or BJD.
;
; Input parameters (x) are:
; x(0) = v_rel/R_*  (typically units of day^-1)
; x(1) = b = impact parameter in units of stellar radius
; x(2) = p = R_p/R_* = radius of planet in units of radius of star
; x(3) = t0 = mid-point of transit
; x(4) = u1 = linear limb-darkening coefficient
; x(5) = u2 = quadratic limb-darkening coefficient
; x(6) = f0 = uneclipsed flux
z0=sqrt(x(1)^2+((t-x(3))*x(0))^2)
occultquadfast,z0,x(4),x(5),x(2),flux,F0
flux=flux*x(6)
end
