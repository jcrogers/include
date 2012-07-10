function ieo, aa, ab, isnt=isnt

;"Is Element Of"
;
;Returns the array of indices of Array A (aa) that 
;represent the values in aa that are included (anywhere) 
;in Array B (ab)
;
;Keyword /isnt: returns the array of indices in aa that *aren't* in ab
;
;Syntax: IDL> c = ieo(aa,ab)   (,/isnt)
;Equivalent to "c = where(aa *is an element of* ab)

lb = n_elements(ab)

ac=where(aa eq ab[0])

if lb gt 1 then for bi=1,lb-1 do $
  ac = [ac,where(aa eq ab[bi])]

;Remove any -1's
notm = where(ac ne -1)
if notm[0] ne -1 then ac = ac[notm] else ac=-1

;Sort and Unique
ac=ac[sort(ac)]
ac=ac[uniq(ac)]

if keyword_set(isnt) then begin
  ad=aa*0
  ad[ac]=1
  ac=where(ad eq 0)
endif

return, ac
end

