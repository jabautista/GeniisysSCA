<div class="sectionDiv" id="lossExpTaxSectionDiv" name="lossExpTaxSectionDiv" style="border: none;">
	<div id="lossExpTaxDiv" name="lossExpTaxDiv" changeTagAttr="true">
		<div id="lossExpTaxTableGridDiv" name="lossExpTaxTableGridDiv" style="margin: 5px;"></div>
		<div class="sectionDiv" style="border: none;">
			<div style="float: right; margin-bottom: 5px;">
				<table>
					<tr>
						<td align="left" style="width: 100px;"><b>Total Tax Amount</b></td>
						<td><input type="text" id="totalTaxAmt" name="totalTaxAmt" class="money" value="0.00" style="width: 130px; margin-right: 10px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="lossExpTaxForm" name="lossExpTaxForm" class="sectionDiv" style="border: none;">
			<table align="center">
				<tr>
					<td align="right" style="width: 100px;">Tax Type</td>
					<td align="left" style="padding-left: 5px;">
						<select class="required" id="selTaxType" name="selTaxType" style="width: 238px;">
							<option value=""></option>
							<option value="I">I - Input Vat</option>
							<option value="W">W - Withholding Tax</option>
							<option value="O">O - Other Taxes</option>
						</select>
					</td>
					<td align="right" style="width: 130px;">Base Amount</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="money required" id="txtTaxBaseAmt" name="txtTaxBaseAmt" style="width: 230px;" readonly="readonly" value=""/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 100px;">Tax</td>
					<td align="left" style="padding-left: 5px;">
						<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtTaxCd" id="txtTaxCd" value="" readonly="readonly"/>
							<img id="hrefTaxCd" alt="goTaxCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td align="right" style="width: 130px;">Tax Percentage</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="required applyDecimalRegExp" regExpPatt="pDeci0309" min="0.000000001" max="100.00" value="" maxlength="13" id="txtTaxPct" name="txtTaxPct" style="width: 230px;" readonly="readonly" value=""/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 100px;">SL Code</td>
					<td align="left" style="padding-left: 5px;">
						<div id="slCodeDiv" name="slCodeDiv" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtSLCode" id="txtSLCode" value="" readonly="readonly"/>
							<img id="hrefSLCode" alt="goSLCode" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td align="right" style="width: 130px;">Tax Amount</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="money required" id="txtTaxAmt" name="txtTaxAmt" style="width: 230px;" readonly="readonly" value=""/>
						<input type="hidden" id="hidTaxId" 	   		name="hidTaxId" 	   	value=""/>
						<input type="hidden" id="hidWTax" 	   		name="hidWTax" 	   		value=""/>
						<input type="hidden" id="hidNetTag"    		name="hidNetTag"    	value=""/>
						<input type="hidden" id="hidAdvTag"    		name="hidAdvTag"    	value=""/>
						<input type="hidden" id="hidSlTypeCd"  		name="hidSlTypeCd"  	value=""/>
						<input type="hidden" id="hidNextTaxId" 		name="hidNextTaxId" 	value="${nextTaxId}"/>
						<input type="hidden" id="hidAllWTax"   		name="hidAllWTax"   	value="${allWTax}"/>
						<input type="hidden" id="hidPayeeSlTypeCd"  name="hidPayeeSlTypeCd" value="${payeeSlTypeCd}"/>
						<input type="hidden" id="hidDisableClmTaxFields"  name=""hidDisableClmTaxFields"" value="${disableClmTaxFields}"/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 100px;">Loss Expense</td>
					<td align="left" style="padding-left: 5px;">
						<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtTaxLossExpCd" id="txtTaxLossExpCd" value="" readonly="readonly"/>
							<img id="hrefTaxLossExpCd" alt="goTaxLossExpCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddLossExpTax" 	   name="btnAddLossExpTax" 	  	class="button"	value="Add" />
			<input type="button" id="btnDeleteLossExpTax"  name="btnDeleteLossExpTax"   class="button"	value="Delete" />			
		</div>
	</div>
</div>

