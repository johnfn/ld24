package {
  import Util;

  public class Inventory extends Entity {

    [Embed(source = "../data/itemsbox.png")] static public var InventoryClass:Class;

    function Inventory() {
      super(0, 0, 150, 50);
      fromExternalMC(InventoryClass);

      this.visible = false;
    }

    override public function update(e:EntityList):void {
      if (Util.keyRecentlyDown(Util.Key.I)) {
        if (Fathom.currentMode == C.MODE_NORMAL) {
          Fathom.currentMode = C.MODE_INVENTORY;
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
