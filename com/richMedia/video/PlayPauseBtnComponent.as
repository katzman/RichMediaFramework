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
		private var broadcaster : EventBroadcaster;


		public function PlayPauseBtnComponent()
		{
			if( this.stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}


		private function init( e:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );

			broadcaster = EventBroadcaster.getInstance();
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

			broadcaster = null;
			playBtn_mc  = null;
			pauseBtn_mc = null;
		}


		private function updateBtn( e:RmVideoEvent ):void
		{
			if( e.data.playerID != playerID ) return;

			switch( e.type )
			{
				case RmVideoEvent.VIDEO_COMPLETE:
				case RmVideoEvent.VIDEO_PAUSED:
				case RmVideoEvent.VIDEO_STOPPED:
					playBtn_mc.visible = true;
					pauseBtn_mc.visible = false;
					isPaused = true;
					break;

				case RmVideoEvent.VIDEO_PLAYING:
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
			broadcaster.dispatchEvent( new RmVideoEvent( RmVideoEvent.PLAY_VIDEO, {playerID:playerID} ));
		}


		private function pauseVideo():void
		{
			broadcaster.dispatchEvent( new RmVideoEvent( RmVideoEvent.PAUSE_VIDEO, {playerID:playerID} ));
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

			broadcaster.addEventListener( RmVideoEvent.VIDEO_COMPLETE, updateBtn );
			broadcaster.addEventListener( RmVideoEvent.VIDEO_PAUSED,   updateBtn );
			broadcaster.addEventListener( RmVideoEvent.VIDEO_PLAYING,  updateBtn );
			broadcaster.addEventListener( RmVideoEvent.VIDEO_STOPPED,  updateBtn );
		}


		private function removeListeners():void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE,  destroy );
			removeEventListener( MouseEvent.CLICK,          btnEvent );
			removeEventListener( MouseEvent.ROLL_OVER,      btnEvent );
			removeEventListener( MouseEvent.ROLL_OUT,       btnEvent );

			broadcaster.removeEventListener( RmVideoEvent.VIDEO_COMPLETE, updateBtn );
			broadcaster.removeEventListener( RmVideoEvent.VIDEO_PAUSED,   updateBtn );
			broadcaster.removeEventListener( RmVideoEvent.VIDEO_PLAYING,  updateBtn );
			broadcaster.removeEventListener( RmVideoEvent.VIDEO_STOPPED,  updateBtn );
		}
	}
}