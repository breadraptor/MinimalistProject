import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.events.*;
import starling.animation.Transitions;
import starling.text.TextField;
import Math.random;

class Root extends Sprite {
	public static var assets:AssetManager;
	public var ninja:Image;
	public var lastTouch:Float=1.0;
	public var score=0;
	public var scoreTxt:TextField;

	public function new() {
		super();
	}

	public function start(startup:Startup){
		assets=new AssetManager();
		assets.enqueue("assets/Ninja.png");
		assets.loadQueue(function onProgress(ratio:Float) {
				// as assets get loaded, ratio gets updated. can be used for progress bar.
				if (ratio == 1) {
					// loading animation
					Starling.juggler.tween(startup.loadingBitmap, 2.0, {transition:Transitions.EASE_OUT, delay:5.0, alpha: 0, onComplete: function(){
						// finished loading	
						startup.removeChild(startup.loadingBitmap);

							ninja = new Image(Root.assets.getTexture("Ninja"));
							ninja.touchable = true; // touchable must to true inorder for the Object to receive Touch Events
							ninja.addEventListener("touch", onTouch); // Assigning the "touch" Event to onTouch
							ninja.useHandCursor = true;
							ninja.x=20;
							ninja.y=20;
							addChild(ninja);

							scoreTxt = new TextField(124, 32, score+""); 
							scoreTxt.hAlign = "left";
							scoreTxt.vAlign = "top";
							addChild(scoreTxt);
						}});
				}
			});
	}

	private function onTouch(e:TouchEvent){
		var touch:Touch = e.getTouch(stage);
		if(touch!=null){
			if(touch.phase == TouchPhase.BEGAN) {
				score+=Math.ceil((lastTouch/touch.timestamp)*10);
				// ^ Supposed to reward more points for fast Clicks
				scoreTxt.text=score+"";
				lastTouch=touch.timestamp;

				touch.target.x=random()*(flash.Lib.current.stage.stageWidth-touch.target.width);
				touch.target.y=random()*(flash.Lib.current.stage.stageHeight-touch.target.height);
				// ^ Jumps the "Ninja" to a Random Point on the Screen
			}
		}
	}
}