package Data::LinkedList;
use strict;
use warnings;
use Class::Accessor "antlers";
use Data::Error::IndexError;

# 簡便のため、今回は要素はNumに限る
has head => (is => "ro", isa => 'Num');
has tail => (is => "ro", isa => 'Data::LinkedList');

###############
# constants
###############
my $nil = Data::LinkedList->new({head => undef, tail => undef});
sub Nil {
  $nil;
}

###################
# instance methods
###################

# O(1)、どんなに長いリストに対してunshiftしても
# 定数時間で処理が終わる
sub unshift {
  my ($self, $element) = @_;
  Data::LinkedList->new({head => $element, tail => $self});
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

  _at_index_helper->($self, $index, 0)->head;
}

sub eq {
  my ($self, $other) = @_;
  if ($self == Data::LinkedList::Nil &&
    $other == Data::LinkedList::Nil) {
    return 1;
  }
  elsif ($self == Data::LinkedList::Nil ||
    $other == Data::LinkedList::Nil) {
    return
  }
  elsif ($self->head != $other->head) {
    return
  }
  else {
    $self->tail->eq($other->tail);
  }
}

sub push {
  my ($self, $element) = @_;

  if ($self == Data::LinkedList::Nil) {
    return Data::LinkedList->new({head => $element, tail => $self});
  }
  else {
    return Data::LinkedList->new({head => $self->head, tail => $self->tail->push($element)});
  }
}

sub pop {
  my ($self, $element) = @_;
  if ($self == Data::LinkedList::Nil) {
    die Data::Error::IndexError->new({message => "can't pop Nil"});
  }
  elsif ($self->tail == Data::LinkedList::Nil) {
    return ($self->head, $self->tail);
  }
  else {
    my ($last_element, $tail_popped_list) = $self->tail->pop;
    my $new_list = Data::LinkedList->new({head => $self->head, tail => $tail_popped_list});
    return ($last_element, $new_list);
  }
}

##########
# private
##########
sub _at_index_helper {
  my ($list, $index, $counter) = @_;

  if ($list == Data::LinkedList::Nil) {
    die Data::Error::IndexError->new({
        message => "too large index",
      });
  };

  if ( $counter == $index ) {
    return $list;
  }
  else {
    return _at_index_helper->($list->tail, $index, $counter + 1);
  }
}

1;
