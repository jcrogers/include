function planckflam, wlen, teff, si=si

;Returns an array of F_lambda fluxes corresponding to the input
;wavelengths
;F_lambda Units -- erg cm^-2 s^-1 A^-1
;
;F_lambda = 2hc^2 / L^5 / (exp(hc/LkT) - 1) * (1 cm / 10^8 A)
;
;To convert to F_nu units, 
;
;Inputs:
;  wlen - wavelength array in micron
;  teff - effective temperature in Kelvin

wcm = wlen * 1.d-4 ;wavelengths to cm

c1 = 1.1910428d-5  ;2*h*c^2 - cgs units: erg cm^2 s^-1
c2 = 1.4387687d0   ;hc/k - cgs units: cm K

nn = c1 / (wcm^5d)    ;Numerator
xx = c2 / (teff*wcm)  ;Exponent of e - unitless

bbf = nn / (exp(xx)-1)  ;cgs units erg cm^-3 s^-1

bbfa = bbf * 1.d-8    ;convert the 'per wavelength' from (per cm) to (per Ang)

if keyword_set(si) then $  ;convert to SI units
   bbfa = bbfa * 1.d-3     ; (W m^-2 A^-1)

return, bbfa
end
