package wighawag.game.cupofcoffee.navigation;

import wighawag.game.cupofcoffee.view.FocusFollower;
import flash.geom.Point;
import wighawag.game.cupofcoffee.model.Focus;
import wighawag.game.cupofcoffee.model.PhysicsEngine;
import wighawag.game.cupofcoffee.model.EntityPopulator;
import wighawag.system.ModelComponent;
import wighawag.game.logic.AISystem;
import wighawag.space.SpatialHashingSystem;
import wighawag.controls.FakeAccelerometer;
import wighawag.controls.NMEAccelerometer;
import wighawag.controls.OpenFLKeyboard;
import wighawag.game.cupofcoffee.controller.GameController;
import wighawag.system.SystemComponent;
import wighawag.system.Model;
import wighawag.core.StateComponent;
import wighawag.core.EntityComponentProvider;
import wighawag.core.EntityTypeParameters;
import wighawag.view.displaylist.EmptyContainer;
import wighawag.view.displaylist.DisplayListLayer;
import flash.geom.Rectangle;
import wighawag.view.View;
import wighawag.gpu.GPUContext;
import wighawag.asset.load.BitmapAsset;
import flash.events.KeyboardEvent;
import wighawag.statemachine.State;
import msignal.Signal;
using wighawag.asset.spritesheet.SpriteUtils;
import wighawag.view.Camera2D;
import wighawag.controls.StageButtonPanel;

import wighawag.view.GPUSpriteViewLayer;
import wighawag.view.BasicGPUSpriteViewFactory;


class Game implements State<NavigationState>{

    private var eventName : String = null;
    private var worldModel : Model;
    private var view : View<GPUContext, BitmapAsset>;
    private var controllerSystem : SystemComponent;

    private var navigationState : NavigationState;

    private var displayListLayer : DisplayListLayer;

    private var camera : Camera2D;
    private var focus : Focus;

    public function new() {

    }

    public function onEnter(model:NavigationState):Void {
        this.navigationState = model;

        Report.anInfo("Game", "Entering Game");
        eventName = null;
        flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);

        navigationState.renderer.setAntiAlias(0);
        navigationState.renderer.setClearColor(0,0,0,1);

        // the assets should be already loaded at this point,
        // so we just need to upload to the gpu
        var spriteBatch =  navigationState.spriteBatch;
        var bitmapAssets : Array<BitmapAsset> = spriteBatch.all().getBitmapAssets();
        navigationState.renderer.uploadTextures(bitmapAssets);

        //create the camera
        camera = new Camera2D(navigationState.renderer, new Point(320,240));

        //TODO same camera ?
        var root = new EmptyContainer();
        displayListLayer = new DisplayListLayer(root, camera);

        //and an empty view while the statemachine prepare the new state
        //TODO can be removed as startGame is instantanous
        view = new View(navigationState.renderer,[displayListLayer]);

        var keyboard = new OpenFLKeyboard();
        controllerSystem = new GameController(keyboard);
        startGame();
    }


    public function startGame() : Void{

        // create the systems
        //physics, populator,controller, AI,...

        var physicsEngine = new PhysicsEngine();

        var systems : Array<ModelComponent> = [new EntityPopulator(navigationState.entityTypeLibrary)];
        systems.push(controllerSystem);
        systems.push(new AISystem());
        systems.push(physicsEngine);
        systems.push(new SpatialHashingSystem());

        worldModel = new Model();                draw
        worldModel.setup(systems);

        //setup the view
        view = new View(navigationState.renderer, [new GPUSpriteViewLayer(worldModel, new BasicGPUSpriteViewFactory(navigationState.spriteBatch), camera), displayListLayer]);
    }


    //this is the main loop
    public function update(dt:Float, model:NavigationState, event:Signal1<String>, elapsedTime:Float):Void {
        if (eventName != null){
            event.dispatch(eventName);
            return;
        }

        //update the model
        if (worldModel != null){
            worldModel.update(dt);
        }

        //update the view to reflect what changed to the screen
        view.update(dt);

    }

    public function onLeave(model:NavigationState):Void {
        model.renderer.reset();
        displayListLayer.dispose();
        flash.Lib.current.stage.removeEventListener (KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function onKeyUp(event : KeyboardEvent) : Void{
        if (event.keyCode == 27) {
            event.stopImmediatePropagation ();
            eventName = "Quit";
        }
    }
}
