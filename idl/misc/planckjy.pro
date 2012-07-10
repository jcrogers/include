;Planckfunktion in Jy
;RK 11.6.96
;RK 8.2.99 emissivity added

function planckjy,wave,Temp,pder,emissivity=emissivity
;input: wave :array with wavelength in microns,
;        Temp :Temperature in K
;KEYWORDS:
; emissivity: array(2) [beta:exponent of wavel. dependence, 
;                       lambda in mic: wavel.^beta where tau eq 1]
   
   if keyword_set(emissivity) $
    THEN faktor = 1d0-exp(-(emissivity(1)/wave)^emissivity(0)) $
    ELSE faktor = 1d0
   
; copied from Astron Planck function
   
   
   bbflux = wave*0d0
   
   w = wave / 1.d4              ; micron to cm    
   ;constants appropriate to cgs units.
     c1 =  3.7417749d-5           ;2pi*h*c^2
     C2 =  1.4387687d0            ;h*c/k
   val =  c2/w/temp               
   good = where( val LT 88, Ngood ) ;Avoid floating underflow
   expval=exp(val)
   if ( Ngood GT 0 ) then  $
    bbflux( good ) =  C1 / ( w(good)^5d0* ( expval(good)-1. ) ) *1.d-8
   
   
   bb=bbflux*faktor             ;1 if no emissivity=
;bb=planck(waveA,Temp)*(1/wave)^grey 
   
;planck returns the blackbody flux 
;(i.e. int(Intensity*cos(theta)* d omega,2*Pi) =PI*Intensity) 
;in units ergs/cm2/s/a 
   Jy=bb*w^2/2.99792458d-21          ; conversion to Jy 


;partial deriivatives 
;   ddw = c1*(w*expval*c2/Temp-(3+grey)*(expval-1.))/ $
;          (w^(5+grey)*(expval-1.)^2)                         /1.e4/3E-21

   IF n_params() GT 2 THEN BEGIN 
      ddt = faktor*c1*c2*expval / (w^4.*(expval-1.)^2.*Temp^2.)   *1e-8/3E-21
      IF keyword_set(emissivity) THEN BEGIN
         com_coef = Jy*exp(-(emissivity(1)/wave)^emissivity(0))* $
                    (emissivity(1)/wave)^emissivity(0)
         dde0 = com_coef * alog(emissivity(1)/wave)
         dde1 = com_coef * emissivity(0)/emissivity(1)
         pder = [[ddt],[dde0],[dde1]] 
      ENDIF $
      ELSE pder = [ddt]
   ENDIF

      
   return,Jy
   

end
