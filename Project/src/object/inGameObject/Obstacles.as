package object.inGameObject
{
	import assets.Assets;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Obstacles extends Sprite
	{		
		private var _type		:String;
		private var _image		:Image;
		private var _gotQns		:Boolean;
		private var _qnsIndex	:Number;
		private var _pos		:Point;
		
		public function Obstacles(type:String, pos:Point, img:Image, gotQns:Boolean = false, qnsIndex:Number = -1){
			super();
			
			this._type 		= type;
			this._pos 		= pos;
			this._image 	= img;
			this._gotQns 	= gotQns;
			this._qnsIndex 	= qnsIndex;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		public function get type():String{
			return _type;
		}
		
		public function get qnsIndex():Number{
			return this._qnsIndex;
		}
		
		public function get gotQns():Boolean{
			return this._gotQns;
		}
		
		public function get pos():Point{
			return this._pos;
		}
		
		public function get img():Image{
			return this._image;
		}
		
		private function onAddedToStage(event:Event):void{
			this.addChild(this._image);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onRemoveFromStage(event:Event):void{
			this.removeChild(this._image);
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	}
}