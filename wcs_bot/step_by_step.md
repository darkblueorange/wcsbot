Follow up
----------

mix phx.gen.live Teachings DanceSchool dance_schools name:string city:string country:string boss:string

mix phx.gen.live Parties Event events name:string begin_date:date end_date:date address:string country:string lineup:string description:string url_event:string wcsdc:boolean dance_school_id:references:dance_schools



ToDo: 
- solve the server small crash when asking for "add_event help" or "add_school help"
- look for an insertion of the schools through the event (or change relation, and attach to a string with "organizer", would be simpler)
- add mail address/contact for school dance studios
- add timeframe lookup
- have a look to Nostrum API and kraigie Elixir wrapper (allows the very helpful command_option helper)

Later: 
- implement timeframe event lookup
- implement with_details AND country filter
- implement too many results retrieval mgmt
- implement regular classes
- implement reccurring events (more parties though)
- implement strictly asking

Much later:
- implement image embedding in Discord (comfort and "good looking feature" but really not mandatory, probably useless)
- implement WCS tips
- implement private classes reservation (and teacher asking) => to think a little bit more
- implement video of the day
