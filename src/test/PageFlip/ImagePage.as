package test.PageFlip
{
import flash.geom.Point;

import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

import test.Proportions;


public class ImagePage extends Image
	{


        private var initialImgWidth:Number;
        private var initialImgHeight:Number;

		/**@private*/
		public function ImagePage(texture:Texture)
		{
			super(texture);
            initialImgWidth = super.width;
            initialImgHeight = super.height;
		}



        public function swapTexture(newTexture:Texture):void
        {
            this.texture = newTexture;
            super.width = initialImgWidth;
            super.height = initialImgHeight;
            readjustSize();
        }

		/**
		 * Set the vertex position
		 * @param flipingPageLocation From -1 to 1
		 */		
		public function setLocation(flipingPageLocation:Number):void
		{
			var fpl:Number = flipingPageLocation;//Math.abs(flipingPageLocation);
			var pageOffset:Number = (initialImgHeight/8);
            var top:Number = 0;
            var bottom:Number = initialImgHeight;
            var left:Number = 0;
            var pageXDeviation:Number =  initialImgWidth*fpl;
            var pageYDeviation:Number = pageOffset*(1-fpl);

            /*
             Image and/or Quad are made of 2 triangles
            0 - 1
            | / |
            2 - 3
            */
            mVertexData.setPosition(0,left,top); //left left
            mVertexData.setPosition(2,left,bottom);   //bottom left
            mVertexData.setPosition(1,pageXDeviation,-pageYDeviation);  //left pageXDeviation
            mVertexData.setPosition(3,pageXDeviation,bottom+pageYDeviation);     //bottom pageXDeviation
            onVertexDataChanged();
		}
	}
}