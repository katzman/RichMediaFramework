/** PlayPauseBtnComponent
 * -------------------------------------------------------------------------------------
 * @ description: Play pause video button component built to work with video players.
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


	public class PlayPauseBtnComponent extends MovieClip
	{

		public var playerID     : String = Constants.PLAYER_DEFAULT_ID;

		public var playBtn_mc   : MovieClip;
		public var pauseBtn_mc  : MovieClip;

		private var isPaused    : Boolean;
		//private var broadcaster : EventBroadcaster;


		public function PlayPauseBtnComponent()
		{
			if( this.stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}


		private function init( e:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );

			//broadcaster = EventBroadcaster.getInstance();
			setListeners();

			this.mouseChildren = false;
			this.buttonMode = true;

			playBtn_mc = this["playBtn_mc"];
			pauseBtn_mc = this["pauseBtn_mc"];

			playBtn_mc.visible = false;
			pauseBtn_mc.visible = true;
		}


		private function destroy( e:Event ):void
		{
			removeListeners();

			//broadcaster = null;
			playBtn_mc  = null;
			pauseBtn_mc = null;
		}


		private function updateBtn(  obj:Object  ):void
		{
			if( obj.data.playerID != playerID ) return;

			switch( obj.interest )
			{
				case RmVideoEvent.VIDEO_COMPLETE:
				case RmVideoEvent.VIDEO_PAUSED:
				case RmVideoEvent.VIDEO_STOPPED:
					playBtn_mc.visible = true;
					pauseBtn_mc.visible = false;
					isPaused = true;
					break;

				case RmVideoEvent.VIDEO_PLAYING:
                case RmVideoEvent.PLAY_WITH_SOUND_CALLED:
					playBtn_mc.visible = false;
					pauseBtn_mc.visible = true;
					isPaused = false;
					break;
			}
		}


		private function btnEvent( e:MouseEvent ):void
		{
			switch( e.type )
			{
				case MouseEvent.CLICK:
					if( isPaused ) playVideo();
					else pauseVideo();
					break;

				case MouseEvent.ROLL_OVER:
					btnOver();
					break;

				case MouseEvent.ROLL_OUT:
					btnOut();
					break;
			}
		}


		private function playVideo():void
		{
			NotificationManager.sendNotification( RmVideoEvent.PLAY_VIDEO, {playerID:playerID} );
		}


		private function pauseVideo():void
		{
			NotificationManager.sendNotification( RmVideoEvent.PAUSE_VIDEO, {playerID:playerID} );
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
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			addEventListener( MouseEvent.CLICK,         btnEvent );
			addEventListener( MouseEvent.ROLL_OVER,     btnEvent );
			addEventListener( MouseEvent.ROLL_OUT,      btnEvent );

			NotificationManager.regisiterNotificationInterest( RmVideoEvent.VIDEO_COMPLETE, updateBtn );
			NotificationManager.regisiterNotificationInterest( RmVideoEvent.VIDEO_PAUSED, updateBtn );
			NotificationManager.regisiterNotificationInterest( RmVideoEvent.VIDEO_PLAYING, updateBtn );
			NotificationManager.regisiterNotificationInterest( RmVideoEvent.VIDEO_STOPPED, updateBtn );
			NotificationManager.regisiterNotificationInterest( RmVideoEvent.PLAY_WITH_SOUND_CALLED, updateBtn );
		}


		private function removeListeners():void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE,  destroy );
			removeEventListener( MouseEvent.CLICK,          btnEvent );
			removeEventListener( MouseEvent.ROLL_OVER,      btnEvent );
			removeEventListener( MouseEvent.ROLL_OUT,       btnEvent );

			NotificationManager.removeNotificationInterest( RmVideoEvent.VIDEO_COMPLETE, updateBtn );
			NotificationManager.removeNotificationInterest( RmVideoEvent.VIDEO_PAUSED, updateBtn );
			NotificationManager.removeNotificationInterest( RmVideoEvent.VIDEO_PLAYING, updateBtn );
			NotificationManager.removeNotificationInterest( RmVideoEvent.VIDEO_STOPPED, updateBtn );
			NotificationManager.removeNotificationInterest( RmVideoEvent.PLAY_WITH_SOUND_CALLED, updateBtn );
		}
	}
}