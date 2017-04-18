/**
 * Shows simple modal searchbox for reinsurer
 * @author eman
 * @return
 */
function openSearchReinsurer() {
	Modalbox.show(contextPath+"/GIISReinsurerController?action=openSearchReinsurer", 
			  {title: "Search Reinsurer", 
			  width: 700,
			  asynchronous: false});	
}