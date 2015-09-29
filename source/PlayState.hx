package;

import flixel.FlxObject;
import flixel.system.debug.Log;
import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.editors.tiled.TiledMap;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var level:TiledLevel;
	public var player:Player;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		FlxG.debugger.visible = true;

        // Load tilemap
		level = new TiledLevel("assets/data/room-001.tmx");

		add(level.backgroundTiles);
        add(level.foregroundTiles);

		// Load player objects
		level.loadObjects(this);


	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		level.collideWithLevel(player);
	}

}
