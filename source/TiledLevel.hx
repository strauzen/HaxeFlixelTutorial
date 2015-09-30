package;

import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.FlxObject;
import flixel.FlxObject;
import haxe.io.Path;
import haxe.io.Path;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;


class TiledLevel extends TiledMap
{
    // For each tile Layer in the map, you must define a tileset property which contains the name of a tile sheet image
    // used to draw tiles in that layer (without file extension). The image file must be located in the directory
    // specified

    private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";

    // Array of tilemaps used for collision
    public var foregroundTiles:FlxGroup;
    public var backgroundTiles:FlxGroup;
    private var collidableTileLayers:Array<FlxTilemap>;

    public function new(tiledLevel:Dynamic)
    {
        super(tiledLevel);

        // Initialization
        foregroundTiles = new FlxGroup();
        backgroundTiles = new FlxGroup();

        FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);

        loadTileMaps();
    }

    // Load the objects from the tiledMap
    public function loadObjects(state:PlayState)
    {
        for (group in objectGroups)
        {
            for (o in group.objects)
            {
                loadObject(o, group, state);
            }
        }
    }

    // Loads the objects containd in the object layers of the tiledmap
    private function loadObject(object:TiledObject, group:TiledObjectGroup, state:PlayState)
    {
        var x:Int = object.x;
        var y:Int = object.y;

        // Objects in tiled are aligned bottom-left (top left in flixel)
        if (object.gid != -1)
            y -= group.map.getGidOwner(object.gid).tileHeight;

        switch (object.type.toLowerCase())
        {
            case "player_start":
                // Create the player and add it to the PlayState
                var player:Player = new Player(x, y);
                state.player = player;

            case "coin":
                // Create a coin and add it to the coin group in the playstate
                state.coins.add(new Coin(x + 4, y + 4));

            case "enemy":
                state.enemies.add(new Enemy(x + 4, y, Std.parseInt(object.custom.get("type"))));
        }
    }

    // Creates the collision between objects and the level
    public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
    {
        if (collidableTileLayers != null)
        {
            for (map in collidableTileLayers)
            {
                // IMPORTANT: Always collide the map with objects, not the other way around.
                // This prevents odd collision errors (collision separation code off by 1 px).
                return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
            }
        }
        return false;
    }

    // Loads the different tilemaps using their properties to define what kind of tiles they are
    private function loadTileMaps()
    {
        for (tileLayer in layers)
        {
            // We retrieve the tilesheet from the properties of the tilemap
            var tileSheetName = tileLayer.properties.get("tilesheet");

            if (tileSheetName == null)
                throw "'tilesheet' property not defined for the '" + tileLayer.name + "' layer. Please add the property
                        to the layer.";

            // Look for the specified tileset in the list of tilesets of a tilesheet
            var tileSet:TiledTileSet = null;
            for (ts in tilesets)
            {
                if (ts.name == tileSheetName)
                {
                    tileSet = ts;
                    break;
                }
            }

            if (tileSet == null)
                throw "Tileset '" + tileSheetName + "' not found. Did you mispell the 'tilesheet' property in '" +
                tileLayer.name + "' layer?";

            var imagePath = new Path(tileSet.imageSource);
            var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

            var tilemap:FlxTilemap = new FlxTilemap();
            tilemap.widthInTiles = width;
            tilemap.heightInTiles = height;
            tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);

            if (tileLayer.properties.contains("nocollide"))
            {
                backgroundTiles.add(tilemap);
            }
            else
            {
                if (collidableTileLayers == null)
                    collidableTileLayers = new Array<FlxTilemap>();

                foregroundTiles.add(tilemap);
                collidableTileLayers.push(tilemap);
            }
        }
    }
}
