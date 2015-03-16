describe "motion-concierge" do
  before do
    @name = "dropzones.geojson"
    @url = "https://raw.githubusercontent.com/OTGApps/USPADropzones/master/dropzones.geojson"
    @interval = 1200
    @debug_interval = 2

    NSUserDefaults.standardUserDefaults.removeObjectForKey("motion_concierge_last_data_check")
    NSUserDefaults.standardUserDefaults.synchronize

    MotionConcierge.local_file_name = @name
    MotionConcierge.remote_file_url = @url
    MotionConcierge.fetch_interval = @interval
    MotionConcierge.debug = true
    MotionConcierge.debug_fetch_interval = @debug_interval
  end

  after do
    MotionConcierge.local_file_name = nil
    MotionConcierge.remote_file_url = nil
    MotionConcierge.fetch_interval = nil
    MotionConcierge.debug = false
    MotionConcierge.debug_fetch_interval = nil
    MotionConcierge.last_fetch = 0
  end

  it "initializes a concierge object with methods" do
    [:local_file_name, :local_file_path, :downloaded_file_exists?].each do |method|
      MotionConcierge.methods.include?(method).should == true
    end
  end

  it "has a local file name" do
    MotionConcierge.local_file_name.should == @name
  end

  it "has a remote file url" do
    MotionConcierge.remote_file_url.should == @url
  end

  it "has a fetch_interval" do
    MotionConcierge.fetch_interval.should == @interval
  end

  it "turns on and off debug mode" do
    MotionConcierge.debug?.should == true
    MotionConcierge.debug = false
    MotionConcierge.debug?.should == false
  end

  it "has default fetch times" do
    MotionConcierge.fetch_interval = nil
    MotionConcierge.debug_fetch_interval = nil

    MotionConcierge.fetch_interval.should == 86400
    MotionConcierge.debug_fetch_interval.should == 30
  end

  it "saves last checked time" do
    MotionConcierge.last_fetch.should == 0

    time = Time.now.to_i

    MotionConcierge.last_fetch = time
    MotionConcierge.last_fetch.should == time
  end

  it "uses the file name form the url" do
    MotionConcierge.local_file_name = nil
    MotionConcierge.local_file_name.should == @url.split("/").last

    MotionConcierge.remote_file_url = "http://google.com"
    MotionConcierge.local_file_name.should == 'google.com'

    MotionConcierge.remote_file_url = "http://google.com/"
    MotionConcierge.local_file_name.should == 'google.com'
  end

  it "uses the documents path" do
    MotionConcierge.local_file_path.split('/')[-2].should == 'Documents'
  end

  it "should have the correct check interval" do
    MotionConcierge.check_interval.should == @debug_interval
    MotionConcierge.debug = false
    MotionConcierge.check_interval.should == @interval
  end

  it "should fetch when necessary" do
    MotionConcierge.debug_fetch_interval = 1
    MotionConcierge.fetch_interval = 1
    MotionConcierge.last_fetch = Time.now
    MotionConcierge.should_fetch?.should == false

    wait 2.0 do
      MotionConcierge.should_fetch?.should == true
    end
  end

end
