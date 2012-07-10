function pme2ecosw, p, pme

;p structure has to have:
; .inc, .per

; (e cos w) = pi / (1+csc^2 i) * (phi_me - 0.5)

;if phi_me is a scalar then just return the ecosw
;if phi_me is a 2 or 3-element vector then return it with error bars

csc2i = (sin(!pi/180.*p.inc))^(-2.)

;Copy and take the 0.5 out of the value (but not the errors)
pmeb = pme
pmeb[0] = pme[0]-0.5

ecwf = !pi / (1 + csc2i) * pmeb

return, ecwf
end
