({
    /**
     * This function makes a handshake request to server using current user's session id
     * Once  the handshake is complete, susbcribe to the channel
     * @author Manish Choudhari
     * @version 1.0.0
     * */
    doInit: function(component, event, helper) {
        //Call server action to get current user's session id
        var action = component.get("c.getSessionId");
        
        action.setCallback(this, function(response) {
	    // setting session id value from response
            var sessionId = response.getReturnValue();
            
            //inintializing cometD object/class
            var cometd = new window.org.cometd.CometD();
            
            //Calling configure method of cometD class, to setup authentication which will be used in handshaking
            cometd.configure({
                url: window.location.protocol + '//' + window.location.hostname + '/cometd/41.0/',
                requestHeaders: { Authorization: 'OAuth ' + sessionId},
                appendMessageTypeToURL : false
            });
        
            cometd.websocketEnabled = false;
            
            //Save the reference of cometD, which will be used to disconnect the subscription
            component.set('v.cometd', cometd);

            // Calling handshake() effectively sends a handshake message request to the server, 
            // and the Bayeux protocol requires that the server sends to the client a handshake message reply.
            // Once handshake() has been called, you must not call handshake() again 
            // unless you have explicitly disconnected by calling disconnect().
            cometd.handshake($A.getCallback(function(status) {
                
                if (status.successful) {
                    // Successfully connected to the server.
			        // Now it is possible to subscribe or send messages
					console.log('Successfully connected to server');
                    //use your channel name here
                    var eventName = component.get("v.channelName");
                    
                    //Subscribe to the event, which will call a callback function once the event 
                    //is being fired. Callback function will have the message received
                    var subscription = cometd.subscribe(eventName, $A.getCallback(function(message) {
                        console.log('New Event Received');
                    	//Fire the component event to notify parent component
                        var messageEvent = component.getEvent("onStreamEvent");
	                        if(messageEvent!=null) {
                                messageEvent.setParam("message", message.data);
                                messageEvent.fire();                            
	                        }
                        }
                    ));
                    
                    component.set('v.subscription', subscription);
                } else {
                    /// Cannot handshake with the server, alert user.
                    console.error('Error in handshaking: ' + status);
                }
            }));

        });
        $A.enqueueAction(action);
    },
    
    /**
     * This function will be fired once the component is destroyed
     * Used for unsubscribing the channel and disconnecting from the server
     * @author Manish Choudhari
     * @version 1.0.0
     * */
    unsubscribe : function (component, event, helper) {
        //get reference if cometD instance
		var cometd = component.get("v.cometd");
        //get current subscription
		var subscription = component.get("v.subscription");
        
        if(cometd){
            //Unsubscribing the current subscription
            cometd.unsubscribe(subscription, {}, function(unsubscribeReply) {
                if(unsubscribeReply.successful) {
                    //unsubcription is susccessful, disconnect from server now
                    console.log('Push topic successfully subscribed. Listening for events now');
                    cometd.disconnect(function(disconnectReply) 
                        { 
                            console.log('Push topic successfully unsubscribed.');
                            if(disconnectReply.successful) {
                                console.log('Successfully disconnected to server');
                            } else {
                                //Error in disconnect. Show user alert
                                console.error('Error is disconnecting')                    
                            }
                        });
                } else {
                     //Error in unsubscribe. Show user alert
                    console.error('Error in unsubscribe')                    		    
                }
            });
        }
    }
})