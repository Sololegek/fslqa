public with sharing class FlowXmlBuilder {
    private FlowXmlBuilder.Questionnaire QuestionnaireObject;
    private XmlStreamWriter writer;
    private String Label;
    private String Name;
    private String startElementReference;
    private Integer PositionX = 40;
    private integer PositionY = 50;
    private String StringXML;
/*

String FlowName = 'TestQuestionnare'
String FlowLabel = 'Test Questionnare'
FlowXmlBuilder XML = new FlowXmlBuilder();
XML.setLabel(FlowLabel);
XML.setStartElementReference('Questions');
XML.setQuestionnare(null);
XML.start();
XML.generateQuestions('Questions', 'Questions','tobody');
XML.addAssignmentBodyAnswers('To Body','tobody','totext');
XML.addAssignmentTextAnswers('text answers','totext','assignQID');
XML.addAssignmentQuestionnaireId('assign q id','assignQID','AssignWOLI');
XML.addAssignmentWOLI('Assign WOLI','AssignWOLI','addRecordCreation');
XML.addRecordCreation('add Record Creation','addRecordCreation',null);
XML.addFieldServiceQuestionare();
XML.end();
String res = XML.getXmlString();
System.debug(res);
String zipfile = FlowBuilderController.generateZip(FlowName,FlowName,Blob.valueof(res));
FlowBuilderController.Deploy(zipfile);

FlowBuilderController.uploadFileVersion(FlowName,'0691w00000111YeAAI',Blob.valueof(res));

*/
    private String Example = '{"Id":"12345","VisitType":"Installation","QuestionnaireType":"Patient","TherapyType":"Oxygen","Product":null,"ApiName":"api","Name":"name","Questions":[{"Id":0,"Text":"q1","Type":"Answer"},{"Id":1,"Text":"q2","Type":"Choice"},{"Id":2,"Text":"q3","Type":"Number"}]}';

    public FlowXmlBuilder () {
        this.writer = new XmlStreamWriter(); 
    }

    public void start () {
        this.writer.writeStartDocument('utf-8', '1.0');
        this.writer.writeStartElement(null, 'Flow', null);
        this.writer.writeNamespace('', 'http://soap.sforce.com/2006/04/metadata');
    }

    public void end () {
        this.addStartElementReference();
        this.writer.writeEndElement();
        this.writer.writeEndDocument();
        this.StringXML = this.writer.getXmlString();
        this.writer.close();
    }

    public String getXmlString () {
        return this.StringXML;
    }

    public void setLabel(String Label){
        this.Label = Label;
    }

    public void setStartElementReference(String startElementReference){
        this.startElementReference = startElementReference;
    }

    public void setQuestionnare( String questions ){
        if( questions == null ){
            questions = this.Example;
        }
        this.QuestionnaireObject = (FlowXmlBuilder.Questionnaire) JSON.deserialize(questions, FlowXmlBuilder.Questionnaire.class);
    }

    public void addFieldServiceQuestionare () {
        this.addLabel();
        this.addProcessType('FieldServiceMobile');
        this.addStatus('Active');
        this.addChoices();
        this.addProcessMetadataValues();
    }

    public void addStartElementReference(){
        this.writer.writeStartElement(null, 'startElementReference', null);
            this.writer.writeCharacters(this.startElementReference);
        this.writer.writeEndElement();
    }

    public void addProcessMetadataValues(){
        this.writer.writeStartElement(null, 'processMetadataValues', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters('BuilderType');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'value', null);
                this.writer.writeStartElement(null, 'stringValue', null);
                    this.writer.writeCharacters('LightningFlowBuilder');
                this.writer.writeEndElement();
            this.writer.writeEndElement();
        this.writer.writeEndElement();

        this.writer.writeStartElement(null, 'processMetadataValues', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters('OriginBuilderType');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'value', null);
                this.writer.writeStartElement(null, 'stringValue', null);
                    this.writer.writeCharacters('LightningFlowBuilder');
                this.writer.writeEndElement();
            this.writer.writeEndElement();
        this.writer.writeEndElement();
    }

    public void addLabel(){
        this.writer.writeStartElement(null, 'label', null);
            this.writer.writeCharacters(this.Label);
        this.writer.writeEndElement();
        this.writer.writeStartElement(null, 'interviewLabel', null);
            this.writer.writeCharacters(this.Label + ' {!$Flow.CurrentDateTime}');
        this.writer.writeEndElement();
    }

    public void addChoices(){
        this.writer.writeStartElement(null, 'choices', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters('No');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'choiceText', null);
                this.writer.writeCharacters('No');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'dataType', null);
                this.writer.writeCharacters('String');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'value', null);
                this.writer.writeStartElement(null, 'stringValue', null);
                    this.writer.writeCharacters('No');
                this.writer.writeEndElement();
            this.writer.writeEndElement();
        this.writer.writeEndElement();

        this.writer.writeStartElement(null, 'choices', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters('Yes');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'choiceText', null);
                this.writer.writeCharacters('Yes');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'dataType', null);
                this.writer.writeCharacters('String');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'value', null);
                this.writer.writeStartElement(null, 'stringValue', null);
                    this.writer.writeCharacters('Yes');
                this.writer.writeEndElement();
            this.writer.writeEndElement();
        this.writer.writeEndElement();
    }

    public void addStatus(String status){
        this.writer.writeStartElement(null, 'status', null);
            this.writer.writeCharacters(status);
        this.writer.writeEndElement();
    }

    public void addProcessType(String processType){
        this.writer.writeStartElement(null, 'processType', null);
            this.writer.writeCharacters(processType);
        this.writer.writeEndElement();
    }

    public Integer getPositionX(){
        this.PositionX += 100;
        return PositionX; 
    }

    public void generateQuestions(String Label, String ApiName, String Target){
        this.writer.writeStartElement(null, 'screens', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'allowBack', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'allowFinish', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'allowPause', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            if(Target != null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            this.writer.writeStartElement(null, 'showFooter', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'showHeader', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                Q.generateQuestion(this.writer);
            }
        this.writer.writeEndElement();
        this.generateVariableAnwers();
    }

    public void generateVariableAnwers(){
        for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
            Q.generateAnswerObject(this.writer);
        }
        this.generateVariableWOLI();
        this.generateVariableAnswerCollection();
    }

    public void generateVariableWOLI(){
        writer.writeStartElement(null, 'variables', null);
            writer.writeStartElement(null, 'description', null);
                writer.writeCharacters('WOLI Id');
            writer.writeEndElement();
            writer.writeStartElement(null, 'name', null);
                writer.writeCharacters('Id');
            writer.writeEndElement();
            writer.writeStartElement(null, 'dataType', null);
                writer.writeCharacters('String');
            writer.writeEndElement();
            writer.writeStartElement(null, 'isCollection', null);
                writer.writeCharacters('false');
            writer.writeEndElement();
            writer.writeStartElement(null, 'isInput', null);
                writer.writeCharacters('true');
            writer.writeEndElement();
            writer.writeStartElement(null, 'isOutput', null);
                writer.writeCharacters('false');
            writer.writeEndElement();
        writer.writeEndElement();
    }

    public void generateVariableAnswerCollection(){
        writer.writeStartElement(null, 'variables', null);
            writer.writeStartElement(null, 'name', null);
                writer.writeCharacters('answers');
            writer.writeEndElement();
            writer.writeStartElement(null, 'dataType', null);
                writer.writeCharacters('SObject');
            writer.writeEndElement();
            writer.writeStartElement(null, 'isCollection', null);
                writer.writeCharacters('true');
            writer.writeEndElement();
            writer.writeStartElement(null, 'isInput', null);
                writer.writeCharacters('false');
            writer.writeEndElement();
            writer.writeStartElement(null, 'isOutput', null);
                writer.writeCharacters('false');
            writer.writeEndElement();
            writer.writeStartElement(null, 'objectType', null);
                writer.writeCharacters('Answer__c');
            writer.writeEndElement();
        writer.writeEndElement();
    }

    public void addAssignmentAnswersToCollection(){
        this.writer.writeStartElement(null, 'assignments', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters('Answers_To_Collection');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters('Add Answers To Collection');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                this.writer.writeStartElement(null, 'assignmentItems', null);
                    this.writer.writeStartElement(null, 'assignToReference', null);
                        this.writer.writeCharacters('answers');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'operator', null);
                        this.writer.writeCharacters('Add');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'value', null);
                        this.writer.writeStartElement(null, 'elementReference', null);
                            this.writer.writeCharacters('AnswerObject'+Q.Id);
                        this.writer.writeEndElement();
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            /*
            this.writer.writeStartElement(null, 'connector', null);
                this.writer.writeStartElement(null, 'targetReference', null);
                    this.writer.writeCharacters('Insert_Answers');
                this.writer.writeEndElement();
            this.writer.writeEndElement();
            */
        this.writer.writeEndElement();
    }

    public void addAssignmentBodyAnswers(String Label, String ApiName, String Target){
        this.writer.writeStartElement(null, 'assignments', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                this.writer.writeStartElement(null, 'assignmentItems', null);
                    this.writer.writeStartElement(null, 'assignToReference', null);
                        this.writer.writeCharacters('AnswerObject' + Q.Id+'.Body__c');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'operator', null);
                        this.writer.writeCharacters('Assign');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'value', null);
                        this.writer.writeStartElement(null, 'elementReference', null);
                            this.writer.writeCharacters('Question0');
                        this.writer.writeEndElement();
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            if(Target!=null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
        this.writer.writeEndElement();
    }

    public void addAssignmentTextAnswers(String Label, String ApiName, String Target){
        this.writer.writeStartElement(null, 'assignments', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                this.writer.writeStartElement(null, 'assignmentItems', null);
                    this.writer.writeStartElement(null, 'assignToReference', null);
                        this.writer.writeCharacters('AnswerObject' + Q.Id+'.QuestionText__c');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'operator', null);
                        this.writer.writeCharacters('Assign');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'value', null);
                        this.writer.writeStartElement(null, 'stringValue', null);
                            this.writer.writeCharacters(Q.Text);
                        this.writer.writeEndElement();
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            if(Target!=null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
        this.writer.writeEndElement();
    }

    public void addAssignmentQuestionnaireId(String Label, String ApiName, String Target){
        this.writer.writeStartElement(null, 'assignments', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                this.writer.writeStartElement(null, 'assignmentItems', null);
                    this.writer.writeStartElement(null, 'assignToReference', null);
                        this.writer.writeCharacters('AnswerObject' + Q.Id+'.Questionnaire__c');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'operator', null);
                        this.writer.writeCharacters('Assign');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'value', null);
                        this.writer.writeStartElement(null, 'stringValue', null);
                            this.writer.writeCharacters(this.QuestionnaireObject.Id);
                        this.writer.writeEndElement();
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            if(Target!=null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
        this.writer.writeEndElement();
    }

    public void addRecordCreation(String Label, String ApiName, String Target){
        this.writer.writeStartElement(null, 'recordCreates', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'inputReference', null);
                this.writer.writeCharacters('answers');
            this.writer.writeEndElement();
            if(Target!=null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
        this.writer.writeEndElement();
    }

    public void addAssignmentWOLI(String Label, String ApiName, String Target){
        this.writer.writeStartElement(null, 'assignments', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                this.writer.writeStartElement(null, 'assignmentItems', null);
                    this.writer.writeStartElement(null, 'assignToReference', null);
                        this.writer.writeCharacters('AnswerObject' + Q.Id+'.Work_Order_Line_Item__c');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'operator', null);
                        this.writer.writeCharacters('Assign');
                    this.writer.writeEndElement();
                    this.writer.writeStartElement(null, 'value', null);
                        this.writer.writeStartElement(null, 'elementReference', null);
                            this.writer.writeCharacters('Id');
                        this.writer.writeEndElement();
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            if(Target!=null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
        this.writer.writeEndElement();
    }

    public void addQuestionnaireList(String Label, String ApiName, String Target) {
        this.writer.writeStartElement(null, 'screens', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'allowBack', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'allowFinish', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'allowPause', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            if(Target != null){
                this.writer.writeStartElement(null, 'connector', null);
                    this.writer.writeStartElement(null, 'targetReference', null);
                        this.writer.writeCharacters(Target);
                    this.writer.writeEndElement();
                this.writer.writeEndElement();
            }
            this.writer.writeStartElement(null, 'showFooter', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'showHeader', null);
                this.writer.writeCharacters('true');
            this.writer.writeEndElement();

        for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
                Q.generateQuestion(this.writer);
            }

        this.writer.writeEndElement();
        this.generateVariableAnwers();
    }

    public void addQuestionnaireChoice(String Label, String ApiName, String Target) {
        this.writer.writeStartElement(null, 'decisions', null);
            this.writer.writeStartElement(null, 'name', null);
                this.writer.writeCharacters(ApiName);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'label', null);
                this.writer.writeCharacters(Label);
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationX', null);
                this.writer.writeCharacters(String.valueOf(this.getPositionX()));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'locationY', null);
                this.writer.writeCharacters(String.valueOf(this.PositionY));
            this.writer.writeEndElement();
            this.writer.writeStartElement(null, 'connector', null);
                this.writer.writeStartElement(null, 'targetReference', null);
                    this.writer.writeCharacters();
                this.writer.writeEndElement();
            this.writer.writeEndElement();

        if(Target != null){
            this.writer.writeStartElement(null, 'connector', null);
            this.writer.writeStartElement(null, 'targetReference', null);
            this.writer.writeCharacters(Target);
            this.writer.writeEndElement();
            this.writer.writeEndElement();
        }
        this.writer.writeStartElement(null, 'showFooter', null);
        this.writer.writeCharacters('true');
        this.writer.writeEndElement();
        this.writer.writeStartElement(null, 'showHeader', null);
        this.writer.writeCharacters('true');
        this.writer.writeEndElement();
        for(FlowXmlBuilder.Question Q : this.QuestionnaireObject.Questions ){
            Q.generateQuestion(this.writer);
        }
        this.writer.writeEndElement();
        this.generateVariableAnwers();*/
    }

    public class Questionnaire {
        public String Id {get;set;}
        public String VisitType {get;set;}
        public String QuestionnaireType {get;set;}
        public String TherapyType {get;set;}
        public String Product {get;set;}
        public String ApiName {get;set;}
        public String Name {get;set;}
        List<Question> Questions {get;set;}
    }
    public class Question {
        public Integer Id {get;set;}
        public String Text {get;set;}
        public String Type {get;set;}
        public String Datatype {get;set;}

        public void generateAnswerObject(XmlStreamWriter writer){
            writer.writeStartElement(null, 'variables', null);
                writer.writeStartElement(null, 'name', null);
                    writer.writeCharacters('AnswerObject' + this.Id);
                writer.writeEndElement();
                writer.writeStartElement(null, 'dataType', null);
                    writer.writeCharacters('SObject');
                writer.writeEndElement();
                writer.writeStartElement(null, 'isCollection', null);
                    writer.writeCharacters('false');
                writer.writeEndElement();
                writer.writeStartElement(null, 'isInput', null);
                    writer.writeCharacters('false');
                writer.writeEndElement();
                writer.writeStartElement(null, 'isOutput', null);
                    writer.writeCharacters('false');
                writer.writeEndElement();
                writer.writeStartElement(null, 'objectType', null);
                    writer.writeCharacters('Answer__c');
                writer.writeEndElement();
            writer.writeEndElement();
        }
        public void generateQuestion(XmlStreamWriter writer){
            if ( this.Type == 'Answer'){
                this.generateText(writer);
            } else if ( this.Type == 'Number'){
                this.generateNumber(writer);
            } else if ( this.Type == 'Choice'){
                this.generateRadio(writer);
            }
        }
        private void generateText(XmlStreamWriter writer){
            writer.writeStartElement(null, 'fields', null);
                writer.writeStartElement(null, 'name', null);
                    writer.writeCharacters('Question' + this.Id);
                writer.writeEndElement();
                writer.writeStartElement(null, 'dataType', null);
                    writer.writeCharacters('String');
                writer.writeEndElement();
                writer.writeStartElement(null, 'fieldText', null);
                    writer.writeCharacters(this.Text);
                writer.writeEndElement();
                writer.writeStartElement(null, 'fieldType', null);
                    writer.writeCharacters('InputField');
                writer.writeEndElement();
                writer.writeStartElement(null, 'isRequired', null);
                    writer.writeCharacters('true');
                writer.writeEndElement();
            writer.writeEndElement();
        }
        private void generateRadio(XmlStreamWriter writer){
            writer.writeStartElement(null, 'fields', null);
                writer.writeStartElement(null, 'choiceReferences', null);
                    writer.writeCharacters('Yes');
                writer.writeEndElement();
                writer.writeStartElement(null, 'choiceReferences', null);
                    writer.writeCharacters('No');
                writer.writeEndElement();
                writer.writeStartElement(null, 'defaultSelectedChoiceReference', null);
                    writer.writeCharacters('Yes');
                writer.writeEndElement();
                writer.writeStartElement(null, 'name', null);
                    writer.writeCharacters('Question' + this.Id);
                writer.writeEndElement();
                writer.writeStartElement(null, 'dataType', null);
                    writer.writeCharacters('String');
                writer.writeEndElement();
                writer.writeStartElement(null, 'fieldText', null);
                    writer.writeCharacters(this.Text);
                writer.writeEndElement();
                writer.writeStartElement(null, 'fieldType', null);
                    writer.writeCharacters('RadioButtons');
                writer.writeEndElement();
                writer.writeStartElement(null, 'isRequired', null);
                    writer.writeCharacters('false');
                writer.writeEndElement();
                writer.writeStartElement(null, 'scale', null);
                    writer.writeCharacters('0');
                writer.writeEndElement();
            writer.writeEndElement();
        }
        private void generateNumber(XmlStreamWriter writer){
            writer.writeStartElement(null, 'fields', null);
                writer.writeStartElement(null, 'name', null);
                    writer.writeCharacters('Question' + this.Id);
                writer.writeEndElement();
                writer.writeStartElement(null, 'dataType', null);
                    writer.writeCharacters('Number');
                writer.writeEndElement();
                writer.writeStartElement(null, 'fieldText', null);
                    writer.writeCharacters(this.Text);
                writer.writeEndElement();
                writer.writeStartElement(null, 'fieldType', null);
                    writer.writeCharacters('InputField');
                writer.writeEndElement();
                writer.writeStartElement(null, 'isRequired', null);
                    writer.writeCharacters('true');
                writer.writeEndElement();
                writer.writeStartElement(null, 'scale', null);
                    writer.writeCharacters('0');
                writer.writeEndElement();
            writer.writeEndElement();
        }
    }

}