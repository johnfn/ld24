package {
  import Util;

  public class Character extends MovingEntity {
    public static var GRAVITY:int = 1;

    private var mapRef:Map;
    private var inventory:Inventory;

    public var xAction:String = "";

    public var fixedProfsComp:Boolean = C.DEBUG;
    public var hasJumper:Boolean = C.DEBUG;
    public var canEvol:Boolean = C.DEBUG;

    public static var NOTHING:int = 0;
    public static var GRANTAPOTAMUS:int = -1;
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
    private var usedDblJump:Boolean = false;

    public var currentAction:int = NOTHING;

    function Character(x:int, y:int, base:Class, mapRef:Map, i:Inventory) {
      //todo; wiggle room
      super(x, y, C.size, C.size);
      fromExternalMC(base, false, [0, 0], true);
      setMCOffset(12, 0);

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

    public function setXAction():void {
      if (canEvol && currentlyTouching("Professor").length) {
        xAction = "Evolve!";
        return;
      }

      if (currentlyTouching("Telephone").length) {
        if (canEvol) {
          xAction = "Call Prof. and Evolve!"
        } else {
          xAction = "Use Phone";
        }

        return;
      }

      if (hasJumper) {
        xAction = "Jump";
        return;
      }

      xAction = "";
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
        if (evolutions.contains(Inventory.BOLT) && evolutions.contains(Inventory.ICE)) {
          currentAction = SMASH;
        } else if (evolutions.contains(Inventory.AIR) && evolutions.contains(Inventory.BOLT)) {
          currentAction = SHOOT;
        } else if (evolutions.contains(Inventory.ICE) && evolutions.contains(Inventory.AIR)) {
          // Er,,,,,,,,
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
        case JUMP: return "Big Jump";
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

    private function pushBlocks():void {
      var blox:EntityList = currentlyTouching("PushBlock");

      for (var i:int = 0; isFreezing && i < blox.length; i++) {
        blox[i].vel.x = vel.x;
      }
    }

    private function killEasterEggs():void {
      if (currentlyTouching("EasterEgg").length) {
        var egg:EasterEgg = currentlyTouching("EasterEgg")[0];
        egg.destroy();

        new DialogText(C.eggy);
      }
    }

    override public function update(e:EntityList):void {
      setCameraFocus();
      setXAction();
      killEasterEggs();

      vel.x = Util.movementVector().x * 8;
      vel.y += GRAVITY;

      pushBlocks();

      if (touchingBottom || touchingTop) {
        vel.y = 0;
      }

      if (touchingBottom) {
        flyingPower = 60;
      }

      // Stopped holding up?
      //if (vel.y < 0 && Util.movementVector().y >= 0) {
      //  vel.y = 0;
      //}

      if (vel.y < 0 && !(Util.keyIsDown(Util.Key.X) || Util.keyIsDown(Util.Key.Z))) {
        vel.y = 0;
      }

      if (hasJumper && Util.keyIsDown(Util.Key.X) && touchingBottom) {
        vel.y -= 15;
        usedDblJump = false;
      }

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
      if (!hasJumper) {
        new DialogText(C.firstTalkProf);
        hasJumper = true;
        return;
      }

      if (!canEvol) {
        if (hasJumper && inventory.items.length == 0) {
          new DialogText(C.dismissiveProf)
          return;
        } else {
          new DialogText(C.firstEvolProf);
          canEvol = true;
          return;
        }
      }

      if (!fixedProfsComp) {
        new DialogText(C.wishICouldFixThatTerminal)
        return;
      }

      if (inventory.getMaxActivated() == 1) {
        new DialogText(C.coolThingFromProf);
        inventory.incMaxActivation();
        return;
      }

      if (inventory.getMaxActivated() == 2) {
        var numAirs:int = inventory.countNumOf(Inventory.AIR);
        if (numAirs == 0) {
          new DialogText(C.newStuff);
        } else if (numAirs == 1) {
          new DialogText(C.withOneAir);
        } else {
          new DialogText(C.withTwoAirs);

          inventory.removeItem(Inventory.AIR);
          inventory.incMaxActivation();
        }

        return;
      }

      new DialogText(["Well, what are you waiting for? Try it out!"]);
    }

    private function fly():void {
      flyingPower--;
      if (flyingPower > 0) {
        this.vel.y = -7;
      }
    }

    // Actions you have to hold down the key to do.
    private function checkHoldActions():void {
      switch (currentAction) {
        case FLY: fly(); break;
      }
    }

    private var energizedTheProfsComp:Boolean = false;

    private function energize():void {
      var used:Boolean = false;

      // Prof's comp is a special case.
      if (mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
        if (currentlyTouching("Terminal").length) {
          if (!energizedTheProfsComp) {
            var gates:EntityList = Fathom.entities.get("Gate");

            for (var i:int = 0; i < gates.length; i++) {
              gates[i].destroy();
            }

            new DialogText(["Seems about halfway there. It needs something else though!", "Looks like it got rid of some locks.", "And there's a crate up there, not that that could be helpful in any way."]);

            energizedTheProfsComp = true;
          } else {
            new DialogText(["Nah, more power isn't helping. It needs a kick somehow."]);
          }
        }
        return;
      }

      for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
        currentlyTouching("Terminal")[i].activate();
        used = true;
      }

      if (used) {
        new DialogText(["The terminal turned on!"]);
      }
    }

    private var examinedItBefore:Boolean = false;

    private function useTerminal():void {
      var used:Boolean = false;

      //Prof's comp.

      if (mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
        if (!examinedItBefore) {
          new DialogText(C.theTerminalWorks);
          examinedItBefore = true;
        } else {
          new DialogText(["YOU Better stay away for now."]);
        }
        return; //dont kill his comp :p
      }

      for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
        currentlyTouching("Terminal")[i].useGate();
      }

      if (used) {
        new DialogText(["The terminal turned on!"]);
      }
    }

    // Not the harry potter item.
    private function fireBolt():void {
      var b:Bolt = new Bolt();
      var dir:int = scaleX * -1;

      b.fromExternalMC(C.SpritesheetClass, false, [4, 4]);
      b.set(this).add(new Vec(-25 * dir, -5));
      b.vel = new Vec(-3 * dir, 0);
      addChild(b);
    }

    private function doSmash():void {
      var blox:EntityList = currentlyTouching("SmashBlock");

      for (var i:int = 0; i < blox.length; i++) {
        blox[i].destroy();
      }
    }

    private function doAction():void {
      switch(currentAction) {
        case NOTHING: trace("You do nothing!"); break;
        case FREEZE: isFreezing = !isFreezing; break;
        case JUMP: vel.y -= 10; break;
        case ENERGIZE: energize(); break;
        case SMASH: doSmash(); break;
        case SHOOT: fireBolt(); break;
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
