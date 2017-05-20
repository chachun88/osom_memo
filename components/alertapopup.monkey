Import imports

Class lpAlertaPopup Extends lpPopup Implements iHudButton

	Private
		Const BTN_CLOSE:Int = 0
		
	    Field close:HudButton
	    Field background:lpImage
		Field screenWidth:Float
		Field screenHeight:Float
		Field vpx:Float
		Field vpy:Float
	    Field theTween:lpTween
	    Field soundButton:String
		Field r:Bool = True
		Field descripcion:String = ""
		Field font:AngelFont
	

    ''' constructor that allow to show a centered text
    Method New(width:Float = 640, height:Float = 960, sound:String, fuente:AngelFont, d:String = "")
    	screenWidth = width
    	screenHeight = height
    	soundButton = sound
    	font = fuente
    	descripcion = d
    End

    ''' implement the framework methods
    Method Create:Void()
    
    	close = New HudButton(skin + "close.png", soundButton)
    	background = New lpImage(skin + "fondo_popup_compra.png", New Vector2(0,0))
    	r = True
    	
    	background.Position.X = -background.Position.Width
		background.Position.Y = screenHeight / 2 - background.Position.Height / 2
		
		close.Position.Y = background.Position.Y - close.Position.Height / 4
		close.SetId( BTN_CLOSE )
		close.SetListener(Self)
    	
    	vpx = Float(DeviceWidth())/screenWidth
		vpy = Float(DeviceHeight())/screenHeight
		
		theTween = lpTween.CreateBack(lpTween.EASEOUT, -background.Position.Width, screenWidth / 2 - background.Position.Width / 2, 500)
		
    End
    
    Method Update:Void(delta:Int)     	
        close.Update(delta)
    End

    Method Render:Void()
    
    	If ( r )
    		theTween.Start()
    		r = False
    	End       
        
        theTween.Update()
        
        background.Position.X = theTween.GetCurrentValue()
    	close.Position.X = background.Position.X + background.Position.Width - close.Position.Width + close.Position.Width / 4
        
    	PushMatrix
    	Scale vpx, vpy
    		background.Render()
			close.Render()
			font.DrawMultilineText(descripcion, 300, theTween.GetCurrentValue() + background.Position.Width / 2, 350, screenWidth, AngelFont.ALIGN_CENTER)
		PopMatrix
    End
    
    Method OnClick:Void(button:HudButton)
    	Select button.GetId()
    		Case BTN_CLOSE
		    	lpHidePopup()
		End Select
    End
End