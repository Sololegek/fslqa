/**
 * Created by Aleh_Salavei on 5/21/2020.
 */

import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getVisitTypes from '@salesforce/apex/FlowBuilderController.getVisitTypes';
import getFlowsApiNames from '@salesforce/apex/FlowBuilderController.getFlowsApiNames';
import getTherapyTypes from '@salesforce/apex/FlowBuilderController.getTherapyTypes';
import getProducts from '@salesforce/apex/FlowBuilderController.getProducts';
import getQuestions from '@salesforce/apex/FlowBuilderController.getQuestions';
import deployFlow from '@salesforce/apex/FlowBuilderController.DeployFlow';
import getQuestionnaireTypes from '@salesforce/apex/FlowBuilderController.getQuestionnaireTypes';

export default class QuestionnaireManager extends LightningElement {

    @track isEquipmentQuestionnaire;
    @track isPatientQuestionnaire;
    @track isTypeSelected;
    @track isVisitsLoaded;
    @track isTherapiesLoaded;
    @track isProductsLoaded;
    isEditMode;

    @track visitType;
    @track therapyType;
    @track product;
    @track questionnaireName;
    @track questionnaireType;
    @track questionnaireApiName;
    @track result;

    @track visitTypes = [];
    @track therapyTypes = [];
    @track products = [];
    @track questionnaireTypes = [];

    @track questionTypes = [
         {
            label : 'Choice',
            value : 'Choice'
        },
        {
            label : 'Answer',
            value : 'Answer'
        },
        {
            label : 'Number',
            value : 'Number'
        }
    ];

    @track questions = [
        {
            Id : 1,
            Text : '',
            Type : 'Answer'
        }
    ];

    @wire(getQuestionnaireTypes)
    wiredQuestionnairesTypes({data}) {
        if (data) {
            this.questionnaireTypes = JSON.parse(data);
        }
    }

    @wire(getVisitTypes)
    wiredVisits({data}) {
        if (data) {
            data.forEach(item =>
                this.visitTypes.push({label : item.Name, value : item.Name})
            );
            this.isVisitsLoaded = true;
        }
    }

    @wire(getTherapyTypes)
    wiredTherapies({data}) {
        if (data) {
            data.forEach(item =>
                this.therapyTypes.push({label : item.Name, value : item.Name})
            );
            this.isTherapiesLoaded = true;
        }
    }

    @wire(getProducts)
    wiredProducts({data}) {
        if (data) {
            data.forEach(item =>
                this.products.push({label : item.Name, value : item.Name})
            );
            this.isProductsLoaded = true;
        }
    }

    @wire(getFlowsApiNames)
    wiredFlows

    handleNameChanging(event) {
        this.questionnaireName = event.detail.value;
    }

    handleChangeProduct(event) {
        this.product = event.detail.value;
    }

    handleChangeTherapyType(event) {
        this.therapyType = event.detail.value;
    }

    handleChangeVisitType(event) {
        this.visitType = event.detail.value;
    }

    handleApiNameChanging(event) {
        this.questionnaireApiName = event.detail.value;
    }

    handleTextChanging(event) {
        const foundElement = this.questions.find(function(element) {
                return element.Id === event.target.name;
            });
        foundElement.Text = event.target.value;
    }

    handleChangeQuestionType(event){
        const foundElement = this.questions.find(function(element) {
                return element.Id === event.target.name;
            });
        foundElement.Type = event.target.value;
    }

    handleChangeQuestionnaireType(event) {
        this.questionnaireType = event.detail.value;
        if (this.questionnaireType == 'Patient') {
            this.isPatientQuestionnaire = true;
            this.isEquipmentQuestionnaire = false;
            this.product = null;
        } else if (this.questionnaireType == 'Equipment') {
            this.isPatientQuestionnaire = false;
            this.isEquipmentQuestionnaire = true;
            this.therapyType = null;
        }
    }

    createNewQuestionnaire() {
        if (this.visitType && (this.product || this.therapyType)) {
            this.questionnaireName = 'Q_' + this.visitType.split(' ').join('_') + '_' + this.questionnaireType.charAt(0) + '_' +
                (this.therapyType ? this.therapyType.split(' ').join('_') : this.product.split(' ').join('_'));
            this.questionnaireName = this.questionnaireName.replace(/[^\w]/g, '');
            this.questionnaireApiName = this.questionnaireName;

            const potentialDuplicateName = this.questionnaireApiName;
            getFlowsApiNames()
                .then(result => {
                    const duplicateName = result.find(function(element) {
                        return element === potentialDuplicateName;
                    });
                    if (duplicateName) {

                        const evt = new ShowToastEvent({
                            title: duplicateName,
                            message: 'This ApiName already existing',
                            variant: 'error'
                        });

                        this.dispatchEvent(evt);

                    } else {
                        this.isTypeSelected = true;
                    }
                });
        } else {
            const evt = new ShowToastEvent({
            title: 'Missed required field',
            message: 'Please fill required fields',
            variant: 'error'
        });
        this.dispatchEvent(evt);
        }
    }

