<div class="sectionDiv" id="lossExpBillSectionDiv" name="lossExpBillSectionDiv" style="border: none;">
	<div id="lossExpBillDiv" name="lossExpBillDiv">
		<div id="lossExpBillTableGridDiv" name="lossExpBillTableGridDiv" style="margin: 5px;"></div>
		<div id="lossExpBillForm" name="lossExpBillForm" class="sectionDiv" style="border: none; margin-top: 10px;">
			<table align="center">
				<tr>
					<td align="right" style="width: 80px;">Type</td>
					<td align="left" style="padding-left: 5px;">
						<select class="required" id="selDocType" name="selDocType" style="width: 238px;">
							<option value="1">Invoice</option>
							<option value="2">Bill</option>
						</select>
					</td>
					<td align="right" style="width: 80px;">Bill Date</td>
					<td align="left" style="padding-left: 5px;">
						<div style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtBillDate" id="txtBillDate" value="" readonly="readonly"/>
							<img id="hrefBillDate" alt="goBillDate" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtBillDate').focus(); scwShow($('txtBillDate'),this, null);" />
						</div>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 80px;">Payee Class</td>
					<td align="left" style="padding-left: 5px;">
						<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtBillPayeeClassCd" id="txtBillPayeeClassCd" value="" readonly="readonly"/>
							<img id="hrefBillPayeeClassCd" alt="goBillPayeeClassCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td align="right" style="width: 80px;">Number</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="required" id="txtDocNumber" name="txtDocNumber" style="width: 230px;" value="" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 80px;">Payee</td>
					<td align="left" style="padding-left: 5px;">
						<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtBillPayeeCd" id="txtBillPayeeCd" value="" readonly="readonly"/>
							<img id="hrefBillPayeeCd" alt="goBillPayeeCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td align="right" style="width: 80px;">Amount</td>
					<td align="left" style="padding-left: 5px;">
						<input type="text" class="money" id="txtBillAmt" name="txtBillAmt" style="width: 230px;" value=""/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 80px;">Remarks</td>
					<td align="left" style="padding-left: 5px;" colspan="3">
						<div style="float: left; border: solid 1px gray; width: 566px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 540px; border: none; background-color: transparent;" name="txtBillRemarks" id="txtBillRemarks" value="" onKeyDown="limitText(this, 4000);" onKeyUp="limitText(this, 4000);"/>
							<img id="hrefBillRemarks" alt="goBillRemarks" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddLossExpBill" 	 name="btnAddLossExpBill" 	  	class="button"	value="Add" />
			<input type="button" id="btnDeleteLossExpBill"   name="btnDeleteLossExpBill"   class="button"	value="Delete" />			
		</div>
	</div>
</div>

