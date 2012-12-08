@isTest
public class CreatePushTopicTests {
	static void testInstallScript() {
        CreatePushTopic postInstallScript = new CreatePushTopic();
        Test.testInstall(postInstallScript, null);
        List<PushTopic> pushTopic = [select Name from PushTopic where name = 'OppSummaryData'];
        System.assertEquals(pushTopic.size(), 1, 'Push Topic not found');
    }
}