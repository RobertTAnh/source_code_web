function onFormSubmit(event) {
  event.preventDefault();

  const form = $(event.target);

  if (!form.valid()) {
    form.trigger('onInvalid');
    return;
  }

  form.trigger('onValid');

  $.ajax({
    type: 'POST',
    data : form.serialize(),
    url: '/orders',
    success: (data) => {
      form.trigger('onSuccess', [data]);

      window.location = data.tracking;
    },
    error: (error) => {
      form.trigger('onError', [error]);

      alert('Error, please try again!');
    }
  });
}

function onProductFormSubmit(event) {
  event.preventDefault();

  const form = $(event.target);

  if (!form.valid()) {
    form.trigger('onInvalid');
    return;
  }

  form.trigger('onValid');

  $.ajax({
    type: 'POST',
    data : form.serialize(),
    url: '/orders',
    success: (data) => {
      form.trigger('onSuccess', [data]);

      window.location = form.attr('target');
    },
    error: (error) => {
      form.trigger('onError', [error]);

      alert('Error, please try again!');
    }
  });
}

$(function() {
  $('form.order-form').submit(onFormSubmit);
  $('form.product-form').submit(onProductFormSubmit);
});
