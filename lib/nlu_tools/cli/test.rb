# frozen_string_literal: true

module NluTools
  # The subcommand for test
  class Test < Thor
    desc 'dialogflow', 'test the data in <file> using dialogflow'
    long_desc 'test the given input file data using dialogflow

              options:

              -f --file TESTDATA_FILENAME the file containing data for testing

              -p --project_id PROJECT_ID the google project-id

    '
    option :file,
           :aliases => :f,
           :banner => 'TESTDATA_FILENAME',
           :type => :string, :required => true
    option :project_id,
           :aliases => :p,
           :banner => 'PROJECT_ID',
           :type => :string, :required => true
    def dialogflow
      unless File.exist?(options[:file])
        puts "File #{options[:file]} does not exist"
        exit(1)
      end

      intents = JSON.parse(File.read(options[:file]))
      d = NluAdapter.new(:Dialogflow,
                         :project_id => options[:project_id],
                         :session_id => 'SESSION1')

      new_intents = {}
      intents.each do |intent|
        new_intents[intent['intent']] = intent['test']
      end

      # puts d.parse_test(new_intents, :csv)
      # puts d.parse_test_report(new_intents, :json)
    end
  end
end
