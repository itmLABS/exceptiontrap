# Exceptiontrap

This gem is used to catch and report your Ruby on Rails applications errors and exceptions to the [Exceptiontrap](https://exceptiontrap.com) webservice.

The gem is compatible with the following Rails versions

- >= 2.3
- 3 and 4

## Setup

### Rails 3 / 4

#### 1. Install

Install the Exceptiontrap gem by putting this line to your `Gemfile`

    gem 'exceptiontrap'

then run `bundle`

#### 2. Configure

Now generate the `config/exceptiontrap.yml` file with

    rails generate exceptiontrap --api-key YOUR_API_KEY

and you should be fine.

**Note:** Some exceptions are ignored by default, e.g. `RoutingError` and `RecordNotFound` errors. You can change this behavior in the just generated `config/exceptiontrap.yml` file.

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

**Note:** Some exceptions are ignored by default, e.g. `RoutingError` and `RecordNotFound` errors. You can change this behavior in the just generated `config/exceptiontrap.yml` file.

## Information / Further Configuration

You can find your API-Key by login to your [Exceptiontrap Account](https://exceptiontrap.com/login), select the application and follow the `Setup` Link.

## Integration with Background Jobs and Workers

### Sidekiq

Exceptiontrap catches [Sidekiq](http://sidekiq.org) errors automatically, you don't have to do anything. Easy, right?

### DelayedJob

There is no automatic integration into [DelayedJob](https://github.com/collectiveidea/delayed_job) yet. Meanwhile you can let Exceptiontrap notifiy you about errors using its `notify` method inside DelayedJobs `error` hook.

```ruby
class ParanoidNewsletterJob < NewsletterJob
  # ...

  def error(job, exception)
    Exceptiontrap.notify(exception, custom_controller: job.class.name)
  end
end
```

### Resque

automatic integration into [Resque](https://github.com/resque/resque) yet. Meanwhile you can let Exceptiontrap notifiy you about errors using its `notify` method inside Resques `on_failure` hook.

You can also create a module with Exceptiontrap enabled and integrate this.

```ruby
module ExceptiontrapJob
  def on_failure(exception, *args)
    Exceptiontrap.notify(exception, args)
  end
end

class MyJob
  extend ExceptiontrapJob
  def self.perform(*args)
    ...
  end
end
```

## Known Issues / Todo

Optimize and insert the test suite to the gem.


Copyright (c) 2013 [Torsten Bühl], released under the MIT license
