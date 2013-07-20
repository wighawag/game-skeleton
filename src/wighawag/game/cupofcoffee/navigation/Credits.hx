package wighawag.game.cupofcoffee.navigation;

import wighawag.statemachine.State;
import msignal.Signal;

class Credits implements State<NavigationState>{

    public function new() {

    }

    public function onEnter(model:NavigationState):Void {
        Report.anInfo("Credits", "Entering Credits");
    }

    public function update(dt:Float, model:NavigationState, event:Signal1<String>, elapsedTime:Float):Void {
    }

    public function onLeave(model:NavigationState):Void {
    }


}
