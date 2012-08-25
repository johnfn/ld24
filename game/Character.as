package {
  import Util;

  public class Character extends MovingEntity {
    public static var GRAVITY:int = 1;

    private var mapRef:Map;

    function Character(x:int, y:int, base:Class, mapRef:Map) {
      //todo; wiggle room
      super(x, y, C.size, C.size);
      fromExternalMC(base, false, [0, 0]);

      this.mapRef = mapRef;

      on("pre-update", Hooks.platformerLike(this));

      on("post-update", Hooks.resolveCollisions());
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
      if (vel.y < 0 && Util.movementVector().y >= 0) {
        vel.y = 0;
      }

      if (Util.movementVector().y && touchingBottom) {
        vel.y -= 15;
      }

      if (Util.movementVector().x > 0) this.scaleX = 1;
      if (Util.movementVector().x < 0) this.scaleX = -1;

      Hooks.onLeaveMap(this, mapRef, leftMap);
    }

    private function leftMap():void {
      Hooks.loadNewMap(this, mapRef)();
      Fathom.camera.snapTo(this);
    }
  }
}
