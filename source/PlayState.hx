package;

import flixel.group.FlxTypedGroup;
import flixel.FlxCamera;
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
	public var coins:FlxTypedGroup<Coin>;
    public var enemies:FlxTypedGroup<Enemy>;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		FlxG.debugger.visible = true;

        // Load tilemap and initialize variables
		level = new TiledLevel("assets/data/room-001.tmx");
		coins = new FlxTypedGroup();
        enemies = new FlxTypedGroup();

		// Load the level background and walls
		add(level.backgroundTiles);
        add(level.foregroundTiles);

		// Load player and coin objects
		level.loadObjects(this);

		// Add the coins to the level
		add(coins);
        add(enemies);

		// Add the player to the level
		add(player);

		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, 1);
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
		FlxG.overlap(player, coins, playerTouchCoin);
	}

    /**
	 * Function that determines what happens when a player touches a coin.
     */
	private function playerTouchCoin(Player:Player, Coin:Coin):Void
	{
		if (Player.alive && Player.exists && Coin.alive && Coin.exists)
			Coin.kill();
	}

}
