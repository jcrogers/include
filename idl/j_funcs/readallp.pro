FUNCTION readallp, filename, silent=silent

if not keyword_set(silent) then silent=0
;Returns structure ap

if n_elements(filename) eq 0 then filename = $
   '~/include/exopd110217.txt'
;   '/Users/jrogers/include/exopd_100721.txt';vhj/exopd_100111.dat'
;'exopd_090803.csv'

readcol, filename, name, mp, rp, sma, $
                   per, inc, ecc, t0, $
                   ms, rs, ts, sptype, $
                   rah,ram,ras, decd,decm,decs,$
                   vmag, imag, $
                   jmag, hmag, kmag, metal, $
           format = '(a,f,f,d,'+'d,f,f,d,'+'f,f,f,a,'+$
                    'f,f,f,f,f,f,'+'f,f,'+'f,f,f,f)', /silent

np = n_elements(name)

ra = rah+ram/60.+ras/3600.
decsign = decd/abs(decd)
dec = decd+decsign*(decm/60.+decs/3600.)

;Convert radii to R_sun
rp = rp/9.73
rs = rs
sma = sma*215.1

;zz = where(name EQ planet)
;zz = zz[0]


ap=create_struct('name',name, $
                'mp',mp, 'rp',rp, 'sma',sma, $
                'per',per, 'inc',inc, 'ecc',ecc, 't0',t0,$
                'ms',ms, 'rs',rs, 'ts',ts, $
                'tpc', fltarr(np), 'tph', fltarr(np),$
                'sptype',sptype, 'ra',ra, 'dec',dec,$
                'vmag',vmag, 'imag',imag, 'jmag',jmag,$
                'hmag',hmag, 'kmag',kmag, 'metal',metal)

ap=pltemp(ap)

return, ap

END


