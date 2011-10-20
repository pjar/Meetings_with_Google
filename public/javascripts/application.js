// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
   $("#meeting_meeting_date").datepicker( { dateFormat: 'yy-mm-dd' });
});

$(function() {
   $("#meeting_start_time").timeEntry( {show24Hours: true, timeSteps: [1, 10]} );
});

$(function() {
   $("#meeting_end_time").timeEntry( {show24Hours: true, timeSteps: [1, 10]} );
});

