
package Angelos::Script::Command::Generate::Flavor::App;
use strict;
use warnings;
use base 'Module::Setup::Flavor';
1;

=head1

Angelos::Script::Command::Generate::Flavor::App - pack from app

=head1 SYNOPSIS

  Angelos::Script::Command::Generate::Flavor::App-setup --init --flavor-class=+Angelos::Script::Command::Generate::Flavor::App new_flavor

=cut

__DATA__

---
file: .gitignore
template: |+
  cover_db
  META.yml
  Makefile
  blib
  inc
  pm_to_blib
  Makefile.old

---
file: MANIFEST.SKIP
template: |
  \bRCS\b
  \bCVS\b
  ^MANIFEST\.
  ^Makefile$
  ~$
  ^#
  \.old$
  ^blib/
  ^pm_to_blib
  ^MakeMaker-\d
  \.gz$
  \.cvsignore
  ^t/9\d_.*\.t
  ^t/perlcritic
  ^tools/
  \.svn/
  ^[^/]+\.yaml$
  ^[^/]+\.pl$
  ^\.shipit$
---
file: README
template: |
  This is Perl module [% module %].
  
  INSTALLATION
  
  [% module %] installation is straightforward. If your CPAN shell is set up,
  you should just be able to do
  
      % cpan [% module %]
  
  Download it, unpack it, then build it as per the usual:
  
      % perl Makefile.PL
      % make && make test
  
  Then install it:
  
      % make install
  
  DOCUMENTATION
  
  [% module %] documentation is available as in POD. So you can do:
  
      % perldoc [% module %]
  
  to read the documentation online with your favorite pager.
  
  [% config.author %]
---
file: Changes
template: |
  Revision history for Perl extension [% module %]
  
  0.01    [% localtime %]
          - original version
---
file: Makefile.PL
template: |
  use inc::Module::Install;
  name '[% dist %]';
  all_from 'lib/[% module_path %].pm';
  
  tests 't/*.t t/unit/*.t t/integration/*.t';
  #author_tests 'xt';
  
  build_requires 'Test::More';
  use_test_base;
  auto_include;
  WriteAll;
---
file: conf/config.yaml
template: |
  ---
  components:
    controller:
      - module: A
  
  middlewares:
    - module: Encode
---
file: conf/routes.pl
template: |+
  HTTP::Router->define(
      sub {
          $_->match('/')->to( { controller => 'Root', action => 'index' } );
      }
  );

---
file: conf/log.yaml
template: |
  ---
  dispatchers:
    - screen
   
  screen:
    class: Log::Dispatch::Colorful
    min_level: debug
    stderr: 1
    format: '[%d] [%p] %m at %F line %L%n'
    color:
      info:
        text: green
      debug:
        text: red
        background: black
      error:
        text: yellow
        background: red
---
file: lib/____var-module_path-var____.pm
template: |
  package [% module %];
  use Angelos::Class;
  extends 'Angelos';
  
  our $VERSION = '0.01';
  
  __END_OF_CLASS__
  
  __END__
  
  =head1 NAME
  
  [% module %] -
  
  =head1 SYNOPSIS
  
    use [% module %];
  
  =head1 DESCRIPTION
  
  [% module %] is
  
  =head1 AUTHOR
  
  [% config.author %] E<lt>[% config.email %]E<gt>
  
  =head1 SEE ALSO
  
  =head1 REPOSITORY
  
    svn co http://svn.coderepos.org/share/lang/perl/[% dist %]/trunk [% dist %]
  
  [% module %] is Subversion repository is hosted at L<http://coderepos.org/share/>.
  patches and collaborators are welcome.
  
  =head1 LICENSE
  
  This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.
  
  =cut
---
file: lib/____var-module_path-var____/Config.pm
template: |
  package [% module %]::Config;
  use base 'Angelos::Config';
  use Angelos::ProjectStructure;
  
  sub config_file {
      Angelos::ProjectStructure->new( home => [% module %]::Home->instance )
          ->config_file;
  }
  
  1;
---
file: lib/____var-module_path-var____/Logger.pm
template: |
  package [% module %]::Logger;
  use base 'Angelos::Logger';
  use Angelos::ProjectStructure;
  use [% module %]::Home;
  
  sub app_class { '[% module %]'; }
  
  sub logger_config_file {
      Angelos::ProjectStructure->new( home => [% module %]::Home->instance )
          ->logger_config_file;
  }
  
  1;
---
file: lib/____var-module_path-var____/Schema.pm
template: |
  package [% module %]::Schema;
  use Mouse;
  use [% module %]::Config;
  extends qw(DBIx::Class::Schema);
  
  sub master {
      my $class        = shift;
      my $connect_info = $class->config->{'Model::DBIC'}{'connect_info'};
      my $schema       = $class->connect( @{$connect_info} );
      return $schema;
  }
  
  sub slave {
      my $class = shift;
      return unless $class->config->{'Model::DBIC::Slave'};
      my $connect_info = $class->config->{'Model::DBIC::Slave'}{'connect_info'};
      my $schema       = $class->connect( @{$connect_info} );
      return $schema;
  }
  
  sub config {
      [% module %]::Config->instance;
  }
  
  no Mouse;
  __PACKAGE__->meta->make_immutable;
  1;
---
file: lib/____var-module_path-var____/Home.pm
template: |
  package [% module %]::Home;
  use base 'Angelos::Home';
  
  sub app_class { '[% module %]'; }
  
  1;
---
file: lib/____var-module_path-var____/CLI.pm
template: |
  package [% module %]::CLI;
  use base qw(Angelos::CLI);
  
  1;
---
file: lib/____var-module_path-var____/Role/HomeAware.pm
template: |
  package [% module %]::Role::HomeAware;
  use Mouse::Role;
  use [% module %]::Home;
  
  sub home {
      [% module %]::Home->instance;
  }
  
  1;
---
file: lib/____var-module_path-var____/Role/SchemaAware.pm
template: |
  package [% module %]::Role::SchemaAware;
  use Mouse::Role;
  
  has 'schema' => (
      is      => 'rw',
      default => sub {
          [% module %]::Schema->master;
      },
  );
  
  has 'slave_schema' => (
      is      => 'rw',
      default => sub {
          [% module %]::Schema->slave;
      },
  );
  
  1;
---
file: lib/____var-module_path-var____/Role/Configurable.pm
template: |
  package [% module %]::Role::Configurable;
  use Mouse::Role;
  use [% module %]::Config;
  
  sub config {
      [% module %]::Config->instance;
  }
  
  1;
---
file: lib/____var-module_path-var____/Role/Loggable.pm
template: |
  package TestApp::Role::Loggable;
  use Mouse::Role;
  use [% module %]::Logger;
  
  sub log {
      [% module %]::Logger->instance;
  }
  
  1;
---
file: lib/____var-module_path-var____/Web/View/TT.pm
template: |+
  package [% module %]::Web::View::TT;
  use Angelos::Class;
  extends 'Angelos::View::TT';
  
  __END_OF_CLASS__
  
  __END__
  

---
file: lib/____var-module_path-var____/Web/Controller/Root.pm
template: |+
  package [% module %]::Web::Controller::Root;
  use Angelos::Class;
  extends 'Angelos::Controller';
  
  sub index {
      my ($self, $params) = @_;
      $self->render(params => {name => 'Yamada Taro'});
  }
  
  __END_OF_CLASS__
  
  __END__

---
dir: lib/____var-module_path-var____/Service/Base
---
file: lib/____var-module_path-var____/CLI/Command/Echo.pm
template: |
  package [% module %]::CLI::Command::Echo;
  use base qw(Angelos::CLI::Command);
  
  =head1 NAME
  
  [% module %]::CLI::Command::Echo - echo command 
  
  =head1 DESCRIPTION
  
      % cli echo --name Yamada  
  
  =cut
  
  sub opt_spec {
      return (
          [ "name=s", "your name" ],
      );
  }
  
  sub validate_args {
      my ( $self, $opt, $arg ) = @_;
  
      return if $opt->{name};
  
      my $name = $opt->{name};
      die "You need to give your name with name option\n"
          unless $name;
  }
  
  sub run {
      my ( $self, $opt, $arg ) = @_;
      my $name = $opt->{name};
      print $name . "\n";
  }
  
  1;
---
file: t/00_load_all.t
template: |+
  use strict;
  use warnings;
  use Test::More ();
  
  Test::More::plan('no_plan');
  
  use Module::Pluggable::Object;
  
  my $finder = Module::Pluggable::Object->new( search_path => ['[% module %]'], );
  
  foreach my $class (
      grep !
      /\.ToDo|[% module %]::Role/,
      sort do { local @INC = ('lib'); $finder->plugins }
      )
  {
      Test::More::use_ok($class);
  }

---
dir: t/unit
---
file: t/integration/01_basic.t
template: |+
  use strict;
  use warnings;
  use FindBin::libs;
  use Angelos::Test::Base;
  
  plan tests => 1 * blocks;
  
  run_tests;
  
  sub check_response {
      my ($response, $expected_response) = @_; 
      is $response->code, $expected_response->code;
  }
  
  sub test_application_class {
      '[% module %]';
  }
  
  __END__
  
  === one
  --- request
  method: GET
  path: /
  --- response
  code: 200

---
file: share/root/templates/root/index.tt
template: |
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
          <title>Welcome to the Angelos Web Framework!</title>
      </head>
      <body>
          <h2>Welcome to the Angelos Web Framework!</h2>
          <p> Hi [% name %] </p>
          <p> This page was generated from the template "templates/root/index.tt" </p>
      </body>
  </html>
