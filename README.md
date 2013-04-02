EventsReader
============
Reader of JSON feed provided from external CMS.

Once dowloaded, JSON feed and its related contents are cached on device. The content's engine uses update.json to retrieve fresh data.

Events are displayed in master / detail view.

JSON Feed Example
=================
{ 
"events":
  [
		{
			"uid": "001",
			"title": "Sommer Cocktail Party",
			"category": ["Party","Cocktail"],
			"date": "05/07/2008",
			"info": [
				  		{
				  			"description":"",
				  			"lon":"9.038125",
				  			"lat":"45.529783", 
				  		}
					],	
			"description": "Schneiderei Bier & Kaffee - Sommer Cocktail Party",
			"picture": "http://localhost/events/images/2591998085_0cfbfbb179.jpg",
			"thumb": "http://localhost/events/images/2591998085_0cfbfbb179_thumb.jpg",
			"media_gallery": [
								"http://localhost/events/images/001/a.jpeg",
								"http://localhost/events/images/001/b.jpeg",
								"http://localhost/events/images/001/c.jpeg"
					 		]
		}
	]
}

JSON Update Example
===================

{
  "updates":
	[
		{"event":1},
	]
}

where %d is a incremental update value

Licence
=======
CC-BY 
