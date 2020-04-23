#! /usr/bin/perl
use strict;
use warnings;

binmode(STDOUT);

my @fn;

if ($#ARGV != 1){
    print STDERR "perl join.pl (dblist) (outfn)\n";
    exit;
}

my ($dblist, $outfn) = @ARGV;
{
    open my $f, '<', $dblist or die;
    while(<$f>){
        chomp;
        push @fn, $_;
    }
    close $f;
}

{
    open my $fo, '>', $outfn or die;
    for(@fn){
        open my $f, '<', $_ or die;
        while(<$f>){
            my $t = substr($_, 0, 1);
            if($t ne '%'){
                print $fo $_;
            }
        }
        close $f;
    }
    close $fo;
}
