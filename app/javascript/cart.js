function formatCurrency(amount) {
  return amount.toLocaleString('vi-VN') + 'đ';
}

function addToCart(event) {
  const data = getCartItemData(event);
  createCartItem(data);
}

function removeCartItem(event) {
  const cartItemId = $(event.target).data('cart-item-id');
  if (cartItemId) {
    deleteCartItem(cartItemId);
  }
}

function changeCartItemQuantity(event) {
  const cartItemId = $(event.target).data('cart-item-id');
  const newQuantity = parseInt($(event.target).val());
  if (newQuantity > 0) {
    updateCartItem(cartItemId, { quantity: newQuantity });
  } else {
    deleteCartItem(cartItemId);
  }
}

function toggleCartItemCheckbox(event) {
  const cartItemRow = $(event.target.closest('.cart-item-row'));
  const totalPrice = parseFloat(cartItemRow.data('total-price'));
  const changedAmount = event.target.checked ? totalPrice : -totalPrice;

  updateCartSubTotal(changedAmount);
}

function toggleCartItemsCheckboxAll(event) {
  if (event.target.checked) {
    updateCartSubTotal(null, calcSelectedCartItemsTotalPrice());
  } else {
    updateCartSubTotal(null, 0);
  }
}

function changeProductFormQuantity(event) {
  const quantity = parseInt($(event.target).val());
  $('.product-form .add-to-cart').data('quantity', quantity);
}

function submitCart() {
  const selected = getSelectedCartItems();

  if (selected.length == 0) {
    alert("Vui lòng chọn sản phẩm");
    return;
  }

  createDraftOrder({ cart_items: selected });
}

function createCartItem(data) {
  $.ajax({
    type: 'POST',
    data : injectCSRFToken(data),
    url: '/cart_items',
    success: (data) => {
      onCartItemAdded();
    },
    error: () => {
      alert('Error, please try again!');
    }
  });
}

function updateCartItem(cartItemId, data) {
  $.ajax({
    type: 'PUT',
    data : injectCSRFToken(data),
    url: `/cart_items/${cartItemId}`,
    success: (data) => {
      updateCartQuantity(cartItemId, data.quantity);
    },
    error: () => {
      alert('Error, please try again!');
    }
  });
}

function deleteCartItem(cartItemId) {
  $.ajax({
    type: 'DELETE',
    data : injectCSRFToken({}),
    url: `/cart_items/${cartItemId}`,
    success: (data) => {
      onCartItemRemoved(data)
    },
    error: () => {
      alert('Error, please try again!');
    }
  });
}

function createDraftOrder(data) {
  data.draft = true;

  $.ajax({
    type: 'POST',
    data : injectCSRFToken(data),
    url: '/orders',
    success: (data) => {
      onDraftOrderCreated();
    },
    error: () => {
      alert('Error, please try again!');
    }
  });
}

function onDraftOrderCreated() {
  window.location = $('.submit-cart').attr('target');
}

function onCartItemAdded() {
  updateCartCount(1);
}

function onCartItemRemoved(cartItem) {
  updateCartCount(-1);
  updateCartSubTotal(-parseFloat(cartItem.total_price));
  $(`.cart-item-row-${cartItem.id}`).remove();
}

function updateCartQuantity(cartItemId, newQuantity) {
  const tr = $(`.cart-item-row-${cartItemId}`);
  const price = parseFloat(tr.data('price'));
  const newTotalPrice = price * newQuantity;
  const oldQuantity = parseInt(tr.data('quantity'));

  tr.data('total-price', newTotalPrice);
  tr.data('quantity', newQuantity);
  tr.find('.cart-item-total-price').text(formatCurrency(newTotalPrice));

  updateCartSubTotal((newQuantity - oldQuantity) * price);
}

function updateCartCount(changedCount) {
  const count = $('.cart-count').data('count') || 0;
  const newCount = count + changedCount;
  $('.cart-count').data('count', newCount).text(newCount).removeClass('d-none');
}

function updateCartSubTotal(changedAmount, newAmount) {
  if (changedAmount != null) {
    const amount = parseFloat($('.cart-sub-total').data('amount') || 0);
    newAmount = amount + changedAmount;
  }

  $('.cart-sub-total').data('amount', newAmount).text(formatCurrency(newAmount));
}

function getCartActiveBlock() {
  if ($('.desktopBlock').css('display') != 'none') {
    return '.desktopBlock';
  }

  return '.mobileBlock';
}

function calcSelectedCartItemsTotalPrice() {
  return $(getCartActiveBlock()).find('.cart-item-row').map((index, row) => {
    if ($(row).find('.cart-item-checkbox')[0].checked) {
      return parseFloat($(row).data('total-price') || 0);
    } else {
      return 0;
    }
  }).toArray().reduce((s, i) => s + i, 0);
}

function getSelectedCartItems() {
  return $(getCartActiveBlock()).find('.cart-item-row').map((index, row) => {
    if ($(row).find('.cart-item-checkbox')[0].checked) {
      return ({
        id: $(row).data('id')
      });
    } else {
      return null;
    }
  }).toArray().filter(e => !!e);
}

function injectCSRFToken(data) {
  const key = $('meta[name="csrf-param"]').attr('content');
  const value = $('meta[name="csrf-token"]').attr('content');

  data[key] = value;

  return data;
}

function getCartItemData(event) {
  const productId = $(event.currentTarget).data('product-id');
  const quantity = $(event.currentTarget).data('quantity');
  const variantId = $(event.currentTarget).data('variant-id');

  return {
    product_id: productId,
    quantity: quantity || 1,
    variant_id: variantId
  }
}

$(function() {
  $('.add-to-cart').click(addToCart);
  $('.remove-cart-item').click(removeCartItem);
  $('input.cart-item-quantity').change(changeCartItemQuantity);
  $('.cart-item-checkbox').change(toggleCartItemCheckbox);
  $('.cart-items-checkbox-all').change(toggleCartItemsCheckboxAll);
  $('.submit-cart').click(submitCart);
  $('.product-form input.quantity').change(changeProductFormQuantity);
});
