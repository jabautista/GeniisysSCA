/*
 * Created By	: andrew robes
 * Date			: November 5, 2010
 * Description	: Shows the item number selection which will be used in adding and deleting of items
 * Parameters	: choice - whether 1 (add) or 2 (delete)
 * 				  itemListingId - id of div containing the records
 * 				  itemRowName - name of row
 * 				  pObjPolbasics - array of policy being endorsed
 */
function showItemSelection(choice, itemListingId, itemRowName, pObjPolbasics) {
	try {
		var itemNoArray = new Array();
		if (choice == 1) {
			// This loop is used to get the item numbers of the previous policy/endorsement						
			/*for (var i=0; i<pObjPolbasics.length; i++){
				for(var j=0; j<pObjPolbasics[i].gipiItems.length; j++){
					if($$("div#"+itemListingId+" div[name='"+itemRowName+"']").size() > 0){
						var exist = false;
						$$("div#"+itemListingId+" div[name='"+itemRowName+"']").each(function(row){
							if(pObjPolbasics[i].gipiItems[j].itemNo == row.down("label", 0).innerHTML.trim()){
								exist = true;
							}
						});
	
						if (!exist) {
							itemNoArray.push(pObjPolbasics[i].gipiItems[j].itemNo);
						}						
					} else {
						itemNoArray.push(pObjPolbasics[i].gipiItems[j].itemNo);
					}
				}
			}*/  //comment out by marco - 04.11.2014
			
			//marco - 04.11.2014 - to consider backward endorsements when retrieving list of item nos.
			new Ajax.Request(contextPath + "/GIPIWItemController",{
				parameters : {
					action: "getEndtItemList",
					lineCd: objGIPIWPolbas.lineCd,
					sublineCd: objGIPIWPolbas.sublineCd,
					issCd: objGIPIWPolbas.issCd,
					issueYy: objGIPIWPolbas.issueYy,
					polSeqNo: objGIPIWPolbas.polSeqNo,
					renewNo: objGIPIWPolbas.renewNo,
					effDate: nvl(objGIPIWPolbas.formattedEffDate, $F("globalEffDate").substr(0, 10)) //Apollo - 5.20.2014
					//effDate: nvl(objGIPIWPolbas.formattedEffDate, objParPolbas.formattedEffDate)
					
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var itemList = eval(response.responseText);
						for (var i = 0; i < itemList.length; i++){
							if($$("div#"+itemListingId+" div[name='"+itemRowName+"']").size() > 0){
								var exist = false;
								$$("div#"+itemListingId+" div[name='"+itemRowName+"']").each(function(row){
									if(itemList[i] == row.down("label", 0).innerHTML.trim()){
										exist = true;
									}
								});
			
								if (!exist) {
									itemNoArray.push(itemList[i]);
								}						
							} else {
								itemNoArray.push(itemList[i]);
							}
						}
					}
				}
			});
	
			if (itemNoArray.length == 0) {
				showMessageBox("All item(s) for this policy is already inserted.");
				return;
			} 
		} else if (choice == 2) {
			//Delete item
			$$("div#"+itemListingId+" div[name='"+itemRowName+"']").each(function(row){
				itemNoArray.push(row.down("label", 0).innerHTML.trim());					
			});
			
			if (itemNoArray.length == 0) {
				showMessageBox("There are no items inserted for this PAR.", imgMessage.INFO);
				return;
			}
		}	
		
		itemNoArray.sort();
		overlayAddDeleteItem = Overlay.show(contextPath+"/GIPIWItemController", {
												urlContent : true,
												title: "Delete/Add All Items", 
												urlParameters : {
													action : "showEndtAddDeleteItem",
													globalParId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
													itemNos : itemNoArray,
													choice : choice
												},
												width : 302,
												height : 300,
												draggable : true 
											});
		//showOverlayContent2(contextPath+"/GIPIWItemController?action=showEndtAddDeleteItem&globalParId="+(objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"))+"&itemNos="+itemNoArray+"&choice="+choice, "Delete/Add All Items", 415, "");
	} catch (e) {
		showErrorMessage("showItemSelection", e);
	}
}