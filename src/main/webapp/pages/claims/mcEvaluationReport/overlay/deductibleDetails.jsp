<div style=" padding: 5px;">
<!-- 	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Deductible Details</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div> -->
	<div class="sectionDiv" style="margin-top: 0;">
		<div style="padding: 10px;  height: 205px;">
			<div id="deductibleDetailsTgDiv" style="height: 200px;"></div>
		</div>
		<div class="sectionDiv" style="border: none;">
			<div style="float: right; margin-bottom: 5px;">
				<table>
					<tr>
						<td align="left" style="width: 170px;"><b>Total Deductible Amount</b></td>
						<td><input type="text" id="totalEvalDedAmt" name="totalEvalDedAmt" class="money" value="0.00" style="width: 136px; margin-right: 10px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div id="evalDeductibleForm" name="evalDeductibleForm" class="sectionDiv" style="margin-top: 0; padding-top: 10px;" changeTagAttr="true">
		<table align="center">
			<tr>
				<td align="right" style="width: 100px;">Deductible</td>
				<td align="left" style="padding-left: 5px;">
					<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
						<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtEvalDedCd" id="txtEvalDedCd" value="" readonly="readonly"/>
						<img id="hrefEvalDedCd" alt="goEvalDedCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
				<td align="right"width: 130px;">Unit(s)</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" class="required rightAligned integerNoNegativeUnformatted" id="txtEvalDedUnits" name="txtEvalDedUnits" style="width: 230px;" value="" maxlength="5"/>
				</td>
			</tr>
			<tr>
				<td align="right" style="width: 100px;">Company</td>
				<td align="left" style="padding-left: 5px;">
					<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
						<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtEvalDedCompany" id="txtEvalDedCompany" value="" readonly="readonly"/>
						<img id="hrefEvalDedCompany" alt="goEvalDedCompany" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
				<td align="right" style="width: 130px;">Deductible Rate</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" class="applyDecimalRegExp" regExpPatt="pDeci0309" min="0.000000001" max="100.00" value="" maxlength="13" id="txtEvalDedRate" name="txtEvalDedRate" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<td align="right" style="width: 100px;">Base Amount</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" class="money required" id="txtEvalDedBaseAmt" name="txtEvalDedBaseAmt" style="width: 230px;" value=""/>
				</td>
				<td align="right" style="width: 130px;">Deductible Amount</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" class="money required" id="txtEvalDedAmt" name="txtEvalDedAmt" style="width: 230px;" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td align="right" style="width: 100px;">Deductible Text</td>
				<td align="left" style="padding-left: 5px;" colspan="3">
					<div style="border: 1px solid gray; width: 615px; height: 20px; float: left;"> 
						<input type="text" id="txtEvalDedText" name="txtEvalDedText" style="float: left; border: none; width: 588px; background: transparent;" readonly="readonly" value=""/> 
						<img id="hrefEvalDedText" alt="goEvalDedText" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />
					</div>
				</td>
			</tr>
		</table>
		<div id="evalDeductiblesHiddenDiv" style="display:none;">
			<input type="hidden" id="hidEvalDedSublineCd" name="hidEvalDedSublineCd" value=""/>
			<input type="hidden" id="hidEvalDedNetTag" name="hidEvalDedNetTag" value=""/>
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddEvalDeductible" 	  	name="btnAddEvalDeductible" 	  class="button"	value="Add" />
			<input type="button" id="btnDeleteEvalDeductible"  	name="btnDeleteEvalDeductible"    class="disabledButton"	value="Delete" />			
		</div>
	</div>
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 10px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnApplyDeductibles" value="Apply UW Deductible"/>
			<input type="button" class="button" 		id="btnSaveEvalDed" 	  value="Save" 			style="width:100px;"/>
			<input type="button" class="button" 		id="btnMainScreen" 		  value="Main Screen" 	style="width:100px;" />
		</div>
	</div>
</div>

