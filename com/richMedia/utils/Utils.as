package com.richMedia.utils
{
	public class Utils
	{
		
		import flash.system.Capabilities;
		
		public static const	PLAYER_AIR		: String = "airPlayer";
		public static const	PLAYER_PLUGIN	: String = "pluginPlayer";
		public static const	PLAYER_IDE		: String = "idePlayer";
		
		
		public static function getPlayerType():String
		{			
			var pType:String = String(Capabilities.playerType);				
			var type:String;
			
			switch ( pType.toLowerCase() )
			{
				case "plugin":
				case "activex": // swf is running a browser						
					type = PLAYER_PLUGIN;			
					break;
				
				case "desktop": // swf is running in a desktop AIR application
					type = PLAYER_AIR;
					break;
				
				case "standalone": // swf is running in a standalone Flash Player						
				case "external": // swf is running in the Flash IDE preview player						
					type = PLAYER_IDE;
					break;
			}
			
			return type;
		}


		public static function formatTime ( _seconds:Number ):String
		{
			var seconds:Number = Math.floor( _seconds);
			var minutes:Number = Math.floor( seconds / 60);

			seconds %= 60;
			minutes %= 60;

			var sec:String = seconds.toString();
			var min:String = minutes.toString();

			if (sec.length < 2) sec = "0" + sec;
			if (min.length < 2) min = "0" + min;

			return ( min + ":" + sec );
		}
	}
}