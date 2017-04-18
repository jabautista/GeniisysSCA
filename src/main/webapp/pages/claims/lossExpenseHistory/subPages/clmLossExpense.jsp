	<div id="clmLossExpenseTableGridDiv" name="clmLossExpenseTableGridDiv"></div>	
<div id="clmLossExpenseForm" name="clmLossExpenseForm" class="sectionDiv" style="border: none; margin-top: 10px;" changeTagAttr="true">
	<table align="center">
		<tr>
			<td class="rightAligned" style="width: 130px;">History Sequence No.</td>
			<td class="leftAligned">
				<input type="text" class="integerNoNegativeUnformatted required" id="txtHistSeqNo" name="txtHistSeqNo" style="width: 230px; text-align: right;" value="" min="1" max="999" maxlength="3"/>
			</td>
			<td class="rightAligned" style="width: 150px;">Loss Paid Amount</td>
			<td class="leftAligned">
				<input type="text" class="money" id="txtLossPaidAmt" name="txtLossPaidAmt" style="width: 230px;" value="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 130px;">History Status</td>
			<td class="leftAligned">
				<div class="required" style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
					<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none; background-color: transparent;" name="txtHistStatus" id="txtHistStatus" value="" readonly="readonly"/>
					<img id="hrefHistStatus" alt="goHistStatus" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>
			</td>
			<td class="rightAligned" style="width: 150px;">Loss Net Amount</td>
			<td class="leftAligned">
				<input type="text" class="money" id="txtLossNetAmt" name="txtLossNetAmt" style="width: 230px;" value=""  readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 130px;">Remarks</td>
			<td class="leftAligned">
				<div style="float: left; border: solid 1px gray; width: 236px; height: 20px;">
					<input type="text" style="float: left; margin-top: 0px; width: 210px; border: none;" name="txtRemarks" id="txtRemarks" value="" maxlength="4000"/>
					<img id="hrefRemarks" alt="goRemarks" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
				</div>
			</td>
			<td class="rightAligned" style="width: 150px;">Loss Advice Amount</td>
			<td class="leftAligned">
				<input type="text" class="money" id="txtLossAdviceAmt" name="txtLossAdviceAmt" style="width: 230px;" value=""  readonly="readonly"/>
			</td>
		</tr>
		<tr style="height: 20px;">
			<td></td>
			<td></td>
			<td></td>
			<td class="leftAligned">
				<div style="float: left; width: 120px;">
					<div style="float: left;"><input type="checkbox" id="chkExGratia" name="chkExGratia" style="width:16px; height:16px;" value=""/></div>
					<div style="float: left;">Ex-Gratia</div>
				</div>
				<div style="float: left; width: 120px;">
					<div style="float: left;"><input type="checkbox" id="chkFinalTag" name="chkFinalTag" style="width:16px; height:16px;" value=""/></div>
					<div style="float: left;">Final Tag</div>
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="clmLossExpHidDiv" name="clmLossExpHidDiv" style="display: none;">
	<input type="hidden" id="hidClmLossId" 		 name="hidClmLossId" 		value="">
	<input type="hidden" id="hidDistSw" 		 name="hidDistSw" 			value="">
	<input type="hidden" id="hidCancelSw" 		 name="hidCancelSw" 		value="">
	<input type="hidden" id="hidWithLossExpDtl"  name="hidWithLossExpDtl" 	value="">
</div>
<div class="buttonsDiv" style="margin-bottom: 15px">
	<input type="button" id="btnAddClmLossExp" 	  name="btnAddClmLossExp" 	  class="button"	value="Add" />
	<input type="button" id="btnDeleteClmLossExp" name="btnDeleteClmLossExp"  class="button"	value="Delete" />
	<input type="button" id="btnCopyClmLossExp"   name="btnCopyClmLossExp"    class="button"	value="Copy History" />			
</div>

