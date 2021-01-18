@isTest
private class CaseTriggerHandlerTest {
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
    @isTest static void testUpdateCaseToClosed() {
        List<Case> caseUpdList = new List<Case>();
        for(Case c: [Select Id,Status from Case]) {
            caseUpdList.add(new Case(Id=c.Id,Status='Closed'));
        }
        
        // Perform test
        Test.startTest();
        Database.SaveResult[] srList = Database.update(caseUpdList, false);
        Test.stopTest();

        // Verify that it was successful and no errors
        for (Database.SaveResult sr : srList) {
            System.AssertEquals(sr.isSuccess(), true);
        }
    }
    
}