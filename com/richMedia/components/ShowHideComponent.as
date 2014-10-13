/** ShowHideComponent
 * -------------------------------------------------------------------------------------
 * @ description: uses on mouse move event to decide if the mouse is currently over a display object. 
 * This can be used when the display object has nested buttons that the mouse needs to have access to. Good for showing and hiding video controls.
 * Add a display object, set it's size and position, pass it through the constructor along with a mouse off display object, "this" as a referance
 * to the entire banner usually works fine, don't always have access to stage, an event will fire when your over it and off it. If you pass a rollOff
 * time value in seconds then if the mouse stays over the object it will fire the off after the mouse stops for the specified amount of time.
 * 
 * @ usage: 
 * var showMC:MovieClip = videoComponent_mc.controlsComponent_mc.show_mc;
 * var showHideComp:ShowHideComponent = new ShowHideComponent( showMC, this );
 * showMC.addEventListener( ShowHideComponent.OVER, showControls );
 * showMC.addEventListener( ShowHideComponent.OFF,  hideControls );
 *  
 * @ developer: Neil Katz
 * @ version: 2.0.0  05.05.2014
 * -------------------------------------------------------------------------------------
 * */


package com.richMedia.components
{

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;


    public class ShowHideComponent
	{
		public static const OVER		: String = "over";
		public static const OFF			: String = "off";

		private var targetMC    		: DisplayObject;
        private var mouseTargetMC    	: DisplayObject;
        private var timer               : Timer;
        private var rollOffTime         : Number;
        private var isEnabled           : Boolean;

		
		public function ShowHideComponent( _target:DisplayObject, _mouseTarget:DisplayObject, _rollOffTime:Number = -1, _isEnabled:Boolean = true )
        {
			if( !_target || !_mouseTarget )
			{
				throw new Error( "ALARM!!! :: SHOW / HIDE COMPONENT :: CONSTRUCTOR :: NO TARGET OR MOUSE TARGET MOVIECLIP SET" );
			}
						
			trace("***************************************************");
			trace("********** SHOW HIDE COMPONENT V 2.0.0 ************");
			trace("***************************************************");

            rollOffTime = _rollOffTime;
            mouseTargetMC = _mouseTarget;
            targetMC = _target;
            isEnabled = _isEnabled;

            setListeners();
        }


        public function set enabled( value:Boolean ):void
        {
            isEnabled = value;
        }
		
		
		public function destroy( e:Event = null ):void 
		{
			removeListeners();
			targetMC = null;
            mouseTargetMC = null;
		}


		private function updateControls( e:MouseEvent ):void 
		{
            if( !isEnabled ) return;

            startTimer();

            //trace( "TARGET MC WIDTH :: " + targetMC.width + "   MOUSE X :: " + targetMC.mouseX );

            if( targetMC.mouseX > 0 && targetMC.mouseX < targetMC.width && targetMC.mouseY > 0 && targetMC.mouseY < targetMC.height )
			{
				overItem();
			}
			else
			{
				offItem();
			}
		}


        private function startTimer():void
        {
            if( rollOffTime == -1 ) return;

            clearTimer();

            timer = new Timer(( rollOffTime * 1000 ), 1 );
            timer.addEventListener( TimerEvent.TIMER_COMPLETE, offItem );
            timer.start();
        }


        private function clearTimer():void
        {
            if( timer )
            {
                timer.stop();
                timer = null;
            }
        }


		private function overItem():void
		{
            if( targetMC ) targetMC.dispatchEvent( new Event( OVER, true ));
		}
		
		
		private function offItem( e:TimerEvent = null ):void
		{
            clearTimer();
            if( targetMC ) targetMC.dispatchEvent( new Event( OFF, true ));
		}
				

        private function setListeners():void
        {
            mouseTargetMC.addEventListener( MouseEvent.MOUSE_MOVE, updateControls );
            targetMC.addEventListener( Event.REMOVED_FROM_STAGE, destroy );
        }
		
		
		private function removeListeners():void 
		{
            mouseTargetMC.removeEventListener( MouseEvent.MOUSE_MOVE, updateControls );
            targetMC.removeEventListener( Event.REMOVED_FROM_STAGE, destroy );
		}
    }
}