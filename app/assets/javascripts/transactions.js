$(document).ready(() => {
  $('.table').DataTable({
    'retrieve': true,
    'order': [[ 0, 'desc' ]]
  });
});
