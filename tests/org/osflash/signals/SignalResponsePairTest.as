package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;

	import flash.display.Sprite;

	public class SignalResponsePairTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		public var responsePair:SignalResponsePair; 
		
		private const REQUEST_STRING:String = 'RequestTestString';
		private const REQUEST_SPRITE:Sprite = new Sprite();
		
		private const RESPONSE_STRING:String = 'ResponseTestString';
		private const RESPONSE_NUMBER:Number = 0.34;
		private const RESPONSE_SPRITE:Sprite = new Sprite();
		
		[Before]
		public function setUp():void
		{
			responsePair = new SignalResponsePair([Sprite, String], [String, Number, Sprite]);
		}

		[After]
		public function tearDown():void
		{
			responsePair.removeAll();
			responsePair = null;
		}

		//////
         
		[Test]
		public function get_responseSignal_gives_signal_with_correct_value_classes():void
		{
			assertTrue('the response signal is a Signal', responsePair.responseSignal is Signal);
			assertTrue('the response signal is not null', responsePair.responseSignal != null);
			assertEqualsArrays('the response signal has the required value types', [String, Number, Sprite], responsePair.responseSignal.valueClasses)
		}

		//////
		
		[Test]
		public function get_value_classes_for_request_is_correct():void
		{
			assertEqualsArrays('the main signal has the required value types', [Sprite, String], responsePair.valueClasses);
		}

		//////

		[Test]
		public function numListeners_is_0_after_creation():void
		{
			assertEquals(0, responsePair.numListeners);
		}
		
		//////
		
		[Test]
		public function addToRequest_adds_to_the_request_signal():void
		{
			responsePair.addToRequest(checkRequestDispatch);
			assertEquals(1, responsePair.numListeners);
		}
		
		//////
		
		[Test]
		public function dispatchRequest_runs_dispatch():void
		{
			responsePair.addToRequest(async.add(checkRequestDispatch, 10));
			responsePair.dispatchRequest(REQUEST_SPRITE, REQUEST_STRING);
		}
		
		private function checkRequestDispatch(sprite:Sprite, str:String):void
		{
			assertEquals("Dispatched sprite ok", REQUEST_SPRITE, sprite);
			assertEquals("Dispatched string ok", REQUEST_STRING, str);
		}
		
		//////

		[Test]
		public function addToResponse_adds_to_the_response_signal():void
		{
			responsePair.addToResponse(checkResponseDispatch);
			assertEquals(1, responsePair.responseSignal.numListeners);
		}

		//////
		
		[Test]
		public function dispatchRequest_runs_dispatch_on_response_signal():void
		{
			responsePair.addToResponse(async.add(checkResponseDispatch, 10));
			responsePair.dispatchResponse(RESPONSE_STRING, RESPONSE_NUMBER, RESPONSE_SPRITE);
		}
		
		protected function checkResponseDispatch(str:String, n:Number, sprite:Sprite):void
		{
			assertEquals("Dispatched string ok", RESPONSE_STRING, str);
			assertEquals("Dispatched number ok", RESPONSE_NUMBER, n);
			assertEquals("Dispatched sprite ok", RESPONSE_SPRITE, sprite);
		}
		
 		//////
      
		
		[Test]
		public function addToRequestOnce_removes_after_one_dispatch():void
		{
			responsePair.addToRequestOnce(async.add(checkRequestDispatch, 10));
			responsePair.dispatchRequest(REQUEST_SPRITE, REQUEST_STRING);
			assertEquals('Listener has been removed from request signal', 0, responsePair.numRequestListeners);
		}

		//////
		
		[Test]
		public function addToResponseOnce_removes_after_one_dispatch():void
		{
			responsePair.addToResponseOnce(async.add(checkResponseDispatch, 10));
			responsePair.dispatchResponse(RESPONSE_STRING, RESPONSE_NUMBER, RESPONSE_SPRITE);
			assertEquals('Listener has been removed from response signal', 0, responsePair.numResponseListeners);
		}
		
 		//////
   	
		[Test]
		public function removeFromRequest_removes_correct_listener():void
		{
			responsePair.addToRequest(async.add(checkRequestDispatch, 10));
			responsePair.addToRequest(failIfCalled);
			responsePair.removeFromRequest(failIfCalled);
			responsePair.dispatchRequest(REQUEST_SPRITE, REQUEST_STRING);
		}

		//////
		
		[Test]
		public function removeFromResponse_removes_correct_listener():void
		{
			responsePair.addToResponse(async.add(checkResponseDispatch, 10));
			responsePair.addToResponse(failIfCalled);
			responsePair.removeFromResponse(failIfCalled);
			responsePair.dispatchResponse(RESPONSE_STRING, RESPONSE_NUMBER, RESPONSE_SPRITE);
		}
		
		private function failIfCalled(arg1:*, arg2:*, arg3:*):void
		{
			fail('This event handler should not have been called.');
		}
		
		private function alsoFailIfCalled(arg1:*, arg2:*, arg3:*):void
		{
			fail('This event handler should not have been called either.');
		}
		   
		//////
		
		[Test]
		public function removeAllFromRequest_removes_all_listeners():void
		{
			responsePair.addToRequest(failIfCalled);
			responsePair.addToRequest(alsoFailIfCalled);
			responsePair.removeAllFromRequest();
			responsePair.dispatchRequest(REQUEST_SPRITE, REQUEST_STRING); 
			assertEquals('All listeners have been removed from request signal', 0, responsePair.numRequestListeners);			
		}

		//////
		
		[Test]
		public function removeAllFromResponse_removes_correct_listener():void
		{
			responsePair.addToResponse(failIfCalled);
			responsePair.addToResponse(alsoFailIfCalled);
			responsePair.removeAllFromResponse();
			responsePair.dispatchResponse(RESPONSE_STRING, RESPONSE_NUMBER, RESPONSE_SPRITE);
 			assertEquals('All listeners have been removed from response signal', 0, responsePair.numResponseListeners);
   	}
		
				
	   
	}
}
