function createAnotherHistory(){
	showConfirmBox("Copy Settlement History", "Do you want to copy an existing history?", "Yes", "No", 
			function(){getViewHistoryListing("Y");}, function(){changeTag=0;});
}