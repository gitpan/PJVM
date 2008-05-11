#!/usr/bin/perl

use strict;
use warnings;

use File::Slurp qw(slurp);
use File::Spec;
use IO::Scalar;

use Test::More tests => 3;

BEGIN { use_ok("PJVM::Class::ConstantPool"); }

my $data = slurp(File::Spec->catfile("java", "test1.class"), binmode => ':raw');
my $io = IO::Scalar->new(\$data);

# Skip header stuff
seek $io, 8, 0;

my $pool = PJVM::Class::ConstantPool->new_from_io($io);
isa_ok($pool, "PJVM::Class::ConstantPool");
is($pool->length, 24);

