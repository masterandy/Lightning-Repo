global  class AttachmentHandlerBatch implements Database.Batchable <sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         return Database.getQueryLocator('SELECT Id , Name  FROM Account ');
    }
    
    global void execute(Database.BatchableContext BC, list<Account> scope)
    {
     /* set <Id> setAccountId = new set <Id>();
        for(Account objAccount :scope )
        {
            setAccountId.add(objAccount.Id);
        }
        system.debug('=====1===='+setAccountId);*/
        //List<Opportunity> lstOpportunity = [SELECT Id ,AccountId , Name from Opportunity where accountId In:scope]; 
        
        //List<Opportunity> lstOpportunity = new  List<Opportunity>([SELECT Id ,AccountId , Name from Opportunity where accountId In:scope]);
        Map<Id,Opportunity> mapIdToOpportunity = new Map<Id,Opportunity>([SELECT Id ,AccountId , Name from Opportunity where accountId In:scope]);
        
        /*set <Id> setOpportunityId = new set <Id>();
        for(Opportunity objOpportunity :lstOpportunity )
        {
            setOpportunityId.add(objOpportunity.id);
        }  */
        
        if(!mapIdToOpportunity.isEmpty()){//empty check 
            //List<Attachment> lstAttachments = new List<Attachment>([SELECT ParentId , Body , Name from Attachment where ParentId IN:lstOpportunity]);
            
            //Map<Id,Attachment> mapNewAttachment = new  Map<Id,Attachment>([SELECT ParentId , Body , Name from Attachment where ParentId IN:mapIdToOpportunity.keyset()]);
            //Map<Id, List<Attachment>> mapIdtoLstAttachment = new Map<Id, List<Attachment>>();
            Map<Id, Set<String>> mapIdtoLstAttachment = new Map<Id, Set<String>>();//set to contain all set of attachments and AccountIds
            List<Attachment> lstAttachToInsert = new List<Attachment>();
            List<Attachment> lstAttachToDelete = new List<Attachment>();
            for(Attachment objAttach : [SELECT Id, ParentId , Body , Name from Attachment where ParentId IN:mapIdToOpportunity.keyset()]) {
                Attachment newAttachment = objAttach.clone(false, false, false, false);
                Id accId = mapIdToOpportunity.get(objAttach.ParentId).AccountId;
                system.debug('====2===='+accId);
                newAttachment.ParentId = accId;
                
                if(!mapIdtoLstAttachment.containsKey(accId)) {
                    mapIdtoLstAttachment.put(accId, new set<String>{objAttach.Name});
                } else {
                    if(mapIdtoLstAttachment.get(accId).contains(objAttach.Name)) {
                        system.debug('----------'+mapIdtoLstAttachment);
                        continue;
                    }
                    mapIdtoLstAttachment.get(accId).add(objAttach.Name);
                }
                lstAttachToInsert.add(newAttachment);
                lstAttachToDelete.add(objAttach);
            }   
            insert lstAttachToInsert;
            delete lstAttachToDelete;
        }
    }
    global void finish(Database.BatchableContext BC)
    {}
}