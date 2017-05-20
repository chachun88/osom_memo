Import imports

Class Credits Extends lpScene Implements iHudButton
	Field img:lpImage
	Field c:String
	
	Global popupSalir:lpSalirPopup
	Const SALIR_BUTTON:Int = 3
	Field btnSalir:HudButton

	Method Create:Void()
	
		img = New lpImage(skin + "fondo.png", New Vector2(0,0))	
		btnSalir = New HudButton(skin + "btnSalir.png", HUDBUTTON_SOUND)
		
		btnSalir.SetId(SALIR_BUTTON)
		btnSalir.SetListener(Self)
		btnSalir.Position.X = 40
		btnSalir.Position.Y = VIEWPORTH - 90
		
		popupSalir = New lpSalirPopup(HUDBUTTON_SOUND, font62, "¿Estás segur@ que desea salir?")
		popupSalir.SetBackgroundAlpha(0.2)
		
	End
	
	Method Update:Void(delta:int)
		
		If (KeyHit(KEY_ESCAPE))
			lpSceneMngr.GetInstance().SetScene(MAINMENU_SCENE)
		End
	
		btnSalir.Update(delta)
	
	End
	
	Method Render:Void()
	
		PushMatrix()
			Scale vpx, vpy
			img.Render()
			btnSalir.Render()
			font.DrawText("Créditos", VIEWPORTW / 2, 50, AngelFont.ALIGN_CENTER)
			font.DrawText("Producción", VIEWPORTW / 2, 170, AngelFont.ALIGN_CENTER)
			font.DrawText("Yi Chun Lin", VIEWPORTW / 2, 240, AngelFont.ALIGN_CENTER)
			font.DrawText("Programación", VIEWPORTW / 2, 340, AngelFont.ALIGN_CENTER)
			font.DrawText("Yi Chun Lin", VIEWPORTW / 2, 410, AngelFont.ALIGN_CENTER)
			font.DrawText("Estefany Campos", VIEWPORTW / 2, 480, AngelFont.ALIGN_CENTER)
			font.DrawText("Diseño", VIEWPORTW / 2, 580, AngelFont.ALIGN_CENTER)
			font.DrawText("Muriel Cáceres", VIEWPORTW / 2, 650, AngelFont.ALIGN_CENTER)
			font.DrawText("Agradecimientos", VIEWPORTW / 2, 750, AngelFont.ALIGN_CENTER)
			font.DrawText("Kiltro", VIEWPORTW / 2, 820, AngelFont.ALIGN_CENTER)
		PopMatrix()
		
		
	End
	
	Method OnClick:Void(button:HudButton)
	
		Select button.GetId()
			Case SALIR_BUTTON
				lpSceneMngr.GetInstance().SetScene(AJUSTES_SCENE)
		End Select
	End

End
