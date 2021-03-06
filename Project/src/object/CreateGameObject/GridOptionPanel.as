package object.CreateGameObject
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;

	public class GridOptionPanel extends Screen
	{
		
		private var _list			:PickerList;
		private var _deleteBtn 		:Button;
		private var _obstacleType	:Number;
		private var _questionList	:Vector.<Object>;
		private var _closeBtn		:Button;
		private var _propBtn		:Button; 
		
		public function GridOptionPanel(questionList : Vector.<Object>)
		{
			super();
			this._questionList = questionList;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get obstacleType():Number
		{
			return _obstacleType;
		}

		public function set obstacleType(value:Number):void
		{
			_obstacleType = value;
		}
		
		//change state of option depends on the type of object
		public function changeStateGrid(type : Number, xPos:Number, yPos:Number, selectedIndex : Number):void{
					
			//if the type is obstacle or goal
			if(type == 2 || type == 5){
				if(xPos > 280)
					this.x					= xPos - 180;
				else
					this.x					= xPos
				this.y 						= yPos;
				this._list.visible 			= false;
				this._deleteBtn.visible 	= true;
				this._deleteBtn.y			= 47;
				this._closeBtn.y			= 94;
				this._closeBtn.visible		= true;
				this._propBtn.y				= 0;
				this._propBtn.visible		= true;
				return;
			}
			else
				//if object is prize, 
				//we allow them to put in the question
				if(type == 1)
				{
					if(xPos > 280)
						this.x					= xPos - 180;
					else
						this.x					= xPos
					this.y						= yPos;
					this._list.visible 			= true;
					this._deleteBtn.visible 	= true;
					this._closeBtn.visible		= true;
					this._deleteBtn.y			= 48;
					this._closeBtn.y 			= 95;
					this._list.selectedIndex	= selectedIndex;
					return;
				}
				else{
					this._list.visible 			= false;
					this._deleteBtn.visible		= false;
					this._closeBtn.visible		= false;
					this._propBtn.visible		= false;
					return;
				}
		}

		private function onAddedToStage(event:Event):void{
			
			var items:Array = [];
			
			//put in all the question of user here
			items.push("None");
			for (var i:uint = 0 ; i < this._questionList.length ; i++){
				var item:Object = {text: this._questionList[i].title};
				items.push(item);	
			}
			
			items.fixed = true;
			
			this._list 					= new PickerList();
			this._list.height			= 50;
			this._list.width			= 140;
			this._list.prompt 			= 'Questions';
			this._list.useHandCursor   	= true; 
			
			this._list.dataProvider 	= new ListCollection(items);
			this._list.selectedIndex 	= 0;
			
			this._list.typicalItem 			= { text: "Delete" };
			this._list.labelField 			= "text";
			
			this._list.listFactory = function():List
			{
				var list:List = new List();
				
				list.typicalItem = { text: "Question" };
				list.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.labelField = "text";
					return renderer;
				};
				return list;
			};
			
			//delete button
			this._deleteBtn			= new Button();
			this._deleteBtn.label	= 'Delete';
			this._deleteBtn.y		= 48;
			this._deleteBtn.width  	= 140;
			this._deleteBtn.height	= 50;
			this._deleteBtn.useHandCursor = true;
			
			//close button
			this._closeBtn       	= new Button();
			this._closeBtn.label 	= 'Close';
			this._closeBtn.y 		= 152;
			this._closeBtn.width	= 140; 
			this._closeBtn.height	= 50;
			this._closeBtn.useHandCursor = true;
			
			//Properties button
			this._propBtn       	= new Button();
			this._propBtn.label 	= 'Properties';
			this._propBtn.y 		= 95;
			this._propBtn.width		= 140; 
			this._propBtn.height	= 50;
			this._propBtn.useHandCursor = true;
			
			this._list.visible		= false;
			this._deleteBtn.visible	= false;
			this._closeBtn.visible 	= false;
			this._propBtn.visible	= false;
			
			this.addChild(this._list);
			this.addChild(this._deleteBtn);
			this.addChild(this._closeBtn);
			this.addChild(this._propBtn);
			
			this._deleteBtn.addEventListener(Event.TRIGGERED, onDeleteBtnTrigger);
			this._closeBtn.addEventListener(Event.TRIGGERED, onCloseBtnTrigger);
			this._list.addEventListener(Event.CHANGE, onListChange);
			this._propBtn.addEventListener(Event.TRIGGERED, onPropBtnTrigger);
		}
		
		private function onDeleteBtnTrigger(event:Event):void
		{
			//change to normal state
			this.changeStateGrid(0, this.x, this.y, -1);
			//and delete the object
			this.dispatchEventWith('GridOptionDeleteBtnClicked' , true);		
		}
		
		private function onCloseBtnTrigger(event:Event):void
		{
			//change to normal state
			//which still in the same postion of the panel
			this.changeStateGrid(0, this.x, this.y, -1);
			this.dispatchEventWith('GridOptionCloseBtnClicked', true);	
		}
		
		private function onPropBtnTrigger(event:Event):void
		{
			//change the properties of the obstacles
			this.dispatchEventWith('GridOptionPropBtnClicked', true);	
		}
		
		private function onListChange(event:Event):void
		{	
			//dispatch the change to gridpanel
			this.dispatchEventWith('GridOptionChangeBtnClicked' , true, {index : this._list.selectedIndex});
		}
	}
}