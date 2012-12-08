@isTest
public class SummarizeYearlyOpportunityDataTests{
    
    static testMethod void testBatchSummary(){
        TestUtil.createTestOppData();
        Test.startTest();
        SummarizeYearlyOpportunityData s = new SummarizeYearlyOpportunityData();
        s.fiscalYear = TestUtil.testFiscalYear;
        
        Id batchProcessId = Database.executeBatch(s, 2000);
        Opp_Summary_Data__c summaryData = new Opp_Summary_Data__c();
        summaryData.Batch_Job_Id__c = batchProcessId;
        summaryData.Status__c = 'Processing';
        insert summaryData;        
        Test.stopTest();
        
        summaryData = 	   [select Batch_Job_Id__c, Fiscal_Year__c,
                           Total_Closed_Lost_Amount__c, Total_Closed_Won_Amount__c,
                           Total_Amount__c, Total_Open_Amount__c, Status__c 
                           from Opp_Summary_Data__c where id=: summaryData.Id];
        System.assertEquals(summaryData.Fiscal_Year__c, TestUtil.testFiscalYear);
        System.assertEquals(summaryData.Total_Amount__c, TestUtil.testTotalAmount);
        System.assertEquals(summaryData.Total_Open_Amount__c, TestUtil.testTotalOpenAmount);
        System.assertEquals(summaryData.Total_Closed_Lost_Amount__c, TestUtil.testTotalClosedLostAmount);
        System.assertEquals(summaryData.Total_Closed_Won_Amount__c, TestUtil.testTotalClosedWonAmount);
        System.assertEquals(summaryData.Status__c, 'Complete');
    }
}