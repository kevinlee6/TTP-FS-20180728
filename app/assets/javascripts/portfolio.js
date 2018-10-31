$(document).ready(() => {
  $('.table').DataTable({
    'retrieve': true
  });

  const price = $('#price-per-share');
  const update = $('#last-updated');
  const total = $('#total-price');
  const qty = $('#qty');
  const errorMsg = 'Symbol not valid.'

  const getPrice = () => {
    const ticker = $('#ticker').val();
    
    if (ticker === '') {
      price.val('');
      total.val('');
      return;
    };
    
    const date = new Date();

    fetch(`https://api.iextrading.com/1.0/stock/${ticker}/price`)
      .then(res => res.json())
      .then(res => {
        price.val(`${res.toFixed(2)}`);
        const amt = qty.val();
        total.val(`${(res * amt).toFixed(2)}`);
      })
      .catch(() => {
        price.val(errorMsg);
        total.val('');
      });
    
    update.val(date.toLocaleString());
  }

  $('.check-price-btn').click(e => {
    e.preventDefault();
    getPrice();
  });

  $('#ticker').keyup(() => {
    getPrice();
  });

  $('#qty').bind('keyup change', () => {
    const currQty = qty.val();
    const currPrice = price.val();
    if (!currQty || currPrice === errorMsg) {
      total.val('');
      return;
    }
    const totalPrice = currQty * currPrice;
    total.val(`${totalPrice.toFixed(2)}`);
  });
});