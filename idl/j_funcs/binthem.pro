function binthem, x, y, xbs, bsc, usemed=usemed

;Bins the (x,y) points into bins of size xbs
;returns a structure b with:
;  x
;  y
;  y_err
;  np    (number of points in each bin)

;Number of bins
  ;LT zero
  if min(x) lt 0 then nneg = long(-1*min(x)/xbs)+1 else nneg=0
  ;GT zero
  if max(x) gt 0 then npos = long(max(x)/xbs)+1 else npos=0

if min(x) ge 0 then begin
  nneg = 0
  npos = long( (max(x)-min(x))/xbs)+1
endif

nbins = nneg+npos


b = create_struct('x', fltarr(nbins), $
                  'y', fltarr(nbins), $
                  'np', intarr(nbins), $
                  'y_err', fltarr(nbins))

if min(x) lt 0 then begin
  for bi = 0, nbins-1 do begin
    lowlim = (bi-nneg)*xbs
    upplim = (bi-nneg+1)*xbs
    b.x[bi] = 0.5*(lowlim+upplim)
    inbin = where(x ge lowlim and x lt upplim)
    if inbin[0] ne -1 then begin
      if keyword_set(usemed) then b.y[bi]=median(y[inbin],/even) $
         else b.y[bi] = mean(y[inbin])
      b.y_err[bi] = stdev(y[inbin])
    endif else b.y_err[bi] = -1
  endfor
endif

if min(x) ge 0 then begin
  for bi = 0, nbins-1 do begin
    lowlim = min(x)+bi*xbs
    upplim = lowlim+xbs
    b.x[bi] = 0.5*(lowlim+upplim)
    inbin = where(x ge lowlim and x lt upplim)
    if inbin[0] ne -1 then begin
      b.y[bi] = mean(y[inbin])
      np = n_elements(inbin)
      b.np[bi] = np
      if np gt 1 then b.y_err[bi] = stdev(y[inbin])/sqrt(np) $
                 else b.y_err[bi] = -1
    endif else b.y_err[bi] = -1
  endfor
endif


keep = where(b.y_err ne -1)
b.x = b.x[keep]
b.y = b.y[keep]
b.np = b.np[keep]
b.y_err = b.y_err[keep]

return, b
end
