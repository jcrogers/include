;+
; NAME:
;       DBLTOSTR
;
; PURPOSE:
;
;       This is a program for converting a double precision numerical value
;       to a string. It was originally offered by BioPhys on the IDL newsgroup.
;
; AUTHOR:
;
;       FANNING SOFTWARE CONSULTING
;       David Fanning,  Ph.D.
;       1645 Sheely Drive
;       Fort Collins,  CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: davidf@dfanning.com
;       Coyote's Guide to IDL Programming: http://www.dfanning.com
;
; CATEGORY:
;
;       Utility
;
; CALLING SEQUENCE:
;
;       stringValue  =  DblToStr(value)
;
; INPUTS:
;
;       value - A double-precision or floating point value to be converted to a string.
;
; OUTPUTS:
;
;       stringValue - The converted string value.
;
; KEYWORDS:
;
;       None.
;
; RESTRICTIONS:
;
;       Assumes 14 significant digits of precision.
;
; MODIFICATION HISTORY:
;
;       Written by BioPhys and offered to the IDL newsgroup,  7 November 2005.
;       Slightly modified and renamed by David Fanning,  30 November,  2005.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright © 2005 Fanning Software Consulting.
;
; This software is provided "as-is",  without any express or
; implied warranty. In no event will the authors be held liable
; for any damages arising from the use of this software.
;
; Permission is granted to anyone to use this software for any
; purpose,  including commercial applications,  and to alter it and
; redistribute it freely,  subject to the following restrictions:
;
; 1. The origin of this software must not be misrepresented; you must
;    not claim you wrote the original software. If you use this software
;    in a product,  an acknowledgment in the product documentation
;    would be appreciated,  but is not required.
;
; 2. Altered source versions must be plainly marked as such,  and must
;    not be misrepresented as being the original software.
;
; 3. This notice may not be removed or altered from any source distribution.
;
; For more information on Open Source Software,  visit the Open Source
; web site: http://www.opensource.org.
;
;###########################################################################


FUNCTION DBLTOSTR,  value

   ; Error handling.
   On_Error,  2
   IF N_Elements(value) EQ 0 THEN Message,  'Double precision or floaing value must be passed to the function.'

   ; Get the data type.
   theType = Size(value, /Type)
   IF theType NE 4 AND theType NE 5 THEN BEGIN
       value = Double(value)
       theType = 5
   ENDIF

   ; Data extension.
   typeExt = theType EQ 4?'E':'D'

   ; Create a string, using the full-widtet G format.
   rawstr = StrTrim(String(value, Format = '(g)'), 2)

   ; Extract the sign from the string and remove it for the moment.
   sign = StrMid(rawstr, 0, 1) EQ '-'?'-':''
   rawstr = sign EQ ''?rawstr:StrMid(rawstr, 1)

   ; Is there an exponent in the string? If so, remove that for the moment.
   epos = StrPos(rawstr, 'e')
   indx = epos gt -1?StrMid(rawstr, epos+1):''
   rawstr = indx EQ ''?rawstr:StrMid(rawstr, 0, epos)

   ; Find the position of the decimal point.
   dpos = StrPos(rawstr, '.')

   ; Rounding process (assumes 14 significant digits).
   outstr = StrArr(15)
   FOR i = 0, 14 DO outstr[i] = StrMid(rawstr, i, 1)
   aux = Fix(StrMid(rawstr, 16, 1)) GE 5?1:0
   FOR i = 14,  0,  -1 DO BEGIN
      IF i NE dpos then BEGIN
         sumstr = StrTrim(String(aux+fix(outstr[i])), 2)
         sumlen = StrLen(sumstr)
         outstr[i] = StrMid(sumstr, sumlen-1, 1)
         aux = sumlen EQ 1?0:1
      ENDIF
   ENDFOR

   ; Throw away '0's at the end.
   ii = 14
   WHILE outstr[ii] EQ '0' DO BEGIN
      ii = ii-1
   ENDWHILE

   ; Reconstruct the string.
   saux = aux NE 0?'1':''
   outstr = sign + saux + StrJoin(outstr[0:ii]) + typeExt + indx

   ; Return it.
   RETURN, outstr

END

