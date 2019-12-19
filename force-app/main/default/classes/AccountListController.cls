public class AccountListController {
 
@AuraEnabled
public static list<Account> getAccountlist(){
 
return [Select id, Name,Industry,Phone from Account Order by CreatedDate desc limit 10];
 
}
 
@AuraEnabled
public static void getAccountupdatedlist(Account newAcc){
 
insert newAcc ;
}
 
}