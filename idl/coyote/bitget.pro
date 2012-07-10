;+
; NAME:
;       BITGET
;
; PURPOSE:
;
;       Returns the bit value (0 or 1) of a specified bit in a supplied number.
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

;       Utilities
;
; CALLING SEQUENCE:
;
;       bitValue = BitGet(number, bit)
;
; INPUT_PARAMETERS:
;
;       number:          The input number. Should be a scalar integer. If not, it is converted to
;                        one by rounding.
;
;       bit:             The number of the bit you are interested in. A value between 0 and 63.
;                        If not supplied, all 64 bit values of the number are returned. May be
;                        an array of bit numbers.
;
; OUTPUT_PARAMETERS:
;
;      bitValue:        The value, 0 or 1, of the specified bit in the number.
;
; KEYWORDS:
;
;     SILENT:           If set, suppresses informational messages regarding rounding operations.
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, 14 June 2006.
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
FUNCTION BitGet, value, bit, SILENT=silent

   ; Return to caller if something goes wrong.
   On_Error, 2

   ; Get the data type.
   theType = Size(value, /TYPE)

   ; Special pointer processing.
   IF theType EQ 10 THEN BEGIN
      theValue = *value
      theType = Size(theValue, /TYPE)
   ENDIF ELSE theValue = value

   ; Validate data type. Round any non-integer data type.
   CASE 1 OF
      theType LT 1: Message, 'VALUE must be defined.'
      theType GT 0 AND theType LT 4:
      theType GT 5 AND theType LT 10: Message, 'Wrong data type (' + Size(theValue, /TNAME) + $
         ') supplied for determining bit value.'
      theType EQ 11: Message, 'Wrong data type supplied for determining bit value.'
      theType GT 11 AND theType LT 16:
      ELSE: BEGIN
         IF ~Keyword_Set(silent) THEN Message, 'Converting value to INTEGER format...', /Informational
         theValue = Round(theValue, /L64)
         END
   ENDCASE

  ; Make sure the value is scalar.
  IF N_Elements(theValue) NE 1 THEN Message, 'Examined value must be a scalar.'
  theValue = theValue[0]

  exponent = 2ULL^UL64indgen(64)

  ; If not bit value is specifed, return all the bits in the value.
  IF N_Elements(bit) EQ 0 THEN BEGIN
      CASE 1 OF
         theType EQ 1: RETURN, Reverse(((theValue AND exponent)/exponent)[0:7])
         theType EQ 2 OR theType EQ 12: RETURN, Reverse(((theValue AND exponent)/exponent)[0:15])
         theType EQ 3 OR theType EQ 13: RETURN, Reverse(((theValue AND exponent)/exponent)[0:31])
         ELSE: RETURN, Reverse((theValue AND exponent)/exponent)
      ENDCASE
  ENDIF ELSE  bit = 0 > bit < 63 ; Confine it to correct range.

  ; Calculate the bit value and return it.
  RETURN, ((theValue AND exponent)/exponent)[bit]

END