---
dir: share/root/static/images
---
file: share/root/static/css/layout-1col.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-horizontal.css\");\r\n \r\n/* NAV BAR AT THE TOP AND ONE COLUMN OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 701px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        width: 100%;\r\n    }\r\n    div#local {\r\n        display: none;\r\n    }\r\n    div#sub {\r\n        display: none;\r\n    }\r\n    div#nav {\r\n        display: none;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/css/tools.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n/* clearing */\r\n    .stretch,\r\n    .clear {\r\n        clear: both;\r\n        height: 1px;\r\n        \r\n        margin: 0;\r\n        padding: 0;\r\n        \r\n        font-size: 15px;\r\n        line-height: 1px;\r\n    }\r\n    .clearfix:after {\r\n        clear: both;\r\n        height: 0;\r\n        \r\n        display: block;\r\n        visibility: hidden;\r\n        \r\n        content: \".\";\r\n    }\r\n    .clearfix {display:inline-block;}\r\n    /* Hide from IE Mac \\*/\r\n    .clearfix {display:block;}\r\n    /* End hide from IE Mac */\r\n/* end clearing */\r\n\r\n/* accessibility */\r\n     span.accesskey {\r\n         text-decoration: none;\r\n     }\r\n     .accessibility {\r\n         position: absolute;\r\n         top: -999em;\r\n         left: -999em;\r\n     }\r\n/* end accessibility */"
---
file: share/root/static/css/layout-navtop-3col.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-horizontal.css\");\r\n \r\n/* NAV BAR AT THE TOP, LOCAL NAV ON THE LEFT AND TWO COLUMNS OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 701px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        float: left;\r\n        width: 300px;\r\n        display: inline;\r\n        \r\n        margin-right: -200px;\r\n        margin-left: 200px;\r\n    }\r\n    div#sub {\r\n        float: right;\r\n        width: 180px;\r\n        display: inline;\r\n    }\r\n    div#local {\r\n        float: left; \r\n        width: 180px;\r\n        display: inline;\r\n        \r\n        margin-left: -300px;\r\n    }\r\n    div#nav {\r\n        position: absolute;\r\n        top: -15px;\r\n        left: 0;\r\n        width: 701px;\r\n        \r\n        text-align: left;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/css/reset-min.css
template: |-
  /*
  Copyright (c) 2008, Yahoo! Inc. All rights reserved.
  Code licensed under the BSD License:
  http://developer.yahoo.net/yui/license.txt
  version: 2.6.0
  */
  html{color:#000;background:#FFF;}body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td{margin:0;padding:0;}table{border-collapse:collapse;border-spacing:0;}fieldset,img{border:0;}address,caption,cite,code,dfn,em,strong,th,var{font-style:normal;font-weight:normal;}li{list-style:none;}caption,th{text-align:left;}h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal;}q:before,q:after{content:'';}abbr,acronym{border:0;font-variant:normal;}sup{vertical-align:text-top;}sub{vertical-align:text-bottom;}input,textarea,select{font-family:inherit;font-size:inherit;font-weight:inherit;}input,textarea,select{*font-size:100%;}legend{color:#000;}del,ins{text-decoration:none;}
---
file: share/root/static/css/nav-vertical.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n/* NAV */\r\n    div#nav {\r\n        font-size: 0.8em;\r\n    }\r\n    * html div#nav {\r\n        /* hide ie/mac \\*/\r\n        height: 1%;\r\n        /* end hide */\r\n    }\r\n    div#nav div.wrapper {\r\n        width: 100%;\r\n        \r\n        background: #ddd;\r\n    }\r\n    div#nav ul {\r\n        width: 100%;\r\n                \r\n        margin: 0;\r\n        padding: 0;\r\n        \r\n        line-height: 1em;\r\n        list-style: none;\r\n    }\r\n    div#nav li {\r\n        display: block;\r\n        \r\n        margin: 0;\r\n        padding: 0;\r\n        \r\n        list-style: none;\r\n        \r\n        line-height: 1em;\r\n    }\r\n    * html div#nav li {\r\n        /* hide ie/mac \\*/\r\n        height: 1%;\r\n        /* end hide */\r\n    }\r\n    div#nav li.last {\r\n        \r\n    }\r\n    div#nav a,\r\n    div#nav a:link,\r\n    div#nav a:active,\r\n    div#nav a:visited {\r\n        display: block;\r\n        \r\n        font-weight: bold;\r\n        text-decoration: none;\r\n        \r\n        margin: 0;\r\n        padding: 5px 10px 5px 10px;\r\n        \r\n        color: black;\r\n        background: white;\r\n    }\r\n    div#nav a:hover {\r\n        text-decoration: underline;\r\n        \r\n        color: white;\r\n        background: black;\r\n    }\r\n    div#nav strong {\r\n        display: block;\r\n        \r\n        color: white;\r\n        background: black;\r\n    }\r\n    div#nav strong a,\r\n    div#nav strong a:link,\r\n    div#nav strong a:active,\r\n    div#nav strong a:visited,\r\n    div#nav strong a:hover {\r\n       color: white;\r\n       background-color: black;\r\n    }\r\n/* END NAV */"
---
file: share/root/static/css/README
template: |
  * css framework
  http://www.contentwithstyle.co.uk/content/a-css-framework/#
  
  * YUI
---
file: share/root/static/css/layout.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n/* SITE SPECIFIC LAYOUT */\r\n    body {\r\n        margin: 0;\r\n        padding: 0;\r\n              \r\n        text-align: center;\r\n        \r\n        background: white;\r\n    }\r\n    div#page {\r\n        width: 780px;\r\n        \r\n        margin:  0 auto;\r\n        padding: 0;\r\n        \r\n        text-align: center;\r\n        \r\n        background: white;\r\n    }\r\n    \r\n    /* HEADER */\r\n        div#header {\r\n            margin: 0 0 5em 0;\r\n            padding: 40px 20px;\r\n            \r\n            color: white;\r\n            background: black;\r\n            \r\n            text-align: left;\r\n        }\r\n        div#branding {\r\n            float: left;\r\n            width: 40%;\r\n            \r\n            margin: 0;\r\n            padding: 10px 0 10px 20px;\r\n            \r\n            text-align: left;\r\n        }\r\n        div#search {\r\n            float: right;\r\n            width: 49%;\r\n            \r\n            margin: 0;\r\n            padding: 16px 20px 0 0;\r\n            \r\n            text-align: right;\r\n        }\r\n    /* END HEADER */\r\n    \r\n    \r\n    /* CONTENT */\r\n        div#content {\r\n            \r\n        }\r\n        \r\n        /* MAIN */\r\n            div#main {\r\n                \r\n            }\r\n        /* END MAIN */\r\n        \r\n        /* SUB */\r\n            div#sub {\r\n                \r\n            }\r\n        /* END SUB */\r\n        \r\n    /* END CONTENT */\r\n    \r\n    \r\n    /* FOOTER */\r\n        div#footer {\r\n            color: white;\r\n            background-color: black;\r\n        }\r\n        div#footer p {\r\n            margin: 0;\r\n            padding: 15px;\r\n            \r\n            font-size: 0.8em;\r\n        }\r\n    /* END FOOTER */\r\n/* END LAYOUT */\r\n\r\n\r\n/* UL.SUBNAV */\r\n    ul.subnav {\r\n        margin: 0;\r\n        padding: 0;\r\n        \r\n        font-size: 0.8em;\r\n        list-style: none;\r\n    }\r\n    ul.subnav li {\r\n        margin: 0 0 1em 0;\r\n        padding: 0;\r\n        \r\n        list-style: none;\r\n    }\r\n    ul.subnav li a,\r\n    ul.subnav li a:link,\r\n    ul.subnav li a:visited,\r\n    ul.subnav li a:active {\r\n        text-decoration: none;\r\n        font-weight: bold;\r\n        \r\n        color: black;\r\n    }\r\n    ul.subnav li a:hover {\r\n        text-decoration: underline;\r\n    }\r\n    ul.subnav li strong {\r\n        padding: 0 0 0 12px;\r\n        \r\n        background: url(\"../i/subnav-highlight.gif\") left top no-repeat transparent;\r\n    }\r\n    ul.subnav li strong a,\r\n    ul.subnav li strong a:link,\r\n    ul.subnav li strong a:visited,\r\n    ul.subnav li strong a:active {\r\n        color: white;\r\n        background-color: black;\r\n    }\r\n/* END UL.SUBNAV */\r\n"
---
file: share/root/static/css/layout-navtop-subright.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-horizontal.css\");\r\n \r\n/* NAV BAR AT THE TOP AND TWO COLUMNS OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 701px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        float: left;\r\n        width: 480px;\r\n        display: inline;\r\n    }\r\n    div#sub {\r\n        float: right;\r\n        width: 200px;\r\n        display: inline;\r\n    }\r\n    div#local {\r\n        display: none;\r\n    }\r\n    div#nav {\r\n        position: absolute;\r\n        top: -15px;\r\n        left: 0;\r\n        width: 100%;\r\n        \r\n        text-align: left;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/css/fonts-min.css
template: |-
  /*
  Copyright (c) 2008, Yahoo! Inc. All rights reserved.
  Code licensed under the BSD License:
  http://developer.yahoo.net/yui/license.txt
  version: 2.6.0
  */
  body{font:13px/1.231 arial,helvetica,clean,sans-serif;*font-size:small;*font:x-small;}select,input,button,textarea{font:99% arial,helvetica,clean,sans-serif;}table{font-size:inherit;font:100%;}pre,code,kbd,samp,tt{font-family:monospace;*font-size:108%;line-height:100%;}
---
file: share/root/static/css/layout-navleft-2col.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-vertical.css\");\r\n\r\n/* NAV BAR ON THE LEFT AND TWO COLUMNS OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 780px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        float: right;\r\n        width: 340px;\r\n        display: inline;\r\n        \r\n        margin-right: 220px;\r\n        margin-left: -220px;\r\n    }\r\n    div#local {\r\n        display: none;\r\n    }\r\n    div#sub {\r\n        float: right;\r\n        width: 200px;\r\n        display: inline;\r\n        \r\n        margin-right: -340px;\r\n        margin-left: 200px;\r\n    }\r\n    div#nav {\r\n        float: left;\r\n        width: 200px;\r\n        display: inline;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/css/layout-navtop-localleft.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-horizontal.css\");\r\n\r\n/* NAV BAR AT THE TOP, LOCAL NAVIGATION ON THE LEFT AND ONE COLUMN OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 701px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        float: right;\r\n        width: 500px;\r\n        display: inline;\r\n    }\r\n    div#local {\r\n        float: left;\r\n        width: 200px;\r\n        display: inline;\r\n    }\r\n    div#sub {\r\n        display: none;\r\n    }\r\n    div#nav {\r\n        position: absolute;\r\n        top: -15px;\r\n        left: 0;\r\n        width: 100%;\r\n        \r\n        text-align: left;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/css/layout-navleft-1col.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-vertical.css\");\r\n\r\n/* NAV BAR ON THE LEFT AND ONE COLUMN OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 780px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        float: right;\r\n        width: 560px;\r\n        display: inline;\r\n    }\r\n    div#local {\r\n        display: none;\r\n    }\r\n    div#sub {\r\n        display: none;\r\n    }\r\n    div#nav {\r\n        float: left;\r\n        width: 200px;\r\n        display: inline;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/css/forms.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n/* FORM ELEMENTS */\r\n    form {\r\n        margin:0;\r\n        padding:0;\r\n    }\r\n    form div,\r\n    form p {\r\n        margin: 0 0 1em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1em;\r\n    }\r\n    label {\r\n        font-weight: bold;\r\n    }\r\n    fieldset {\r\n        padding: 5px 10px;\r\n        margin: 0 0 1.5em 0;\r\n        \r\n        border: 1px solid #eee;\r\n    }\r\n    fieldset legend {\r\n        margin: 0 0 0 0px;\r\n        padding: 0;\r\n        \r\n        font-size: 1.1em;\r\n        font-weight: bold;\r\n        \r\n        color: #666;\r\n        background-color: white;\r\n    }\r\n    * html fieldset legend {\r\n        margin: 0 0 10px -10px;\r\n    }\r\n    fieldset ul {\r\n        margin: 0 0 1.5em 0;\r\n        padding: 0;\r\n        \r\n        list-style: none;\r\n    }\r\n    fieldset ul li {\r\n        margin: 0 0 0.5em 0;\r\n        padding: 0;\r\n        \r\n        list-style: none;\r\n    }\r\n    input, select, textarea {\r\n        margin: 0;\r\n        padding: 2px;\r\n        \r\n        font-size: 1em; \r\n        font-family: arial, helvetica, verdana, sans-serif;\r\n    }\r\n    \r\n    input, select {\r\n        vertical-align: middle;\r\n    }\r\n    textarea {\r\n        width: 200px;\r\n        height: 8em;\r\n    }\r\n    \r\n    input.check {\r\n        width: auto;\r\n        height: auto;\r\n        \r\n        margin: 0;\r\n        \r\n        border: none;\r\n    }\r\n    input.radio {\r\n        width: auto;\r\n        \r\n        height: auto;\r\n        margin: 0;\r\n        \r\n        border: none;\r\n    }\r\n    input.file {\r\n        width: 250px;\r\n        height: auto;\r\n    }\r\n    input.readonly {\r\n        background-color: transparent;\r\n        border: none;\r\n    }\r\n    input.button {\r\n        width: 10em;\r\n        \r\n        background-color: #ddd;\r\n        border: 1px solid black;\r\n    }\r\n    input.image {\r\n        width: auto;\r\n        height: auto;\r\n        \r\n        border: none;\r\n    }\r\n    \r\n    form div.submit {\r\n        margin: 1em 0;\r\n    }\r\n    form div.submit input {\r\n        width: 15em;\r\n        height: 2em;\r\n    }\r\n/* END FORM ELEMENTS */"
---
file: share/root/static/css/framework.html
template: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \r\n    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n    \r\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\r\n<head>\r\n    <title>CSS Framework example</title>\r\n    <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf=8\" />\r\n        \r\n    <style type=\"text/css\" media=\"screen\">\r\n        @import url(\"static/css/reset-min.css\");\r\n        @import url(\"static/css/fonts-min.css\");\r\n        @import url(\"static/css/tools.css\");\r\n        @import url(\"static/css/typo.css\");\r\n        @import url(\"static/css/forms.css\");\r\n        /* swap layout stylesheet: \r\n        layout-navtop-localleft.css\r\n        layout-navtop-subright.css\r\n        layout-navtop-3col.css\r\n        layout-navtop-1col.css\r\n        layout-navleft-1col.css\r\n        layout-navleft-2col.css*/\r\n        @import url(\"static/css/layout-navtop-localleft.css\");\r\n        @import url(\"static/css/layout.css\");\r\n    </style>\r\n</head>\r\n\r\n<body id=\"page-home\">\r\n    \r\n    <div id=\"page\">\r\n    \r\n        <div id=\"header\" class=\"clearfix\">\r\n        \r\n            <div id=\"branding\">\r\n                <img src=\"i/logo.gif\" alt=\"Content with Style: Web Technique\" />\r\n            </div><!-- end branding -->\r\n            \r\n            <div id=\"search\">\r\n                <form method=\"post\" action=\"\">\r\n                    <div><label for=\"search-site\">Search</label>\r\n                    <input type=\"text\" name=\"search\" id=\"search-site\" />\r\n                    <input type=\"submit\" value=\"go\" name=\"search\" id=\"submit\" /></div>\r\n                </form>\r\n            </div><!-- end search -->\r\n                \r\n            <hr />\r\n        </div><!-- end header -->\r\n        \r\n        \r\n        <div id=\"content\" class=\"clearfix\">\r\n        \r\n            <div id=\"main\">\r\n                <h1>Main</h1>\r\n                \r\n                <h2>Subheading</h2>\r\n                <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut ac leo in lorem ultricies sollicitudin. Vivamus molestie elit nec nulla. Suspendisse potenti. Suspendisse at lorem. Donec pulvinar, magna eget molestie pretium, justo sem iaculis urna, eget condimentum nibh augue pellentesque arcu. Integer tristique tempor mauris. Sed justo orci, commodo volutpat, sagittis vitae, varius vitae, massa. Maecenas pede ligula, iaculis sit amet, pharetra eu, adipiscing consectetuer, eros. Duis ullamcorper nisl ac magna. Nunc neque dolor, posuere dapibus, convallis non, tristique sed, nibh. Suspendisse quis leo. Phasellus pretium erat ut purus. Duis facilisis consectetuer sapien. Nulla eget pede ut nisl faucibus consequat. Quisque erat lectus, luctus in, pellentesque ac, adipiscing eu, enim. Donec ultrices laoreet urna.</p>\r\n                \r\n                <h2>Subheading</h2>\r\n                <p>Pellentesque ac odio et nulla adipiscing fermentum. Proin nibh lorem, rhoncus et, commodo non, consequat vitae, sem. Donec a orci. Sed a wisi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer nulla enim, ornare volutpat, semper et, malesuada ut, sapien. Vestibulum convallis, est sed lacinia accumsan, felis ipsum sollicitudin est, a dapibus dui dui dictum neque. In hac habitasse platea dictumst. Donec non mi. Phasellus facilisis, est ornare facilisis rhoncus, nisl velit malesuada urna, et adipiscing elit enim vitae metus. Maecenas dapibus. Sed erat. Nulla congue wisi sit amet dui.</p>\r\n                <p>Vestibulum vitae tellus. Fusce quis ligula. Cras mi. Mauris congue, lacus eget rhoncus venenatis, mi nunc volutpat nisl, ut ornare erat augue quis mauris. Nulla in sem. Donec semper odio ac ante. Cras a libero in risus mattis commodo. Phasellus pellentesque lectus. Donec a mi. Integer euismod neque at arcu. Morbi ligula nulla, dapibus nec, fermentum ut, tristique vel, pede. Morbi at diam. Vestibulum quam. Cras consectetuer wisi id neque. Etiam dictum vulputate ligula. Aliquam erat volutpat. Proin vitae lorem in justo imperdiet nonummy. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Suspendisse leo. Sed in eros ut lectus lacinia condimentum. </p>\r\n                \r\n                <hr />\r\n            </div><!-- end main -->\r\n            \r\n            <div id=\"sub\">\r\n            \r\n                <h2>Sub</h2>\r\n                <p>Proin pellentesque ullamcorper ipsum. Sed tincidunt tincidunt mi. Vestibulum magna wisi, vehicula eu, ullamcorper et, egestas in, tortor. Vestibulum interdum, massa in faucibus laoreet, tortor massa congue ligula, et feugiat elit mauris nec enim. Phasellus pellentesque tellus nec nisl. Mauris dignissim iaculis leo. Maecenas id lorem. Aenean tortor eros, dignissim eu, vehicula id, dictum eu, neque. Maecenas nisl. Proin dui lacus, aliquam eget, volutpat vel, aliquam quis, velit. Proin neque. Etiam turpis odio, tincidunt id, accumsan tincidunt, mollis a, nibh. Donec porta.</p>\r\n                \r\n            </div><!-- end sub -->\r\n            \r\n            \r\n            <div id=\"local\">\r\n                <h2>Local</h2>\r\n                <ul>\r\n                    <li><a href=\"somewhere.html\">Content page 1</a></li>\r\n                    <li><a href=\"somewhere.html\">Content page 2</a></li>\r\n                    <li><a href=\"somewhere.html\">Content page 3</a></li>\r\n                    <li><a href=\"somewhere.html\">Content page 4</a></li>\r\n                    <li><a href=\"somewhere.html\">Content page 5</a></li>\r\n                    <li><a href=\"somewhere.html\">Content page 6</a></li>\r\n                </ul>\r\n                \r\n            </div><!-- end local -->\r\n            \r\n            \r\n            <div id=\"nav\">\r\n                <div class=\"wrapper\">\r\n                <h2 class=\"accessibility\">Navigation</h2>\r\n                <ul class=\"clearfix\">\r\n                     <li><strong><a href=\"home.html\">Home</a></strong></li>\r\n                     <li><a href=\"articles.html\">Articles</a></li>\r\n                     <li><a href=\"archive.html\">Archive</a></li>\r\n                     <li><a href=\"photos.html\">Photos</a></li>\r\n                     <li><a href=\"about.html\">About</a></li>\r\n                     <li class=\"last\"><a href=\"contact.html\">Contact</a></li>\r\n                </ul>\r\n                </div>\r\n                <hr />\r\n            </div><!-- end nav -->\r\n            \r\n        </div><!-- end content -->\r\n        \r\n        \r\n        <div id=\"footer\" class=\"clearfix\">\r\n            <p>&copy; Copyright 2005 Nobody</p>\r\n        </div><!-- end footer -->\r\n        \r\n    </div><!-- end page -->\r\n    \r\n    <div id=\"extra1\">&nbsp;</div>\r\n    <div id=\"extra2\">&nbsp;</div>\r\n    \r\n</body>\r\n</html>\r\n"
---
file: share/root/static/css/typo.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n/* TYPOGRAPHY */\r\n    body {\r\n        text-align: left;\r\n        font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\r\n        font-size: 76%;\r\n        line-height: 1em;\r\n        \r\n        color: #333;\r\n    }\r\n    div {\r\n        font-size: 1em;\r\n    }\r\n    img {\r\n        border: 0;\r\n    }\r\n    \r\n/* LINKS */\r\n    a,\r\n    a:link,\r\n    a:active {\r\n        text-decoration: underline;\r\n        \r\n        color: blue;\r\n        background-color: white;\r\n    }\r\n    a:visited {\r\n        color: purple;\r\n        background-color: transparent;\r\n    }\r\n    a:hover {\r\n        text-decoration: none;\r\n        \r\n        color: white;\r\n        background-color: black;\r\n    }\r\n/* END LINKS */\r\n    \r\n/* HEADINGS */\r\n    h1 {\r\n        margin: 0 0 0.5em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 2em;\r\n        line-height: 1.5em;\r\n        \r\n        color: black;\r\n    }\r\n    h2 {\r\n        margin: 0 0 0.5em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1.5em;\r\n        line-height: 1.5em;\r\n        \r\n        color: black;\r\n    }\r\n    h3 {\r\n        margin: 0 0 0.5em 0;\r\n        padding:0;\r\n        \r\n        font-size: 1.3em;\r\n        line-height: 1.3em;\r\n        \r\n        color: black;\r\n    }\r\n    h4 {\r\n        margin: 0 0 0.25em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1.2em;\r\n        line-height: 1.3em;\r\n        \r\n        color: black;\r\n    }\r\n    h5 {\r\n        margin: 0 0 0.25em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1.1em;\r\n        line-height: 1.3em;\r\n        \r\n        color: black;\r\n    }\r\n    h6 {\r\n        margin: 0 0 0.25em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1em;\r\n        line-height: 1.3em;\r\n        \r\n        color: black;\r\n    }\r\n/* END HEADINGS */\r\n\r\n/* TEXT */\r\n    p {\r\n        margin: 0 0 1.5em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1em;\r\n        line-height:1.4em;\r\n    }\r\n    blockquote {\r\n        margin-left: 10px;\r\n        \r\n        border-left: 10px solid #ddd;\r\n    }\r\n    pre {\r\n        font-family: monospace;\r\n        font-size: 1.0em;\r\n    }\r\n    strong, b {\r\n        font-weight: bold;\r\n    }\r\n    em, i {\r\n        font-style:italic;\r\n    }\r\n    code {\r\n        font-family: \"Courier New\", Courier, monospace;\r\n        font-size: 1em;\r\n        white-space: pre;\r\n    }\r\n/* END TEXT */\r\n    \r\n/* LISTS */\r\n    ul {\r\n        margin: 0 0 1.5em 0;\r\n        padding: 0;\r\n        \r\n        line-height:1.4em;\r\n    }\r\n    ul li {\r\n        margin: 0 0 0.25em 30px;\r\n        padding: 0;\r\n    }\r\n    ol {\r\n        margin: 0 0 1.5em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1.0em;\r\n        line-height: 1.4em;\r\n    }\r\n    ol li {\r\n        margin: 0 0 0.25em 30px;\r\n        padding: 0;\r\n        \r\n        font-size: 1.0em;\r\n    }\r\n    dl {\r\n        margin: 0 0 1.5em 0;\r\n        padding: 0;\r\n        \r\n        line-height: 1.4em;\r\n    }\r\n    dl dt {\r\n        margin: 0.25em 0 0.25em 0;\r\n        padding: 0;\r\n        \r\n        font-weight: bold;\r\n    }\r\n    dl dd {\r\n        margin: 0 0 0 30px;\r\n        padding: 0;\r\n    }\r\n/* END LISTS */\r\n    \r\n    \r\n/* TABLE */\r\n    table {\r\n        margin: 0 0 1.5em 0;\r\n        padding: 0;\r\n        \r\n        font-size: 1em;\r\n    }\r\n    table caption {\r\n        margin: 0;\r\n        padding: 0 0 1.5em 0;\r\n        \r\n        font-weight: bold;\r\n    }\r\n    th {\r\n        font-weight: bold;\r\n        text-align: left;\r\n    }\r\n    td {\r\n        font-size: 1em;\r\n    }\r\n/* END TABLE */    \r\n    \r\n    hr {\r\n        display: none;\r\n    }\r\n    div.hr {\r\n        height: 1px;\r\n        \r\n        margin: 1.5em 10px;\r\n        \r\n        border-bottom: 1px dotted black;\r\n    }\r\n    \r\n/* END TYPOGRAPHY */    "
---
file: share/root/static/css/nav-horizontal.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n/* NAV */\r\n    div#nav {\r\n        font-size: 0.8em;\r\n    }\r\n    * html div#nav {\r\n        /* hide ie/mac \\*/\r\n        height: 1%;\r\n        /* end hide */\r\n    }\r\n    div#nav div.wrapper {\r\n        position: absolute;\r\n        left: 0;\r\n        bottom: 0;\r\n        width: 100%;\r\n    }\r\n    div#nav ul {\r\n        width: 100%;\r\n                \r\n        margin: 0;\r\n        padding: 0;\r\n        \r\n        line-height: 1em;\r\n        list-style: none;\r\n    }\r\n    div#nav li {\r\n        float: left;\r\n        display: inline;\r\n        \r\n        margin: 0;\r\n        padding: 0;\r\n        \r\n        list-style: none;\r\n        \r\n        line-height: 1em;\r\n        border-right: 1px solid #aaa;\r\n    }\r\n    div#nav li.last {\r\n        border-right: none;\r\n    }\r\n    div#nav a,\r\n    div#nav a:link,\r\n    div#nav a:active,\r\n    div#nav a:visited {\r\n        display: inline-block;\r\n        /* hide from ie/mac \\*/\r\n        display: block;\r\n        /* end hide */\r\n        \r\n        margin: 0;\r\n        padding: 5px 38px 5px 38px;\r\n        \r\n        font-weight: bold;\r\n        text-decoration: none;\r\n        \r\n        color: black;\r\n        background: #ddd;\r\n    }\r\n    div#nav a:hover {\r\n        text-decoration: underline;\r\n    }\r\n    div#nav strong {\r\n        display: inline-block;\r\n        /* hide from ie/mac \\*/\r\n        display: block;\r\n        /* end hide */\r\n        \r\n        color: white;\r\n        background: black;\r\n    }\r\n    div#nav strong a,\r\n    div#nav strong a:link,\r\n    div#nav strong a:active,\r\n    div#nav strong a:visited,\r\n    div#nav strong a:hover {\r\n       color: white;\r\n       background-color: black;\r\n    }\r\n/* END NAV */"
---
file: share/root/static/css/layout-navtop-1col.css
template: "/* \r\nA CSS Framework by Mike Stenhouse of Content with Style \r\n-------------------------------------------------------\r\n\r\nCopyright (c) 2005, Mike Stenhouse of Content with Style\r\n\r\nAll rights reserved.\r\n\r\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\n\r\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\n    * Neither the name of CSS Framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\r\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\r\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\r\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR\r\nCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,\r\nEXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,\r\nPROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR\r\nPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF\r\nLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING\r\nNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\r\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\n*/\r\n\r\n@import url(\"nav-horizontal.css\");\r\n \r\n/* NAV BAR AT THE TOP AND ONE COLUMN OF CONTENT */\r\n    div#content {\r\n        position: relative;\r\n        width: 701px;\r\n        \r\n        margin: 0 auto 20px auto;\r\n        padding: 0;\r\n        \r\n        text-align: left;\r\n    }\r\n    div#main {\r\n        width: 100%;\r\n    }\r\n    div#local {\r\n        width: 100%;\r\n    }\r\n    div#sub {\r\n        width: 100%;\r\n    }\r\n    div#nav {\r\n        position: absolute;\r\n        top: -15px;\r\n        left: 0;\r\n        width: 100%;\r\n        \r\n        text-align: left;\r\n    }\r\n/* END CONTENT */"
---
file: share/root/static/js/jquery-1.2.6.min.js
template: |-
  /*
   * jQuery 1.2.6 - New Wave Javascript
   *
   * Copyright (c) 2008 John Resig (jquery.com)
   * Dual licensed under the MIT (MIT-LICENSE.txt)
   * and GPL (GPL-LICENSE.txt) licenses.
   *
   * $Date: 2008-05-24 14:22:17 -0400 (Sat, 24 May 2008) $
   * $Rev: 5685 $
   */
  (function(){var _jQuery=window.jQuery,_$=window.$;var jQuery=window.jQuery=window.$=function(selector,context){return new jQuery.fn.init(selector,context);};var quickExpr=/^[^<]*(<(.|\s)+>)[^>]*$|^#(\w+)$/,isSimple=/^.[^:#\[\.]*$/,undefined;jQuery.fn=jQuery.prototype={init:function(selector,context){selector=selector||document;if(selector.nodeType){this[0]=selector;this.length=1;return this;}if(typeof selector=="string"){var match=quickExpr.exec(selector);if(match&&(match[1]||!context)){if(match[1])selector=jQuery.clean([match[1]],context);else{var elem=document.getElementById(match[3]);if(elem){if(elem.id!=match[3])return jQuery().find(selector);return jQuery(elem);}selector=[];}}else
  return jQuery(context).find(selector);}else if(jQuery.isFunction(selector))return jQuery(document)[jQuery.fn.ready?"ready":"load"](selector);return this.setArray(jQuery.makeArray(selector));},jquery:"1.2.6",size:function(){return this.length;},length:0,get:function(num){return num==undefined?jQuery.makeArray(this):this[num];},pushStack:function(elems){var ret=jQuery(elems);ret.prevObject=this;return ret;},setArray:function(elems){this.length=0;Array.prototype.push.apply(this,elems);return this;},each:function(callback,args){return jQuery.each(this,callback,args);},index:function(elem){var ret=-1;return jQuery.inArray(elem&&elem.jquery?elem[0]:elem,this);},attr:function(name,value,type){var options=name;if(name.constructor==String)if(value===undefined)return this[0]&&jQuery[type||"attr"](this[0],name);else{options={};options[name]=value;}return this.each(function(i){for(name in options)jQuery.attr(type?this.style:this,name,jQuery.prop(this,options[name],type,i,name));});},css:function(key,value){if((key=='width'||key=='height')&&parseFloat(value)<0)value=undefined;return this.attr(key,value,"curCSS");},text:function(text){if(typeof text!="object"&&text!=null)return this.empty().append((this[0]&&this[0].ownerDocument||document).createTextNode(text));var ret="";jQuery.each(text||this,function(){jQuery.each(this.childNodes,function(){if(this.nodeType!=8)ret+=this.nodeType!=1?this.nodeValue:jQuery.fn.text([this]);});});return ret;},wrapAll:function(html){if(this[0])jQuery(html,this[0].ownerDocument).clone().insertBefore(this[0]).map(function(){var elem=this;while(elem.firstChild)elem=elem.firstChild;return elem;}).append(this);return this;},wrapInner:function(html){return this.each(function(){jQuery(this).contents().wrapAll(html);});},wrap:function(html){return this.each(function(){jQuery(this).wrapAll(html);});},append:function(){return this.domManip(arguments,true,false,function(elem){if(this.nodeType==1)this.appendChild(elem);});},prepend:function(){return this.domManip(arguments,true,true,function(elem){if(this.nodeType==1)this.insertBefore(elem,this.firstChild);});},before:function(){return this.domManip(arguments,false,false,function(elem){this.parentNode.insertBefore(elem,this);});},after:function(){return this.domManip(arguments,false,true,function(elem){this.parentNode.insertBefore(elem,this.nextSibling);});},end:function(){return this.prevObject||jQuery([]);},find:function(selector){var elems=jQuery.map(this,function(elem){return jQuery.find(selector,elem);});return this.pushStack(/[^+>] [^+>]/.test(selector)||selector.indexOf("..")>-1?jQuery.unique(elems):elems);},clone:function(events){var ret=this.map(function(){if(jQuery.browser.msie&&!jQuery.isXMLDoc(this)){var clone=this.cloneNode(true),container=document.createElement("div");container.appendChild(clone);return jQuery.clean([container.innerHTML])[0];}else
  return this.cloneNode(true);});var clone=ret.find("*").andSelf().each(function(){if(this[expando]!=undefined)this[expando]=null;});if(events===true)this.find("*").andSelf().each(function(i){if(this.nodeType==3)return;var events=jQuery.data(this,"events");for(var type in events)for(var handler in events[type])jQuery.event.add(clone[i],type,events[type][handler],events[type][handler].data);});return ret;},filter:function(selector){return this.pushStack(jQuery.isFunction(selector)&&jQuery.grep(this,function(elem,i){return selector.call(elem,i);})||jQuery.multiFilter(selector,this));},not:function(selector){if(selector.constructor==String)if(isSimple.test(selector))return this.pushStack(jQuery.multiFilter(selector,this,true));else
  selector=jQuery.multiFilter(selector,this);var isArrayLike=selector.length&&selector[selector.length-1]!==undefined&&!selector.nodeType;return this.filter(function(){return isArrayLike?jQuery.inArray(this,selector)<0:this!=selector;});},add:function(selector){return this.pushStack(jQuery.unique(jQuery.merge(this.get(),typeof selector=='string'?jQuery(selector):jQuery.makeArray(selector))));},is:function(selector){return!!selector&&jQuery.multiFilter(selector,this).length>0;},hasClass:function(selector){return this.is("."+selector);},val:function(value){if(value==undefined){if(this.length){var elem=this[0];if(jQuery.nodeName(elem,"select")){var index=elem.selectedIndex,values=[],options=elem.options,one=elem.type=="select-one";if(index<0)return null;for(var i=one?index:0,max=one?index+1:options.length;i<max;i++){var option=options[i];if(option.selected){value=jQuery.browser.msie&&!option.attributes.value.specified?option.text:option.value;if(one)return value;values.push(value);}}return values;}else
  return(this[0].value||"").replace(/\r/g,"");}return undefined;}if(value.constructor==Number)value+='';return this.each(function(){if(this.nodeType!=1)return;if(value.constructor==Array&&/radio|checkbox/.test(this.type))this.checked=(jQuery.inArray(this.value,value)>=0||jQuery.inArray(this.name,value)>=0);else if(jQuery.nodeName(this,"select")){var values=jQuery.makeArray(value);jQuery("option",this).each(function(){this.selected=(jQuery.inArray(this.value,values)>=0||jQuery.inArray(this.text,values)>=0);});if(!values.length)this.selectedIndex=-1;}else
  this.value=value;});},html:function(value){return value==undefined?(this[0]?this[0].innerHTML:null):this.empty().append(value);},replaceWith:function(value){return this.after(value).remove();},eq:function(i){return this.slice(i,i+1);},slice:function(){return this.pushStack(Array.prototype.slice.apply(this,arguments));},map:function(callback){return this.pushStack(jQuery.map(this,function(elem,i){return callback.call(elem,i,elem);}));},andSelf:function(){return this.add(this.prevObject);},data:function(key,value){var parts=key.split(".");parts[1]=parts[1]?"."+parts[1]:"";if(value===undefined){var data=this.triggerHandler("getData"+parts[1]+"!",[parts[0]]);if(data===undefined&&this.length)data=jQuery.data(this[0],key);return data===undefined&&parts[1]?this.data(parts[0]):data;}else
  return this.trigger("setData"+parts[1]+"!",[parts[0],value]).each(function(){jQuery.data(this,key,value);});},removeData:function(key){return this.each(function(){jQuery.removeData(this,key);});},domManip:function(args,table,reverse,callback){var clone=this.length>1,elems;return this.each(function(){if(!elems){elems=jQuery.clean(args,this.ownerDocument);if(reverse)elems.reverse();}var obj=this;if(table&&jQuery.nodeName(this,"table")&&jQuery.nodeName(elems[0],"tr"))obj=this.getElementsByTagName("tbody")[0]||this.appendChild(this.ownerDocument.createElement("tbody"));var scripts=jQuery([]);jQuery.each(elems,function(){var elem=clone?jQuery(this).clone(true)[0]:this;if(jQuery.nodeName(elem,"script"))scripts=scripts.add(elem);else{if(elem.nodeType==1)scripts=scripts.add(jQuery("script",elem).remove());callback.call(obj,elem);}});scripts.each(evalScript);});}};jQuery.fn.init.prototype=jQuery.fn;function evalScript(i,elem){if(elem.src)jQuery.ajax({url:elem.src,async:false,dataType:"script"});else
  jQuery.globalEval(elem.text||elem.textContent||elem.innerHTML||"");if(elem.parentNode)elem.parentNode.removeChild(elem);}function now(){return+new Date;}jQuery.extend=jQuery.fn.extend=function(){var target=arguments[0]||{},i=1,length=arguments.length,deep=false,options;if(target.constructor==Boolean){deep=target;target=arguments[1]||{};i=2;}if(typeof target!="object"&&typeof target!="function")target={};if(length==i){target=this;--i;}for(;i<length;i++)if((options=arguments[i])!=null)for(var name in options){var src=target[name],copy=options[name];if(target===copy)continue;if(deep&&copy&&typeof copy=="object"&&!copy.nodeType)target[name]=jQuery.extend(deep,src||(copy.length!=null?[]:{}),copy);else if(copy!==undefined)target[name]=copy;}return target;};var expando="jQuery"+now(),uuid=0,windowData={},exclude=/z-?index|font-?weight|opacity|zoom|line-?height/i,defaultView=document.defaultView||{};jQuery.extend({noConflict:function(deep){window.$=_$;if(deep)window.jQuery=_jQuery;return jQuery;},isFunction:function(fn){return!!fn&&typeof fn!="string"&&!fn.nodeName&&fn.constructor!=Array&&/^[\s[]?function/.test(fn+"");},isXMLDoc:function(elem){return elem.documentElement&&!elem.body||elem.tagName&&elem.ownerDocument&&!elem.ownerDocument.body;},globalEval:function(data){data=jQuery.trim(data);if(data){var head=document.getElementsByTagName("head")[0]||document.documentElement,script=document.createElement("script");script.type="text/javascript";if(jQuery.browser.msie)script.text=data;else
  script.appendChild(document.createTextNode(data));head.insertBefore(script,head.firstChild);head.removeChild(script);}},nodeName:function(elem,name){return elem.nodeName&&elem.nodeName.toUpperCase()==name.toUpperCase();},cache:{},data:function(elem,name,data){elem=elem==window?windowData:elem;var id=elem[expando];if(!id)id=elem[expando]=++uuid;if(name&&!jQuery.cache[id])jQuery.cache[id]={};if(data!==undefined)jQuery.cache[id][name]=data;return name?jQuery.cache[id][name]:id;},removeData:function(elem,name){elem=elem==window?windowData:elem;var id=elem[expando];if(name){if(jQuery.cache[id]){delete jQuery.cache[id][name];name="";for(name in jQuery.cache[id])break;if(!name)jQuery.removeData(elem);}}else{try{delete elem[expando];}catch(e){if(elem.removeAttribute)elem.removeAttribute(expando);}delete jQuery.cache[id];}},each:function(object,callback,args){var name,i=0,length=object.length;if(args){if(length==undefined){for(name in object)if(callback.apply(object[name],args)===false)break;}else
  for(;i<length;)if(callback.apply(object[i++],args)===false)break;}else{if(length==undefined){for(name in object)if(callback.call(object[name],name,object[name])===false)break;}else
  for(var value=object[0];i<length&&callback.call(value,i,value)!==false;value=object[++i]){}}return object;},prop:function(elem,value,type,i,name){if(jQuery.isFunction(value))value=value.call(elem,i);return value&&value.constructor==Number&&type=="curCSS"&&!exclude.test(name)?value+"px":value;},className:{add:function(elem,classNames){jQuery.each((classNames||"").split(/\s+/),function(i,className){if(elem.nodeType==1&&!jQuery.className.has(elem.className,className))elem.className+=(elem.className?" ":"")+className;});},remove:function(elem,classNames){if(elem.nodeType==1)elem.className=classNames!=undefined?jQuery.grep(elem.className.split(/\s+/),function(className){return!jQuery.className.has(classNames,className);}).join(" "):"";},has:function(elem,className){return jQuery.inArray(className,(elem.className||elem).toString().split(/\s+/))>-1;}},swap:function(elem,options,callback){var old={};for(var name in options){old[name]=elem.style[name];elem.style[name]=options[name];}callback.call(elem);for(var name in options)elem.style[name]=old[name];},css:function(elem,name,force){if(name=="width"||name=="height"){var val,props={position:"absolute",visibility:"hidden",display:"block"},which=name=="width"?["Left","Right"]:["Top","Bottom"];function getWH(){val=name=="width"?elem.offsetWidth:elem.offsetHeight;var padding=0,border=0;jQuery.each(which,function(){padding+=parseFloat(jQuery.curCSS(elem,"padding"+this,true))||0;border+=parseFloat(jQuery.curCSS(elem,"border"+this+"Width",true))||0;});val-=Math.round(padding+border);}if(jQuery(elem).is(":visible"))getWH();else
  jQuery.swap(elem,props,getWH);return Math.max(0,val);}return jQuery.curCSS(elem,name,force);},curCSS:function(elem,name,force){var ret,style=elem.style;function color(elem){if(!jQuery.browser.safari)return false;var ret=defaultView.getComputedStyle(elem,null);return!ret||ret.getPropertyValue("color")=="";}if(name=="opacity"&&jQuery.browser.msie){ret=jQuery.attr(style,"opacity");return ret==""?"1":ret;}if(jQuery.browser.opera&&name=="display"){var save=style.outline;style.outline="0 solid black";style.outline=save;}if(name.match(/float/i))name=styleFloat;if(!force&&style&&style[name])ret=style[name];else if(defaultView.getComputedStyle){if(name.match(/float/i))name="float";name=name.replace(/([A-Z])/g,"-$1").toLowerCase();var computedStyle=defaultView.getComputedStyle(elem,null);if(computedStyle&&!color(elem))ret=computedStyle.getPropertyValue(name);else{var swap=[],stack=[],a=elem,i=0;for(;a&&color(a);a=a.parentNode)stack.unshift(a);for(;i<stack.length;i++)if(color(stack[i])){swap[i]=stack[i].style.display;stack[i].style.display="block";}ret=name=="display"&&swap[stack.length-1]!=null?"none":(computedStyle&&computedStyle.getPropertyValue(name))||"";for(i=0;i<swap.length;i++)if(swap[i]!=null)stack[i].style.display=swap[i];}if(name=="opacity"&&ret=="")ret="1";}else if(elem.currentStyle){var camelCase=name.replace(/\-(\w)/g,function(all,letter){return letter.toUpperCase();});ret=elem.currentStyle[name]||elem.currentStyle[camelCase];if(!/^\d+(px)?$/i.test(ret)&&/^\d/.test(ret)){var left=style.left,rsLeft=elem.runtimeStyle.left;elem.runtimeStyle.left=elem.currentStyle.left;style.left=ret||0;ret=style.pixelLeft+"px";style.left=left;elem.runtimeStyle.left=rsLeft;}}return ret;},clean:function(elems,context){var ret=[];context=context||document;if(typeof context.createElement=='undefined')context=context.ownerDocument||context[0]&&context[0].ownerDocument||document;jQuery.each(elems,function(i,elem){if(!elem)return;if(elem.constructor==Number)elem+='';if(typeof elem=="string"){elem=elem.replace(/(<(\w+)[^>]*?)\/>/g,function(all,front,tag){return tag.match(/^(abbr|br|col|img|input|link|meta|param|hr|area|embed)$/i)?all:front+"></"+tag+">";});var tags=jQuery.trim(elem).toLowerCase(),div=context.createElement("div");var wrap=!tags.indexOf("<opt")&&[1,"<select multiple='multiple'>","</select>"]||!tags.indexOf("<leg")&&[1,"<fieldset>","</fieldset>"]||tags.match(/^<(thead|tbody|tfoot|colg|cap)/)&&[1,"<table>","</table>"]||!tags.indexOf("<tr")&&[2,"<table><tbody>","</tbody></table>"]||(!tags.indexOf("<td")||!tags.indexOf("<th"))&&[3,"<table><tbody><tr>","</tr></tbody></table>"]||!tags.indexOf("<col")&&[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"]||jQuery.browser.msie&&[1,"div<div>","</div>"]||[0,"",""];div.innerHTML=wrap[1]+elem+wrap[2];while(wrap[0]--)div=div.lastChild;if(jQuery.browser.msie){var tbody=!tags.indexOf("<table")&&tags.indexOf("<tbody")<0?div.firstChild&&div.firstChild.childNodes:wrap[1]=="<table>"&&tags.indexOf("<tbody")<0?div.childNodes:[];for(var j=tbody.length-1;j>=0;--j)if(jQuery.nodeName(tbody[j],"tbody")&&!tbody[j].childNodes.length)tbody[j].parentNode.removeChild(tbody[j]);if(/^\s/.test(elem))div.insertBefore(context.createTextNode(elem.match(/^\s*/)[0]),div.firstChild);}elem=jQuery.makeArray(div.childNodes);}if(elem.length===0&&(!jQuery.nodeName(elem,"form")&&!jQuery.nodeName(elem,"select")))return;if(elem[0]==undefined||jQuery.nodeName(elem,"form")||elem.options)ret.push(elem);else
  ret=jQuery.merge(ret,elem);});return ret;},attr:function(elem,name,value){if(!elem||elem.nodeType==3||elem.nodeType==8)return undefined;var notxml=!jQuery.isXMLDoc(elem),set=value!==undefined,msie=jQuery.browser.msie;name=notxml&&jQuery.props[name]||name;if(elem.tagName){var special=/href|src|style/.test(name);if(name=="selected"&&jQuery.browser.safari)elem.parentNode.selectedIndex;if(name in elem&&notxml&&!special){if(set){if(name=="type"&&jQuery.nodeName(elem,"input")&&elem.parentNode)throw"type property can't be changed";elem[name]=value;}if(jQuery.nodeName(elem,"form")&&elem.getAttributeNode(name))return elem.getAttributeNode(name).nodeValue;return elem[name];}if(msie&&notxml&&name=="style")return jQuery.attr(elem.style,"cssText",value);if(set)elem.setAttribute(name,""+value);var attr=msie&&notxml&&special?elem.getAttribute(name,2):elem.getAttribute(name);return attr===null?undefined:attr;}if(msie&&name=="opacity"){if(set){elem.zoom=1;elem.filter=(elem.filter||"").replace(/alpha\([^)]*\)/,"")+(parseInt(value)+''=="NaN"?"":"alpha(opacity="+value*100+")");}return elem.filter&&elem.filter.indexOf("opacity=")>=0?(parseFloat(elem.filter.match(/opacity=([^)]*)/)[1])/100)+'':"";}name=name.replace(/-([a-z])/ig,function(all,letter){return letter.toUpperCase();});if(set)elem[name]=value;return elem[name];},trim:function(text){return(text||"").replace(/^\s+|\s+$/g,"");},makeArray:function(array){var ret=[];if(array!=null){var i=array.length;if(i==null||array.split||array.setInterval||array.call)ret[0]=array;else
  while(i)ret[--i]=array[i];}return ret;},inArray:function(elem,array){for(var i=0,length=array.length;i<length;i++)if(array[i]===elem)return i;return-1;},merge:function(first,second){var i=0,elem,pos=first.length;if(jQuery.browser.msie){while(elem=second[i++])if(elem.nodeType!=8)first[pos++]=elem;}else
  while(elem=second[i++])first[pos++]=elem;return first;},unique:function(array){var ret=[],done={};try{for(var i=0,length=array.length;i<length;i++){var id=jQuery.data(array[i]);if(!done[id]){done[id]=true;ret.push(array[i]);}}}catch(e){ret=array;}return ret;},grep:function(elems,callback,inv){var ret=[];for(var i=0,length=elems.length;i<length;i++)if(!inv!=!callback(elems[i],i))ret.push(elems[i]);return ret;},map:function(elems,callback){var ret=[];for(var i=0,length=elems.length;i<length;i++){var value=callback(elems[i],i);if(value!=null)ret[ret.length]=value;}return ret.concat.apply([],ret);}});var userAgent=navigator.userAgent.toLowerCase();jQuery.browser={version:(userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/)||[])[1],safari:/webkit/.test(userAgent),opera:/opera/.test(userAgent),msie:/msie/.test(userAgent)&&!/opera/.test(userAgent),mozilla:/mozilla/.test(userAgent)&&!/(compatible|webkit)/.test(userAgent)};var styleFloat=jQuery.browser.msie?"styleFloat":"cssFloat";jQuery.extend({boxModel:!jQuery.browser.msie||document.compatMode=="CSS1Compat",props:{"for":"htmlFor","class":"className","float":styleFloat,cssFloat:styleFloat,styleFloat:styleFloat,readonly:"readOnly",maxlength:"maxLength",cellspacing:"cellSpacing"}});jQuery.each({parent:function(elem){return elem.parentNode;},parents:function(elem){return jQuery.dir(elem,"parentNode");},next:function(elem){return jQuery.nth(elem,2,"nextSibling");},prev:function(elem){return jQuery.nth(elem,2,"previousSibling");},nextAll:function(elem){return jQuery.dir(elem,"nextSibling");},prevAll:function(elem){return jQuery.dir(elem,"previousSibling");},siblings:function(elem){return jQuery.sibling(elem.parentNode.firstChild,elem);},children:function(elem){return jQuery.sibling(elem.firstChild);},contents:function(elem){return jQuery.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:jQuery.makeArray(elem.childNodes);}},function(name,fn){jQuery.fn[name]=function(selector){var ret=jQuery.map(this,fn);if(selector&&typeof selector=="string")ret=jQuery.multiFilter(selector,ret);return this.pushStack(jQuery.unique(ret));};});jQuery.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(name,original){jQuery.fn[name]=function(){var args=arguments;return this.each(function(){for(var i=0,length=args.length;i<length;i++)jQuery(args[i])[original](this);});};});jQuery.each({removeAttr:function(name){jQuery.attr(this,name,"");if(this.nodeType==1)this.removeAttribute(name);},addClass:function(classNames){jQuery.className.add(this,classNames);},removeClass:function(classNames){jQuery.className.remove(this,classNames);},toggleClass:function(classNames){jQuery.className[jQuery.className.has(this,classNames)?"remove":"add"](this,classNames);},remove:function(selector){if(!selector||jQuery.filter(selector,[this]).r.length){jQuery("*",this).add(this).each(function(){jQuery.event.remove(this);jQuery.removeData(this);});if(this.parentNode)this.parentNode.removeChild(this);}},empty:function(){jQuery(">*",this).remove();while(this.firstChild)this.removeChild(this.firstChild);}},function(name,fn){jQuery.fn[name]=function(){return this.each(fn,arguments);};});jQuery.each(["Height","Width"],function(i,name){var type=name.toLowerCase();jQuery.fn[type]=function(size){return this[0]==window?jQuery.browser.opera&&document.body["client"+name]||jQuery.browser.safari&&window["inner"+name]||document.compatMode=="CSS1Compat"&&document.documentElement["client"+name]||document.body["client"+name]:this[0]==document?Math.max(Math.max(document.body["scroll"+name],document.documentElement["scroll"+name]),Math.max(document.body["offset"+name],document.documentElement["offset"+name])):size==undefined?(this.length?jQuery.css(this[0],type):null):this.css(type,size.constructor==String?size:size+"px");};});function num(elem,prop){return elem[0]&&parseInt(jQuery.curCSS(elem[0],prop,true),10)||0;}var chars=jQuery.browser.safari&&parseInt(jQuery.browser.version)<417?"(?:[\\w*_-]|\\\\.)":"(?:[\\w\u0128-\uFFFF*_-]|\\\\.)",quickChild=new RegExp("^>\\s*("+chars+"+)"),quickID=new RegExp("^("+chars+"+)(#)("+chars+"+)"),quickClass=new RegExp("^([#.]?)("+chars+"*)");jQuery.extend({expr:{"":function(a,i,m){return m[2]=="*"||jQuery.nodeName(a,m[2]);},"#":function(a,i,m){return a.getAttribute("id")==m[2];},":":{lt:function(a,i,m){return i<m[3]-0;},gt:function(a,i,m){return i>m[3]-0;},nth:function(a,i,m){return m[3]-0==i;},eq:function(a,i,m){return m[3]-0==i;},first:function(a,i){return i==0;},last:function(a,i,m,r){return i==r.length-1;},even:function(a,i){return i%2==0;},odd:function(a,i){return i%2;},"first-child":function(a){return a.parentNode.getElementsByTagName("*")[0]==a;},"last-child":function(a){return jQuery.nth(a.parentNode.lastChild,1,"previousSibling")==a;},"only-child":function(a){return!jQuery.nth(a.parentNode.lastChild,2,"previousSibling");},parent:function(a){return a.firstChild;},empty:function(a){return!a.firstChild;},contains:function(a,i,m){return(a.textContent||a.innerText||jQuery(a).text()||"").indexOf(m[3])>=0;},visible:function(a){return"hidden"!=a.type&&jQuery.css(a,"display")!="none"&&jQuery.css(a,"visibility")!="hidden";},hidden:function(a){return"hidden"==a.type||jQuery.css(a,"display")=="none"||jQuery.css(a,"visibility")=="hidden";},enabled:function(a){return!a.disabled;},disabled:function(a){return a.disabled;},checked:function(a){return a.checked;},selected:function(a){return a.selected||jQuery.attr(a,"selected");},text:function(a){return"text"==a.type;},radio:function(a){return"radio"==a.type;},checkbox:function(a){return"checkbox"==a.type;},file:function(a){return"file"==a.type;},password:function(a){return"password"==a.type;},submit:function(a){return"submit"==a.type;},image:function(a){return"image"==a.type;},reset:function(a){return"reset"==a.type;},button:function(a){return"button"==a.type||jQuery.nodeName(a,"button");},input:function(a){return/input|select|textarea|button/i.test(a.nodeName);},has:function(a,i,m){return jQuery.find(m[3],a).length;},header:function(a){return/h\d/i.test(a.nodeName);},animated:function(a){return jQuery.grep(jQuery.timers,function(fn){return a==fn.elem;}).length;}}},parse:[/^(\[) *@?([\w-]+) *([!*$^~=]*) *('?"?)(.*?)\4 *\]/,/^(:)([\w-]+)\("?'?(.*?(\(.*?\))?[^(]*?)"?'?\)/,new RegExp("^([:.#]*)("+chars+"+)")],multiFilter:function(expr,elems,not){var old,cur=[];while(expr&&expr!=old){old=expr;var f=jQuery.filter(expr,elems,not);expr=f.t.replace(/^\s*,\s*/,"");cur=not?elems=f.r:jQuery.merge(cur,f.r);}return cur;},find:function(t,context){if(typeof t!="string")return[t];if(context&&context.nodeType!=1&&context.nodeType!=9)return[];context=context||document;var ret=[context],done=[],last,nodeName;while(t&&last!=t){var r=[];last=t;t=jQuery.trim(t);var foundToken=false,re=quickChild,m=re.exec(t);if(m){nodeName=m[1].toUpperCase();for(var i=0;ret[i];i++)for(var c=ret[i].firstChild;c;c=c.nextSibling)if(c.nodeType==1&&(nodeName=="*"||c.nodeName.toUpperCase()==nodeName))r.push(c);ret=r;t=t.replace(re,"");if(t.indexOf(" ")==0)continue;foundToken=true;}else{re=/^([>+~])\s*(\w*)/i;if((m=re.exec(t))!=null){r=[];var merge={};nodeName=m[2].toUpperCase();m=m[1];for(var j=0,rl=ret.length;j<rl;j++){var n=m=="~"||m=="+"?ret[j].nextSibling:ret[j].firstChild;for(;n;n=n.nextSibling)if(n.nodeType==1){var id=jQuery.data(n);if(m=="~"&&merge[id])break;if(!nodeName||n.nodeName.toUpperCase()==nodeName){if(m=="~")merge[id]=true;r.push(n);}if(m=="+")break;}}ret=r;t=jQuery.trim(t.replace(re,""));foundToken=true;}}if(t&&!foundToken){if(!t.indexOf(",")){if(context==ret[0])ret.shift();done=jQuery.merge(done,ret);r=ret=[context];t=" "+t.substr(1,t.length);}else{var re2=quickID;var m=re2.exec(t);if(m){m=[0,m[2],m[3],m[1]];}else{re2=quickClass;m=re2.exec(t);}m[2]=m[2].replace(/\\/g,"");var elem=ret[ret.length-1];if(m[1]=="#"&&elem&&elem.getElementById&&!jQuery.isXMLDoc(elem)){var oid=elem.getElementById(m[2]);if((jQuery.browser.msie||jQuery.browser.opera)&&oid&&typeof oid.id=="string"&&oid.id!=m[2])oid=jQuery('[@id="'+m[2]+'"]',elem)[0];ret=r=oid&&(!m[3]||jQuery.nodeName(oid,m[3]))?[oid]:[];}else{for(var i=0;ret[i];i++){var tag=m[1]=="#"&&m[3]?m[3]:m[1]!=""||m[0]==""?"*":m[2];if(tag=="*"&&ret[i].nodeName.toLowerCase()=="object")tag="param";r=jQuery.merge(r,ret[i].getElementsByTagName(tag));}if(m[1]==".")r=jQuery.classFilter(r,m[2]);if(m[1]=="#"){var tmp=[];for(var i=0;r[i];i++)if(r[i].getAttribute("id")==m[2]){tmp=[r[i]];break;}r=tmp;}ret=r;}t=t.replace(re2,"");}}if(t){var val=jQuery.filter(t,r);ret=r=val.r;t=jQuery.trim(val.t);}}if(t)ret=[];if(ret&&context==ret[0])ret.shift();done=jQuery.merge(done,ret);return done;},classFilter:function(r,m,not){m=" "+m+" ";var tmp=[];for(var i=0;r[i];i++){var pass=(" "+r[i].className+" ").indexOf(m)>=0;if(!not&&pass||not&&!pass)tmp.push(r[i]);}return tmp;},filter:function(t,r,not){var last;while(t&&t!=last){last=t;var p=jQuery.parse,m;for(var i=0;p[i];i++){m=p[i].exec(t);if(m){t=t.substring(m[0].length);m[2]=m[2].replace(/\\/g,"");break;}}if(!m)break;if(m[1]==":"&&m[2]=="not")r=isSimple.test(m[3])?jQuery.filter(m[3],r,true).r:jQuery(r).not(m[3]);else if(m[1]==".")r=jQuery.classFilter(r,m[2],not);else if(m[1]=="["){var tmp=[],type=m[3];for(var i=0,rl=r.length;i<rl;i++){var a=r[i],z=a[jQuery.props[m[2]]||m[2]];if(z==null||/href|src|selected/.test(m[2]))z=jQuery.attr(a,m[2])||'';if((type==""&&!!z||type=="="&&z==m[5]||type=="!="&&z!=m[5]||type=="^="&&z&&!z.indexOf(m[5])||type=="$="&&z.substr(z.length-m[5].length)==m[5]||(type=="*="||type=="~=")&&z.indexOf(m[5])>=0)^not)tmp.push(a);}r=tmp;}else if(m[1]==":"&&m[2]=="nth-child"){var merge={},tmp=[],test=/(-?)(\d*)n((?:\+|-)?\d*)/.exec(m[3]=="even"&&"2n"||m[3]=="odd"&&"2n+1"||!/\D/.test(m[3])&&"0n+"+m[3]||m[3]),first=(test[1]+(test[2]||1))-0,last=test[3]-0;for(var i=0,rl=r.length;i<rl;i++){var node=r[i],parentNode=node.parentNode,id=jQuery.data(parentNode);if(!merge[id]){var c=1;for(var n=parentNode.firstChild;n;n=n.nextSibling)if(n.nodeType==1)n.nodeIndex=c++;merge[id]=true;}var add=false;if(first==0){if(node.nodeIndex==last)add=true;}else if((node.nodeIndex-last)%first==0&&(node.nodeIndex-last)/first>=0)add=true;if(add^not)tmp.push(node);}r=tmp;}else{var fn=jQuery.expr[m[1]];if(typeof fn=="object")fn=fn[m[2]];if(typeof fn=="string")fn=eval("false||function(a,i){return "+fn+";}");r=jQuery.grep(r,function(elem,i){return fn(elem,i,m,r);},not);}}return{r:r,t:t};},dir:function(elem,dir){var matched=[],cur=elem[dir];while(cur&&cur!=document){if(cur.nodeType==1)matched.push(cur);cur=cur[dir];}return matched;},nth:function(cur,result,dir,elem){result=result||1;var num=0;for(;cur;cur=cur[dir])if(cur.nodeType==1&&++num==result)break;return cur;},sibling:function(n,elem){var r=[];for(;n;n=n.nextSibling){if(n.nodeType==1&&n!=elem)r.push(n);}return r;}});jQuery.event={add:function(elem,types,handler,data){if(elem.nodeType==3||elem.nodeType==8)return;if(jQuery.browser.msie&&elem.setInterval)elem=window;if(!handler.guid)handler.guid=this.guid++;if(data!=undefined){var fn=handler;handler=this.proxy(fn,function(){return fn.apply(this,arguments);});handler.data=data;}var events=jQuery.data(elem,"events")||jQuery.data(elem,"events",{}),handle=jQuery.data(elem,"handle")||jQuery.data(elem,"handle",function(){if(typeof jQuery!="undefined"&&!jQuery.event.triggered)return jQuery.event.handle.apply(arguments.callee.elem,arguments);});handle.elem=elem;jQuery.each(types.split(/\s+/),function(index,type){var parts=type.split(".");type=parts[0];handler.type=parts[1];var handlers=events[type];if(!handlers){handlers=events[type]={};if(!jQuery.event.special[type]||jQuery.event.special[type].setup.call(elem)===false){if(elem.addEventListener)elem.addEventListener(type,handle,false);else if(elem.attachEvent)elem.attachEvent("on"+type,handle);}}handlers[handler.guid]=handler;jQuery.event.global[type]=true;});elem=null;},guid:1,global:{},remove:function(elem,types,handler){if(elem.nodeType==3||elem.nodeType==8)return;var events=jQuery.data(elem,"events"),ret,index;if(events){if(types==undefined||(typeof types=="string"&&types.charAt(0)=="."))for(var type in events)this.remove(elem,type+(types||""));else{if(types.type){handler=types.handler;types=types.type;}jQuery.each(types.split(/\s+/),function(index,type){var parts=type.split(".");type=parts[0];if(events[type]){if(handler)delete events[type][handler.guid];else
  for(handler in events[type])if(!parts[1]||events[type][handler].type==parts[1])delete events[type][handler];for(ret in events[type])break;if(!ret){if(!jQuery.event.special[type]||jQuery.event.special[type].teardown.call(elem)===false){if(elem.removeEventListener)elem.removeEventListener(type,jQuery.data(elem,"handle"),false);else if(elem.detachEvent)elem.detachEvent("on"+type,jQuery.data(elem,"handle"));}ret=null;delete events[type];}}});}for(ret in events)break;if(!ret){var handle=jQuery.data(elem,"handle");if(handle)handle.elem=null;jQuery.removeData(elem,"events");jQuery.removeData(elem,"handle");}}},trigger:function(type,data,elem,donative,extra){data=jQuery.makeArray(data);if(type.indexOf("!")>=0){type=type.slice(0,-1);var exclusive=true;}if(!elem){if(this.global[type])jQuery("*").add([window,document]).trigger(type,data);}else{if(elem.nodeType==3||elem.nodeType==8)return undefined;var val,ret,fn=jQuery.isFunction(elem[type]||null),event=!data[0]||!data[0].preventDefault;if(event){data.unshift({type:type,target:elem,preventDefault:function(){},stopPropagation:function(){},timeStamp:now()});data[0][expando]=true;}data[0].type=type;if(exclusive)data[0].exclusive=true;var handle=jQuery.data(elem,"handle");if(handle)val=handle.apply(elem,data);if((!fn||(jQuery.nodeName(elem,'a')&&type=="click"))&&elem["on"+type]&&elem["on"+type].apply(elem,data)===false)val=false;if(event)data.shift();if(extra&&jQuery.isFunction(extra)){ret=extra.apply(elem,val==null?data:data.concat(val));if(ret!==undefined)val=ret;}if(fn&&donative!==false&&val!==false&&!(jQuery.nodeName(elem,'a')&&type=="click")){this.triggered=true;try{elem[type]();}catch(e){}}this.triggered=false;}return val;},handle:function(event){var val,ret,namespace,all,handlers;event=arguments[0]=jQuery.event.fix(event||window.event);namespace=event.type.split(".");event.type=namespace[0];namespace=namespace[1];all=!namespace&&!event.exclusive;handlers=(jQuery.data(this,"events")||{})[event.type];for(var j in handlers){var handler=handlers[j];if(all||handler.type==namespace){event.handler=handler;event.data=handler.data;ret=handler.apply(this,arguments);if(val!==false)val=ret;if(ret===false){event.preventDefault();event.stopPropagation();}}}return val;},fix:function(event){if(event[expando]==true)return event;var originalEvent=event;event={originalEvent:originalEvent};var props="altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode metaKey newValue originalTarget pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target timeStamp toElement type view wheelDelta which".split(" ");for(var i=props.length;i;i--)event[props[i]]=originalEvent[props[i]];event[expando]=true;event.preventDefault=function(){if(originalEvent.preventDefault)originalEvent.preventDefault();originalEvent.returnValue=false;};event.stopPropagation=function(){if(originalEvent.stopPropagation)originalEvent.stopPropagation();originalEvent.cancelBubble=true;};event.timeStamp=event.timeStamp||now();if(!event.target)event.target=event.srcElement||document;if(event.target.nodeType==3)event.target=event.target.parentNode;if(!event.relatedTarget&&event.fromElement)event.relatedTarget=event.fromElement==event.target?event.toElement:event.fromElement;if(event.pageX==null&&event.clientX!=null){var doc=document.documentElement,body=document.body;event.pageX=event.clientX+(doc&&doc.scrollLeft||body&&body.scrollLeft||0)-(doc.clientLeft||0);event.pageY=event.clientY+(doc&&doc.scrollTop||body&&body.scrollTop||0)-(doc.clientTop||0);}if(!event.which&&((event.charCode||event.charCode===0)?event.charCode:event.keyCode))event.which=event.charCode||event.keyCode;if(!event.metaKey&&event.ctrlKey)event.metaKey=event.ctrlKey;if(!event.which&&event.button)event.which=(event.button&1?1:(event.button&2?3:(event.button&4?2:0)));return event;},proxy:function(fn,proxy){proxy.guid=fn.guid=fn.guid||proxy.guid||this.guid++;return proxy;},special:{ready:{setup:function(){bindReady();return;},teardown:function(){return;}},mouseenter:{setup:function(){if(jQuery.browser.msie)return false;jQuery(this).bind("mouseover",jQuery.event.special.mouseenter.handler);return true;},teardown:function(){if(jQuery.browser.msie)return false;jQuery(this).unbind("mouseover",jQuery.event.special.mouseenter.handler);return true;},handler:function(event){if(withinElement(event,this))return true;event.type="mouseenter";return jQuery.event.handle.apply(this,arguments);}},mouseleave:{setup:function(){if(jQuery.browser.msie)return false;jQuery(this).bind("mouseout",jQuery.event.special.mouseleave.handler);return true;},teardown:function(){if(jQuery.browser.msie)return false;jQuery(this).unbind("mouseout",jQuery.event.special.mouseleave.handler);return true;},handler:function(event){if(withinElement(event,this))return true;event.type="mouseleave";return jQuery.event.handle.apply(this,arguments);}}}};jQuery.fn.extend({bind:function(type,data,fn){return type=="unload"?this.one(type,data,fn):this.each(function(){jQuery.event.add(this,type,fn||data,fn&&data);});},one:function(type,data,fn){var one=jQuery.event.proxy(fn||data,function(event){jQuery(this).unbind(event,one);return(fn||data).apply(this,arguments);});return this.each(function(){jQuery.event.add(this,type,one,fn&&data);});},unbind:function(type,fn){return this.each(function(){jQuery.event.remove(this,type,fn);});},trigger:function(type,data,fn){return this.each(function(){jQuery.event.trigger(type,data,this,true,fn);});},triggerHandler:function(type,data,fn){return this[0]&&jQuery.event.trigger(type,data,this[0],false,fn);},toggle:function(fn){var args=arguments,i=1;while(i<args.length)jQuery.event.proxy(fn,args[i++]);return this.click(jQuery.event.proxy(fn,function(event){this.lastToggle=(this.lastToggle||0)%i;event.preventDefault();return args[this.lastToggle++].apply(this,arguments)||false;}));},hover:function(fnOver,fnOut){return this.bind('mouseenter',fnOver).bind('mouseleave',fnOut);},ready:function(fn){bindReady();if(jQuery.isReady)fn.call(document,jQuery);else
  jQuery.readyList.push(function(){return fn.call(this,jQuery);});return this;}});jQuery.extend({isReady:false,readyList:[],ready:function(){if(!jQuery.isReady){jQuery.isReady=true;if(jQuery.readyList){jQuery.each(jQuery.readyList,function(){this.call(document);});jQuery.readyList=null;}jQuery(document).triggerHandler("ready");}}});var readyBound=false;function bindReady(){if(readyBound)return;readyBound=true;if(document.addEventListener&&!jQuery.browser.opera)document.addEventListener("DOMContentLoaded",jQuery.ready,false);if(jQuery.browser.msie&&window==top)(function(){if(jQuery.isReady)return;try{document.documentElement.doScroll("left");}catch(error){setTimeout(arguments.callee,0);return;}jQuery.ready();})();if(jQuery.browser.opera)document.addEventListener("DOMContentLoaded",function(){if(jQuery.isReady)return;for(var i=0;i<document.styleSheets.length;i++)if(document.styleSheets[i].disabled){setTimeout(arguments.callee,0);return;}jQuery.ready();},false);if(jQuery.browser.safari){var numStyles;(function(){if(jQuery.isReady)return;if(document.readyState!="loaded"&&document.readyState!="complete"){setTimeout(arguments.callee,0);return;}if(numStyles===undefined)numStyles=jQuery("style, link[rel=stylesheet]").length;if(document.styleSheets.length!=numStyles){setTimeout(arguments.callee,0);return;}jQuery.ready();})();}jQuery.event.add(window,"load",jQuery.ready);}jQuery.each(("blur,focus,load,resize,scroll,unload,click,dblclick,"+"mousedown,mouseup,mousemove,mouseover,mouseout,change,select,"+"submit,keydown,keypress,keyup,error").split(","),function(i,name){jQuery.fn[name]=function(fn){return fn?this.bind(name,fn):this.trigger(name);};});var withinElement=function(event,elem){var parent=event.relatedTarget;while(parent&&parent!=elem)try{parent=parent.parentNode;}catch(error){parent=elem;}return parent==elem;};jQuery(window).bind("unload",function(){jQuery("*").add(document).unbind();});jQuery.fn.extend({_load:jQuery.fn.load,load:function(url,params,callback){if(typeof url!='string')return this._load(url);var off=url.indexOf(" ");if(off>=0){var selector=url.slice(off,url.length);url=url.slice(0,off);}callback=callback||function(){};var type="GET";if(params)if(jQuery.isFunction(params)){callback=params;params=null;}else{params=jQuery.param(params);type="POST";}var self=this;jQuery.ajax({url:url,type:type,dataType:"html",data:params,complete:function(res,status){if(status=="success"||status=="notmodified")self.html(selector?jQuery("<div/>").append(res.responseText.replace(/<script(.|\s)*?\/script>/g,"")).find(selector):res.responseText);self.each(callback,[res.responseText,status,res]);}});return this;},serialize:function(){return jQuery.param(this.serializeArray());},serializeArray:function(){return this.map(function(){return jQuery.nodeName(this,"form")?jQuery.makeArray(this.elements):this;}).filter(function(){return this.name&&!this.disabled&&(this.checked||/select|textarea/i.test(this.nodeName)||/text|hidden|password/i.test(this.type));}).map(function(i,elem){var val=jQuery(this).val();return val==null?null:val.constructor==Array?jQuery.map(val,function(val,i){return{name:elem.name,value:val};}):{name:elem.name,value:val};}).get();}});jQuery.each("ajaxStart,ajaxStop,ajaxComplete,ajaxError,ajaxSuccess,ajaxSend".split(","),function(i,o){jQuery.fn[o]=function(f){return this.bind(o,f);};});var jsc=now();jQuery.extend({get:function(url,data,callback,type){if(jQuery.isFunction(data)){callback=data;data=null;}return jQuery.ajax({type:"GET",url:url,data:data,success:callback,dataType:type});},getScript:function(url,callback){return jQuery.get(url,null,callback,"script");},getJSON:function(url,data,callback){return jQuery.get(url,data,callback,"json");},post:function(url,data,callback,type){if(jQuery.isFunction(data)){callback=data;data={};}return jQuery.ajax({type:"POST",url:url,data:data,success:callback,dataType:type});},ajaxSetup:function(settings){jQuery.extend(jQuery.ajaxSettings,settings);},ajaxSettings:{url:location.href,global:true,type:"GET",timeout:0,contentType:"application/x-www-form-urlencoded",processData:true,async:true,data:null,username:null,password:null,accepts:{xml:"application/xml, text/xml",html:"text/html",script:"text/javascript, application/javascript",json:"application/json, text/javascript",text:"text/plain",_default:"*/*"}},lastModified:{},ajax:function(s){s=jQuery.extend(true,s,jQuery.extend(true,{},jQuery.ajaxSettings,s));var jsonp,jsre=/=\?(&|$)/g,status,data,type=s.type.toUpperCase();if(s.data&&s.processData&&typeof s.data!="string")s.data=jQuery.param(s.data);if(s.dataType=="jsonp"){if(type=="GET"){if(!s.url.match(jsre))s.url+=(s.url.match(/\?/)?"&":"?")+(s.jsonp||"callback")+"=?";}else if(!s.data||!s.data.match(jsre))s.data=(s.data?s.data+"&":"")+(s.jsonp||"callback")+"=?";s.dataType="json";}if(s.dataType=="json"&&(s.data&&s.data.match(jsre)||s.url.match(jsre))){jsonp="jsonp"+jsc++;if(s.data)s.data=(s.data+"").replace(jsre,"="+jsonp+"$1");s.url=s.url.replace(jsre,"="+jsonp+"$1");s.dataType="script";window[jsonp]=function(tmp){data=tmp;success();complete();window[jsonp]=undefined;try{delete window[jsonp];}catch(e){}if(head)head.removeChild(script);};}if(s.dataType=="script"&&s.cache==null)s.cache=false;if(s.cache===false&&type=="GET"){var ts=now();var ret=s.url.replace(/(\?|&)_=.*?(&|$)/,"$1_="+ts+"$2");s.url=ret+((ret==s.url)?(s.url.match(/\?/)?"&":"?")+"_="+ts:"");}if(s.data&&type=="GET"){s.url+=(s.url.match(/\?/)?"&":"?")+s.data;s.data=null;}if(s.global&&!jQuery.active++)jQuery.event.trigger("ajaxStart");var remote=/^(?:\w+:)?\/\/([^\/?#]+)/;if(s.dataType=="script"&&type=="GET"&&remote.test(s.url)&&remote.exec(s.url)[1]!=location.host){var head=document.getElementsByTagName("head")[0];var script=document.createElement("script");script.src=s.url;if(s.scriptCharset)script.charset=s.scriptCharset;if(!jsonp){var done=false;script.onload=script.onreadystatechange=function(){if(!done&&(!this.readyState||this.readyState=="loaded"||this.readyState=="complete")){done=true;success();complete();head.removeChild(script);}};}head.appendChild(script);return undefined;}var requestDone=false;var xhr=window.ActiveXObject?new ActiveXObject("Microsoft.XMLHTTP"):new XMLHttpRequest();if(s.username)xhr.open(type,s.url,s.async,s.username,s.password);else
  xhr.open(type,s.url,s.async);try{if(s.data)xhr.setRequestHeader("Content-Type",s.contentType);if(s.ifModified)xhr.setRequestHeader("If-Modified-Since",jQuery.lastModified[s.url]||"Thu, 01 Jan 1970 00:00:00 GMT");xhr.setRequestHeader("X-Requested-With","XMLHttpRequest");xhr.setRequestHeader("Accept",s.dataType&&s.accepts[s.dataType]?s.accepts[s.dataType]+", */*":s.accepts._default);}catch(e){}if(s.beforeSend&&s.beforeSend(xhr,s)===false){s.global&&jQuery.active--;xhr.abort();return false;}if(s.global)jQuery.event.trigger("ajaxSend",[xhr,s]);var onreadystatechange=function(isTimeout){if(!requestDone&&xhr&&(xhr.readyState==4||isTimeout=="timeout")){requestDone=true;if(ival){clearInterval(ival);ival=null;}status=isTimeout=="timeout"&&"timeout"||!jQuery.httpSuccess(xhr)&&"error"||s.ifModified&&jQuery.httpNotModified(xhr,s.url)&&"notmodified"||"success";if(status=="success"){try{data=jQuery.httpData(xhr,s.dataType,s.dataFilter);}catch(e){status="parsererror";}}if(status=="success"){var modRes;try{modRes=xhr.getResponseHeader("Last-Modified");}catch(e){}if(s.ifModified&&modRes)jQuery.lastModified[s.url]=modRes;if(!jsonp)success();}else
  jQuery.handleError(s,xhr,status);complete();if(s.async)xhr=null;}};if(s.async){var ival=setInterval(onreadystatechange,13);if(s.timeout>0)setTimeout(function(){if(xhr){xhr.abort();if(!requestDone)onreadystatechange("timeout");}},s.timeout);}try{xhr.send(s.data);}catch(e){jQuery.handleError(s,xhr,null,e);}if(!s.async)onreadystatechange();function success(){if(s.success)s.success(data,status);if(s.global)jQuery.event.trigger("ajaxSuccess",[xhr,s]);}function complete(){if(s.complete)s.complete(xhr,status);if(s.global)jQuery.event.trigger("ajaxComplete",[xhr,s]);if(s.global&&!--jQuery.active)jQuery.event.trigger("ajaxStop");}return xhr;},handleError:function(s,xhr,status,e){if(s.error)s.error(xhr,status,e);if(s.global)jQuery.event.trigger("ajaxError",[xhr,s,e]);},active:0,httpSuccess:function(xhr){try{return!xhr.status&&location.protocol=="file:"||(xhr.status>=200&&xhr.status<300)||xhr.status==304||xhr.status==1223||jQuery.browser.safari&&xhr.status==undefined;}catch(e){}return false;},httpNotModified:function(xhr,url){try{var xhrRes=xhr.getResponseHeader("Last-Modified");return xhr.status==304||xhrRes==jQuery.lastModified[url]||jQuery.browser.safari&&xhr.status==undefined;}catch(e){}return false;},httpData:function(xhr,type,filter){var ct=xhr.getResponseHeader("content-type"),xml=type=="xml"||!type&&ct&&ct.indexOf("xml")>=0,data=xml?xhr.responseXML:xhr.responseText;if(xml&&data.documentElement.tagName=="parsererror")throw"parsererror";if(filter)data=filter(data,type);if(type=="script")jQuery.globalEval(data);if(type=="json")data=eval("("+data+")");return data;},param:function(a){var s=[];if(a.constructor==Array||a.jquery)jQuery.each(a,function(){s.push(encodeURIComponent(this.name)+"="+encodeURIComponent(this.value));});else
  for(var j in a)if(a[j]&&a[j].constructor==Array)jQuery.each(a[j],function(){s.push(encodeURIComponent(j)+"="+encodeURIComponent(this));});else
  s.push(encodeURIComponent(j)+"="+encodeURIComponent(jQuery.isFunction(a[j])?a[j]():a[j]));return s.join("&").replace(/%20/g,"+");}});jQuery.fn.extend({show:function(speed,callback){return speed?this.animate({height:"show",width:"show",opacity:"show"},speed,callback):this.filter(":hidden").each(function(){this.style.display=this.oldblock||"";if(jQuery.css(this,"display")=="none"){var elem=jQuery("<"+this.tagName+" />").appendTo("body");this.style.display=elem.css("display");if(this.style.display=="none")this.style.display="block";elem.remove();}}).end();},hide:function(speed,callback){return speed?this.animate({height:"hide",width:"hide",opacity:"hide"},speed,callback):this.filter(":visible").each(function(){this.oldblock=this.oldblock||jQuery.css(this,"display");this.style.display="none";}).end();},_toggle:jQuery.fn.toggle,toggle:function(fn,fn2){return jQuery.isFunction(fn)&&jQuery.isFunction(fn2)?this._toggle.apply(this,arguments):fn?this.animate({height:"toggle",width:"toggle",opacity:"toggle"},fn,fn2):this.each(function(){jQuery(this)[jQuery(this).is(":hidden")?"show":"hide"]();});},slideDown:function(speed,callback){return this.animate({height:"show"},speed,callback);},slideUp:function(speed,callback){return this.animate({height:"hide"},speed,callback);},slideToggle:function(speed,callback){return this.animate({height:"toggle"},speed,callback);},fadeIn:function(speed,callback){return this.animate({opacity:"show"},speed,callback);},fadeOut:function(speed,callback){return this.animate({opacity:"hide"},speed,callback);},fadeTo:function(speed,to,callback){return this.animate({opacity:to},speed,callback);},animate:function(prop,speed,easing,callback){var optall=jQuery.speed(speed,easing,callback);return this[optall.queue===false?"each":"queue"](function(){if(this.nodeType!=1)return false;var opt=jQuery.extend({},optall),p,hidden=jQuery(this).is(":hidden"),self=this;for(p in prop){if(prop[p]=="hide"&&hidden||prop[p]=="show"&&!hidden)return opt.complete.call(this);if(p=="height"||p=="width"){opt.display=jQuery.css(this,"display");opt.overflow=this.style.overflow;}}if(opt.overflow!=null)this.style.overflow="hidden";opt.curAnim=jQuery.extend({},prop);jQuery.each(prop,function(name,val){var e=new jQuery.fx(self,opt,name);if(/toggle|show|hide/.test(val))e[val=="toggle"?hidden?"show":"hide":val](prop);else{var parts=val.toString().match(/^([+-]=)?([\d+-.]+)(.*)$/),start=e.cur(true)||0;if(parts){var end=parseFloat(parts[2]),unit=parts[3]||"px";if(unit!="px"){self.style[name]=(end||1)+unit;start=((end||1)/e.cur(true))*start;self.style[name]=start+unit;}if(parts[1])end=((parts[1]=="-="?-1:1)*end)+start;e.custom(start,end,unit);}else
  e.custom(start,val,"");}});return true;});},queue:function(type,fn){if(jQuery.isFunction(type)||(type&&type.constructor==Array)){fn=type;type="fx";}if(!type||(typeof type=="string"&&!fn))return queue(this[0],type);return this.each(function(){if(fn.constructor==Array)queue(this,type,fn);else{queue(this,type).push(fn);if(queue(this,type).length==1)fn.call(this);}});},stop:function(clearQueue,gotoEnd){var timers=jQuery.timers;if(clearQueue)this.queue([]);this.each(function(){for(var i=timers.length-1;i>=0;i--)if(timers[i].elem==this){if(gotoEnd)timers[i](true);timers.splice(i,1);}});if(!gotoEnd)this.dequeue();return this;}});var queue=function(elem,type,array){if(elem){type=type||"fx";var q=jQuery.data(elem,type+"queue");if(!q||array)q=jQuery.data(elem,type+"queue",jQuery.makeArray(array));}return q;};jQuery.fn.dequeue=function(type){type=type||"fx";return this.each(function(){var q=queue(this,type);q.shift();if(q.length)q[0].call(this);});};jQuery.extend({speed:function(speed,easing,fn){var opt=speed&&speed.constructor==Object?speed:{complete:fn||!fn&&easing||jQuery.isFunction(speed)&&speed,duration:speed,easing:fn&&easing||easing&&easing.constructor!=Function&&easing};opt.duration=(opt.duration&&opt.duration.constructor==Number?opt.duration:jQuery.fx.speeds[opt.duration])||jQuery.fx.speeds.def;opt.old=opt.complete;opt.complete=function(){if(opt.queue!==false)jQuery(this).dequeue();if(jQuery.isFunction(opt.old))opt.old.call(this);};return opt;},easing:{linear:function(p,n,firstNum,diff){return firstNum+diff*p;},swing:function(p,n,firstNum,diff){return((-Math.cos(p*Math.PI)/2)+0.5)*diff+firstNum;}},timers:[],timerId:null,fx:function(elem,options,prop){this.options=options;this.elem=elem;this.prop=prop;if(!options.orig)options.orig={};}});jQuery.fx.prototype={update:function(){if(this.options.step)this.options.step.call(this.elem,this.now,this);(jQuery.fx.step[this.prop]||jQuery.fx.step._default)(this);if(this.prop=="height"||this.prop=="width")this.elem.style.display="block";},cur:function(force){if(this.elem[this.prop]!=null&&this.elem.style[this.prop]==null)return this.elem[this.prop];var r=parseFloat(jQuery.css(this.elem,this.prop,force));return r&&r>-10000?r:parseFloat(jQuery.curCSS(this.elem,this.prop))||0;},custom:function(from,to,unit){this.startTime=now();this.start=from;this.end=to;this.unit=unit||this.unit||"px";this.now=this.start;this.pos=this.state=0;this.update();var self=this;function t(gotoEnd){return self.step(gotoEnd);}t.elem=this.elem;jQuery.timers.push(t);if(jQuery.timerId==null){jQuery.timerId=setInterval(function(){var timers=jQuery.timers;for(var i=0;i<timers.length;i++)if(!timers[i]())timers.splice(i--,1);if(!timers.length){clearInterval(jQuery.timerId);jQuery.timerId=null;}},13);}},show:function(){this.options.orig[this.prop]=jQuery.attr(this.elem.style,this.prop);this.options.show=true;this.custom(0,this.cur());if(this.prop=="width"||this.prop=="height")this.elem.style[this.prop]="1px";jQuery(this.elem).show();},hide:function(){this.options.orig[this.prop]=jQuery.attr(this.elem.style,this.prop);this.options.hide=true;this.custom(this.cur(),0);},step:function(gotoEnd){var t=now();if(gotoEnd||t>this.options.duration+this.startTime){this.now=this.end;this.pos=this.state=1;this.update();this.options.curAnim[this.prop]=true;var done=true;for(var i in this.options.curAnim)if(this.options.curAnim[i]!==true)done=false;if(done){if(this.options.display!=null){this.elem.style.overflow=this.options.overflow;this.elem.style.display=this.options.display;if(jQuery.css(this.elem,"display")=="none")this.elem.style.display="block";}if(this.options.hide)this.elem.style.display="none";if(this.options.hide||this.options.show)for(var p in this.options.curAnim)jQuery.attr(this.elem.style,p,this.options.orig[p]);}if(done)this.options.complete.call(this.elem);return false;}else{var n=t-this.startTime;this.state=n/this.options.duration;this.pos=jQuery.easing[this.options.easing||(jQuery.easing.swing?"swing":"linear")](this.state,n,0,1,this.options.duration);this.now=this.start+((this.end-this.start)*this.pos);this.update();}return true;}};jQuery.extend(jQuery.fx,{speeds:{slow:600,fast:200,def:400},step:{scrollLeft:function(fx){fx.elem.scrollLeft=fx.now;},scrollTop:function(fx){fx.elem.scrollTop=fx.now;},opacity:function(fx){jQuery.attr(fx.elem.style,"opacity",fx.now);},_default:function(fx){fx.elem.style[fx.prop]=fx.now+fx.unit;}}});jQuery.fn.offset=function(){var left=0,top=0,elem=this[0],results;if(elem)with(jQuery.browser){var parent=elem.parentNode,offsetChild=elem,offsetParent=elem.offsetParent,doc=elem.ownerDocument,safari2=safari&&parseInt(version)<522&&!/adobeair/i.test(userAgent),css=jQuery.curCSS,fixed=css(elem,"position")=="fixed";if(elem.getBoundingClientRect){var box=elem.getBoundingClientRect();add(box.left+Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),box.top+Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));add(-doc.documentElement.clientLeft,-doc.documentElement.clientTop);}else{add(elem.offsetLeft,elem.offsetTop);while(offsetParent){add(offsetParent.offsetLeft,offsetParent.offsetTop);if(mozilla&&!/^t(able|d|h)$/i.test(offsetParent.tagName)||safari&&!safari2)border(offsetParent);if(!fixed&&css(offsetParent,"position")=="fixed")fixed=true;offsetChild=/^body$/i.test(offsetParent.tagName)?offsetChild:offsetParent;offsetParent=offsetParent.offsetParent;}while(parent&&parent.tagName&&!/^body|html$/i.test(parent.tagName)){if(!/^inline|table.*$/i.test(css(parent,"display")))add(-parent.scrollLeft,-parent.scrollTop);if(mozilla&&css(parent,"overflow")!="visible")border(parent);parent=parent.parentNode;}if((safari2&&(fixed||css(offsetChild,"position")=="absolute"))||(mozilla&&css(offsetChild,"position")!="absolute"))add(-doc.body.offsetLeft,-doc.body.offsetTop);if(fixed)add(Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));}results={top:top,left:left};}function border(elem){add(jQuery.curCSS(elem,"borderLeftWidth",true),jQuery.curCSS(elem,"borderTopWidth",true));}function add(l,t){left+=parseInt(l,10)||0;top+=parseInt(t,10)||0;}return results;};jQuery.fn.extend({position:function(){var left=0,top=0,results;if(this[0]){var offsetParent=this.offsetParent(),offset=this.offset(),parentOffset=/^body|html$/i.test(offsetParent[0].tagName)?{top:0,left:0}:offsetParent.offset();offset.top-=num(this,'marginTop');offset.left-=num(this,'marginLeft');parentOffset.top+=num(offsetParent,'borderTopWidth');parentOffset.left+=num(offsetParent,'borderLeftWidth');results={top:offset.top-parentOffset.top,left:offset.left-parentOffset.left};}return results;},offsetParent:function(){var offsetParent=this[0].offsetParent;while(offsetParent&&(!/^body|html$/i.test(offsetParent.tagName)&&jQuery.css(offsetParent,'position')=='static'))offsetParent=offsetParent.offsetParent;return jQuery(offsetParent);}});jQuery.each(['Left','Top'],function(i,name){var method='scroll'+name;jQuery.fn[method]=function(val){if(!this[0])return;return val!=undefined?this.each(function(){this==window||this==document?window.scrollTo(!i?val:jQuery(window).scrollLeft(),i?val:jQuery(window).scrollTop()):this[method]=val;}):this[0]==window||this[0]==document?self[i?'pageYOffset':'pageXOffset']||jQuery.boxModel&&document.documentElement[method]||document.body[method]:this[0][method];};});jQuery.each(["Height","Width"],function(i,name){var tl=i?"Left":"Top",br=i?"Right":"Bottom";jQuery.fn["inner"+name]=function(){return this[name.toLowerCase()]()+num(this,"padding"+tl)+num(this,"padding"+br);};jQuery.fn["outer"+name]=function(margin){return this["inner"+name]()+num(this,"border"+tl+"Width")+num(this,"border"+br+"Width")+(margin?num(this,"margin"+tl)+num(this,"margin"+br):0);};});})();
