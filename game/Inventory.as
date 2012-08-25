package {
  import Util;

  public class Inventory extends Entity {

    [Embed(source = "../data/itemsbox.png")] static public var InventoryClass:Class;

    public static var ICE:int = 4;
    public static var AIR:int = 5;
    public static var BOLT:int = 6;

    private static const BOX_WIDTH:int = 150;
    private static const BOX_HEIGHT:int = 50;

    public var items:Array = [new InventoryItem(Inventory.ICE), new InventoryItem(Inventory.AIR), new InventoryItem(Inventory.BOLT)];

    function Inventory() {
      super(0, 0, 150, 50);
      fromExternalMC(InventoryClass);

      // stick in middle, assuming w==h==50.
      set(new Vec(250 - BOX_WIDTH/2, 250 - BOX_HEIGHT/2));

      this.visible = false;

      for (var i:int = 0; i < items.length; i++) {
        addChild(items[i]);
      }
    }

    public function addItem(itemType:int):void {
      var newItem:InventoryItem = new InventoryItem(itemType);

      addChild(newItem);
    }

    // Called immediately when inventory + items are displayed.
    private function prepare():void {
      Util.assert(items.length <= 6);

      for (var i:int = 0; i < items.length; i++) {
        var xLoc:int = this.x + 10 + i * C.size;
        var yLoc:int = this.y + 17;

        items[i].set(new Vec(xLoc, yLoc));
        items[i].visible = true;
      }
    }

    override public function update(e:EntityList):void {
      if (Util.keyRecentlyDown(Util.Key.I)) {
        if (Fathom.currentMode == C.MODE_NORMAL) {
          Fathom.currentMode = C.MODE_INVENTORY;

          prepare();
        } else {
          Fathom.currentMode = C.MODE_NORMAL;
        }

        this.visible = Fathom.currentMode == C.MODE_INVENTORY;
      }
    }

    override public function modes():Array {
      return [C.MODE_NORMAL, C.MODE_INVENTORY];
    }

    override public function collides(e:Entity):Boolean {
      return false;
    }

    override public function groups():Array {
      return super.groups().concat("no-camera");
    }
  }
}

class InventoryItem extends Entity {
  [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

  private var selected:Boolean = false;

  function InventoryItem(itemType:int) {
    super(0, 0, C.size, C.size);

    fromExternalMC(SpritesheetClass, false, [itemType, 0]);

    this.visible = false;
  }

  public function select():void {
    this.selected = true;
  }

  public function deselect():void {
    this.selected = false;
  }

  override public function groups():Array {
    return super.groups().concat("no-camera");
  }

  override public function collides(e:Entity):Boolean {
    return false;
  }
}
