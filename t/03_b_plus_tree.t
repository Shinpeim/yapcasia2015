use strict;
use warnings;
use utf8;
use Test::More;
use Data::BPlusTree;
use List::Util qw/shuffle/;

subtest 'can initialize' => sub {
  my $tree = Data::BPlusTree->new;
  isa_ok($tree, 'Data::BPlusTree');
};

subtest 'can insert values and search values' => sub {
  my $tree = Data::BPlusTree->new;

  my $keys = [1..50];
  $keys = [shuffle @{$keys}];

  for my $i (@$keys) {
    my $k = $i + 1;
    $tree->insert("$k", $i);
  }

  for my $i (@$keys) {
    my $k = $i + 1;
    is($tree->find("$k"), $i, "${k}'s value");
  }
};

subtest 'can update value' => sub {
  my $tree = Data::BPlusTree->new;
  my $keys = [1..50];

  for my $i (@$keys) {
    my $k = $i + 1;
    $tree->insert("$k", $i);
  }

  $tree->insert('1' => 100);
  is($tree->find('1'), 100);
};

done_testing;
