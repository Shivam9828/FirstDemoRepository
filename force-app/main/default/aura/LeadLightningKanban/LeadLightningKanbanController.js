( {
    init : function( component, event, helper ) {
        alert('dds');
        debugger;
        component.set( "v.scriptsLoaded", true );
        var action = component.get( "c.initialize" );
        
        
        alert();
        action.setCallback( this, function( response ) {
            var state = response.getState();
             alert('hgfdd'+state);
            if ( state === "SUCCESS" ) {
                alert('bnnmm');
                var result = response.getReturnValue();
                
                var cols = {};
                result.columns.forEach(
                    function( col ) {
                        cols[col.label] = col;
                    }
                );
                
                var rows = [];               
                for( var key in result.rows ) {
                    rows.push( { value: result.rows[key], key: cols[key] } );
                }
                
                component.set( "v.rows", rows );                
                component.set( "v.columns", result.columns );
                
                helper.hideSpinner( component );
            }
            else {
                helper.showToast( 
                    {
                        "title"     : "Error", 
                        "message"   : "Error: " + JSON.stringify( response.getError() ) + ", State: " + state, 
                        "isSuccess" : "error"
                    } 
                );
            }
        } );
        
        $A.enqueueAction( action );
    },    
    applySortable : function( component, event, helper ) {        
        var sortableApplied = component.get( "v.sortableApplied" );
        var scriptsLoaded   = component.get( "v.scriptsLoaded" );
        
        /**
         * Apply the jQuery Sortable
         * when the DOM is ready and 
         * the Scripts have been loaded.
         */
        if( scriptsLoaded   && 
           !sortableApplied && 
           jQuery( ".slds-lane" ).length > 0
        ) {
            component.set( "v.sortableApplied", true );
            
            helper.applySortable( component );
        }
    },
    logACall : function( component, event, helper ) {
        var createRecordEvent = $A.get( "e.force:createRecord" );
        
        createRecordEvent.setParams(
            {
                "entityApiName"     : "Task",
                "defaultFieldValues": {
                    "WhoId"     : event.getSource().get( "v.name" ),
                    "Subject"   : "Log A Call"
                }
            }
        );
        
        createRecordEvent.fire();
    },
    logAMeeting : function( component, event, helper ) {
        var createRecordEvent = $A.get( "e.force:createRecord" );
        
        createRecordEvent.setParams(
            {
                "entityApiName"     : "Event",
                "defaultFieldValues": {
                    "WhoId"     : event.getSource().get( "v.name" ),
                    "Subject"   : "Log A Meeting"
                }
            }
        );
        
        createRecordEvent.fire();
    }
} )