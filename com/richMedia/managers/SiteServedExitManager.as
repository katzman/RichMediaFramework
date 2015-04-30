/**
 * Created by nkatz on 4/1/15.
 */
package com.richMedia.managers
{

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;


	public class SiteServedExitManager
	{

		public static var stage:Stage;

		private static var exitList:Object = {};


		public static function addExit( btnId:String, clickTag:String, url:String ):void
		{
			if( !exitList ) exitList = {};
			exitList[btnId] = { clickTag:clickTag, url:url };
		}


		public static function exitClicked( btn:DisplayObject ):void
		{
			if( !btn ) return;

			var btnId:String = btn.name;
			var url:String;

			if( !exitList[btnId] ) return;

			if( exitList[btnId].clickTag )
			{
				url = getFlashVar( exitList[btnId].clickTag )
			}
			else if( exitList[btnId].url )
			{
				url = exitList[btnId].url;
			}

			if( url ) handleExit( url );
		}


		private static function getFlashVar( prop:String ):String
		{
			return stage.loaderInfo.parameters[prop];
		}


		private static function handleExit( url:String ):void
		{

			if( !url ) return;

			if( ExternalInterface.available )
			{
				try
				{
					ExternalInterface.call( "window.open", url, "_blank" );
				}
				catch( e:Error )
				{
					navigateToURL( new URLRequest( url ), "_blank" );
				}
			}
		}
	}
}
