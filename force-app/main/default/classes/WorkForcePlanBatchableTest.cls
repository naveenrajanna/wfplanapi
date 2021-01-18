@isTest
public class WorkForcePlanBatchableTest {
    @testSetup
    static void setup(){
        List<Case> caseList = new List<Case>();
        for(Integer i=0;i<10;i++) {
            caseList.add(new Case(Subject='TeleCase '+i,
                                Status='New', 
                                Origin='Phone'));
        }
        insert caseList;
    }

    @isTest static void testExecuteSuccess(){
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id from Case]);
        
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('makeWFPlanPostCallout_success');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
            WorkForcePlanBatchable cb = new WorkForcePlanBatchable(caseMap.keySet());
            Id batchId = database.executeBatch(cb, 10);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from Case where WorkforcePlanSecret__c != NULL]);
    }

    @isTest static void testExecuteFailure(){
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id from Case]);
        Database.BatchableContext bc;
        Test.startTest();
            try{
                WorkForcePlanBatchable cb = new WorkForcePlanBatchable(caseMap.keySet());
                cb.execute(bc, null);
            } catch(Exception e){

            }
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from Case where WorkforcePlanSecret__c != NULL]);
    }
}