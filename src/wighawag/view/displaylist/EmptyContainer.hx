package wighawag.view.displaylist;

import flash.geom.Rectangle;

class EmptyContainer implements DisplayElementContainer{

    public var x : Float = 0;
    public var y : Float = 0;
    public var width(default, null) : Float = 0;
    public var height(default, null) : Float = 0;

    public var children:Array<DisplayElement>;



    public function new() {
        children = new Array();

        //TODO implement width and height ?
    }



    public function addChild(element:DisplayElement):Void {
        children.remove(element);
        children.push(element);
    }

    public function removeChild(element:DisplayElement):Void {
        children.remove(element);
    }


    public function render(program:DisplayListProgram, timeElapsed:Float):Void {
        program.translate(x,y);
        //program.scale(1); //TODO
        for(element in children){
            element.render(program, timeElapsed);
        }
        program.translate(-x,-y); // TODO use states push and pop
    }

    public function pixelCollide(localX:Float, localY:Float):Bool {
        //TODO
        return new Rectangle(0,0, width, height).contains(localX,localY);
    }


}

