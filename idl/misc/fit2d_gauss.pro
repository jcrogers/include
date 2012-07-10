PRO fit2d_gauss,image,coef,modim,errcoef,difim, AUTO=auto, ACCURACY=accuracy, PRINT=print, log=log

; i$id: fit2d_gauss.pro

; Find position of a gaussian profile in an image
;+
; NAME:		FIT2D_GAUSS
;
; PURPOSE:	Find position of a gaussian profile in an image
;                      	
;
; CATEGORY:	Fitting, Image processing               	
;
; CALLING SEQUENCE: 
;		FIT2D_GAUSS, image, coef [,modim [, errcoef]], [ACCURACY=accuracy] $
;		 [, PRINT=print]
;
; INPUT:
;		image:	The image, in which the gaussian is to be fitted.
;
;		coef:	Estimated parameters of the fit, contains
;		coef(0)	Peak intensity
;		coef(1)	x-position
;		coef(2) x-stdev
;		coef(3) y-position
;		coef(4) y-stdev
;		coef(5) Background
;
;		Is updated upon termination to the optimum parameters found!
;
; KEYWORDS:	
;
;		ACCURACY: Set the accuracy, where iteration should terminate
;			when the relative Chi^2 improvement gets lass than accuracy.
;			if this takes more than 30 iterations, an error message is
;			produced, and only 30 iterations are performed.
;			Yet, the parameters are still returned as found after the 30. iteration!
;
;		PRINT:	Print out information about the results found.
;		
; OUTPUT:
;		coef:	see above!
;
; OPTIONAL OUTPUT:
;		modim:	The image which contains the fitted gaussian.
;
;		errcoef:Vector containing the errors of coef as they result from the fit!
;
; ROUTINES CALLED:
;		None
;
; RESTRICTIONS:
;		None
;
; PROCEDURE:
;		A Newton-Roughton fit is performed in the parameter space. 
;		CAUTION: If the initial parameters are to far from the optimum
;		(In fact if they are only slightly away from it), this procedure
;		will produce mind bogglingly crazy results!
;
; RISKS & SIDE-EFFECTS:
;		See above. THIS ROUTINE IS NOT MEANT TO BE USED INTERACTIVELY
;		BUT TO BE CALLED BY CENTER_GAUSS!
;
; EXAMPLE:	fit2d_gauss, image, coef
;			fit a 2-dimensional gaussian in image, where coef contains
;			the previously estimated optimum parameters.
;
; MODIFICATION HISTORY:
; 	Written by:	M. Feldt
;                       MPG-WG "Dust in Star Forming Regions"
;                       Schillergaesschen 3
;                       D-07745 Jena
;
;			Feb 96  
;                       Oct. 99, changes by B.St
;                       corrected error in partial derivations for sigme
;                       iterate on ln(I), ln(sigma_x), ln(sigma_y) to force positivity
;
;                       Jan 00, this was still buggy, goto it right now
;
;                       Nov.00, leads to strange results in case of small numbers,
;                       introduced keyword log, HOWEVER: switched back to linear behaviour
;                       for I, sigma_x, and sigma_y since otherwise, errors are not
;                       comparable (between log and linear quantities, has to be understood!)
;-



saveimage=image

log=0

; adjust numerics to avoid extreme range of singular values
; range pixel coordinates and flux levels may be VERY different! 
rr=coef[0]*2/(coef[1]+coef[3])

coef[0]=coef[0]/rr
image=image/rr

imsize=size(image)
sizx=imsize(1)
sizy=imsize(2)

pder=fltarr(sizx,sizy,6)

j=0
if not keyword_set(accuracy) then $
	accuracy = 1e-4

xar=findgen(sizx)#replicate(1.,sizy) ; array of x values
yar=replicate(1.,sizx)#findgen(sizy) ; same for y


r=dblarr(6)
act=r#r
chisq=1e11
count = 0

if keyword_set(log) then begin
; message,'doing log',/inform
coef[0]=alog(coef[0])
coef[2]=alog(coef[2])
coef[4]=alog(coef[4])
end

repeat begin

if keyword_set(log) then begin
 c0=exp(coef(0))
 c2=exp(coef(2))
 c4=exp(coef(4))
end else begin
 c0=coef(0)
 c2=coef(2)
 c4=coef(4)
end

 chi_old = chisq

 zx = (xar-coef(1))/c2
 zy = (yar-coef(3))/c4
 ez = exp(-zx^2/2-zy^2/2) 
 modim=c0*ez+coef(5) 

 difim=image-modim
 chisq=total(difim^2)/float(sizx)/float(sizy) 

;  ##### Compute the partial derivatives

if keyword_set(log) then begin
 pder(*,*,0) = c0*ez
 pder(*,*,1) = c0*ez*zx/c2
 pder(*,*,2) = c0*ez*zx^2
 pder(*,*,3) = c0*ez*zy/c4
 pder(*,*,4) = c0*ez*zy^2
 pder(*,*,5) = 1.
end else begin
 pder(*,*,0) = ez
 pder(*,*,1) = c0*ez*zx/c2
 pder(*,*,2) = c0*ez*zx^2/c2
 pder(*,*,3) = c0*ez*zy/c4
 pder(*,*,4) = c0*ez*zy^2/c4
 pder(*,*,5) = 1.

end


 for k=0,5 do begin
	r(k)=total((difim) * pder(*,*,k))
  	for l=0,5 do begin
		act(l,k)=double(total(pder(*,*,k)*pder(*,*,l)))
	endfor
endfor
; nr_svd,act,w,u,v,/double
 svdc,act,w,u,v,/double

; stop

 idx=where(w/max(w) lt 1e-10,cnt)
 if cnt NE 0 then w[idx]=0


 dcoef=svsol(u,w,v,r,/double)

; dcoef=nr_svbksb(u,w,v,r)

;  ##### Make new image and check if it fits better than the old one

 coef=coef+dcoef
 count = count + 1
endrep until abs(chisq - chi_old)/abs(chisq) lt accuracy or count ge 30
if count ge 30 then $
	message,'Iteration failed to converge - result is inconclusive!',/inform

; print,w,count,chisq,rr

;  ##### Now compute the errors

   errcoef=nr_svbksb(u,w,v,replicate(double(1.),6))
   errcoef=sqrt(abs(chisq*errcoef)) 

;  ##### Make the results available to the scientist

if keyword_set(log) then begin
coef(0)=exp(coef(0))
coef(2)=exp(coef(2))
coef(4)=exp(coef(4))
errcoef(0)=coef(0)*errcoef(0)
errcoef(2)=coef(2)*errcoef(2)
errcoef(4)=coef(4)*errcoef(4)
end 

coef[0]=coef[0]*rr
errcoef[0]=errcoef[0]*rr
coef[5]=coef[5]*rr
errcoef[5]=errcoef[5]*rr


image=saveimage

   if keyword_set(print) then begin
	print,''
	print,format='("Maximum Position (x,y):  ",f6.2," ",f6.2)',coef(1),coef(3)
	print,format='("Error of Position (x,y): ",f6.2," ",f6.2)',errcoef(1),errcoef(3)
	print,''
	print,format='("Stdev (x,y):              ",f6.2," ",f6.2)',coef(2),coef(4)
	print,format='("Error of Stdev:           ",f6.2," ",f6.2)',errcoef(2),errcoef(4)
	print,''
	print,format='("Peak Flux:               ",f6.2)',coef(0)
	print,format='("Error of Peak Flux:      ",f6.2)',errcoef(0)
   endif
end

