//added by irwin. This version prevents the modal box from closing when the user clicked outside the modal box.
function openSearchClientModal2() {
	Modalbox.show(contextPath+"/GIISAssuredController?action=openSearchClientModal&ajaxModal=1", 
				  {title: "Search Assured Name", 
				  width: 800,
				  overlayClose: false,
				  asynchronous:false});	
}