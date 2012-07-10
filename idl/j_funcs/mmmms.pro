function mmmms, array
  
;prints out the minimum, maximum, mean, median, and standard deviation
;of the values in an array

print, 'Number of elements: ', strtrim(n_elements(array),2)
print, 'Minimum value: ', strtrim(min(array),2)
print, 'Maximum value: ', strtrim(max(array),2)
print, 'Mean: ', strtrim(mean(array),2)
print, 'Median: ', strtrim(median(array, /even),2)
print, 'Std. Dev: ', strtrim(stdev(array),2)

return, array
end
