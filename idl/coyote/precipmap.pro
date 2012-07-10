;+
; NAME:
;       PrecipMap
;
; PURPOSE:
;
;       This is a program that demonstrates how to place an IDL map projection
;       onto an image that is already in a map projection space. It uses a NOAA
;       precipitation image that is in a polar stereographic map projection, and
;       for which the latitudes and longitudes of its four corners are known.
;
;       For additional details, see http://www.dfanning.com/map_tips/precipmap.html.
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
;       Map Projection
;
; CALLING SEQUENCE:
;
;       IDL> PrecipMap, filename
;
; INPUTS:
;
;      filename:   The name of the precipitation file. For demo, download
;                  ST4.2005010112.24h.bin from ftp://ftp.dfanning.com/pub/dfanning/outgoing/misc.
;
; RESTRICTIONS:
;
;     Requires files from the Coyote Library:
;
;     http://www.dfanning.com/documents/programs.html
;
; MODIFICATION HISTORY:
;
;  Written by David W. Fanning, 28 April 2006 from code and discussion supplied
;  by James Kuyper in the IDL newsgroup.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright © 2006 Fanning Software Consulting.
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

FUNCTION PrecipMap_Annotate, axis, index, value

   ; This is a function for annotating the colorbar.

   plevels = Indgen(15)
   levels = [0, 2, 5, 10, 15, 20, 25, 50, 75, 100, 125, 150, 200, 250]
   labels = StrTrim(levels, 2)
   text = [labels[0:12], labels[13] + '+', '']
   selection = Where(plevels eQ value)
   RETURN, (text[selection])[0]

END ;----------------------------------------------------------------------



PRO PrecipMap, filename

   ; Error handling.
   Catch, theError
   IF theError NE 0 THEN BEGIN
      Catch, /Cancel
      void = Error_Message()
      RETURN
   ENDIF

   ; Need a filename?
   IF N_Elements(filename) EQ 0 THEN filename = 'ST4.2005010112.24h.bin' ; Demo file.
   OPENR, lun, filename, /Get_Lun
   image = FltArr(1121, 881)
   ReadU, lun, image
   Free_Lun, lun

   ; Set up 14 colors, roughly equvilent to NOAA precipitation colors.
   ; Use black for missing values.
   colors = ['dark green', 'lime green', 'light sea green', 'yellow', 'khaki', $
             'dark goldenrod', 'light salmon', 'orange', 'red', 'sienna', 'purple', $
             'orchid', 'thistle', 'sky blue', 'black']
   TVLCT, FSC_COLOR(colors, /Triple), 1

   ; Process image data. Missing values = 9.999e20.
   s = Size(image, /Dimensions)
   scaledImage = BytArr(s[0],s[1])
   levels = [0, 2, 5, 10, 15, 20, 25, 50, 75, 100, 125, 150, 200, 250]
   FOR j=1,13 DO BEGIN
      index = Where(image GE levels[j-1] AND image LT levels[j], count)
      IF count GT 0 THEN scaledImage[index] = Byte(j)
   ENDFOR
   index = Where(image GT 250 AND image LT 9.999e20, count)
   IF count GT 0 THEN scaledImage[index] = 14B
   missing = Where(image EQ 9.999e20, missing_count)
   IF missing_count GT 0 THEN scaledImage[missing] = 15B

   ; Set up the map structure. This image is a stereographic image.
   stereo = MAP_PROJ_INIT('Stereographic', CENTER_LONGITUDE=-105, CENTER_LATITUDE=90)

   ; Set up latitutes and longitudes at the corners of the image. (ll, ul, ur, lr)
   longitude = [-119.023D, -134.039, -59.959, -80.7500]
   latitude =  [  23.117D,   53.509,  45.619,  19.8057]

   ; Project those lat/lon points into UV space..
   uv = MAP_PROJ_FORWARD(longitude, latitude, MAP_STRUCTURE=stereo)

   ; To set up map projection space, we need values at left, top, right, and bottom
   ; of image. We calculate these in UV space. Note that these values are in the
   ; center of the pixel. We have to move them to the edge of the pixel below.
   ; The U direction corresponds to longitude, and the V direction to latitude.
   topv =   (uv[1,1] + uv[1,2]) * 0.5
   botv =   (uv[1,0] + uv[1,3]) * 0.5
   leftu =  (uv[0,0] + uv[0,1]) * 0.5
   rightu = (uv[0,2] + uv[0,3]) * 0.5

   ; Calculate the scales in UV directions
   xscale = (rightu-leftu) / (1121-1)
   yscale = (topv-botv) / (881-1)

   ; UV coordinates of the mid-points of outer edges. (Note that these are moved
   ; to the edge of the pixel now.)
   u = [leftu-(0.5*xscale), 0.5*(leftu+rightu), rightu+(0.5*xscale), 0.5*(leftu+rightu)]
   v = [0.5*(botv+topv),     topv+(0.5*yscale),   0.5*(botv+topv),    botv-(0.5*yscale)]

   ; Convert the UV coordinates back to lat/lon coordinates.
   lonlat = MAP_PROJ_INVERSE(u, v, MAP_STRUCTURE=stereo)

   ; Calculate the limits of the map projection.
   limit = Reform([lonlat[1,*],lonlat[0,*]], 8)

   ; Decide on a position of the image in the window.
   pos = [0.05, 0.25, 0.95, 0.95]

   ; Erase the window, unless you are in PostScript.
   IF (!D.Flags AND 256) NE 0 THEN Erase, COLOR=FSC_COLOR('ivory')

   ; Display the image. The variable POS will change (probably) to keep the aspect.
   TVIMAGE, scaledImage, POSITION=pos, /NOINTERP, /KEEP_ASPECT

   ; Set up a map projection space on top of the image.
   MAP_SET, 90, -105, /STEREOGRAPHIC, LIMIT=limit, /NOBORDER, POSITION=pos, /NOERASE

   ; Add continent and state outlines, along with grid labels.
   MAP_CONTINENTS,/HIRES, Color=FSC_Color('medium gray'), /USA
   MAP_GRID,/LABEL, Color=FSC_Color('light gray')

   ; Add a colorbar. Non-linear scaling requires use of tick formatting function.
   Colorbar, NColors=14, Bottom=1, Position=[pos[0], 0.1, pos[2], 0.15], $
      Divisions=14, Title='24 Hour Precipitation (mm)', $
      Color=FSC_Color('black'), XTicklen=1, XMinor=1, XTickFormat='precipmap_annotate'
END ;----------------------------------------------------------------------
