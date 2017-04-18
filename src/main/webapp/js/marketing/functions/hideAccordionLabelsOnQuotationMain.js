/**
 * Shows the Show/Hide Labels on the accordion headers
 * @author rencela
 * @return
 */
function hideAccordionLabelsOnQuotationMain(){
	$$("label.accordionLabel").each(function(lab){
		lab.hide();
	});
}