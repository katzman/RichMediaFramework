package com.richMedia.events
{

    import flash.events.EventDispatcher;


    public class EventBroadcaster extends EventDispatcher
	{

        private static var instance :EventBroadcaster = new EventBroadcaster();


        public static function getInstance():EventBroadcaster
        {
            return instance;
        }


        public function EventBroadcaster():void
        {
            if ( instance ) throw new Error("Error: Instantiation failed: Use EventBroadcaster.getInstance() instead of new.");
        }
    }
}