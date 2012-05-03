use warnings;
use strict;

package Weaver;
use Exporter;
our @ISA = ("Exporter");
our @EXPORT = qw(&stutter &alternate);

# WEAVER
# These functions take a list of references to ordered lists and
# return a single list "woven" together in a particular way.
# The returned list will be the length of the shortest input list.

# This weave will return a list with the first $interval items of each list,
# followed by the next $interval items, etc. Given lists of the same size,
# the resulting array will contain every value.
sub stutter {
    my @lists = @{$_[0]};
    my $interval = $_[1]; # interval at which to alternate

    my @result;
    my $length = min_length(@lists);

    for (my $i = 0; $i < $length; $i += $interval) {
        for my $list (@lists) {
            for (my $j = 0; $j < $interval && $i + $j < $length; $j++) {
                push @result, $list->[$i + $j];
            }
        }
    }

    return @result;
}

# This weave will return a list with the first $interval items from the first
# list followed by the second $interval items of the second list, etc.
sub alternate {
    my @lists = @{$_[0]};
    my $interval = $_[1]; # interval at which to alternate

    my @result;
    my $length = min_length(@lists);
    my $list_count = $#lists + 1;

    my $current_list = 0;
    for (my $i = 0; $i < $length; $i += $interval) {
        for (my $j = 0; $j < $interval && $i + $j < $length; $j++) {
            push @result, $lists[$current_list]->[$i + $j];
        }
        $current_list = (++$current_list) % $list_count;
    }

    return @result;
}



# Return the minimum length of lists passed in as references.
sub min_length {
    my @lengths = map { $#{$_} + 1 } @_;
    return (sort @lengths)[0];
}