global class UpdateFieldForExistingRecord implements Database.Batchable<sObject> {

global Database.QueryLocator start(Database.BatchableContext BC) {

String query = 'select id,name from account where createdDate < today';

return Database.getQueryLocator(query);

}

 

global void execute(Database.BatchableContext BC, List<account> scope) {

for(Account a : scope)

{

a.Name = a.Name + 'Updated';

}

update scope;

}

global void finish(Database.BatchableContext BC) {

}

}