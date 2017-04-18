//nok 02.08.2011 move this function from index.jsp
function continueLogout() {	
	new Ajax.Request(contextPath+"/GIISUserController?action=logout", {
		asynchronous: false,
		evalScripts: true,
		onComplete: function ()	{
			window.location.reload();		
		}
	});
}