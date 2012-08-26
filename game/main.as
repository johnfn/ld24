package {
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import flash.display.MovieClip;

  import Entity;
  import Hooks;
  import Map;
  import Color;

  [SWF(backgroundColor="#00000000", width="500", height="500", frameRate="30", wmode="transparent")]
  public class main extends Sprite {
    [Embed(source = "../data/map.png")] static public var MapClass:Class;

    public function main():void {
      var container:MovieClip = new MovieClip();
      container.x = 0;
      container.y = 0;
      stage.addChild(container);

      var m:Map = new Map(25, 25, C.size).fromImage(MapClass, {
        (new Color(0, 0, 0).toString()) : { type: Block, gfx: C.SpritesheetClass, spritesheet: [1, 2], fixedSize: true, roundOutEdges: true },
        (new Color(0, 0, 255).toString()) : { type: Treasure, gfx: C.SpritesheetClass, spritesheet: [2, 0], fixedSize: true },
        (new Color(0, 255, 0).toString()) : { type: Professor, gfx: C.SpritesheetClass, spritesheet: [6, 3], fixedSize: true },
        (new Color(255, 0, 0).toString()) : { type: PushBlock, gfx: C.SpritesheetClass, spritesheet: [0, 5], fixedSize: true },
        (new Color(255, 0, 255).toString()) : { type: EasterEgg, gfx: C.SpritesheetClass, spritesheet: [7, 1], fixedSize: true },
        (new Color(0, 255, 255).toString()) : { type: SmashBlock, gfx: C.SpritesheetClass, spritesheet: [1, 0], fixedSize: true },
        (new Color(0, 0, 200).toString()) : { type: Gate, gfx: C.SpritesheetClass, spritesheet: [3, 4], fixedSize: true },
        (new Color(0, 0, 101).toString()) : { type: Telephone, gfx: C.SpritesheetClass, spritesheet: [4, 3], fixedSize: true },
        (new Color(100, 100, 100).toString()) : { type: Terminal, gfx: C.SpritesheetClass, spritesheet: [3, 3], fixedSize: true },
        (new Color(101, 101, 101).toString()) : { type: AlmostStatic, gfx: C.SpritesheetClass, spritesheet: [5, 4], fixedSize: true },
        (new Color(102, 102, 102).toString()) : { type: AlmostStatic, gfx: C.SpritesheetClass, spritesheet: [6, 4], fixedSize: true }
      }).startingCorner(new Vec(4, 0));

      Fathom.initialize(container, m);

      Fathom.camera.setEaseSpeed(3);

      var i:Inventory = new Inventory();
      var c:Character = new Character(2 * 25 + 2, 5 * 25, MapClass, m, i);
      var h:HUD       = new HUD(c);
    }
  }
}
