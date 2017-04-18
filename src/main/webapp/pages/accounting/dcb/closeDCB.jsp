<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="dcbMainDiv" style="margin-top: 1px;">
	<form id="dcbForm" name="dcbForm">
		<!-- VARIABLE fields -->
		<input type="hidden" id="varAllORsRCancelled" 		name="varAllORsRCancelled" 		value="N" />
		<input type="hidden" id="varYesNo" 					name="varYesNo" 				value="N" />
		<input type="hidden" id="varTotAmtForGicdSumRec" 	name="varTotAmtForGicdSumRec" 	value="0" />
		<input type="hidden" id="varTotFcAmtForGicdSumRec" 	name="varTotFcAmtForGicdSumRec" value="0" />
		<input type="hidden" id="varPrevAdjAmt" 			name="varPrevAdjAmt" 			value="0" />
		<input type="hidden" id="varDefaultCurrency"		name="varDefaultCurrency"		value="" />
		<input type="hidden" id="varWithError"				name="varWithError"				value="N" />
		<input type="hidden" id="varWithOTC"				name="varWithOTC"				value="N" />
		<input type="hidden" id="varLocSur"					name="varLocSur"				value="" />
		<input type="hidden" id="varForSur"					name="varForSur"				value="" />
		<input type="hidden" id="varNetCollnAmt"			name="varNetCollnAmt"			value="" />
		<input type="hidden" id="varOTCSaved"				name="varOTCSaved"				value="N" />
		<input type="hidden" id="newDCBForClosing"			name="newDCBForClosing"			value="N" />
		<input type="hidden" id="moduleName"		   	    name="moduleName"		        value="GIACS035"/> <!-- dren 08.03.2015 : SR 0017729 - For Adding Accounting Entries -->
		
		<!-- CONTROL variables -->
		<input type="hidden" id="controlPrevDCBDate" 		name="controlPrevDCBDate" 			value="" />
		<input type="hidden" id="controlPrevDCBNo" 			name="controlPrevDCBNo" 			value="" />
		<input type="hidden" id="controlPrevPayMode" 		name="controlPrevPayMode" 			value="" />
		<input type="hidden" id="controlPrevCurrencyCd" 	name="controlPrevCurrencyCd" 		value="" />
		<input type="hidden" id="controlPrevCurrencyRt" 	name="controlPrevCurrencyRt" 		value="" />
		<input type="hidden" id="controlPrevAmount" 		name="controlPrevAmount" 			value="" />
		<input type="hidden" id="controlPrevForeignCurrAmt"	name="controlPrevForeignCurrAmt" 	value="" />
		<input type="hidden" id="controlPrevCurrSname" 		name="controlPrevCurrSname" 		value="" />
		
		<!-- **Misc fields** -->
		<!-- variable used to check the current mode of the page (Insert/Update) -->
		<input type="hidden" id="formStatus" name="formStatus" value="
			<c:choose>
				<c:when test='${gacc eq null }'>INSERT</c:when>
				<c:otherwise>UPDATE</c:otherwise>
			</c:choose>" />
			
		<!-- used to check if UPDATE_DCB_NO will be executed upon saving -->
		<input type="hidden" id="varUpdateDCB" 			name="varUpdateDCBNo" 		value="N" />
		
		<!-- used for checking short_name of GDBD on bankDeposits and cashDeposits page -->
		<input type="hidden" id="gdbdShortName"			name="gdbdShortName"		value="" />
		
		<!-- used for checking pay_mode of GDBD on bankDeposits page -->
		<input type="hidden" id="gdbdPayMode"			name="gdbdPayMode"		value="" />
		
		<!-- the default currency code. 
				variables.default_currency is initially blank and is assigned a value in specific triggers -->
		<input type="hidden" id="defaultCurrency"		name="defaultCurrency"		value="${defaultCurrency }" />
	
		<jsp:include page="subPages/officialReceiptInformation.jsp"></jsp:include>
		<jsp:include page="subPages/collectionBreakdown.jsp"></jsp:include>
		<jsp:include page="subPages/bankAccountDetails.jsp"></jsp:include>
	</form>
	
	<div class="buttonsDiv" id="dcbButtonDiv">
		<table align="center">
			<tr>
				<td><input type="button" class="button" id="btnDeposits" name="btnDeposits" value="Deposits" style="width: 90px;"/></td>
				<td><input type="button" class="button" id="btnAcctEntries" name="btnAcctEntries" value="Accounting Entries" style="width: 130px;"/></td>
				<td><input type="button" class="button" id="btnCloseDCB" name="btnCloseDCB" value="Close DCB" style="width: 100px;"/></td>
				<td><input type="button" class="button" id="btnRefresh" name="btnRefresh" value="Refresh" style="width: 100px;"/></td> <!-- SR#18447; John Dolon; 05.25.2015 -->
				<td><input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 90px;" /></td>
				<td><input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 90px;" /></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	/** Initialization */
	setModuleId("GIACS035");
	setDocumentTitle("Close DCB");
	initializeAccordion(); 
	var objGIACS035 = {}; // dren 07.16.2015 : SR 0017729 - Added variables - Start
	var objBankAcctDetails = null; 
	var addButtonBalance = null; 
	var itemNoSeq = 0; // dren 07.16.2015 : SR 0017729 - Added variables - End	
	//added by steven 07.30.2014
	if (objACGlobal.gaccTranId == null || objACGlobal.gaccTranId == "") {
		disableButton("btnAcctEntries");
	 	disableButton("btnCloseDCB");
	 	disableButton("btnRefresh"); // //#18447; John Dolon; 5.25.2015
	}else{
		enableButton("btnAcctEntries");
	 	enableButton("btnCloseDCB");
	 	enableButton("btnRefresh"); //#18447; John Dolon; 5.25.2015
	}
	
	disableButton("btnAddGDBD"); //#18447; John Dolon; 5.25.2015

	/** Record Groups */
	var rgAmtPerPm = new Array(); // amt_per_pm
	var rgListOfChecks = new Array(); // list_of_checks
	var rgSelected = new Array(); // selected

	/** Block Objects */
	objACModalboxParams = new Object();
	
	var gbds2BlockRows = [];
	var gcddBlockRows = [];
	var gbdsBlockRows = [];
	var gbdsdBlockRows = [];
	var errorBlockRows = [];
	var otcBlockRows = [];
	
	var gaccDspFundCd;

	var updateEntries = "Y";
	var closingParam = new Object();
	
	var objGIACS035 = {};
	
	/** Disable fields if Mode is Update */
	if (nvl($F("formStatus").trim(), "INSERT") == "UPDATE") { //added by steven 1/16/2012 "trim()"
		$("gaccDspDCBNo").readOnly = true;
	} else if (nvl($F("formStatus").trim(), "INSERT") == "INSERT") {//added by steven 1/16/2012 "trim()"
		$("gaccTranFlag").value = "O";
		$("gaccMeanTranFlag").value = nvl('${tranFlagMean }', "");
		
		if ($F("gaccMeanTranFlag").blank()) {
			showMessageBox("Tran_flag_mean not found.", imgMessage.ERROR);
		}
	}

	/** Disable Close DCB Button and Add GDBD if DCB Flag is 'Closed (emman 06.14.2011) **/
	if($F("gaccDspDCBFlag") == "C") {
		disableButton("btnCloseDCB");
		disableButton("btnAddGDBD");
		disableButton("btnRefresh"); //#18447; John Dolon; 5.25.2015
	}

	/** Table Grids */
	
	// row
	var selectedGicdSumRow = null;
	var selectedGdbdRow	   = null;

	// index
	var selectedGdbdIndex  = null;
		
	try {
		var objGicdSum = new Object();
		objGicdSum.objGicdSumListTableGrid = JSON.parse('${gicdSumListTableGrid}'.replace(/\\/g, '\\\\'));
		objGicdSum.objGicdSumList = objGicdSum.objGicdSumListTableGrid.rows || [];

		var gicdSumTableModel = {
				url: contextPath+"/GIACAccTransController?action=refreshGicdSumListing&gibrBranchCd="+encodeURIComponent('${gacc.branchCd }')
									+"&gfunFundCd="+encodeURIComponent('${gacc.gfunFundCd }')+"&dcbNo="+encodeURIComponent('${gacc.tranClassNo }')
									+"&dcbDate="+encodeURIComponent($F("gaccDspDCBDate")),

				options:{
					title: '',
					width: '685px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = gicdSumListTableGrid._mtgId;
						selectedGicdSumRow = null;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected GICD_SUM row
							selectedGicdSumRow = gicdSumListTableGrid.geniisysRows[y];
						}
						observeChangeTagInTableGrid(gicdSumListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						selectedGicdSumRow = null;
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(gicdSumListTableGrid);
					},
					onRowDoubleClick: function(y){
						// none
					}
				},
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'dspPayMode',
						title: 'Pay Mode',
						width: '80px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'dspAmount',
						title: 'Local Currency Amt',
						width: '138px',
						align: 'right',
						titleAlign: 'center',
						geniisysClass: 'money'
					},
					{
						id: 'dspCurrSname',
						title: 'Curr Sname',
						width: '85px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'dspCurrDesc',
						title: 'Currency',
						width: '125px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'dspFcAmt',
						title: 'Foreign Currency',
						width: '138px',
						align: 'right',
						titleAlign: 'center',
						geniisysClass: 'money'
					},
					{
						id: 'dspCurrencyRt',
						title: 'Currency Rate',
						width: '95px',
						align: 'right',
						titleAlign: 'center'
					}
				],
				resetChangeTag: true,
				rows: objGicdSum.objGicdSumList
		};
	
		gicdSumListTableGrid = new MyTableGrid(gicdSumTableModel);
		gicdSumListTableGrid.pager = objGicdSum.objGicdSumListTableGrid;
		gicdSumListTableGrid.render('gicdSumListTableGrid');

		computeGicdSumTotal();
	} catch(e){
		showErrorMessage("Collection Breakdown", e);
	}
	
	try {
		var objGdbd = new Object();
		var rowCount = null; // dren 07.16.2015 : SR 0017729 - Added Rowcount variable
		objGdbd.objGdbdListTableGrid = JSON.parse('${gdbdListTableGrid}'.replace(/\\/g, '\\\\'));
		objGdbd.objGdbdList = objGdbd.objGdbdListTableGrid.rows || [];
	
		var gdbdTableModel = {
				url: contextPath+"/GIACBankDepSlipsController?action=refreshGdbdListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId), //#18447; John Dolon; 5.25.2015
				options:{
					title: '',
					width: '900px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						gdbdListTableGrid.keys.removeFocus(gdbdListTableGrid.keys._nCurrentFocus, true);
						gdbdListTableGrid.keys.releaseKeys();
						var mtgId = gdbdListTableGrid._mtgId;
						selectedGdbdRow = null;
						selectedGdbdIndex = y;
				        objBankAcctDetails = gdbdListTableGrid.geniisysRows[y]; // dren 07.16.2015 : SR 0017729
				        rowCount = y; // dren 07.16.2015 : SR 0017729						
						
				        if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected GICD_SUM row
							if (y >= 0) {
								selectedGdbdRow = gdbdListTableGrid.geniisysRows[y];
								
								$("gdbdItemNo").value = gdbdListTableGrid.geniisysRows[y].itemNo; // dren 07.16.2015 : SR 0017729 - For Add/Update Functions - Start
								$("gdbdBankCd").value = gdbdListTableGrid.geniisysRows[y].dspBankName;
								$("gdbdBankAcctCd").value = gdbdListTableGrid.geniisysRows[y].dspBankAcctNo;
								$("gdbdDepositType").value = gdbdListTableGrid.geniisysRows[y].payMode;
								$("gdbdLocalCurrAmt").value = formatCurrency(gdbdListTableGrid.geniisysRows[y].amount);
								$("gdbdCurrency").value = gdbdListTableGrid.geniisysRows[y].dspCurrSname;
								$("gdbdCurrencyCd").value = gdbdListTableGrid.geniisysRows[y].currencyCd;
								$("gdbdForeignCurrAmt").value = formatCurrency(gdbdListTableGrid.geniisysRows[y].foreignCurrAmt);
								$("gdbdCurrencyRt").value = formatToNineDecimal(gdbdListTableGrid.geniisysRows[y].currencyRt);
								$("gdbdOldDepositAmt").value = formatCurrency(gdbdListTableGrid.geniisysRows[y].oldDepAmt);
								$("gdbdAdjustingAmt").value = formatCurrency(gdbdListTableGrid.geniisysRows[y].adjAmt);
								$("gdbdRemarks").value = gdbdListTableGrid.geniisysRows[y].remarks; // dren 07.16.2015 : SR 0017729 - For Add/Update 
								
								/*$("gdbdItemNo").value = getGdbdValue('itemNo');
								$("gdbdBankCd").value = unescapeHTML2(getGdbdValue('dspBankName'));
								$("gdbdBankAcctCd").value = unescapeHTML2(getGdbdValue('dspBankAcctNo'));
								$("gdbdDepositType").value = getGdbdValue('payMode');
								$("gdbdLocalCurrAmt").value = formatCurrency(getGdbdValue('amount'));
								$("gdbdCurrency").value = getGdbdValue('dspCurrSname');
								$("gdbdCurrencyCd").value = getGdbdValue('currencyCd');
								$("gdbdForeignCurrAmt").value = formatCurrency(getGdbdValue('foreignCurrAmt'));
								$("gdbdCurrencyRt").value = formatToNineDecimal(getGdbdValue('currencyRt'));
								$("gdbdOldDepositAmt").value = formatCurrency(getGdbdValue('oldDepAmt'));
								$("gdbdAdjustingAmt").value = formatCurrency(getGdbdValue('adjAmt'));
								$("gdbdRemarks").value = unescapeHTML2(getGdbdValue('remarks'));  //added unescape - Halley 11.22.13 */ // dren 07.16.2015 : SR 0017729 - Comment out for Add/Update Functions
								enableButton("btnDeposits");	
								
								if(!($F("gaccDspDCBFlag") == "C" || $F("gaccDspDCBFlag") == "T")){ //added by Halley 11.21.13
									$("gdbdRemarks").readOnly = false;
								}
								
								if ($F("gaccDspDCBFlag") != "C") {
									enableButton("btnDeleteGDBD");
									enableButton("btnAddGDBD"); //moved by Halley 11.22.13
								}
								
								if('${gaccTranId}' == 0){
									$("gdbdAdjustingAmt").readOnly = false;
								}
																
								$("btnAddGDBD").value = "Update";
								setUpdateFields(); // dren 07.16.2015 : SR 0017729
								
								if(getGdbdValue('payMode') == "CA") {
									$("selectedGdbdAmt").value = getGdbdValue('amount');
									$("selectedGdbdForCurrAmt").value = getGdbdValue('foreignCurrAmt');
								} else if(getGdbdValue('payMode') == "CHK"){
									
								}
								if($F("gaccDspDCBFlag") == "T"){ //marco - 10.08.2014 - added @FGIC
									if ($("gdbdOldDepositAmt").value != 0) {	// dren 08.03.2015 : SR 0017729 - Start
										$("gdbdAdjustingAmt").readOnly = false;
									} else {
										$("gdbdAdjustingAmt").readOnly = true;
									}	 // dren 08.03.2015 : SR 0017729 - End
								}
							}

							observeChangeTagInTableGrid(gdbdListTableGrid); 
						}
													
						//robert comment out muna
						/* PRE-TEXT-ITEM */
						/* if (x == gdbdListTableGrid.getColumnIndex('amount')) {
							$("controlPrevAmount").value = getGdbdValue('amount');
							
							if(nvl(getGdbdValue('amount'), "").blank()) {
								new Ajax.Request(contextPath+"/GIACAccTransController?action=executeGdbdAmtPreTextItem", {
									evalScripts: true,
									asynchronous: false,
									method: "GET",
									parameters: {
										dcbDate: $F("gaccDspDCBDate"),
										dcbNo:	 $F("gaccDspDCBNo"),
										payMode: getGdbdValue('payMode')
									},
									onComplete: function(response) {
										if (checkErrorOnResponse(response)) {
											setGdbdValue(nvl(response.responseText, ""), 'amount');
										}
									}
								});
							}

						} else if (x == gdbdListTableGrid.getColumnIndex('dspCurrSname')) {
							$("controlPrevCurrSname").value = getGdbdValue('dspCurrSname');
							$("controlPrevCurrencyCd").value = getGdbdValue('currencyCd');
							$("controlPrevCurrencyRt").value = getGdbdValue('currencyRt');
							$("controlPrevForeignCurrAmt").value = getGdbdValue('foreignCurrAmt');
						} else if (x == gdbdListTableGrid.getColumnIndex('foreignCurrAmt')) {
							$("controlPrevForeignCurrAmt").value = getGdbdValue('foreignCurrAmt');
						} else if (x == gdbdListTableGrid.getColumnIndex('adjAmt')) {
							$("varPrevAdjAmt").value = getGdbdValue('adjAmt');
						} */
						/* end of PRE-TEXT-ITEM */
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						gdbdListTableGrid.keys.removeFocus(gdbdListTableGrid.keys._nCurrentFocus, true);
						gdbdListTableGrid.keys.releaseKeys();
						selectedGdbdRow = null;
						selectedGdbdIndex = null;
						/*$("gdbdItemNo").value = "";
						$("gdbdBankCd").value = "";
						$("gdbdBankAcctCd").value = "";
						$("gdbdDepositType").value = "";
						$("gdbdLocalCurrAmt").value = "";
						$("gdbdCurrency").value = "";
						$("gdbdForeignCurrAmt").value = "";
						$("gdbdCurrencyRt").value = "";
						$("gdbdOldDepositAmt").value = "";
						$("gdbdAdjustingAmt").value = "";
						$("gdbdRemarks").value = "";
						$("gdbdShortName").value = "";
						$("gdbdPayMode").value = "";
						$("gdbdAdjustingAmt").readOnly = true;*/ // dren 07.16.2015 : SR 0017729 - Added clear fields function
						setFieldValues(null); // dren 07.16.2015 : SR 0017729
					    setBankAccountDetailsFields(); // dren 07.16.2015 : SR 0017729
					    
						//disableButton("btnDeposits");
						disableButton("btnDeleteGDBD");
						$("btnAddGDBD").value = "Add";
						//disableButton("btnAddGDBD"); // dren 08.25.2015 : SR 0017729 - Enable Add Button when selecting and deselecting record.
						//disableButton("btnAcctEntries"); //#18447; John Dolon; 5.25.2015
						//disableButton("btnCloseDCB");

						/* POST-TEXT-ITEM */
						/* if (x == gdbdListTableGrid.getColumnIndex('foreignCurrAmt')) {
							executeGdbdForeignCurrAmtPostTextItem(getGdbdValue('amount'));
						} */
						/* end of POST-TEXT-ITEM */
					}/* ,
					onCellBlur: function(element, value, x, y, id){
						observeChangeTagInTableGrid(gdbdListTableGrid);
					} */
				},
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	id: 'gaccTranId',
						width: '0px',
						visible: false
					},
					{	id: 'fundCd',
						width: '0px',
						visible: false
					},
					{	id: 'branchCd',
						width: '0px',
						visible: false
					},
					{	id: 'dcbYear',
						width: '0px',
						visible: false
					},
					{	id: 'dcbNo',
						width: '0px',
						visible: false
					},
					{	id: 'dcbDate',
						width: '0px',
						visible: false
					},
					{
						id: 'itemNo',
						title: 'Item No',
						width: '47px',
						align: 'center',
						titleAlign: 'center',
						editableOnAdd: true,
						maxlength: 9,
						geniisysClass: 'integerNoNegativeUnformattedNoComma',
						geniisysErrorMsg: 'Invalid input.'
					},
					{	id: 'bankCd',
						width: '0px',
						visible: false
					},
					{	id: 'bankAcctCd',
						width: '0px',
						visible: false
					},
					{	id: 'dspBankName dspBankAcctNo',
						title: 'Bank/Acct',
						titleAlign: 'center',
						children : 
						[
							{
								id: 'dspBankName',
								title: 'Bank Name',
								width: '105'
							},
							{	
								id: 'dspBankAcctNo',
								title: 'Bank Acct No.',
								width: '105'
							}
						]
					},
					{
						id: 'payMode',
						title: 'Deposit Type',
						width: '77px',
						align: 'center',
						titleAlign: 'center',
						editableOnAdd: true,
						/*,
						editor: new MyTableGrid.BrowseInput({
							onClick: function() {
								var coords = gdbdListTableGrid.getCurrentPosition();
								var inputId = 'mtgInput' + gdbdListTableGrid._mtgId + '_' + coords[0] + ',' + coords[1];
								$("controlPrevPayMode").value = getGdbdValue('payMode');
								$("controlPrevCurrencyCd").value = getGdbdValue('currencyCd');
								$("controlPrevCurrencyRt").value = getGdbdValue('currencyRt');
								Modalbox.show(contextPath+"/GIACAccTransController?action=showDCBPayModeLOV&inputId="+inputId,
										{  title: "Valid Values for Pay Mode",
										   width: 400,
										   onHideFunc: function() {
											  	var selectedLOVRow = $($F("selectedRow"));
											  	if (validateGdbdPayMode(selectedLOVRow.down("input", 0).value)) {
													setGdbdValue(selectedLOVRow.down("input", 0).value, 'payMode');
											  	}
								}});
							},
							validate: function(value, input) {
								//return validateGdbdPayMode(value);
								return false;
							}
						})  */ //dren 07.16.2015 : SR 0017729 - Comment out to separate LOV Function
					},
					{
						id: 'amount',
						title: 'Local Curr Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						geniisysMaxValue: '99,999,999,999,999.99',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 22,
						editableOnAdd: true,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								if (input != null) {
									var vIdx;
									var vExists = "N";
									var vSumDepAmt;
									/* :GDBD.AMOUNT : WHEN-VALIDATE-ITEM*/
									if (selectedGdbdIndex < 0 &&
											parseFloat(nvl(getGdbdValue('oldDepAmt'), "0")) == 0) {
										if (parseFloat(nvl(value, "0")) > parseFloat(nvl($F("controlDspGicdSumAmt"), "0"))) {
											showMessageBox("Amount for deposit should not be greater than total collection.", imgMessage.INFO);
											return false;
										}
	
										if (parseFloat(nvl(value, "0")) == 0
											&& parseFloat(nvl(getGdbdValue('oldDepAmt'), "0")) == 0) {
											showMessageBox("Zero amount not allowed.", imgMessage.INFO);
											return false;
										}
	
										if (parseFloat(nvl(value, "0")) < 0) {
											showMessageBox("Negative amount not allowed.", imgMessage.INFO);
											return false;
										}
	
										if (parseFloat(nvl($F("controlPrevAmount"), "0")) != parseFloat(value)) {
											if (!nvl(getGdbdValue('currencyCd'), "").blank() && nvl(!getGdbdValue('currencyRt'), "").blank()) {
												new Ajax.Request(contextPath+"/GIACAccTransController?action=getGdbdAmtWhenValidate", {
													evalScripts: true,
													asynchronous: false,
													method: "GET",
													parameters: {
														gfunFundCd: $F("gaccGfunFundCd"),
														gibrBranchCd: $F("gaccGibrBranchCd"),
														dcbDate: $F("gaccDspDCBDate"),
														dcbYear: $F("gaccDspDCBYear"),
														dcbNo: $F("gaccDspDCBNo"),
														payMode: getGdbdValue('payMode'),
														currencyCd: getGdbdValue('currencyCd'),
														currencyRt: getGdbdValue('currencyRt')
													},
													onComplete: function(response) {
														if (checkErrorOnResponse(response)) {
															$("varTotAmtForGicdSumRec").value = response.responseText;
														}
													}
												});

												if (parseFloat(value) > parseFloat(nvl($F("varTotAmtForGicdSumRec"),"0"))) {
													showMessageBox("Amount for deposit should not be greater than total collection for this pay mode, currency and currency rate.",imgMessage.INFO);
													return false;
												}

												if (rgAmtPerPm != null) {
													for (var i = 0; i < rgAmtPerPm.length; i++) {
														if (nvl(getGdbdValue('payMode'), "") == rgAmtPerPm[i].payMode) {
															vSumDepAmt = rgAmtPerPm[i].sumDepAmt;
															setGdbdValue('currencyCd', rgAmtPerPm[i].currencyCd);
															setGdbdValue('currencyRt', rgAmtPerPm[i].currency);
															vIdx = i;
															vExists = "Y";
															break;
														}
													}
			
													if (vExists == "Y") {
														if (parseFloat(nvl($F("controlPrevAmount"), "0")) != parseFloat(nvl(value, "0"))) {
															vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0"))
																		+ parseFloat(nvl(value, "0"))
																		- parseFloat(nvl($F("controlPrevAmount"), "0"));
														} else {
															vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) + parseFloat(nvl(value, "0"));
														}
			
														if (vSumDepAmt > parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0"))) {
															showMessageBox("Amount for deposit should not exceed the total collection for this pay mode, currency code and currency rate.",imgMessage.INFO);
															return false;
														}
			
														rgAmtPerPm[vIdx].sumDepAmt = vSumDepAmt;
													} else {
														showMessageBox("Error in :GDBD.amount dynamic record group.", imgMessage.ERROR);
														return false;
													}
												}
											}
										}
									}
	
									$("gaccDspGdbdSumAmount").value = parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0"))
																	- parseFloat(nvl($F("controlPrevAmount"), "0"))
																	- parseFloat(nvl(value, "0"));
	
									if (parseFloat(value) != parseFloat(nvl($F("controlPrevAmount"), "0"))) {
										if ((parseFloat(nvl(value, "0")) > 0 || (parseFloat(nvl(value, "0")) == 0 && parseFloat(nvl(getGdbdValue('oldDepAmt'), "0")) != 0))
											&& !nvl(getGdbdValue('currencyCd'), "").blank()
											&& parseFloat(nvl(getGdbdValue('currencyRt'), "0")) > 0) {
											$("controlPrevForeignCurrAmt").value = parseFloat(nvl(getGdbdValue('foreignCurrAmt'), "0"));
											setGdbdValue(parseFloat(value) / parseFloat(getGdbdValue('currencyRt')), 'foreignCurrAmt');
										}
									}
									/* end of :GDBD.AMOUNT : WHEN-VALIDATE-ITEM*/
									return true;
								} else {
									return false;
								}
							}
						})
					},
					{	id: 'currencyCd',
						width: '0px',
						visible: false
					},
					{
						id: 'dspCurrSname',
						title: 'Currency',
						width: '57px',
						align: 'center',
						titleAlign: 'center',
						maxlength: 3,
						editableOnAdd: true,
						/*,
						editor: new MyTableGrid.BrowseInput({
							onClick: function() {
								Modalbox.show(contextPath+"/GIISCurrencyController?action=showDCBCurrencyLOV&payMode="+encodeURIComponent(getGdbdValue('payMode')),
										{  title: "Valid Values for Currency",
										   width: 500,
										   onHideFunc: function() {
												var selectedLOVRow = $($F("selectedRow"));
												setGdbdValue(selectedLOVRow.down("input", 2).value, 'currencyCd');
												setGdbdValue(selectedLOVRow.down("input", 3).value, 'currencyRt');
												if (validateGdbdDspCurrSname(selectedLOVRow.down("input", 0).value)) {
													setGdbdValue(selectedLOVRow.down("input", 0).value, 'dspCurrSname');
											  	}
										}
								});
							},
							validate: function(input, value) {
								return false;
							}
						}) */ //dren 07.16.2015 : SR 0017729 - Comment out to separate LOV Function
					},
					{
						id: 'foreignCurrAmt',
						title: 'Foreign Curr Amt',
						width: '100px',
						align: 'right',
						titleAlign: 'right',
						editableOnAdd: true,
						geniisysClass: 'money',
						geniisysMaxValue: '99,999,999,999,999.99',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 22,
						editableOnAdd: true,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								/* :GDBD.FOREIGN_CURR_AMT : WHEN-VALIDATE-ITEM*/
								if (selectedGdbdIndex < 0 && parseFloat(nvl(getGdbdValue('oldDepAmt'), "0")) != 0) {
									new Ajax.Request(contextPath+"/GIACAccTransController?action=getTotFcAmtForGicdSumRec", {
										evalScripts: true,
										asynchronous: false,
										method: "GET",
										parameters: {
											gibrBranchCd: $F("gaccGibrBranchCd"),
											gfunFundCd: $F("gaccGfunFundCd"),
											dcbNo: $F("gaccDspDCBNo"),
											dcbDate: $F("gaccDspDCBDate"),
											dcbYear: $F("gaccDspDCBYear"),
											payMode: getGdbdValue('payMode'),
											currencyCd: getGdbdValue('payMode'),
											currencyRt: getGdbdValue('payMode'),
											varTotAmtForGicdSumRec: $F("varTotAmtForGicdSumRec"),
											varTotFcAmtForGicdSumRec: $F("varTotFcAmtForGicdSumRec")
										},
										onComplete: function(response) {
											if (checkErrorOnResponse(response)) {
												var result = response.responseText.toQueryParams();

												$("varTotAmtForGicdSumRec").value = result.varTotAmtForGicdSumRec;
												$("varTotFcAmtForGicdSumRec").value = result.varTotFcAmtForGicdSumRec;

												if (!nvl(getGdbdValue('currencyRt'), "").blank()) {
													if (parseFloat(nvl(value, "0")) > roundNumber(parseFloat(nvl($F("controlDspGicdSumAmt"), "0"))/parseFloat(getGdbdValue('currencyRt')), 2)) {
														setGdbdValue(nvl($F("controlPrevForeignCurrAmt"), "0"), 'foreignCurrAmt');
														showMessageBox("Amount for deposit should not exceed total collection.", imgMessage.INFO);
														return false;
													}
												}

												if (parseFloat(nvl(value, "0")) == 0 && parseFloat(nvl(getGdbdValue('oldDepAmt'), "0"))) {
													setGdbdValue(nvl($F("controlPrevForeignCurrAmt"), "0"), 'foreignCurrAmt');
													showMessageBox("Zero amount not allowed.", imgMessage.INFO);
													return false;
												}

												if (parseFloat(nvl(value, "0")) < 0) {
													setGdbdValue(nvl($F("controlPrevForeignCurrAmt"), "0"), 'foreignCurrAmt');
													showMessageBox("Negative amount not allowed.", imgMessage.INFO);
													return false;
												}
											} else {
												showMessageBox("An error has occured: " + response.responseText, imgMessage.ERROR);
												return false;
											}
										}
									});
								}
								/* end of :GDBD.FOREIGN_CURR_AMT : WHEN-VALIDATE-ITEM*/

								return executeGdbdForeignCurrAmtPostTextItem(value);
							}
						})
					},
					{
						id: 'currencyRt',
						title: 'Currency Rt',
						width: '80px',
						align: 'right',
						titleAlign: 'right',
						type: 'number',
						geniisysClass: 'rate',
			            deciRate: 9
					},
					{
						id: 'oldDepAmt',
						title: 'Old Deposit Amt',
						width: '100px',
						align: 'right',
						titleAlign: 'right',
						defaultValue: '0.00',
						geniisysClass: 'money'
					},
					{
						id: 'adjAmt',
						title: 'Adjusting Amt',
						width: '100px',
						align: 'right',
						titleAlign: 'right',
						//defaultValue: '0.00', // dren 07.16.2015 : SR 0017729 - Comment out to avoid setting 0.00 value
						geniisysClass: 'money',
						geniisysMaxValue: '99,999,999,999,999.99',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 22,
						editableOnAdd: true,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								if (parseFloat(nvl($F("varPrevAdjAmt"), "0")) != parseFloat(nvl(value, "0"))) {
									setGdbdValue(parseFloat(nvl(getGdbdValue('oldDepAmt'), "0")) + parseFloat(nvl(value, "0")), 'amount');
								}
							}
						})
					},
					{	id: 'bankAcct',
						title: 'Bank Account',
						width: '0',
						visible: false
						/* width: '50',
						editableOnAdd: true,
						editor: new MyTableGrid.BrowseInput({
							onClick: function() {
								var coords = gdbdListTableGrid.getCurrentPosition();
								var inputId = 'mtgInput' + gdbdListTableGrid._mtgId + '_' + coords[0] + ',' + coords[1];
								Modalbox.show(contextPath+"/GIACBankAccountsController?action=showBankAcctNoLOV",
										{  title: "Valid Values for Bank Account",
										   width: 800,
										   onHideFunc: function() {
											  	var selectedLOVRow = $($F("selectedRow"));
												setGdbdValue(selectedLOVRow.down("input", 0).value, 'bankCd');
												setGdbdValue(selectedLOVRow.down("input", 3).value, 'bankAcctCd');
												setGdbdValue(selectedLOVRow.down("input", 0).value + "-" + selectedLOVRow.down("input", 3).value, 'bankAcct');											
								}});
							},
							validate: function() {
								return false;
							}
						})  */
					},
					{	id: 'dspBankAcctNo',
						width: '0px',
						visible: false
					},
					{	id: 'remarks',
						width: '0px',
						visible: false
					}
				],
				requiredColumns: 'itemNo bankAcct payMode amount dspCurrSname foreignCurrAmt currencyRt oldDepAmt adjAmt',
				resetChangeTag: true,
				rows: objGdbd.objGdbdList
		};
	
		gdbdListTableGrid = new MyTableGrid(gdbdTableModel);
		gdbdListTableGrid.pager = objGdbd.objGdbdListTableGrid;
		gdbdListTableGrid.render('gdbdListTableGrid');

		gdbdListTableGrid.afterRender = function(){	// dren 07.07.2015 : SR 0019264 - Reformat the date to save the correct format in the table - Start
			for (var i=0; i<gdbdListTableGrid.geniisysRows.length;i++){
				var date = gdbdListTableGrid.geniisysRows[i].dcbDate;
				gdbdListTableGrid.geniisysRows[i].dcbDate = dateFormat(date, "mm-dd-yyyy");
			}
		}; // dren 07.07.2015 : SR 0019264 - Reformat the date to save the correct format in the table - End
		
		computeGdpdSumTotal(); //robert
		
		
		
		// GDBD POST-QUERY
		for (var i = 0; i < gdbdListTableGrid.geniisysRows.length; i++) {
			if (rgAmtPerPm == null) {
				showMessageBox("Record group amt_per_pm not found.", imgMessage.ERROR);
			} else {
				var rowCnt = rgAmtPerPm.length;
				var vPayMode;
				var varCurrencyCd;
				var currencyRt;
				var vSumDepAmt;
				var vIdx;
				var vExists = "N";

				if (rowCnt == 0) {
					var rgAmtPerPmRec = new Object();

					rgAmtPerPmRec.payMode = gdbdListTableGrid.geniisysRows[i].payMode;
					rgAmtPerPmRec.currencyCd = gdbdListTableGrid.geniisysRows[i].currencyCd;
					rgAmtPerPmRec.currencyRt = parseFloat(gdbdListTableGrid.geniisysRows[i].currencyRt);
					rgAmtPerPmRec.sumDepAmt = parseFloat(nvl(gdbdListTableGrid.geniisysRows[i].amount, "0"));

					rgAmtPerPm.push(rgAmtPerPmRec);
				} else {
					for (var j = 0; j < rowCnt; j++) {
						vPayMode = rgAmtPerPm[j].payMode;
						vCurrencyCd = rgAmtPerPm[j].currencyCd;
						vCurrencyRt = rgAmtPerPm[j].currencyRt;
						vSumDepAmt = rgAmtPerPm[j].sumDepAmt;

						if (gdbdListTableGrid.geniisysRows[i].payMode == vPayMode &&
								gdbdListTableGrid.geniisysRows[i].currencyCd == vCurrencyCd && 
								gdbdListTableGrid.geniisysRows[i].currencyRt == vCurrencyRt) {
							vIdx = j;
							vExists = "Y";
						}
					}

					if (vExists == "Y") {
						vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) - parseFloat(nvl(gdbdListTableGrid.geniisysRows[i].amount, "0"));
						rgAmtPerPm[vIdx].sumDepAmt = vSumDepAmt;
					} else {
						var rgAmtPerPmRec = new Object();

						rgAmtPerPmRec.payMode = gdbdListTableGrid.geniisysRows[i].payMode;
						rgAmtPerPmRec.currencyCd = gdbdListTableGrid.geniisysRows[i].currencyCd;
						rgAmtPerPmRec.currencyRt = parseFloat(gdbdListTableGrid.geniisysRows[i].currencyRt);
						rgAmtPerPmRec.sumDepAmt = parseFloat(nvl(gdbdListTableGrid.geniisysRows[i].amount, "0"));

						rgAmtPerPm.push(rgAmtPerPmRec);
					}
				}
			}
		}
	} catch(e){
		showErrorMessage("Bank Account Details", e);
	}

	/** End of Table Grids */
	
	/** Field Events */
	
	$("btnDeposits").observe("click", function() {
		if (objACGlobal.gaccTranId == null || objACGlobal.gaccTranId == "") { //added by Halley 02.07.14
			showMessageBox("Please save the record you created first.", imgMessage.ERROR);
		}else if (!requiredGdbdColumnsHaveValues()) {
			showMessageBox("Required fields must be entered.", imgMessage.INFO);
		} else if (selectedGdbdIndex == null){
			showMessageBox("Please select bank account record first.", imgMessage.INFO);
		} else if (selectedGdbdIndex == null){
			showMessageBox("Please select bank account record first.", imgMessage.INFO);
		} else if (selectedGdbdIndex != null) {
			$("gdbdShortName").value = getGdbdValue('dspCurrSname');
			if (getGdbdValue('payMode') == "CHK" || getGdbdValue('payMode') == "PDC") {
				$("gdbdPayMode").value = getGdbdValue('payMode');
				objACModalboxParams.gbdsRows = gbdsBlockRows;
				objACModalboxParams.gbdsdRows = gbdsdBlockRows;
				objACModalboxParams.errorRows = errorBlockRows;
				objACModalboxParams.otcRows =  otcBlockRows;
				
				Modalbox.show(contextPath+"/GIACBankDepSlipsController?action=showBankDepositPage"
						+ "&gaccTranId=" + ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('gaccTranId')))
						+ "&itemNo=" 	 + ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('itemNo')))
						+ "&dcbNo=" 	 + ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('dcbNo')))
						+ "&dcbNo=" 	 + ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('dcbNo')))
						+ "&parameters=" + JSON.stringify(objACModalboxParams)
						+ "&selectedGdbdIndex=" + selectedGdbdIndex,
						{  title: "List of Check Deposit Slips",
						   width: 800,
						   headerClose: false,
						   overlayClose: false,
						   onHideFunc: function() {
					   			// this handles the changes made on the blocks GBDS2 and GCDD
					   			for (var i = 0; i < gbdsListTableGrid.rows.length; i++) {
									addOrUpdateGbdsBlockRows(gbdsListTableGrid.getRow(i));
								}

					   			for (var i = 1; i <= gbdsListTableGrid.newRowsAdded.length; i++) {
									addOrUpdateGbdsBlockRows(gbdsListTableGrid.getRow(-i));
								}

								for (var i = 0; i < gbdsdListTableGrid.rows.length; i++) {
									addOrUpdateGbdsdBlockRows(gbdsdListTableGrid.getRow(i));
								}

								for (var i = 1; i <= gbdsdListTableGrid.newRowsAdded.length; i++) {
									addOrUpdateGbdsdBlockRows(gbdsdListTableGrid.getRow(-i));
								}
							} });
			} else if (getGdbdValue('payMode') == "CA") {
				objACModalboxParams.gbdsRows = gbds2BlockRows;
				objACModalboxParams.gcddRows = gcddBlockRows;
				objACModalboxParams.otcRows =  otcBlockRows;
				
				/* Modified by : J. Diago - acctOverlay and ModalBox.show pinalitan ko na.
				** Date : 11.11.2013
				** Remarks : Will be redesigned completely using overlay. Yung dating page na tinatawag nya is yung cashDeposit.jsp
				** papalitan ko na sya ng cashDepositOverlay, plus nandun na yung tamang process nya.
				*/
				
				cashDepositOverlay = Overlay.show(contextPath+"/GIACBankDepSlipsController", {
						urlContent: true,
						urlParameters: { 
								action: "showCashDepositPage",
								gaccTranId: encodeURIComponent(objACGlobal.gaccTranId),
								itemNo: ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('itemNo'))),
								selectedGdbdIndex: selectedGdbdIndex,
								parameters: JSON.stringify(objACModalboxParams) 											
							},
						title: "Cash Deposits",
						height: 500,
						width: 800,
						draggable: false
				});

				/* acctOverlay = Overlay.show(contextPath+"/GIACBankDepSlipsController", {
								urlContent: true,
								urlParameters: { 
										action: "showCashDepositPage",
										gaccTranId: encodeURIComponent(objACGlobal.gaccTranId),
										itemNo: ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('itemNo'))),
										selectedGdbdIndex: selectedGdbdIndex,
										parameters: JSON.stringify(objACModalboxParams) 											
									},
								title: "Cash Deposits",
								height: 480,
								width: 800,
								draggable: true
				}); */

				/* Modalbox.show(contextPath+"/GIACBankDepSlipsController?action=showCashDepositPage&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId)
						+ "&itemNo=" + ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('itemNo')))
						+ "&selectedGdbdIndex=" + selectedGdbdIndex
						+ "&parameters=" + JSON.stringify(objACModalboxParams),
						{  title: "List of Cash Deposit Slips",
						   width: 800,
						   headerClose: false,
						   overlayClose: false,
						   onHideFunc: function() {
					   			// this handles the changes made on the blocks GBDS2 and GCDD
					   			for (var i = 0; i < gbds2ListTableGrid.rows.length; i++) {
									addOrUpdateGbds2BlockRows(gbds2ListTableGrid.getRow(i));
								}

					   			for (var i = 1; i <= gbds2ListTableGrid.newRowsAdded.length; i++) {
									addOrUpdateGbds2BlockRows(gbds2ListTableGrid.getRow(-i));
								}

								for (var i = 0; i < gcddListTableGrid.rows.length; i++) {
									addOrUpdateGcddBlockRows(gcddListTableGrid.getRow(i));
								}

								for (var i = 1; i <= gcddListTableGrid.newRowsAdded.length; i++) {
									addOrUpdateGcddBlockRows(gcddListTableGrid.getRow(-i));
								}
							}}); */
			} else {
				Modalbox.show(contextPath+"/GIACAccTransController?action=showLocmPage&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId)
						+ "&itemNo=" + ((selectedGdbdIndex == null) ? "" : encodeURIComponent(getGdbdValue('itemNo'))),
						{  title: "List of Credit Memo",
						   width: 800,
						   headerClose: false,
						   overlayClose: false });
			}
		}
	});

	function setAcctTransRows(act) {
		try {
			// act = 0, save; act=1, close
			var newObj = new Object();
			var particulars = "To record deposit and to close DCB No. "+parseInt($F("gaccDspDCBNo")).toPaddedString(6)+".";

			newObj.tranId	  = $F("gaccTranId") == "" ? 0 : $F("gaccTranId");
			newObj.fundCd	  = $F("gaccGfunFundCd");
			newObj.branchCd	  = $F("gaccGibrBranchCd");
			newObj.tranYear    = $F("gaccDspDCBYear");
			newObj.tranDate	  = dateFormat($F("gaccDspDCBDate"), "mm-dd-yyyy");
			newObj.tranClassNo = $F("gaccDspDCBNo");
			newObj.tranMonth   = dateFormat($F("gaccDspDCBDate"), "mm");
			newObj.tranFlag	  = act == 1 ? "C" : "O";
			newObj.tranClass   = "CDC";
			newObj.particulars = act == 1 ? $F("gaccParticulars")+" No adjusting entries." : particulars;

			return newObj;
			
		} catch (e) {
			showErrorMessage("setAcctTransRows", e);
		}
	}

	function saveDCB() {
		try {
			//if(changeTag == 0){
			//	showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);
			//}else{
			if(requiredGdbdColumnsHaveValues) {
				if(checkAllRequiredFieldsInDiv("dcbInformationHeader")){
					
				} else {
					return false;
				}
				
				if(checkAllRequiredFieldsInDiv("dcbInformationDiv")){
					
				} else {
					return false;
				}
				
				if($F("controlDspGicdSumAmt") != $F("controlDspGdbdSumAmt")){ //&& '${gaccTranId}' != 0 // dren 09.03.2015 : SR 0017729 - prevent Saving when new DCB is added and adjustment is made.
					showMessageBox('Total collection amount is not equal to total bank deposit.','I');
					return false;
				}
				
				var tranDate = makeDate($F("gaccDspDCBDate"));
				var tranSeqNo = 0;
				
				var addedGdbdRows 	 = gdbdListTableGrid.getNewRowsAdded();
				var modifiedGdbdRows = gdbdListTableGrid.getModifiedRows();
				var delGdbdRows 	 = getDeletedJSONObjects(gdbdListTableGrid.geniisysRows); // dren 07.16.2015 : SR 0017729 - for Add/Update/Delete functions
				var setGdbdRows		 = getAddedAndModifiedJSONObjects(gdbdListTableGrid.geniisysRows); // dren 07.16.2015 : SR 0017729 - for Add/Update/Delete functions

				if($F("newDCBForClosing") == "Y") {
					setGdbdRows = setGdbdRows.concat(gdbdListTableGrid.geniisysRows);
					tranSeqNo = 0;
				}
				
				var objParameters = new Object();
				objParameters.isNew		  = $F("newDCBForClosing");
				objParameters.dcbFlagC    = $F("varUpdateDCB");
				objParameters.gaccBranchCd= $F("gaccGibrBranchCd"); // dren 08.03.2015 : SR 0017729 - Additional parameters for Adding Acct Entries - Start
				objParameters.gaccFundCd  = $F("gaccGfunFundCd");
				objParameters.moduleName  = $F("moduleName"); // dren 08.03.2015 : SR 0017729 - Additonal parameters for Adding Acct Entries - End				
				objParameters.accTransRows = setAcctTransRows(0);
				objParameters.delGdbdRows = prepareJsonAsParameter(delGdbdRows); // dren 07.16.2015 : SR 0017729 - for Add/Update/Delete functions
				objParameters.setGdbdRows = prepareJsonAsParameter(setGdbdRows); // dren 07.16.2015 : SR 0017729 - for Add/Update/Delete functions	
				
				new Ajax.Request(contextPath+"/GIACAccTransController", {
					method: "POST",
					parameters: {
					    action: "saveDCBForClosing",
						parameters: JSON.stringify(objParameters)						
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function() {
						showNotice("Saving DCB for Closing, please wait...");
					},
					onComplete: function(response) {
						hideNotice();
						changeTagFunc = "";
						var paramMap = JSON.parse(response.responseText);
						if(paramMap.gaccTranId == null || paramMap.gaccTranId == "" || paramMap.gaccTranId < 1) {
							if (paramMap.mesg != "Y") {  //Deo [03.03.2017]: add start (SR-5939)
								showMessageBox(paramMap.mesg, imgMessage.INFO);
							} else {					 //Deo [03.03.2017]: add start (SR-5939)
							showMessageBox("Saving failed.", imgMessage.ERROR);
							} //Deo [03.03.2017]: close if (SR-5939)
						} else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if(objGIACS035.exitPage != null) {
									objGIACS035.exitPage();
								} else {
									if($F("varUpdateDCB") == "Y"){
										changeTagFunc = "";
										changeTag = 0;
										$("varUpdateDCB").value = "N";	
									}
									$("gaccTranId").value = paramMap.gaccTranId;
									objACGlobal.gaccTranId = paramMap.gaccTranId;
									//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS); //remove by steven 07.30.2014 - nadouble na siya.
									editDCBInformation();
								}
							});
							
							/* if($F("varUpdateDCB") == "Y"){
								updateDCBCancel();
							} else {
								// Added condition for exitpage by J. Diago 10.07.2013 to handle unsaved modifications by user.
								if(objGIACS035.exitPage != null) {
									objGIACS035.exitPage();
								} else {
									$("gaccTranId").value = paramMap.gaccTranId;
									objACGlobal.gaccTranId = paramMap.gaccTranId;
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
									editDCBInformation();
								}
							} */
						} 
					}
				});
			}
			//}
		} catch(e) {
			showErrorMessage("saveDCB", e);
		}
	}
	
	function updateDCBCancel(){
		try {
			new Ajax.Request(contextPath+"/GIACAccTransController", {
				method: "POST",
				parameters : {
					action : "updateDCBCancel",
					fundCd : $F("gaccGfunFundCd"),
					branchCd : $F("gaccGibrBranchCd"),
					dcbYear : $F("gaccDspDCBYear"),
					dcbNo : $F("gaccDspDCBNo")
				},
				onCreate : showNotice("Updating DCB, please wait..."),
				onComplete: function(response){
					hideNotice();
					changeTagFunc = "";
					changeTag = 0;
					$("varUpdateDCB").value = "N";
					$("gaccTranId").value = paramMap.gaccTranId;
					objACGlobal.gaccTranId = paramMap.gaccTranId;
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					editDCBInformation();
				}
			});
		} catch(e) {
			showErrorMessage("updateDCBCancel", e);
		}
	}
	
	function validateDCBForClosing() {
		var valid = true;
		if($F("newDCBForClosing") == "Y") {
			showMessageBox("Please save the record you created first.", imgMessage.ERROR);
			valid = false;
		} else if(parseFloat($F("controlDspGicdSumAmt")) == 0 || $F("controlDspGicdSumAmt") == "") {
			showMessageBox("There is no collection amount.");
			valid = false;
		//} else if(parseFloat($F("controlDspGicdSumAmt")) < $F("gaccDspGdbdSumAmount")) {
		//} else if(parseFloat($F("controlDspGicdSumAmt")) < parseFloat($F("controlDspGdbdSumAmt"))) {
		//	showMessageBox("Total bank deposit should not be greater than total collection amount.");
		//	valid = false; //marco - 03.09.2015 - comment out - moved to checkDCBforClosing
		} else if($F("gaccTranId") == "") {
			showMessageBox("No tran id found. Unable to save.");
			valid = false;
		} else {
			valid = requiredGdbdColumnsHaveValues();
		}
		return valid;
	}

	function closeDCB() {
		try {
			var parameter = new Object();
			parameter.closeParams = closingParam;
			parameter.accTranParams = setAcctTransRows(1);
			parameter.updateEntries = updateEntries;
			new Ajax.Request(contextPath+"/GIACAccTransController", {
				method: "POST",
				parameters: {
					action : "closeDCBgiacs035",
					closeParams : JSON.stringify(parameter)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function() {
					showNotice("Closing DCB, please wait...");
				},
				onComplete: function(response) {
					hideNotice("");
					if(response.responseText == "Y") {
						showMessageBox("DCB has been closed.", imgMessage.SUCCESS);
						editDCBInformation();
					} else {
						showMessageBox(response.responseText);
					}
				}
			});
		} catch(e) {
			showErrorMessage("closeDCB", e);
		}
	}

	function checkDCBForClosing() {
		try {
			var valid = validateDCBForClosing();
			if(valid == 1) {
				new Ajax.Request(contextPath+"/GIACAccTransController", {
					method: "POST",
					parameters: {
					    action: "checkDCBforClosing",
					    gaccTranId: $F("gaccTranId"),
					    dcbNo: $F("gaccDspDCBNo"),
					    dcbYear: $F("gaccDspDCBYear"),
					    fundCd: $F("gaccGfunFundCd"),
					    branchCd: $F("gaccGibrBranchCd"),
					    gicdSumAmt: unformatCurrencyValue($F("controlDspGicdSumAmt")), //marco - 03.09.2015 - added parameters
					    gdbdSumAmt: unformatCurrencyValue($F("controlDspGdbdSumAmt")), //
					    dcbDate: $F("gaccDspDCBDate")								   //
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function() {
						showNotice("Checking if DCB is valid for closing...");
					},
					onComplete: function(response) {
						hideNotice();
						closingParam = JSON.parse(response.responseText);
						var mesg = closingParam.mesg;
						if(mesg == "Y") {
							showConfirmBox("Close DCB", "Do you want to close the DCB No. " + $F("gaccDspDCBYear")+ //change by steven to "showConfirmBox3"
									" - " + formatNumberDigits($F("gaccDspDCBNo"), 6) + "?", "Yes", "No", closeDCB, "");
							
							updateEntries = "Y";
							if(closingParam.bankInOR == "Y" && closingParam.pdcExists == "N") {
								updateEntries = "N";
							}
						} else if(mesg == "withCancelled"){ //marco - 03.09.2015
							showConfirmBox("Confirmation", "There is/are cancelled OR/s included in this DCB. Would you like to refresh the amounts?",
								"Yes", "No", refreshDCB, null, "");
						} else {
							showMessageBox(mesg);
						}
					}
				});
			}
		} catch(e) {
			showErrorMessage("checkDCBForClosing", e);
		}
	}

	observeSaveForm("btnSave", saveDCB);  
//	$("btnSave").observe("click", function() {
//		saveDCB();
//	});

	$("btnCloseDCB").observe("click", function() {
		//checkDCBForClosing();
		if(changeTag == 1){	//#18447; John Dolon; 5.25.2015
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		new Ajax.Request(contextPath+"/GIACAccTransController", {
			method: "POST",
			parameters: {
			    action : "checkUserAccessClose",
			    issCd : $F("gaccGibrBranchCd"), 
			    moduleId : "GIACS035",
			    lineCd : ""
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				//showNotice("Checking if DCB is valid for closing...");
			},
			onComplete: function(response) {
				//hideNotice();
				if(response.responseText == "0") {
					showMessageBox("You are not allowed to close the DCB for this branch.");
				} else if(isNaN(parseFloat(response.responseText))) {
					showMessageBox("Error in validating user.");
				} else {
					checkDCBForClosing();
				}
			}
		});
	});
	
	/* GDBD Block */
	//if('${gaccTranId}' != 0){
		//disableButton("btnAddGDBD"); //#18447; John Dolon; 5.25.2015
	//}
	
	function countExistingRecords() { // dren 07.16.2015 : SR 0017729 - Function to count existing records to get the next seq ItemNo - Start
	    var highest = 0;
	    for (var index = 0; index < gdbdListTableGrid.geniisysRows.length; index ++) {	
			if (parseFloat(gdbdListTableGrid.geniisysRows[index].itemNo) > highest) {
				if (gdbdListTableGrid.geniisysRows[index].recordStatus != -1){
	    			highest = parseFloat(gdbdListTableGrid.geniisysRows[index].itemNo);
		            itemNoSeq = highest+1;
				}
	        }
	    } 
	}
	countExistingRecords(); // dren 07.16.2015 : SR 0017729 - Function to count existing records to get the next seq ItemNo - End	
	
	function setBankAccountDetailsFields() { // dren 07.16.2015 : SR 0017729 - Set properties of fields for Add/Update Record - Start
		if ($F("controlDspGicdSumAmt") == $F("controlDspGdbdSumAmt")) {
			disableButton("btnAddGDBD");	
			setUpdateFields();
			$("gdbdAdjustingAmt").readOnly = true;
			$("gdbdRemarks").readOnly = true;	
			$("gdbdAdjustingAmt").value = "";
			$("gdbdOldDepositAmt").value = "";	
			addButtonBalance = 1;
			$("gdbdItemNo").value = "";
		} else {
			enableButton("btnAddGDBD");
			addButtonBalance = 0;
			setAddFields();			
		}		
	};	
	setBankAccountDetailsFields(); // dren 07.16.2015 : SR 0017729 - Set properties of fields for Add/Update Record - End
	
		$("gdbdLocalCurrAmt").observe("change", function(){
			if ($("gdbdCurrency").value == ""){ 
			customShowMessageBox("Please enter a valid Currency.", imgMessage.INFO, "gdbdCurrency");
			$("gdbdLocalCurrAmt").value = "";
			$("gdbdForeignCurrAmt").value = "";		
			} else if ($("gdbdLocalCurrAmt").value == 0){
				customShowMessageBox("Zero amount not allowed.", imgMessage.INFO, "gdbdLocalCurrAmt");
				$("gdbdLocalCurrAmt").value = "";
			} else if ($("gdbdLocalCurrAmt").value < 0){
				customShowMessageBox("Negative amount not allowed.", imgMessage.INFO, "gdbdLocalCurrAmt");
				$("gdbdLocalCurrAmt").value = "";
		} else if ($("gdbdLocalCurrAmt").value > 0){
	 		document.getElementById('gdbdForeignCurrAmt').value = formatCurrency(document.getElementById('gdbdLocalCurrAmt').value *
	 		document.getElementById('gdbdCurrencyRt').value);
	 		document.getElementById('gdbdLocalCurrAmt').value = formatCurrency(document.getElementById('gdbdLocalCurrAmt').value);
	 		//document.getElementById('gdbdOldDepositAmt').value = formatCurrency(document.getElementById('gdbdLocalCurrAmt').value);
		} else {
			customShowMessageBox("Please enter a valid amount.", imgMessage.INFO, "gdbdLocalCurrAmt");
				$("gdbdLocalCurrAmt").value = "";
		}
	});	   
	
	function setAddFields(){ // dren 07.16.2015 : SR 0017729 - Set fields when Adding a record - Start
		$("gdbdItemNo").readOnly = true;	
		$("gdbdItemNo").value = itemNoSeq;	
		$("gdbdBankCd").readOnly = false;
		$("gdbdBankAcctCd").readOnly = false;
		$("gdbdDepositType").readOnly = false;
		$("gdbdLocalCurrAmt").readOnly = false;
		$("gdbdCurrency").readOnly = false;
		$("gdbdAdjustingAmt").readOnly = true;
		$("gdbdRemarks").readOnly = false;
		document.getElementById('gdbdBankCd').setAttribute('class', "required");
		document.getElementById('gdbdBankAcctCd').setAttribute('class', "required");
		document.getElementById('gdbdDepositType').setAttribute('class', "required");
		document.getElementById('gdbdLocalCurrAmt').setAttribute('class', "required");
		document.getElementById('gdbdCurrency').setAttribute('class', "required");
			document.getElementById('bankCdDiv').setAttribute('class', "required");
		document.getElementById('bankAcctCdDiv').setAttribute('class', "required");
		document.getElementById('depositTypeDiv').setAttribute('class', "required");
		document.getElementById('currencyDiv').setAttribute('class', "required"); 
		$("gdbdAdjustingAmt").value = "0.00";
		$("gdbdOldDepositAmt").value = "0.00";
	} // dren 07.16.2015 : SR 0017729 - Set fields when Adding a record - End
	
	function setUpdateFields(){ // dren 07.16.2015 : SR 0017729 - Set fields when Updating a record - Start
		$("gdbdItemNo").readOnly = true;		
		$("gdbdBankCd").readOnly = true;
		$("gdbdBankAcctCd").readOnly = true;
		$("gdbdDepositType").readOnly = true;
		$("gdbdLocalCurrAmt").readOnly = true;
		$("gdbdCurrency").readOnly = true;
		$("gdbdRemarks").readOnly = false;
				if ($("gdbdOldDepositAmt").value != 0) {	
				$("gdbdAdjustingAmt").readOnly = false;
			} else {
				$("gdbdAdjustingAmt").readOnly = true;
			}	
		document.getElementById('gdbdItemNo').removeAttribute('class');
		document.getElementById('gdbdBankCd').removeAttribute('class');
		document.getElementById('gdbdBankAcctCd').removeAttribute('class');
		document.getElementById('gdbdDepositType').removeAttribute('class');
		document.getElementById('gdbdLocalCurrAmt').removeAttribute('class');
		document.getElementById('gdbdCurrency').removeAttribute('class');
			document.getElementById('bankCdDiv').removeAttribute('class');
		document.getElementById('bankAcctCdDiv').removeAttribute('class');
		document.getElementById('depositTypeDiv').removeAttribute('class');
		document.getElementById('currencyDiv').removeAttribute('class');
	} // dren 07.16.2015 : SR 0017729 - Set fields when Updating a record - End		
	
	$("imgBankCd").observe("click",function(){ // dren 07.16.2015 : SR 0017729 - LOV for Bank Name - Start
		if ($("btnAddGDBD").value == "Update"){
			null;
		} else if (addButtonBalance == 1) {		
			null;		
		} else {
			$("gdbdBankAcctCd").value = "";
			showGIACS035BankCdLOV("%");
		}
	});		
	
		function showGIACS035BankCdLOV(x){
		try{		
			LOV.show({
				  controller : "AcCashReceiptsTransactionsLOVController",
			   urlParameters : {
					  action : "getGIACS035BankCdLOV",
					  search : x,
						page : 1
				},
				title: "Valid Values for Bank",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'bankCd',
						title: 'Bank Code',
						width : '100px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'bankName',
						title: 'Bank Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("gdbdBankCd").value = unescapeHTML2(row.bankName);
						$("gdbdBankCd").setAttribute("lastValidValue", unescapeHTML2(row.bankName));
						objGIACS035.bankName = unescapeHTML2(row.bankName);			
						$("gdbdBankCdValue").value = unescapeHTML2(row.bankCd);
						$("gdbdBankCdValue").setAttribute("lastValidValue", unescapeHTML2(row.bankCd));
						objGIACS035.bankCd = unescapeHTML2(row.bankCd);							
					}
				},
				onCancel: function(){
					$("gdbdBankCd").focus();
					$("gdbdBankCd").value = $("gdbdBankCd").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("gdbdBankCd").value = $("gdbdBankCd").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "gdbdBankCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS035BankCdLOV",e);
		}
	} 	
	
		$("gdbdBankCd").observe("change", function(){
		if($("gdbdBankCd").value == ""){
			objGIACS035.gdbdBankCd = "";
			$("gdbdBankCd").setAttribute("lastValidValue", "");
			$("gdbdBankCdValue").value = "";
			$("gdbdBankAcctCd").value = "";			
		} else {
			showGIACS035BankCdLOV($("gdbdBankCd").value+"%");
		}
	}); // dren 07.16.2015 : SR 0017729 - LOV for Bank Name - End	   
		
	$("imgBankAcctCd").observe("click",function(){ // dren 07.16.2015 : SR 0017729 - LOV for Bank Acct No. - Start
		if ($("btnAddGDBD").value == "Update"){
			null;
		} else if (addButtonBalance == 1) {
			null;				
		} else {
			if ($("gdbdBankCd").value == ""){ 
				customShowMessageBox("Please enter a valid Bank.", imgMessage.INFO, "gdbdBankCd");
			} else {
				showGIACS035BankAcctCdLOV("%"); 
			}
		}
	});	
	
		function showGIACS035BankAcctCdLOV(x){
		try{		
			LOV.show({
				controller : "AcCashReceiptsTransactionsLOVController",
				urlParameters : {
					  action : "getGIACS035BankAcctCdLOV",
					  search : x,
					  bankCd : $("gdbdBankCdValue").value,		  
						page : 1
				},
				title: "Valid Values for Bank Account No.",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'bankAcctCd',
						title: 'Bank Acct Code',
						width : '100px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'bankAcctNo',
						title: 'Acct No.',
					    width: '150px',
					    align: 'left'
					},
					{
						id : 'bankAcctType',
						title: 'Acct Type',
					    width: '80px',
					    align: 'left'
					},	
					{
						id : 'branchCd',
						title: 'Branch',
					    width: '100px',
					    align: 'left'
					}					
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("gdbdBankAcctCd").value = unescapeHTML2(row.bankAcctNo);
						$("gdbdBankAcctCd").setAttribute("lastValidValue", unescapeHTML2(row.bankAcctNo));
						objGIACS035.bankAcctNo = unescapeHTML2(row.bankAcctNo);		
						$("gdbdBankAcctCdValue").value = unescapeHTML2(row.bankAcctCd);
						$("gdbdBankAcctCdValue").setAttribute("lastValidValue", unescapeHTML2(row.bankAcctCd));
						objGIACS035.bankAcctCd = unescapeHTML2(row.bankAcctCd);							
					}
				},
				onCancel: function(){
					$("gdbdBankAcctCd").focus();
					$("gdbdBankAcctCd").value = $("gdbdBankAcctCd").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("gdbdBankAcctCd").value = $("gdbdBankAcctCd").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "gdbdBankAcctCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS035BankAcctCdLOV",e);
		}
	} 	
	
		$("gdbdBankAcctCd").observe("change", function(){
		if($("gdbdBankAcctCd").value == ""){
			objGIACS035.gdbdBankAcctCd = "";
			$("gdbdBankAcctCd").setAttribute("lastValidValue", "");
		} else {
			showGIACS035BankAcctCdLOV($("gdbdBankAcctCd").value+"%");
		}
	}); // dren 07.16.2015 : SR 0017729 - LOV for Bank Acct No. - End	  
	
	$("imgDepositType").observe("click",function(){ // dren 07.16.2015 : SR 0017729 - LOV for Pay Mode - Start
		if ($("btnAddGDBD").value == "Update"){
			null;
		} else if (addButtonBalance == 1) {
			null;				
		} else {
			showGIACS035PayModeLOV("%"); 			
		}
	});	
	
		function showGIACS035PayModeLOV(x){
		try{		
			LOV.show({
				controller : "AcCashReceiptsTransactionsLOVController",
				urlParameters : {
					  action : "getGIACS035PayModeLOV",
					  search : x,
			    gibrBranchCd : $("gaccGibrBranchCd").value,	
			      gfunFundCd : $("gaccGfunFundCd").value,
				  dspDcbDate : $("gaccDspDCBDate").value, 	
				       dcbNo : $("gaccDspDCBNo").value,
						page : 1
				},
				title: "Valid Values for Pay Mode",
				width: 400,
				height: 300,
				columnModel: [
		 			{
						id : 'payMode',
						title: 'Pay Mode',
						width : '60px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'rvMeaning',
						title: 'Description',
					    width: '300px',
					    align: 'left'
					}			
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("gdbdDepositType").value = unescapeHTML2(row.payMode);
						$("gdbdDepositType").setAttribute("lastValidValue", unescapeHTML2(row.payMode));
						objGIACS035.payMode = unescapeHTML2(row.payMode);						
					}
				},
				onCancel: function(){
					$("gdbdDepositType").focus();
					$("gdbdDepositType").value = $("gdbdDepositType").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("gdbdDepositType").value = $("gdbdDepositType").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "gdbdDepositType");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS035PayModeLOV",e);
		}
	} 	
	
		$("gdbdDepositType").observe("change", function(){
		if($("gdbdDepositType").value == ""){
			objGIACS035.gdbdDepositType = "";
			$("gdbdDepositType").setAttribute("lastValidValue", "");
			$("gdbdCurrency").value = "";
			$("gdbdLocalCurrAmt").value = "";
			$("gdbdForeignCurrAmt").value = "";
		} else {
			showGIACS035PayModeLOV($("gdbdDepositType").value+"%");
		}
	}); // dren 07.16.2015 : SR 0017729 - LOV for Pay Mode - End	  
	
	$("imgCurrency").observe("click",function(){ // dren 07.16.2015 : SR 0017729 - LOV for Currency - Start
		if ($("btnAddGDBD").value == "Update"){
			null;
		} else if (addButtonBalance == 1) {
			null;				
		} else {			
			if ($("gdbdDepositType").value == ""){ 
				customShowMessageBox("Please enter a valid Pay Mode.", imgMessage.INFO, "gdbdDepositType");
			} else {
				showGIACS035CurrencyLOV("%"); 
			}
		}
	});		
	
		function showGIACS035CurrencyLOV(x){
		try{		
			LOV.show({
				controller : "AcCashReceiptsTransactionsLOVController",
				urlParameters : {
					  action : "getGIACS035CurrencyLOV",
					  search : x,
			    gibrBranchCd : $("gaccGibrBranchCd").value,	
			      gfunFundCd : $("gaccGfunFundCd").value,
				  dspDcbDate : $("gaccDspDCBDate").value, 
				     payMode : $("gdbdDepositType").value,
				       dcbNo : $("gaccDspDCBNo").value,
						page : 1
				},
				title: "Valid Values for Currency",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'shortName',
						title: 'Short name',
						width : '80px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'currencyDesc',
						title: 'Currency',
					    width: '200px',
					    align: 'left'
					},
					{
						id : 'currencyRt',
						title: 'Currency Rate',
					    width: '100px',
					    align: 'left'
					}				
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("gdbdCurrency").value = unescapeHTML2(row.shortName);
						$("gdbdCurrency").setAttribute("lastValidValue", unescapeHTML2(row.shortName));
						objGIACS035.shortName = unescapeHTML2(row.shortName);						
						$("gdbdCurrencyRt").value = unescapeHTML2(row.currencyRt);
						objGIACS035.gdbdCurrencyRt = unescapeHTML2(row.currencyRt);	
						$("gdbdCurrencyCd").value = unescapeHTML2(row.code);
						objGIACS035.gdbdCurrencyCd = unescapeHTML2(row.code);
					}
				},
				onCancel: function(){
					$("gdbdCurrency").focus();
					$("gdbdCurrency").value = $("gdbdCurrency").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("gdbdCurrency").value = $("gdbdCurrency").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "gdbdCurrency");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS035CurrencyLOV",e);
		}
	} 	
	
		$("gdbdCurrency").observe("change", function(){
		if($("gdbdCurrency").value == ""){
			objGIACS035.gdbdCurrency = "";
			$("gdbdCurrency").setAttribute("lastValidValue", "");
			$("gdbdCurrency").value = "";
			$("gdbdCurrencyRt").value = "";
			$("gdbdLocalCurrAmt").value = "";
			$("gdbdForeignCurrAmt").value = "";
			$("gdbdCurrency").value = "";
		} else {
			showGIACS035CurrencyLOV($("gdbdCurrency").value+"%");
		}
	});	  // dren 07.16.2015 : SR 0017729 - LOV for Currency - End
	
	//transferred from bankAccountDetails.jsp - Halley 11.21.13
	$("editGdbdRemarks").observe("click", function() { // dren 08.25.2015 SR 0017729 - Enable text editor when adding/updating records. - Start
		//if(selectedGdbdIndex != null)
		if ($("gdbdItemNo").value == "") {
			null; 
		} else {
			if(!($F("gaccDspDCBFlag") == "C" || $F("gaccDspDCBFlag") == "T")){ 
				showEditor("gdbdRemarks", 4000);
			}else{
				//showEditor("gdbdRemarks", 4000, "true");
				showOverlayEditor("gdbdRemarks", 500, $("gdbdRemarks").hasAttribute("readonly")); 
			}
		}
	}); // dren 08.25.2015 SR 0017729 - Enable text editor when adding/updating records. - End
		
	$("gdbdRemarks").observe("blur", function() {
		if (selectedGdbdIndex != null) {
			setGdbdValue($F("gdbdRemarks"), 'remarks');
		}
	});

	function setGdbd(){
		var itemInfo 						= new Object();
		itemInfo 							= selectedGdbdRow;
		itemInfo.amount    				= unformatCurrencyValue($F("gdbdLocalCurrAmt"));
		itemInfo.foreignCurrAmt     = unformatCurrencyValue($F("gdbdForeignCurrAmt"));
		itemInfo.adjAmt    				= unformatCurrencyValue($F("gdbdAdjustingAmt"));
		itemInfo.remarks				= $("gdbdRemarks").value == "" ? "" : escapeHTML2($F("gdbdRemarks"));
		return itemInfo;
	}

	function setFieldValues(rec){ // dren 07.16.2015 : SR 0017729 - Set fields when Updating records and to clear fields - Start
		try{		
			$("gdbdItemNo").value = (rec == null) ? "" : getGdbdValue('itemNo');
			$("gdbdBankCd").value = (rec == null) ? "" : unescapeHTML2(getGdbdValue('dspBankName'));
			$("gdbdBankAcctCd").value = (rec == null) ? "" : unescapeHTML2(getGdbdValue('dspBankAcctNo'));
			$("gdbdDepositType").value = (rec == null) ? "" : getGdbdValue('payMode');
			$("gdbdLocalCurrAmt").value = (rec == null) ? "" : formatCurrency(getGdbdValue('amount'));
			$("gdbdCurrency").value = (rec == null) ? "" : getGdbdValue('dspCurrSname');
			$("gdbdCurrencyCd").value = (rec == null) ? "" : getGdbdValue('currencyCd');
			$("gdbdForeignCurrAmt").value = (rec == null) ? "" : formatCurrency(getGdbdValue('foreignCurrAmt'));
			$("gdbdCurrencyRt").value = (rec == null) ? "" : formatToNineDecimal(getGdbdValue('currencyRt'));
			$("gdbdOldDepositAmt").value = (rec == null) ? "" : formatCurrency(getGdbdValue('oldDepAmt'));
			$("gdbdAdjustingAmt").value = (rec == null) ? "" : formatCurrency(getGdbdValue('adjAmt'));
			$("gdbdRemarks").value = (rec == null) ? "" : unescapeHTML2(getGdbdValue('remarks'));  //added unescape - Halley 11.22.13
		    objBankAcctDetails = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	} // dren 07.16.2015 : SR 0017729 - Set fields when Updating records and to clear fields - End	

	function setRec(rec){ // dren 07.16.2015 : SR 0017729 - Set record when Adding - Start
		try {
			var obj = (rec == null ? {} : rec);
				obj.itemNo = escapeHTML2($F("gdbdItemNo"));
			obj.dspBankName = escapeHTML2($F("gdbdBankCd"));
			obj.dspBankAcctNo = escapeHTML2($F("gdbdBankAcctCd"));				
			obj.amount = unformatCurrencyValue($F("gdbdLocalCurrAmt"));			
			obj.currencyCd = escapeHTML2($F("gdbdCurrencyCd"));
			obj.foreignCurrAmt = unformatCurrencyValue($F("gdbdForeignCurrAmt"));
			obj.currencyRt = formatToNineDecimal($F("gdbdCurrencyRt"));
			obj.oldDepAmt = unformatCurrencyValue($F("gdbdOldDepositAmt"));
			obj.adjAmt = formatCurrency($F("gdbdAdjustingAmt"));
			obj.remarks = escapeHTML2($F("gdbdRemarks")); 
			obj.payMode = escapeHTML2($F("gdbdDepositType"));	
			obj.dspCurrSname = escapeHTML2($F("gdbdCurrency")); 			
			obj.gaccTranId = escapeHTML2($F("gaccTranId"));
			obj.fundCd = escapeHTML2($F("gaccGfunFundCd"));
			obj.branchCd = escapeHTML2($F("gaccGibrBranchCd"));
			obj.dcbYear = escapeHTML2($F("gaccDspDCBYear"));
			obj.dcbNo = escapeHTML2($F("gaccDspDCBNo"));
			obj.dcbDate = dateFormat($F("gaccDspDCBDate"), "mm-dd-yyyy");
			obj.bankCd = escapeHTML2($F("gdbdBankCdValue"));
			obj.bankAcctCd = escapeHTML2($F("gdbdBankAcctCdValue"));
			obj.bankAcct = obj.bankCd + "-" + obj.bankAcctCd;			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	} // dren 07.16.2015 : SR 0017729 - Set record when Adding - End

	function addRec(){ // dren 07.16.2015 : SR 0017729 - Function for adding new record - Start
		try {
			changeTagFunc = saveDCB;
			var dept = setRec(objBankAcctDetails);
			gdbdListTableGrid.addBottomRow(dept);
			changeTag = 1;
			computeGdpdSumTotal();
			gdbdListTableGrid.keys.removeFocus(gdbdListTableGrid.keys._nCurrentFocus, true);
			gdbdListTableGrid.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}	// dren 07.16.2015 : SR 0017729 - Function for adding new record - End		
	
	$("btnAddGDBD").observe("click", function() {
		if ($F("gaccGfunFundCd").blank() || $F("gaccGibrBranchCd").blank() || $F("gaccDspDCBYear").blank() || 
				$F("gaccDspDCBNo").blank() || $F("gaccDspDCBDate").blank()) {
			showMessageBox("Required fields must be entered.", imgMessage.INFO);
		} else {
			//$("gdbdRemarks").value = "";

			if ($F("btnAddGDBD") == "Add") {  // dren 07.16.2015 : SR 0017729 - Added condition for adding - Start
				if (!checkAllRequiredFieldsInDiv("bankAccountDetailsDiv")){
					showMessageBox("Required fields must be entered.", imgMessage.INFO);
				} else {
					addRec();
					setFieldValues(null);	
				} // dren 07.16.2015 : SR 0017729 - Added condition for adding - End
			} else {
				changeTag = 1;
				changeTagFunc = saveDCB;
				$("gdbdShortName").value = "";
				$("gdbdPayMode").value = "";
				disableButton("btnDeposits");
				disableButton("btnDeleteGDBD");		
				/*if($F("btnAddGDBD") == "Add"){
					gdbdListTableGrid.addNewRow();
					selectedGdbdIndex = -gdbdListTableGrid.newRowsAdded.length;
				}*/  // dren 07.16.2015 : SR 0017729 - Comment out and added new function for adding records 
				/* setGdbdValue($F("gaccTranId"), 'gaccTranId');
				setGdbdValue($F("gaccGfunFundCd"), 'fundCd');
				setGdbdValue($F("gaccGibrBranchCd"), 'branchCd');
				setGdbdValue($F("gaccDspDCBYear"), 'dcbYear');
				setGdbdValue($F("gaccDspDCBNo"), 'dcbNo');
				setGdbdValue($F("gaccDspDCBDate"), 'dcbDate'); */
				
				var item = setGdbd();
				gdbdListTableGrid.updateRowAt(item, selectedGdbdIndex);
			
				setGdbdValue(unformatCurrencyValue($F("gdbdOldDepositAmt")), 'oldDepAmt');
				setGdbdValue(unformatCurrencyValue($F("gdbdAdjustingAmt")), 'adjAmt');
				
				gdbdListTableGrid.onRemoveRowFocus();
				selectedGdbdIndex = null;
				computeGdpdSumTotal();
				observeChangeTagInTableGrid(gdbdListTableGrid);  //added by Halley 11.21.13			
			}
			countExistingRecords(); // dren 07.16.2015 : SR 0017729
			setBankAccountDetailsFields(); // dren 07.16.2015 : SR 0017729
			}
			/* disableButton("btnAddGDBD"); */ // dren 07.16.2015 : SR 0017729
	});
	
	$("btnDeleteGDBD").observe("click", function() {
		//$("gdbdRemarks").value = "";  //commented out by Halley 11.22.13
		//if (selectedGdbdRow < 0) {
		if ($("gdbdOldDepositAmt").value != 0) { // dren 07.16.2015 : SR 0017729 - Added delete functions - Start		
			showMessageBox("You cannot delete this record.", imgMessage.INFO); //added by Halley 11.22.13
		} else {		
		    //gdbdListTableGrid.deleteRows();		
			changeTagFunc = saveDCB; 
			objBankAcctDetails.recordStatus = -1;
			gdbdListTableGrid.deleteRow(selectedGdbdIndex);
			changeTag = 1;	
			computeGdpdSumTotal();
			setFieldValues(null);			
			disableButton("btnDeleteGDBD");
			gdbdListTableGrid.onRemoveRowFocus();
			selectedGdbdIndex = null;		
			observeChangeTagInTableGrid(gdbdListTableGrid);
			countExistingRecords();
			setBankAccountDetailsFields(); // dren 07.16.2015 : SR 0017729 - Added delete finctions - End			
		}
	}); 

	$("gdbdAdjustingAmt").observe("change", function(){ // dren 07.24.2015 : SR 0017729
	 	if ($("gdbdAdjustingAmt").value < 1) {	 		
	 		$("gdbdForeignCurrAmt").value = formatCurrency(parseFloat(unformatCurrencyValue(nvl($F("gdbdLocalCurrAmt"), "0"))) / parseFloat($F("gdbdCurrencyRt")));
	 	}
 	});	  	// dren 07.24.2015 : SR 0017729	
 	
	/* end of GDBD Block */
	
	/* GACC Block */
	
	/* Start modification of J. Diago for Fund and Branch LOV 10.04.2013 */
	$("gaccDspFundDesc").setAttribute("lastValidValue", "");
	$("gaccDspBranchName").setAttribute("lastValidValue", "");
	
	$("gaccDspFundDesc").observe("change", function() {		
		if($F("gaccDspFundDesc").trim() == "") {
			$("gaccGfunFundCd").value = "";
			$("gaccDspFundDesc").setAttribute("lastValidValue", "");
			$("gaccDspFundDesc").value = "";
			$("gaccGibrBranchCd").value = "";
			$("gaccDspBranchName").setAttribute("lastValidValue", "");
			$("gaccDspBranchName").value = "";
		} else {
			if($F("gaccDspFundDesc").trim() != "" && $F("gaccDspFundDesc") != $("gaccDspFundDesc").readAttribute("lastValidValue")) {
				showGIACS035FundLOV();
			}
		}
	});
	
	$("gaccDspBranchName").observe("change", function() {		
		if($F("gaccDspBranchName").trim() == "") {
			$("gaccDspBranchName").value = "";
			$("gaccDspBranchName").setAttribute("lastValidValue", "");
			$("gaccDspBranchName").value = "";
		} else {
			if($F("gaccDspBranchName").trim() != "" && $F("gaccDspBranchName") != $("gaccDspBranchName").readAttribute("lastValidValue")) {
				showGIACS035BranchLOV();
			}
		}
	});
	
	$("gaccDspFundDesc").observe("keyup", function(){
		$("gaccDspFundDesc").value = $F("gaccDspFundDesc").toUpperCase();
	});
	
	$("gaccDspBranchName").observe("keyup", function(){
		$("gaccDspBranchName").value = $F("gaccDspBranchName").toUpperCase();
	});
	
	if ($("oscmGaccCompany") != null) {
		$("oscmGaccCompany").observe("click", function() {
			/* Modalbox.show(contextPath+"/GIISFundsController?action=showCloseDCBFundCdLOV",
					{  title: "Valid Values for Company",
					   width: 800}); */
			showGIACS035FundLOV();
		});
	}
	
	if ($("oscmGaccBranch") != null) {
		$("oscmGaccBranch").observe("click", function() {
			if ($F("gaccDspFundDesc") != "") {
				/* Modalbox.show(contextPath+"/GIACBranchController?action=showCloseDCBBranchCdLOV"
						+ "&gfunFundCd=" + $F("gaccGfunFundCd")
						+ "&moduleId=GIACS035",
						{  title: "Valid Values for Branch",
						   width: 800}); */
				showGIACS035BranchLOV();
			} else {
				showMessageBox("Please enter the Company first.", imgMessage.INFO);
			}
		});
	}
	
	function showGIACS035FundLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getFundLOV",
							filterText : ($("gaccDspFundDesc").readAttribute("lastValidValue").trim() != $F("gaccDspFundDesc").trim() ? $F("gaccDspFundDesc").trim() : ""),
							page : 1},
			title: "List of Funds",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "fundCd",
								title: "Code",
								width : '100px',
							}, {
								id : "fundDesc",
								title : "Description",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("gaccDspFundDesc").readAttribute("lastValidValue").trim() != $F("gaccDspFundDesc").trim() ? $F("gaccDspFundDesc").trim() : ""),
				onSelect: function(row) {
					$("gaccGfunFundCd").value = row.fundCd;
					$("gaccDspFundDesc").value = row.fundDesc;
					$("gaccDspFundDesc").setAttribute("lastValidValue", row.fundDesc);
				},
				onCancel: function (){
					$("gaccDspFundDesc").value = $("gaccDspFundDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("gaccDspFundDesc").value = $("gaccDspFundDesc").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIACS035BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGeneralBranchLOV",
							gfunFundCd : $F("gaccGfunFundCd"),
							moduleId :  "GIACS035",
							filterText : ($("gaccDspBranchName").readAttribute("lastValidValue").trim() != $F("gaccDspBranchName").trim() ? $F("gaccDspBranchName").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("gaccDspBranchName").readAttribute("lastValidValue").trim() != $F("gaccDspBranchName").trim() ? $F("gaccDspBranchName").trim() : ""),
				onSelect: function(row) {
					$("gaccGibrBranchCd").value = row.branchCd;
					$("gaccDspBranchName").value = row.branchName;
					$("gaccDspBranchName").setAttribute("lastValidValue", row.branchName);								
				},
				onCancel: function (){
					$("gaccDspBranchName").value = $("gaccDspBranchName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("gaccDspBranchName").value = $("gaccDspBranchName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	/* End modification of J. Diago for Fund and Branch LOV 10.04.2013 */
    
	/* Modified by J. Diago 10.07.2013 to convert DCB Date LOV from modal to Overlay */
	if ($("oscmGaccDCBDate") != null) {
		$("oscmGaccDCBDate").observe("click", function() {
			if (!$F("gaccGfunFundCd").blank() && !$F("gaccGibrBranchCd").blank()) {
				/* Modalbox.show(contextPath+"/GIACCollnBatchController?action=showDCBDateLOV"
						+ "&gfunFundCd=" + $F("gaccGfunFundCd")
						+ "&gibrBranchCd=" + $F("gaccGibrBranchCd"),
						{  title: "Valid Values for DCB Date",
						   width: 350}); */
			    showGIACS035DCBDateLOV();
			} else {
				showMessageBox("Please enter the Company and Branch first.", imgMessage.INFO);
			}
		});
	}
	
	function showGIACS035DCBDateLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs035DcbDateLOV",
				gaccGfunFundCd : $F("gaccGfunFundCd"),
				gaccGibrBranchCd :  $F("gaccGibrBranchCd"),
				page : 1
			},
			title: "Valid Values for DCB Date",
			width: 350,
			height: 400,
			columnModel : 
			[
				{
					id : "dcbDate",
					title: "DCB Date",
					width: '325px',
					filterOption: true
				}
			],
			autoSelectOneRecord: true,
			filterText : $F("gaccDspDCBDate"),
			onSelect: function(row) {
				$("gaccDspDCBDate").value = row.dcbDate;
				$("gaccDspDCBYear").value = row.dcbYear;
				$("gaccDspDCBNo").value = "";
				$("controlPrevDCBDate").value = $F("gaccDspDCBDate");
				$("gicdSumDspFcSumAmt").value = "";
				$("controlDspGicdSumAmt").value = "";	
				gicdSumListTableGrid.url = contextPath+"/GIACAccTransController?action=refreshGicdSumListing";
				gdbdListTableGrid.url = contextPath+"/GIACBankDepSlipsController?action=refreshGdbdListing";
				gicdSumListTableGrid.empty();
				gdbdListTableGrid.empty();
			},
			onCancel: function (){
				
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("gaccDspDCBDate").value = "";
				$("gaccDspDCBYear").value = "";
			},
			onShow : function(){$(this.id+"_txtLOVFindText").value = "";}
		});
	}
	/* End of modification by J. Diago 10.07.2013 to convert DCB Date LOV from modal to Overlay */

	$("gaccDspDCBNo").observe("focus", function() {
		$("controlPrevDCBNo").value = $F("gaccDspDCBNo");
	});

	$("gaccDspDCBNo").observe("change", function() {
		validateGiacs035DCBNo1();
		//accValidateGiacs035DCBNo1();
	});
    
	/* Modified by J. Diago 10.07.2013 to convert LOV from modal to overlay. */
	if ($("oscmGaccDCBNo") != null) {
		$("oscmGaccDCBNo").observe("click", function() {
			$("controlPrevDCBNo").value = $F("gaccDspDCBNo");

			if ($F("gaccGfunFundCd").blank()) {
				showMessageBox("Please enter the Company first.", imgMessage.INFO);
			} else if ($F("gaccGibrBranchCd").blank()) {
				showMessageBox("Please enter the Branch first.", imgMessage.INFO);
			} else if ($F("gaccDspDCBDate").blank()) {
				showMessageBox("Please enter the DCB Date first.", imgMessage.INFO);
			} else if ($F("gaccDspDCBYear").blank()) {
				showMessageBox("Please enter the DCB Year first.", imgMessage.INFO);
			} else {
				/* Modalbox.show(contextPath+"/GIACCollnBatchController?action=showDCBNoLOV"
						+ "&gfunFundCd=" + $F("gaccGfunFundCd")
						+ "&gibrBranchCd=" + $F("gaccGibrBranchCd")
						+ "&dcbDate=" + $F("gaccDspDCBDate")
						+ "&dcbYear=" + $F("gaccDspDCBYear"),
						{  title: "Valid Values for DCB No.",
						   width: 300}); */
			    showGiacs035DcbNoLOV();
			}
		});
	}
	
	function showGiacs035DcbNoLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs035DcbNoLOV",
				gaccGfunFundCd : $F("gaccGfunFundCd"),
				gaccGibrBranchCd :  $F("gaccGibrBranchCd"),
				dcbDate : $F("gaccDspDCBDate"),
				dcbYear : $F("gaccDspDCBYear"),
				page : 1
			},
			title: "Valid Values for DCB Date",
			width: 350,
			height: 400,
			columnModel : 
			[
				{
					id : "dcbNo",
					title: "DCB Number",
					width: '325px',
					filterOption: true
				}
			],
			autoSelectOneRecord: true,
			onSelect: function(row) {
				$("gaccDspDCBNo").value = row.dcbNo;
				validateGiacs035DCBNo1();
			},
			onCancel: function (){
				
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("gaccDspDCBNo").value = "";
			},
			onShow : function(){$(this.id+"_txtLOVFindText").value = "";}
		});
	}
	/* End of modification by J. Diago 10.07.2013 to convert LOV from modal to overlay. */
	
	/** end of GACC block **/
	
	/** End of Field Events */
	
	/** Page functions **/
	/*
	** Gets the value of GDBD record in specified column and selected row
	*/
	function getGdbdValue(column) {
		return gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex(column), selectedGdbdIndex);
	}

	/*
	** Sets the value of GDBD record in specified column and selected row
	*/
	function setGdbdValue(value, column) {
		gdbdListTableGrid.setValueAt(value, gdbdListTableGrid.getColumnIndex(column), selectedGdbdIndex);
	}

	/*
	** Checks if GBDS2 row is existing on the array to be used in saving
	** If existing, just update the array. Otherwise, add the non-existing row.
	*/
	function addOrUpdateGbds2BlockRows(row) {
		var exists = false;
		var index = -1;
		
		for (var i = 0; i < gbds2BlockRows.length; i++) {
			if (String(nvl(row['depId'],"")).blank() &&
				gbds2BlockRows[i]['depNo'] == row['depNo'] &&
				gbds2BlockRows[i]['itemNo'] == row['itemNo']) {
				exists = true;
				index = i;
				break;
			} else if (gbds2BlockRows[i]['depId'] == row['depId'] &&
						gbds2BlockRows[i]['depNo'] == row['depNo'] &&
						gbds2BlockRows[i]['itemNo'] == row['itemNo']) {
				exists = true;
				index = i;
				break;
			}
		}

		if (exists) {
			gbds2BlockRows[index] = row;
		} else {
			gbds2BlockRows.push(row);
		}
	}

	/*
	** Checks if GCDD row is existing on the array to be used in saving
	** If existing, just update the array. Otherwise, add the non-existing row.
	*/
	function addOrUpdateGcddBlockRows(row) {
		var exists = false;
		var index = -1;
		
		for (var i = 0; i < gcddBlockRows.length; i++) {
			if (//gcddBlockRows[i]['gaccTranId'] == row['gaccTranId'] &&
				gcddBlockRows[i]['itemNo'] == row['itemNo']) {
				exists = true;
				index = i;
				break;
			}
		}

		if (exists) {
			gcddBlockRows[index] = row;
		} else {
			gcddBlockRows.push(row);
		}
	}

	/*
	** Checks if GBDS row is existing on the array to be used in saving
	** If existing, just update the array. Otherwise, add the non-existing row.
	*/
	function addOrUpdateGbdsBlockRows(row) {
		var exists = false;
		var index = -1;

		for (var i = 0; i < gbdsBlockRows.length; i++) {
			if (String(nvl(gbdsBlockRows[i]['depId'],"")).blank() &&
				gbdsBlockRows[i]['depNo'] == row['depNo'] &&
				gbdsBlockRows[i]['itemNo'] == row['itemNo']) {
				exists = true;
				index = i;
				break;
			} else if (gbdsBlockRows[i]['depId'] == row['depId'] &&
						gbdsBlockRows[i]['depNo'] == row['depNo'] &&
						gbdsBlockRows[i]['itemNo'] == row['itemNo']) {
				exists = true;
				index = i;
				break;
			}
		}

		if (exists) {
			gbdsBlockRows[index] = row;
		} else {
			gbdsBlockRows.push(row);
		}
	}

	/*
	** Checks if GBDSD row is existing on the array to be used in saving
	** If existing, just update the array. Otherwise, add the non-existing row.
	*/
	function addOrUpdateGbdsdBlockRows(row) {
		var exists = false;
		var index = -1;
		
		for (var i = 0; i < gbdsdBlockRows.length; i++) {
			if (//gbdsdBlockRows[i]['depId'] == row['depId'] &&
				gbdsdBlockRows[i]['depNo'] == row['depNo'] &&
				gbdsdBlockRows[i]['bankCd'] == row['bankCd']) {
				exists = true;
				index = i;
				break;
			}
		}

		if (exists) {
			gbdsdBlockRows[index] = row;
		} else {
			gbdsdBlockRows.push(row);
		}
	}
	/** End of Page functions **/
	
	/** Module Triggers **/
	// GDBD.PAY_MODE when-validate-item
	function validateGdbdPayMode(value) {
		var vPayMode;
		var vCurrencyCd;
		var vCurrencyRt;
		var vSumDepAmt;
		var vIdx;
		var vExists1 = "N";
		var vExists2 = "N";

		if (!nvl(getGdbdValue('currencyCd'), "").blank()
				&& !nvl(getGdbdValue('currencyRt'), "").blank()) {
			if (rgAmtPerPm == null) {
				showMessageBox("Record group amt_per_pm not found.", imgMessage.ERROR);
				return false;
			} else {
				var rowCnt = rgAmtPerPm.length;

				if (rowCnt == 0) {
					showMessageBox("Error in pay mode dynamic record group.", imgMessage.ERROR);
					return false;
				} else {
					for (var i = 0; i < rowCnt; i++) {
						vPayMode 	= rgAmtPerPm[i].payMode;
						vCurrencyCd = rgAmtPerPm[i].currencyCd;
						vCurrencyRt = rgAmtPerPm[i].currencyRt;
						vSumDepAmt 	= rgAmtPerPm[i].sumpDepAmt;

						if (value == vPayMode) {
							setGdbdValue(vCurrencyCd, 'currencyCd');
							setGdbdValue(vCurrencyRt, 'currencyRt');
							vIdx = i;
							vExists1 = "Y";
						}
					}

					if (vExists1 == "Y") {
						if (!$F("controlPrevPayMode").blank()) {
							for (var i = 0; i < rowCnt; i++) {
								vPayMode 	= rgAmtPerPm[i].payMode;
								vCurrencyCd = rgAmtPerPm[i].currencyCd;
								vCurrencyRt = rgAmtPerPm[i].currencyRt;
								vSumDepAmt 	= rgAmtPerPm[i].sumpDepAmt;

								if ($F("controlPrevPayMode") == vPayMode &&
									parseInt($F("controlPrevCurrencyCd")) == parseInt(vCurrencyCd) && 
									parseFloat($F("controlPrevCurrencyRt")) == parseFloat(vCurrencyRt)) {
									vIdx = i;
									vExists2 = "Y";
									vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) - parseFloat(nvl(getGdbdValue('amount'), "0"));
									rgAmtPerSum[i].sumDepAmt = vSumDepAmt;

									$("gaccDspGdbdSumAmount").value = parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0")) - parseFloat(nvl(getGdbdValue('amount'), "0"));

									setGdbdValue(null, 'amount');
									setGdbdValue(null, 'dspCurrSname');
									setGdbdValue(null, 'currencyCd');
									setGdbdValue(null, 'foreignCurrAmt');
									setGdbdValue(null, 'currencyRt');
									setGdbdValue(null, 'remarks');
								}
							}
						}
					} else {
						if (!$F("controlPrevPayMode").blank()) {
							for (var i = 0; i < rowCnt; i++) {
								vPayMode 	= rgAmtPerPm[i].payMode;
								vCurrencyCd = rgAmtPerPm[i].currencyCd;
								vCurrencyRt = rgAmtPerPm[i].currencyRt;
								vSumDepAmt 	= rgAmtPerPm[i].sumpDepAmt;

								if ($F("controlPrevPayMode") == vPayMode &&
										parseInt($F("controlPrevCurrencyCd")) == parseInt(vCurrencyCd) && 
										parseFloat($F("controlPrevCurrencyRt")) == parseFloat(vCurrencyRt)) {
									vIdx = i;
									vExists2 = "Y";
									vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) - parseFloat(nvl(getGdbdValue('amount'), "0"));
									rgAmtPerSum[i].sumDepAmt = vSumDepAmt;

									$("gaccDspGdbdSumAmount").value = parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0")) - parseFloat(nvl(getGdbdValue('amount'), "0"));

									setGdbdValue(null, 'amount');
									setGdbdValue(null, 'dspCurrSname');
									setGdbdValue(null, 'currencyCd');
									setGdbdValue(null, 'foreignCurrAmt');
									setGdbdValue(null, 'currencyRt');
									setGdbdValue(null, 'remarks');
								}
							}
						}
					}
				}
			}
		}
		
		return true;
	}

	// GDBD.DSP_CURR_SNAME when-validate-item
	function validateGdbdDspCurrSname(value) {
		if (selectedGdbdIndex < 0) {
			var vIdx;
			var vExists = "N";
			var vExists2 = "N";
			var vExists3 = "N";
			var vPayMode;
			var vCurrencyCd;
			var vCurrencyRt;
			var vSumDepAmt;
			
			if (nvl(getGdbdValue('currencyCd'), "").blank()) {
				showMessageBox("This currency has no currency code.", imgMessage.INFO);
				return false;
			}

			if (parseInt(getGdbdValue('currencyCd')) == 0) {
				showMessageBox("This currency has an invalid currency code.", imgMessage.INFO);
				return false;
			}

			if (nvl(getGdbdValue('currencyRt'), "").blank()) {
				showMessageBox("This currency has no currency rate.", imgMessage.INFO);
				return false;
			}

			if (parseFloat(getGdbdValue('currencyRt')) == 0) {
				showMessageBox("This currency has a zero currency rate.", imgMessage.INFO);
				return false;
			}

			setGdbdValue(roundNumber(parseFloat(getGdbdValue('amount')) / parseFloat(getGdbdValue('currencyRt')), 2), 'foreignCurrAmt');

			if (parseInt(nvl($F("controlPrevCurrencyCd"), "0")) != parseInt(nvl(getGdbdValue('currencyCd'), "0"))
			  || parseFloat(nvl($F("controlPrevCurrencyRt"), "0")) != parseFloat(nvl(getGdbdValue('currencyRt'), "0"))) {
				  if (!nvl(getGdbdValue('currencyCd'), "").blank() && !nvl(getGdbdValue('currencyCd'), "").blank()) {
					  new Ajax.Request(contextPath+"/GIACAccTransController?action=getCurrSnameGicdSumRec", {
							evalScripts: true,
							asynchronous: false,
							method: "GET",
							parameters: {
								gfunFundCd: $F("gaccGfunFundCd"),
								gibrBranchCd: $F("gaccGibrBranchCd"),
								dcbDate: $F("gaccDspDCBDate"),
								dcbYear: $F("gaccDspDCBYear"),
								dcbNo: $F("gaccDspDCBNo"),
								payMode: getGdbdValue('payMode'),
								currencyCd: getGdbdValue('currencyCd'),
								currencyRt: getGdbdValue('currencyRt')
							},
							onComplete: function(response) {
								if (checkErrorOnResponse(response)) {
									$("varTotAmtForGicdSumRec").value = response.responseText;
								}
							}
					   });

					   if (rgAmtPerPm == null) {
						   showMessageBox("Record group amt_per_pm not found.", imgMessage.ERROR);
						   return false;
					   } else {
						   if (rgAmtPerPm.length == 0) {
							   if (parseFloat(nvl(getGdbdValue('amount'), "0")) > parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0"))) {
								   setGdbdValue($F("controlPrevCurrencyCd"), 'currencyCd');
								   setGdbdValue($F("controlPrevCurrencyRt"), 'currencyRt');
								   setGdbdValue($F("controlPrevCurrSname"), 'dspCurrSname');
								   setGdbdValue($F("controlPrevForeignCurrAmt"), 'foreignCurrAmt');
								   showMessageBox("Amount for deposit should not exceed the total collection for this pay mode, currency code and currency rate.", imgMessage.INFO);
								   return false;
							   }

							   var rgAmtPerPmRec = new Object();

							   rgAmtPerPmRec.payMode = getGdbdValue('payMode');
							   rgAmtPerPmRec.currencyCd = getGdbdValue('currencyCd');
							   rgAmtPerPmRec.currencyRt = getGdbdValue('currencyRt');
							   rgAmtPerPmRec.sumDepAmt = parseFloat(nvl(getGdbdValue('amount'), "0"));

							   rgAmtPerPm.push(rgAmtPerPmRec);
						   } else {
							   for (var i = 0; i < rgAmtPerPm.length; i++) {
								   vPayMode = rgAmtPerPm[i].payMode;
								   vCurrencyCd = rgAmtPerPm[i].currencyCd;
								   vCurrencyRt = rgAmtPerPm[i].currencyRt;
								   vSumDepAmt = rgAmtPerPm[i].sumDepAmt;
								   if (nvl(getGdbdValue('payMode'), "") == rgAmtPerPm[i].payMode
									 && parseInt(getGdbdValue('currencyCd')) == parseInt(vCurrencyCd)
									 && parseFloat(getGdbdValue('currencyRt')) == parseFloat(vCurrencyRt)) {
									   vIdx = i;
									   vExists = "Y";
									   break;
								   }
							   }

							   if (vExists == "Y") {
								   if (parseInt($F("controlPrevCurrencyCd")) != parseInt(getGdbdValue('currencyCd'))
									 || parseFloat($F("controlPrevCurrencyRt")) != parseFloat(getGdbdValue('currencyRt'))) {
									   for (var i = 0; i < rgAmtPerPm.length; i++) {
										   vCurrencyCd = rgAmtPerPm[i].currencyCd;
										   vCurrencyRt = rgAmtPerPm[i].currencyRt;
										   vSumDepAmt = rgAmtPerPm[i].sumDepAmt;
										   if (parseInt($F("controlPrevCurrencyCd")) == parseInt(vCurrencyCd)
													 && parseFloat($F("controlPrevCurrencyRt")) != parseFloat(vCurrencyRt)) {
												 vIdx = i;
												 vExists2 = "Y";
												 vSumDepAmt = parseFloat(nvl(rgAmtPerPm[i].sumDepAmt, "0")) - parseFloat(nvl(getGdbdValue('amount'), "0"));
												 rgAmtPerPm[i].sumDepAmt = vSumDepAmt;
												 break;
										   }
									   }
								   }

								   if (vExists2 == "Y") {
									   for (var i = 0; i < rgAmtPerPm.length; i++) {
										   vPayMode = rgAmtPerPm[i].payMode;
										   vCurrencyCd = rgAmtPerPm[i].currencyCd;
										   vCurrencyRt = rgAmtPerPm[i].currencyRt;
										   vSumDepAmt = rgAmtPerPm[i].sumDepAmt;
										   
										   if (nvl(getGdbdValue('payMode'), "") == vPayMode
										     && parseInt(getGdbdValue('currencyCd')) == parseInt(vCurrencyCd)
											 && parseFloat(getGdbdValue('currencyRt')) == parseFloat(vCurrencyRt)) {
											   vIdx = i;
											   vExists3 = "Y";
											   break;
										   }
									   }

									   if (vExists3 == "Y") {
										   vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) + parseFloat(nvl(getGdbdValue('amount'), "0"));

										   if (vSumDepAmt > parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0"))) {
											   setGdbdValue($F("controlPrevCurrencyCd"), 'currencyCd');
											   setGdbdValue($F("controlPrevCurrencyRt"), 'currencyRt');
											   setGdbdValue($F("controlPrevCurrSname"), 'dspCurrSname');
											   setGdbdValue($F("controlPrevForeignCurrAmt"), 'foreignCurrAmt');
											   showMessageBox("Amount for deposit should not exceed the total collection for this pay mode, currency code and currency rate.", imgMessage.INFO);
											   return false;
										   }

										   rgAmtPerPm[vIdx].sumDepAmt = vSumDepAmt;
									   }
								   } else {
									   vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) + parseFloat(nvl(getGdbdValue('amount'), "0"));

									   if (vSumDepAmt > parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0"))) {
										   setGdbdValue($F("controlPrevCurrencyCd"), 'currencyCd');
										   setGdbdValue($F("controlPrevCurrencyRt"), 'currencyRt');
										   setGdbdValue($F("controlPrevCurrSname"), 'dspCurrSname');
										   setGdbdValue($F("controlPrevForeignCurrAmt"), 'foreignCurrAmt');
										   showMessageBox("Amount for deposit should not exceed the total collection for this pay mode, currency code and currency rate.", imgMessage.INFO);
										   return false;
									   }

									   rgAmtPerPm[vIdx].sumDepAmt = vSumDepAmt;
								   }
							   } else {
								   if (parseFloat(nvl(getGdbdValue('amount'), "0")) > parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0"))) {
									   setGdbdValue($F("controlPrevCurrencyCd"), 'currencyCd');
									   setGdbdValue($F("controlPrevCurrencyRt"), 'currencyRt');
									   setGdbdValue($F("controlPrevCurrSname"), 'dspCurrSname');
									   setGdbdValue($F("controlPrevForeignCurrAmt"), 'foreignCurrAmt');
									   showMessageBox("Amount for deposit should not exceed the total collection for this pay mode, currency code and currency rate.", imgMessage.INFO);
									   return false;
								   }

								   for (var i = 0; i < rgAmtPerPm.length; i++) {
									   vCurrencyCd = rgAmtPerPm[i].currencyCd;
									   vCurrencyRt = rgAmtPerPm[i].currencyRt;
									   vSumDepAmt = rgAmtPerPm[i].sumDepAmt;

									  if (parseInt($F("controlPrevCurrencyCd")) == parseInt(vCurrencyCd)
										&& parseFloat($F("controlPrevCurrencyRt")) == parseFloat(vCurrencyRt)) {
											vIdx = i;
											vExists2 = "Y";
											vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) - parseFloat(nvl(getGdbdValue('amount'), "0"));
											rgAmtPerPm[vIdx].sumDepAmt = vSumDepAmt;
											break;
									  }
								   }

								   var rgAmtPerPmRec = new Object();

								   rgAmtPerPmRec.payMode = getGdbdValue('payMode');
								   rgAmtPerPmRec.currencyCd = getGdbdValue('currencyCd');
								   rgAmtPerPmRec.currencyRt = getGdbdValue('currencyRt');
								   rgAmtPerPmRec.sumDepAmt = getGdbdValue('amount');

								   rgAmtPerPm.push(rgAmtPerPmRec);
							   }
						   }
					   }
				  }
			}
		}
		
		return true;
	}

	// GDBD.FOREIGN_CURR_AMT post-text-item
	function executeGdbdForeignCurrAmtPostTextItem(value) {
		var ok = true;
		var vAmount;
		var vPayMode;
		var vCurrencyCd;
		var vCurrencyRt;
		var vSumDepAmt;
		var vIdx;
		var vExists = "N";
		
		if (parseFloat(value) != parseFloat($F("controlPrevForeignCurrAmt"))) {
			$("controlPrevAmount").value = nvl(getGdbdValue('amount'));

			if (parseFloat(value) == parseFloat($F("varTotFcAmtForGicdSumRec"))) {
				vAmount = roundNumber(parseFloat(nvl(value, "0")) * parseFloat(nvl(getGdbdValue('currencyRt'), "0")), 2);

				if (vAmount > parseFloat($F("varTotAmtForGicdSumRec"))) {
					setGdbdValue(parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0")), 'amount');
				} else {
					setGdbdValue(vAmount, 'amount');
				}
			} else {
				setGdbdValue(roundNumber(parseFloat(nvl(value, "0")) * parseFloat(nvl(getGdbdValue('currencyRt'), "0")), 2), 'amount');
			}

			$("gaccDspGdbdSumAmount").value = parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0")) -
												parseFloat(nvl($F("controlPrevAmount"), "0")) +
												parseFloat(nvl(getGdbdValue('amount'), "0"));

			if (parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0")) > parseFloat(nvl($F("controlDspGicdSumAmt"), "0"))) {
				$("gaccDspGdbdSumAmount").value = parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0")) -
													parseFloat(nvl(getGdbdValue('amount'), "0")) +
													parseFloat(nvl($F("controlPrevAmount"), "0"));
				setGdbdValue($F("controlPrevAmount"), 'amount');
				setGdbdValue(parseFloat(nvl($F("controlPrevForeignCurrAmt"), "0")), 'foreignCurrAmt');
				showMessageBox("Amount for deposit should not exceed total collection.", imgMessage.INFO);
				return false;
			}

			if (rgAmtPerPm == null) {
				showMessageBox("Error in foreign_curr_amt record group.", imgMessage.ERROR);
				return false;
			} else {
				for (var i = 0; i < rgAmtPerPm.length; i++) {
					vPayMode = rgAmtPerPm[i].payMode;
					vCurrencyCd = parseInt(rgAmtPerPm[i].currencyCd);
					vCurrencyRt = parseFloat(rgAmtPerPm[i].currencyRt);
					vSumDepAmt = rgAmtPerPm[i].sumDepAmt;

					if (nvl(getGdbdValue('payMode'), "") == vPayMode
						&& parseInt(getGdbdValue('currencyCd')) == vCurrencyCd
						&& parseFloat(getGdbdValue('currencyRt')) == vCurrencyRt) {
						vIdx = i;
						vExists = "Y";
						break;
					}
				}

				if (vExists == "Y") {
					if (parseFloat(nvl($F("controlPrevAmount"), "0")) != parseFloat(nvl(getGdbdValue('amount'), "0"))) {
						vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) +
										parseFloat(nvl(getGdbdValue('amount'), "0")) -
										parseFloat(nvl($F("controlPrevAmount"), "0"));
					} else {
						vSumDepAmt = parseFloat(nvl(vSumDepAmt, "0")) +	parseFloat(nvl(getGdbdValue('amount'), "0"));
					}

					if (vSumDepAmt > parseFloat(nvl($F("varTotAmtForGicdSumRec"), "0"))) {
						$("gaccDspGdbdSumAmount").value = parseFloat(nvl($F("gaccDspGdbdSumAmount"), "0")) -
															parseFloat(nvl(getGdbdValue('amount'), "0")) +
															parseFloat(nvl($F("controlPrevAmount"), "0"));
						setGdbdValue(parseFloat($F("controlPrevAmount")), 'amount');
						setGdbdValue(parseFloat(nvl($F("controlPrevForeignCurrAmt"), "0")), 'foreignCurrAmt');
						showMessageBox("Amount for deposit should not exceed the total collection for this pay mode, currency code and currency rate.", imgMessage.INFO);
					}

					rgAmtPerPm[vIdx].sumDepAmt = vSumDepAmt;
				} else {
					var rgAmtPerPmRec = new Object();

					rgAmtPerPmRec.payMode = getGdbdValue('payMode');
					rgAmtPerPmRec.currencyCd = getGdbdValue('currencyCd');
					rgAmtPerPmRec.currencyRt = parseFloat(getGdbdValue('currencyRt'));
					rgAmtPerPmRec.sumDepAmt = parseFloat(nvl(getGdbdValue('amount'), "0"));

					rgAmtPerPm.push(rgAmtPerPmRec);
				}
			}
		}
		
		return ok;
	}
	/** End of Module Triggers **/
	
	/*
	** Checks if the required fields in GBDSD are filled up
	*/
	function requiredGdbdColumnsHaveValues() {
		var requiredColumns = $w(gdbdListTableGrid.requiredColumns);
		var ok = true;

		if (selectedGdbdIndex == null) {
			return true;
		}
		
		for (var i = 0; i < requiredColumns.length; i++) {
			if(String(getGdbdValue(requiredColumns[i])).blank()) {
				ok = false;
				break;
			}
		}

		return ok;
	}
	/** */
	
	function viewAcctEntries() {
		try {
			if(changeTag == 1) {
				showMessageBox("Please save your changes first.");
			} else {
				new Ajax.Updater("dcbMainDiv", contextPath + "/GIACAcctEntriesController?action=showAcctEntries", {
					method: "POST",
					parameters: {
						gaccTranId: $F("gaccTranId"),
						dcbFlag: "Y",
						fundCd: $F("gaccGfunFundCd"),
						branchCd: $F("gaccGibrBranchCd")
						},
					asynchronous: true,
					evalScripts: true,
					onCreate: function() {
						showNotice("Loading DCB Accounting Entries. Please Wait...</br> " + contextPath);
					}, 
					onComplete: function() {
						hideNotice("");
						
					}
				});
			}
		} catch(e) {
			showErrorMessage();
		}
	}
	
	function showAcctEntries(){  
		new Ajax.Request(contextPath+"/GIACAccTransController", {
			method: "POST",
			parameters: {
			    action : "checkUserAccess2",
			    moduleName : "GIACS042"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				//showNotice("Checking if DCB is valid for closing...");
			},
			onComplete: function(response) {
				//hideNotice();
				if(response.responseText == "0") {
					showMessageBox("You are not allowed to access this module.");
				} else if(isNaN(parseFloat(response.responseText))) {
					showMessageBox("Error in validating user.");
				} else {
					viewAcctEntries();
				}
			}
		});
	}
	
	//added by Halley 11.22.13
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		updateMainContentsDiv("/GIACAccTransController?action=showDCBListing", "Retrieving DCB list, please wait...");
		hideAccountingMainMenus();
	});
	
	// Added by J. Diago 10.04.2013 for exit function.
	function exitPage(){
		updateMainContentsDiv("/GIACAccTransController?action=showDCBListing",
		"Retrieving DCB list, please wait...");
		objAC.butLabel = "Spoil OR";	//tonio March 15, 2011
		$("acExit").show(); // added by andrew - 02.18.2011
		hideAccountingMainMenus();
	}
	
	// Added by J. Diago 10.04.2013 to handle modifications upon cancelling page.
	$("btnCancel").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS035.exitPage = exitPage;
						saveDCB();						
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	});
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS035.exitPage = exitPage;
						saveDCB();						
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	});
	
	//marco - 02.20.2015
	$("btnRefresh").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showConfirmBox("Confirmation", "Bank Account Details will be refreshed. Would you like to continue?", "Yes", "No", refreshDCB, null, null)
		}
	});
	
	//marco - 02.20.2015
	function refreshDCB(){ 
		new Ajax.Request(contextPath+"/GIACAccTransController", {
			method: "POST",
			parameters: {
				action: "refreshDCB",
				gaccTranId: objACGlobal.gaccTranId,
				fundCd: $F("gaccGfunFundCd"),
				branchCd: $F("gaccGibrBranchCd"),
				dcbYear: $F("gaccDspDCBYear"),
				dcbNo: $F("gaccDspDCBNo"),
				dcbDate: $F("gaccDspDCBDate"),
				moduleName: $F("moduleName") // dren 08.03.2015 : SR 0017729 - Additional parameter for Refresh DCB				
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Processing, please wait...");
			},
			onComplete: function(response) {
				hideNotice("");
				if(checkCustomErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", editDCBInformation);
				}
			}
		});
	}
	
	changeTagFunc = saveDCB;
	
	observeAccessibleModule(accessType.BUTTON, "GIACS042", "btnAcctEntries", showCloseDcbAcctEntries);
	//end 

	observeReloadForm("reloadForm", editDCBInformation);
</script>