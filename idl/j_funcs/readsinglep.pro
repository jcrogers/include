FUNCTION readsinglep, planet, filename, silent=silent

;Input: planet (string from list in simplepd)
;Returns structure p
;  rp, rs, sma all in R_sun
;  RA in decimal hours, DEC in decimal degrees.

IF n_elements(planet) EQ 0 THEN planet = 'corot1'
if n_elements(filename) eq 0 then filename = $
   '~/include/exopd110217.txt' ;'~/include/exopd_100721.txt'
;vhj/exopd_100427.dat';exopd_091212.dat'
;planning/observability/exopd_090803.csv'
if not keyword_set(silent) then silent=0

readcol, filename, name, mp, rp, sma, $
                   per, inc, ecc, t0, $
                   ms, rs, ts, sptype, $
                   rah,ram,ras, decd,decm,decs,$
                   vmag, imag, jmag, hmag, kmag, $
                   metal, $
           format = '(a,f,f,d,'+'d,f,f,d,'+'f,f,f,a,'+$
                    'f,f,f,f,f,f,'+'f,f,f,f,f,'+'f)', /silent

ra = rah+ram/60.+ras/3600.
;if decd ge 0 then dec = decd+decm/60.+decs/3600. $
;             else dec = decd-decm/60.-decs/3600.
decsign = decd/abs(decd)
zerod = where(decd eq 0)
decsign[zerod] = 1
dec = decd+decsign*(decm/60.+decs/3600.)



;Convert radii to R_sun
rp = rp/9.73
rs = rs
sma = sma*215.1

zz = where(name EQ planet)
zz = zz[0]


p=create_struct('name',planet, $
                'mp',mp[zz], 'rp',rp[zz], 'sma',sma[zz], $
                'per',per[zz], 'inc',inc[zz], 'ecc',ecc[zz], 't0',t0[zz],$
                'ms',ms[zz], 'rs',rs[zz], 'ts',ts[zz], $
                'tpc', 0., 'tph', 0.,$
                'sptype',sptype[zz], 'ra',ra[zz], 'dec',dec[zz],$
                'vmag',vmag[zz], 'imag',imag[zz], 'jmag',jmag[zz],$
                'hmag',hmag[zz], 'kmag',kmag[zz], 'metal',metal[zz])

p=pltemp(p)

return, p

END


