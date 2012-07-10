function pastruct

pa = create_struct($
     'thk', 4., $
     'cthk', 2., $
     'csize', 1.4, $
     'stype', 6, $
     'ssize', 0.3, $
     'thk2', 1.2, $
     'csize2', 0.9, $
     'csize3', 1.2, $
     'yr', [0.98,1.02], $
     'lstyle', 0, $
     'colr', 0 $
     )

return, pa
end
