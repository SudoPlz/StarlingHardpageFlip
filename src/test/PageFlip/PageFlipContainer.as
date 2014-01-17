package test.PageFlip
{

    import starling.display.DisplayObject;

    import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
    import starling.textures.RenderTexture;
    import starling.textures.Texture;


/**
	 * Starling single page flip hardbook effect
	 * @author SudoPlz
     * @Description This class is meant to add any DisplayObject among its pages,
     *              then immitate the hard book flip effect.
     *              if the pages are sprites, then it adds them as children as is
     *              and uses a rasterized version of them as a texture JUST for the flip effect to take place.
	 */	
	public class PageFlipContainer extends Sprite
	{

        public static const NEXT:int = 1;
        public static const PREVIOUS:int = -1;

        /** Book width */
        private var bookWidth: Number;
        /** The height of the book */
        private var bookHeight: Number;
        /** The total number of pages of the book */
        private var pageCount: Number;

        private var pages:Vector.<DisplayObject>;
        public var pageOrientation: Number = -1;   //-1 means totally turned on the left, 1 means totally turned on the right.

        private var previousPage:int;
        private var nextPage:int;
        private var currentPage:int;

        private var topImage:Image;
        private var bottomImage:Image;
        private var flipImage:ImagePage;
//        private var quadBatch:QuadBatch;



		/**@private*/
		public function PageFlipContainer(pages:Vector.<DisplayObject>,bookWidth:Number,bookHeight:Number,startOnPage:int = 0)
		{
			super();
            this.pages = pages;
			this.bookWidth = bookWidth;
			this.bookHeight = bookHeight;
			this.pageCount = pages.length;

            currentPage = startOnPage;
            previousPage = startOnPage - 1;
            nextPage = startOnPage + 1;
            if(!canTurnTo(previousPage))
                previousPage = currentPage;
            if(!canTurnTo(nextPage))
                nextPage = currentPage;

			initPage();
		}

        public function canTurnTo(pageNo:int):Boolean
        {
            var valid:Boolean = false;
            if (pageIsValid(pageNo) && pageNo!=currentPage)
                valid = true;
            return valid;
        }


        public function pageIsValid(pageNo:int):Boolean
        {
            var valid:Boolean = false;
            if (pageNo>=0 && pageNo<pageCount)
                valid = true;
            return valid;
        }


		/** Init the pages*/
		private function initPage():void
		{


            if (pageIsValid(currentPage))
            {

                bottomImage = new Image(rasterizeDispObj(pages[currentPage]));
                bottomImage.x = bottomImage.y = 0;
                bottomImage.width = bookWidth;
                bottomImage.height = bookHeight;
                addChildAt(bottomImage,0);

                flipImage = new ImagePage(rasterizeDispObj(pages[currentPage]));
                flipImage.x = flipImage.y = 0;
                flipImage.width = bookWidth;
                flipImage.height = bookHeight;
                addChild(flipImage);

                topImage = new Image(rasterizeDispObj(pages[currentPage]));
                topImage.x = topImage.y = 0;
                topImage.width = bookWidth;
                topImage.height = bookHeight;
                topImage.visible = false;
                addChildAt(topImage,0);

//                quadBatch = new QuadBatch();
//                addChild(quadBatch);

            }
            else
                throw new Error ("Please specify a correct page index to start from.")

		}


        public function turnToNextPage():void
        {
            turnToPage(nextPage);
        }
        public function turnToPreviousPage():void
        {
            turnToPage(previousPage);
        }

        public function turnToPage(pageNo:int):void
        {
            if (canTurnTo(pageNo) && touchable)
            {
                if(pageNo>currentPage)
                {
                    pageOrientation = 1;    //totally right
                    tweenPageTurn(NEXT);
                }
                else if(pageNo<currentPage)
                {
                    pageOrientation = 0;    //totally middle
                    tweenPageTurn(PREVIOUS);
                }
                else    //turnToPage equals current page, no need to do anything
                {}
            }

        }

        private function tweenPageTurn(turnOrientation:int = NEXT):void
        {
//    	    needUpdate = true;
            touchable = false;
//            flipImgTexture = rasterizeDispObj(pages[currentPage]);
//            flipImage.texture =


            if (turnOrientation == NEXT)
            {
                flipImage.swapTexture(rasterizeDispObj(pages[currentPage]));
                bottomImage.texture = rasterizeDispObj(pages[nextPage]);
                topImage.visible = false;
            }
            else
            {
                bottomImage.texture = rasterizeDispObj(pages[currentPage]);
                flipImage.swapTexture(rasterizeDispObj(pages[previousPage]));
                topImage.visible = true;
                topImage.texture = rasterizeDispObj(pages[previousPage]);
            }
            var step:Number = 0.1*(-turnOrientation);
            addEventListener(Event.ENTER_FRAME,executeMotion);
            function executeMotion(event:Event):void
            {
                pageOrientation += step;

                if (pageOrientation < 0 || pageOrientation > 1)
                {
                    removeEventListener(Event.ENTER_FRAME,executeMotion);

                    flipImage.setLocation(pageOrientation);
                    tweenCompleteHandler(turnOrientation);
                }
                else
                {
                    flipImage.setLocation(pageOrientation);
                }
            }
        }



        /**Reset after the animation is finished */
        private function tweenCompleteHandler(justWent:int = NEXT):void
        {

            if (justWent == NEXT){
                pageOrientation = 0;
                currentPage = nextPage;
            }
            else{
                pageOrientation = 1;
                currentPage = previousPage;
            }
            flipImage.setLocation(pageOrientation);
            previousPage = currentPage-1;
            nextPage = currentPage+1;
            //TODO: Later on, set the next and previous flip images so that they are ready for the next animation
            touchable = true;
        }


        private function rasterizeDispObj(toBeRasterized:DisplayObject):Texture
        {
            var rasterized:Texture;

            if(toBeRasterized is Image)
            {
                rasterized = (toBeRasterized as Image).texture;
            }
            else //if (toBeRasterized is Sprite)
            {
                var renderer:RenderTexture = new RenderTexture(bookWidth,bookHeight,false);
                renderer.draw(toBeRasterized);
                rasterized = renderer;
            }
//            else
//                throw new Error("Only Textures or Sprites are allowed to be added on PageFlipContainer as pages.");

            return rasterized;
        }


	}
}