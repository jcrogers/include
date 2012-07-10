function pltemp, p, f, ab

;Calculates the planet effective temperature range
; cold = p.tpc, hot = p.tph
;p struct must have:
; rs, sma (same units)
; ts
;also need f, ab
fc = 0.25
abc = 0.3
fh = 2./3.
abh = 0.

xxx = (p.rs / p.sma)^0.5

yyc = (fc * (1-abc))^0.25
yyh = (fh * (1-abh))^0.25

p.tpc = p.ts * xxx * yyc
p.tph = p.ts * xxx * yyh

if n_elements(f) ne 0 then begin
  yygen = (f * (1-ab))^0.25
  tpgen = p.ts * xxx * yygen
  return, tpgen
endif else return, p

END
