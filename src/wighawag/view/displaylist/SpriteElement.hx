package wighawag.view.displaylist;


import wighawag.asset.spritesheet.Sprite;
import flash.geom.Rectangle;

using wighawag.view.GPUSpriteUtils;

class SpriteElement extends EmptyContainer{

    private var sprite : Sprite;
    private var animation : String;

    public function new(sprite : Sprite, animation : String) {
        super();
        this.sprite = sprite;
        this.animation = animation;
    }


    override public function render(program:DisplayListProgram, timeElapsed:Float):Void {

        //Compute width and height
        var frame = sprite.getFrame(animation, timeElapsed);
        var subTexture = frame.texture;
        width = subTexture.frameWidth;
        height = subTexture.frameHeight;
        //TODO what about children height and width (+ their relative position)?


        sprite.draw(program, animation, timeElapsed, Std.int(x), Std.int(y));
        super.render(program, timeElapsed);
    }


}
