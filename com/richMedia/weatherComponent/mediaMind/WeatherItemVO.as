package com.richMedia.weatherComponent.mediaMind
{
	import com.richMedia.weatherComponent.mediaMind.WeatherBlock;
		
	
	public class WeatherItemVO
	{
		public var minTempF			: String;
		public var maxTempF			: String;
		public var tempF			: String;
		public var avgTempF			: String;
		public var feelslikeF		: String;
		
		public var minTempC			: String;
		public var maxTempC			: String;
		public var tempC			: String;
		public var avgTempC			: String;
		public var feelslikeC		: String;
		
		public var weather			: String;
		public var isDay			: String;
		
		public var windSpeedMPH		: String;
		public var windSpeedKPH		: String;
		
		public var cloudsCoded		: String;
		public var weatherPrimary	: String;
		public var weatherCoded		: String;
		
		public var dateTimeISO		: String;
		public var validTime		: String;
		public var timeStamp		: String;
		
		public var dayNumber		: String;
		public var dayName			: String;
		public var monthNumber		: String;
		public var monthName		: String;
		public var year				: String;
		
		private var weatherCold		: int = 50;
        private var weatherCloudy	: int = 60;
		private var weatherHot		: int = 80;
		
		
		public function WeatherItemVO() {}
		
		
		public function setValues ( obj:Object ):void 
		{
			//trace_r( obj );

            minTempF		= obj[WeatherBlock.MIN_TEMP_F];
			maxTempF		= obj[WeatherBlock.MAX_TEMP_F];	
			tempF			= ( obj[WeatherBlock.TEMP_F] && obj[WeatherBlock.TEMP_F] != "null" ) ? obj[WeatherBlock.TEMP_F] : obj[WeatherBlock.AVG_TEMP_F];
			avgTempF		= obj[WeatherBlock.AVG_TEMP_F];
			feelslikeF		= obj[WeatherBlock.FEELS_LIKE_F];
			
			minTempC		= obj[WeatherBlock.MIN_TEMP_C];
			maxTempC		= obj[WeatherBlock.MAX_TEMP_C];
			tempC			= ( obj[WeatherBlock.TEMP_C] && obj[WeatherBlock.TEMP_C] != "null" ) ? obj[WeatherBlock.TEMP_C] : obj[WeatherBlock.AVG_TEMP_C];
			avgTempC		= obj[WeatherBlock.AVG_TEMP_C];
			feelslikeC		= obj[WeatherBlock.FEELS_LIKE_C];
						
			weatherCoded	= obj[WeatherBlock.WEATHER_CODED];
			weatherPrimary	= obj[WeatherBlock.WEATHER_PRIMARY];
			isDay			= obj[WeatherBlock.IS_DAY];
			
			windSpeedMPH	= obj[WeatherBlock.WINDSPD_MPH];	
			windSpeedKPH	= obj[WeatherBlock.WINDSPD_KPH];	
			
			cloudsCoded		= obj[WeatherBlock.CLOUDS_CODED];
			
			dateTimeISO		= obj[WeatherBlock.DATE_TIME_ISO];
			validTime		= obj[WeatherBlock.VALID_TIME];
			timeStamp		= obj[WeatherBlock.TIME_STAMP];
			
			setDateValues();
			setWeatherValues();
		}


        public function get dataValues():String
        {
            var data:String = "";
            data += "TEMP F: " + tempF + "\n";
            data += "TEMP C: " + tempC + "\n";
            data += "SWITCH CODE: " + weatherCoded.split( ":" )[2] + "\n";
            data += "CURRENT WEATHER: " + weather + "\n";

            return data;
        }
		
		
		private function setDateValues():void 
		{			
			var days:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
			var months:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
			
			var tempDate:String = validTime || dateTimeISO;
			var date:String =  tempDate.toLowerCase().split ( "t" )[0];
			var dateArray = date.split( "-" );
			
			dayNumber = dateArray[2];			
			monthNumber = dateArray[1];
			year = dateArray[0];
			
			var dateObj:Date = new Date( year, ( int( monthNumber ) -1), dayNumber );			
			dayName = days[ int ( dateObj.day ) ];
			monthName = months[ int ( dateObj.month ) ];
		}
		
		
		private function setWeatherValues():void 
		{
			var code:String = weatherCoded.split( ":" )[2] as String;
			
			trace( "SET WEATHER VALUES :: CODE: " + code + "    CODED: " + weatherCoded );
			
			switch ( code.toUpperCase() )
			{
				case "BD":	// blowing dust
				case "BN":	// blowing sand
				case "BS":	// blowing snow - this we may want to remove
				case "WP":	// water spouts
					// wind
					weather = WeatherBlock.TYPE_WIND;
					break;
				
				case "SC":	// partly cloudy
				case "BK":	// mostly cloudy
				case "OV":	// cloudy
				case "H":	// haze
				case "BR": 	// mist
				case "F":	// fog
				case "IF":	// ice fog
				case "VA":	// volcanic ash
				case "ZF": 	// freezing fog
				case "K":	// smoke
					// cloudy
                    if( int(tempF) <= weatherCloudy ) weather = WeatherBlock.TYPE_CLOUDY;
                    else weather = WeatherBlock.TYPE_DEFAULT;
					break;
				
				case "CL": 	// clear
				case "FW":	// fair/mostly sunny
					// sunny;
					if ( int(tempF) <= weatherCold )
					{
						weather = WeatherBlock.TYPE_COLD;
					}
					else if ( int(tempF) >= weatherHot )
					{
						//weather = WeatherBlock.TYPE_HOT; // not currently serving hot yet. 
						weather = WeatherBlock.TYPE_DEFAULT;
					}
					else
					{
						weather = WeatherBlock.TYPE_DEFAULT;
					}
					break;
								
				case "R":	// rain
				case "L":	// drizzle
				case "RW":	// rain showers
				case "RS":	// rain/snow mix
				case "ZL":	// freezing drizzle
				case "ZR":	// freezing rain
				case "T":	// thunderstorms
				case "ZY":	// freezing spray
					// rain
					weather = WeatherBlock.TYPE_RAIN;
					break;
								
				case "S":	// snow
				case "SW":	// snow showers
				case "SI":	// snow/sleet mix
				case "FR":	// frost
				case "IC":	// ice crystals
				case "WM":	// wintry mix
					// snow
					weather = WeatherBlock.TYPE_SNOW;
					break;
				
				case "R":	// hail
				case "IP":	// ice pellets / sleet
					// hail
					//weather = WeatherBlock.TYPE_HAIL; // dont currently have creative for hail
					weather = WeatherBlock.TYPE_DEFAULT;
					break;
				
				default:
					// default value
					weather = WeatherBlock.TYPE_DEFAULT;
					break;
			}
			
			trace ( "SET WEATHER VALUES :: WEATHER: " + weather + "   CODE: " + code.toUpperCase() ); 
			
			/*
			//Weather Codes
			//cloud codes
			--CL	Clear	
			--FW	Fair/mostly sunny	
			--SC	Partly cloudy	
			--BK	Mostly cloudy	
			--OV	Cloudy	
			
			--A		Hail	
			--BD	Blowing dust	
			--BN	Blowing sand	
			--BR	Mist	
			--BS	Blowing snow	
			--F		Fog	
			--FR	Frost	
			--H		Haze	
			--IC	Ice crystals	
			--IF	Ice fog	
			--IP	Ice pellets / sleet	
			--K		Smoke	
			--L		Drizzle	
			--R		Rain	
			--RW	Rain showers	
			--RS	Rain/snow mix	
			--SI	Snow/sleet mix	
			--WM	Wintry mix	
			--S		Snow	
			--SW	Snow showers	
			--T		Thunderstorms	
			UP		Unknown Precipitation	
			--VA	Volcanic ash	
			--WP	Water spouts	
			--ZF	Freezing fog	
			--ZL	Freezing drizzle	
			--ZR	Freezing rain	
			--ZY	Freezing spray
			*/
		}
	}
}