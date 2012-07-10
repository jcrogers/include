function sunalt, rjd, o

;Calculates the altitude of the sun at given RJD(s)
;  at an observing site (o)
;o is observatory structure from OBSITE, and should have:
;  .lati, .longi, .alt
;Uses SUNPOS, EQ2HOR

jd = rjd + 2400000.D ;RJD to JD

;Use SUNPOS to get ra, dec of Sun
sunpos, jd, sra, sdec

;Use EQ2HOR to get altitude of Sun
eq2hor, sra, sdec, jd, sun_alt, sunaz, $
        lat=o.lati, lon=-o.longi, altitude=o.alt

return, sun_alt

end
