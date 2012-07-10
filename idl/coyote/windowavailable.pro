;+
; NAME:
;       WindowAvailable
;
; PURPOSE:
;
;       This function returns a 1 if the specified window index number is
;       currently open or available. It returns a 0 if the window is currently
;       closed or unavailable.
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
;       Utilities
;
; CALLING SEQUENCE:
;
;       available = WindowAvaiable(windowIndexNumber)
;
; INPUTS:
;
;       windowIndexNumber:   The window index number of the window you wish to
;                            know is available or not.
;
; KEYWORDS:
;
;       None.
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, June 2005.
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

FUNCTION WindowAvailable, windowID

   ; Error handling.

Catch, theError
IF theError NE 0 THEN BEGIN
   Catch, /Cancel
   ok = Error_Message(Traceback=1)
   Print, 'Window ID: ', windowID
   RETURN, 0
ENDIF

   ; Get current window if window index number is unspecified.

IF N_Elements(windowID) EQ 0 THEN RETURN, 0
IF windowID LT 0 THEN RETURN, 0

   ; Default is window closed.

result = 0


CASE !D.Name OF

   'WIN': BEGIN
      Device, Window_State=theState
      result = theState[windowID]
      END

   'X': BEGIN
      Device, Window_State=theState
      result = theState[windowID]
      END

   'MAC': BEGIN
      Device, Window_State=theState
      result = theState[windowID]
      END

   ELSE:
ENDCASE

RETURN, result
END