package PJVM::ExecutionEngine::SimpleRunloop;

use strict;
use warnings;

sub new {
    my $pkg = shift;
    return bless do { my $v; \$v; }, $pkg;
}

sub compile {
    my ($self, $bytecode) = @_;
    return $bytecode;
}

1;
__END__

=head1 NAME

PJVM::ExecutionEngine::SimpleRunloop -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
