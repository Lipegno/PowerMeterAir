package sinais.powermeter.handlersObjects.semaphore
{
	public class FlerrySemaphore extends Semaphore
	{
		protected var _locks:int = 0;
		
		public function FlerrySemaphore(owner:Object = null, description:String = null)
		{
			super(owner, description);
		}
		
		override protected function initialize():void
		{
			_locks = 0;
		}
		
		override public function get locks():int
		{
			return _locks;
		}
		
		override public function get isLocked():Boolean
		{
			return (_locks > 0);
		}
		
		public function lock():void
		{
			if (_locks++ == 0)
			{
				dispatchEvent(new SemaphoreEvent(SemaphoreEvent.UNAVAILABLE));
			}
		}
		
		public function unlock():void
		{
			_locks--;
			if (locks < 0)
			{
				throw new Error("Semaphore Asymmetrically Unlocked!");
				locks = 0;
			} else if (locks == 0) {
				dispatchEvent(new SemaphoreEvent(SemaphoreEvent.AVAILABLE));
			}
		}
	}
	
}