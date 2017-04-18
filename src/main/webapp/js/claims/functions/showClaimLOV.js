function showClaimLOV(){
    var contentDiv = new Element("div", {id : "modal_content_lov2"});
    var contentHTML = '<div id="modal_content_lov2"></div>';
    //var provinceCd = $F("txtProvinceCd") == "" ? 
    overlayClaimLOV = Overlay.show(contentHTML, {
						id: 'modal_dialog_lov2',
						title: objCLM.lovTitle,
						width: 600,
						height: 390,
						draggable: true
						//closable: true
					});
    
    new Ajax.Updater("modal_content_lov2", contextPath+"/GICLClaimsController?action=getBasicInfoPopupListing&lovSelected=" + objCLM.lovSelected + "&polIssCd=" +$F("txtPolIssCd") + "&lineCd=" + $F("txtLineCd") 
    	    																								+ "&provinceCd=" + nvl(objCLM.basicInfo.provinceCode,"") + "&sublineCd=" + $F("txtSublineCd") + "&renewNo=" + $F("txtRenewNo") 
    	    																								+ "&issueYy=" + $F("txtIssueYy") + "&cityCd=" + $F("txtCityCd") + "&districtNo=" + $F("txtDistrictNo") + 
    	    																								"&adjCompanyCd=" + ($("txtAdjCompanyCd") == null ? "" : $F("txtAdjCompanyCd")) + "&claimId=" + nvl(objCLMGlobal.claimId,""), {
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Getting list of values, please wait..."),
		onComplete: function (response) {			
			if (!checkErrorOnResponse(response)) {
				showMessageBox(response.responseText, imgMessage.ERROR);
			} 
		}
	});
}