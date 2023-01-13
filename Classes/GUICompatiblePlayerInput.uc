//=============================================================================
// GUICompatiblePlayerInput
//
// $wotgreal_dt: 11.09.2012 19:36:02$
//
// Captures mouse movement and translates them to cursor location for the Canvas.
//
// Modified by Luke Scovel (AKA Flameis) for use in Rising Storm 2: Vietnam
//=============================================================================
class GUICompatiblePlayerInput extends ROPlayerInput within GUICompatiblePlayerController
    config(Input);

var IntPoint 		CurPos;

event PlayerInput(float DeltaTime)
{
    local GUIMenuScene ActiveMenuScene;
    // local GameViewportClient Viewport;

    ActiveMenuScene = GetActiveMenuScene();

    // Handle mouse
    // Ensure we have a valid HUD
    if (ActiveMenuScene != None && ActiveMenuScene.bCaptureMouseInput)
    {
        ActiveMenuScene.MousePos.X = CurPos.X;
        ActiveMenuScene.MousePos.Y = CurPos.Y;
    }

    Super.PlayerInput(DeltaTime);
}

/**
 * Process an input key event routed through unrealscript from another object. This method is assigned as the value for the
 * OnRecievedNativeInputKey delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this input key event
 * @param   Key             the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param   EventType       the type of event which occured (pressed, released, etc.)
 * @param   AmountDepressed for analog keys, the depression percent.
 *
 * @return  true to consume the key event, false to pass it on.
 */
function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
{
    local GUIMenuScene ActiveMenuScene;

    ActiveMenuScene = GetActiveMenuScene();

    // Handle mouse events separately and redirect them to the Menu Scene.
    if (ActiveMenuScene != None && ActiveMenuScene.bCaptureMouseInput)
    {
        if (Key == 'LeftMouseButton')
        {
            HandleMouseInput(LeftMouseButton, Event);
            return True;
        }

        if (Key == 'RightMouseButton')
        {
            HandleMouseInput(RightMouseButton, Event);
            return True;
        }

        if (Key == 'MiddleMouseButton')
        {
            HandleMouseInput(MiddleMouseButton, Event);
            return True;
        }

        if (Key == 'MouseScrollUp')
        {
            HandleMouseInput(ScrollWheelUp, IE_Pressed);
            return True;
        }

        if (Key == 'MouseScrollDown')
        {
            HandleMouseInput(ScrollWheelDown, IE_Pressed);
            return True;
        }
    }

    if (ActiveMenuScene != None)
    {
        return  ActiveMenuScene.InputKey(ControllerId,Key,Event,AmountDepressed,bGamepad);
    }

    return false;
}

/**
 * Process a character input event (typing) routed through unrealscript from another object. This method is assigned as the value for the
 * OnRecievedNativeInputKey delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this character input event
 * @param   Unicode         the character that was typed
 *
 * @return  True to consume the character, false to pass it on.
 */
function bool InputChar( int ControllerId, string Unicode )
{
    local bool bConsume;

    local GUIMenuScene ActiveMenuScene;

    ActiveMenuScene = GetActiveMenuScene();

    if (ActiveMenuScene != None)
    {
        if (ActiveMenuScene.ClickedSelection != none)
        {
            if (ActiveMenuScene.ClickedSelection.bReceiveText)
                bConsume = ActiveMenuScene.ClickedSelection.InputChar(ControllerId,Unicode);
        }
    }

    return bConsume;
}

/**
 * Process an input axis event routed through unrealscript from another object. This method is assigned as the value for the
 * OnRecievedNativeInputAxis delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this input axis event
 * @param   Key             the name of the axis which an event occured for (MouseX, MouseY, etc.)
 * @param   Delta           the amount of change in the axis
 * @param   DeltaTime       the time since the last axis event
 *
 * @return  true to consume the axis event, false to pass it on.
 */
function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
{
    if (GetActiveMenuScene().bCaptureMouseInput)
    {
	    // if they moved the Mouse on the X Axis
	    if ( Key == 'MouseX' )
	    {
	    	if (CurPos.X+Delta < GetActiveMenuScene().GetScreenSizeX() && CurPos.X+Delta > 0)
	    	    CurPos.X += Delta;
	    	return true;
	    }
	    // If they moved the Mouse on the Y Axis
	    else if ( Key == 'MouseY' )
	    {
	    	if (CurPos.Y-Delta < GetActiveMenuScene().GetScreenSizeY() && CurPos.Y-Delta > 0)
	    	    CurPos.Y -= Delta;
	    	return true;
	    }
    }
	return false;
}

defaultproperties
{
    OnReceivedNativeInputKey=InputKey
    OnReceivedNativeInputChar=InputChar
    OnReceivedNativeInputAxis=InputAxis
}