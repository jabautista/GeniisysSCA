/**
 * Shows simple modal searchbox for intermediary
 * @author eman
 * @return
 */
function openSearchIntermediary() {
	Modalbox.show(contextPath+"/GIISIntermediaryController?action=openSearchIntermediary", 
			  {title: "Search Intermediary", 
			  width: 700,
			  asynchronous: false});	
}