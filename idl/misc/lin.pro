function lin, x, p
;p is a 2-element array [intercept, slope]
 ymod = p[0] + p[1]*x
return, ymod
end
