package wighawag.view.displaylist;

import wighawag.view.ViewLayer;
import wighawag.gpu.GPUContext;
import wighawag.view.TexturedQuadProgram;
import wighawag.view.Camera2D;
import haxe.Timer;


import flash.events.TouchEvent;
import flash.display.Stage;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import flash.events.MouseEvent;



class DisplayListLayer implements ViewLayer<GPUContext>{

    private var root : DisplayElement;
    private var program : DisplayListProgram;
    private var lastTime : Float;
    private var timeElapsed : Float;
    private var stage : Stage;
    private var camera : Camera2D;

    public function new(root : DisplayElement, camera : Camera2D) {
        this.root = root;
        this.camera = camera;
        lastTime = Timer.stamp();
        timeElapsed = 0;

        stage = flash.Lib.current.stage;
        if(Multitouch.supportsTouchEvents){
            Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
            stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        }else{
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }

        program = new TexturedQuadProgram(camera);
    }

    public function render(context:GPUContext):Void {
        var now = Timer.stamp();
        var delta = now - lastTime;
        lastTime = now;
        timeElapsed += delta;

        context.addProgram(program);
        program.reset();
        root.render(program, timeElapsed);
        program.upload();
    }


    private function onTouchBegin(event : TouchEvent) : Void{
        stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        registerEvent(event.stageX, event.stageY, true);
    }

    private function onTouchEnd(event : TouchEvent) : Void{
        stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        registerEvent(event.stageX, event.stageY, false);
    }

    private function onMouseDown(event : MouseEvent) : Void{
        registerEvent(event.stageX, event.stageY, true);
    }

    private function onMouseUp(event : MouseEvent) : Void{
        registerEvent(event.stageX, event.stageY, false);
    }

    //TODO :
    //TODO  keep track of which entities are mouseOver and remove them when mouseOut
    private function onMouseMove(event : MouseEvent) : Void{

    }



    //TODO use quad tree or other similar space hashing technique to speed up mouse detection
    private function registerEvent(x : Float, y : Float, down : Bool) : Void{
        // TODO deal with order ? go backward ? to not trigger for several entities ?
        var element = traverse(root,x , y);
        if(element != null){
            if(down){
            //element.triggerMouseDown();
            }else{
                element.triggerClick();
            }
        }


    }


    private function traverse(displayElement : DisplayElement, x : Float, y : Float) : InteractiveElement{
        var found : InteractiveElement = null;

        if(Std.is(displayElement, DisplayElementContainer)){
            var container : DisplayElementContainer = cast(displayElement);

            var i = container.children.length - 1;
            while(i >= 0){
                found = traverse(container.children[i], (x - container.x) / camera.scale, (y - container.y) / camera.scale);
                if(found != null){
                    break;
                }
                i --;
            }
        }

        if(found == null && Std.is(displayElement, InteractiveElement) && displayElement.pixelCollide(x - displayElement.x,y - displayElement.y)){
            found = cast(displayElement);
        }

        return found;
    }

    public function dispose() : Void{
        if(Multitouch.supportsTouchEvents){
            Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
            stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
            stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        }else{
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
    }


}
