# frozen_string_literal: true

module NluTools
  # The subcommand for test
  class Test < Thor
    desc 'dialogflow', 'test the data in <file> using Goolge Dialogflow'
    long_desc 'test the given input file data using Google Dialogflow

              options:

              -f --file TESTDATA_FILENAME the file containing data for testing

              -p --project_id PROJECT_ID the google project-id

    '
    option :file,
           aliases: :f,
           banner: 'TESTDATA_FILENAME',
           type: :string,
           required: true
    option :project_id,
           aliases: :p,
           banner: 'PROJECT_ID',
           type: :string,
           required: true
    def dialogflow
      unless File.exist?(options[:file])
        puts "File #{options[:file]} does not exist"
        exit(1)
      end
      intents = JSON.parse(File.read(options[:file]))
      d = NluAdapter.new(:Dialogflow,
                         project_id: options[:project_id],
                         session_id: 'SESSION1')
      new_intents = {}
      intents.each do |intent|
        new_intents[intent['intent']] = intent['test']
      end

      # puts d.parse_test(new_intents, :csv)
      # puts d.parse_test_report(new_intents, :json)
    end

    desc 'lex', 'test the data in <file> using AWS Lex'
    long_desc 'test the given input file data using AWS Lex

              options:

              -f --file TESTDATA_FILENAME the file containing data for testing

              -b --botname BOTNAME the AWS Lex bot name

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
    def lex
      unless File.exist?(options[:file])
        puts "File #{options[:file]} does not exist"
        exit(1)
      end

      intents = JSON.parse(File.read(options[:file]))
      l = NluAdapter.new(:Lex,
                         bot_name: options[:botname],
                         bot_alias: 'BotAlias',
                         user_id: 'user-1')
      new_intents = {}
      intents.each do |intent|
        intent_name = intent['intent'].gsub('-', '_')
        new_intents[intent_name] = intent['test']
      end

      # puts l.parse_test(new_intents, :csv)
      # puts l.parse_test_report(new_intents, :json)
    end
  end
end
