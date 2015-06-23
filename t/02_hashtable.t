use strict;
use warnings;
use utf8;
use Test::More;
use Data::HashTable;

subtest 'can initailize' => sub {
  my $hash = Data::HashTable->new;
  isa_ok($hash, 'Data::HashTable');
};

subtest 'can set and get' => sub {
  my $hash = Data::HashTable->new;
  $hash->set(key_a => 'value_a');
  $hash->set(key_b => 'value_b');
  is($hash->get('key_a'), 'value_a');
  is($hash->get('key_b'), 'value_b');
};

done_testing;
