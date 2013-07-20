package wighawag.view.displaylist;

import wighawag.asset.NinePatch;
using wighawag.asset.NinePatchUtils;

class NinePatchElement extends EmptyContainer{

    private var ninePatch : NinePatch;


    public function new(ninePatch : NinePatch, width : Float, height : Float) {
        super();

        this.ninePatch = ninePatch;
        this.width = width;
        this.height = height;
    }



    override public function render(program:DisplayListProgram, timeElapsed:Float):Void {

        //Compute width and height
        //TODO what about children height and width (+ their relative position)?

        ninePatch.draw(program, Std.int(x), Std.int(y), Std.int(width), Std.int(height));
        super.render(program, timeElapsed);
    }


}
