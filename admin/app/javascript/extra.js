window.validateImageSize = function(file, maxSize, msg="") {
  // maxSize: byte
  if (!file) {
    return true
  }

  if(file.type.match(/^image/)){
    const fileSize = file.size;
    var limit = `${Math.round(maxSize / 1024)}KB`;

    if (fileSize > 1 * 1024 * 1024){
      limit = `${Math.round(maxSize / (1024 * 1024))}MB`;
    }

    if (fileSize > maxSize) {
      msg = msg || `File bạn upload > ${limit} gây ảnh hưởng đến hiệu năng của website. Vui lòng tối ưu ảnh và upload lại`;
      toastr.error(msg);
      return false;
    }

    return true;
  }

  return true;
}
