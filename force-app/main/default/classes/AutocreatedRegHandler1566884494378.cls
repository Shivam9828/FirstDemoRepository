global class AutocreatedRegHandler1566884494378 implements Auth.RegistrationHandler{
global boolean canCreateUser(Auth.UserData data) {
	
	return false;
}

global User createUser(Id portalId, Auth.UserData data){
	User u = [SELECT ID FROM User Where Other_Salesforce_Org_Username__c = : data.username];
	return u;
}

global void updateUser(Id userId, Id portalId, Auth.UserData data){
	
}
}