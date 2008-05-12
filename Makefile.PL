use 5.008001;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'PJVM',
    VERSION_FROM    => 'lib/PJVM.pm',
    PREREQ_PM       => {
        Test::More      => 0,
        IO::Scalar      => 0,
        File::Slurp     => 0,
        Object::Tiny    => 0,
        Scalar::Util    => 0,
        Test::Exception => 0,
    },
    LICENSE         => 'mit',
    ABSTRACT_FROM   => 'lib/PJVM.pm',
    AUTHOR          => 'Claes Jakobsson <claesjac@cpan.org>',
);
