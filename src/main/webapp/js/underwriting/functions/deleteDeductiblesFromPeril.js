/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function deleteDeductiblesFromPeril(){
	$("fireDeleteDeductibles").value = "Y";
	$("deductiblesDeleted").value = "Y";

	for (var dedLevel=3; dedLevel>0; dedLevel--){
		for (var i=0; i<objDeductibles.length; i++){
			if ((objDeductibles[i].deductibleType == "T")
					&& (objDeductibles[i].recordStatus != -1)){
				$$("div[name='ded"+dedLevel+"']").each(function(deduct){
					if ((objDeductibles[i].dedDeductibleCd == deduct.getAttribute("dedCd"))
							&& (objDeductibles[i].itemNo == deduct.getAttribute("item"))
							&& (objDeductibles[i].perilCd == deduct.getAttribute("perilCd"))
							&& (objDeductibles[i].recordStatus != -1)){
						var delId = dedLevel + objDeductibles[i].itemNo + objDeductibles[i].perilCd + objDeductibles[i].dedDeductibleCd;
						var delDedCd = objDeductibles[i].dedDeductibleCd;
						var dedForDeleteDiv = $("dedForDeleteDiv"+dedLevel);
						var deleteContent  = '<input type="hidden" id="delDedItemNo'+ delId +'"			name="delDedItemNo'+dedLevel+'" 		value="'+ objDeductibles[i].itemNo +'" />'+
											 '<input type="hidden" id="delDedPerilCd'+ delId +'"		name="delDedPerilCd'+dedLevel+'" 		value="'+ objDeductibles[i].perilCd +'" />'+
											 '<input type="hidden" id="delDedDeductibleCd'+ delId +'"	name="delDedDeductibleCd'+dedLevel+'" 	value="'+ objDeductibles[i].dedDeductibleCd +'" />';

						var delDiv = new Element("div");
						delDiv.setAttribute("name", "delDed"+dedLevel);
						delDiv.setAttribute("id", "delDed"+delId);
						delDiv.setStyle("display: none;");
						delDiv.update(deleteContent);
						dedForDeleteDiv.insert({bottom : delDiv});

						$$("div[name='insDed"+dedLevel+"']").each(function(div){
							var id = div.getAttribute("id");
							if(id == "insDed"+delId){
								div.remove();
							}
						});

						//setVariables();
						var objDed = objDeductibles[i];
						//addDeletedJSONDeductible(objDed);
						addDelObjByAttr(objDeductibles, objDed, "parId itemNo perilCd dedDeductibleCd");
						
						Effect.Fade(deduct, {
							duration: .5,
							afterFinish: function () {
								//if(1 < dedLevel) {
								//	updateTempDeductibleItemNos();
								//}
								//setDeductibleForm(null, dedLevel);							
								deduct.remove();
								checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
								checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
								setTotalAmount(dedLevel, objDeductibles[i].itemNo, objDeductibles[i].perilCd);
								//setDeductibleListing(objDeductibleListing);
							}
						});
						
						$("inputDeductible"+dedLevel).show();
						$("inputDeductDisplay"+dedLevel).clear();
						$("inputDeductDisplay"+dedLevel).hide();
					}
				});
			}
		}
	}
	if ($F("deleteTag") == "Y"){		
		deleteItemPeril2();
		$("deleteTag").value = "N";
	} else if ("Y" == $F("copyPerilTag")){
		//checkIfItemHasExistingPeril();
		showCopyPerilOverlay();
		$("copyPerilTag").value = "N";
	} else if ("perilCd" == $F("validateDedCallingElement")){				
		getPerilDetails();
	} else if ("premiumAmt" == $F("validateDedCallingElement")){	
		validateItemPerilPremAmt();
	} else if ("perilRate" == $F("validateDedCallingElement")){				
		validateItemPerilRateTG(); //validateItemPerilRate(); //edited by d.alcantara, 8.24.2012
	} else if ("perilTsiAmt" == $F("validateDedCallingElement")){				
		validateItemPerilTsiAmt();
	} else if ("perilBaseAmt" == $F("validateDedCallingElement")){				
		validateBaseAmt();
	}
}