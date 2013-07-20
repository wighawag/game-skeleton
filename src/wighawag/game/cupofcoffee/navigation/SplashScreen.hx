package wighawag.game.cupofcoffee.navigation;

import wighawag.asset.entity.EntityTypeLibrary;
import wighawag.ui.BasicUIAssetProvider;
import wighawag.statemachine.State;
import msignal.Signal;
import promhx.Promise;

class SplashScreen implements State<NavigationState>{

    private var eventName : String = null;

    public function new() {

    }

    public function onEnter(model:NavigationState):Void {
        Report.anInfo("SplashScreen", "Entering SplashScreen");
        eventName = null;
        Promise.when(model.loadUIAssets(), model.loadEntityTypes()).then(function(uiAssetProvider : BasicUIAssetProvider, entityTypeLibrary : EntityTypeLibrary):Void{eventName = "SplashEnd";});


    }

    public function update(dt:Float, model:NavigationState, event:Signal1<String>, elapsedTime:Float):Void {
        if (elapsedTime > 1.5 && eventName != null){
            event.dispatch(eventName);
        }
    }

    public function onLeave(model:NavigationState):Void {
    }




}

