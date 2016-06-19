//Every time an Ajax call is being invoked the listener will recognize it and  will call the native app with the request details

/*$( document ).ajaxSend(function( event, request, settings )  {
                       callNativeApp (settings.data);
                       });

function callNativeApp (data) {
    try {
        webkit.messageHandlers.callbackHandler.postMessage(data);
    }
    
    catch(err) {
        console.log('The native context does not exist yet');
        webkit.messageHandlers.callbackHandler.postMessage('The native context does not exist yet');
    }
}*/

function addXMLRequestCallback(callback){
    var oldSend, i, oldOpen;
    if( XMLHttpRequest.callbacks ) {
        // we've already overridden send() so just add the callback
        XMLHttpRequest.callbacks.push( callback );
    } else {
        // create a callback queue
        XMLHttpRequest.callbacks = [callback];
        // store the native send()
        oldSend = XMLHttpRequest.prototype.send;
        // override the native send()
        XMLHttpRequest.prototype.send = function(){
            // process the callback queue
            // the xhr instance is passed into each callback but seems pretty useless
            // you can't tell what its destination is or call abort() without an error
            // so only really good for logging that a request has happened
            // I could be wrong, I hope so...
            // EDIT: I suppose you could override the onreadystatechange handler though
            for( i = 0; i < XMLHttpRequest.callbacks.length; i++ ) {
                XMLHttpRequest.callbacks[i]( this );
            }
            //webkit.messageHandlers.callbackHandler.postMessage("send");
            //webkit.messageHandlers.callbackHandler.postMessage(XMLHttpRequest.callbacks.length);
            // call the native send()
            oldSend.apply(this, arguments);
        }
        
        oldOpen = XMLHttpRequest.prototype.open;
        
        XMLHttpRequest.prototype.open = function(httpMethod, url) {
            //webkit.messageHandlers.callbackHandler.postMessage("open " + httpMethod);
            webkit.messageHandlers.callbackHandler.postMessage(url);
            
            oldOpen.apply(this, arguments);
        }
    }
}

// e.g.
addXMLRequestCallback( function( xhr ) {
                      //console.log( xhr.responseText ); // (an empty string)
                      //webkit.messageHandlers.callbackHandler.postMessage(xhr.responseText);
                      });
/*addXMLRequestCallback( function( xhr ) {
                      console.dir( xhr ); // have a look if there is anything useful here
                      webkit.messageHandlers.callbackHandler.postMessage(data);
                      });*/



window.onclick = function(e) {
    webkit.messageHandlers.callbackHandler.postMessage("onClick");
    webkit.messageHandlers.callbackHandler.postMessage("e>> " + e.target.localName);
    webkit.messageHandlers.callbackHandler.postMessage("e>> " + e.target);
};










