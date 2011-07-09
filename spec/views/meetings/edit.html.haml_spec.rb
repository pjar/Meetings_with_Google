require 'spec_helper'

describe "meetings/edit.html.haml" do
  before(:each) do
    @meeting = assign(:meeting, stub_model(Meeting,
      :title => "MyString",
      :description => "MyText",
      :place => "MyString",
      :tutor => "MyString",
      :total_places => 1,
      :google_event_id => "MyString",
      :google_sync_status => "MyString"
    ))
  end

  it "renders the edit meeting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => meetings_path(@meeting), :method => "post" do
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
