// charts/MyDataTip.as
package sinais.powermeter.view.components.eventsComponents{
	import flash.display.*;
	import flash.geom.Matrix;
	
	import mx.charts.*;
	import mx.charts.chartClasses.DataTip;
	
	public class MyDataTip extends DataTip {
		
		public function MyDataTip() {
			super();            
		}       
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			
			this.setStyle("textAlign","center");
			this.setStyle("font-family","myFontFamily");
			this.setStyle("embedAsCff","false");
			
			var x:int = this.x;
			this.x= x+40;
			var g:Graphics = graphics; 
			g.clear();  
			var m:Matrix = new Matrix();
			m.createGradientBox(w+100,h,0,0,0);
			g.beginGradientFill(GradientType.LINEAR,[0xF4F4F4,0X9B9B9B],
				[.7,1],[0,255],m,null,null,0);
			g.drawRect(-50,0,w+100,h);
			g.endFill(); 
		}
	}
}