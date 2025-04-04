public class OpportunityTriggerHelper {
    public static void updateAccountTotalAmount(List<Opportunity> newOppInsertList, Map<Id, Opportunity> newOppInsertMap,
                                          List<Opportunity> oldOppInsertList, Map<Id, Opportunity> oldOppInsertMap) {
        Map<Id, Decimal> mapOfAcctIdToTotalAmt = new Map<Id, Decimal>();
        if(oldOppInsertList == null) {
        	// Only inserted records
        	// Get the exisiting Total Amount of related Account
        	mapOfAcctIdToTotalAmt = getAcctIdWithTotalAmount(newOppInsertList);
            
            // Add the newly inserted Oppotunities Amount to related Account's Total Amount
            mapOfAcctIdToTotalAmt = addAmountToTotalAmt(mapOfAcctIdToTotalAmt, newOppInsertList);
        } else if(newOppInsertList == null) {
            //Only deleted records
            // Get the exisiting Total Amount of related Account
            mapOfAcctIdToTotalAmt = getAcctIdWithTotalAmount(newOppInsertList);
            
            // Add the newly inserted Oppotunities Amount to related Account's Total Amount
            mapOfAcctIdToTotalAmt = deductAmountToTotalAmt(mapOfAcctIdToTotalAmt, oldOppInsertList);
        } else {
            //updated records
            // Get the only Opportunity list where Amount field is changed
            List<Opportunity> oppWithChangeAmountList = getOppAmountChangeList(newOppInsertList, oldOppInsertMap);
            mapOfAcctIdToTotalAmt = addAmountToTotalAmt(mapOfAcctIdToTotalAmt, oppWithChangeAmountList);
            mapOfAcctIdToTotalAmt = deductAmountToTotalAmt(mapOfAcctIdToTotalAmt, oppWithChangeAmountList);
        }
                                              
        updateAccountRecords(mapOfAcctIdToTotalAmt);
    }
    
    private static Map<Id, Decimal> getAcctIdWithTotalAmount(List<Opportunity> newOppInsertList) {
        Set<Id> setOfAcctIds = new Set<Id>();
        for(Opportunity opp : newOppInsertList) {
            setOfAcctIds.add(opp.AccountId);
        }
        
        Map<Id, Decimal> mapOfAcctIdToTotalAmt = new Map<Id, Decimal>();
        for(Account acct : [SELECT Id, Total_Amount__c FROM Account WHERE Id IN :setOfAcctIds]) {
            if(acct.Total_Amount__c == null) {
                acct.Total_Amount__c = 0.0;
            }
            mapOfAcctIdToTotalAmt.put(acct.Id, acct.Total_Amount__c);
        }
        
        return mapOfAcctIdToTotalAmt;
    }
    
    private static Map<Id, Decimal> addAmountToTotalAmt(Map<Id, Decimal> mapOfAcctIdToTotalAmt, List<Opportunity> newOppInsertList) {
        for(Opportunity opp : newOppInsertList) {
            Decimal oldValue = mapOfAcctIdToTotalAmt?.get(opp.AccountId);
            mapOfAcctIdToTotalAmt.put(opp.AccountId, oldValue + opp.Amount);
        }
        
        return mapOfAcctIdToTotalAmt;
    }
    
    private static Map<Id, Decimal> deductAmountToTotalAmt(Map<Id, Decimal> mapOfAcctIdToTotalAmt, List<Opportunity> oldOppInsertList) {
        for(Opportunity opp : oldOppInsertList) {
            Decimal oldValue = mapOfAcctIdToTotalAmt?.get(opp.AccountId);
            mapOfAcctIdToTotalAmt.put(opp.AccountId, oldValue - opp.Amount);
        }
        
        return mapOfAcctIdToTotalAmt;
    }
    
    private static List<Opportunity> getOppAmountChangeList(List<Opportunity> newOppInsertList, Map<Id, Opportunity> oldOppInsertMap) {
        List<Opportunity> updatedOppList = new List<Opportunity>();
        
        for(Opportunity opp : newOppInsertList) {
            if(opp.Amount != oldOppInsertMap.get(opp.Id).Amount) {
                updatedOppList.add(opp);
            }
        }
        
        return updatedOppList;
    }
    
    private static void updateAccountRecords(Map<Id, Decimal> mapOfAcctIdToTotalAmt) {
        List<Account> acctToBeUpdateList = new List<Account>();
        for(Id acctId : mapOfAcctIdToTotalAmt.KeySet()) {
            Decimal totalAmount = mapOfAcctIdToTotalAmt.get(acctId);
            acctToBeUpdateList.add(
            	new Account(Id = acctId, Total_Amount__c = totalAmount)
            );
        }
        
        if(acctToBeUpdateList.size() > 0) {
            UPDATE acctToBeUpdateList;
        }
    }
}