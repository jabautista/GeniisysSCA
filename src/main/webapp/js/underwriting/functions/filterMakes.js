//Filter makes for Item Info.
function filterMakes(paramVal){		
	new Ajax.Updater($("makeCd").up("td", 0), contextPath + "/GIPIQuotationMotorCarController?action=filterMakes", {
		method : "GET",
		parameters : {
			carCompany : $F("carCompany")
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : 
			function(){					
				$("makeCd").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");					
				$("isLoaded").value = 0;									
			},
		onComplete :
			function(){
				$("makeCd").value = paramVal;								
			}
	});			
}