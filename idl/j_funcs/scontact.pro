FUNCTION scontact, p, minu=minu, phi=phi

;Calculates and returns the time difference (in days) between the
;center of the transit and second contact.

;p struct must have:
; rs, rp, sma (all in same units)
; inc (degrees)
; per (days)

rsc = (p.rs-p.rp)/p.sma
cosphisc = sqrt(1 - rsc^2) / (sin(p.inc*!pi/180.))
phisc = acos(cosphisc)
sc = phisc / (2*!pi) * p.per


;Returns in days (not hours / minutes)
if (not keyword_set(minu) and not keyword_set(phi)) then return, sc

;Unless keywords set:
if keyword_set(minu) then return, sc*1440.

if keyword_set(phi) then return, sc / p.per


END
