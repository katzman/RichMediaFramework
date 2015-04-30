/**
 * Version: 1.0
 * 03/31/15 Neil Katz
 * Original Version
 */

package com.richMedia.managers.doubleclick
{

	import com.google.ads.studio.ProxyEnabler;
	import com.google.ads.studio.utils.StudioClassAccessor;

	import flash.display.DisplayObject;


	/**
	 *
	 * A static class to handle exits, counters, and timers. It's set up to work directly with the MouseEventManager.
	 * Organizes the exit's based on the button instance name. It will also fire a counter with the exit provided it is passed in the exitObj.
	 *
	 * Currently has no special counter functionality, work in progress.
	 *
	 * The only extra timer functionality is when you start a timer through this class it will get added to an array.
	 * It has a method that will parse through the array and kill all timers in the array.
	 *
	 * @example
	 * <listing version="3.0">
	 * DCTrackingManager.addExit( button instance name ( btn.name ), { id:( exit string that will be tracked in DC), ctr:( counter string that will be tracked in studio )); // adding exit that is associated with a specific button
	 * DCTrackingManager.exitClicked( button that was clicked ); // It will fire the exit provided the button name has an associated exit value that was passed in addExit. It will also fire a counter provided that value was also passed in addExit.
	 * DCTrackingManager.trackCounter( counter id ); // fires a counter using the passed string. No extra functionality yet.
	 * DCTrackingManager.timerStart( timer id ); // starts a timer using the string value that is passed, adds the timer to an array, allowing you to call a single method to stop all currently running timers
	 * DCTrackingManager.timerStop( timer id ); // stops a timer using the string value that is passed, removes the timer from the timer array.
	 * DCTrackingManager.stopAllTimers(); // kills all running timers.
	 * </listing>
	 */
	public class DCTrackingManager
	{

		private static var exitList:Object = {};
		private static var timerList:Array = [];

		private static var enabler:ProxyEnabler = ProxyEnabler.getInstance();
		private static var expanding:Object = StudioClassAccessor.getClass(StudioClassAccessor.CLASS_EXPANDING)["getInstance"]();


		// ######################## EXIT METHODS #############################
		/**
		 * Adds and exit using the button instance name as a key and the exitObj is the exit and optional counter value associated with that button.
		 * @param btnId 	A String that is the button's actual instance name that it was given in flash.
		 * @param exitObj An object that includes the exit tracking value and the optional counter value. These values must match up to an enabler.exit( "value" ) and enabler.counter( "value" ) in the DCData AS file.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.addExit( button instance name ( btn.name ), { id:( exit string that will be tracked in DC), ctr:( counter string that will be tracked in studio ));
		 * </listing>
		 */
		public static function addExit( _btnId:String, _exitId:String, _close:Boolean = false ):void
		{
			if( !_exitId ) return;

			if( !exitList ) exitList = {};
			exitList[_btnId] = { id:_exitId, close:_close };
		}


		/**
		 * Pass the display object that was clicked, if there is an exit added using the addExit method using this buttons instance name it's exit and counter will get processed.
		 * @param btn A DisplayObject, can be a MovieClip or Button or even a sprite.
		 * @example <listing version="3.0">
		 * DCTrackingManager.exitClicked( btn that was clicked );</listing>
		 */
		public static function exitClicked( btn:DisplayObject ):void
		{
			if( !btn ) return;

			var btnId:String = btn.name;
			if( !exitList[btnId] ) return;

			enabler.exit( exitList[btnId].id );

			if( exitList[btnId].close ) collapseUnit();
		}


		/**
		 * All this does is fire a simple exit, same as calling enabler.exit( value ).
		 * @param exit A String defining the exit value.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.fireExit( exit value );</listing>
		 */
		public static function fireExit( _exit:String ):void
		{
			if( !_exit ) return;

			enabler.exit( _exit );
		}


		// ######################## COUNTER METHODS #############################
		/**
		 * Pass the string that you want tracked. This is the exact same as writing enabler.counter( value ).
		 * I'm moving all these events to one class to better organize them and add more functionality later.
		 * @param id String value to be tracked, must match up to an enabler.counter( value ) in the DCData AS file.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.trackCounter( counter );
		 * </listing>
		 */
		public static function trackCounter( id:String ):void
		{
			if( !id ) return;
			enabler.counter( id );
		}


		// ######################## COLLAPSE UNIT #############################
		/**
		 * This is the exact same as writing expanding.collapse();.
		 * I'm moving all these events to one class to better organize them and add more functionality later.
		 * @param isUser Boolean value that differentiates between user and non user initiated close.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.collapseUnit( true );
		 * </listing>
		 */
		public static function collapseUnit( isUser:Boolean = false, ctr:String = "" ):void
		{
			expanding.collapse();

			stopAllTimers();

			if( !isUser ) return;

			var counter:String;

			if( ctr != "" ) counter = ctr;
			else if( DCData && DCData.CTR_CLOSE_BTN ) counter = DCData.CTR_CLOSE_BTN;

			if( counter ) trackCounter( counter );
		}


		// ######################## EXPAND UNIT #############################
		/**
		 * This is the exact same as writing expanding.expand();.
		 * I'm moving all these events to one class to better organize them and add more functionality later.
		 * @param btn this is if your dropping it directly in the mouseManager which returns the button that was clicked.
		 * @param ctr this is a counter value, if it's passed a counter track will be fired.
		 * @param tmr this is a timer value, if it's passed a timer will start using this value.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.expandUnit( panel id );
		 * </listing>
		 */
		public static function expandUnit( btn:DisplayObject = null, ctr:String = "", tmr:String = ""  ):void
		{
			expanding.expand();

			var counter:String;
			var timer:String;

			if( ctr != "" ) counter = ctr;
			else if( DCData && DCData.CTR_EXPANDED ) counter = DCData.CTR_EXPANDED;

			if( tmr != "" ) timer = tmr;
			else if( DCData && DCData.TMR_EXPANSION ) timer = DCData.TMR_EXPANSION;

			if( counter ) trackCounter( counter );
			if( timer ) timerStart( timer );
		}


		// ######################## TIMER METHODS #############################
		/**
		 * Pass the string that you want tracked as a timer. This is the exact same as writing enabler.timerStart( value ).
		 * I'm moving all these events to one class to better organize them and add more functionality later. When you start a timer
		 * through this class it is added to a list where you can call one method to kill all the current running timers.
		 * @param id a String value to be tracked, must match up to an enabler.timerStart( id ) in the DCData AS file.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.timerStart( timer id );
		 * </listing>
		 */
		public static function timerStart( id:String ):void
		{
			timerList.push( id );
			enabler.startTimer( id );
		}


		/**
		 * This is the exact same as writing enabler.timerStop( value ).
		 * I'm moving all these events to one class to better organize them and add more functionality later. When you start a timer
		 * through this class it is added to a list where you can call one method to kill all the current running timers.
		 * @param id String value to be tracked, must match up to an enabler.timerStop( id ) in the DCData AS file.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.timerStop( timer id );</listing>
		 */
		public static function timerStop( id:String ):void
		{
			trace( "DC TRACKING MANAGER TIMER STOP :: " + id );

			removeTimerFromList( id );
			enabler.stopTimer( id );
		}


		/**
		 * This will stop all currently running timers provided they were started using timerStart in this class.
		 * @example
		 * <listing version="3.0">
		 * DCTrackingManager.stopAllTimers();
		 * </listing>
		 */
		public static function stopAllTimers():void
		{
			if( timerList.length == 0 ) return;

			var id:String;
			var length:uint = timerList.length;

			for( var i:uint = 0; i < length; i++ )
			{
				id = timerList[i];
				if( id ) enabler.stopTimer( id );
			}

			timerList = [];
		}


		private static function removeTimerFromList( id:String ):void
		{
			if( !id || !timerList || timerList.length == 0 ) return;

			var length:uint = timerList.length;

			for( var i:uint = 0; i < length; i++ )
			{
				if( id == timerList[i] )
				{
					timerList.splice( i, 1 );
				}
			}
		}
	}
}
