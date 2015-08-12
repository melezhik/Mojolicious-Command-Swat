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


=head2 specify routes checks

This phase might be skiped as preliminary `200 OK` checks are already added on bootstrap phase. But you may define ones more:

    $ echo ROOT >> swat/get.txt
    $ echo HELLO >> swat/hello/post.txt
    $ echo HELLO WORLD >> swat/hello/world/get.txt


=head2 start mojo application

    $ morbo ./myapp.pl
    Server available at http://127.0.0.1:3000

=head2 install swat

    sudo cpanm swat

=head2 run swat tests

    $ swat ./swat/  http://127.0.0.1:3000
    /home/vagrant/.swat/reports/http://127.0.0.1:3000/00.t ..............
    # start swat for http://127.0.0.1:3000// | is swat package 0
    # swat version v0.1.19 | debug 0 | try num 2 | ignore http errors 0
    ok 1 - successfull response from GET http://127.0.0.1:3000/
    # data file: /home/vagrant/.swat/reports/http://127.0.0.1:3000///content.GET.txt
    ok 2 - GET / returns 200 OK
    ok 3 - GET / returns ROOT
    1..3
    ok
    /home/vagrant/.swat/reports/http://127.0.0.1:3000/hello/00.post.t ...
    # start swat for http://127.0.0.1:3000//hello | is swat package 0
    # swat version v0.1.19 | debug 0 | try num 2 | ignore http errors 0
    ok 1 - successfull response from POST http://127.0.0.1:3000/hello
    # data file: /home/vagrant/.swat/reports/http://127.0.0.1:3000//hello/content.POST.txt
    ok 2 - POST /hello returns 200 OK
    ok 3 - POST /hello returns HELLO
    1..3
    ok
    /home/vagrant/.swat/reports/http://127.0.0.1:3000/hello/world/00.t ..
    # start swat for http://127.0.0.1:3000//hello/world | is swat package 0
    # swat version v0.1.19 | debug 0 | try num 2 | ignore http errors 0
    ok 1 - successfull response from GET http://127.0.0.1:3000/hello/world
    # data file: /home/vagrant/.swat/reports/http://127.0.0.1:3000//hello/world/content.GET.txt
    ok 2 - GET /hello/world returns 200 OK
    ok 3 - GET /hello/world returns HELLO WORLD
    1..3
    ok
    All tests successful.
    Files=3, Tests=9,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.04 CPU)
    Result: PASS
        
    
=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
