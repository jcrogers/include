;+
; NAME:
;    DIRPATH
;
; PURPOSE:
;
;    The purpose of this function is to return a device-independent
;    name of a directory. It is similar to the IDL-supplied FILEPATH
;    routine, except that a file name is not required.
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
;    IDL> theDirectory = DIRPATH('examples')
;    IDL> Print, theDirectory
;             C:\IDL\IDL56\examples
;
; INPUTS:
;
;    subDirectory:    This is a string argument containing the name of the
;                     sub-directory you wish to use. It can be a string
;                     array of sub-directory names. By default, the subDirectory
;                     is set to ['examples', 'data']. To only return the Root_Directory,
;                     set the subDirectory to a null string ("").
;
; KEYWORDS:
;
;    ROOT_DIRECTORY: The name of the root directory to use. By default,
;                    the root directory is set to !DIR.
;
; OUTPUTS:
;
;    The machine-independent directory path.
;
; MODIFICATION HISTORY:
;
;    Written by: David W. Fanning, 28 April 2003.
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
FUNCTION DirPath, subdirectory, RootDirectory=rootdirectory

   ; Returns the name of a directory in the spirit of FILEPATH.

   ; rootdirectory - The name of the root directory where subdirectories branch.
   ;                 Use !Dir by default.
   ;
   ; subdirectory -  The name of a subdirectory. Use string array to specify path of
   ;                 multiple subdirectories. If absent, uses ['examples', 'data'].

   ; Catch the error. If something goes wrong, return the current directory.

   Forward_Function Error_Message

   Catch, theError
   IF theError NE 0 THEN BEGIN
      Catch, /Cancel
      ok = Error_Message(/Traceback)
      CD, Current=currentDir
      Return, currentDir
   ENDIF

   ; Check for arguments. Define defaults, if necessary.
   IF N_Elements(rootdirectory) EQ 0 THEN rootdirectory = !Dir
   IF N_Elements(subdirectory) EQ 0 THEN subdirectory = ['examples', 'data']

   ; Use FILEPATH to construct a device-independent file name. Strip the directory
   ; information from that and return it.
   source = FilePath(Root_Dir=rootdirectory, SubDirectory=subdirectory, 'junk.pro')
   directory = Strmid(source, 0, Strpos(source, Path_Sep(), /REVERSE_SEARCH))

   RETURN, directory
END