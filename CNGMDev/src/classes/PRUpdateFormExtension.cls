/*
    @author        TCS Developer    
    *@date         17/02/2014
    *@description  This class is to submit PR for approval process
    *@Used for     CDF_PRApprovalForm
*/

public with sharing class PRUpdateFormExtension {

    public Implementation_Period__c implementationPeriod {get;set;} 
    public Account account  {get;set;} 
    public List<Contact> listContacts{get;set;}
    public List<SelectOption> roles {get;set;}
    public String currentPrimary{get;set;}
    
    public String selectedIndex{get;set;}
    public List<Selectoption> ContactRoleList {get;set;}
    //public Attachment attach {get;set;}
    
    //CCM Contacts
     public Contact contactCCMChair  {get;set;} 
     //public Id contactCCMChairAttachmentId  {get;set;} 
     //public Attachment attachContactCCMChair {get;set;}
     public Contact contactCCMCivilSociety {get;set;} 
     //public Id contactCCMCivilSocietyAttachmentId  {get;set;} 
     //public Attachment attachCCMCivilSociety {get;set;}
     public String CCMContactId{get;set;}
     public String CCMContactType{get;set;}
        
     //PR Authorized Signatory Contacts
     public Contact grantAgreement  {get;set;} 
     public Contact disbursementRequest1 {get;set;} 
     public Contact disbursementRequest2 {get;set;} 
     
     //Boolean for controlling mode -- Added 2014-06-17 by Matthew Miller
     Public Boolean blnFinanceMode {get;set;}
     
     //TCS 15/10/2014: US Core Data Form
     Public Boolean blnEditPRInformation {get;set;}
     public boolean attachmentMessage{get;set;}
     public Contact LFAContact{get;set;}
     public String attachmentIdToDelete{get;set;}
     public static Id contactPRRecordTypeId {get;set;}
     public List<Attachment> lstAttachment {get;set;}
     public void setGrantAgreement(Contact grantAgreement) {
         this.grantAgreement  = grantAgreement;
     }
     private boolean success;
      private transient List<Contact> orgContactList;
     public PRUpdateFormExtension(ApexPages.StandardController controller) {
        success = true;
        checkProfile(); //TCS 15/10/2014: US Core Data Form
         if(controller.getId() == NULL || (controller.getId().length() != 15 && controller.getId().length() != 18)) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.label.CDF_Account_Missing));return;
             
         }
         account = getAccount(controller.getid());
         // TODO : Add Error
         populateContactRoleList();
         init();
