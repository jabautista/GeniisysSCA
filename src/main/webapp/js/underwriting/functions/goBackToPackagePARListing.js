function goBackToPackagePARListing(){
	try{
		if(objUWGlobal.parType == "E"){
			showEndtPackParListing(objUWGlobal.issCd == "RI" ? "Y" : "");
		}else{
			showPackParListing(objUWGlobal.issCd == "RI" ? "Y" : "");
		}
	}catch(e){
		showErrorMessage("goBackToPackagePARListing", e);
	}
}