/**
 * Calls the LOV for GIIS_CURRENCY
 * @author eman 02.09.2011
 * @return
 */
function openSearchGIISCurrencyLOV() {
	Modalbox.show(contextPath+"/GIISCurrencyController?action=openSearchGIISCurrencyLOV", 
				  {title: "Search Currency", 
				  width: 800});	
}