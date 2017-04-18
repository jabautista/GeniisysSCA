/*	Created by	: Deo [01.26.2017] (SR-23702)
 * 	Description	: Fill-up group item list
 *  Parameter   : itemNos - item no/s to be retrieved
 */
function supplyCAGrpItms(itemNos) {
	try {
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController", {
			parameters : {
				action : "getCAGroupedItems",
				parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
				itemNo : itemNos,
				lineCd : objParPolbas.lineCd,
				sublineCd : objParPolbas.sublineCd,
				issCd : objParPolbas.issCd,
				issueYy : objParPolbas.issueYy,
				polSeqNo : objParPolbas.polSeqNo,
				renewNo : objParPolbas.renewNo,
				effDate : dateFormat($F("globalEffDate"), "mm-dd-yyyy")
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					var objRes = JSON.parse(response.responseText);
					if (objRes.rows.length > 0) {
						for (var i = 0; i < objRes.rows.length; i++) {
							if (!inGrpItmsObj(objRes.rows[i])) {
								addNewJSONObject(objGIPIWGroupedItems, objRes.rows[i]);
							}
						}
						fireEvent($("caEndtItmNo"), "click");
					}
				}
			}
		});

		function inGrpItmsObj(objRes) {
			var exist = false;
			if (objGIPIWGroupedItems != null) {
				for (var i = 0; i < objGIPIWGroupedItems.length; i++) {
					if (objRes.parId == objGIPIWGroupedItems[i].parId
							&& objRes.itemNo == objGIPIWGroupedItems[i].itemNo
							&& objRes.groupedItemNo == objGIPIWGroupedItems[i].groupedItemNo) {
						exist = true;
						break;
					}
				}
			}
			return exist;
		}
	} catch (e) {
		showMessageBox("supplyCAGrpItms : " + e.message);
	}
}