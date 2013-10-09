package object.chapterOne
{
	import assets.Assets;
	
	import constant.chapterOne.Constant;
	
	import controller.chapterOne.Controller;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Hero extends Sprite
	{
		private var _controller:Controller;
		private var _heroStand :Array;
		private var _heroRun   :Array;
		
		public function Hero(controller:Controller)
		{	
			this._controller = controller;
			this._heroStand  = new Array();
			this._heroRun    = new Array();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function moveHero(index:uint):void{
			
		}
		
		public function showHero(index:uint, status:uint = 0):void{
			
			if(index >= _heroStand.length){
				trace('Function: ShowHero, Error: Out of bound');
				return ;
			}
			
			if(status == 0){
				for(var i:uint = 0 ; i < _heroStand.length ; i++){
					
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
		
		private function onAddedToStage(e:Event):void{
			
			heroAddToStage();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
				this.addChild(_heroStand[index]);
				
				Starling.juggler.add(_heroRun[index]);
				this.addChild(_heroRun[index]);
			}
			
			this.showHero(3, 0);
		}
		
		private function onEnterFrame(e:Event):void{
			
		}
	}
}