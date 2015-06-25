package Data::BPlusTree::Leaf;
use strict;
use warnings;
use Class::Accessor qw/antlers/;
use Data::BPlusTree;
use parent qw/Data::BPlusTree::Node/;

has values    => (is => "ro", isa => "ArrayRef");
has keys      => (is => "ro", isa => "ArrayRef[Str]");
has parent    => (is => "rw");

sub first_root {
  my ($class, $tree) = @_;
  $class->new({keys => [], values => [], parent => $tree});
}

sub insert {
  my ($self, $given_key, $value) = @_;

  my $inserted = 0;
  for (my $i = 0; $i < scalar @{$self->keys}; $i++) {
    my $key = $self->keys->[$i];
    if ( $given_key lt $key ) {
      splice @{$self->values}, $i, 0,  $value;
      splice @{$self->keys}, $i, 0, $given_key;
      $inserted = 1;
      last;
    }
    if ( $given_key eq $key ) {
      $self->values->[$i] = $value;
      return;
    }
  }
  if (! $inserted) {
    push @{$self->values}, $value;
    push @{$self->keys}, $given_key;
  }

  # slot_size をあふれたら分割処理
  if ( scalar @{$self->values} >  $self->SLOT_SIZE ) {
    $self->_divide;
    return;
  }
}

sub find {
  my ($self, $given_key) = @_;
  for (my $i = 0; $i < scalar @{$self->keys}; $i++) {
    my $key = $self->keys->[$i];
    if ( $given_key eq $key ) {
      return $self->values->[$i];
    }
  }
}

sub _divide {
  my ($self) = @_;

  my $middle_index = int($self->ORDER / 2) - 1;

  my $small_keys   = [@{$self->keys}[0..$middle_index]];
  my $small_values = [@{$self->values}[0..$middle_index]];
  my $middle_key   = $self->keys->[$middle_index];
  my $large_keys   = [@{$self->keys}[($middle_index + 1)..($self->SLOT_SIZE)]];
  my $large_values = [@{$self->values}[($middle_index + 1)..($self->SLOT_SIZE)]];

  my $small_leaf = Data::BPlusTree::Leaf->new({
    keys => $small_keys,
    values => $small_values,
    parent => $self->parent,
  });
  my $large_leaf = Data::BPlusTree::Leaf->new({
    keys => $large_keys,
    values => $large_values,
    parent => $self->parent,
  });

  $self->parent->child_divided($middle_key, $small_leaf, $large_leaf);
  $self->_cleanup;
}

sub _cleanup {
  my ($self) = @_;
  $self->{parent} = undef;
  $self->{keys} = undef;
  $self->{values} = undef;
}

1;
