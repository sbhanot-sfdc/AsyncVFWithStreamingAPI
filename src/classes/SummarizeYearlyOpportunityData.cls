global class SummarizeYearlyOpportunityData implements Database.Batchable<sObject>, Database.Stateful{
    public String fiscalYear;
    String query = 'select Amount, isClosed, isWon from Opportunity where FISCAL_YEAR(CloseDate) = {0}';
    Double totalAmt = 0;
    Double totalOpenAmt = 0;
    Double totalClosedWonAmt = 0;
    Double totalClosedLostAmt = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        query = String.format(query, new String[]{fiscalYear});
    	return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope){
        for(SObject s : scope){
            Opportunity o = (Opportunity)s;
            totalAmt += o.amount;
            if (o.isClosed){
                if (o.isWon){
                    totalClosedWonAmt += o.amount;
                }else{
                    totalClosedLostAmt += o.amount;
                }
            }else{
                totalOpenAmt += o.amount;
            }
        }
    }

    global void finish(Database.BatchableContext bc){
        Opp_Summary_Data__c summaryData = [select Batch_Job_Id__c, Fiscal_Year__c, Total_Amount__c, 
                                           Total_Closed_Lost_Amount__c, Total_Closed_Won_Amount__c,
                                           Total_Open_Amount__c from Opp_Summary_Data__c where
                                           Batch_Job_Id__c = :bc.getJobID()];
        summaryData.Status__c = 'Complete';
        summaryData.Fiscal_Year__c = fiscalYear;
        summaryData.Total_Amount__c = totalAmt;
        summaryData.Total_Closed_Lost_Amount__c = totalClosedLostAmt;
        summaryData.Total_Closed_Won_Amount__c = totalClosedWonAmt;
        summaryData.Total_Open_Amount__c = totalOpenAmt;
        update summaryData;
    } 
}