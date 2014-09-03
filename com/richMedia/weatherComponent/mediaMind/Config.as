package com.blt.weatherComponent.mediaMind
{
    import com.blt.weatherComponent.mediaMind.WeatherBlock;


	public class Config	
	{	
		// Override GEO Script and hardcode City
		public static const GEO_OVERRIDE_CITY:String = "";
		
		// Override GEO Script and hardcode STATE
		public static const GEO_OVERRIDE_STATE:String = "";
		
		// Weather API Icons Server Policy 
		public static const WTHR_ICON_SVR:String = "";
		
		// Weather API Icons Link 
		public static const WTHR_ICON_STRING:String = "http://hosting.serving-sys.com/Blocks/weatherBlock/weather_icons/";
		
		// Weather API Client ID 
		public static const WTHR_CLIENT_ID_STRING:String = "7iWWuqhapqrIGgc9i1hLJ";
		
		// Weather API Client Secret 
		public static const WTHR_CLIENT_SECRET_STRING:String = "alDf16bbmNVur2dCBwHgPRFsylm6kXtkAwNH3xmq";										
		// Location of Weather API Script
		public static const WTHR_SVR_STRING:String = "";


        //_obj.response.responses[1].response.ob
        //_obj.response.responses[2].response[0].periods[1]
        //_obj.response.responses[2].response[0].periods[2]
        //_obj.response.responses[0].response.place
        public static function get TestData():Object
        {
            var obj:Object = {};
            obj.success = true;
            obj.response = {};
            obj.response.responses = [];
            obj.response.responses[0] = { response:{ place:{ name:"LOS ANGELES" }}};
            obj.response.responses[1] = { response:{ ob:{} } };
            obj.response.responses[2] = { response:[] };

            var periods:Array = [];

            var day1:Object = {};
            day1[WeatherBlock.MIN_TEMP_F] = 1;
            day1[WeatherBlock.MAX_TEMP_F] = 24;
            day1[WeatherBlock.TEMP_F] = 42;
            day1[WeatherBlock.AVG_TEMP_F] = 30;
            day1[WeatherBlock.FEELS_LIKE_F] = 30;
            day1[WeatherBlock.MIN_TEMP_C] = 10;
            day1[WeatherBlock.MAX_TEMP_C] = 40;
            day1[WeatherBlock.TEMP_C] = 30;
            day1[WeatherBlock.AVG_TEMP_C] = 30;
            day1[WeatherBlock.FEELS_LIKE_C] = 25;
            day1[WeatherBlock.WEATHER_CODED] = '::OV';
            day1[WeatherBlock.WEATHER_PRIMARY] = '';
            day1[WeatherBlock.IS_DAY] = '';
            day1[WeatherBlock.WINDSPD_MPH] = '';
            day1[WeatherBlock.WINDSPD_KPH] = '';
            day1[WeatherBlock.CLOUDS_CODED] = '';
            day1[WeatherBlock.DATE_TIME_ISO] = '';
            day1[WeatherBlock.VALID_TIME] = '';
            day1[WeatherBlock.TIME_STAMP] = '';

            var day2:Object = {};
            day2[WeatherBlock.MIN_TEMP_F] = 2;
            day2[WeatherBlock.MAX_TEMP_F] = 24;
            day2[WeatherBlock.TEMP_F] = 42;
            day2[WeatherBlock.AVG_TEMP_F] = 30;
            day2[WeatherBlock.FEELS_LIKE_F] = 30;
            day2[WeatherBlock.MIN_TEMP_C] = 10;
            day2[WeatherBlock.MAX_TEMP_C] = 40;
            day2[WeatherBlock.TEMP_C] = 30;
            day2[WeatherBlock.AVG_TEMP_C] = 30;
            day2[WeatherBlock.FEELS_LIKE_C] = 25;
            day2[WeatherBlock.WEATHER_CODED] = '::FR';
            day2[WeatherBlock.WEATHER_PRIMARY] = '';
            day2[WeatherBlock.IS_DAY] = '';
            day2[WeatherBlock.WINDSPD_MPH] = '';
            day2[WeatherBlock.WINDSPD_KPH] = '';
            day2[WeatherBlock.CLOUDS_CODED] = '';
            day2[WeatherBlock.DATE_TIME_ISO] = '';
            day2[WeatherBlock.VALID_TIME] = '';
            day2[WeatherBlock.TIME_STAMP] = '';

            var day3:Object = {};
            day3[WeatherBlock.MIN_TEMP_F] = 3;
            day3[WeatherBlock.MAX_TEMP_F] = 24;
            day3[WeatherBlock.TEMP_F] = 42;
            day3[WeatherBlock.AVG_TEMP_F] = 30;
            day3[WeatherBlock.FEELS_LIKE_F] = 30;
            day3[WeatherBlock.MIN_TEMP_C] = 10;
            day3[WeatherBlock.MAX_TEMP_C] = 40;
            day3[WeatherBlock.TEMP_C] = 30;
            day3[WeatherBlock.AVG_TEMP_C] = 30;
            day3[WeatherBlock.FEELS_LIKE_C] = 25;
            day3[WeatherBlock.WEATHER_CODED] = '::SW';
            day3[WeatherBlock.WEATHER_PRIMARY] = '';
            day3[WeatherBlock.IS_DAY] = '';
            day3[WeatherBlock.WINDSPD_MPH] = '';
            day3[WeatherBlock.WINDSPD_KPH] = '';
            day3[WeatherBlock.CLOUDS_CODED] = '';
            day3[WeatherBlock.DATE_TIME_ISO] = '';
            day3[WeatherBlock.VALID_TIME] = '';
            day3[WeatherBlock.TIME_STAMP] = '';

            periods[0] = null;
            periods[1] = day2;
            periods[2] = day3;

            obj.response.responses[1].response.ob = day1;
            obj.response.responses[2].response[0] = {periods:periods};

            return obj;
        }
    }
}


