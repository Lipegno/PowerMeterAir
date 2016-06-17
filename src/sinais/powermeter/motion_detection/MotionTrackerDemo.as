
package sinais.powermeter.motion_detection  
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite; 
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.media.Camera;
	import flash.media.Video;
	
	import uk.co.soulwire.cv.MotionTracker;

	/**
	 * MotionTrackerDemo
	 */

	[SWF(width="870", height="420", backgroundColor="#FFFFFF", frameRate="31")]
	
	[Event(name="motionEvent", type="faceAndmotion.MotionEvent")]

	public class MotionTrackerDemo extends Sprite 
	{

		//	----------------------------------------------------------------
		//	PRIVAYE MEMBERS
		//	----------------------------------------------------------------

		private var _motionTracker : MotionTracker;

		private var _output : Bitmap;
		private var _source : Bitmap;
		private var _video : BitmapData;
		private var _matrix : ColorMatrix;

		public function MotionTrackerDemo()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------

		public function initTracking() : void
		{
			var camW : int = 100;
			var camH : int = 40;

			// Create the camera
			var cam : Camera = Camera.getCamera();
			cam.setMode(camW, camH, 12);
			
			// Create a video
			var vid : Video = new Video(camW, camH);
			vid.attachCamera(cam);
			
			// Create the Motion Tracker
			_motionTracker = new MotionTracker(vid);
			
			// We flip the input as we want a mirror image
			_motionTracker.flipInput = true;
			
			/*** Create a few things to help us visualise what the MotionTracker is doing... ***/

			_matrix = new ColorMatrix();
			_matrix.brightness = _motionTracker.brightness;
			_matrix.contrast = _motionTracker.contrast;
			
			// Display the camera input with the same filters (minus the blur) as the MotionTracker is using
			_video = new BitmapData(camW, camH, false, 0);
			_source = new Bitmap(_video);

			
			// Show the image the MotionTracker is processing and using to track
			_output = new Bitmap(_motionTracker.trackingImage);

			addChild(_output);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}



		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------

		private function onAddedToStage(event : Event) : void
		{
			initTracking();
			trace("aded to stage");
		}

		private function onEnterFrameHandler(event : Event) : void
		{
			

			
			// Tell the MotionTracker to update itself
			_motionTracker.track();

		
			_video.draw(_motionTracker.input);
			
			// If there is enough movement (see the MotionTracker's minArea property) then continue
			if ( !_motionTracker.hasMovement ){ return;}
			else{
				////////////////

//SEND THE EVENTS TO THE MAIN CALSS		
				var motionEvent:MotionEvent = new MotionEvent("motion",true,false);
				super.dispatchEvent(motionEvent);
			}
			// Draw the motion bounds so we can see what the MotionTracker is doing
			
		}

}
}
