function fov, f, inst=inst, offset=offset, rotangle=rotangle

;Sets the offset, rotation angle, array size, pixel scale (into f) 
;  for an instrument

if n_elements(inst) eq 0 then inst='nsfcam2'

if inst eq 'nsfcam2' then begin
  f.pixscale = 0.04
  f.asize = [2048,2048]
endif
if inst eq 'spex' then begin
  f.pixscale = 60/512.
  f.asize = [512,512]
endif

if keyword_set(offset) then f.offset=offset
if keyword_set(rotangle) then f.rotangle=rotangle

f = offrot(f)

return, f
end
