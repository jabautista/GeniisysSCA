function loadDirectPremCollnsForm(reload) {
	// new Ajax.Updater("transBasicInfoSubpage", contextPath +
	// "/GIACDirectPremCollnsController?action=loadDirectPremForm&" +
	// Form.serialize("itemInformationForm") ,{ robert 9.3.2012
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACDirectPremCollnsController?action=loadDirectPremForm2&"
					+ Form.serialize("itemInformationForm"),
			{
				method : "POST",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					if (reload == null) {
						showNotice("Loading Direct Premium Collections Information. Please wait... </br> "
								+ contextPath);
					}
				},
				onComplete : function() {
					hideNotice("");
					setORParams();
					disableButton("btnAdd");
					disableButton("btnPolicy");
					disableButton("btnDelete");
				}
			});
}