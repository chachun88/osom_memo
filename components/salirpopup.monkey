Import imports
Class lpSalirPopup Extends lpPopup Implements iHudButton

	Private
	
		Const BTN_CLOSE:Int = 0
		Const BTN_CONTINUAR:Int = 1
		Const BTN_SALIR:Int = 3
		
	    Field close:HudButton
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
	

    ''' constructor that allow to show a centered text
    Method New(sound:String, fuente:AngelFont, desc:String, width:Float = 640, height:Float = 960)
    	screenWidth = width
    	screenHeight = height
    	soundButton = sound
    	font = fuente
    	descripcion = desc
    End

    ''' implement the framework methods
    Method Create:Void()
    
    	close = New HudButton(skin + "close.png", soundButton)
    	continuar = New HudButton(skin + "boton_sin_sombra.png", soundButton)
    	salir = New HudButton(skin + "boton_sin_sombra.png", soundButton)
    	background = New lpImage(skin + "fondo_popup_compra.png", New Vector2(0,0))
    	r = True
    	
    	background.Position.X = -background.Position.Width
		background.Position.Y = screenHeight / 2 - background.Position.Height / 2
		
		close.Position.Y = background.Position.Y - close.Position.Height / 4
		close.SetId( BTN_CLOSE )
		close.SetListener(Self)
		
		salir.Position.Y = 630
		salir.SetFont(font)
		salir.SetText("Salir")
		salir.SetLeftPadding(-30)
		salir.SetTopPadding(-5)
		salir.SetId( BTN_SALIR )
		salir.SetListener( Self )
		
		continuar.Position.Y = 500
		continuar.SetFont(font)
		continuar.SetText("Continuar")
		continuar.SetLeftPadding(-30)
		continuar.SetTopPadding(-5)
		continuar.SetId( BTN_CONTINUAR )
		continuar.SetListener( Self )
    	
		vpx = Float(DeviceWidth())/screenWidth
		vpy = Float(DeviceHeight())/screenHeight
		
		theTween = lpTween.CreateBack(lpTween.EASEOUT, -background.Position.Width, screenWidth / 2 - background.Position.Width / 2, 500)
		
    End
    
    Method Update:Void(delta:Int)     	
    	UpdateAsyncEvents
        close.Update(delta)
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
    	close.Position.X = background.Position.X + background.Position.Width - close.Position.Width + close.Position.Width / 4
		salir.Position.X = background.Position.X + background.Position.Width / 2 - salir.Position.Width / 2	
		continuar.Position.X = background.Position.X + background.Position.Width / 2 - continuar.Position.Width / 2
        
    	PushMatrix
    	Scale vpx, vpy
    		background.Render()
			close.Render()
			continuar.Render()
			salir.Render()
			font.DrawMultilineText(descripcion, 300, theTween.GetCurrentValue() + background.Position.Width / 2, 300, screenWidth, AngelFont.ALIGN_CENTER)
		PopMatrix
    End
    
    Method OnClick:Void(button:HudButton)
    	Select button.GetId()
    		Case BTN_CLOSE
		    	lpHidePopup()
		    Case BTN_SALIR
		    	lpHidePopup()
		    	
				If ObjetivoNivel.numNivel >= NIVEL1_SCENE And ObjetivoNivel.numNivel <= NIVEL9_SCENE
					lpSceneMngr.GetInstance().SetScene(LEVELMENU_SCENE)
				Else If ObjetivoNivel.numNivel >= NIVEL10_SCENE And ObjetivoNivel.numNivel <= NIVEL18_SCENE
					lpSceneMngr.GetInstance().SetScene(LEVELMENU2_SCENE)
				Else If ObjetivoNivel.numNivel >= NIVEL19_SCENE And ObjetivoNivel.numNivel <= NIVEL27_SCENE
					lpSceneMngr.GetInstance().SetScene(LEVELMENU3_SCENE)
				End If
			Case BTN_CONTINUAR
		    	lpHidePopup()
		End Select
    End
End