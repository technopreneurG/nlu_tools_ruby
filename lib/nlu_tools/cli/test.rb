# frozen_string_literal: true

module NluTools
  # The subcommand for test
  class Test < Thor
    desc 'dialogflow', 'test the data in <file> using Goolge Dialogflow'
    long_desc 'test the given input file data using Google Dialogflow

              options:

              -f --file TESTDATA_FILENAME the file containing data for testing

              -p --project_id PROJECT_ID the google project-id

              -o --output_file OUTPUT_FILENAME.ext filename extension .json/.csv/.yaml
                  is used to determine the output format. if skipped, output to STDOUT

              -t --output_type OUTPUT_TYPE raw/summary. if skipped, output is raw
    '
    option :file,
           aliases: :f,
           banner: :TESTDATA_FILENAME,
           type: :string,
           required: true
    option :project_id,
           aliases: :p,
           banner: :PROJECT_ID,
           type: :string,
           required: true
    option :output_file,
           aliases: :o,
           banner: :OUTPUT_FILENAME,
           type: :string
    option :output_type,
           aliases: :t,
           banner: :OUTPUT_TYPE,
           type: :string
    def dialogflow
      unless File.exist?(options[:file])
        puts "File #{options[:file]} does not exist"
        exit(1)
      end

      intents = JSON.parse(File.read(options[:file]))
      na = NluAdapter.new(:Dialogflow,
                          project_id: options[:project_id],
                          session_id: 'SESSION1')
      new_intents = {}
      intents.each do |intent|
        new_intents[intent['intent']] = intent['test']
      end

      run_tests(na, new_intents, options[:output_file], options[:output_type])
    end

    desc 'lex', 'test the data in <file> using AWS Lex'
    long_desc 'test the given input file data using AWS Lex

              options:

              -f --file TESTDATA_FILENAME the file containing data for testing

              -b --botname BOTNAME the AWS Lex bot name

              -o --output_file OUTPUT_FILENAME.ext filename extension .json/.csv/.yaml
                  is used to determine the output format. if skipped, output to STDOUT

              -t --output_type OUTPUT_TYPE raw/summary. if skipped, output is raw

    '
    option :file,
           aliases: :f,
           banner: 'TESTDATA_FILENAME',
           type: :string,
           required: true
    option :botname,
           aliases: :b,
           banner: 'BOT_NAME',
           type: :string,
           required: true
    option :output_file,
           aliases: :o,
           banner: 'OUTPUT_FILENAME.json/csv/yaml',
           type: :string,
           default: :STDOUT
    option :output_type,
           aliases: :t,
           banner: :OUTPUT_TYPE,
           type: :string,
           default: :raw
    def lex
      unless File.exist?(options[:file])
        puts "File #{options[:file]} does not exist"
        exit(1)
      end

      intents = JSON.parse(File.read(options[:file]))
      na = NluAdapter.new(:Lex,
                          bot_name: options[:botname],
                          bot_alias: 'BotAlias',
                          user_id: 'user-1')
      new_intents = {}
      intents.each do |intent|
        intent_name = intent['intent'].gsub('-', '_')
        new_intents[intent_name] = intent['test']
      end

      run_tests(na, new_intents, options[:output_file], options[:output_type])
    end

    private

    def run_tests(nlu_adapter, intents, output_file, output_type)
      ext = output_file.nil? || output_file.empty? ? :none : output_file.split('.')[-1].intern
      type = output_type.nil? || output_type.empty? ? :raw : output_type.intern

      case type
      when :raw
        case ext
        when :none
          puts nlu_adapter.parse_test(intents, :csv)
        when :csv, :json, :yaml
          File.open(output_file, 'w') { |file| file.write(nlu_adapter.parse_test(intents, ext)) }
        else
          puts 'Only csv/json/yaml output file format supported'
        end

      when :summary
        case ext
        when :none
          puts nlu_adapter.parse_test_report(intents, :csv)
        when :csv, :json, :yaml
          File.open(output_file, 'w') { |file| file.write(nlu_adapter.parse_test_report(intents, ext)) }
        else
          puts 'Only csv/json/yaml output file format supported'
        end

      else
        puts 'Only raw/summary output type supported'
      end
    end
  end
end
