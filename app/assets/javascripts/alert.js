$(document).ready(() => {
  // 3000ms is length of alert/flash animation
  const alert = document.getElementsByClassName('alert');
  const parent = document.getElementsByClassName('main-content')[0];
  setTimeout(() => {
    if (alert.length) {
      for (let i = 0; i < alert.length; i++) {
        parent.removeChild(alert[i]);
      }
    }
  }, 3000); 
});