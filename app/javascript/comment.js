$(function() {
  $('form.wk-comment-form').validate({
    rules: {
      content: {
        required: true,
      },
      name: {
        required: true,
      },
      phone: {
        required: true,
        phoneNumber: true,
      }    },
    messages: {
      content: 'Vui lòng nhập cảm nhận của bạn',
      name: "Vui lòng nhập tên",
      phone: {
        required: "Vui lòng nhập số điện thoại",
        phoneNumber: 'Vui lòng nhập đúng số điện thoại',
      },
    },
    submitHandler: function(form, e) {
      e.preventDefault();
      $(form).find($('button[type="submit"]')).attr("disabled", true);
      const url = $(form).attr('action');
      data = $(form).serializeArray();

      $.ajax({
        url: url,
        type: 'POST',
        data: data,
        success: function(res) {
          if (res.success) {
            html = `<div class='alert alert-success' role='alert'>
              <h4 class='alert-heading text-center'>Cảm ơn bạn đã gửi cảm nhận</h4>
              <p>Hệ thống sẽ kiểm duyệt đánh giá của bạn và đăng lên sau 24h nếu phù hợp</p>
            </div>`
          }else {
            html = `<div class='alert alert-danger' role='alert'>
              <h4 class='alert-heading'>Cảm ơn bạn đã gửi cảm nhận</h4>
              <p>Đánh giá của bạn chưa được gửi thành công. Vui lòng thử lại sau</p>
            </div>`
          }

          if ($('#comment-message-modal').length > 0) {
            $('#comment-message-modal').find('.comment-result-message').html(html);
            $('#comment-message-modal').modal('show');
          }

          $(form).closest('.wk-comments-container').find('.wk-comments-body').prepend(decodeURI(res.comment_html));
        },
        error: function(err) {
          alert("Hệ thống đang bận, vui lòng thử lại sau");
        }
      })
    }
  });
})

$(document).ready(function() {
  $('.wk-comments-container').each((index, container) => loadComments(container, 1));

  $(document).on('click', '.wk-comments-container .load-more-comments', function(e) {
    const page = $(this).attr('data-page');
    const container = $(this).closest('.wk-comments-container');
    loadComments(container, page);
  })
})

function loadComments(container, page) {
  const body = $(container).find('.wk-comments-body');
  const owner_id = $(body).data('owner-id');
  const owner_type = $(body).data('owner-type');
  const url = $(body).data('url');

  $.ajax({
    url: url,
    type: 'GET',
    data: {
      owner_id: owner_id,
      owner_type: owner_type,
      page: page
    },
    success: function(res) {
      $(body).append(res.html);

      if (res.load_more) {
        $(container).find('.load-more-comments').removeClass('d-none');
        $(container).find('.load-more-comments').attr('data-page', `${res.page}`);
      }else {
        $(container).find('.load-more-comments').addClass('d-none');
      }
    },
    error: function(err) {
      console.log(err);
    }
  })
}
