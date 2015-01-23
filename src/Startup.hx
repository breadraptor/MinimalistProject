import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Rectangle;
import starling.core.Starling;

@:bitmap("assets/loading.png")
// statically loads the png
class LoadingBitmapData extends flash.display.BitmapData {}

// BitmapData -> Bitmap -> Sprites

class Startup extends Sprite {

	// have to type loadingBitmap as Bitmap because haxe can't tell from context
	public var loadingBitmap:Bitmap;

	// constructor
	function new() {
		super();
		loadingBitmap = new Bitmap(new LoadingBitmapData(0, 0));
		loadingBitmap.x = 0; // upper left hand corner in flash coords.
		loadingBitmap.y = 0;
		
		// set width and height. Will have dimensions from the img, but we can resize to fit screen
		loadingBitmap.width = flash.Lib.current.stage.stageWidth;
		loadingBitmap.height = flash.Lib.current.stage.stageHeight;
		
		// control the movement
		loadingBitmap.smoothing = true;
		
		// bitmap connect to startup sprite
		addChild(loadingBitmap);
		
		// handle resolution resize events
		flash.Lib.current.stage.addEventListener(flash.events.Event.RESIZE,
					function(e:flash.events.Event) { 
						Starling.current.viewPort = new Rectangle(0,0,
						flash.Lib.current.stage.stageWidth,
						flash.Lib.current.stage.stageHeight);
						if (loadingBitmap != null){
							loadingBitmap.width = flash.Lib.current.stage.stageWidth;
							loadingBitmap.height = flash.Lib.current.stage.stageHeight;
							
							}});
							
		// Root is a file in the same directory
		// initialize starling
		var mStarling = new Starling(Root, 
				flash.Lib.current.stage);
		// pixel art is good for antiAliasing = 0
		mStarling.antiAliasing = 0;

		function onRootCreated(event:Dynamic, root:Root) {
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			root.start(this);
			// start the starling stage with this object as its first parameter
			mStarling.start();
		}
		mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
	
	}
	
	//main function
	static function main(){
		var stage = flash.Lib.current.stage;
		stage.addChild(new Startup());
	}
	
}


