Public with sharing class GM_newGrantRequestController{
    public String CountryId {get;set;}
    public String message{get;set;}
    Public String strCountry {get;set;}
    public List<Implementation_Period__c> lstIP {get;set;}
    Public List<SelectOption> selOptCountry{get;set;}
    Public String strGuidanceId {get;set;}
    public String strLanguage {get;set;} 
    public boolean blndisable {get;set;}
    public boolean blndisplay {get;set;}
    public string PRCountry{get;set;}
    public Boolean blnExternalPro {get;set;}
    public Boolean blnCountrySpecific {get;set;}
    public string impid{get;set;}
    
    public GM_newGrantRequestController(ApexPages.StandardController controller) {
        checkProfile();
        PRCountry = '';
         System.debug('---StrCountry--'+strCountry);
        FillCountry(strCountry);
        lstIP = new List<Implementation_Period__c>();
        //lstIP = [Select Id, Name, Component__c, Concept_Note__r.Component__c,Status__c, Principal_Recipient__c,Principal_Recipient__r.Name,Start_Date__c,End_Date__c,Grant__r.Name,Grant_Making_submission_date__c,Grant_Status__c,Implementation_Period_Status__c, High_level_budget_TRP_USD__c, High_level_budget_TRP_EUR__c, High_level_budget_GAC_1_USD__c, High_level_budget_GAC_1_EUR__c,Currency_of_Grant_Agreement__c From Implementation_Period__c Where Status__c = 'Grant-Making' Order by Name];
     
         List<Guidance__c> lstGuidance = [Select Id from Guidance__c where Name = :label.Grant_Making_Home];
            if(!lstGuidance.isEmpty()) 
            {
              strGuidanceId = lstGuidance[0].Id;
            }
            strLanguage = 'ENGLISH';
        if(System.UserInfo.getLanguage() == 'fr'){
            strLanguage = 'FRENCH'; }
        if(System.UserInfo.getLanguage() == 'ru'){
            strLanguage = 'RUSSIAN'; }
        if(System.UserInfo.getLanguage() == 'es'){
            strLanguage = 'SPANISH'; }
        IPByCountry();
            
        //checkProfile();
}
 public Void IPByCountry(){
 //List if no country is selected
        if(CountryId == null ||CountryId  == ''){
            lstIP = [Select Id, Name,Approval_Status__c, Status__c,Component__c, Concept_Note__r.Component__c,Principal_Recipient__c,Principal_Recipient__r.Name,Start_Date__c,End_Date__c,Grant__r.Name,Grant_Making_submission_date__c,Grant_Status__c, Implementation_Period_Status__c, High_level_budget_TRP_USD__c, High_level_budget_TRP_EUR__c, High_level_budget_GAC_1_USD__c, High_level_budget_GAC_1_EUR__c, Currency_of_Grant_Agreement__c From Implementation_Period__c Where Status__c = 'Grant-Making' Order by Name ];
        }
 //List Countries if a country is selected
        if(CountryId != null && CountryId != ''){
            lstIP = [Select Id, Name,Approval_Status__c, Status__c,Component__c, Concept_Note__r.Component__c,Principal_Recipient__c,Principal_Recipient__r.Name,Start_Date__c,End_Date__c,Grant__r.Name,Grant_Making_submission_date__c,Grant_Status__c,Implementation_Period_Status__c, High_level_budget_TRP_USD__c, High_level_budget_TRP_EUR__c, High_level_budget_GAC_1_USD__c, High_level_budget_GAC_1_EUR__c, Currency_of_Grant_Agreement__c From Implementation_Period__c Where Status__c = 'Grant-Making' and Principal_Recipient__r.Country__r.id =:CountryId Order by Name];
        }
    }
    Public void FillCountry(String Country){
        List<Country__c> lstCountry= [Select id,name from Country__c WHERE To_be_hidden__c = false order by name asc];
        selOptCountry= new List<SelectOption>();
        //selOptCountry.add(new SelectOption('','All Countries'));
        selOptCountry.add(new SelectOption('',Label.All_Countries)); // INC029826 Change
        for(Country__c objCon:lstCountry){
            if(Country==objCon.Name)
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
    
    Public void SaveChanges(){
        update lstIP;
    }
    //TCS 22/08/2014 Added for Profile Access
     public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
      List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GrantMakingHome' and Profile_Name__c =: profilename];
      system.debug(checkpage);
      for (Profile_Access_Setting__c check : checkpage){
        if (check.Salesforce_Item__c == 'External Profile')blnExternalPro = true;
        if (check.Salesforce_Item__c == 'Country Specific')blnCountrySpecific = true;
        }
    }
}