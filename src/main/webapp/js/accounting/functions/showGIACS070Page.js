/** Shows View Journal Entries Page
 ** Module Id:  GIACS070
 ** Created By: Shan
 ** Date Created: 08.22.2013
 **/
function showGIACS070Page(){
	try{
		new Ajax.Request(contextPath+"/GIACInquiryController",{
			parameters: {
				action:			"showViewJournalEntriesPage",
				gfunFundCd:		objACGlobal.hidObjGIACS070.giopGaccFundCd,
				gibrBranchCd:	objACGlobal.hidObjGIACS070.giopGaccBranchCd 	
			},
			onCreate: showNotice("Loading View Journal Entries Page, please wait..."),
			onComplete: function(response){
				hideNotice();
				try{
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						hideAccountingMainMenus();
					}
				}catch(e){
					showErrorMessage("showGIACS070 - onComplete: ", e);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIACS070", e);
	}
}