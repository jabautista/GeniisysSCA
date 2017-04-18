<div id="lossExpDtlTableGridDiv" name="lossExpDtlTableGridDiv"></div>
<div class="sectionDiv" style="border: none;">
	<div style="float: right; margin-right: 15px; margin-top: 5px;">
		<table>
			<tr>
				<td class="leftAligned" style="width: 40px;"><b>Total</b></td>
				<td><input type="text" id="totalLossAmt" name="totalLossAmt" class="money" value="0.00" style="width: 155px;" readonly="readonly"/></td>
				<td><input type="text" id="totalAmtLessDed" name="totalAmtLessDed" class="money" value="0.00" style="width: 155px;" readonly="readonly"/></td>
			</tr>
		</table>
	</div>
</div>
<div id="lossExpDtlForm" name="lossExpDtlForm" class="sectionDiv" style="border: none;"  changeTagAttr="true">
	<table align="center">
		<tr style="height: 20px;">
			<td></td>
			<td class="leftAligned">
				<div style="float: left; width: 70px;">
					<div style="float: left;"><input type="radio" id="radioUW" name="distRG" value="1" checked="checked" disabled="disabled"/></div>
					<div style="float: left;">UW</div>
				</div>
				<div style="float: left; width: 70px;">
					<div style="float: left;"><input type="radio" id="radioReserve" name="distRG" value="2" disabled="disabled"/></div>
					<div style="float: left;">Reserve</div>
				</div>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 130px;">Loss</td>
			<td class="leftAligned">
				<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
					<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtLoss" id="txtLoss" value="" readonly="readonly"/>
					<img id="hrefLoss" alt="goLoss" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>
			</td>
			<td class="rightAligned" style="width: 150px;">Base Amount</td>
			<td class="leftAligned">
				<input type="text" class="money4 required" id="txtBaseAmt" name="txtBaseAmt" lastValidValue="" style="width: 230px;" value="" readonly="readonly"/> <!-- modified by kenneth : 05262015 : SR 3637 -->
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 130px;">Unit(s)</td>
			<td class="leftAligned">
				<input type="text" class="required rightAligned integerNoNegativeUnformatted" id="txtUnits" name="txtUnits" style="width: 230px;" value="" readonly="readonly" maxlength="5"/>
			</td>
			<td class="rightAligned" style="width: 150px;">Loss Amount</td>
			<td class="leftAligned">
				<input type="text" class="money" id="txtLossAmt" name="txtLossAmt" style="width: 230px;" value="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned">
				<div style="float: left; width: 165px;">
					<div style="float: left;"><input type="checkbox" id="chkOriginalSw" name="chkOriginalSw" style="width:16px; height:16px;" value=""/></div>
					<div style="float: left;">Tag for Orig. Amount</div>
				</div>
				<div style="float: left; width: 150px;">
					<div style="float: left;"><input type="checkbox" id="chkWithTax" name="chkWithTax" style="width:16px; height:16px;" value=""/></div>
					<div style="float: left;">With Tax</div>
				</div>
			</td>
			<td class="rightAligned" style="width: 150px;">Amount Less Deductibles</td>
			<td class="leftAligned">
				<input type="text" class="money" id="txtAmtLessDed" name="txtAmtLessDed" style="width: 230px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
</div>
<div id="hidLossExpDtlDiv" name="hidLossExpDtlDiv" style="display: none;">
	<input id="hidNbtCompSw" 	name="hidNbtCompSw" 	value=""/>
	<input id="hidLossExpClass" name="hidLossExpClass" 	value=""/>
	<input id="hidSublineCd" 	name="hidSublineCd" 	value=""/>
	<input type="hidden" id="hidenableLeBaseAmt" 		name="hidenableLeBaseAmt" 	 	value="${enableLeBaseAmt}"/>
</div>
<div class="buttonsDiv" style="margin-bottom: 5px"  changeTagAttr="true">
	<input type="button" id="btnAddLossExpDtl" 	  name="btnAddLossExpDtl" 	  class="button"	value="Add" />
	<input type="button" id="btnDeleteLossExpDtl" name="btnDeleteLossExpDtl"  class="button"	value="Delete" />			
</div>
<div class="buttonsDiv" style="margin-bottom: 15px">
	<input type="button" id="btnDeductibles" 	 name="btnDeductibles" 	 class="button"		value="Deductibles" />
	<input type="button" id="btnDepreciation" 	 name="btnDepreciation"  class="button"		value="Depreciation" />
	<input type="button" id="btnLossTax" 	 	 name="btnLossTax"  	 class="button"		value="Loss Tax" />			
</div>

