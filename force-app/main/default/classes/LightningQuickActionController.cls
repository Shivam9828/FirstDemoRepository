public class LightningQuickActionController {
 @AuraEnabled
    public static Utilisateur_Client__c checkUtilisateur(string utilId){
        Utilisateur_Client__c util = [select Reference_utilisateur__c,Mot_de_Passe__c from Utilisateur_Client__c where id=:utilId];
        return util;
    }
    
  @AuraEnabled
    public static contract getContract(string contractId) {
        contract con = [select Offre_Immo__c from contract where id=:contractId];
        return con;
    }
    
}