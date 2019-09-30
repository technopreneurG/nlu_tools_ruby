# frozen_string_literal: true

module NluTools
  # The subcommand import
  class Import < Thor
    desc 'dialogflow', 'import the data in <file> into dialogflow'
    long_desc 'import the given input file data into given dialogflow <project>

              options:

              -f --file IMPORTDATA_FILENAME the file containing data for importing

              -p --project_id PROJECT_ID the google project-id

    '
    option :file,
           :aliases => :f,
           :banner => 'IMPORTDATA_FILENAME',
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
      intents.each do |intent|
        i = d.new_intent(intent['intent'], intent['train'])
        d.create_intent(i)
      end
    end
  end
end
