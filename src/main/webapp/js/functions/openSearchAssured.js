/**
 * Shows simple modal searchbox for assured
 * @author eman
 * @return
 */
function openSearchAssured() {
	Modalbox.show(contextPath+"/GIISAssuredController?action=openSearchAssured&ajaxModal=1", 
				  {title: "Search Assured Name", 
				  width: 800});	
}