# NluTools

Useful NLU Tools to import training data into AWS Lex, Google Dialogflow and run tests

## Installation

To install:
```bash
$ gem install nlu_tools
```

## Usage

### get help
```bash
$ nlu_toolset help
$ nlu_toolset import help
$ nlu_toolset import help dialogflow
$ nlu_toolset import help lex
$ nlu_toolset test help
$ nlu_toolset test help lex
$ nlu_toolset test help dialogflow
```


### setup keys
```bash
$ export AWS_REGION='AWS_REGION'
$ export AWS_ACCESS_KEY_ID='AWS_ACCESS_KEY_ID'
$ export AWS_SECRET_ACCESS_KEY='AWS_SECRET_ACCESS_KEY'
$ export GOOGLE_APPLICATION_CREDENTIALS='/path/to/google-project-key.json'

```

### importing training data
```bash
$ nlu_toolset import lex -f ./data/simple_train.json --botname testbot

$ nlu_toolset import dialogflow -f ./data/simple_train.json -p google-project-id
```

### running tests
```bash
$ nlu_toolset test lex -f ./data/simple_test.json --botname testbot -o output_l.csv -t summary

$ nlu_toolset test dialogflow -f ./data/simple_test.json -p google-project-id -o output_d.csv
```

### creating training & test data
The training and testing data is a truncated version of the data obtained from [Watson Assistant Sample Application repo](https://github.com/watson-developer-cloud/assistant-simple/) / [bank_simple_workspace.json](https://github.com/watson-developer-cloud/assistant-simple/blob/master/training/bank_simple_workspace.json).
Generated using [jq](https://stedolan.github.io/jq/).

#### get all intents and its examples except the last 2 for training:
```bash
$ jq '[.intents[] | {"intent":.intent, "train":[.examples[].text] | .[:-2]}]' data/bank_simple_workspace.json > ./data/simple_train.json
```

#### get the last 2 intents and its examples for testing:
```bash
$ jq '[.intents[] | {"intent":.intent, "test":[.examples[].text] | .[-2:]}]' data/bank_simple_workspace.json > ./data/simple_test.json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nlu_tools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NluTools project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nlu_tools/blob/master/CODE_OF_CONDUCT.md).
