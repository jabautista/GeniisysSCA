/**
 * Call ajax result modal page for General Info in GIPIS002 - Basic Information
 * @author Jerome Orio 01.10.2011
 * @version 1.0
 * @param modalPageNo - page no. of record
 * 		  keyword	  - keyword about to search
 * @return
 */
function searchGenInfoModal(modalPageNo, keyword){
	new Ajax.Updater('searchResult','GIISGeninInfoController?action=searchGenInfoModal&pageNo='+modalPageNo+'&keyword='+keyword, {
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showLoading('searchResult', 'Getting list, please wait...', "120px");
		}	
	});
}