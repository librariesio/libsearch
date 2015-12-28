#!/usr/bin/env ruby
require 'commander/import'
require 'typhoeus'
require 'ansi/core'

program :version, '0.0.1'
program :description, 'command line search of Libraries.io'

default_command :search

command :search do |c|
  c.syntax = 'libsearch query'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--platform PLATFORM', String, 'search a particular package manager'
  c.option '--language LANGUAGE', String, 'search for libraries written in a language'
  c.option '--license LICENSE', String, 'search for libraries with a given license'
  c.option '--debug', 'output helpful debug info'
  c.action do |args, options|
    puts
    search_url = "https://libraries.io/api/search?q=#{args.first}&platforms=#{options.platform}&languages=#{options.language}&licenses=#{options.license}"
    if options.debug
      puts "debug: #{search_url}"
      puts
    end

    results = JSON.parse Typhoeus.get(search_url).response_body
    results[0..5].each do |result|
      puts " #{result['name'].ansi(:bold)} - #{result['platform'].ansi(:white)} - #{result['language'].ansi(:yellow)}"
      description = result['description']
      description = "#{result['description'][0..60]}..." if result['description'].length > 60
      puts " #{description}"
      puts " #{result['package_manager_url'].ansi(:underline)}"
      puts
    end
  end
end
