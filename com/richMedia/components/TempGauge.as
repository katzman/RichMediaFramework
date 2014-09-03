package com.blt.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	
	public class TempGauge
	{				
		public static const INIT_ANIMATION_COMPLETE	: String = "initAnimationComplete";
		public static const SCROLL_COMPLETE			: String = "scrollComplete";
		public static const SCROLL_UP				: String = "scrollUp";
		public static const SCROLL_DOWN				: String = "scrollDown";
		
		// movie clip targets
		public var gaugeComponent	: MovieClip; // set in fla
		
		private var gaugeTarget		: MovieClip;
		private var titlesTarget	: MovieClip;
		
		private var upBtn			: MovieClip;
		private var downBtn			: MovieClip;
		
		// speed of gauge animation
		public var scrollSpeed		: uint; // set in fla
		
		// lists
		private var tempList		: Array;
		private var titleList		: Array;
		private var initList		: Array;
		
		// static temp values
		private var MAX_TEMP		: uint = 130;
		private var MIN_TEMP		: uint = 30;
		
		// temp values
		public var tempMax			: uint; // set in fla
		public var tempMin			: uint; // set in fla
		public var tempStep			: uint; // set in fla
		public var tempDistance		: uint; // set in fla
		public var dynamicTemp		: int;  // set in fla, if set will ignore temp min and max values. 
		
		// title values
		public var titleSpacing		: uint; // set in fla
		public var maxTitleWidth	: uint; // width of title elements, pixel value, set in fla	
		public var maxTitleHeight	: uint; // height of title elements, pixel value, set in fla
		
		// scroll direction
		private var scrollValue		: int = 0;
		private var titlesScrollSpd	: Number = 3;
		private var tempsScrollSpd	: Number = 3;
		
		private var initComplete	: Boolean;
		private var initAnimationPos: uint;
		
		private var mouseOffStage	: Boolean;
		
		
		public function TempGauge(){}
		

		public function init():void 
		{
			setValues();
			buildTempGauge();
			buildTitles();
			setScrollSpeeds();
			setListeners();
		}
		
		
		/**
		 * adds movie title item to sync to temp gauge
		 * @param temp - uint :: value temp that title should sync with. 
		 * @param item - String :: value of the items linkage name set in the flash library.  
		 * @param initItem - int :: number setting when the title will be shown on the init animation.
		 * lower values come before higher ones.  
		 */		
		public function addItem( temp:uint, title:String, initItem:int = -1 ):void 
		{
			if ( !titleList ) titleList = [];
			
			var item:Object = { tempValue:temp, linkName:title, ypos:0 };
			titleList.push ( item );
			
			if ( initItem != -1 ) 
			{
				if ( !initList ) initList = [];
				initList[initItem] = item;
			} 
		}
		
		/**
		 * will animate to a title based on a temp value 
		 * @param temp - uint
		 * 
		 */		
		public function setTitleByTemp( temp:uint ):void 
		{
			initComplete = false;
			
			var tempObj:Object = getTempByValue( temp );
			var title:Object = getTitleByValue( "tempValue", String ( temp ) );
	
			if (!title || !tempObj) return;
			
			TweenLite.to(titlesTarget,  2, {y:-title.ypos, 		ease:Cubic.easeOut});
			TweenLite.to(gaugeTarget, 	2, {y:-tempObj.ypos, 	ease:Cubic.easeOut, onComplete:titleTempAnimationsComplete});
		}
		
		
		/**
		 * will animate to a title based on a title link id passed in the fla 
		 * @param id - String
		 * 
		 */
		public function setTitleById( id:String ):void 
		{
			initComplete = false;
			
			var title:Object = getTitleByValue( "linkName", id );
			var tempObj:Object = getTempByValue( title.tempValue );
			
			if (!title || !tempObj) return;
			
			TweenLite.to(titlesTarget,  2, {y:-title.ypos, 		ease:Cubic.easeOut});
			TweenLite.to(gaugeTarget, 	2, {y:-tempObj.ypos, 	ease:Cubic.easeOut, onComplete:titleTempAnimationsComplete});
		}
		
		
		private function titleTempAnimationsComplete():void 
		{
			initComplete = true;
		}
		
		
		public function showInitAnimation():void 
		{
			if ( initList && initList.length > 0 ) 
			{
				gaugeTarget.y = -gaugeTarget.height;
				titlesTarget.y = -titlesTarget.height;
				initAnimationPos = 0;
				scrollToTitle( initList[initAnimationPos] );
			}
			else
			{
				initAnimationComplete();
			}
		}
		
		
		private function nextInitAnimationItem():void
		{
			if ( initAnimationPos < initList.length -1 )
			{
				initAnimationPos++;
				scrollToTitle ( initList[initAnimationPos] );
			}
			else
			{
				initAnimationComplete();				
			}
		}
		
		
		private function initAnimationComplete():void
		{
			initComplete = true;
			gaugeComponent.dispatchEvent( new Event ( INIT_ANIMATION_COMPLETE, true ));
		}
		
		
		// init animation cycle complete, checks for another cycle
		private function animationDone():void 
		{
			if ( !initComplete ) nextInitAnimationItem();
		}
				
		
		private function setValues():void 
		{
			gaugeTarget = gaugeComponent.tempGauge_mc;
			titlesTarget = gaugeComponent.titles_mc;
			
			upBtn = gaugeComponent.up_btn;
			downBtn = gaugeComponent.down_btn;
		}
		
		
		private function setListeners():void 
		{
			gaugeComponent.stage.addEventListener(Event.ENTER_FRAME, updateView );
			gaugeComponent.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeftStage );
		}
		
		
		// titles and temps have different scroll speeds based on height, this matches them up
		private function setScrollSpeeds():void 
		{
			var titlesHeight:uint = titleList[titleList.length -1].ypos;
			var tempHeight:Number = tempList[0].ypos;
			var scale:Number = titlesHeight / tempHeight; 
				
			tempsScrollSpd = titlesScrollSpd * scale;  
		}
		
		
		// mouse off banner
		private function mouseLeftStage( e:Event ):void
		{			
			gaugeComponent.stage.addEventListener ( MouseEvent.MOUSE_MOVE, mouseOverStage );
			mouseOffStage = true;			
			if ( initComplete ) scrollStop();
		}
		
		
		// mouse back over stage
		private function mouseOverStage( e:MouseEvent ):void
		{
			gaugeComponent.stage.removeEventListener ( MouseEvent.MOUSE_MOVE, mouseOverStage );
			mouseOffStage = false;
		}
		
		
		// called on enter frame, updates scroll based on mouse position
		private function updateView( e:Event ):void
		{
			e.stopImmediatePropagation();				
			
			if ( !initComplete || mouseOffStage ) return;
			
			var direction:String;
			if ( upBtn.hitTestPoint(gaugeComponent.stage.mouseX, gaugeComponent.stage.mouseY))
			{
				scrollValue = -scrollSpeed;
			}
			else if ( downBtn.hitTestPoint(gaugeComponent.stage.mouseX, gaugeComponent.stage.mouseY))
			{
				scrollValue = scrollSpeed;
			}
			else
			{
				scrollValue = 0;
			}
			
			scrollElements();
		}
		
		
		private function scrollElements():void
		{
			if ( scrollValue == 0 )
			{
				scrollStop();
			}
			else
			{
				scrollTitles();
				scrollTemps();		
			}			
		}
		
		
		// scrolls to a specific title object that is passed, will update temp also. 
		private function scrollToTitle( title:Object ):void 
		{
			var tempObj = getTempByValue( title.tempValue );
			TweenLite.to(titlesTarget, 4, {y:-title.ypos, ease:Cubic.easeOut, onComplete:animationDone});
			if( tempObj ) TweenLite.to(gaugeTarget, 4, {y:-tempObj.ypos, ease:Cubic.easeOut});
		}
		
		
		// scrolls titles only
		private function scrollTitles():void 
		{
			var titlesHeight:uint = titleList[titleList.length -1].ypos;
			var ypos:Number = titlesTarget.y + scrollValue;			
			
			ypos = ( ypos > 0 ) ? 0 : ypos;
			ypos = ( Math.abs ( ypos ) > titlesHeight ) ? -titlesHeight : ypos;
			
			TweenLite.to(titlesTarget, titlesScrollSpd, {y:ypos, ease:Cubic.easeOut});
		}
		
		
		// scrolls temps only
		private function scrollTemps():void
		{
			var tempHeight:Number = tempList[0].ypos;
			var ypos:Number = gaugeTarget.y + scrollValue;
			
			ypos = ( ypos > 0 ) ? 0 : ypos;
			ypos = ( Math.abs ( ypos ) > tempHeight ) ? -tempHeight : ypos;
			
			TweenLite.to(gaugeTarget, tempsScrollSpd, {y:ypos, ease:Cubic.easeOut});
		}
		
		
		private function scrollStop():void
		{
			var ypos			: int = Math.abs ( titlesTarget.y );
			var itemYpos		: int;
			var closestNum		: int;
			var tempNum			: int;
			var tempObj			: Object;
			
			var closestArrayItem: uint;
			var length			: uint = titleList.length;
			
			for ( var i:uint = 0; i < length; i++ )
			{
				itemYpos = titleList[i].ypos;
				tempNum = Math.abs ( itemYpos - ypos );
				
				if ( tempNum <= closestNum || i == 0 )
				{
					closestNum 		 = tempNum;
					closestArrayItem = i;
					tempObj = getTempByValue( titleList[closestArrayItem].tempValue );
				}
			}
			
			TweenLite.to(titlesTarget, 2, {y:-titleList[closestArrayItem].ypos, ease:Cubic.easeOut});
			if( tempObj ) TweenLite.to(gaugeTarget, 2, {y:-tempObj.ypos, ease:Cubic.easeOut});
		}
		
		
		// returns title object by matching temp or title id. Type value is the object props, either linkName or tempValue.
		private function getTitleByValue( type:String, value:String ):Object
		{
			var length:int = titleList.length;
			var tempValue:String;
			
			for ( var i:uint = 0; i < length; i++ ) 
			{
				tempValue = String ( titleList[i][type] ); 
				
				if ( tempValue == value )
				{
					return titleList[i];
				}
			}
			
			return null;
		}
		
		
		// returns temp object by matching temp value. 
		private function getTempByValue( value:uint ):Object
		{
			var length:uint = tempList.length;
			
			for ( var i:uint = 0; i < length; i++ ) 
			{
				if ( tempList[i].value == value )
				{
					return tempList[i];
				}
			}
			
			return null;
		}
		
		
		// updates temp values based on dynamic value from weather api. 
		private function updateTempValues():void 
		{
			var tempRange:uint = Math.floor ( titleList.length * .5 ) * tempStep;
			tempMax = dynamicTemp + tempRange;
			tempMin = dynamicTemp - tempRange + 1;
		}
		
		
		// resets the title temp based on the new temp values set by the weather api. 
		private function updateTitleTemp( count:uint ):void
		{
			var title:Object = titleList[count];			
			var tempPos:Number = tempList.length -1 - count;			
			title.tempValue = tempList[tempPos].value;			
		}
		
		
		// builds temp list
		private function buildTempGauge():void 
		{
			tempList = [];
			
			if ( dynamicTemp )
			{
				updateTempValues();
			}

            // TempElement is in flash library.
			var item:TempElement;
			var length:uint = ( tempMax - tempMin ) / tempStep;
			var tempValue:uint;
			var tempObj:Object;
			var ypos:uint;
			
			for ( var i:uint = 0; i <= length; i++ ) 
			{
				tempValue = tempMin + ( tempStep*i );
				item = new TempElement();
				item.temp_txt.text = tempValue + "˚";
				ypos = ( length - i ) * tempDistance;
				item.y = ypos; 
								
				tempObj = { ypos:ypos, value:tempValue };
				tempList.push ( tempObj );
				
				gaugeTarget.addChild ( item );
			}		
		}
		
		
		// builds titles list
		private function buildTitles():void
		{
			var length:uint = titleList.length;
			var title:MovieClip;
			var prevTitle:MovieClip;
			var itemClass:Class;
			var scale:Number;
			
			for ( var i:uint = 0; i < length; i++ )
			{
				itemClass = getDefinitionByName( titleList[i].linkName ) as Class;
				title = new itemClass();
				setTitleScale ( title );
				
				if ( dynamicTemp ) updateTitleTemp( i );
				
				title.y = ( prevTitle ) ? prevTitle.y + prevTitle.height + titleSpacing : 0;
				titleList[i].ypos = title.y + ( title.height * .5 );
				titlesTarget.addChild ( title );
				prevTitle = title;
			}
		}
		
		
		// scales title elements based on width and height value passed from fla. 
		private function setTitleScale( title:MovieClip ):void 
		{
			var scaleWidth:Number = ( maxTitleWidth ) ? maxTitleWidth / title.width : 10;
			var scaleHeight:Number = ( maxTitleHeight ) ? maxTitleHeight / title.height : 10;			
			var scale:Number = ( scaleWidth < scaleHeight ) ? scaleWidth : scaleHeight;
			
			title.scaleX = title.scaleY = scale;
		}
	}
}