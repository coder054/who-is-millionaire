pragma solidity ^0.4.0;

contract WhoIsMillionaire {

    event Log(string);
    address public manager;
    uint public maxNumberOfQuestions = 15;
    enum Stages {
        CreateQuestion,
        First5,
        FiveToTen,
        TenToFiftteem,
        Finished
    }

    uint public currentCreatingQuestionIndex;
    uint public currentAnswerQuestionIndex;


    Stages public stage = Stages.CreateQuestion;


    constructor () public payable {
        manager = msg.sender;
    }

    modifier onlyManager (){
        require(msg.sender == manager);
        _;
    }

    modifier atStage(Stages _stage) {
        require(stage == _stage);
        _;
    }



    struct Question {
        string question;
        string answerA;
        string answerB;
        string answerC;
        string answerD;
        uint value;
        uint correctAnswer; //1 is A, 2 is B .....
    }

    mapping (uint => Question) public questions;

    function createQuestion(
        string _question,
        string _answerA,
        string _answerB,
        string _answerC,
        string _answerD,
        uint _value,
        uint _correctAnswer
        )
        public onlyManager atStage(Stages.CreateQuestion) {

        require(currentCreatingQuestionIndex < maxNumberOfQuestions);
        Question memory question;
        question.question = _question;
        question.answerA = _answerA;
        question.answerB = _answerB;
        question.answerC = _answerC;
        question.answerD = _answerD;
        question.value = _value;
        question.correctAnswer = _correctAnswer;

        questions[currentCreatingQuestionIndex] = question;
        currentCreatingQuestionIndex++;
        if(currentCreatingQuestionIndex == maxNumberOfQuestions){
            stage = Stages.First5;
        }
    }

    function fetchNextQuestionToAnswer () public returns (string, string, string, string, string, uint) {
        require(stage!= Stages.CreateQuestion && stage!= Stages.Finished);
        if(currentAnswerQuestionIndex == 5){
            stage = Stages.FiveToTen;
        }else if(currentAnswerQuestionIndex == 10){
            stage = Stages.TenToFiftteem;
        }
        Question memory question;
        question = questions[currentAnswerQuestionIndex];

        return (
            question.question,
            question.answerA,
            question.answerB,
            question.answerC,
            question.answerD,
            question.value

        );
    }


    function answer(uint _answer) public {
        //1 is A, 2 is B

        Question memory question;
        question = questions[currentAnswerQuestionIndex];
        bool result = (question.correctAnswer == _answer);
        if(result){
            currentAnswerQuestionIndex++;
             emit Log("answerTrue");
        }else{
            emit Log("answerWrong");
            answerWrong();
        }
    }




    function minimumAward (Stages _stage) public pure returns (uint) {
        if(_stage == Stages.First5){
            return 0;
        } else if(_stage == Stages.FiveToTen){
            return 6000000000000000000;
        }else if(_stage == Stages.TenToFiftteem){
            return 11000000000000000000;
        }
    }

    function answerWrong() public {
        emit Log("answerWrong22222");
        require(stage!= Stages.Finished);
        uint award = minimumAward(stage);

        msg.sender.transfer(award);
        stage = Stages.Finished;
    }

    function StopPlaying() public {
        require(stage!= Stages.Finished);

        Question memory question;
        question = questions[currentAnswerQuestionIndex - 1];
        uint award = question.value;

        msg.sender.transfer(award);
        emit Log("stop playing");
        stage = Stages.Finished;
    }

    function getBalanceContract() public returns (uint){
        emit Log("getBalanceContract");
        return address(this).balance;
    }

    function resetToStageAfterCreatingQuestionFinished() public {
        require(stage!= Stages.CreateQuestion);


        currentAnswerQuestionIndex = 0;
        stage = Stages.First5;


    }

    function testTransfer() public {
        msg.sender.transfer(2000000000000000000);
    }

    function createQuestionsForTest() public  {
        createQuestion("Question1","a","b","c","d",1000000000000000000,1);
        createQuestion("Question2","a","b","c","d",2000000000000000000,1);
        createQuestion("Question3","a","b","c","d",3000000000000000000,1);
        createQuestion("Question4","a","b","c","d",4000000000000000000,1);
        createQuestion("Question5","a","b","c","d",5000000000000000000,1);
        createQuestion("Question6","a","b","c","d",6000000000000000000,1);
        createQuestion("Question7","a","b","c","d",7000000000000000000,1);
        createQuestion("Question8","a","b","c","d",8000000000000000000,1);
        createQuestion("Question9","a","b","c","d",9000000000000000000,1);
        createQuestion("Question10","a","b","c","d",10000000000000000000,1);
        createQuestion("Question11","a","b","c","d",11000000000000000000,1);
        createQuestion("Question12","a","b","c","d",12000000000000000000,1);
        createQuestion("Question13","a","b","c","d",13000000000000000000,1);
        createQuestion("Question14","a","b","c","d",14000000000000000000,1);
        createQuestion("Question15","a","b","c","d",15000000000000000000,1);
    }

    function deleteAllQuestions () public {
        for(uint i = 0; i < maxNumberOfQuestions; i++){
            delete questions[i];
        }
        stage = Stages.CreateQuestion;
        currentCreatingQuestionIndex= 0;

    }





}
