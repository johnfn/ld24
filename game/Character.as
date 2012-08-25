package {
  import Util;

  public class Character extends MovingEntity {
    function Character(x:int, y:int, base:Class) {
      //todo; wiggle room
      super(x, y, C.size, C.size);
      fromExternalMC(base, false, [0, 0]);

      on("pre-update", Hooks.platformerLike(this));

      on("post-update", Hooks.resolveCollisions());
    }

    override public function update(e:EntityList):void {
      Fathom.camera.follow(this);
      vel = new Vec(Util.movementVector().x * 8, 3);
    }
  }
}
