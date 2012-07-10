function hjd2phase, hjd, t0, period

;Converts the hjd array to phase

;Defaults -- Corot-1; Jan. 15
if n_elements(t0) eq 0 then t0 = 54159.4532d  ;54846.782521d
if n_elements(period) eq 0 then period = 1.5089557d

;Example:
;IDL> phase = hdj2phase(ms.hjd, 54846.782521d, 1.5089557d)
;  *or just IDL> phase = hjd2phase(ms.hjd) *

relhjd = hjd - t0
phase = (relhjd / period) mod 1

return, phase
end
