/**
 * Call ajax result modal page for Bank reference number in GIPIS002, GIPIS017
 * @author Jerome Orio 01.11.2011
 * @version 1.0
 * @param modalPageNo - page no. of record
 * 		  keyword	  - keyword about to search
 * @return
 */
function searchBankRefNoModal(modalPageNo, keyword){
	var isPack = (objUWGlobal.packParId == null || $F("globalPackParId") == "") ? 'N' : 'Y'; // added by Nica for package Par Basic Info
	
	new Ajax.Updater('searchResult','GIPIParInformationController?action=searchBankRefNoModal&pageNo='+modalPageNo+'&keyword='+keyword+'&parId='+$F("globalParId")+'&nbtAcctIssCd='+$F("nbtAcctIssCd")+'&nbtBranchCd='+$F("nbtBranchCd")+'&isPack='+isPack, {
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showLoading('searchResult', 'Getting list, please wait...', "120px");
		}	
	});
}