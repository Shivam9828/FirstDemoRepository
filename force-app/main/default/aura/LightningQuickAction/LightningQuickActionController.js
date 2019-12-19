({
	doInit : function(component, event, helper) {
		 var action = component.get("c.checkUtilisateur");
        action.setParams({
            "utilId": component.get("v.recordId")
        });
        
         action.setCallback(this, function(response) {
             
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
               
                if(res.Reference_utilisateur__c =='' || res.Reference_utilisateur__c == undefined || res.Mot_de_Passe__c=='' || res.Mot_de_Passe__c == undefined){
                
                    $A.get("e.force:closeQuickAction").fire(); 
                 var toastEvent2 = $A.get("e.force:showToast");
            toastEvent2.setParams({
                "title": "ERROR!",
                "message": 'Le champ référence utilisateur ou le champ mot de passe n’est pas renseigné, l’e-mail ne peut pas être envoyé',
                type: 'error',
            });
                 toastEvent2.fire();
                 //$A.get('e.force:refreshView').fire();
                //return;
             }
                else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/apex/VF34_EnvoiEmailUtilisateurCient?uClientId="+component.get("v.recordId"),
              "isredirect": "true"
            });
            urlEvent.fire();
               }
            }
        });
        
        $A.enqueueAction(action);
        
	}
})