/**
 * Shows the Show/Hide Labels on the accordion headers
 * @author rencela
 * @return
 */
function showAccordionLabelsOnQuotationMain(){
	$$("label.accordionLabel").each(function(lab){
		lab.show();
	});
}