;+
; NAME:
;       NUMBER_FORMATTER
;
; PURPOSE:
;
;       This is a utility routine format a number into a string. It is
;       used primarily for formatting numbers that will appear in
;       text widgets in widget programs.
;
; AUTHOR:
;
;       FANNING SOFTWARE CONSULTING
;       David Fanning, Ph.D.
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: davidf@dfanning.com
;       Coyote's Guide to IDL Programming: http://www.dfanning.com
;
; CATEGORY:
;
;       Utilities, Widget Programming
;
; CALLING SEQUENCE:
;
;       numberAsString = Number_Formatter(number)
;
; ARGUMENTS:
;
;       number:          The number to be turned into a string. May be any data type
;                        except complex, double complex, pointer or object. Must be a scalar.
;
; KEYWORDS:
;
;       DECIMALS:        Set this keyword to the number of decimal places to
;                        be included to the right of the decimal point in floats
;                        and doubles. Set to 2 by default.
;
; RETURN VALUE:
;
;       numberAsString:  A string representation of the number.
;
; COMMON BLOCKS:
;       None.
;
; EXAMPLES:
;
;       IDL> Print, Number_Formatter(16.837574837e-14)
;            1.683757e-13
;       IDL> Print, Number_Formatter(16.837574837e-14, Decimals=2)
;            1.68e-13
;
;
; RESTRICTIONS:
;
;     None.
;
; MODIFICATION HISTORY:
;
;       Written by:  David W. Fanning, 9 March 2006.
;-
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright © 2006 Fanning Software Consulting
;
; This software is provided "as-is", without any express or
; implied warranty. In no event will the authors be held liable
; for any damages arising from the use of this software.
;
; Permission is granted to anyone to use this software for any
; purpose, including commercial applications, and to alter it and
; redistribute it freely, subject to the following restrictions:
;
; 1. The origin of this software must not be misrepresented; you must
;    not claim you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation
;    would be appreciated, but is not required.
;
; 2. Altered source versions must be plainly marked as such, and must
;    not be misrepresented as being the original software.
;
; 3. This notice may not be removed or altered from any source distribution.
;
; For more information on Open Source Software, visit the Open Source
; web site: http://www.opensource.org.
;
;###########################################################################
FUNCTION Number_Formatter, number, DECIMALS=decimals

   On_Error, 2

   IF N_Elements(number[0]) EQ 0 THEN Message, 'A number must be passed as an argument to the function.''
   IF N_Elements(decimals) EQ 0 THEN decimals = 2

   ; If the number is a byte, convert it to an integer and return it.
   IF Size(number[0], /TNAME) EQ 'BYTE' THEN RETURN, String(Fix(number), Format='(I3)')

   ; If the number is a string, return it directly.
   IF Size(number[0], /TNAME) EQ 'STRING' THEN RETURN, number

   ; Is the number a negative value? Deal only with positive values, until the end.
   IF number LT 0.0 THEN minus = 1 ELSE minus = 0
   theNumber = Abs(number[0])

   ; Do the appropriate thing.
   CASE Size(theNumber, /TNAME) OF

      'INT': retValue = StrTrim(String(theNumber),2)

      'LONG': retValue = StrTrim(String(theNumber),2)

      'FLOAT': BEGIN

         ; Format the number with G format.
         aString = StrTrim(String(theNumber, Format='(G)'), 2)

         ; Split the number into a whole part and a fractional part.
         parts = StrSplit(aString, '.', /Extract)
         parts[1] = StrTrim(parts[1],2)

         ; Does the fractional part have an E or a D in it?
         loc = StRegEx(parts[1], '[DE]')
         CASE loc OF

            -1: BEGIN ; No exponent.

                ; Round to the number of decimals you want.
                fracpart = StrTrim(Round(Float('1.' + parts[1]) * (10L^decimals), /L64), 2)
                IF StrMid(fracpart,0,1) EQ '2' THEN BEGIN
                  parts[0] = StrTrim(Long(parts[0]) + 1, 2)
                ENDIF
                parts[1] = StrMid(fracpart, 1)
                retValue = StrTrim(parts[0],2) + '.' + parts[1]
                END

            ELSE: BEGIN

                ; Divide the fractional part of the number up into parts.
                ; Treat p[0] as you treated parts[1] above. Then put it all
                ; back together.
                p = StrSplit(parts[1], '[DdEe]', /RegEx, /Extract)

                ; Round to the number of decimals you want.
                fracpart = StrTrim(Round(Float('1.' + p[0]) * (10L^decimals), /L64), 2)
                IF StrMid(fracpart,0,1) EQ '2' THEN BEGIN
                  parts[0] = StrTrim(Long(parts[0]) + 1, 2)
                ENDIF
                p[0] = StrMid(fracpart, 1)

                ; Get the exponent sign and exponent part.
                expSign = StrMid(p[1],0,1)
                expPart = StrMid(p[1],1)

                ; Trim zeros in exponent.
                firstChar = StrMid(expPart, 0, 1)
                WHILE firstChar EQ '0' DO BEGIN
                  expPart = StrMid(expPart, 1)
                  firstChar = StrMid(expPart, 0, 1)
                ENDWHILE

                ; Put it all back together.
                retValue = StrTrim(parts[0],2) + '.' + p[0] + StrLowCase(StrMid(parts[1],loc,1)) + expSign + expPart
                END

         ENDCASE

         END

      'DOUBLE': BEGIN
         ; Format the number with G format.
         aString = StrTrim(String(theNumber, Format='(G)'), 2)

         ; Split the number into a whole part and a fractional part.
         parts = StrSplit(aString, '.', /Extract)
         parts[1] = StrTrim(parts[1],2)

         ; Does the fractional part have an E or a D in it?
         loc = StRegEx(parts[1], '[DE]')
         CASE loc OF

            -1: BEGIN ; No exponent.

                ; Round to the number of decimals you want.
                fracpart = StrTrim(Round(Float('1.' + parts[1]) * (10L^decimals), /L64), 2)
                IF StrMid(fracpart,0,1) EQ '2' THEN BEGIN
                  parts[0] = StrTrim(Long(parts[0]) + 1, 2)
                ENDIF
                parts[1] = StrMid(fracpart, 1)
                retValue = StrTrim(parts[0],2) + '.' + parts[1]
                END

            ELSE: BEGIN

                ; Divide the fractional part of the number up into parts.
                ; Treat p[0] as you treated parts[1] above. Then put it all
                ; back together.
                p = StrSplit(parts[1], '[DdEe]', /RegEx, /Extract)

                ; Round to the number of decimals you want.
                fracpart = StrTrim(Round(Float('1.' + p[0]) * (10L^decimals), /L64), 2)
                IF StrMid(fracpart,0,1) EQ '2' THEN BEGIN
                  parts[0] = StrTrim(Long(parts[0]) + 1, 2)
                ENDIF
                p[0] = StrMid(fracpart, 1)

                ; Get the exponent sign and exponent part.
                expSign = StrMid(p[1],0,1)
                expPart = StrMid(p[1],1)

                ; Trim zeros in exponent.
                firstChar = StrMid(expPart, 0, 1)
                WHILE firstChar EQ '0' DO BEGIN
                  expPart = StrMid(expPart, 1)
                  firstChar = StrMid(expPart, 0, 1)
                ENDWHILE

                ; Put it all back together.
                retValue = StrTrim(parts[0],2) + '.' + p[0] + StrLowCase(StrMid(parts[1],loc,1)) + expSign + expPart
                END

         ENDCASE

         END

      'UINT': retValue = StrTrim(String(theNumber),2)

      'ULONG': retValue = StrTrim(String(theNumber),2)

      'LONG64': retValue = StrTrim(String(theNumber),2)

      'ULONG64': retValue = StrTrim(String(theNumber),2)

      ELSE: Message, 'Cannot format a number of this type: ' + Size(theNumber, /TNAME) + '.'

   ENDCASE

   ; Need a minus sign?
   IF minus THEN retValue = '-' + retValue

   RETURN, retValue

END ;----------------------------------------------------------------------------------------