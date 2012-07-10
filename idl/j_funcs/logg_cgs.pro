function logg_cgs, p

;Returns log(g) where g was in cgs units (cm s^-2)

;Input structure p must have:
;  .rs -- star radius (in solar radii)
;  .ms -- star mass (in solar masses)

bigg = 6.67428e-8

m_g = p.ms * 1.9891e33

r_cm = p.rs * 6.955e10

lilg = (bigg * m_g) / (r_cm^2)

logg = alog10(lilg)

return, logg

end

