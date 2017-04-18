<div class="sectionDiv" id="lossExpDedSectionDiv" name="lossExpDedSectionDiv" style="border: none;">
	<div id="lossExpDedDiv" name="lossExpDedDiv" changeTagAttr="true">
		<div id="lossExpDeductiblesTableGridDiv" name="lossExpDeductiblesTableGridDiv" style="margin: 5px;"></div>
		<div class="sectionDiv" style="border: none;">
			<div style="float: right; margin-top: 5px;">
				<table>
					<tr>
						<td align="left" style="width: 145px;"><b>Total Deductible Amount</b></td>
						<td><input type="text" id="totalDedAmt" name="totalDedAmt" class="money" value="0.00" style="width: 130px; margin-right: 5px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="lossExpDeductibleForm" name="lossExpDeductibleForm" class="sectionDiv" style="border: none;">
			<table align="center">
				<tr>
					<td align="right" style="width: 100px;">Loss Expense</td>
					<td align="left" style="padding-left: 5px;">
						<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtLossExpCd" id="txtLossExpCd" value="" readonly="readonly"/>
							<img id="hrefLossExpCd" alt="goLossExpCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td align="right"width: 130px;">Unit(s)</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="required rightAligned integerNoNegativeUnformatted" id="txtDedUnits" name="txtDedUnits" style="width: 230px;" value="" maxlength="5"/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 100px;">For Loss Expense</td>
					<td align="left" style="padding-left: 5px;">
						<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtDedLossExpCd" id="txtDedLossExpCd" value="" readonly="readonly"/>
							<img id="hrefDedLossExpCd" alt="goDedLossExpCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td align="right" style="width: 130px;">Deductible Rate</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="applyDecimalRegExp" customLabel="Deductible Rate" regExpPatt="pDeci0309" min="0.000000001" max="100.00" value="" maxlength="13" id="txtDedRate" name="txtDedRate" style="width: 230px;" value=""/> <!-- modified by kenneth : 05262015 : SR 3637 -->
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 100px;">Deductible Type</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" id="txtDeductibleType" name="txtDeductibleType" style="width: 230px;" readonly="readonly" value=""/>
					</td>
					<td align="right" style="width: 130px;">Base Amount</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="money4 required" readonly="readonly" id="txtDedBaseAmt" name="txtDedBaseAmt" style="width: 230px;" value="" maxlength="17"/><!-- modified by kenneth : 05262015 : SR 3637 -->
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 100px;">Deductible Text</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" id="txtDeductibleText" name="txtDeductibleText" style="width: 230px;" readonly="readonly" value=""/>
					</td>
					<td align="right" style="width: 130px;">Deductible Amount</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="money required" id="txtDeductibleAmt" name="txtDeductibleAmt" style="width: 230px;" maxlength="17" value=""/><!-- modified by kenneth : 05262015 : SR 3637 -->
					</td>
				</tr>
			</table>
		</div>
		<div id="hidDeductibleFields" name="hidDeductibleFields" style="display: none;">
			<input type="hidden" id="hidDedSublineCd"     name="hidDedSublineCd"     value=""/>
			<input type="hidden" id="hidDedOriginalSw"    name="hidDedOriginalSw"    value=""/>
			<input type="hidden" id="hidDedType"     	  name="hidDedType"     	 value=""/>
			<input type="hidden" id="hidDedCompSw"    	  name="hidDedCompSw" 	     value=""/>
			<input type="hidden" id="hidDedAggregateSw"   name="hidDedAggregateSw" 	 value=""/>
			<input type="hidden" id="hidDedCeilingSw"     name="hidDedCeilingSw" 	 value=""/>
			<input type="hidden" id="hidDedMinAmt"     	  name="hidDedMinAmt" 	 	 value=""/>
			<input type="hidden" id="hidDedMaxAmt"     	  name="hidDedMaxAmt" 	 	 value=""/>
			<input type="hidden" id="hidDedRangeSw"       name="hidDedRangeSw" 	 	 value=""/>
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddLossExpDeductible" 	  name="btnAddLossExpDeductible" 	  class="button"	value="Add" />
			<input type="button" id="btnDeleteLossExpDeductible"  name="btnDeleteLossExpDeductible"   class="button"	value="Delete" />			
		</div>
	</div>
</div>

