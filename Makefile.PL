use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'      => 'Apache::RandomImage',
    'VERSION_FROM'  => 'RandomImage.pm',
    'PREREQ_PM'     => {'Apache' => 0},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'RandomImage.pm', # retrieve abstract from module
       AUTHOR     => 'Michael Kröll <michael.kroell@uibk.ac.at>') : ()),
);
