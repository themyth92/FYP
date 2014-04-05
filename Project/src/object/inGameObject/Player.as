/*****************************************************
 * ================================================= *
 *                    HERO OBJECT                    *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	//import library
	import assets.Assets;
	
	import constant.Constant;
	
	import controller.ObjectController.MainController;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Player extends Sprite
	{	
		private var _controller  	:MainController;
		private var _normalStand    :Array;
		private var _normalRun      :Array;
		private var _hitStand	 	:Array;
		private var _hitRun		 	:Array;
		private var _moveX       	:int;
		private var _moveY       	:int;
		private var _playerStatus   :String;
		private var _player         :Sprite;
		private var _gender		 	:String;
		
		public function Player(controller:MainController)
		{	
			this._controller  	= controller;
			this._normalStand   = new Array();
			this._normalRun     = new Array();
			this._hitStand   	= new Array();
			this._hitRun     	= new Array();
			this._moveX      	= 0;
			this._moveY      	= 0;
			this._playerStatus  = null;
			this._player        = new Sprite();  
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function set moveY(value:int):void{
			this._moveY = value;
		}

		public function set moveX(value:int):void{
			this._moveX = value;
		}
		
		public function get moveY():int{
			return this._moveY;
		}
		
		public function get moveX():int{
			return this._moveX;
		}
		public function set playerStatus(value:String):void{
			this._playerStatus = value;
		}
		
		public function get playerStatus():String{
			return this._playerStatus;
		}
		
		public function set gender(value:String):void{
			this._gender = value;
		}
		
		public function showHero(index:int, status:uint = 0):void{
			if(index >= _normalStand.length){
				trace('Function: ShowHero, Error: Out of bound');
				return ;
			}
			
			if(index < 0){
				//do not show anything
				for(var i:uint = 0 ; i < _normalStand.length ; i++)
				{
					_normalStand[i].visible = false;	
					_normalRun[i].visible   = false;
				}	
				return;
			}
			
			if(status == 0)
			{
				for(i = 0 ; i < _normalStand.length ; i++){
					if(i==index && _normalStand[i] != null){
						_normalStand[i].visible = true;
					}
					else{
						_normalStand[i].visible = false;	
					}
					_normalRun[i].visible = false;
				}			
			}
			else{
				for(i = 0 ; i < _normalRun.length ; i++){
					if(i == index && _normalRun[i] != null){
						_normalRun[i].visible = true;
					}		
					else{
						_normalRun[i].visible = false;
					}
					_normalStand[i].visible = false;
				}
			}
		}
		
		private function heroAddToStage():void{
			var image:Image;
			var movie:MovieClip;
			
			for(var index:uint = 0 ; index < Constant.HERO_MALE_STAND.length ; index++)
			{
				if(this._gender == "Male")
				{
					image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture(Constant.HERO_MALE_STAND[index]));
					movie = new MovieClip(Assets.getAtlas(Constant.PLAYER_SPRITE).getTextures(Constant.HERO_MALE_RUN[index]));
				}else
				{
					image = new Image(Assets.getAtlas(Constant.PLAYER_SPRITE).getTexture(Constant.HERO_FEMALE_STAND[index]));
					movie = new MovieClip(Assets.getAtlas(Constant.PLAYER_SPRITE).getTextures(Constant.HERO_FEMALE_RUN[index]));
				}
				_normalStand.push(image);
				_normalRun.push(movie);
			}
			
			for(index = 0; index < _normalStand.length; index++)
			{
				this._player.addChild(_normalStand[index]);
				Starling.juggler.add(_normalRun[index]);
				this._player.addChild(_normalRun[index]);
			}
			this.addChild(_player);
			this.showHero(2, 0);
		}
		
		private function onAddedToStage(e:Event):void
		{
			heroAddToStage();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}		
	}
}