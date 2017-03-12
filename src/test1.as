package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class test1 extends Sprite
	{

		
		public function test1(x:Number, y:Number)
		{
			super();
			trace("adasdasd");

			graphics.beginFill(0xFF0000, 0.5);
			graphics.drawRect(30,30,20,20);
			graphics.endFill();
			addEventListener(Event.ENTER_FRAME, H_enterframe);
		}
		public function H_enterframe(evt:Event):void
		{
			this.x++;
		}
	}
}