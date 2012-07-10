function bwin, fullarr, xb, yb

;Takes in a full array 'fullarr', and makes a smaller, windowed array 
;with index limits 'xb' and 'yb', which are each a 2-element intarr
;
;Syntax e.g.:
;IDL> winarr = bwin(fullarr,[120,189],[220,289])

;Second element in array can also be the number of pixels to do...
;  (but must be less than the first element)
if xb[1] lt xb[0] then xb[1]=xb[0]+xb[1]-1
if yb[1] lt yb[0] then yb[1]=yb[0]+yb[1]-1

x_inds = xb[0]+indgen(xb[1]-xb[0]+1)
y_inds = yb[0]+indgen(yb[1]-yb[0]+1)

cut1 = fullarr[x_inds,*]
cut2 = cut1[*,y_inds]

bwinarr=cut2

return, bwinarr

end
