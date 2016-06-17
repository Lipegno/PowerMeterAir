package sinais.powermeter.handlersObjects
{
	
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	
	import mx.events.FlexEvent;
	
	public class SoundGenerator
	{
		
		private var angle:Number;
		private  var mySound:Sound;
		
		
		public function SoundGenerator()
		{
			mySound=new Sound();
		}
		
		public function play(deltaPMean:Number):void{
			
			setangle(deltaPMean);
			
			mySound.addEventListener(SampleDataEvent.SAMPLE_DATA, sineWaveGenerator); 
			var myTimer:Timer = new Timer(100, 2);
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.start();
			mySound.play(0,1); 
			
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sineWaveGenerator);
		}
		
		private function sineWaveGenerator(event:SampleDataEvent):void 
		{ 
			var soundAmp:int = ConfigSingleton.getInstance().soundAmp;
			for (var i:int = 0; i < 2048; i++) 
			{ 
				var n:Number = soundAmp*Math.sin((i + event.position) / Math.PI / angle); 
				event.data.writeFloat(n); 
				event.data.writeFloat(n); 
			} 
			
		}
		
		
		private function setangle(deltaPmean:Number):void{
			
			angle = 5-((deltaPmean*5)/1100);
			
		}
	}
}