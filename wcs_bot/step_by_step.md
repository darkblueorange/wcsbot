Follow up
----------

mix phx.gen.live Teachings DanceSchool dance_schools name:string city:string country:string boss:string mail:string website_url:string

mix phx.gen.live Parties Event events name:string begin_date:date end_date:date address:string country:string lineup:string description:string url_event:string wcsdc:boolean dance_school_id:references:dance_schools

mix phx.gen.live Parties SmallParty small_parties name:string party_date:date begin_hour:datetime end_hour:datetime address:string country:string description:string url_party:string fb_link:string dj:string dance_school_id:references:dance_schools

ToDo: 
- look for an insertion of the schools through the event (or change relation, and attach to a string with "organizer", would be simpler)
- add timeframe lookup

Later: 
- implement too many results retrieval mgmt
- implement regular classes
- implement reccurring events (more parties though)
- implement strictly asking

Much later:
- implement image embedding in Discord (comfort and "good looking feature" but really not mandatory, probably useless)
- implement WCS tips
- implement private classes reservation (and teacher asking) => to think a little bit more
- implement video of the day
