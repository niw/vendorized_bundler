#!/usr/bin/env ruby

module Bundler
  class Vendorized
    VERSION = "1.0.3"

    def boot!
      unless bundler_exists?
        puts "bundler-#{VERSION} is not found, install it under #{vendor_path} directory."
        create_vendor_path
        install_bundler
      end
      $LOAD_PATH << "#{bundler_path}/lib"

      if $0 == __FILE__
        if ARGV.empty? && !File.exists?(bundle_path)
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
      require "rubygems"
      require "rubygems/commands/unpack_command"
      unpack_command = Gem::Commands::UnpackCommand.new
      unpack_command.invoke("--target", vendor_path, "bundler", "-v", VERSION)
    end

    def vendor_path
      @vendor_path ||= File.expand_path(File.join(File.dirname(__FILE__), "vendor"))
    end

    def bundler_path
      @bundler_path ||= File.join(vendor_path, "bundler-#{VERSION}")
    end

    def bundle_path
      @bundle_path ||= File.join(vendor_path, "bundle")
    end
  end
end

Bundler::Vendorized.boot!