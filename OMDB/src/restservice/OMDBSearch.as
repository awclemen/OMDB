package restservice
{
	import events.ResultEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.XMLListCollection;
	
	/**
	 * This class performs the service call to the OMDB API.
	 * 
	 * @author awclements 01July2015
	 */
	public class OMDBSearch extends EventDispatcher {
	
		// URL address of OMDB service.
		private static omdbURL = "http://www.omdbapi.com/?";
		
		// Singleton instance of this class.
		private static var _instance:OMDBSearch;
		
		public static function getInstance():OMDBSearch {
			if (_instance == null)
				_instance = new OMDBSearch();
				
			return _instance;
		} // end getInstance()
		
		/**
		 * Takes the search parameters and creates the search URL and 
		 * then sends the request to the service.
		 * 
		 * @param title - requested movie title
		 * @param year - requested year of movie
		 */
		public function sendSearch(title:String, year:int):void {
			var request:URLRequest = new URLRequest(omdbURL);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			// need to use GET for service to work.
			request.method = URLRequestMethod.GET;
			 
			var variables:URLVariables = new URLVariables();
			// s is for search on title, y is for year, r is for return type (xml or json)
			variables.s = title;
			if (year > 0)
				variables.y = year;
			variables.r = "xml";
			 
			// assign the data to be sent by GET
			request.data = variables;
			 
			// add event listeners
			loader.addEventListener(Event.COMPLETE, handleResults);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR , handleSecurityError);
			 
			// send the request
			loader.load(request);
		} // end sendSearch(String, int)
		
		private function handleResults(evt:Event):void {
			var response:String = evt.target.data as String;
			var xmlData:XML = null;
			var xmlListCol:XMLListCollection = null;
			
			try	{
				xmlData = new XML(response);
				xmlListCol = new XMLListCollection(xmlData.Movie);
				dispatchEvent(new ResultEvent(ResultEvent.RESULTS_RECEIVED, xmlListCol));
			} catch(error:TypeError) {
				trace("the response data was not in valid XML format");
				trace(response);
			}
		} // end handleResults(Event)
		
		protected function handleIOError(evt:IOErrorEvent):void
		{
			trace("handleIOError(" + evt.toString()  + ")");
		}
				
		protected function handleSecurityError(evt:SecurityErrorEvent):void
		{
			trace("handleSecurityError(" + evt.toString() + ")");			
		}
		
	} // end class OMDBSearch
} // end package restservice