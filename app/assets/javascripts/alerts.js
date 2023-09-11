function showAlert(message, success = true) {
  const alertDiv = document.createElement('div');
  alertDiv.className= 'alert' + (success ? ' success' : ' failure')

  const closeButton = document.createElement('span');
  closeButton.className = 'closebtn';
  closeButton.innerHTML = '&times;';
  closeButton.onclick = closeAlert;

  const alertMessage = document.createElement('p');
  alertMessage.innerText = message;

  alertDiv.appendChild(alertMessage);
  alertDiv.appendChild(closeButton);

  document.body.appendChild(alertDiv);

  setTimeout(() => {
    document.body.removeChild(alertDiv);
  }, 3000); // Hide the alert after 3 seconds (adjust as needed)
}

function closeAlert() {
  const alerts = document.querySelectorAll('.alert');
  alerts.forEach((alert) => {
    document.body.removeChild(alert);
  });
}
