/**
 * CollisionEngine by Grant Skinner. Aug 5, 2005
 * Visit www.gskinner.com/blog for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2011 Grant Skinner
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

class com.gskinner.sprites.CollisionEngine {
	// public properties:
	public var gridSize:Number = 70;
	
	// private properties:
	private var mcs:Array;
	private var pos:Array;
	
	// initialization:
	public function CollisionEngine() {
		mcs = [];
		pos = [];
		
		// testing:
		_root.lineStyle(0,0,10);
		var y = 0;
		while (y<400) {
			_root.moveTo(0,y);
			_root.lineTo(550,y);
			y += gridSize;
		}
		var x = 0;
		while (x<550) {
			_root.moveTo(x,0);
			_root.lineTo(x,400);
			x += gridSize;
		}
	}
	
	// public methods:
	public function getNeighbours(p_mc:MovieClip):Array {
		return getNeighboursAt(Math.ceil(p_mc._x/gridSize),Math.ceil(p_mc._y/gridSize));
	}
	
	public function getNeighboursAt(p_x:Number,p_y:Number):Array {
		
		var p:Array = pos;
		var r:Array = [];
		
		if (p[p_x][p_y]) { r = r.concat(p[p_x][p_y]); }
		
		if (p[p_x-1][p_y-1]) { r = r.concat(p[p_x-1][p_y-1]); }
		if (p[p_x][p_y-1]) { r = r.concat(p[p_x][p_y-1]); }
		if (p[p_x+1][p_y-1]) { r = r.concat(p[p_x+1][p_y-1]); }
		
		if (p[p_x-1][p_y]) { r = r.concat(p[p_x-1][p_y]); }
		if (p[p_x+1][p_y]) { r = r.concat(p[p_x+1][p_y]); }
		
		if (p[p_x-1][p_y+1]) { r = r.concat(p[p_x-1][p_y+1]); }
		if (p[p_x][p_y+1]) { r = r.concat(p[p_x][p_y+1]); }
		if (p[p_x+1][p_y+1]) { r = r.concat(p[p_x+1][p_y+1]); }
		return r;
	}
	
	public function checkCollision(p_mc:MovieClip,p_alphaTolerance:Number):MovieClip {
		var p_scope:MovieClip = _root;
		
		var x:Number = Math.ceil(p_mc._x/gridSize);
		var y:Number = Math.ceil(p_mc._y/gridSize);
		
		var a:Array = getNeighboursAt(x,y);
		if (a.length < 1) { return null; }
		
		if (p_alphaTolerance == undefined) { p_alphaTolerance = 255; }
		
		// get bounds of target:
		var bounds1:Object = p_mc.getBounds(p_scope);
		// get bounds of grid:
		var bounds2:Object = {xMin:(x-2)*gridSize,xMax:(x+1)*gridSize,yMin:(y-2)*gridSize,yMax:(y+1)*gridSize};
		
		// determine test area boundaries:
		var bounds:Object = {};
		bounds.xMin = Math.max(bounds1.xMin,bounds2.xMin);
		bounds.xMax = Math.min(bounds1.xMax,bounds2.xMax);
		bounds.yMin = Math.max(bounds1.yMin,bounds2.yMin);
		bounds.yMax = Math.min(bounds1.yMax,bounds2.yMax);
		
		// set up the image to use:
		var img:BitmapData = new BitmapData(bounds.xMax-bounds.xMin,bounds.yMax-bounds.yMin,false);
		
		// for testing:
		_root.createEmptyMovieClip("blah",200);
		_root.blah.attachBitmap(img,1);
		
		// draw in the first image:
		var mat:Matrix = p_mc.transform.matrix;
		mat.tx = p_mc._x-bounds.xMin;
		mat.ty = p_mc._y-bounds.yMin;
		img.draw(p_mc,mat,new ColorTransform(1,1,1,1,255,-255,-255,p_alphaTolerance))//new ColorTransform(100,100,100,100,255,-255,-255,p_alphaTolerance));
		
		// set up the color transform:
		var ct:ColorTransform = new ColorTransform(1,1,1,1,255,255,255,p_alphaTolerance)
		
		// iterate through neighbours and test for collisions:
		var i:Number = a.length;
		while (i--) {
			var mc:MovieClip = a[i];
			if (mc == p_mc) { continue; }
			var bounds2:Object = mc.getBounds(p_scope);
			
			// rule out anything that doesn't intersect our test boundaries:
			if (
				((bounds.xMax < bounds2.xMin) || (bounds2.xMax < bounds.xMin)) ||
				((bounds.yMax < bounds2.yMin) || (bounds2.yMax < bounds.yMin)) ) {
				continue;
			}
			
			// overlay the second image:
			mat = mc.transform.matrix;
			mat.tx = mc._x-bounds.xMin;
			mat.ty = mc._y-bounds.yMin;
			img.draw(mc,mat,ct,"difference");
			
			// find the intersection:
			if (img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF).width > 0) { return mc; }
		}
		
		return null;
	}
	
	public function addItem(p_mc:MovieClip):Void {
		mcs.push(p_mc);
		p_mc.i = mcs.length-1;
	}
	
	public function removeItem(p_mc:MovieClip):Void {
		var i:Number = mcs.length;
		while (i--) {
			if (mcs[i] == p_mc) {
				mcs.splice(i,1);
				return;
			}
		}
	}
	
	public function refresh():Void {
		// calculate grid positions:
		var m:Array = mcs;
		var p:Array = []; // = pos; // if they never move.
		var i:Number = m.length;
		while (i--) {
			var mc:MovieClip = mcs[i];
			//if (mc.x) { break; } // if they never move, this can work, but make sure to update above
			var x:Number = Math.ceil(mc._x/gridSize);
			var y:Number = Math.ceil(mc._y/gridSize);
			mc.x = x;
			mc.y = y;
			if (!p[x]) { p[x] = []; }
			if (!p[x][y]) { p[x][y] = [mc]; continue; }
			p[x][y].push(mc);
		}
		pos = p;
	}
}