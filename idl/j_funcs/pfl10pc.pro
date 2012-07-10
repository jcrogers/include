function pfl10pc, wlen, teff, rad, rjup=rjup

;Returns an array of F_lam fluxes at a distance of 10 pc
;
;Inputs:
;  wlen - wavelength array in micron
;  teff - effective temperature in Kelvin
;  rad  - radius of source in solar radii (or jupiter radii if /rjup
;         set)

;Constants
     rjup = 7.1492d7            ; Jupiter radius in m
     rsol = 6.95508d8           ; Solar radius in m
     pc2m = 3.085677d16         ; pc in m
     au2m = 1.495978606d11      ; AU in m


if keyword_set(rjup) then radm = rad*rjup else radm = rad * rsol
distm = 10.d*pc2m

flam = planckflam(wlen, teff)

flobs = !pi * (radm/distm)^2 * flam

return, flobs
end
