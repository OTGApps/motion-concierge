describe "motion-concierge" do
  before do
    @name = "dropzones.geojson"
    @url = "https://raw.githubusercontent.com/OTGApps/USPADropzones/master/dropzones.geojson"
    @interval = 1200
    @debug_interval = 2

    NSUserDefaults.standardUserDefaults.removeObjectForKey("motion_concierge_last_data_check")
    NSUserDefaults.standardUserDefaults.synchronize

    mc.local_file_name = @name
    mc.remote_file_url = @url
    mc.fetch_interval = @interval
    mc.debug = true
    mc.debug_fetch_interval = @debug_interval
  end

  after do
    mc.local_file_name = nil
    mc.remote_file_url = nil
    mc.fetch_interval = nil
    mc.debug = false
    mc.debug_fetch_interval = nil
    mc.last_fetch = 0
  end

  def mc
    MotionConcierge
  end

  it "initializes a concierge object with methods" do
    [:local_file_name, :local_file_path, :downloaded_file_exists?].each do |method|
      mc.methods.include?(method).should == true
    end
  end

  it "has a local file name" do
    mc.local_file_name.should == @name
  end

  it "has a remote file url" do
    mc.remote_file_url.should == @url
  end

  it "has a fetch_interval" do
    mc.fetch_interval.should == @interval
  end

  it "turns on and off debug mode" do
    mc.debug?.should == true
    mc.debug = false
    mc.debug?.should == false
  end

  it "has default fetch times" do
    mc.fetch_interval = nil
    mc.debug_fetch_interval = nil

    mc.fetch_interval.should == 86400
    mc.debug_fetch_interval.should == 30
  end

  it "saves last checked time" do
    mc.last_fetch.should == 0

    time = Time.now.to_i

    mc.last_fetch = time
    mc.last_fetch.should == time
  end

  it "uses the file name form the url" do
    mc.local_file_name = nil
    mc.local_file_name.should == @url.split("/").last

    mc.remote_file_url = "http://google.com"
    mc.local_file_name.should == 'google.com'

    mc.remote_file_url = "http://google.com/"
    mc.local_file_name.should == 'google.com'
  end

  it "uses the documents path" do
    mc.local_file_path.split('/')[-2].should == 'Documents'
  end

  it "should have the correct check interval" do
    mc.check_interval.should == @debug_interval
    mc.debug = false
    mc.check_interval.should == @interval
  end

  it "should fetch when necessary" do
    mc.debug_fetch_interval = 1
    mc.fetch_interval = 1
    mc.last_fetch = Time.now
    mc.should_fetch?.should == false

    wait 2.0 do
      mc.should_fetch?.should == true
    end
  end

end
