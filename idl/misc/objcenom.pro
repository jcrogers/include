pro objcenom,img,xcenter,ycenter,x,y,radius,INFO=INFO
;+
; NAME: 
;   OBJCENOM
; PURPOSE:
;   Compute "center of mass" in a box with the specified center and radius.
;   This procedure is suited for irregular objects with multiple peaks that
;   that would normall confuse a steller centroider.
; CALLING SEQUENCE: 
;   OBJCENOM,img,xcenter,ycenter,xcen,ycen,radius,[/INFO]
; INPUTS:     
;   IMG      Two dimensional image array
;   XGUESS   Scalar giving X box center
;   YGUESS   Scalar giving Y box center
;   RADIUS   Scalar giving half-diameter of box within which to compute c.o.m.
;              If not suppied, the radius will be prompted for
; OUTPUTS:   
;   XCEN     The computed X centroid position.  -1 if unable to centroid
;   YCEN     The computed Y centroid position.  -1 if unable to centroid
;        NOTE: The convention is such that the CENTER of a pixel is (n.00,n.00)
;  OPTIONAL OUTPUT KEYWORDS:
;   INFO     Return some informational parameters?
; PROCEDURE: 
;   Extract box. determine a sky value from square annulus from radius to
;   radius+3.  computer center of mass (counts) in the box.
;   Actually, the sky is pretty irrelevant, but I do it just for fun.
; MODIFICATION HISTORY:
;   24-JAN-94 Written by Eric Deutsch
;-


  if (n_params(0) lt 5) then begin
    print,'IDL> OBJCENOM,img,xcenter,ycenter,xcen,ycen,radius,[/INFO]'
    print,'e.g> OBJCENOM,img,213,450,xcen,ycen,6,/INFO'
    return
    endif

  if (n_elements(INFO) eq 0) then INFO=0

  if (n_params(0) eq 5) then begin
    inp='' & radius=0
    while (radius le 0) do begin
      read,'Enter radius of box for C.O.M.: ',inp
      if (strnumber(inp) eq 1) then radius=inp
      endwhile
    endif

; ***** Extract the necessary box and sky value box ***************************

  xguess=fix(xcenter) & yguess=fix(ycenter)
  im1=extrac(img,xguess-radius,yguess-radius,radius*2,radius*2)*1.0

  im2=extrac(img,xguess-radius-3,yguess-radius-3,(radius+6)*2,(radius+6)*2)*1.0
  bkgmask=intarr((radius+6)*2,(radius+6)*2)
  bkgmask(3:radius*2+3,3:radius*2+3)=1
  bkgarr=im2(where(bkgmask eq 0))

  skyline,bkgarr,skyv,rmsv
  im1=im1-skyv
  if (INFO eq 1) then print,'Background Value: ',strn(skyv),'   ',vect([rmsv])


; ***** Calculate the center of Volume of the star ****************************

  sttot=1.0D*total(im1) & i=0 & xcen=0. & tot=0.
  while (xcen eq 0) and (i lt radius*2) do begin
    band=im1(i,*) & btot=total(band)
    if (tot+btot gt sttot/2.) then xcen=i-.5+(sttot/2-tot)/btot
    i=i+1 & tot=tot+btot
    endwhile
  i=0 & ycen=0. & tot=0.
  while (ycen eq 0) and (i lt radius*2) do begin
    band=im1(*,i) & btot=total(band)
    if (tot+btot gt sttot/2.) then ycen=i-.5+(sttot/2-tot)/btot
    i=i+1 & tot=tot+btot
    endwhile

  x=xguess-radius+xcen
  y=yguess-radius+ycen

  return
end
