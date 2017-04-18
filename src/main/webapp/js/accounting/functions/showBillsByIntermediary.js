function showBillsByIntermediary(reload){
	try{
		new Ajax.Request(contextPath+"/GIACInquiryController",{
			parameters: {
				action: "showBillsByIntermediary",
				reload: reload
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showBillsByIntermediary", e);
	}
}