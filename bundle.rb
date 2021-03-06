#!/usr/bin/env ruby

module Bundler
  class Vendorized
    VERSION = "1.1.1"

    def boot!
      # Remember bundle path exists or not.
      # install_bundler may create this path.
      bundle_path_exists = File.exists?(bundle_path)
      
      unless bundler_exists?
        puts "#{bundler_gem_name} is not found, install it under #{vendor_path} directory."
        create_vendor_path
        install_bundler
      end
      $LOAD_PATH << "#{bundler_path}/lib"

      if $0 == __FILE__
        if ARGV.empty? && !bundle_path_exists
          ARGV.unshift("install", "--path", bundle_path)
        end
        load "#{bundler_path}/bin/bundle"
      else
        require "rubygems"
        require "bundler/setup"
      end
    end

    def self.boot!
      Bundler::Vendorized.new.boot!
    end

    private

    def bundler_exists?
      File.exists?(File.join(bundler_path, "lib", "bundler.rb"))
    end

    def create_vendor_path
      Dir.mkdir(vendor_path) unless File.exists?(vendor_path)
    end

    def install_bundler
      invoke_gem_command("fetch", "bundler", "-v", VERSION)
      invoke_gem_command("unpack", "--target", vendor_path, "#{bundler_gem_name}.gem")
    end

    def invoke_gem_command(command, *options)
      require "rubygems"
      require "rubygems/commands/#{command}_command"

      # To avoid Gem::Installer claims, which is trying to create Gem.dir first.
      # Use same dir which bundler is going to use.
      Gem.use_paths gem_home_path

      command = Gem::Commands.const_get("#{classify(command)}Command").new
      command.invoke(*options)

      Gem.clear_paths
    end

    def classify(name)
      # Based on ActiveSupport::Inflector.camelize
      name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
    end

    def vendor_path
      @vendor_path ||= File.expand_path(File.join(File.dirname(__FILE__), "vendor"))
    end

    def bundler_path
      @bundler_path ||= File.join(vendor_path, bundler_gem_name)
    end

    def bundle_path
      @bundle_path ||= File.join(vendor_path, "bundle")
    end

    def gem_home_path
      @gem_home_path ||= File.join(bundle_path, Gem.ruby_engine, Gem::ConfigMap[:ruby_version])
    end

    def bundler_gem_name
      @bundler_gem_name ||= "bundler-#{VERSION}"
    end
  end
end

Bundler::Vendorized.boot!