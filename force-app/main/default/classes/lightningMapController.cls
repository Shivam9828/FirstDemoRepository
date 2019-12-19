public with sharing class lightningMapController {
    @AuraEnabled
    public static list<leadLocationWrapper> getLocation(string recId){
        list<leadLocationWrapper> lstALW = new list<leadLocationWrapper>();
        /*Query accounts records with billing address information */  
        for(Lead ld : [Select Name,description, country, City, PostalCode, Street, State
                           From Lead
                           Where Country != null
                           And City != null
                          AND id=:recId ]){
                               // first create "locationDetailWrapper" instance and set appropriate values
                               locationDetailWrapper oLocationWrap = new locationDetailWrapper();
                               oLocationWrap.Street = ld.Street;
                               oLocationWrap.PostalCode = ld.PostalCode;
                               oLocationWrap.City = ld.City;
                               oLocationWrap.State = ld.State;
                               oLocationWrap.Country = ld.Country;
                               
                               // create "accountLocationWrapper" instance, set values and add to final list. 
                               leadLocationWrapper oWrapper = new leadLocationWrapper();
                               oWrapper.icon = 'utility:location'; // https://www.lightningdesignsystem.com/icons/#utility
                               oWrapper.title = ld.Name;
                               oWrapper.description = ld.description;
                               oWrapper.location = oLocationWrap;
                               
                               lstALW.add(oWrapper);
                           }
        // retrun the "accountLocationWrapper" list
        return lstALW;
    }
    /* wrapper class to store required properties for "lightning:map" component' */ 
    public class leadLocationWrapper{
        @AuraEnabled public string icon{get;set;} 
        @AuraEnabled public string title{get;set;} 
        @AuraEnabled public string description{get;set;} 
        @AuraEnabled public locationDetailWrapper location{get;set;} 
    }
    /* sub wrapper class to store location details for "accountLocationWrapper" location property.*/ 
    public class locationDetailWrapper{
        @AuraEnabled public string Street{get;set;}
        @AuraEnabled public string PostalCode{get;set;}
        @AuraEnabled public string City{get;set;}
        @AuraEnabled public string State{get;set;}
        @AuraEnabled public string Country{get;set;}
    }
}