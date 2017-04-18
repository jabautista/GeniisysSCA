/*Created by 	: Gzelle 
 * Date			: August 11, 2015
 * Remarks		: UW-SPECS-2015-079*/
function recomputeDeductiblesTableGrid(deleteTag){
	var rangeSw = null;
	var rate = 0;
	var amount = 0;
	var totalAmount = 0;
	var objMaintainedDeductibles = [];
	var dedDeductibleCd = null;
	var objDeductible = new Object();
	
	function getAllDedType() {
		new Ajax.Request(contextPath+"/GIISDeductibleDescController",{
			method: "POST",
			parameters: {
				action: "getAllTDedType",
				lineCd: objDeductibles[0].dedLineCd,
				sublineCd: objDeductibles[0].dedSublineCd,
				deductibleType: "T"
			},
			asynchronous : false,
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					objMaintainedDeductibles = JSON.parse(response.responseText);
					
					for ( var j = 0; j < objMaintainedDeductibles.maintainedDed.length; j++) {
						dedDeductibleCd = objMaintainedDeductibles.maintainedDed[j]['deductibleCd'];
						
						/* policy deductible*/
						for ( var a = 0; a < objDeductibles.length; a++) {
							if (objDeductibles[a].deductibleType == "T" && 
									objDeductibles[a].itemNo == 0 && 
									objDeductibles[a].perilCd == 0) {
								if (objDeductibles[a].dedDeductibleCd == dedDeductibleCd ) {
									rate   = objMaintainedDeductibles.maintainedDed[j]['deductibleRate'];
									amount = parseFloat(unformatCurrency("perilTsiAmt")) * (parseFloat(rate) / 100);
									
									deductAmount = computeDeductibleAmount(rate, amount,
														objMaintainedDeductibles.maintainedDed[j]['minimumAmount'],
														objMaintainedDeductibles.maintainedDed[j]['maximumAmount'],
														objMaintainedDeductibles.maintainedDed[j]['rangeSw']);
									
									objDeductible = setDeductibleAmt(objDeductibles[a], deductAmount, objMaintainedDeductibles.maintainedDed[j]);
									objDeductibles.splice(a, 1);
									objDeductibles.push(objDeductible);
								}
							}
						}
						
						/* item deductible */
						totalAmount = unformatCurrency("itemAmtTotal");
						
						for ( var b = 0; b < tbgItemDeductible.geniisysRows.length; b++) {
							if (tbgItemDeductible.geniisysRows[b].deductibleType == "T" && 
									tbgItemDeductible.geniisysRows[b].itemNo == $F("itemNo") && 
									tbgItemDeductible.geniisysRows[b].perilCd == 0) {
								
								if (tbgItemDeductible.geniisysRows[b].dedDeductibleCd == dedDeductibleCd ) {
									totalAmount = parseFloat(totalAmount) - parseFloat((tbgItemDeductible.geniisysRows[b].deductibleAmount));
									rate   = objMaintainedDeductibles.maintainedDed[j]['deductibleRate'];
									amount = parseFloat(unformatCurrency("perilTsiAmt")) * (parseFloat(rate) / 100);
									
									deductAmount = computeDeductibleAmount(rate, amount,
														objMaintainedDeductibles.maintainedDed[j]['minimumAmount'],
														objMaintainedDeductibles.maintainedDed[j]['maximumAmount'],
														objMaintainedDeductibles.maintainedDed[j]['rangeSw']);
									
									objDeductible = setDeductibleAmt(tbgItemDeductible.geniisysRows[b], deductAmount, objMaintainedDeductibles.maintainedDed[j]);
									
									for(var i = 0; i < objDeductibles.length; i++){
										if (objDeductibles[i].dedDeductibleCd == tbgItemDeductible.geniisysRows[b].dedDeductibleCd) {
											if(objDeductibles[i].itemNo == $F("itemNo") && objDeductibles[i].perilCd == 0 && objDeductibles[i].deductibleType == 'T'){
												objDeductibles.splice(i, 1);
												objDeductibles.push(objDeductible);
											}
										}
									}	
									
									$("mtgIC" + tbgItemDeductible._mtgId + '_' + tbgItemDeductible.getColumnIndex("deductibleAmount") + ','+ b).innerHTML = formatCurrency(deductAmount);
									$("mtgIC" + tbgItemDeductible._mtgId + '_' + tbgItemDeductible.getColumnIndex("deductibleRate") + ','+ b).innerHTML = formatToNineDecimal(objMaintainedDeductibles.maintainedDed[j]['deductibleRate']);
									$("mtgIC" + tbgItemDeductible._mtgId + '_' + tbgItemDeductible.getColumnIndex("deductibleText") + ','+ b).innerHTML = objMaintainedDeductibles.maintainedDed[j]['deductibleText'];
									$("mtgIC" + tbgItemDeductible._mtgId + '_' + tbgItemDeductible.getColumnIndex("deductibleTitle") + ','+ b).innerHTML = objMaintainedDeductibles.maintainedDed[j]['deductibleTitle'];
									if($('mtgRow'+tbgItemDeductible._mtgId+'_'+b).hasClassName("selectedRow")){
										tbgItemDeductible.onRemoveRowFocus();
										tbgItemDeductible.unselectRows();
									}
									totalAmount = parseFloat(totalAmount) + parseFloat(deductAmount);
								}
							} 
						}
						
						$("itemAmtTotal").value = formatCurrency(totalAmount);
						totalAmount = 0;
						
						/* peril deductible */
						totalAmount = unformatCurrency("perilAmtTotal");
						
						for ( var c = 0; c < tbgPerilDeductible.geniisysRows.length; c++) {
							if (tbgPerilDeductible.geniisysRows[c].deductibleType == "T" && 
									tbgPerilDeductible.geniisysRows[c].itemNo == $F("itemNo") && 
									tbgPerilDeductible.geniisysRows[c].perilCd == $F("perilCd")) {
								
								if (tbgPerilDeductible.geniisysRows[c].dedDeductibleCd == dedDeductibleCd ) {
									totalAmount = parseFloat(totalAmount) - parseFloat((tbgPerilDeductible.geniisysRows[c].deductibleAmount));
									rate   = objMaintainedDeductibles.maintainedDed[j]['deductibleRate'];
									amount = parseFloat(unformatCurrency("perilTsiAmt")) * (parseFloat(rate) / 100);
									
									deductAmount = computeDeductibleAmount(rate, amount,
														objMaintainedDeductibles.maintainedDed[j]['minimumAmount'],
														objMaintainedDeductibles.maintainedDed[j]['maximumAmount'],
														objMaintainedDeductibles.maintainedDed[j]['rangeSw']);
									
									objDeductible = setDeductibleAmt(tbgPerilDeductible.geniisysRows[c], deductAmount, objMaintainedDeductibles.maintainedDed[j]);

									for(var i = 0; i < objDeductibles.length; i++){
										if (objDeductibles[i].dedDeductibleCd == tbgPerilDeductible.geniisysRows[c].dedDeductibleCd) {
											if(objDeductibles[i].itemNo == $F("itemNo") && objDeductibles[i].perilCd == $F("perilCd") && objDeductibles[i].deductibleType == 'T'){
												objDeductibles.splice(i, 1);
												objDeductibles.push(objDeductible);
											}
										}
									}										
									
									$("mtgIC" + tbgPerilDeductible._mtgId + '_' + tbgPerilDeductible.getColumnIndex("deductibleAmount") + ','+ c).innerHTML = formatCurrency(deductAmount);
									$("mtgIC" + tbgPerilDeductible._mtgId + '_' + tbgPerilDeductible.getColumnIndex("deductibleRate") + ','+ c).innerHTML = formatToNineDecimal(objMaintainedDeductibles.maintainedDed[j]['deductibleRate']);
									$("mtgIC" + tbgPerilDeductible._mtgId + '_' + tbgPerilDeductible.getColumnIndex("deductibleText") + ','+ c).innerHTML = objMaintainedDeductibles.maintainedDed[j]['deductibleText'];
									$("mtgIC" + tbgPerilDeductible._mtgId + '_' + tbgPerilDeductible.getColumnIndex("deductibleTitle") + ','+ c).innerHTML = objMaintainedDeductibles.maintainedDed[j]['deductibleTitle'];
									if($('mtgRow'+tbgPerilDeductible._mtgId+'_'+c).hasClassName("selectedRow")){
										tbgPerilDeductible.onRemoveRowFocus();
										tbgPerilDeductible.unselectRows();
									}
									totalAmount = parseFloat(totalAmount) + parseFloat(deductAmount);
								}
							}
						}
						
						$("perilAmtTotal").value = formatCurrency(totalAmount);
						totalAmount = 0;
					}

					changeTag = 1;
					objUW.hidObjGIPIS010.perilChangeTag = 1;

					if ($F("deleteTag") == "Y"){		
						deleteItemPeril2();
						$("deleteTag").value = "N";
					} else if ("Y" == $F("copyPerilTag")){
						showCopyPerilOverlay();
						$("copyPerilTag").value = "N";
					} else if ("perilCd" == $F("validateDedCallingElement")){				
						getPerilDetails();
					} else if ("premiumAmt" == $F("validateDedCallingElement")){	
						validateItemPerilPremAmt();
					} else if ("perilRate" == $F("validateDedCallingElement")){				
						validateItemPerilRateTG();
					} else if ("perilTsiAmt" == $F("validateDedCallingElement")){				
						validateItemPerilTsiAmt();
					} else if ("perilBaseAmt" == $F("validateDedCallingElement")){				
						validateBaseAmt();
					}
				}
			}							 
		});
	}
	
	function setDeductibleAmt(objDeduct,deductAmt,objMaintained) {
		var obj = new Object();
		obj.parId			 = objDeduct.parId; 
		obj.dedLineCd		 = objDeduct.dedLineCd; 
		obj.dedSublineCd	 = objDeduct.dedSublineCd; 
		obj.userId			 = objDeduct.userId; 
		obj.itemNo			 = objDeduct.itemNo; 
		obj.perilCd			 = objDeduct.perilCd; 
		obj.dedDeductibleCd	 = objDeduct.dedDeductibleCd; 
		obj.deductibleTitle	 = objMaintained['deductibleTitle']; 
		obj.deductibleAmount = deductAmt.toString(); 
		obj.deductibleRate	 = objMaintained['deductibleRate']; 
		obj.deductibleText	 = objMaintained['deductibleText'];
		obj.aggregateSw		 = objDeduct.aggregateSw; 
		obj.ceilingSw		 = objDeduct.ceilingSw; 
		obj.deductibleType	 = objDeduct.deductibleType; 
		obj.minimumAmount	 = objDeduct.minimumAmount; 
		obj.maximumAmount	 = objDeduct.maximumAmount; 
		obj.rangeSw 		 = objDeduct.rangeSw; 
		obj.recordStatus     = 1;
		return obj;
	}

	function computeDeductibleAmount(dedRate,dedDeductAmount,dedMinAmt,dedMaxAmt,dedRangeSw) {
		var amt = 0;
		if (dedRate != null) {
			if (dedMinAmt != null && dedMaxAmt != null) {
				if (dedRangeSw == "H") {
					amt = Math.min(Math.max(dedDeductAmount, dedMinAmt), dedMaxAmt);
				} else if (dedRangeSw == "L") {
					amt = Math.min(Math.max(dedDeductAmount, dedMinAmt), dedMaxAmt);
				} else {
					amt = dedMaxAmt;
				}
			} else if (dedMinAmt != null) {
				amt = Math.max(dedDeductAmount, dedMinAmt);
			} else if (dedMaxAmt != null) {
				amt = Math.min(dedDeductAmount, dedMaxAmt);
			} else {
				amt = parseFloat(unformatCurrency("perilTsiAmt")) * (parseFloat(dedRate) / 100);
			}
		} else {
			if (dedMinAmt != null) {
				amt = dedMinAmt;
			} else if (dedMaxAmt != null) {
				amt = dedMaxAmt;
			}
		}
		return amt;
	}
	
	getAllDedType();
}