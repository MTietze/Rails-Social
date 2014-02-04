$(function() {
  $('.reply a').click(function(e) {
    var recipient = "@" + $(this).text() + " ";
    $("#micropost_content").val(recipient + $("#micropost_content").val()); 
    e.preventDefault();// prevent the default anchor functionality
    $('.reply a').off('click');
  });
});
