function outecl, reltime, flux, sigl=sigl, fcon=fcon, target=target

;Returns a set of indices for the out-of-eclipse datapoints
;Clips out those > n-sigma away from median
;
;Inputs:
;  reltime -- time from mid-eclipse (in minutes)
;  flux -- magnitudes or fluxes; used for sigma clipping only
;Optional inputs:
;  sigl -- any points more than sigl sigma away from the median are
;          clipped
;  fcon -- time of first contact (in minutes)
;  target -- name of target for use with readsinglep, e.g. 'wasp4'

if n_elements(sigl) eq 0 then sigl = 5.

if n_elements(target) eq 0 then target='wasp4'
if n_elements(fcon) eq 0 then begin
   p = readsinglep(target, /silent)
   fcon = fcontact(p, /minu)
endif


oec = where(abs(reltime) gt fcon)
n_out = n_elements(oec)

;Remove NaN's
mmed = median(flux[oec])
good = where(abs(flux[oec]-mmed) lt 10*mmed)
oec = oec[good]

;N-sigma clip
mmed = median(flux[oec])
msd = stdev(flux[oec])
good = where(abs(flux[oec]-mmed) le sigl*msd)
oec = oec[good]

;Repeat for good measure
mmed = median(flux[oec])
msd = stdev(flux[oec])
good = where(abs(flux[oec]-mmed) le sigl*msd)
oec = oec[good]

return, oec
end
