$(document).ready(function () {
  // Thay đổi state và update variant text khi click chọn variant
  $(".optionBlock").click(function () {
    if (!$(this).hasClass("active")) {
      var $this = $(this);
      var $articleSelectVerPr = $this.closest('.articleSelectVerPr');

      // Update active state
      $articleSelectVerPr.find(".optionBlock").removeClass("active");
      $this.addClass("active");

      // Update text
      var verText = $this.find(".infoOptionPr .nameOptionPr").text() || $this.attr("name");
      if (verText) {
        $articleSelectVerPr.find(".titleSelectVer .verText").text(verText);
      }
    }
  });


  $(".option").on("click", function () {
    let $option = $(this);
    let $productBlock = $option.closest(".specialBlock_28");
    let data_variant = "";
    let variant = {};



    // lấy các variant đang chọn
    $productBlock.find(".variant_options").each(function () {
      let $variantOpt = $(this);
      let key = $variantOpt.find(".variant_name").attr("key");
      let value = $variantOpt.find(".option.active").attr("name");

      data_variant += `[${key}='${value}']`;
      variant[key] = value;

      // gán vào hidden input
      $(`input[name="variants[${key}]"]`).val(value);
    });

    // tìm đúng variant trong list
    let $data = $(".variants p" + data_variant);
    let variant_id = $data.attr("variant_id");

    // lấy thông tin variant
    let price = parseInt($data.attr("price") || 0, 10);
    let oldPrice = parseInt($data.attr("original_price") || 0, 10);
    let dataImg = $data.attr("image_url");
    let sku = $data.attr("sku") || "";


    // cập nhật UI nếu tìm thấy variant
    if ($data.length > 0) {
      $productBlock.find("input#price").val(price);
      $productBlock.find(".price_change").text(Intl.NumberFormat("de-DE").format(price));
      $productBlock.find(".sku_change").text(sku);
      $productBlock.find(".oldprice_change").text(Intl.NumberFormat("de-DE").format(oldPrice));

      // đổi ảnh chính & ảnh nhỏ
      $(".specialBlock_27 .bigImgBlock .imgPart.firstImgPart img").attr("src", dataImg);
      $(".specialBlock_27 .smallImgBlock .imgPart.firstImgPart img").attr("src", dataImg);
      $productBlock.closest(".specialBlock_25").find(".left-block .wrap-image img").attr("src", dataImg);

      // bật nút add-to-cart
      $productBlock.find(".cart").removeClass("disabled-add-to-cart").addClass("add-to-cart");
      // bật nút .submit-direct-order
      $productBlock.find(".btn-submit-direct-order").removeClass("disabled-add-to-cart").addClass("submit-direct-order");
      $productBlock.find(".btn-submit-direct-order").removeClass("disabled-add-to-cart").addClass("add-to-cart");
    } else {
      // disable nếu chưa chọn đúng variant
      $productBlock.find(".cart").addClass("disabled-add-to-cart").removeClass("add-to-cart");
      $productBlock.find(".btn-submit-direct-order").addClass("disabled-add-to-cart").removeClass("add-to-cart");
      $productBlock.find(".btn-submit-direct-order").addClass("disabled-add-to-cart").removeClass("submit-direct-order");
    }

    // cập nhật variant_id
    if (variant_id) {
      $("input#variant_id").val(variant_id);
      $(".add-to-cart").attr("data-variant-id", variant_id);
    } else {
      $("input#variant_id").removeAttr("value");
      $(".add-to-cart").removeAttr("data-variant-id");
    }
  });

  $(document).on('click', '.disabled-add-to-cart', function (e) {
    var $btn = $(this);

    // Chưa chọn đủ variant hoặc chưa sẵn sàng
    if (!$btn.hasClass('add-to-cart') || $btn.hasClass('disabled-add-to-cart')) {
      e.preventDefault();
      e.stopPropagation();

      //xử lí chưa chọn variant thì thêm class missing-selection cảnh báo
      let firstMissing = null;
      $('.variant_options').each(function () {
        const $group = $(this);
        const hasActive = $group.find('.option.active').length > 0;
        $group.toggleClass('missing-selection', !hasActive);
        if (!hasActive && !firstMissing) firstMissing = $group;
      });

      toastr.error('Vui lòng chọn option cho sản phẩm');
      return;
    }
  });

  toastr.options = {
    "timeOut": 5000,
    "extendedTimeOut": 1000,
    "closeButton": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": true,
  };

});
