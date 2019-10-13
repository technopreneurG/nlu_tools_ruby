# frozen_string_literal: true
require 'pathname'
require 'json_schemer'

module NluTools
  # The subcommand import
  class Import < Thor
    desc 'dialogflow', 'import the data in <file> into Goole Dialogflow'
    long_desc 'import the given input file data into given Goole Dialogflow <project>

              options:

              -f --file IMPORTDATA_FILENAME the file containing data for importing

              -p --project_id PROJECT_ID the google project-id

    '
    option :file,
           aliases: :f,
           banner: 'IMPORTDATA_FILENAME',
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
      schema = Pathname.new('schema/nlu_training_data.json')
      schemer = JSONSchemer.schema(schema)
      if schemer.valid?(intents)
        d = NluAdapter.new(:Dialogflow,
                           project_id: options[:project_id],
                           session_id: 'SESSION1')
        intents['training_data'].each do |intent|
          i = d.new_intent(intent['intent'], intent['utterences'])
          d.create_intent(i)
        end
      else
        puts "Training data is not in valid format\nPlease check data/simple_train.json for reference"
        exit(1)
      end
    end

    desc 'lex', 'import the data in <file> into AWS Lex'
    long_desc 'import the given input file data into given Lex <botname>

              options:

              -f --file IMPORTDATA_FILENAME the file containing data for importing

              -b --botname BOTNAME the Lex bot name

    '
    option :file,
           aliases: :f,
           banner: 'IMPORTDATA_FILENAME',
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
      schema = Pathname.new('schema/nlu_training_data.json')
      schemer = JSONSchemer.schema(schema)
      if schemer.valid?(intents)
        l = NluAdapter.new(:Lex,
                           bot_name: options[:botname],
                           bot_alias: 'BotAlias',
                           user_id: 'user-1')
        lex_intents = []
        intents['training_data'].each do |intent|
          intent_name = intent['intent'].gsub('-', '_')
          i = l.new_intent(intent_name, intent['utterences'])
          lex_intents << i
        end

        ic = l.new_intent_collection(options[:botname], lex_intents)
        l.create_intent_collection(ic)
      else
        puts "Training data is not in valid format\nPlease check data/simple_train.json for reference"
        exit(1)
      end
    end
  end
end
