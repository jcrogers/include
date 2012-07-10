FUNCTION smoothit, arr, nn

;Smooths a 1-D array over each value and its nearest 2*nn neighbors

leng = n_elements(arr)

smarr = fltarr(leng)

FOR ii = 0, nn-1 DO BEGIN
inds = indgen(nn+ii+1)
smarr[ii]=mean(arr[inds])
ENDFOR

FOR ii = nn, leng-nn-1 DO BEGIN
inds = (ii-nn) + indgen(2*nn+1)
smarr[ii]=mean(arr[inds])
ENDFOR

FOR ii = leng-nn, leng-1 DO BEGIN
inds = (ii-nn) + indgen(leng-ii+nn-1)
smarr[ii]=mean(arr[inds])
ENDFOR

return, smarr

END
