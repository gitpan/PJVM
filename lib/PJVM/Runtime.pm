package PJVM::Runtime;

use strict;
use warnings;

use Scalar::Util qw(blessed);

use PJVM::Runtime::Class;

use Object::Tiny qw(
    classpath
    system_class_loader
    default_execution_engine
    class_registry
);

sub new {
    my ($pkg, $args) = @_;

    $args = {} unless ref $args eq "HASH";
    
    # Default class loader
    my $class_loader = $args->{class_loader} || "PJVM::ClassLoader";
    if ($class_loader eq "PJVM::ClassLoader") {
        require PJVM::ClassLoader;
    }
    my $system_class_loader = blessed $class_loader ? $class_loader : $class_loader->new($args);
    
    # The object that runs the actual bytecode
    my $engine = $args->{engine} || "PJVM::ExecutionEngine::SimpleRunloop";
    if ($engine eq "PJVM::ExecutionEngine::SimpleRunloop") {
        require PJVM::ExecutionEngine::SimpleRunloop;
    }
    my $default_engine = blessed $engine ? $engine : $engine->new($args);
    
    my $self = $pkg->SUPER::new(
        classpath                   => $args->{classpath},
        system_class_loader         => $system_class_loader,
        default_execution_engine    => $default_engine,
        class_registry              => {},
    );
    
    return $self;
}

sub load_class {
    my ($self, $classname) = @_;
    
    return $self->get_class($classname) if $self->has_class($classname);
    
    my @classes = $self->system_class_loader->load_class($classname);
    $self->register_class($_) for @classes;
    
    my $class = $self->get_class($classname);
    die "NoClassDefFoundError" unless $class;
    return $class;
}

sub has_class {
    my ($self, $class) = @_;
    return exists $self->class_registry->{$class};
}

sub get_class {
    my ($self, $class) = @_;
    return $self->class_registry->{$class};
}

sub register_class {
    my ($self, $class_spec) = @_;
    
    my $class = PJVM::Runtime::Class->new_from_spec($self, $class_spec);
    $self->class_registry->{$class->qname} = $class;
    
    1;
}

1;
__END__

=head1 NAME

PJVM::Runtime -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
