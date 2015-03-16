# motion-concierge

[![Build Status](https://travis-ci.org/OTGApps/motion-concierge.svg)](https://travis-ci.org/OTGApps/motion-concierge)
[![Gem Version](https://badge.fury.io/rb/motion-concierge.png)](http://badge.fury.io/rb/motion-concierge)

motion-concierge is your personal data concierge! Just provide a file name, and network url, and set up some basic rules regarding when to download the data and the concierge will automatically fetch your data for you from the web!

## Installation

Add this line to your application's Gemfile:

    gem 'motion-concierge'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-concierge

After installing, you'll need to install the needed pods:

    $ [bundle exec] rake pod:install

## Usage

```ruby
# You configure motion-concierge when the app first launches:
def application(application, didFinishLaunchingWithOptions:launchOptions)
    # Something here

    # Set up motion-concierge
    MotionConcierge.local_file_name = 'my_data_file.json'
    MotionConcierge.remote_file_url = 'http://whatever.com/my_data_file.json'
    MotionConcierge.fetch_interval = 86400 # Once a day
    # You can put it in debug mode too!
    MotionConcierge.debug = true
    MotionConcierge.debug_fetch_interval = 30 # Every 30 seconds


    # Something else here
end

# Then make sure to check for the data each time the app is launched
def applicationDidBecomeActive(application)
    # Check for new data is necessary
    MotionConcierge.fetch
end

```

That's it! From now on, every day (86400 seconds) when the app is launched, or comes back into the foreground, motion-concierge will check to see if it should download new data and then fire off a notification once it's recieved the data and saved it to disk so that you can listen for the event and refresh your interface as necessary.

Here's how you'd listen for the event:

```ruby
def listen_for_new_data
    NSNotificationCenter.defaultCenter.addObserver(self, selector:"reload_data", name:"MotionConciergeNewDataReceived", object:nil)
end

def reload_data(notification)
    puts "Got new data!"
end
```

You can use the local file easily!
```ruby
puts 'The file is located here: ' + MotionConcierge.local_file_path
puts 'The file contents are: ' + MotionConcierge.local_file_string
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
