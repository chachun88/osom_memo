Import imports

Class LevelMenu Extends lpScene Implements iHudButton

	Field img:lpImage
	Field buttonNext:HudButton
	Field margen_x:Int = 100
	Field margen_y:Int = 50
	
	Const botonW:Float = 163
	Const botonH:Float = 153
	Const border:Float = 10
	Const initialX:Float = 70
	Const finalX:Float = 450
	Const initialY:Float = 250
	Const finalY:Float = 650
	
	Field logo:lpImage = New lpImage( skin + "splash.png", New Vector2(0,0) )
	
	Global popupSalir:lpSalirPopup
	Const SALIR_BUTTON:Int = 3
	Field btnSalir:HudButton
	
	
	
	Global sgte:Bool = True
	
	Field botones:Stack<HudButton>
	
	Field done:Bool = False
	
	Method New()
		#If TARGET="android"
        If isOnline() And facebook.IsOpened() And Not sincronizado
	        reqFinished = False
	        Config.Request()
	    Else
	    	Config.Init()
		Endif
    	#End
    End

	Method Create:Void()
	
		sgte = True
	
		img = New lpImage(skin + "fondo.png", New Vector2(0,0))
		botones = New Stack<HudButton>()
		
		buttonNext = New HudButton(skin + "right_arrow.png")
		buttonNext.Position.X = VIEWPORTW - margen_x - buttonNext.Position.Width / 2
		buttonNext.Position.Y = VIEWPORTH - buttonNext.Position.Height - margen_y
		buttonNext.SetId(LEVELMENU2_SCENE)
		buttonNext.SetListener(Self)
		
		btnSalir = New HudButton(skin + "btnSalir.png", HUDBUTTON_SOUND)
		
		btnSalir.SetId(SALIR_BUTTON)
		btnSalir.SetListener(Self)
		btnSalir.Position.X = VIEWPORTW / 2 - btnSalir.Position.Width / 2
		btnSalir.Position.Y = VIEWPORTH - 90
		
		popupSalir = New lpSalirPopup(HUDBUTTON_SOUND, font62, "¿Estás segur@ que desea salir?")
		popupSalir.SetBackgroundAlpha(0.2)
		
		Self.CrearNiveles(NIVEL1_SCENE)
		
	End
	Method CrearNiveles:Void(i:Int)
	
		botones.Clear
		
		For Local y:Float = initialY Until finalY Step botonH + border
			For Local x:Float = initialX Until finalX Step botonW + border
				Local button:HudButton
				
				If  i <= userData.GetItem("lastPassedLevel",NIVEL1_SCENE)
					button = New HudButton(skin + "boton_nivel.png", font, "")
					button.SetText( i - 19 )
					button.SetListener(Self)
				Else
					button = New HudButton(skin + "level_button.png", font, "")
					'inactivo
				Endif
				button.SetTopPadding(-10)
				button.SetId(i)
				button.SetMuted(Not soundOn)
				button.Position.X = x
				button.Position.Y = y
				botones.Push(button)
				i += 1
			Next 
		Next
		
	End
	
	Method Update:Void(delta:Int)

		If (KeyHit( KEY_ESCAPE ))
			lpSceneMngr.GetInstance().SetScene(MAINMENU_SCENE)
		End
		For Local boton := Eachin botones
			boton.Update(delta)
		Next
		buttonNext.Update(delta)
		btnSalir.Update(delta)
		If sincronizado And Not done 
			Self.CrearNiveles(NIVEL1_SCENE)
			done = Not done
		Endif
		UpdateAsyncEvents
	End
	
	Method Render:Void()
		PushMatrix()
			Scale vpx, vpy
			img.Render()
			font.DrawText("Niveles", VIEWPORTW / 2, 50, AngelFont.ALIGN_CENTER)
			btnSalir.Render()
		PopMatrix()
		
		For Local boton := Eachin botones		
			PushMatrix()
				Scale vpx, vpy
				boton.Render()
			PopMatrix()
		Next
		Scale vpx, vpy
		If sgte
			buttonNext.Render()
		Endif
	End
	
	Method LoadingRender:Void()
        Scale vpx, vpy
        logo.Render()
        font92.DrawText("Cargando...", VIEWPORTW / 2, 750, AngelFont.ALIGN_CENTER)
    End 
	
	Method OnClick:Void(button:HudButton)
	
		Select button.GetId()
			Case SALIR_BUTTON
				lpSceneMngr.GetInstance().SetScene(MAINMENU_SCENE)
				Return
		    Case NIVEL1_SCENE
		    	ObjetivoNivel.numNivel = NIVEL1_SCENE 
		    Case NIVEL2_SCENE
		    	ObjetivoNivel.numNivel = NIVEL2_SCENE 
		    Case NIVEL3_SCENE
		    	ObjetivoNivel.numNivel = NIVEL3_SCENE 
		    Case NIVEL4_SCENE
		    	ObjetivoNivel.numNivel = NIVEL4_SCENE 
		    Case NIVEL5_SCENE
		    	ObjetivoNivel.numNivel = NIVEL5_SCENE 
		    Case NIVEL6_SCENE
		    	ObjetivoNivel.numNivel = NIVEL6_SCENE 
		    Case NIVEL7_SCENE
		    	ObjetivoNivel.numNivel = NIVEL7_SCENE 
		    Case NIVEL8_SCENE
		    	ObjetivoNivel.numNivel = NIVEL8_SCENE 
		    Case NIVEL9_SCENE
		    	ObjetivoNivel.numNivel = NIVEL9_SCENE
			Case LEVELMENU2_SCENE
				Memorice.GetInstance().SetScene(LEVELMENU2_SCENE)
				Return
		End Select
        StopMusic
		Memorice.GetInstance().SetScene( OBJETIVO_SCENE )
    End

End 