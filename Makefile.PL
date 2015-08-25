use inc::Module::Install;

# Define metadata
name           'Mojolicious-Command-swat';
all_from       'lib/Mojolicious/Command/swat.pm';

# Specific dependencies
requires    'Mojolicious';
license     'perl';

WriteAll;

