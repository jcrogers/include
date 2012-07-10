;+
; NAME:
;       CAPFIRSTLETTER
;
; PURPOSE:
;
;       Given a string, separates the parts by white space, commas,
;       semi-colons, or colons. Each part has the first letter capitalized.
;       The returned string has the capitalized parts separated by a space.
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
;       capitalizedString = CatFirstLetter(theString)
;
; AUGUMENTS:
;
;       theString:         The input string.
;
; RETURN_VALUE:
;
;      capitalizedString:  The capitalized output string. There is a space between parts
;                          (words) of the input string.
;
; KEYWORDS:
;
;     None.
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, 29 July 2005.
;-
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright © 2005 Fanning Software Consulting
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
FUNCTION CapFirstLetter, theString

   ; Return to caller on error.
   On_Error, 2

   ; Separate string into parts.
   parts = StrSplit(theString, " ,;:", /Extract, /Preserve_Null)

   ; Capitalize the first letter of each part.
   FOR j=0, N_Elements(parts)-1 DO BEGIN
      parts[j] = StrLowCase(parts[j])
      firstLetter = StrUpCase(StrMid(parts[j], 0, 1))
      temp = parts[j]
      StrPut, temp, firstLetter, 0
      parts[j] = temp
   ENDFOR

   ; Join the parts together with a space.
   RETURN, StrJoin(parts, " ")
END