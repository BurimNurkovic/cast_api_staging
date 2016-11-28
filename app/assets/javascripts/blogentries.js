/*global $, console */

function showHideFields() {
  var self = $('#blogentry_blog_type');
  if (self.val() === 'video') {
    $('#blogentry_url_input').hide();
    $('#blogentry_image_input').hide();
    $('#blogentry_text_input').show();
    $('#blogentry_video_url_input').show();
  } else if (self.val() === 'text') {
    $('#blogentry_url_input').hide();
    $('#blogentry_image_input').show();
    $('#blogentry_text_input').show();
    $('#blogentry_video_url_input').hide();
  } else if (self.val() === 'url') {
    $('#blogentry_url_input').show();
    $('#blogentry_image_input').show();
    $('#blogentry_text_input').hide();
    $('#blogentry_video_url_input').hide();
  }
}

$(document).ready(function () {
  showHideFields();
  $('#blogentry_blog_type').change(showHideFields);
});