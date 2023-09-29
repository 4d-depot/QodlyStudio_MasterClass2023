function onClick()
{
sendData({identifier:document.forms['myForm'].elements['identifier'].value , password:document.forms['myForm'].elements['password'].value})
};

function sendData(data) {
  var XHR = new XMLHttpRequest();
  
  XHR.onload = function() {
    let result = XHR.response;
    if (result === 'OK')  { 
      window.location = "http://127.0.0.1/$lib/renderer/?w=S2023_main";
      }
      else {
      document.getElementById("authenticationFailed").style.visibility = "visible";
      document.getElementById("authenticationFailed").innerHTML = result;
      }
  };
  
  XHR.open('POST', 'http://127.0.0.1:80/4DACTION/authenticate'); 
  XHR.setRequestHeader('identifier', data.identifier);
  XHR.setRequestHeader('password', data.password);
  XHR.send();
};
