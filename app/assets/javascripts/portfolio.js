$(document).ready(() => {
  $(".table").DataTable({
    retrieve: true,
    columnDefs: [{ orderable: false, targets: 5 }]
  });

  const API_PREFIX = "https://cloud.iexapis.com/v1/stock";
  const API_SUFFIX = "token=pk_b39407374e9f40cd9ae9d082c95e7fd9";

  const price = $(".price-per-share");
  const update = $(".last-updated");
  const total = $(".total-price");
  const qty = $(".qty");
  const errorMsg = "Symbol not valid.";
  const errors = $(".errors");

  const hideErrors = () => errors.hide();

  const getPrice = () => {
    hideErrors();
    const ticker = $(".ticker").val();

    if (ticker === "") {
      price.val("");
      total.val("");
      return;
    }

    const date = new Date();

    fetch(`${API_PREFIX}/${ticker}/quote?${API_SUFFIX}`)
      .then(res => res.json())
      .then(
        res => {
          const { latestPrice } = res;
          price.val(`${latestPrice.toFixed(2)}`);
          const amt = qty.val();
          total.val(`${(latestPrice * amt).toFixed(2)}`);
        },
        rej => {
          price.val(errorMsg);
          total.val("");
        }
      );

    update.val(date.toLocaleString());
  };

  $(".check-price-btn").click(e => {
    e.preventDefault();
    getPrice();
  });

  $(".ticker").keyup(() => {
    getPrice();
  });

  $(".qty").bind("keyup change", () => {
    hideErrors();
    const currQty = qty.val();
    const currPrice = price.val();
    if (!currQty || currPrice === errorMsg) {
      total.val("");
      return;
    }
    const totalPrice = currQty * currPrice;
    total.val(`${totalPrice.toFixed(2)}`);
  });
});
