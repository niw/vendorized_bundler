Vendorized Bundler
==================

This small single script can make [Bundler](http://gembundler.com/) and dependencies gems
managed by Bundler in vendor directory, say vendorized.

Usage
-----

Put `bundle.rb` in top of your project directory, then write `Gemfile`. More details about `Gemfile`,
you can read the [documentation](http://gembundler.com/man/gemfile.5.html).

Running `bundle.rb` without any options, it installs Bundler itself and dependences gems defined in Gemfile under `vendor` directory.

    % ruby bundle.rb

 *  bundler will be installed into `vendor/bundlr-#{version}`.
 *  dependences gems will be installed into `vendor/bundle`.

In your ruby code, you may need just to include `bundle.rb` like,

    #!/usr/bin/env ruby
    require 'bundle'
     
    # doing something awesome,
    # awesome...
