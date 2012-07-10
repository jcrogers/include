function inecl, reltime, flux, sigl=sigl, scon=scon, target=target

;Returns a set of indices for the fully in-eclipse datapoints
;Clips out those > n-sigma away from median
;
;Inputs:
;  reltime -- time from mid-eclipse (in minutes)
;  flux -- magnitudes or fluxes; used for sigma clipping only
;Optional inputs:
;  sigl -- any points more than sigl sigma away from the median are
;          clipped
;  scon -- time of second contact (in minutes)
;  target -- name of target for use with readsinglep, e.g. 'wasp4'

if n_elements(sigl) eq 0 then sigl = 5.

if n_elements(target) eq 0 then target='wasp4'
if n_elements(scon) eq 0 then begin
   p = readsinglep(target, /silent)
   scon = scontact(p, /minu)
endif


iec = where(abs(reltime) lt scon)
n_in = n_elements(iec)

;Remove NaN's
mmed = median(flux[iec])
good = where(abs(flux[iec]-mmed) lt 10*mmed)
iec = iec[good]

;N-sigma clip
mmed = median(flux[iec])
msd = stdev(flux[iec])
good = where(abs(flux[iec]-mmed) le sigl*msd)
iec = iec[good]

;Repeat for good measure
mmed = median(flux[iec])
msd = stdev(flux[iec])
good = where(abs(flux[iec]-mmed) le sigl*msd)
iec = iec[good]

return, iec
end
