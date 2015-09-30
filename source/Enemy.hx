package ;

import flixel.FlxObject;
import flixel.FlxSprite;

class Enemy extends FlxSprite{

    public var speed:Float = 140;
    public var type(default, null):Int;

    public function new(X:Float=0, Y:Float=0, Type:Int)
    {
        super(X, Y);

        type = Type;
        loadGraphic("assets/images/enemy-" + Std.string(Type) + ".png", true, 16, 16);

        // We set how the sprite is fliped depending on which direction the object faces
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        // We add the animations by selecting the sprites
        animation.add("d", [0,1,0,2], 6, false);
        animation.add("lr", [3,4,3,5], 6, false);
        animation.add("u", [6,7,6,8], 6, false);

        // We add some drag for feel
        drag.x = drag.y = 10;

        // We change its size making it smaller than the sprite so that it fits in the map
        width = 8;
        height = 14;

        // We change the offset to adjust for the new size
        offset.x = 4;
        offset.y = 2;
    }

    override public function draw():Void
    {
        if ((velocity.x != 0 || velocity.y != 0 ) && touching == FlxObject.NONE)
        {
            if (Math.abs(velocity.x) > Math.abs(velocity.y))
            {
                if (velocity.x < 0)
                    facing = FlxObject.LEFT;
                else
                    facing = FlxObject.RIGHT;
            }
            else
            {
                if (velocity.y < 0)
                    facing = FlxObject.UP;
                else
                    facing = FlxObject.DOWN;
            }

            switch (facing)
            {
                case FlxObject.LEFT, FlxObject.RIGHT:
                    animation.play("lr");

                case FlxObject.UP:
                    animation.play("u");

                case FlxObject.DOWN:
                    animation.play("d");
            }
        }
        super.draw();
    }
}
