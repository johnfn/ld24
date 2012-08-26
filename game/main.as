package {
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.filters.DropShadowFilter;
  import flash.text.TextFormat;

  import Entity;
  import Hooks;
  import Map;
  import Color;

  [SWF(backgroundColor="#00000000", width="500", height="500", frameRate="30", wmode="transparent")]
  public class main extends Sprite {
    [Embed(source = "../data/map.png")] static public var MapClass:Class;

    public static var MainObj:main;

    var scrollBG:ScrollingBackground;

    private function addBG():void {
      scrollBG = new ScrollingBackground();
      addChild(scrollBG);
      addEventListener(Event.ENTER_FRAME, scroll);
    }

    private function scroll(e:Event):void {
      scrollBG.move(1, 0);
      scrollBG.x = -Fathom.camera.x;
      scrollBG.y = -Fathom.camera.y;
    }

    public function showEndGameScreen():void {
      var eg = new C.EndGameClass();
      var c:MovieClip = new MovieClip();
      c.addChild(eg);
      c.scaleX = 2;
      c.scaleY = 2;

      stage.addChild(c);

      var newFormat:TextFormat = new TextFormat();
      newFormat.size = 16;
      newFormat.font = "Arial";

      var finaltext:TextField = new TextField();
      finaltext.text = "You turn into Godzilla. You win by default!";
      finaltext.wordWrap = true;
      finaltext.x = 40;
      finaltext.y = 200;
      finaltext.width = 200;
      finaltext.filters = [new DropShadowFilter(1.0, 45, 0, 1, 0, 0, 1)];
      finaltext.textColor = 0xffffff;
      finaltext.selectable = false;
      finaltext.setTextFormat(newFormat);
      stage.addChild(finaltext);

      var text2:TextField = new TextField();
      text2.text = "Later you terrorize Tokyo just for the heck of it.";
      text2.wordWrap = true;
      text2.x = 40;
      text2.y = 400;
      text2.width = 400;
      text2.filters = [new DropShadowFilter(1.0, 45, 0, 1, 0, 0, 1)];
      text2.textColor = 0xffffff;
      text2.selectable = false;
      stage.addChild(text2);
      text2.setTextFormat(newFormat);
    }

    public function main():void {
      addBG();
      MainObj = this;

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
      }).startingCorner(new Vec(3, 1));

      Fathom.initialize(container, m);

      Fathom.camera.setEaseSpeed(3);

      var i:Inventory = new Inventory();
      var c:Character = new Character(2 * 25 + 2, 5 * 25, C.CharacterClass, m, i);
      var h:HUD       = new HUD(c);
    }
  }
}

class ScrollingBackground extends ScrollingLayer {
  [Embed(source = "../data/bg.png")] static public var BGClass:Class;
  private var bitmapClass:Class
  public function ScrollingBackground() {
    scrollingBitmap = new BGClass().bitmapData;
  }
}
