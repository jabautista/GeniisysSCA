function searchPreviousRiModal(page){
	new Ajax.Updater('searchResult','GIRIWFrpsRiController?action=searchPreviousRiModal&page='+page, {
		parameters:{	
			distNo: objUW.hidObjGIRIS001.viewJSON.distNo
		},	
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showLoading('searchResult', 'Getting list, please wait...', "120px");
		}	
	});
}