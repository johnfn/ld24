package {
  public class PushBlock extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;
    private var startingLoc:Vec;

    private static var crushedConsole:Boolean = false;

    function PushBlock(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      on("pre-update", Hooks.decel());
    }

    public function rememberLoc():void {
      startingLoc = this.rect();
    }

    public function resetLoc():void {
      this.setPos(startingLoc);
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

    override public function groups():Array {
      return super.groups().concat("remember-loc");
    }

    override public function update(e:EntityList):void {
      this.vel.x *= 0.9;
      this.vel.y = 6;

      if (this.vel.x < 0.1 || this.vel.x > -0.1) this.vel.x = 0;

      if (this.currentlyTouching("Terminal").length && !PushBlock.crushedConsole) {
        if (Fathom.mapRef.getTopLeftCorner().equals(new Vec(3 * 25, 1 * 25))) {
          PushBlock.crushedConsole = true;
          handleProfsComp();
          return;
        }

        var didSomething:Boolean = false;

        for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
          if (currentlyTouching("Terminal")[i].notDead()) {
            didSomething = true;
          }

          currentlyTouching("Terminal")[i].activate();
          currentlyTouching("Terminal")[i].useGate();
        }

        if (didSomething) {
          new DialogText(C.consoleCrusher);
        }
      }
    }
  }
}
