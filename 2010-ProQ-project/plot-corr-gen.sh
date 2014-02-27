input_file=$1
output_file=$2
using_columns=$3 # for example "1:2"
x_label=$4
y_label=$5


gnuplot <<EOF
set size 1.0, 0.7
set size square
set terminal postscript portrait lw 3 "Helvetica" 14 
#set key below box
set nokey
set output "$output_file"
#set xrange [ -11.00 : 1.00 ]
#set yrange [ -11.00 : 1.00 ]
set xlabel "$x_label"
set ylabel "$y_label"
plot "$input_file" using $using_columns with dots
exit
EOF
