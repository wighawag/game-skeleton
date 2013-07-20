package wighawag.view.displaylist;

import flash.geom.Rectangle;

interface DisplayElement {

    public var x : Float;
    public var y : Float;
    public var width(default, null) : Float;
    public var height(default, null) : Float;

    public function render(program : DisplayListProgram, timeElapsed : Float)  : Void;
    public function pixelCollide(x : Float, y : Float) : Bool;

}
