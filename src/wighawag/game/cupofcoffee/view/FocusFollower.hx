package wighawag.game.cupofcoffee.view;

import wighawag.game.cupofcoffee.model.Focus;
import wighawag.view.Camera2D;
import wighawag.gpu.GPUContext;
import wighawag.view.ViewLayer;
class FocusFollower implements ViewLayer<GPUContext>{

    public var camera : Camera2D;
    private var focus : Focus;
    private var follow : Bool;

    public function new(camera : Camera2D, focus : Focus) {
        this.camera = camera;
        this.focus = focus;
        follow = true;
    }

    public function render(context:GPUContext):Void {
        if(follow){
            camera.setFocus(focus.area);
        }
    }


    public function pause() : Void{
        follow = false;
    }

    public function resume() : Void{
        follow = true;
    }

    public function dispose() : Void{
        camera = null;
        focus = null;
    }

}
