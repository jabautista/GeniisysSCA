<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
			
<div class="sectionDiv" style="border-top: none;" id="accountingEntriesDiv" name="accountingEntriesDiv">			
	<!-- HIDDEN FIELDS -->
	<input type="hidden" id="tranFlag" name="tranFlag" value="${tranFlag}" />
	<input type="hidden" id="hiddenAcctEntryId" name="hiddenAcctEntryId" value="" />
	<input type="hidden" id="hiddenGlAcctId" name="hiddenGlAcctId" value="" />
	<input type="hidden" id="hiddenGenType" name="hiddenGenType" value="" />
	<input type="hidden" id="hiddenSlTypeCd" name="hiddenSlTypeCd" value="" isSlExisting=""/>
	<input type="hidden" id="hiddenSlCd" name="hiddenSlCd" value="" />
	<input type="hidden" id="hiddenFundCd" name="hiddenFundCd" value="" />
	<input type="hidden" id="hiddenBranchCd" name="hiddenBranchCd" value="" />
	<input type="hidden" id="hiddenSlSourceCd" name="hiddenSlSourceCd" value="" />
	<input type="hidden" id="hiddenTranClass" name="hiddenTranClass" value="${gacc.tranClass}" />
	<input type="hidden" id="hiddenDvFlag" name="hiddenDvFlag" value="${gacc.dvFlag}" />
	<input type="hidden" id="hidDspIsExisting" name="hidDspIsExisting" value="" />		<!-- start - Gzelle 11102015 KB#132 AP/AR ENH -->
	<input type="hidden" id="hidDrCrTag" name="hidDrCrTag" value="" />
	<input type="hidden" id="hidKnockOff" name="hidKnockOff" value="N" />
	<input type="hidden" id="hidAcctRefNo" name="hidAcctRefNo" value="" />
	<input type="hidden" id="hidOutstandingBal" name="hidOutstandingBal" value="" currKnockOffAmt=""/>	<!-- end - Gzelle 12172015 KB#132 AP/AR ENH -->
	<!-- END HIDDEN FIELDS -->
	
	<div id="accountingEntriesTableGridDiv" style= "padding: 11px 10px 10px 10px;">
		<div id="accountingEntriesTableGrid" style="height: 285px;"></div>
	</div>
	<div id="acctTotalsMainDiv" style="width: 900px; display: block; margin:0 auto; padding-top: 10px; padding-bottom: 10px;">
		<div id="acctTotalsDiv" style="height: 100px;">
			<input type="button" class="button" style="width:11%; float: left;" id="btnCloseTrans" name="btnCloseTrans" value="Close Trans" tabindex=201/>
			<input type="button" class="button" style="width:13%; float: left; margin-left: 1%" id="btnViewGlBal" name="btnViewGlBal" value="View GL Balance" tabindex=202/>
			<table align="right">
				<tr>
					<td style="text-align:right; padding-right:10px;">Total Debit Amount</td>
					<td>
						<input type="text" id="txtDebitTotal" class="money" style="width: 125px; text-align: right;" readonly="readonly" tabindex=203/>
					</td>
				</tr>
				<tr>
					<td style="text-align:right; padding-right:10px;">Total Credit Amount</td>
					<td>
						<input type="text" id="txtCreditTotal" class="money" style="width: 125px; text-align: right;" readonly="readonly" tabindex=204/>					
					</td>
				</tr>
				<tr>
					<td style="text-align:right; padding-right:10px;">Difference</td>
					<td>
						<input type="text" id="txtDifference" class="difference" style="width: 125px; text-align: right;" readonly="readonly" tabindex=205/>
					</td>
				</tr>
			</table>
		</div>
	</div>
		
	<div id="acctEntriesFormDiv" name="acctEntriesFormDiv" changetagattr="true" >
		<table style="margin: 10px 0 10px 115px;">	<!-- (margin-left) Gzelle 11052015 KB#132 -->
			<tbody>
				<tr>
					<td class="rightAligned" style="width: 101px;">GL Account Code</td>
					<td class="leftAligned" style="width: 445px;">
						<div id="glCodeDiv" style="float: left;">
							<input type="text" style="width: 22px;" id="inputGlAcctCtgy" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit01" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9" customLabel="GL Account Code" tabindex=206/>
							<input type="text" style="width: 22px;" id="inputGlCtrlAcct" 	name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=207/>
							<input type="text" style="width: 22px;" id="inputSubAcct1" 		name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=208/>
							<input type="text" style="width: 22px;" id="inputSubAcct2" 		name="glAccountCode"	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=209/>
							<input type="text" style="width: 22px;" id="inputSubAcct3"		name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=210/>
							<input type="text" style="width: 22px;" id="inputSubAcct4"		name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=211/>
							<input type="text" style="width: 22px;" id="inputSubAcct5"		name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=212/>
							<input type="text" style="width: 22px;" id="inputSubAcct6"		name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=213/>
							<input type="text" style="width: 22px;" id="inputSubAcct7"		name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=214/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 101px;">GL Account Name</td>
					<td class="leftAligned" style="width: 445px;">
						<div id="glAcctNameDiv" style="float: left; width: 451px; border: 1px solid gray; height: 20px;" class="required">
							<input type="text" style="width: 94%; float: left; border: none; height: 15px; padding-top: 0px;" id="inputGlAcctName" name="inputGlAcctName" value="" class="required" readonly="readonly" tabindex=215/>
							<img id="searchGlAcct" name="searchGlAcct" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex=216 />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 101px;">SL Name</td>
					<td class="leftAligned" style="width: 445px;">
						<div id="selectSlDiv" style="float: left; width: 451px; border: 1px solid gray; height: 20px;">
							<input type="text" id="inputSlName" name="inputSlName" style="width: 94%; float: left; border: none; height: 15px; padding-top: 0px;" value="" readonly="readonly" tabindex=217/>
							<img id="searchSlCd" name="searchSlCd" alt="Go" style="float: right" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex=218/>
						</div>
					</td>
				</tr>
				<!-- start - Gzelle - 11052015 - KB#132 AP/AR ENH -->
				<tr>
					<td class="rightAligned" style="width: 150px;"> Account Reference No.</td>
					<td class="leftAligned" style="width: 445px;">
						<input type="text" style="float: left; width: 48px; margin-right: 3px;" id="txtLedgerCd" class="" disabled="disabled" tabindex=219/>
						<input type="text" style="float: left; width: 48px; margin-right: 3px;" id="txtSubLedgerCd" class="" disabled="disabled" tabindex=220/>
						<div id="selTranDiv" class="" style="float: left; width: 60px; border: 1px solid gray; margin-right: 3px; margin-top:2px; height: 21px;">
							<input type="text" class="" id="txtTranCd" name="txtTranCd" style="width: 34px; float: left; border: none; height: 15px; padding-top: 0px;" value="" tabindex=221/>
							<img id="imgSearchTranCd" name="imgSearchTranCd" alt="Go" style="float: right" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex=222/>
						</div>	
						<input type="text" style="float: left; width: 48px; margin-right: 3px;" id="txtSlCd" class="" disabled="disabled" tabindex=223/>
						<div id="selSeqNoDiv" class="" style="float: left; width: 60px; border: 1px solid gray; margin-right: 3px; margin-top:2px; height: 21px;">
							<input type="text" class="" id="txtSeqNo" name="txtSeqNo" style="width: 34px; float: left; border: none; height: 15px; padding-top: 0px;" readonly="readonly" value="" tabindex=224/>
							<img id="imgSearchSeqNo" name="imgSearchSeqNo" alt="Go" style="float: right" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex=225/>
						</div>		
						<div style="float: left; margin-right: 3px; margin-top:2px;">
							<input type="radio" name="rdoAcctTranType" id="rdoSetUp" value="S" style="float: left; margin: 3px 5px 3px 5px;" tabindex=226 />
							<label for="rdoSetUp" style="float: left; height: 20px; padding-top: 3px;" title="Set-up">Set-up</label>
						</div>	
						<div style="float: left; margin-right: 3px; margin-top:2px;">
							<input type="radio" name="rdoAcctTranType" id="rdoKnockOff"  value="K" style="float: left; margin: 3px 5px 3px 5px;" tabindex=227 />
							<label for="rdoKnockOff" style="float: left; height: 20px; padding-top: 3px;" title="Knock-off">Knock-off</label>
						</div>															
					</td>					
				</tr>
				<!-- end - Gzelle - 11052015 - KB#132 AP/AR ENH -->
				<tr>
					<!-- <td class="rightAligned" style="width: 101px;">Debit Amount</td>
					<td class="leftAligned" style="width: 320px;">
						<input type="text" style="width: 320px;" id="inputDebitAmt" name="inputDebitAmt" class="rightAligned list money required" maxlength="15" tabindex=219/>
					</td>
					<td class="rightAligned" style="width: 101px;">Credit Amount</td>
					<td class="leftAligned" style="width: 320px;">
						<input type="text" style="width: 320px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned list money required" maxlength="15" tabindex=220/>
					</td> -->
					<td class="rightAligned" style="width: 101px;" for="inputDebitAmt">Debit Amount</td>
					<td class="leftAligned" style="width: 160px;">
						<input type="text" style="width: 160px;" id="inputDebitAmt" name="inputDebitAmt" class="rightAligned required applyDecimalRegExp" 
							 regExpPatt="pDeci1002" min="0.00" max="9999999999.99" hasOwnChange="Y" hasOwnBlur="Y" maxlength="15" tabindex=219 customLabel="Debit Amount" />	<!-- 11052015 Gzelle KB#132 -->
						<div class="rightAligned" style="width: 280px; float:right;">
							<span class="rightAligned" style="width: 120px;">Credit Amount</span>
							<input type="text" style="width: 160px; margin-left:5px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned required applyDecimalRegExp" 
							 regExpPatt="pDeci1002" min="0.00" max="9999999999.99" hasOwnChange="Y" hasOwnBlur="Y" maxlength="15" tabindex=220 customLabel="Credit Amount" />
						</div>
					</td>
					<!-- <td class="rightAligned" style="width: 81px;" for="inputCreditAmt">Credit Amount</td>
					<td class="leftAligned" style="width: 160px;">
						<input type="text" style="width: 160px; margin-left:5px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned required applyDecimalRegExp" 
							 regExpPatt="pDeci1002" min="0" max="9999999999.99" hasOwnChange="Y" hasOwnBlur="Y" maxlength="15" tabindex=220/>
					</td> -->
				</tr>
				<tr>
					<td class="rightAligned" style="width: 101px;">Remarks</td>
					<td class="leftAligned" style="width: 445px;">
						<div style="border: 1px solid gray; height: 20px; width:451px; ">
							<input type="text" id="inputEntryRemarks" name="inputEntryRemarks" style="width: 94% ; border: none; height: 12px;" maxlength="4000" tabindex=221/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" name="editText" tabindex=222/>
						</div>
					</td>
				</tr>
				<tr id="sapTextRow">
					<td class="rightAligned" style="width:101px;">SAP Text</td>
					<td class="leftAligned" style="width:445px;">
						<div style="border: 1px solid gray; height: 20px; width:451x; ">
							<input type="text" id="inputSapText" name="inputSapText" style="width: 94% ; border: none; height: 12px;" tabindex=223/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editSapText" id="editSapText" name="editText" tabindex=224/>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div style="margin-top: 10px; margin-bottom: 15px;">
		<input type="button" class="button" style="width: 90px;" id="btnAddEntry" name="btnAddEntry" value="Add" tabindex=225/>
		<!-- class="disabledButton" --> 
		<input type="button" class="button" style="width: 90px;" id="btnDelEntry" name="btnDelEntry" value="Delete" disabled="disabled" tabindex=226/>
	</div>
