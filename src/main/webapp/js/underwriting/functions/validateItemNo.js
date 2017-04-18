function validateItemNo(itemNo){
	
	if($("row" + itemNo) != undefined){
		customShowMessageBox("Item Number must be unique.", imgMessage.ERROR, "itemNo");
		return false;
	} 
	
	new Ajax.Request(contextPath+"/GIPIWItemController", {
		method: "POST",
		parameters:{
			action : "validateItemNo",
			packParId : objUWGlobal.packParId,
			itemNo : itemNo,
			lineCd : objUWGlobal.lineCd,
			issCd  : objGIPIWPolbas.issCd,
			sublineCd : objGIPIWPolbas.sublineCd,
			issueYy  : objGIPIWPolbas.issueYy,
			polSeqNo : objGIPIWPolbas.polSeqNo,
			renewNo  : objGIPIWPolbas.renewNo,
			effDate  : objGIPIWPolbas.effDate,
			expiryDate : objGIPIWPolbas.expiryDate
		},
		onCreate: function(){
			setCursor("wait");
		},
		onComplete: function(response){
			setCursor("default");
			if(checkErrorOnResponse(response)){
				jsonObject = new Object();
				jsonObject = JSON.parse(response.responseText);
				
				if(jsonObject.msgAlert == "EXISTING"){
					addExistingPolicyItems(jsonObject);
					$("recFlag").value = "C";
				}else if(jsonObject.msgAlert == "NEW"){
					if(($$("div#packageParPolicyTable .selectedRow")).length < 1){
						showMessageBox("Please select PAR first.", imgMessage.ERROR);
					}
				}else{
					showMessageBox(unescapeHTML2(jsonObject.msgAlert), imgMessage.ERROR);
					setMainItemForm(null);
				}
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}