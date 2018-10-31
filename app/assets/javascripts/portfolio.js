$(document).ready(() => {
  $('.table').DataTable({
    'retrieve': true
  });

  $('#ticker').keyup(() => {
    const ticker = $('#ticker').val();
    const price = $('#price-per-share');
    if (ticker === '') {
      price.val('');
      return;
    };
    const update = $('#last-updated');
    const date = new Date();

    fetch(`https://api.iextrading.com/1.0/stock/${ticker}/price`)
      .then(res => res.json())
      .then(res => {
        price.val(`${res.toFixed(2)}`);
      })
      .catch(err => {
        price.val('Symbol not valid.');
      });
    
    update.text(date.toLocaleString());
  });
});