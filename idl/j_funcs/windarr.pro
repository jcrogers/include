function windarr, fullarr, xc, yc, xs, ys

;Takes in a full array FULLARR, and makes a smaller, windowed array of size xs x ys, centered at [xc,yc].
;
;For best results, use ODD values for xs and ys

wa = fltarr(xs,ys)

minx = xc - (xs-1)/2
miny = yc - (ys-1)/2


for xx=0,xs-1 do begin
  for yy=0, ys-1 do begin
    wa[xx,yy] = fullarr[minx+xx,miny+yy]
  endfor
endfor

return, wa

end

