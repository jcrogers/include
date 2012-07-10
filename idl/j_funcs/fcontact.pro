FUNCTION fcontact, p, minu=minu, phi=phi

;Calculates and returns the time difference (in days) between the
;center of the transit and first contact.

;p struct must have:
; rs, rp, sma (all in same units)
; inc (degrees)
; period (days)


rfc = (p.rs+p.rp)/p.sma
cosphifc = sqrt(1 - rfc^2) / (sin(p.inc*!pi/180.))
phifc = acos(cosphifc)
fc = phifc / (2*!pi) * p.per

;Returns in days (not hours / minutes)
if (not keyword_set(minu) and not keyword_set(phi)) then return, fc

;Unless keywords set:
if keyword_set(minu) then return, fc*1440.

if keyword_set(phi) then return, fc / p.per

END
