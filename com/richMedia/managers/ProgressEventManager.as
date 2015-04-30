/** ProgressEventManager
 * -------------------------------------------------------------------------------------
 * @ description: acts as a mini model for video progress events.   
 * @ developer: Neil Katz
 * @ version: 1.0.0  04.13.2014
 * -------------------------------------------------------------------------------------
 * */


package com.richMedia.managers
{
	
	public class ProgressEventManager
	{

		private var progressEvents_obj 	: Object;


		public function ProgressEventManager() 
		{			
			trace("***************************************************");
			trace("********* PROGRESS EVENT MANAGER V 2.0.0 **********");
			trace("***************************************************");
		}

		
		/**
		 * add a percent value between 0 and 1 that fires a method when video reaches that point of the video.
		 */
		public function addProgressEvent( time:String, videoID:String, method:Function = null, useTime:Boolean = false ):void 
		{
			if( !time ) 
			{
				trace( "ALARM!!! ADD PROGRESS EVENT MUST INCLUDE A VALID NUMBER BETWEEN 0 AND 1 OR TIME AS STRING" );
				return;
			}
			
			if( !videoID ) 
			{
				trace( "ALARM!!! ADD PROGRESS EVENT MUST INCLUDE A VALID VIDEO REPORTING ID" );
				return;
			}
			
			if( method == null ) 
			{
				trace( "ALARM!!! ADD PROGRESS EVENT MUST INCLUDE A VALID CALL BACK FUNCTION" );
				return;
			}
			
			if( !progressEvents_obj ) progressEvents_obj = {};
			if( !progressEvents_obj[videoID] ) progressEvents_obj[videoID] = [];
			
			var timePos:Number = ( useTime ) ? convertToSeconds( time ) : Number( time );
			progressEvents_obj[videoID].push( { time:timePos, value:time, callback:method, fired:false, useTime:useTime } );
			
			progressEvents_obj[videoID].sortOn( "time", Array.NUMERIC );
		}
		
		
		private function convertToSeconds( _time:String ):Number
		{			
			var timeArray:Array;
			var minutes:Number;
			var time:Number;
			
			if( _time.indexOf( ":" ) == -1 )
			{
				time = Number( _time );
			}
			else 
			{
				timeArray = _time.split( ":" );
				minutes = Number( timeArray[0] | 0 ) * 60; 
				time = minutes + Number( timeArray[1] );				
			}
			
			return time;
		}
		
		
		public function getProgressList( _videoID:String ):Array
		{
			if( !progressEvents_obj || !progressEvents_obj[_videoID] || progressEvents_obj[_videoID].length == 0 ) return null;			
			return progressEvents_obj[_videoID];
		}


        public function resetEvents():void
        {
            var eventList:Array;
            var item:Object;
            var length:uint;

            for each ( eventList in progressEvents_obj )
            {
                length = eventList.length;

                for( var i:uint = 0; i < length; i++ )
                {
                    item = eventList[i];
                    if( item ) item.fired = false;
                }
            }
        }
	}
}