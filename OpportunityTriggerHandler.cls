public class OpportunityTriggerHandler {
    public static void processTrigger() {
        if(Trigger.isInsert && Trigger.isAfter) {
            afterInsertHandle((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>)Trigger.newMap);
        }
        
        if(Trigger.isUpdate && Trigger.isAfter) {
            afterUpdateHandle((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>)Trigger.newMap, 
                              (List<Opportunity>)Trigger.Old, (Map<Id, Opportunity>)Trigger.oldMap);
        }
        
        if(Trigger.isDelete && Trigger.isAfter) {
            afterDeleteHandle((List<Opportunity>)Trigger.Old, (Map<Id, Opportunity>)Trigger.oldMap);
        }
    }
    
    private static void beforeInsertHandle() {
		
    }
    
    private static void afterInsertHandle(List<Opportunity> newOppInsertList, Map<Id, Opportunity> newOppInsertMap) {
		
    }
    
    private static void beforeUpdateHandle() {
		
    }
    
    private static void afterUpdateHandle(List<Opportunity> newOppInsertList, Map<Id, Opportunity> newOppInsertMap,
                                  List<Opportunity> oldOppInsertList, Map<Id, Opportunity> oldOppInsertMap) {
		
    }
    
    private static void beforeDeleteHandle() {
		
    }
    
    private static void afterDeleteHandle(List<Opportunity> oldOppInsertList, Map<Id, Opportunity> oldOppInsertMap) {
		
    }
    
    private static void afterUndeleteHandle() {
		
    }
}