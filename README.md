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

## specify routes checks

This phase might be skiped as preliminary \`200 OK\` checks are already added on bootstrap phase. But you may define ones more:

    $ echo ROOT >> swat/get.txt
    $ echo HELLO >> swat/hello/post.txt
    $ echo HELLO WORLD >> swat/hello/world/get.txt

## start mojo application

    $ morbo ./myapp.pl
    Server available at http://127.0.0.1:3000

## install swat

    sudo cpanm swat

## run swat tests

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
        
    

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicio.us](http://mojolicio.us).
