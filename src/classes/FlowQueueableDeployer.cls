/**
 * Created by Aleh_Salavei on 6/1/2020.
 */

public with sharing class FlowQueueableDeployer implements Queueable, Database.AllowsCallouts {

    public String zipfile;
    public String FlowName;
    public String xmlString;

    public FlowQueueableDeployer(String FlowName, String zipfile, String xmlString) {
        this.FlowName = FlowName;
        this.zipfile = zipfile;
        this.xmlString = xmlString;
    }

    public void execute(QueueableContext context) {
        MetadataService.AsyncResult result = Deploy(zipfile);
        uploadFileVersion(FlowName, Blob.valueof(xmlString));
    }

    private static MetadataService.AsyncResult Deploy (String ZipArchive) {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        //service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.SessionHeader.sessionId = FlowBuilderController.fetchUserSessionId();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        deployOptions.testLevel = 'NoTestRun';
        deployOptions.runTests = null;
        deployOptions.singlePackage = true;
        MetadataService.AsyncResult  res = service.deploy(ZipArchive, DeployOptions);
        return res;
    }

    private static void uploadFileVersion( String filename, Blob Content){
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
    }
}