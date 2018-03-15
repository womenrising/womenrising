// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(function() {
  $('#user_mentor').on('change', function() {
    $('#mentor_info').toggleClass('hidden', $(this).val() == 'false');
  }).trigger('change');

  $('#user_location_id').on('change', function() {
    $('#zip-code').toggleClass('hidden', $(this).val() !== '');
  }).trigger('change');

  $('.mentor_check_box').children('input[type="checkbox"]').each(function(index) {
    $(this).on('change', function() {
      $('.mentor_career_stage').eq(index).toggleClass('hidden', this.checked == false);
    }).trigger('change');
  });
});
