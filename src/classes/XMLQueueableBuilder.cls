/**
 * Created by Aleh_Salavei on 6/1/2020.
 */

public with sharing class XMLQueueableBuilder implements Queueable {

    private String JSONQuestions;
    private String FlowLabel;
    private String FlowName;

    public XMLQueueableBuilder(String FlowLabel, String FlowName, String JSONQuestions) {
        this.FlowLabel = FlowLabel;
        this.FlowName = FlowName;
        this.JSONQuestions = JSONQuestions;
    }

    public void execute(QueueableContext context) {
        FlowXmlBuilder XML = new FlowXmlBuilder();
        XML.setLabel(FlowLabel);
        //XML.setStartElementReference('Questions');
        XML.setStartElementReference('Questionnaires');
        XML.setQuestionnare(JSONQuestions);
        XML.start();

        XML.addQuestionnaireList('Questionnaires', 'Questionnaires', 'Choices');
        XML.addQuestionnaireChoice('Choices', 'Choices', 'Questions');

        XML.generateQuestions('Questions', 'Questions','tobody');
        XML.addAssignmentBodyAnswers('To Body','tobody','totext');
        XML.addAssignmentTextAnswers('text answers','totext','assignQID');
        XML.addAssignmentQuestionnaireId('assign q id','assignQID','AssignWOLI');
        XML.addAssignmentWOLI('Assign WOLI','AssignWOLI','addRecordCreation');
        XML.addRecordCreation('add Record Creation','addRecordCreation',null);
        XML.addFieldServiceQuestionare();
        XML.end();
        String xmlString = XML.getXmlString();

        System.enqueueJob(new ZipQueueableBuilder(FlowName, xmlString));
    }
}