# config-file-loader

Inspired/ ripped off from Ryan Bate's great railscast

[http://railscasts.com/episodes/85-yaml-configuration-file]()

## features

* configuration file is in yaml
* supports erb in yaml file
* assumes/adds yml extension
* assumes file is in config/
* can override config file location per file (using an absolute or relative path) or globally 
* allows custom override files, so for local developers or production per machine values
* different variable values for different "Rails" environments.
* works in Rails, but also in non rails-projects.

## file format

  supports aliases, erb, and any yaml construct.

    defaults: &defaults
      d1: v1
      d2: v2
    development:
      <<: *defaults
      attribute1: value1
      attribute2:
        attribute2a: value2a
        attribute2b: value2b
      attribute3: <%= ENV['USER'] %>
    test:
      <<: *defaults
      attribute1: value1b
    ...

override file:

    development:
      attribute2:
        attribute2a: replaced-value2a

Note: override files do deep merges. but yml files ( <<: *defaults and &defaults) does not work for deep merge

But a separate override file will merge in values. So in development, only attribute2a will be replaced.

## Installation

Add this line to your application's Gemfile:

    gem 'config_file_loader'

## Usage

    APP_CONFIG = ConfigFileLoader.load(
      'app_config',
      'app_config_local.yml',
      '/opt/local/config/app_config_override.yml'
    )


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Contributions

Thanks to @brodock

## Copyright

Copyright (c) 2012 kbrock. See LICENSE for details.
