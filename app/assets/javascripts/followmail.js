 $(function() {
  $('#followmail').click(function(e) {
    $.ajax({
    url: "toggle_followmail"
    });
  });
}); 