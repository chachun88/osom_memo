Import imports

Class LevelMenu3 Extends LevelMenu

	Field buttonPrev:HudButton

	Method Create:Void()
		Super.Create()
		
		Self.sgte = False
		done = False
		
		buttonPrev = New HudButton(skin + "left_arrow.png")
		buttonPrev.SetMuted(Not soundOn)
		buttonPrev.Position.X = margen_x - buttonPrev.Position.Width / 2
		buttonPrev.Position.Y = VIEWPORTH - buttonPrev.Position.Height - margen_y
		buttonPrev.SetId(LEVELMENU2_SCENE)
		buttonPrev.SetListener(Self)
		
		Self.CrearNiveles(NIVEL19_SCENE)
	End
	
	Method Update:Void(delta:Int)
		If sincronizado And Not done 
			Self.CrearNiveles(NIVEL19_SCENE)
			done = Not done
		Endif
		Super.Update(delta)
		
		buttonPrev.Update(delta)
	End
	
	Method Render:Void()
		Super.Render()
		buttonPrev.Render()
	End
	
	Method LoadingRender:Void()
        Cls 255,255,255
    End 
	
	Method OnClick:Void(button:HudButton)

		    Select button.GetId()
		    Case SALIR_BUTTON
				lpSceneMngr.GetInstance().SetScene(MAINMENU_SCENE)
				Return
		    Case NIVEL19_SCENE
		    	ObjetivoNivel.numNivel = NIVEL19_SCENE
		    Case NIVEL20_SCENE
		    	ObjetivoNivel.numNivel = NIVEL20_SCENE
		    Case NIVEL21_SCENE
		    	ObjetivoNivel.numNivel = NIVEL21_SCENE
		    Case NIVEL22_SCENE
		    	ObjetivoNivel.numNivel = NIVEL22_SCENE
		    Case NIVEL23_SCENE
		    	ObjetivoNivel.numNivel = NIVEL23_SCENE
		    Case NIVEL24_SCENE
		    	ObjetivoNivel.numNivel = NIVEL24_SCENE
		    Case NIVEL25_SCENE
		    	ObjetivoNivel.numNivel = NIVEL25_SCENE
		    Case NIVEL26_SCENE
		    	ObjetivoNivel.numNivel = NIVEL26_SCENE
		    Case NIVEL27_SCENE
		    	ObjetivoNivel.numNivel = NIVEL27_SCENE
		    Case LEVELMENU2_SCENE
				Memorice.GetInstance().SetScene(LEVELMENU2_SCENE) 
				Return
	        End Select
	        
	        Memorice.GetInstance().SetScene(OBJETIVO_SCENE)
'		EndIf	
	End
End
