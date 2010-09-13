Vendorized Bundler
==================

This small single script can make [Bundler](http://gembundler.com/) and dependencies gems
managed by Bundler in single `vendor` directory, say *vendorized*.

Usage
-----

Put `bundle.rb` in top of your project directory, then write `Gemfile`. More details about `Gemfile`, please read [documentation](http://gembundler.com/man/gemfile.5.html).

Running `bundle.rb` without any options, it installs Bundler itself and dependences gems defined in `Gemfile` into `vendor` directory.

    % ruby bundle.rb

 *  Bundler itself will be installed into `vendor/bundler-#{version}`.
 *  All dependences gems will be installed into `vendor/bundle`.

Then, in your ruby code, you may need just to require `bundle.rb` like,

    #!/usr/bin/env ruby
    require 'bundle'
     
    # doing something
    # awesome...
