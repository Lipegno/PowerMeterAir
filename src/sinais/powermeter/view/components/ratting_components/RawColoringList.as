package sinais.powermeter.view.components.ratting_components
{
	import mx.controls.List;
	import mx.collections.IList;
	import flash.display.Sprite;
	
	public class RawColoringList extends List {
		
		[Bindable]
		public var rowColoringFunction:Function;
		
		protected override function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void {
			if (rowColoringFunction != null && IList(dataProvider).length > dataIndex) {
				color = rowColoringFunction(IList(dataProvider).getItemAt(dataIndex), dataIndex, color);
			}
			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
		}
		
	}
}