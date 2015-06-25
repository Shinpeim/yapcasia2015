package Data::BPlusTree;
use strict;
use warnings;
use Class::Accessor qw/antlers/;
use Data::BPlusTree::Leaf;

has root => (is => "ro", isa => "Data::BPlusTree::Node");

sub new {
  my ($class) = @_;
  my $self = bless {}, $class;
  $self->{root} = Data::BPlusTree::Leaf->first_root($self);

  $self;
}

sub insert {
  my ($self, $key, $value) = @_;
  $self->root->insert($key, $value);
}

sub find {
  my ($self, $key) = @_;
  $self->root->find($key);
}

sub child_divided {
  my ($self, $key, $small_node, $large_node) = @_;

  my $new_root = Data::BPlusTree::Node->new({
    keys => [$key],
    children => [$small_node, $large_node],
    parent => $self,
  });

  $small_node->parent($new_root);
  $large_node->parent($new_root);

  $self->{root} = $new_root;
}
1;
