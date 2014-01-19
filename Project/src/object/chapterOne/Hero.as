/*****************************************************
 * ================================================= *
 *                    HERO OBJECT                    *
 * ================================================= * 
 *****************************************************/

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
		
		//STATES VARIABLE
		private var _state					 :String = Constant.INSTRUCTING_STATE;
		
		//GAME STAT VARIABLE
		private var _maxLife				:Number;
		private var _currentLife			:Number;
		private var _coinCollected			:Number = 0;
		private var _counter   				:int = 60;
		private var _isHit:Boolean;
		
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
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			heroAddToStage();
			enableHero();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			this._heroEnable = false;
			this.removeEventListener(Event.ADDED_TO_STAGE, onRemoveFromStage);
		}
		
		public function get heroEnable():Boolean
		{
			return _heroEnable;
		}

		public function set heroEnable(value:Boolean):void
		{
			_heroEnable = value;
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
				for(var i:uint = 0 ; i < _heroStand.length ; i++)
				{
					_heroStand[i].visible = false;	
					_heroRun[i].visible   = false;
				}	
				return;
			}
			
			if(status == 0)
			{
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
		
		public function enableHero():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function retrieveHeroPosition():Array{
			
			var arr:Array = new Array(this.x, this.y);
			return arr;
		}
		
		private function heroAddToStage():void{
			
			var image:Image;
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
			this.showHero(2, 0);
			this._heroEnable = true;
		}
		
		private function onEnterFrame(e:Event):void{
			if(_state == Constant.PLAYING_STATE)
			{
				this._hero.x += _speedX;
				this._hero.y += _speedY;
				
				var heroPos : Array = _controller.notifyForCollisionChecking(_hero.x, _hero.y);
				
				if(heroPos.length == 1)
				{
					//trace("do nothing");
				}
				else if(heroPos.length  == 2)
				{
					_controller.notifyCollectCoin(heroPos[1]);
				}
				else if (heroPos.length == 3)
				{
					this._hero.x = heroPos[1];
					this._hero.y = heroPos[2];
				}
			}
			
			if(_isHit)
				_counter++;
		}
		
		private function onKeyDown(e:KeyboardEvent):void{
			if(_state == Constant.PLAYING_STATE)
			{
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
		}
		
		private function onKeyUp(e:KeyboardEvent):void{
			if(_state == Constant.PLAYING_STATE)
			{
				_speedX = 0;
				_speedY = 0;
				_controller.notifyObserver({event:Constant.KEY_UP, arg:_heroStatus, target:Constant.HERO});
			}
		}
	
		public function changeState(currentState:String):void
		{
			_state = currentState;
		}
		
		public function changeLife(isHit:Boolean, isBonus:Boolean):void
		{
			if(isHit)
			{
				_isHit = true;
				if(_currentLife > 0)
					if(_counter >= 60)
					{
						_currentLife --;
						_counter    = 0;
						_isHit = false;
					}
			}
			if(isBonus)
				if(_currentLife < _maxLife)
					_currentLife ++;
			
			_controller.getGameStat("life",_currentLife);
		}
		
		public function changeCoin():void
		{
			_coinCollected ++;
			_controller.getGameStat("coin", _coinCollected);
		}
		
		public function updateMaxLife(value:Number):void
		{
			_maxLife = value;
			_currentLife = _maxLife;
		}
	}
}