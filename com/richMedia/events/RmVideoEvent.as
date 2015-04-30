package com.richMedia.events
{
	
	import flash.events.Event;

	
	public class RmVideoEvent extends Event
	{
        // video player update events
        public static const VIDEO_PROGRESS			:String = "progress";
		public static const VIDEO_UNMUTED			:String = "unmuted";
		public static const VIDEO_MUTED			    :String = "muted";
		public static const VIDEO_ERROR				:String = "error";
		public static const	VIDEO_STOPPED			:String = "stopped";
		public static const	VIDEO_COMPLETE			:String = "complete";
		public static const	VIDEO_LOOP_COMPLETE		:String = "loop complete";
		public static const VIDEO_STARTED			:String = "started";
        public static const VIDEO_CLEARED			:String = "cleared";
		public static const VIDEO_PAUSED			:String = "paused";
        public static const VIDEO_PLAYING           :String = "playing";
		public static const VIDEO_RESUMED			:String = "resumed";
		public static const VIDEO_BUFFER_EMPTY		:String = "buffer empty";
		public static const VIDEO_BUFFER_FULL		:String = "buffer full";
		public static const VIDEO_READY				:String = "ready";
        public static const VIDEO_LOADED            :String = "loaded";
		public static const VIDEO_ON_CUEPOINT   	:String = "cue point";
		public static const UPDATE_VIDEO_ID		    :String = "update video id";
		public static const VIDEO_UPDATED		    :String = "updated";
        public static const VIDEO_REPLAYING		    :String = "replaying";

        public static const VIDEO_BYTES_LOADED		:String = "bytesLoaded";

        public static const VIDEO_0_PERCENT         :String = "video 0% complete";
        public static const VIDEO_25_PERCENT        :String = "video 25% complete";
        public static const VIDEO_50_PERCENT        :String = "video 50% complete";
        public static const VIDEO_75_PERCENT        :String = "video 75% complete";
        public static const VIDEO_100_PERCENT       :String = "video 100% complete";

        public static const SHOW_BUFFERING 			:String = "showBuffering";
        public static const HIDE_BUFFERING 			:String = "hideBuffering";

        // controls events
        public static const MUTE_VIDEO  			:String = "muteVideo";
        public static const UNMUTE_VIDEO  			:String = "unmuteVideo";

        public static const PLAY_VIDEO  			:String = "playVideo";
        public static const PAUSE_VIDEO  			:String = "pauseVideo";

        public static const SEEK_VIDEO              :String = "seekVideo";
        public static const STOP_VIDEO              :String = "stopVideo";

        public static const PLAY_WITH_SOUND_CALLED  :String = "playWithSoundCalled";

		public var data 							:Object;

		
		public function RmVideoEvent( type:String, _data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false ):void
		{
			super( type, true, false);
			
			data = _data;
		}
		

		public override function clone():Event 
		{
            return new RmVideoEvent( type, bubbles, cancelable );
        }

		
        public override function toString():String 
		{
            return formatToString( "RmVideoEvent", "type", "bubbles", "cancelable" );
        }
	}
}