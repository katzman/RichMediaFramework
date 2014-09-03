/** LibResourceManager
 * -------------------------------------------------------------------------------------
 * @ description: for sharing library assets across multiple swfs in the same domain
 * @ usage: var bgMc:MovieClip = LibResourceManager.getMovieClip( "BgAnimation" );
 * @ developer: Neil Katz
 * @ version: 2.0.0  02.13.2014
 * -------------------------------------------------------------------------------------
 * */


package com.richMedia.managers
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;


    public class LibResourceManager
	{
        /**
         * @description grab linked images from any loaded swfs library, the id is the linkage value
         * @param id
         * @return Bitmap
         */
        public static function getBitmap( id:String ):Bitmap
        {
            var imageDataClass:Class = Class( getDefinitionByName( id ) );
	        if( !imageData ) return null;

            var imageData:BitmapData = new imageDataClass() as BitmapData;
            var image:Bitmap = new Bitmap( imageData );

            return image;
        }


        /**
         * @description grab linked MovieClips from any loaded swfs library, the id is the linkage value
         * @param id
         * @return MovieClip
         */
        public static function getMovieClip( id:String ):MovieClip
        {
            var mcClass:Class = Class( getDefinitionByName( id ) );
	        if( !mcClass ) return null;

            var mc:MovieClip = new mcClass() as MovieClip;

            return mc;
        }


        /**
         * @description grab any linked items from any loaded swfs library, the id is the linkage value.
         * This should cover any object in the library, just need to make sure and type it when loaded.
         * @param id
         * @return Object
         */
        public static function getObject( id:String ):Object
        {
            var objClass:Class = Class( getDefinitionByName( id ));
	        if( !objClass ) return null;

            var obj:Object = new objClass() as Object;

            return obj;
        }
    }
}