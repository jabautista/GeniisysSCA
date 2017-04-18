//mrobes 01.22.10 shows deductible page per level
/* LEVEL
 *  1 = Policy Deductible
 *  2 = Item Deductible
 *  3 = Peril Deductible
 * */
function showDeductibleModal(level, callbackFunc){
	var dedDesc;
	if(1 == level) {
		dedDesc = "Policy Deductible";
	} else if (2 == level) {
		dedDesc = "Item Deductible";
	} else if (3 == level) {
		dedDesc = "Peril Deductible";
	}
	try {
		new Ajax.Updater("deductibleDiv"+level, contextPath+"/GIPIWDeductibleController", {
			method: "GET",
			asynchronous: false,//change asynchronous to false by steven 1/31/2013, This way the function waits for the request to be complete
			evalScripts: true,
			parameters: {globalParId:      (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
						 globalLineCd: 	   (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")),
						 globalSublineCd:  (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")),
						 action:		  "showDeductiblePage",
						 dedLevel: 		  level},
			onCreate: function () {
				setCursor("wait");
				//showNotice("Getting " + dedDesc + ", Please wait...");
				//showSubPageLoading("showDeductible"+level, true);
			},
			onComplete: function(response){
				//showSubPageLoading("showDeductible"+level, false);
				setCursor("default");	
				//hideNotice();			
				if(checkErrorOnResponse(response)){							
					if ((objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "E" && level == 3){
						if ($("perilCd") != null){
							toggleEndtPerilDeductibles($F("itemNo"), $F("perilCd"));
						}
					} else {		
						toggleDeductibles(level, ($("itemNo") == null ? 0 : $F("itemNo")), ($("perilCd") == null ? 0 : $F("perilCd")));	
					}
					if(callbackFunc != null && callbackFunc != ""){		
						window.setTimeout(callbackFunc, 500);
					}
					//setDeductibleListing(objDeductibleListing, level);
				}	
			}
		});
	} catch (e){
		showErrorMessage("showDeductibleModal", e);
	}
}