class MutGUI extends ROMutator
    config(MutGUI_Server);

function PreBeginPlay()
{
    super.PreBeginPlay();

    ROGameInfo(WorldInfo.Game).PlayerControllerClass = class'GUICompatiblePlayerController';
    ROGameInfo(WorldInfo.Game).HUDType = class'GUIExampleHUD';
}