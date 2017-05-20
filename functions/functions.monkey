Import imports

Class Globals

	Public 

	'''genera numeros al azar

	Function RandomNumber:Int(desde:Int, hasta:Int)	
		
		Seed = Millisecs() * 1234
		
		Local random = Int(Rnd()*(hasta-desde) + desde)
		
		Return random
	End
	
	
	''' escribe textos multilineas
	''' text, texto
	''' font, tipo de letra
	''' padding, espacio a los costados
	
	Function DrawMultilineText:Void(text:String, font:AngelFont, padding:Int, align:Int = AngelFont.ALIGN_CENTER, x:Int = VIEWPORTW/2, y:Int = 400)
		
		Local array_text:String[] = text.Split(" ")
		Local cadena:String = ""
		Local width:Int = 0
		Local stack_text:Stack<String>
		Local index:Int = 0
		
		stack_text = New Stack<String>()
		
		For Local palabra := Eachin array_text
		
			width += font.TextWidth(palabra)
			
			cadena = cadena + " " + palabra		
			
			If width <= VIEWPORTW - padding
				If index = array_text.Length() - 1
					stack_text.Push( cadena )
				End
			Else
				stack_text.Push( cadena )
				width = 0
				cadena = ""
			Endif
			
			index += 1		
		Next
		
		For Local linea := Eachin stack_text
			font.DrawText(linea, x, y, align)
			y += font.TextHeight(linea)
		Next
	End
	
	
End 