package wighawag.game.cupofcoffee.navigation;


import wighawag.asset.spritesheet.Sprite;
import wighawag.asset.load.TextAsset;
import wighawag.asset.font.FontFace;
import wighawag.asset.load.Batch;
import wighawag.asset.NinePatch;
import promhx.Promise;
import wighawag.ui.BasicUIAssetProvider;
import wighawag.asset.NinePatchLibrary;
import wighawag.asset.font.FontFaceLibrary;
import wighawag.asset.entity.EntityTypeLibrary;
import wighawag.asset.spritesheet.SpriteLibrary;
import wighawag.asset.spritesheet.TextureAtlasLibrary;
import wighawag.asset.load.AssetManager;
import wighawag.asset.load.Asset;
import wighawag.gpu.GPURenderer;

class NavigationState {

    public var renderer : GPURenderer;
    public var assetManager : AssetManager;
    public var textureAtlasLibrary : TextureAtlasLibrary;
    public var fontFaceLibrary : FontFaceLibrary;
    public var spriteLibrary : SpriteLibrary;
    public var ninePatchLibrary : NinePatchLibrary;
    public var entityTypeLibrary : EntityTypeLibrary;

    public var spriteBatch : Batch<Sprite>;
    private var requiredSpritesPromise : Promise<Batch<Sprite>>;


    public function new(assetManager : AssetManager, renderer : GPURenderer) {

        this.assetManager = assetManager;
        this.renderer = renderer;
        this.textureAtlasLibrary = new TextureAtlasLibrary(assetManager);
        this.fontFaceLibrary = new FontFaceLibrary(assetManager);
        this.ninePatchLibrary = new NinePatchLibrary(textureAtlasLibrary);
    }


    private var spriteLibraryPromise : Promise<SpriteLibrary>;
    public function prepareSpriteLibrary() : Promise<SpriteLibrary> {
        if(spriteLibraryPromise != null){
            return spriteLibraryPromise;
        }
        spriteLibraryPromise = new Promise();

        assetManager.load("sprites.library").then(function(asset : Asset):Void{
          var textAsset : TextAsset = cast(asset);
          spriteLibrary = new SpriteLibrary(textAsset.text, textureAtlasLibrary);
          spriteLibraryPromise.resolve(spriteLibrary);
        });
        return spriteLibraryPromise;
    }



    private var requiredUIAssetsPromise : Promise<BasicUIAssetProvider>;
    public var uiAssetProvider : BasicUIAssetProvider;
    public function loadUIAssets() : Promise<BasicUIAssetProvider>{
        if (requiredUIAssetsPromise != null){
            return requiredUIAssetsPromise;
        }
        requiredUIAssetsPromise = new Promise();
        loadNinePatch();
        return requiredUIAssetsPromise;
    }
    //TODO Parralel download  :
    private function loadNinePatch() : Void{
        ninePatchLibrary.fetchSkin("ui.9").then(function(ninePatchBatch : Batch<NinePatch>):Void{
            loadFontFaces(ninePatchBatch);
        });
    }
    private function loadFontFaces(ninePatchBatch : Batch<NinePatch>) : Void{
        fontFaceLibrary.fetchBatch(["afont"]).then(function(fontFaces : Batch<FontFace>):Void{
            onUIAssetsLoaded(new BasicUIAssetProvider(ninePatchBatch, fontFaces));
        });
    }
    private function onUIAssetsLoaded(uiAssetProvider : BasicUIAssetProvider) : Void{
        this.uiAssetProvider = uiAssetProvider;
        requiredUIAssetsPromise.resolve(uiAssetProvider);
    }


    private var entityTypeLibraryPromise : Promise<EntityTypeLibrary>;
    public function loadEntityTypes() : Promise<EntityTypeLibrary>{
        if(entityTypeLibraryPromise != null){
            return entityTypeLibraryPromise;
        }
        entityTypeLibraryPromise = new Promise();
        assetManager.load("entityTypes").then(onEntityTypeLibraryLoaded);
        return entityTypeLibraryPromise;
    }
    private function onEntityTypeLibraryLoaded(asset : Asset): Void{
        var textAsset : TextAsset = cast(asset);
        this.entityTypeLibrary = new EntityTypeLibrary(textAsset.text);
        entityTypeLibraryPromise.resolve(entityTypeLibrary);
    }

//    private var gameSpritesPromise : Promise<Batch<Sprite>>;
//    private function getGameSprites(spriteIds : Array<AssetId>) : Promise<Batch<Sprite>>{
//        gameSpritesPromise = new Promise();
//        prepareSpriteLibrary().then(function(sp : SpriteLibrary):Void{
//            spriteLibrary.fetchBatch(spriteIds).then(function(batch : Batch<Sprite>){
//                gameSpritesPromise.resolve(batch);
//            });
//        });
//
//        return gameSpritesPromise;
//    }


    public function loadSprites() : Promise<Batch<Sprite>>{
        if (requiredSpritesPromise != null){
            return requiredSpritesPromise;
        }
        requiredSpritesPromise = new Promise();
        assetManager.load("sprites.library").then(function(asset : Asset):Void{
            var textAsset : TextAsset = cast(asset);
            spriteLibrary = new SpriteLibrary(textAsset.text, new TextureAtlasLibrary(assetManager));
            spriteLibrary.fetchBatch([
            "asteroid",
            "spaceship"
            ]).then(spritesLoaded);
        });

        return requiredSpritesPromise;
    }

    private function spritesLoaded(spriteBatch : Batch<Sprite>): Void{
        this.spriteBatch = spriteBatch;
        requiredSpritesPromise.resolve(spriteBatch);
    }

}
