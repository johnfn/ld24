package {
  public class Gate extends Entity {
    private var type:int;
    private const SIZE:int = C.size;

    function Gate(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      animations.addAnimationXY("open", [[3, 4], [3, 5], [3, 6], [3, 7], [3, 8]])
    }

    public function open():void {
      animations.play("open").andThen(destroy);
    }
  }
}
