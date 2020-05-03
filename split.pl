#! /usr/bin/perl
use strict;
use warnings;

binmode(STDOUT);

my @fn;
my $fndef = 'x' x 30;

if ($#ARGV != 1){
    print STDERR "perl split.pl (data.base) (outdir)\n";
    exit;
}

my ($database, $outdir) = @ARGV;
{
    my $f = 0;
    my $fn = $fndef;
    my $c = '';

    open my $fr, '<', $database or die;
    while(<$fr>){
        my $t = substr($_, 0, 1);
#        if($t eq "\n"){
#        if($t eq "\n" || $t eq '#'){
#            next;
#        }

        if($f == 1){
            if($t eq "\t" || $t eq "\n" || $t eq '#'){
                $c .= $_;
                next;
            }
            {
                $f = 0;
                open my $fw, '>', $outdir . '/' . $fn or die $!;
                print $fw $c;
                close $fw;
                $c = '';
                $fn = $fndef;
            }
        }

        $c .= $_;

        if($t eq "\t"){
            chomp $fn;
            printf "data/%s\n", $fn;
            $f = 1;
            next;
        } else {
            if($t eq '' || $t eq '~'){
                next;
            }
            s/[.?* ]//g;
            s/[^-A-Za-z]//g;
            if($_ ne '' and length $fn > length $_){
                $fn = $_;
            }
        }
    }
    close $fr;
    {
        open my $fw, '>', $outdir . '/' . $fn or die;
        print $fw $c;
        close $fw;
    }
}
