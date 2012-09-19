
package {
  import Util;
  import flash.events.Event;
  import flash.display.MovieClip;
  import flash.display.Shape;

  public class Character extends MovingEntity {
    private var mapRef:Map;
    private var inventory:Inventory;

    public var xAction:String = "";

    public var fixedProfsComp:Boolean = C.DEBUG;
    public var hasJumper:Boolean = C.DEBUG;
    public var canEvol:Boolean = C.DEBUG;

    public static var NOTHING:int = 0;
    public static var FREEZE:int = 1;
    public static var JUMP:int = 2;
    public static var ENERGIZE:int = 3;
    public static var SMASH:int = 4;
    public static var SHOOT:int = 5;
    public static var FLY:int = 6;
    public static var TALK_PROF:int = 7;
    public static var USE_TERMINAL:int = 8;
    public static var EXAMINE_TERMINAL:int = 9;

    private var flyingPower:int = 0;
    private var isFreezing:Boolean = false;
    private var usedDblJump:Boolean = false;

    private var lastOnGround:int = 0;
    private var facingDirection:int = 1;

    public var currentAction:int = NOTHING;

    function Character(x:int, y:int, mapRef:Map, i:Inventory) {
      super(x, y, C.size, C.size);
      loadSpritesheet(C.CharacterClass, C.dim, new Vec(0, 0));

      animations.addAnimations({ "walk": { startPos: [0, 0], numFrames: 7 }
                               , "idle": { startPos: [0, 0], numFrames: 1 }
      });

      animations.ticksPerFrame = 3;

      this.mapRef = mapRef;

      this.width -= 2;
      this.height -= 2;

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
      if (canEvol && isTouching("Professor")) {
        xAction = "Ask Prof. to evolve you.";
        return;
      }

      if (isTouching("Telephone")) {
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

    private var blackFadeCount:int = 0;
    private var blackFader:Shape;

    private function fadeToBlack(e:Event):void {
      if (blackFadeCount == 0) {
        blackFader = new Shape();
        blackFader.graphics.beginFill(0x000000, 1.0);
        blackFader.graphics.drawRect(0, 0, 1000,1000);
        blackFader.graphics.endFill();

        Fathom.container.addChild(blackFader);
      }

      blackFader.alpha = Math.min(blackFadeCount / 100, 1);

      if (blackFadeCount == 150) {
        main.MainObj.showEndGameScreen();
      }

      ++blackFadeCount;
    }

    private function endGame():void {
      Fathom.camera.stopAllEvents();
      Fathom.stop();

      Fathom.container.addEventListener(Event.ENTER_FRAME, fadeToBlack);
    }

    private var everSeenIceB4:Boolean = false;

    public function getActionString():String {
      var evolutions:Array = getEvolutions();
      currentAction = NOTHING;

      var action:String = "Nothing";

      if (evolutions.length == 1) {
        if (evolutions.contains(Inventory.ICE)) {
          currentAction = FREEZE;

          if (!everSeenIceB4) {
            new DialogText(["Ice! This might make blocks slippery and easier to push."])
            everSeenIceB4 = true;
          }
        }

        if (evolutions.contains(Inventory.AIR)) {
          currentAction = JUMP;
        }

        if (evolutions.contains(Inventory.BOLT) && isTouching("Terminal")) {
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

      if (evolutions.length == 3) {
        endGame();
      }

      handleFreezing();

      // Context-specific

      if (isTouching("Professor")) {
        currentAction = TALK_PROF;
      }

      if (isTouching("Terminal")) {
        if ((touchingSet("Terminal").one() as Terminal).isActivated) {
          currentAction = USE_TERMINAL;
        } else if (currentAction != ENERGIZE) {
          currentAction = EXAMINE_TERMINAL;
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
        case EXAMINE_TERMINAL: return "Examine";
        default: return "BUGGY";
      }
    }

    private function setCameraFocus():void {
      var focus:Vec = this.rect();
      if (facing > 0) {
        focus.x += 100;
      } else {
        focus.x -= 100;
      }

      Fathom.camera.follow(focus);
    }

    private var lastPlayed:int = 30;

    private function pushBlocks():void {
      var pushed:Boolean = false;

      lastPlayed++;

      for each (var blox:PushBlock in xColl.get("PushBlock")) {
        blox.vel.x = vel.x;

        pushed = true;
      }

      if (pushed && lastPlayed > 30) {
        C.pushSound.play();

        lastPlayed = 0;
      }
    }

    private function killEasterEggs():void {
      if (isTouching("EasterEgg")) {
        touchingSet("EasterEgg").one().destroy();

        new DialogText(C.eggy);
      }
    }

    private function landSnd():void {
      if (touchingBottom) {
        if (lastOnGround > 5) {
          C.hitSound.play();

          new Particles(C.CloudParticleClass).spawnAt(this.x, this.y + this.height - 5, this.width, 5)
          .withVelY(-.1, -.5).withVelX(-1, 1).withScale(2)
          .animateFromSpritesheet().spawnParticles(3).andThenStop();

        }

        lastOnGround = 0;
      } else {
        lastOnGround++;
      }
    }

    private function movement():void {
      var mv:int = Util.movementVector().x;
      var accel:Number = 1;

      if (touchingBottom) {
       if (mv > 0 && vel.x >= 0) {
          vel.x += accel;

          if (vel.x > 5) vel.x = 5;
        } else if (mv < 0 && vel.x <= 0) {
          vel.x -= accel;

          if (vel.x < -5) vel.x = -5;
        } else {
          if (Math.abs(vel.x) < 2) vel.x = 0;
          vel.x -= Util.sign(vel.x) * 2;
        }
      } else {
        if (mv != 0) {
          vel.x = mv * 5;
        } else {
          vel.x -= Util.sign(vel.x) * 0.3;
        }
      }

      if (Math.abs(vel.x) < 0.4) vel.x = 0;

      if (touchingBottom || touchingTop) {
        vel.y = 0;
      }
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      setCameraFocus();
      setXAction();
      killEasterEggs();

      landSnd();

      pushBlocks();

      movement();

      if (touchingBottom) {
        flyingPower = 60;
      }

      if (touchingTop) {
        new Particles(C.ParticleClass).spawnAt(this.x, this.y, this.width, 2).withVelY(-.1, -2).withLifetime(10, 20).thatFlicker().spawnParticles(3).andThenStop();

        C.hitSound.play();
      }

      if (vel.x != 0) {
        animations.play("walk");
      } else {
        animations.play("idle");
      }

      if (vel.y < 0 && !(Util.KeyDown.X || Util.KeyDown.Z)) {
        vel.y = 0;
      }

      vel.y += C.GRAVITY;

      if (hasJumper && Util.KeyDown.X && touchingBottom && vel.y > -5 && !isTouching("Telephone")) {
        vel.y -= 10;
        C.jumpSound.play();
        usedDblJump = false;
      }

      face(Util.movementVector().x);

      var val:int = Util.sign(Util.movementVector().x);
      facingDirection = (val == 0 ? facingDirection : val);

      Hooks.onLeaveMap(this, mapRef, leftMap);

      if (Util.KeyJustDown.Z) {
        doAction();
      }

      if (Util.KeyDown.Z) {
        checkHoldActions();
      }

      if (isFreezing) {
        freezeBlocks();
      }

      checkToggleInventory();

      checkOpenChest();
    }

    private function checkOpenChest():void {
      if (isTouching("Treasure")) {
        (touchingSet("Treasure").one() as Treasure).open();
      }
    }

    private function checkToggleInventory():void {
      var hasAccess:Boolean = false;

      if (Util.KeyJustDown.X || (Util.KeyJustDown.C && C.DEBUG)) {

        hasAccess = hasAccess || (C.DEBUG && Util.KeyJustDown.C);

        if (isTouching("Telephone")) {
          if (canEvol) {
            hasAccess = true;
          } else {
            if (hasJumper) {
              new DialogText(C.whatNow);
            } else {
              new DialogText(C.whosThat);
            }

            hasAccess = false;
          }
        }

        hasAccess = hasAccess || (isTouching("Professor") && canEvol);

      }

      inventory.setActivated(hasAccess);
    }

    private function freezeBlocks():void {
      var froze:Boolean = false;

      for each (var e:Block in touchingSet("Block")) {
        if (!e.frozen()) {
          e.freezeOver();
          froze = true;
        }
      }

      if (froze) {
        C.iceSound.play();
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

    private var energizedTheProfsComp:Boolean = false;

    private function energize():void {
      var used:Boolean = false;
      var i:int;

      // Prof's comp is a special case.
      if (mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
        if (isTouching("Terminal")) {
          if (!energizedTheProfsComp) {

            for each (var g:Gate in Fathom.entities.get("Gate")) {
              g.open();
            }

            C.energySound.play();
            new DialogText(["That did something!", "It seems about halfway there. It needs something else though!", "Looks like it got rid of some locks.", "And there's a crate up there, not that that could be helpful in any way."]);

            energizedTheProfsComp = true;
          } else {
            new DialogText(["Nah, more power isn't helping. It needs a kick somehow."]);
          }
        }
        return;
      }

      for each (var t:Terminal in touchingSet("Terminal")) {
        t.activate();
        used = true;
      }

      if (used) {
        C.energySound.play();
        new DialogText(["The terminal turned on!"]);
      }
    }

    private var examinedItBefore:Boolean = false;

    private function examineTerminal(t:Terminal):void {
      if (mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
        if (!hasJumper) {
          new DialogText(C.whosComp);
        } else {
          new DialogText(C.profsComp);
        }
      } else {
        if (t.notDead()) {
          new DialogText(C.unpoweredTerminal);
        } else {
          if (t.wasCrushed()) {
            new DialogText(C.crushedTerminal);
          } else {
            new DialogText(C.usedTerminal);
          }
        }
      }
    }

    private function useTerminal():void {
      var used:Boolean = false;

      //Prof's comp.

      if (mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
        if (fixedProfsComp) {
          if (!examinedItBefore) {
            new DialogText(C.theTerminalWorks);
            examinedItBefore = true;
          } else {
            new DialogText(["YOU Better stay away for now."]);
          }
        }
        return; //dont kill his comp :p
      }

      for each (var t:Terminal in touchingSet("Terminal")) {
        t.useGate();
      }

      if (used) {
        new DialogText(["The terminal turned on!"]);
      }
    }

    // Not the harry potter item.
    public function fireBolt():void {
      var b:Bolt = new Bolt();

      b.loadSpritesheet(C.SpritesheetClass, C.dim, new Vec(4, 4));
      b.setPos(this.vec().add(new Vec(25 * facingDirection, -5)));
      b.vel = new Vec(9 * facingDirection, 0);

      if (!C.DEBUG) {
        C.shootSound.play();
      }
    }

    private function doSmash():void {
      var blox:EntitySet = Fathom.entities.get("SmashBlock");
      var destroyed:Boolean = false;

      for (var i:int = 0; i < blox.length; i++) {
        var dist:int = Math.abs(blox[i].x - this.x) + Math.abs(blox[i].y - this.y);

        if (dist < 40) {
          blox[i].destroy();
          destroyed = true;
        }
      }

      if (destroyed) {
        C.smashSound.play();
      }
    }

    // Actions you have to hold down the key to do.
    private function checkHoldActions():void {
      switch (currentAction) {
        case FLY: fly(); break;
        case JUMP: if (touchingBottom && vel.y > -5) { vel.y -= 20; C.jumpSound.play(); } break;
      }
    }

    private function doAction():void {
      switch(currentAction) {
        case NOTHING: trace("You do nothing!"); break;
        case FREEZE: isFreezing = !isFreezing; break;
        case JUMP: break;
        case ENERGIZE: energize(); break;
        case SMASH: doSmash(); break;
        case SHOOT: fireBolt(); break;
        case FLY: break;
        case TALK_PROF: dispatchProfDialog(mapRef.getTopLeftCorner()); break;
        case USE_TERMINAL: useTerminal(); break;
        case EXAMINE_TERMINAL: examineTerminal(touchingSet("Terminal").one() as Terminal); break;
        default: trace("o krap"); break;
      }
    }

    private function leftMap():void {
      Hooks.loadNewMap(this, mapRef)();
      Fathom.camera.snapTo(this);
    }

    override public function modes():Array { return [0]; }
  }
}
