
#set term postscript eps color
set term png size 1200, 800

set xlabel 'xlabel'

set ylabel 'ylabel'

#set output 'img.eps'
set output 'img.png'

splot '0.499' with lines, '0.5' with lines, '0.501' with lines, '0.549' with lines, '0.55' with lines, '0.551' with lines, '0.599' with lines, '0.6' with lines                                             

exit

