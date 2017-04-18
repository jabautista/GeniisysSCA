function checkAssuredExistGiiss006b(){
	try{
		popObjTempAssured();
		new Ajax.Request(contextPath+"/GIISAssuredController?action=checkAssuredExistGiiss006b",{
			method: "POST",
			parameters: {
				assdName: objTempAssured.assdName,
				lastName: objTempAssured.lastName,
				firstName: objTempAssured.firstName,
				middleInitial: objTempAssured.middleInitial,
				mailAddr1: objTempAssured.mailAddress1,
				mailAddr2: objTempAssured.mailAddress2,
				mailAddr3: objTempAssured.mailAddress3,
				assdNo: objTempAssured.assdNo
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				if (checkErrorOnResponse(response)){
					if(response.responseText == "Y"){
						showMessageBox("This assured with the same mailing address already exists.", "I");
					}
				} 
			}
		});
	}catch(e){
		showErrorMessage("checkAssuredExistGiiss006b",e);
	}
}