//         account = getAccount(implementationPeriod.Principal_Recipient__c);
//         getContact(implementationPeriod.Principal_Recipient__c);
		   getContact(account.id);             
         populateRoles();
         contactPRRecordTypeId= Schema.SObjectType.Contact.RecordTypeInfosByName.get(System.Label.CDF_PR).getRecordTypeId();
         
     }
     
     
     public void populateContactRoleList(){
          List<Selectoption> lstSelectOptions = new List<Selectoption>();
         lstSelectOptions.add(new Selectoption('','--None--'));
         lstSelectOptions.add(new Selectoption('Other','Other'));
         lstSelectOptions.add(new Selectoption('Focal point' ,'Focal Point'));
         ContactRoleList = lstSelectOptions;

     }

     public void init() {
         //Using a custom setting to set the Boolean that controls the mode -- Added 2014-06-17 by Matthew Miller
         blnFinanceMode = false;
         List<PR_Update_Mode__c> lstCustSetting = [Select Finance_Mode__c from PR_Update_Mode__c ORDER BY CreatedDate DESC LIMIT 1];
         if(lstCustSetting.size() > 0){
             blnFinanceMode = lstCustSetting[0].Finance_Mode__c;
         }
         
         LFAContact = new Contact(); 
         Set<Id> contactIds = new Set<Id>();
         contactCCMCivilSociety = new Contact();
         contactCCMChair = new Contact();
         attachmentMessage = false;
         /*if(Test.isRunningTest()) {
            implementationPeriod = [SELECT Principal_Recipient__c,Implementation_Period__c.Local_Fund_Agent__c,CCM_Chair__c,
            Approval_Status_Explanation__c , Grant_Tax_Exemption__c ,Name, Auth_Sig_for_Grant_Agreement__c, CCM_Civil_Society_Representative__c, 
            Auth_Sig_for_Disbursement_Request_1__c,   Auth_Sig_for_Disbursement_Request_2__c, Country__c FROM  Implementation_Period__c
            WHERE Id =: implementationPeriod.Id];
         }*/
         
/*         if(implementationPeriod.CCM_Chair__c != NULL) {contactIds.add(implementationPeriod.CCM_Chair__c);}
         if(implementationPeriod.CCM_Civil_Society_Representative__c != NULL) {contactIds.add(implementationPeriod.CCM_Civil_Society_Representative__c);}
         if(implementationPeriod.Auth_Sig_for_Grant_Agreement__c != NULL) {contactIds.add(implementationPeriod.Auth_Sig_for_Grant_Agreement__c);}
         if(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c != NULL) {contactIds.add(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c);}
         if(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c != NULL) {contactIds.add(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c);}
         system.debug(' ContactIds '+contactIds);
         populateMapContact(contactIds);
         
         if(implementationPeriod.CCM_Chair__c != NULL) {
             contactCCMChair = getContactById(implementationPeriod.CCM_Chair__c);
             //attachContactCCMChair = getAttachmentId(implementationPeriod.CCM_Chair__c);
         }
         if(implementationPeriod.CCM_Civil_Society_Representative__c != NULL) {
             contactCCMCivilSociety = getContactById(implementationPeriod.CCM_Civil_Society_Representative__c);
             //attachCCMCivilSociety = getAttachmentId(implementationPeriod.CCM_Civil_Society_Representative__c);
         }
         
         grantAgreement = getContactById(implementationPeriod.Auth_Sig_for_Grant_Agreement__c);
         grantAgreement.Role__c = System.Label.CDF_Authorized_Signatory_for_Grant_Agreement;
         
         disbursementRequest1 = getContactById(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c);
         disbursementRequest1.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
         
         disbursementRequest2 = getContactById(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c);
         disbursementRequest2.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
*/         
         lstAttachment = [SELECT BodyLength, ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :account.id];
     }
     
     public void removeRow() {
         if(attachmentIdToDelete != NULL){
             Id loggedInUsedId = UserInfo.getUserId();
             Id profileId=userinfo.getProfileId();
             String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
             
             Attachment attchmentToDelete = [Select Id,lastmodifiedById from Attachment where Id =:attachmentIdToDelete Limit 1];
             //Rohini : check which user has uploaded the attachment and allow only that user to delete the attachment 
             if( loggedInUsedId != attchmentToDelete.lastmodifiedById && profileName != System.Label.CDF_System_Administrator){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.CDF_Insufficient_Privileges));return;                    
             }else{
                 delete attchmentToDelete;    

             }
             lstAttachment = [SELECT ParentId , Parent.Name ,Name,LastModifiedDate,CreatedById ,Id FROM Attachment WHERE ParentId = :account.id];
         }
     }

     public Pagereference renderReadOnly(){  //Modified 2014-06-17 by Matthew Miller to include Locked__c
         if(account.Approval_Status__c == System.Label.CDF_LFA_Verification || account.Approval_Status__c == System.Label.CDF_Send_to_finance_system_for_approval ||
                 account.Approval_Status__c == System.Label.CDF_Reject || account.Approval_Status__c == System.Label.CDF_Correction_required || account.Approval_Status__c == System.Label.CDF_Approved 
                 || account.Approval_Status__c == System.Label.CDF_Finance_Officer_verification || account.Locked__c) {
//             System.debug('----'+implementationPeriod.Id);
             Pagereference pg = new Pagereference('/apex/CDF_PRReadonlyForm?id='+account.Id);
             pg.setRedirect(true);
             return pg;
         }

         return NULL;
     }


     public PageReference renderEditable()   // //upd by jl  //Modified 2014-06-17 by Matthew Miller to include Locked__c
     {
         if(account.Approval_Status__c == System.Label.CDF_Update_Information && account.Locked__c == false){
             Pagereference pg = new Pagereference('/apex/CDF_PRApprovalForm?id='+account.Id);
             pg.setRedirect(true);
             return pg;
         }       
         return NULL;
     }
     
     public Pagereference editPrInformation() {

         if(account != null){
             
             string previousAprrovalStatus = account.Approval_Status__c;
             account.Approval_Status__c = System.Label.CDF_Update_Information;
             account.Approval_Status_Explanation__c = '';
             update account;
            
            /*** Payal: 23/2/2015: BR5 US CGDF - Core Data forms Adjustments ***/
 /*            if(previousAprrovalStatus == System.Label.CDF_Approved){
            Performance_Framework__c objPF = [Select PF_Status__c from Performance_Framework__c where Implementation_Period__c =: implementationPeriod.Id Limit 1];
            if(objPF.PF_Status__c == Label.IP_Accepted)objPF.PF_Status__c = Label.IP_Sub_to_GF ;
            update objPF;
            
            HPC_Framework__c objHPC = [Select HPC_Status__c from HPC_Framework__c where Grant_Implementation_Period__c =: implementationPeriod.Id Limit 1];
            if(objHPC.HPC_Status__c == Label.IP_Accepted)objHPC.HPC_Status__c = Label.IP_Sub_to_GF ;
            update objHPC;
            
            IP_Detail_Information__c objDB = [Select Budget_Status__c from IP_Detail_Information__c where Implementation_Period__c =: implementationPeriod.Id Limit 1];
            if(objDB.Budget_Status__c == Label.IP_Accepted)objDB.Budget_Status__c = Label.IP_Sub_to_GF ;
            update objDB;
            }
 */           /*** Payal: 23/2/2015: BR5 US CGDF - Core Data forms Adjustments ***/
   
         }
         


         Pagereference pg = new Pagereference('/apex/CDF_PRApprovalForm?id='+account.Id);
         pg.setRedirect(true);
         return pg;
     }
     
     
     
     

     /* Get All contact associated to the Account Contact Relationship where account is
      * Implementation Period account
      */
     public void getContact(Id accountId) {
         listContacts = new List<Contact>();

         for(Contact contact : [SELECT Id, FirstName , LastName, Email,Phone ,Salutation , 
                                Title, Role__c,Primary_Contact__c,Fax,Department
                                FROM Contact 
                                WHERE AccountId = :accountId
                                AND (Role__c =: System.Label.CDF_Other OR Role__c =: System.Label.CDF_Focal_Point)]) {
             listContacts.add(contact);
         }

         // add 2 blank rows if there are no contacts
         if(listContacts.size() == 0) {
             //listContacts.add(new Contact(AccountId=account.Id));
             //listContacts.add(new Contact());
         }
     }

     /* Get all required Account fields from Implementation Period account 
      */
     public Account getAccount(Id accountId){
         /*String query = 'SELECT ';
         List<Schema.FieldSetMember> lstFields = SObjectType.Account.FieldSets.PR_Information.getFields();
         for(Schema.FieldSetMember f : lstFields) {
             if(f.getFieldPath() == 'Ethics_COI_Code_of_Conduct__c' || 
                     f.getFieldPath() == 'Address_line_1__c' || 
                     f.getFieldPath() == 'Approval_Status__c' || 
                     f.getFieldPath() == 'Approval_Status_Explanation__c' || 
                     f.getFieldPath() == 'Country__c') {
                 continue;
             }
             query += f.getFieldPath() + ', ';
         }
         query += 'Id , Country__c, Ethics_COI_Code_of_Conduct__c,Address_line_1__c ,Approval_Status__c, Approval_Status_Explanation__c, Locked__c FROM Account ';
         query += 'Where Id = \''+accountId+'\' LIMIT 1';
         return Database.query(query);*/
         Account acct = new Account();
         List<Account> lstAccount = [Select Id, Name, PR_Validity_Period_Start_Date__c, Full_Legal__c, PR_Validity_Period_End_Date__c, Legal_Abbreviation__c, Address_line_1__c, 
                                     Country_Fiscal_Cycle__c, Address_line_2__c, PR_Type__c,  Address_line_3__c, PR_Sub_Type__c, City__c, PR_Fiscal_Cycle_Start_Month__c, 
                                     State_Province__c, PR_Fiscal_Cycle_Start_Day__c, Zip_Postal_Code__c, PR_Fiscal_Cycle_End_Month__c, Country_address__c, PR_Fiscal_Cycle_End_Day__c,
                                     Ethics_COI_Code_of_Conduct__c, Approval_Status__c, Approval_Status_Explanation__c, Country__c, Locked__c, Submitted_GIP_Id__c,Country_Official_Name__c,
                                     Grantee_Name__c,Different_Primary_Contact_Address__c,Address_line_1_Primary__c,Address_line_2_Primary__c,Address_line_3_Primary__c,City_Primary__c,
                                     State_Province_Primary__c,Zip_Postal_Code_Primary__c,Country_Mailing_Address_Primary__c
                                     from Account where Id = :accountId];
         if(lstAccount.size() > 0) acct = lstAccount[0];
         if(acct.PR_Type__c == System.Label.CDF_Governmental){
             acct.Grantee_Name__c = acct.Country_Official_Name__c;
         }else{
             acct.Grantee_Name__c = acct.Full_Legal__c;
         }
         return acct;
     }

     
     public void populateRoles() {
         roles = new List<SelectOption>();
         roles.add(new SelectOption('none','--None--'));
         for(Schema.Picklistentry role : Account_Contact_Relationship__c.Role__c.getDescribe().getPicklistValues()){
             roles.add(new SelectOption(role.getValue(),role.getValue()));
         }
     }
        
     public PageReference updateAccountApprovalStatus() {
         if( success ){
             attachmentMessage =false;
             account.Approval_Status__c =  System.Label.CDF_Finance_Officer_verification;
             account.Most_Recent_Submitter__c = UserInfo.getUserId();
             try {
                 update account;
             } catch(Exception ex) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
             }
             if(account.Approval_Status__c == System.Label.CDF_LFA_Verification || account.Approval_Status__c == System.Label.CDF_Send_to_finance_system_for_approval ||
                     account.Approval_Status__c == System.Label.CDF_Reject || account.Approval_Status__c == System.Label.CDF_Correction_required || account.Approval_Status__c ==  System.Label.CDF_Finance_Officer_verification) {
                 Pagereference pg = new Pagereference('/apex/CDF_PRReadonlyForm?id='+account.Id);
                 pg.setRedirect(true);
                 return pg;
             }
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your PR Request has been submitted.'));
             return NULL;
         }else{
             return NULL;
         }
     }

     public Pagereference updatePrimary(){
         if(currentPrimary == NULL) {
             return NULL;
         }
         if(currentPrimary.length() != 15 &&  currentPrimary.length() != 18) {
             // TODO Throw ERROR
             //return NULL;
         }  
         for(Contact c : listContacts) {
             c.Primary_Contact__c = false;
         } 
         listContacts[Integer.valueof(currentPrimary)].Primary_Contact__c = true;

         return NULL;
     }
