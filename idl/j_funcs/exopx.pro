function exopx

;Makes a fake "Exoplanet X", beginning with the CoRoT-1b template

p = readsinglep('corot1', /silent)

p.name = 'x'
p.mp = 1.
p.rp = 1.5 / 9.73
p.sma = 4.254
p.per = 25/24.
p.inc = 88.
p.t0 = 55555.5 - p.per/2
p.ms = 1.
p.rs = 1.
p.ts = 6000.

p = pltemp(p)

return, p
end
