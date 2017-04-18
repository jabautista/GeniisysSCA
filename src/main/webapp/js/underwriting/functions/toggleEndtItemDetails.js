/**
 * Retrieve details of item to be endorsed
 * @author andrew
 * @date 05.23.2011
 * @param itemNo - endtered item number
 */
function toggleEndtItemDetails(itemNo){
	try {
		var item = null;
		//marco - 04.25.2014 - added to check if entered item is not within the endt effectivity date
		if (nvl($F("globalBackEndt"), "N") == "Y" && $F("itemNo") != "") {
			new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getBackEndtEffectivityDate",{
				method : "GET",
				parameters : {
					itemNo : $F("itemNo"),
					parId : nvl($F("globalParId"), objUWParList.parId)
				},					
				asynchronous : false,
				evalScripts : true,
				onCreate: function() {
					showNotice("Checking if item has already been endorsed. Please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						var msg = response.responseText;
						if (!msg.blank()) {
							var res = msg.split(" ")[0];
							if (res == "SUCCESS") {
								showMessageBox("This is a backward endorsement, any changes made in this item will affect " +
						                 "all previous endorsement that has an effectivity date later than " + msg.substring(8), imgMessage.INFO);
							} else {
								showMessageBox(msg, imgMessage.ERROR);
							}
						}
					}
				}
			});
		}
		outerLoop: for (var i=0; i<objPolbasics.length; i++){
			for(var j=0; j<objPolbasics[i].gipiItems.length; j++){
				if(objPolbasics[i].gipiItems[j].itemNo == itemNo){
					item = objPolbasics[i].gipiItems[j];
					break outerLoop;
				}
			}
		}
		
		if (objFormParameters.paramMenuLineCd == "CA") { //Added by Jerome 12.01.2016 SR 5606
			var pflSublineCd = objFormParameters.paramSublineCd.split(",");
			
			for (var i=0; i<objPolbasics.length; i++){
				for(var j=0; j<objPolbasics[i].gipiItems.length; j++){
					if(objPolbasics[i].gipiItems[j].itemNo == itemNo){
						$("btnUpdPropertyFloater").hide();
						$("btnMaintainLocation").hide();
						$("locationCd").removeClassName("required");
					} else if (objPolbasics[i].gipiItems[j].itemNo != itemNo){
						for (var k = 0; k < pflSublineCd.length; k++){
							var pflSublineCd2 = pflSublineCd[k];
							
							if ($F("globalSublineCd") == ltrim(pflSublineCd2)) {
								$("rowLocationCd").show();
								$("locationCd").addClassName("required");
							}
						}
						break;
					}
				}
			}
		}
		
		prepareEndtItemByLine(item);
		onEndtItemNoEntered(item);
		if(item == null) $("itemNo").value = itemNo;
	} catch (e) {
		showErrorMessage("toggleEndtItemDetails", e);
	}
}