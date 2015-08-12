# NAME

Mojolicious::Command::swat - Swat command

# SYNOPSIS

    Usage: APPLICATION swat [OPTIONS]

    Options:
      -f, --force   Override existed swat tests

# DESCRIPTION

[Mojolicious::Command::swat](https://metacpan.org/pod/Mojolicious::Command::swat) generate swat tests for mojo routes.

This command walk through all availbale routes and generate a swat test for every one. 
POST and GET http requests are only supported ( might be changed in the future ).

# Hello World Example 

## install mojo

    sudo cpanm Mojolicious

## bootstrap a mojo application

    mkdir myapp
    cd myapp
    mojo generate lite_app myapp.pl
    

## define routes

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

# install Mojolicious::Command::swat

    sudo cpanm Mojolicious::Command::swat

## bootstrap swat tests

    $ ./myapp.pl swat
    generate swat route for / ...
    generate swat data for GET / ...
    generate swat route for /hello ...
    generate swat data for POST /hello ...
    generate swat route for /hello/world ...
    generate swat data for GET /hello/world ...

# specify routes checks

This phase might be skiped as preliminary \`200 OK\` checks are already added added on bootstrap phase. But you may define ones more:

    $ echo ROOT >> swat/get.txt
    $ echo HELLO >> swat/hello/post.txt
    $ echo HELLO WORLD >> swat/hello/world/get.txt

# install swat

    sudo cpanm swat

# run swat tests

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicio.us](http://mojolicio.us).
