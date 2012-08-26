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

    override public function update(e:EntityList):void {
      this.vel.x *= 0.9;
      this.vel.y = 6;

      if (this.vel.x < 0.1 || this.vel.x > -0.1) this.vel.x = 0;

      if (this.currentlyTouching("Terminal").length && !PushBlock.crushedConsole) {
        PushBlock.crushedConsole = true;

        new DialogText(C.consoleCrusher);

        for (var i:int = 0; i < currentlyTouching("Terminal").length; i++) {
          currentlyTouching("Terminal")[i].activate();
          currentlyTouching("Terminal")[i].useGate();
        }
      }
    }
  }
}
