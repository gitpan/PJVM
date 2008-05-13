package PJVM::Runtime::Class;

use strict;
use warnings;

use PJVM::Types;
use PJVM::Access qw(:flags);

use Object::Tiny qw(
    qname
    methods
    methods_access
    fields
    fields_access
    ee
);

sub new_from_spec {
    my ($pkg, $runtime, $spec) = @_;
    
    # Methods
    my $ee = $runtime->default_execution_engine;
    my (%methods, %methods_access);
    for my $method (@{$spec->methods}) {
        my $mkey = $method->name . "#" . $method->signature;
        
        # Let the engine have a chance to compile this if we want too
        my $cb = $ee->compile($method->code);
        $methods{$mkey} = ref $cb eq "CODE" ? $cb : sub { $ee->execute($cb) };
        $methods_access{$mkey} = $method->access_flags;
    }
    
    # Fields
    my (%fields, %fields_access);
    for my $field (@{$spec->fields}) {
        $fields{$field->name} = $field->signature;
        $fields_access{$field->name} = $field->access_flags;
    }
    
    my $self = $pkg->SUPER::new(
        qname           => $spec->name,
        methods         => \%methods,
        methods_acces   => \%methods_access,
        fields          => \%fields,
        fields_access   => \%fields_access,
        access_flags    => $spec->access_flags,
    );
    
    return $self;
}

sub class {
    my $self = shift;
    return $self;
}

sub get_method {
    my ($self, $signature) = @_;
    my $method = $self->{methods}->{$signature};
    die "AbstractMethodError" unless $method;
    return $method;
}
sub static_fields {
    my $self = shift;
    my $fields = $self->fields;
    my $fields_access = $self->fields_access;
    my %static = map { $_ => $fields->{$_} } grep { $fields_access->{$_} & ACC_STATIC } keys %$fields;
    return \%static;
}

sub instance_fields {
    my $self = shift;
    my $fields = $self->fields;
    my $fields_access = $self->fields_access;
    my %static = map { $_ => $fields->{$_} } grep { !($fields_access->{$_} & ACC_STATIC)  } keys %$fields;
    return \%static;
}

1;
__END__

=head1 NAME

PJVM::Runtime::Class -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
