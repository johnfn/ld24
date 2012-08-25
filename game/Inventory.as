package {
  import Util;

  public class Inventory extends Entity {

    [Embed(source = "../data/itemsbox.png")] static public var InventoryClass:Class;

    public static var ICE:int = 4;
    public static var AIR:int = 5;
    public static var BOLT:int = 6;

    private static const BOX_WIDTH:int = 150;
    private static const BOX_HEIGHT:int = 50;

    private var selection:int = 0;
    private var activated:int = 0;
    private var activated_max:int = 2;

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
    private function prepareToShow():void {
      Util.assert(items.length <= 6);

      for (var i:int = 0; i < items.length; i++) {
        var xLoc:int = this.x + 10 + i * C.size;
        var yLoc:int = this.y + 17;

        items[i].set(new Vec(xLoc, yLoc));
        items[i].visible = true;
      }

      items[selection].select();
    }

    private function prepareToHide():void {
      for (var i:int = 0; i < items.length; i++) {
        items[i].visible = false;
      }
    }

    override public function update(e:EntityList):void {
      // Toggle inventory.
      if (Util.keyRecentlyDown(Util.Key.I)) {
        if (Fathom.currentMode == C.MODE_NORMAL) {
          Fathom.currentMode = C.MODE_INVENTORY;

          prepareToShow();
        } else {
          Fathom.currentMode = C.MODE_NORMAL;
        }

        this.visible = Fathom.currentMode == C.MODE_INVENTORY;
      }

      if (Fathom.currentMode != C.MODE_INVENTORY) return;

      // Rotate selection.
      if (Util.keyRecentlyDown(Util.Key.Right) || Util.keyRecentlyDown(Util.Key.Left)) {
        items[selection].deselect();

        if (Util.keyRecentlyDown(Util.Key.Right)) {
          selection = (selection + 1) % items.length;
        }

        if (Util.keyRecentlyDown(Util.Key.Left)) {
          if (selection == 0) {
            selection = items.length - 1;
          } else {
            selection--;
          }
        }

        items[selection].select();
      }

      if (Util.keyRecentlyDown(Util.Key.X)) {
        if (items[selection].activated == true || (items[selection].activated == false && activated < activated_max)) {
          items[selection].toggleActivation();

          if (items[selection].activated) {
            activated++;
          } else {
            activated--;
          }
        } else {
          new DialogText("You can only activate " + activated_max + " evolutions at once.");
        }
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

  private var _activated:Boolean = false;
  private var selected:Boolean = false;
  private var itemType:int = -1;

  public function get activated():Boolean {
    return _activated;
  }

  function InventoryItem(itemType:int) {
    super(0, 0, C.size, C.size);

    fromExternalMC(SpritesheetClass, false, [itemType, 0]);

    this.visible = false;
    this.itemType = itemType;
  }

  public function toggleActivation():void {
    _activated = !_activated;

    if (_activated) {
      updateExternalMC(SpritesheetClass, false, [itemType, 2]);
    } else {
      if (selected) {
        select();
      } else {
        deselect();
      }
    }
  }

  public function select():void {
    this.selected = true;
    updateExternalMC(SpritesheetClass, false, [itemType, 1]);
  }

  public function deselect():void {
    this.selected = false;
    if (_activated) {
      updateExternalMC(SpritesheetClass, false, [itemType, 2]);
    } else {
      updateExternalMC(SpritesheetClass, false, [itemType, 0]);
    }
  }

  override public function groups():Array {
    return super.groups().concat("no-camera");
  }

  override public function collides(e:Entity):Boolean {
    return false;
  }
}
