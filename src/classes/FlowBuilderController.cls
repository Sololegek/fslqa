public with sharing class FlowBuilderController {

    public FlowBuilderController() {

    }
    
    @AuraEnabled
    public static String DeployFlow(String FlowLabel, String FlowName, String JSONQuestions) {
        System.debug(FlowLabel);
        System.debug(FlowName);
        System.debug(JSONQuestions);

        XMLQueueableBuilder xmlQueueableBuilder = new XMLQueueableBuilder(FlowLabel, FlowName, JSONQuestions);
        Id jobId = System.enqueueJob(xmlQueueableBuilder);

        DeployResult DepRes = new DeployResult();
/*        DepRes.id = result.id;
        DepRes.message = result.message;
        DepRes.state = result.state;
        DepRes.statusCode = result.statusCode;
        DepRes.done = result.done;*/
        return JSON.serialize(DepRes);
    }

    public static List<FlowXmlBuilder.Question> getQuestionsByDocId(Id DocumentId){
        List<FlowXmlBuilder.Question> lstQ = new List<FlowXmlBuilder.Question>();
        ContentVersion CT = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:DocumentId AND IsLatest = true LIMIT 1];
        Dom.Document doc = new Dom.Document();
        System.debug(CT.VersionData.toString());
        doc.load(CT.VersionData.toString());
        Dom.XMLNode flow = doc.getRootElement();
        Integer counter = 1;
        for(Dom.XMLNode screenSearch : flow.getChildElements() ) {
            if( screenSearch.getName() == 'screens' ){
                for(Dom.XMLNode screenField : screenSearch.getChildElements() ) {
                    if(screenField.getName() == 'fields'){
                        FlowXmlBuilder.Question Q = new FlowXmlBuilder.Question();
                        for(Dom.XMLNode fieldNode : screenField.getChildElements() ) {
                            if( fieldNode.getName() == 'fieldText' ){
                                Q.Text = fieldNode.getText();
                            }
                            if( fieldNode.getName() == 'fieldType' ){
                                Q.Type = fieldNode.getText();
                            }
                            if( fieldNode.getName() == 'dataType'){
                                Q.Datatype = fieldNode.getText();
                            }
                        }
                        Q.Id = counter;
                        counter++;
                        if (Q.Type == 'RadioButtons'){
                            Q.Type = 'Choice';
                        } else if (Q.Datatype == 'Number'){
                            Q.Type = 'Number';
                        } else if (Q.Datatype == 'String'){
                            Q.Type = 'Answer';
                        }
                        
                        lstQ.add(Q);
                    }
                }
            }
        }
        return lstQ;
    }

    @AuraEnabled
    public static String fetchUserSessionId(){
         String sessionId = null;
         PageReference reportPage = Page.currentSessionId;
         String vfContent = reportPage.getContent().toString();
         Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
         endP = vfContent.indexOf('End_Of_Session_Id');
         sessionId = vfContent.substring(startP, endP);
         return sessionId;
     }

    @AuraEnabled
    public static String getQuestions(String FlowName){
        List<ContentDocument> lstDoc = new List<ContentDocument>();
        lstDoc = [SELECT Id FROM ContentDocument WHERE Title =: FlowName];
        return JSON.serialize((lstDoc.size() > 0) ? FlowBuilderController.getQuestionsByDocId(lstDoc.get(0).Id) : new List<FlowXmlBuilder.Question>());
    }

/*    public static void uploadFileVersion( String filename, Blob Content){
        List<ContentDocument> lstDoc = new List<ContentDocument>();
        lstDoc = [SELECT Id FROM ContentDocument WHERE Title =: filename];
        Id DocumentId = null;
        if(lstDoc.size()>0){
            DocumentId = lstDoc.get(0).Id;
        }
        ContentVersion contentVersion = new ContentVersion(
            ContentDocumentId = DocumentId,
            Title = filename,
            PathOnClient = filename,
            ReasonForChange = 'Document replaced by user',
            VersionData = Content,
            IsMajorVersion = true
        );
        insert contentVersion;
    }*/

    @AuraEnabled
    public static List<String> getFlowsApiNames() {

        List<FlowDefinitionView> flows = [SELECT ApiName FROM FlowDefinitionView];
        List<String> apiNames = new List<String>();

        for (FlowDefinitionView flow : flows) {
            apiNames.add(flow.ApiName);
        }

        return apiNames;
    }

    @AuraEnabled(Cacheable=true)
    public static List<ALH_TherapyType__c> getTherapyTypes() {
        return [SELECT Id, Name FROM ALH_TherapyType__c];
    }

    @AuraEnabled(Cacheable=true)
    public static List<WorkType> getVisitTypes() {
        return [SELECT Id, Name FROM WorkType];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Product2> getProducts() {
        return [SELECT Id, Name FROM Product2];
    }

    public class DeployResult {
        public String id {get;set;}
        public String message {get;set;}
        public String state {get;set;}
        public String statusCode {get;set;}
        public Boolean done {get;set;}
    }

    @AuraEnabled(Cacheable=true)
    public static String getQuestionnaireTypes(){
        return JSON.serialize(Questionnaire_Template__c.Type__c.getDescribe().getPicklistValues());
    }

}