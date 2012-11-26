# Exceptiontrap

This gem is used to catch and report your Ruby on Rails applications errors and exceptions to the [Exceptiontrap](https://alpha.exceptiontrap.com) webservice.

The gem is compatible with the following Rails versions

- >= 2.3
- >= 3

**This is an Alpha Release**

## Setup

### Rails 3

#### 1. Install

Install the Exceptiontrap gem by putting this line to your `Gemfile`

    gem 'exceptiontrap'

then run `bundle`

#### 2. Configure

Now generate the `config/exceptiontrap.yml` file with

    rails generate exceptiontrap --api-key YOUR_API_KEY

and you should be fine.

### Rails 2.3

#### 1a. Install (with Bundler)

Install the Exceptiontrap gem by putting this line to your `Gemfile`

    gem 'exceptiontrap'

then run `bundle`

#### 1b. Install (without Bundler)

Install the Exceptiontrap gem by putting this line to your `config/environment.rb` file

    config.gem 'exceptiontrap'

then run `rake gems:install`

#### 2. Configure

Now generate the `config/exceptiontrap.yml` file with

    script/generate exceptiontrap --api-key YOUR_API_KEY

and you should be fine.

## Information / Further Configuration

You can find your API-Key by login to your [Exceptiontrap Account](https://alpha.exceptiontrap.com/login), select the application and follow the `Setup` Link.

## Known Issues / Todo

At the moment ActionController::RoutingError's are not catched in Rails 3 applications.

SSL-Support is not included.

Optimize and insert the test suite to the gem.


Copyright (c) 2012 [Torsten Bühl], released under the MIT license
