package test.PageFlip
{

    import starling.display.DisplayObject;

    import starling.display.Image;
import starling.display.Quad;
import starling.display.QuadBatch;
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

        private var pages:Vector.<DisplayObject>;  //our array of objects to display

        public var pageOrientation: Number = -1;    //Where we are currently at (on our path to turn the page)
        //-1 means totally turned on the left, 1 means totally turned on the right.

        private var nowTurning:int;             //Where we WANT to turn to (NEXT or PREVIOUS)
        private var previousPage:int;           // previous page number
        private var nextPage:int;               // next page number
        private var currentPage:int;            // current page number

        private var flipImage:ImagePage;        //the moving image that represents the flipping page
        private var cacheImage:ImagePage;       //the non moving image that represents the other page
        private var step:Number;                //how quick our page will be flipping


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



		/** Init the pages*/
		private function initPage():void
		{


            if (pageIsValid(currentPage))
            {
                cacheImage = new ImagePage(rasterizeDispObj(pages[currentPage]));
                flipImage = new ImagePage(rasterizeDispObj(pages[currentPage]));
                addChild(cacheImage);
                addChild(flipImage);
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
                    nowTurning = NEXT;      //going to the NEXT page
                    tweenPageTurn();
                }
                else if(pageNo<currentPage)
                {
                    pageOrientation = 0;    //totally middle
                    nowTurning = PREVIOUS;  //going to the PREVIOUS page
                    tweenPageTurn();
                }
                else    //turnToPage equals current page, no need to do anything
                {}
            }

        }


    ////////////////////////////////////////////////////////////////////////////////////
                                    //BASIC FUNCTION//
    ////////////////////////////////////////////////////////////////////////////////////
        private function tweenPageTurn():void
        {
            touchable = false;

            if (nowTurning == NEXT)
            {
                cacheImage.swapTexture(rasterizeDispObj(pages[nextPage]));
                flipImage.swapTexture(rasterizeDispObj(pages[currentPage]));
            }
            else
            {
                cacheImage.swapTexture(rasterizeDispObj(pages[currentPage]));
                flipImage.swapTexture(rasterizeDispObj(pages[previousPage]));
            }
            setChildIndex(cacheImage,0);
            setChildIndex(flipImage,1);
            step = 0.1*(-nowTurning);
            addEventListener(Event.ENTER_FRAME,onEnterFrame);

        }

        private function onEnterFrame(event:Event):void
        {
            pageOrientation += step;
            if (pageOrientation < 0 || pageOrientation > 1)
            {
                removeEventListener(Event.ENTER_FRAME,onEnterFrame);
                tweenCompleteHandler();
            }
            flipImage.setLocation(pageOrientation);
        }


        /**Reset after the animation is finished */
        private function tweenCompleteHandler():void
        {
            if (nowTurning == NEXT){
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

            cacheImage.swapTexture(rasterizeDispObj(pages[currentPage]));

            setChildIndex(cacheImage,0);
            setChildIndex(flipImage,1);
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


    }
}