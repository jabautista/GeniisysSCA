function showAbout(){
	ovlAboutGeniisys = Overlay.show(contextPath+"/GIISController", {
		urlContent : true,
		urlParameters: {action : "showAboutGeniisys"},
	    title: "About Geniisys",
	    height: 300,
	    width: 600,
	    draggable: true
	});
}