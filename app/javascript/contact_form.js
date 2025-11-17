function addCustomValidators() {
  $.validator.addMethod('phoneNumber', function(value, element) {
    const phonePattern = /(09|02|03|07|08|05)+([0-9 -()+])+$/;

    return this.optional(element) || (
      value.length >= 10 && value.length <= 12 && phonePattern.test(value)
    )
  }, 'Please specify the correct phone number');
}

$(function() {
  addCustomValidators();

  $('form.contact-form').submit((event) => {
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
      url: '/contacts',
      success: (data) => {
        form.trigger('onSuccess', [data]);

        window.location = form.attr('target');
      },
      error: (error) => {
        form.trigger('onError', [error]);

        alert('Error, please try again!');
      }
    });
  });
});
