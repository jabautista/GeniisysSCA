/**
 * Call ajax result modal page for Endt Text in GIPI031 - Endt Basic Information
 * @author Grace 05.06.2011
 * @version 1.0
 * @param modalPageNo - page no. of record
 * 		  keyword	  - keyword about to search
 * @return
 */
function searchEndtTextModal(modalPageNo, keyword){
	new Ajax.Updater('searchResult','GIISEndtTextController?action=searchEndtTextModal&pageNo='+modalPageNo+'&keyword='+encodeURIComponent(keyword), {
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showLoading('searchResult', 'Getting list, please wait...', "120px");
		}	
	});
}