/*
     public List<Contact> getLFAContactList() {

         if(LFAContact.AccountId == NULL) {
             return NULL;
         }       
         Account a = [SELECT Country__c From Account WHERE Id = :implementationPeriod.Principal_Recipient__c];
         return [SELECT Id, Name , FirstName , LastName, Email,Phone ,Salutation, MailingCity, MailingCountry,
                 MailingPostalCode,MailingState,MailingStreet,Fax,Account.Name,
                 Title, Role__c,Primary_Contact__c FROM Contact 
                 WHERE Account.Country__c =:a.Country__c AND Account.RecordType.Name = 'LFA']; 


     }

     public List<Grant__c> getGrantList() {

         return [SELECT Name , Start_Date__c , End_Date__c ,Grant_Status__c ,Sub_Status__c FROM Grant__c 
                 WHERE Principal_Recipient__c =:implementationPeriod.Principal_Recipient__c];

     }
*/     //all validations consolidated here
     private pageReference checkValidations(){
       
         boolean hasPrimaryContact = false;
         if(blnFinanceMode) hasPrimaryContact = true;
                                 
         attachmentMessage = false;
         // field Validations
         String errorMessage = 'sd';
         List<String> errorFields = new List<String>();
         if(account.Ethics_COI_Code_of_Conduct__c != 'Yes') {
             errorFields.add('Please confirm that you have read the Policy on Ethics and COI and the Code of Conduct : Select at the bottom.');
         }
         System.debug('----Account---'+account.Name);
         if(account.Name == NULL) {errorFields.add(System.Label.CDF_PR_Organization_Missing);}
         if(account.Full_Legal__c == NUll) {errorFields.add(System.Label.CDF_Full_Legal_Name_Missing);}
         if(account.Legal_Abbreviation__c == NULL) {errorFields.add(System.Label.CDF_Official_Abbreviation_Missing);}
         if(account.Address_line_1__c == NULL) {errorFields.add(System.Label.CDF_Address_line_1_missing);}
         if(account.PR_Type__c == NULL) {errorFields.add(System.Label.CDF_PRType_Missing);}
         if(account.City__c == NULL) {errorFields.add(System.Label.CDF_City_Missing);}
         if(account.Country_address__c == NULL) {errorFields.add(System.Label.CDF_Country_Mailing_Address_Missing);}
         if(account.PR_Fiscal_Cycle_Start_Month__c == NULL) {errorFields.add(System.Label.CDF_PR_Fiscal_Cycle_Start_Month_missing);}
         if(account.PR_Fiscal_Cycle_Start_Day__c == NULL) {errorFields.add(System.Label.CDF_PR_Fiscal_Cycle_Start_Day_missing);}
         if(account.PR_Fiscal_Cycle_End_Month__c == NULL) {errorFields.add(System.Label.CDF_PR_Fiscal_Cycle_End_Month_Missing);}
         if(account.PR_Fiscal_Cycle_End_Day__c == NULL) {errorFields.add(System.Label.CDF_PR_Fiscal_Cycle_End_Day_Missing);}        
         //if(account.Country__c == NULL) {errorFields.add('Country');}
         if(account.Different_Primary_Contact_Address__c==true)
         {
             if(account.Address_line_1_Primary__c==NULL) {errorFields.add(System.label.CDF_PrimaryAddr_Missing);}
             if(account.City_Primary__c==NULL) {errorFields.add(System.Label.CDF_City_Primary_Missing);}
             if(account.State_Province_Primary__c==NULL) {errorFields.add(System.Label.CDF_State_Missing);}
             if(account.Zip_Postal_Code_Primary__c==NULL) {errorFields.add(System.Label.CDF_zipCode_Missing);}
             if(account.Country_Mailing_Address_Primary__c==NULL) {errorFields.add(System.Label.CDF_Country_Missing);}
         }
         //PR Contacts. Now the page will only check for the first signatory if the page is in Finance Mode. Modified 2014-06-17 by Matthew Miller     
/*
         List<Contact> ccmContact = new List<Contact>();
         if(contactCCMChair != null) ccmContact.add(contactCCMChair);
         if(contactCCMCivilSociety != null) ccmContact.add(contactCCMCivilSociety);
       
         List<Contact> signatoryContact = new List<Contact>();
         if(grantAgreement != null && !blnFinanceMode) signatoryContact.add(grantAgreement);
         if(disbursementRequest1 != null && !blnFinanceMode) signatoryContact.add(disbursementRequest1);        
         if(disbursementRequest2 != null && !blnFinanceMode){
            signatoryContact.add(disbursementRequest2);         
         }
         
         for(Contact contact : signatoryContact) {  
             if(contact.FirstName == NULL) { errorFields.add(contact.Role__c + ' '+System.Label.CDF_FirstName);}
             if(contact.LastName == NULL) {errorFields.add(contact.Role__c + ' '+System.Label.CDF_Last_Name);}
             if(contact.Email == NULL) { errorFields.add(contact.Role__c + ' '+System.Label.CDF_Email);}  // As per request of Finance, Email and Phone are no longer required. 2014-6-17 modified by Matthew Miller
             //if(Contact.Phone == NULL) {errorFields.add(contact.Role__c + ' Phone');}
             if(contact.Phone != null){
                 if(!checkPhone(contact.Phone)){errorFields.add(Contact.Role__c + ' '+System.Label.CDF_Phone_Validation);}
             }
             if(contact.Title == NULL) {errorFields.add(contact.Role__c + ' '+System.Label.CDF_Title);}
             if(contact.Primary_Contact__c) {hasPrimaryContact = true;}
         }
*/
         for(Contact contact : listContacts) {
               if(!blnFinanceMode){
                 if(contact.FirstName == NULL) {errorFields.add(System.Label.CDF_FirstName);}
                 if(contact.Role__c == NULL) {errorFields.add(System.Label.CDF_Role);}
                 if(contact.Email == NULL) {errorFields.add(System.Label.CDF_Email);} //As per request of Finance, Email and Phone are no longer required. 2014-6-17 modified by Matthew Miller
                 if(contact.Phone != null){
                   if(!checkPhone(contact.Phone)) {errorFields.add(System.Label.CDF_Phone_Validation);}}
                 }
             
                 if(contact.Primary_Contact__c){
                   if(!blnFinanceMode){
                     //if(contact.Phone == NULL) {errorFields.add('PR Contact Phone');}                     
                     if(contact.Salutation == NULL) {errorFields.add(System.Label.CDF_Salutation);}
                     if(contact.Title == NULL) {errorFields.add(System.Label.CDF_Title);}
                   }
                   hasPrimaryContact = true;
                 }
           }
           
           System.debug('=====lstAttachment ======'+lstAttachment );
             if( lstAttachment.isEmpty() ){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.CDF_AttachmentValidation));
                 success = false;
                 return NULL;        
             }else if( lstAttachment.size() == 1){
                if( lstAttachment[0].BodyLength == 0){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.CDF_AttachmentContentValidation));
                     success = false;
                     return NULL;   
                }
             }else{
                 success = true;
             }

         //CCM Contacts. If the page is in Finance Mode, these are not required. Modified 2014-06-17 by Matthew Miller
