public with sharing class GM_GrantCreationController {

public string selectOpt{get;set;}
public boolean blnExtSSF {get;set;}
public boolean blnNewGrant {get;set;}
public boolean blnTBD {get;set;}
public boolean blnShowIP {get;set;}
public String CountryId {get;set;}
public List<SelectOption> selOptCountry{get;set;}
public List<SelectOption> selOptComponent{get;set;}
public List<SelectOption> selOptGrant{get;set;}
public List<SelectOption> selAcc{get;set;}
public string strCountry{get;set;}
public String strComponent{get;set;}
public String strGrant{get;set;}
public String strAcc{get;set;}
public List<Grant__c> lstGrant{get;set;} 
public List<Implementation_Period__c> lstIP {get;set;}
public String ipName {get;set;}
public String strAccid;
public String strCompCode;
public String strConCode;
public String strShortNM;   
 
    public GM_GrantCreationController(){
    blnShowIP = false;    
    FillCountry(strCountry);
    IPByCountry();  
    fillComponent();
    lstGrant = [Select Id, Name From Grant__c Order by Name ];
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
             lstGrant = [Select Id, Name From Grant__c Order by Name ];
        }
          if(CountryId != null && CountryId != ''){ 
              if(strComponent != null && strComponent != ''){
                system.debug('**inside first CountryId'+CountryId );
                lstGrant = [Select Id, Name From Grant__c WHERE Country__c =:CountryId AND Disease_Component__c=: strComponent AND Grant_Type__c=:'SSF' Order by Name ];
                system.debug('**lstGrant'+lstGrant);
            }else{
                system.debug('** inside second CountryId'+CountryId );
                lstGrant = [Select Id, Name From Grant__c WHERE Country__c =:CountryId AND Grant_Type__c=:'SSF' Order by Name ];
                system.debug('**lstGrant'+lstGrant);
            }
        }
        
        selOptGrant = new List<SelectOption>();
        for(Grant__c  objGrant :lstGrant ){            
            selOptGrant.add(new SelectOption(objGrant.id,objGrant.Name));
        } 
        
    }
    
    public void fillComponent(){
        selOptComponent =  new List<SelectOption>();
        selOptComponent.add(new SelectOption('',Label.All_Countries));
         selOptComponent.add(new SelectOption('Malaria','Malaria'));
         selOptComponent.add(new SelectOption('HIV/AIDS','HIV/AIDS'));
         selOptComponent.add(new SelectOption('Tuberculosis','Tuberculosis'));
         selOptComponent.add(new SelectOption('HIV/TB','HIV/TB'));
    }
    
     public Void Grantbycomp(){
         system.debug('**strComponent'+strComponent);
        if(strComponent == null ||strComponent == ''){
            if(CountryId != null && CountryId != ''){
             lstGrant = [Select Id, Name From Grant__c WHERE Country__c =:CountryId AND Grant_Type__c=:'SSF' Order by Name ];
            }else{
             lstGrant = [Select Id, Name From Grant__c Order by Name ];
            }
        }
          if(strComponent != null && strComponent != ''){ 
               if(CountryId != null && CountryId != ''){   
            lstGrant = [Select Id, Name From Grant__c WHERE Disease_Component__c=: strComponent AND Country__c =:CountryId AND Grant_Type__c=:'SSF' Order by Name ];
            system.debug('**lstGrant'+lstGrant);
           }else{
               lstGrant = [Select Id, Name From Grant__c WHERE Disease_Component__c=: strComponent AND Grant_Type__c=:'SSF' Order by Name ];
           }
        }
        
        selOptGrant = new List<SelectOption>();
        for(Grant__c  objGrant :lstGrant ){
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
    
    public void ShowIP(){
    	lstIP = [Select id,name from Implementation_Period__c where Grant__c =: strGrant];
       	system.debug('**lstIP'+lstIP);
       	system.debug('**strGrant'+strGrant);
        if(lstIP.size()>0){
        	system.debug('**inside first If');
        	blnShowIP = true;
        }else{
        	system.debug('**inside else');
        	blnShowIP = false;
        }
    }
    
    public Pagereference createGIPExtSSF(){
    	Implementation_Period__c objIP = new Implementation_Period__c();
    	Integer i;
    	 objIP.Grant__c = strGrant;
    	 List<Implementation_Period__c> lstTotalIP = [Select Id from Implementation_Period__c where Grant__c =: strGrant];
    	 List<Grant__c> grantListNM = new List<Grant__c>([Select Id,Country__r.MEPH_Specialist__c,Disease_Component__c,Principal_Recipient__c from Grant__c where id =: strGrant ]);
           for(Grant__c objGrant: grantListNM ){
                if(objGrant.Disease_Component__c == 'Malaria'){
                        strCompCode = 'M';
                    }else if(objGrant.Disease_Component__c == 'Tuberculosis'){
                        strCompCode = 'T';
                    }else if(objGrant.Disease_Component__c == 'HIV/AIDS'){
                        strCompCode = 'H';
                    }else if(objGrant.Disease_Component__c == 'HIV/TB'){
                        strCompCode = 'C';
                    }else{
                        strCompCode = 'S';
                    }
				 strAccid = objGrant.Principal_Recipient__c;
           }
           objIP.Principal_Recipient__c = strAccid;
           List<Account> lstAccForNM = [Select Id,Short_Name__c,Country__r.Country_Code__c From Account where Id  =: strAccid];
		        for(Account acc : lstAccForNM ){
		            strConCode = acc.Country__r.Country_Code__c;
		            strShortNM = acc.Short_Name__c;
		        }
		    if(lstTotalIP.size()==0){
	            i = 01;
	        }else{
	            i = lstTotalIP.size();
	        }  
	        
	        objIP.name = strConCode+'-'+strCompCode+'-'+strShortNM+'-'+'P'+i;
            objIP.Implementation_Cycle__c = 'P'+i;
	        insert objIP; 
	        
	        Pagereference ref = new Pagereference('/'+objIP.id);
	        ref.setRedirect(true);
            return ref; 
   		}
   		
   		public void updatableIPName(){
   			
   			if(strComponent == 'Malaria'){
                    strCompCode = 'M';
                }else if(strComponent == 'Tuberculosis'){
                    strCompCode = 'T';
                }else if(strComponent == 'HIV/AIDS'){
                    strCompCode = 'H';
                }else if(strComponent == 'HIV/TB'){
                    strCompCode = 'C';
                }else{
                    strCompCode = 'S';
                }
                
   			 List<Account> lstAccForNM = [Select Id,Short_Name__c,Country__r.Country_Code__c From Account where Id  =: strAcc];
			        for(Account acc : lstAccForNM ){
			            strConCode = acc.Country__r.Country_Code__c;
			            strShortNM = acc.Short_Name__c;
			        }
			        
		        ipName = strConCode+'-'+strCompCode+'-'+strShortNM+'-'+'P'+'1';
		        blnShowIP = true;
   		}
   		
   		public Pagereference createNewGrant(){
   			System.debug('---Name in submit method--'+ipName);
	   		Grant__c objGrant = new Grant__c();
	   		objGrant.Country__c = CountryId;
	   		objGrant.Disease_Component__c = strComponent;
	   		objGrant.Principal_Recipient__c = strAcc;
	   		objGrant.Grant_Type__c = 'SSF';
	   		insert objGrant;
	   		
	    	Implementation_Period__c objIP = new Implementation_Period__c();
	    	//Integer i;
    		objIP.Grant__c = objGrant.id;
    	  	objIP.Principal_Recipient__c = strAcc;    
	        objIP.name = ipName;
	        //objIP.Implementation_Cycle__c = 'P'+'1';
	        objIP.Status__c = 'Grant-Making';
		    insert objIP;
		    System.debug('--Id-'+objIP.Id); 
		        
		     Pagereference ref = new Pagereference('/'+objIP.id);
		        ref.setRedirect(true);
	            return ref; 
   		}
   		
  }