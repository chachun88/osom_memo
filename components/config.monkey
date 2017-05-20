Import imports

Class Config Implements IOnHttpRequestComplete

	Global get_req:HttpRequest,post_req:HttpRequest
	Global dataString:String = ""
	Global localData:String = ""
	
	Function Init()	
		
		localData = LoadState()
		
		If localData <> ""
			userData = JSONObject(JSONData.ReadJSON(localData))
		Else
			userData = New JSONObject()
		Endif
		
		userData.AddPrim("musicOn", userData.GetItem("musicOn", True))
		userData.AddPrim("soundOn", userData.GetItem("soundOn", True))
		userData.AddPrim("clock", userData.GetItem("clock", 0))
		userData.AddPrim("moves", userData.GetItem("moves", 0))
		
		musicOn = userData.GetItem("musicOn")
		soundOn = userData.GetItem("soundOn")
		
		userData.AddPrim("lastPassedLevel", userData.GetItem("lastPassedLevel", NIVEL1_SCENE))
		
		
		If userData.GetItem("puntajes") <> Null
			Local puntajes:JSONObject = JSONObject(JSONData.ReadJSON(userData.GetItem("puntajes")))
				
			For Local key := Eachin puntajes.Names()
				points.AddPrim(key, puntajes.GetItem(key,0))
			Next
		Else
			userData.AddItem("puntajes", New JSONObject())
			points = New JSONObject()
		End
		
		
		If userData.GetItem("patitas") <> Null
		
			Local datatype:Int = JSONData.ReadJSON(userData.GetItem("patitas")).dataType
		
			If datatype = JSONDataType.JSON_OBJECT
			
				Local patas:JSONObject = JSONObject(JSONData.ReadJSON(userData.GetItem("patitas")))
				
				For Local key := Eachin patas.Names()
					levels.AddPrim(key, patas.GetItem(key,0))
				Next
				
			Else
				Local arr:JSONArray = JSONArray(JSONData.ReadJSON(userData.GetItem("patitas")))
				Local i:Int = 0
			
				For Local item:String = Eachin arr.values
					Print item
					levels.AddPrim("nivel " + i,item)
					i+=1
				Next
			Endif
		Else
			levels = New JSONObject()
		Endif

		userData.AddItem("patitas", levels)		
		
		SaveState(userData.ToJSONString())
		#If TARGET="android"
        If isOnline() And facebook.IsOpened() And sincronizado
        	Config.BackUp()
	    End
	    #End
	End
	
	Function Request:Void()
		
		#If TARGET="android"
			If(isOnline() And facebook.IsOpened())
     
	        	Local req:String = ""
		        	
		       	req = "" + facebook.Me().Get("id")
				       	
		       	If req <> "null"
	    	   		post_req=New HttpRequest( "GET","http://198.61.180.245:" + port + "/getprogress?data=" + EncodeBase64(req),New Config )
			    	post_req.Send
			    Else
			    	'si aun no puede obtener el id de facebook usar datos locales
			    	Config.Init()
	        	Endif
	        Else
	        	'si no esta conectado a internet y no esta conectado a facebook, utiliza datos locales
	        	Config.Init()
			Endif
		#End
	End
	
	Method OnHttpRequestComplete:Void( req:HttpRequest )
	    
	    'si request es exitoso    
        If req.Status() = 200
        	dataString = req.ResponseText()
        	
        	'si no es backup
        	If dataString <> EncodeBase64("-1", True)
        		If dataString <> ""
	        		'si no existe data local pero si existe datos sincronizados
				   	If levels.values.Count = 0
			    		userData = JSONObject(JSONData.ReadJSON(DecodeBase64(dataString)))
			    		SaveState(userData.ToJSONString())
				    Else
				    	'si existe dato local y tambien sincronizados, hacer el merge
				    	Local localObj:JSONObject = JSONObject(JSONData.ReadJSON(LoadState()))
				    	Local sincObj:JSONObject = JSONObject(JSONData.ReadJSON(DecodeBase64(dataString)))
				    	
				    	
				    	Local clock_local:Int = localObj.GetItem("clock",0)
				    	Local clock_sync:Int = sincObj.GetItem("clock",0)
				    	Local clock_sum:Int = clock_local + clock_sync
				    	
				    	Local moves_local:Int = localObj.GetItem("moves",0)
				    	Local moves_sync:Int = sincObj.GetItem("moves",0)
				    	Local moves_sum:Int = moves_local + moves_sync
				    	
				    	userData.AddPrim("moves",moves_sum)
				    	userData.AddPrim("clock",clock_sum)
						    	
				    	Local a:Int = localObj.GetItem("lastPassedLevel", NIVEL1_SCENE)
					    Local b:Int = sincObj.GetItem("lastPassedLevel", NIVEL1_SCENE)
					    
					    'hace merge de las patitas obtenidas en datos locales y sincronizados
								    	
					    If a >= b 
					    	userData.AddPrim("lastPassedLevel", a)
					    Else
					    	userData.AddPrim("lastPassedLevel", b)
					    End If
					    
						'patitas del ws
						Local patitasWs:JSONObject = JSONObject(JSONData.ReadJSON(sincObj.GetItem("patitas")))
						
						'patitas local
						Local patitasLocal:JSONObject = JSONObject(JSONData.ReadJSON(localObj.GetItem("patitas")))
						
						
						'json object auxiliar para hacer merge de las patitas	
						Local patitasAux:JSONObject = New JSONObject()
						
						If patitasWs.values.Count() >= patitasLocal.values.Count()
							For Local key := Eachin patitasWs.values.Keys()

								Local valorLocal:Int = patitasLocal.GetItem(key, 0)
								Local valorWs:Int = patitasWs.GetItem(key, 0)
											
								If valorWs >= valorLocal
									patitasAux.AddPrim(key,valorWs)
								Else
									patitasAux.AddPrim(key,valorLocal)
								Endif
							Next
						Else
							For Local key := Eachin patitasLocal.values.Keys()

								Local valorLocal:Int = patitasLocal.GetItem(key, 0)
								Local valorWs:Int = patitasWs.GetItem(key, 0)
											
								If valorWs >= valorLocal
									patitasAux.AddPrim(key,valorWs)
								Else
									patitasAux.AddPrim(key,valorLocal)
								Endif
							Next
						End If
								
						userData.AddItem("patitas", patitasAux)	
						
						
						'merge puntajes
						
						'puntajes del ws
						Local puntajesWs:JSONObject = JSONObject(JSONData.ReadJSON(sincObj.GetItem("puntajes")))
						
						'puntajes local
						Local puntajesLocal:JSONObject = JSONObject(JSONData.ReadJSON(localObj.GetItem("puntajes")))
						
						'json object auxiliar para hacer merge de los puntajes	
						Local puntajesAux:JSONObject = New JSONObject()
						
						For Local key := Eachin patitasLocal.values.Keys()

							Local valorLocal:Int = puntajesLocal.GetItem(key, 0)
							Local valorWs:Int = puntajesWs.GetItem(key, 0)
											
							If valorWs >= valorLocal
								puntajesAux.AddPrim(key,valorWs)
							Else
								puntajesAux.AddPrim(key,valorLocal)
							Endif
						Next
						
						For Local key := Eachin puntajesWs.values.Keys()

							Local valorLocal:Int = puntajesLocal.GetItem(key, 0)
							Local valorWs:Int = puntajesWs.GetItem(key, 0)
											
							If valorWs >= valorLocal
								puntajesAux.AddPrim(key,valorWs)
							Else
								puntajesAux.AddPrim(key,valorLocal)
							Endif
						Next
						
						userData.AddItem("puntajes", puntajesAux)				
						
				    	userData.AddPrim("musicOn", localObj.GetItem("musicOn", True))
						userData.AddPrim("soundOn", localObj.GetItem("soundOn", True))
						
						musicOn = userData.GetItem("musicOn")
						soundOn = userData.GetItem("soundOn")
						
				    	SaveState(userData.ToJSONString())
				    	
				    Endif	'si existe dato local
				Endif 'si trae progreso
				
				#If TARGET="android"
			        If isOnline() And facebook.IsOpened() And sincronizado
			        	Config.BackUp()
					Endif
		    	#End
				
				'setea sincronizado, para no hacer el proceso mas de una vez    
			    sincronizado = True
			    
			Endif 		'si no es backup	
        Endif   'request status
        reqFinished = True 
    End

	Function BackUp:Void()
			        
	   	Local req:String = ""
			        	
	   	If LoadState().Length()
	   		req = "[{~qprogress~q:" + LoadState() + ",~quserid~q:~q" + facebook.Me().Get("id") + "~q}]"
	   	Else If facebook.Me().Get("id") <> ""
	   		req = "[{~qprogress~q:{},~quserid~q:~q" + facebook.Me().Get("id") + "~q}]"
	   	Endif
						
		Print req

		post_req=New HttpRequest( "GET","http://198.61.180.245:" + port + "/saveprogress?data=" + EncodeBase64(req), New Config())
		post_req.Send()
				        
	End
	
	
End