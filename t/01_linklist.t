use strict;
use warnings;
use utf8;
use Test::More;
use Data::LinkedList;

subtest 'can initialize' => sub {
  my $list = Data::LinkedList->new(1, Data::LinkedList::Nil);
  isa_ok($list, 'Data::LinkedList');
};

subtest "unshift returns new list which's head is given value and tail is old list" => sub {
  my $old_list = Data::LinkedList::Nil;
  my $new_list = $old_list->unshift(1);
  is($new_list->head, 1, 'head');
  is($new_list->tail, $old_list, 'tail');
};

subtest 'shift returns head and new list which is eq to old tail' => sub {
  my $list = Data::LinkedList::Nil->unshift(1);
  my $head = $list->head;
  my $tail = $list->tail;

  my ($shifted_value, $shifted_list) = $list->shift;
  is($shifted_value, $head, 'unshifted_value');
  is($shifted_list, $tail, 'unshifted_list');
};

subtest 'die when shift Nil' => sub {
  eval {
    my $nil = Data::LinkedList::Nil->shift;
  };
  isa_ok($@, 'Data::Error::IndexError');
};

subtest 'at_index(n) returns value at the index' => sub {
  my $list = Data::LinkedList::Nil->
    unshift(3)->
    unshift(2)->
    unshift(1); # [1, 2, 3]
  is($list->at_index(0), 1);
  is($list->at_index(1), 2);
  is($list->at_index(2), 3);
};

subtest 'at_index raises IndexError when given negative index' => sub {
  my $list = Data::LinkedList::Nil->
    unshift(3)->
    unshift(2)->
    unshift(1); # [1, 2, 3]

  eval {
    $list->at_index(-1);
  };
  isa_ok($@, 'Data::Error::IndexError');
};

subtest 'at_index raises IndexError when given too large index' => sub {
  my $list = Data::LinkedList::Nil->
    unshift(3)->
    unshift(2)->
    unshift(1); # [1, 2, 3]

  eval {
    $list->at_index(3);
  };

  isa_ok($@, 'Data::Error::IndexError');
};

done_testing;
