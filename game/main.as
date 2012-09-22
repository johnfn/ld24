package {
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.filters.DropShadowFilter;
  import flash.text.TextFormat;

  import flash.display.DisplayObject;

  import Entity;
  import Hooks;
  import Map;
  import Color;

  [SWF(backgroundColor="#00000000", width="500", height="500", frameRate="30", wmode="transparent")]
  public class main extends Sprite {
    [Embed(source = "../data/map.png")] static public var MapClass:Class;

    public static var MainObj:main;
    public static var c:Character;
    public static var weather:Particles;

    private var m:Map;

    private var scrollBG:ScrollingBackground;
    private var scrollBG2:ScrollingBackgroundBottom; // Lower
    private var scrollBG3:ScrollingBackgroundBottomOverlay; // Lower - planets

    private function addBG():void {
      scrollBG = new ScrollingBackground();
      addChild(scrollBG);

      scrollBG2 = new ScrollingBackgroundBottom();
      addChild(scrollBG2);

      scrollBG3 = new ScrollingBackgroundBottomOverlay();
      addChild(scrollBG3);

      addEventListener(Event.ENTER_FRAME, scroll);
    }

    private function scroll(e:Event):void {
      if (Fathom.currentMode != 0) return;

      if (m.getTopLeftCorner().y == 0) {
        scrollBG.move(.3, 0);
        scrollBG.x = -Fathom.camera.x * 15/20;
        scrollBG.y = -Fathom.camera.y * 15/20;
        scrollBG.visible = true;
        scrollBG2.visible = false;
        scrollBG3.visible = false;
      } else {
        scrollBG2.move(.3, 0);
        scrollBG3.move(.1, 0);
        scrollBG2.x = -Fathom.camera.x * 15/20;
        scrollBG2.y = -Fathom.camera.y * 15/20;
        scrollBG3.x = -Fathom.camera.x * 15/20;
        scrollBG3.y = -Fathom.camera.y * 15/20;
        scrollBG.visible = false;
        scrollBG2.visible = true;
        scrollBG3.visible = true;
      }
    }

    public function showEndGameScreen():void {
      var eg:* = new C.EndGameClass();
      var c:* = new MovieClip();
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

      Fathom.initialize(stage);

      m = new Map(25, 25, C.size).fromImage(MapClass, {
        (new Color(0, 0, 0).toString()) : { type: Block, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 2), fixedSize: true, roundOutEdges: true },
        (new Color(200, 100, 0).toString()) : { type: BGBlock, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 7), fixedSize: true, roundOutEdges: true },
        (new Color(0, 0, 255).toString()) : { type: Treasure, gfx: C.SpritesheetClass, spritesheet: new Vec(2, 0), fixedSize: true },
        (new Color(0, 255, 0).toString()) : { type: Professor, gfx: C.ProfessorClass, spritesheet: new Vec(0, 0), fixedSize: true },
        (new Color(255, 0, 0).toString()) : { type: PushBlock, gfx: C.SpritesheetClass, spritesheet: new Vec(0, 5), fixedSize: true },
        (new Color(255, 0, 255).toString()) : { type: EasterEgg, gfx: C.SpritesheetClass, spritesheet: new Vec(7, 1), fixedSize: true },
        (new Color(0, 255, 255).toString()) : { type: SmashBlock, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 0), fixedSize: true },
        (new Color(0, 0, 200).toString()) : { type: Gate, gfx: C.SpritesheetClass, spritesheet: new Vec(3, 4), fixedSize: true },
        (new Color(0, 0, 101).toString()) : { type: Telephone, gfx: C.SpritesheetClass, spritesheet: new Vec(4, 3), fixedSize: true },
        (new Color(100, 100, 100).toString()) : { type: Terminal, gfx: C.SpritesheetClass, spritesheet: new Vec(3, 3), fixedSize: true },
        (new Color(101, 101, 101).toString()) : { type: AlmostStatic, gfx: C.SpritesheetClass, spritesheet: new Vec(5, 4), fixedSize: true },
        (new Color(102, 102, 102).toString()) : { type: AlmostStatic, gfx: C.SpritesheetClass, spritesheet: new Vec(6, 4), fixedSize: true }
      }).loadNewMap(new Vec(0, 0));

      Fathom._camera.beBoundedBy(m);

      Fathom.mapRef = m;

      var i:Inventory = new Inventory();
      var c:Character = new Character(3 * 25 + 2, 5 * 25, m, i);
                        new HUD(c);

      main.c = c;

      Fathom.start();

      weather = new Particles(C.WeatherParticleClass).spawnAt(0, 0, 600, 200).withSpawnRate(0.3)
      .withLifetime(90,180).withVelY(.1, 3).withVelX(-2, 2).withScale(2).thatFade();

      Fathom.pushMode(C.MODE_TITLE);
      addEventListener(Event.ENTER_FRAME, flashTitleScreen);

      title1 = new C.TitleClass();
      title2 = new C.TitleFlashClass();

      addChild(title1);
      addChild(title2);

      title1.width = 500;
      title1.height = 500;
      title2.width = 500;
      title2.height = 500;

      C.titleMusic.play();
    }

    private var title1:DisplayObject;
    private var title2:DisplayObject;
    private var ticks:int = 0;

    public function flashTitleScreen(e:Event):void {
      ++ticks;

      if (Math.floor(ticks / 15) % 2 == 0) {
        title1.visible = true;
        title2.visible = false;
      } else {
        title1.visible = false;
        title2.visible = true;
      }

      if (Util.KeyDown.X) {
        Fathom.popMode();
        title1.visible = false;
        title2.visible = false;

        C.titleMusic.stop();
        C.bgMusic.play();

        this.removeEventListener(Event.ENTER_FRAME, flashTitleScreen);
      }
    }
  }
}

class ScrollingBackground extends ScrollingLayer {
  private var bitmapClass:Class
  public function ScrollingBackground() {
    scrollingBitmap = new C.BGClass1().bitmapData;
  }
}

class ScrollingBackgroundBottom extends ScrollingLayer {
  private var bitmapClass:Class
  public function ScrollingBackgroundBottom() {
    scrollingBitmap = new C.BGClass2().bitmapData;
  }
}


class ScrollingBackgroundBottomOverlay extends ScrollingLayer {
  private var bitmapClass:Class
  public function ScrollingBackgroundBottomOverlay() {
    scrollingBitmap = new C.BGClass3().bitmapData;
  }
}

