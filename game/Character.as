package {
  import Util;

  public class Character extends MovingEntity {
    public static var GRAVITY:int = 1;

    function Character(x:int, y:int, base:Class) {
      //todo; wiggle room
      super(x, y, C.size, C.size);
      fromExternalMC(base, false, [0, 0]);

      on("pre-update", Hooks.platformerLike(this));

      on("post-update", Hooks.resolveCollisions());
    }

    override public function update(e:EntityList):void {
      Fathom.camera.follow(this);
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
    }
  }
}
