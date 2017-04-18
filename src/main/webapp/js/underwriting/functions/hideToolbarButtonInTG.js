/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	12.13.2011	mark jm			hides the refresh and filter button in table grid if no records 
 */
function hideToolbarButtonInTG(tbg){
	try{		
		if((tbg != null || tbg != undefined) && $$("#mtgBT"+ tbg._mtgId + " .mtgRow" + tbg._mtgId).filter(function(o){ return o.getStyle("display") != "none"; }).length < 1){
			$("mtgFilterBtn" + tbg._mtgId).hide();
			$("mtgRefreshBtn" + tbg._mtgId).hide();
		}
	}catch(e){
		showErrorMessage("hideToolbarButtonInTG", e);
	}
}