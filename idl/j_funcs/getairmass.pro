function getairmass, rjd, p, o

;p is planet structure  from READSINGLEP, and should have:
;  .ra, .dec
;o is observatory structure from OBSITE, and should have:
;  .lati, .longi, .alt
;Uses EQ2HOR

;Number of dates
ndates = n_elements(rjd)
;Duplicate the ra/dec accordingly
ra = 15*p.ra+fltarr(ndates)  ;RA from Hours to Degrees
dec = p.dec+fltarr(ndates)

jd = rjd + 2400000.D ;RJD to JD
elong = -o.longi     ;Obs. longitude is W; EQ2HOR needs E.

EQ2HOR, ra, dec, jd, alt, az, lat=o.lati, lon=elong, altitude=o.alt

zdist = (90.-alt)*(!pi/180.)  ;zenith distance in radians
airmass = 1./cos(zdist)       ;airmass = sec(zenith dist.)

return, airmass

end
