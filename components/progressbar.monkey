Import imports

Class ProgressBar
	
	Field x:Float, y:Float
	
	Field m1:Bool = True, m2:Bool = True, m3:Bool = True
	
	Field b1:Bool = False, b2:Bool = False, b3:Bool = False
	
	Field width:Float, height:Float
	
	Field meta1:Float, meta2:Float, meta3:Float
	
	Field drawProgress:Float
	
	Field oldProgress:Float
	
	Field elapsed_time:Float
	
	Field stopped:Bool = False
	
	Field metaSound:Sound
	
	Field patas:lpImage[]
	
	Field theTween:lpTween[]
	
Private
	Field value:Float
	
	Method New(x:Float, y:Float, width:Float, height:Float)
		Self.x = x; Self.y = y
		Self.width = width; Self.height = height
		value = 1
		metaSound = lpLoadSound(METASOUND)		
	End Method
	
	Method Draw:Void()
	
	
		If ( b1 )
			theTween[0].Start()
    		b1 = False
    	End

    	If ( b2 )
			theTween[1].Start()
    		b2 = False
    	End
    	
    	If ( b3 )
			theTween[2].Start()
    		b3 = False
    	End

		For Local tw:= Eachin theTween
    		tw.Update()
    	Next
    	
	
		SetColor(234, 241, 216)
		DrawRect(x, y, width, height)
		
		SetColor(135,181,173)
		'dibuja el progreso anterior
		DrawRect(x, y, oldProgress, height)
		
		'dibuja el progreso actual con la animacion
		DrawRect(x + oldProgress, y, drawProgress, height)
		
		SetColor(147,131,120)
		DrawRect(x, y, width, 5)
		DrawRect(x, y, 5, height)
		DrawRect(x, y + height, width, 5)
		DrawRect(x + width - 5, y, 5, height)
		
		
		'dibuja linea de meta 1
		DrawRect(x + width * (meta1 / meta3), y, 5, height)
		
		'dibuja linea de meta 2
		DrawRect(x + width * (meta2 / meta3), y, 5, height)
		
		SetColor(255, 255, 255)
		
		For Local s:= EachIn patas
           	s.Render()
        Next
	End Method
	
	Method Value:Void(value:Float) Property
		If (value > 1) value = 1
		If (value < 0) value = 0
		If Self.value <> value
			stopped = False
		Endif
		Self.value = value
	End Method
	
	Method SetMetas(m1:Float, m2:Float, m3:Float)
		meta1 = m1
		meta2 = m2
		meta3 = m3
		
		patas =[	New lpImage(skin + "pata.png", New Vector2(0, 0)),
		            New lpImage(skin + "pata.png", New Vector2(0, 0)),
	    	        New lpImage(skin + "pata.png", New Vector2(0, 0)) ]
		
		patas[0].Position.X = -patas[0].Position.Width
		patas[1].Position.X = -patas[1].Position.Width
		patas[2].Position.X = -patas[2].Position.Width
		
		patas[0].Position.Y = y-10-patas[0].Position.Height
		patas[1].Position.Y = patas[0].Position.Y
		patas[2].Position.Y = patas[0].Position.Y
		
		theTween =[	lpTween.CreateBack(lpTween.EASEOUT, -patas[0].Position.Width, (x + width * (meta1 / meta3)) - patas[0].Position.Width / 2, 500),
		            lpTween.CreateBack(lpTween.EASEOUT, -patas[1].Position.Width, (x + width * (meta2 / meta3)) - patas[0].Position.Width / 2, 500),
	    	        lpTween.CreateBack(lpTween.EASEOUT, -patas[2].Position.Width, (x + width) - patas[0].Position.Width / 2, 500) ]
		
	End
	
	Method Update:Void(delta:Int)
	
		elapsed_time = Clamp(elapsed_time, 0.0, 600.0)
		
		For Local i:Int = 0 Until theTween.Length Step 1
			If theTween[i].IsRunning()
				patas[i].Position.X = theTween[i].GetCurrentValue()
			Endif
		Next
		
		If Not stopped
		
			If oldProgress + drawProgress >= width * (meta1/meta3) And m1
				If soundOn PlaySound(metaSound, 6, 0)
				m1 = False
				b1 = True
			Else If oldProgress + drawProgress >= width * (meta2/meta3) And m2
				If soundOn PlaySound(metaSound, 6, 0)
				m2 = False
				b2 = True
			Else If oldProgress + drawProgress >= width And m3
				If soundOn PlaySound(metaSound, 6, 0)
				m3 = False
				b3 = True
			Endif
		
			If elapsed_time <= 600
				drawProgress = (width * value - oldProgress) * (elapsed_time/600) 
				elapsed_time += delta
			Else
				stopped = True
				elapsed_time = 0
				oldProgress += drawProgress
				drawProgress = 0
			Endif
		Endif
	End

End Class