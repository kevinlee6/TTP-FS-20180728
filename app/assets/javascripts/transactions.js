document.addEventListener('turbolinks:load', () => {
  $('.table').DataTable({
    'retrieve': true,
    'order': [[ 0, 'desc' ]]
  });
});