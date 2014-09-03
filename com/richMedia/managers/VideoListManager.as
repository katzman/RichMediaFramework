/** TuneInListManager
 * -------------------------------------------------------------------------------------
 * @ description: maintains video lists based on date coded values
 * @ developer: Neil Katz
 * @ version: 1.0  02.13.2014
 * -------------------------------------------------------------------------------------
 * */

package com.richMedia.managers
{
	import com.richMedia.components.*;
	import com.richMedia.constants.Constants;
	import com.richMedia.video.vo.VideoVO;
	import com.richMedia.components.TuneIn;


	public class VideoListManager
	{

		private var _tuneInId    : String;
		private var swfId        : String;
		private var videoList    : Object;
		private var useTuneIn	 : Boolean;


		public function VideoListManager( _useTuneIn:Boolean, _swfId:String )
		{
			useTuneIn   = _useTuneIn;
			swfId       = _swfId;

			trace("***************************************************");
			trace("*********** VIDEO LIST MANAGER V 2.0.0 ************");
			trace("***************************************************");
		}


		/**
		 * videos are added in the flash IDE
		 * this method creates a generic object which adds
		 * videos based on their date code in an array.
		 */
		public function addVideo( day:String, path:String, reportingID:String = "", id:Number = -1 ):void
		{
			if( !useTuneIn ) day = Constants.TUNEIN_DEFAULT_ID;
			if( !videoList ) videoList = {};
			if( !videoList[day] ) videoList[day] = [];

			var videoVO:VideoVO = new VideoVO();
			videoVO.videoID = id;
			videoVO.videoPath = path;
			videoVO.videoReportingID = reportingID;

			videoList[day].push( videoVO );
		}


		/**
		 * Returns video array by tunin date.
		 */
		public function get videoArray():Array
		{
			return videoList[tuneInId];
		}


		/**
		 * Returns video object by tunin date and position value.
		 */
		public function getCurrentVideo( pos:uint ):VideoVO
		{
			if( !videoArray || !videoArray[pos] )
			{
				trace("ALARM!!! ::: GET CURRENT VIDEO CALLED : VIDEO ARRAY IS NULL. Make sure videos have been added before playing video." );
				return null;
			}

			return videoArray[pos];
		}


		/**
		 * Returns the current tunein id.
		 */
		public function get tuneInId():String
		{
			if( _tuneInId ) return _tuneInId;

			if( swfId && TuneIn.getCurrentVideoId( swfId )) return TuneIn.getCurrentVideoId( swfId );

			if( TuneIn.currentVideoId ) return TuneIn.currentVideoId;

			return Constants.TUNEIN_DEFAULT_ID;
		}


		public function set tuneInId( value:String ):void
		{
			_tuneInId = value;
		}
	}
}