;+
; NAME:
;       HELP_VAR
;
; PURPOSE:
;
;       The purpose of this program is to display HELP on just
;       the variables at the level in which HELP_VAR is called.
;       It is similar to the HELP command, except that compiled
;       functions and procedures are not displayed.
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
;       Utilities.
;
; CALLING SEQUENCE:
;
;       HELP_VAR
;
; REQUIRED INPUTS:
;
;       None.
;
; SIDE EFFECTS:
;
;       Memory is allocated for each variable, in turn, then deleted.
;       Uses undefined and unsupported ROUTINE_NAMES function. May not
;       work in all versions of IDL, including future versions.
;
; EXAMPLE:
;
;
;       PRO HELP_VAR_TEST
;          a = 4.0
;          b = Lindgen(11)
;          HELP_VAR
;       END
;
;       IDL> help_var
;            A          FLOAT     =       4.00000
;            B          LONG      = Array[11]
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, 8 August 2003.
;-
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright © 2003 Fanning Software Consulting
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

PRO HELP_VAR_UNDEFINE, varname
IF (N_Elements(varname) NE 0) THEN tempvar = Temporary(varname)
END


PRO HELP_VAR

;What level are we on?

levelNumber = ROUTINE_NAMES(/LEVEL)

; Get the names of the variables one level above me.

names = ROUTINE_NAMES(Variables=levelNumber - 1)

; Check to see if you can grab those variables.
; You can only set a value if the variable is define.
;This routine will skill all undefined variables.

FOR j=0, N_Elements(names) - 1 DO BEGIN

   ; Get the variable if it is defined.
   IF N_Elements(ROUTINE_NAMES(names[j], FETCH=levelNumber - 1)) GT 0 THEN BEGIN
   value  = ROUTINE_NAMES(names[j], FETCH=levelNumber - 1)

   ; What is this variable?
   HELP, value, Output=s

   ; Delete the variable so we don't double our memory
   ; allocation. :-(

   Help_Var_UnDefine, value

   ; Substitute the actual name of the variable for VALUE
   ; and print it out.

   Print, StrUpCase(names[j]) + StrMid(s, 6)

   ENDIF

ENDFOR

END
