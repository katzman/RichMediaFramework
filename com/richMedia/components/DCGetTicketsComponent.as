/**
 * Created by nkatz on 4/22/15.
 */


package com.richMedia.components
{

	import com.richMedia.events.RmAdEvent;
	import com.richMedia.managers.MouseEventManager;
	import com.google.ads.studio.ProxyEnabler;
	import com.richMedia.managers.doubleclick.DCTrackingManager;

	import flash.display.DisplayObject;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;


	public class DCGetTicketsComponent extends MovieClip
	{
		public var closeOnExit  : Boolean;

		private var mouseManager: MouseEventManager;
		private var enabler     : ProxyEnabler = ProxyEnabler.getInstance();
		private var zip         : String = "";
		private var zipInput_txt: TextField;
		private var initText    : String = "";


		public function DCGetTicketsComponent()
		{
			if( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}


		public function init( e:Event = null ):void
		{
			mouseManager = new MouseEventManager( this );
			mouseManager.addButtons( ['moviefone_btn','movietickets_btn','fandango_btn'], getTickets );

			addEventListener( Event.REMOVED_FROM_STAGE, destroy );

			setInput();
		}


		public function destroy( e:Event = null ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, destroy );

			if( mouseManager ) mouseManager.destroy();
			if( zipInput_txt )
			{
				zipInput_txt.removeEventListener( FocusEvent.FOCUS_IN, handleZipFocusIn );
				zipInput_txt.removeEventListener( Event.CHANGE, handleZipInput );
				zipInput_txt = null;
			}

			enabler = null;
		}


		private function setInput():void
		{
			if( !this['zip_txt'] ) return;

			zipInput_txt = this['zip_txt'];
			initText = zipInput_txt.text;
			zipInput_txt.restrict = "0-9";
			zipInput_txt.maxChars = 5;
			zipInput_txt.addEventListener( FocusEvent.FOCUS_IN, handleZipFocusIn );
			zipInput_txt.addEventListener( Event.CHANGE, handleZipInput );
		}


		private function getTickets( btn:DisplayObject ):void
		{
			if( !btn ) return;

			zip = zipInput_txt.text;

			switch( btn.name )
			{
				case 'moviefone_btn':
					enabler.exitQueryString( DCData.EXIT_MOVIEFONE, 'locationQuery=' + zip );
					break;

				case 'movietickets_btn':
					enabler.exitQueryString( DCData.EXIT_MOVIETICKETS, 'SearchZip=' + zip + '&movie_id=' + DCData.MOVIETICKETS_ID );
					break;

				case 'fandango_btn':
					enabler.exitQueryString( DCData.EXIT_FANDANGO, 'location=' + zip );
					break;
			}

			if( closeOnExit ) DCTrackingManager.collapseUnit( true );
			dispatchEvent( new RmAdEvent( RmAdEvent.CLICK_FIRED ));
		}


		private function handleZipFocusIn( e:FocusEvent ):void
		{
			if( zipInput_txt.text == initText ) zipInput_txt.text = "";
		}


		private function handleZipInput( e:Event ):void
		{
			var enabled:Boolean = zipInput_txt.length == 5;
			setEnabled( this['moviefone_btn'], enabled );
			setEnabled( this['movietickets_btn'], enabled );
			setEnabled( this['fandango_btn'], enabled );
		}


		private function setEnabled( _btn:DisplayObject, _isEnabled:Boolean ):void
		{
			var btn:SimpleButton = _btn as SimpleButton;

			if( !btn ) return;
			btn.mouseEnabled = _isEnabled;
			btn.alpha = ( _isEnabled ) ? 1 : .5;
		}
	}
}