<div class="buttonsDiv" style="margin-bottom: 15px">
	<input type="button" id="btnDeductiblesDetails" 	  name="btnDeductiblesDetails" 	 	  class="button"	value="Deductible Details" />
	<input type="button" id="btnComputeDepreciation" 	  name="btnComputeDepreciation"  	  class="button"	value="Compute Depreciation" />
	<input type="button" id="btnClearDeductibles" 	 	  name="btnClearDeductibles"  	 	  class="button"	value="Clear Deductibles" />
	<input type="button" id="btnSaveDeductibles" 		  name="btnSaveDeductibles" 	 	  class="button"	value="Save" 	style="width: 90px;"/>
	<input type="button" id="btnDeductiblesReturn" 	 	  name="btnDeductiblesReturn"  	 	  class="button"	value="Return" 	style="width: 90px;"/>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializePreTextAttribute();
	objCurrLossExpDeductibles = null;
	var savingSw = "N"; // added by: Nica 04.09.2013 to determine if user save changes to refresh main page upon exit to deductible window
	
	retrieveLossExpDeductibles();
	checkLossExpDeductiblesForUpdate();
	
	if(objCLMGlobal.lineCd != "MC" && objCLMGlobal.menuLineCd != "MC"){
		disableButton("btnComputeDepreciation");
	}else{
		enableButton("btnComputeDepreciation");
	}
	
	$("btnDeductiblesReturn").observe("click", function(){
		if(hasPendingLossExpDeductibleRecords()){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveLossExpDeductibles(true);
					}, 
					function(){
						lossExpHistWin.close();
						if(savingSw == "Y"){
							retrieveClmLossExpense(objCurrGICLLossExpPayees);
							clearAllRelatedClmLossExpRecords();
						}
					},
					"");
		}else{
			lossExpHistWin.close();
			if(savingSw == "Y"){
				retrieveClmLossExpense(objCurrGICLLossExpPayees);
				clearAllRelatedClmLossExpRecords();
			}
		}
	});
	
	$("btnDeductiblesDetails").observe("click", function(){
		if(objCurrLossExpDeductibles == null){
			showMessageBox("Please select a deductible first.");
		}else if(hasPendingLossExpDeductibleRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else{
			showLossExpDeductibleDetails();
		}
	});
	
	$("btnComputeDepreciation").observe("click", function(){
		validateIfToComputeDepreciation("Y");
	});
	
	$("btnClearDeductibles").observe("click", function(){
		showConfirmBox("Confirmation", "Taxes included to the detail of the deductibles (if ever there are any) "+
                       "will also be deleted. Are you sure you want to delete deductible/s for this history?", "Yes", "No", 
						function(){clearLossExpenseDeductibles();}, function(){});
	});
	
	$("hrefLossExpCd").observe("click", function(){
		if(hasPendingLossExpDeductibleRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		getGiisLossExpForDedList(objCurrGICLItemPeril, objCurrGICLLossExpPayees, objCurrGICLClmLossExpense);	
	});
	
	$("hrefDedLossExpCd").observe("click", function(){
		if(hasPendingLossExpDeductibleRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		if(parseInt(objGICLLossExpDtl.length) > 1){
			getDeductibleLossExpList(objCurrGICLClmLossExpense, "getDeductibleLossExpList2");	
		}else{
			getDeductibleLossExpList(objCurrGICLClmLossExpense, "getDeductibleLossExpList");
		}
			
	});

	$("btnAddLossExpDeductible").observe("click", function(){
		if(validateAddLossExpDeductible()){
			addLossExpDeductible();			
		}
	});
	
	$("btnDeleteLossExpDeductible").observe("click", function(){
		if(validateDeleteLossExpDeductible()){
			deleteLossExpDeductible();			
		}
	});
	
	$("btnSaveDeductibles").observe("click", function(){
		if(hasPendingLossExpDeductibleRecords()){
			saveLossExpDeductibles(false);
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	
	// Modified by Kenneth : 05262015 : SR 4204
	$("txtDedUnits").observe("change", function(){
		var dedUnits = unformatNumber($("txtDedUnits").value); 
		$("txtDeductibleAmt").setAttribute("pre-text", $F("txtDeductibleAmt"));
		if(parseFloat(dedUnits) == 0){
			customShowMessageBox("Unit(s) cannot be zero.", "I", "txtDedUnits");
			$("txtDedUnits").value = $("txtDedUnits").getAttribute("pre-text");
			$("txtDedRate").value =  formatToNineDecimal(Math.abs(unformatCurrencyValue($F("txtDeductibleAmt"))) * 100/ (unformatCurrencyValue($F("txtDedBaseAmt")) * unformatNumber($F("txtDedUnits"))));
			fireEvent($("txtDedRate"), "change");
		}else{
			getLossExpDeductibleAmts();
			if(Math.abs(unformatCurrency("txtDeductibleAmt")) > unformatCurrency("txtDedBaseAmt")){
				showWaitingMessageBox("Deductible amount exceeds loss expense base amount.", "I", function (){
					$("txtDedUnits").value = $("txtDedUnits").getAttribute("pre-text");
					$("txtDeductibleAmt").value = formatCurrency($("txtDeductibleAmt").getAttribute("pre-text"));
				});
			}else{
				$("txtDedUnits").setAttribute("pre-text", $F("txtDedUnits"));
			}
		}
	});
	
	// Modified by Kenneth : 05262015 : SR 3637
	$("txtDedRate").observe("change", function(){
		$("txtDeductibleAmt").setAttribute("pre-text", $F("txtDeductibleAmt"));
		if($F("txtDedRate") == 0 || $F("txtDedRate") > 100){
			showWaitingMessageBox("Invalid Deductible Rate. Valid value should be from 0.000000001 to 100.00.", "E", function (){
				$("txtDedRate").value = formatToNineDecimal($("txtDedRate").getAttribute("pre-text"));
				$("txtDeductibleAmt").value = formatCurrency($("txtDeductibleAmt").getAttribute("pre-text"));
			});
		}else{
			getLossExpDeductibleAmts();	
			if(Math.abs(unformatCurrency("txtDeductibleAmt")) > unformatCurrency("txtDedBaseAmt")){
				showWaitingMessageBox("Deductible amount exceeds loss expense base amount.", "I", function (){
					$("txtDedRate").value = $("txtDedRate").getAttribute("pre-text");
					$("txtDeductibleAmt").value = formatCurrency($("txtDeductibleAmt").getAttribute("pre-text"));
				});
			}else{
				$("txtDedRate").setAttribute("pre-text", $F("txtDedRate"));
			}
		}
	});
	
	// Modified by Kenneth : 06162015 : SR 4646
	$("txtDedBaseAmt").observe("change", function(){
		var dedBaseAmt = unformatCurrencyValue($("txtDedBaseAmt").value);
		if(parseFloat(dedBaseAmt) <= 0){
			customShowMessageBox("Invalid Base Amount.Value should be from 1 to 99,999,999,999,999.99.", "I", "txtDedBaseAmt");
			$("txtDedBaseAmt").value = "";
		}else{
			getLossExpDeductibleAmts();
		}
		
	});
	
	// Modified by Kenneth : 05262015 : SR 3637
	$("txtDeductibleAmt").observe("change", function(){
		var dedAmt = unformatCurrencyValue($("txtDeductibleAmt").value);
		
		if(parseFloat(dedAmt) > 0 || parseFloat(dedAmt) > -0.01){
			customShowMessageBox("Invalid Deductible Amount. Valid value must be negative.", "I", "txtDeductibleAmt");
			$("txtDeductibleAmt").value = formatCurrency($("txtDeductibleAmt").getAttribute("pre-text"));
		}else{
			if($("txtLossExpCd").value == ""){
				customShowMessageBox("Please enter Loss Expense.", "I", "txtLossExpCd");
				$("txtDeductibleAmt").value = "";
				return false;
			}else if(parseFloat(dedAmt) > parseFloat(nvl(objCurrGICLItemPeril.annTsiAmt, 0))){
				showConfirmBox4("Confirmation", "Current market value exceeds the Total Sum Insured. Do you want to continue?", "Yes", "No", "Cancel", 
					function(){}, 
					function(){
						$("txtDeductibleAmt").value = "";
					},	
					function(){
						$("txtDeductibleAmt").value = formatCurrency($("txtDeductibleAmt").getAttribute("pre-text"));
					});
			}else{
				$("txtDedRate").value =  formatToNineDecimal(Math.abs($F("txtDeductibleAmt")) * 100/ (unformatNumber($F("txtDedBaseAmt")) * unformatNumber($F("txtDedUnits"))));
			}
		}
	});
	
	function saveLossExpDeductibles(closeWindow){
		try{
			var objParameters = new Object();
			objParameters.setGiclLossExpDeductibles  = getAddedAndModifiedJSONObjects(objLossExpDeductibles);
			objParameters.delGiclLossExpDeductibles = getDeletedJSONObjects(objLossExpDeductibles);
			
			new Ajax.Request(contextPath+"/GICLLossExpDtlController", {
				asynchronous: true,
				parameters:{
					action: "saveLossExpDeductibles",
					parameters: JSON.stringify(objParameters) 
				},
				onCreate: function(){
					showNotice("Saving Loss Expense Deductibles...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", 
							function(){
								if(nvl(closeWindow, false) == true){ // added condition Nica 04.09.2013
									lossExpHistWin.close();
									retrieveClmLossExpense(objCurrGICLLossExpPayees);
									clearAllRelatedClmLossExpRecords();	
								}else{
									savingSw = "Y";
									retrieveLossExpDeductibles();
								}
							});	
						}else{
							showMessageBox(response.responseText, "E");							
						}
					}else{
						showMessageBox(response.responseText, "E");							
					}	
				}
			});			
		
		}catch(e){
			showErrorMessage("saveLossExpDeductibles", e);	
		}
	}
	
</script>