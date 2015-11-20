/**--
Purpose : This class is use to Display all PR accounts in a list on PRform Tab
**/
Public with sharing class CDFPRFormListctrl{
    public String CountryId {get;set;}
    public String strCountry {get;set;}
    public List<Account> lstAccount{get;set;}
    public List<SelectOption> selOptCountry{get;set;}
    public Boolean blnExternalPro {get;set;}
    public Boolean blnCountrySpecific {get;set;}
	public ID prRecTypeId{get;set;}
    
	//Constructor
    public CDFPRFormListctrl(ApexPages.StandardController controller) {
        List<Account> lstAccount= new List<Account>();
		// --Query PR record type Id
        prRecTypeId= [Select id from RecordType where Developername ='PR' limit 1].ID;
        
        FillCountry(strCountry);
        populatePRList();
            
	}
 
 // This method query Accounts based on Country selected in Picklist
	public void populatePRList(){
		//List if no country is selected
		if(CountryId == null ||CountryId  == ''){
			lstAccount = [Select Id, Name, PR_Validity_Period_Start_Date__c, Address_line_1__c, Short_Name__c,
			Address_line_2__c, PR_Type__c,  Address_line_3__c, PR_Sub_Type__c, City__c, PR_Fiscal_Cycle_Start_Month__c, 
			State_Province__c, PR_Fiscal_Cycle_Start_Day__c, Zip_Postal_Code__c, PR_Fiscal_Cycle_End_Month__c, Country_address__c, PR_Fiscal_Cycle_End_Day__c,
			Ethics_COI_Code_of_Conduct__c, Approval_Status__c, Approval_Status_Explanation__c, Country__c, Country__r.Name,Locked__c, Submitted_GIP_Id__c,Country_Official_Name__c,
			Grantee_Name__c,Different_Primary_Contact_Address__c,Address_line_1_Primary__c,Address_line_2_Primary__c,Address_line_3_Primary__c,City_Primary__c,
			State_Province_Primary__c,Zip_Postal_Code_Primary__c,Country_Mailing_Address_Primary__c
			from Account where RecordTypeId=:prRecTypeId order by Name limit 100];
		}
		//List Countries if a country is selected
		if(CountryId != null && CountryId != ''){
			lstAccount = [Select Id, Name, PR_Validity_Period_Start_Date__c, Address_line_1__c, Short_Name__c,
			Address_line_2__c, PR_Type__c,  Address_line_3__c, PR_Sub_Type__c, City__c, PR_Fiscal_Cycle_Start_Month__c, 
			State_Province__c, PR_Fiscal_Cycle_Start_Day__c, Zip_Postal_Code__c, PR_Fiscal_Cycle_End_Month__c, Country_address__c, PR_Fiscal_Cycle_End_Day__c,
			Ethics_COI_Code_of_Conduct__c, Approval_Status__c, Approval_Status_Explanation__c, Country__c,Country__r.Name, Locked__c, Submitted_GIP_Id__c,Country_Official_Name__c,
			Grantee_Name__c,Different_Primary_Contact_Address__c,Address_line_1_Primary__c,Address_line_2_Primary__c,Address_line_3_Primary__c,City_Primary__c,
			State_Province_Primary__c,Zip_Postal_Code_Primary__c,Country_Mailing_Address_Primary__c
			from Account where RecordTypeId=:prRecTypeId And Country__c=:CountryId  order by Name limit 100];
		}
    }
	
	// This method populates Country Picklist
    public void FillCountry(String Country){
        List<Country__c> lstCountry= [Select id,name from Country__c WHERE To_be_hidden__c = false order by name asc];
        selOptCountry= new List<SelectOption>();
        selOptCountry.add(new SelectOption('',Label.All_Countries)); 
        for(Country__c objCon:lstCountry){
            if(Country==objCon.Name)
            {
                CountryId = objCon.id;
            }
            selOptCountry.add(new SelectOption(objCon.id,objCon.Name));
        }   
        if(CountryId == NULL ){
             CountryId ='';   
        }    
    }
   
    //TCS 22/08/2014 Added for Profile Access
     public void checkProfile(){
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
     
		List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c from Profile_Access_Setting__c where Page_Name__c ='GrantMakingHome' and Profile_Name__c =: profilename];
		system.debug(checkpage);
		for (Profile_Access_Setting__c check : checkpage){
			if (check.Salesforce_Item__c == 'External Profile'){
				blnExternalPro = true;
			}
			if (check.Salesforce_Item__c == 'Country Specific'){
				blnCountrySpecific = true;
			}
		}
    }
}