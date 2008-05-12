#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

BEGIN { use_ok("PJVM::Runtime"); }

my $rt = PJVM::Runtime->new({classpath => [qw(java)]});
isa_ok($rt, "PJVM::Runtime");
is_deeply($rt->classpath, ["java"]);

my $class = $rt->get_class("test2");
ok(!defined $class);

$class = $rt->load_class("test2");
ok(defined $class);

use Data::Dumper qw(Dumper);
print STDERR Dumper($class);