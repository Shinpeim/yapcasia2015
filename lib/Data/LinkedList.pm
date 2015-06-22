package Data::LinkedList;
use strict;
use warnings;
use Class::Accessor "antlers";
use Data::Error::IndexError;

has head => (is => "ro");
has tail => (is => "ro", isa => 'Data::LinkedList');

my $nil = Data::LinkedList->new(head => undef, tail => undef);

sub Nil {
  $nil;
}

sub new {
  my ($class, $head, $tail) = @_;
  bless {
    head => $head,
    tail => $tail,
  }, $class;
};

# O(1)、どんなに長いリストに対してunshiftしても
# 定数時間で処理が終わる
sub unshift {
  my ($self, $element) = @_;
  Data::LinkedList->new($element, $self);
}

# O(1)、どんなに長いリストに対してunshiftしても
# 定数時間で処理が終わる
sub shift {
  my ($self) = @_;

  if ( $self == Nil ) {
    die Data::Error::IndexError->new({message => "can't unshit Nil"});
  }

  ($self->head, $self->tail);
}

sub at_index {
  my ($self, $index) = @_;

  if ($index < 0 ) {
    die Data::Error::IndexError->new({
      message => "index can't be negative",
    });
  }

  my $helper; $helper = sub {
    my ($list, $counter) = @_;

    if ($list == Data::LinkedList::Nil) {
      die Data::Error::IndexError->new({
        message => "too large index",
      });
    };

    if ( $counter == $index ) {
      return $list;
    }
    else {
      return $helper->($list->tail, $counter + 1);
    }
  };

  $helper->($self, 0)->head;
}


1;
