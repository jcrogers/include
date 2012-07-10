pro jxyo, x, y, text, color=color, size=size, $
            thk1=thk1, thk2=thk2, cthk=cthk, csize1=csize1, csize2=csize2, $
            csize3=csize3, ssize=ssize, stype=stype, lstyle=lstyle, $
            hatlength=hatlength

pa=pastruct()

if n_elements(thk1) ne 0 then pa.thk=thk1
if n_elements(thk2) ne 0 then pa.thk2=thk2
if n_elements(cthk) ne 0 then pa.cthk=cthk
if n_elements(csize1) ne 0 then pa.csize=csize1
if n_elements(csize2) ne 0 then pa.csize2=csize2
if n_elements(csize3) ne 0 then pa.csize3=csize3
if n_elements(ssize) ne 0 then pa.ssize=ssize
if n_elements(stype) ne 0 then pa.stype=stype
if n_elements(lstyle) ne 0 then pa.lstyle=lstyle
;if n_elements(hatlength) eq 0 then hatlength = !d.x_visize / 100.

;Colors here
if n_elements(color) eq 0 then color = 'black'
if color eq 'black' then pa.colr = 0
if color eq 'red' then pa.colr = 2
if color eq 'green' then pa.colr = 3
if color eq 'blue' then pa.colr = 4
if color eq 'cyan' then pa.colr = 6
if color eq 'pink' then pa.colr = 7
if color eq 'orange' then pa.colr = 8
if color eq 'purple' then pa.colr = 13
if color eq 'dk green' then pa.colr = 18
if color eq 'gray' then pa.colr = 21

;Sizes
if n_elements(size) eq 0 then size = 'med'
if size eq 'big' then pa.csize=1.4
if size eq 'med' then pa.csize=1.2
if size eq 'small' then pa.csize=0.9
if size eq 'tiny' then pa.csize=0.7

xyouts, x, y, textoidl(text), color=pa.colr, charsize=pa.csize, charthick=pa.cthk

end
