package com.richMedia.events
{
	
	import flash.events.Event;

	
	public class RmVideoEvent extends Event
	{
        // video player update events
        public static const VIDEO_PROGRESS			:String = "videoProgress";
		public static const VIDEO_UNMUTED			:String = "videoUnmuted";
		public static const VIDEO_MUTED			    :String = "videoMuted";
		public static const VIDEO_ERROR				:String = "videoError";
		public static const	VIDEO_STOPPED			:String = "videoStopped";
		public static const	VIDEO_COMPLETE			:String = "videoComplete";
		public static const	VIDEO_LOOP_COMPLETE		:String = "videoLoopComplete";
		public static const VIDEO_STARTED			:String = "videoStarted";
        public static const VIDEO_CLEARED			:String = "videoCleared";
		public static const VIDEO_PAUSED			:String = "videoPaused";
        public static const VIDEO_PLAYING           :String = "videoPlaying";
		public static const VIDEO_RESUMED			:String = "videoResumed";
		public static const VIDEO_BUFFER_EMPTY		:String = "videoBufferEmpty";
		public static const VIDEO_BUFFER_FULL		:String = "videoBufferFull";
		public static const VIDEO_READY				:String = "videoReady";
        public static const VIDEO_LOADED            :String = "videoLoaded";
		public static const VIDEO_ON_CUEPOINT   	:String = "onCuePoint";
		public static const UPDATE_VIDEO_ID		    :String = "updateVideoID";
		public static const VIDEO_UPDATED		    :String = "videoUpdated";

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