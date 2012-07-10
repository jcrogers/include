function obsite, obsname

;Returns a structure with:
;  .observatory
;  .name
;  .longitude
;  .latitude
;  .altitude
;  .tz  (time zone)
if obsname eq 'vlt' then obsname = 'cpo'
if obsname eq 'cpo' then $
   ostruct = create_struct('ocode', 'cpo', $
                 'name', 'Cerro Paranal Observatory', $
                 'longi', 70.4041667, $
                 'lati', -24.6272222, $
                 'alt', 2635., $
                 'tz', 4.) $
else begin
  observatory, obsname, o
  ostruct = create_struct('ocode', o.observatory, $
                'name', o.name, $
                'longi', o.longitude, $
                'lati', o.latitude, $
                'alt', o.altitude, $
                'tz', o.tz)
endelse

return, ostruct

end
