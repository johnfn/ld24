package {
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import flash.display.MovieClip;

  import Entity;
  import Hooks;
  import Map;
  import Color;

  [SWF(backgroundColor="#000000", width="500", height="500", frameRate="30")]
  public class main extends Sprite {
    [Embed(source = "../data/map.png")] static public var MapClass:Class;
    [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

    public function main():void {
      var container:MovieClip = new MovieClip();
      container.x = 0;
      container.y = 0;
      stage.addChild(container);

      //TODO: spritesheet: [0, 0]

      var m:Map = new Map(25, 25, C.size).fromImage(MapClass, {
        (new Color(0, 0, 0).toString()) : { type: Block, gfx: SpritesheetClass, spritesheet: [1, 2], fixedSize: true, roundOutEdges: true }
      });

      Fathom.initialize(container, m);

      Fathom.camera.setEaseSpeed(10);

      //var h:HUD = new HUD();
      var x:Character = new Character(40, 40, MapClass);
    }
  }
}
