/*	Created by	: Deo [01.26.2017] (SR-23702)
 * 	Description	: delete temp CA grouped item records
 * 	Parameters	: itemNo - itemNo to be deleted
 */
function deleteTempCAGrpItms(itemNo) {
	try {
		if (objFormParameters.paramMenuLineCd == "CA" && objGIPIWGroupedItems != null) {
			var filteredValue = objGIPIWGroupedItems.filter(function(obj) {
				return obj.itemNo == itemNo;
			});

			if (filteredValue.length > 0) {
				var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
				var forSplice = [];

				for (var i = 0; i < objGIPIWGroupedItems.length; i++) {
					if (objGIPIWGroupedItems[i].parId == parId
							&& objGIPIWGroupedItems[i].itemNo == itemNo) {
						forSplice.push(i);
					}
				}

				forSplice = (forSplice.sort()).reverse();

				for (var i = 0; i < forSplice.length; i++) {
					objGIPIWGroupedItems.splice(forSplice[i], 1);
				}
			}
		}
	} catch (e) {
		showErrorMessage("deleteTempCAGrpItms", e);
	}
}