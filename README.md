# NAME

Mojolicious::Command::swat - Swat command

# SYNOPSIS

    Usage: APPLICATION swat [OPTIONS]

    Options:
      -f, --force   Override existed swat tests

# DESCRIPTION

[Mojolicious::Command::swat](https://metacpan.org/pod/Mojolicious::Command::swat) 

* Generates [swat](https://github.com/melezhik/swat) swat tests scaffolding for mojo application.

* This command walks through all available routes and generates a swat test for every one. 

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

## specify swat [check lists](https://github.com/melezhik/swat#swat-check-lists)

This phase might be skipped as preliminary \`200 OK\` checks are already added on bootstrap phase. But you may define more. 

For complete documentation on \*how to write swat tests\*  please visit  https://github.com/melezhik/swat

    $ echo ROOT >> swat/get.txt
    $ echo HELLO >> swat/hello/post.txt
    $ echo HELLO WORLD >> swat/hello/world/get.txt

## start mojo application

    $ morbo ./myapp.pl
    Server available at http://127.0.0.1:3000

## install swat

    sudo cpanm swat

## run swat tests

# SEE ALSO

* [swat](https://github.com/melezhik/swat)
* [Mojolicious](https://metacpan.org/pod/Mojolicious)
