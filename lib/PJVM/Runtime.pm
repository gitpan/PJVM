package PJVM::Runtime;

use strict;
use warnings;

use Module::Load qw();
use Scalar::Util qw(blessed);

use PJVM::Runtime::Class;
use PJVM::Runtime::Object;

use Object::Tiny qw(
    classpath
    system_class_loader
    default_execution_engine
    class_registry
    stack
);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT;
our @EXPORT_OK = qw(rt_push_stack rt_pop_stack);
our %EXPORT_TAGS = (
    stack => [qw(rt_push_stack rt_pop_stack)],
);

use Module::Pluggable
    search_path => [qw(PJVM::Runtime::Native)], 
    sub_name => "native_classes";

# Stack functions
{
    my $stack;

    # Sets the current stack
    sub rt_set_stack {
        $stack = shift;
    }

    sub rt_pop_stack() {
        return pop @$stack;
    }

    sub rt_push_stack($) {
        push @$stack, @_;
        1;
    }
}

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
    
    my $self = bless {
        classpath                   => $args->{classpath},
        system_class_loader         => $system_class_loader,
        default_execution_engine    => $default_engine,
        class_registry              => {},
        stack                       => [],
    }, $pkg;
    
    # Setup native classes
    for my $native_pkg ($self->native_classes) {
        Module::Load::load $native_pkg;
        my $class = $native_pkg->new();
        $self->register_class($class);
    }
    
    return $self;
}

sub find_class {
    my ($self, $classname) = @_;
    return $self->get_class($classname) if $self->has_class($classname);
    return $self->load_class($classname);
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
    my ($self, $class) = @_;
    
    if ($class->isa("PJVM::Class")) {
        $class = PJVM::Runtime::Class->new_from_spec($self, $class);
    }

    $self->class_registry->{$class->qname} = $class;
    
    1;
}

sub call {
    my ($rt, $signature, $instance, @args) = @_;
    
    rt_set_stack($rt->stack);
    
    # this
    rt_push_stack $instance;
    
    my $method = $instance->class->get_method($signature);
    
    # Throw some shit on stack
    rt_push_stack $_ for @args;
    
    # Run method
    $method->();
    
    # Get result from stack if not void
    my $result;
    if ($signature !~ m/\)V$/) {
        $result = rt_pop_stack;
    }
    
    return $result;
}

sub instantiate {
    my ($self, $class) = @_;
    my $object = PJVM::Runtime::Object->new($class);
    return $object;
}

1;
__END__

=head1 NAME

PJVM::Runtime -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
