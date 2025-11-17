window.handleUploadBrowse = function(e){
  var action = e.form.action;
  var method = e.form.method;
  const formData = new FormData();
  var file = $("#upload-file")[0].files[0]

  const limitSize = window.IMAGE_LIMIT_SIZE || 1 * 1024 *1024;
  if (!validateImageSize(file, limitSize)) return false;

  formData.append("upload", file, file.name);
  $.ajax({
    method: method,
    url: action,
    data: formData,
    mimeType: 'multipart/form-data',
    contentType: false,
    dataType: 'json',
    processData: false,
    success: function(res){
      if(res['uploaded'] == 1){
        var show_tag = "img"
        if(res['mediaType'] == 'video'){
          show_tag = 'video'
        }

        $("#append-echo").after(`
           <div class="card mt-2 mr-2 float-left hoverable" onclick="browseItemClick(this, ${e.form.dataset.ckeditorfuncnum}, '${res['url']}');" style="width: 11rem;">
             <a class="btn btn-danger ck-delete-btn" onclick="handleDeleteImage(event, this, '${res['key']}')">
               <i class="bi bi-trash"></i>
             </a>
             <${show_tag} alt="${res['fileName']}" class="card-img-top" src="${res['url']}"></${show_tag}>
             <div class="card-body p-2" style="font-size: 80%;">
               <p class="card-text">${res['fileName']}</p>
             </div>
             <div class="card-footer p-2">
               <small class="text-muted">Just now</small>
             </div>
           </div>
         `)
      }
    }
  });
}

window.handleDeleteImage = function(event, ele, key){
  event.preventDefault();
  event.stopPropagation();
  if(window.confirm("Are you sure?")){
    $.ajax({
      method: 'delete',
      url: `/admin/medias/files/${key}`,
      contentType: false,
      dataType: 'json',
      success: function(res){
        ele.parentElement.remove()
      }
    });
  }
}

window.browseItemClick = function (e, funcNum, url){
  window.opener.CKEDITOR.tools.callFunction(funcNum, url);
  window.close();
}

