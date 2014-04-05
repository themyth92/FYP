package assets
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import manager.SoundManager;

	public class SoundAssets
	{	
		[Embed(source = '../media/sound/CreateGameBackground.mp3')]
		private static const CreateGameBackgroundSound:Class;
		
		[Embed(source="../media/sound/NavigationBackground.mp3")]
		private static const NavigationBackgroundSound:Class;
		
		[Embed(source="../media/sound/StoryBackground.mp3")]
		private static const StoryBackgroundSound:Class;
		
		private static var _music		: SoundManager = new SoundManager();
		private static var _soundFX 	: SoundManager = new SoundManager();
		
		/*
			check if the sound is added
			return to the user the static instace of this class
		 * */
		public static function getMusic(soundName:String):SoundManager
		{
			if(!_music.soundIsAdded(soundName)){
				
				var sound:Sound = new SoundAssets[soundName]();
				_music.addSound(soundName, sound);
			}
			
			return _music;
		}
		
		public static function getSoundFX(soundName:String):SoundManager
		{
			if(!_soundFX.soundIsAdded(soundName)){
				
				var sound : Sound 	= new SoundAssets[soundName]();
				_soundFX[soundName]	= sound;	
			}
			
			return _soundFX;	
		}
	}
}