trigger OpportunityTrigger on Opportunity (before update, before delete, after insert, after update, before insert)
{
    List<Opportunity> opportunities = (List<Opportunity>) Trigger.new;
    List<Opportunity> oldOpportunities = (List<Opportunity>) Trigger.old;
    Map<Id, Opportunity> opportunityMap = (Map<Id, Opportunity>) Trigger.newMap;
    Map<Id, Opportunity> oldOpportunityMap = (Map<Id, Opportunity>) Trigger.oldMap;
    
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            handler.onBeforeInsert(opportunities, oldOpportunityMap);
        }
        else if(Trigger.isUpdate)
        {
            handler.onBeforeUpdate(opportunities, opportunityMap, oldOpportunities, oldOpportunityMap);
        }
        else if(Trigger.isDelete)
        {
            handler.onBeforeDelete(oldOpportunities, oldOpportunityMap);
        }
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            handler.onAfterInsert(opportunities, opportunityMap);
        }
        else if(Trigger.isUpdate)
        {
            handler.onAfterUpdate(opportunities, opportunityMap, oldOpportunities, oldOpportunityMap);
        }
        else if(Trigger.isDelete)
        {
            handler.onAfterDelete(oldOpportunities, oldOpportunityMap);
        }
    }
    
}