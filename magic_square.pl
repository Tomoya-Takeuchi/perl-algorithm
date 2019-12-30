#!/usr/bin/perl -w

use utf8;
use strict;
use warnings;

my $order = 3;
my $size = $order**2;

my $start = 1;
my $max = 9;

use constant HORIZONTAL => 0;
use constant VERTICAL => 1;

my @position_fill_order;

my @rows;
my @collums;
my @diagonals;

my %positions_in_checks;

my %checks_by_position;

sub define_best_fill_order {

	my $stage = HORIZONTAL;
	my $position = 1;
	my $cycle = 1;
	my $last_position_to_fill = $order ** 2 - $order + 1;
	
	while (1) {
		
		if ($position == $last_position_to_fill) {
			push(@position_fill_order, $position);
			last;
		}
		
		my $end_of_stage_position;
		my $increment_by_position;
		my $start_of_next_stage_position;
		if ($stage == HORIZONTAL) {
			$end_of_stage_position = $order * $cycle - $cycle + 1;
			$increment_by_position = 1;
			$start_of_next_stage_position = $end_of_stage_position + $order;
			$stage = VERTICAL;
			
		} else {
			$end_of_stage_position = $order ** 2 - $cycle + 1;
			$increment_by_position = $order;
			$start_of_next_stage_position = 1 + $order * ($cycle);
			$stage = HORIZONTAL;
			$cycle++;
		}
		
		while (1) {
			push(@position_fill_order, $position);
			if ($position != $end_of_stage_position) {
				$position += $increment_by_position;
			} else {
				last;
			}
		}
		$position = $start_of_next_stage_position;
	}
}

sub define_positions_to_check_sum {
	my ($start, $end, $increment);
	
	foreach my $current_order (1..$order) {
		
		#Horizontal
		$start = 1 + $order * ($current_order - 1);
		$end = $order * ($current_order);
		$increment = 1;
		
		$rows[$current_order] = get_pos_array($start, $end, $increment);
		
		#Vertical
		$start = $current_order;
		$end = $order ** 2 - $order + $current_order;
		$increment = $order;
		
		$collums[$current_order] = get_pos_array($start, $end, $increment);
		
	}
	
	#Right Diagonal
	$start = 1;
	$end = $order ** 2;
	$increment = $order + 1;

	$diagonals[1] = get_pos_array($start, $end, $increment);
	
	#Left Diagonal
	$start = $order;
	$end = $order ** 2 - $order + 1;
	$increment = $order - 1;

	$diagonals[2] = get_pos_array($start, $end, $increment);
}

sub get_pos_array {
	my ($start, $end, $increment) = @_;
	my @pos;
	while (1) {
		push(@pos, $start);
		if ($start != $end) {
			$start += $increment;
		} else {
			last;
		}
	}
	return \@pos;
}

sub define_positions_in_sums {
	foreach my $current_order (1..$order) {
		foreach my $pos (@{$rows[$current_order]}) {
			$positions_in_checks{$pos}{'row'} = $current_order;
		}
		
		foreach my $pos (@{$collums[$current_order]}) {
			$positions_in_checks{$pos}{'collum'} = $current_order;
		}
	}
		
	foreach my $pos (@{$diagonals[1]}) {
		$positions_in_checks{$pos}{'diagonals_right'} = 1;
	}
		
	foreach my $pos (@{$diagonals[2]}) {
		$positions_in_checks{$pos}{'diagonals_left'} = 1;
	}
}

sub define_checks_on_positions {
	my %sums;
	foreach my $pos (@position_fill_order) {
		
		#Rows
		$sums{'row'}{$positions_in_checks{$pos}{'row'}}++;
		if ($sums{'row'}{$positions_in_checks{$pos}{'row'}} == $order) {
			push(@{$checks_by_position{$pos}}, $rows[$positions_in_checks{$pos}{'row'}]);
		}
		
		#Collums
		$sums{'collum'}{$positions_in_checks{$pos}{'collum'}}++;
		if ($sums{'collum'}{$positions_in_checks{$pos}{'collum'}} == $order) {
			push(@{$checks_by_position{$pos}}, $collums[$positions_in_checks{$pos}{'collum'}]);
		}
		
		#Right diagonal
		if (exists $positions_in_checks{$pos}{'diagonals_right'}) {
			$sums{'diagonals_right'}++;
			if ($sums{'diagonals_right'} == $order) {
				push(@{$checks_by_position{$pos}}, $diagonals[1]);
			}
		}
		
		#Left diagonal
		if (exists $positions_in_checks{$pos}{'diagonals_left'}) {
			$sums{'diagonals_left'}++;
			if ($sums{'diagonals_left'} == $order) {
				push(@{$checks_by_position{$pos}}, $diagonals[2]);
			}
		}
		
	}
}

define_best_fill_order();

define_positions_to_check_sum();

define_positions_in_sums();

define_checks_on_positions();

#Messages

print "Doing a $order x $order matrix !\n";

print "The best order to fill is: ".join(' -> ',@position_fill_order)." !\n";

foreach (1..$order) {
	print "The ".$_."rd row positions are ".join(' -> ',@{$rows[$_]})."\n";
}

foreach (1..$order) {
	print "The ".$_."rd collum positions are ".join(' -> ',@{$collums[$_]})."\n";
}

print "The right diagonal positions are ".join(' -> ',@{$diagonals[1]})."\n";

print "The left diagonal positions are ".join(' -> ',@{$diagonals[2]})."\n";


#Actual finding the numbers

my $start_time = time;

my @current_each_position;
my %numbers_in_use;

my $sum;

get_magic_square();

sub get_magic_square {
	if (check_layer(0) == 1) {
		print "Found Valid Solution of sum $sum\n";
		print "The results are are: ".join(' -> ',@current_each_position[1..$#current_each_position])."\n";
	}
}

sub check_layer {
	my $fill_index = shift;
	my $position = $position_fill_order[$fill_index];
	my $defined_sum_here = 0;
	LAYER: for(my $i = $start; $i <= $max; $i++) {
		next if (exists $numbers_in_use{$i});
		
		delete $numbers_in_use{$current_each_position[$position]} if (defined $current_each_position[$position]);
		$numbers_in_use{$i} = 1;
		$current_each_position[$position] = $i;
		
		foreach my $checks (@{$checks_by_position{$position}}) {
			my $current_sum;
			foreach my $sum_position (@{$checks}) {
				$current_sum += $current_each_position[$sum_position];
			}
			
			if (!defined $sum) {
				$sum = $current_sum;
				$defined_sum_here = 1;
			} else {
				unless ($sum == $current_sum) {
					next LAYER;
				}
			}
		}
		
		if ($position == $position_fill_order[-1]) {
			return 1;
			
		} else {
			return 1 if (check_layer(($fill_index+1)) == 1);
		}
		if ($defined_sum_here == 1) {
			undef $sum;
		}
	}
	if (defined $current_each_position[$position]) {
		delete $numbers_in_use{$current_each_position[$position]};
		undef $current_each_position[$position];
	}
	return 0;
}

my $end_time = time;

my $elapsed = $end_time - $start_time;

print "It only took $elapsed seconds !\n";

print "Finished !\n";

system("pause");