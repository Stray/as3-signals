package org.osflash.signals
{
 
  	/**
	 * Signal dispatches events to multiple listeners.
	 * It is inspired by C# events and delegates, and by
	 * <a target="_top" href="http://en.wikipedia.org/wiki/Signals_and_slots">signals and slots</a>
	 * in Qt.
	 * A Signal adds event dispatching functionality through composition and interfaces,
	 * rather than inheriting from a dispatcher.
	 * <br/><br/>
	 * Project home: <a target="_top" href="http://github.com/robertpenner/as3-signals/">http://github.com/robertpenner/as3-signals/</a>
	 */
	public class ResponseSignal extends Signal implements ISignalOwnerDispatcher
	{

		/* purpose of this class is just to provide an ISignalOwnerDispatch implementation */
		public function ResponseSignal(valueClasses:Array)
		{
			super(valueClasses);
		}
		
	}
}
