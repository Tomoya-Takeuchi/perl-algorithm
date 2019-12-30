#!/usr/bin/perl -w

use strict;
use warnings;

binmode STDIN, ':encoding(cp932)';
binmode STDOUT, ':encoding(cp932)';
binmode STDERR, ':encoding(cp932)';

print "1 to 100\n";

print "3\n";
my $a = <STDIN>;
chomp($a);

print "5\n";
my $b = <STDIN>;
chomp($b);

print "7\n";
my $c = <STDIN>;
chomp($c);

my $x = (70 * $a + 21 * $b + 15 * $c) % 105;
print "$x";