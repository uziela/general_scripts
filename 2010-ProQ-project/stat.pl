#!/usr/bin/perl -w


sub sign{

    my $a=shift;
    if($a>0) {
    return 1;
    } else {
    return -1;
    }
    
}

sub correlation_significance_two
{
    my ($ra,$na,$rb,$nb)=@_;
    my $raplus = 1*$ra+1;
    my $raminus = 1-$ra;
    my $rbplus = 1*$rb+1;
    my $rbminus = 1-$rb;
    my $za = (log($raplus)-log($raminus))/2;
    my $zb = (log($rbplus)-log($rbminus))/2;
    my $se = sqrt((1/($na-3))+(1/($nb-3)));
    my $z = ($za-$zb)/$se;
#    my $z = round(z*100)/100;

    my $z2 = abs($z);
    
    my $p2 =(((((.000005383*$z2+.0000488906)*$z2+.0000380036)*$z2+.0032776263)*$z2+.0211410061)*$z2+.049867347)*$z2+1;
    $p2 = $p2**(-16);
    my $p1 = $p2/2;
    
    return($p1,$p2,$z2);

}

sub rmse_S2d #Max deviation predicted is 5 angstroms
{
   my ($x,$y)=@_;
   my @x=@{$x};
   my @y=@{$y};
   my $n=0;
   my $total=0;
   my $c0=0.5;
   for (my $i = 0; $i < @x; $i++){

       
       $x[$i]=1 if($x[$i]>1);
       $y[$i]=1 if($y[$i]>1);
       $rms_x=5;
       $rms_y=5;

       $cutoff=1/(1+$rms_y*$rms_y/9);
       if($x[$i]>$cutoff) {
                        #print $S."\n";
       $rms_x=3*sqrt(1/$x[$i]-1)
           
       }
       if($y[$i]>$cutoff) {
                        #print $S."\n";
       $rms_y=3*sqrt(1/$y[$i]-1)
           
       }
 #      print "$rms_y $rms_x\n";
       my $Diff = $rms_x - $rms_y;
#       my $Diff = $x[$i]-$y[$i];

       
#       $total += 1/(1+($Diff*$Diff)/($c0*$c0));
       $total += $Diff*$Diff; #1/(1+($Diff*$Diff)/($c0*$c0));
       $n++;
  }
   my $rmse=sqrt($total/$n);
#       my $rmse=$total/$n;
 #  print "RMSE: $rmse\n";
#   printf ("RMSE %f ($i %d)\n", sqrt(total/(double)$i),$i);
   return $rmse;
}

sub rmse
{
   my ($x,$y)=@_;
   my @x=@{$x};
   my @y=@{$y};
   my $n=0;
   my $total=0;
   #print "Hej\n";
   for (my $i = 0; $i < @x; $i++){

       #       my $Diff = $rms_x - $rms_y;
       my $Diff = $x[$i]-$y[$i];
#       $total += 1/(1+($Diff*$Diff)/($c0*$c0));
       $total += $Diff*$Diff; #1/(1+($Diff*$Diff)/($c0*$c0));
       $n++;
  }
   my $rmse=sqrt($total/$n);
#       my $rmse=$total/$n;
#   printf ("RMSE %f ($i %d)\n", total/(double)$i,$i);
#   printf ("RMSE %f ($i %d)\n", sqrt(total/(double)$i),$i);
   return $rmse;
}


