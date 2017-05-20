Import imports

Class LevelMenu2 Extends LevelMenu

	Field buttonPrev:HudButton
		
	Method Create:Void()
		Super.Create()
		
		sgte = True
		done = False
		
		buttonPrev = New HudButton(skin + "left_arrow.png")
		buttonPrev.SetMuted(Not soundOn)
		buttonPrev.Position.X = margen_x - buttonPrev.Position.Width / 2
		buttonPrev.Position.Y = VIEWPORTH - buttonPrev.Position.Height - margen_y
		buttonPrev.SetId(LEVELMENU_SCENE)
		buttonPrev.SetListener(Self)
		
		buttonNext.SetId(LEVELMENU3_SCENE)
		
		
		Self.CrearNiveles(NIVEL10_SCENE)
	End
	
	Method Update:Void(delta:Int)
		If sincronizado And Not done 
			Self.CrearNiveles(NIVEL10_SCENE)
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
		    Case NIVEL10_SCENE
		    	ObjetivoNivel.numNivel = NIVEL10_SCENE
		    Case NIVEL11_SCENE
		    	ObjetivoNivel.numNivel = NIVEL11_SCENE
		    Case NIVEL12_SCENE
		    	ObjetivoNivel.numNivel = NIVEL12_SCENE
		    Case NIVEL13_SCENE
		    	ObjetivoNivel.numNivel = NIVEL13_SCENE
		    Case NIVEL14_SCENE
		    	ObjetivoNivel.numNivel = NIVEL14_SCENE
		    Case NIVEL15_SCENE
		    	ObjetivoNivel.numNivel = NIVEL15_SCENE
		    Case NIVEL16_SCENE
		    	ObjetivoNivel.numNivel = NIVEL16_SCENE
		    Case NIVEL17_SCENE
		    	ObjetivoNivel.numNivel = NIVEL17_SCENE
		    Case NIVEL18_SCENE
		    	ObjetivoNivel.numNivel = NIVEL18_SCENE
		    Case LEVELMENU_SCENE
				Memorice.GetInstance().SetScene(LEVELMENU_SCENE) 
				Return
			Case LEVELMENU3_SCENE
				Memorice.GetInstance().SetScene(LEVELMENU3_SCENE)
				Return
		End Select
	        
	    Memorice.GetInstance().SetScene(OBJETIVO_SCENE)
	End
End
