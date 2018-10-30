document.addEventListener('turbolinks:load', () => {
  $('.table').DataTable();
  $('#ticker').keyup(() => {
    const ticker = $('#ticker').val();
    const price = $('#stock-price');
    const update = $('#last-updated');
    const date = new Date();

    fetch(`https://api.iextrading.com/1.0/stock/${ticker}/price`)
      .then(res => res.json())
      .then(res => {
        price.text(`$${res.toFixed(2)}`);
      })
      .catch(err => {
        price.text('Symbol not valid.');
      });
    
     update.text(date.toLocaleString());
  });
});