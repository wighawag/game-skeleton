package wighawag.view.displaylist;

import wighawag.asset.font.FontFace;
import wighawag.asset.font.FontUtils;
import flash.geom.Rectangle;
class TextElement implements DisplayElement{

    public var x : Float = 0;
    public var y : Float = 0;
    public var width(default, null) : Float = 0;
    public var height(default, null) : Float = 0;

    public var text(default, null) : String;
    public var fontFace(default, null) : FontFace;

    public function new(text : String, fontFace : FontFace) {
        this.text = text;
        this.fontFace = fontFace;
        width = fontFace.widthOf(text);
        height = fontFace.heightOf(text);
    }

    public function render(program:DisplayListProgram, timeElapsed:Float):Void {
        fontFace.draw(program, text, x, y);
    }

    public function pixelCollide(localX:Float, localY:Float):Bool {
        //TODO
        return new Rectangle(0,0, width, height).contains(localX,localY);
    }


}
