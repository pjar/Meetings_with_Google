require 'spec_helper'

describe "meetings/new.html.haml" do
  before(:each) do
    assign(:meeting, stub_model(Meeting,
      :title => "MyString",
      :description => "MyText",
      :place => "MyString",
      :tutor => "MyString",
      :total_places => 1,
      :google_event_id => "MyString",
      :google_sync_status => "MyString"
    ).as_new_record)
  end

  it "renders new meeting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => meetings_path, :method => "post" do
      assert_select "input#meeting_title", :name => "meeting[title]"
      assert_select "textarea#meeting_description", :name => "meeting[description]"
      assert_select "input#meeting_place", :name => "meeting[place]"
      assert_select "input#meeting_tutor", :name => "meeting[tutor]"
      assert_select "input#meeting_total_places", :name => "meeting[total_places]"
      assert_select "input#meeting_google_event_id", :name => "meeting[google_event_id]"
      assert_select "input#meeting_google_sync_status", :name => "meeting[google_sync_status]"
    end
  end
end
