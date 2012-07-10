function numname, ii, digits=digits

;Turns an input integer ii to an output four-digit string nname
if n_elements(digits) eq 0 then digits=4

nname = strtrim(long(ii),2)

for di = 1, digits-1 do begin
  if ii lt 10.^di then nname='0'+nname
endfor

;if ii lt 1000 then nname='0'+nname
;if ii lt 100 then nname='0'+nname
;if ii lt 10 then nname='0'+nname

return, nname
end
