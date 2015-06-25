package Data::BPlusTree::Node;
use strict;
use warnings;
use Class::Accessor qw/antlers/;

use constant ORDER     => 4;
use constant SLOT_SIZE => 3;

has keys     => (is => "ro", isa => "ArrayRef[Str]");
has children => (is => "ro", isa => "ArrayRef[Data::BPlusTree::Node]");
has parent   => (is => "rw");

sub insert {
  my ($self, $given_key, $value) = @_;

  for (my $i = 0; $i < scalar @{$self->keys}; $i++) {
    my $key = $self->keys->[$i];
    if ( $given_key le $key ) {
      $self->children->[$i]->insert($given_key, $value);
      return;
    }
  }
  $self->children->[-1]->insert($given_key, $value);
}

sub find {
  my ($self, $given_key) = @_;
  for (my $i = 0; $i < scalar @{$self->keys}; $i++) {
    my $key = $self->keys->[$i];
    if ( $given_key le $key ) {
      return $self->children->[$i]->find($given_key);
    }
  }
  return $self->children->[-1]->find($given_key);
}

sub child_divided {
  my ($self, $new_key, $small_node, $large_node) = @_;

  # keyの挿入とlinkの張り替え
  my $inserted = 0;
  for (my $i = 0; $i < scalar @{$self->keys}; $i++) {
    my $key = $self->keys->[$i];
    if ($new_key lt $key) {
      splice @{$self->keys}, $i, 0, $new_key;
      splice @{$self->children}, $i, 0, $small_node;
      $self->children->[$i + 1] = $large_node;
      $inserted = 1;
      last;
    }
  }
  if ( ! $inserted ) {
    push @{$self->keys}, $new_key;
    $self->children->[-1] =  $small_node;
    push @{$self->children}, $large_node;
  }

  $small_node->parent($self);
  $large_node->parent($self);

  # slot超えてたら分割処理
  if ( scalar @{$self->keys} > $self->SLOT_SIZE ) {
    $self->_divide;
  }
}

sub _divide {
  my ($self) = @_;

  my $middle_index = int($self->ORDER / 2) - 1;

  my $small_keys     = [@{$self->keys}[0..($middle_index - 1)]];
  my $small_children = [@{$self->children}[0..($middle_index)]];

  my $middle_key = $self->keys->[$middle_index];

  my $large_keys     = [@{$self->keys}[($middle_index + 1)..($self->SLOT_SIZE)]];
  my $large_children = [@{$self->children}[($middle_index + 1)..($self->SLOT_SIZE + 1)]];

  my $small_node = Data::BPlusTree::Node->new({
    keys     => $small_keys,
    children => $small_children,
    parent => $self->parent,
  });
  for my $child (@$small_children) {
    $child->parent($small_node);
  }

  my $large_node = Data::BPlusTree::Node->new({
    keys     => $large_keys,
    children => $large_children,
    parent => $self->parent,
  });
  for my $child (@$large_children) {
    $child->parent($large_node);
  }

  $self->parent->child_divided($middle_key, $small_node, $large_node);

  $self->_cleanup;
}

sub _cleanup {
  my ($self) = @_;
  $self->{parent} = undef;
  $self->{keys} = undef;
  $self->{children} = undef;
}

1;
