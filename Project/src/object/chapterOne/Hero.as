package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.Controller;
	
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class Hero extends Sprite
	{		
		private var _controller  :Controller;
		private var _heroStand   :Array;
		private var _heroRun     :Array;
		private var _speedX      :int;
		private var _speedY      :int;
		private var _heroStatus  :String;
		private var _heroEnable  :Boolean;
		private var _hero        :Sprite;
		
		public function Hero(controller:Controller)
		{	
			this._controller  = controller;
			this._heroStand   = new Array();
			this._heroRun     = new Array();
			this._speedX      = 0;
			this._speedY      = 0;
			this._heroStatus  = null;
			this._heroEnable  = false;
			this._hero        = new Sprite();  
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function set speedY(value:int):void
		{
			_speedY = value;
		}

		public function set speedX(value:int):void
		{
			_speedX = value;
		}
		
		public function set heroStatus(value:String):void
		{
			_heroStatus = value;	
		}
		
		public function showHero(index:int, status:uint = 0):void{
			
			if(index >= _heroStand.length){
				trace('Function: ShowHero, Error: Out of bound');
				return ;
			}
			
			if(index < 0){
				
				//do not show anything
				for(var i:uint = 0 ; i < _heroStand.length ; i++){
						
					_heroStand[i].visible = false;	
					_heroRun[i].visible   = false;
				}	
				return;
			}
			
			if(status == 0){
				for(i = 0 ; i < _heroStand.length ; i++){
					
					if(i==index && _heroStand[i] != null){
						
						_heroStand[i].visible = true;
					}
						
					else{
						
						_heroStand[i].visible = false;	
					}
						
					_heroRun[i].visible = false;
				}			
			}
			else{
				for(i = 0 ; i < _heroRun.length ; i++){
					
					if(i == index && _heroRun[i] != null){
						
						_heroRun[i].visible = true;
					}		
					else{
						
						_heroRun[i].visible = false;
					}
					
					_heroStand[i].visible = false;
				}
			}
		}
		
		public function enableHero():void{
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function retrieveHeroPosition():Array{
			
			var arr:Array = new Array(this.x, this.y);
			return arr;
		}
		
		private function onAddedToStage(e:Event):void{
			
			heroAddToStage();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function heroAddToStage():void{
			
			var image:Image    ;
			var movie:MovieClip;
			
			for(var index:uint = 0 ; index < Constant.HERO_MALE_STAND.length ; index++){
				
				image = new Image(Assets.getAtlas(Constant.SPRITE_ONE).getTexture(Constant.HERO_MALE_STAND[index]));
				movie = new MovieClip(Assets.getAtlas(Constant.SPRITE_ONE).getTextures(Constant.HERO_MALE_RUN[index]));
				_heroStand.push(image);
				_heroRun.push(movie);
			}
			
			for(index = 0; index < _heroStand.length; index++){
				this._hero.addChild(_heroStand[index]);
				
				Starling.juggler.add(_heroRun[index]);
				this._hero.addChild(_heroRun[index]);
			}
			this.addChild(_hero);
			this.showHero(-1, 0);
		}
		
		private function onEnterFrame(e:Event):void{
			this._hero.x += _speedX;
			this._hero.y += _speedY;
		}
		
		private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.LEFT){
				_controller.notifyObserver({event:Constant.KEY_PRESSED, arg:Constant.KEY_LEFT, target:Constant.HERO});
			}
			else if(e.keyCode == Keyboard.RIGHT){
				_controller.notifyObserver({event:Constant.KEY_PRESSED, arg:Constant.KEY_RIGHT, target:Constant.HERO});
			}
			else if(e.keyCode == Keyboard.UP){
				_controller.notifyObserver({event:Constant.KEY_PRESSED, arg:Constant.KEY_UP, target:Constant.HERO});
			}
			else if(e.keyCode == Keyboard.DOWN){
				_controller.notifyObserver({event:Constant.KEY_PRESSED, arg:Constant.KEY_DOWN, target:Constant.HERO});
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void{
			_speedX = 0;
			_speedY = 0;
			_controller.notifyObserver({event:Constant.KEY_UP, arg:_heroStatus, target:Constant.HERO});
		}
	}
}