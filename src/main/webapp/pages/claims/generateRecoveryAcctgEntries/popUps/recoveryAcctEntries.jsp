<div id="recoveryAcctEntriesMainDiv" class="sectionDiv" style="height: 480px;">
	<table align="center" style="margin-top: 5px; ">
		<tr>
			<td class="rightAligned">Tran No:</td>
			<td class="leftAligned" width="30%">
				<input type="text" id="dspTranNo" name="dspTranNo" value="${tranNo}"  />
			</td>
			<td class="rightAligned">Tran Date:</td>
			<td class="leftAligned" width="30%">
				<input type="text" id="dspTranDate" name="dspTranDate" value="${tranDate}"  />
			</td>
		</tr>
	</table>
	<div id="hiddenAEParamsDiv">
		<!-- <input type="hidden" id="hidRecAcctId" 		name="hidRecAcctId" 	value="" /> -->
		<input type="hidden" id="hidPayorCd" 		name="hidPayorCd" 		value="" />
		<input type="hidden" id="hidPayorClassCd" 	name="hidPayorClassCd" 	value="" />
	</div>
	<div id="recoveryAcctEntriesGridDiv" style="padding: 5px; margin-left: 15px; margin-top: 5px;">
		<div id="recoveryAcctEntriesTableGrid" style="height: 130px; width: 620px;"></div>
	</div>
	<div id="recAESumDiv" style="margin-top: 75px; margin-right: 19px;">
		<table align="right">
			<tr>
				<td class="rightAligned" width="70px;">Totals: </td>
				<td class="leftAligned" width="120px;">
					<input type="text" id="dspTotalDebit" name="dspTotalDebit" style="width: 110px" class="money2" value="" />
				</td>
				<td class="leftAligned" width="120px;">
					<input type="text" id="dspTotalCredit" name="dspTotalCredit" style="width: 110px" class="money2" value="" />
				</td>
			</tr>
		</table>
	</div>
	<div id="recAEFormDiv" style="margin-top: 115px; margin-bottom: 10px;">
		<table align="center">
			<tr>
				<td class="rightAligned" style="width: 130px;">GL Account Code</td>
				<td class="leftAligned" style="width: 400px;">
					<div id="glCodeDiv" style="float: left;">
						<input type="hidden" id="inputGlAcctId" name="inputGlAcctId" value="" />
						<input type="text" style="width: 22px;" id="inputGlAcctCtgy" 	name="glAccountCode" maxlength="2"  value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="201" />
						<input type="text" style="width: 22px;" id="inputGlCtrlAcct" 	name="glAccountCode" maxlength="2"  value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="202" />
						<input type="text" style="width: 22px;" id="inputSubAcct1" 		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="203" />
						<input type="text" style="width: 22px;" id="inputSubAcct2" 		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="204" />
						<input type="text" style="width: 22px;" id="inputSubAcct3"		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="205" />
						<input type="text" style="width: 22px;" id="inputSubAcct4"		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="206" />
						<input type="text" style="width: 22px;" id="inputSubAcct5"		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="207" />
						<input type="text" style="width: 22px;" id="inputSubAcct6"		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="208" />
						<input type="text" style="width: 22px;" id="inputSubAcct7"		name="glAccountCode" maxlength="2"	value="" class="rightAligned list required integerNoNegativeUnformattedNoComma" tabindex="209" />
					</div>
			
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Account Name: </td>
				<td class="leftAligned">
					<div style="float: left; width: 326px; border: 1px solid gray; height: 20px;" class="required">
						<input type="hidden" id="hidSlTypeCd"		name="hidSlTypeCd" 		value="" />
						<input type="hidden" id="hidAcctEntryId"	name="hidAcctEntryId"	value="" />
						<input type="hidden" id="hidGenType"	    name="hidGenType" 	    value="" /> <!-- benjo 08.27.2015 UCPBGEN-SR-19654 -->
						
						<input type="text" style="width: 295px; float: left; border: none; height: 15px; padding-top: 0px;" id="inputGlAcctName" name="inputGlAcctName" value="" readonly="readonly" class="required" tabindex="210"/>
						<img id="searchGlAcct" name="searchGlAcct" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">SL Name: </td>
				<td class="leftAligned">
					<div id="selectSlDiv" style="float: left; width: 326px; border: 1px solid gray; height: 20px;">
						<input type="hidden" id="inputSlCd" name="inputSlCd" value="" />
						<input type="text" id="inputSlName" name="inputSlName" style="width: 295px; float: left; border: none; height: 15px; padding-top: 0px;" value="" readonly="readonly" tabindex="211" />
						<img id="searchSlCd" name="searchSlCd" alt="Go" style="float: right" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Debit Amount: </td>
				<td class="leftAligned">
					<input type="text" style="width: 320px;" id="inputDebitAmt" name="inputDebitAmt" class="required applyDecimalRegExp rightAligned" min="-99999999999999.99" max="99999999999999.99" regExpPatt="nDeci1402" hasOwnChange="Y" maxlength="17" tabindex="212" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Credit Amount: </td>
				<td class="leftAligned">
					<input type="text" style="width: 320px;" id="inputCreditAmt" name="inputCreditAmt" class="required applyDecimalRegExp rightAligned" min="-99999999999999.99" max="99999999999999.99" regExpPatt="nDeci1402" hasOwnChange="Y" maxlength="17" tabindex="213" />
				</td>
			</tr>
		</table>
		<div class="buttonsDiv" style="margin-bottom: 2px; margin-top: 4px;">
			<input type="button" id="btnAddAE" 		name="btnAddAE" 	class="button" value="Add" 		style="margin-left: 1px;" tabindex="214" />
			<input type="button" id="btnDeleteAE" 	name="btnDeleteAE" 	class="button" value="Delete" 	style="margin-left: 10px;" tabindex="215" />
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin-bottom: 0;">
	<input type="button" id="btnSaveRecAE" 			name="btnSaveRecAE" 		class="button" value="Save" style="margin-left: 1px;" />
	<input type="button" id="btnExitRecAE" 			name="btnExitRecAE" 		class="button" value="Return" style="margin-left: 8px;" />
	<input type="button" id="btnPrintAcctEntries" 	name="btnPrintAcctEntries" 	class="button" value="Print Acctg. Entries" style="margin-left: 8px;" />
