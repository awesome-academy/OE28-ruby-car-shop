$(document).on('turbolinks:load', function() {
  $('#sort').on('change', function() {
    var sort_type = $(this).val();
    $.ajax({
      method: 'POST',
      dataType: 'json',
      url: '/posts/update_index',
      dataType: 'script',
      data: {
        sort_type: sort_type,
      }
    });
  });
});