<div class="buttonsDiv" style="margin-bottom: 15px">
	<input type="button" id="btnSaveTax" 		  name="btnSaveTax" 	 	  class="button"	value="Save" 	style="width: 90px;"/>
	<input type="button" id="btnTaxReturn" 	 	  name="btnTaxReturn"  	 	  class="button"	value="Return" 	style="width: 90px;"/>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAllMoneyFields();
	
	if($F("hidDisableClmTaxFields") == "Y"){
		$("txtTaxPct").readOnly = true;
	}else{
		$("txtTaxPct").readOnly = false;
	}

	retrieveLossExpTax();
	populateLossExpTaxForm(null);
	var savingSw = "N";
	
	$("btnTaxReturn").observe("click", function(){
		if(hasPendingLossExpTaxRecords()){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveLossExpTax(true);
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
	
	$("selTaxType").observe("change", function(){
		function onChangeTaxType(){
			$("txtTaxCd").value = "";
			$("txtTaxCd").setAttribute("taxCd", "");
			$("txtSLCode").value = "";
			$("txtTaxLossExpCd").value = "";
			$("txtTaxLossExpCd").setAttribute("lossExpCd", "");
			$("txtTaxBaseAmt").value = "";
			$("txtTaxPct").value = "";
			$("txtTaxAmt").value = "";
			//$("txtTaxBaseAmt").readOnly = false;
			$("hidTaxId").value = "";
			$("hidWTax").value = "";
			$("hidNetTag").value = "";
			$("hidAdvTag").value = "";
			$("hidSlTypeCd").value = "";
			$("slCodeDiv").removeClassName("required");
			setValuesForWTaxAdvTagNetTag();
		}
		if(hasPendingLossExpTaxRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			$("selTaxType").value = "";
			return false;
		}
		if($("selTaxType").value == "I"){
			if(checkLossExpTaxType() == 0){
				onChangeTaxType();
			}else{
				showMessageBox("Vat can only be selected once per settlement", "I");
				$("selTaxType").value = "";
			}
		}else{
			onChangeTaxType();
		}
	});
	
	$("hrefTaxCd").observe("click", function(){
		if(hasPendingLossExpTaxRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		var taxType = $("selTaxType").value;
		if(nvl(taxType, "") == ""){
			showMessageBox("Please enter Tax Type.");
			return false;
		}else{
			var payeeCd = objCurrGICLLossExpPayees.payeeCd;
			getGiisLossTaxesLOV(taxType, payeeCd, $("hidPayeeSlTypeCd").value);	
		}
	});
	
	$("hrefSLCode").observe("click", function(){
		if(hasPendingLossExpTaxRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		var taxCd = $("txtTaxCd").getAttribute("taxCd");
		var taxType = $("selTaxType").value;
		
		if(nvl(taxType, "") == ""){
			showMessageBox("Please enter Tax Type.");
			return false;
		}else if(nvl(taxCd, "") == ""){
			showMessageBox("Please enter Tax Code.");
			return false;
		}else{
			if(taxType == "W"){
				getSlListForTaxTypeW(taxCd, "getSlListForTaxTypeW");
			}else if(taxType == "O"){
				getSlListForTaxTypeW(taxCd, "getSlListForTaxTypeO");
			}else if(taxType == "I"){
				getSlListForTaxTypeW(taxCd, "getSlListForTaxTypeI");
			}
		}
	});
	
	$("hrefTaxLossExpCd").observe("click", function(){
		if(hasPendingLossExpTaxRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		var taxCd = $("txtTaxCd").getAttribute("taxCd");
		var taxType = $("selTaxType").value;
		
		if(nvl(taxType, "") == ""){
			showMessageBox("Please enter Tax Type.");
			return false;
		}else if(nvl(taxCd, "") == ""){
			showMessageBox("Please enter Tax Code.");
			return false;
		}else{
			var clmLossId = objCurrGICLClmLossExpense.claimLossId;
			var payeeType = objCurrGICLLossExpPayees.payeeType;
			
			if(taxType == "I"){
				var allWTax = $("hidAllWTax").value;
				if(allWTax == "N"){
					getLossDtlLOV(clmLossId, payeeType, taxCd, taxType, "getLossDtlRgN");
				}else{
					getLossDtlLOV(clmLossId, payeeType, taxCd, taxType, "getLossDtlRgY");
				}
			}else{
				getLossDtlLOV(clmLossId, payeeType, taxCd, taxType, "getLossDtlWonRg");				
			}
		}
	});
	
	$("txtTaxBaseAmt").observe("blur", function(){
		if(hasPendingLossExpTaxRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		$("txtTaxAmt").value = "";
		if($("txtTaxBaseAmt").value != ""){
			computeTaxAmount();			
		}
	});
	
	$("btnAddLossExpTax").observe("click", function(){
		if(validateAddLossExpTax()){
			var newObj = setLossExpTaxObject();
			giclLossExpTaxTableGrid.addBottomRow(newObj);
			$("hidNextTaxId").value = parseInt($("hidNextTaxId").value) + 1;
			updateTGPager(giclLossExpTaxTableGrid);
			populateLossExpTaxForm(null);
			computeTotalTaxAmount();
			saveLossExpTax(false);
		}
	});
	
	$("btnDeleteLossExpTax").observe("click", function(){
		if(validateDeleteLossExpTax()){
			var delObj = setLossExpTaxObject();
			var index = giclLossExpTaxTableGrid.getCurrentPosition()[1];
			
			for(var i=0; i<objGICLLossExpTax.length; i++){
				var tax = objGICLLossExpTax[i];
				if(parseInt(delObj.claimId) == parseInt(tax.claimId) && parseInt(delObj.clmLossId) == parseInt(tax.clmLossId) &&
				   parseInt(delObj.taxId) == parseInt(tax.taxId) && parseInt(delObj.taxCd) == parseInt(tax.taxCd) && delObj.taxType == tax.taxType){
					delObj.recordStatus = -1;
					objGICLLossExpTax.splice(i,1,delObj);
				}
			}
			giclLossExpTaxTableGrid.deleteVisibleRowOnly(index);
			updateTGPager(giclLossExpTaxTableGrid);
			populateLossExpTaxForm(null);
			computeTotalTaxAmount();	
		}
	});
	
	$("btnSaveTax").observe("click", function(){
		if(hasPendingLossExpTaxRecords()){
			saveLossExpTax(false);
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	
	function saveLossExpTax(closeWindow){
		try{
			var objParameters = new Object();
			objParameters.setGiclLossExpTax  = getAddedAndModifiedJSONObjects(objGICLLossExpTax);
			objParameters.delGiclLossExpTax = getDeletedJSONObjects(objGICLLossExpTax);
			
			new Ajax.Request(contextPath+"/GICLLossExpTaxController", {
				asynchronous: true,
				parameters:{
					action: "saveLossExpTax",
					parameters: JSON.stringify(objParameters) 
				},
				onCreate: function(){
					showNotice("Saving Loss Expense Tax...");
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
									retrieveLossExpTax();
									populateLossExpTaxForm(null);
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
			showErrorMessage("saveLossExpTax", e);	
		}
	}
	
</script>