// ActionScript file
package events
{
	import flash.events.Event;
	import mx.collections.XMLListCollection;
 
	public class ResultEvent extends Event
	{
		public static const RESULTS_RECEIVED:String = "results_received";
 
		// in our case the data is of XML type..
		protected var _data:XMLListCollection;
 
		// the getter
		public function get data():XMLListCollection
		{
			return _data;
		}
 
		public function ResultEvent(type:String, data:XMLListCollection):void
		{
			// initialize the event
			super(type);
 
			// keep reference to the data
			_data = data;
		}		
	} // end class ResultEvent
} // end package events