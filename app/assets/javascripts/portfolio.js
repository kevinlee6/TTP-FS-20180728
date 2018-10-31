$(document).ready(() => {
  $('.table').DataTable({
    'retrieve': true
  });

  const price = $('#price-per-share');
  const update = $('#last-updated');

  const getPrice = () => {
    const ticker = $('#ticker').val();
    
    if (ticker === '') {
      price.val('');
      return;
    };
    
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
  }

  $('.check-price-btn').click(() => {
    getPrice();
  });

  $('#ticker').keyup(() => {
    getPrice();
  });
});