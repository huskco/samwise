$(function() {
  $(".alert").each(function(index) {
    const $alert = $(this)
    const delay = ((index + 1) * 1000) + 4000;
    setTimeout(function() {
      $alert.addClass("transition-out");
    }, delay);
  });
});
