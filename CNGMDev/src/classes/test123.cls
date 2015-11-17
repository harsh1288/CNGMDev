public with sharing class test123 {

public string selectOpt{get;set;}
public boolean blnExtSSF {get;set;}
public boolean blnNewGrant {get;set;}
public boolean blnTBD {get;set;}
public String CountryId {get;set;}
Public List<SelectOption> selOptCountry{get;set;}
Public List<SelectOption> selOptComponent{get;set;}
Public List<SelectOption> selOptGrant{get;set;}
Public List<SelectOption> selAcc{get;set;}
public string strCountry{get;set;}
public String strComponent{get;set;}
public String strGrant{get;set;}
public String strAcc{get;set;}
Public List<Grant__c> lstIP{get;set;}
   
    public test123(){
        
    FillCountry(strCountry);
    IPByCountry();  
    fillComponent();
    lstIP = [Select Id, Name From Grant__c Order by Name ];
    }

    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('1','Existing SSF Grant'));
            options.add(new SelectOption('2','New Grant'));
            return options;
    
        }

 public void pmRecPR(){
        if(selectOpt == '1'){
            blnExtSSF = true;
            blnNewGrant = false;
        }
        
       if(selectOpt == '2'){
            blnNewGrant = true;
            blnExtSSF = false;
        }
    }
    
     Public void FillCountry(String Country){
        List<Country__c> lstCountry= [Select id,name from Country__c WHERE To_be_hidden__c = false order by name asc];
        selOptCountry= new List<SelectOption>();
        //selOptCountry.add(new SelectOption('','All Countries'));
        selOptCountry.add(new SelectOption('',Label.All_Countries)); // INC029826 Change
        for(Country__c objCon:lstCountry){
            if(Country == objCon.Name)
            {
                CountryId = objCon.id;
            }
            selOptCountry.add(new SelectOption(objCon.id,objCon.Name));
            
        }   
        if(  CountryId == NULL ){
             CountryId ='';   
        }    
    system.debug('selOptCountry: ' +'Selected--->'+CountryId +selOptCountry);
    }
    
    public Void IPByCountry(){
        if(CountryId == null ||CountryId  == ''){
             lstIP = [Select Id, Name From Grant__c Order by Name ];
        }
          if(CountryId != null && CountryId != ''){ 
              if(strComponent != null && strComponent != ''){
                system.debug('**inside first CountryId'+CountryId );
                lstIP = [Select Id, Name From Grant__c WHERE Country__c =:CountryId AND Disease_Component__c=: strComponent AND Grant_Type__c=:'SSF' Order by Name ];
                system.debug('**lstIP'+lstIP);
            }else{
                system.debug('** inside second CountryId'+CountryId );
                lstIP = [Select Id, Name From Grant__c WHERE Country__c =:CountryId AND Grant_Type__c=:'SSF' Order by Name ];
                system.debug('**lstIP'+lstIP);
            }
        }
        
        selOptGrant = new List<SelectOption>();
        for(Grant__c  objGrant :lstIP ){
            
            selOptGrant.add(new SelectOption(objGrant.id,objGrant.Name));
            
        } 
    }
    
    public void fillComponent(){
        selOptComponent =  new List<SelectOption>();
        selOptComponent.add(new SelectOption('',Label.All_Countries));
         selOptComponent.add(new SelectOption('HIV/AIDS','HIV/AIDS'));
         selOptComponent.add(new SelectOption('Tuberculosis','Tuberculosis'));
    }
    
     public Void Grantbycomp(){
         system.debug('**strComponent'+strComponent);
        if(strComponent == null ||strComponent == ''){
            if(CountryId != null && CountryId != ''){
             lstIP = [Select Id, Name From Grant__c WHERE Country__c =:CountryId AND Grant_Type__c=:'SSF' Order by Name ];
            }else{
             lstIP = [Select Id, Name From Grant__c Order by Name ];
            }
        }
          if(strComponent != null && strComponent != ''){ 
               if(CountryId != null && CountryId != ''){   
            lstIP = [Select Id, Name From Grant__c WHERE Disease_Component__c=: strComponent AND Country__c =:CountryId AND Grant_Type__c=:'SSF' Order by Name ];
            system.debug('**lstIP'+lstIP);
           }else{
               lstIP = [Select Id, Name From Grant__c WHERE Disease_Component__c=: strComponent AND Grant_Type__c=:'SSF' Order by Name ];
           }
        }
        
        selOptGrant = new List<SelectOption>();
        for(Grant__c  objGrant :lstIP ){
            selOptGrant.add(new SelectOption(objGrant.id,objGrant.Name));
        } 
    }
    
    public void fillPRCountry(){
        List<Account> lstAcc = new List<Account>();
        if(CountryId != null && CountryId != ''){ 
            lstAcc = [Select id,Name from Account where Country__c =: CountryId Order by Name ];
        }
        
        selAcc = new List<SelectOption>();
        for(Account objAcc :lstAcc ){
            selAcc.add(new SelectOption(objAcc.id,objAcc.Name));
        } 
        
        
    }
    
  }