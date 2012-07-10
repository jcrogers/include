function bbsedrange, p, band

;first do p=readsinglep('name',/silent)
;band is the filter: 'K', 'z', etc.
;
;Uses obsbbflux
;
;Returns a 2-element array of the minimum and maximum secondary
;eclipse depth
;
;IDL> bbsr = bbsedrange(p, 'K')

;Range of albedos to test
  abmax = 0.50
  abinc = 0.01
  n_ab = long(abmax/abinc)+1
  testabs = abinc*findgen(n_ab)   ;0.00 to 0.50

;Reflected component
  reflc = 2/3.*testabs*(p.rp/p.sma)^2

;Min, max dayside temperature
  fmin = 0.25
  fmax = 2/3.
  tmin = p.ts * (p.rs/p.sma)^0.5 * (fmin*(1-testabs))^0.25
  tmax = p.ts * (p.rs/p.sma)^0.5 * (fmax*(1-testabs))^0.25

;Depths from thermal component only
  thermmin = fltarr(n_ab)
  thermmax = fltarr(n_ab)
  for ii = 0, n_ab-1 do begin
    thermmin[ii] = obsbbflux(tmin[ii],p.rp,band)/obsbbflux(p.ts,p.rs,band)
    thermmax[ii] = obsbbflux(tmax[ii],p.rp,band)/obsbbflux(p.ts,p.rs,band)
  endfor

;Overall min and max
  ovrmin = min(thermmin+reflc)
  ovrmax = max(thermmax+reflc)

return, [ovrmin,ovrmax]
end
