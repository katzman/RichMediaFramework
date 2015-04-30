/**
 * Created by nkatz on 3/31/15.
 */
package com.richMedia.ui.buttons
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class FrameAnimationBtn extends MovieClip
	{
		public var disableRollOut   : Boolean;

		private var frameLabels     : Array = [];


		public function FrameAnimationBtn()
		{
			if( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}


		/*------------------------- PUBLIC FUNCTIONS -------------------------*/
		public function enable():void
		{
			setup();
			showEnabled();
		}


		public function disable():void
		{
			setup( false );
			showDisabled();
		}


		/*------------------------- PRIVATE FUNCTIONS -------------------------*/
		private function init( e:Event = null ):void
		{
			mouseChildren = false;
			gotoAndStop( 1 );
			setFramelabels();
			setup();
			addListeners();
		}


		private function setFramelabels():void
		{
			var label:FrameLabel;
			var length:uint = this.currentLabels.length;

			for( var i:uint = 0; i < length; i++ )
			{
				label = this.currentLabels[i];
				frameLabels.push( label.name );
			}
		}


		private function hasFramelabel( label:String ):Boolean
		{
			if( !frameLabels ) setFramelabels();
			if( frameLabels.indexOf( label ) > -1 ) return true;
			return false;
		}


		private function setup( active:Boolean = true ):void
		{
			buttonMode = active;
			mouseEnabled = active;
			enabled = active;
		}


		public function rollOver( event:MouseEvent = null ) : void
		{
			if( !enabled ) return;
			if( currentFrame < totalFrames ) play();
		}


		public function rollOut( event:MouseEvent = null, force:Boolean = false ) : void
		{
			if(( disableRollOut && !force ) || !enabled ) return;

			removeEventListener( Event.ENTER_FRAME, reverse );
			addEventListener( Event.ENTER_FRAME, reverse );
		}


		private function showDisabled():void
		{
			if( !hasFramelabel( 'disabled' )) return;
			gotoAndStop( 'disabled' );
		}


		private function showEnabled():void
		{
			gotoAndStop( 1 );
		}


		private function reverse( e:Event ):void
		{
			if ( currentFrame > 1 )
			{
				prevFrame();
			}
			else
			{
				removeEventListener( Event.ENTER_FRAME, reverse );
			}
		}


		private function addListeners():void
		{
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			addEventListener( MouseEvent.ROLL_OVER, rollOver );
			addEventListener( MouseEvent.ROLL_OUT, rollOut );
		}


		private function removeListeners():void
		{
			removeEventListener( Event.ENTER_FRAME, reverse );
			removeEventListener( Event.REMOVED_FROM_STAGE, destroy );
			removeEventListener( MouseEvent.ROLL_OVER, rollOver );
			removeEventListener( MouseEvent.ROLL_OUT, rollOut );
		}


		private function destroy( e:Event ) : void
		{
			e.stopImmediatePropagation();
			removeListeners();
		}
	}
}
