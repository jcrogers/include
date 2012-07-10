FUNCTION reflfratio, p, Ab, mmag=mmag

;p struct must have:
;  Rp and sma (must be in the same units)

;Default
   if n_elements(Ab) eq 0 then Ab = 0.3

fpref = (2*Ab/3.) * (p.Rp/p.sma)^2

if keyword_set(mmag) then fpref = frat2mmag(fpref)

return, fpref

END
