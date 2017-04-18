/**
 * Shows simple modal searchbox for intermediary for giis_banc_type_dtl
 * @author eman 12.21.2010
 * @return
 */
function openSearchBancaIntermediary() {
	Modalbox.show(contextPath+"/GIISIntermediaryController?action=openSearchBancaIntermediary", 
			  {title: "Search Intermediary", 
			  width: 700,
			  asynchronous: false});	
}