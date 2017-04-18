function changeAssured(){
	function revertAssured(){
		$("assuredNo").value = objUW.GIPIS031.gipiParList.assdNo;
		$("assuredName").value = objUW.GIPIS031.gipiParList.assdName;
	}
	showConfirmBox("Confirmation", "Change of Assured will automatically recreate invoice and delete corresponding data on group information both ITEM and GROUP level. Do you wish to continue?",
			"Yes", "No", "", revertAssured);
}