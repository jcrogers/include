pro skyline,origline,skyv,rms,verbose=verbose,plot=plot1,gaussfit=gaussfit1


  if (n_elements(verbose) eq 0) then verbose=0
  if (n_elements(plot1) eq 0) then plot1=0
  if (n_elements(gaussfit1) eq 0) then gaussfit1=0


  tmp=where((origline ne 0) and (origline ne -999))
  if (tmp(0) eq -1) then begin
    print,"[SKYLINE]: Warning: piece of sky is all 0.00's!"
    skyv=0.0 & rms=1.0
    return
    endif

  line=origline
  if (min(line) eq 0) then begin
    tmp1=where(origline ne 0)
    if (n_elements(tmp1) gt 1) then line=origline(tmp1)
    if (verbose eq 1) then $
      print,'[SKYLINE] Warning: Excluding values of 0.00 from calculation'
    endif

  tmp=where(line eq -999)
  if (tmp(0) ne -999) then begin
    line=line(where(line ne -999))
    if (verbose eq 1) then $
      print,'[SKYLINE] Warning: Excluding values of -999 from calculation'
    endif


  nels=n_elements(line)
  av1=median(line)
  rms1=stdev(line)
  if (verbose eq 1) then $
    print,'[SKYLINE] Start with:  MED=',strn(av1),',RMS=',strn(rms1)


  iters=0 & badvals=999
  while (badvals gt 0) do begin
    tmp=where(line lt av1+4*rms1)
    if (tmp(0) ne -1) then line2=line(tmp) else line2=line
    av1=median(line2)
    rms1=stdev(line2)
    if (verbose eq 1) then $
      print,'[SKYLINE] Iteration '+strn(iters)+': MED=',strn(av1),',RMS=',strn(rms1)
    if (plot1 eq 1) then begin
      if (iters le 2) then begin
        minv=fix(min(line)) & maxv=fix(max(line)+1)
        xax=indgen(maxv-minv+1)+minv
        his=histogram(line,min=minv,max=maxv,binsize=1)
        plot,xax,his,psym=10
        plots,[0,0]+av1(0)+4*rms1(0),[0,1]*!cymax
        endif
      plots,[0,0]+av1(0)+4*rms1(0),[0,1]*!cymax
      wait,0.5
      endif


    badvals=n_elements(line)-n_elements(line2)
    line=line2
    iters=iters+1
    endwhile


  tmp=where((line lt av1+3*rms1) and (line gt av1-5*rms1))
  chk=size(tmp)
  if (chk(0) eq 0) then goto,DONE

  line=line(tmp)
  av1=avg(line)
  rms1=stdev(line)
  if (verbose eq 1) then $
    print,'[SKYLINE] Final Cut:   AVG=',strn(av1),',RMS=',strn(rms1)
  if (plot1 eq 1) then begin
    minv=fix(min(line)) & maxv=fix(max(line)+1)
    xax=indgen(maxv-minv+1)+minv
    his=histogram(line,min=minv,max=maxv,binsize=1)
    plot,xax,his,psym=10
    plots,[0,0]+av1,[0,1]*!cymax,linesty=2
    plots,[0,0]+av1-5*rms1,[0,1]*!cymax
    plots,[0,0]+av1+3*rms1,[0,1]*!cymax
    endif


  if (gaussfit1 ne 0) then begin
    minv=fix(min(line)) & maxv=fix(max(line)+1)
    xax=indgen(maxv-minv+1)+minv
    his=histogram(line,min=minv,max=maxv,binsize=1)
    yfit=gaussfit(xax,his,coeff)
    if (plot1 eq 1) then oplot,xax,yfit
    av2=float(coeff(1)) & rms2=float(coeff(2))
    print,'[SKYLINE] Gauss Fit:   CEN=',strn(av2),',FWH=',strn(rms2)
    print,'[SKYLINE] Avg-Fit:     CEN=',strn(av1-av2),',FWH=',strn(rms1-rms2)
    av1=av2+gaussfit1 & rms1=rms2i
    print,'[SKYLINE] Final Value: AVG=',strn(av1),',RMS=',strn(rms1)
    endif


DONE:
  skyv=av1 & rms=rms1

  return
end
