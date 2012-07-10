function getneart0, hjd, p, planet=planet

if n_elements(p) eq 0 then p=readsinglp(planet)

;get that hjd to the 5-digit form
if hjd gt 2e6 then hjd = hjd-2450000d
if hjd lt 1e4 then hjd = hjd+50000d

posst0s=p.t0+p.per*dindgen(4096)

absd=abs(posst0s-hjd)

nearest=where(absd eq min(absd))

neart0=posst0s[nearest[0]]

return, neart0
end
