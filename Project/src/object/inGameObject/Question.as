package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	import constant.Constant;
	
	import controller.ObjectController.Controller;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class Question extends Sprite
	{
		[Embed(source = '../media/sprite/spriteSheet/Blackboard.jpg')]
		private static const Blackboard:Class;
		
		private static const SHORT_QUESTION	:String = "1 + 1= ?";
		private static const SHORT_ANSWER	:String = "2";
		private static const MCQ_QUESTION	:String = "Which continent does Singapore belongs to?";
		private static const MCQ_CHOICES	:Array = new Array("Asia", "Europe", "Africa");
		private static const MCQ_ANSWER		:Number = 0;
		
		private var _type 			:String;
		private var _question		:TextField;
		private var _answerShort	:TextInput;
		private var _answerMCQ		:ToggleGroup;
		private var _questionArea	:Panel;
		private var _isDisplayed	:Boolean = false;
		private var _isPoppedUp		:Boolean = false;
		private var _isCorrect		:Boolean;
		private var _mcqLayout		:VerticalLayout;
		private var _controller		:Controller;
		
		public function Question(controller:Controller, type:String)
		{
			this._controller = controller;
			this._type = type;
			this._isDisplayed = true;
			
			if(_type == Constant.MCQ_QUESTION)
			{
				this._mcqLayout = new VerticalLayout();
				this._mcqLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
				this._mcqLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
				this._mcqLayout.gap = 20;
			}
				
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage(event:Event):void
		{
			if(_isDisplayed)
			{
				displayQuestionArea();
				displayQuestion();
				PopUpManager.addPopUp(_questionArea);
				this._isPoppedUp = true;
			}
		}
				
		private function displayQuestionArea():void
		{
			_questionArea = new Panel();
			_questionArea.x = 50;
			_questionArea.y = 50;
			_questionArea.width  = 700;
			_questionArea.height = 500;
			_questionArea.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Quiz";
				header.y = -15;
				return header;
			}
		}
		
		private function displayQuestion():void
		{
			_question = new TextField(500, 150, null, ChapterOneConstant.GROBOLD_FONT, 18, 0xFF0000);
			if(_type == Constant.MCQ_QUESTION)
				_question.text = "Question: " + MCQ_QUESTION;
			else if(_type == Constant.SHORT_QUESTION)
				_question.text = "Question: " + SHORT_QUESTION;
			_question.y = -65;
			_question.autoScale = true;
			_question.hAlign = HAlign.LEFT;
			
			_questionArea.addChild(_question);
			var submitButton	:feathers.controls.Button = new feathers.controls.Button();
			submitButton.label = "Submit";
			submitButton.height = 50;
			submitButton.width = 150;
			submitButton.x = 520;
			submitButton.y = 320;
			if(this._type == Constant.SHORT_QUESTION)
				submitButton.addEventListener(Event.TRIGGERED, function(e:Event): void {
					onSubmitShortAns(_answerShort);
				});
			else if(this._type == Constant.MCQ_QUESTION)
				submitButton.addEventListener(Event.TRIGGERED, function(e:Event): void {
					onSubmitMCQAns(_answerMCQ);
				});
			_questionArea.addChild(submitButton);
			
			if(_type == Constant.SHORT_QUESTION)
				displayAnswerBox();
			else if (_type == Constant.MCQ_QUESTION)
				displayChoices();	
		}
		
		private function displayAnswerBox():void
		{
			this._answerShort = new TextInput();
			this._answerShort.width = 500;
			this._answerShort.height = 150;
			this._answerShort.x = 50;
			this._answerShort.y = 100;
			this._questionArea.addChild(this._answerShort);
			this.addChild(_questionArea);
		}
		
		private function displayChoices():void
		{		
			this._answerMCQ = new ToggleGroup();
			
			var radioContainer:ScrollContainer = new ScrollContainer();
			radioContainer.layout = this._mcqLayout;
			radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			for(var i:uint=0; i<MCQ_CHOICES.length; i++)
			{
				var choices:Radio = new Radio();
				choices.label = MCQ_CHOICES[i];
				_answerMCQ.addItem(choices);
				radioContainer.addChild(choices);
			}
			radioContainer.x = 50;
			radioContainer.y = 100;
			this._questionArea.addChild(radioContainer);
			this.addChild(_questionArea);
		}
		
		private function onSubmitShortAns(answer:TextInput):void{
			_isCorrect = checkAnswer(answer.text,0);
			this._controller.updateAnswerStatus(this._isCorrect);
			displayResult(_isCorrect);
		}
		
		private function onSubmitMCQAns(answer:ToggleGroup):void{
			_isCorrect = checkAnswer(null,answer.selectedIndex);
			this._controller.updateAnswerStatus(this._isCorrect);
			displayResult(_isCorrect);
		}
		
		private function checkAnswer(shortAnswer:String, mcqAnswer:int):Boolean
		{
			var result :Boolean;
			switch(_type)
			{
				case Constant.SHORT_QUESTION:
					if(shortAnswer.toLocaleLowerCase() == SHORT_ANSWER)
						result = true;
					else
						result = false;
					break;
				case Constant.MCQ_QUESTION:
					if(mcqAnswer == MCQ_ANSWER)
						result = true;
					else
						result = false;
					break;
				default:
					result = false;
					break;
			}
			return result;
		}
		
		private function displayResult(isCorrect:Boolean):void
		{
			_questionArea.removeChildren();
			var correction :TextField = new TextField(500, 150, null, ChapterOneConstant.GROBOLD_FONT, 15, 0xFF0000);;
			correction.y = -65;
			correction.autoScale = true;
			correction.hAlign = HAlign.CENTER;
			if(isCorrect)
				correction.text = "Congratulation! You are correct!";
			else
			{
				if(_type == Constant.SHORT_QUESTION)
					correction.text = "Sorry. The correct answer is '" + SHORT_ANSWER + "'.";
				else
					correction.text = "Sorry. The correct option is 'Option " + (MCQ_ANSWER + 1) + "'.";
			}
			_questionArea.addChild(correction);
			var closeButton :feathers.controls.Button = new feathers.controls.Button();
			closeButton.height = 50;
			closeButton.width = 150;
			closeButton.x = 520;
			closeButton.y = 320;
			closeButton.label = "OK";
			closeButton.addEventListener(Event.TRIGGERED, onCloseQuestionWindow);
			_questionArea.addChild(closeButton);
		}
		
		private function onCloseQuestionWindow(event:Event):void
		{
			PopUpManager.removePopUp(_questionArea, true );
			_isPoppedUp = false;
		}
		
		
	}
}