/*         if(!blnFinanceMode){
           if(implementationPeriod.CCM_Civil_Society_Representative__c == NULL) { errorFields.add(System.Label.CDF_CCM_Civil_Society_Representative); }               
           if(implementationPeriod.CCM_Chair__c == NULL) { errorFields.add(System.Label.CDF_CCM_Chair); }
         }

         if(implementationPeriod.Grant_Tax_Exemption__c== NULL) {errorFields.add(System.Label.CDF_Grant_Tax_Exemption);}
*/
         if(errorFields.size() > 0) {
             errorMessage = System.Label.CDF_ErrorValidations;
             errorMessage += '<ul>';
             errorFields.sort();
             for(String field : errorFields) {
                 errorMessage += '<li>'+field+'</li>';
             }
             errorMessage += '</ul>';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
             success = false;
             System.debug(' in check validations---');
             return NULL;
         } else if(!hasPrimaryContact){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CDF_PrimaryContact_missing));
             success = false;
             return NULL;
         }else{
             success = true;
         }
/*
         // Check Primary Contact on Implementation Period
         List<Contact> contactList = [SELECT Id , Name FROM Contact 
                                      WHERE Primary_Contact__c = true 
                                      AND AccountId = :account.id
                                      AND (Id in :listContacts OR Id in :signatoryContact)];
*/         /*if(contactList.size() == 0 && !blnFinanceMode) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must select one PR Contact as the Primary Contact for the organization'));
             success = false;
             return NULL;
         }else{
             success = true;
         }*/
