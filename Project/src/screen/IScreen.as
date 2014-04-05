/*
	interface for all the class 
	that extend the screen class inside the current class
	package
*/
package screen
{
	public interface IScreen
	{	
		function quitCurrentActiveScreen():void;
		
		function resetCurrentActiveScreen():void;
	}
}