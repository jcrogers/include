function texerr, val, upe, loe

;takes three numbers VALue, UPper Error, LOwer Error and puts them in
;a nice LaTeX table format

;Must have all three - can be a 3-element array VAL, or 3 inputs
;LoE should be a negative value
if n_elements(val) eq 3 then begin
  upe=val[1]
  loe=val[2]
  valu=val[0]
endif else valu=val

texout='$'+strtrim(valu,2)+'^{+'+strtrim(upe,2)+'}_{'+strtrim(loe,2)+'}$'

return, texout
end
