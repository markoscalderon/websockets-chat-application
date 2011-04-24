google.load("jquery", "1.5.2");
function OnLoad() {
	 ws = new WebSocket("ws://localhost:3001/socket");

 	ws.onmessage = function(evt) { 
		$("#chathistory").append("<p>"+evt.data+"</p>"); 
	 };
     ws.onclose = function() {
	  	$("#chathistory").append("<p>socket disconnected</p>");
	 };
      ws.onopen = function() {
		$("#chathistory").append("<p>socket connected</p>");
     };
}
google.setOnLoadCallback(OnLoad);

function sendMessage(){
	var aName = $("#txtname").val().trim();
	var aMessage = $("#txtmessage").val().trim();
	ws.send('{ "name":"'+aName+'" , "message":"'+aMessage+'" }');
}