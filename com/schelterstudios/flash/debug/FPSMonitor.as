package com.schelterstudios.flash.debug{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class FPSMonitor extends Bitmap{
		
		private static const PADDING:int = 1;
		private var oldTimer:int = 0;
		
		public function FPSMonitor(){
			super(new BitmapData(200, 25, false, 0xff000000));
		}
		
		public function start():void{
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function stop():void{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(evt:Event):void{
			var timer:int = getTimer();
			var fps:Number = Math.round(10000/(timer-oldTimer)) / 10;
			oldTimer = timer;
			
			var p:Number = Math.min(fps/stage.frameRate, 1);
			var h:Number = (height-PADDING*2) * p;
			var c:Number = 0xff * p;
			bitmapData.scroll(1, 0);
			bitmapData.fillRect(new Rectangle(0, 0, 1, height), 0x000000);
			bitmapData.fillRect(new Rectangle(width-PADDING, 0, PADDING, height), 0x000000);
			bitmapData.fillRect(new Rectangle(PADDING, height-h-PADDING, 1, h), 0xff0000 | c << 8 | c);
		}
	}
}