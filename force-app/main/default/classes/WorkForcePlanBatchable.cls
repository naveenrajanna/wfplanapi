global class WorkForcePlanBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private Set<Id> caseIdSet;
    private List<Case> caseToUpdList;

    public WorkForcePlanBatchable(Set<Id> caseIdSet){
        this.caseIdSet = caseIdSet;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, OwnerId, WorkforcePlanSecret__c FROM Case WHERE Id in:caseIdSet';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope) {
        try{
            if(!scope.isEmpty()){            
                for(Case c:scope){
                    OutboundResponseWrapper responseWrapper = null;
                    String request='id='+c.Id+'&agentid='+c.OwnerId;
                    responseWrapper = WSLRESTCallout.makePostCallout(request);
                    if(responseWrapper != null) {
                        Map<String, Object> results = responseWrapper.outboundResponse;
                        caseToUpdList = new List<Case>();    
                        if(results.containsKey('response') && results.get('response') != null){
                            WSLRESTCallout.CalloutResponse response = (WSLRESTCallout.CalloutResponse) results.get('response');
                            caseToUpdList.add(new Case(Id=c.Id,WorkforcePlanSecret__c=response.secretKey));
                        }
                    }
                }
                if(!caseToUpdList.isEmpty()) update caseToUpdList; //update cases with the secretKey from WorkFlow Plan
            }
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }   

    global void finish(Database.BatchableContext BC) {
    }
}