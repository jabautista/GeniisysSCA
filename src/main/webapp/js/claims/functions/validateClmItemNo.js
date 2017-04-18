/**
 * Validate item no.
 * 
 * @author Niknok Orio
 * @param
 */
function validateClmItemNo(){
	try{
		objCLMItem.itemLovSw = false;
		var url;

		if (nvl(objCLMItem.selItemIndex,null) != null){
			var itemNo = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('itemNo')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('itemNo')]));
			var grpItemNo = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('groupedItemNo')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('groupedItemNo')]));
			if ($F("txtItemNo") == itemNo){
				null;
			}else if ($F("txtGrpItemNo") == grpItemNo){
				null;
			}else{
				if (!itemGrid.validateSequence($F("txtItemNo"), "itemNo")){
					showMessageBox("Item Number already used.", "I");
					$("txtItemNo").value = objCLMItem.selected != {} && objCLMItem.selItemIndex != null  ? unescapeHTML2(String(objCLMItem.selected[itemGrid.getColumnIndex('itemNo')])) :"";
					if ($F("txtItemNo") == "") clearClmItemForm();
					return false;
				}
			}
		}else{
			if (!itemGrid.validateSequence($F("txtItemNo"), "itemNo")){
				showMessageBox("Item Number already used.", "I");
				$("txtItemNo").value = objCLMItem.selected != {} && objCLMItem.selItemIndex != null  ? unescapeHTML2(String(objCLMItem.selected[itemGrid.getColumnIndex('itemNo')])) :"";
				if ($F("txtItemNo") == "") clearClmItemForm();
				return false;
			}
		}

		if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI || objCLMGlobal.menuLineCd == objLineCds.FI){
			url = "/GICLFireDtlController";
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS015";
		}else if(objCLMGlobal.lineCd == "CA" || objCLMGlobal.lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA || objCLMGlobal.lineCd == "LI" || objCLMGlobal.lineCd == objLineCds.LI){//added by steven 10/30/2012
			url = "/GICLCasualtyDtlController";
			objAC.funcCode = "VL";
			objACGlobal.calledForm = "GICLS016";			
		}else if (objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC) { // Added
																							// for
																							// Motor
																							// car
																							// -
																							// Irwin
			url = "/GICLMotorCarDtlController";
			//marco - 05.25.2015 - GENQA SR 4436 -  from UCPB SR 17673
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS014";
		}else if (objCLMGlobal.lineCd == "EN" || objCLMGlobal.lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN) { // Added
																							// for
																							// Engineering
																							// -
																							// Emman
			url = "/GICLEngineeringDtlController";
			//kenneth - 07.31.2015 - SR 18895
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS021";
		}else if (objCLMGlobal.lineCd == "MN" || objCLMGlobal.lineCd == objLineCds.MN || objCLMGlobal.menuLineCd == objLineCds.MN) { // Added
																							// for
																							// Marine
																							// Cargo
																							// -
																							// Irwin
			url = "/GICLCargoDtlController";
			//marco - 05.25.2015 - GENQA SR 4436 -  from UCPB SR 17673
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS019";
		}else if (objCLMGlobal.lineCd == "AV" || objCLMGlobal.lineCd == objLineCds.AV || objCLMGlobal.menuLineCd == objLineCds.AV) { // Added for Aviation - Irwin
			url = "/GICLAviationDtlController";
			//marco - 05.25.2015 - GENQA SR 4436 -  from UCPB SR 17673
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS020";
		}else if (objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.lineCd == "AH" || objCLMGlobal.menuLineCd == "AC") { // Added for ACcident - Belle 12.05.2011
			url = "/GICLAccidentDtlController";
			var groupedItemNo = nvl($F("txtGrpItemNo"),0);
			//marco - 05.25.2015 - GENQA SR 4436 -  from UCPB SR 17673
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS017";
		}else if (objCLMGlobal.lineCd == "MH" || objCLMGlobal.lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){// Added by Rey 01-12-2011
			objAC.funcCode = "TL";
			objACGlobal.calledForm = "GICLS022";	
			url = "/GICLMarineHullDtlController";
		}

		
		new Ajax.Request(contextPath+url,{
			parameters:{
				action: 	"validateClmItemNo",
				lineCd: 	objCLMGlobal.lineCd,
				sublineCd: 	objCLMGlobal.sublineCd,
				polIssCd: 	objCLMGlobal.policyIssueCode,
				issueYy: 	objCLMGlobal.issueYy,
				polSeqNo: 	objCLMGlobal.policySequenceNo,
				renewNo: 	objCLMGlobal.renewNo,
				polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
				expiryDate: objCLMGlobal.strExpiryDate2,
				lossDate: 	objCLMGlobal.strLossDate2,
				inceptDate: objCLMGlobal.strInceptDate,
				issCd: 		objCLMGlobal.issCd,
				itemNo: 	$F("txtItemNo"),
				claimId:	objCLMGlobal.claimId,
				groupedItemNo:	groupedItemNo,
				from: 		itemGrid.pager.from,
				to: 		itemGrid.pager.to	
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText); //JSON.parse(response.responseText.replace(/\\/g, '\\\\')); //modified by Halley 10.23.13
					if (nvl(res.itemExist2,"N") == "Y"){
						showMessageBox("Item Number already used.", "I");
						$("txtItemNo").value = objCLMItem.selected != {} && objCLMItem.selItemIndex != null  ? unescapeHTML2(String(objCLMItem.selected[itemGrid.getColumnIndex('itemNo')])) :"";
						if ($F("txtItemNo") == "") clearClmItemForm();
						return false;
					}
					if (nvl(res.itemExist,"0") == "0"){
						objCLMItem.newItem = [];
						$("txtItemNo").value = objCLMItem.selected != {} && objCLMItem.selItemIndex != null  ? unescapeHTML2(String(objCLMItem.selected[itemGrid.getColumnIndex('itemNo')])) :"";
						if ($F("txtItemNo") == "") clearClmItemForm();
						showMessageBox("Item Number entered does not exist for this policy.", "E");
						return false;
					}
					objCLMItem.newItem = res.row || []; 
					objCLMItem.newBeneficiary = res.c017b || []; //belle 02.17.2012 
					objCLMItem.benCount	= res.benCnt;
					
					var newItem = itemGrid.generateRows(objCLMItem.newItem);
					if (nvl(res.tlossFl,"TRUE") == "TRUE"){
						if (objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC"){
							if (res.exist == "Y" ){
								if (res.valid == 0 ){ 
									if ($F("txtGrpItemNo") == ""){
										$("txtItemTitle").value = res.row[0].itemTitle; 
									}else{
										showMessageBox("Grouped item number entered does not exist for this policy.", "E"); 
										clearItemGrpDtls(); 
										return false;
									}
								}else if (res.valid == 1){
									setNewClmItem(newItem[0]);
								}								
							}else{
								if ($F("txtGrpItemNo")!= 0){
									showMessageBox("Grouped item detail does not exist for this policy.", "E"); 
									$("txtGrpItemNo").value = 0; 
									objCLMItem.newItem[0].groupedItemNo = 0; //set back Grouped Item Number if value is invalid by MAC 11/07/2013.
									return false;
								}else{
									setNewClmItem(newItem[0]);
								}
							}
						}else{
							setNewClmItem(newItem[0]);
						}
					}else{
						if (res.overrideFl == "FALSE"){
							showConfirmBox("Confirm", "The item selected has a peril with a total loss claim. Do you want to override?", "Yes", "No", 
									function(){
										if (objCLMItem.overrider){
											setNewClmItem(newItem[0]);
										}else{
											$("txtItemNo").blur();
											commonOverrideOkFunc = function(){
												objCLMItem.overrider = true;
												$("txtItemTitle").focus();
												$("txtItemTitle").scrollTo();
												setNewClmItem(newItem[0]);
											};
											commonOverrideNotOkFunc = function(){
												showWaitingMessageBox("User is not allowed to process another claim for this item.", "E", 
														clearOverride);
												return false;
											};
											commonOverrideCancelFunc = function(){
												$("txtItemNo").clear();
												$("txtItemTitle").clear();
											};
											getUserInfo();
											$("overlayTitle").innerHTML = "Override User";
										}
									},
									function(){
										$("txtItemNo").clear();
										$("txtItemTitle").clear();
									});	
						}else{
							//marco - 05.25.2015 - GENQA SR 4436 -  from UCPB SR 17673
							showConfirmBox("Confirm", "The item selected has a peril with a total loss claim. Do you want to continue?", "Yes", "No",
								function(){
									setNewClmItem(newItem[0]);
								}, 
								function(){
									$("txtItemNo").clear();
									$("txtItemTitle").clear();
								}
							);
						}
					}
					
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}	
			}
		});
	}catch(e){
		showErrorMessage("validateClmItemNo" ,e);
	}
}