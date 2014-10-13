﻿package com.richMedia.components{	import com.richMedia.constants.Constants;	import com.richMedia.events.RmAdEvent;	import com.richMedia.events.EventBroadcaster;	import com.richMedia.utils.Utils;    import flash.events.TimerEvent;    import flash.utils.Timer;    public class TuneIn	{		///////////////////////////// PUBLIC VARS /////////////////////////////		public static const TIMEZONE_UTC		: String = "utc";		public static const TIMEZONE_ATLANTIC	: String = "atlantic";		public static const TIMEZONE_EASTERN	: String = "eastern";		public static const TIMEZONE_CENTRAL	: String = "central";		public static const TIMEZONE_MOUNTAIN	: String = "mountain";		public static const TIMEZONE_PACIFIC	: String = "pacific";		public static const TIMEZONE_ALASKA		: String = "alaska";		public static const TIMEZONE_HAWAII		: String = "hawaii";		public static const SUNDAY		        : uint = 0;		public static const MONDAY	            : uint = 1;		public static const TUESDAY	            : uint = 2;		public static const WEDNESDAY	        : uint = 3;		public static const THURSDAY	        : uint = 4;		public static const FRIDAY	            : uint = 5;		public static const SATURDAY		    : uint = 6;		public static var isReady               : Boolean;		public static var _utcOffset	        : Number = 0;		public static var currentZone	        : Object;		///////////////////////////// PRIVATE VARS /////////////////////////////		private static const OFFSET_UTC			: Object = { dst:0,  standard:0 };  // GMT time, always 0		private static const OFFSET_ATLANTIC	: Object = { dst:4,  standard:4 };		private static const OFFSET_EASTERN		: Object = { dst:4,  standard:5 };		private static const OFFSET_CENTRAL		: Object = { dst:5,  standard:6 };		private static const OFFSET_MOUNTAIN	: Object = { dst:6,  standard:7 };		private static const OFFSET_PACIFIC		: Object = { dst:7,  standard:8 };		private static const OFFSET_ALASKA		: Object = { dst:8,  standard:9 };		private static const OFFSET_HAWAII		: Object = { dst:10, standard:10 };  // doesn't observe DST		private static var zoneList		: Object = {};		zoneList[TIMEZONE_UTC] 			= OFFSET_UTC;		zoneList[TIMEZONE_ATLANTIC] 	= OFFSET_ATLANTIC;		zoneList[TIMEZONE_EASTERN] 		= OFFSET_EASTERN;		zoneList[TIMEZONE_CENTRAL] 		= OFFSET_CENTRAL;		zoneList[TIMEZONE_MOUNTAIN] 	= OFFSET_MOUNTAIN;		zoneList[TIMEZONE_PACIFIC] 		= OFFSET_PACIFIC;		zoneList[TIMEZONE_ALASKA] 		= OFFSET_ALASKA;		zoneList[TIMEZONE_HAWAII] 		= OFFSET_HAWAII;		private static var dtsDates		: Object = {};		dtsDates["2014"] = {start:{ year:2014, month:3, day:9 }, stop:{ year:2014, month:11, day:2 }};		dtsDates["2015"] = {start:{ year:2015, month:3, day:8 }, stop:{ year:2015, month:11, day:1 }};		dtsDates["2016"] = {start:{ year:2016, month:3, day:13 }, stop:{ year:2016, month:11, day:6 }};		dtsDates["2017"] = {start:{ year:2017, month:3, day:12 }, stop:{ year:2017, month:11, day:5 }};		dtsDates["2018"] = {start:{ year:2018, month:3, day:11 }, stop:{ year:2018, month:11, day:4 }};		private static var dates 		: Array;		private static var dateRange 	: Object = {};		private static var dateObj 		: Object = {};		private static var dateResults 	: Object = {};        // countdown timer        private static var countdownList    : Object = {};        private static var countDownTimer   : Timer;		private static var id			: String;		private static var videoid		: String;		private static var defaultId	: String = Constants.TUNEIN_DEFAULT_ID;		private static var frameNum		: uint;		private static var defaultFrame	: uint;		private static var testToday	: Date;		///////////////////////////// PUBLIC METHODS /////////////////////////////		public static function addDefault( _id:String = "", _frame:uint = 0, _swfId:String = null ):void		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			if( !dateResults[_swfId] ) dateResults[_swfId] = {};			dateResults[_swfId].defaultFrame = _frame;			dateResults[_swfId].defaultId = _id;		}		public static function addDate( _date:Object, _id:String = "", _frame:uint = 0, _useWithVideo:Boolean = true, _swfId:String = null ):void		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			if ( !dateObj[_swfId] ) dateObj[_swfId] = [];			var date:Date = getDate( _date );			var date_obj:Object = { date:date, time:date.time, frame:_frame, id:_id, useVideo:_useWithVideo };			dateObj[_swfId].push( date_obj );		}		public static function addDateRange( _startDate:Object, _endDate:Object, _day:uint, _id:String = "", _frame:uint = 0, _useWithVideo:Boolean = false, _swfId:String = null ):void		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			var startDate:Date = getDate( _startDate );			var endDate:Date = getDate( _endDate );			var date_obj:Object = { startDate:startDate, endDate:endDate, day:_day, frame:_frame, id:_id, useVideo:_useWithVideo };			dateRange[_swfId] = date_obj;		}        public static function addCountdownTimer( _endDate:Object, _callBack:Function, _swfId:String = null ):void        {            _swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;            var endDateObj:Date = getDate( _endDate );            countdownList[_swfId] = { endDate:endDateObj, callback:_callBack };            if( !countDownTimer )            {                countDownTimer = new Timer( 1000 );                countDownTimer.addEventListener( TimerEvent.TIMER, updateCountdown );                countDownTimer.start();            }        }        private static function updateCountdown( e:TimerEvent ):void        {            var countDownObj:Object;            var todayTime:Number = todayCheckTime;            var timeDifference:Number;            var checkTime:Number;            var seconds:Number;            var minutes:Number;            var hours:Number;            var days:Number;            var returnObj:Object;            var complete:Boolean;            for each ( countDownObj in countdownList )            {                if( countDownObj && countDownObj.endDate )                {                    checkTime = getUTCTime( countDownObj.endDate, _utcOffset );                    timeDifference = checkTime - todayTime;                    if( timeDifference <= 0 )                    {                        complete = true;                        countDownTimer.stop();                    }                    else                    {                        seconds = Math.floor( timeDifference / 1000 );                        minutes = Math.floor( seconds / 60 );                        seconds = seconds % 60;                        hours = Math.floor( minutes / 60 );                        minutes = minutes % 60;                        days = Math.floor( hours / 24 );                        hours = hours % 24;                    }                    returnObj = { days:days, hours:hours, minutes:minutes,  seconds:seconds, complete:complete };                    countDownObj.callback( returnObj );                }            }        }		public static function setTimezone( zone:String ):void		{			if( !zoneList[zone] )			{				trace( "ALARM!!! valid zone not passed, make sure to use zone values referanced from this class" );				return;			}			currentZone = zoneList[zone];			var offSet:Number = isObservingDTS() ? currentZone.dst : currentZone.standard;			_utcOffset = offSet * ( 1000*60*60 );		}		public static function get currentTimeZoneOffset():Number		{			var offset:Number = today.timezoneOffset / 60;			return offset;		}		public static function get currentframe():uint		{			if( !isReady ) parseDate();			var dateItem:Object = dateResults[defaultId];			return dateItem.frameNum || dateItem.defaultFrame;		}		public static function getCurrentframeBySwfID( _swfId:String = null ):uint		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			if( !isReady ) parseDate();			var dateItem:Object = dateResults[_swfId];			if( !dateItem )			{				trace( "ALARM!!! :: TUNE IN GET CURRENT FRAME BY SWF ID CALLED :: NO DATES ARRAY ATTACHED TO THIS ID, MAKE SURE SWF ID IS SET WHEN SETTING DATES AND YOUR CALLING CORRECT ID FOR PARSE DATE" );				return null;			}			return dateItem.frameNum || dateItem.defaultFrame;		}		public static function get currentId():String		{			if( !isReady ) parseDate();			var dateItem:Object = dateResults[defaultId];			if( !dateItem )			{				trace( "ALARM!!! :: TUNE IN GET CURRENT ID CALLED :: NO DEFAULT DATES ARRAY, GET CURRENT TUNE IN ID BY PASSING SWF ID TO getCurrentIdBySwfID" );				return null;			}			return dateItem.id || dateItem.defaultId;		}		public static function getCurrentIdBySwfID( _swfId:String = null ):String		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			if( !isReady ) parseDate();			var dateItem:Object = dateResults[_swfId];			if( !dateItem )			{				trace( "ALARM!!! :: TUNE IN GET CURRENT ID BY SWF ID CALLED :: NO DATES ARRAY ATTACHED TO THIS ID, MAKE SURE SWF ID IS SET WHEN SETTING DATES AND YOUR CALLING CORRECT ID FOR PARSE DATE" );				return null;			}			return dateItem.id || dateItem.defaultId;		}		public static function get currentVideoId():String		{			if( !isReady ) parseDate();			return dateResults[defaultId].videoid || dateResults[defaultId].defaultId;		}		public static function getCurrentVideoId( _swfId:String = null ):String		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			if( !isReady ) parseDate();			var dateItem:Object = dateResults[_swfId];			if( !dateItem )			{				trace( "ALARM!!! :: TUNE IN GET CURRENT ID BY SWF ID CALLED :: NO DATES ARRAY ATTACHED TO THIS ID, MAKE SURE SWF ID IS SET WHEN SETTING DATES AND YOUR CALLING CORRECT ID FOR PARSE DATE" );				return null;			}			return dateItem.videoid || dateItem.defaultId;		}		public static function setTestDateByDate( _date:Object ):void		{			testToday = getDate( _date );		}		public static function parseDate( _swfId:String = null ):void		{			_swfId = ( _swfId ) ? _swfId : Constants.TUNEIN_DEFAULT_ID;			if ( !dateObj[_swfId] )			{				trace( "ALARM!!! :: TUNE IN PARSE DATE CALLED :: NO DATES ARRAY FOR SWF ID :: " + _swfId );				return;			}			if( !dateResults[_swfId] ) dateResults[_swfId] = {};			dateObj[_swfId].sortOn( "time", Array.NUMERIC );			var length:uint = dateObj[_swfId].length;			var todayTime:Number = todayCheckTime;			var checkTime:Number;			var date_obj:Object;			for ( var i:uint = 0; i < length; i++ )			{				date_obj = dateObj[_swfId][i];				if( !date_obj ) continue;				checkTime = getUTCTime( date_obj.date, _utcOffset );				if( checkTime <= todayTime )				{					if( date_obj.useVideo ) dateResults[_swfId].videoid = date_obj.id;					dateResults[_swfId].id = date_obj.id;					dateResults[_swfId].frameNum = date_obj.frame;				}				else				{					break;				}			}			if( checkDateRange( _swfId ) )			{				if( dateRange[_swfId].useVideo ) dateResults[_swfId].videoid = dateRange[_swfId].id;				dateResults[_swfId].id = dateRange[_swfId].id;				dateResults[_swfId].frameNum = dateRange[_swfId].frame;			}			isReady = true;			trace("***************************************************");			trace("********** TUNE IN DATE MANAGER V 2.0.0 ***********");			trace("********** SWF ID: " + _swfId + " *****************");			trace("***************************************************");			var broadcaster:EventBroadcaster = EventBroadcaster.getInstance();			broadcaster.dispatchEvent( new RmAdEvent( RmAdEvent.TUNEIN_READY ));		}		private static function checkDateRange( _swfId:String ):Boolean		{			if( !dateRange || !dateRange[_swfId] ) return false;			var startDate:Number = getUTCTime( dateRange[_swfId].startDate, _utcOffset ); //dateRange[_swfId].startDate.time;			var endDate:Number = getUTCTime( dateRange[_swfId].endDate, _utcOffset ); //dateRange[_swfId].endDate.time;			var checkDay:uint = dateRange[_swfId].day;			var onDay:Boolean = dateRange[_swfId].onDay;			var todayTime:Number = todayCheckTime;			var day:uint = today.day as uint;			if( todayTime >= startDate && todayTime <= endDate )			{				if( checkDay == day )				{					return true;				}			}			return false;		}		///////////////////////////// PRIVATE METHODS /////////////////////////////		private static function getDate( _obj:Object ):Date		{			//object properties { year:2014, month:4, day:14, hours:14, minutes:30 }			if( !_obj ) return null;			var year:int 	= _obj.year;			var month:int 	= _obj.month -1;			var day:int 	= _obj.day;			var hour:int 	= _obj.hours || 0;			var minute:int 	= _obj.minutes || 0;			var date:Date 	= new Date( year, month, day, hour, minute );			return date;		}		private static function get todayCheckTime():Number		{			var time:Number;			var zoneOffset:Number = today.timezoneOffset * (60*1000);			if( _utcOffset != 0 )			{				time = getUTCTime( today, zoneOffset );			}			else			{				time = today.time;			}			return time;		}		private static function getUTCTime( date:Date, offset:Number ):Number		{			var result:Date = new Date( date.time );			result.setTime( date.time + offset );			return result.time;		}		public static function isObservingDTS():Boolean		{			var now:Date = new Date();			var dts:Object = dtsDates[String( now.fullYear )];			var start:Date = getDate( dts.start as Object );			var stop:Date = getDate( dts.stop as Object );			if( start.time <= now.time && stop.time >= now.time )			{				return true;			}			return false;		}		private static function get today():Date		{			if( testToday && Utils.getPlayerType() != Utils.PLAYER_PLUGIN )			{				trace( "\n\n\nALARM!!! TEST DATE SET IN TUNE IN :: DISABLE BEFORE GOING LIVE\n\n\n" );				return testToday;			}			return new Date();		}	}}