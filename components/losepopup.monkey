Import imports

''''''''''''''''''''''''''''''''''
''' POPUP AL MOMENTO DE PERDER '''
''''''''''''''''''''''''''''''''''

Class lpLosePopup Extends lpPopup Implements iHudButton

	Public
	
		Global g_ptje:Int
		Global g_meta:Int
		Global g_left_moves:Int
		Global g_total_moves:Int
		Global g_left_time:Int
		Global g_total_time:Int
		Global g_volteados:Int
		Global g_pares:Int
		
	Private
	
		Const BTN_SALIR:Int = 1
		Const BTN_CONTINUAR:Int = 2
		
		Field idBooster:Int
		
	    Field continuar:HudButton
        Field salir:HudButton
	    Field background:lpImage
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
		Field url_background:String
		
		Field font42:AngelFont
		
		Field checked:lpImage = New lpImage( skin + "checked.png", New Vector2(0,0))
		Field unchecked:lpImage = New lpImage( skin + "unchecked.png", New Vector2(0,0))
	

    ''' constructor that allow to show a centered text
    Method New(sound:String, fuente:AngelFont, desc:String, url_fondo:String = "", idbooster:Int = lpMemoricePopup.CLOCKMOVES_BOOSTER, width:Float = 640, height:Float = 960)
    	screenWidth = width
    	screenHeight = height
    	soundButton = sound
    	font = fuente
    	descripcion = desc
    	url_background = url_fondo
    	idBooster = idbooster
    	font42 = New AngelFont()
		font42.LoadFntFont( skin + "font/crayon_42" )
    End

    ''' implement the framework methods
    Method Create:Void()
   
    	continuar = New HudButton(skin + "btnPopup.png", soundButton)
    	salir = New HudButton(skin + "btnPopup.png", soundButton)
    	background = New lpImage(skin + url_background, New Vector2(0,0))
    	r = True
    	
    	
    	
    	background.Position.X = -background.Position.Width
		background.Position.Y = screenHeight / 2 - background.Position.Height / 2
		
		checked.Position.Y = 635
		unchecked.Position.Y = 635
		
		salir.Position.Y = 470
		'salir.Position.X = 330
		salir.SetFont(font52)
		salir.SetText("Salir")
		'salir.SetLeftPadding(-30)
		salir.SetTopPadding(-12)
		salir.SetId( BTN_SALIR )
		salir.SetListener( Self )
		
		continuar.Position.Y = 470
		'continuar.Position.X = 100
		continuar.SetFont(font52)
		continuar.SetText("Continuar")
		'continuar.SetLeftPadding(-30)
		continuar.SetTopPadding(-12)
		continuar.SetId( BTN_CONTINUAR )
		continuar.SetListener( Self )
    	
		vpx = Float(DeviceWidth())/screenWidth
		vpy = Float(DeviceHeight())/screenHeight
		
		theTween = lpTween.CreateBack(lpTween.EASEOUT, -background.Position.Width, screenWidth / 2 - background.Position.Width / 2, 500)
		
    End
    
    Method Update:Void(delta:Int)     	
    	UpdateAsyncEvents
        continuar.Update(delta)
        salir.Update(delta)
    End

    Method Render:Void()
    
    	If ( r )
    		theTween.Start()
    		r = False
    	End       
        
        theTween.Update()
        
        background.Position.X = theTween.GetCurrentValue()
		salir.Position.X = theTween.GetCurrentValue() + 290
		continuar.Position.X = theTween.GetCurrentValue() + 60
		
		checked.Position.X = theTween.GetCurrentValue() + 80
		unchecked.Position.X = theTween.GetCurrentValue() + 80
        
    	PushMatrix
    	Scale vpx, vpy
    		background.Render()
			continuar.Render()
			salir.Render()
			
			If g_volteados >= g_pares checked.Render() Else unchecked.Render()
			
			checked.Position.X += 150
			unchecked.Position.X += 150

			If g_ptje >= g_meta	checked.Render() Else unchecked.Render()
			
			font42.DrawMultilineText(descripcion, 300, theTween.GetCurrentValue() + background.Position.Width / 2, 580, screenWidth, AngelFont.ALIGN_CENTER)
			font42.DrawMultilineText(g_ptje + "/" + g_meta, 300, theTween.GetCurrentValue() + 270, 630, screenWidth, AngelFont.ALIGN_LEFT)
			font42.DrawMultilineText(g_volteados + "/" + g_pares, 300, theTween.GetCurrentValue() + 120, 630, screenWidth, AngelFont.ALIGN_LEFT)
		PopMatrix
    End
    
    Method OnClick:Void(button:HudButton)
    	Select button.GetId()
		    Case BTN_SALIR
		    	lpHidePopup()
		    	
				lpSceneMngr.GetInstance().SetScene(LOSE_SCENE)
				
			Case BTN_CONTINUAR
			
				Local popup:lpMemoricePopup = New lpMemoricePopup(idBooster, VIEWPORTW, VIEWPORTH, HUDBUTTON_SOUND, font62)
				popup.SetBackgroundAlpha(0.2)
				popup.Create()
				lpShowPopup(popup)
				
		End Select
    End
    
    Method SetDescripcion:Void(desc:String)
    	descripcion = desc
    End
    
    Method SetIdBooster:Void(id:Int)
    	idBooster = id
    End	
   
End