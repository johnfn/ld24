package {
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import flash.display.MovieClip;

  import Entity;
  import Hooks;
  import Map;
  import Color;

  public class main extends Sprite {

    [Embed(source = "../data/map.png")] static public var MapClass:Class;

    public function main():void {
      var container:MovieClip = new MovieClip();
      container.x = 0;
      container.y = 0;
      stage.addChild(container);

      Fathom.initialize(container);

      var m:Map = new Map(20, 20, C.size).fromImage(null, {
        (new Color(255, 255, 255).toString()) : Tile,
        (new Color(0, 0, 255).toString()) : DialogTrigger,
        (new Color(0, 0, 200).toString()) : TreasureChest,
        (new Color(255, 0, 0).toString()) : Monster,
        (new Color(0, 255, 0).toString()) : Crystal,
        (new Color(0, 255, 255).toString()) : IceBlock
      });

      //var h:HUD = new HUD();
      //var x:Character = new Character(m, h, 100, 100);
    }
  }
}