</div>
<div class="buttonsDiv" id="acctEntriesButtonsDiv" changeTagAttr="true">
	<input type="button" class="button noChangeTagAttr" style="width: 90px;" id="btnCancelEntry" name="btnCancelEntry" value="Cancel" tabindex=227/>
	<input type="button" class="button noChangeTagAttr" style="width: 90px;" id="btnSaveEntry" name="btnSaveEntry" value="Save" tabindex=228/>
</div>
<script type="text/javascript">
	hideNotice();	
	setModuleId("GIACS030");
	setDocumentTitle("Accounting Entries");
	var checkEntry = JSON.parse('${checkManualEntry}');
	
	var prevRdo = "rdoSetUp";		/* start -  Gzelle 12112015 AP/AR ENH */
	acctRefNoList = [];
	recToAdd = [];
	recToRemove = [];				/* end -  Gzelle 12112015 AP/AR ENH */
	
	var sapSw = '${sapSw}' == null ? "N" : '${sapSw}';
	var userId = '${userId}';
	
	$("txtDebitTotal").value = formatCurrency('${totalDebitAmt}');
	$("txtCreditTotal").value = formatCurrency('${totalCreditAmt}');
	
	if(objACGlobal.previousModule == "GIACS003" && objACGlobal.callingForm == "ACCT_ENTRIES" && $("fundCd").value == ""){//added by steven 04.09.2013
		formatAcctEntriesField();
	}else if(objACGlobal.previousModule == "GIACS070" && objACGlobal.callingForm == "ACCT_ENTRIES" && $("fundCd").value == ""){//added by shan 08.27.2013
		formatAcctEntriesField();
	}
	
	var newEntryId = 100000;
	var prevCredit = 0;
	var prevDebit = 0;
	
	computeTotalsAE(0, 0);
	
	try{
		var objAcctEntriesArray = [];
		var objAccountingEntries = new Object();
		objAccountingEntries.objAccountingEntriesTableGrid = JSON.parse('${acctEntriesJSON}');
		objAccountingEntries.acctEntriesList = objAccountingEntries.objAccountingEntriesTableGrid.rows || [];
	
		var tableModel = {
				url: contextPath+"/GIACAcctEntriesController?action=showAcctEntriesTableGrid&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
				options:{
					title: '',
					height: '270px',
					onCellFocus: function(element, value, x, y, id) {
						accountingEntriesTableGrid.keys.releaseKeys();
						var obj = accountingEntriesTableGrid.geniisysRows[y];
						populateAcctEntries(obj);
						getOutstandingBalance();
					},
					onRemoveRowFocus: function(){
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
					},
					onSort: function () {
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
						acctRefNoList =	[];
					},
					beforeSort: function(){
						if(changeTag == 1){
							showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
									function(){
										saveAcctEntries();
									}, 
									function(){
										showAcctEntries();
										changeTag = 0;
									}, "");
							return false;
						}else{
							return true;
						}
					},
					postPager: function () {
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
						acctRefNoList =	[];
					},
					onRefresh: function(){
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
						acctRefNoList =	[];
					},
					toolbar : {
						elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
						onFilter: function(){
							accountingEntriesTableGrid.keys.releaseKeys();
							populateAcctEntries(null);
							acctRefNoList =	[];
						}
				}
		},
		columnModel: [
						{	
							id: 'recordStatus', 	
						    width: '0',
						   	visible: false,
						    editor: 'checkbox' 					
						},
						{	id: 'divCtrId',
							width: '0',
							visible: false
						},
						{	id: 'acctCode',
							title: 'GL Account Code',
							width: '230px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'glAcctName',
							title: 'GL Account Name',
							width: '230px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'slName',
							title: 'SL Name',
							width: '200px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'debitAmt',
							title: 'Debit Amount',
							width: '100px',
							align: 'right',
							sortable: true,
			 			    filterOption : true,
						    renderer: function(value){
		            			return formatCurrency(value);
		            	    }
						},
						{	id: 'creditAmt',
							title: 'Credit Amount',
							width: '100px',
							align: 'right',
			 			    filterOption : true,
			 			    sortable: true,
						    renderer: function(value){
		            			return formatCurrency(value);
		            	    }
						},
						{	id: 'glAcctId',
							width: '0',
							visible: false
						},
						{	id: 'slCd',
							width: '0',
							visible: false
						},
						{	id: 'slTypeCd',
							width: '0',
							visible: false
						},
						{	id: 'generationType',
							width: '0',
							visible: false
						}
			],
			rows: objAccountingEntries.acctEntriesList
		};
		
		accountingEntriesTableGrid = new MyTableGrid(tableModel);
		accountingEntriesTableGrid.pager = objAccountingEntries.objAccountingEntriesTableGrid;
		accountingEntriesTableGrid.render('accountingEntriesTableGrid');
		accountingEntriesTableGrid.afterRender = function(){
			objAcctEntriesArray = accountingEntriesTableGrid.geniisysRows;
			totalDebitAmt = 0;
			totalCreditAmt = 0;
			
			if(objAcctEntriesArray.length != 0){
				totalDebitAmt = objAcctEntriesArray[0].totalDebitAmt;
				totalCreditAmt = objAcctEntriesArray[0].totalCreditAmt;
			}

			$("txtDebitTotal").value = formatCurrency(totalDebitAmt);
			$("txtCreditTotal").value = formatCurrency(totalCreditAmt);
			computeTotalsAE(0, 0);
		};
	}catch (e) {
		showErrorMessage("accountingEntries.jsp",e);
	}

	$("btnAddEntry").observe("click", function() {
		var checkRequired = true;					/* start - Gzelle 12152015 AP/AR ENH*/
		if ($F("hidKnockOff") != "Y") {
			checkRequired = checkRequiredFields();
		}
		
		function checkUserEntry() {
			if(checkEntry.transMesg == "YES") {
				if(checkEntry.allowManual == "Y") {
					if ($F("btnAddEntry") == "Update"){
						addAccountingEntry();
					}else if(checkEntry.userValid == "TRUE") {
						addAccountingEntry();
					} else {
					 	 showConfirmBox("Confirm", userId + " is not allowed to create manual accounting entries.  Would you like to override?",
							 	"Yes", "No", function() {
					 				override();
					 			}, ""
					 	);
					} 
				} else {
					showMessageBox(checkEntry.allowManual);
				} 
			} else {
				showMessageBox(checkEntry.transMesg);
			}
		}
		
		if(checkRequired){							
			if ($F("btnAddEntry") == "Add"){
				valAddGlAcctRefNo(checkUserEntry);
			} else {
				checkUserEntry();
			}
		}	/* end - Gzelle 12152015 AP/AR ENH*/													
	});
	
	function override(){
		showGenericOverride(
				"GIACS030",
				"MA",
				function(ovr, userId, result){
					if(result == "FALSE"){
						showMessageBox( userId + " is not allowed to create manual accounting entries.", imgMessage.ERROR);
						$("txtOverrideUserName").clear();
						$("txtOverridePassword").clear();
						return false;
					} else {
						if(result == "TRUE"){
							addAccountingEntry();	
							ovr.close();
							delete ovr;	
						}
// 						ovr.close();
// 						delete ovr;	
					}
				},
				""
		);
	}
	
	$("btnDelEntry").observe("click", function() {
		if(objACGlobal.tranFlagState == "C"){
			showMessageBox("Deletion is not allowed for closed transaction.");
		}else if(objACGlobal.tranFlagState == "P"){
			showMessageBox("Deletion is not allowed for posted transaction.");
		}else if(objACGlobal.tranFlagState == "D"){
			showMessageBox("This is a deleted transaction.");
		}else if($F("hiddenDvFlag") == "C"){
			showMessageBox("Deletion is not allowed for Cancelled DV.");
		}else if($F("hiddenDvFlag") == "A"){
			showMessageBox("Deletion is not allowed for Approved DV.");
		}else{
			deleteAccountingEntryObj();
		}
	});
	
	function computeTotalsAE(debitAmt, creditAmt) {
		try{
			var totalDebit = unformatCurrency("txtDebitTotal");
			var totalCredit= unformatCurrency("txtCreditTotal");
			
			totalDebit = parseFloat(totalDebit) - prevDebit + (parseFloat(debitAmt));
			totalCredit = parseFloat(totalCredit) - prevCredit + (parseFloat(creditAmt));
			
			$("txtDebitTotal").value = formatCurrency(totalDebit);
			$("txtCreditTotal").value = formatCurrency(totalCredit);
			
			/* for(var i=0; i<objAcctEntriesArray.length; i++) {
				if (objAcctEntriesArray[i].recordStatus != -1) {
					totalDebit += parseFloat(objAcctEntriesArray[i].debitAmt);
				}
			}
			for(var i=0; i<objAcctEntriesArray.length; i++) {
				if (objAcctEntriesArray[i].recordStatus != -1) {
					totalCredit += parseFloat(objAcctEntriesArray[i].creditAmt);
				}
			} */
			
			//$("txtDebitTotal").value = formatCurrency(totalDebit);
			//$("txtCreditTotal").value = formatCurrency(totalCredit);
			
			var difference = parseFloat(totalDebit) - parseFloat(totalCredit);
			difference = roundNumber(parseFloat(difference), 2);
			
			if(difference < 0) {
				$("txtDifference").value = "<"+formatCurrency(Math.abs(difference))+">"
			} else {
				$("txtDifference").value = formatCurrency(difference);
			}
		}catch(e){
			showErrorMessage("computeTotalsAE", e);
		}
	}
	
	function populateAcctEntries(obj){
		if(obj == null){			
			resetFieldBehavior();					
		}else{
			prevCredit = obj.creditAmt;
			prevDebit = obj.debitAmt;
			
			$("inputGlAcctCtgy").value 	= parseInt(obj.glAcctCategory);
			$("inputGlCtrlAcct").value 	= parseInt(obj.glControlAcct).toPaddedString(2);
			$("inputSubAcct1").value 	= parseInt(obj.glSubAcct1).toPaddedString(2);
			$("inputSubAcct2").value 	= parseInt(obj.glSubAcct2).toPaddedString(2);
			$("inputSubAcct3").value 	= parseInt(obj.glSubAcct3).toPaddedString(2);
			$("inputSubAcct4").value 	= parseInt(obj.glSubAcct4).toPaddedString(2);
			$("inputSubAcct5").value 	= parseInt(obj.glSubAcct5).toPaddedString(2);
			$("inputSubAcct6").value 	= parseInt(obj.glSubAcct6).toPaddedString(2);
			$("inputSubAcct7").value 	= parseInt(obj.glSubAcct7).toPaddedString(2);
				
			$("inputGlAcctName").value 	= unescapeHTML2(obj.glAcctName);
			$("inputSlName").value 		= unescapeHTML2(obj.slName);
			$("inputDebitAmt").value 	= formatCurrency(obj.debitAmt);
			$("inputCreditAmt").value 	= formatCurrency(obj.creditAmt);
			$("inputEntryRemarks").value = unescapeHTML2(obj.remarks);
			$("inputSapText").value 	= unescapeHTML2(obj.sapText);
			
			$("hiddenAcctEntryId").value = obj.acctEntryId;
			$("hiddenGlAcctId").value	= obj.glAcctId;
			$("hiddenSlCd").value 		= obj.slCd;
			$("hiddenGenType").value 	= obj.generationType;
			$("hiddenSlTypeCd").value 	= obj.slTypeCd;
			$("hiddenFundCd").value 	= obj.gaccGfunFundCd;
			$("hiddenBranchCd").value 	= obj.gaccGibrBranchCd;
			$("hiddenSlSourceCd").value = obj.slSourceCd;
			
			if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR")  && objAC.tranFlagState != "C" && objACGlobal.fromDvStatInq != 'Y') { //added fromDvStatInq by Robert SR 5189 12.22.15 // andrew - 08.15.2012 SR 0010292 
				enableButton("btnDelEntry");
				$("btnAddEntry").value = "Update";
			}
		
			if (obj.slName == "" || obj.slName == null || objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
				$("inputSlName").removeClassName("required");
				$("selectSlDiv").removeClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFFFF";
			}else{
				$("inputSlName").addClassName("required");
				$("selectSlDiv").addClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFACD";
			}
			
			//disables update for module generated records
			if (obj.generationType != "X" || objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){  // andrew - 08.15.2012 - added cancelOR condition SR 0010292
				disableButton("btnAddEntry");
				disableFields();
			}else{
				enableButton("btnAddEntry");
				enableFields();
			}
			
			if(objACGlobal.tranFlagState == "C" 
					|| objACGlobal.tranFlagState == "P" 
					|| objACGlobal.tranFlagState == "D" 
					|| objACGlobal.callingForm == "GIACS237"
					|| (objACGlobal.previousModule == "GIACS002" && objACGlobal.dvTag != "M") //Deo [02.10.2017]: added dv_tag condition (SR-5924)
					|| objACGlobal.fromDvStatInq == 'Y') {  //added fromDvStatInq by Robert SR 5189 12.22.15
				disableButton("btnCloseTrans");
				disableButton("btnAddEntry");
				disableFields();
			}
			
			$("inputGlAcctCtgy").setAttribute("readonly", "readonly");
			$$("input[type='text'].glAC").each(function (m) {
				m.setAttribute("readonly", "readonly");
			});
			
			disableSearch("searchGlAcct");
			disableSearch("searchSlCd");
			
			/*start - Gzelle 11122015 KB#132 AP/AR ENH*/
			var acctRefNo = obj.acctRefNo == null ? "" : obj.acctRefNo.split(" - ");
			$("hidAcctRefNo").value 	= obj.acctRefNo		== null ? "" : obj.acctRefNo;
			$("txtLedgerCd").value 		= obj.ledgerCd 		== null ? (acctRefNo[0] == null ? "" : acctRefNo[0]) : obj.ledgerCd;
			$("txtSubLedgerCd").value 	= obj.subLedgerCd 	== null ? (acctRefNo[1] == null ? "" : acctRefNo[1]) : obj.subLedgerCd;
			$("txtTranCd").value 		= obj.transactionCd == null ? (acctRefNo[2] == null ? "" : acctRefNo[2]) : obj.transactionCd;
			$("txtSlCd").value 			= acctRefNo[3]	    == null ? "" : acctRefNo[3];
			$("txtSeqNo").value 		= obj.acctSeqNo 	== null ? (acctRefNo[4] == null ? "" : acctRefNo[4]) : obj.acctSeqNo;
			$$("input[name='rdoAcctTranType']").each(function (m) {
				if ($(m.id).value == obj.acctTranType) {
					$(m.id).checked = true;
				}
				if (obj.acctTranType == "" || obj.acctTranType == null) {
					$("rdoSetUp").checked = true;
				}
				$(m.id).disable();
			});		
			$("hidDrCrTag").value = obj.drCrTag;
			if (obj.drCrTag == "C") {
				$("hidOutstandingBal").setAttribute("currKnockOffAmt",obj.debitAmt);
				$("inputDebitAmt").setAttribute("lastValidValue", obj.debitAmt);
			} else {
				$("hidOutstandingBal").setAttribute("currKnockOffAmt",obj.creditAmt);
				$("inputCreditAmt").setAttribute("lastValidValue", obj.creditAmt);
			}
			 $("selTranDiv").removeClassName("required");
			 $("txtTranCd").removeClassName("required");
			 $("selSeqNoDiv").removeClassName("required");
			 $("txtSeqNo").removeClassName("required");
			 $("selTranDiv").style.backgroundColor = "#FFFFFF";
			 $("selSeqNoDiv").style.backgroundColor = "#FFFFFF";
			 disableSearch("imgSearchTranCd");
			 disableSearch("imgSearchSeqNo");
			 $("hidDspIsExisting").value = nvl(obj.dspIsExisting,"N");
			/*end - Gzelle 11122015 KB#132 AP/AR ENH*/
		}
	}
	
	function resetFields(){
		$("inputGlAcctCtgy").value 	 = "";
		$("inputGlCtrlAcct").value 	 = "";
		$("inputSubAcct1").value 	 = "";
		$("inputSubAcct2").value 	 = "";
		$("inputSubAcct3").value 	 = "";
		$("inputSubAcct4").value 	 = "";
		$("inputSubAcct5").value 	 = "";
		$("inputSubAcct6").value 	 = "";
		$("inputSubAcct7").value 	 = "";
		$("inputGlAcctName").value 	 = "";
		$("inputDebitAmt").value 	 = "";
		$("inputCreditAmt").value 	 = "";
		$("inputEntryRemarks").value = "";
		$("inputSlName").value 		 = "";
		$("inputSapText").value 	 = "";
		
		$("hiddenGlAcctId").value 	 = "";
		$("hiddenSlCd").value 		 = "";
		$("hiddenGenType").value 	 = "";
		$("hiddenSlTypeCd").value 	 = "";
		
		/*start-Gzelle 11102015 KB#132 AP/AR ENH*/
		$("hidKnockOff").value		 = "";
		$("hidOutstandingBal").value = "";
		$("hidAcctRefNo").value 	 = "";
		$("txtLedgerCd").value 		 = "";
		$("txtSubLedgerCd").value 	 = "";
		$("txtTranCd").value		 = "";
		$("txtSlCd").value		 	 = "";
		$("txtSeqNo").value 		 = "";
		$("inputDebitAmt").setAttribute("lastValidValue", "");
		$("inputCreditAmt").setAttribute("lastValidValue", "");
		$("hidOutstandingBal").setAttribute("currKnockOffAmt", "");
		/*end-Gzelle 11102015 KB#132 AP/AR ENH*/
	}
	
	
	function disableFields(){
		$$("input[type='text'].glAC").each(function (m) {
			m.setAttribute("readonly", "readonly");
		});
		
		$("inputDebitAmt").readOnly = true;
		$("inputCreditAmt").readOnly = true;
		$("inputEntryRemarks").readOnly = true;
		$("inputSapText").readOnly = true;
		$("inputEntryRemarks").style.backgroundColor = "#FFFFFF";
		$("inputSapText").style.backgroundColor = "#FFFFFF";
		
		disableSearch("searchGlAcct");
		disableSearch("searchSlCd");
		
		/*start - Gzelle 11122015 KB#132 AP/AR ENH*/
		 $("selTranDiv").removeClassName("required");
		 $("txtTranCd").removeClassName("required");
		 $("selTranDiv").style.backgroundColor = "#FFFFFF";
		/*end - Gzelle 11122015 KB#132 AP/AR ENH*/
	}
	
	function enableFields(){
		/* $$("input[type='text'].glAC").each(function (m) {
			m.removeAttribute("readonly");
		});
		 */
		$("inputDebitAmt").readOnly = false; 
		$("inputCreditAmt").readOnly = false;
		$("inputEntryRemarks").readOnly = false;
		$("inputSapText").readOnly = false;
		
		$("inputEntryRemarks").style.backgroundColor = "#FFFFFF";
		$("inputSapText").style.backgroundColor = "#FFFFFF";
		
		$$("img[name='editText']").each(function(image) {
			image.show();
		});
	}
	
	function resetFieldBehavior() {
		resetFields();
		
		if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR")  && objAC.tranFlagState != "C"){  // andrew - 08.15.2012 SR 0010292
			$$("input[type='text'].glAC").each(function (m) {
				m.removeAttribute("readonly");
			});		
		
			$("inputGlAcctCtgy").readOnly = false;
			
			prevCredit = 0;
			prevDebit = 0;
			
			$("inputDebitAmt").readOnly = false; 
			$("inputCreditAmt").readOnly = false;
			$("inputEntryRemarks").readOnly = false;
			$("inputSapText").readOnly = false;
			
			$("inputSlName").style.backgroundColor = "#FFFFFF";
			$("selectSlDiv").removeClassName("required");
			$("btnAddEntry").value = "Add";
			enableSearch("searchGlAcct");
			enableButton("btnAddEntry");
			disableSearch("searchSlCd");
			disableButton("btnDelEntry");
							
			if(objACGlobal.tranFlagState == "C" 
					|| objACGlobal.tranFlagState == "P" 
					|| objACGlobal.tranFlagState == "D" 
					|| objACGlobal.callingForm == "GIACS237"
					|| (objACGlobal.previousModule == "GIACS002" && objACGlobal.dvTag != "M") //Deo [02.10.2017]: added dv_tag condition (SR-5924)
					|| objACGlobal.fromDvStatInq == 'Y') {  //added fromDvStatInq by Robert SR 5189 12.22.15
				disableButton("btnCloseTrans");
				disableButton("btnAddEntry");
				disableFields();
			}
		}
		
		if(sapSw != "Y") {
			$("sapTextRow").hide();
		} else{
			$("sapTextRow").show();
		}
		
		/*start-Gzelle 11102015 KB#132 AP/AR ENH*/
		$("rdoSetUp").checked = true;	
		prevRdo = "rdoSetUp";
		disableInputField("txtTranCd");
		disableSearch("imgSearchSeqNo");
		disableSearch("imgSearchTranCd");
		/*end-Gzelle 11102015 KB#132 AP/AR ENH*/
	}
	
	function setAccountingEntryObj(type,obj){	//modified by Gzelle 12152015 AP/AR ENH
		// type = 0 -> add; type = 1 -> update
		var newObj = new Object();
		try{
			if(type == 0){
				newObj.generationType = "X";
				newObj.gaccGfunFundCd = objACGlobal.fundCd;
				newObj.gaccGibrBranchCd = objACGlobal.branchCd;
				newObj.slSourceCd 	= 1;
				newObj.acctEntryId  = newEntryId;
			}else{
				newObj.generationType = $F("hiddenGenType");
				newObj.gaccGfunFundCd = $F("hiddenFundCd");
				newObj.gaccGibrBranchCd = $F("hiddenBranchCd");
				newObj.slSourceCd 	= $F("hiddenSlSourceCd");
				newObj.acctEntryId  = $F("hiddenAcctEntryId");
			}
			newObj.gaccTranId 	= objACGlobal.gaccTranId;
			newObj.slCd 		= $F("hiddenSlCd");	
			newObj.slTypeCd 	= $F("hiddenSlTypeCd");
			newObj.glAcctId 	= $F("hiddenGlAcctId");
					
			newObj.glAcctCategory = (removeLeadingZero($F("inputGlAcctCtgy")));
			newObj.glControlAcct  = (removeLeadingZero($F("inputGlCtrlAcct")));
			newObj.glSubAcct1 	  = (removeLeadingZero($F("inputSubAcct1")));
			newObj.glSubAcct2 	  = (removeLeadingZero($F("inputSubAcct2")));
			newObj.glSubAcct3 	  = (removeLeadingZero($F("inputSubAcct3")));
			newObj.glSubAcct4 	  = (removeLeadingZero($F("inputSubAcct4")));
			newObj.glSubAcct5 	  = (removeLeadingZero($F("inputSubAcct5")));
			newObj.glSubAcct6 	  = (removeLeadingZero($F("inputSubAcct6")));
			newObj.glSubAcct7 	  = (removeLeadingZero($F("inputSubAcct7")));
			newObj.debitAmt 	= $F("inputDebitAmt") == null ? 0 : ($F("inputDebitAmt") == "" ? 0 : unformatCurrency("inputDebitAmt")); //: parseFloat($F("inputDebitAmt").replace(/,/g, "")));
			newObj.creditAmt 	= $F("inputCreditAmt") == null ? 0 : ($F("inputCreditAmt") == "" ? 0 : unformatCurrency("inputCreditAmt"));
			newObj.remarks 		= ($F("inputEntryRemarks"));
			newObj.sapText 		= ($F("inputSapText"));
			newObj.glAcctName 	= escapeHTML2($F("inputGlAcctName")); //added escapeHTML2 by robert 10.19.2013
			newObj.slName 		= $F("inputSlName") == "" ? null : escapeHTML2($F("inputSlName"));
			newObj.acctCode		= (removeLeadingZero($F("inputGlAcctCtgy"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputGlCtrlAcct"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct1"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct2"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct3"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct4"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct5"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct6"))) + " - " +
								  formatToTwoDecimal(removeLeadingZero($F("inputSubAcct7")));
			
			/*start-Gzelle 11102015 KB#132 AP/AR ENH*/
			newObj.dspIsExisting 	  = $F("hidDspIsExisting");
			if ($F("hidKnockOff") == "Y" && type == 0) {
				newObj.ledgerCd		  = obj.ledgerCd;
				newObj.subLedgerCd	  = obj.subLedgerCd;
				newObj.transactionCd  = obj.transactionCd;
				newObj.acctSeqNo	  =	obj.acctSeqNo;
				newObj.acctTranType	  = getAcctTranType();
				newObj.acctRefNo	  = obj.acctRefNo;
				newObj.drCrTag	 	  = obj.drCrTag;
				newObj.outstandingBal = obj.outstandingBal;

				if (obj.drCrTag == "D") {
					newObj.creditAmt 	= obj.outstandingBal;
				} else if (obj.drCrTag == "C") {
					newObj.debitAmt  	= obj.outstandingBal;
				}
				
				$("hidOutstandingBal").value = obj.outstandingBal;
				$("hidDrCrTag").value = obj.drCrTag;
			} else {
				if ($F("hidDspIsExisting") == "Y" || $F("txtLedgerCd") != "") {
					newObj.ledgerCd		  = escapeHTML2($F("txtLedgerCd"));
					newObj.subLedgerCd	  = escapeHTML2($F("txtSubLedgerCd"));
					newObj.transactionCd  = escapeHTML2($F("txtTranCd"));
					newObj.acctSeqNo	  =	nvl($F("txtSeqNo"),0);
					newObj.acctTranType	  = getAcctTranType();
					newObj.acctRefNo	  = escapeHTML2($F("txtLedgerCd")) + " - " +
											escapeHTML2($F("txtSubLedgerCd")) + " - " +
											escapeHTML2($F("txtTranCd")) + " - " +
											$F("txtSlCd")  + " - " +
											nvl($F("txtSeqNo"),0);
				}				
			}
			if ($("hiddenSlTypeCd").getAttribute("isSlExisting") == "N") {
				newObj.slCd = $F("txtSlCd");
			}
			/*end-Gzelle 11102015 KB#132 AP/AR ENH*/
			return newObj;			
		}catch(e){
			showErrorMessage("Set Accounting Entry Object");
		}
	}
	
	function addAccountingEntry(){
		try{
			var newObj = setAccountingEntryObj(0,"");	//modified by Gzelle 12152015 AP/AR ENH
			if ($F("btnAddEntry") == "Update"){
				newObj = setAccountingEntryObj(1,"");	//modified by Gzelle 12152015 AP/AR ENH
				for(var i=0; i<objAcctEntriesArray.length; i++){
					if((objAcctEntriesArray[i].recordStatus != -1)
							&&(objAcctEntriesArray[i].gaccTranId == newObj.gaccTranId)
							&&(objAcctEntriesArray[i].acctEntryId == newObj.acctEntryId)){
						newObj.recordStatus = 1;
						computeTotalsAE(newObj.debitAmt, newObj.creditAmt);
						objAcctEntriesArray.splice(i, 1, newObj);
						accountingEntriesTableGrid.updateVisibleRowOnly(newObj, accountingEntriesTableGrid.getCurrentPosition()[1]);
					}
				} 
			}else{
				/* start - modified by Gzelle 12152015 AP/AR ENH */
				if ($F("hidKnockOff") == "Y") {
					for ( var i = 0; i < recToAdd.length; i++) {
						newEntryId += 1;
						newObj = setAccountingEntryObj(0, recToAdd[i]);
						newObj.recordStatus = 0;
						computeTotalsAE(newObj.debitAmt, newObj.creditAmt);
						objAcctEntriesArray.push(newObj);
						accountingEntriesTableGrid.addBottomRow(newObj);
					}
					acctRefNoList = recToAdd;
					recToAdd = 	[];
				} else {
					newEntryId += 1;
					newObj = setAccountingEntryObj(0,"");
					newObj.recordStatus = 0;
					computeTotalsAE(newObj.debitAmt, newObj.creditAmt);
					objAcctEntriesArray.push(newObj);
					accountingEntriesTableGrid.addBottomRow(newObj);
				}
				/* end - modified by Gzelle 12152015 AP/AR ENH */
			}
			changeTag = 1;
			populateAcctEntries(null);
		}catch (e){
			showErrorMessage("Add Accounting Entry", e);
		}
	}
		
 	function deleteAccountingEntryObj(){
		try{
			var delObj = setAccountingEntryObj(1,"");	//modified by Gzelle 12152015 AP/AR ENH
			if (nvl(delObj.generationType, "X") == "X") {
				for(var i=0; i<acctRefNoList.length; i++) {
					for(var b = 0; b < objAcctEntriesArray.length; b++) {
						if(acctRefNoList[i].ledgerCd == objAcctEntriesArray[b].ledgerCd
								&& acctRefNoList[i].subLedgerCd == objAcctEntriesArray[b].subLedgerCd
								&& acctRefNoList[i].transactionCd == objAcctEntriesArray[b].transactionCd
								&& acctRefNoList[i].acctSeqNo == objAcctEntriesArray[b].acctSeqNo) {
							acctRefNoList.splice(i,1);
						}
					}
				}
				for(var i=0; i<objAcctEntriesArray.length; i++){
					if(( objAcctEntriesArray[i].recordStatus != -1)
							&&(objAcctEntriesArray[i].gaccTranId == delObj.gaccTranId)
							&&(objAcctEntriesArray[i].acctEntryId == delObj.acctEntryId)){
						delObj.recordStatus = -1;
						//computeTotalsAE(-1*parseFloat(delObj.debitAmt), -1*parseFloat(delObj.creditAmt));
						computeTotalsAE(0, 0);  // edited by d.alcantara, 11-06-12
						objAcctEntriesArray.splice(i, 1, delObj);
						accountingEntriesTableGrid.deleteRow(accountingEntriesTableGrid.getCurrentPosition()[1]);
						changeTag = 1;
					}
				}
				changeTag = 1;
				populateAcctEntries(null);
			} else {
				showMessageBox("Deletion is not allowed for module - generated entries.");
			}
		}catch (e){
			showErrorMessage("Delete Accounting Entry", e);
		}
	}
 	
 	function saveAcctEntries() {
 		if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS030")){ //marco - SR-5719 - 11.04.2016
			return;
		}
 		
		try {
			var objParameter = new Object();
			
			objParameter.addedEntries = getAddedAndModifiedJSONObjects(objAcctEntriesArray);
			objParameter.delEntries = getDeletedJSONObjects(objAcctEntriesArray);
			
			new Ajax.Request(contextPath+"/GIACAcctEntriesController?action=saveAcctEntries", {
				method: "POST",
				parameters: {gaccTranId: objACGlobal.gaccTranId,
							 parameters: JSON.stringify(objParameter)},
				onCreate: function() {
					showNotice("Saving Accounting Entries, please wait...");
				},
				onComplete: function(response) {
					hideNotice();
					if(checkErrorOnResponse(response)) {
						if(response.responseText == "SUCCESS") {
							showWaitingMessageBox("Saving successful.", imgMessage.SUCCESS, function() {
								$("hidDspIsExisting").value  = "";	//Gzelle 01212016 AP/AR ENH
								recToAdd = [];	//Gzelle 12162015 AP/AR ENH
								acctRefNoList = [];
								changeTag = 0;
								populateAcctEntries(null);
								accountingEntriesTableGrid.refresh();
								lastAction = "";
							});
						} else {
							showMessageBox(response.responseText.replace("Error occured. ",""),imgMessage.ERROR);
						}
					}
				}
			});
		} catch(e) {
			showErrorMessage("saveAcctEntries", e);
		}
	}

 	//added by reymon 04292013
 	$("inputDebitAmt").observe("blur", function() {
 		//adpascual 08232012
		if($F("inputDebitAmt") == null || $F("inputDebitAmt") == '') {
			$("inputDebitAmt").value =  formatCurrency(0); 
		}
		if($F("inputCreditAmt") == null || $F("inputCreditAmt") == '') {
			$("inputCreditAmt").value = formatCurrency(0); 
		}
		//end
 		$("inputDebitAmt").value = formatCurrency($F("inputDebitAmt"));
 	});
 	//end reymon
 	$("inputDebitAmt").observe("change", function() {
 		if(parseFloat(unformatCurrency("inputDebitAmt")) > 9999999999.99) {
			showMessageBox("Invalid Debit Amount. Valid value is from 0.00 to 9,999,999,999.99.");
			$("inputDebitAmt").clear();
			$("inputDebitAmt").focus();
		//} else if(isNaN($F("inputDebitAmt"))) {
		} else if(isNaN(unformatCurrency("inputDebitAmt"))) {
			showMessageBox("Invalid amount. Valid value is from 0.00 to 9,999,999,999.99.");
			$("inputDebitAmt").clear();
			$("inputDebitAmt").focus();
		} else if(parseFloat(unformatCurrency("inputDebitAmt")) < 0) {
			showMessageBox("Invalid Debit Amount. Valid value should be from 0.00 to 9,999,999,999.99.");
			$("inputDebitAmt").clear();
			$("inputDebitAmt").focus();
		} else if ($F("txtLedgerCd") != "") {	//start - Gzelle 12112015 AP/AR ENH
			valDrCrAmount($F("hidDrCrTag"));
		}																							//end - Gzelle 12112015 AP/AR ENH
	});

 	//added by reymon 04292013
 	$("inputCreditAmt").observe("blur", function() {
 		//adpascual 08232012
		if($F("inputDebitAmt") == null || $F("inputDebitAmt") == '') {
			$("inputDebitAmt").value =  formatCurrency(0); 
		}
		if($F("inputCreditAmt") == null || $F("inputCreditAmt") == '') {
			$("inputCreditAmt").value = formatCurrency(0); ; 
		}
		//end
 		$("inputCreditAmt").value = formatCurrency($F("inputCreditAmt"));
 	});
 	//end reymon
 	$("inputCreditAmt").observe("change", function() {
		if(parseFloat(unformatCurrency("inputCreditAmt")) > 9999999999.99) {
			showMessageBox("Invalid Credit Amount. Valid value is from 0.00 to 9,999,999,999.99.");
			$("inputCreditAmt").clear();
			$("inputCreditAmt").focus();
		//} else if(isNaN($F("inputCreditAmt"))) {
		} else if(isNaN(unformatCurrency("inputCreditAmt"))) {
			showMessageBox("Invalid amount. Valid value is from 0.00 to 9,999,999,999.99.");
			$("inputCreditAmt").clear();
			$("inputCreditAmt").focus();
		} else if(parseFloat(unformatCurrency("inputCreditAmt")) < 0) {
			showMessageBox("Invalid Credit Amount. Valid value is from 0.00 to 9,999,999,999.99.");
			$("inputCreditAmt").clear();
			$("inputCreditAmt").focus();
		} else if ($F("txtLedgerCd") != "") {	//start - Gzelle 12112015 AP/AR ENH
			valDrCrAmount($F("hidDrCrTag"));
		}																	//end - Gzelle 12112015 AP/AR ENH
	});
	
	$$("input[name='glAccountCode']").each(function(gl) {
		gl.observe("change", function() {
			checkGLCodeError(gl.id);
		});
	});
	
	$("inputGlAcctCtgy").observe("change", function () {
		if(isNaN($("inputGlAcctCtgy").value) || parseInt($("inputGlAcctCtgy").value) < 0  || parseInt($("inputGlAcctCtgy").value) > 9 || checkDecimal($("inputGlAcctCtgy").value)) {
			customShowMessageBox("Invalid GL Account Code. Valid value should be from 0 to 9.", imgMessage.ERROR, "inputGlAcctCtgy");
			$("inputGlAcctCtgy").clear();
		}else if($("inputGlAcctCtgy").value == "") {
			$("inputGlAcctCtgy").value = ""
		} else {
			//$("inputGlAcctCtgy").value 	= parseInt($F("inputGlAcctCtgy")).toPaddedString(2);
			getGLAccount();
		}
	});

	function checkGLCodeError(elem) {
		if(isNaN($(elem).value) || parseInt($(elem).value) < 0  || parseInt($(elem).value) > 99 || checkDecimal($(elem).value)) {
			customShowMessageBox("Entered value is invalid. Valid value is from 0 to 99.", imgMessage.ERROR, elem);
			$(elem).clear();
			$(elem).focus();
		} else if($(elem).value == "") {
			$(elem).value = ""
		} else {
			$(elem).value = parseInt(removeLeadingZero($F(elem))).toPaddedString(2);
			getGLAccount();
		}
	}
	
	function checkDecimal(txtId){
		for(var i = 0; i < txtId.length; i++){
			if (txtId.charAt(i)=='.'){
				return true;
			}
		}
		return false;
	}
	
	function getGLAccount() {
		try {
			var valid = true;
			$$("input[name='glAccountCode']").each(function(gl) {
				if(gl.value == "") {
					valid = false;
				}
			});
			
			if ($("inputGlAcctCtgy").value == ""){
				valid = false;
			}
			
			if(valid) {
				new Ajax.Request(contextPath+"/GIACAcctEntriesController", {
					method: "GET",
					parameters: {
						action: "retrieveGlAcct",
						glAcctObj: getGlAcctObj()
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response) {
						var res = JSON.parse(response.responseText);
						if(res.empty != true) {
							$("inputGlAcctName").value 	= res.glAcctName;
							$("hiddenGlAcctId").value 	= res.glAcctId;
							$("hiddenSlTypeCd").value	= res.gsltSlTypeCd;
							$("inputSlName").value 		= "";
							validateGlAcctId(res.glAcctId,res.gsltSlTypeCd);	//Gzelle 12072015 KB#132 AP/AR ENH
							if(res.gsltSlTypeCd == null || res.gsltSlTypeCd == "") {
								$("inputSlName").removeClassName("required");
								$("selectSlDiv").removeClassName("required");
								$("inputSlName").style.backgroundColor = "#FFFFFF";
								disableSearch("searchSlCd");
							} else {
								if ($("hiddenSlTypeCd").getAttribute("isSlExisting") == "Y") {
									$("inputSlName").addClassName("required");
									$("selectSlDiv").addClassName("required");
									$("inputSlName").style.backgroundColor = "#FFFACD";
								}else {
									$("inputSlName").removeClassName("required");
									$("selectSlDiv").removeClassName("required");
									$("inputSlName").style.backgroundColor = "#FFFFFF";
								}
								enableSearch("searchSlCd");								
							}
						} else {
							showMessageBox("There is no account name existing for this account code.", imgMessage.ERROR);
							validateGlAcctId(res.glAcctId,res.gsltSlTypeCd);	//Gzelle 12072015 KB#132 AP/AR ENH
							$("inputGlAcctName").value 	= "";
							$("inputSlName").value 	= "";
							$("hiddenGlAcctId").value 	= "";
							$("hiddenSlTypeCd").value   = "";
							
							$("inputSlName").removeClassName("required");
							$("selectSlDiv").removeClassName("required");
							$("inputSlName").style.backgroundColor = "#FFFFFF";
							disableSearch("searchSlCd");
						}
					}
				});
			} else {
				$("inputGlAcctName").value 	= "";
				$("inputSlName").value 		= "";
				$("hiddenGlAcctId").value 	= "";
				$("hiddenSlTypeCd").value 	= "";
				
				$("inputSlName").removeClassName("required");
				$("selectSlDiv").removeClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFFFF";
				disableSearch("searchSlCd");
			}
		} catch(e) {
			showErrorMessage("getGLAccount", e);
		}
	}
	
	function checkRequiredFields(){
		try{
			var isOk = true;
						
			$$("input[type='text'].required").each(function (m) {
				if (m.value == "") {
					showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
					isOk = false;
				}
			});
			return isOk;
		}catch(e){
			showErrorMessage("checkRequiredFields", e);
		}
	}

	function formatToTwoDecimal(num) {
		num = parseInt(num);
		return num.toPaddedString(2);
	}
	
	$("btnViewGlBal").observe("click", function() {
		if(unformatCurrency("txtDebitTotal") == 0 && unformatCurrency("txtCreditTotal") == 0){
			showMessageBox("Either Debit or Credit must have a value.");
		}else if(changeTag == 1){
			showMessageBox("Cannot view GL Balance when there are unsaved changes.");
		}else{
			viewGlBalance();
		}
	});
	
	function viewGlBalance(){
		glBalance = Overlay.show(contextPath+"/GIACAcctEntriesController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: "viewGlBalance",
				gaccTranId: objACGlobal.gaccTranId},
		    title: "GL Balance",
		    height: 500,
		    width: 700
		});
	}
	
	$("btnCloseTrans").observe("click", function() {
		if(changeTag ==1) {
			showConfirmBox2("Confirmation", "There are unsaved changes. Do you want to save them?", "Yes", "No", saveAndClose, showCloseTransError);
		}else if(unformatCurrency("txtDebitTotal") == 0 && unformatCurrency("txtCreditTotal") == 0){
			showMessageBox("Either Debit or Credit must have a value.");
		}else if($F("hiddenTranClass") == 'DV' || $F("hiddenTranClass") == 'DISB_REQ'){
			if (objGIACS002.allowCloseTrans == "Y"){	// added condition to allow closing of transaction if Manual DV : shan 09.15.2014
				if ($F("tranFlag") == "C"){
					showMessageBox("This disbursement request has already been closed.", "I");
					return;
				}else if ($F("tranFlag") == "P"){
					showMessageBox("Update not allowed.", "I");
					return;
				} else if ($F("tranFlag") == "O"){
					closeTrans();	
				}
			}else{
				showMessageBox("Cannot close transaction. The system will automatically close the transaction after printing of DV/ Check.");
			}
		} else if ($F("hiddenTranClass") == "COL"){ // bonok :: 07.26.2013 :: as per Sir JM, if tran_class = 'COL', transaction should be able to close as long as total debit and credit amount is balanced 
			if(objAC.tranFlagState == "O" && objACGlobal.orFlag == "P"){ //added by steven to close the OR if it is already printed. magagawa mo tong scenario na to kapag ung giac_parameters.param_name = 'AUTO_CLOSE_OR' ay nakaset sa "N". 02.18.2013
				closeTrans();
			}else{
				showMessageBox("Cannot close transaction. The system will automatically close the transaction after printing of OR.");
			}
		} else if ($F("hiddenTranClass") == "JV"){//added steven 05.17.2013
			if (validateUserFunc2("CL","GIACS030")) {
				if (checkUserPerIssCdAcctg($F("branch"),"GIACS030") != "0") {
					closeTrans();
				} else {
					showMessageBox("User has no access to close accounting entries for this branch.","E");
				}
			} else {
				showMessageBox("You are not authorized to close transaction accounting entries.","E");
			}
		} else {
			closeTrans();
		}
	});
	
	function saveAndClose() {
		saveAcctEntries();
		closeTrans();
	}


	function showCloseTransError() {
		showMessageBox("Unable to close transaction when there are unsaved records.");
		return false;
	}
	
	function getGlAcctObj() {
		var acctIdObj = new Object();
		acctIdObj.glAcctCategory	=	$F("inputGlAcctCtgy") == "" ? "" : parseInt($F("inputGlAcctCtgy"));
		acctIdObj.glControlAcct		=	$F("inputGlCtrlAcct") == "" ? "" : removeLeadingZero($F("inputGlCtrlAcct"));
		acctIdObj.glSubAcct1		=	$F("inputSubAcct1") == "" ? "" : removeLeadingZero($F("inputSubAcct1"));
		acctIdObj.glSubAcct2		=	$F("inputSubAcct2") == "" ? "" : removeLeadingZero($F("inputSubAcct2"));
		acctIdObj.glSubAcct3		=	$F("inputSubAcct3") == "" ? "" : removeLeadingZero($F("inputSubAcct3"));
		acctIdObj.glSubAcct4		=	$F("inputSubAcct4") == "" ? "" : removeLeadingZero($F("inputSubAcct4"));
		acctIdObj.glSubAcct5		=	$F("inputSubAcct5") == "" ? "" : removeLeadingZero($F("inputSubAcct5"));
		acctIdObj.glSubAcct6		=	$F("inputSubAcct6") == "" ? "" : removeLeadingZero($F("inputSubAcct6"));
		acctIdObj.glSubAcct7		=	$F("inputSubAcct7") == "" ? "" : removeLeadingZero($F("inputSubAcct7"));
		return JSON.stringify(acctIdObj);
	}

	$("searchGlAcct").observe("click", function() {
		if($F("hiddenGenType")=="X" || $F("hiddenGenType").blank()) {
			var notIn = "";
			var withPrevious = false;
			for(var i=0; i<objAcctEntriesArray.length; i++) {
				if(withPrevious) notIn += ",";
				notIn += objAcctEntriesArray[i].glAcctId;
				withPrevious = true;
			}
			notIn = (notIn != "" ? "("+notIn+")" : "");
			var acctIdObj = getGlAcctObj();
			
			//showChartOfAcctsLOV("", acctIdObj, $F("inputGlAcctName"));
			showChartOfAcctsLOV("", "{}", "%"); //modified by robert 11.27.2013; LOV should not be filtered, should display all values
		} else {
			showMessageBox("Update not allowed for this record.");
			return false;
		} 
	});

	$("searchSlCd").observe("click", function() {
		var slTypeCd = $F("hiddenSlTypeCd");
		showSlListLOV(slTypeCd, "GIACS030");
	});

	$("inputEntryRemarks").observe("keyup", function () {
		limitText(this, 4000);
	});
	
	$("editRemarksText").observe("click", function () {
		showEditor("inputEntryRemarks", 4000);
		if($F("btnAddEntry") == "Update" && $("btnAddEntry").disabled == true){
			showEditor("inputEntryRemarks", 4000, "true");
		}else if(objACGlobal.tranFlagState == "C" || objACGlobal.tranFlagState == "P"){
			showEditor("inputEntryRemarks", 4000, "true");
		} 
	});
	
	$("editSapText").observe("click", function () {
		showEditor("inputSapText", 50);
		if($F("btnAddEntry") == "Update" && $("btnAddEntry").disabled == true){
			showEditor("inputSapText", 50, "true");
		}else if(objACGlobal.tranFlagState == "C" || objACGlobal.tranFlagState == "P"){
			showEditor("inputSapText", 50, "true");
		} 
	});
	
	$("inputSapText").observe("keyup", function() {
		limitText(this, 50);
	});

	function clearGlCodeInputs() {
		$("inputGlAcctCtgy").clear();
		$("inputGlCtrlAcct").clear();
		$("inputSubAcct1").clear();
		$("inputSubAcct2").clear();
		$("inputSubAcct3").clear();
		$("inputSubAcct4").clear();
		$("inputSubAcct5").clear();
		$("inputSubAcct6").clear();
		$("inputSubAcct7").clear();
		$("inputGlAcctName").clear();

		$("inputSlName").clear();
		$("inputSlName").removeClassName("required");
		$("selectSlDiv").removeClassName("required");
		$("inputSlName").style.backgroundColor = "#FFFFFF";
		disableSearch("searchSlCd");
		disableSearch("imgSearchTranCd");	//Gzelle 11062015 KB#132 AP/AR ENH
	}
	
	/* $("inputGlAcctName").observe("keyup", function(e) {
		if (objKeyCode.BACKSPACE == e.keyCode && 
				document.getElementById("inputGlAcctName").getAttribute("readonly") == "readonly"
					){
			if($F("hiddenGenType")=="X" || $F("hiddenGenType").blank() ||  $F("hiddenGenType") == "") {
				clearGlCodeInputs();
			}
		}	
	});

	$("inputSlName").observe("keyup", function(e) {
		if (objKeyCode.BACKSPACE == e.keyCode){
				$("inputSlName").clear();
		}	
	}); */

	//added by steven 1/11/2013
	$$("input[type='text'].difference").each(function (m) {
		m.observe("focus", function ()	{
			if (m.value.include("<")){
				m.select();
				m.value = m.value;
			}else{
				m.select();
				m.value = (m.value).replace(/,/g, "");
			}
		});

		m.observe("blur", function ()	{
			if (m.value.include("<")){
				m.value = (m.value == "" ? "" :m.value);
			}else{
				m.value = (m.value == "" ? "" :formatCurrency(m.value));
			}
		});		
	});
	
	
	$("btnCancelEntry").stopObserving("click");
	$("btnCancelEntry").observe(
			"click",
			function() {
				$("acExit").click();//change by steven 04.09.2013;same lang kasi sila ng function
				/*if (changeTag == 1) {
					showConfirmBox4("CONFIRMATION",
							objCommonMessage.WITH_CHANGES, "Yes", "No",
							"Cancel", function() {
								saveAcctEntries();
								if(objACGlobal.calledForm == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else{
									editORInformation();
								}
							}, function() {
								if(objACGlobal.calledForm == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else{
									editORInformation();
								}
								changeTag = 0;
							}, "");
				} else {
					if(objACGlobal.calledForm == "GIACS016"){
						showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
					}else{
						editORInformation();
					}
				} */
			});

	$("acExit").stopObserving("click");
	$("acExit").observe(
			"click",
			function() {
				if(objACGlobal.previousModule == "GIACS003"){ //added by steven 04.09.2013
					if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
						showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
					}else{
						showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
					}
					objACGlobal.previousModule = null;
				}else if(objACGlobal.previousModule == "GIACS071"){
					updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
					objACGlobal.previousModule = null;					
				}else if(objACGlobal.previousModule == "GIACS002"){
					showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
					objACGlobal.previousModule = null;
				}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
					showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
					objACGlobal.previousModule = null;
				}else if(objACGlobal.previousModule == "GIACS070"){ //added by shan 08.27.2013
					showGIACS070Page();
					objACGlobal.previousModule = null;
				}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
					$("giacs031MainDiv").hide();
					$("giacs032MainDiv").show();
					$("mainNav").hide();
				} else{
					if (changeTag == 1) {
						showConfirmBox4("CONFIRMATION",
								objCommonMessage.WITH_CHANGES, "Yes", "No",
								"Cancel", function() {
									saveAcctEntries();
									if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
										showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
									}else{
										editORInformation();
									}
								}, function() {
									if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
										showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
									}else{
										editORInformation();
									}
									changeTag = 0;
								}, "");
					} else {
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else{
							editORInformation();
						}
					}
				}
			});
	
	window.scrollTo(0,0); 
	populateAcctEntries(null);
	changeTag = 0;
		
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS030(){
		try {
			$("inputGlAcctCtgy").removeClassName("required");
			$("inputGlAcctCtgy").readOnly = true;
			$("inputGlCtrlAcct").removeClassName("required");
			$("inputGlCtrlAcct").readOnly = true;
			$("inputSubAcct1").removeClassName("required");
			$("inputSubAcct1").readOnly = true;
			$("inputSubAcct2").removeClassName("required");
			$("inputSubAcct2").readOnly = true;
			$("inputSubAcct3").removeClassName("required");
			$("inputSubAcct3").readOnly = true;
			$("inputSubAcct4").removeClassName("required");
			$("inputSubAcct4").readOnly = true;
			$("inputSubAcct5").removeClassName("required");
			$("inputSubAcct5").readOnly = true;
			$("inputSubAcct6").removeClassName("required");
			$("inputSubAcct6").readOnly = true;
			$("inputSubAcct7").removeClassName("required");
			$("inputSubAcct7").readOnly = true;
			$("inputGlAcctName").removeClassName("required");
			$("inputGlAcctName").readOnly = true;
			$("glAcctNameDiv").removeClassName("required");
			disableSearch("searchGlAcct");
			$("inputDebitAmt").readOnly = true;
			$("inputCreditAmt").readOnly = true;
			$("inputDebitAmt").removeClassName("required");
			$("inputCreditAmt").removeClassName("required");
			$("inputEntryRemarks").readOnly = true;
			$("inputSapText").readOnly = true;
			disableButton("btnDelEntry");
			disableSearch("searchSlCd");
			disableButton("btnAddEntry");
			disableButton("btnSaveEntry");
			disableButton("btnCloseTrans");
			if (nvl($F("tranFlag"), '*') != "C"
				&& nvl($F("tranFlag"), "*") != "P"
				&& !((objACGlobal.previousModule == "GIACS002" && objACGlobal.dvTag != "M") //Deo [02.10.2017]: added dv_tag condition (SR-5924)
						|| objACGlobal.callingForm == "GIACS237" || objACGlobal.fromDvStatInq == 'Y')) { //added fromDvStatInq by Robert SR 5189 12.22.15
				enableButton("btnCloseTrans");
			}
			/*start - Gzelle 11122015 KB#132 AP/AR ENH*/
			$("rdoSetUp").disable();
			$("rdoKnockOff").disable();
			$("selTranDiv").removeClassName("required");
		 	$("txtTranCd").removeClassName("required");
		 	$("selTranDiv").style.backgroundColor = "#FFFFFF";
			/*end - Gzelle 11122015 KB#132 AP/AR ENH*/
		} catch(e){
			showErrorMessage("disableGIACS030", e);
		}
	}
	
	if(objAC.fromMenu == "cancelOR" 
			|| objAC.fromMenu == "cancelOtherOR" 
			|| objAC.tranFlagState == "C" 
			|| objACGlobal.queryOnly == "Y"
			|| objACGlobal.previousModule == "GIACS002"){
		disableGIACS030();
	} else {	
		initializeChangeTagBehavior(saveAcctEntries);
		observeSaveForm("btnSaveEntry", saveAcctEntries);
		observeAcctgHome(saveAcctEntries);
	}
	
	if (objACGlobal.previousModule == "GIACS149"){
		$("acExit").show();
	}
	
	/*--start Gzelle 11052015 KB#132 AP/AR ENH--*/
	function valAddGlAcctRefNo(func) {
		var acctTranType = getAcctTranType();
		var addedSameExists = false;
		var deletedSameExists = false;
		
		for(var i=0; i<accountingEntriesTableGrid.geniisysRows.length; i++){
			if(accountingEntriesTableGrid.geniisysRows[i].recordStatus == 0 || accountingEntriesTableGrid.geniisysRows[i].recordStatus == 1){								
				if(accountingEntriesTableGrid.geniisysRows[i].glAcctId == $F("hiddenGlAcctId")
						&& accountingEntriesTableGrid.geniisysRows[i].ledgerCd == $F("txtLedgerCd")
						&& accountingEntriesTableGrid.geniisysRows[i].subLedgerCd == $F("txtSubLedgerCd")
						&& accountingEntriesTableGrid.geniisysRows[i].transactionCd == $F("txtTranCd")
						&& accountingEntriesTableGrid.geniisysRows[i].slCd == $F("txtSlCd")
						&& accountingEntriesTableGrid.geniisysRows[i].acctSeqNo == $F("txtSeqNo")
						&& accountingEntriesTableGrid.geniisysRows[i].acctTranType == acctTranType){
					addedSameExists = true;								
				}							
			} else if(accountingEntriesTableGrid.geniisysRows[i].recordStatus == -1){
				if(accountingEntriesTableGrid.geniisysRows[i].glAcctId == $F("hiddenGlAcctId")
						&& accountingEntriesTableGrid.geniisysRows[i].ledgerCd == $F("txtLedgerCd")
						&& accountingEntriesTableGrid.geniisysRows[i].subLedgerCd == $F("txtSubLedgerCd")
						&& accountingEntriesTableGrid.geniisysRows[i].transactionCd == $F("txtTranCd")
						&& accountingEntriesTableGrid.geniisysRows[i].slCd == $F("txtSlCd")
						&& accountingEntriesTableGrid.geniisysRows[i].acctSeqNo == $F("txtSeqNo")
						&& accountingEntriesTableGrid.geniisysRows[i].acctTranType == acctTranType){
					deletedSameExists = true;
				}
			}
		}
		
		if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
			showMessageBox("Record already exists with the same Account Reference No..", "E");
			return;
		} else if(deletedSameExists && !addedSameExists){
			func();
			return;
		}
		
		new Ajax.Request(contextPath+ "/GIACGlAcctRefNoController", {
			method : "POST",
			parameters : {
				action : "valAddGlAcctRefNo",
			gaccTranId : objACGlobal.gaccTranId,
			  glAcctId : $F("hiddenGlAcctId"),
			  ledgerCd : $F("txtLedgerCd"),
		   subLedgerCd : $F("txtSubLedgerCd"),
	 	 transactionCd : $F("txtTranCd"),
				  slCd : $F("txtSlCd"),
			 acctSeqNo : $F("txtSeqNo"),
		  acctTranType : acctTranType
			},
		    asynchronous : false,
		    onComplete : function(response) {
		    	if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
		    		func();
				}
			}
		})
	}
	
	function getOutstandingBalance() {	/*retrieves the remaining balance (setup amount less all the knock off accounts regardless if posted or not)*/
		var remainingBal = 0;
		new Ajax.Request(contextPath+ "/GIACGlAcctRefNoController", {
			method : "POST",
			parameters : {
				action : "valRemainingBalGiacs30",
			gaccTranId : objACGlobal.gaccTranId,
			  glAcctId : $F("hiddenGlAcctId"),
		 		  slCd : $F("txtSlCd"),
		     acctRefNo : $F("hidAcctRefNo"),
		  acctTranType : getAcctTranType(),
		 transactionCd : $F("txtTranCd"),
		     acctSeqNo : $F("txtSeqNo")
			},
			asynchronous : false,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					res = JSON.parse(response.responseText);
					remainingBal = res[0].remainingBal;
					 if (objACGlobal.tranFlagState == "O") {
						if (res[0].dspIsRecExisting == "Y") {
							/*return the current knock off amount to the remaining balance, so that it will be included in the maximum amount the
						 	current record could use, if record is already saved on the database*/
							remainingBal = parseFloat(remainingBal) + parseFloat($("hidOutstandingBal").getAttribute("currKnockOffAmt"));
						}
					}
					$("hidOutstandingBal").value = remainingBal;
				}
			}
		});
	}
	
	function valDrCrAmount(drCrTag) {
		var field = null;
		var drCrDesc = drCrTag == "D" ? "Debit" : "Credit";
		var knockOffMsg = "";
		if ($("rdoKnockOff").checked) { 
			/* reverse scenario for Knock-Off
			** drCrTag = D : check outstanding balance for Credit
		    **  		   : check if amount is greater than 0 for Debit
			** drCrTag = C : check outstanding balance for Debit
		    **  		   : check if amount is greater than 0 for Credit		    
			*/
			if (drCrTag == "D") {
				userOverride("inputCreditAmt");
				field = "inputDebitAmt";
			}else {
				userOverride("inputDebitAmt");
				field = "inputCreditAmt";
			}
			knockOffMsg = " during Knock-off.";
		}else {
			/* scenario for Setup
			** drCrTag = C : check if amount is greater than 0 amount for Debit
			** drCrTag = D : check if amount is greater than 0 amount for Credit		    
			*/
			if (drCrTag == "D") {
				field = "inputCreditAmt";
			}else {
				field = "inputDebitAmt";
			}
			knockOffMsg = ".";
		}
		
		if(parseFloat(unformatCurrency(field)) > 0) {
			showWaitingMessageBox("The GL Account selected is tagged as "+ drCrDesc +
							", you cannot enter a " + $(field).getAttribute("customLabel") + " that is greater than zero" + knockOffMsg,imgMessage.INFO, function() {
								$(field).value = formatCurrency(0);
							});
		}
	}
	
	function userOverride(field) {
		if(parseFloat(unformatCurrency(field)) > parseFloat(unformatCurrency("hidOutstandingBal"))) {
			showConfirmBox("", "Amount entered exceeds the outstanding balance. Would you like to continue?",
					"Yes", "No", 
					function() {	/*Yes Function*/
						if (!validateUserFunc2("EO", "GIACS030")) {
							showGenericOverride( // this is the original function
									"GIACS030",
									"EO",
									function(ovr, userId, result){
										if(result == "FALSE"){
											showMessageBox("User " + userId + " is not allowed for override.", imgMessage.ERROR);
											$("txtOverrideUserName").clear();
											$("txtOverridePassword").clear();
											$("txtOverrideUserName").focus();
											return false;
										} else {
											if(result == "TRUE"){
												ovr.close();
												delete ovr;	
											}	
										}
									},
									function() {	//onCancel
										$(field).value = formatCurrency($(field).getAttribute("lastValidValue"));
									}
							);	
						}
					},
					function() {	/*No Function*/
						$(field).value = formatCurrency($(field).getAttribute("lastValidValue"));
					}, "");
		}
	}
	
	function getAcctTranType(){
		var tag = "";
		$$("input[name='rdoAcctTranType']").each(function(a){
			if($(a.id).checked){
				tag = $(a.id).value;
			}
		});	
		return tag;
	}
	
	function showAcctRefNo() {
		var addedAcctRefNo = "";
		if (acctRefNoList.length > 0) {
			for(var i=0; i<acctRefNoList.length; i++) {
				addedAcctRefNo = acctRefNoList[i].acctRefNo + "," + addedAcctRefNo;
			}
		}

		acctRefNoOverlay = Overlay.show(contextPath+"/GIACGlAcctRefNoController", {
			asynchronous : true,
			urlContent: true,
			draggable: true,
			onCreate : showNotice("Loading, please wait..."),
			urlParameters: {
				action     	: "showGlAcctRefNo",
				glAcctId 	: $F("hiddenGlAcctId"),
				slCd 		: $F("txtSlCd"),
			  transactionCd : $F("txtTranCd"),
			  gaccTranId	: objACGlobal.gaccTranId, 
			addedAcctRefNo  : addedAcctRefNo
			},
		    title: "Account Reference No",
		    height: 490,
		    width: 860
		});	
	}
	
	$("rdoSetUp").checked = true;	
	prevRdo = "rdoSetUp";
	disableInputField("txtTranCd");
	disableSearch("imgSearchSeqNo");
	disableSearch("imgSearchTranCd");

	$("imgSearchSeqNo").observe("click", function() {
		showAcctRefNo();
	});
	
	$("imgSearchTranCd").observe("click", function() {
		showGlTranTypeLOV("%", $F("txtLedgerCd"), $F("txtSubLedgerCd"));
	});
	
	$("txtTranCd").observe("change", function() {
		if (this.value != "") {
			showGlTranTypeLOV($F("txtTranCd"), $F("txtLedgerCd"), $F("txtSubLedgerCd"));
		}
	});		
	
	function fireRdoClick() {
		$$("input[name='rdoAcctTranType']").each(function(radio) {
			radio.observe("click", function() {
				if ($F("hiddenGlAcctId") != "") {
					if ((parseFloat(unformatCurrency("inputDebitAmt")) != 0 || parseFloat(unformatCurrency("inputCreditAmt")) != 0)
							&& ($F("inputDebitAmt") != "" || $F("inputCreditAmt") != "")) {
						showConfirmBox("Account Transaction Type",
								"This will update the Debit and Credit amounts to zero. " +
								"Do you want to continue?", "Yes", "No", 
								function() {
									if ($(radio).checked == true && $(radio).value == "K") {
										enableSearch("imgSearchSeqNo");
										$("txtSeqNo").addClassName("required");
										$("selSeqNoDiv").addClassName("required");
										$("selSeqNoDiv").style.backgroundColor = "#FFFACD";
									}else{
										disableSearch("imgSearchSeqNo");
										disableInputField("txtSeqNo");
										$("txtSeqNo").removeClassName("required");
										$("selSeqNoDiv").removeClassName("required");
										$("selSeqNoDiv").style.backgroundColor = "#FFFFFF";
									}							
									$("inputDebitAmt").value = formatCurrency(0);
									$("inputCreditAmt").value = formatCurrency(0);
									prevRdo = radio.id;
								}, 
								function() {
									$(prevRdo).checked = true;
								}, "");
					} else {
						prevRdo = radio.id;
						if ($(radio).checked == true && $(radio).value == "K") {
							enableSearch("imgSearchSeqNo");
							$("txtSeqNo").addClassName("required");
							$("selSeqNoDiv").addClassName("required");
							$("selSeqNoDiv").style.backgroundColor = "#FFFACD";
						}else{
							disableSearch("imgSearchSeqNo");
							$("txtSeqNo").removeClassName("required");
							$("selSeqNoDiv").removeClassName("required");
							$("selSeqNoDiv").style.backgroundColor = "#FFFFFF";
						}	
					}
				}
			});
		});
	}
	
	fireRdoClick();
	/*--end Gzelle 11062015 KB#132 AP/AR ENH--*/
	
	initializeAll();
	addStyleToInputs();
	initializeAllMoneyFields();
</script>