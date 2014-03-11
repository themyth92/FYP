/*****************************************************
 * ================================================= *
 *                   ARROW OBJECT                    *
 * ================================================= * 
 *****************************************************/

package object.inGameObject
{
	import assets.Assets;
	
	import constant.ChapterOneConstant;
	
	import flashx.textLayout.formats.Float;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class InstrArrow extends Sprite
	{
		private var _arrowLeft 	: Image;
		private var _arrowRight	: Image;
		private var _leftPosX  	: int;
		private var _leftPosY  	: int;
		private var _rightPosX 	: int;
		private var _rightPosY 	: int;
		private var _heightLeft	: int;
		private var _widthLeft		: int;
		private var _heightRight	: int;
		private var _widthRight	: int;

		public function InstrArrow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		public function toggleDisplayInstrArrow(e:Boolean = true, isBoth:Boolean = false, arrowNum:uint = 0):void{
			
			if(e){
				
				if(isBoth){
					this._arrowLeft.visible  = true;
					this._arrowRight.visible = false;
				}
				else{
					if(arrowNum == 0){
						this._arrowLeft.visible  = true;
						this._arrowRight.visible = false;
					}
					else{
						this._arrowLeft.visible  = false;
						this._arrowRight.visible = true;
					}
				}
			}
			else{
				
				if(isBoth){
					this._arrowLeft.visible  = false;
					this._arrowRight.visible = false;
				}
				else{
					if(arrowNum == 0)
						this._arrowLeft.visible = false;
					else
						this._arrowRight.visible = false;
				}
			}	
		}
		
		public function setLeftArrow(posX:int, posY:int, width:int, height:int):void{
			
			this._leftPosX  	= posX;
			this._leftPosY  	= posY;
			this._widthLeft 	= width;
			this._heightLeft 	= height;
		}
		
		public function setRightArrow(posX:int, posY:int, width:int, height:int):void{
			
			this._rightPosX  	= posX;
			this._rightPosY  	= posY;
			this._widthRight 	= width;
			this._heightRight 	= height;
		}
		
		private function onAddedToStage(e:Event):void{
			
			_arrowLeft  = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.INSTRUC_ARROW_LEFT));
			_arrowRight = new Image(Assets.getAtlas(ChapterOneConstant.SPRITE_ONE).getTexture(ChapterOneConstant.INSTRUC_ARROW_RIGHT));
			
			_leftPosX    = 0;
			_leftPosY    = 0;
			_rightPosX   = 0;
			_rightPosY   = 0;
			
			_heightLeft	 = 0;
			_widthLeft	 = 0;
			_heightRight = 0;
			_widthRight  = 0;
			
			this.addChild(_arrowLeft);
			this.addChild(_arrowRight);
			this.toggleDisplayInstrArrow(false, true);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onEnterFrame(e:Event):void{
			
			var currentDate:Date = new Date();
			_arrowLeft.x 	= _leftPosX  + Math.cos(currentDate.getTime()*0.004)*_widthLeft;
			_arrowLeft.y	= _leftPosY  + Math.cos(currentDate.getTime()*0.004)*_heightLeft;
			_arrowRight.x   = _rightPosX + Math.cos(currentDate.getTime()*0.004)*_widthRight;
			_arrowRight.y   = _rightPosY + Math.cos(currentDate.getTime()*0.004)*_heightRight;
		}
		
		private function onRemoveFromStage(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);	
		}
	}
}