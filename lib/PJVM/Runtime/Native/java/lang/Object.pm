package PJVM::Runtime::Native::java::lang::Object;

use strict;
use warnings;

use Scalar::Util qw(refaddr);

use PJVM::Access qw(:flags);
use PJVM::Runtime qw(:stack);
use PJVM::Runtime::Class;

sub new {
    my $class = PJVM::Runtime::Class->new(
        qname => "java/lang/Object",
        methods => {            
            # Constructor
            "#()V"                          => \&j_new,

            # protected Object clone()
            "clone#()Ljava/lang/Object;"    => \&j_clone,
            
            # boolean equals(Object)
            "equals#(Ljava/lang/Object;)Z"  => \&j_equals,
            
            # protected void finalize()
            "finalize#()V"                  => \&j_finalize,
            
            # Class getClass()
            "getClass#()Ljava/lang/Class;"  => \&j_get_class,
            
            # int hashCode()
            "hashCode#()I"                  => \&j_hash_code,
            
        },
        methods_access => {
            "#()V"                          => ACC_PUBLIC,
            "clone#()Ljava/lang/Object;"    => ACC_PROTECTED,
            "equals#(Ljava/lang/Object;)Z"  => ACC_PUBLIC,
            "finalize#()V"                  => ACC_PROTECTED,
            "getClass#()Ljava/lang/Class;"  => ACC_PUBLIC,            
        },
    );
    
    return $class;
}

sub j_new {
}

# Methods bound to Java space, refere to $self as $this to follow Java conventions
sub j_clone {
    my $this = rt_pop_stack;
    # TODO: check interface and throw java/lang/CloneNotSupportedException if 
    # not class does not implement java/lang/Cloneable

    # Performs a shallow clone
    my $clone = $this->clone();

    rt_push_stack $clone;
    
    1;
}

sub j_equals {
    my $this = rt_pop_stack;
    my $that = rt_pop_stack;
    
    rt_push_stack refaddr $this == refaddr $that;
}

sub j_finalize {
}

sub j_get_class {
    my $this = rt_pop_stack;
    rt_push_stack $this->class();
}

sub j_hash_code {
    my $this = rt_pop_stack;
    rt_push_stack refaddr $this;
}

1;
__END__

=head1 NAME

PJVM::Runtime::Native::java::lang::Object -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
