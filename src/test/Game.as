package test
{
import flash.display.BitmapData;
import flash.display.Shape;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
    import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

import test.PageFlip.PageFlipContainer;
	import test.PageFlip.ShadowUtil;


	public class Game extends Sprite
	{

        [Embed(source="../assets/btn.png")]
        public static const Btn:Class;

        [Embed(source="../assets/fairy0.jpg")]
        public static const fairy0:Class;
        [Embed(source="../assets/fairy1.jpg")]
        public static const fairy1:Class;
        [Embed(source="../assets/fairy2.jpg")]
        public static const fairy2:Class;
        [Embed(source="../assets/fairy3.jpg")]
        public static const fairy3:Class;
		private var pageFlipContainer:PageFlipContainer;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,initGame);
		}
		
		private function initGame(event:Event):void
		{

            var textures:Vector.<DisplayObject>;
            textures = new Vector.<DisplayObject>();


            var spr:Sprite = new Sprite();
            spr.addChild(new Image(Texture.fromBitmap(new fairy0())));


            var shape:Shape;
            shape = new Shape();
            shape.graphics.beginFill(Math.random()*0xFFFFFF);
            var radius:Number = 50;
            shape.graphics.drawCircle(radius+2,radius+2,radius);
            shape.graphics.endFill();

            var canvas:BitmapData = new BitmapData(shape.width+4,shape.height+4,true,0xFF0000);
            shape.x = 2;
            shape.y= 2;
            canvas.draw(shape);
            var texture:Texture = Texture.fromBitmapData(canvas);
            var image:Image = new Image(texture);
            spr.addChild(image);

            textures.push(spr);
            textures.push(new Image(Texture.fromBitmap(new fairy1(),false)));
            textures.push(new Image(Texture.fromBitmap(new fairy2(),false)));
            textures.push(new Image(Texture.fromBitmap(new fairy3(),false)));
//			ShadowUtil.addShadow(bookImgs,xml);//TODO: Add shadows on each img later..

            //add imgs somehow
			pageFlipContainer = new PageFlipContainer(textures,stage.stageWidth-100,stage.stageHeight-100);
			pageFlipContainer.x = pageFlipContainer.y = 50;
			addChild(pageFlipContainer);


            var btn:Button = new Button(Texture.fromBitmap(new Btn(),false));
            btn.x = 100;
            btn.y = 600;
            addChild(btn);
            btn.addEventListener(TouchEvent.TOUCH, onBtnClickPrev);
            var btn2:Button = new Button(Texture.fromBitmap(new Btn(),false));
            btn2.x = 200;
            btn2.y = 600;
            addChild(btn2);
            btn2.addEventListener(TouchEvent.TOUCH, onBtnClickNext);
		}

        private function onBtnClickNext(event:TouchEvent):void {
            var touch:Touch = event.getTouch(event.target as DisplayObject);
            if(touch != null && touch.phase == TouchPhase.ENDED)
            {
                pageFlipContainer.turnToNextPage();
            }
        }
        private function onBtnClickPrev(event:TouchEvent):void {
            var touch:Touch = event.getTouch(event.target as DisplayObject);
            if(touch != null && touch.phase == TouchPhase.ENDED)
            {
                pageFlipContainer.turnToPreviousPage();
            }
        }
	}
}