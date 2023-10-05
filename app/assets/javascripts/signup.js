$(document).ready(function() {
  // Cache the checkbox and the username input
  var $instagramCheckbox = $('#instagram_account');
  var $usernameInput = $('#username');
  var $whatsAppNumber = $('#whatsapp_number');

  console.log('lets do this')


  // Add a change event listener to the checkbox
  $instagramCheckbox.change(function() {
    if (this.checked) {
      // If the checkbox is checked, change the label to "Username"
      $usernameInput.attr('placeholder', 'Username');
      $whatsAppNumber.attr('placeholder', 'Whatsapp #');
      $whatsAppNumber.prop('required', true);
    } else {
      // If the checkbox is unchecked, change the label to "Instagram @"
      $usernameInput.attr('placeholder', 'Instagram @');
      $whatsAppNumber.attr('placeholder', 'Whatsapp # (Optional)');
      $whatsAppNumber.prop('required', false);
    }
  });
});
