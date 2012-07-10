function fpfs, p, band, ff=ff, ab=ab, $
               tfr=tfr, rfr=rfr

;Just outputs the expected planet-to-star flux ratio in the given band
;Returns the combined thermal and reflected components
;Optional output keywords TFR and RFR will contain each component
;separately
;Each of the inputs (p, band, ff, ab) should be for one planet / value
;Uses the routines:
; (ReadSingleP)
; PlTemp
; ObsBBFlux: FilTrans, PFl10Pc
; ReflFRatio

if n_elements(p) eq 0 then p=readsinglep('corot1')
if n_elements(band) eq 0 then band='Ks'
if n_elements(ff) eq 0 then ff=0.25
if n_elements(ab) eq 0 then ab=0.3

;Thermal Component
Tp = pltemp(p,ff,ab)
;tfr = bbtfratio(p,band,tp=tp)
pflux = obsBBflux(Tp,p.Rp,band)
sflux = obsBBflux(p.ts,p.rs,band)
tfr = pflux/sflux

;Reflected Component
rfr = reflfratio(p,ab)

;Combined flux ratio
cfr = tfr + rfr

return, cfr
end
