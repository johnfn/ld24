package {
  public class PushBlock extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;

    private static var crushedConsole:Boolean = false;

    function PushBlock(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      on("pre-update", Hooks.decel());
      on("pre-update", Hooks.platformerLike(this));
      on("post-update", Hooks.resolveCollisions());
    }

    private function handleProfsComp():void {
      for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
        currentlyTouching("Terminal")[i].activate();
      }

      // Hacks? Where we're going, we don't need hacks.
      //
      // ... because the codebase is one huge hack.
      (Fathom.entities.one("Character") as Character).fixedProfsComp = true;

      new DialogText(C.profConCrush);
    }

    override public function update(e:EntityList):void {
      this.vel.x *= 0.9;
      this.vel.y = 6;

      if (this.vel.x < 0.1 || this.vel.x > -0.1) this.vel.x = 0;

      if (this.currentlyTouching("Terminal").length && !PushBlock.crushedConsole) {
        PushBlock.crushedConsole = true;

        if (Fathom.mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
          handleProfsComp();
          return;
        }

        new DialogText(C.consoleCrusher);

        for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
          currentlyTouching("Terminal")[i].activate();
          currentlyTouching("Terminal")[i].useGate();
        }
      }
    }
  }
}
