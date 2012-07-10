function getcolarr, noinput

	 n_cols = !d.n_colors ; number of colors available to the system
         IF (n_cols GT 255) THEN n_cols = 255 ; especially for 24-bit color tables
         col_array = fltarr(n_cols,3)         ; 3 columns = r,g,b


         col_array(0,*)  = [0.00,0.00,0.00] ; black
         col_array(1,*)  = [1.00,1.00,1.00] ; white
         col_array(2,*)  = [1.00,0.00,0.00] ; red
         col_array(3,*)  = [0.00,1.00,0.00] ; green
         col_array(4,*)  = [0.00,0.00,1.00] ; blue
         col_array(5,*)  = [1.00,1.00,0.00] ; yellow
         col_array(6,*)  = [0.00,1.00,1.00] ; cyan( light blue)
         col_array(7,*)  = [1.00,0.00,1.00] ; violet
         col_array(8,*)  = [1.00,0.60,0.00] ; orange
         col_array(9,*)  = [0.00,0.60,1.00] ; med blue
         col_array(10,*) = [1.00,0.00,0.60] ; pink
         col_array(11,*) = [0.00,1.00,0.70] ; blue/green
         col_array(12,*) = [0.80,1.00,0.00] ; yellow/green
         col_array(13,*) = [0.60,0.00,1.00] ; purple
         col_array(14,*) = [0.00,0.40,1.00] ; lightblue
         col_array(15,*) = [0.00,0.40,0.70] ; blue
         col_array(16,*) = [0.50,0.70,0.50] ; lighter green
         col_array(17,*) = [0.20,0.60,0.20] ; green
         col_array(18,*) = [0.20,0.40,0.20] ; green
         col_array(19,*) = [0.70,0.70,0.50] ; yellowish
         col_array(20,*) = [0.70,0.20,0.20] ; reddish
         col_array(21,*) = [0.50,0.50,0.50] ; gray


    	col_array = col_array * 255

return, col_array

;Then run:
;> tvlct, col_array[*,0],col_array[*,1],col_array(*,2)

end
