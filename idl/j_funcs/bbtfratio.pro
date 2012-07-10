FUNCTION bbtfratio, p, band, tcase=tcase, tp=tp, mmag=mmag

;p struct must have:
;  Rp and sma (must be in the same units)
;  ts, (tpc, tph)

;Band options (as string):
;  K, Ks, H, J, Y, I, z, R
;  NB670, BrG, Fell_126, Fell_164, SiVi, H2_225, H2_214, 
;  NB2090, NB1190, NB1060, Ch4, NB921

;Uses the routines
;  (This Directory): N/A (this is in include)
;  (My Include Dir): FilTrans, FRat2mmag
;  (Astrolib, etc.): 

;Planet Temperature tp
if n_elements(tp) eq 0 then begin
  ;tcase=0 -- cold planet case, tcase=1 -- hot planet case
  if n_elements(tcase) eq 0 then tcase=0
  if tcase[0] eq 0 then tp=p.tpc
  if tcase[0] eq 1 then tp=p.tph
endif

;Get filter transmission data
t = filtrans(band)
;structure t returns with:
;  .lambda = wavelength grid in microns
;  .trans = transmission fraction as a decimal

;Quantity (hc/k)*(10^4 micron/1 cm)
hck = ((1000. * 6.6260755 * 2.99792458) / 1.380658)
;Quantity (c^2)*(1 cm / 10^4 micron)^5
csq = 2.99792458^2

stplanck = (p.rs^2)*(t.lambda^(-5))/(exp(hck/(p.ts*t.lambda)) - 1)
plplanck = (p.rp^2)*(t.lambda^(-5))/(exp(hck/(tp*t.lambda)) - 1)

np = n_elements(p.ts)

if np eq 1 then begin
  ttop = total(plplanck*t.trans)
  tbot = total(stplanck*t.trans)
  fpth = ttop / tbot
endif else begin
  fpth = fltarr(np)
  for pp = 0, np-1 do begin
    ttop = total(plplanck[pp]*t.trans)
    tbot = total(stplanck[pp]*t.trans)
    fpth[pp] = ttop / tbot
  endfor
endelse

;Optionally, put into mmags
  if keyword_set(mmag) then fpth = frat2mmag(fpth)
;stop

return, fpth

END
