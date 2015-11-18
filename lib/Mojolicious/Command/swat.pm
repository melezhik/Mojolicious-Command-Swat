package Mojolicious::Command::swat;

our $VERSION = '0.0.5';

use Mojo::Base 'Mojolicious::Command';

use re 'regexp_pattern';
use Getopt::Long qw(GetOptionsFromArray);
use File::Path qw(make_path);

has description => 'Generates swat tests scaffolding for mojo application';
has usage => sub { shift->extract_usage };

sub run {

    my ($self, @args) = @_;

    GetOptionsFromArray \@args, 'f|force' => \my $force;

    mkdir 'swat';

    my $hostname_file = 'swat/host';

    open(my $fh, '>', $hostname_file) or die "Could not open file $hostname_file: $!";
    print $fh "http://127.0.0.1:3000";
    close $fh;
    
 
    my $rows = [];

    _walk($_, 0, $rows, 0) for @{$self->app->routes->children};

    ROUTE: for my $i (@$rows){

        my $http_method = $i->[1];
        my $route  = $i->[0];

        unless ($http_method=~/GET|POST|DELETE|PUT/i){
            print "sorry, swat does not support $http_method methods yet \n";
            next ROUTE;
        }

        my $filename = "swat/$route/";
        
        if (-e $filename and !$force){

            print "skip route $route - swat test already exist, use --force to override existed routes \n";
            next ROUTE;

        } else {

            print "generate swat route for $route ... \n";
            make_path("swat/$route");
    
            print "generate swat data for $http_method $route ... \n";
    
            $filename.=lc($http_method); $filename.=".txt";
            open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
            print $fh "200 OK\n";
            close $fh;
        }

    }

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

__END__

