// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//string tempvar = 'Enter_your_name_here';
//System.debug('Hello World!');
//System.debug('My name is ' + tempvar);


AccountProcess__e event = new AccountProcess__e();
event.AccountId__c = '0015g00000xhJ41AAE';
event.FieldApiName__c = 'Name';
event.OperationType__c = 'I';
event.FieldValue__c = 'Updated by PE';
event.ObjectApiName__c = 'Account';

//DML operations (Not supported in platform events)
//We need to publish the platform events -> 

Database.SaveResult result = Eventbus.publish(event);