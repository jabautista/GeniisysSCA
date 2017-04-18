/**
 * Retrieve Marine Hull JSON LOV 
 * @author rencela
 * @return
 */
function getMarineHulls(aiItemNo){
	new Ajax.Request(contextPath + "/GIPIQuotationMarineHullController?action=getMarineHulls",{
		evalScripts:	true,
		asynchronous:	true,
		onCreate: function(){
			$("marineHullAdditionalInformationForm" + aiItemNo).disable();
		},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				$("marineHullAdditionalInformationForm" + aiItemNo).enable();
				marineVessels = (response.responseText).evalJSON();
			}
			enableQuotationMainButtons();
			showAccordionLabelsOnQuotationMain();
		}
	});
}