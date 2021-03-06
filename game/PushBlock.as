package {
  import caurina.transitions.*;

  public class PushBlock extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;
    private var startingLoc:Vec;
    private var lastOnGround:int = 0;

    private static var crushedConsole:Boolean = false;

    function PushBlock(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    public function rememberLoc():void {
      startingLoc = this.rect();
    }

    public function resetLoc():void {
      this.setPos(startingLoc);
    }

    private function handleProfsComp():void {
      for each (var t:Terminal in touchingSet("Terminal")) {
        t.activate();
      }

      // Hacks? Where we're going, we don't need hacks.
      //
      // ... because the codebase is one huge hack.
      (Fathom.entities.one("Character") as Character).fixedProfsComp = true;

      new DialogText(C.profConCrush);
    }

    override public function groups():Set {
      return super.groups().concat("remember-loc");
    }

    private function landSnd():void {
      if (touchingBottom) {
        if (lastOnGround > 5) {
          new Particles(C.CloudParticleClass).spawnAt(this.x, this.y + this.height, this.width, 2)
          .withVelY(-.1, -2).withLifetime(10, 20).thatFade().withScale(2)
          .spawnParticles(9).andThenStop();


          this.scaleX = 1.2;
          Tweener.addTween(this, {scaleX: 1.0, time:0.5});

          C.hitSound.play();
        }

        lastOnGround = 0;
      } else {
        lastOnGround++;
      }
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      raiseToTop();

      this.vel.x *= 0.9;
      this.vel.y += C.GRAVITY;

      landSnd();

      if (touchingBottom) {
        this.vel.y = 0;
      }

      var canSlide:Boolean = false;

      for each (var b:Block in touchingSet("Block")) {
        if (b.frozen()) {
          canSlide = true;
        }
      }

      if (!canSlide) {
        this.vel.x = 0;
      }

      if (Math.abs(this.vel.x) < 0.1) this.vel.x = 0;

      if (this.isTouching("Terminal") && !PushBlock.crushedConsole) {
        if (Fathom.mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
          PushBlock.crushedConsole = true;
          handleProfsComp();
          return;
        }

        var didSomething:Boolean = false;

        for each (var t:Terminal in touchingSet("Terminal")) {
          if (t.notDead()) {
            didSomething = true;
          }

          t.crush();
        }

        if (didSomething) {
          new DialogText(C.consoleCrusher);
        }
      }
    }
  }
}
