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
    private var activated_max:int = 1;

    public var items:Array = [new InventoryItem(Inventory.BOLT), new InventoryItem(Inventory.AIR), new InventoryItem(Inventory.AIR), new InventoryItem(Inventory.ICE)];//new InventoryItem(Inventory.AIR), new InventoryItem(Inventory.AIR)];

    function Inventory() {
      super(0, 0, 150, 50);
      fromExternalMC(InventoryClass);
      addDropShadow();

      // stick in middle, assuming w==h==50.
      set(new Vec(250 - BOX_WIDTH/2, 250 - BOX_HEIGHT/2));

      this.visible = false;
    }

    public function incMaxActivation():void {
      activated_max++;
    }

    public function getMaxActivated():int {
      return activated_max;
    }

    public function addItem(itemType:int):void {
      var newItem:InventoryItem = new InventoryItem(itemType);

      items.push(newItem);
    }

    // Called immediately when inventory + items are displayed.
    private function prepareToShow():void {
      Util.assert(items.length <= 6);

      this.raiseToTop();

      for (var i:int = 0; i < items.length; i++) {
        var xLoc:int = this.x + 10 + i * C.size;
        var yLoc:int = this.y + 17;

        items[i].set(new Vec(xLoc, yLoc));
        items[i].visible = true;
        items[i].raiseToTop();
      }

      if (items.length > 0) {
        items[selection].select();
      }
    }

    private function prepareToHide():void {
      for (var i:int = 0; i < items.length; i++) {
        items[i].visible = false;
      }
    }

    override public function update(e:EntityList):void {

      // Toggle inventory.

      if (Util.keyRecentlyDown(Util.Key.X) || (Util.keyRecentlyDown(Util.Key.C) && C.DEBUG)) {
        var hasAccess:Boolean = false;

        hasAccess = hasAccess || (C.DEBUG && Util.keyRecentlyDown(Util.Key.C));

        var ch:Character = (Fathom.entities.one("Character") as Character);

        if (ch.currentlyTouching("Telephone").length) {
          if (ch.canEvol) {
            hasAccess = true;
          } else {
            if (ch.hasJumper) {
              new DialogText(C.whatNow);
            } else {
              new DialogText(C.whosThat);
            }
            hasAccess = false;
          }
        }

        hasAccess = hasAccess || ch.currentlyTouching("Professor").length;

        if (hasAccess) {
          if (Fathom.currentMode == C.MODE_NORMAL) {
            Fathom.currentMode = C.MODE_INVENTORY;

            prepareToShow();
          } else {
            Fathom.currentMode = C.MODE_NORMAL;

            prepareToHide();
          }

          this.visible = Fathom.currentMode == C.MODE_INVENTORY;
        }
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

      if (Util.keyRecentlyDown(Util.Key.Z)) {
        if (items[selection].activated == true || (items[selection].activated == false && activated < activated_max)) {
          items[selection].toggleActivation();

          if (items[selection].activated) {
            activated++;
          } else {
            activated--;
          }
        } else {
          new DialogText(["You can only activate " + activated_max + " evolution" + (activated_max > 1 ? "s" : "") + " at once."]);
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
  private var _activated:Boolean = false;
  private var selected:Boolean = false;
  private var _itemType:int = -1;

  public function get activated():Boolean {
    return _activated;
  }

  function InventoryItem(itemType:int) {
    super(0, 0, C.size, C.size);

    fromExternalMC(C.SpritesheetClass, false, [itemType, 0]);

    this.visible = false;
    this.itemType = itemType;
  }

  public function get itemType():int {
    return _itemType;
  }

  public function set itemType(v:int):void {
    _itemType = v;
  }

  public function toggleActivation():void {
    _activated = !_activated;

    if (_activated) {
      updateExternalMC(C.SpritesheetClass, false, [itemType, 2]);
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
    updateExternalMC(C.SpritesheetClass, false, [itemType, 1]);
  }

  public function deselect():void {
    this.selected = false;
    if (_activated) {
      updateExternalMC(C.SpritesheetClass, false, [itemType, 2]);
    } else {
      updateExternalMC(C.SpritesheetClass, false, [itemType, 0]);
    }
  }

  override public function groups():Array {
    return super.groups().concat("no-camera");
  }

  override public function collides(e:Entity):Boolean {
    return false;
  }
}
