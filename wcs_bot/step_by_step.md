

mix phx.gen.live Teachings DanceSchool dance_schools name:string city:string country:string boss:string


mix phx.gen.live Parties Event events name:string begin_date:date end_date:date address:string country:string lineup:string description:string url_event:string wcsdc:boolean dance_school_id:references:dance_schools


