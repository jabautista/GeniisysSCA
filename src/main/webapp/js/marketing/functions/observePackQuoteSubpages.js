/**
 * Manage showing/hiding of sub-pages for package quotation information
 * @param accordionLbl - label of the accordion
 * @param subPageDiv - the sub-page that will be shown/hidden
 * 
 */

function observePackQuoteSubpages(accordionLbl, subPageDiv){
	$(accordionLbl).innerHTML = $(accordionLbl).innerHTML == "Hide" ? "Show" : "Hide";
	var infoDiv = $(subPageDiv).down("div", 0);
	if(infoDiv != null){
		Effect.toggle(infoDiv, "blind", {duration: .3});
	}
}