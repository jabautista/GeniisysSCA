/**
 * Validate booking date in GIPIS017
 * @author Jerome Orio 01.24.2011
 * @version 1.0
 * @param 
 * @return
 */
function validateBookingDate(){
	try{
		var ok = true;
		new Ajax.Request(contextPath+"/GIPIParBondInformationController", {
			method: "GET",
			parameters: {action: 	  	"validateBookingDate",
						 parId:		  	$F("globalParId"),
						 bookingYear: 	$F("bookingYear"),
						 bookingMth:	$F("bookingMth"),
						 issueDate: 	$F("issueDate"),
						 doi:	  		$F("doi")  
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var text = response.responseText;
				if (checkErrorOnResponse(response)){
					if (text != "SUCCESS"){
						showMessageBox(text, imgMessage.ERROR);
						ok = false;
					}	
				}else{
					showMessageBox(text, imgMessage.ERROR);
					ok = false;
				}	
			}
		});		 
		return ok;
	}catch(e){
		showErrorMessage("validateBookingDate",e);
	}	
}