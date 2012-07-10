function radec2arcsec, st, hrs=hrs, ndeci=ndeci

;Reads in a RA or DEC value as a string, format:
;  '+DD:MM:SS.ddd'
;Turns it into a number of arcseconds from zero
;Returns that value

;Keywords: 
;ndeci= -- number of decimal places in the seconds column
if n_elements(ndeci) eq 0 then ndeci=1
;/hrs -- if RA is given in HOURS, not DEGREES, have to multiply by 15
;        at the end

;Example syntax:
;IDL> ra_as = radec2arcsec('-23:59:59.936      ', ndeci=3, /hrs)

;Split up each part
dd = double(strmid(st,0,3))
mm = double(strmid(st,4,2))
ss = double(strmid(st,7,3+ndeci))

if dd gt 0 then $
  totalas = 3600*dd+60*mm+ss $
  else totalas = 3600*dd-60*mm-ss

if keyword_set(hrs) then totalas=totalas*15d

return, totalas
end
