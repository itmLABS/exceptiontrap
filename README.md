[![Gem Version](https://badge.fury.io/rb/exceptiontrap.svg)](https://badge.fury.io/rb/exceptiontrap)
[![Maintainability](https://api.codeclimate.com/v1/badges/54bdf2c81f42aac11680/maintainability)](https://codeclimate.com/github/itmLABS/exceptiontrap/maintainability)

# Exceptiontrap

This gem is used to catch and report your Ruby on Rails applications errors and exceptions to the [Exceptiontrap](https://exceptiontrap.com) webservice.

The gem is compatible with Rails >= 3 (yes, including Rails 7)

## Setup

### 1. Install

Install the Exceptiontrap gem by putting this line to your `Gemfile`

    gem 'exceptiontrap'

then run `bundle`

### 2. Configure

Now generate the `config/exceptiontrap.yml` file with

    rails generate exceptiontrap --api-key YOUR_API_KEY

and you should be fine.

**Note:** Some exceptions are ignored by default, e.g. `RoutingError` and `RecordNotFound` errors. You can change this behavior in the `config/exceptiontrap.yml` file that we just generated.

## Information / Further Configuration

You can find your API-Key by logging in to your [Exceptiontrap Account](https://exceptiontrap.com/login). Select the application, and follow the `Setup` link.

## Integration with Background Jobs and Workers

### Sidekiq

Exceptiontrap catches [Sidekiq](http://sidekiq.org) errors automatically. You don't have to set up anything. Easy, right?

### DelayedJob

There is no automatic integration into [DelayedJob](https://github.com/collectiveidea/delayed_job) yet. Meanwhile you can let Exceptiontrap notifiy you about errors using its `notify` method inside DelayedJob's `error` hook.

```ruby
class ParanoidNewsletterJob < NewsletterJob
  # ...

  def error(job, exception)
    Exceptiontrap.notify(exception, custom_controller: job.class.name)
  end
end
```

### Resque

There is no automatic integration into [Resque](https://github.com/resque/resque) yet. Meanwhile you can let Exceptiontrap notifiy you about errors using its `notify` method inside Resque's `on_failure` hook.

You can also create a module with Exceptiontrap enabled and integrate it.

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

## License

Copyright (c) 2021 [Torsten Bühl], released under the MIT license
