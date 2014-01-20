package test.PageFlip
{
    import starling.display.Image;
	import starling.textures.Texture;



public class ImagePage extends Image
	{


        private var initialWidth:Number;
        private var initialHeight:Number;

		/**@private*/
		public function ImagePage(texture:Texture)
		{
			super(texture);
            initialHeight = super.height;
            initialWidth = super.width;
		}


        override public function set height(value:Number):void
        {
            initialHeight = value;
            super.height = initialHeight;
        }

        override public function set width(value:Number):void
        {
            initialWidth = value;
            super.width = initialWidth;
        }



        public function swapTexture(newTexture:Texture):void//, setUpwards:Boolean = false):void
        {
            this.texture = newTexture;
            readjustSize();
//            if(setUpwards)
//                setLocation(0);
//            else
//                setLocation(1);

            initialHeight = super.height;
            initialWidth = super.width;

        }



		/**
		 * Set the vertex position
		 * @param flipingPageLocation From -1 to 1
		 */		
		public function setLocation(flipingPageLocation:Number):void
		{
			var fpl:Number = Math.abs(flipingPageLocation);
			var pageOffset:Number = (initialHeight/8);
            var top:Number = 0;
            var bottom:Number = initialHeight;
            var left:Number = 0;
            var pageXDeviation:Number =  initialWidth*fpl;
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