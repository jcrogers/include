function sigclip, inarr, sigl, lims, mindev

;Clips the outliers from an input array "inarr"
; at the "sigl" n-sigma level
;
;Returns the array of indices to keep for the array (and associated
;arrays)
;
;Optional inputs:
;  lims -- limits to clip off before even the sigma-clip
;  mindev -- minimum deviation to never clip below

mdn = median(inarr)
if n_elements(inarr) gt 1 then std = stdev(inarr)

if n_elements(sigl) eq 0 then sigl = 3.

;If 'lims' set
if n_elements(lims) ne 0 then begin
  inrg = where(inarr ge lims[0] and inarr le lims[1])
  if n_elements(inrg) gt 1 then begin
    mdn = median(inarr[inrg])
    std = stdev(inarr[inrg])
  endif
endif 

if n_elements(mindev) eq 0 then mindev = 0

keep = where(abs(inarr-mdn) le (sigl*std > mindev))


return, keep
end
