package {
  import Util;

  public class Character extends MovingEntity {
    public static var GRAVITY:int = 1;

    private var mapRef:Map;
    private var inventory:Inventory;

    public static var NOTHING:int = 0;
    public static var FREEZE:int = 1;
    public static var JUMP:int = 2;
    public static var ENERGIZE:int = 3;
    public static var SMASH:int = 4;
    public static var SHOOT:int = 5;
    public static var FLY:int = 6;

    public var currentAction:int = NOTHING;

    function Character(x:int, y:int, base:Class, mapRef:Map, i:Inventory) {
      //todo; wiggle room
      super(x, y, C.size, C.size);
      fromExternalMC(base, false, [0, 0]);

      this.mapRef = mapRef;

      on("pre-update", Hooks.platformerLike(this));

      on("post-update", Hooks.resolveCollisions());

      this.inventory = i;
    }

    public function getEvolutions():Array {
      var result:Array = [];

      for (var i:int = 0; i < inventory.items.length; i++) {
        if (inventory.items[i].activated) {
          result.push(inventory.items[i].itemType);
        }
      }

      return result;
    }

    public function getActionString():String {
      var evolutions:Array = getEvolutions();
      currentAction = NOTHING;

      var action:String = "Nothing";

      if (evolutions.length == 1) {
        if (evolutions.contains(Inventory.ICE)) {
          currentAction = FREEZE;
        }

        if (evolutions.contains(Inventory.AIR)) {
          currentAction = JUMP;
        }

        if (evolutions.contains(Inventory.BOLT)) {
          currentAction = ENERGIZE;
        }
      }

      if (evolutions.length == 2) {
        if (evolutions.contains(Inventory.AIR) && evolutions.contains(Inventory.BOLT)) {
          currentAction = SMASH;
        } else if (evolutions.contains(Inventory.AIR) && evolutions.contains(Inventory.ICE)) {
          currentAction = SHOOT;
        } else {
          currentAction = FLY;
        }
      }

      switch(currentAction) {
        case NOTHING: return "Nothing";
        case FREEZE: return "Freeze";
        case JUMP: return "Jump";
        case ENERGIZE: return "Energize";
        case SMASH: return "Smash";
        case SHOOT: return "Shoot";
        case FLY: return "Fly";
        default: return "BUGGY";
      }
    }

    private function setCameraFocus():void {
      var focus:Vec = this.clone();
      if (this.scaleX > 0) {
        focus.x += 50;
      } else {
        focus.x -= 50;
      }

      Fathom.camera.follow(focus);
    }

    override public function update(e:EntityList):void {
      setCameraFocus();

      vel.x = Util.movementVector().x * 8;
      vel.y += GRAVITY;

      if (touchingBottom || touchingTop) {
        vel.y = 0;
      }

      // Stopped holding up?
      if (vel.y < 0 && Util.movementVector().y >= 0) {
        vel.y = 0;
      }

      if (Util.movementVector().y && touchingBottom) {
        vel.y -= 15;
      }

      if (Util.movementVector().x > 0) this.scaleX = 1;
      if (Util.movementVector().x < 0) this.scaleX = -1;

      Hooks.onLeaveMap(this, mapRef, leftMap);

      if (Util.keyRecentlyDown(Util.Key.Z)) {
        doAction();
      }
    }

    private function doAction():void {
      switch(currentAction) {
        case NOTHING: trace("You do nothing!"); break;
        case FREEZE: trace("You do nothing!"); break;
        case JUMP: trace("You jormp!"); break;
        case ENERGIZE: trace("You jormp!"); break;
        case SMASH: trace("You jormp!"); break;
        case SHOOT: trace("You jormp!"); break;
        case FLY: trace("You jormp!"); break;
        default: trace("o krap"); break;
      }
    }

    private function leftMap():void {
      Hooks.loadNewMap(this, mapRef)();
      Fathom.camera.snapTo(this);
    }
  }
}
