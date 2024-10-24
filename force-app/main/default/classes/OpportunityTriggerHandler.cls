public without sharing class OpportunityTriggerHandler{
    
    public void onBeforeInsert(List<Opportunity> opportunities, Map<Id, Opportunity> oldOpportunityMap) 
    {    
        system.debug('In before insert');
    }
    
    public void onBeforeUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap, List<Opportunity> oldOpportunities, Map<Id, Opportunity> oldOpportunityMap)
    {
        system.debug('In before update');
        checkPrimaryContact(opportunities, oldOpportunityMap);
    }
    
    public void onBeforeDelete(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap)
    {
        system.debug('In before delete');
    }
    
    public void onAfterInsert(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap)
    {
        system.debug('In after insert');
    }
    
    public void onAfterUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap, List<Opportunity> oldOpportunities, Map<Id, Opportunity> oldOpportunityMap)
    {
        system.debug('In after update');
        createPortalUser(opportunities, oldOpportunityMap);
    }
    
    public void onAfterDelete(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap)
    {
        system.debug('In after delete');
    }
    
    public void checkPrimaryContact(List<Opportunity> opportunities, Map<Id, Opportunity> oldMap){
        if(opportunities.size() > 0 && !opportunities.isEmpty()){
            Map<Id, Id> oppIdVsPrimaryContactMap = new Map<Id, Id>();
            for(Opportunity objOpp : [Select id, AccountId,Account.Primary_Contact__c from Opportunity where Id in: opportunities]){
                oppIdVsPrimaryContactMap.put(objOpp.id, objOpp.Account.Primary_Contact__c);
            }
            
            for(Opportunity objOpp : opportunities){                
                if(oldMap != null){
                    system.debug(oppIdVsPrimaryContactMap.get(objOpp.id));
                    if(objOpp.StageName == 'Accepted' && string.isNotEmpty(objOpp.StageName) 
                       && objOpp.StageName != oldMap.get(objOpp.Id).StageName && oppIdVsPrimaryContactMap.get(objOpp.id) == null){
                           system.debug(oppIdVsPrimaryContactMap.get(objOpp.id));
                           objOpp.adderror('Acc Blank');
                       }
                }
            }
        }
    }
    
    public void createPortalUser(List<Opportunity> opportunities, Map<Id, Opportunity> oldMap){
        if(opportunities.size() > 0 && !opportunities.isEmpty()){
            Map<Id, Id> oppIdVsPrimaryContactMap = new Map<Id, Id>();
            for(Opportunity objOpp : [Select id, AccountId,Account.Primary_Contact__c from Opportunity where Id in: opportunities]){
                oppIdVsPrimaryContactMap.put(objOpp.id, objOpp.Account.Primary_Contact__c);
            }
            
            set<id> setOfContactId = new set<id>();
            for(Opportunity objOpp : opportunities){                
                if(oldMap != null){
                    /*system.debug(oppIdVsPrimaryContactMap.get(objOpp.id));
                    if(objOpp.StageName == 'Accepted' && string.isNotEmpty(objOpp.StageName) 
                       && objOpp.StageName != oldMap.get(objOpp.Id).StageName && oppIdVsPrimaryContactMap.get(objOpp.id) == null){
                           system.debug(oppIdVsPrimaryContactMap.get(objOpp.id));
                           objOpp.adderror('Acc Blank');
                       }*/
                    
                    if(objOpp.StageName == 'Accepted' && string.isNotEmpty(objOpp.StageName) 
                       && objOpp.StageName != oldMap.get(objOpp.Id).StageName && oppIdVsPrimaryContactMap.containskey(objOpp.id)){
                           setOfContactId.add(oppIdVsPrimaryContactMap.get(objOpp.id));
                       }
                }
            }
            
            if(!setOfContactId.isEmpty() && setOfContactId.size() > 0){
                Set<String> conFieldList = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet();
                List<String> strListCon = new List<String>();
                strListCon.addAll(conFieldList);
                Set<String> setOfUsernames = new Set<String>();
                Set<String> setOfNicknames = new Set<String>();
                
                
                String soqlQueryO = ' SELECT ' + string.join(strListCon, ',') + ' FROM Contact Where Id IN: setOfContactId';
                List<Contact> recordsCon = (List<Contact>)Database.query(soqlQueryO);
                map<id, Contact> mapOdContact = new map<id, Contact>();
                if(recordsCon.size() > 0 && !recordsCon.isEmpty()){
                    for(Contact objCon : recordsCon){
                        mapOdContact.put(objCon.id, objCon);
                        setOfUsernames.add(objCon.Email);
                        setOfNicknames.add(objCon.FirstName.left(15) + objCon.LastName.left(25));
                    }
                }
                
                // Query On profile
                List<Profile> lstProfile = [select id, Name from Profile where Name = 'Custom Community' limit 1];
                
                set<string> setOfUserName = new set<string>();
                set<string> setOfNickName = new set<string>();
                
                map<id, User> mapOfContactsUser = new map<id, User>();
                
                
                List<User> lstUser = [select id, Name, UserName, Contact.Id, Email, IsActive from User where Contact.Id IN: setOfContactId OR UserName IN: setOfUsernames OR CommunityNickname IN: setOfNicknames];
                
                if(!lstUser.isEmpty() && lstUser.size() > 0){
                    for(User objUser : lstUser){
                        //Changes - 2021-04-14
                        If(objUser.Contact.Id != null){
                            mapOfContactsUser.put(objUser.Contact.Id, objUser);
                        }
                        
                        setOfUserName.add(objUser.UserName.toLowerCase());
                        setOfNickName.add(objUser.Username);
                    }
                }
                
                list<User> lstUserInsert = new list<User>();
                list<User> lstUserInActiveUpdate = new list<User>();
                list<Contact> lstContactUpdate = new list<Contact>();
                //Changes - 2021-04-14
                String oppEmail;
                String oppNickname;
                
                for(Opportunity objOpp : opportunities){
                    oppEmail = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).Email.toLowerCase();
                    //oppNickname = mapOdContact.get(objOpp.Primary_Contact__c).FirstName.left(15) + mapOdContact.get(objOpp.Primary_Contact__c).LastName.left(25);
                    Integer randomNumber = Integer.valueof((Math.random() * 1000));
                    oppNickname = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).FirstName.left(15) + mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).LastName.left(21)+randomNumber;
                    if(mapOfContactsUser.containsKey(oppIdVsPrimaryContactMap.get(objOpp.id))){
                        // objOpp.addError('User already exist for this Contact.');
                    }else if(setOfUserName.contains(oppEmail)){
                        // objOpp.addError('User already exist for this Contact.');
                    }else if(setOfNickName.contains(oppNickname)){
                        // objOpp.addError('User already exist for this Contact.');
                    }
                    else{
                        // Create User
                        User usr = new User();
                        usr.Email = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).Email;
                        usr.Username = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).Email;
                        usr.Alias = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).FirstName.left(1).trim() +  mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).LastName.right(7).trim();
                        usr.CommunityNickname = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).LastName.left(10) +mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).id;
                        usr.EmailEncodingKey = 'UTF-8';
                        usr.LanguageLocaleKey = 'en_US';
                        usr.LocaleSidKey = 'en_CA';
                        usr.ProfileId = lstProfile[0].Id;
                        usr.LastName = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).LastName;
                        usr.TimeZoneSidKey = 'America/New_York';
                        usr.ContactId = oppIdVsPrimaryContactMap.get(objOpp.id);
                        usr.FirstName = mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).FirstName;
                        
                        if(setOfUserName.contains(mapOdContact.get(oppIdVsPrimaryContactMap.get(objOpp.id)).Email.toLowerCase())){
                            usr.Username = string.valueOf(Math.random() * 100)+mapOdContact.get(objOpp.Account.Primary_Contact__c).Email;
                        }
                        lstUserInsert.add(usr);
                    }
                }
                
                if(!lstUserInsert.isEmpty() && lstUserInsert.size() > 0){
                    insert lstUserInsert;
                    
                }
            }
        }
    }
}