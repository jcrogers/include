pro joplot, x, y, yupe, yloe, xupe=xupe, xloe=xloe, color=color, $
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
if color eq 'dk.green' then pa.colr = 18
if color eq 'darkgreen' then pa.colr = 18
if color eq 'darkred' then pa.colr = 20
if color eq 'gray' then pa.colr = 21


;Error bars??
if n_elements(yupe) gt 0 then begin
  if n_elements(yloe) eq 0 then yloe = -yupe
  oploterror, x, y, yupe, /hibar, color=pa.colr, thick=pa.thk, psym=pa.stype, $
              symsize=pa.ssize, errthick=pa.thk, errcolor=pa.colr ;, hatlength=hatlength
  oploterror, x, y, yloe, /lobar, color=pa.colr, thick=pa.thk, psym=pa.stype, $
              symsize=pa.ssize, errthick=pa.thk, errcolor=pa.colr ;, hatlength=hatlength
endif else begin
;No error bars -- can be done with symbols or with a line
  oplot, x, y, color=pa.colr, thick=pa.thk, psym=pa.stype, $
         symsize=pa.ssize, linestyle=pa.lstyle
endelse

;X-Error bars
if n_elements(xupe) gt 0 then begin
  if n_elements(xloe) eq 0 then xloe = -xupe
  oploterror, x, y, xupe, yupe*0, /hibar, color=pa.colr, thick=pa.thk, psym=pa.stype, $
              symsize=pa.ssize, errthick=pa.thk, errcolor=pa.colr ;, hatlength=hatlength
  oploterror, x, y, xloe, yloe*0, /lobar, color=pa.colr, thick=pa.thk, psym=pa.stype, $
              symsize=pa.ssize, errthick=pa.thk, errcolor=pa.colr 
endif

end




