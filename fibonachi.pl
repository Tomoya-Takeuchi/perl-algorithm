use strict;
use warnings;

sub fibo {
    my($n) = $_[0];

    return 0 if ($n == 1);
    return 1 if ($n == 2);
    return &fibo($n-1) + &fibo($n-2);
}

for (my($i)=1; $i<31; $i++) {
    print(&fibo($i)."\n");
}