sub dist
{
    my ($x,$y,$z)=@_;
    return sqrt($x*$x+$y*$y+$z*$z);
}
sub spearman_corrcoef
{
    my ($x,$y)=@_;
    my @x=@{$x};
    my @y=@{$y};
    my @x_r=ranks(@x);
    my @y_r=ranks(@y);
    my $corr=corrcoef([@x_r],[@y_r]);
}
sub ranks
{
    my @x=@_;
    my @ranks=();
   
    for(my $i=0;$i<=$#x;$i++) {
#   $rank++; # if($i>0 && $x_s[$i] != $x_s[$i-1]);

#   print "$x[$i]\n";
    $x[$i].=" $i";
#   print "$x[$i]\n";
    $ranks[$i]=0;
    }
    my @x_s=sort numerically_str(@x);
#    my @x_s=sort numerically(@x);
    my $rank=0;
    my $last=999;
    my @ranks_val=();
    my @tmp_rank=();
    my @index_rank=();
    %def=();
    foreach $line(@x_s) {
#   print $line."\n";
    my @temp=split(/\s+/,$line);
    my $i=$temp[$#temp];
    my $val=$temp[0];
    $rank++;
    #print "$temp[0] $x[$i]\n";
    #print "$val $last $i\n";
#   $def{$i}=$rank;
    


    if($val != $last) {
        if(scalar(@tmp_rank)>0) {
        my $mean_rank=mean(@tmp_rank);
        for(my $j=0;$j<=$#index_rank;$j++) {
            $ranks[$index_rank[$j]]=$mean_rank;
            
        #    print "* $index_rank[$j] $mean_rank\n";
        }
        }
        @tmp_rank=();
        @index_rank=();
    }
    push(@tmp_rank,$rank);
    push(@index_rank,$i);
    $last=$val;
#   print "$temp[$#temp]\n";
    #push(@ranks,$temp[$#temp]);
    }
    

    if(scalar(@tmp_rank)>0) {
    my $mean_rank=mean(@tmp_rank);
    for(my $j=0;$j<=$#index_rank;$j++) {
        $ranks[$index_rank[$j]]=$mean_rank;
    }
    }

#    for(my $i=0;$i<=$#x;$i++) {
##  if(not(defined($def{$i}))) 
#   {
#       print "$ranks[$i] $x[$i] $def{$i}\n";
#   }
#    }
#    foreach $r(@ranks) {
#   print $r."\n";
#    }
    #exit;

    return(@ranks);
}
sub corrcoef
{
    my ($x,$y)=@_;
    my @x=@{$x};
    my @y=@{$y};
    my $xm=mean(@x);
    my $ym=mean(@y);
    if(scalar @y == 0)
    {
    warn "You need to use bracket (\[\]) for both array arguments!\n";
    }
    my $cov=0;
    my $corr=0;
    my $elements=scalar(@x);
    for(my $i=0;$i<scalar @x;$i++)
    {
#   print "$x[$i] $y[$i]\n";
    $cov+=($x[$i]-$xm)*($y[$i]-$ym)
    }
    $cov=$cov/($elements-1);
    $std_x=std(@x);
    $std_y=std(@y);
    $corr=0;
    if($std_x*$std_y != 0)
    {
    $corr=$cov/($std_x*$std_y);
    }
    if($std_x == 0 &&
       $std_y == 0) {
    $corr=1;
    }


    return $corr;
}

sub median
{
    my @data_s=sort numerically(@_);
    my $n=scalar @data_s;
    my $m=int($n/2);
    return $data_s[$m];
}

sub std
{
    my @data=@_;
    my $mean=mean(@data);
    my $n=scalar @data;
    if($n!=1)
    {
    my $sum=0;
    foreach my $term(@data)
    {
        $sum+=($term-$mean)*($term-$mean);
    }
    return sqrt(1/($n-1)*$sum);
    }
    else
    {
    return 0;
    }
}


sub mean
{
    my @data=@_;
    my $sum=0;
    my $number_of_elements=scalar @data;
    foreach my $term(@data)
    {
    $sum+=$term;
    }
    if($number_of_elements==0)
    {
    return 0;
    }
    else
    {
    return $sum/$number_of_elements;
    }
}
sub error
{
    my @data=@_;
    my $mean=mean(@data);
    my $n=scalar @data;
    if($n!=1)
    {
    my $sum=0;
    foreach my $term(@data)
    {
        $sum+=($term-$mean)*($term-$mean);
    }
    return 1.960*(sqrt(1/($n*($n-1))*$sum));
    }
    else
    {
    return 0;
    }
}


sub numerically
{
    $b<=>$a;
}

sub numerically_inc
{
    $a<=>$b
}


sub numerically_str
{
    my @temp_a=split(/\s+/,$a);
    my @temp_b=split(/\s+/,$b);
    $temp_b[0]<=>$temp_a[0];
}

sub sum
{
    my @vec=@_;
    my $sum=0;
    foreach my $term(@vec)
    {
    #print $term,"\n";
    $sum+=$term;
    }
    return $sum;
}

sub max
{
    my @vec=@_;
    my $max=$vec[0];
    foreach my $term(@vec)
    {
    if($term>$max)
    {
        $max=$term;
    }
#   print $term,"\n";
    }
    return $max;
}
sub min
{
    my @vec=@_;
    my $min=$vec[0];
    foreach my $term(@vec)
    {
    if($term<$min)
    {
        $min=$term;
    }
    #print $term,"\n";
    }
    return $min;
}
sub mcc {
    my ($dummyA, $dummyB,$correct_cutoff,$pred_cutoff) = @_; # ---> Get input
    
    my @A = @{$dummyA};
    my @B = @{$dummyB};
    
    # ---> DEBUG <---
    # print STDERR "@B\n";
    
    my $tp = 0;
    my $fp = 0;
    my $fn = 0;
    my $tn = 0;
    
    for (my $i = 0; $i < @A; $i++) {
    # ---> DEBUG <---
    # print STDERR $A[$i]." ".$B[$i]."\n";
    
    if ($A[$i] > $pred_cutoff ) {
        if ($B[$i] > $correct_cutoff) {
        $tp++ ;
        }
        else {
        $fp++ ;
        }       
    }
    
    else {
        if ($B[$i] > $correct_cutoff) {
        $fn++ ;
        }
        else {
        $tn++ ;
        }
    }
    } # ---> FOR LOOP ENDS
    
    my $nom = ($tp*$tn)-($fp*$fn);
    my $denom = sqrt(($tp+$fn)*($tp+$fp)*($tn+$fp)*($tn+$fn));
    #print "$pred_cutoff $correct_cutoff $denom $tp, $fp, $tn, $fn \n";
    my $result = $nom/$denom;

    return $result; #, $tp, $fp, $tn, $fn);
} # ---> SUB ENDS



sub histogram
{
    my ($ranges,$x,$frac)=@_;
    my @ranges=@{$ranges};
    my @x=@{$x};
    my @hist=();
    my @middle_points=();
   # print scalar @ranges," ",scalar @x," ",scalar @{$x[0]},"\n";;
    if(scalar @ranges == 1)
    {
    print STDERR "\@ranges only contain 1 element!\n";
    return 0;
    } 
   # print @{$x[0]},"\n";

   
    #print scalar @x."\n";
 #   exit;
    for(my $i=0;$i<scalar @ranges-1;$i++)
    {
    #my @temp=();
#   push(@temp,0);
    #if(scalar @x>0)
#   {
    for(my $j=0;$j<scalar @x;$j++)
    {
    #    push(@temp,0);
    
#   }
    #push(@hist,\@temp);
        ${$hist[$i]}[$j]=0
    }
#   
    }
    
    for(my $i=0;$i<scalar @ranges - 1;$i++)
    {
    push(@middle_points,($ranges[$i]+$ranges[$i+1])/2);
    #print scalar @x,"\n===\n";
    for(my $j=0;$j<scalar @x;$j++)
    {
       # print scalar @{$x[$j]},"\n";
        #if(defined(@{$x[$j]}))
        {
        for(my $k=0;$k<scalar @{$x[$j]};$k++)
        {
            ${$hist[$i]}[$j]++ if(${$x[$j]}[$k]>=$ranges[$i] && ${$x[$j]}[$k]<$ranges[$i+1]);
            
            #print "${$x[$j]}[$k] $ranges[$i+1] i=$i j=$j k=$k\n";# if(not(defined($ranges[$i+1])));
        }
        }
        #print "\n" if($j==0);
    }
    #exit;
    }
    if(defined($frac) && $frac==1)
    {
    $len=scalar @x;
    #print $len,"\n";
    for(my $i=0;$i<scalar @ranges-1;$i++)
    {
        my @temp=();
        #printf("%6.2f ",$middle_points[$i]);
        for(my $j=0;$j<scalar @x;$j++)
        {
        #printf("before %4d ",${$hist[$i]}[$j]);
        ${$hist[$i]}[$j]/=scalar(@{$x[$j]});
    #   printf("after %4d ",${$hist[$i]}[$j]/$len);
        }
     #   print "\n";
    }
    # $len=scalar @x;
    }


    return([@middle_points],[@hist]);

}


1;
