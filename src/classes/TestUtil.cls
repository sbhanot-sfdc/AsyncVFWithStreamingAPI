@isTest
public class TestUtil {
	public static final String testFiscalYear = '2009';
	public static final Double testTotalAmount = 830000;
	public static final Double testTotalOpenAmount = 100000;
	public static final Double testTotalClosedWonAmount = 310000;
	public static final Double testTotalClosedLostAmount = 420000;
    
    public static List<Opportunity> createTestOppData(){
        List<Opportunity> ls = (List<Opportunity>)Test.loadData(Opportunity.sObjectType, 'testOpps');
        return ls;
    }
    
}