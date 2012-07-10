;+
; NAME:
;    GET_OBJECT_ID
;
; PURPOSE:
;
;    The purpose of this function is to be able to obtain a unique
;    object identifier string for a heap variable (object or pointer).
;
; AUTHOR:
;
;   FANNING SOFTWARE CONSULTING
;   David Fanning, Ph.D.
;   1645 Sheely Drive
;   Fort Collins, CO 80526 USA
;   Phone: 970-221-0438
;   E-mail: davidf@dfanning.com
;   Coyote's Guide to IDL Programming: http://www.dfanning.com/
;
; CATEGORY:
;
;    Utility.
;
; CALLING SEQUENCE:
;
;    objectID = Get_Object_ID(theObject)
;
; INPUTS:
;
;    theObject:    The object or pointer for which an identifier is requested. If
;                  this is a null object, the function returns the string
;                  "NullObject". If it is a null pointer, "NullPointer". If
;                  it is neither, a null string is returned.
;
; OUTPUTS:
;
;    objectID:     The unique object identifier.
;
; KEYWORDS:
;
;    None.
;
; EXAMPLE:
;
;    Create a trackball object and obtain its unique object ID.
;
;       IDL> theObject = Obj_New('TRACKBALL', [100,100], 50)
;       IDL> objectID = Get_Object_ID(theObject)
;       IDL> Print, objectID
;               ObjHeapVar71(TRACKBALL)
;
; MODIFICATION HISTORY:
;
;    Written by: David W. Fanning, 4 September 2003.
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
FUNCTION Get_Object_ID, theObject

   On_Error, 2

   ; Store information about the object in a string variable.
   Help, theObject, Output=theInfo
   theInfo = theInfo[0]

   ; Search the string for the identifying information and return it.
   f_bracket = StrPos(theInfo, '<')
   r_bracket = StrPos(theInfo, '>')
   ID = StrMid(theInfo, f_bracket+1, r_bracket-f_bracket-1)

   RETURN, ID

END