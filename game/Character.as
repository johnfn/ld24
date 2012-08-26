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
    public static var TALK_PROF:int = 7;
    public static var USE_TERMINAL:int = 8;

    private var flyingPower:int = 0;
    private var isFreezing:Boolean = false;

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

    private function handleFreezing():void {
      if (currentAction != FREEZE) {
        isFreezing = false;
      }
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

      handleFreezing();

      // Context-specific

      if (currentlyTouching("Professor").length) {
        currentAction = TALK_PROF;
      }

      if (currentlyTouching("Terminal").length) {
        if (currentlyTouching("Terminal")[0].isActivated) {
          currentAction = USE_TERMINAL;
        }
      }

      switch(currentAction) {
        case NOTHING: return "Nothing";
        case FREEZE: return isFreezing ? "Stop Freezing" : "Freeze";
        case JUMP: return "Jump";
        case ENERGIZE: return "Energize";
        case SMASH: return "Smash";
        case SHOOT: return "Shoot";
        case FLY: return "Fly";
        case TALK_PROF: return "Talk";
        case USE_TERMINAL: return "Use";
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
      //if (vel.y < 0 && Util.movementVector().y >= 0) {
      //  vel.y = 0;
      //}

      if (vel.y < 0 && !Util.keyIsDown(Util.Key.Z)) {
        vel.y = 0;
      }

      //if (Util.movementVector().y && touchingBottom) {
      //  vel.y -= 15;
      //}

      if (Util.movementVector().x > 0) this.scaleX = 1;
      if (Util.movementVector().x < 0) this.scaleX = -1;

      Hooks.onLeaveMap(this, mapRef, leftMap);

      if (Util.keyRecentlyDown(Util.Key.Z)) {
        doAction();
      }

      if (Util.keyIsDown(Util.Key.Z)) {
        checkHoldActions();
      }

      for (var i:int = 0; isFreezing && i < currentlyTouching("Block").length; i++) {
        currentlyTouching("Block")[i].freezeOver();
      }
    }

    private function dispatchProfDialog(whichMap:Vec):void {
      new DialogText("YOU Hello!", "PROF Sup?");
    }

    private function fly():void {
      if (touchingBottom) {
        flyingPower = 60;
      } else {
        flyingPower--;
        if (flyingPower > 0) {
          this.vel.y = -7;
        }
      }
    }

    // Actions you have to hold down the key to do.
    private function checkHoldActions():void {
      switch (currentAction) {
        case FLY: fly(); break;
      }
    }

    private function energize():void {
      for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
        currentlyTouching("Terminal")[i].activate();
      }
    }

    private function useTerminal():void {
      for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
        currentlyTouching("Terminal")[i].useGate();
      }
    }

    private function doAction():void {
      switch(currentAction) {
        case NOTHING: trace("You do nothing!"); break;
        case FREEZE: isFreezing = !isFreezing; break;
        case JUMP: vel.y -= 15; break;
        case ENERGIZE: energize(); break;
        case SMASH: trace("You jormp!"); break;
        case SHOOT: trace("You jormp!"); break;
        case FLY: break;
        case TALK_PROF: dispatchProfDialog(mapRef.getTopLeftCorner()); break;
        case USE_TERMINAL: useTerminal(); break;
        default: trace("o krap"); break;
      }
    }

    private function leftMap():void {
      Hooks.loadNewMap(this, mapRef)();
      Fathom.camera.snapTo(this);
    }
  }
}