/*         if(contactList.size() > 1) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.CDF_SinglePrimaryValidtion));
             success = false;
             return NULL;
         }else{
             success = true;
         }
*/         
         List<Contact> primaryOffPage = [SELECT Id , Name FROM Contact 
                                      WHERE Primary_Contact__c = true 
                                      AND AccountId = :account.id
                                      AND Id not in :listContacts ];  //AND Id not in :signatoryContact
                                      
               for(Contact pc : primaryOffPage){
                  pc.Primary_Contact__c = false; }
               update primaryOffPage;
          return NULL;    
     }
        
     public Pagereference submittForApproval() {    
         
         // Save Record first 
         Pagereference pg = saveRecord();
         System.debug('----PG---'+pg);
         
         return checkValidations();
         
     } 
     
     
     Boolean noError = true;
     public Pagereference saveRecord() {
         attachmentMessage = false;
         
         // Update Implementation Period
         checkValidations();
         contactPRRecordTypeId= Schema.SObjectType.Contact.RecordTypeInfosByName.get(System.Label.CDF_PR).getRecordTypeId();
         try{
/*             if(contactCCMCivilSociety.Id != NULL) {
                 implementationPeriod.CCM_Civil_Society_Representative__c = contactCCMCivilSociety.Id;
             }
             if(contactCCMChair.Id != NULL) {
                 implementationPeriod.CCM_Chair__c = contactCCMChair.Id;
             }
             System.debug('>>>>>grantAgreement'+grantAgreement);
             // Populate GrantAgreement
             if( !ApexPages.hasMessages(ApexPages.Severity.ERROR)){
                 if(grantAgreement.Id == NULL) {
                     if( grantAgreement.LastName != NULL){ //MM removed the email as a requirement for upsert on 23.01.2014
                         
                         if( !duplicateContactCheck(grantAgreement) ){
                             
                             
                        }else{
                            //show exception on page for duplicate contact record.
                            noError = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Duplicate contact '+grantAgreement.FirstName+' '+ grantAgreement.lastName +' found.'));
                            return NULL;
                        }
                     }
                 } else {
    
                     implementationPeriod.Auth_Sig_for_Grant_Agreement__c = grantAgreement.Id;
                     upsert grantAgreement;  
                 }
                 System.debug('>>>>>disbursementRequest1'+disbursementRequest1);
                 // Populate disbursementRequest1
                 if(disbursementRequest1.Id == NULL) {
                     if(disbursementRequest1.Lastname != NULL){ //MM removed the email as a requirement for upsert on 23.01.2014
                        
                         if( !duplicateContactCheck(disbursementRequest1) ){
                             //insert disbursementRequest1;
                             //implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = disbursementRequest1.Id;
                         }else{
                             //show exception on page for duplicate contact record.
                             noError = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Duplicate contact '+disbursementRequest1.FirstName+' '+ disbursementRequest1.lastName +' found.'));
                            return NULL;
                         }
                     }
                 } else {
                     upsert disbursementRequest1;    
                 }
                 System.debug('>>>>>disbursementRequest2'+disbursementRequest2);
                 // Populate disbursementRequest2
                 if(disbursementRequest2.Id == NULL) {
                     if( disbursementRequest2.Lastname != NULL){ //MM removed the email as a requirement for upsert on 23.01.2014
                        
                         if( !duplicateContactCheck(disbursementRequest2) ){
                             //insert disbursementRequest2;
                             //implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = disbursementRequest2.Id;
                         }else{
                              //show exception on page for duplicate contact record.
                              noError = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Duplicate contact '+disbursementRequest2.FirstName+' '+ disbursementRequest2.lastName +' found.'));
                            return NULL;
                         }
                     }
                 } else {
                     upsert disbursementRequest2;    
                 }
                 System.debug('---'+ApexPages.hasMessages(ApexPages.Severity.ERROR));
              }  
                 if( noError  ){
                    if( grantAgreement != NULL &&  grantAgreement.lastName != NULL){
                        if( grantAgreement.Id == NULL ){
                            grantAgreement.RecordTypeId = contactPRRecordTypeId;
                            grantAgreement.AccountId = account.Id;
                            grantAgreement.Role__c = System.Label.CDF_Authorized_Signatory_for_Grant_Agreement;
                            //check if contact is already present in the system.
                            
                            insert grantAgreement;
                            implementationPeriod.Auth_Sig_for_Grant_Agreement__c = grantAgreement.Id;
                             System.debug('-grantAgreement--'+grantAgreement);
                        }
                    }
                    if( disbursementRequest1 != NULL &&  disbursementRequest1.lastName != NULL){
                        if( disbursementRequest1.Id == NULL ){
                             disbursementRequest1.RecordTypeId = contactPRRecordTypeId;
                             disbursementRequest1.AccountId = account.Id;
                             disbursementRequest1.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
                            insert disbursementRequest1;
                            implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = disbursementRequest1.Id;
                             System.debug('-disbursementRequest1--'+disbursementRequest1);
                        }
                    }
                    if( disbursementRequest2 != NULL && disbursementRequest2.lastName != NULL ){
                        if( disbursementRequest2.Id == NULL ){
                             disbursementRequest2.RecordTypeId = contactPRRecordTypeId;
                             disbursementRequest2.AccountId = account.Id;
                             disbursementRequest2.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
                            insert disbursementRequest2;
                            implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = disbursementRequest2.Id;
                             System.debug('-disbursementRequest2--'+disbursementRequest2);
                        }
                   }
                    
                     System.debug('>>>>>implementationPeriod'+implementationPeriod);
                     update implementationPeriod;
                     account.Submitted_GIP_Id__c = implementationPeriod.Id;
                     update account;
 */       
                     // Upsert Key Contacts
                     system.debug('>>>>clistContactsoUpdate'+listContacts);
                     List<Contact> lstContactToUpdate = new List<Contact>();
                     for(Contact c : listContacts) {
                         system.debug('------0--->'+c);
                         if(c.Id != NULL) {
                             system.debug('------1--->'+c);
                             lstContactToUpdate.add(c);
                             system.debug('>>>>'+c);
                         } else {
                            
                             system.debug('------2--->'+c);
                             if(c.email != NULL && c.LastName != NULL && c.Role__c != NULL ) {
                                 c.RecordTypeId = contactPRRecordTypeId;
                                 c.AccountId = account.Id;
                                 lstContactToUpdate.add(c);
                             }
                         }

             }  
             system.debug('>>>>lstContactToUpdate'+lstContactToUpdate);
             upsert lstContactToUpdate;
 
                     
//                 }
            
            System.debug('---Successs'+success );
             
             //@Rohini : check if at least one attachment is presen. If not present throw the exception else save the record
             if( success ){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.CDF_Success));
                 return NULL;
             }else{
                 return NULL;
             }
         } catch (exception ex) {
             return NULL;
         }
         
     }
