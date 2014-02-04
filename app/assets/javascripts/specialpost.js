$(function() {
  $('.recipient a').click(function(e) {
    if ($(this).hasClass("message"))
    var recipient = "*" + $(this).text() + " ";
    if ($(this).hasClass("reply"))
    var recipient = "@" + $(this).text() + " ";
    $("#micropost_content").val(recipient + $("#micropost_content").val()); 
    e.preventDefault();// prevent the default anchor functionality
    $('.recipient a').off('click');
  });
});