<script type="text/javascript">
	changeTag = 0;
	objGICLEvalDeductiblesReplaceRows = [];
	initializeAll();
	initializeAllMoneyFields();
	initializeChangeTagBehavior(saveEvalDeductibles);
	getGicls070DeductibleDetailsList();
		
	observeCancelForm("btnMainScreen", saveEvalDeductibles, function(){
		genericObjOverlay.close();
		if(hasSaved == "Y"){
			refreshMainMcEvalList();
		}
	});
	
	/* observeReloadForm("reloadForm",function(){
		genericObjOverlay.close();
		showMcEvalDeductibleDetails();
	}); */
	
	$("hrefEvalDedText").observe("click", function(){
		showEditor("txtEvalDedText", 2000, "true");
	});
	
	$("hrefEvalDedCd").observe("click", function(){
		getMCEvalDeductibleListing(mcMainObj);
	});
	
	$("hrefEvalDedCompany").observe("click", function(){
		getMcEvalDeductibleCompanyList(selectedMcEvalObj.evalId);
	});
	
	$("txtEvalDedRate").observe("change", function(){
		computeEvalDeductibleAmount();
	});
	
	$("txtEvalDedBaseAmt").observe("change", function(){
		computeEvalDeductibleAmount();
	});
	
	$("txtEvalDedUnits").observe("change", function(){
		computeEvalDeductibleAmount();
	});
	
	$("btnAddEvalDeductible").observe("click", function(){
		if(validateAddEvalDeductible()){
			var newObj = createEvalDeductiblesObject();
			
			if($("btnAddEvalDeductible").value == "Update"){
				var currIndex = evalDeductiblesTableGrid.getCurrentPosition()[1];
				var prevObj = evalDeductiblesTableGrid.geniisysRows[currIndex];
				newObj.recordStatus = prevObj.recordStatus == "0" ? 0 : 1;
				if(prevObj.recordStatus != "0" && prevObj.recordStatus != "1"){
					objGICLEvalDeductiblesReplaceRows.push(prevObj);				
				}
				addModifiedEvalDeductible(prevObj, newObj);
				evalDeductiblesTableGrid.updateVisibleRowOnly(newObj, currIndex);
			}else{
				objGICLEvalDeductiblesArr.push(newObj);
				evalDeductiblesTableGrid.addBottomRow(newObj);
			}
			updateTGPager(evalDeductiblesTableGrid);
			populateEvalDeductible(null);
			computeTotalEvalDedAmt();
			enableDisableApplyDeductible();
			changeTag = 1;			
		}
	});
	
	$("btnDeleteEvalDeductible").observe("click", function(){
		var currIndex = evalDeductiblesTableGrid.getCurrentPosition()[1];
		var delObj = evalDeductiblesTableGrid.geniisysRows[currIndex];
		deleteEvalDeductible(delObj);
		evalDeductiblesTableGrid.deleteVisibleRowOnly(currIndex);
		updateTGPager(evalDeductiblesTableGrid);
		populateEvalDeductible(null);
		computeTotalEvalDedAmt();
		enableDisableApplyDeductible();
		changeTag = 1;
	});
	
	$("btnSaveEvalDed").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}else{
			saveEvalDeductibles();
		}
	});
	
	$("btnApplyDeductibles").observe("click", function(){
		showApplyDedDialogBox("dedDetails");
	});
	
	function saveEvalDeductibles(){
		try{
			var objParameters = new Object();
			objParameters.evalId = selectedMcEvalObj.evalId;
			objParameters.setGiclEvalDeductibles = getAddedAndModifiedJSONObjects(objGICLEvalDeductiblesArr);
			objParameters.delGiclEvalDeductibles = getDeletedJSONObjects(objGICLEvalDeductiblesArr);
			objParameters.replaceGiclEvalDeductibles = objGICLEvalDeductiblesReplaceRows;
			
			new Ajax.Request(contextPath+"/GICLEvalDeductiblesController", {
				asynchronous: true,
				parameters:{
					action: "saveGiclEvalDeductibles",
					parameters: JSON.stringify(objParameters) 
				},
				onCreate: function(){
					showNotice("Saving MC Evaluation Deductible Details...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", 
							function(){
								changeTag = 0;
								hasSaved = "Y";
								genericObjOverlay.close();
								showMcEvalDeductibleDetails();
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
			showErrorMessage("saveEvalDeductibles", e);	
		}
	}
	
	if( variablesObj.evalStatCd == 'CC' || variablesObj.evalStatCd == 'PD'){
		disableButton("btnAddEvalDeductible");
		disableButton("btnSaveEvalDed");
		disableSearch("hrefEvalDedCd");
		disableSearch("hrefEvalDedCompany");
		disableInputField("txtEvalDedBaseAmt");
		disableInputField("txtEvalDedRate");
		$("txtEvalDedRate").disable();
		$("txtEvalDedUnits").disable();
		$("txtEvalDedBaseAmt").disable();
		
	}
	
	// bonok :: 11.08.2013
	if(objCLMGlobal.callingForm == "GICLS260"){
		$("evalDeductibleForm").hide();
		$("btnApplyDeductibles").hide();
		$("btnSaveEvalDed").hide();
	}
</script>