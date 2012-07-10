function boxclip, inx, iny, boxsize, nsig=nsig

;Flags any points more than nsig sigma away from the median of all
;points within a window (half-width boxsize away from them)

;Returns clipflag
;  intarr[nframes]
;  1 = clip; 0 = don't

;Syntax
;IDL> clipflag = boxclip(inarr, 8., nsig=2)


if n_elements(boxsize) eq 0 then boxsize = 10.
if n_elements(nsig) eq 0 then nsig = 3

nframes = n_elements(iny)
clipflag = intarr(nframes)

for fi = 0, nframes-1 do begin
  inbox = where(abs(inx-inx[fi]) lt boxsize)
  if n_elements(inbox) gt 1 then begin
    boxmed = median(iny[inbox], /even)
    boxsd = stdev(iny[inbox])
    sigdev = (iny[fi]-boxmed)/boxsd
    if abs(sigdev) gt nsig then clipflag[fi]=1
  endif
endfor

return, clipflag
end
