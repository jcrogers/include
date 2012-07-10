FUNCTION pflist, date, ftype=ftype, rawpath=rawpath, $
                 test=test, disk=disk, silent=silent

;Makes a list of the images from a given date
; 20090812, 20090824, 20091204, 20091207
;and file type
; sci, flat, dark
;WITH the path name
;
;Example element:
;  '../data/b_run/sci/HAWKI.2009-08-26T22_55_15.248.fits'

;Returns a string array with each entry being the path and name of a
;fits file to read in.

if n_elements(date) eq 0 then date = '20090812'
if n_elements(ftype) eq 0 then ftype = 'sci'

if n_elements(rawpath) ne 0 then begin
  flf = rawpath+'ut'+date+'_'+ftype+'.txt'
  path = rawpath+ftype+'/'
endif

if n_elements(path) eq 0 then begin
  if date eq '20090812' then begin
    if keyword_set(disk) then path = '/Volumes/HobbesMac/hawki-wasp4/data/a_run/' $
       else path = '../data/a_run/'
    flf = path+'vlt'+date+'_'+ftype+'.txt'
    path = path + ftype+'/'
    if keyword_set(test) then flf = 'vlt0812_'+ftype+'test.txt'
  endif
  if date eq '20090824' then begin
    if n_elements(path) eq 0 then $
    if keyword_set(disk) then path = '/Volumes/HobbesMac/hawki-wasp4/data/b_run/' $
                       else path = '../data/b_run/'
    flf = 'vlt20090824_'+ftype+'.txt'
    path = path + ftype+'/'
  endif
  if (date eq '20091204' or date eq '20091207') then begin
    if n_elements(path) eq 0 then $
      if keyword_set(disk) then $
        path = '/Volumes/PUDDLE_JUMP/hawki-corot1/UT'+$
               date+'/' else $
        path = '../data/corot1/UT'+date+'/'
     flf = path+'vlt'+date+'_'+ftype+'.txt'
     path = path+ftype+'/'
  endif
endif

nf = file_lines(flf)
if not keyword_set(silent) then print, $
   ftype+': '+strtrim(nf,2)+' frames to read in.'

readcol, flf, fnames, format='(a)', /silent

filist = path+fnames

return, filist

end
