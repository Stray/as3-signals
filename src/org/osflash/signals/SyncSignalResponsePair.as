package org.osflash.signals
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

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
	public class SyncSignalResponsePair extends Signal
	{
		
		private var _responseSignal:Signal;
				
		/**
		 * Creates a Signal instance to dispatch value objects.
		 * @param	valueClasses Any number of class references that enable type checks in dispatch().
		 * For example, new Signal(String, uint)
		 * would allow: signal.dispatch("the Answer", 42)
		 * but not: signal.dispatch(true, 42.5)
		 * nor: signal.dispatch()
		 *
		 * NOTE: Subclasses cannot call super.apply(null, valueClasses),
		 * but this constructor has logic to support super(valueClasses).
		 */
		public function SyncSignalResponsePair(requestValueClasses:Array, responseValueClasses:Array)
		{
			// The dispatch will always be the response signal
			requestValueClasses.unshift(Signal);
			super(requestValueClasses);
			_responseSignal = new Signal(responseValueClasses);
		}
		
		public function addToRequest(listener:Function):Function
		{
			return add(listener);
		}

		public function addToResponse(listener:Function):Function
		{
			return _responseSignal.add(listener);
		}

		public function addToRequestOnce(listener:Function):Function
		{
			return addOnce(listener);
		}

		public function addToResponseOnce(listener:Function):Function
		{
			return _responseSignal.addOnce(listener);
		} 

		public function removeFromRequest(listener:Function):Function
		{
			return remove(listener);
		}

		public function removeFromResponse(listener:Function):Function
		{
			return _responseSignal.remove(listener);
		}

		public function removeAllFromRequest():void
		{
			removeAll();
		}

		public function removeAllFromResponse():void
		{
			_responseSignal.removeAll();
		}

		public function get numRequestListeners():uint
		{
			return numListeners;
		}

		public function get numResponseListeners():uint
		{
			return _responseSignal.numListeners;
		}
		
		public function get requestValueClasses():Array
		{
			return valueClasses;
		}
		
		public function get responseValueClasses():Array
		{
			return _responseSignal.valueClasses;
		}

		public function dispatchRequest(...valueObjects):void
		{
			switch (valueObjects.length)
			{
				case 0:
					dispatch();
					break;

				case 1:
					dispatch(valueObjects[0]);
					break;

				default:
					dispatch.apply(this, valueObjects);
			}
		}
		
		public override function dispatch(...valueObjects):void
		{
			switch (valueObjects.length)
			{
				case 0:
					super.dispatch(_responseSignal);
					break;

				case 1:
					super.dispatch([_responseSignal, valueObjects[0]]);
					break;

				default:
					
					var valueObjectsWithResponseSignal:Array = [_responseSignal];
					
					var iLength:uint = valueObjects.length;
					for (var i:int = 0; i < iLength; i++)
					{
						valueObjectsWithResponseSignal.push(valueObjects[i]);
					}
					
					processDispatch(valueObjectsWithResponseSignal);
			}
		}
		
		protected function processDispatch(valueObjects:Array):void
		{
			
			
			switch (valueObjects.length)
			{
				case 3:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2]);
					break;

				case 4:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3]);
					break;
					
		   	   	case 5:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3], valueObjects[4]);
					break;

		   	   	case 6:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3], valueObjects[4], valueObjects[5]);
					break;

		   	   	case 7:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3], valueObjects[4], valueObjects[5], valueObjects[6]);
					break;
	        
		   	   	case 8:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3], valueObjects[4], valueObjects[5], valueObjects[6], valueObjects[7]);
					break;

		   	   	case 9:
					super.dispatch(valueObjects[0], valueObjects[1], valueObjects[2], valueObjects[3], valueObjects[4], valueObjects[5], valueObjects[6], valueObjects[7], valueObjects[8]);
					break;
                       
				default:
					throw new IllegalOperationError('The SyncSignalResponsePair is only set up to handle up to 8 args on dispatch, override the processDispatch function for more');
			}
		
		}

	        
		
	}
}
