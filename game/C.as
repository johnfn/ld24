package {
  public class C {
    public static var size:int = 25;
    public static var DEBUG:Boolean = true;

    // Graphics.
    [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

    // Game modes.
    public static var MODE_NORMAL:int    = 0; // Should be the only unpaused mode.
    public static var MODE_INVENTORY:int = 1;
    public static var MODE_TEXT:int      = 2;

    /*public static var firstAirEv:Array = [   "YOU Oh cool, an air ... evolution ... thing ..?"
	    		                           , "YOU I heard about these on TV!"
				                           , "YOU But I don't know how to use them."
				                           , "YOU I'll hold onto it just in case."];*/

	public static var firstIceEv:Array =   [ "YOU Hmm, this card looks like ice."
	    		                           , "YOU I wonder what it does?"
				                           , "YOU Too bad the prof isn't nearby."
				                           ];

    public static var firstTalkProf:Array =[ "YOU Hello!"
	    		                           , "PROF What can I do for you, my boy?"
				                           , "YOU Um."
				                           , "YOU It's a little embarrassing."
				                           , "PROF Go on."
				                           , "YOU Well you see."
				                           , "YOU I was exploring."
				                           , "YOU And I don't know how to jump."
				                           , "YOU So I kept falling down cliffs and now it looks like I'm stuck here unless you can help."
				                           , "PROF ..."
				                           , "PROF You're right."
				                           , "PROF That is literally the dumbest thing I've heard all day."
				                           , "PROF ..."
				                           , "PROF Let me help you out."
				                           , "STARZ Got the *jumper*!"
				                           , "PROF That'll allow you to jump with the X key."
				                           , "YOU What the heck is a X key?."
				                           , "PROF Never mind."
				                           , "PROF Come back if you need more help."
				                           ];

    public static var dismissiveProf:Array=[ "STARZ The professor looks over you."
                                           , "PROF You don't need more help."
                                           ];

    public static var whosThat:Array=      [ "STARZ Ring ring ring..."
                                           , "PROF Who is this?"
                                           , "YOU Um."
                                           , "PROF Sorry, I don't take calls from telemarketers."
				                           , "STARZ The person on the other side of the line hangs up."
                                           ];

    public static var consoleCrusher:Array=[ "YOU Oh my God!"
                                           , "YOU I crushed the console with that block!"
                                           , "YOU WHY AM I SO DUMB?!?"
                                           , "YOU Actually, that looked like it worked."
                                           , "YOU Yay :D"
                                           ];

    public static var whatNow:Array=      [ "STARZ Ring ring ring..."
                                           , "PROF What now?"
                                           , "YOU Uh."
                                           , "PROF If you find a card, come talk to me."
                                           , "PROF Otherwise, I'm busy!"
				                           , "STARZ Click."
                                           ];

    public static var firstEvolProf:Array=[ "PROF Ah, an evolution card."
    									  , "PROF Let me help you out with that."
    									  , "PROF When you're standing near me, press X."
    									  , "PROF That will open up the evolve screen."
    									  , "PROF You navigate it with the arrow keys, and select with Z."
    									  , "PROF You can choose 1 or 2 cards to use to evolve yourself."
    									  , "PROF After you hit Z to quit, I'll do some mad science and you'll get the new ability!"
				                          , "YOU I have NO IDEA what you just said."
                                          ];
  }
}

