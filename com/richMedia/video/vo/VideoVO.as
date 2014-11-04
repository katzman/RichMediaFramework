package com.richMedia.video.vo
{
	
	public class VideoVO
	{
        public var videoPathLow		: String;
        public var videoPathHigh	: String;
        public var videoPathMid		: String;

        public var videoPath		: String;
		public var videoReportingID	: String;
		public var videoID			: Number;
		
		public var played			: Boolean;


		public function VideoVO() {}


        public function isMultiband():Boolean
        {
            if( videoPathHigh || videoPathMid || videoPathLow ) return true;
            return false;
        }
	}
}