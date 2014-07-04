use Test::More qw/ no_plan /;

use Text::LevenshteinXS qw(distance);

use Encode;
use Unicode::Normalize;

ok(1); 

# basic tests
is(distance("foo","four"), 2);
is(distance("foo","foo"), 0);
is(distance("foo",""), 3);
is(distance("four","foo"), 2);
is(distance("foo","bar"), 3);

# more tests from the bugtracking system
is(distance('headache','heavy load'), 7);
is(distance('Distinction courses', 'Distinction Courses'), 1, 'upper/lower');
is(distance("fool's handiwork bar", 'food handling bar'), 8);


# utf-8 tests
is(distance("äöü","äöü"), 0);
is(distance("strase","straße"), 1);
is(distance("strasse","straße"), 2);
is(distance("äöü","123"), 3);

is(distance("","str"), 3, 'length check');
is(distance("","straße"), 6, 'length check �');
is(distance("", decode("utf8", "stra\x{00DF}e")), 6, 'length check \x');

is(distance("äöü",decode("latin1", "���")), 0);
is(distance("123","abcde"), 5, 'foo');

my $umls = "äöü";

{
  use encoding "latin1";
  is(distance($umls, "���"), 0, 'encoding latin1');
}