<div class="buttonsDiv" style="margin-bottom: 15px">
	<input type="button" id="btnSaveBill" 		  name="btnSaveBill" 	 	  class="button"	value="Save" 	style="width: 90px;"/>
	<input type="button" id="btnBillReturn" 	  name="btnBillReturn"  	 	  class="button"	value="Return" 	style="width: 90px;"/>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAllMoneyFields();
	retrieveLossExpBillListing();
	populateLossExpBillForm(null);
	objGICLLossExpBill = [];
	
	$("btnBillReturn").observe("click", function(){
		if(hasPendingLossExpBillRecords()){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveLossExpBill();
					}, 
					function(){
						lossExpHistWin.close();},
					"");
		}else{
			lossExpHistWin.close();	
		}
	});
		
	$("hrefBillPayeeClassCd").observe("click", function(){
		showLossExpPayeeClassLov("billInfo");
	});
	
	$("hrefBillPayeeCd").observe("click", function(){
		var payeeClassCd = $("txtBillPayeeClassCd").getAttribute("payeeClassCd");
		var payeeType = unescapeHTML2(objCurrGICLLossExpPayees.payeeType);
		
		if(nvl(payeeClassCd, "") == ""){
			showMessageBox("Please enter payee class first.");
		}else if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
			showMessageBox("Record cannot be updated. Loss for this peril has been closed/withdrawn/denied.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
			showMessageBox("Record cannot be updated. Expense for this peril has been closed/withdrawn/denied.", "I");
			return false;
		}else if(payeeClassCd == $("hidAdjpClassCd").value){
			showLEBillAdjusterLov(objCurrGICLItemPeril, payeeClassCd, payeeType);
		}else{
			showLEBillPayeeLov(objCurrGICLItemPeril, payeeClassCd, payeeType);
		}
	});
	
	function checkIfLossExpBillAlreadyExist2(newObj){	//Added by: Jerome Bautista 05.28.2015 SR 3646
	new Ajax.Request(contextPath+"/GICLLossExpBillController", {
		asynchronous: false,
		evalScripts: true,
		parameters:{
			action: 		"chkGiclLossExpBill",
			payeeClassCd: 	$("txtBillPayeeClassCd").getAttribute("payeeClassCd"),
			payeeCd: 		$("txtBillPayeeCd").getAttribute("payeeCd"),
			docType: 		$("selDocType").value,
			docNumber: 		escapeHTML2($("txtDocNumber").value)
		},
		onComplete: function(response){
			if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
				var lossExpBill = JSON.parse(response.responseText);
				var str = lossExpBill.message;
				if(lossExpBill.counter == 1){
					showConfirmBox("Confirmation", "Another claim uses the same Bill/Invoice number ("+ str.substring(0,str.length-1) +"). Would you like to continue ?","Ok","Cancel",
							function(){ 
						giclLossExpBillTableGrid.addBottomRow(newObj);
						updateTGPager(giclLossExpBillTableGrid);
						},null);
				}else if(lossExpBill.counter > 1){
					showConfirmBox("Confirmation", "Various other claims use the same Bill/Invoice number ("+ str.replace(str.substring(20,str.length)," etc") + "). Would you like to continue ?","Ok","Cancel",
							function(){ 
						giclLossExpBillTableGrid.addBottomRow(newObj);
						updateTGPager(giclLossExpBillTableGrid);
						},null);
				}else{
					giclLossExpBillTableGrid.addBottomRow(newObj);
					updateTGPager(giclLossExpBillTableGrid);
				}
			}
	}});
	}
	
	$("btnAddLossExpBill").observe("click", function(){
		if(validateAddLossExpBill()){
			var newObj = setLossExpBillObject();
			if($("btnAddLossExpBill").value == "Update"){
				for(var i=0; i<objGICLLossExpBill.length; i++){
					var bill = objGICLLossExpBill[i];
					if(parseInt(newObj.claimId) == parseInt(bill.claimId) && parseInt(newObj.claimLossId) == parseInt(bill.claimLossId) && parseInt(newObj.payeeClassCd) == parseInt(bill.payeeClassCd) && 
					   parseInt(newObj.payeeCd) == parseInt(bill.payeeCd) && newObj.docType == bill.docType && newObj.docNumber == bill.docNumber){
						newObj.recordStatus = 1;
						objGICLLossExpBill.splice(i,1,newObj);
						giclLossExpBillTableGrid.updateVisibleRowOnly(newObj, giclLossExpBillTableGrid.getCurrentPosition()[1]);
					}
				}
			}else{
				if(checkIfLossExpBillAlreadyExist(newObj)){
					showMessageBox("Record already exists.", "I");
					return false;
				}else{
					checkIfLossExpBillAlreadyExist2(newObj); //Added by: Jerome Bautista 05.28.2015 SR 3646
					//giclLossExpBillTableGrid.addBottomRow(newObj);
					//updateTGPager(giclLossExpBillTableGrid);
					// Commented out by: Jerome Bautista 05.28.2015 SR 3646
				}
			}
			populateLossExpBillForm(null);
		}
	});
	
	$("btnDeleteLossExpBill").observe("click", function(){
		if(validateDeleteLossExpBill()){
			var delObj = setLossExpBillObject();
			var index = giclLossExpBillTableGrid.getCurrentPosition()[1];
			
			for(var i=0; i<objGICLLossExpBill.length; i++){
				var bill = objGICLLossExpBill[i];
				if(parseInt(delObj.claimId) == parseInt(bill.claimId) && parseInt(delObj.claimLossId) == parseInt(bill.claimLossId) && parseInt(delObj.payeeClassCd) == parseInt(bill.payeeClassCd) && 
				   parseInt(delObj.payeeCd) == parseInt(bill.payeeCd) && delObj.docType == bill.docType && delObj.docNumber == bill.docNumber){
					delObj.recordStatus = -1;
					objGICLLossExpBill.splice(i,1,delObj);
				}
			}
			giclLossExpBillTableGrid.deleteVisibleRowOnly(index);
			updateTGPager(giclLossExpBillTableGrid);
			populateLossExpBillForm(null);
		}
	});
	
	$("btnSaveBill").observe("click", function(){
		if(hasPendingLossExpBillRecords()){
			saveLossExpBill();
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	
	function saveLossExpBill(){
		try{
			var objParameters = new Object();
			objParameters.setGiclLossExpBill  = getAddedAndModifiedJSONObjects(objGICLLossExpBill);
			objParameters.delGiclLossExpBill = getDeletedJSONObjects(objGICLLossExpBill);
			
			new Ajax.Request(contextPath+"/GICLLossExpBillController", {
				asynchronous: true,
				parameters:{
					action: "saveLossExpBill",
					parameters: JSON.stringify(objParameters) 
				},
				onCreate: function(){
					showNotice("Saving Loss Expense Bill Information...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", 
							function(){
								retrieveLossExpBillListing();
								clearObjectRecordStatus(objGICLLossExpBill);
								changeTag = 0;
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
			showErrorMessage("saveLossExpBill", e);	
		}
	}
	
</script>