<script type="text/javascript">
	$("btnAddLossExpDtl").observe("click", function(){
		if(validateAddGiclLossExpDtl()){
			var baseAmt = unformatCurrencyValue($("txtBaseAmt").value);
			if((parseFloat(nvl(baseAmt, 0)) > parseFloat(objCurrGICLItemPeril.annTsiAmt)) && objCurrGICLLossExpPayees.payeeType == "L"){ //(objCurrGICLLossExpPayees.payeeType == "L") Added by Kenneth 06152015 SR 3622
				customShowMessageBox("Total loss amount should not be greater than the TSI Amount.", "I", "txtBaseAmt");
				$("txtBaseAmt").value = "";
				return false;
			}else{
				savedFromLossExpDtl = "Y"; //added by robert GENQA 5027 11.04.15
				addGiclLossExpDtl();				
			}	
		}
	});
	
	$("btnDeleteLossExpDtl").observe("click", function(){
		if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
			showMessageBox("You cannot delete this record.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
			showMessageBox("You cannot delete this record.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
			showMessageBox("You cannot delete this record.", "I");
			return false;
		}else{
			savedFromLossExpDtl = "Y";  //added by robert GENQA 5027 11.04.15
			deleteGiclLossExpDtl();
		}
		
	});
	
	$("btnDeductibles").observe("click", function(){
		if(changeTag == 1 || checkLossExpChildRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees == null){
			showMessageBox("Please select a payee first.", "I");
			return false;
		}else if(objCurrGICLClmLossExpense == null){
			showMessageBox("Please select a history record first.", "I");
			return false;
		}else if(objCurrGICLLossExpDtl == null){
			showMessageBox("Please select a history detail record first.", "I");
			return false;
		}else{
			showLossExpDeductibles();	
		}
	});
	
	$("btnLossTax").observe("click", function(){
		if(changeTag == 1 || checkLossExpChildRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees == null){
			showMessageBox("Please select a payee first.", "I");
			return false;
		}else if(objCurrGICLClmLossExpense == null){
			showMessageBox("Please select a history record first.", "I");
			return false;
		}else{
			showLossExpTax();	
		}
	});
	
	$("btnDepreciation").observe("click", function(){
		validateIfToComputeDepreciation("N");
	});
	
	function getOrigSurplusAmt(){ //Function added by Kenneth L. 06.11.2015 SR 3626 @lines 161 - 188
		try{
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "getOrigSurplusAmt",		
						      claimId :nvl(objCurrGICLItemPeril.claimId, 0),
							  itemNo : nvl(objCurrGICLItemPeril.itemNo, 0),
							  lossExpCd : $("txtLoss").getAttribute("lossExpCd"),
							  tag: $("chkOriginalSw").checked ? "Y" : "N"},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						 var result = JSON.parse(response.responseText);
						 $("txtBaseAmt").setAttribute("lastValidValue", $F("txtBaseAmt"));
						 if(result.amount == null){
							 $("txtBaseAmt").value = formatCurrency(nvl($("txtBaseAmt").readAttribute("lastValidValue"),0));
						 }else{
							 $("txtBaseAmt").value = formatCurrency(result.amount);	 
						 }
						 fireEvent($("txtBaseAmt"), "change");
					}
				} 
			}); 
		} catch(e){
			showErrorMessage("getOrigSurplusAmt", e);
		}
	}
	
	$("chkOriginalSw").observe("click", function(){
		if(objCLMGlobal.lineCd != "MC" && objCLMGlobal.menuLineCd != "MC"){
			showMessageBox("Original switch field is only updateable for line " + $("hidMCLineName").value+ ".", "I");
			$("chkOriginalSw").checked = false;
			return false;
		}else if(nvl($("hidNbtCompSw").value, "+") == "-" || nvl($("hidLossExpClass").value, "L") != "P"){
			showMessageBox("Only loss expense record with expense class is equal to PARTS can be tagged as original.", "I");
			$("chkOriginalSw").checked = false;
			return false;
		}else{
			getOrigSurplusAmt();
		}
	});
	
	$("txtBaseAmt").observe("change", function(){
		if(hasPendingLossExpDtlRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			populateLossExpDtlForm(null);
			return false;
		}else{
			if(objCurrGICLItemPeril != null){
				var baseAmt = unformatCurrencyValue($("txtBaseAmt").value);
				function proceedOnChange(){
					if((parseFloat(nvl(baseAmt, 0)) > parseFloat(objCurrGICLItemPeril.annTsiAmt)) && objCurrGICLLossExpPayees.payeeType == "L"){
						showWaitingMessageBox("Total loss amount should not be greater than the TSI Amount.", "I", function(){
							$("txtBaseAmt").value = $("txtBaseAmt").readAttribute("lastValidValue");
							$("txtBaseAmt").focus();
							computeLossAndNetAmounts();
						});
					//} else if (baseAmt > 99999999999999.99 || baseAmt < 1) { //Added by Kenneth 06.16.2015 SR 3622 @lines 218 - 223 comment out by Aliza G 
					} else if (baseAmt > 99999999999999.99 || baseAmt < .01) { //Added by Aliza G. 01.26.2016 SR 21464  
						showWaitingMessageBox("Invalid Amount Covered. Value should be from 0.01 to 99,999,999,999,999.99.", "I", function(){ //changed the text from 1 to 0.01 Aliza G SR 21464
							$("txtBaseAmt").value = $("txtBaseAmt").readAttribute("lastValidValue");
							$("txtBaseAmt").focus();
							computeLossAndNetAmounts();
						});
					} else {
						$("txtBaseAmt").setAttribute("lastValidValue", $F("txtBaseAmt"));
						computeLossAndNetAmounts();
					}
				}
				if($("hidMCTowing").value == $("txtLoss").getAttribute("lossExpCd") && (objCLMGlobal.menuLineCd == "MC" || objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC)){
					showConfirmBox("Confirmation", " Do you want to change the default tow amount?", "Yes", "No", 
							proceedOnChange, function(){
												$("txtBaseAmt").value = $("txtBaseAmt").readAttribute("lastValidValue");
												$("txtBaseAmt").focus();
												computeLossAndNetAmounts();
											});
				}else{
					proceedOnChange();
				}
			} else {
				$("txtBaseAmt").setAttribute("lastValidValue", $F("txtBaseAmt"));
				computeLossAndNetAmounts();
			}		
		}
	});
	
	$("txtUnits").observe("blur", function(){
		if(hasPendingLossExpDtlRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			populateLossExpDtlForm(null);
			return false;
		}else{
			computeLossAndNetAmounts();			
		}
	});
	
</script>