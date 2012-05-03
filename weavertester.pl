use Test::Simple tests => 6;
use Weaver;

@l_1 = (1, 2, 3, 4);
@l_2 = (5, 6, 7, 8);

@l_3 = alternate([\@l_1, \@l_2], 1);
ok arr_eq(\@l_3, [1, 6, 3, 7]);

@l_3 = alternate([\@l_1, \@l_2], 2);
ok arr_eq(\@l_3, [1, 2, 7, 8]);

@l_3 = stutter([\@l_1, \@l_2], 1);
ok arr_eq(\@l_3, [1, 5, 2, 6, 3, 7, 4, 8]);

@l_3 = stutter([\@l_1, \@l_2], 2);
ok arr_eq(\@l_3, [1, 2, 5, 6, 3, 4, 7, 8]);

# uneven array lengths, more than two arrays
@l_4 = alternate([\@l_1, \@l_2, \@l_3], 1);
ok arr_eq(\@l_4, [1, 6, 5, 4]);

@l_4 = stutter([\@l_1, \@l_2, \@l_3], 1);
ok arr_eq(\@l_4, [1, 5, 1, 2, 6, 2, 3, 7, 5, 4, 8, 6]);


sub arr_eq {
    my ($a, $b) = @_;
    return false unless $#a == $#b;

    my $i;
    for my $el (@$a) {
        return false unless $el eq $b->[$i++];
    }
    return true;
}