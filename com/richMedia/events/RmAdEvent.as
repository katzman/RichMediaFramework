package com.richMedia.events
{
	
	import flash.events.Event;
	
	
	public class RmAdEvent extends Event
	{
        public static const ANIMATION_COMPLETE  : String = "animationComplete";
        public static const ANIMATION_UPDATE    : String = "animationUpdate";

        public static const EXPAND_UNIT	    	: String = "expandUnit";
        public static const EXPAND_START	    : String = "expandStart";
        public static const EXPAND_COMPLETE	    : String = "expandComplete";

        public static const COLLAPSE_UNIT	    : String = "collapseUnit";
        public static const COLLAPSE_COMPLETE   : String = "collapseComplete";

		public static const ASSET_LOAD_COMPLETE	: String = "assetLoadComplete";
		public static const ASSET_LOAD_ERROR	: String = "assetLoadError";

        public static const CLICK_FIRED			: String = "clickFired";
        public static const TUNEIN_READY	    : String = "tuneInReady";

		public var data							: Object;
	
		
		public function RmAdEvent( type:String, _data:Object = null, bubbles:Boolean = true, cancelable:Boolean = true ):void
		{
			super( type, bubbles, cancelable );
			data = _data;
		}
		
		
		public override function clone():Event 
		{
            return new RmAdEvent ( type, bubbles, cancelable );
        }
		

        public override function toString():String 
		{
            return formatToString( "RmAdEvent", "type", "bubbles", "cancelable" );
        }
	}
}