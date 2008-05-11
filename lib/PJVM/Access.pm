package PJVM::Access;

use strict;
use warnings;

our @ISA = qw(Exporter);

our @EXPORT;
our @EXPORT_OK = qw(ACC_PUBLIC ACC_FINAL ACC_SUPER ACC_INTERFACE ACC_ABSTRACT);

our %EXPORT_TAGS = (
    access_flags => [qw(ACC_PUBLIC ACC_FINAL ACC_SUPER ACC_INTERFACE ACC_ABSTRACT)],
);

use constant {
    ACC_PUBLIC      => 0x0001, # Declared public; may be accessed from outside its package.
    ACC_PRIVATE     => 0x0002, # Declared private; usable only within the defining class.
    ACC_PROTECTED   => 0x0004, # Declared protected; may be accessed within subclasses.
    ACC_STATIC      => 0x0008, # Declared static.
    ACC_FINAL       => 0x0010, # Declared final; no subclasses allowed.
    ACC_SUPER       => 0x0020, # Treat superclass methods specially when invoked by the invokespecial instruction.
    ACC_VOLATILE    => 0x0040, #Declared volatile; cannot be cached.
    ACC_TRANSIENT   => 0x0080, #Declared transient; not written or read by a persistent object manager.
    ACC_INTERFACE   => 0x0200, # Is an interface, not a class.
    ACC_ABSTRACT    => 0x0400, # Declared abstract; may not be instantiated.    
};

1;
__END__

=head1 NAME

PJVM::Access -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
