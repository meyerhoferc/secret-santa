document.addEventListener('DOMContentLoaded', function() {
  var flash = document.querySelector('.warning') || document.querySelector('.notice');
  if (flash) {
    flash.addEventListener('click', function() {
      flash.style.display = 'none';
    });
  }
});
