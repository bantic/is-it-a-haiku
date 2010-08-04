jQuery( function() {
  $(".dismiss").click(function() {
    var object_id = $(this).attr("href").split("#")[1];
    var ajax_url = "/dismiss/" + object_id;
    $.ajax({
      url: ajax_url,
      type: "POST",
      success: function() { $("#" + object_id).hide() },
      error: function() { alert("There was an error"); }
    });
    return false;
  });
});
