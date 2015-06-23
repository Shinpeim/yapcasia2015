package Data::HashTable;
use strict;
use warnings;
use Digest::MD5 qw/md5/;

my $slotsize = 128;

sub new {
  my ($class, $args) = @_;
  my $self = bless {}, $class;
  $self->{slot_arrays} = [];
  for my $i (1..$slotsize) {
    push @{$self->{slot_arrays}}, [];
  }

  $self;
};

sub set {
  my ($self, $key, $value) = @_;
  my $index = _hash_index_of($key);
  my $slot_array = $self->{slot_arrays}->[$index];

  my $found = 0;
  for my $slot (@{$slot_array}) {
    if($slot->[0] eq $key) {
      $slot->[1] = $value;
      $found = 1;
      last;
    }
  }

  if ( $found == 0 ) {
    push @{$slot_array}, [$key, $value];
  }
};

sub get {
  my ($self, $key) = @_;
  my $index = _hash_index_of($key);
  my $slot_array = $self->{slot_arrays}->[$index];

  my $found = 0;
  for my $slot (@{$slot_array}) {
    if($slot->[0] eq $key) {
      return $slot->[1];
    }
  }
};

###################
# private
###################
sub _hash_index_of {
  my ($key) = @_;
  my $digest = md5($key);
  my $num = unpack("L", $digest);
  $num % $slotsize;
};
1;
