trigger AccountIntegrationTrigger on Account (after insert, after update) {
    if(trigger.isAfter && trigger.isInsert){
        Set<Id> accounts = new Set<Id>();
        for(Account acc : Trigger.new){
            accounts.add(acc.Id);
        }
        GoogleMapsIntegration.getAuthorization(accounts);
    }

    if(trigger.isAfter && trigger.isUpdate){
        Set<Id> accounts = new Set<Id>();
        for(Account acc : Trigger.newMap.values()){
            Account oldAcc = Trigger.oldMap.get(acc.Id);
            if(acc.Coordinates__latitude__s != oldAcc.Coordinates__latitude__s || acc.Coordinates__longitude__s != oldAcc.Coordinates__longitude__s){
                accounts.add(acc.Id);
            }
        }
        if(!System.isFuture() && !System.isBatch())
            GoogleMapsIntegration.getAuthorization(accounts);
    } 
}