<?xml version="1.0" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rev="made" href="mailto:root@localhost" />
</head>

<body>



<ul id="index">
  <li><a href="#NAME">NAME</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a></li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a></li>
  <li><a href="#Hello-World-Example">Hello World Example</a>
    <ul>
      <li><a href="#install-mojo">install mojo</a></li>
      <li><a href="#bootstrap-a-mojo-application">bootstrap a mojo application</a></li>
      <li><a href="#define-routes">define routes</a></li>
    </ul>
  </li>
  <li><a href="#install-Mojolicious::Command::swat">install Mojolicious::Command::swat</a>
    <ul>
      <li><a href="#bootstrap-swat-tests">bootstrap swat tests</a></li>
      <li><a href="#specify-routes-checks">specify routes checks</a></li>
      <li><a href="#start-mojo-application">start mojo application</a></li>
      <li><a href="#install-swat">install swat</a></li>
      <li><a href="#run-swat-tests">run swat tests</a></li>
    </ul>
  </li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Mojolicious::Command::swat - Swat command</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<pre><code>  Usage: APPLICATION swat [OPTIONS]

  Options:
    -f, --force   Override existed swat tests</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p><a>Mojolicious::Command::swat</a> generate swat tests for mojo routes.</p>

<p>This command walk through all available routes and generate a swat test for every one. POST and GET http requests are only supported ( might be changed in the future ).</p>

<h1 id="Hello-World-Example">Hello World Example</h1>

<h2 id="install-mojo">install mojo</h2>

<pre><code>    sudo cpanm Mojolicious</code></pre>

<h2 id="bootstrap-a-mojo-application">bootstrap a mojo application</h2>

<pre><code>    mkdir myapp
    cd myapp
    mojo generate lite_app myapp.pl
    </code></pre>

<h2 id="define-routes">define routes</h2>

<pre><code>    $ nano myapp.pl

    #!/usr/bin/env perl
    use Mojolicious::Lite;
    
    get &#39;/&#39; =&gt; sub {
      my $c = shift;
      $c-&gt;render(text =&gt; &#39;ROOT&#39;);
    };
    
    
    post &#39;/hello&#39; =&gt; sub {
      my $c = shift;
      $c-&gt;render(text =&gt; &#39;HELLO&#39;);
    };
    
    get &#39;/hello/world&#39; =&gt; sub {
      my $c = shift;
      $c-&gt;render(text =&gt; &#39;HELLO WORLD&#39;);
    };
    
    app-&gt;start;
    

    $ ./myapp.pl routes
    /             GET
    /hello        POST  hello
    /hello/world  GET   helloworld</code></pre>

<h1 id="install-Mojolicious::Command::swat">install Mojolicious::Command::swat</h1>

<pre><code>    sudo cpanm Mojolicious::Command::swat    </code></pre>

<h2 id="bootstrap-swat-tests">bootstrap swat tests</h2>

<pre><code>    $ ./myapp.pl swat
    generate swat route for / ...
    generate swat data for GET / ...
    generate swat route for /hello ...
    generate swat data for POST /hello ...
    generate swat route for /hello/world ...
    generate swat data for GET /hello/world ...</code></pre>

<h2 id="specify-routes-checks">specify routes checks</h2>

<p>This phase might be skipped as preliminary `200 OK` checks are already added on bootstrap phase. But you may define ones more. For complete documentation on *how to write swat tests* please visit https://github.com/melezhik/swat</p>

<pre><code>    $ echo ROOT &gt;&gt; swat/get.txt
    $ echo HELLO &gt;&gt; swat/hello/post.txt
    $ echo HELLO WORLD &gt;&gt; swat/hello/world/get.txt</code></pre>

<h2 id="start-mojo-application">start mojo application</h2>

<pre><code>    $ morbo ./myapp.pl
    Server available at http://127.0.0.1:3000</code></pre>

<h2 id="install-swat">install swat</h2>

<pre><code>    sudo cpanm swat</code></pre>

<h2 id="run-swat-tests">run swat tests</h2>

<pre><code>    $ swat ./swat/  http://127.0.0.1:3000
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
        
    </code></pre>

<h1 id="SEE-ALSO">SEE ALSO</h1>

<p><a>Mojolicious</a>, <a>Mojolicious::Guides</a>, <a href="http://mojolicio.us">http://mojolicio.us</a>.</p>


</body>

</html>


