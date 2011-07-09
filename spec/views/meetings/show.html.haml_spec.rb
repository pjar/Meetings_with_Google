require 'spec_helper'

describe "meetings/show.html.haml" do
  before(:each) do
    @meeting = assign(:meeting, stub_model(Meeting,
      :title => "Title",
      :description => "MyText",
      :place => "Place",
      :tutor => "Tutor",
      :total_places => 1,
      :google_event_id => "Google Event",
      :google_sync_status => "Google Sync Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Place/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tutor/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Google Event/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Google Sync Status/)
  end
end
