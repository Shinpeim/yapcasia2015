package Data::Error;
use strict;
use warnings;
use Class::Accessor qw/antlers/;

has message => (is => "ro", isa => "Str");

1;
