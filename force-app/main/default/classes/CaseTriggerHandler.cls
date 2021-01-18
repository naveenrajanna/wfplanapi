public class CaseTriggerHandler extends TriggerHandler {
    private Map<Id,Case> newCaseMap; 
    private Map<Id,Case> oldCaseMap;
    
    public CaseTriggerHandler() {
        newCaseMap = (Map<Id,Case>) Trigger.newMap;
        oldCaseMap = (Map<Id,Case>) Trigger.oldMap; 
    }

    public override void beforeUpdate() {
        //put logic here
    } 
    public override void  beforeInsert () {
        //put logic here
    } 
    public override void  beforeDelete () {
        //put logic here
    } 
    public override void  afterInsert () {
        //put logic here
    } 
    public override void afterUpdate() {
        Set<Id> caseIdSet = new Set<Id>();
        for(Case c : (List<Case>) Trigger.new){
            if(Trigger.isUpdate && c.Status != oldCaseMap.get(c.Id).Status && c.Status == 'Closed' )
            {
                caseIdSet.add(c.Id);
            }
        }

        if(!caseIdSet.isEmpty()) {
            this.setMaxLoopCount(1); // To prevent recursion
            Database.executeBatch(new WorkForcePlanBatchable(caseIdSet), 1);
        }
    } 
    public override void  afterDelete () {
        //put logic here
    }  
    public override void   afterUndelete  () {
        //put logic here
    }
}