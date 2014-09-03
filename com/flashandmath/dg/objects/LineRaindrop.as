/*

Altered version to be used for Dripping example.


Flash CS4 ActionScript 3 Tutorial by Dan Gries.

www.flashandmath.com.

Last modified August 22, 2009.

*/

package com.flashandmath.dg.objects {
	import flash.display.Sprite;
	import flash.geom.*;
	
	public class LineRaindrop extends Sprite {
				
		public var lifespan:int;
		public var breakawayTime:int;
				
		public var thickness:Number;
		
		public var pos:Point;		
		public var vel:Point;
		public var accel:Point;
		
		public var color:uint;
		
		//drawing points
		public var p0:Point;
		public var p1:Point;
		
		public var lastPos:Point;
		public var lastLastPos:Point;
		
		public var radiusWhenStill:Number;
		
		//The following attributes are for the purposes of creating a
		//linked list of LineRaindrop instances.
		public var next:LineRaindrop;
		public var prev:LineRaindrop;
		
		public var splashing:Boolean;
		public var atTerminalVelocity:Boolean;
		
		public function LineRaindrop(x0=0,y0=0) {
			super();
			lastPos = new Point(x0,y0);
			lastLastPos = new Point(x0,y0);
			pos = new Point(x0,y0);
			p0 = new Point(x0,y0);
			p1 = new Point(x0,y0);
			accel = new Point();
			vel = new Point();
			thickness = 1;
			color = 0xDDDDDD;
			splashing = true;
			atTerminalVelocity = false;
			radiusWhenStill = 1.5;
		}
		
		public function resetPosition(x0=0,y0=0) {
			lastPos = new Point(x0,y0);
			lastLastPos = new Point(x0,y0);
			pos = new Point(x0,y0);
			p0 = new Point(x0,y0);
			p1 = new Point(x0,y0);
		}
		
		public function redraw():void {
			this.graphics.clear();
			if (lifespan < breakawayTime) {
				this.graphics.beginFill(color);
				this.graphics.drawEllipse(p1.x-radiusWhenStill,p1.y-radiusWhenStill,2*radiusWhenStill,2*radiusWhenStill)
				this.graphics.endFill();
			}
			else {			
				this.graphics.lineStyle(thickness,color,1,false,"normal","none");
				this.graphics.moveTo(p0.x,p0.y);
				this.graphics.lineTo(p1.x,p1.y);
			}
		}
		
	}
}
			
		