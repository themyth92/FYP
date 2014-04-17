package object.inGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import manager.ServerClientManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class Question extends Sprite
	{
		private static const MCQ_QUESTION	:String = "Which continent does Singapore belongs to?";
		private static const MCQ_CHOICES	:Array = new Array({answer:"Asia"},{answer:"Europe"},{answer:"Africa"});
		private static const MCQ_ANSWER	:String = "01";
		private static const MCQ_HINT	:String = "It is in the same continent as China.";
		
		private var _questionDiv	:TextField;
		private var _choicesDiv	:ToggleGroup;
		private var _statusDiv	:TextField;
		private var _hintDiv	:TextField;
		
		//Provided information
		private var _correctAns	:String;
		private var _hint	:String;
		private var _choices	:Array;
		
		private var _questionArea	:Panel;
		private var _isDisplayed	:Boolean = false;
		private var _isPoppedUp	:Boolean = false;
		private var _isCorrect	:Boolean;
		private var _mcqLayout	:VerticalLayout;
		private var _controller	:MainController;
		private var _index		:Number;
		private var _serverClient	:ServerClientManager;
		
		public function Question(controller:MainController, index:Number)
		{
			this._controller = controller;
			this._isDisplayed = true;
			
			this._questionDiv = new TextField(500, 150, null, Constant.GROBOLD_FONT, 18, 0xFF0000);
			if(this._controller.screen == Constant.PLAY_SCREEN)
			{
				if(index != 0 && index != -1)
				{
					index --;
					this._questionDiv.text = "Question :" + Assets.getUserQuestion()[index].title;
					this._choices = Assets.getUserQuestion()[index].answers;
					this._hint = Assets.getUserQuestion()[index].hint;
					this._correctAns = Assets.getUserQuestion()[index].select;
					this._index = index;
				}
			}
			
			this._mcqLayout = new VerticalLayout();
			this._mcqLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			this._mcqLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			this._mcqLayout.gap = 20;
			
			this._serverClient = new ServerClientManager();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage(event:Event):void
		{
			if(_isDisplayed)
			{
				if(this._controller.screen == Constant.STORY_SCREEN_5)
				{
					this._questionDiv.text = MCQ_QUESTION;
					this._choices = MCQ_CHOICES;
					this._hint = MCQ_HINT;
					this._correctAns = MCQ_ANSWER;
				}
				displayQuestionArea();
				displayQuestion();
				displayStatus();
				
				PopUpManager.addPopUp(_questionArea);
				this._isPoppedUp = true;
			}
		}
		
		private function displayQuestionArea():void
		{
			var panelLayout	:VerticalLayout = new VerticalLayout();
			panelLayout.gap = 10;
			panelLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			panelLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			
			_questionArea = new Panel();
			_questionArea.x = 50;
			_questionArea.y = 50;
			_questionArea.width = 700;
			_questionArea.height = 500;
			_questionArea.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Quiz";
				header.y = -5;
				return header;
			}
			_questionArea.layout = panelLayout;
		}
		
		private function displayQuestion():void
		{
			this._questionDiv.y = -65;
			this._questionDiv.autoScale = true;
			this._questionDiv.hAlign = HAlign.LEFT;
			
			_questionArea.addChild(this._questionDiv);
			displayChoices();	
		}
		
		private function displayChoices():void
		{	
			this._choicesDiv = new ToggleGroup();
			
			var radioContainer:ScrollContainer = new ScrollContainer();
			radioContainer.layout = this._mcqLayout;
			radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			for(var i:uint=0; i<this._choices.length; i++)
			{
				var choices:Radio = new Radio();
				choices.label = this._choices[i].answer;
				_choicesDiv.addItem(choices);
				radioContainer.addChild(choices);
			}
			this._questionArea.addChild(radioContainer);
		}
		
		private function displayStatus():void{
			
			this._hintDiv = new TextField(500, 40, null, "Verdana", 16, 0xFFFFFF);
			this._questionArea.addChild(this._hintDiv);
			this._statusDiv = new TextField(500, 30, null,"Verdana", 16, 0xFF0000);
			
			this._questionArea.addChild(this._statusDiv);
			
			var buttonGroup	:LayoutGroup = new LayoutGroup();
			var buttonGroupLayout	:HorizontalLayout = new HorizontalLayout();
			buttonGroupLayout.gap = 75;
			buttonGroupLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			buttonGroup.layout = buttonGroupLayout;
			
			var submitButton :Button = new Button();
			submitButton.label = "Submit";
			submitButton.height = 50;
			submitButton.width = 150;
			submitButton.addEventListener(Event.TRIGGERED, onSubmitAns);
			buttonGroup.addChild(submitButton);
			
			var hint	:Button = new Button();
			hint.label = "Show Hint";
			hint.height = 50;
			hint.width = 150;
			hint.addEventListener(Event.TRIGGERED, showHint);
			buttonGroup.addChild(hint);
			
			var closeButton :Button = new Button();
			closeButton.label = "Exit";
			closeButton.height = 50;
			closeButton.width = 150;
			closeButton.addEventListener(Event.TRIGGERED, onCloseQuestionWindow);
			buttonGroup.addChild(closeButton);
			
			this._questionArea.addChildAt(buttonGroup, 4);
			this.dispatchEventWith('doingQuiz', true);
			this.addChild(_questionArea);
		}
		
		private function onSubmitAns():void{
			_isCorrect = checkAnswer(this._choicesDiv.selectedIndex);
			this._controller.updateAnswerStatus(this._isCorrect);
			displayResult(_isCorrect);
			this._questionArea.removeChildAt(4);
			var closeButton :Button = new Button();
			closeButton.label = "Exit";
			closeButton.height = 50;
			closeButton.width = 150;
			closeButton.x = 275;
			closeButton.addEventListener(Event.TRIGGERED, onCloseQuestionWindow);
			this._questionArea.addChildAt(closeButton, 4);
		}
		
		private function checkAnswer(mcqAnswer:int):Boolean
		{
			var result :Boolean;
			
			if(mcqAnswer+1 == Number(this._correctAns))
				result = true;
			else
				result = false;
			return result;
		}
		
		private function displayResult(isCorrect:Boolean):void
		{
			if(isCorrect)
				this._statusDiv.text = "Congratulation! You are correct!";
			else
				this._statusDiv.text = "Sorry. Your answer is not correct.";
			
			var returnData	:Object = new Object();
			returnData.gameID = PreviewGameInfo._gameID;
			returnData.questionIndex = this._index;
			returnData.correct = isCorrect;
			
			this._serverClient.sendQnsStats(returnData);
		}
		
		private function showHint(event:Event):void
		{
			this._hintDiv.text = this._hint;
		}
		
		private function onCloseQuestionWindow(event:Event):void
		{
			this.dispatchEventWith('doneQuiz', true);
			PopUpManager.removePopUp(_questionArea, true );
			_isPoppedUp = false;
			this._controller.doneQuiz();
		}
	}
}