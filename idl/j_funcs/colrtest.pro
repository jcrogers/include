pro colrtest

psopen, 'colrtest.ps'
!p.multi=[0,1,1]
pa=pastruct()

plot, [0,10],[0,0], /nodata, yrange=[-1, 26], /ystyle, $
      thick=pa.thk, charsize=pa.csize, charthick=pa.cthk, $
      ytitle='Color', title='Colors by "color=" number'

for ii=0,25 do oplot, [0,10], [ii,ii], thick=10, color=ii

psclose
print, 'output file: colrtest.ps'
end
