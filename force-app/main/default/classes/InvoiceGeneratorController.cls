public class InvoiceGeneratorController {

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderLineItems(String orderId){
        return [select id,OrderItemNumber, Product2.Name,Activation_Date__c from OrderItem where OrderId =: orderId];
    }

    @AuraEnabled
    public static String createInvoices(String orderId,String activationDateInfo){
        List<Invoice_Line_Item__c> iliList = new List<Invoice_Line_Item__c>();
        Map<String,String> orderLineIdsToEffectiveDateMap = new Map<String,String>();
        System.debug(orderId);
        System.debug(activationDateInfo);
        List<ActivationDateInfo> actvationList = (List<ActivationDateInfo>)JSON.deserialize(activationDateInfo,List<ActivationDateInfo>.class);
        System.debug(ActivationDateInfo);
        for(ActivationDateInfo act : actvationList ){
			orderLineIdsToEffectiveDateMap.put(act.orderLineId, act.activationDate);      
        }
        try {
            Invoice__c invoiceInstance = new Invoice__c();
            invoiceInstance.Order__c = orderId;
            invoiceInstance.Status__c = 'Draft';
            invoiceInstance.Invoice_Date__c =  System.today();
            insert invoiceInstance;

            //Map<Id,OrderItem> oliIdtoOliMap = new Map<Id,OrderItem>([select id,Product2.Name, Quantity,UnitPrice, TotalPrice from OrderItem where Id in: orderLineIdsToEffectiveDateMap.keySet()]);
            List<OrderItem> orderLines = [select id,Product2.Name, Quantity,UnitPrice, TotalPrice from OrderItem where Id in: orderLineIdsToEffectiveDateMap.keySet()];
            for(OrderItem oi : orderLines){
				Invoice_Line_Item__c ili = new Invoice_Line_Item__c();
                ili.Quantity__c = oi.Quantity;
                ili.Name = oi.Product2.Name;
                ili.Unit_Price__c = oi.UnitPrice;
                ili.Total_Amount__c = oi.TotalPrice;
                ili.Invoice__c = invoiceInstance.Id;
                ili.Activation_Date__c = Date.valueOf(orderLineIdsToEffectiveDateMap.get(oi.Id));
                iliList.add(ili);
                
            }
            insert iliList;
            return invoiceInstance.Id;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class ActivationDateInfo{
        @AuraEnabled
        public string orderLineId;
        @AuraEnabled
        public string activationDate;
    }
}