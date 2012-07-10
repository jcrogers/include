pro psopen, outfile, silent=silent, square=square

if keyword_set(square) then ys=18 else ys=21

if n_elements(outfile) eq 0 then outfile='psfile.ps'
  set_plot, 'ps'
  device, filename=outfile, xsize=18, ysize=ys, $
          yoffset = 4.5, /color, bits_per_pixel=8
  loadct, 13, /silent
  cola = GetColArr()
  tvlct, cola[*,0], cola[*,1], cola[*,2]
  ;[2]Red, [3]Green, [4]Blue, [5]yellow, [6]cyan, [7]violet, 
  ;[8]orange, [9]med.blue, [10]pink,  [11]sea-green

if not keyword_set(silent) then print, 'Output file: '+outfile

end
