package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Radio;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Question extends Sprite
	{
		[Embed(source = '../media/sprite/spriteSheet/Blackboard.jpg')]
		private static const Blackboard:Class;
		
		private static const MCQ_TYPE	:String = "MCQ";
		private static const SHORT_TYPE	:String = "shortQuestion";
		
		private var _type 			:String;
		private var _question		:TextField;
		private var _answerShort	:TextInput;
		private var _answerMCQ		:Radio;
		private var _questionArea	:Image;
		private var _isDisplayed	:Boolean = false;
		private var _quizLayout		:LayoutGroup;
		
		public function Question(type:String)
		{
			_type = type;
			_isDisplayed = true;
			_quizLayout = new LayoutGroup();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage(event:Event):void
		{
			if(_isDisplayed)
			{
				displayQuestionArea();
				displayQuestion();
			}
		}
				
		private function displayQuestionArea():void
		{
			var texture: Texture = Texture.fromBitmap(new Blackboard());
			
			_questionArea 	= new Image(texture);
			_questionArea.x = 50;
			_questionArea.y = 50;
			_questionArea.width  = 400;
			_questionArea.height = 400;
			
			this.addChild(_questionArea);
		}
		
		private function displayQuestion():void
		{
			_question = new TextField(150, 75, "Question:", ChapterOneConstant.GROBOLD_FONT, 15, 0xFF0000);
			_question.x = 75;
			_question.y = 75;
			
			this.addChild(_question);
			
			if(_type == SHORT_TYPE)
				displayAnswerBox();
			else if (_type == MCQ_TYPE)
				displayChoices();	
		}
		
		private function displayAnswerBox():void
		{
			
		}
		
		private function displayChoices():void
		{		
			var choicesLayout:LayoutGroup = new LayoutGroup();
			var layout:VerticalLayout  = new VerticalLayout();
	
			layout.gap = 10;
			choicesLayout.layout = layout;
			
			/*
			var numChoices	:Number = getQuestionInfo('choices');
			for(var i:Number = 0; i < num_choices; i++)
			{
				var choicesValue: String = getQuestionInfor('choicesValue');
				choices	= new Radio();
				choices.label = choices_value;			
				choices.defaultSkin 		= new Image();
				choices.defaultSelectedSkin = new Image();
				choicesLayout.addChild(choices);
			
				choicesText = new TextField(choicesX, choicesY, choicesValue, ChapterOneConstant.GROBOLD_FONT, 15, 0xFF0000);
				this.addChild(choicesText);
			}
			*/
			
			var choices1	:Radio = new Radio();
			choices1.label = "Option 1";
			choicesLayout.addChild( choices1 );
			
			var choices2	:Radio = new Radio();
			choices2.label = "Option 2";
			choicesLayout.addChild( choices2 );
			
			var choices3	:Radio = new Radio();
			choices3.label = "Option 1";
			choicesLayout.addChild( choices3 );
			
			//var test = new TextField(150, 75, "asdsadsadsa", ChapterOneConstant.GROBOLD_FONT, 15, 0xFF0000);
			choicesLayout.x = 75;
			choicesLayout.y = 200;
			//PopUpManager.addPopUp(choicesLayout, true, true);
			this.addChild(choicesLayout);
		}
	}
}