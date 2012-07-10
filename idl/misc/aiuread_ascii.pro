; $Log: read_ascii.pro,v $
;Revision 1.2  1998/09/01  15:40:42  rklein
;Added ability to skip comment lines
;
;Revision 1.1  1997/08/21  07:14:44  loewe
;Initial revision
;
; Read ascii tables into data array

;+
; NAME:
;       AIUREAD_ASCII
;
; PURPOSE: 	Read data stored in an ascii table into an IDL data
;		structure. The array must be organised in rows and columns, 
;		with the columns separated by at least one whitespace.
;		The number of columns is assumed to be 2, this can be 
;		changed using the 'ncol' keyword. Lines with '!', '%',
;		';' or 'C' as first character are skipped in the
;		processing as comment lines but are echoed on the screen.
;
;
; CALLING SEQUENCE: aiuread_ascii, filename, array [, NCOL=ncol, ...]
;
;
; INPUTS: 	filename: Name of the file to be read
;		array:	  Logical Name of the array the data will be stored
;			  in, will be created.
; 
; KEYWORDS:	ncol:	  If the number of columns in your array is not 2,
;			  but, e.g. 3, just use 'ncol=3'
;			  You can use ncol, to read the file as seperate strings
;			  (line by line) and process these later yourself.
;			  to do this, set 'ncol=0'. aiuread_ascii then returns a
;			  a string array containing the lines of the file.
;
;		comment:  NOW OBSOLETE: routine reads always only the
;                         first "ncol" columns.
;                         If this keyword is set, READ_ASCII reads only the 
;			  first ncol records of each line of the input file.
;			  Additional columns may then contain comments (or
;			  useless data), which are ignored.
;
;               comm_char: may contain a differnt set of characters
;                         idicating comments lines. Example: If
;                         comments start with 'c' or '$', set
;                         comm_char='c$'. 
;
;               skip:     skip the first SKIP lines while reading the
;                         file. This is convenient if the first lines
;                         are comment lines but do not have a leading
;                         comment char. 
;
;               quiet:    Set this key word to Supress any output.
;
;
; NOTES:	Rather primitive, but useful.
;
;
; REVISION HISTORY:
;       Written by M. Feldt             May 1996, Jena
;
;       Added ability to read string arrays, May 1997, MFeldt
;       
;       Added ability to skip comment lines, Sep 1998, rklein
;
;       Keyword SKIP added, May 1999, rklein
;-

pro aiuread_ascii, fn, a, NCOL=ncol, QUIET=quiet, COMMENT=comment, $
                       COMM_CHAR=comm_char,skip=skip

   if datatype(ncol,2) eq 0 then $
    ncol=2
   IF NOT keyword_set(comm_char) THEN comm_char = '!%;C'
   IF NOT keyword_set(skip) THEN skip = 0
   
   get_lun,fu
   t=string('xxxx')	
   n=0L
   openr,fu,fn
   FOR i=1,skip DO BEGIN
      readf,fu,t
      IF not keyword_set (quiet) THEN print,t
   ENDFOR
   repeat begin
      readf,fu,t
      IF strpos(comm_char,strmid(t,0,1)) EQ -1 $
       THEN  n=n+1 $
       ELSE IF not keyword_set (quiet) THEN print,t
   endrep until eof(fu)         ; #####  determine the number of rows
   if not keyword_set (quiet) then print,n,' valid rows found'
   close,fu
   
   if ncol eq 0 then BEGIN 
      a = strarr(n) 
      c = 'xxx'
      ncol = 1
   ENDIF ELSE BEGIN 
      a = fltarr(ncol,n)
      c = fltarr(ncol)
   ENDELSE

   openr,fu,fn   
   FOR i=1,skip DO readf,fu,t
   for i=0L,n-1 do begin
      REPEAT $
       readf,fu,t $
      UNTIL strpos(comm_char,strmid(t,0,1)) EQ -1
      reads,t,c
      a(i*ncol:(i+1)*ncol-1)=c
   endfor
   
   close,fu
   free_lun,fu
end
