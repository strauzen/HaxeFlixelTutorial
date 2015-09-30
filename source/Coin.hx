package ;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Coin extends FlxSprite{

    public function new(X:Float=0, Y:Float=0)
    {
        super(X, Y);

        loadGraphic(AssetPaths.coin__png, false, 8, 8);
    }

    override public function kill():Void
    {
        alive = false;

        // We call an animation made with Tween then proceed to call a function to end the kill process
        FlxTween.tween(this, { alpha:0, y:y - 16 }, .33, {ease:FlxEase.circOut, complete:finishKill } );
    }

    private function finishKill(_):Void
    {
        // By setting exist to false we make the game stop drawing the coins
        exists = false;
    }
}
