Import imports

Class LoseScene Extends lpScene Implements iHudButton


	Field background:lpImage
	Field margen:Int = 30
	Field retry:HudButton
	Const RETRY_BUTTON:Int = 1
	
	Method Create:Void()
	
		'Print "puntaje final: " + Nivel.puntaje_obtenido
		background = New lpImage(skin + "fondo_lose.png", New Vector2(0, 0))
		
		'Method New( resource:String, font:AngelFont, text:String, snd:String = "", left_padding:Int = 0 , top_padding:Int = 0 )
		
		retry = New HudButton(skin + "boton.png", font92, "Reintentar", HUDBUTTON_SOUND, -50, -15)
		retry.SetId(RETRY_BUTTON)
		retry.SetListener(Self)
		retry.Position.X = 45
		retry.Position.Y = 780
		retry.SetMuted(Not soundOn)

		If (0 = ChannelState( 8 ) Or -1 = ChannelState( 8 ))
			If musicOn
				SetMusicVolume( 1.0 )
				PlayMusic( FAILSOUND, 0 )
			Endif
		End If
		Super.Create()
	End
	Method Update:Void(delta:Int)
		If MouseHit() And Not retry.Position.IsPointInside(MouseX()/vpx,MouseY()/vpy)
	    	Skip()
		Endif
		If (KeyHit( KEY_ESCAPE ))
			Skip()
		End
		
		retry.Update(delta)
	End
	Method LoadingRender:Void()
		Cls 255,255,255
	End
	Method Render:Void()
		Scale vpx, vpy
		background.Render()
		retry.Render()
	End
	
	Method OnClick:Void(boton:HudButton)
		Select boton.GetId()
		Case RETRY_BUTTON
			Memorice.GetInstance().SetScene( OBJETIVO_SCENE )
		End Select
	End
	
	Method Skip:Void()
		If ObjetivoNivel.numNivel >= NIVEL1_SCENE And ObjetivoNivel.numNivel <= NIVEL9_SCENE
			lpSceneMngr.GetInstance().SetScene(LEVELMENU_SCENE)
		Else If ObjetivoNivel.numNivel >= NIVEL10_SCENE And ObjetivoNivel.numNivel <= NIVEL18_SCENE
			lpSceneMngr.GetInstance().SetScene(LEVELMENU2_SCENE)
		Else If ObjetivoNivel.numNivel >= NIVEL19_SCENE And ObjetivoNivel.numNivel <= NIVEL27_SCENE
			lpSceneMngr.GetInstance().SetScene(LEVELMENU3_SCENE)
		End If
	End

End 