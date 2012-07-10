function indx2combo, inlist, ii

;inlist should be a list of whatever
nn = n_elements(inlist)
;ii is the index number from 1 to 2^nn-1


outlist=[]
onoff=intarr(nn)

ri=ii

for pp=0,nn-1 do begin
  if ri mod 2^(pp+1) ne 0 then begin
    onoff[pp]=1
    ri = ri - (ri mod 2^(pp+1))
  endif
endfor

outpicks=where(onoff eq 1,nout)

if nout eq 0 then begin
  print, 'no outputs chosen'
  outlist=[]
endif else outlist=inlist[outpicks]

return, outlist
end