    showListOfQuestionnaires() {
        if (this.visitType && (this.product || this.therapyType)) {
            const result = {
                VisitType : this.visitType,
                QuestionnaireType : this.questionnaireType,
                TherapyType : this.therapyType,
                Product : this.product
            };
            console.log(JSON.stringify(result));

            this.questionnaireName = 'Q_' + this.visitType.split(' ').join('_') + '_' + this.questionnaireType.charAt(0) + '_' +
                (this.therapyType ? this.therapyType.split(' ').join('_') : this.product.split(' ').join('_'));
            this.questionnaireName = this.questionnaireName.replace(/[^\w]/g, '');
            this.questionnaireApiName = this.questionnaireName;

            const potentialDuplicateName = this.questionnaireApiName;
            getFlowsApiNames()
                .then(result => {
                    const duplicateName = result.find(function(element) {
                        return element === potentialDuplicateName;
                    });

                    if (duplicateName) {
                        getQuestions({FlowName : this.questionnaireApiName}).then(
                            result => {
                                this.questions = JSON.parse(result);
                                console.log(this.questions);
                                this.isTypeSelected = true;
                                this.isEditMode = true;
                            });
                    } else {
                        const evt = new ShowToastEvent({
                            title: duplicateName,
                            message: 'This ApiName not existing',
                            variant: 'error'
                        });

                        this.dispatchEvent(evt);
                    }
                });

        } else {
            const evt = new ShowToastEvent({
            title: 'Missed required field',
            message: 'Please fill required fields',
            variant: 'error'
        });
        this.dispatchEvent(evt);
        }
    }

    addNewQuestion() {
        this.questions.push({Id : (this.questions.length + 1), Text : '', Type : 'Answer'});
    }

    cancelNewQuestionnaire() {
        this.isTypeSelected = false;
        this.isEditMode = false;
        this.questionnaireApiName = null;
        this.questionnaireName = null;
        this.result = null;
        this.questions = [
            {
                Id : 1,
                Text : '',
                Type : 'Answer'
            }
        ];
    }

    saveNewQuestionnaire(){
        if (this.questionnaireApiName && this.questionnaireName) {
            const potentialDuplicateName = this.questionnaireApiName;

            getFlowsApiNames()
                .then(result => {
                    const duplicateName = result.find(function(element) {
                        return element === potentialDuplicateName;
                    });

                    if (duplicateName && !this.isEditMode) {

                        const evt = new ShowToastEvent({
                            title: duplicateName,
                            message: 'This ApiName already existing',
                            variant: 'error'
                        });

                        this.dispatchEvent(evt);

                    } else {

                        const result = {
                            VisitType : this.visitType,
                            QuestionnaireType : this.questionnaireType,
                            TherapyType : this.therapyType,
                            Product : this.product,
                            ApiName : this.questionnaireApiName,
                            Name : this.questionnaireName,
                            Questions : this.questions
                        };
                        const request = JSON.stringify(result);
                        console.log(request);
                        this.insertQuestionnaireTemplate();
                        deployFlow({FlowLabel : this.questionnaireName, FlowName : this.questionnaireApiName, JSONQuestions : request})
                            .then(result => {
                                console.log(result);
                                this.result = JSON.parse(result);
                                if (this.isEditMode) {
                                    this.insertQuestionnaireTemplate();
                                }
                            })
                    };
                });
        } else {
            const evt = new ShowToastEvent({
                title: 'Missed required field',
                message: 'Please fill required fields',
                variant: 'error'
            });
            this.dispatchEvent(evt);
        }
    }

    insertQuestionnaireTemplate() {
        const recordInput = {
            apiName: 'Questionnaire_Template__c',
            fields: {
                "Name" : this.questionnaireName,
                "Products__c" : this.product,
                "Therapy_types__c" : this.therapyType,
                "Visit_Types__c" : this.visitType,
                "Type__c" : this.questionnaireType,
                "IsActive__c" : true
            }
        };
        createRecord(recordInput);
    }
}