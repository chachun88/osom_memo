Import imports


Class lpLoginButton Extends HudButton

	Method New( resource:String, font:AngelFont, text:String, snd:String = "", left_padding:Int = 0 , top_padding:Int = 0 )
		Super.New ( resource, font, text, snd, left_padding, top_padding )
	End

End


Class Ajustes Extends lpScene Implements iHudButton

	Const MUTED_SOUND:Int = 1
	Const MUTED_MUSIC:Int = 2
	Const LISTO_BUTTON:Int = 3
	Const CREDITS_BUTTON:Int = 4
	Const BACKUP_BUTTON:Int = 5

	Field buttonSonido:ToggleButton
	Field buttonMusic:ToggleButton
	Field buttonListo:HudButton
	Field buttonBackup:HudButton
	Field background:lpImage
	Field creditsButton:HudButton
	
	Field backup_done:Bool = False

	Global popup:lpAlertaPopup
	
	Method New()
	
		#If TARGET="html5"
		If Not PRODUCCION Config.Init()
		#End
	
		#If TARGET="android"
        If isOnline() And facebook.IsOpened() And Not sincronizado
        	reqFinished = False
	        Config.Request()
		Endif
    	#End
    End
	
	Method Create:Void()
	
		background = New lpImage(skin + "fondo.png", New Vector2(0,0))
		
		popup = New lpAlertaPopup(VIEWPORTW, VIEWPORTH, HUDBUTTON_SOUND, font62, "No tienes conexión a internet. Por favor intenta más tarde.")
		popup.SetBackgroundAlpha(0.2)
	
		buttonSonido = New ToggleButton(skin + "on.png", skin + "off.png", HUDBUTTON_SOUND)
		buttonSonido.SetEnable(userData.GetItem("soundOn"))
		buttonSonido.SetId(MUTED_SOUND)
		buttonSonido.Position.X = 330
		buttonSonido.Position.Y = 290
		buttonSonido.SetListener(Self)
		buttonSonido.SetMuted(Not soundOn)
		
		buttonMusic = New ToggleButton(skin + "on.png", skin + "off.png", HUDBUTTON_SOUND)
		buttonMusic.SetEnable(userData.GetItem("musicOn"))
		buttonMusic.SetId(MUTED_MUSIC)
		buttonMusic.Position.X = 330
		buttonMusic.Position.Y = 170
		buttonMusic.SetListener(Self)
		buttonMusic.SetMuted(Not soundOn)
		
		buttonListo = New HudButton(skin + "boton.png", font72, "Listo", HUDBUTTON_SOUND, -50, -5)
		buttonListo.SetId(LISTO_BUTTON)
		buttonListo.Position.X = VIEWPORTW / 2 - buttonListo.Position.Width / 2
		buttonListo.Position.Y = 730
		buttonListo.SetListener(Self)
		buttonListo.SetMuted(Not soundOn)
		
		buttonBackup = New HudButton(skin + "boton.png", font72, "Backup", HUDBUTTON_SOUND, -50, -5)
		buttonBackup.SetId(BACKUP_BUTTON)
		buttonBackup.Position.X = VIEWPORTW / 2 - buttonListo.Position.Width / 2
		buttonBackup.Position.Y = 570
		buttonBackup.SetListener(Self)
		buttonBackup.SetMuted(Not soundOn)

		creditsButton = New HudButton(skin + "boton.png", font72, "Créditos", HUDBUTTON_SOUND, -50, -15)
		creditsButton.SetTopPadding(-7)
		creditsButton.SetId(CREDITS_BUTTON)
		creditsButton.SetListener(Self)
		creditsButton.Position.X = VIEWPORTW / 2 - creditsButton.Position.Width / 2
		creditsButton.Position.Y = 410
		creditsButton.SetMuted(Not soundOn)	
	End
	
	Method Update:Void(delta:Int)
		buttonSonido.Update(delta)
		buttonMusic.Update(delta)
		buttonListo.Update(delta)
		creditsButton.Update(delta)
		buttonBackup.Update(delta)
		
		If (KeyHit( KEY_ESCAPE ))
			lpSceneMngr.GetInstance().SetScene(MAINMENU_SCENE)
		End
		
		UpdateAsyncEvents

	End
	
	Method Render:Void()
		PushMatrix
			Scale vpx, vpy
			background.Render()
			font72.DrawText("Ajustes", VIEWPORTW/2 , 30, AngelFont.ALIGN_CENTER)
			font72.DrawText("Música", 80, 170, AngelFont.ALIGN_LEFT)
			font72.DrawText("Sonido", 80, 290, AngelFont.ALIGN_LEFT)
			buttonSonido.Render()
			buttonMusic.Render()
			buttonListo.Render()
			creditsButton.Render()
			'buttonBackup.Render()
		PopMatrix
	End

	Method OnClick:Void(button:HudButton)
	
		Select button.GetId()
			Case MUTED_SOUND
				soundOn = Not soundOn
				userData.AddPrim("soundOn",soundOn)
			Case MUTED_MUSIC
				musicOn = Not musicOn
				userData.AddPrim("musicOn",musicOn)
			Case LISTO_BUTTON
				If Not musicOn
					StopMusic
				Endif
				SaveState(userData.ToJSONString())
				Config.BackUp()
				Memorice.GetInstance().SetScene(MAINMENU_SCENE)	
			Case CREDITS_BUTTON
				Memorice.GetInstance().SetScene(CREDITS_SCENE)	
			Case BACKUP_BUTTON
				#If TARGET="android"
				If(isOnline())
					'''http request
			        If ( facebook.IsOpened() )
			        	Config.BackUp()  
			    	Endif
				Else
					lpShowPopup(popup)
				    popup.Create()
				Endif
				#End
		End Select		
	End
End
