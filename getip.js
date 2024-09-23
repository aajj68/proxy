var xhr = new XMLHttpRequest();
xhr.open('GET', 'https://api.ipify.org?format=json');
xhr.onload = function() {
  if (xhr.status === 200) {
    var response = JSON.parse(xhr.responseText);
    var userIP = response.ip;
    // You can modify the HTML here (limited options in Privoxy config)
    // For example, set a data attribute on an existing element:
    document.getElementById("myElement").dataset.userIp = userIP;
  }
};
xhr.send();