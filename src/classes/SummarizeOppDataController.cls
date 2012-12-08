public with sharing class SummarizeOppDataController {
    public Opp_Summary_Data__c summaryCriteria {get;set;}
    public List<Opp_Summary_Data__c> summaryData {get;set;}
    public Opp_Summary_Data__c selectedSummary {get;set;}
    public String selectedSummaryId {get;set;}
    private Map<Id,Opp_Summary_Data__c> id2Summary = new Map<Id,Opp_Summary_Data__c>();
    
    public SummarizeOppDataController(){
        summaryCriteria = new Opp_Summary_Data__c();
        getSummaryData();
    }
    
    public PageReference doSummarize(){
        if (summaryCriteria == null ||
            summaryCriteria.Fiscal_Year__c == null || 
            summaryCriteria.Fiscal_Year__c.trim() == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                                                       'Please select a fiscal year'));
            return null;
        }
        
        try{
            SummarizeYearlyOpportunityData s = new SummarizeYearlyOpportunityData();
            s.fiscalYear = summaryCriteria.Fiscal_Year__c;
            ID batchProcessId = Database.executeBatch(s, 2000);
            Opp_Summary_Data__c summaryData = new Opp_Summary_Data__c();
        	summaryData.Batch_Job_Id__c = batchProcessId;
            summaryData.Fiscal_Year__c = summaryCriteria.Fiscal_Year__c;
            summaryData.Status__c = 'Processing';
            insert summaryData;
            getSummaryData();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                                                       'Unable to summarize data:'+e.getMessage()));
        }
        return null;
	}

    public PageReference getSummaryDetails()
    {
        selectedSummary = id2Summary.get(selectedSummaryId);
        if (selectedSummary != null && 
            selectedSummary.Status__c == 'Processing'){
            //This can only happen if the user clicks on a summary row that
            //was previously processing. The summary data is therefore stale 
            //and needs to be refreshed from the DB
              getSummaryData();
              selectedSummary = id2Summary.get(selectedSummaryId);  
        }
        return null;
    }

    private void getSummaryData(){
        selectedSummary = null;
        try{
            //Note: We can't use the simpler "Map<Id, SObject> = new Map<Id, SObject>()[soql query]"
            //notation here because we need a sorted list of summary data (most recent first)
            //and the Map would be an unordered list.
            summaryData = [select CreatedBy.Name, CreatedDate, Batch_Job_Id__c, Fiscal_Year__c,
                           Total_Closed_Lost_Amount__c, Total_Closed_Won_Amount__c,Total_Amount__c,
                           Total_Open_Amount__c, Status__c from Opp_Summary_Data__c 
                           order by createdDate desc limit 10];
            id2Summary = new Map<Id,Opp_Summary_Data__c>();
            for (Opp_Summary_Data__c i : summaryData){
                id2Summary.put(i.id, i);
            }
        }
        catch(QueryException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
}