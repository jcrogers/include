function ecosw2pme, p, ecosw

;p structure has to have:
; .inc, .per

;(phi_me - 0.5) = (1+csc^2 i) / pi * e cos w

;if ecosw is a scalar then just return the phi_me
;if ecosw is a 2 or 3-element vector then return it with error bars

csc2i = (sin(!pi/180.*p.inc))^(-2.)

pmpf = (1 + csc2i) / !pi * ecosw

;Add the 0.5 to the first element but not to the error bars...
pme = pmpf
pme[0] = pmpf[0]+0.5
;if n_elements(ecosw) eq 3 then pme[[1,2]]=pmpf[[1,2]]

return, pme
end
