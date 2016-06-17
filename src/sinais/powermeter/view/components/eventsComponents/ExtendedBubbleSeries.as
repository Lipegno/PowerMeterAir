package sinais.powermeter.view.components.eventsComponents
{
	import mx.charts.series.BubbleSeries;
	import mx.charts.series.items.BubbleSeriesItem;
	
	public class ExtendedBubbleSeries extends BubbleSeries
	{
		
		[Bindable] 
		public var lrAlpha:String;
		[Bindable] 
		public var lrBeta:String;
		[Bindable]
		public var cluster:int;
		
		public function ExtendedBubbleSeries()
		{
			super();
		}

		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var arrayItems:Array = super.items;
			for( var i:int = 0 ; i < arrayItems.length ; i++)
			{
				var item:BubbleSeriesItem = arrayItems[i] as BubbleSeriesItem;
			}
		}
	}
}