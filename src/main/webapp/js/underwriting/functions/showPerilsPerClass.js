function showPerilsPerClass(callingForm, assdNo, assdName){ // Nica 05.25.2012 - added parameter callingForm, assdNo, assdName
	updateMainContentsDiv("/GIISPerilsPerPerilClassController?action=getPerilsPerClass&ajax=1", "Loading peril class table, please wait...");
}