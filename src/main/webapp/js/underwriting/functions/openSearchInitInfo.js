/**
 * Call modal page for Initial Info in GIPIS002 - Basic Information
 * @author Jerome Orio 01.10.2011
 * @version 1.0
 * @param 
 * @return
 */
function openSearchInitInfo(){
	Modalbox.show(contextPath+"/GIISGeninInfoController?action=openSearchInitInfo&ajaxModal=1",  
			  {title: "Search Initial Information.", 
			  width: 900,
			  asynchronous: false});
}