/*     
      public  boolean duplicateContactCheck(Contact conObj){
         orgContactList = new List<Contact>();
         
         for(Contact con : [Select id, FirstName, LastName, Email from Contact where createdDate <=: System.Today()]){
             if( con.firstName == conObj.FirstName && con.lastName == conObj.lastName || con.Email == conObj.Email ){
                 System.debug('Duplicate found'+con.id);
                 return true;                     
             }
         }
         return false;       
     }
*/
     public Pagereference deleteRowCon(){
         if(selectedIndex == NULL) {
             return null;
         }
         Contact contact  = listContacts.get(Integer.valueOf(selectedIndex));
         try{
             if(contact.Id != NULL) {
                 delete contact;
             }
         } catch (exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));return NULL;
         }
         listContacts.remove(Integer.valueOf(selectedIndex));
         return NULL;
     }
/*         
      public Pagereference clearPRRow(){
         Contact c = new Contact();
         c.RecordTypeId = contactPRRecordTypeId;
         c.AccountId = account.Id;
         System.debug('----selectedIndex --'+selectedIndex );
         if(selectedIndex == 'grant') {
            c.Role__c = System.Label.CDF_Authorized_Signatory_for_Grant_Agreement;
            grantAgreement = c;
            implementationPeriod.Auth_Sig_for_Grant_Agreement__c = null;
         }
         if(selectedIndex == 'dr1') {
            c.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
            disbursementRequest1 = c;
            implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = null;
         }
         if(selectedIndex == 'dr2') {
            c.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
            disbursementRequest2 = c;
            implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = null;
         }
         if(selectedIndex == 'ccmChair') {
            c.Role__c = 'CCM Chair';
            contactCCMChair = c;
            implementationPeriod.CCM_Chair__c = null;
         }
         if(selectedIndex == 'ccmSocietyRepresentative') {
            c.Role__c = 'CCM Civil Society Representative';
            contactCCMCivilSociety = c;
            implementationPeriod.CCM_Civil_Society_Representative__c= null;
         }
         return NULL;
     }

     public Pagereference updateCCMContact(){
        
         if(CCMContactId == NULL) {return NULL;}
         if(CCMContactType == 'ccmchair') {
             contactCCMChair = getContactById(CCMContactId);
             implementationPeriod.CCM_Chair__c = CCMContactId;      //upd by jl
         }

         if(CCMContactType == 'ccmcivil') {
             contactCCMCivilSociety = getContactById(CCMContactId);
             implementationPeriod.CCM_Civil_Society_Representative__c = CCMContactId;   //upd by jl
         }

         if(CCMContactType == 'grant') {
             grantAgreement = getContactById(CCMContactId);
             grantAgreement.Role__c = System.Label.CDF_Authorized_Signatory_for_Grant_Agreement;
             implementationPeriod.Auth_Sig_for_Grant_Agreement__c = CCMContactId;    //upd by jl
         }
         if(CCMContactType == 'request1') {
             disbursementRequest1 = getContactById(CCMContactId);
             disbursementRequest1.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
             implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c = CCMContactId;   //upd by jl
         }
         if(CCMContactType == 'request2') {
             disbursementRequest2 = getContactById(CCMContactId);
             disbursementRequest2.Role__c = System.Label.CDF_Authorized_Signatory_for_Disbursement_Request;
             implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c = CCMContactId;   //upd by jl
         }
         return NULL;
     }
*/
         public Static Map<Id,Contact> mapContacts = new Map<Id,Contact>(); 
