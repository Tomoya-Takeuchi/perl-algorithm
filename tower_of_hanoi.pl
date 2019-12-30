#!/usr/bin/perl -w

use strict;
use warnings;

binmode STDIN, ':encoding(cp932)';
binmode STDOUT, ':encoding(cp932)';
binmode STDERR, ':encoding(cp932)';

sub movedisk {

    my ($disk_ammount, $a, $b) = @_;

    if ($disk_ammount > 1) {
    	my $movedisk = movedisk($disk_ammount - 1, $a, 6 - $a - $b);
    }

    if ($disk_ammount > 1) {
    	my $movedisk = movedisk($disk_ammount - 1, 6 - $a - $b, $b);
    }

}

my $a = 1;
my $b = 2;

print "円盤の枚数\n";
my $disk_ammount = <STDIN>;
chomp($disk_ammount);

my $movedisk = movedisk($disk_ammount, $a, $b);