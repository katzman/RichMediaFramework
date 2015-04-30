/** AudioBtnComponent
 * -------------------------------------------------------------------------------------
 * @ description: Audio button component built to work with video players
 * @ usage: refer to documentation for usage.
 * @ developer: Neil Katz
 * @ version: 1.0.0  02.13.2014
 * -------------------------------------------------------------------------------------
 * */

package com.richMedia.video
{
	import com.richMedia.constants.Constants;
	import com.richMedia.events.RmVideoEvent;
	import com.richMedia.managers.NotificationManager;

	import flash.display.MovieClip;
	import com.richMedia.events.EventBroadcaster;

	import flash.events.Event;
	import flash.events.MouseEvent;


	public class AudioBtnComponent extends MovieClip
	{
		public var audioToggle_mc   : MovieClip;
		public var playerID         : String = Constants.PLAYER_DEFAULT_ID;

		private var isMuted         : Boolean;
		//private var broadcaster     : EventBroadcaster;


		public function AudioBtnComponent()
		{
			if( this.stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}


		private function init( e:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );

			//broadcaster = EventBroadcaster.getInstance();
			audioToggle_mc = this["audioToggle_mc"];

			this.buttonMode = true;
			this.mouseChildren = false;
			setListeners();
		}


		private function destroy( e:Event ):void
		{
			removeListeners();

			//broadcaster = null;
			audioToggle_mc = null;
		}


		private function updateBtn( obj:Object ):void
		{
			trace( "UPDATE SOUND BUTTON CALLED :: PLAYER ID: " + playerID + "    EVENT PLAYER ID: " + obj.data.playerID + "    EVENT TYPE: " + obj.interest );

			if( obj.data.playerID != playerID ) return;

			switch( obj.interest )
			{
				case RmVideoEvent.VIDEO_MUTED:
					audioToggle_mc.gotoAndStop ( "off" );
					isMuted = true;
					break;

				case RmVideoEvent.VIDEO_UNMUTED:
					audioToggle_mc.gotoAndStop ( "on" );
					isMuted = false;
					break;
			}
		}


		private function btnEvent( e:MouseEvent ):void
		{
			switch( e.type )
			{
				case MouseEvent.CLICK:
					if( isMuted ) unMute();
					else mute();
					break;

				case MouseEvent.ROLL_OVER:
					btnOver();
					break;

				case MouseEvent.ROLL_OUT:
					btnOut();
					break;
			}
		}


		private function unMute():void
		{
			//broadcaster.dispatchEvent( new RmVideoEvent( RmVideoEvent.UNMUTE_VIDEO, {playerID:playerID} ));
			NotificationManager.sendNotification( RmVideoEvent.UNMUTE_VIDEO, {playerID:playerID} );
		}


		private function mute():void
		{
			//broadcaster.dispatchEvent( new RmVideoEvent( RmVideoEvent.MUTE_VIDEO, {playerID:playerID} ));
			NotificationManager.sendNotification( RmVideoEvent.MUTE_VIDEO, {playerID:playerID} );
		}


		private function btnOver():void
		{
			this.gotoAndStop( "over" );
		}


		private function btnOut():void
		{
			this.gotoAndStop( "out" );
		}


		private function setListeners():void
		{
			addEventListener( MouseEvent.CLICK,     btnEvent );
			addEventListener( MouseEvent.ROLL_OVER, btnEvent );
			addEventListener( MouseEvent.ROLL_OUT,  btnEvent );

			NotificationManager.regisiterNotificationInterest( RmVideoEvent.VIDEO_MUTED, updateBtn );
			NotificationManager.regisiterNotificationInterest( RmVideoEvent.VIDEO_UNMUTED, updateBtn );
		}


		private function removeListeners():void
		{
			removeEventListener( MouseEvent.CLICK,      btnEvent );
			removeEventListener( MouseEvent.ROLL_OVER,  btnEvent );
			removeEventListener( MouseEvent.ROLL_OUT,   btnEvent );

			NotificationManager.removeNotificationInterest( RmVideoEvent.VIDEO_MUTED, updateBtn );
			NotificationManager.removeNotificationInterest( RmVideoEvent.VIDEO_UNMUTED, updateBtn );
		}
	}
}