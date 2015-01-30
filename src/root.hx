import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.events.*;
import starling.display.Quad;
import starling.display.QuadBatch;
import starling.animation.Transitions;
import starling.text.TextField;
import flash.system.System;
import flash.media.Sound;
import flash.net.URLRequest;
import Math.random;
import starling.utils.Color;
import starling.textures.Texture;
import starling.animation.Tween;

class Root extends Sprite {
	public static var assets:AssetManager;
	public var ninja:Ninja;
	public var restart:Image;	
	public var background:Background;
	public var lastTouch:Float=1.0;
	public var score=0;
	public var scoreTxt:TextField;
	public var endGame:TextField;
	public var t1:Float = 0;
	public var t2:Float = 0;
	public var t3:Float = 0;
	public var scoreMax = 10000;	//The highest score you can get per click. The higher the scoreMax, the more variance you get between box sizes
	public var scoreMin = 0;		//The lowest score you can get per click.
	public var growthRate = 20;	//The lower the growth rate, the faster the game ends
	public function new() {
		super();
	}

	public function start(startup:Startup){
		assets=new AssetManager();
		assets.enqueue("assets/Ninja.png", "assets/Ninja_2.png", "assets/smoke.png", "assets/blue_box.png");
		assets.loadQueue(function onProgress(ratio:Float) {
				// as assets get loaded, ratio gets updated. can be used for progress bar.
				if (ratio == 1) {
					// loading completed animation
					Starling.juggler.tween(startup.loadingBitmap, 2.0, {transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
						// cleaning up the loadingScreen after it has already faded	
						startup.removeChild(startup.loadingBitmap);
						t1 = (flash.Lib.getTimer()/1000);

						background = new Background();
						addChild(background.getNewQuad(20));

						Ninja.init();
						
						ninja = new Ninja();
						ninja.addEventListener("touch", onTouch); // Assigning the "touch" Event to onTouch
						addChild(ninja);
						
						lastTouch = flash.Lib.getTimer();	//Start timer when ninja spawns for the first time
					}});
				}
			});
	}

	private function onTouch(e:TouchEvent){
		var touch:Touch = e.getTouch(stage);
		if(touch!=null){
			if(touch.phase == TouchPhase.BEGAN) {
				var addScore = scoreMax - Math.ceil(flash.Lib.getTimer() - lastTouch);
				if (addScore < scoreMin) {
					addScore = scoreMin;
				}
				
				score += addScore;
				// ^ Supposed to reward more points for fast Clicks
				
				var growth = Math.ceil((scoreMax - addScore) / growthRate);
				
				lastTouch=flash.Lib.getTimer();
				
				ninja.clicked();

				var quad = background.getNewQuad(growth);
				addChildAt(quad,0);

				checkGameOver(quad);
			}
		}
	}
	private function checkGameOver(quad:Quad) {
		if(quad.width >= flash.Lib.current.stage.stageWidth){
			/*var quad = new Quad(640, 640, 0x000000);
			quad.rotation=(3.14/2);
			quad.alpha=0;
			addChild(quad);
			Starling.juggler.tween(quad, 1.5, {transition:Transitions.EASE_OUT, delay:0, alpha: 1, onComplete: function(){
				endGame = new TextField(640,1000, "Game Over!\n Your Time was " + (flash.Lib.getTimer()/1000) + " seconds!\n Your score was " + score);
				endGame.hAlign = "center";
				endGame.vAlign = "center";
				addChild(endGame);
			}});
			Trying to get a white diamond behind the Game Over Text*/
			t2 = (flash.Lib.getTimer()/1000);
			t3 = Math.round((t2 - t1)*100)/100.0;
			endGame = new TextField(640,1000, "Game Over!\n Your Time was " + (flash.Lib.getTimer()/1000) + " seconds!\n Your score was " + score);
			endGame.hAlign = "center";
			endGame.vAlign = "center";
			addChild(endGame);

			restart = new Image(Root.assets.getTexture("blue_box"));
			restart.touchable = true;
			restart.addEventListener("touch", touchRestart);
			restart.y = 360;
			restart.x = 310;
			addChild(restart);
		}
	}
		private function touchRestart(e:TouchEvent){
		var touch:Touch = e.getTouch(stage);
		if(touch != null){
			if(touch.phase == TouchPhase.BEGAN){
				removeChildren();
				score= 0;
				lastTouch = flash.Lib.getTimer();
								t1 = Math.round(flash.Lib.getTimer()/1000);
					// loading completed animation
						// cleaning up the loadingScreen after it has already faded	
						
						background.resetCurrentSize();
						addChild(background.getNewQuad(20));

						Ninja.init();
						
						ninja = new Ninja();
						ninja.addEventListener("touch", onTouch); // Assigning the "touch" Event to onTouch
						addChild(ninja);

			}
		}
	}
}

class Ninja extends Sprite {
	private static var clickSound:Sound;
	
	private var ow:Image;
	private var norm:Image;
	
	private var smoke:Image;
	
	public function new() {
		super();
	
		// the two ninja states
		norm = new Image(Root.assets.getTexture("Ninja"));
		ow = new Image(Root.assets.getTexture("Ninja_2"));
		smoke = new Image(Root.assets.getTexture("smoke"));
		
		addChild(norm);
		addChild(ow);
		addChild(smoke);
		ow.visible = false;
		
		touchable = true; // touchable must to true inorder for the Object to receive Touch Events
		useHandCursor = true;
		x = random()*(flash.Lib.current.stage.stageWidth - width);
		y = random()*(flash.Lib.current.stage.stageHeight - height);
		
		newSmoke();
	}
	
	// Should only be called once
	public static function init() {
		clickSound = new Sound();
		clickSound.load(new URLRequest("assets/click.mp3"));
	}
	
	public function clicked() {
		clickSound.play();
	
		// the ninja has been clicked, so his face turns red
		norm.visible = false;
		ow.visible = true;

		// animation for jumping up
		Starling.juggler.tween(this, .25, { transition: Transitions.EASE_OUT,
		y: this.y - 10});
		
		// animation for jumping down. On complete, move ninja to new location
		Starling.juggler.tween(this, .2, { transition: Transitions.EASE_IN,
			y: this.y + 3, delay: .25, onComplete: function() {
			norm.visible = true;
			ow.visible = false;
			x = random()*(flash.Lib.current.stage.stageWidth - width);
			y = random()*(flash.Lib.current.stage.stageHeight - height);
			newSmoke();
			}
		});
	}
	
	private function newSmoke() {
		smoke.alpha = 0;
		Starling.juggler.tween(smoke, .1, {
			transition:Transitions.EASE_OUT, delay:0, alpha: 1, onComplete: function() {
				Starling.juggler.tween(smoke, .8, {
					transition:Transitions.EASE_OUT, delay:0, alpha: 0
				});
			}
		});
	}
}

class Background {
	private static var colors:Array<UInt> = [Color.RED, Color.MAROON, Color.YELLOW, Color.BLUE, Color.NAVY, Color.GREEN, Color.PURPLE, Color.AQUA, Color.FUCHSIA];
	
	private var currentSize:Int = 0;
	
	public function new() {}
	
	public function getNewQuad(growth:Int):Quad {
		currentSize += growth;
		var quad = new Quad(currentSize,currentSize,0xffffff);
		quad.x = (flash.Lib.current.stage.stageWidth/2)-(quad.width/2);
		quad.y = (flash.Lib.current.stage.stageHeight/2)-(quad.height/2);
		quad.color = colors[Math.floor(random()*colors.length)];
		return quad;
	}
	
	public function resetCurrentSize() {
		currentSize = 0;
	}
}