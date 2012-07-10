function obsbbflux, teff,rad,filter, rjup=rjup, verbose=verbose, $
                    ewidth=ewidth, fluxdens=fluxdens

;Returns the Observed blackbody flux at 10 pc in designated filter
;  units erg / s / cm^2
;
;Inputs:
;  teff   - temperature (K)
;  rad    - radius (R_sun; unless /rjup set)
;  filter - name of the filter ('K','z','NB2090',etc.)
;Output keywords:
;  ewidth=      - effective width in Angstroms
;  fluxdens=    - integrated flux density
;Uses the routines:
;  filtrans
;  int_tabulated
;  pfl10pc

;1. Read in the filter profile
   ft = filtrans(filter)
   ; ft.lambda - wavelength in microns
   ; ft.trans - transmission in decimal

;2. Filter effective width
   lama = ft.lambda*1d4  ;wavelength in angstroms
   ewidth = int_tabulated(lama,ft.trans)

;3. Source flux at 10 pc
   if not keyword_set(rjup) then rjup=0
   sflux = pfl10pc(ft.lambda,teff,rad,rjup=rjup)

;4. Integrate (flux x trans) over wavelength
   fluxtot = int_tabulated(lama, ft.trans*sflux)

;5. Flux density
   fdens = fluxtot / ewidth

if keyword_set(fluxdens) then return, fdens else $
return, fluxtot
end