</div>

<script>
	var selectedAERow = null;
	var selectedAEIndex = null;
	var recPaytRow = recPaytGrid.getRow($F("selectedPaytIndex"));
	var formDisabled = false;
	
	if($F("c042AcctTranId") == "" || $F("c042AcctTranId") == null) {
		/* $$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
			row.removeAttribute("readonly");
		}); */
		disableButton($("btnDeleteAE")); //benjo 08.27.2015 UCPBGEN-SR-19654
		formDisabled = false;
	} else {
		$$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
			row.setAttribute("readonly", "readonly");
		});
		disableButton("btnAddAE");
		disableButton("btnDeleteAE");
		disableButton("btnSaveRecAE"); //benjo 08.27.2015 UCPBGEN-SR-19654
		$("inputDebitAmt").setAttribute("readonly", "readonly"); //benjo 08.27.2015 UCPBGEN-SR-19654
		$("inputCreditAmt").setAttribute("readonly", "readonly"); //benjo 08.27.2015 UCPBGEN-SR-19654
		$("searchGlAcct").hide();
		$("searchSlCd").hide();
		formDisabled = true;
	}
	
	function validateRecAEInputs() {
		try {
			var valid = true;
			if($F("inputGlAcctName") == "" || $F("inputGlAcctCtgy") == "" || $F("inputGlCtrlAcct") == "") {
				showMessageBox("Account Name is required.", imgMessage.ERROR);
				valid = false;
			} else if(($F("inputDebitAmt").blank() || formatCurrency($F("inputDebitAmt")) == "0.00") && 
					($F("inputCreditAmt").blank() || formatCurrency($F("inputCreditAmt")) == "0.00")) {
				showMessageBox("Either debit or credit must have a value.", imgMessage.ERROR);
				valid = false;
			}
			return valid;
		} catch(e) {
			showErrorMessage("validateRecAEInputs", e);
		}
	}
	
	function populateRecAEFields(row) {
		try {
			$("inputGlAcctId").value = row == null ? "" : row.glAcctId;
			$("hidAcctEntryId").value = row == null ? "" : row.acctEntryId;
			$("inputGlAcctName").value = row == null ? "" : row.dspGlAcctName;
			$("inputGlAcctCtgy").value = row == null ? "" : row.glAcctCategory;
			$("inputGlCtrlAcct").value = row == null ? "" : row.glControlAcct;
			$("inputSubAcct1").value = row == null ? "" : row.glSubAccount1;
			$("inputSubAcct2").value = row == null ? "" : row.glSubAccount2;
			$("inputSubAcct3").value = row == null ? "" : row.glSubAccount3;
			$("inputSubAcct4").value = row == null ? "" : row.glSubAccount4;
			$("inputSubAcct5").value = row == null ? "" : row.glSubAccount5;
			$("inputSubAcct6").value = row == null ? "" : row.glSubAccount6;
			$("inputSubAcct7").value = row == null ? "" : row.glSubAccount7;
			$("inputSlCd").value = row == null ? "" : row.slCd;
			$("inputSlName").value = row == null ? "" : row.dspSlName;
			$("inputDebitAmt").value = row == null ? "" : (row.debitAmt==null? "" : formatCurrency(row.debitAmt));
			$("inputCreditAmt").value = row == null ? "" : (row.creditAmt==null? "" : formatCurrency(row.creditAmt));
			$("hidSlTypeCd").value = row == null ? "" : row.slTypeCd;
			$("hidGenType").value = row == null ? "" : row.generationType; //benjo 08.27.2015 UCPBGEN-SR-19654
			
			/* if(row==null) {
				disableButton($("btnDeleteAE"));
				$("btnAddAE").value = "Add";
				if(!formDisabled) {
					$$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
						row.removeAttribute("readonly");
					});
					//$("inputGlAcctName").removeAttribute("readonly");
					$("searchGlAcct").show();
					$("searchSlCd").show();
				}
			} else {
				$("btnAddAE").value = "Update";
				if(!formDisabled) {
					enableButton($("btnDeleteAE"));
					$$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
						row.setAttribute("readonly", "readonly");
					});
					$("searchGlAcct").hide();
					$("searchSlCd").hide();
					//$("inputGlAcctName").setAttribute("readonly", "readonly");
				}
			} */ //benjo 08.27.2015 comment out
			
			/* benjo 08.27.2015 UCPBGEN-SR-19654 */
			if(!formDisabled) {
				if(row==null) {
					enableButton($("btnAddAE"));
					disableButton($("btnDeleteAE"));
					$("btnAddAE").value = "Add";
					$$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
						row.removeAttribute("readonly");
					});
					$("inputDebitAmt").removeAttribute("readonly");
					$("inputCreditAmt").removeAttribute("readonly");
					$("searchGlAcct").show();
					$("searchSlCd").show();
				} else {
					$("btnAddAE").value = "Update";
					if(row.generationType == 'X') {
						enableButton($("btnAddAE"));
						enableButton($("btnDeleteAE"));
						$$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
							row.removeAttribute("readonly");
						});
						$("inputDebitAmt").removeAttribute("readonly");
						$("inputCreditAmt").removeAttribute("readonly");
						$("searchGlAcct").show();
						$("searchSlCd").show();
					} else {
						disableButton($("btnAddAE"));
						disableButton($("btnDeleteAE"));
						$$("div#recAEFormDiv input[name='glAccountCode']").each(function(row) {
							row.setAttribute("readonly", "readonly");
						});
						$("inputDebitAmt").setAttribute("readonly", "readonly");
						$("inputCreditAmt").setAttribute("readonly", "readonly");
						$("searchGlAcct").hide();
						$("searchSlCd").hide();
					}
				}
			}
		} catch(e) {
			showErrorMessage("populateRecAEFields", e);
		}
	}
	
	function deleteAE() {
		try {
			if(selectedAEIndex != null) {
				recAEGrid.deleteRow(selectedAEIndex);
				changeTag = 1;
				selectedAERow = null;
				populateRecAEFields(null);
				computeAmtSum();
			}
		} catch(e) {
			showErrorMessage("deleteAE", e);
		}
	}
	
	function addAE() {
		try {
			if (validateRecAEInputs()) {
				var ae = prepareRecAEObject("add");
				if($F("btnAddAE") == "Add") {
					recAEGrid.addRow(ae);
				} else {
					recAEGrid.updateRowAt(ae, selectedAEIndex);
				}
				changeTag = 1;
				selectedAERow = null;	
				populateRecAEFields(null);
				computeAmtSum();
			}
		} catch(e) {
			showErrorMessage("addAE", e);
		}
	}
	
	function saveRecAE() {
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		} else {
			var aeObj = new Object();
			var modifiedRows = recAEGrid.getModifiedRows();
			
			aeObj.setRecAEObj = recAEGrid.getNewRowsAdded().concat(modifiedRows);
			aeObj.delRecAEObj = recAEGrid.getDeletedRows();
			
			new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
				method: "GET",
				parameters: {
					action: "saveRecAE",
					parameters: JSON.stringify(aeObj)
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response){
					if(checkErrorOnResponse(response)) {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
					} else {
						showMessageBox("An error occured while saving - \n"+response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}
	
	$("btnAddAE").observe("click", addAE);
	$("btnDeleteAE").observe("click", deleteAE);
	$("btnSaveRecAE").observe("click", saveRecAE);
	$("btnExitRecAE").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {saveRecAE(); aeOverlay.close();},
					function() {aeOverlay.close();}, "");
		} else {
			aeOverlay.close();
		}
		
	});
	
	function prepareRecAEObject(action) {
		try {
			var obj = new Object();

			obj.recoveryAcctId	    = $F("c042RecAcctId");
			obj.acctEntryId         = $F("hidAcctEntryId");
			obj.glAcctId 			= $F("inputGlAcctId");
			obj.dspGlAcctName 		= $F("inputGlAcctName");
			obj.glAcctCategory 		= $F("inputGlAcctCtgy");
			obj.glControlAcct 		= $F("inputGlCtrlAcct");
			obj.glSubAccount1 		= $F("inputSubAcct1");
			obj.glSubAccount2 		= $F("inputSubAcct2");
			obj.glSubAccount3 		= $F("inputSubAcct3");
			obj.glSubAccount4 		= $F("inputSubAcct4");
			obj.glSubAccount5 		= $F("inputSubAcct5");
			obj.glSubAccount6 		= $F("inputSubAcct6");
			obj.glSubAccount7 		= $F("inputSubAcct7");
			obj.slCd 				= $F("inputSlCd");
			obj.slTypeCd			= $F("hidSlTypeCd");
			obj.dspSlName 			= $F("inputSlName");
			obj.debitAmt 			= $F("inputDebitAmt") == "" ? 0 : unformatCurrencyValue($F("inputDebitAmt"));
			obj.creditAmt 			= $F("inputCreditAmt") == "" ? 0 : unformatCurrencyValue($F("inputCreditAmt"));
			obj.dspGlAcctCd         = $F("inputGlAcctCtgy")+"-"+
										parseInt($F("inputGlCtrlAcct")).toPaddedString(2)+"-"+ //lara 1/10/2014
										parseInt($F("inputSubAcct1")).toPaddedString(2)+"-"+
										parseInt($F("inputSubAcct2")).toPaddedString(2)+"-"+
										parseInt($F("inputSubAcct3")).toPaddedString(2)+"-"+
										parseInt($F("inputSubAcct4")).toPaddedString(2)+"-"+
										parseInt($F("inputSubAcct5")).toPaddedString(2)+"-"+
										parseInt($F("inputSubAcct6")).toPaddedString(2)+"-"+
										parseInt($F("inputSubAcct7")).toPaddedString(2);
			
			/* benjo 08.27.2015 UCPBGEN-SR-19654 */
			if($F("btnAddAE") == "Add") {
				obj.generationType = 'X';
			} else {
				obj.generationType = $F("hidGenType");
			}
		
			return obj;
		} catch(e) {
			showErrorMessage("prepareRecAEObject", e);
		}
	}
	
    try {
    	var objRecAE =  JSON.parse('${recAcctEntriesTableGrid}'.replace(/\\/g, '\\\\'));
    	var recAETable = {
    			url: contextPath+"/GICLRecoveryPaytController?action=showRecAcctEntries&refresh=0&recoveryAcctId="+
				 $F("c042RecAcctId")+"&payorCd="+$F("hidPayorCd")+"&payorClassCd="+$F("hidPayorClassCd"),
				options: {
					title: '',
					height: '180',
					width: '600',
					beforeSort: function(){
						if(changeTag == 1){
							showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", ""/*save*/, ""/*refresh*/, "");
							return false;
						} else {
							return true;
						}
					},
					prePager: function(){
						if(changeTag == 1){
							showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", ""/*save*/, ""/*refresh*/, "");
							return false;
						} else {
							return true;
						}
					},
					onCellFocus: function(element, value, x, y, id) {
						selectedAEIndex = y;
						selectedAERow = recAEGrid.getRow(y);
						populateRecAEFields(selectedAERow);
					},
					onRemoveRowFocus: function() {
						selectedAEIndex = null;
						selectedAERow = null;
						populateRecAEFields(null);
					}
				},
				columnModel: [
					{   
						id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'dspGlAcctCd',
						title: 'GL Account Code',
					  	width: '270',
					  	titleAlign: 'left',
					  	editable: false
					},
					{
						id: 'slCd',
						title: 'SL Code',
					  	width: '50',
					  	titleAlign: 'center',
					  	align: 'right',
					  	editable: false
					},
					{
						id: 'debitAmt',
						title: 'Debit Amount',
					  	width: '120',
					  	titleAlign: 'center',
					  	editable: false,
					  	align: 'right',
						renderer: function(value) {
							return formatCurrency(value);
						}
					},
					{
						id: 'creditAmt',
						title: 'Credit Amount',
					  	width: '120',
					  	titleAlign: 'center',
					  	editable: false,
					  	align: 'right',
						renderer: function(value) {
							return formatCurrency(value);
						}
					},
					{
						id: 'acctEntryId',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glAcctId',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glAcctCategory',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glControlAcct',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount1',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount2',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount3',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount4',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount5',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount6',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'glSubAccount7',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'slCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'dspGlAcctName',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'dspPayorName',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'slTypeCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'dspSlName',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'generationType',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'slSourceCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'recoveryAcctId',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					}
					
				],
				resetChangeTag: true,
				rows: objRecAE.rows
    		};
    		
    		recAEGrid = new MyTableGrid(recAETable);
    		recAEGrid.pager = objRecAE;
    		recAEGrid.render('recoveryAcctEntriesTableGrid');
    		computeAmtSum();
    } catch(e) {
    	showErrorMessage("recovery Acctg. Entry TableGrid", e);
    }
    
    function computeAmtSum() {
    	try {
    		var rows = recAEGrid.geniisysRows;
    		var deletedRows = recAEGrid.getDeletedRows();
    		var credit = 0;
    		var debit = 0;
    		var temp;
    		
    		for(var i=0; i<rows.length; i++) {
    			temp = rows[i].creditAmt == null ? 0 : parseFloat(rows[i].creditAmt);
    			credit = credit + temp;
    			temp = rows[i].debitAmt == null ? 0 : parseFloat(rows[i].debitAmt);
    			debit = debit + temp;
    		}
    		
    		for(var i=0; i<deletedRows.length; i++) {
    			temp = deletedRows[i].creditAmt == null ? 0 : parseFloat(deletedRows[i].creditAmt);
    			credit = credit - temp;
    			temp = deletedRows[i].debitAmt == null ? 0 : parseFloat(deletedRows[i].debitAmt);
    			debit = debit - temp;
    		}
    		
    		$("dspTotalDebit").value = formatCurrency(debit);
    		$("dspTotalCredit").value = formatCurrency(credit);
    	} catch(e) {
    		showErrorMessage("computeAmtSum", e);
    	}
    }
    
    function prepareSearchGlObj() {
    	var obj = new Object();
    }
    
    $("searchGlAcct").observe("click", function() {
    	var notIn = "";
    	var withPrevious = false;
		var rows = recAEGrid.geniisysRows;
		for(var i=0; i<rows.length; i++){
			if(withPrevious) notIn += ",";
			notIn += rows[i].glAcctId;
			withPrevious = true;	
		}
		
		notIn = (notIn != "" ? "("+notIn+")" : "");
		
		var entryId = (rows.length <= 0) ? 0 : rows[0].acctEntryId ;
		for(var i=1; i<rows.length; i++) {
			if(entryId < rows[i].acctEntryId && rows[i].recoveryAcctId == $F("c042RecAcctId")) {
				entryId = rows[i].acctEntryId;
			}
		}
		
		var searchObj = new Object();
		searchObj.glAcctCategory 	= $F("inputGlAcctCtgy");
		searchObj.glControlAcct 	= $F("inputGlCtrlAcct");
		searchObj.glSubAcct1		= $F("inputSubAcct1");
		searchObj.glSubAcct2		= $F("inputSubAcct2");
		searchObj.glSubAcct3		= $F("inputSubAcct3");
		searchObj.glSubAcct4		= $F("inputSubAcct4");
		searchObj.glSubAcct5		= $F("inputSubAcct5");
		searchObj.glSubAcct6		= $F("inputSubAcct6");
		searchObj.glSubAcct7		= $F("inputSubAcct7");
		
		entryId = parseInt(entryId)+1;
		showGLChartLOV(notIn, entryId, JSON.stringify(searchObj), $F("inputGlAcctName"));
    });
	
    $("searchSlCd").observe("click", function() {
    	if($F("hidSlTypeCd") == "") {
			showMessageBox("No records.");
		} else {
			showSlListLOV($F("hidSlTypeCd"), "");
		}
    });
    
    $("btnPrintAcctEntries").observe("click", function() {
    	if(changeTag != 0) {
    		showMessageBox("Please save changes first.");
    		return;
    	} 
    	
    	if(objRecAE.rows.length < 1) {
    		showMessageBox("Please insert Recovery Accounting Entry record/s first before printing.");
    		return;
    	}
    	
    	if (unformatCurrencyValue($F("inputDebitAmt")) != unformatCurrencyValue($F("inputCreditAmt"))) {
    		showMessageBox("Total Debit and Credit amounts are not equal. Please check the entries.", "e");
    		return;
    	}
    	
    	printRecAEOverlay = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
    		urlContent: true,
    		urlParameters: {
    			action: "showPrintRecAEDialog",
    			recoveryAcctId: $F("c042RecAcctId")
    		},
    		//title: "Print Accounting Entries",
    		height: 160,
    		width: 450,
    		draggable: true
    	});
    });
    
    $("inputDebitAmt").observe("change"/*"blur"*/, function() {  //benjo 08.27.2015 UCPBGEN-SR-19654 replaced blur -> change
		if(parseFloat(($F("inputDebitAmt")).replace(/,/g, "")) > 9999999999.99) {
			showMessageBox("Maximum value for Debit Amount is 9,999,999,999.99");
			$("inputDebitAmt").clear();
			$("inputDebitAmt").focus();
		} else if(isNaN(parseFloat($F("inputDebitAmt")))) {
			showMessageBox("Entered value is not allowed. Valid value is from 0 to 9,999,999,999.99.");
			$("inputDebitAmt").clear();
			$("inputDebitAmt").focus();
		}/* else if(parseFloat(($F("inputDebitAmt")).replace(/,/g, "")) < 0) {
			showMessageBox("Negative Amounts are not Allowed.");
			$("inputDebitAmt").clear();
			$("inputDebitAmt").focus();
		}*/ else {
			$("inputDebitAmt").value = formatCurrency($F("inputDebitAmt"));
		}
	});
    
    $("inputCreditAmt").observe("change"/*"blur"*/, function() {  //benjo 08.27.2015 UCPBGEN-SR-19654 replaced blur -> change
		if(parseFloat(($F("inputCreditAmt")).replace(/,/g, "")) > 9999999999.99) {
			showMessageBox("Maximum value for Credit Amount is 9,999,999,999.99.");
			$("inputCreditAmt").clear();
			$("inputCreditAmt").focus();
		} else if(isNaN(parseFloat($F("inputCreditAmt")))) {
			showMessageBox("Entered value is not allowed. Valid value is from 0 to 9,999,999,999.99.");
			$("inputCreditAmt").clear();
			$("inputCreditAmt").focus();
		}/* else if(parseFloat(($F("inputCreditAmt")).replace(/,/g, "")) < 0) {
			showMessageBox("Negative Amounts are not Allowed.");
			$("inputCreditAmt").clear();
			$("inputCreditAmt").focus();
		}*/ else {
			$("inputCreditAmt").value = formatCurrency($F("inputCreditAmt"));
		}
	});
    
    function showGLChartLOV(notIn, entryId, obj, acctName) {
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGlAcctsLOV",
				notIn: notIn,
				glObj: obj,
				acctName: acctName,
				page: 1
			},
			title: "Installment No. List",
			width: 600,
			height: 350,
			columnModel: [
				{
					   id: "glAcctName",
					   title: "GL Account Name",
					   width: '250px',
					   titleAlign: 'left',
					   align: 'left'
				},           
				{
					   id: "glAcctCategory",
					   title: "",
					   width: '40px',
					   align: 'center'
				},
				{
					   id: "glControlAcct",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct1",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct2",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct3",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct4",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct5",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct6",
					   title: "",
					   width: '40px',
					   align: 'center'
				}, 
				{
					   id: "glSubAcct7",
					   title: "",
					   width: '40px',
					   align: 'center'
				}
			],
			draggable: true,
			onSelect: function(row) {
				$("hidSlTypeCd").value = row.gsltSlTypeCd;
				$("inputGlAcctId").value = row.glAcctId;
				$("inputGlAcctName").value = row.glAcctName;
				
				$("inputGlAcctCtgy").value = row.glAcctCategory;
				$("inputGlCtrlAcct").value = row.glControlAcct;
				$("inputSubAcct1").value = row.glSubAcct1;
				$("inputSubAcct2").value = row.glSubAcct2;
				$("inputSubAcct3").value = row.glSubAcct3;
				$("inputSubAcct4").value = row.glSubAcct4;
				$("inputSubAcct5").value = row.glSubAcct5;
				$("inputSubAcct6").value = row.glSubAcct6;
				$("inputSubAcct7").value = row.glSubAcct7;
				$("hidAcctEntryId").value = entryId;
			}
		});
	}
    
    //added by Halley 01.15.14
    if($("c042AcctTranId").value == null || $("c042AcctTranId").value == ""){
    	disableButton("btnPrintAcctEntries");
    }else{
    	enableButton("btnPrintAcctEntries");
    }
</script>