---
dir: share/po
---
file: xt/02_perlcritic.t
template: |
  use strict;
  use Test::More;
  eval {
      require Test::Perl::Critic;
      Test::Perl::Critic->import( -profile => 'xt/perlcriticrc');
  };
  plan skip_all => "Test::Perl::Critic is not installed." if $@;
  all_critic_ok('lib');
---
file: xt/perlcriticrc
template: |
  [TestingAndDebugging::ProhibitNoStrict]
  allow=refs
---
file: xt/03_pod.t
template: |
  use Test::More;
  eval "use Test::Pod 1.00";
  plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
  all_pod_files_ok();
---
file: xt/01_podspell.t
template: |
  use Test::More;
  eval q{ use Test::Spelling };
  plan skip_all => "Test::Spelling is not installed." if $@;
  add_stopwords(map { split /[\s\:\-]/ } <DATA>);
  $ENV{LANG} = 'C';
  all_pod_files_spelling_ok('lib');
  __DATA__
  [% config.author %]
  [% config.email %]
  [% module %]
---
file: log/error.log
is_binary: 1
template: ''
---
file: log/server.log
is_binary: 1
template: ''
---
file: bin/cli
template: |+
  #!/usr/bin/env perl
  use strict;
  use warnings;
  use FindBin::libs;
  
  use [% module %]::CLI;
  [% module %]::CLI->run;

