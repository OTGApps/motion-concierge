class MotionConcierge
  class << self

    def local_file_name=(file_name)
      @_local_file_name = file_name
    end

    def local_file_name
      @_local_file_name || @_remote_file_url.split("/").last
    end

    def remote_file_url=(url)
      @_remote_file_url = url
    end

    def fetch_interval=(interval)
      @_fetch_interval = interval
    end

    def debug_fetch_interval=(interval)
      @_debug_fetch_interval = interval
    end

    def downloaded_file_exists?
      local_file_name.document_path.file_exists?
    end

    def fetch
      if debug?
        puts "Fetching data from: #{@_remote_file_url}"
        puts " Saving it to: #{local_file_name}"
        puts " Every #{@_fetch_interval} seconds"
      end

      check_interval = debug? ? (@_debug_fetch_interval || 30) : @_fetch_interval

      if last_fetch < Time.now.to_i - check_interval
        puts "Data is old. Downloading new data file." if debug?
        AFMotion::HTTP.get(@_remote_file_url) do |result|
          if result.success?
            puts 'Got successful result from server.' if debug?
            result.object.write_to(local_file_name.document_path)
            last_fetch = Time.now.to_i
            NSNotificationCenter.defaultCenter.postNotificationName("MotionConciergeNewDataReceived", object:self)
          else
            if debug?
              puts "There was an error downloading the data from the server:"
              puts result.error.localizedDescription
            end
          end
        end
      else
        puts "Data is not stale. Not fetching." if debug?
      end
    end

    def last_fetch=(last)
      NSUserDefaults.standardUserDefaults.tap do |defaults|
        defaults.setInteger(last, forKey:"motion_concierge_last_data_check")
        defaults.synchronize
      end
    end

    def last_fetch
      NSUserDefaults.standardUserDefaults.integerForKey("motion_concierge_last_data_check")
    end

    # Debugging

    def debug=(debug)
      @_debug = !!debug
    end

    def debug?
      @_debug
    end
  end
end
