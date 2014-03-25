package object.CreateGameObject
{
	import assets.Assets;
	
	import constant.Constant;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollText;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ComponentPanel extends Sprite
	{
		private static const PLAYER_POS_GUIDE		:String = "Indicates the player position on the screen.\nCan only take in value from 1 to 99.";
		private static const ENEMY1_POS_GUIDE		:String = "Indicates where the enemy No.1 is on the screen if its type is not 'None'.\nCan only take in value from 1 to 99.";
		private static const ENEMY1_SPD_GUIDE		:String = "Indicates how fast enemy No.1 move.\nValue should be around '0.01' to '0.09'.";
		private static const ENEMY2_POS_GUIDE		:String = "Indicates where the enemy No.2 is on the screen if its type is not 'None'.\nCan only take in value from 1 to 99.";
		private static const ENEMY2_SPD_GUIDE		:String = "Indicates how fast enemy No.2 move.\nValue should be around '0.01' to '0.09'.";
		
		private var _titleInput			:TextInput;
		
		//used to notify user when the game is saved
		//or when user has error
		//this is used in game creation part
		private var _notiPanel   		:ScrollText;
		
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
		private var _message:Label;		
		
		public function ComponentPanel()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//return the title of the input
		public function getTitle():String{
			return this._titleInput.text;
		}
		
		public function getPlayerInfo():Array
		{
			var gender		:String;
			var pos			:Number;
			
			if(this._genderInput.isSelected)
				gender = "Male";
			else 
				gender = "Female";
			
			pos = Number(this._playerPosInput.text);
			var playerInfo	:Array	= new Array(gender, pos);
			return playerInfo;
		}
		
		public function getEnemyInfo():Array
		{
			var enemy1		:Array;
			var enemy2		:Array;
			var amount		:Number = 0;
			
			if(_enemy1InputType.selectedIndex != 2)
			{
				amount ++;
				enemy1 = new Array(_enemy1InputType.selectedItem, Number(_enemy1InputPos.text), Number(_enemy1InputSpeed.text), _enemy1InputImage.selectedItem.text);
			}
			
			if(_enemy2InputType.selectedIndex != 2)
			{
				amount ++;
				enemy2 = new Array(_enemy2InputType.selectedItem, Number(_enemy2InputPos.text), Number(_enemy2InputSpeed.text), _enemy2InputImage.selectedItem.text);
			}
			
			var enemyInfo	:Array = new Array(amount, enemy1, enemy2);
			return enemyInfo;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this._titleInput = new TextInput();		
			this._titleInput.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontSize = 12;
				return editor;
			}
				
			//change the textinput width and height
			this._titleInput.width = 150;
			this._titleInput.height = 50;
			
			//debugger to notify error to user
			this._notiPanel        	= new ScrollText();
			
			/* Inialize */
			_playerPosInput 	= new TextInput();			
			this._playerPosInput.addEventListener(FeathersEventType.ENTER, onPlayerPosEnter);
			this._playerPosInput.addEventListener(FeathersEventType.FOCUS_IN, onPlayerPosFocus);
			
			_genderInput		= new ToggleSwitch();
			
			_enemy1InputType 	= new PickerList();
			_enemy1InputPos		= new TextInput();
			this._enemy1InputPos.addEventListener(FeathersEventType.ENTER, onEnemy1PosEnter);
			this._enemy1InputPos.addEventListener(FeathersEventType.FOCUS_IN, onEnemy1PosFocus);
			_enemy1InputSpeed	= new TextInput();
			this._enemy1InputSpeed.addEventListener(FeathersEventType.ENTER, onEnemy1SpeedEnter);
			this._enemy1InputSpeed.addEventListener(FeathersEventType.FOCUS_IN, onEnemy1SpeedFocus);
			_enemy1InputImage	= new PickerList();
			
			_enemy2InputType 	= new PickerList();
			_enemy2InputPos		= new TextInput();
			this._enemy2InputPos.addEventListener(FeathersEventType.ENTER, onEnemy2PosEnter);
			this._enemy2InputPos.addEventListener(FeathersEventType.FOCUS_IN, onEnemy2PosFocus);
			_enemy2InputSpeed	= new TextInput();
			this._enemy2InputSpeed.addEventListener(FeathersEventType.ENTER, onEnemy2SpeedEnter);
			this._enemy2InputSpeed.addEventListener(FeathersEventType.FOCUS_IN, onEnemy2SpeedFocus);
			_enemy2InputImage	= new PickerList();
			
			/* Place them on the correct position on the screen */
			this._playerPosInput.x 		= 196;	this._playerPosInput.y 		= 365;
			this._playerPosInput.width 	= 55; 	this._playerPosInput.height = 30;
			this._playerPosInput.textEditorProperties.fontSize = 10;
			this._genderInput.x 		= 70;	this._genderInput.y 		= 370;
			this._genderInput.isSelected = false;
			this._genderInput.offText = "F";
			this._genderInput.onText = "M";
			this._genderInput.width		= 55;	this._genderInput.height	= 30;
			
			var enemyType	:Array = new Array(Constant.FOLLOW_TYPE, Constant.PATROL_TYPE, "None");
			this._enemy1InputType.prompt = "Type";
			this._enemy1InputType.dataProvider = new ListCollection(enemyType);
			this._enemy1InputType.selectedIndex = 2;
			this._enemy2InputType.prompt = "Type";
			this._enemy2InputType.dataProvider = new ListCollection(enemyType);
			this._enemy2InputType.selectedIndex = 2;
			
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
				renderer.iconSourceField = "icon";
				return renderer;
			};
			
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
				renderer.iconSourceField = "icon";
				return renderer;
			};
			this._enemy2InputImage.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			
			this._enemy1InputType.x 	= 70; 	this._enemy1InputType.y 	= 425;
			this._enemy1InputType.width = 40;	this._enemy1InputType.height= 40;
			this._enemy1InputPos.x 		= 196; 	this._enemy1InputPos.y 		= 425;
			this._enemy1InputPos.width = 55;	this._enemy1InputPos.height = 30;
			this._enemy1InputSpeed.x 	= 70; 	this._enemy1InputSpeed.y 	= 467;
			this._enemy1InputSpeed.width = 55;	this._enemy1InputSpeed.height= 30;
			this._enemy1InputImage.x 	= 196; 	this._enemy1InputImage.y	= 455;
			this._enemy1InputImage.width = 40;	this._enemy1InputImage.height= 40;
			
			this._enemy2InputType.x 	= 70; 	this._enemy2InputType.y 	= 517;
			this._enemy2InputType.width = 40;	this._enemy2InputType.height= 40;
			this._enemy2InputPos.x 		= 196; 	this._enemy2InputPos.y 	 	= 517;
			this._enemy2InputPos.width = 55;	this._enemy2InputPos.height= 30;
			this._enemy2InputSpeed.x 	= 70; 	this._enemy2InputSpeed.y 	= 559;
			this._enemy2InputSpeed.width = 55;	this._enemy2InputSpeed.height= 30;
			this._enemy2InputImage.x	= 196; 	this._enemy2InputImage.y 	= 547;
			this._enemy2InputImage.width = 40;	this._enemy2InputImage.height= 40;
			
			/* Restrict user input to numberic or alphabet */
			this._playerPosInput.restrict 	= "0-9";
			
			this._enemy1InputPos.restrict 	= "0-9";
			this._enemy1InputSpeed.restrict = "\\. 0-9";
			
			this._enemy2InputPos.restrict 	= "0-9";
			this._enemy2InputSpeed.restrict = "\\. 0-9";
			
			this._playerPosInput.maxChars 	= 2;
			
			/* Limit number of characters user can input */
			this._enemy1InputPos.maxChars 	= 2;
			this._enemy1InputSpeed.maxChars = 5;
			
			//this._enemy2InputType.maxChars 	= 2;
			this._enemy2InputPos.maxChars 	= 2;
			this._enemy2InputSpeed.maxChars = 5;
			
			/* Add Information Box to display */
			this.addChild(this._titleInput);
			this.addChild(this._playerPosInput);
			this.addChild(this._genderInput);
			this.addChild(this._enemy1InputType);
			this.addChild(this._enemy1InputPos);
			this.addChild(this._enemy1InputSpeed);
			this.addChild(this._enemy1InputImage);
			this.addChild(this._enemy2InputType);
			this.addChild(this._enemy2InputPos);
			this.addChild(this._enemy2InputSpeed);
			this.addChild(this._enemy2InputImage);
		}
		
		private function onEnemy2SpeedFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY2_SPD_GUIDE;
			const callout:Callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy2InputSpeed), Callout.DIRECTION_UP);
			callout.disposeContent = false;
		}
		
		private function onEnemy2SpeedEnter(event:Event):void
		{
			if(Number(this._enemy2InputSpeed.text) > 0.09 || Number(this._enemy2InputSpeed.text) < 0.01)
			{
				Alert.show("Enemy's speed should be from 0.01 to 0.09", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy2InputSpeed.text = "";
			}
			this._enemy2InputSpeed.clearFocus();
		}
		
		private function onEnemy2PosFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY2_POS_GUIDE;
			const callout:Callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy2InputPos), Callout.DIRECTION_UP);
			callout.disposeContent = false;
		}
		
		private function onEnemy2PosEnter(event:Event):void
		{
			if(Number(this._enemy2InputPos.text) == 0)
			{
				Alert.show("Enemy No.2's position can only be from 1 to 99.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy2InputPos.text = "";	
			}			
			this._enemy2InputPos.clearFocus();
		}
		
		private function onEnemy1SpeedFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY1_SPD_GUIDE;
			const callout:Callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy1InputSpeed), Callout.DIRECTION_UP);
			callout.disposeContent = false;	
		}
		
		private function onEnemy1SpeedEnter(event:Event):void
		{
			if(Number(this._enemy1InputSpeed.text) > 0.09 || Number(this._enemy1InputSpeed.text) < 0.01)
			{
				Alert.show("Enemy's speed should be from 0.01 to 0.09", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy1InputSpeed.text = "";
			}
			this._enemy1InputSpeed.clearFocus();
		}
		
		private function onEnemy1PosFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = ENEMY1_POS_GUIDE;
			const callout:Callout = Callout.show(DisplayObject(this._message), DisplayObject(this._enemy1InputPos), Callout.DIRECTION_UP);
			callout.disposeContent = false;	
		}
		
		private function onEnemy1PosEnter(event:Event):void
		{
			if(Number(this._enemy1InputPos.text) == 0)
			{
				Alert.show("Enemy No.1's position can only be from 1 to 99.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._enemy1InputPos.text = "";		
			}
			this._enemy1InputPos.clearFocus();
		}
		
		private function onPlayerPosFocus(event:Event):void
		{
			this._message = new Label();
			this._message.text = PLAYER_POS_GUIDE;
			const callout:Callout = Callout.show(DisplayObject(this._message), DisplayObject(this._playerPosInput), Callout.DIRECTION_UP);
			callout.disposeContent = false;
		}
		
		private function onPlayerPosEnter(event:Event):void
		{
			if(Number(this._playerPosInput.text) == 0)
			{
				Alert.show("Player's position can only be from 1 to 99.", "Error", new ListCollection(
					[
						{ label: "OK" }
					]));				
				this._playerPosInput.text = "";	
			}
			this._playerPosInput.clearFocus();
		}
		
	}
}