---
file: bin/server
template: |+
  #!/usr/bin/perl
  use strict;
  use warnings;
  use FindBin::libs;
  use Angelos::Script::Server;
  
  my $app = Angelos::Script::Server->new_with_options(app=> "[% module %]");
  $app->run;
  
  __END__
  
  =head1 NAME 
  
  bin/server - a command-line interface to angelos
  
  =head1 SYNOPSIS
  
    bin/server [--host=192.168.0.100] [--port 3001] [--server ServerSimple] [--debug]
  
  =head1 AUTHOR
  
  Takatoshi Kitano
  
  =cut

---
dir: inc/.author
---
file: inc/Module/Install.pm
template: |
  #line 1
  package Module::Install;
  
  # For any maintainers:
  # The load order for Module::Install is a bit magic.
  # It goes something like this...
  #
  # IF ( host has Module::Install installed, creating author mode ) {
  #     1. Makefile.PL calls "use inc::Module::Install"
  #     2. $INC{inc/Module/Install.pm} set to installed version of inc::Module::Install
  #     3. The installed version of inc::Module::Install loads
  #     4. inc::Module::Install calls "require Module::Install"
  #     5. The ./inc/ version of Module::Install loads
  # } ELSE {
  #     1. Makefile.PL calls "use inc::Module::Install"
  #     2. $INC{inc/Module/Install.pm} set to ./inc/ version of Module::Install
  #     3. The ./inc/ version of Module::Install loads
  # }
  
  BEGIN {
  	require 5.004;
  }
  use strict 'vars';
  
  use vars qw{$VERSION};
  BEGIN {
  	# All Module::Install core packages now require synchronised versions.
  	# This will be used to ensure we don't accidentally load old or
  	# different versions of modules.
  	# This is not enforced yet, but will be some time in the next few
  	# releases once we can make sure it won't clash with custom
  	# Module::Install extensions.
  	$VERSION = '0.77';
  
  	*inc::Module::Install::VERSION = *VERSION;
  	@inc::Module::Install::ISA     = __PACKAGE__;
  
  }
  
  
  
  
  
  # Whether or not inc::Module::Install is actually loaded, the
  # $INC{inc/Module/Install.pm} is what will still get set as long as
  # the caller loaded module this in the documented manner.
  # If not set, the caller may NOT have loaded the bundled version, and thus
  # they may not have a MI version that works with the Makefile.PL. This would
  # result in false errors or unexpected behaviour. And we don't want that.
  my $file = join( '/', 'inc', split /::/, __PACKAGE__ ) . '.pm';
  unless ( $INC{$file} ) { die <<"END_DIE" }
  
  Please invoke ${\__PACKAGE__} with:
  
  	use inc::${\__PACKAGE__};
  
  not:
  
  	use ${\__PACKAGE__};
  
  END_DIE
  
  
  
  
  
  # If the script that is loading Module::Install is from the future,
  # then make will detect this and cause it to re-run over and over
  # again. This is bad. Rather than taking action to touch it (which
  # is unreliable on some platforms and requires write permissions)
  # for now we should catch this and refuse to run.
  if ( -f $0 and (stat($0))[9] > time ) { die <<"END_DIE" }
  
  Your installer $0 has a modification time in the future.
  
  This is known to create infinite loops in make.
  
  Please correct this, then run $0 again.
  
  END_DIE
  
  
  
  
  
  # Build.PL was formerly supported, but no longer is due to excessive
  # difficulty in implementing every single feature twice.
  if ( $0 =~ /Build.PL$/i ) { die <<"END_DIE" }
  
  Module::Install no longer supports Build.PL.
  
  It was impossible to maintain duel backends, and has been deprecated.
  
  Please remove all Build.PL files and only use the Makefile.PL installer.
  
  END_DIE
  
  
  
  
  
  # To save some more typing in Module::Install installers, every...
  # use inc::Module::Install
  # ...also acts as an implicit use strict.
  $^H |= strict::bits(qw(refs subs vars));
  
  
  
  
  
  use Cwd        ();
  use File::Find ();
  use File::Path ();
  use FindBin;
  
  sub autoload {
  	my $self = shift;
  	my $who  = $self->_caller;
  	my $cwd  = Cwd::cwd();
  	my $sym  = "${who}::AUTOLOAD";
  	$sym->{$cwd} = sub {
  		my $pwd = Cwd::cwd();
  		if ( my $code = $sym->{$pwd} ) {
  			# delegate back to parent dirs
  			goto &$code unless $cwd eq $pwd;
  		}
  		$$sym =~ /([^:]+)$/ or die "Cannot autoload $who - $sym";
  		unless ( uc($1) eq $1 ) {
  			unshift @_, ( $self, $1 );
  			goto &{$self->can('call')};
  		}
  	};
  }
  
  sub import {
  	my $class = shift;
  	my $self  = $class->new(@_);
  	my $who   = $self->_caller;
  
  	unless ( -f $self->{file} ) {
  		require "$self->{path}/$self->{dispatch}.pm";
  		File::Path::mkpath("$self->{prefix}/$self->{author}");
  		$self->{admin} = "$self->{name}::$self->{dispatch}"->new( _top => $self );
  		$self->{admin}->init;
  		@_ = ($class, _self => $self);
  		goto &{"$self->{name}::import"};
  	}
  
  	*{"${who}::AUTOLOAD"} = $self->autoload;
  	$self->preload;
  
  	# Unregister loader and worker packages so subdirs can use them again
  	delete $INC{"$self->{file}"};
  	delete $INC{"$self->{path}.pm"};
  
  	return 1;
  }
  
  sub preload {
  	my $self = shift;
  	unless ( $self->{extensions} ) {
  		$self->load_extensions(
  			"$self->{prefix}/$self->{path}", $self
  		);
  	}
  
  	my @exts = @{$self->{extensions}};
  	unless ( @exts ) {
  		my $admin = $self->{admin};
  		@exts = $admin->load_all_extensions;
  	}
  
  	my %seen;
  	foreach my $obj ( @exts ) {
  		while (my ($method, $glob) = each %{ref($obj) . '::'}) {
  			next unless $obj->can($method);
  			next if $method =~ /^_/;
  			next if $method eq uc($method);
  			$seen{$method}++;
  		}
  	}
  
  	my $who = $self->_caller;
  	foreach my $name ( sort keys %seen ) {
  		*{"${who}::$name"} = sub {
  			${"${who}::AUTOLOAD"} = "${who}::$name";
  			goto &{"${who}::AUTOLOAD"};
  		};
  	}
  }
  
  sub new {
  	my ($class, %args) = @_;
  
  	# ignore the prefix on extension modules built from top level.
  	my $base_path = Cwd::abs_path($FindBin::Bin);
  	unless ( Cwd::abs_path(Cwd::cwd()) eq $base_path ) {
  		delete $args{prefix};
  	}
  
  	return $args{_self} if $args{_self};
  
  	$args{dispatch} ||= 'Admin';
  	$args{prefix}   ||= 'inc';
  	$args{author}   ||= ($^O eq 'VMS' ? '_author' : '.author');
  	$args{bundle}   ||= 'inc/BUNDLES';
  	$args{base}     ||= $base_path;
  	$class =~ s/^\Q$args{prefix}\E:://;
  	$args{name}     ||= $class;
  	$args{version}  ||= $class->VERSION;
  	unless ( $args{path} ) {
  		$args{path}  = $args{name};
  		$args{path}  =~ s!::!/!g;
  	}
  	$args{file}     ||= "$args{base}/$args{prefix}/$args{path}.pm";
  	$args{wrote}      = 0;
  
  	bless( \%args, $class );
  }
  
  sub call {
  	my ($self, $method) = @_;
  	my $obj = $self->load($method) or return;
          splice(@_, 0, 2, $obj);
  	goto &{$obj->can($method)};
  }
  
  sub load {
  	my ($self, $method) = @_;
  
  	$self->load_extensions(
  		"$self->{prefix}/$self->{path}", $self
  	) unless $self->{extensions};
  
  	foreach my $obj (@{$self->{extensions}}) {
  		return $obj if $obj->can($method);
  	}
  
  	my $admin = $self->{admin} or die <<"END_DIE";
  The '$method' method does not exist in the '$self->{prefix}' path!
  Please remove the '$self->{prefix}' directory and run $0 again to load it.
  END_DIE
  
  	my $obj = $admin->load($method, 1);
  	push @{$self->{extensions}}, $obj;
  
  	$obj;
  }
  
  sub load_extensions {
  	my ($self, $path, $top) = @_;
  
  	unless ( grep { lc $_ eq lc $self->{prefix} } @INC ) {
  		unshift @INC, $self->{prefix};
  	}
  
  	foreach my $rv ( $self->find_extensions($path) ) {
  		my ($file, $pkg) = @{$rv};
  		next if $self->{pathnames}{$pkg};
  
  		local $@;
  		my $new = eval { require $file; $pkg->can('new') };
  		unless ( $new ) {
  			warn $@ if $@;
  			next;
  		}
  		$self->{pathnames}{$pkg} = delete $INC{$file};
  		push @{$self->{extensions}}, &{$new}($pkg, _top => $top );
  	}
  
  	$self->{extensions} ||= [];
  }
  
  sub find_extensions {
  	my ($self, $path) = @_;
  
  	my @found;
  	File::Find::find( sub {
  		my $file = $File::Find::name;
  		return unless $file =~ m!^\Q$path\E/(.+)\.pm\Z!is;
  		my $subpath = $1;
  		return if lc($subpath) eq lc($self->{dispatch});
  
  		$file = "$self->{path}/$subpath.pm";
  		my $pkg = "$self->{name}::$subpath";
  		$pkg =~ s!/!::!g;
  
  		# If we have a mixed-case package name, assume case has been preserved
  		# correctly.  Otherwise, root through the file to locate the case-preserved
  		# version of the package name.
  		if ( $subpath eq lc($subpath) || $subpath eq uc($subpath) ) {
  			my $content = Module::Install::_read($subpath . '.pm');
  			my $in_pod  = 0;
  			foreach ( split //, $content ) {
  				$in_pod = 1 if /^=\w/;
  				$in_pod = 0 if /^=cut/;
  				next if ($in_pod || /^=cut/);  # skip pod text
  				next if /^\s*#/;               # and comments
  				if ( m/^\s*package\s+($pkg)\s*;/i ) {
  					$pkg = $1;
  					last;
  				}
  			}
  		}
  
  		push @found, [ $file, $pkg ];
  	}, $path ) if -d $path;
  
  	@found;
  }
  
  
  
  
  
  #####################################################################
  # Utility Functions
  
  sub _caller {
  	my $depth = 0;
  	my $call  = caller($depth);
  	while ( $call eq __PACKAGE__ ) {
  		$depth++;
  		$call = caller($depth);
  	}
  	return $call;
  }
  
  sub _read {
  	local *FH;
  	open FH, "< $_[0]" or die "open($_[0]): $!";
  	my $str = do { local $/; <FH> };
  	close FH or die "close($_[0]): $!";
  	return $str;
  }
  
  sub _write {
  	local *FH;
  	open FH, "> $_[0]" or die "open($_[0]): $!";
  	foreach ( 1 .. $#_ ) { print FH $_[$_] or die "print($_[0]): $!" }
  	close FH or die "close($_[0]): $!";
  }
  
  # _version is for processing module versions (eg, 1.03_05) not
  # Perl versions (eg, 5.8.1).
  
  sub _version ($) {
  	my $s = shift || 0;
  	   $s =~ s/^(\d+)\.?//;
  	my $l = $1 || 0;
  	my @v = map { $_ . '0' x (3 - length $_) } $s =~ /(\d{1,3})\D?/g;
  	   $l = $l . '.' . join '', @v if @v;
  	return $l + 0;
  }
  
  # Cloned from Params::Util::_CLASS
  sub _CLASS ($) {
  	(
  		defined $_[0]
  		and
  		! ref $_[0]
  		and
  		$_[0] =~ m/^[^\W\d]\w*(?:::\w+)*$/s
  	) ? $_[0] : undef;
  }
  
  1;
  
  # Copyright 2008 Adam Kennedy.
---
file: tools/test_it
template: |
  #!/bin/sh
  prove -lv t/integration/serversimple/*.t
---
file: tools/test_pt_simple.pl
template: |+
  #!/usr/bin/env perl
  use strict;
  use warnings;
  use lib 'lib';
  use Test::TCP;
  use [% module %];
  use LWP::UserAgent;
  use Benchmark qw/countit timethese timeit timestr/;
  use IO::Scalar;
  
  my $module = shift || 'ServerSimple';
  my $port   = shift || empty_port();
  my $loop   = shift || 100;
  
  test_tcp(
      client => sub {
  
          my $port = shift;
          tie *STDOUT, 'IO::Scalar', \my $out;
          my $t = countit 2 => sub {
              my $ua = LWP::UserAgent->new;
              $ua->get("http://localhost:$port/");
          };
          untie *STDOUT;
          print timestr($t), "\n";
  
      },
      server => sub {
          my $port   = shift;
          my $engine = [% module %]->new(
              server => $module,
              port   => $port,
          );
          $engine->run;
      },
  );

---
file: tools/profile_module_memory.pl
template: |
  #!/usr/bin/env perl
  use strict;
  use warnings;
  use Devel::MemUsed;
  use Module::Depends;
  use Number::Bytes::Human qw(format_bytes);
  
  main();
  
  sub main {
      my $memory_record = record_memory_usage();
  }
  
  sub record_memory_usage {
      my $deps = Module::Depends->new->dist_dir('.')->find_modules;
      foreach my $module ( keys %{ $deps->requires } ) {
          my $pid = fork();
          if ($pid) {
  
              # parent
              wait();
          }
          elsif ( defined $pid ) {
              my $memused = Devel::MemUsed->new;
              eval "use $module";
              print sprintf( "%35s %08s", $module, $memused ) . "\n";
              exit();
          }
          else {
              die "fork error : $!";
          }
      }
  }
---
file: tools/test_coverage
template: |+
  #!/bin/zsh
  rm -rf cover_db
  perl Makefile.PL
  HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,inc,-coverage,statement,branch,condition,path,subroutine make test
  cover
  rm -rf cover_db_view
  mv cover_db cover_db_view
  open cover_db_view/coverage.html

---
file: tools/test_ut
template: |
  #!/bin/sh
  prove -lv t/*.t
  prove -lv t/unit/*/*.t
---
file: tools/profile_module_memory
template: |
  #!/bin/sh
  perl tools/profile_module_memory.pl | sort -k 2
---
file: tools/autotest
template: |+
  #!/bin/sh
  perl -MTest::Continuous -e runtests t/*.t t/unit/*/*.t xt/*.t t/integration/*.t

---
config:
  author: Your Name
  class: Angelos::Script::Command::Generate::Flavor::App
  email: 'default {at} example.com'
  plugins:
    - Template


