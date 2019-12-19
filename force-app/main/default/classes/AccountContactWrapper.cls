public class AccountContactWrapper {
 @AuraEnabled
  public list<Account> accounts {get;set;}
  @AuraEnabled
  public list<contact> contacts {get;set;}
  public AccountContactWrapper(){
      this.accounts = new list<Account>();
      this.contacts = new list<contact>();
  }
}