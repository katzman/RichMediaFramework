package com.richMedia.components
{
	
	import com.greensock.TweenNano;
    import com.richMedia.events.RmAdEvent;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
	import flash.geom.Rectangle;


	public class SliderComponent
	{
        public var bar_mc 		    : MovieClip;
        public var sliderBtn_mc 	: MovieClip;
        private var slider_mc       : MovieClip;

        private var sliderRect		: Rectangle;
        private var sliderLimit		: int;


		public function SliderComponent() {}

		
		public function setSlider( _slider:MovieClip ):void
		{		
			if( !_slider ) return;

            slider_mc = _slider;

            if( slider_mc.stage ) init();
            else slider_mc.addEventListener( Event.ADDED_TO_STAGE, init );
		}


        private function init( e:Event = null ):void
        {
            slider_mc.removeEventListener( Event.ADDED_TO_STAGE, init );

            sliderBtn_mc    = slider_mc["sliderBtn_mc"];
            bar_mc          = slider_mc["bar_mc"];

            slider_mc.buttonMode = true;

            sliderLimit = Math.round ( bar_mc.width - sliderBtn_mc.btn_mc.width );
            sliderRect = new Rectangle( 0, 0, sliderLimit, 0 );

            setListeners();
        }


        private function destroy( e:Event ):void
        {
            removeListeners();

            sliderRect      = null;
            sliderBtn_mc    = null;
            bar_mc          = null;
        }

		
		public function disable():void
		{
			if ( slider_mc.mouseEnabled )
			{
                TweenNano.to ( slider_mc, .3, {alpha:.5} );
                slider_mc.mouseEnabled = false;
			}
		}
		
		public function enable ():void 
		{
			if ( !slider_mc.mouseEnabled )
			{
                TweenNano.to ( slider_mc, .3, {alpha:1} );
                slider_mc.mouseEnabled = true;
			}
		}
				

		protected function btnEvents( e:MouseEvent ):void
		{
            switch( e.type )
            {
                case MouseEvent.MOUSE_DOWN:
                    if( e.target == sliderBtn_mc ) startDragging();
                    break;

                case MouseEvent.MOUSE_OVER:
                    if( e.target == sliderBtn_mc ) btnOver();
                    break;

                case MouseEvent.MOUSE_OUT:
                    if( e.target == sliderBtn_mc )
                    {
                        btnOut();
                        stopDragging();
                    }
                    break;

                case MouseEvent.MOUSE_UP:
                    stopDragging();
                    break;

                case MouseEvent.CLICK:
                    if( e.target == bar_mc ) seekToPoint();
                    break;
			}
		}


		private function stopDragging():void
		{
            sliderBtn_mc.removeEventListener( MouseEvent.MOUSE_MOVE, updateSliderValue );
            sliderBtn_mc.stopDrag();
		}


		private function startDragging():void
		{
            sliderBtn_mc.addEventListener( MouseEvent.MOUSE_MOVE, updateSliderValue );
            sliderBtn_mc.startDrag( false, sliderRect );
		}


		private function updateSliderValue( event:MouseEvent ):void
		{
            var scale:Number = ( sliderBtn_mc.x ) / sliderLimit;
            slider_mc.dispatchEvent( new RmAdEvent( RmAdEvent.SLIDER_UPDATED, {pos:scale} ));

            if( slider_mc.stage ) slider_mc.stage.invalidate();
			event.updateAfterEvent();
		}


        private function seekToPoint():void
        {
            var scale:Number = ( bar_mc.mouseX ) / sliderLimit;
            slider_mc.dispatchEvent( new RmAdEvent( RmAdEvent.SLIDER_UPDATED, {pos:scale} ));
        }


        private function btnOut():void
        {
            sliderBtn_mc.gotoAndStop( "out" );
        }


        private function btnOver():void
        {
            sliderBtn_mc.gotoAndStop( "over" );
        }


        public function setListeners():void
        {
            sliderBtn_mc.mouseChildren = false;

            slider_mc.addEventListener( Event.REMOVED_FROM_STAGE, destroy );

            slider_mc.stage.addEventListener( MouseEvent.MOUSE_UP,   btnEvents );
            slider_mc.addEventListener( MouseEvent.MOUSE_DOWN,       btnEvents );
            slider_mc.addEventListener( MouseEvent.MOUSE_OVER,       btnEvents );
            slider_mc.addEventListener( MouseEvent.MOUSE_OUT,        btnEvents );
            slider_mc.addEventListener( MouseEvent.CLICK,            btnEvents );
        }


        public function removeListeners():void
        {
            slider_mc.removeEventListener( Event.REMOVED_FROM_STAGE, destroy );

            slider_mc.stage.removeEventListener( MouseEvent.MOUSE_UP,   btnEvents );
            slider_mc.removeEventListener( MouseEvent.MOUSE_DOWN,       btnEvents );
            slider_mc.removeEventListener( MouseEvent.MOUSE_OVER,       btnEvents );
            slider_mc.removeEventListener( MouseEvent.MOUSE_OUT,        btnEvents );
            slider_mc.removeEventListener( MouseEvent.CLICK,            btnEvents );
        }
	}
}