FUNCTION frat2mmag, fratio

mmag = 2500 * (alog10(1+fratio))

return, mmag

END
