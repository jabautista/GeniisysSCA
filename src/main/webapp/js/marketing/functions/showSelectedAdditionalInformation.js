/** 
 * Displays the Information related to the currently selected item
 * - executed when selecting an item
 * @author rencela
 */
function showSelectedAdditionalInformation() {
	var selectedItemNo = getSelectedRowId("row");
	if (!selectedItemNo.blank()) {
		$$("div[name='additionalInformationDiv']").each(function(additionalInfoRow){
				var rowItemNo = additionalInfoRow.down("input", 0).value;
				if (selectedItemNo == rowItemNo) {
					additionalInfoRow.show();
				} else {
					additionalInfoRow.hide();
				}
		});

		$("mortgageeInformationMotherDiv").show();
		$("attachedMediaMotherDiv").show();

		$("attachedMediaTopDiv" + selectedItemNo).show();

		$("mortgageeInformationDiv").show();
		var oneFound = false;
		var ctr = 0;
		$$("div[name='rowMortg']").each(function(mortgRow) { // show mortgRows having same itemNo
			mortgRow.hide();
			ctr++;
			var c2 = 0;
			mortgRow.childElements().each(function(kid) {
				c2++;
				if (c2 == 3 && kid.value == selectedItemNo) {
					mortgRow.show();
				}
			});
		});
		$("newMortgageeItemNo").value = selectedItemNo;
	}
}