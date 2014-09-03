/** LibResourceManager
 * -------------------------------------------------------------------------------------
 * @ description: for sharing library assets across multiple swfs in the same domain
 * @ usage: var bgMc:MovieClip = LibResourceManager.getMovieClip( "BgAnimation" );
 * @ developer: Neil Katz
 * @ version: 1.0.0  02.13.2014
 * -------------------------------------------------------------------------------------
 * */


package com.blt.components
{


    public class GlobalDataHolder
	{

        private static var data : Object;


        public static function setData( id:String, value:* ):void
        {
            if( !data ) data = {};
            data[id] = value;
        }


        public static function getData( id:String ):*
        {
            if( !data || !data[id] ) return null;
            return data[id];
        }
    }
}