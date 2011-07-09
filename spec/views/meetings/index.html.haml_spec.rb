require 'spec_helper'

describe "meetings/index.html.haml" do
  before(:each) do
    assign(:meetings, [
      stub_model(Meeting,
        :title => "Title",
        :description => "MyText",
        :place => "Place",
        :tutor => "Tutor",
        :total_places => 1,
        :google_event_id => "Google Event",
        :google_sync_status => "Google Sync Status"
      ),
      stub_model(Meeting,
        :title => "Title",
        :description => "MyText",
        :place => "Place",
        :tutor => "Tutor",
        :total_places => 1,
        :google_event_id => "Google Event",
        :google_sync_status => "Google Sync Status"
      )
    ])
  end

  it "renders a list of meetings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Place".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Tutor".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Google Event".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Google Sync Status".to_s, :count => 2
  end
end
