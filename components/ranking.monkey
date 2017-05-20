Import imports

Class Ranking Extends lpScene Implements IOnHttpRequestComplete

	Global ranking_req:HttpRequest
	Global amigos_ranking:StringList = New StringList
	Global puntajes_ranking:IntList = New IntList
	
	Function GetRankingByLevel:Void( data:String, nivel:String )
	
		ranking_req=New HttpRequest( "GET","http://198.61.180.245:" + port + "/getrankingbylevel?data=" + EncodeBase64(data) + "&nivel=" + EncodeBase64(nivel),New Ranking )
    	ranking_req.Send
    	
	End 'end GetRankingByLevel

	Method OnHttpRequestComplete:Void( req:HttpRequest )
	
		'si es exitoso
		If req.Status() = 200
		
			amigos_ranking.Clear()
			
			Local arr:JSONArray = JSONArray(JSONData.ReadJSON(req.ResponseText()))
			
			For Local item := Eachin arr
				Local i:JSONArray = JSONArray(JSONData.ReadJSON(item.ToJSONString()))
				amigos_ranking.AddFirst(i.values.First().ToString())
				puntajes_ranking.AddFirst(i.values.Last().ToInt())
			Next
			
		End 'end req.Status() = 200
		
	End 'end method OnHttpRequestComplete

End 'end class