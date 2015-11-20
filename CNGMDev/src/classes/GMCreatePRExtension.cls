Public with sharing class GMCreatePRExtension{

   Public Account account{get;set;}
   Public Account accRec{get;set;}
   Public Contact conRec{get;set;}
   Public ID prRecTypeId{get;set;}

   public GMCreatePRExtension(ApexPages.StandardController acc){
      account= (Account)acc.getRecord();
      accRec = new Account ();
      conRec = new Contact();
      prRecTypeId= [Select id from RecordType where Developername ='PR' limit 1].ID;
   }

    public pageReference save(){
        accRec.RecordTypeID = prRecTypeId;
        accRec.Approval_Status__c = 'Requested';
        insert accRec;
        system.debug('@@accRec.id'+accRec.id);
        
        conRec.AccountID = accRec.id;
        insert conRec;
        system.debug('@@Contact'+conRec);  
        
        Pagereference page = New PageReference('/apex/PRformList');
        return page ;
   }
    
    public pageReference cancelRequest(){
        Pagereference page = New PageReference('/apex/PRformList');
        return page ;
    }
}