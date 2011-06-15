package be.arnordhaenens.mvc.view
{
	/**
	 * Imports
	 **/
	import be.arnordhaenens.events.ApplicationEvent;
	import be.arnordhaenens.events.CameraEvent;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.media.Camera;
	import flash.net.URLRequest;
	
	import org.osmf.events.DisplayObjectEvent;
	

	/**
	 * Class	iDrawView
	 * @author	D'Haenens Arnor
	 * @see		flash.display.Sprite
	 **/
	public class iDrawView extends Sprite
	{
		/**
		 * Variables
		 **/
		private var _background:BackgrouncCork;
		private var _drawingbord:DrawingBordMC;
		private var _postit:PostItMC;
		
		private var _pencil:PencilMC;
		private var _eraser:EraserMC;
		
		private var _closebtn:CloseMC;
		private var _clearbtn:ClearButton;
		private var _savebtn:SaveMC;
		
		private var _squareCursor:SquareMC;
		private var _circleCursor:CircleMC;
		
		private var _cursorOptions:CursorOptionsMC;
		
		private var _shapeContainerOriginalHeight:int;
		
		private var _colorBitmapValue:BitmapData;
		private var _pixelColorValue:uint;
		private var _colorActive:uint;
		private var _colorTransform:ColorTransform;
		
		private var _drawing:Shape;
		private var _eraserShape:Shape;
		
		private var _shapeScaling:Number;
		private var _addBitmapDataSupport:Boolean;
		private var _cameraSupport:Boolean;
		
		private var _currentShape:String;
		
		/**
		 * Constructor
		 **/
		public function iDrawView(cameraSupport:Boolean, addBitmapDataSupport:Boolean)
		{
			//check if camera is supported
			this._cameraSupport = cameraSupport;
			
			//check if adding bitmap data to the camera roll is supported
			this._addBitmapDataSupport = addBitmapDataSupport;
			
			//inherit
			super();
			
			/**
			 * Add the event listener added to stage
			 * Then we know that the stage is fully created
			 **/
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//
		////////////////////////////////
		//	PUBLIC FUNCTIONS
		////////////////////////////////
		//
		/**
		 * Handle image chosen
		 **/
		public function handleImageChosen(url:String):void
		{
			_postit.imageContainer.source = url;
		}
		
		/**
		 * Handle screenshot saved
		 **/
		public function handleScreenshotSaved():void
		{
			//go to the first frame
			_savebtn.gotoAndStop(1);
			
			//add event listener to the movieclip
			_savebtn.addEventListener(MouseEvent.CLICK, handleSaveClick);
		}
		
		//
		////////////////////////////////
		//	INITIALIZER
		////////////////////////////////
		//
		/**
		 * Initializer
		 **/
		private function init(evt:Event=null):void
		{
			/**
			 * Creating the interface
			 * 
			 * 1.	Create the background
			 * 2.	Create the drawing bord
			 * 3.	Create the postit
			 * 4.	Create the CameraButton
			 **/
			createBackground();
			createDrawingBord();
			createPostIt();
			createInterface();
			
			/**
			 * Setting the basics for the color
			 **/
			_colorActive = 0x000000;
			_colorTransform = new ColorTransform();
		}
		
		
		//
		////////////////////////////////
		//	PRIVATE FUNCTIONS
		////////////////////////////////
		//
		/**
		 * Creating the background for the application
		 **/
		private function createBackground():void
		{
			//creating a new loader
			_background = new BackgrouncCork();
			
			//scale the background
			_background.scaleX = _background.scaleY = (this.stage.fullScreenWidth) / (_background.height);
			
			//add the background to the current view
			addChild(_background);
		}
		
		/**
		 * Creating the drawing bord
		 **/
		private function createDrawingBord():void
		{
			//create new instance of the mc
			_drawingbord = new DrawingBordMC();
			_drawingbord.blendMode = BlendMode.DARKEN;
			
			//set the bounds
			_drawingbord.width = (this.stage.fullScreenHeight * .68);
			_drawingbord.height = (this.stage.fullScreenWidth - 40);
			
			//set the position
			_drawingbord.x = (this.stage.fullScreenHeight - _drawingbord.width) - 20;
			_drawingbord.y = 20;
			
			//add drawingbord to the current view
			addChild(_drawingbord);
		}
		
		/**
		 * Creating the postit
		 **/
		private function createPostIt():void
		{
			//create new instance
			_postit = new PostItMC();
			
			//set the bounds
			_postit.scaleX = _postit.scaleY = (this.stage.fullScreenHeight * .3) / (_postit.width);
			
			if(this._cameraSupport)
			{
				//add event listener to the camera button
				_postit.btnCamera.addEventListener(MouseEvent.CLICK, handleCameraButtonClicked);
			}			
			
			//add to the current view
			addChild(_postit);
		}
		
		/**
		 * Creating the interface
		 * 
		 * Create the pencil icon
		 * Create the eraser icon
		 * Create the colors
		 **/
		private function createInterface():void
		{
			/**
			 * Creating new pencil object
			 **/
			_pencil = new PencilMC();											//create new instance pencil
			_pencil.scaleX = _pencil.scaleY = .5;								//adjust the size
			_pencil.x = 20;														//set the position 
			_pencil.y = (_postit.y + _postit.height) + 40;
			_pencil.gotoAndStop(5);												//goto the 'up' frame
			_pencil.addEventListener(MouseEvent.CLICK, handlePencilClick);		//add event listener to pencil
			addChild(_pencil);													//add to the current view
			
			/**
			 * Adding event listeners to the drawing bord
			 **/
			_drawingbord.addEventListener(MouseEvent.MOUSE_DOWN, handleStartDrawing);
			
			/**
			 * Creating new eraser object
			 **/
			_eraser = new EraserMC();											//create new instance eraser
			_eraser.scaleX = _eraser.scaleY = .5;								//adjust the size
			_eraser.x = _pencil.x + _pencil.width + 20;							//set the position
			_eraser.y = (_postit.y + _postit.height) + 40;
			_eraser.gotoAndStop(1);												//goto 'disabled' frame
			_eraser.addEventListener(MouseEvent.CLICK, handleEraserClick);		//add event listener
			addChild(_eraser);													//add to the current view
			
			/**
			 * Creating the cirlce cursor
			 **/
			_circleCursor = new CircleMC();												//create new instance of the circle cursor
			_circleCursor.scaleX = _circleCursor.scaleY = .3;							//scale the instance
			_circleCursor.x = _eraser.x + _eraser.width + 20;							//set the position
			_circleCursor.y = _eraser.y + _eraser.height - _circleCursor.height;	
			_circleCursor.gotoAndStop(5);												//go to the 'disabled' frame
			_currentShape = "circle";
			_circleCursor.addEventListener(MouseEvent.CLICK, handleCircleCursorClick);	//add event listener
			addChild(_circleCursor);													//add child to the current view
			
			/**
			 * Creating the square cursor
			 **/
			_squareCursor = new SquareMC();												//create new square cursor
			_squareCursor.scaleX = _squareCursor.scaleY = .3;							//scale the instance
			_squareCursor.x = _circleCursor.x + _circleCursor.width + 20;				//set the position
			_squareCursor.y = _circleCursor.y;	
			_squareCursor.gotoAndStop(1);												//go to the 'up' frame
			_squareCursor.addEventListener(MouseEvent.CLICK, handleSquareCursorClick);	//add event listener
			addChild(_squareCursor);													//add to the current view
			
			
			
			/**
			 * Creating the cursor options
			 **/
			_cursorOptions = new CursorOptionsMC();														//create a new instance
			_shapeScaling = _cursorOptions.scaleX = _cursorOptions.scaleY = 
				((this.stage.fullScreenHeight * .3)-40) / (_cursorOptions.width);						//scale the options
			_shapeContainerOriginalHeight = _cursorOptions.shapecontainer.height;						//store the original height
			_cursorOptions.x = 20;																		//set the position
			_cursorOptions.y = _circleCursor.y + _circleCursor.height + 30;				
			_cursorOptions.colors.addEventListener(MouseEvent.CLICK, handleColorsClick);				//add event listener to the colors movieclip
			_cursorOptions.shapecontainer.addEventListener(MouseEvent.CLICK, handleShapeSize); 			//add event listener to the shape container
			_cursorOptions.shapecontainer.shape.addEventListener(MouseEvent.CLICK, handleShapeSize);	//add event listener to the shape movieclip
			_cursorOptions.shapecontainer.shape.width += (_cursorOptions.shapecontainer.height) * .1;	//set the initial shape size
			_cursorOptions.shapecontainer.shape.height = _cursorOptions.shapecontainer.shape.width;		
			addChild(_cursorOptions);																	//add child to the current view
			
			/**
			 * Colors handling
			 **/
			_colorBitmapValue = new BitmapData(_cursorOptions.colors.width, _cursorOptions.colors.height);
			_colorBitmapValue.draw(_cursorOptions.colors);
			
			/**
			 * Creating close button
			 **/
			/*_closebtn = new CloseMC();
			_closebtn.width = _closebtn.height = _pencil.width;
			_closebtn.x = (this.stage.fullScreenHeight) - (_closebtn.width);
			_closebtn.y = 0;
			_closebtn.gotoAndStop(1);
			_closebtn.addEventListener(MouseEvent.CLICK, handleCloseClick);
			addChild(_closebtn);*/
			
			/**
			 * Creating clear button
			 **/
			_clearbtn = new ClearButton();																//create new instance
			_clearbtn.width = _pencil.width / 2;														//setting the width
			_clearbtn.height = _clearbtn.width;															//setting the height
			_clearbtn.x = 20;																			//setting the x-position
			_clearbtn.y = (this.stage.fullScreenWidth) - (_clearbtn.height) - 20;						//setting the y-position
			_clearbtn.addEventListener(MouseEvent.CLICK, handleClearClick);								//adding event listener
			addChild(_clearbtn);																		//add child to the current view
			
			//check if adding bitmap data to the cameraroll is supported
			if(this._addBitmapDataSupport)
			{
				/**
				 * Creating save button
				 **/
				_savebtn = new SaveMC();																//creating new instance
				_savebtn.width = _eraser.width / 2;														//setting the proportions
				_savebtn.height = _savebtn.width;
				_savebtn.x = _eraser.x;																	//setting the position
				_savebtn.y = (this.stage.fullScreenWidth) - (_savebtn.height) - 20;
				_savebtn.gotoAndStop(1);																//setting the current frame
				_savebtn.addEventListener(MouseEvent.CLICK, handleSaveClick);							//add event listener to the save button
				addChild(_savebtn);																		//add child to the current view
			}
		}

		//
		////////////////////////////////
		//	PRIVATE EVENT HANDLERS
		////////////////////////////////
		//
		/**
		 * Handle camera button clicked
		 * 
		 * Dispatch event CameraEvent.SHOW_INTERFACE
		 * @see be.arnordhaenens.events.CameraEvent
		 * @see flash.events.Event
		 **/
		private function handleCameraButtonClicked(evt:MouseEvent):void
		{
			dispatchEvent(new CameraEvent(CameraEvent.SHOW_INTERFACE));
		}
		
		/**
		 * Handle pencil click
		 * 
		 * 
		 **/
		private function handlePencilClick(evt:MouseEvent):void
		{
			if(evt.target.parent.currentFrame == 1)
			{
				_pencil.gotoAndStop(5);
				_eraser.gotoAndStop(1);
				
				//remove the event listener of the eraser
				//add the event listener for drawing
				_drawingbord.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartErasing);
				_drawingbord.addEventListener(MouseEvent.MOUSE_DOWN, handleStartDrawing);
			}
		}
		
		/**
		 * Handle eraser click
		 **/
		private function handleEraserClick(evt:MouseEvent):void
		{
			if(evt.target.parent.currentFrame == 1)
			{
				_eraser.gotoAndStop(5);
				_pencil.gotoAndStop(1);
				
				//remove the event listener for drawing
				//add event listener for erasing
				_drawingbord.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartDrawing);
				_drawingbord.addEventListener(MouseEvent.MOUSE_DOWN, handleStartErasing);
			}
		}
		
		/**
		 * Handle square cursor click
		 **/
		private function handleSquareCursorClick(evt:MouseEvent):void
		{
			if(evt.target.parent.currentFrame == 1)
			{
				_squareCursor.gotoAndStop(5);
				_circleCursor.gotoAndStop(1);
				
				_currentShape = "square";
			}
		}
		
		/**
		 * Handle circle cursor click
		 **/
		private function handleCircleCursorClick(evt:MouseEvent):void
		{
			if(evt.target.parent.currentFrame == 1)
			{
				_circleCursor.gotoAndStop(5);
				_squareCursor.gotoAndStop(1);
				
				_currentShape = "circle";
			}
		}
		
		/**
		 * Handle colors clicked
		 **/
		private function handleColorsClick(evt:MouseEvent):void
		{
			//kleur ophalen
			//parent.mouseX want je klikt op een enkel kleur
			//positie van de parent ophalen
			_pixelColorValue = _colorBitmapValue.getPixel(evt.target.parent.mouseX, evt.target.parent.mouseY);
			
			//trace the color value
			MonsterDebugger.trace(this, _pixelColorValue);
			
			//actieve kleur aanpassen
			_colorActive = _pixelColorValue;
			
			//kleur van de shape aanpassen
			_colorTransform.color = _colorActive;
			_cursorOptions.shapecontainer.shape.transform.colorTransform = _colorTransform;
		}
		
		/**
		 * Handle shape size
		 **/
		private function handleShapeSize(evt:MouseEvent):void
		{
			//calculate the new height
			var _newHeight:int = _cursorOptions.shapecontainer.shape.height + (_cursorOptions.shapecontainer.height) * .1;
			
			if(_newHeight >= _shapeContainerOriginalHeight)
			{
				_cursorOptions.shapecontainer.shape.width = _cursorOptions.shapecontainer.shape.height = (_cursorOptions.shapecontainer.height) * .1;
			}
			else
			{
				_cursorOptions.shapecontainer.shape.width += (_cursorOptions.shapecontainer.height) * .1;
				_cursorOptions.shapecontainer.shape.height = _cursorOptions.shapecontainer.shape.width;
			}
		}
		
		/**
		 * Handle start drawing
		 **/
		private function handleStartDrawing(evt:MouseEvent):void
		{
			//adding event listeners
			_drawingbord.addEventListener(MouseEvent.MOUSE_MOVE, handlePencilMoving);
			_drawingbord.addEventListener(MouseEvent.MOUSE_OUT, handleStopDrawing);
			_drawingbord.addEventListener(MouseEvent.MOUSE_UP, handleStopDrawing);
			
			//creating a new shape
			_drawing = new Shape();
			_drawingbord.addChild(_drawing);
			
			//setting the properties
			if(_currentShape == "circle")
			{
				_drawing.graphics.moveTo(evt.localX, evt.localY);
				_drawing.graphics.lineStyle((_cursorOptions.shapecontainer.shape.width)*(_shapeScaling / 1.8), _colorActive);
			}
			else if(_currentShape == "square")
			{
				_drawing.graphics.moveTo(evt.localX, evt.localY);
				_drawing.graphics.beginFill(_colorActive, 1);
				_drawing.graphics.drawRect(evt.localX, evt.localY, (_cursorOptions.shapecontainer.shape.width)*(_shapeScaling / 1.8), (_cursorOptions.shapecontainer.shape.width)*(_shapeScaling / 1.8));
			}
		}
		
		/**
		 * Handle the moving of the finger or the mouse
		 **/
		private function handlePencilMoving(evt:MouseEvent):void
		{
			//draw line to the new point
			
			
			if(_currentShape == "circle")
				_drawing.graphics.lineTo(evt.localX, evt.localY);
			else if(_currentShape == "square")
			{
				_drawing.graphics.beginFill(_colorActive, 1);
				_drawing.graphics.drawRect(evt.localX, evt.localY, (_cursorOptions.shapecontainer.shape.width)*(_shapeScaling / 1.8), (_cursorOptions.shapecontainer.shape.width)*(_shapeScaling / 1.8));
			}			
		}
		
		/**
		 * Stop drawing
		 * when user exits the bord
		 * or when user lifts its finger up or releases the key
		 **/
		private function handleStopDrawing(evt:MouseEvent):void
		{
			_drawing.graphics.endFill();
			//remove the event listeners
			_drawingbord.removeEventListener(MouseEvent.MOUSE_MOVE, handlePencilMoving);
			_drawingbord.removeEventListener(MouseEvent.MOUSE_OUT, handleStopDrawing);
			_drawingbord.removeEventListener(MouseEvent.MOUSE_UP, handleStopDrawing);
		}
		
		/**
		 * Handle Start erasing
		 **/
		private function handleStartErasing(evt:MouseEvent):void
		{
			//adding event listeners
			_drawingbord.addEventListener(MouseEvent.MOUSE_MOVE, handleEraserMoving);
			_drawingbord.addEventListener(MouseEvent.MOUSE_OUT, handleStopErasing);
			_drawingbord.addEventListener(MouseEvent.MOUSE_UP, handleStopErasing);
			
			//creating new erasing shape
			_eraserShape = new Shape();
			_drawingbord.addChild(_eraserShape);
			
			_eraserShape.graphics.moveTo(evt.localX, evt.localY);
			_eraserShape.graphics.lineStyle((_cursorOptions.shapecontainer.shape.width)*(_shapeScaling / 1.8), 0xffffff);
		}
		
		/**
		 * Handle Eraser moving
		 **/
		private function handleEraserMoving(evt:MouseEvent):void
		{
			_eraserShape.graphics.lineTo(evt.localX, evt.localY);
		}
		
		/**
		 * Handle stop erasing
		 **/
		private function handleStopErasing(evt:MouseEvent):void
		{
			//remove the event listeners
			_drawingbord.removeEventListener(MouseEvent.MOUSE_MOVE, handleEraserMoving);
			_drawingbord.removeEventListener(MouseEvent.MOUSE_OUT, handleStopErasing);
			_drawingbord.removeEventListener(MouseEvent.MOUSE_UP, handleStopErasing);
		}
		
		/**
		 * Handle close button click
		 **/
		private function handleCloseClick(evt:MouseEvent):void
		{
			_closebtn.currentFram = 5;
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE));
		}
		
		/**
		 * Handle Clear click
		 **/
		private function handleClearClick(evt:MouseEvent):void
		{
			for(var i:int=_drawingbord.numChildren;i>1;i--)
			{
				//not 0, else the background itself will be deleted
				_drawingbord.removeChildAt(1);
			}
		}
		
		/**
		 * Handle save button click
		 **/
		private function handleSaveClick(evt:MouseEvent):void
		{			
			//dispatch event
			dispatchEvent(new CameraEvent(CameraEvent.SAVE));
			
			//goto the right frame
			_savebtn.gotoAndStop(5);
			
			//remove the event listener
			//so that the user can't press a second time
			_savebtn.removeEventListener(MouseEvent.CLICK, handleSaveClick);
		}
	}
}