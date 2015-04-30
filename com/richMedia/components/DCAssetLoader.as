package com.richMedia.components
{
	import com.richMedia.events.RmAdEvent;
	import com.google.ads.studio.display.StudioLoader;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;


	public class DCAssetLoader extends EventDispatcher
	{

		private var params      : Object;
		private var bitmap      : Bitmap;

		private var loader      : StudioLoader;
		private var urlReq      : URLRequest;
		private var context     : LoaderContext;
		private var path        : String;

		private var targetMC    : MovieClip;
		private var asset       : MovieClip;


		public function DCAssetLoader()
		{
			context  = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
		}


		public function loadSwf( _path:String, _target:MovieClip, _params:Object = null )
		{
			targetMC    = _target;
			params      = _params;

			loader      = new StudioLoader();
			urlReq      = new URLRequest( _path );

			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, swfLoadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.load( urlReq, context );
		}


		public function loadBitmap( _path:String, _target:MovieClip = null ):void
		{
			targetMC = _target;

			loader   = new StudioLoader();
			urlReq   = new URLRequest( _path );

			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, bitmapLoadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadError );

			loader.load( urlReq, context );
		}


		public function loadItem( _path:String, _target:MovieClip ):void
		{
			targetMC = _target;

			loader   = new StudioLoader();
			urlReq   = new URLRequest( _path );

			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, itemLoadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadError );

			loader.load( urlReq, context );
		}


		private function loadError( e:IOErrorEvent ):void
		{
			trace( "LOAD ERROR :: " + e );
			dispatchEvent( new RmAdEvent( RmAdEvent.ASSET_LOAD_ERROR, asset ));
		}


		public function destroy( e:Event = null ):void
		{
			trace( "\n\nASSET LOADER DESTROY CALLED\n\n" );

			if( loader ) loader.unload();

			if( bitmap && targetMC && targetMC.contains( bitmap )) targetMC.removeChild( bitmap );
			if( asset && targetMC && targetMC.contains( asset )) targetMC.removeChild( asset );

			loader = null;
			urlReq = null;
			asset = null;
			bitmap = null;
			targetMC = null;
			params = null;
		}


		private function itemLoadComplete( e:Event ):void
		{
			targetMC.addChild( loader );
			dispatchEvent( new RmAdEvent( RmAdEvent.ASSET_LOAD_COMPLETE, loader ));
		}


		private function swfLoadComplete( e:Event )
		{
			asset = e.target.content as MovieClip;
			passParams();
			if( targetMC ) targetMC.addChild( asset );

			dispatchEvent( new RmAdEvent( RmAdEvent.ASSET_LOAD_COMPLETE, asset ));
		}


		private function bitmapLoadComplete( e:Event )
		{
			bitmap = e.target.content as Bitmap;
			if( targetMC ) targetMC.addChild( bitmap );

			dispatchEvent( new RmAdEvent( RmAdEvent.ASSET_LOAD_COMPLETE, bitmap ));
		}


		private function passParams():void
		{
			if( !params ) return;

			var prop:Object;

			for ( prop in params )
			{
				trace( "PROP :: " + prop + "  VALUE :: " + params[prop] );
				asset[prop] = params[prop];
			}
		}
	}
}
