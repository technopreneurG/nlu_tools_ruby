# frozen_string_literal: true

require 'thor'
require 'json'
require 'nlu_adapter'

module NluTools
  # The CLI
  class CLI < Thor
    desc 'import <provider>', 'import data into <provider>'
    require_relative 'cli/import'
    subcommand 'import', Import

    desc 'test <provider>', 'test data using <provider>'
    require_relative 'cli/test'
    subcommand 'test', Test
  end
end
