public class DataService {

    public static String getOpportunities(Id accountId) {
        // Query to fetch open Opportunities, related Quotes, and Quote Line Items
        List<Opportunity> opportunities = [
            SELECT Id, Name, StageName, CloseDate,
                   (SELECT Id, Name, Status, 
                           (SELECT Id, Description, Quantity, PricebookEntry.UnitPrice 
                            FROM QuoteLineItems)
                    FROM Quotes)
            FROM Opportunity
            WHERE AccountId = :accountId AND IsClosed = false
        ];

        // Prepare the response wrapper
        ResponseWrapper response = new ResponseWrapper();
        response.status = 'success';
        response.data = new List<OpportunityWrapper>();

        for (Opportunity opp : opportunities) {
            OpportunityWrapper oppWrapper = new OpportunityWrapper();
            oppWrapper.opportunityId = opp.Id;
            oppWrapper.opportunityName = opp.Name;
            oppWrapper.stageName = opp.StageName;
            oppWrapper.closeDate = opp.CloseDate;
            oppWrapper.quotes = new List<QuoteWrapper>();

            for (Quote quote : opp.Quotes) {
                QuoteWrapper quoteWrapper = new QuoteWrapper();
                quoteWrapper.quoteId = quote.Id;
                quoteWrapper.quoteName = quote.Name;
                quoteWrapper.status = quote.Status;
                quoteWrapper.quoteLineItems = new List<QuoteLineItemWrapper>();

                for (QuoteLineItem qli : quote.QuoteLineItems) {
                    QuoteLineItemWrapper qliWrapper = new QuoteLineItemWrapper();
                    qliWrapper.lineItemId = qli.Id;
                    qliWrapper.description = qli.Description;
                    qliWrapper.quantity = qli.Quantity;
                    qliWrapper.unitPrice = qli.PricebookEntry.UnitPrice;
                    quoteWrapper.quoteLineItems.add(qliWrapper);
                }
                oppWrapper.quotes.add(quoteWrapper);
            }
            response.data.add(oppWrapper);
        }

        return JSON.serialize(response);
    }

    // Wrapper class for the overall response
    public class ResponseWrapper {
        public String status;
        public List<OpportunityWrapper> data;
    }

    // Wrapper class for Opportunities
    public class OpportunityWrapper {
        public Id opportunityId;
        public String opportunityName;
        public String stageName;
        public Date closeDate;
        public List<QuoteWrapper> quotes;
    }

    // Wrapper class for Quotes
    public class QuoteWrapper {
        public Id quoteId;
        public String quoteName;
        public String status;
        public List<QuoteLineItemWrapper> quoteLineItems;
    }

    // Wrapper class for Quote Line Items
    public class QuoteLineItemWrapper {
        public Id lineItemId;
        public String description;
        public Decimal quantity;
        public Decimal unitPrice;
    }
}