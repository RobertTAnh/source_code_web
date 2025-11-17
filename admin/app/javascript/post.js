$(function () {
  'use strict'

  console.log('Admin loaded');
  $('.dropify').dropify({
    tpl: {
        wrap:            '<div class="dropify-wrapper"></div>',
        loader:          '<div class="dropify-loader"></div>',
        message:         '<div class="dropify-message"><span class="file-icon"></span> <p>{{ default }}</p></div>',
        preview:         '<div class="dropify-preview"><span class="dropify-render"></span><div class="dropify-infos"><div class="dropify-infos-inner"><p class="dropify-infos-message">{{ replace }}</p></div></div></div>',
        filename:        '<p class="dropify-filename"><span class="file-icon"></span> <span class="dropify-filename-inner"></span></p>',
        clearButton:     '<button type="button" class="dropify-clear">{{ remove }}</button>',
        errorLine:       '<p class="dropify-error">{{ error }}</p>',
        errorsContainer: '<div class="dropify-errors-container"><ul></ul></div>'
    }
  });
});

// Function for datepicker
$(function () {
  'use strict'

  addDatePicker($('.datepicker'))
})

$(document).on('change', '.record-status-field', function(){
  if ($(this).val() == 'unpublished'){
    addDatePicker($('#post_release_date'));
    $('#post_release_date').prop('disabled', false);
  }else{
    $('#post_release_date').val('');
    $('#post_release_date').prop('disabled', true);
  }
})

function addDatePicker(element){
  element.datepicker({ format: 'dd-mm-yyyy' });
  $('.gj-datepicker i.gj-icon').remove();
  element.removeClass('gj-textbox-md');
}

function csrfParam(){
  return $('meta[name=csrf-param]').attr('content');
}

function csrfToken(){
  return $('meta[name=csrf-token]').attr('content');
}

function handleDeleteSlug(e, id){
  if(window.confirm("Are you sure?")){
    var data = {};
    data[csrfParam()] = csrfToken()

    $.ajax({
      type: "DELETE",
      url : `/admin/global_slugs/${id}`,
      data: data,
      success: function(data){
        e.parentElement.parentElement.parentElement.remove();
        return;
      },
      error: function(xhr, status, error) {
	alert(xhr.responseText)
      }
    })
  }
}

window.handleDeleteSlug = handleDeleteSlug;

window.handleUploadMedias = function(e) {
  var action = e.form.action;
  var method = e.form.method;
  const formData = new FormData();
  var file = $("#upload-file_medias")[0].files[0];
  formData.append("upload", file, file.name);
  $.ajax({
  method,
  url: action,
  data: formData,
  mimeType: "multipart/form-data",
  contentType: false,
  dataType: "json",
  processData: false,
  success: function(res) {
    $(`#append-echo-${res["type"]} .row .col-2:first`).after(`
      <div class="col-2">
        <div class="card mt-2 mr-2 float-left" style="width: 11rem;">
          <a class="btn btn-danger ck-delete-btn" onclick="handleDeleteImage(event, this, '${res["key"]}')">
            <i class="bi bi-trash"></i>
          </a>
          <img alt="${res["fileName"]}" class="card-img-top img-list" src="${res["url"]}">
          <div class="card-body p-2" style="font-size: 80%;">
            <p class="card-text">${res["fileName"]}</p>
            <div class="row">
              <div class="col-9">
                <a class="card-text medias-url-wrap" target="_blank" href="${res["url"]}">${res["url"]}</a>
              </div>
              <div class="col-3">
                <button name="button" type="button" class="btn btn-outline-primary btn-sm" onclick="copyToClipboard('${res["url"]}')" data-toggle="tooltip" data-placement="top" title="Copy link""><i class="bi bi-clipboard"></i>
                </button>
             </div>
           </div>
          </div>
          <div class="card-footer p-2">
            <small class="text-muted">Just now</small>
          </div>
        </div>
      </div>
      `);
    closeModal()
  }
});
};

function handleDeleteVariant(e, id){
  if(window.confirm("Are you sure?")){
    var data = {};
    data[csrfParam()] = csrfToken()

    $.ajax({
      type: "DELETE",
      url : `/admin/variants/${id}`,
      data: data,
      success: function(data){
        e.parentElement.parentElement.parentElement.remove();
        return;
      },
      error: function(xhr, status, error) {
	alert(xhr.responseText)
      }
    })
  }
}

window.handleDeleteVariant = handleDeleteVariant
