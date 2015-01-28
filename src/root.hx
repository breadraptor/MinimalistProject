import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.events.*;
import starling.display.Quad;
import starling.animation.Transitions;
import starling.text.TextField;
import flash.system.System;
import Math.random;
import starling.utils.Color;

class Root extends Sprite {
	public static var assets:AssetManager;
	public var ninja:Image;
	public var quad:Quad;
	public var lastTouch:Float=1.0;
	public var score=0;
	public var scoreTxt:TextField;
	public var endGame:TextField;
	var colors:Array<UInt> = [Color.RED, Color.YELLOW, Color.BLUE, Color.GREEN, Color.PURPLE, Color.AQUA, Color.LIME, Color.FUCHSIA];

	public function new() {
		super();
	}

	public function start(startup:Startup){
		assets=new AssetManager();
		assets.enqueue("assets/Ninja.png");
		assets.loadQueue(function onProgress(ratio:Float) {
				// as assets get loaded, ratio gets updated. can be used for progress bar.
				if (ratio == 1) {
					// loading completed animation
					Starling.juggler.tween(startup.loadingBitmap, 2.0, {transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
						// cleaning up the loadingScreen after it has already faded	
						startup.removeChild(startup.loadingBitmap);
							quad = new Quad(20,20,0xababab);
							quad.touchable = false;
							quad.x = (flash.Lib.current.stage.stageWidth/2)-10;
							quad.y = (flash.Lib.current.stage.stageHeight/2)-10;
							addChild(quad);

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

				quad.scaleX+=8;
				quad.scaleY+=8;
				quad.x = (flash.Lib.current.stage.stageWidth/2)-(quad.width/2);
				quad.y = (flash.Lib.current.stage.stageHeight/2)-(quad.height/2);
				quad.color = colors[Math.floor(random()*colors.length)];

				touch.target.x=random()*(flash.Lib.current.stage.stageWidth-touch.target.width);
				touch.target.y=random()*(flash.Lib.current.stage.stageHeight-touch.target.height);
				// ^ Jumps the "Ninja" to a Random Point on the Screen

				if(quad.width >= flash.Lib.current.stage.stageWidth){
					endGame = new TextField(640,640, "Game Over!\n Your Time was " + (flash.Lib.getTimer()/1000) + " seconds!");
					endGame.hAlign = "center";
					endGame.vAlign = "center";
					addChild(endGame);
				}


			}
		}
	}
}