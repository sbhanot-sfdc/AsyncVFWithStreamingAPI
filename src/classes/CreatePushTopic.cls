global class CreatePushTopic implements InstallHandler {
	global void onInstall(InstallContext context) {
        PushTopic pushTopic;
        try{
        	pushTopic = [select Name, query, ApiVersion, NotifyForOperations, NotifyForFields
            	         from PushTopic where name = 'OppSummaryData'];
        }catch(Exception e){}
        
        if (pushTopic == null){
            pushTopic = new PushTopic();
        }
        pushTopic.Name = 'OppSummaryData';
        pushTopic.Query = 'SELECT Id, Status__c FROM Opp_Summary_Data__c where status__c =\'Complete\'';
        pushTopic.ApiVersion = 26.0;
        pushTopic.NotifyForOperations = 'Update';
        pushTopic.NotifyForFields = 'Referenced';
        upsert pushTopic;
    }
}