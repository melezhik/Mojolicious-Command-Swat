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

  Usage: APPLICATION routes [OPTIONS]

  Options:
    -f, --force   Override existed swat tests

=head1 DESCRIPTION

L<Mojolicious::Command::swat> generate swat tests for mojo routes.

This command walk through all availbale routes and generate a swat test for every one. 
POST and GET http requests are only supported ( might be changed in the future ).


SWAT is a Simple Web Application Test ( FrameWork )

=head1 Hello World Example 


=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
