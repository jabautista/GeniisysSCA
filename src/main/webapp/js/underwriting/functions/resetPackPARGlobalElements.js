function resetPackPARGlobalElements(){
	try{
		var element = document.getElementById("globalPackParId");
		if(element != null) {
			$("globalParStatus").value = "0";
			$("globalPackParId").value = "0";
			$("globalPackPolFlag").value = "0";
		}
	}catch(e){
		showErrorMessage("resetPackPARGlobalElements",e);
	}
}