function binrms, yy, bs=bs, $
                 verbose=verbose, usemean=usemean, rall=rall

np = n_elements(yy) ;Total number of points
if n_elements(bs) eq 0 then bs = 7 ;Bin size
nb = np / bs ;Number of whole bins
nr = np mod bs ;Number of leftover points
nsp = nr + 1 ;Number of starting point options

rmses = dblarr(nsp)
binavgs = dblarr(nb) ;Bin averages

;Each S.P. Option
for spi = 0, nsp-1 do begin
  sp = spi
  ;Each bin sp+bi*bs+indgen(bs)
  for bi = 0, nb-1 do begin
    tbi = sp+bi*bs+indgen(bs) ;This bin indices
    if keyword_set(usemean) then binavgs[bi]=mean(yy[tbi]) $
                            else binavgs[bi]=median(yy[tbi],/even)
  endfor
  avgba = mean(binavgs)
  rmses[spi]=sqrt(mean((binavgs-avgba)^2))
endfor

if keyword_set(verbose) then begin
  print, 'Binned RMSes: ', rmses
  print, 'Median B.RMS: ', median(rmses,/even)
endif

if keyword_set(rall) then rmsret = rmses $
                     else rmsret = median(rmses,/even)

return, rmsret
end
