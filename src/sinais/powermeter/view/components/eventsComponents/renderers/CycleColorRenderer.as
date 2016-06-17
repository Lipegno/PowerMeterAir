package sinais.powermeter.view.components.eventsComponents.renderers 
{
	import flash.display.Graphics;
	
	import mx.charts.series.items.BubbleSeriesItem;
	import mx.core.IDataRenderer;
	import mx.skins.ProgrammaticSkin;
	
	public class CycleColorRenderer extends mx.skins.ProgrammaticSkin implements IDataRenderer {
		
		private var colors:Array = [0xCCCC99,0x999933,0x999966];
		private var _chartItem:BubbleSeriesItem;
		private var lastRadius:int;
		
		import mx.core.INavigatorContent;
		import mx.core.UIComponent;
	//	import decisionTree.ClusterCalculatorV2;
	
		
		public function CycleColorRenderer() {
			// Empty constructor.
			lastRadius=0;
		}
		
		public function get data():Object {
			return _chartItem;
		}
		
		public function set data(value:Object):void {
			if (_chartItem == value)
			{
				return;
			} 
			_chartItem = BubbleSeriesItem(value);
			
			invalidateDisplayList();
		}
		
		override protected function
			updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			var red:int,green:int,blue:int;
			var maxpowerExpected:int = 300;
			var color1:Number;
			var colorhex:String;
			var color2:Number;
			var i:int;
			var alphas:Array = [1, 0.8];
			var colors:Array;
			var ratios:Array = [0x00, 0xFF];
			blue=0;
			var cluster:int = 0;
			
			if(_chartItem!=null){
		 	cluster = Number(_chartItem.item.i);
			if(cluster==0)
				colorhex="0xff1fff";
			if(cluster==1) 
				colorhex="0x70b2ee";
			if(cluster==2)
				colorhex="0x70eec9";
			if(cluster==3) 
				colorhex="0xbdee70";
			if(cluster==4)
				colorhex="0xeec970";
			if(cluster==5) 
				colorhex="0xa49b8c";
			if(cluster==6)
				colorhex="0x4ad300";
			if(cluster==7) 
				colorhex="0x715b7d";
			if(cluster==8)
				colorhex="0xbe4b66";
			if(cluster==9) 
				colorhex="0xf0ff00";
			if(cluster==-1)
				colorhex="0x70b2ee";
			if(cluster==-2)
				colorhex="0x70eec9";
			if(cluster==-3)
				colorhex="0xbdee70";
			if(cluster==-4)
				colorhex="0xeec970";
			if(cluster==-5)
				colorhex="0xa49b8c";
			if(cluster==-6) 
				colorhex="0x4ad300";
			if(cluster==50)
				colorhex="0x715b7d";
			if(cluster==330)
				colorhex="0xfffff6";
			if(cluster==-9)
				colorhex="0xf0ff00";
			}
			
			color1 = Number(colorhex);
			var g:Graphics = graphics;
			
			trace("last one "+lastRadius); 
			var radius:Number =  Math.abs((_chartItem.item.deltaPMean/20))>10?10:Math.abs((_chartItem.item.deltaPMean/20));
			trace("radius "+radius); 
			
			lastRadius= radius;
			
			if(_chartItem.item.is_class){
				g.beginFill(color1);
				g.drawCircle((unscaledWidth/2),(unscaledWidth/2),radius);
				trace("with fill");
			}
			else{
				g.beginFill(Number("0xffffff"));
				g.lineStyle(3,color1);
				g.drawCircle((unscaledWidth/2),(unscaledWidth/2),radius);
				trace("only line");
			}
			
			trace("---->"+radius);
			
			g.endFill();
			}
			
		}
	} // Close class.
