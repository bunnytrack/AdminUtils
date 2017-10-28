//=============================================================================
// AdminUtilsMutator.
//=============================================================================
class AdminUtilsMutator expands Mutator;

function PreBeginPlay() {
	Level.Game.BaseMutator.AddMutator(self);
}

simulated event PostBeginPlay() {

	Super.PostBeginPlay();

	Log("");
	Log("+--------------------------------------------------------------------------+");
	Log("| AdminUtilsMutator                                                        |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Author:      >@tack!<                                                    |");
	Log("| Description: Provides useful functionality to server admins:             |");
	Log("|              mutate TriggerMover -> Aim your crosshair at a mover and    |");
	Log("|                                     this command will trigger the mover  |");
	Log("| Version:     2017-10-28                                                  |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Released under the Creative Commons Attribution-NonCommercial-ShareAlike |");
	Log("| license. See https://creativecommons.org/licenses/by-nc-sa/4.0/          |");
	Log("+--------------------------------------------------------------------------+");

}

// Process mutate commands
function Mutate(string MutateString, PlayerPawn Sender){
	local String action, par1;

	if(Sender.bAdmin){

		Scan(MutateString,action,par1);

		if(action ~= "TriggerMover"){
			TriggerMover(Sender);
		}
	}
	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
}

function TriggerMover(PlayerPawn Sender){
	local Actor HitActor;
	local vector X,Y,Z, HitLocation, HitNormal, EndTrace, StartTrace;
	local Mover HitMover;

	GetAxes(Sender.ViewRotation,X,Y,Z);

	StartTrace = Sender.Location + Sender.EyeHeight * vect(0,0,1);
	EndTrace = StartTrace + X * 10000;

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, false);
	HitMover = Mover(HitActor);

	if(HitMover != none){

		if(HitMover.InitialState == 'BumpOpenTimed'){
			HitMover.HandleDoor(Sender);
		} else if(HitMover.InitialState == 'StandOpenTimed'){
			HitMover.Attach(Sender);
		} else{
			HitMover.Trigger(Sender, Sender);
		}

	}
}

// Scans a string and splits the string in an action and 2 parameters
function Scan (String mString, out String action, out string par1){
	local String temp1;
	if(InStr(mString," ") != -1){
		action = Left(mString,InStr(mString," "));
		par1 = Right(mString,Len(mString)-InStr(mString," ")-1);
	}
	else
		action = mString;
}

defaultproperties
{
}
