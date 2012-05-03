use Test::Simple tests => 4;
use Weaver;
use 5.010;

@l_1 = (1, 2, 3, 4);
@l_2 = (5, 6, 7, 8);

# expected
@l_3 = stutter([\@l_1, \@l_2], 1);
ok arr_comp(\@l_3, [1, 5, 2, 6, 3, 7, 4, 8]);

@l_3 = stutter([\@l_1, \@l_2], 2);
ok arr_comp(\@l_3, [1, 2, 5, 6, 3, 4, 7, 8]);

@l_3 = alternate([\@l_1, \@l_2], 1);
ok arr_comp(\@l_3, [1, 6, 3, 7]);

@l_3 = alternate([\@l_1, \@l_2], 2);
ok arr_comp(\@l_3, [1, 2, 7, 8]);

sub arr_comp {
    my ($a, $b) = @_;

    my $i;
    for my $el (@$a) {
        return false unless $el eq $b->[$i++];
    }
    return true;
}