@isTest
public class SummarizeOppDataControllerTests {
	static testMethod void summarizeOppDataTest(){
        TestUtil.createTestOppData();
        ApexPages.PageReference pr = Page.SummarizeOppData;
        Test.setCurrentPage(pr);
        Test.startTest();
        SummarizeOppDataController c = new SummarizeOppDataController();
        //Negative test
        c.doSummarize();
        System.assertEquals(ApexPages.hasMessages(ApexPages.severity.ERROR), true);
        c.summaryCriteria = new Opp_Summary_Data__c(Fiscal_Year__c = TestUtil.testFiscalYear);
        c.doSummarize();
        Test.stopTest();
        System.assertEquals(c.summaryData.size(), 1);
        c.selectedSummaryId = c.summaryData[0].Id;
        c.getSummaryDetails();
        System.assertEquals(c.selectedSummary, c.summaryData[0]);
    }
}