package object.CreateGameObject
{
	import assets.Assets;
	import assets.PreviewGameInfo;
	
	import constant.Constant;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.controls.PickerList;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import flash.ui.Keyboard;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class ComponentPanel extends Sprite
	{
		private static const PLAYER_POS_GUIDE		:String = "Player's start position.\nCan take in value from 1 to 99.";
		private static const ENEMY1_POS_GUIDE		:String = "Enemy No.1's start position.\nCan take in value from 1 to 99.";
		private static const ENEMY1_SPD_GUIDE		:String = "Enemy No.1's speed.\nCan take in value from '1' to '9'.";
		private static const ENEMY2_POS_GUIDE		:String = "Enemy No.2's start position.\nCan only take in value from 1 to 99.";
		private static const ENEMY2_SPD_GUIDE		:String = "Enemy No.2's speed.\nCan take in value from '1' to '9'.";
		
		private var _titleInput			:TextInput;
		
		//used to notify user when the game is saved
		//or when user has error
		//this is used in game creation part
		private var _notiPanel   		:ScrollText;
		private var _endPtChoosePanel	:Panel;
		
		//Player characters info
		private var _playerPosInput		:TextInput;
		private var _genderInput		:ToggleSwitch;
		
		//Enemy 1 character info
		private var _enemy1InputType	:PickerList;
		private var _enemy1InputPos		:TextInput;
		private var _enemy1InputSpeed	:TextInput;
		private var _enemy1InputImage	:PickerList;
		
		//Enemy 2 character info	
		private var _enemy2InputType	:PickerList;
		private var _enemy2InputPos		:TextInput;
		private var _enemy2InputSpeed	:TextInput;
		private var _enemy2InputImage	:PickerList;
		
		private var _hasPatrol			:Array = new Array(false, false);
		private var _message:Label;		
		private var _callout	:Callout;
		private var _alert		:Alert;
		
		public function ComponentPanel()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener('gotPopUp', onGotPopUp);
			this.addEventListener('closedPopUp', onClosedPopUp);
		}
		
		private function onAlertClosed(event:Event):void{
			if(event.data != null)
			{
				if(event.data.id == "changeType")
				{
					if(event.data.enemy == "enemy1")
					{
						this._hasPatrol[0] = false;
						this._enemy1InputType.selectedIndex = 2;
					}
					else if(event.data.enemy == "enemy2")
					{
						this._hasPatrol[1] = false;
						this._enemy2InputType.selectedIndex = 2;
					}
				}
			}
			this.dispatchEventWith('popUpClose', true);
			this.removeEventListener(Event.CLOSE, onAlertClosed);
		}
		
		public function reset():void{
			this._playerPosInput.text = "";
			this._genderInput.isSelected = false;
			this._enemy1InputImage.selectedIndex = 0;
			this._enemy1InputPos.text = "";
			this._enemy1InputSpeed.text = "";
			this._enemy1InputType.selectedIndex = 2;
			
			this._enemy2InputImage.selectedIndex = 0;
			this._enemy2InputPos.text = "";
			this._enemy2InputSpeed.text = "";
			this._enemy2InputType.selectedIndex = 2;
		}
		
		public function test():String
		{
			return this._enemy1InputPos.text;
		}
		
		public function disableInput():void
		{
			this._playerPosInput.removeEventListener(FeathersEventType.ENTER, 		onPlayerPosEnter);
			this._playerPosInput.removeEventListener(FeathersEventType.FOCUS_IN, 	onPlayerPosFocus);
			this._playerPosInput.removeEventListener(FeathersEventType.FOCUS_OUT, 	onPlayerPosEnter);
			this._genderInput.removeEventListener	 (Event.CHANGE, 				onSwitch);
			
			this._enemy1InputType.removeEventListener	(Event.CHANGE, 				 onEnemy1TypeChange);
			this._enemy1InputPos.removeEventListener	(FeathersEventType.ENTER, 	 onEnemy1PosEnter);
			this._enemy1InputPos.removeEventListener	(FeathersEventType.FOCUS_IN, onEnemy1PosFocus);
			this._enemy1InputPos.removeEventListener	(FeathersEventType.FOCUS_OUT, 	 onEnemy1PosEnter);
			this._enemy1InputSpeed.removeEventListener	(FeathersEventType.ENTER, 	 onEnemy1SpeedEnter);
			this._enemy1InputSpeed.removeEventListener	(FeathersEventType.FOCUS_IN, onEnemy1SpeedFocus);
			this._enemy1InputSpeed.removeEventListener	(FeathersEventType.FOCUS_OUT, 	 onEnemy1SpeedEnter);
			this._enemy1InputImage.removeEventListener (Event.CHANGE,				 onEnemy1ImgChange);
			
			this._enemy2InputType.removeEventListener	(Event.CHANGE, 				 onEnemy2TypeChange);
			this._enemy2InputPos.removeEventListener	(FeathersEventType.ENTER, 	 onEnemy2PosEnter);
			this._enemy2InputPos.removeEventListener	(FeathersEventType.FOCUS_IN, onEnemy2PosFocus);
			this._enemy2InputPos.removeEventListener	(FeathersEventType.FOCUS_OUT, 	 onEnemy2PosEnter);
			this._enemy2InputSpeed.removeEventListener	(FeathersEventType.ENTER, 	 onEnemy2SpeedEnter);
			this._enemy2InputSpeed.removeEventListener	(FeathersEventType.FOCUS_IN, onEnemy2SpeedFocus);
			this._enemy2InputSpeed.removeEventListener	(FeathersEventType.FOCUS_OUT, 	 onEnemy2SpeedEnter);
			this._enemy2InputImage.removeEventListener (Event.CHANGE,				 onEnemy2ImgChange);
			
			this._playerPosInput.clearFocus();
			this._enemy1InputPos.clearFocus();
			this._enemy1InputSpeed.clearFocus();
			this._enemy2InputPos.clearFocus();
			this._enemy2InputSpeed.clearFocus();
			
			this._playerPosInput.touchable = false;
			this._genderInput.touchable = false;
			this._enemy1InputType.touchable = false;
			this._enemy1InputPos.touchable = false;
			this._enemy1InputSpeed.touchable = false;
			this._enemy1InputImage.touchable = false;
			this._enemy2InputType.touchable = false;
			this._enemy2InputPos.touchable = false;
			this._enemy2InputSpeed.touchable = false;
			this._enemy2InputImage.touchable = false;
			
			this._playerPosInput.isEnabled = false;
			this._genderInput.isEnabled = false;
			this._enemy1InputType.isEnabled = false;
			this._enemy1InputPos.isEnabled = false;
			this._enemy1InputSpeed.isEnabled = false;
			this._enemy1InputImage.isEnabled = false;
			this._enemy2InputType.isEnabled = false;
			this._enemy2InputPos.isEnabled = false;
			this._enemy2InputSpeed.isEnabled = false;
			this._enemy2InputImage.isEnabled = false;
			
			this._playerPosInput.isFocusEnabled = false;
			this._enemy1InputPos.isFocusEnabled = false;
			this._enemy1InputSpeed.isFocusEnabled = false;
			this._enemy2InputPos.isFocusEnabled = false;
			this._enemy2InputSpeed.isFocusEnabled = false;
			
			
		}
		
		public function enableInput():void
		{
			this._playerPosInput.touchable = true;
			this._genderInput.touchable = true;
			this._enemy1InputType.touchable = true;
			this._enemy1InputPos.touchable = true;
			this._enemy1InputSpeed.touchable = true;
			this._enemy1InputImage.touchable = true;
			this._enemy2InputType.touchable = true;
			this._enemy2InputPos.touchable = true;
			this._enemy2InputSpeed.touchable = true;
			this._enemy2InputImage.touchable = true;
			
			this._playerPosInput.isEnabled = true;
			this._genderInput.isEnabled = true;
			this._enemy1InputType.isEnabled = true;
			this._enemy1InputPos.isEnabled = true;
			this._enemy1InputSpeed.isEnabled = true;
			this._enemy1InputImage.isEnabled = true;
			this._enemy2InputType.isEnabled = true;
			this._enemy2InputPos.isEnabled = true;
			this._enemy2InputSpeed.isEnabled = true;
			this._enemy2InputImage.isEnabled = true;
			
			this._playerPosInput.isFocusEnabled = true;
			this._enemy1InputPos.isFocusEnabled = true;
			this._enemy1InputSpeed.isFocusEnabled = true;
			this._enemy2InputPos.isFocusEnabled = true;
			this._enemy2InputSpeed.isFocusEnabled = true;
			
			this._playerPosInput.addEventListener(FeathersEventType.ENTER, 		onPlayerPosEnter);
			this._playerPosInput.addEventListener(FeathersEventType.FOCUS_IN, 	onPlayerPosFocus);
			this._genderInput.addEventListener	 (Event.CHANGE, 				onSwitch);
			
			this._enemy1InputType.addEventListener	(Event.CHANGE, 				 onEnemy1TypeChange);
			this._enemy1InputPos.addEventListener	(FeathersEventType.ENTER, 	 onEnemy1PosEnter);
			this._enemy1InputPos.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy1PosFocus);
			this._enemy1InputSpeed.addEventListener	(FeathersEventType.ENTER, 	 onEnemy1SpeedEnter);
			this._enemy1InputSpeed.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy1SpeedFocus);
			this._enemy1InputImage.addEventListener (Event.CHANGE,				 onEnemy1ImgChange);
			
			this._enemy2InputType.addEventListener	(Event.CHANGE, 				 onEnemy2TypeChange);
			this._enemy2InputPos.addEventListener	(FeathersEventType.ENTER, 	 onEnemy2PosEnter);
			this._enemy2InputPos.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy2PosFocus);
			this._enemy2InputSpeed.addEventListener	(FeathersEventType.ENTER, 	 onEnemy2SpeedEnter);
			this._enemy2InputSpeed.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy2SpeedFocus);
			this._enemy2InputImage.addEventListener (Event.CHANGE,				 onEnemy2ImgChange);
		}
		
		/**====================================================================
		 * |	              GET INFORMATION FOR SAVING		              | *
		 * ====================================================================**/
		public function getTitle():String{
			return this._titleInput.text;
		}
		
		public function getPlayerInfo():Object
		{
			var gender		:String;
			var pos			:Number;
			
			if(this._genderInput.isSelected)
				gender = "Male";
			else 
				gender = "Female";
			
			pos = Number(this._playerPosInput.text);
			var playerInfo	:Object	= new Object();
			
			playerInfo.pos = pos;
			playerInfo.gender = gender;
			return playerInfo;
		}
		
		public function getEnemyInfo():Array
		{
			var enemy1		:Object = new Object();
			var enemy2		:Object = new Object();
						
			enemy1.type 		= _enemy1InputType.selectedItem;
			enemy1.pos 			= Number(_enemy1InputPos.text);
			enemy1.speed 		= Number(_enemy1InputSpeed.text);
			enemy1.textureIndex = _enemy1InputImage.selectedIndex + 1;
			
			enemy2.type 		= _enemy2InputType.selectedItem;
			enemy2.pos 			= Number(_enemy2InputPos.text);
			enemy2.speed 		= Number(_enemy2InputSpeed.text);
			enemy2.textureIndex = _enemy2InputImage.selectedIndex + 1;
			
			var enemyInfo	:Array = new Array(enemy1, enemy2);
			return enemyInfo;
		}
		
		public function setPosFocus(id:Number):void{
			if(id == 0)
				this._playerPosInput.setFocus();
			else if(id == 1)
				this._enemy1InputPos.setFocus();
			else if(id == 2)
				this._enemy2InputPos.setFocus();
		}
		
		/**====================================================================
		 * |	                     EVENT HANDLERS			                  | *
		 * ====================================================================**/
		private function onAddedToStage(event:Event):void
		{
			/* Get title for the game */
			this._titleInput = new TextInput();		
			this._titleInput.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontSize = 20;
				return editor;
			}
			this._titleInput.x = 10;
			this._titleInput.y = 50;
				
			//change the textinput width and height
			this._titleInput.width = 220;
			this._titleInput.height = 50;
			
			var text	:TextField;
			
			/* Setup layout for the whole information board */
			var infoGetter	:LayoutGroup = new LayoutGroup();
			var infoLayout	:VerticalLayout = new VerticalLayout();
			infoLayout.gap = 5;
			infoLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			infoGetter.layout = infoLayout;
			
			text = new TextField(150, 30,"Player:", "Verdana", 24, 0x304bbd, true);
			text.hAlign = starling.utils.HAlign.LEFT;
			infoGetter.addChild(text);
			
			/* Setup layout for each information */
			var layout	:HorizontalLayout = new HorizontalLayout();
			layout.gap = 50;
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			
			//debugger to notify error to user
			this._notiPanel        	= new ScrollText();
			
			/* Get player information */
			this._playerPosInput 	= new TextInput();
			this._playerPosInput.x 		= 196;	this._playerPosInput.y 		= 365;
			this._playerPosInput.width 	= 55; 	this._playerPosInput.height = 30;
			this._playerPosInput.textEditorProperties.fontSize = 10;
			text = new TextField(150, 30,"Position:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputPos :LayoutGroup = new LayoutGroup();
			inputPos.layout = layout;
			inputPos.addChild(text);
			inputPos.addChild(this._playerPosInput);
			infoGetter.addChild(inputPos);
			
			this._genderInput		= new ToggleSwitch();
			this._genderInput.x 		= 70;	this._genderInput.y 		= 365;
			this._genderInput.isSelected = false;
			this._genderInput.offText = "F";
			this._genderInput.onText = "M";
			this._genderInput.setSize(60, 30);
			this._genderInput.thumbProperties.@height = 30;
			this._genderInput.thumbProperties.@width = 30;
			text = new TextField(150, 30,"Gender:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputGender :LayoutGroup = new LayoutGroup();
			inputGender.layout = layout;
			inputGender.addChild(text);
			inputGender.addChild(this._genderInput);
			infoGetter.addChild(inputGender);
			
			/* Get enemies information */
			this._enemy1InputType 	= new PickerList();
			var enemyType	:Array = new Array(Constant.FOLLOW_TYPE, Constant.PATROL_TYPE, "None");
			this._enemy1InputType.dataProvider = new ListCollection(enemyType);
			this._enemy1InputType.selectedIndex = 2;
			
			this._enemy1InputPos	= new TextInput();
			this._enemy1InputSpeed	= new TextInput();
			this._enemy1InputImage	= new PickerList();
			var enemyImg	:Array = [];
			
			for(var i:uint=0; i<Constant.ENEMY_SPRITE_TEXTURE.length; i++)
			{
				var img			:Image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture(Constant.ENEMY_SPRITE_TEXTURE[i]));
				enemyImg.push(img);
			}
			
			this._enemy1InputImage.dataProvider = new ListCollection(
				[
					{ text: "Enemy 1", icon: enemyImg[0] },
					{ text: "Enemy 2", icon: enemyImg[1] },
					{ text: "Enemy 3", icon: enemyImg[2] },
					{ text: "Enemy 4", icon: enemyImg[3] },
					{ text: "Enemy 5", icon: enemyImg[4] },
					{ text: "Enemy 6", icon: enemyImg[5] },
				]);
			this._enemy1InputImage.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				renderer.accessoryField = "icon";
				renderer.layoutOrder = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;
				return renderer;
			};
			this._enemy1InputImage.selectedIndex = 0;
			
			this._enemy2InputType 	= new PickerList();
			this._enemy2InputType.dataProvider = new ListCollection(enemyType);
			this._enemy2InputType.selectedIndex = 2;
			this._enemy2InputPos	= new TextInput();
			this._enemy2InputSpeed	= new TextInput();
			this._enemy2InputImage	= new PickerList();
			
			this._enemy2InputImage.dataProvider = new ListCollection(
				[
					{ text: "Enemy 1", icon: enemyImg[0] },
					{ text: "Enemy 2", icon: enemyImg[1] },
					{ text: "Enemy 3", icon: enemyImg[2] },
					{ text: "Enemy 4", icon: enemyImg[3] },
					{ text: "Enemy 5", icon: enemyImg[4] },
					{ text: "Enemy 6", icon: enemyImg[5] },
				]);
			
			this._enemy2InputImage.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				renderer.accessoryField = "icon";
				renderer.layoutOrder = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;
				return renderer;
			};
			this._enemy2InputImage.selectedIndex = 0;
			
			this._enemy1InputType.width = 40;	this._enemy1InputType.height= 40;
			this._enemy1InputPos.width = 55;	this._enemy1InputPos.height = 30;
			this._enemy1InputSpeed.width = 55;	this._enemy1InputSpeed.height= 30;
			this._enemy1InputImage.width = 40;	this._enemy1InputImage.height= 40;
			
			this._enemy2InputType.width = 40;	this._enemy2InputType.height= 40;
			this._enemy2InputPos.width = 55;	this._enemy2InputPos.height= 30;
			this._enemy2InputSpeed.width = 55;	this._enemy2InputSpeed.height= 30;
			this._enemy2InputImage.width = 40;	this._enemy2InputImage.height= 40;
			
			/* Restrict user input to numberic or alphabet */
			this._playerPosInput.restrict 	= "0-9";
			
			this._enemy1InputPos.restrict 	= "0-9";
			this._enemy1InputSpeed.restrict = "0-9";
			
			this._enemy2InputPos.restrict 	= "0-9";
			this._enemy2InputSpeed.restrict = "0-9";
			
			this._playerPosInput.maxChars 	= 2;
			
			/* Limit number of characters user can input */
			this._enemy1InputPos.maxChars 	= 2;
			this._enemy1InputSpeed.maxChars = 5;
			
			this._enemy2InputPos.maxChars 	= 2;
			this._enemy2InputSpeed.maxChars = 5;
			
			text = new TextField(150, 30,"Enemy 1:", "Verdana", 24, 0x304bbd, true);
			text.hAlign = starling.utils.HAlign.LEFT;
			infoGetter.addChild(text);
			
			text = new TextField(150, 30,"Type:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE1Type :LayoutGroup = new LayoutGroup();
			inputE1Type.layout = layout;
			inputE1Type.addChild(text);
			inputE1Type.addChild(this._enemy1InputType);
			infoGetter.addChild(inputE1Type);
			
			text = new TextField(150, 30,"Position:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE1Pos :LayoutGroup = new LayoutGroup();
			inputE1Pos.layout = layout;
			inputE1Pos.addChild(text);
			inputE1Pos.addChild(this._enemy1InputPos);
			infoGetter.addChild(inputE1Pos);
			
			text = new TextField(150, 30,"Speed:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE1Spd :LayoutGroup = new LayoutGroup();
			inputE1Spd.layout = layout;
			inputE1Spd.addChild(text);
			inputE1Spd.addChild(this._enemy1InputSpeed);
			infoGetter.addChild(inputE1Spd);
			
			text = new TextField(150, 30,"Image:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE1Img :LayoutGroup = new LayoutGroup();
			inputE1Img.layout = layout;
			inputE1Img.addChild(text);
			inputE1Img.addChild(this._enemy1InputImage);
			infoGetter.addChild(inputE1Img);
			
			text = new TextField(150, 30,"Enemy 2:", "Verdana", 24, 0x304bbd, true);
			text.hAlign = starling.utils.HAlign.LEFT;
			infoGetter.addChild(text);
			
			text = new TextField(150, 30,"Type:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE2Type :LayoutGroup = new LayoutGroup();
			inputE2Type.layout = layout;
			inputE2Type.addChild(text);
			inputE2Type.addChild(this._enemy2InputType);
			infoGetter.addChild(inputE2Type);
			
			text = new TextField(150, 30,"Position:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE2Pos :LayoutGroup = new LayoutGroup();
			inputE2Pos.layout = layout;
			inputE2Pos.addChild(text);
			inputE2Pos.addChild(this._enemy2InputPos);
			infoGetter.addChild(inputE2Pos);
			
			text = new TextField(150, 30,"Speed:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE2Spd :LayoutGroup = new LayoutGroup();
			inputE2Spd.layout = layout;
			inputE2Spd.addChild(text);
			inputE2Spd.addChild(this._enemy2InputSpeed);
			infoGetter.addChild(inputE2Spd);
			
			text = new TextField(150, 30,"Image:", "Verdana", 20, 0xffffff, false);
			text.hAlign = starling.utils.HAlign.LEFT;
			var inputE2Img :LayoutGroup = new LayoutGroup();
			inputE2Img.layout = layout;
			inputE2Img.addChild(text);
			inputE2Img.addChild(this._enemy2InputImage);
			infoGetter.addChild(inputE2Img);
			
			/* Add Information Box to display */
			infoGetter.x = 10;
			infoGetter.y = 100;
			this.addChild(infoGetter);
			if(PreviewGameInfo._isSaved)
				this.initializeInfo();
			
			/* Add eventlistener for player info input */
			this._playerPosInput.addEventListener(FeathersEventType.ENTER, 		onPlayerPosEnter);
			this._playerPosInput.addEventListener(FeathersEventType.FOCUS_IN, 	onPlayerPosFocus);
			this._playerPosInput.addEventListener(FeathersEventType.FOCUS_OUT, 	onPlayerPosEnter);
			this._genderInput.addEventListener	 (Event.CHANGE, 				onSwitch);
			
			this._enemy1InputType.addEventListener	(Event.CHANGE, 				 onEnemy1TypeChange);
			this._enemy1InputPos.addEventListener	(FeathersEventType.ENTER, 	 onEnemy1PosEnter);
			this._enemy1InputPos.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy1PosFocus);
			this._enemy1InputPos.addEventListener	(FeathersEventType.FOCUS_OUT, onEnemy1PosEnter);
			this._enemy1InputSpeed.addEventListener	(FeathersEventType.ENTER, 	 onEnemy1SpeedEnter);
			this._enemy1InputSpeed.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy1SpeedFocus);
			this._enemy1InputSpeed.addEventListener	(FeathersEventType.FOCUS_OUT, onEnemy1SpeedEnter);
			this._enemy1InputImage.addEventListener (Event.CHANGE,				 onEnemy1ImgChange);
			
			this._enemy2InputType.addEventListener	(Event.CHANGE, 				 onEnemy2TypeChange);
			this._enemy2InputPos.addEventListener	(FeathersEventType.ENTER, 	 onEnemy2PosEnter);
			this._enemy2InputPos.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy2PosFocus);
			this._enemy2InputPos.addEventListener	(FeathersEventType.FOCUS_OUT, onEnemy2PosEnter);
			this._enemy2InputSpeed.addEventListener	(FeathersEventType.ENTER, 	 onEnemy2SpeedEnter);
			this._enemy2InputSpeed.addEventListener	(FeathersEventType.FOCUS_IN, onEnemy2SpeedFocus);
			this._enemy2InputSpeed.addEventListener	(FeathersEventType.FOCUS_OUT, onEnemy2SpeedEnter);
			this._enemy2InputImage.addEventListener (Event.CHANGE,				 onEnemy2ImgChange);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function initializeInfo():void
		{
			this.initializePlayerInfo();
			this.initializeEnemyInfo();
		}
		
		private function initializePlayerInfo():void
		{
			var pos	:uint = PreviewGameInfo._playerPos;
			var gender :String = PreviewGameInfo._playerGender;
			
			if(pos != 0)
				this._playerPosInput.text = pos.toString();
			if(gender == "Male")
				this._genderInput.isSelected = false;
			else(gender == "Female")
				this._genderInput.isSelected = true;
		}
		
		private function initializeEnemyInfo():void
		{
			var type	:Array = PreviewGameInfo._enemyType;
			var pos		:Array = PreviewGameInfo._enemyPos;
			var spd		:Array = PreviewGameInfo._enemySpd;
			var img		:Array = PreviewGameInfo._enemyImg;
						
			if(type[1] == "None")
				this._enemy2InputType.selectedIndex = 2;
			else if(type[1] == "Patrol Enemy")
				this._enemy2InputType.selectedIndex = 1;
			else 
				this._enemy2InputType.selectedIndex = 0;
			
			this._enemy1InputPos.text = pos[0].toString();
			this._enemy2InputPos.text = pos[1].toString();
			this._enemy1InputSpeed.text = spd[0].toString();
			this._enemy2InputSpeed.text = spd[1].toString();
			this._enemy1InputImage.selectedIndex = img[0] - 1;
			this._enemy2InputImage.selectedIndex = img[1] - 1;
			
			if(type[0] == "None")
				this._enemy1InputType.selectedIndex = 2;
			else if(type[0] == "Patrol Enemy")
				this._enemy1InputType.selectedIndex = 1;
			else 
				this._enemy1InputType.selectedIndex = 0;
		}
		
		/**====================================================================
		 * |	               	ENEMY EVENT HANDLERS			              | *
		 * ====================================================================**/
		private function onEnemy2TypeChange(event:Event):void
		{
			if(this._enemy2InputType.selectedIndex == 1 || this._enemy2InputPos.text == "0")
			{
				if(this._enemy2InputPos.text == "")
					posFillInNotify(2);
				else
					enemyPatrolNotify(2);
			}
			else
			{
				if(this._hasPatrol[1])
				{
					this._alert = Alert.show("You changed the enemy type.\n Continue will delete your previous process.", "Notification", new ListCollection(
						[
							{ label: "Yes" , triggered: function(e:Event):void{onChangeEnemyType(2)}},
							{ label: "No" , triggered: function(e:Event):void{onKeepEnemyType(2)}},
							
						]));
					this.dispatchEventWith('gotPopUp', true);
				}
				
				if(this._enemy2InputType.selectedIndex == 2)
					this.dispatchEventWith('deleteEnemy', true, {id:2});
			}
		}
		
		private function onEnemy1TypeChange(event:Event):void
		{
			if(this._enemy1InputType.selectedIndex == 1)
			{
				if(this._enemy1InputPos.text == "" || this._enemy1InputPos.text == "0")
					posFillInNotify(1);
				else
					enemyPatrolNotify(1);
			}
			else
			{
				if(this._hasPatrol[0])
				{
					this._alert = Alert.show("You changed the enemy type.\n Continue will delete your previous process.", "Notification", new ListCollection(
						[
							{ label: "Yes" , triggered: function(e:Event):void{onChangeEnemyType(1)}},
							{ label: "No" , triggered: function(e:Event):void{onKeepEnemyType(1)}},
							
						]));
					this.dispatchEventWith('gotPopUp', true);
				}
				
				if(this._enemy1InputType.selectedIndex == 2)
					this.dispatchEventWith('deleteEnemy', true, {id:1});
			}
		}
						
		private function onChangeEnemyType(id:Number):void{
			this._hasPatrol[id-1] = false;			
			this.dispatchEventWith("removeEndPts", true, {enemy:id});	
		}
		
		private function onKeepEnemyType(id:Number):void{

			if(id==1)
			{
				this._enemy1InputType.removeEventListener(Event.CHANGE, onEnemy1TypeChange);
				this._enemy1InputType.selectedIndex = 1;
				this._enemy1InputType.addEventListener(Event.CHANGE, onEnemy1TypeChange);
			}
			else if(id==2)
			{
				this._enemy2InputType.removeEventListener(Event.CHANGE, onEnemy2TypeChange);
				this._enemy2InputType.selectedIndex = 1;
				this._enemy2InputType.addEventListener(Event.CHANGE, onEnemy2TypeChange);
			}
			this.dispatchEventWith('popUpClose', true);
		}
		
		private function posFillInNotify(id:Number):void
		{
			this._alert = Alert.show("Please give your Patrol Enemy a start position.", "Notification", new ListCollection(
				[
					{ label: "OK" }
				]));
			this.dispatchEventWith('gotPopUp', true);
			this._alert.addEventListener(Event.CLOSE, function(e:Event):void{
				enableInput();
				if(id == 1)
				{
					_enemy1InputPos.setFocus();
				}
				else if(id == 2)
					_enemy2InputPos.setFocus();
			});
		}
		
		private function enemyPatrolNotify(id:Number):void
		{
			_endPtChoosePanel = new Panel();
			var panelLayout:VerticalLayout = new VerticalLayout();
			_endPtChoosePanel.height = 400;
			_endPtChoosePanel.width = 600;

			panelLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			panelLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			panelLayout.gap = 75;
			_endPtChoosePanel.layout = panelLayout;
			
			var notifyMsg	:TextField = new TextField(500, 100, "You chose enemy as Patrol type.\nThe enemy will start at the indicated position. It can patrol in 'Reverse' or 'Circle' mode. Please indicate your choice below.", "Grobold", 18, 0xfa0000, false);
			_endPtChoosePanel.addChild(notifyMsg);
			
			var typeChoice	:ToggleGroup = new ToggleGroup(); 
			var layout 		:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.gap = 20;
			
			var radioContainer:ScrollContainer = new ScrollContainer();
			radioContainer.layout = layout;
			radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			var choices1:Radio = new Radio();
			choices1.label = "Reverse";
			typeChoice.addItem(choices1);
			radioContainer.addChild(choices1);
			
			var choices2:Radio = new Radio();
			choices2.label = "Circle";
			typeChoice.addItem(choices2);
			radioContainer.addChild(choices2);
						
			radioContainer.y = 220;
			_endPtChoosePanel.addChild(radioContainer);
			
			var closeButton	:Button = new Button();
			closeButton.label = "Ok";
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void{
				EnemyPatrolEndPos(id, typeChoice);
			});
			closeButton.y = 300;
			_endPtChoosePanel.addChild(closeButton);
			
			PopUpManager.addPopUp( _endPtChoosePanel);
		}
		
		private function EnemyPatrolEndPos(id:Number, type:ToggleGroup):void
		{
			var optionType	:String;
			if(type.selectedIndex == 0)
				optionType = "Reverse";
			else
				optionType = "Circle";
			
			_endPtChoosePanel.removeChildren();
			
			var notifyMsg	:TextField = new TextField(500, 100, "Click on the highlighted tiles to choose end points.\n They must be in the same row or column as the start position.", "Grobold", 20, 0xfa0000, false);
			_endPtChoosePanel.addChild(notifyMsg);
			var closeButton	:Button = new Button();
			closeButton.label = "Ok";
			closeButton.addEventListener(Event.TRIGGERED, function(e:Event):void{
				onStartChoosingEndPts(id, optionType);
			});
			closeButton.y = 300;
			_endPtChoosePanel.addChild(closeButton);
		}
		
		private function onStartChoosingEndPts(id:Number, type:String):void
		{
			PopUpManager.removePopUp(_endPtChoosePanel);
			this.disableInput();
			if(id == 1)
			{
				this._hasPatrol[0] = true;
				this.dispatchEventWith('startChoosingEndPt', true, {id:"enemy1", option:type, pos:Number(this._enemy1InputPos.text)});
			}
			else if(id == 2)
			{
				this._hasPatrol[1] = true;
				this.dispatchEventWith('startChoosingEndPt', true, {id:"enemy2", option:type, pos:Number(this._enemy2InputPos.text)});
			}
		}
		
		private function onEnemy2SpeedFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY2_SPD_GUIDE;
			_callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy2InputSpeed), Callout.DIRECTION_UP);
			_callout.closeOnTouchBeganOutside = true;
			_callout.closeOnTouchEndedOutside = true;
		}
		
		private function onEnemy2SpeedEnter(event:Event):void
		{
			if(Number(this._enemy2InputSpeed.text) > 9 || Number(this._enemy2InputSpeed.text) < 1)
			{
				this._alert = Alert.show("Enemy's speed should be from 1 to 9", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy2InputSpeed.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else
			{
				this._enemy2InputSpeed.clearFocus();
				_callout.close();
			}
		}
		
		private function onEnemy2PosFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY2_POS_GUIDE;
			_callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy2InputPos), Callout.DIRECTION_UP);
			_callout.closeOnTouchBeganOutside = true;
			_callout.closeOnTouchEndedOutside = true;
		}
		
		private function onEnemy2PosEnter(event:Event):void
		{
			if(Number(this._enemy2InputPos.text) == 0)
			{
				this._alert = Alert.show("Enemy No.2's position can only be from 1 to 99.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy2InputPos.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else if(Number(this._playerPosInput.text) == Number(this._enemy2InputPos.text) || Number(this._enemy1InputPos.text) == Number(this._enemy2InputPos.text))
			{
				this._alert = Alert.show("Position occupied.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy2InputPos.text = "";	
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else
			{
				if(this._enemy2InputType.selectedIndex == 1)
					enemyPatrolNotify(2);	
				this._enemy2InputPos.clearFocus();
				_callout.close();
				this.dispatchEventWith('displayCharacters', true, {id:"enemy2", textureIndex:this._enemy2InputImage.selectedIndex +1, pos:Number(this._enemy2InputPos.text)});
			}
		}
		
		private function onEnemy2ImgChange(event:Event):void
		{
			if(Number(this._enemy2InputPos.text) != 0)
				this.dispatchEventWith('displayCharacters', true, {id:"enemy2", textureIndex:this._enemy2InputImage.selectedIndex +1, pos:Number(this._enemy2InputPos.text)});
		}
		
		private function onEnemy1SpeedFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY1_SPD_GUIDE;
			_callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy1InputSpeed), Callout.DIRECTION_UP);
			_callout.closeOnTouchBeganOutside = true;
			_callout.closeOnTouchEndedOutside = true;
		}
		
		private function onEnemy1SpeedEnter(event:Event):void
		{
			if(Number(this._enemy1InputSpeed.text) > 9 || Number(this._enemy1InputSpeed.text) < 1)
			{
				this._alert = Alert.show("Enemy's speed should be from 1 to 9", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy1InputSpeed.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else
			{
				this._enemy1InputSpeed.clearFocus();
				_callout.close();
			}
		}
		
		private function onEnemy1PosFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY1_POS_GUIDE;
			_callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy1InputPos), Callout.DIRECTION_UP);
			_callout.closeOnTouchBeganOutside = true;
			_callout.closeOnTouchEndedOutside = true;
		}
		
		private function onEnemy1PosEnter(event:Event):void
		{
			if(Number(this._enemy1InputPos.text) == 0)
			{
				this._alert = Alert.show("Enemy No.1's position can only be from 1 to 99.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy1InputPos.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else if(Number(this._playerPosInput.text) == Number(this._enemy1InputPos.text) || Number(this._enemy1InputPos.text) == Number(this._enemy2InputPos.text))
			{
				this._alert = Alert.show("Position occupied.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy1InputPos.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else
			{
				if(this._enemy1InputType.selectedIndex == 1)
					enemyPatrolNotify(1);	
				this._enemy1InputPos.clearFocus();
				_callout.close();
				this.dispatchEventWith('displayCharacters', true, {id:"enemy1", textureIndex:this._enemy1InputImage.selectedIndex +1, pos:Number(this._enemy1InputPos.text)});
			}
		}
		
		private function onEnemy1ImgChange(event:Event):void
		{
			if(Number(this._enemy1InputPos.text) != 0)
				this.dispatchEventWith('displayCharacters', true, {id:"enemy1", textureIndex:this._enemy1InputImage.selectedIndex +1, pos:Number(this._enemy1InputPos.text)});
		}
		
		/**====================================================================
		 * |	               	PLAYER EVENT HANDLERS			              | *
		 * ====================================================================**/
		private function onPlayerPosFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = PLAYER_POS_GUIDE;
			_callout = Callout.show(DisplayObject(this._message), DisplayObject(this._playerPosInput), Callout.DIRECTION_UP);
			_callout.closeOnTouchBeganOutside = true;
			_callout.closeOnTouchEndedOutside = true;
		}
		
		private function onPlayerPosEnter(event:Event):void
		{
			if(Number(this._playerPosInput.text) == 0)
			{
				this._alert = Alert.show("Player's position can only be from 1 to 99.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._playerPosInput.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else if(Number(this._playerPosInput.text) == Number(this._enemy1InputPos.text) || Number(this._playerPosInput.text) == Number(this._enemy2InputPos.text))
			{
				this._alert = Alert.show("Position occupied.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));
				this._playerPosInput.text = "";
				this.dispatchEventWith('gotPopUp', true);
				this._alert.addEventListener(Event.CLOSE, onAlertClosed);
			}
			else
			{
				this._playerPosInput.clearFocus();
				_callout.close();
				this.dispatchEventWith('displayCharacters', true, {id:"player", gender:this._genderInput.isSelected, pos:Number(this._playerPosInput.text)});
			}
		}

		private function onSwitch(event:Event):void
		{
			if(Number(this._playerPosInput.text) !=0)
				this.dispatchEventWith('displayCharacters', true, {id:"player", gender:this._genderInput.isSelected, pos:Number(this._playerPosInput.text)});
		}
		
		private function onGotPopUp(event:Event):void{
			this.disableInput();
		}
		
		private function onClosedPopUp(event:Event):void{
			this.enableInput();
		}
	}
}