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
	public var lastTouch:Float=1.0;
	public var score=0;
	public var scoreTxt:TextField;
	public var endGame:TextField;
	var colors:Array<UInt> = [Color.RED, Color.MAROON, Color.YELLOW, Color.BLUE, Color.NAVY, Color.GREEN, Color.PURPLE, Color.AQUA, Color.FUCHSIA];

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
							var quad = new Quad(20,20,0xababab);
							quad.touchable = false;
							quad.x = (flash.Lib.current.stage.stageWidth/2)-10;
							quad.y = (flash.Lib.current.stage.stageHeight/2)-10;
							quad.color = colors[Math.floor(random()*colors.length)];
							addChild(quad);

							ninja = new Image(Root.assets.getTexture("Ninja"));
							ninja.touchable = true; // touchable must to true inorder for the Object to receive Touch Events
							ninja.addEventListener("touch", onTouch); // Assigning the "touch" Event to onTouch
							ninja.useHandCursor = true;
							ninja.x=20;
							ninja.y=20;
							addChild(ninja);
						}});
				}
			});
	}

	private function onTouch(e:TouchEvent){
		var touch:Touch = e.getTouch(stage);
		if(touch!=null){
			if(touch.phase == TouchPhase.BEGAN) {
				score+=Math.ceil((lastTouch/flash.Lib.getTimer())*4);
				// ^ Supposed to reward more points for fast Clicks
				lastTouch=flash.Lib.getTimer();

				var quad = new Quad(20,20,0xffffff);
				addChildAt(quad,0);
				quad.scaleX+=score;
				quad.scaleY+=score;
				quad.x = (flash.Lib.current.stage.stageWidth/2)-(quad.width/2);
				quad.y = (flash.Lib.current.stage.stageHeight/2)-(quad.height/2);
				quad.color = colors[Math.floor(random()*colors.length)];

				touch.target.x=random()*(flash.Lib.current.stage.stageWidth-touch.target.width);
				touch.target.y=random()*(flash.Lib.current.stage.stageHeight-touch.target.height);
				// ^ Jumps the "Ninja" to a Random Point on the Screen

				if(quad.width >= flash.Lib.current.stage.stageWidth){
					/*var quad = new Quad(640, 640, 0x000000);
					quad.rotation=(3.14/2);
					quad.alpha=0;
					addChild(quad);
					Starling.juggler.tween(quad, 1.5, {transition:Transitions.EASE_OUT, delay:0, alpha: 1, onComplete: function(){
						endGame = new TextField(640,640, "Game Over!\n Your Time was " + (flash.Lib.getTimer()/1000) + " seconds!");
						endGame.hAlign = "center";
						endGame.vAlign = "center";
						addChild(endGame);
					}});
					Trying to get a white diamond behind the Game Over Text*/
					endGame = new TextField(640,640, "Game Over!\n Your Time was " + (flash.Lib.getTimer()/1000) + " seconds!");
					endGame.hAlign = "center";
					endGame.vAlign = "center";
					addChild(endGame);
				}


			}
		}
	}
}