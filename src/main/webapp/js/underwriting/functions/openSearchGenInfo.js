/**
 * Call modal page for General Info in GIPIS002 - Basic Information
 * @author Jerome Orio 01.10.2011
 * @version 1.0
 * @param 
 * @return
 */
function openSearchGenInfo(){
	Modalbox.show(contextPath+"/GIISGeninInfoController?action=openSearchGenInfo&ajaxModal=1",  
			  {title: "Search General Information.", 
			  width: 900,
			  asynchronous: false});
}