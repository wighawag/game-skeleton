package wighawag.game.cupofcoffee;

import wighawag.console.WConsole;
import flash.events.ErrorEvent;
import flash.errors.Error;
import haxe.PosInfos;
import wighawag.application.Application;
import openfl.Assets;
import wighawag.asset.load.ResourceMap;
import wighawag.asset.load.NMEAssetManager;
import wighawag.asset.load.AssetManager;
import wighawag.report.DefaultLogger;
import wighawag.report.ReportUtil;

class GameMain {

    private static var console : WConsole;

    public function new(){

    }

    //Doc : Entry Point
    public static function main() {

        // on screen console
        console = new WConsole();

        //redirect trace
        haxe.Log.trace = myTrace;

        // testing trace
        Report.anInfo("GameMain","Logger in place");

        // bootstrap the asset manager with the resource map that list all the resources available and their respective location
        NMEAssetManager.bootstrap("assets/resources.xml").then(launchGame);

        //add some global error handling (supported only on flash)
        #if flash
	    flash.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(flash.events.UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
	    #end
    }

    private static function launchGame(resourceMap : ResourceMap) : Void{
        // when the resource map is loaded initialise the asset manager
        var assetManager = new NMEAssetManager(resourceMap);

        //and create the application
        var app:Application = new Application(new CupCofeeGameManager(assetManager));
        flash.Lib.current.addChild(app);

        // The Application will call call CupOfCoffeeGameManager.start() when ready
    }

    #if flash
	public static function onUncaughtError(event:flash.events.UncaughtErrorEvent) : Void{

		var extra = "";
		if(Std.is(event.error, Error)){
			var stackTrace = event.error.getStackTrace();
			if(stackTrace != null){
				extra = stackTrace;
			}
		}
		Report.anError("UncaughtError", event.error, extra);
		//event.preventDefault();

//		// TODO make sure cast does not loose teh info ()
//		if (Std.is(event.error, Error)){
//			var error:Error = cast(event.error);
//
//		}
//		else if (Std.is(event.error, ErrorEvent)){
//			var errorEvent:ErrorEvent = cast(event.error);
//			// do something with the error
//		}
//		else
//		{
//			// a non-Error, non-ErrorEvent type was thrown and uncaught
//		}
	}
	#end

    public static function myTrace(severity : Dynamic, ?posInfos : PosInfos) : Void
    {
        var message = ReportUtil.getMessage(severity, posInfos);

        switch(severity){
            case Report.ERROR: console.show(message);
            default: console.print(message);
        }

        DefaultLogger.trace(severity, posInfos);

    }
}

