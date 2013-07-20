package wighawag.game.cupofcoffee.navigation;

import wighawag.view.displaylist.NinePatchElement;
import wighawag.view.displaylist.EmptyContainer;
import wighawag.view.displaylist.DisplayListLayer;
import flash.geom.Rectangle;
import wighawag.ui.BasicGenericUI;
import wighawag.asset.load.BitmapAsset;
import wighawag.gpu.GPUContext;
import flash.events.KeyboardEvent;
import wighawag.view.View;
import wighawag.ui.view.UILayer;
import wighawag.asset.load.Batch;
import wighawag.asset.spritesheet.Sprite;
import wighawag.ui.core.UIActionElement;
import wighawag.ui.BasicUIAssetProvider;
import wighawag.statemachine.State;
import msignal.Signal;
import promhx.Promise;

import wighawag.view.Camera2D;

class MainMenu implements State<NavigationState>{

    private var eventName : String = null;

    private var view : View<GPUContext, BitmapAsset>;

    private var ui : BasicGenericUI<BasicUIAssetProvider>;

    private var navigationState : NavigationState;

    private var displayListLayer : DisplayListLayer;

    public function new() {
    }

    public function onEnter(model:NavigationState):Void {
        this.navigationState = model;

        Report.anInfo("MainMenuState", "Entering Main Menu");
        eventName = null;
        //TODO use assetManager instead of flash.Assets? (same in OptionMenuState)
        ui = new BasicGenericUI(openfl.Assets.getText("assets/mainmenu.xml"), openfl.Assets.getText("assets/mainmenu.json"),model.uiAssetProvider);
        var playButton = ui.getActionElement("playButton");


        //TODO should show the button only after asset are loaded
        navigationState.loadSprites();

        playButton.onTriggered.add(function(button : UIActionElement):Void{
            eventName = "Play";
        });


        navigationState.renderer.setAntiAlias(2);
        navigationState.renderer.setClearColor(1,1,1,1);

        var bitmapAssets : Array<BitmapAsset> = model.uiAssetProvider.getRequiredBitmapAssets();
        model.renderer.uploadTextures(bitmapAssets);

        var camera = new Camera2D(model.renderer, null);

        var uiLayer = new UILayer(ui.root, camera);

        var root = new EmptyContainer();
        var square = new NinePatchElement(navigationState.uiAssetProvider.ninePatches.get("greenButton"), 100,100);
        square.x = 30;
        square.y = 30;
        root.addChild(square);
        displayListLayer = new DisplayListLayer(root, camera);



        view = new View(model.renderer, [uiLayer, displayListLayer]);
        flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);
    }

    public function update(dt:Float, model : NavigationState, event : Signal1<String>, elapsedTime : Float):Void {
        view.update(dt);
        if (eventName != null){
            event.dispatch(eventName);
        }
    }

    public function onLeave(model:NavigationState):Void {
        flash.Lib.current.stage.removeEventListener (KeyboardEvent.KEY_UP, onKeyUp);
        model.renderer.reset();
        displayListLayer.dispose();
        //flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    private function onKeyUp(event : KeyboardEvent) : Void{
        if (event.keyCode == 27) {
            event.stopImmediatePropagation ();
            //TODO flash.Lib.exit();
        }
    }


}

