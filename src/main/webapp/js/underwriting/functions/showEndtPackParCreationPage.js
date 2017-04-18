function showEndtPackParCreationPage(lineCd){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPackPARListController?action=showEndtPackParCreationPage&lineCd="+nvl(lineCd, ""),{
		method:"GET",
		evalScripts: true,
		asynchronous: true,
		onCreate:function(){ 
			showNotice("Getting Endorsement Package Par Creation page, please wait... ");
		},
		onComplete: function(){
			hideNotice("");
			setDocumentTitle("Endorsement Package PAR Creation");
		}
	});
}