<script type="text/javascript">
	$("chkFinalTag").observe("change", function(){ // ante 11/7/2013
		enableButton("btnAddClmLossExp");
	});

	$("chkExGratia").observe("change", function(){ // ante 11/7/2013
		enableButton("btnAddClmLossExp");
	});

	$("txtRemarks").observe("change", function(){ //Kenneth L. //05.22.2015 //To enable Add button when remarks field is updated, if record is already distributed. SR 3618
		enableButton("btnAddClmLossExp");
	});
	
	$("txtHistSeqNo").observe("blur", function(){
		$("txtHistSeqNo").value = lpad($("txtHistSeqNo").value, 3, "0");	
	});
	
	//modified btnAddClmLossExp on click functionality to handle adding of duplicate history sequence no. //Kenneth 06.16.2015
	$("btnAddClmLossExp").observe("click", function(){
		if(validateAddGiclClmLossExpense()){
			var addedSameExists = false;
			var deletedSameExists = false;	
			for(var i=0; i<objGICLClmLossExpense.length; i++){
				if(objGICLClmLossExpense[i].recordStatus == 0 || objGICLClmLossExpense[i].recordStatus == 1){	
					if(formatNumberDigits(objGICLClmLossExpense[i].historySequenceNumber, 3) == $F("txtHistSeqNo")){
						addedSameExists = true;								
					}							
				} else if(objGICLClmLossExpense[i].recordStatus == -1){
					if(formatNumberDigits(objGICLClmLossExpense[i].historySequenceNumber, 3) == $F("txtHistSeqNo")){
						deletedSameExists = true;
					}
				}
			}
			if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				if(!($("txtHistSeqNo").value == formatNumberDigits($("txtHistSeqNo").getAttribute("lastValidValue"), 3))){
					showMessageBox("Record already exists with the same hist_seq_no.", "E");
					$("txtHistSeqNo").value = nvl(formatNumberDigits($("txtHistSeqNo").getAttribute("lastValidValue"), 3), lpad(getNextHistSeqNo(), 3, "0"));
					return;
				}
			} else if(deletedSameExists && !addedSameExists){
				if(nvl($("hidCheckPLA").value, "N") == "Y"){
					validateHistSeqNo();
				}else{
					addGiclClmLossExpense();
				}
			}
			if(!($("txtHistSeqNo").value == formatNumberDigits($("txtHistSeqNo").getAttribute("lastValidValue"), 3))){
				new Ajax.Request(contextPath + "/GICLClaimLossExpenseController", {
					parameters : {action : "checkHistoryNumber",
								  claimId: nvl(objCurrGICLLossExpPayees.claimId, 0),
								  itemNo: nvl(objCurrGICLLossExpPayees.itemNo, 0),
								  perilCd: nvl(objCurrGICLLossExpPayees.perilCd, 0),
								  groupedItemNo : objCurrGICLLossExpPayees.groupedItemNo,
								  payeeType : objCurrGICLLossExpPayees.payeeType,
								  payeeClassCd : objCurrGICLLossExpPayees.payeeClassCd,
								  payeeCd : objCurrGICLLossExpPayees.payeeCd,
								  histSeqNo : $F("txtHistSeqNo")},
				  	asynchronous: false,
				    evalScripts: true,
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							if(nvl($("hidCheckPLA").value, "N") == "Y"){
								validateHistSeqNo();
							}else{
								addGiclClmLossExpense();
							}
						}else{
							$("txtHistSeqNo").value = nvl(formatNumberDigits($("txtHistSeqNo").getAttribute("lastValidValue"), 3), lpad(getNextHistSeqNo(), 3, "0"));
							return;
						}
					}
				});
			}else{
				if(nvl($("hidCheckPLA").value, "N") == "Y"){
					validateHistSeqNo();
				}else{
					addGiclClmLossExpense();
				}
			}
		}
	});
	
	$("btnDeleteClmLossExp").observe("click", function(){
		var index = giclClmLossExpenseTableGrid.getCurrentPosition()[1];
		
		if(checkLossExpChildRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else if(nvl(objCurrGICLClmLossExpense.withLossExpTax, "N") == "Y" ||
		   nvl(objCurrGICLClmLossExpense.withLossExpDs, "N") == "Y" ||
		   nvl(objCurrGICLClmLossExpense.withGiclAdvice, "N") == "Y"){
			showMessageBox("Cannot delete master record when matching detail records exist.", "I");
			disableButton("btnDeleteClmLossExp");
		}else{
			var delObj = setGiclClmLossExpObject();
			delObj.recordStatus = -1;
			replaceClmLossExpObject(delObj);
			giclClmLossExpenseTableGrid.deleteVisibleRowOnly(index);
			clearAllRelatedClmLossExpRecords();
			changeTag = 1;
		}
	});
	
	$("btnCopyClmLossExp").observe("click", function(){
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees == null){
			showMessageBox("Please select a payee first.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
			showMessageBox("Cannot create another history. Loss for this peril has been closed/withdrawn/denied.", "I");
			return false;
		}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
			showMessageBox("Cannot create another history. Expense for this peril has been closed/withdrawn/denied.", "I");
			return false;
		}else if(changeTag == 1 || checkLossExpChildRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else if(objGICLClmLossExpense.length == 0){
			showMessageBox("There is no history to be copied.", "I");
			return false;
		}else if(nvl($("hidCheckPLA").value, "N") == "Y"){
			validateHistSeqNo("Y");
		}else{
			createAnotherHistory();				
		}
	});
	
</script>