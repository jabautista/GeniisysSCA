/**
 * Call modal page for Endt Text in GIPIS031 - Endt Basic Information
 * @author Grace 05.06.2011
 * @version 1.0
 * @param 
 * @return
 */
function openSearchEndtText(){
	Modalbox.show(contextPath+"/GIISEndtTextController?action=openSearchEndtText&ajaxModal=1",  
			  {title: "Search Endorsement Text", 
			  width: 900,
			  asynchronous: false});
}