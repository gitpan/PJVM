package PJVM::Runtime::Class;

use strict;
use warnings;

use Object::Tiny qw(
    qname
    methods
    ee
);

sub new_from_spec {
    my ($pkg, $runtime, $spec) = @_;

    # Qualified name, for example se/versed/SomeClass
    my $qname = $spec->name;
    
    # Methods
    my $ee = $runtime->default_execution_engine;
    my %methods;
    for my $method (@{$spec->methods}) {
        my $mkey = $method->name . "#" . $method->signature;
        
        # Let the engine have a chance to compile this if we want too
        my $method = $ee->compile($method->bytecode);
        $methods{$mkey} = [$ee, $method];
    }
    
    my $self = $pkg->SUPER::new(
        qname   => $qname,
        methods => \%methods,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Runtime::Class -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
