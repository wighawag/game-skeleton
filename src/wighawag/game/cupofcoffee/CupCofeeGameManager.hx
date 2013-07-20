package wighawag.game.cupofcoffee;

import wighawag.gpu.GPURenderer;
import wighawag.gpu.GPUContext;
import wighawag.asset.load.AssetManager;
import wighawag.asset.renderer.Renderer;
import wighawag.asset.load.BitmapAsset;
import wighawag.statemachine.StateMachine;
import wighawag.application.ApplicationManager;
import wighawag.game.cupofcoffee.navigation.NavigationState;
import wighawag.game.cupofcoffee.navigation.Credits;
import wighawag.game.cupofcoffee.navigation.Game;
import wighawag.game.cupofcoffee.navigation.MainMenu;
import wighawag.game.cupofcoffee.navigation.SplashScreen;
import haxe.Timer;

class CupCofeeGameManager implements ApplicationManager {

    private var lastTime : Float;
    private var timer : Timer;

    private var stateMachine : StateMachine<NavigationState>;

    private var renderer  : GPURenderer;
    private var assetManager : AssetManager;

    public function new(assetManager : AssetManager) {
        this.assetManager = assetManager;

        renderer = new GPURenderer();
        renderer.init().then(launchApp).error(handleError);

    }

    private function handleError(error : Dynamic) : Void{
        Report.anError("CupOfCoffeeGameManager", "error while initialising the GPURenderer", error);
    }

    private function launchApp(gpuRenderer : GPURenderer) : Void{

        //initialise the meta model of the game (menu....)

        var splashScreen = new SplashScreen();
        var mainMenu = new MainMenu();
        var game = new Game();
        var credits = new Credits();
        stateMachine = new StateMachine(new NavigationState(assetManager, renderer));
        stateMachine.addTransition(splashScreen,"SplashEnd", mainMenu);
        stateMachine.addTransition(mainMenu,"Play", game);
        stateMachine.addTransition(game,"Quit", mainMenu);

        // start if ready ( start has been called)
        if(timer != null){
            lastTime = Timer.stamp();
            timer.run = update;
        }
    }

    public function start() : Void{
    // TODO 25 should be set somewhere else
        timer = new Timer(25);

        // start if the meta model has been setup
        if(stateMachine != null){
            lastTime = Timer.stamp();
            timer.run = update;
        }
    }

    // update the state machine, this is where the main loop is.
    // depending on the current state (menu, splash scree, game) the action will differ
    // look at the corresponding State
    private function update() : Void{
        var now : Float = Timer.stamp();
        var delta : Float = now - lastTime;
        lastTime = now;
        stateMachine.update(delta);
    }

}

