/**
 * Created by Aleh_Salavei on 6/1/2020.
 */

public with sharing class ZipQueueableBuilder implements Queueable {

    public String xmlString;
    public String FlowName;

    public ZipQueueableBuilder(String FlowName, String xmlString) {
        this.FlowName = FlowName;
        this.xmlString = xmlString;
    }

    public void execute(QueueableContext context) {
        String zipfile = generateZip(FlowName, Blob.valueof(xmlString));
        System.enqueueJob(new FlowQueueableDeployer(FlowName, zipfile, xmlString));
    }

    private static String generateZip (String Name, Blob xmlFlow) {
        Zippex zipArchive = new Zippex();
        zipArchive.addFile('flows/'+Name+'.flow-meta.xml', xmlFlow, null);
        zipArchive.addFile('package.xml', generatePackageXML(), null);
        return EncodingUtil.base64Encode(zipArchive.getZipArchive());
    }

    private static Blob generatePackageXML () {
        return Blob.valueof('<Package xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<types>' +
                '<members>*</members>' +
                '<name>Flow</name>' +
                '</types>' +
                '<version>48.0</version>' +
                '</Package>');
    }
}