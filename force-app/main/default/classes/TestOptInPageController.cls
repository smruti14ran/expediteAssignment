public class TestOptInPageController {
    public String paramAccountId { get; set; }
    public String paramCampaignId { get; set; }
    public String paramContactId { get; set; }
    
    public TestOptInPageController() {
        paramAccountId = ApexPages.currentPage().getParameters().get('accId');
        paramCampaignId = ApexPages.currentPage().getParameters().get('cmpId');
        paramContactId = ApexPages.currentPage().getParameters().get('conId');
    }
}