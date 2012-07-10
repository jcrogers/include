function rednoisetest, yy, maxbs=maxbs, fitln=fitln, usemean=usemean, $
                       plt=plt, outf=outf, xlog=xlog, ylog=ylog, $
                       verbose=verbose, stp=stp

;Syntax IDL> result ( [white, red] ) = 
; rednoisetest(yy,maxbs=30,outf='test.ps',/usemean,/verbose,/stp)
np = n_elements(yy)
if n_elements(maxbs) eq 0 then maxbs = long(2*sqrt(np))
if not keyword_set(usemean) then usemean=0
if n_elements(outf) eq 0 then outf='rntest.ps'
if n_elements(xlog) eq 0 then xlog=0
if n_elements(ylog) eq 0 then ylog=0
;X-range
xr=[0,maxbs]
if keyword_set(xlog) then xr=[1,maxbs]

n = 1+dindgen(maxbs)       ;N
sig_n = dblarr(maxbs)  ;Sigma_N

for bsi = 0, maxbs-1 do sig_n[bsi]=binrms(yy,bs=bsi+1,usemean=usemean)

;stop

;Find the best-fit parameters SIGW and SIGR such that:
; sig^2 = sigw^2 / N + sigr^2

ss = sig_n^2     ;Sigma_n squared
nbs = n_elements(n)

;Guess grids (test values)
;sigma_w: 0-200% of sig_n[0]
  swres = 80   ;sigma_w resolution
  sigwg = (dindgen(2*swres+1)/swres) * sig_n[0]
;sigma_r: 0-200% of sig_n[max N]
  srres = 80   ;sigma_r resolution
  sigrg = (dindgen(2*srres+1)/srres) * sig_n[nbs-1]

;Guess cube: layer[0]=wnoise, [1]=rnoise, [2]=chisq, [3]=chisq in ln space
gcube = dblarr(n_elements(sigwg),n_elements(sigrg),4)

;New: use the equation N*Sig_n^2 = Sig_w^2 + Sig_r^2 * N
;For the Chi^2, fit model (Nsign2) to actual
nsns = n*sig_n^2
lognsns = alog(nsns)

for wgi=0,n_elements(sigwg)-1 do begin
  for rgi=0,n_elements(sigrg)-1 do begin
    gcube[wgi,rgi,0]=sigwg[wgi]
    gcube[wgi,rgi,1]=sigrg[rgi]
    nsnsc = sigwg[wgi]^2 + n * sigrg[rgi]^2
    resid = nsns - nsnsc
;    sncalc = sqrt( (sigwg[wgi]^2 / n) + sigrg[rgi]^2 )  ;calc sig_n
;    resid = sig_n - sncalc
    gcube[wgi,rgi,2]=total(resid^2)
    lnres = lognsns - alog(nsnsc)
    gcube[wgi,rgi,3]=total(lnres^2)
 endfor
endfor

if keyword_set(stp) then stop

if keyword_set(fitln) then csq = gcube[*,*,3] else $
   csq = gcube[*,*,2]
best=where(csq eq min(csq))

wns=gcube[*,*,0]
rns=gcube[*,*,1]

bsigw = wns[best[0]]
bsigr = rns[best[0]]
nsm = bsigw^2/n + bsigr^2     ;sig_N^2 model
nssm = bsigw^2 + bsigr^2 * n  ;n sig_n^2 model

if keyword_set(verbose) then begin
  print, 'Tested Sig_w range ', minmax(sigwg)
  print, 'Tested Sig_r range ', minmax(sigrg)
  print, 'Best fits:'
  print, 'White Noise: ', bsigw
  print, 'Red Noise:   ', bsigr
endif

if keyword_set(stp) then stop

if keyword_set(plt) then begin
  psopen, outf
  !p.multi=[0,2,2]
;  for ylogi=0,1 do begin
;Plot 1 - time series
  medi=median(yy,/even)
  plot, yy-medi, /nodata, thick=3, charsize=1., charthick=2, $
        ytitle='Value-Median', title='Series to Bin', $
        yrange=(max(yy)-min(yy))*[-0.6,1], /ystyle
  oplot, yy-medi, psym=6, symsize=0.3, thick=2, color=21
  oplot, [0,np], [0,0], color=0,thick=3
  oplot, [0,np], bsigw+[0,0], color=4, linestyle=2,thick=3
  oplot, [0,np], -bsigw+[0,0], color=4, linestyle=2,thick=3
  oplot, [0,np], bsigr+[0,0], linestyle=2, color=2,thick=3
  oplot, [0,np], -bsigr+[0,0], linestyle=2, color=2,thick=3
  legend, textoidl(['\sigma_w','\sigma_r']),thick=3, $
          linestyle=[2,2], color=[4,2],charsize=0.9, /top,/right

;Plot 2 - sigma_N vs. calc
    plot, n, sig_n, /nodata, xlog=xlog,ylog=ylog, xrange=xr,/xstyle,$
          thick=3, charsize=1., charthick=2, $
          xtitle='Bin size N', ytitle=textoidl('\sigma_N'), $
          title=''
    oplot, n, sig_n, psym=6, thick=2, symsize=0.3, color=21
    oplot, xr, [bsigw,bsigw], thick=3, linestyle=2, color=4
    oplot, n, bsigw/sqrt(n), thick=3, color=4
    oplot, xr, [bsigr,bsigr], thick=3, linestyle=2, color=2
    oplot, n, sqrt( bsigr^2 + bsigw^2/n ), $
           thick=3, linestyle=3, color=13
    legend, textoidl(['\sigma_w', '\sigma_r', '\sigma_w N^{-1/2}', $
             '\sigma_N Calc']), thick=3, charsize=0.9, $
            linestyle=[2,2,0,3], color=[4,2,4,13], /top, /right
;Plot 3 - sigma_N^2
    plot, n, ss, /nodata, xlog=xlog,ylog=ylog, xrange=xr,/xstyle, $
          thick=3, charsize=1., charthick=2, $
          xtitle='Bin Size N', ytitle=textoidl('\sigma_n^2')
    oplot, n, ss, psym=6, thick=2, symsize=0.3, color=21
    oplot, n, bsigw^2/n, thick=3, linestyle=2, color=4
    oplot, xr, bsigr^2+[0,0], thick=3, linestyle=2, color=2
    oplot, n, nsm, thick=3, linestyle=3, color=13
;Plot 4 - N*sigma_N^2
    plot, n, ss*n, /nodata, xlog=xlog,ylog=ylog, xrange=xr,/xstyle, $
          thick=3, charsize=1., charthick=2, $
          xtitle='Bin Size N', ytitle=textoidl('N \sigma_n^2')
    oplot, n, ss*n, psym=6, thick=2, symsize=0.3, color=21
    oplot, n, nssm, thick=3, linestyle=2, color=13
    legend, /bottom, /right, thick=3, linestyle=[0,2], psym=[6,0], color=[0,13], $
            [textoidl('N \sigma_n^2 (calc)'), textoidl('N \sigma_n^2 (best-fit)')]
  psclose
endif

if keyword_set(stp) then stop

return, [bsigw,bsigr]
end
