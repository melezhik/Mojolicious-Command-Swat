package Mojolicious::Command::swat;
use Mojo::Base 'Mojolicious::Command';

use re 'regexp_pattern';
use Getopt::Long qw(GetOptionsFromArray);

has description => 'Show available routes';
has usage => sub { shift->extract_usage };

sub run {
  my ($self, @args) = @_;

  GetOptionsFromArray \@args, 'f|force' => \my $force;

  my $rows = [];
  _walk($_, 0, $rows, $verbose) for @{$self->app->routes->children};

}

sub _walk {
  my ($route, $depth, $rows, $verbose) = @_;

  # Pattern
  my $prefix = '';
  if (my $i = $depth * 2) { $prefix .= ' ' x $i . '+' }
  push @$rows, my $row = [$prefix . ($route->pattern->unparsed || '/')];

  # Flags
  my @flags;
  push @flags, @{$route->over || []} ? 'C' : '.';
  push @flags, (my $partial = $route->partial) ? 'D' : '.';
  push @flags, $route->inline       ? 'U' : '.';
  push @flags, $route->is_websocket ? 'W' : '.';
  push @$row, join('', @flags) if $verbose;

  # Methods
  my $via = $route->via;
  push @$row, !$via ? '*' : uc join ',', @$via;

  # Name
  my $name = $route->name;
  push @$row, $route->has_custom_name ? qq{"$name"} : $name;

  # Regex (verbose)
  my $pattern = $route->pattern;
  $pattern->match('/', $route->is_endpoint && !$partial);
  my $regex  = (regexp_pattern $pattern->regex)[0];
  my $format = (regexp_pattern($pattern->format_regex))[0];
  push @$row, $regex, $format ? $format : '' if $verbose;

  $depth++;
  _walk($_, $depth, $rows, $verbose) for @{$route->children};
  $depth--;
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Command::swat - Swat command

=head1 SYNOPSIS

  Usage: APPLICATION swat [OPTIONS]

  Options:
    -f, --force   Override existed swat tests

=head1 DESCRIPTION

L<Mojolicious::Command::swat> generate swat tests for mojo routes.

This command walk through all availbale routes and generate a swat test for every one. 
POST and GET http requests are only supported ( might be changed in the future ).


=head1 Hello World Example 


=head2 install mojo

    sudo cpanm Mojolicious

=head2 bootstrap a mojo application

    mkdir myapp
    cd myapp
    mojo generate lite_app myapp.pl
    
=head2 define routes


    $ nano myapp.pl

    #!/usr/bin/env perl
    use Mojolicious::Lite;
    
    get '/' => sub {
      my $c = shift;
      $c->render(text => 'ROOT');
    };
    
    
    post '/hello' => sub {
      my $c = shift;
      $c->render(text => 'HELLO');
    };
    
    get '/hello/world' => sub {
      my $c = shift;
      $c->render(text => 'HELLO WORLD');
    };
    
    app->start;
    

    $ ./myapp.pl routes
    /             GET
    /hello        POST  hello
    /hello/world  GET   helloworld

=head1 install Mojolicious::Command::swat

    sudo cpanm Mojolicious::Command::swat

=head2 bootstrap swat tests

    $ ./myapp.pl swat
    generate swat route for / ...
    generate swat data for GET / ...
    generate swat route for /hello ...
    generate swat data for POST /hello ...
    generate swat route for /hello/world ...
    generate swat data for GET /hello/world ...


=head1 specify routes checks

This phase might be skiped as preliminary `200 OK` checks are already added added on bootstrap phase. But you may define ones more:

    $ echo ROOT >> swat/get.txt
    $ echo HELLO >> swat/hello/post.txt
    $ echo HELLO WORLD >> swat/hello/world/get.txt


=head1 install swat

    sudo cpanm swat

=head1 run swat tests


=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
