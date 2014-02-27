input_file1=$1
input_file2=$2
input_file3=$3
input_file4=$4
input_file5=$5
input_file6=$6
output_file=$7
using_columns=$8 # for example "1:2"
x_label=$9
y_label=$10


gnuplot <<EOF
set size 1.0, 0.7
set size square
set terminal postscript color portrait lw 3 "Helvetica" 14 
set key below box
#set nokey
set output "$output_file"
#set xrange [ -11.00 : 1.00 ]
#set yrange [ -11.00 : 1.00 ]
set xlabel "$x_label"
set ylabel "$y_label"
plot "$input_file1" using $using_columns with points pointtype 1 title "Expression < 10% quantile", "$input_file2" using $using_columns with points pointtype 1 title "Expression < 20% quantile", "$input_file3" using $using_columns with points pointtype 1 title "Expression < 30% quantile", "$input_file4" using $using_columns with points pointtype 1 title "Expression < 40% quantile", "$input_file5" using $using_columns with points pointtype 1 title "Expression < 50% quantile", "$input_file6" using $using_columns with points pointtype 1 title "The rest"
exit
EOF
