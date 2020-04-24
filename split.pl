#! /usr/bin/perl
use strict;
use warnings;

binmode(STDOUT);

my @fn;

if ($#ARGV != 0){
    print STDERR "perl split.pl (data.base)\n";
    exit;
}

my ($database) = @ARGV;
{
    my $f = 0;
    my $fn = 'x' x 100;
    my $c = '';

    open my $fr, '<', $database or die;
    while(<$fr>){
        my $t = substr($_, 0, 1);
        if($t eq "\n" || $t eq '#'){
            next;
        }

        if($f == 1){
            if($t eq "\t"){
                $c .= $_;
                next;
            }
            {
                $f = 0;
                open my $fw, '>', 'orig/' . $fn or die $!;
                print $fw $c;
                close $fw;
                $c = '';
                $fn = 'x' x 100;
            }
        }

        $c .= $_;

        if($t eq "\t"){
            chomp $fn;
            printf "data/%s\n", $fn;
            $f = 1;
            next;
        } else {
            if($t eq '~'){
                next;
            }
            s/[?* ]//g;
            if(length $fn > length $_){
                $fn = $_;
            }
        }
    }
    close $fr;
    {
        open my $fw, '>', 'orig/' . $fn or die;
        print $fw $c;
        close $fw;
        $c = '';
    }
}
