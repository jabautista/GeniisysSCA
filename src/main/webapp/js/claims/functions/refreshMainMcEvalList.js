function refreshMainMcEvalList(){
	try{
		mcEvalGrid._refreshList();
		populateEvalSumFields(null);
		populateOtherDetailsFields(null);
		toggleEditableOtherDetails(false);
		toggleButtons(null);
		enableButton("btnAddReport");
		selectedMcEvalObj = null;
		$("editMode").value = "";
		hasSaved = "";
		changeTag = 0;
	}catch(e){
		showErrorMessage("refreshMainMcEvalList",e);
	}
	
}