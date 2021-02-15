(function(){
    const $ = document.querySelector.bind(document);
    let host = document.location.href.replace('http', 'ws');
    var ws = new ReconnectingWebSocket(host);
    var messages = $('#messages');
    function connected(){
        while(messages.firstChild){
            messages.removeChild(messages.firstChild);
        }
    }
    function addMessage(msg){
        let el = document.createElement('li');
        el.innerText = (msg);
        messages.appendChild(el);
    }
    function processEvent(event){
        let data = JSON.parse(event.data)
        console.log(data);
        if (data[0] == 'gotMessage'){
            addMessage('stranger: ' + data[1])
        } else if(data[0] =='connected') {
            connected();
        } else if(data[0] == 'strangerDisconnected'){
            connected();
        }
    }
    $("#form").addEventListener('submit', function(evt){
        evt.preventDefault();
        let message = $("#message").value;
        ws.send(message);
        addMessage('you: ' + message);
        $("#message").value = '';
        return false;
    });
    ws.onopen = function (event) {
        console.log('connected to websocket');
    };
    ws.onmessage = function (event) {
        processEvent(event);
    }    
})();