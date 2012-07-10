pro fastpsplot, x, y, psym=psym

if n_elements(psym) eq 0 then psym=0

set_plot, 'ps'
device, filename='test.ps'
plot, x, y, psym=psym
device, /close
print, 'Output file: test.ps'
end
