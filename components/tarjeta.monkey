Import imports

Class Tarjeta Implements iDrawable

	Private
		Field x:Float
		Field y:Float
		Field width:Float
		Field height:Float
		Field id:Int
		Field background:lpImage
		Field rectangle:lpRectangle
		Field last_hit:Int = 0
		Field clickeable:Bool = True
		Field front_image:lpImage
		Field gris:Bool
		Field popSound:Sound
		Field parSound:Sound
		Field puntaje:Int
		
		Field puntaje_gris:Float = 2000
		Field puntaje_color:Float = 1500
		
		''' scala
		Field totalTime:Int = 50
		Field currentTime:Int = 0
		Field sx:Float
		Field orientacion:Bool = True
		
		Const FACTOR:Float = 4
		
	Public 	
	
		Const HIT_TIME:Int = 10
		Const INITIAL:Int = 1
		Const VOLTEADO:Int = 2
		Const NO_VOLTEADO:Int = 3
		Const VOLTEO_DOBLE:Int = 4
		
		Field state:Int = INITIAL
		Field cant_volteos:Int = 0
	
		Method New( tx:Float, ty:Float, tw:Float, th:Float, id:Int, gris:Bool = False )
			Self.x = tx
			Self.y = ty
			Self.width = tw
			Self.height = th
			Self.id = id
			Self.gris = gris
			popSound = lpLoadSound ( POP )
			parSound = lpLoadSound ( PAR )
			Self.Create()
		End
	
		Method Create:Void()
			rectangle = New lpRectangle()
			background = New lpImage( skin + "carta.png", New Vector2(Self.x,Self.y))
			front_image = New lpImage( skin + "t1.png", New Vector2(Self.x,Self.y))
			
			Select Self.id
				Case 0
					If Self.gris
						background = New lpImage( skin + "carta_g.png", New Vector2(Self.x,Self.y))
						front_image = New lpImage( skin + "t1_g.png", New Vector2(Self.x, Self.y))
						puntaje = puntaje_gris
					Else
						front_image = New lpImage( skin + "t1.png", New Vector2(Self.x,Self.y))
						puntaje = puntaje_color
					End 
				Case 1
					If Self.gris
						background = New lpImage( skin + "carta_g.png", New Vector2(Self.x, Self.y))
						front_image = New lpImage( skin + "t2_g.png", New Vector2(Self.x, Self.y))
						puntaje = puntaje_gris					
					Else
						front_image = New lpImage( skin + "t2.png", New Vector2(Self.x,Self.y))
						puntaje = puntaje_color
					End 
						
				Case 2
					If Self.gris
						background = New lpImage( skin + "carta_g.png", New Vector2(Self.x, Self.y))
						front_image = New lpImage( skin + "t3_g.png", New Vector2(Self.x, Self.y))
						puntaje = puntaje_gris
					Else
						front_image = New lpImage( skin + "t3.png", New Vector2(Self.x,Self.y))
						puntaje = puntaje_color
					End
				Case 3
					If Self.gris
						background = New lpImage( skin + "carta_g.png", New Vector2(Self.x, Self.y))
						front_image = New lpImage( skin + "t4_g.png", New Vector2(Self.x, Self.y))
						puntaje = puntaje_gris
					Else
						front_image = New lpImage( skin + "t4.png", New Vector2(Self.x, Self.y))
						puntaje = puntaje_color
					End
				Case 4
					If Self.gris
						background = New lpImage( skin + "carta_g.png", New Vector2(Self.x, Self.y))
						front_image = New lpImage( skin + "t5_g.png", New Vector2(Self.x, Self.y))
						Local x:Float = (background.Position.X + background.Position.Width / 2) - front_image.Position.Width / 2
						front_image.Position.X = x
						puntaje = puntaje_gris
					Else
						front_image = New lpImage( skin + "t5.png", New Vector2(x, Self.y))
						Local x:Float = (background.Position.X + background.Position.Width / 2) - front_image.Position.Width / 2
						front_image.Position.X = x
						puntaje = puntaje_color
					End
				Case 5
					If Self.gris
						background = New lpImage( skin + "carta_g.png", New Vector2(Self.x, Self.y))
						front_image = New lpImage( skin + "t6_g.png", New Vector2(Self.x, Self.y))
						Local x:Float = (background.Position.X + background.Position.Width / 2) - front_image.Position.Width / 2
						front_image.Position.X = x
						puntaje = puntaje_gris
					Else
						front_image = New lpImage( skin + "t6.png", New Vector2(Self.x, Self.y))
						Local x:Float = (background.Position.X + background.Position.Width / 2) - front_image.Position.Width / 2
						front_image.Position.X = x
						puntaje = puntaje_color
					End

			End Select
			
		End 
		Method Update:Void(delta:Int)
		
			'tiempo transcurrido entre el click de la segunda carta y el tiempo actual
			Local elapse_time = Millisecs() - last_hit
			
			'valido si el tiempo transcurrido es mayor al tiempo de espera para voltear las cartas
			'y si usuario ya volteo la segunda carta
			
			Select state
				Case INITIAL
			
					If totalTime >= currentTime
					
						If orientacion
							sx = 1 - (Float(currentTime) / Float(totalTime))
							currentTime += delta
						Else 
							If currentTime >= 0
								sx = 1 - (Float(currentTime) / Float(totalTime))
								currentTime -= delta
							Else
								currentTime = 0
								state = NO_VOLTEADO 
							End If
						End If
						
					Else
						currentTime = totalTime
						orientacion = False
					End If
				
				Case VOLTEADO
				
					If totalTime >= currentTime
					
						If orientacion
							sx = 1 - (Float(currentTime) / Float(totalTime))
							currentTime += delta
						Else 
							If currentTime >= 0
								sx = 1 - (Float(currentTime) / Float(totalTime))
								currentTime -= delta
							Else
								currentTime = 0
							End If
						End If
								
					Else
						currentTime = totalTime
						orientacion = False
					End If
					
				
					If elapse_time > HIT_TIME And last_hit <> 0
					
						'si la carta actual no coincide con la carta ya volteada
						If Self.id <> Nivel.last_flipped.id
							Self.currentTime = 0
							Self.orientacion = True
							state = VOLTEO_DOBLE

							Nivel.last_flipped.currentTime = 0
							Nivel.last_flipped.orientacion = True
							Nivel.last_flipped.state = VOLTEO_DOBLE
							Nivel.last_flipped = Null
						Else 'si la carta actual coincide con la carta ya volteada
							If soundOn
								PlaySound(parSound, 7, 0)
							Endif
							Nivel.pares_volteados+=1
							currentTime = 0
							Nivel.last_flipped.currentTime = 0
							Nivel.puntaje_obtenido += (Self.puntaje + Nivel.last_flipped.puntaje) * Clamp(FACTOR/(Nivel.tiempo_transcurrido/1000), 1.0, FACTOR)
						End If
						
						Nivel.intentos += 1
						last_hit = 0
					End If 
				
				Case NO_VOLTEADO
					
					If totalTime >= currentTime
					
						If orientacion
							sx = 1 - (Float(currentTime) / Float(totalTime))
							currentTime += delta
						Else 
							If currentTime >= 0
								sx = 1 - (Float(currentTime) / Float(totalTime))
								currentTime -= delta
							Else
								currentTime = 0
							End If
						End If
					End If
					
					If MouseHit() And Self.GetPosition().IsPointInside(MouseX() / vpx, MouseY() / vpy) And Nivel.IsClickAllowed And Self.GetClickeable
					
						If soundOn
							PlaySound(popSound,8,0)
						Endif

						state = VOLTEADO

						currentTime = 0
						totalTime = 100
						orientacion = True
						Nivel.jugada += 1
						
						

						If Nivel.jugada = 2
							Nivel.jugada = 0
							last_hit = Millisecs()
						Else
							Nivel.last_flipped = Self
						End If

						Self.cant_volteos += 1
							
					End If
				Case VOLTEO_DOBLE
				
					If totalTime >= currentTime
					
						If orientacion
							sx = 1 - (Float(currentTime) / Float(totalTime))
							currentTime += delta
						Else 
							If currentTime >= 0
								sx = 1 - (Float(currentTime) / Float(totalTime))
								currentTime -= delta
							Else
								currentTime = 0
								state = NO_VOLTEADO
							End If
						End If
								
					Else
						currentTime = totalTime
						orientacion = False
					End If
			End Select
		End 
		Method Render:Void() 'dibuja objetos sobre la pantalla
		
			PushMatrix 'se guarda matriz de transformacion actual
			
				Select state
					Case INITIAL
				
						Translate( (1 - sx) * x + width / 2, 0)
						Scale(sx, 1.0) ' lo que se dibuje despues de scale va a ser con esa escala
						Translate(-width/2, 0)
						
						If orientacion	
							front_image.Render()				
						Else
							background.Render()
						End If 
					
					Case VOLTEADO
						
						Translate( (1 - sx) * x + width / 2, 0)
						Scale(sx, 1.0) ' lo que se dibuje despues de scale va a ser con esa escala
						Translate(-width/2, 0)
						
						If orientacion	
							background.Render()
						Else
							front_image.Render()
						End If
						
						'front_image.Render()					
						'SetColor 255,255,255
						'font.DrawText("" + Self.GetId(), Self.GetX(),Self.GetY())
					
					Case NO_VOLTEADO
						If Not clickeable
							SetAlpha(0.5)
						Endif
						Translate( (1 - sx) * x + width / 2, 0)
						Scale(sx, 1.0) ' lo que se dibuje despues de scale va a ser con esa escala
						Translate(-width/2, 0)
						
						If orientacion	
							front_image.Render()
						Else
							background.Render()
						End If
						'background.Render()
					Case VOLTEO_DOBLE
						Translate( (1 - sx) * x + width / 2, 0)
						Scale(sx, 1.0) ' lo que se dibuje despues de scale va a ser con esa escala
						Translate(-width/2, 0)
						
						If orientacion	
							front_image.Render()
						Else
							background.Render()
						End If
				End Select
				SetAlpha(1)
			PopMatrix 'para recuperar la matriz que se guardo
			
		End 
		Method GetX:Int()
			Return Self.x
		End
		Method GetY:Int()
			Return Self.y
		End
		
		Method GetPosition:lpRectangle()
			rectangle.X = Self.x
			rectangle.Y = Self.y
			rectangle.Width = Self.width
			rectangle.Height = Self.height
			Return rectangle
		End 
		
		Method SetClickeable:Void(clickeable:Bool)
			Self.clickeable = clickeable
		End
		
		Method GetClickeable:Bool()
			Return Self.clickeable
		End
End 