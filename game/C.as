package {
  public class C {
    public static var size:int = 25;

    // Graphics.
    [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

    // Game modes.
    public static var MODE_NORMAL:int    = 0; // Should be the only unpaused mode.
    public static var MODE_INVENTORY:int = 1;
    public static var MODE_TEXT:int      = 2;
  }
}

