package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

class Player extends FlxSprite
{

    public var speed:Float = 200;

    public function new(X:Float=0, Y:Float=0)
    {
        super(X, Y);

        // Load an asset from the asset folder
        loadGraphic(AssetPaths.player__png, true, 16, 16);

        // Notify that the sprite is to be fliped when facing right but not when
        // facing left
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        // Add the animations from the Spritesheet to the Sprite
        animation.add("lr", [3, 4, 3, 5, 3], 6, false);
        animation.add("u", [6, 7, 6, 8, 6], 6, false);
        animation.add("d", [0, 1, 0, 2, 0], 6, false);

        // Set a drag speed to the sprite to make the movement feel more
        // realistic to the user input
        drag.x = drag.y = 1600;
        setSize(8, 14);
        offset.set(4,2);
    }

    override public function update():Void
    {
        movement();
        super.update();
    }

    private function movement():Void
    {
        // We declare local variables to check if movement keys are pressed
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;

        // We set the variables to true if the keys are being pressed
        _up = FlxG.keys.anyPressed(["UP", "W"]);
        _down = FlxG.keys.anyPressed(["DOWN", "S"]);
        _left = FlxG.keys.anyPressed(["LEFT", "A"]);
        _right = FlxG.keys.anyPressed(["RIGHT", "D"]);

        // If two directions that cancel each other are being pressed we cancel
        // the key press
        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        // We check if the player is actually moving
        if (_up || _down || _left || _right)
        {
            // First we calculate the angle towards where the player is facing
            // this tells us if he is moving in diagonal or a straight line
            var mA:Float = calculateMovementAngle(_up, _down, _left, _right);
            // Then we place a point in front of the player and rotate him
            // to the angle he is moving towards, this gives us the equivalent
            // speed for that angle
            FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);

            // If the player is moving we change its animation to match the
            // direction it is facing
            if ((velocity.x != 0 || velocity.y != 0) &&
                touching == FlxObject.NONE)
                {
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
        }
    } // End of movement

    private function calculateMovementAngle(Up:Bool, Down:Bool,
                                            Left:Bool, Right:Bool):Float
    {
        // We check towards which angle the player is moving
        var mA:Float = 0;
        if (Up)
        {
            mA = -90;
            if (Left)
                mA -= 45;
            else if (Right)
                mA += 45;

            // Set the sprite facing up
            facing = FlxObject.UP;
        }
        else if (Down)
        {
            mA = 90;
            if (Left)
                mA += 45;
            else if (Right)
                mA -=45;

            // Set the sprite facing down
            facing = FlxObject.DOWN;
        }
        else if (Left)
        {
            mA = 180;

            // Set the sprite facing down
            facing = FlxObject.LEFT;
        }
        else if(Right)
        {
            mA = 0;

            // Set the sprite facing down
            facing = FlxObject.RIGHT;
        }

        return mA;
    }
}
