package {
  public class PushBlock extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;

    function PushBlock(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      on("pre-update", Hooks.platformerLike(this));
      on("post-update", Hooks.resolveCollisions());
    }

    override public function update(e:EntityList):void {
      this.vel.x *= 0.9;

      if (this.vel.x < 0.1 || this.vel.x > -0.1) this.vel.x = 0;
    }
  }
}
