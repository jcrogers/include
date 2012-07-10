FUNCTION filtrans, band, path=path

;Reads in the appropriate transfunc file, returns a structure with:
; lambda - wavelength in micron
; trans - transmission in decimal

if n_elements(path) eq 0 then path = '~/include/tfuncs/'

IF band EQ 'K' THEN tf_file = path+'transfunc_k.dat' ;nm, pct
IF band EQ 'Ks' THEN tf_file = path+'transfunc_k.dat' 
IF band EQ 'H' THEN tf_file = path+'transfunc_h.dat' ;nm, pct
IF band EQ 'J' THEN tf_file = path+'transfunc_j.dat' ;nm, pct
IF band EQ 'z' THEN tf_file = path+'transfunc_z.dat' ;nm, pct
IF band EQ 'NB670' THEN tf_file = path+'transfunc_670.dat' ;nm, pct
IF band EQ 'BrG' THEN tf_file = path+'transfunc_brg.dat' ;nm, pct
IF band EQ 'Fell_126' THEN tf_file = path+'transfunc_1260.dat' ;nm, pct
IF band EQ 'Fell_164' THEN tf_file = path+'transfunc_1640.dat' ;nm, pct
IF band EQ 'SiVI' THEN tf_file = path+'transfunc_1960.dat' ;nm, pct
IF band EQ 'H2_225' THEN tf_file = path+'transfunc_2250.dat' ;nm, pct
if band eq 'Y' then tf_file = path+'transfunc_y.dat' ;nm, pct
if band eq 'H2_214' then tf_file = path+'transfunc_2140.dat' ;nm, pct
IF band EQ 'NB2090' THEN tf_file = path+'transfunc_2090.dat' ;nm, pct
IF band EQ 'NB1190' THEN tf_file = path+'transfunc_1190.dat' ;nm, pct
IF band EQ 'NB1060' THEN tf_file = path+'transfunc_1060.dat' ;nm, pct
if band eq 'CH4' then tf_file = path+'transfunc_ch4.dat' ;nm, pct

IF band EQ 'NB921' THEN tf_file = path+'transfunc_921.dat' ;ang, dec
IF band EQ 'R' THEN tf_file = path+'transfunc_r.dat' ;nm, dec
IF band EQ 'I' THEN tf_file = path+'transfunc_i.dat'
IF band EQ 'i' THEN tf_file = path+'transfunc_i.dat'
if band eq 'V' then tf_file = path+'transfunc_v.dat'
if band eq 'B' then tf_file = path+'transfunc_b.dat'


readcol, tf_file, lambda, trans, format='(d,d)', /silent

;lambda in nm, trans in percent
IF band eq 'NB921' THEN trans = trans * 100d
IF band EQ 'NB921' THEN lambda = lambda/10d
if band eq 'R' then trans = trans * 100d
IF band EQ 'I' THEN lambda = lambda/10d
if band eq 'V' then lambda = lambda/10d
if band eq 'B' then lambda = lambda/10d

;lambda to micron
lambda = lambda / 1000d
;trans to decimal
trans = trans / 100d

;dlambda = lambda[1] - lambda[0]

ftstr = create_struct('lambda', lambda, 'trans', trans)

return, ftstr
END