/*         
         public static void populateMapContact(Set<Id> contactIdSet) {
            mapContacts = new Map<Id,Contact>([SELECT Name,Id, FirstName , LastName, Email,Phone ,Salutation , 
                                                                 Title, Role__c,Primary_Contact__c,Fax,Department
                                                                 FROM Contact 
                                                                 WHERE Id in: contactIdSet ]);
            system.debug('mapContacts '+mapContacts);
         }
*/         
     public Contact getContactById(Id contactId) {
         System.debug('-contactId---  '+contactId);
         if(contactId == NULL) {
             return new Contact();
         }
           if(!mapContacts.containsKey(contactId)) {
             
            List<Contact> lstAddCons = [SELECT Name,Id, FirstName , LastName, Email,Phone ,Salutation , 
                                             Title, Role__c,Primary_Contact__c,Fax,Department
                                             FROM Contact 
                                             WHERE Id =: contactId limit 1];
                                             
            if(!lstAddCons.isEmpty()){
                system.debug('Lst Contact '+lstAddCons);
            Contact c = lstAddCons[0]; 
                 mapContacts.put(c.Id,c);    }        
           }
         return mapContacts.get(contactId);
     }

     public Pagereference addNewPRContact(){
         
         for(Contact c : listContacts) {
             c.Primary_Contact__c = false;
         system.debug('listContacts===>'+ c +' List '+c.firstName+ c.lastName+c.Email+c.Role__c);     
             // c.Primary_Contact__c = true;
         }
         listContacts.add(new Contact(LastName = '', AccountId=account.Id));
         system.debug('LLLLLLlistContacts'+listContacts);
         return NULL;
     }
        // Rahul : method to clear Primary address fields if No is select for different Primary address
        
        public void showHideAddress(){
                If(account.Different_Primary_Contact_Address__c == false)
        {
            account.Address_line_1_Primary__c='';
            account.Address_line_2_Primary__c='';     
            account.Address_line_3_Primary__c='';
            account.City_Primary__c='';
            account.State_Province_Primary__c='';                
            account.Zip_Postal_Code_Primary__c='';
            account.Country_Mailing_Address_Primary__c='';
        }
        else
        {
            List<Account> a = new List<Account>([Select Address_line_1_Primary__c,Address_line_2_Primary__c,Address_line_3_Primary__c,City_Primary__c,
                                     State_Province_Primary__c,Zip_Postal_Code_Primary__c,Country_Mailing_Address_Primary__c
                                     from Account where Id = :account.Id]);
            if(a.size()>0)
            {
                account.Address_line_1_Primary__c=a[0].Address_line_1_Primary__c;
                account.Address_line_2_Primary__c=a[0].Address_line_2_Primary__c;     
                account.Address_line_3_Primary__c=a[0].Address_line_3_Primary__c;
                account.City_Primary__c=a[0].City_Primary__c;
                account.State_Province_Primary__c=a[0].State_Province_Primary__c;                
                account.Zip_Postal_Code_Primary__c=a[0].Zip_Postal_Code_Primary__c;
                account.Country_Mailing_Address_Primary__c=a[0].Country_Mailing_Address_Primary__c;
            }
        }
    }

     /* Check if Phone number is 15 Digit or 9 Digit
      */
     public boolean checkPhone(String phone) {
         if(phone.length() <= 40 && phone.length() >= 9) {
             return true;
         }
         return false;
     }
     
    /*
     public Pagereference uploadCCMCivil() {
         System.debug('><>>'+contactCCMCivilSociety.Id);
         System.debug('><>>'+attachCCMCivilSociety.Name);
         if(contactCCMCivilSociety.Id == NULL || attachCCMCivilSociety.Name == NULL ) {
             return null;
         }
         System.debug('><>>'+3);     
         try{
             if(attachCCMCivilSociety.id == NULL) {
                 attachCCMCivilSociety.ParentId = contactCCMCivilSociety.Id; 
             }
             upsert attachCCMCivilSociety;       
             //contactCCMCivilSociety = getContactById(implementationPeriod.CCM_Civil_Society_Representative__c);
             attachCCMCivilSociety = getAttachmentId(implementationPeriod.CCM_Civil_Society_Representative__c);
             System.debug('><>>'+attachCCMCivilSociety);
         }catch (exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
             return NULL;
         }   
         return NULL; 
     }
     */

     public Pagereference saveChangesAndRedirect() {
         saveRecord();
         Pagereference pg = new Pagereference('/apex/PRformList');
         pg.setRedirect(true);
         return pg;

     }

     public Pagereference attachfile(){
         saveRecord();
         Pagereference ref = new Pagereference('/p/attach/NoteAttach?pid='+account.Id+'&parentname='+account.Name+'&retURL=/apex/CDF_PRApprovalForm?id='+account.Id);
         ref.setRedirect(true);
         return ref;
     }
     
     /* For Custom Setting profile Implementation*/
     //TCS 15/10/2014: US Core Data Form
    public void checkProfile(){
                blnEditPRInformation = false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Profile_Access_Setting__c> checkpage = new List<Profile_Access_Setting__c>();
        checkpage = [Select Salesforce_Item__c,Status__c from Profile_Access_Setting__c where Page_Name__c ='PR Update Form Readonly' and Profile_Name__c =: profileName ];
        for (Profile_Access_Setting__c check : checkpage){
            if(check.Salesforce_Item__c == 'Edit PR Information') blnEditPRInformation = true;
            }
    }
    /* End */
}