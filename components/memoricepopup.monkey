Import imports

Import brl.json

'''' interfaces para MonkeyStore están disponibles solo para ios y android
#If TARGET="android" Or TARGET="ios"
Class lpMemoricePopup Extends lpPopup Implements iHudButton,IOnOpenStoreComplete,IOnBuyProductComplete,IOnGetOwnedProductsComplete
#Else
Class lpMemoricePopup Extends lpPopup Implements iHudButton
#End

	Private
	
		'''''''''''
		''' iap '''
		'''''''''''
		Const BTN_CLOSE:Int = 0
		Const BTN_PRICE:Int = 1
		
        #If TARGET="android" Or TARGET="ios"
		Field store:MonkeyStore
        #End
		

	    Field close:HudButton
	    Field price:HudButton
	    Field background:lpImage
	    Field booster:lpImage
		Field screenWidth:Float
		Field screenHeight:Float
		Field vpx:Float
		Field vpy:Float
	    Field theTween:lpTween
	    Field soundButton:String
		Field r:Bool = True
		Field scale_value:Float = 0.0
		Field descripcion:String = ""
		Field font:AngelFont
		Field boton_comprar_visible:Bool
		
	Public
	
		Global idBooster:Int

		Const CLOCK_BOOSTER:Int = 1
		Const MOVES_BOOSTER:Int = 2
		Const CLOCKMOVES_BOOSTER:Int = 3
	

    ''' constructor that allow to show a centered text
    Method New(id_booster:Int, width:Float = 640, height:Float = 960, sound:String, fuente:AngelFont)
    	idBooster = id_booster
    	screenWidth = width
    	screenHeight = height
    	soundButton = sound
    	font = fuente
    	
        #If TARGET="android" Or TARGET="ios"
    	''' iap store initialization
    	store = New MonkeyStore    	
    	store.AddProducts( CONSUMABLES, 1 )    	
    	store.OpenStoreAsync( Self )
        #End
    End

    ''' implement the framework methods
    Method Create:Void()
    
    	close = New HudButton(skin + "close.png", soundButton)
    	price = New HudButton(skin + "boton_sin_sombra.png", soundButton)
    	background = New lpImage(skin + "fondo_popup_compra.png", New Vector2(0,0))
    	r = True
    	
    	boton_comprar_visible = True
    	
    	background.Position.X = -background.Position.Width
		background.Position.Y = screenHeight / 2 - background.Position.Height / 2
		
		close.Position.Y = background.Position.Y - close.Position.Height / 4
		close.SetId( BTN_CLOSE )
		close.SetListener(Self)
		
		price.Position.Y = 630
		price.SetFont(font)
		price.SetText("0.99")
		price.SetLeftPadding(-30)
		price.SetTopPadding(-5)
		price.SetId( BTN_PRICE )
		price.SetListener( Self )
    	
    	Select Self.idBooster
    		Case CLOCK_BOOSTER
		    	booster = New lpImage(skin + "big_clock.png", New Vector2(0,0))
		    	descripcion = "Detiene el tiempo por 5 segundos"
		    	#If TARGET="android" Or TARGET="ios"
		    		If store.IsOpen() And Not store.IsBusy()
						descripcion = store.GetProduct(CONSUMABLES[0]).Description()
						price.SetText(store.GetProduct(CONSUMABLES[0]).Price())
					Endif
        		#End		    	
		    Case MOVES_BOOSTER
		    	booster = New lpImage(skin + "big_moves.png", New Vector2(0,0))
		    	descripcion = "Agrega 3 movimientos"
		    	#If TARGET="android" Or TARGET="ios"
			    	If store.IsOpen() And Not store.IsBusy()
						descripcion = store.GetProduct(CONSUMABLES[1]).Description()
						price.SetText(store.GetProduct(CONSUMABLES[1]).Price())
					Endif
        		#End
        	Case CLOCKMOVES_BOOSTER
        		booster = New lpImage(skin + "clock_moves.png", New Vector2(0,0))
		    	descripcion = "Agrega 5 segundos y 3 movimientos"
		    	#If TARGET="android" Or TARGET="ios"
			    	If store.IsOpen() And Not store.IsBusy()
						descripcion = store.GetProduct(CONSUMABLES[2]).Description()
						price.SetText(store.GetProduct(CONSUMABLES[2]).Price())
					Endif
        		#End
		End Select
		
		booster.Position.Y = background.Position.Y + 50
		booster.Position.X = (background.Position.X + background.Position.Width) / 2 - booster.Position.Width / 2 '+ booster.Position.Width / 8
		
		vpx = Float(DeviceWidth())/screenWidth
		vpy = Float(DeviceHeight())/screenHeight
		
		theTween = lpTween.CreateBack(lpTween.EASEOUT, -background.Position.Width, screenWidth / 2 - background.Position.Width / 2, 500)
		
    End
    
    Method Update:Void(delta:Int)     	
    	UpdateAsyncEvents
        close.Update(delta)
        price.Update(delta)
    End

    Method Render:Void()
    
    	If ( r )
    		theTween.Start()
    		r = False
    	End       
        
        theTween.Update()
        
        background.Position.X = theTween.GetCurrentValue()
    	close.Position.X = background.Position.X + background.Position.Width - close.Position.Width + close.Position.Width / 4
    	booster.Position.X = (background.Position.X + background.Position.Width) / 2 - booster.Position.Width / 2 + booster.Position.Width / 10
		price.Position.X = background.Position.X + background.Position.Width / 2 - price.Position.Width / 2	
        
    	PushMatrix
    	Scale vpx, vpy
    		background.Render()
			close.Render()
			booster.Render()
			font.DrawMultilineText(descripcion, 400, theTween.GetCurrentValue() + background.Position.Width / 2, screenHeight / 2, screenWidth, AngelFont.ALIGN_CENTER)
			If boton_comprar_visible
				price.Render()
			Endif
		PopMatrix
    End
    
    Method OnClick:Void(button:HudButton)
    	Select button.GetId()
    		Case BTN_CLOSE
		    	lpHidePopup()
		    	If Nivel.finished
		    		lpSceneMngr.GetInstance().SetScene(LOSE_SCENE)
		    	End
		    Case BTN_PRICE
		    	
                #If TARGET="android" Or TARGET="ios"
		    	
			    	If store.IsOpen() And Not store.IsBusy()
			    	
			    		#If CONFIG="release"
			    			Flurry.LogEvent ( "click en boton comprar - nivel " + (ObjetivoNivel.numNivel - 19) )
							lpAnalytics.SendView( "click en boton comprar - nivel " + (ObjetivoNivel.numNivel - 19) )
						#End
						Select Self.idBooster
				    		Case CLOCK_BOOSTER
				    			Local p:Product = store.GetProduct(CONSUMABLES[0])
				    			If p <> Null
					    			store.BuyProductAsync p,Self
					    		Endif
						    Case MOVES_BOOSTER
						    	Local p:Product = store.GetProduct(CONSUMABLES[1])
				    			store.BuyProductAsync p,Self
				    		Case CLOCKMOVES_BOOSTER
				    			Local p:Product = store.GetProduct(CONSUMABLES[2])
				    			store.BuyProductAsync p,Self
						End Select
					End
                #End
		End Select
    End
    
    
    ''''''''''''''''''''''''''''''''''''
    '''' implementing iap listeners ''''
    ''''''''''''''''''''''''''''''''''''
    #If TARGET="android" Or TARGET="ios"
    Field purchases:=New JsonObject
	
	Method LoadPurchases:Void()
		Local f:=FileStream.Open( "monkey://internal/.purchases","r" )
		If Not f Return
		Local json:=f.ReadString()
		Print "LoadPurchases: Json="+json
		purchases=New JSONObject( JSONData.ReadJSON(json) )
		f.Close()
	End
	
	Method SavePurchases:Void()
		Local f:=FileStream.Open( "monkey://internal/.purchases","w" )
		If Not f Error "Unable to save purchases"
		Local json:=purchases.ToJson()
		Print "SavePurchases: Json="+json
		f.WriteString( json )
		f.Close()
	End
	
	Method OnOpenStoreComplete:Void( result:Int )
		Print "OpenStoreComplete, result="+result
		If result<>0 
			descripcion = "La tienda no está disponible, por favor intente más tarde"
			boton_comprar_visible = False
		Endif
		Self.Create()
	End
	
	Method OnBuyProductComplete:Void( result:Int,product:Product )
		Print "BuyProductComplete, result="+result
		If result<>0 Return
		Select product.Type
		Case 1 
			purchases.SetInt product.Identifier,purchases.GetInt( product.Identifier )+1
			If(product.Identifier = "com.loadingplay.osom.time") 
				Nivel.left_time += 5000
				Nivel.finished = False
				SaveState(userData.ToJSONString())
				#If CONFIG="release"
			    	Flurry.LogEvent ( "booster comprado - nivel " + (ObjetivoNivel.numNivel - 19) )
					lpAnalytics.SendView( "booster comprado - nivel " + (ObjetivoNivel.numNivel - 19) )
				#End
			Else If(product.Identifier = "com.loadingplay.osom.moves") 
				userData.AddPrim("moves", userData.GetItem("moves",0) + 1)
				Nivel.intentos_sobrantes += 3
				Nivel.finished = False
				#If CONFIG="release"
			    	Flurry.LogEvent ( "booster comprado - nivel " + (ObjetivoNivel.numNivel - 19) )
					lpAnalytics.SendView( "booster comprado - nivel " + (ObjetivoNivel.numNivel - 19) )
				#End
			Endif
		Case 2 purchases.SetBool product.Identifier,True
		End
		SavePurchases
	End
	
	Method OnGetOwnedProductsComplete:Void( result:Int,products:Product[] )
		Print "GetOwnedProductsComplete, result="+result
		If result<>0 Return
		If Not products Return
		For Local p:=Eachin products
			purchases.SetBool p.Identifier,True
		Next
		SavePurchases
	End
	#end
End





