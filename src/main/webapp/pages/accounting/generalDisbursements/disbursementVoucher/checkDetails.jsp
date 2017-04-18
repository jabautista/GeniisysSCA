<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- <div id="mainNav" name="mainNav"> 
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="checkDetailsExit">Exit</a></li>
		</ul>
	</div>
</div> -->


<div id="checkInformationMainDiv" name="checkInformationMainDiv">
	<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Check Details</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
					<label id="reloadForm" name="reloadForm" style="margin-left: 5px">Reload Form</label>
				</span>				 
			</div>
	</div> 

	<form id="checkInformationForm" name="checkInformationForm" >
		<div id="checkInformationSubDiv1" name="checkInformationSubDiv1" class="sectionDiv">
			<table border="0" style="width:800px; margin:30px auto 20px auto;" cellpadding="0" cellspacing="2">
				<tr>
					<td align="right" style="width:70px;">Company</td>
					<td>
						<!-- <input type="text" id="txtMIRFundCd" name="txtMIRFundCd" class="required" /> -->
						<input type="text" id="company" name="company" readonly="readonly" style="width:300px; float:left; margin-left:5px;" tabindex="101" />
						<input type="hidden" id="txtFundCd" name="txtFundCd" />
						<input type="hidden" id="txtDspFundDesc" name="txtDspFundDesc" />	
					</td>
					<td align="right" style="width:70px;">Branch</td>
					<td>
						<input type="text" id="txtBranch" name="txtBranch" readonly="readonly" style="width:250px; float:left; margin-left:5px;"  tabindex="102" />
						<input type="hidden" id="hidBranchCd" name="hidBranchCd" />
						<input type="hidden" id="hidBranchName" name="hidBranchName" />
						<input type="hidden" id="hidLastUpdate" name="hidLastUpdate" />			
					</td>
				</tr>
				<tr style="height:20px;"><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td align="right">Payee</td>
					<td colspan="3"><input type="text" id="txtMIRPayee" name="txtMIRPayee" style="float:left; width:678px; margin-left:5px;" readonly="readonly" /></td>					
				</tr>
				<tr>
					<td align="right">DV No.</td>
					<td>
						<input type="text" id="txtMIRDVPref" name="txtMIRDVPref" style="float:left; width:90px; margin-left:5px;" readonly="readonly" />
						<input type="text" id="txtMIRDVNo" name="txtMIRDVNo" style="float:left; text-align: right; width:200px; margin-left:4px;" readonly="readonly" />
					</td>		
					<td align="right">DV Amount</td>
					<td>
						<input type="text" id="txtMIRForeignCurrency" name="txtMIRForeignCurrency" style="float:left; margin-left:5px; width:70px;" readonly="readonly"  />
						<input type="text" id="txtMIRForeignAmount" name="txtMIRForeignAmount" style="float:left; margin-left:4px; width:167px; text-align:right;" readonly="readonly" />
					</td>			
				</tr>
				<tr>
					<td>
						<input type="hidden" id="hidGaccTranId" name="hidGaccTranId" />
						<input type="hidden" id="hidTotalAmt" name="hidTotalAmt" />
						<input type="hidden" id="hidBatchTag" name="hidBatchTag" />
					</td>
				</tr>
			</table>
 		</div> <!-- end of checkInformationSubDiv1 -->
		
		<div id="checkInformationSubDiv2" name="checkInformationSubDiv2" class="sectionDiv" >
			<div id="radioBtnsDiv" name="radioBtnsDiv" style="text-align:left; width:530px; height:30px; float:left; margin: 15px 5px 5px 10px;">
				<table>
					<tr>
						<td><input type="radio" id="rdoCheckDisbursement" name="rdoDisbMode" value="checkDisbursement" style="width: 30px" checked="checked" tabindex="201"/></td>
						<td style="width:200px; text-align:left;"><label for="rdoCheckDisbursement"> Check Disbursement</label></td>
						<td><input type="radio" id="rdoBankTransfer" name="rdoDisbMode" value="bankTransfer" style="width: 30px" tabindex="202"/></td>
						<td><label for="rdoBankTransfer"> Bank Transfer</label></td>
					</tr>
				</table>
			</div>
			
			<div id="checkInformationListing" name="checkInformationListing" style="text-align:left; width:900px; height:300px; float:left; margin: 5px 5px 10px 10px;">
			
			</div>
			
			<div id="checkInformationListingFields" name="checkInformationListingFields"  style="text-align:left; width:820px; height:175px; float:left; margin: 10px 5px 5px 50px;" changeTagAttr="true">
				<table align="center" style="width:600px;" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right">Item</td>
						<td><input type="text" id="txtTGItem" name="txtTGItem" maxLength="3" style="text-align:right; margin-left:5px; width:350px;" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered Item Number is invalid. Valid value is from 1 to 999." min="1" max="999" /></td> 
					</tr>
					<tr>
						<td align="right">Bank/Bank Account No.</td>
						<td>
							<!-- <input type="text" id="txtTGBank" name="txtTGBank" maxLength="3" style="margin-left:5px; width:350px;" /> -->
							<div style="float:left; border: solid 1px gray; width: 356px; height: 23px; margin-left:5px;margin-right:0px; margin-top: 0px;" class="required">
								<input type="text" id="txtTGBank" name="txtTGBank" readonly="readonly" style="width:320px; margin-left:5px; border:none; float:left;" class="required" ignoreDelKey="1"/>  <!-- added ignoreDelKey : shan 05.22.2014 -->
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBankNo" name="osBankNo" alt="Go" />
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">Currency Code</td>
						<td><input type="text" id="txtTGCurrencyCd" name="txtTGCurrencyCd" maxLength="3" style="margin-left:5px; width:350px;" class="required" readonly="readonly" /></td>
					</tr>
					<tr>
						<td align="right">Amount</td>
						<td><input type="text" id="txtTGAmount" name="txtTGAmount" maxLength="22" style="text-align:right;margin-left:5px; width:350px;" class="required" /></td>
					</tr>
					<tr>
						<td align="right">Currency Rate</td>
						<td><input type="text" id="txtTGCurrencyRt" name="txtTGCurrencyRt" maxLength="14" style="text-align:right;margin-left:5px; width:350px;" class="required" readonly="readonly" /></td>
					</tr>
					<tr>
						<td align="right">Local Currency Amount</td>
						<td><input type="text" id="txtTGLocalCurrencyAmount" name="txtTGLocalCurrencyAmount" maxLength="21" style="text-align:right;margin-left:5px; width:350px;" class="required" readonly="readonly" /></td>
					</tr>
					<tr>
						<td>
							<input type="hidden" id="hidBankCd" name="hidBankCd" />
							<input type="hidden" id="hidBankAcctCd" name="hidBankAcctCd" />
							<input type="hidden" id="hidBankSname" name="hidBankSname" />
							<input type="hidden" id="hidBankAcctNo" name="hidBankAcctNo" />							
						</td>
					</tr>
				</table>
			</div>
			
			<div id="checkInformationListingButtons" name="checkInformationListingButtons" class="buttonsDiv" style="margin: 5px 5px 20px 40px;">
				<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" style="width: 90px;" />
				<input type="button" class="button" id="btnDelete" name="btnCancel" value="Delete" style="width: 90px;" />
			</div>
			
		</div><!-- end of checkInformationSubDiv2 -->
		
		<div id="checkInformationSubDiv3" name="checkInformationSubDiv3" class="sectionDiv" style="height:230px;" changeTagAttr="true">
			<table border="0" style="width:860px; margin:30px auto 20px auto;" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right" style="width:80px;">Payee</td>
					<td colspan="5">
					    <div style="float:left; border: solid 1px gray; width: 81px; height: 21px; margin-left: 5px; margin-top:0px;  margin-bottom:5px;" >
							<input style="width: 56px;  height: 13px; margin-left: 0px;  text-align: right; border: none;" id="txtPayeeClassCd" name="txtPayeeClassCd" type="text" value="" readOnly="readonly" />
							<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeClassCd" name="lovPayeeClassCd" alt="Go"/>
						</div>
					    <div style="width: 161px; height: 21px; float: left; border: solid 1px gray; margin-left: 5px; margin-top:0px;  margin-bottom:5px;" >
							<input style="width: 135px; height: 13px; text-align: right; border: none;" id="txtPayeeNo" name="txtPayeeClassNo" type="text" value="" readOnly="readonly" />
							<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeNo" name="lovPayeeNo" alt="Go" />
						</div>
						<input type="text" id="txtPayeeName" name="txtPayeeClassName" style="float:left; margin-left:5px; margin-top:0px;  margin-bottom:5px; width:483px; height: 15px; " readonly="readonly" />
						
						<!-- <input type="text" id="txtPayeeClassCd" name="txtPayeeClassCd" style="float:left; margin-left:5px; width:60px;" readonly="readonly"  />
						<input type="text" id="txtPayeeNo" name="txtPayeeClassNo" style="text-align:right;float:left; margin-left:3px; width:150px;" readonly="readonly"  /> 
						<input type="text" id="txtPayeeName" name="txtPayeeClassName" style="float:left; margin-left:3px; width:508px;" readonly="readonly" />
						<!-- jeffDojello Enhancement SR-1069 11.05.2013 -->
						
					</td>
				</tr>
				<tr>
					<td align="right" id="dspTDCheckButtonNo" style="width:90px;">Check No.</td>
					<td>
						<input type="text" id="txtCheckPrefSuf" name="txtCheckPrefSuf" maxLength="5" style="float:left; margin-left:5px; width:39px;"  />
						<input type="text" id="txtCheckNo" name="txtCheckNo" maxLength="10" style="text-align:right;float:left; margin-left:3px; width:110px;" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Check Number is invalid. Valid value is from 1 to 9999999999." min="1" max="9999999999" />
					</td> 
					<td align="right" id="dspTDCheckClassLabel" style="width:90px;">Check Class</td>
					<td id="dspTDCheckClassLabel2" style="width:190px;">
						<div id="dspTDCheckClassLabel3">
							<div style="float:left; border: solid 1px gray; width: 50px; height: 21px; margin: 2px 0px 0px 5px; " >
							<input type="text" id="txtCheckClass" name="txtCheckClass" lastValidValue="" style="width:25px;height:11px;  margin-left:0px; border:none; float:left;" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCheckClass" name="osCheckClass" alt="Go" />
						</div>
						<input type="text" id="txtCheckClassMean" maxLength="15" name="txtCheckClassMean" style="float:left; margin-left:3px; width:105px;" readonly="readonly" />
						</div>
					</td><!-- <input type="text" id="txtCheckClass" maxLength="3" name="txtCheckClass" style="float:left; margin-left:5px; width:39px;" readonly="readonly"  /> -->
					<td align="right" id="dspTDCheckBTStatus" style="width:110px;">Check Status</td>
					<td id="dspTDCheckBTStatus2">
						<input type="text" id="txtCheckStat" maxLength="1" name="txtCheckStat" style="float:left; margin-left:5px; width:39px;" readonly="readonly" />
						<input type="text" id="txtCheckStatMean" maxLength="9" name="txtCheckStatMean" style="float:left; margin-left:3px; width:110px;" readonly="readonly" />
					</td> <%-- <div style="float:left; border: solid 1px gray; width: 39px; height: 23px; margin-left:5px;margin-right:0px; margin-top: 0px;" changeTagAttr="true">
							<input type="text" id="txtCheckStat" name="txtCheckStat" readonly="readonly" style="width:25px; margin-left:5px; border:none; float:left;" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCheckStat" name="osCheckStat" alt="Go" />
						</div> --%>						
				</tr>
				<tr>
					<td align="right" id="dspTDCheckBTDate">Check Date</td>
					<td id="dspTDCheckBTDate2">
						<!-- <input type="text" id="txtCheckDate" name="txtCheckDate" style="float:left; margin-left:5px; width:160px;" readonly="readonly"  /> -->
						<div id="dspDivCheckBTDate2" style="border: solid 1px gray; width:165px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;">
					    	<input type="text" id="txtCheckDate" name="txtCheckDate"  style="float:left;width:140px; border: none; height:12px;" ignoreDelKey = "true"/>
					    	<img name="hrefCheckDate" id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="checkDate" />
						</div>
					</td>
					<td colspan="2"></td>
					<td align="right" id="dspTDCheckPrintDate">Check Print Date</td>
					<td id="dspTDCheckPrintDate2">
						<div id="dspTDCheckPrintDate3" style="border: solid 1px gray; width:166px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;">
							<input type="text" id="txtCheckPrintDate" name="txtCheckPrintDate" style="float:left;width:141px; border: none; height:12px;" readonly="readonly" ignoreDelKey = "true"/>
							<img name="hrefCheckPrintDate" id="hrefCheckPrintDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="checkPrintDate" />
						</div>
					</td>
				</tr>
				<tr>
					<td align="right">Particulars</td>
					<td class="leftAligned" colspan="5">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 746px; border: 1px solid gray; height: 20px;">
							<textarea style="float: left; height: 14px; width: 720px; margin-top: 0; border: none;" id="txtParticulars" name="txtParticulars" maxlength="500" onkeyup="limitText(this,500);" ></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" />
						</div>
						<!-- <input type="text" id="txtParticulars" name="txtParticulars" style="float:left; margin-left:5px; width:740px;"  /> -->
					</td>
				</tr>
				<tr>
					<td align="right">User ID</td>
					<td><input type="text" id="txtUserID" name="txtUserID" style="float:left; margin-left:5px; width:160px;" readonly="readonly" /></td>
					<td colspan="2"></td>
					<td align="right">Last Update</td>
					<td><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="float:left; margin-left:5px; width:160px;" readonly="readonly" /></td>
				</tr>
			</table>
			
			<div id="subDiv4" name="subDiv4" class="buttonsDiv" style="margin: 0px 5px 20px 40px;">
				<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 90px;" />
				<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 90px;" />
			</div>
			
		</div><!-- end of checkInformationSubDiv3 -->
		
		<div id="checkInformationButtonsDiv" name="checkInformationButtonsDiv" class="buttonsDiv" style="margin: 20px 5px 30px 40px;">
			<input type="button" id="btnSpoilCheck" name="btnSpoilCheck" class="button" value="Spoil Check" style="width:120px;" />
			<input type="button" id="btnPrintCheckDV" name="btnPrintCheckDV" class="button" value="Print Check / DV" style="width:120px;" />
			<input type="button" id="btnCheckRelease" name="btnCheckRelease" class="button" value="Check Release" style="width:120px;" />
			<input type="button" id="btnReturn" name="btnReturn" class="button" value="Return" style="width:90px;" />			
		</div> <!-- <input type="button" id="btnCancelDV" name="btnCancelDV" class="button" value="Cancel DV" style="width:120px;" /> -->
	
	</form>
</div>
<script type="text/javascript">
	try {
		var chkDisbInfo = JSON.parse('${chkDisbInfo}');
		var disbVoucherInfo = objGIACS002.disbVoucherInfo; //JSON.parse('${disbVoucherInfo}');
		var paramCheckPref = '${paramCheckPref}';
		var paramUpdatePayeeName = '${paramUpdatePayeeName}';
		var paramGenBankTransferNo = '${paramGenBankTransferNo}';
		var paramCheckDVPrint = '${paramCheckDVPrint}';
		var checkDVPrintColumn = '${checkDVPrintColumn}'; //added by steven 09.15.2014
		paramCheckDVPrint = nvl(checkDVPrintColumn,paramCheckDVPrint); //added by steven 09.15.2014
		var paramAllowDVPrinting = '${paramAllowDVPrinting}';
		var varUserId = '${userId}';
		var tranFlag = '${tranFlag}';
		var gidvPrintTag = null; //added by robert 01.26.15
		
		//jeffDojello Enhancement SR-1069 11.05.2013
		if(paramUpdatePayeeName=="Y"){
			$("lovPayeeClassCd").show();
			$("lovPayeeNo").show();
		}else{
			$("lovPayeeClassCd").hide();
			$("lovPayeeNo").hide();
		}
		
	} catch(e){
		showErrorMessage("checkDetails.jsp", e);
	}
	
	objGIACS002.exitPage = null;
	
	var isReset = false; // if tgfields should be reset
	changeTag = 0;
	objGIACS002.chkReleaseInfo = null;
	
	// for the table grid
	var checkListSelectedIndex = -1;
	var checkListSelectedRow = "";
	var itemNoCtr = 0;
	objGIACS002.itemNoList = null;
	
	var isNewLoad = true; // page is newly loaded - used to check if needed to autoselect first record in tg.
	//var isEmpty = false; // determines if tg has rows.
	
	var objCheckArray = [];
	var objCheck = new Object();
	objCheck.objCheckListTableGrid = JSON.parse('${checkList}');  //.replace(/\\/g, '\\\\')
	objCheck.objCheckList = objCheck.objCheckListTableGrid.rows || [];
	var buttons2 = [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
	try{
		var checkTableModel = {
				url : contextPath + "/GIACDisbVouchersController?action=getGIACS002ChkDisbursementTG&refresh=1" + "&gaccTranId=" + objACGlobal.gaccTranId, // + "&dvItem=" + JSON.stringify(disbVoucherInfo),
				options : {
					title :'',
					width : '900px',
					height: '280px',
					hideColumnChildTitle: true,
					newRowPosition: 'bottom',
					onCellFocus: function(elemet, value, x, y, id){
						var mtgId = checkListTableGrid._mtgId;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							var row = checkListTableGrid.geniisysRows[y];
							checkListSelectedIndex = y;
							checkListSelectedRow = row;
							populateChkFields(row, true);
						}						
					},
					onRemoveRowFocus: function(){
						checkListTableGrid.keys.releaseKeys();
	                	checkListSelectedIndex = -1;
	                	checkListSelectedRow = "";
	                	
	                	populateChkFields(null, false);	                	
		          	},
					onRowDoubleClick : function(y){
						var row = checkListTableGrid.geniisysRows[y];
						populateChkFields(row, true);
					},
					beforeSort: function(){
						if(changeTag != 0){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							return true;
						} 
					},
					prePager: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							return true;
						}
					},
					
					checkChanges: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailRequireSaving: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetail: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailSaveFunc: function() {
						return (changeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
					
					toolbar : {
						elements : buttons2						
					}
				},
				columnModel : [
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
								    id: 'gaccTranId',
								    title: 'gaccTranId',
								    width: '70',
									visible: false
								},
								{
								    id: 'itemNo',
								    title: 'Item',
								    width: '50px',
								    visible: true,
								    filterOption: true
								},
								{
									id: 'bankCd bankAcctCd dspBankSname bankAcctNo',
									title: 'Bank/Bank Account No',
									titleAlign: 'center',
									children: [
										{
											id : 'bankCd',
											title: 'Bank Code',
							                width : 50,
							                editable: false,
							                sortable: false,
							                align: 'left',
							                filterOption: true
										},     
										{
											id : 'bankAcctCd',
											title: 'Bank Acct Code',
							                width : 75,
							                editable: false,
							                sortable: false,
							                align: 'left',
							                filterOption: true
										},  
										{
											id : 'dspBankSname',
											title: 'Bank Name',
							                width : 75,
							                editable: false,
							                sortable: false,
							                align: 'left',
							                filterOption: true
										},  
										{
											id : 'bankAcctNo',
											title: 'Bank Acct No',
							                width : 100,
							                editable: false,
							                sortable: false,
							                align: 'left',
							                filterOption: true
										}
									]
								},
								{
									id: 'dspCurrency',
									title: 'Code',
									width: '75px',
									filterOption: true,
									sortable: true
								},
								{
								    id: 'fCurrencyAmt',
								    title: 'Amount',
								    width: '120px',
								    titleAlign: 'right',
								    align: 'right',
									filterOption: true,
									filterOptionType: 'number',
									sortable: true,
									geniisysClass: 'money'
								},
								{
								    id: 'currencyRt',
								    title: 'Currency Rt',
								    titleAlign: 'right',
								    align: 'right',
								    width: '120px',
									filterOption: true,
									filterOptionType: 'number',
									sortable: true,
									geniisysClass: 'rate'
								},
								{
									id: 'amount',
									title: 'Local Currency Amount',
									titleAlign: 'right',
									width: '130px',
									align: 'right',
									filterOption: true,
									filterOptionType: 'number',
									sortable: true,
									geniisysClass: 'money'
								}
					],
				rows : objCheck.objCheckList
		};
		checkListTableGrid = new MyTableGrid(checkTableModel);
		checkListTableGrid.pager = objCheck.objCheckListTableGrid;
		checkListTableGrid.render('checkInformationListing');
		checkListTableGrid.afterRender = function(){
			objCheckArray = checkListTableGrid.geniisysRows;
			//itemNoCtr = checkListTableGrid.geniisysRows.length + 1;
			isNewLoad = true;
			var isEmpty = true;
			//initTGFields();
			
			for(var i=0; i<checkListTableGrid.geniisysRows.length; i++){
				if(i==0){
					checkListTableGrid.selectRow(0);
					isEmpty = false;
					populateChkFields(checkListTableGrid.geniisysRows[i], true);
				}
			}
			if(isEmpty){
				//itemNoCtr = checkListTableGrid.geniisysRows.length + 1;
				populateChkFields(null, false);
			}			
		}; 
		
	} catch(e){
		showErrorMessage("checkTableGrid",e);
	}
	
	objGIACS002.itemSw = "Y"; //-- used in item no
	objGIACS002.checkDVPrint = paramCheckDVPrint;
	var itemInc = 1;
	var prevCheckInfoButtonsDiv = null; //$("checkInformationButtonsDiv").innerHTML;
	var prevdspTDCheckClassLabel2 = null; //$("dspTDCheckClassLabel2").innerHTML;
	var prevCheckClassValue1 = null;
	var prevCheckClassValue2 = null;
	var prevdspTDCheckPrintDate2 = null; //$("dspTDCheckPrintDate2").innerHMTL;
	var prevCheckPrintDateValue = null;
	var prevdspTDCheckBTStatus2 = null; //$("dspTDCheckBTStatus2").innerHTML;
	
	var isAmountAutoSet = false;  // to check if the amount in txtTGItem is automatically computed or input by user.
	
	/*if(objGIACS002.cancelDV == "Y"){
		setDocumentTitle("Cancel DV/Check");
		var reqDivArray = ["checkInformationSubDiv1", "checkInformationSubDiv2", "checkInformationSubDiv3"];
		disableChkFields(reqDivArray, true);
		//$("btnCancelDV").show();		
		$("btnCancelDV").show();		
		$("checkInformationButtonsDiv").innerHTML = prevCheckInfoButtonsDiv + "<input type='button' id='btnCancelDV' name='btnCancelDV' " +
				"class='button' value='Cancel DV' style='width:120px;' />";
	} else {
		setDocumentTitle("Check Details");
		//$("btnCancelDV").hide();
	}*/
	
	function initializeFields(){
		$("hidGaccTranId").value = disbVoucherInfo.gaccTranId;
		$("txtFundCd").value = disbVoucherInfo.gibrGfunFundCd;
		$("txtDspFundDesc").value = disbVoucherInfo.fundDesc;
		$("hidBranchCd").value = disbVoucherInfo.gibrBranchCd;
		$("hidBranchName").value = disbVoucherInfo.branchName;
		
		$("company").value = $F("txtFundCd") + " - " + $F("txtDspFundDesc");
		$("txtBranch").value = $F("hidBranchCd") + " - " + $F("hidBranchName");
		$("txtMIRPayee").value = unescapeHTML2(disbVoucherInfo.payee);
		$("txtMIRDVPref").value = disbVoucherInfo.dvPref;
		$("txtMIRDVNo").value = formatNumberDigits(disbVoucherInfo.dvNo, 10);		
		$("txtMIRForeignCurrency").value = disbVoucherInfo.foreignCurrency;
		$("txtMIRForeignAmount").value = disbVoucherInfo.dvFcurrencyAmt == null ? disbVoucherInfo.dvFcurrencyAmt : formatCurrency(disbVoucherInfo.dvFcurrencyAmt);
		
		objGIACS002.currentUserId = varUserId;
		$("txtPayeeClassCd").value = disbVoucherInfo.payeeClassCd;
		$("txtPayeeNo").value = formatNumberDigits(disbVoucherInfo.payeeNo,12);
		$("txtPayeeName").value = unescapeHTML2(disbVoucherInfo.payee);	
		$("txtUserID").value = varUserId;
		
		// when-new-block-instance trigger
		if(objGIACS002.dvTag == "M"){ 
			//var tranFlag = objACGlobal.tranFlagState; //commented out by KRis 05.27.2013
			tranFlag == "O" ? enableInputField("rdoCheckDisbursement") : disableInputField("rdoCheckDisbursement");  
			tranFlag == "O" ? enableInputField("rdoBankTransfer") : disableInputField("rdoBankTransfer");
			tranFlag == "O" ? enableInputField("txtCheckPrefSuf") : disableInputField("txtCheckPrefSuf");
			tranFlag == "O" ? enableInputField("txtCheckNo") : disableInputField("txtCheckNo");
			tranFlag == "O" ? enableInputField("txtCheckDate") : disableInputField("txtCheckDate");
			tranFlag == "O" ? enableDate("hrefCheckDate") : disableDate("hrefCheckDate");
			
			// when-new-form-instance trigger
			//disableButton("btnPrintCheckDV");
			//disableButton("btnSpoilCheck");			
			$("txtCheckPrefSuf").addClassName("required");
			//enableInputField("txtCheckPrefSuf");	
			$("txtCheckPrefSuf").value = paramCheckPref;
			
			$("txtCheckNo").addClassName("required");
			//enableInputField("txtCheckNo");			
			$("txtCheckDate").addClassName("required");
			$("dspDivCheckBTDate2").addClassName("required");
			//enableInputField("txtCheckDate");
			//enableDate("hrefCheckDate");
			// end of when-new-form-instance trigger
			
			$("rdoCheckDisbursement").disabled = true;
			$("rdoBankTransfer").disabled = true;
			disableButton("btnPrintCheckDV");	// shan 09.15.2014
			
		} else if(nvl(objGIACS002.dvTag,null) == null){
			// when-new-form-instance trigger
			if(objGIACS002.checkDVPrint == "4"){
				$("txtCheckPrefSuf").addClassName("required");
				enableInputField("txtCheckPrefSuf");
				$("txtCheckNo").addClassName("required");
				enableInputField("txtCheckNo");				
				$("txtCheckDate").addClassName("required");
				$("dspDivCheckBTDate2").addClassName("required");
				enableInputField("txtCheckDate");
				enableDate("hrefCheckDate");
				
				disableButton("btnSpoilCheck");
			} else {
				$("txtCheckPrefSuf").removeClassName("required");
				disableInputField("txtCheckPrefSuf");
				$("txtCheckNo").removeClassName("required");
				disableInputField("txtCheckNo");				
				$("txtCheckDate").removeClassName("required");
				$("dspDivCheckBTDate2").removeClassName("required");
				disableInputField("txtCheckDate");
				disableDate("hrefCheckDate");
				
				enableButton("btnSpoilCheck");
			}
			if(objGIACS002.cancelDV == "N"){
				objGIACS002.dvApproval = (validateUserFunc3($F("txtUserID"), "D2", "GIACS002") ? "TRUE" : "FALSE");
				enableButton("btnPrintCheckDV");
				enableButton("btnSpoilCheck");				
			}else if(objGIACS002.cancelDV == "Y"){
				disableButton("btnPrintCheckDV");
				disableButton("btnSpoilCheck");				
				//enableButton("btnCancelDV");
			}
			// end of when-new-form-instance trigger
			
			if(chkDisbInfo.dvFlag == "N"){
				enableInputField("rdoCheckDisbursement");
				enableInputField("rdoBankTransfer");
			} else {
				disableInputField("rdoCheckDisbursement");
				disableInputField("rdoBankTransfer");
			}
		} else if(objGIACS002.dvTag == "I"){ //'I' is a dummy value, it is used when GIACS002 is called by GIACS230
			disableButton("btnPrintCheckDV");
			disableButton("btnSpoilCheck");	
		}
		objGIACS002.gcdbCreateRec = "Y";
		
		if(objGIACS002.dvFlag != "P" || objGIACS002.dvFlag != "C"){
			enableInputField("txtPayeeName"); //jeffDojello Enhancement SR-1069 11.05.2013 ; removed comment for PHILFIRE : shan 05.22.2014
		} else {
			disableInputField("txtPayeeName");//jeffDojello Enhancement SR-1069 11.05.2013 ; removed comment for PHILFIRE : shan 05.22.2014
		}
		
		//jeffDojello Enhancement SR-1069 11.05.2013 ; removed comment for PHILFIRE : shan 05.22.2014
		if(paramUpdatePayeeName == "N"){ 
			disableInputField("txtPayeeName");
			disableInputField("txtPayeeNo");
			disableInputField("txtPayeeClassCd");
		}
		
		initializeCheckButton();

		if(checkListTableGrid.geniisysRows.length == 0){
			if(objGIACS002.cancelDV == "N"){
				if(objGIACS002.gcdbCreateRec == "Y"){
					if(objGIACS002.dvTag == "M"){
						$("txtCheckPrefSuf").value = paramCheckPref;
						$("txtCheckStat").value = "2";
						$("txtCheckStatMean").value = "Printed";
					} else if (nvl(objGIACS002.dvTag,null) == null){
						populateChkFields(null, false);
						if(objGIACS002.checkDVPrint == "4"){
							$("txtCheckPrefSuf").value = paramCheckPref;
							$("txtCheckStat").value = "2";
							$("txtCheckStatMean").value = "Printed";
						} else {
							$("txtCheckStat").value = "1";
							$("txtCheckStatMean").value = "Unprinted";
						}
					}
					
					if(objGIACS002.itemSw == "Y"){
						if(objGIACS002.allowMultiCheck == "N"){
							if(objCheckArray.length == 1 && itemInc == 1){
								showMessageBox("Multiple Checks are not allowed.", "I");
							} else {
								//:gcdb.item_no := variables.item_inc + 1;
								itemInc++;
							}
						} else {
							//:gcdb.item_no := variables.item_inc + 1;
							itemInc++;
						}
					}
				}
				/* $("txtPayeeClassCd").value = disbVoucherInfo.payeeClassCd;
				$("txtPayeeNo").value = formatNumberDigits(disbVoucherInfo.payeeNo,12);
				$("txtPayeeName").value = unescapeHTML2(disbVoucherInfo.payee);
				$("txtUserID").value = varUserId; */
			}
			//populateChkFields(null, false);
		}
		
		if(!isReset){
			initTGFields();
		}
		if(objACGlobal.fromDvStatInq == "Y" || objACGlobal.callingForm == "GIACS237"){ //added by Robert SR 5189 12.22.15
			disableGIACS002CheckDetails();
		}
	}
	
	function initializeCheckButton(){
		if(chkDisbInfo.disbMode == "B"){
			if(nvl(paramGenBankTransferNo, "M") == "M"){
				$("dspTDCheckButtonNo").innerHTML = "BT No.";
				$("dspTDCheckBTDate").innerHTML = "BT Date";
				$("dspTDCheckBTStatus").innerHTML = "BT Status";					
				$("dspTDCheckClassLabel").innerHTML = "";
				//$("dspTDCheckClassLabel2").innerHTML = "";
				$("dspTDCheckClassLabel3").hide();  // kris test 5.11.2013
				
				$("dspTDCheckPrintDate").innerHTML = "";
				//$("dspTDCheckPrintDate2").innerHTML = "";
				$("dspTDCheckPrintDate3").hide(); // kris test 5.11.2013				
				
				$("btnPrintCheckDV").value = "Print DV";
				disableButton("btnSpoilCheck");
				disableButton("btnCheckRelease");
				enableInputField("txtCheckPrefSuf");
				enableInputField("txtCheckNo");
				enableInputField("txtCheckDate");
				enableDate("hrefCheckDate");
				$("txtParticulars").readOnly = false;
			} else {
				$("dspTDCheckButtonNo").innerHTML = "BT No.";
				$("dspTDCheckBTDate").innerHTML = "BT Date";
				$("dspTDCheckBTStatus").innerHTML = "BT Status";
				$("dspTDCheckClassLabel").innerHTML = "";
				//$("dspTDCheckClassLabel2").innerHTML = "";
				$("dspTDCheckClassLabel3").hide();  // kris test 5.11.2013
				
				$("dspTDCheckPrintDate").innerHTML = "";
				//$("dspTDCheckPrintDate2").innerHTML = "";
				$("dspTDCheckPrintDate3").hide(); // kris test 5.11.2013
				
				$("btnPrintCheckDV").value = "Print DV";
				enableButton("btnSpoilCheck");
				disableButton("btnCheckRelease");
			}
			
			if($F("txtCheckStat") == "2"){
				return;
			} else {
				if(nvl(paramGenBankTransferNo, "M") == "M"){
					enableInputField("txtCheckPrefSuf");
					enableInputField("txtCheckNo");
					enableInputField("txtCheckDate");
					enableDate("hrefCheckDate");
				} else {					
					disableInputField("txtCheckPrefSuf");
					disableInputField("txtCheckNo");
					disableInputField("txtCheckDate");
					disableDate("hrefCheckDate");
				}
			}
		} else if(chkDisbInfo.disbMode == "C") { //if check disbursement
			$("dspTDCheckButtonNo").innerHTML = "Check No.";
			$("dspTDCheckBTDate").innerHTML = "Check Date";
			$("dspTDCheckBTStatus").innerHTML = "Check Status";
			//$("dspTDCheckBTStatus2").innerHTML = prevdspTDCheckBTStatus2;
			$("dspTDCheckClassLabel").innerHTML = "Check Class";
			//$("dspTDCheckClassLabel2").innerHTML = prevdspTDCheckClassLabel2;
			$("dspTDCheckClassLabel3").show();  // kris test 5.11.2013
			
			$("dspTDCheckPrintDate").innerHTML = "Check Print Date";
			//$("dspTDCheckPrintDate2").innerHTML = prevdspTDCheckPrintDate2; //prevdspTDCheckBTStatus2;
			$("dspTDCheckPrintDate3").show(); // kris test 5.11.2013
			
			$("btnPrintCheckDV").value = "Print Check/DV";
			enableButton("btnSpoilCheck");
			enableButton("btnCheckRelease");

			if(objGIACS002.dvTag == "M"){
				enableInputField("txtCheckPrefSuf");
				enableInputField("txtCheckNo");
				enableDate("hrefCheckDate");
				enableInputField("txtCheckDate");
				enableDate("hrefCheckDate");
				enableInputField("txtCheckPrintDate");
				enableDate("hrefCheckPrintDate");
			} else {
				disableInputField("txtCheckPrefSuf");
				disableInputField("txtCheckNo");
				disableInputField("txtCheckDate");
				disableInputField("txtCheckPrintDate");
				disableDate("hrefCheckDate");
				disableDate("hrefCheckPrintDate");
			}
		}
		if(objACGlobal.fromDvStatInq == "Y" || objACGlobal.callingForm == "GIACS237"){ //added by Robert SR 5189 12.22.15
			disableGIACS002CheckDetails();
		}
	}
	
	function getCheckPrefSuf(){
		if(paramCheckPref == null){
			showMessageBox("Check Prefix not in giac_parameters.", "E");
		} else {
			return paramCheckPref;
		}
	}
		
	function validateSpoilCheck(){
		if($F("txtCheckStat") != "2"){
			showMessageBox("Check spoiling not allowed.", "I");
		} else {
			if(objACGlobal.tranFlagState == "O" || objACGlobal.tranFlagState == "C"){
				validateIfReleasedCheck();
			} else if(objACGlobal.tranFlagState == "D"){
				showMessageBox("Spoiling not allowed. This is a deleted transaction.", "E");
			} else if(objACGlobal.tranFlagState == "P"){
				showMessageBox("Spoiling not allowed. This is a posted transaction.", "E");
			}
		}
	}
	
	function validateIfReleasedCheck(){
		try {
			new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=validateIfReleasedCheck", {
				parameters	: {
					gaccTranId	: $F("hidGaccTranId"),
					itemNo		: $F("txtTGItem"),
					checkPrefSuf: $F("txtCheckPrefSuf"),
					checkNo		: $F("txtCheckNo")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					showNotice("Validating check, please wait...");
				},
				onComplete	: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						if(response.responseText == "Y"){
							showMessageBox("Spoiling not allowed. This check has already been released.", "I");
						} else if(response.responseText == "N") {
							var message = "Do you want to spoil check no. " + $F("txtCheckPrefSuf") + "-" + $F("txtCheckNo") +"?";
							showConfirmBox("Spoil Check", message, "Yes", "No", spoilCheck, "", "");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateIfReleasedCheck", e);
		}
	}
	
	function spoilCheck(){
		try {
			new Ajax.Request(contextPath +"/GIACChkDisbursementController?action=spoilCheck", {
				parameters	: {
					gaccTranId	: $F("hidGaccTranId"),
					itemNo		: $F("txtTGItem"),
					bankCd		: $F("hidBankCd"),
					bankAcctCd	: $F("hidBankAcctCd"),
					checkDate	: $F("txtCheckDate"),
					checkPrefSuf: $F("txtCheckPrefSuf"),
					checkNo		: $F("txtCheckNo"),
					checkStat	: $F("txtCheckStat"),
					checkClass	: $F("txtCheckClass"),
					currencyCd	: objGIACS002.localCurrencyCd,
					currencyRt	: objGIACS002.currencyRt,
					fcurrencyAmt: unformatCurrency("txtTGAmount"),
					amount		: unformatCurrency("txtTGLocalCurrencyAmount"),
					printDate	: $F("txtLastUpdate"), //value is ilast_update // $F("hidLastUpdate"), //
					checkDVPrint: paramCheckDVPrint,
					tranFlag 	: tranFlag, //objACGlobal.tranFlagState, : changed by shan 10.22.2014
					dvFlag		: objGIACS002.dvFlag,
					lastUpdate	: $F("txtLastUpdate"),  //$F("hidLastUpdate") //type date
					fundCd		: objACGlobal.fundCd,
					branchCd	: objACGlobal.branchCd,
					moduleId	: "GIACS002",
					batchTag	: $F("hidBatchTag")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					showNotice("Spoiling check, please wait...");
				},
				onComplete	: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var params = JSON.parse(response.responseText);
						
						// update properties
				        $("txtCheckPrefSuf").value = "";
				        $("txtCheckNo").value = "";
				        $("txtCheckStat").value = "1";
				        $("txtCheckStatMean").value ="Unprinted";
				        $("txtCheckDate").value = "";
				        $("txtUserID").value = params.userId;
				        $("txtLastUpdate").value = params.lastUpdateStr;
				        $("hidLastUpdate").value = params.lastUpdate;
				        if($F("hidBatchTag") == "Y"){
				        	$("hidBatchTag").value = "";
				        }	
				        enableButton("btnPrintCheckDV");
				        disableButton("btnCheckRelease");	
				        
						if(paramCheckDVPrint == "1"){ 	//ensure that these global variables are assigned to local when returned to disbursement voucher
				        	objGIACS002.printDate = null; // if null > make str time and date = ""
				    		objGIACS002.dvFlag = "A";
				    		objGIACS002.dvFlagMean = "Approved for Printing";
				    		objGIACS002.printTag = params.printTag;
				    		objGIACS002.printTagMean = params.printTagMean;
				    		objGIACS002.userId = params.userId;
				    		objGIACS002.lastUpdate = params.lastUpdate;
				    		objGIACS002.lastUpdateStr = params.lastUpdateStr;				    		
				        }
						objGIACS002.spoiledCheck = true;
						tranFlag = params.tranFlag;	// shan 10.22.2014
						var reqDivArray = ["checkInformationListingFields", "checkInformationSubDiv3"];
						disableChkFields(reqDivArray, false);
						enableInputField("txtTGAmount");
					}
				}
			});
		} catch(e){
			showErrorMessage("spoilCheck", e);
		}
	}
	
	function disableChkFields(reqDivArray, flag){

		// if flag == true > disable		
		/*if (reqDivArray!= null){
			for ( var i = 0; i < reqDivArray.length; i++) {
				$$("div#"+reqDivArray[i]+" input[type='text']").each(function (a) {
					//if($(a).id == "txtTGAmount"){
						//$(a).disable = flag;
					//}
					//$(a).readonly = flag; 
					flag ? disableInputField(a) : enableInputField(a);
				});
			}				
		}*/
		/*$("txtTGItem").readOnly = flag;
		$("txtTGAmount").readOnly = flag;
		$("txtParticulars").readOnly = flag;
		$("txtCheckClass").readOnly = flag;
		//flag ? disableButton("btnAdd") : enableButton("btnAdd");
		flag ? disableSearch("osBankNo") : enableSearch("osBankNo");
		flag ? disableSearch("osCheckClass") : enableSearch("osCheckClass");
		
		if(objGIACS002.dvTag == "M"){ //for MANUAL DV
			enableInputField("txtCheckPrefSuf");
			enableInputField("txtCheckNo");
			enableInputField("txtCheckDate");
			enableDate("hrefCheckDate");*/

		// if flag == true > disable
		try{
			if (reqDivArray!= null){
				for ( var i = 0; i < reqDivArray.length; i++) {
					$$("div#"+reqDivArray[i]+" input[type='text']").each(function (a) {
						if($(a).id == "txtTGAmount"){
							$(a).disable = flag;
						}
						$(a).readonly = flag;
						//$(a).disable();
					});
					
					//jeffDojello Enhancement SR-1069 11.05.2013
					//$$("div#"+reqDivArray[i]+" img").each(function (c) {
					//	flag ? disableSearch(c) : enableSearch(c);
					//});
					
					//jeffDojello Enhancement SR-1069 11.05.2013
					if(flag){
						disableSearch("osBankNo");
						disableSearch("osCheckClass");						
						if(paramUpdatePayeeName == "Y"){
							disableSearch("lovPayeeClassCd");
							disableSearch("lovPayeeNo");
						}
					}else{
						enableSearch("osBankNo");
						enableSearch("osCheckClass");
						if(paramUpdatePayeeName == "Y"){
							enableSearch("lovPayeeClassCd");
							enableSearch("lovPayeeNo");
						}
					}
										
					$$("div#"+reqDivArray[i]+" input[type='button']").each(function (d) {
						if(d == "btnAdd"){
							flag ? disableButton(d) : enableButton(d);
						}
					});
				}
			}
			if(objACGlobal.fromDvStatInq == "Y" || objACGlobal.callingForm == "GIACS237"){ //added by Robert SR 5189 12.22.15
			    disableSearch("osBankNo");
			    disableSearch("osCheckClass");
			}
		}catch(e){
			showErrorMessage("disableModuleFields", e);
		}
	}
	
	function computeTotalAmountInTG(includeAll){
		var total = parseFloat(0);
		for(var i=0; i<objCheckArray.length; i++){
			var currTGAmount = unformatCurrency("txtTGAmount");
			
			if(objCheckArray[i].recordStatus != -1){
				if(objCheckArray[i].itemNo != $F("txtTGItem")){
					total = parseFloat(total) + parseFloat(objCheckArray[i].fCurrencyAmt);	//change by steven 09.18.2014; amount
				} else {
					if ($("txtTGAmount").readOnly || includeAll) total = parseFloat(total) + parseFloat(currTGAmount);	// added condition to allow Amount update for unprinted check: shan 10.22.2014
				}
			}
		}
		return total;
	}
	
	//checks for the total amount in tg then computes if how much should be the amount for the new check 
	function getNewCheckAmount(){
		var currTotal = computeTotalAmountInTG();
		var dvAmount = parseFloat(unformatCurrency("txtMIRForeignAmount"));
		var newAmount = parseFloat(0);
		if(currTotal < dvAmount){
			newAmount = dvAmount - parseFloat(currTotal);
		} /*else if (currTotal > dvAmount){
			showMessageBox("Total check amount should not be greater than DV amount.", "I");
		}*/
		return parseFloat(newAmount) == parseFloat(0) ? "" : newAmount;
	}
	
	function populateChkFields(row, flag){
		if(row == null && objCheckArray.length > 0){
			getNextItemNo();
		}
		
		$("txtTGItem").value = flag ? (row == null ? itemNoCtr : row.itemNo) : itemNoCtr;
		$("txtTGBank").value = flag ? (row == null ? "" : row.bankAcctNo) : "";    //row.bankCd +" - " + row.bankAcctCd + " - " + row.dspBankSname + " - " + row.bankAcctNo : "";
		$("txtTGCurrencyCd").value = flag ? (row == null ? "" : row.dspCurrency) : "";
		$("txtTGAmount").value = flag ? (row == null ? "" : formatCurrency(row.fCurrencyAmt)) : "";
		$("txtTGCurrencyRt").value = flag ? (row == null ? "" : formatToNineDecimal(row.currencyRt)) : "";
		$("txtTGLocalCurrencyAmount").value = flag ? (row == null ? "" : formatCurrency(row.amount)) : "";
		
		//jeffDojello Enhancement SR-1069 11.05.2013
		$("txtPayeeClassCd").value = row == null ? disbVoucherInfo.payeeClassCd : row.payeeClassCd;
		$("txtPayeeNo").value = row == null ? formatNumberDigits(disbVoucherInfo.payeeNo,12) : formatNumberDigits(row.payeeNo,12);
		$("txtPayeeName").value = row == null ? unescapeHTML2(disbVoucherInfo.payee) : unescapeHTML2(row.payee);
		
		$("hidBankCd").value = row == null ? "" : row.bankCd;
		$("hidBankAcctCd").value = row == null ? "" : row.bankAcctCd;
		$("hidBankSname").value = row == null ? "" : unescapeHTML2(row.dspBankSname);
		$("hidBankAcctNo").value = row == null ? "" : row.bankAcctNo;
		$("hidBatchTag").value = row == null ? "" : row.batchTag;

		////
			if(objGIACS002.dvTag == "M"){
				$("txtCheckPrefSuf").value = row == null ? paramCheckPref : (row.checkPrefSuf == null ? "" : unescapeHTML2(row.checkPrefSuf));  //paramCheckPref : unescapeHTML2(row.checkPrefSuf);
				$("txtCheckNo").value = row == null ? "" : (row.checkNo == null ? "" : (row.checkNo == "" ? "" : formatNumberDigits(row.checkNo,10)));
				$("txtCheckStat").value = row == null ? "2" : row.checkStat;
				$("txtCheckStatMean").value = row == null ? "Printed" : unescapeHTML2(row.checkStatMean);
				/*if($F("txtCheckPrefSuf") == ""){
					showMessageBox("Check Prefix not in giac_parameters.", "E");
				}*/
			} else {
				$("txtCheckPrefSuf").value = row == null ? "" : row.checkPrefSuf;
				$("txtCheckNo").value = row == null ? "" : (row.checkNo == null ? "" : (row.checkNo == "" ? "" : formatNumberDigits(row.checkNo,10)));
				$("txtCheckStat").value = row == null ? "1" : row.checkStat;
				$("txtCheckStatMean").value = row == null ? "Unprinted" : unescapeHTML2(row.checkStatMean);
			}
			$("txtCheckClass").value = row == null ? "" : (row.checkClass == null ? "" : row.checkClass);
			$("txtCheckClassMean").value = row == null ? "" : (row.checkClassMean == null ? "" : unescapeHTML2(row.checkClassMean));
			
			$F("txtCheckStatMean") == "Printed" ? (objGIACS002.cancelDV == "Y" ? disableButton("btnCheckRelease") : enableButton("btnCheckRelease")) : disableButton("btnCheckRelease");
			
			$("txtCheckDate").value = row == null ? "" : row.strCheckDate;
			$("txtParticulars").value = row == null ? "" : (row.nbtDVParticulars == null ? "" : unescapeHTML2(row.nbtDVParticulars));
			$("txtUserID").value = row == null ? varUserId : row.userId;
			var now = new Date().format("mm-dd-yyyy h:MM:ss TT");
			$("txtLastUpdate").value = row == null ? now : (row.strLastUpdate2 == null ? now : row.strLastUpdate2);
			$("hidLastUpdate").value = row == null ? now : (row.lastUpdate == null ? now : row.lastUpdate); 
			$("hidTotalAmt").value = row == null ? "" : (row.totalAmount == null ? "" : row.totalAmount);
		
			$("rdoCheckDisbursement").checked = row == null ? false : (row.disbMode == "C" ? true : false);
			$("rdoBankTransfer").checked = row == null ? false : (row.disbMode == "B" ? true : false);
			/*if($("rdoCheckDisbursement").checked == false && $("rdoBankTransfer").checked == false){
				$("rdoCheckDisbursement").checked = true;
			}*/
			
			if($("rdoCheckDisbursement").checked == true){
				//$("txtCheckPrintDate").value = row == null ? "" : (row.strCheckPrintDate == null ? "" : row.strCheckPrintDate);
				$("txtCheckClass").value = row == null ? "" : (row.checkClass == null ? "" : row.checkClass);
				$("txtCheckClassMean").value = row == null ? "" : (row.checkClassMean == null ? "" : unescapeHTML2(row.checkClassMean));
				$("dspTDCheckButtonNo").innerHTML = "Check No.";
				$("dspTDCheckBTDate").innerHTML = "Check Date";
				$("dspTDCheckBTStatus").innerHTML = "Check Status";
				$("dspTDCheckClassLabel").innerHTML = "Check Class";
				$("dspTDCheckClassLabel3").show();
				$("dspTDCheckPrintDate").innerHTML = "Check Print Date";
				$("dspTDCheckPrintDate3").show(); 
			}
			$("txtCheckPrintDate").value = row == null ? "" : (row.strCheckPrintDate == null ? "" : row.strCheckPrintDate);
			
			if($("rdoBankTransfer").checked == true){
				$("dspTDCheckButtonNo").innerHTML = "BT No.";
				$("dspTDCheckBTDate").innerHTML = "BT Date";
				$("dspTDCheckBTStatus").innerHTML = "BT Status";					
				$("dspTDCheckClassLabel").innerHTML = "";
				$("dspTDCheckClassLabel3").hide();  				
				$("dspTDCheckPrintDate").innerHTML = "";
				$("dspTDCheckPrintDate3").hide();
			}
			
			if(row != null){
				if(row.gaccTranId != null && row.itemNo != null){
					$("rdoCheckDisbursement").disabled = true;
					$("rdoBankTransfer").disabled = true;
				}
			} else {
				$("rdoCheckDisbursement").disabled = false;
				$("rdoBankTransfer").disabled = false;
			}

		//var disableArray = ["txtTGItem", "txtTGBank", "txtTGCurrencyCd", "txtTGAmount", "txtTGCurrencyRt", "txtTGLocalCurrencyAmount"];		
		if(flag){
			disableInputField("txtTGAmount");
			disableInputField("txtTGItem");		// shan 05.21.2014
			/*for ( var i = 0; i < disableArray.length; i++) {
				if(row.recordStatus != 0 ){
					disableInputField(disableArray[i]);
				} else if(row == null){
					
				}
			}	*/				
		} else{ 	// shan 05.21.2014
			enableInputField("txtTGItem");
		}
		
		if(objACGlobal.queryOnly != "Y" || objGIACS002.dvTag == "M") {
			if(row != null && row.itemNo != ""){
				if(row.recordStatus == "0" || row.recordStatus == "1"){
					$("btnAdd").value = "Update";	
					enableInputField("txtTGAmount");
					enableSearch("osCheckClass");
					
					//jeffDojello Enhancement SR-1069 11.05.2013
					if(paramUpdatePayeeName == "Y"){
						enableSearch("lovPayeeClassCd");
						enableSearch("lovPayeeNo");
					}
				} else if (row.recordStatus == ""){
					//disable update to divs
					var reqDivArray = ["checkInformationListingFields", "checkInformationSubDiv3"];
					//var flag = checkListSelectedIndex == -1 ? false : true;	// replaced by code below : shan 10.22.2014
					var flag = checkListSelectedIndex == -1 ? false : (checkListTableGrid.geniisysRows[checkListSelectedIndex].checkStat == "1" ? false : true);
					disableChkFields(reqDivArray, flag);	
					//disableInputField("txtTGAmount");	// replaced by code below : shan 10.22.2014
					flag ? disableInputField("txtTGAmount") : enableInputField("txtTGAmount");
					//disableButton("btnAdd"); //added by Halley 11.26.13 // commented out, button will be used to update Payee Name of the selected record : shan 05.21.2014
					$("btnAdd").value = "Update"; // shan 05.21.2014
				}
				
			} else if(row == null) {
				$("btnAdd").value = "Add";
				if(checkListSelectedIndex == -1){
					enableInputField("txtTGAmount");
					enableSearch("osCheckClass");
					enableSearch("osBankNo");
					enableButton("btnAdd"); //added by Halley 11.26.13
					
					//jeffDojello Enhancement SR-1069 11.05.2013
					if(paramUpdatePayeeName == "Y"){
						enableSearch("lovPayeeClassCd");
						enableSearch("lovPayeeNo");
					}
					
					$("rdoCheckDisbursement").checked = true;
					chkDisbInfo.disbMode = "C";
					initializeCheckButton();
				}
				var reqDivArray = ["checkInformationListingFields", "checkInformationSubDiv3"];
				var flag = checkListSelectedIndex == -1 ? false : true;
				disableChkFields(reqDivArray, flag);
			} else if(row.itemNo != ""){
				if(row.recordStatus == "0" || row.recordStatus == "1"){
					enableInputField("txtTGAmount");
					enableSearch("osCheckClass");
				} else if (row.recordStatus == ""){
					//disable update to divs
					
					var reqDivArray = ["checkInformationListingFields", "checkInformationSubDiv3"];
					var flag = checkListSelectedIndex == -1 ? false : true;
					disableChkFields(reqDivArray, flag);	
					disableInputField("txtTGAmount");
				}
				$("btnAdd").value = "Update";				
			}
			
			if (objGIACS002.dvFlag != "P" && objGIACS002.dvFlag != "C"){	//shan 05.21.2014
				if(paramUpdatePayeeName == "N"){
					$("txtPayeeName").readOnly = true;
				}else{
					$("txtPayeeName").readOnly = false;
				}				
			}else{
				$("txtPayeeName").readOnly = true;
			}
		}
		 //added by steven 09.10.2014
		 if (row == null) {
			 if(objGIACS002.cancelDV == "N"){
				if(objGIACS002.gcdbCreateRec == "Y"){
					if(objGIACS002.dvTag == "M"){
						$("txtCheckPrefSuf").value = paramCheckPref;
						$("txtCheckStat").value = "2";
						$("txtCheckStatMean").value = "Printed";
						enableInputField("txtCheckNo");
						enableDate("hrefCheckDate");
						enableInputField("txtCheckDate");
						enableDate("hrefCheckDate");
						$("txtCheckPrefSuf").addClassName("required");
						$("txtCheckNo").addClassName("required");
						$("txtCheckDate").addClassName("required");
						$("dspDivCheckBTDate2").addClassName("required");
					} else if (nvl(objGIACS002.dvTag,null) == null){
						if(objGIACS002.checkDVPrint == "4"){
							$("txtCheckPrefSuf").value = paramCheckPref;
							$("txtCheckStat").value = "2";
							$("txtCheckStatMean").value = "Printed";
							enableInputField("txtCheckNo");
							enableDate("hrefCheckDate");
							enableInputField("txtCheckDate");
							enableDate("hrefCheckDate");
							$("txtCheckPrefSuf").addClassName("required");
							$("txtCheckNo").addClassName("required");
							$("txtCheckDate").addClassName("required");
							$("dspDivCheckBTDate2").addClassName("required");
						} else {
							$("txtCheckStat").value = "1";
							$("txtCheckStatMean").value = "Unprinted";
							disableInputField("txtCheckNo");
							disableInputField("hrefCheckDate");
							disableInputField("txtCheckDate");
							disableInputField("hrefCheckDate");
							$("txtCheckPrefSuf").removeClassName("required");
							$("txtCheckNo").removeClassName("required");
							$("txtCheckDate").removeClassName("required");
							$("dspDivCheckBTDate2").removeClassName("required");
						}
					}
				}
			}else{
				disableGIACS002CheckDetails();
			}
		}else{
			if($F("txtCheckStat") == "1"){
				$("txtCheckPrefSuf").removeClassName("required");
				$("txtCheckNo").removeClassName("required");
				$("txtCheckDate").removeClassName("required");
				$("dspDivCheckBTDate2").removeClassName("required");
			}
		}
	}
	
	function getCurrentItemNoList(){
		var isExisting = false;
		if(objGIACS002.itemNoList == null || objGIACS002.itemNoList == 0){
			objGIACS002.itemNoList = [];
			getDBItemNoList();
		} else {
			for(var z=0; z<objCheckArray.length; z++){
				isExisting = false;
				for(var y=0; y<objGIACS002.itemNoList.length; y++){
					if(objGIACS002.itemNoList[y] == objCheckArray[z].itemNo){
						isExisting = true;						
						break;
					}					
				}
				if(!isExisting){
					objGIACS002.itemNoList.push(objCheckArray[z].itemNo);
				}
			}
		}
		//showMessageBox("currList: "+objGIACS002.itemNoList, "I");
	}
	
	function getDBItemNoList(){
		try{
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				method: "POST",
				parameters: {
					action 		: "getDBItemNoList",
					gaccTranId	: objACGlobal.gaccTranId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if (response.responseText != "" && response.responseText != "[]") {
						var tempArr = eval(response.responseText);
						for(var i=0; i<tempArr.length; i++){
							objGIACS002.itemNoList.push(tempArr[i]);
						}
					}
				}
			});		
		}catch(e){
			showErrorMessage("getDBItemNoList", e);
		}
	}
	
	function initTGFields(){
		if(isNewLoad){
			if(checkListTableGrid.geniisysRows.length > 0){
				$("txtCheckPrefSuf").value = chkDisbInfo.checkPrefSuf == null ? "" : unescapeHTML2(chkDisbInfo.checkPrefSuf);
				$("txtCheckNo").value = chkDisbInfo.checkNo == null ? "" : formatNumberDigits(chkDisbInfo.checkNo,10);
				
				$("txtCheckStat").value = chkDisbInfo.checkStat == null ? "" : chkDisbInfo.checkStat;
				$("txtCheckStatMean").value = chkDisbInfo.checkStatMean == null ? "" : unescapeHTML2(chkDisbInfo.checkStatMean);
				$("txtCheckDate").value = chkDisbInfo.strCheckDate == null ? "" : chkDisbInfo.strCheckDate;
				
				$("txtParticulars").value = chkDisbInfo.particulars == null ? "" : unescapeHTML2(chkDisbInfo.particulars);
				$("txtUserID").value = chkDisbInfo.userId == null ? "" : chkDisbInfo.userId;
				var now = new Date().format("mm-dd-yyyy h:MM:ss TT");
				$("txtLastUpdate").value = chkDisbInfo.strLastUpdate2 == null ? now : chkDisbInfo.strLastUpdate2;
				$("hidLastUpdate").value = chkDisbInfo.lastUpdate == null ? now : chkDisbInfo.lastUpdate; 
				$("hidTotalAmt").value = chkDisbInfo.totalAmount == null ? "" : chkDisbInfo.totalAmount;
				$("rdoCheckDisbursement").checked = chkDisbInfo.disbMode == "C" ? true : false;
				$("rdoBankTransfer").checked = chkDisbInfo.disbMode == "B" ? true : false;
				
				if($("rdoCheckDisbursement").checked == false && $("rdoBankTransfer").checked == false){
					$("rdoCheckDisbursement").checked = true;
				}
				
				if($("rdoCheckDisbursement").checked == true){
					$("txtCheckClass").value = chkDisbInfo.checkClass == null ? "" : chkDisbInfo.checkClass;
					$("txtCheckClassMean").value = chkDisbInfo.checkClassMean == null ? "" : unescapeHTML2(chkDisbInfo.checkClassMean);
					$("txtCheckPrintDate").value = chkDisbInfo.strCheckPrintDate == null ? "" : chkDisbInfo.strCheckPrintDate;
					//disableSearch("osCheckClass");
					//disableSearch("osBankNo");
				}
				
				//$('mtgRow'+mtgId+'_'+0).addClassName("selectedRow");
				
				var row = new Object();
				row = checkListTableGrid.geniisysRows[0];
				checkListSelectedIndex = 0;
				checkListSelectedRow = row;

				populateChkFields(row, true);
			} /* else {
				//itemNoCtr++; // = objCheckArray.length + 1;
				$("txtTGItem").value = itemNoCtr;	
				populateChkFields(null, false);
			} */
		}/* else {
			itemNoCtr = objCheckArray.length + 1;
			$("txtTGItem").value = itemNoCtr;	
		}*/
	}
	
	function createObjCheck(currentFunction){
		var newCheck = new Object();
		newCheck.gaccTranId = objACGlobal.gaccTranId; //objGIACS002.gaccTranId;
		newCheck.itemNo = $F("txtTGItem");
		newCheck.bankAcctNo = $F("hidBankAcctNo");
		newCheck.bankCd = $F("hidBankCd");
		newCheck.dspBankSname = escapeHTML2($F("hidBankSname"));
		newCheck.dspCurrency = $F("txtTGCurrencyCd");
		newCheck.bankAcctCd = $F("hidBankAcctCd");
		newCheck.currencyCd = objGIACS002.localCurrencyCd;
		newCheck.fCurrencyAmt = unformatCurrency("txtTGAmount");
		newCheck.currencyRt = $F("txtTGCurrencyRt");
		newCheck.amount = unformatCurrency("txtTGLocalCurrencyAmount");
		
		newCheck.payee = escapeHTML2($F("txtPayeeName"));
		newCheck.payeeClassCd = escapeHTML2($F("txtPayeeClassCd"));
		newCheck.payeeNo = escapeHTML2($F("txtPayeeNo"));
		newCheck.checkPrefSuf = escapeHTML2($F("txtCheckPrefSuf"));
		newCheck.checkNo = $F("txtCheckNo") == "" ? "" : $F("txtCheckNo"); //parseInt($F("txtCheckNo")); 
		
		newCheck.checkStat = escapeHTML2($F("txtCheckStat"));
		newCheck.checkStatMean = escapeHTML2($F("txtCheckStatMean"));
		newCheck.strCheckDate = $F("txtCheckDate");
		newCheck.nbtDVParticulars = escapeHTML2($F("txtParticulars"));
		newCheck.userId = escapeHTML2($F("txtUserID"));
		newCheck.strLastUpdate2 = $F("txtLastUpdate");
		
		if($("rdoCheckDisbursement").checked == true){
			newCheck.disbMode = "C";
			newCheck.checkPrintDate = $F("txtCheckPrintDate");
			newCheck.checkClass = escapeHTML2($F("txtCheckClass"));
			newCheck.checkClassMean = escapeHTML2($F("txtCheckClassMean"));	
		} else if($("rdoBankTransfer").checked == true){
			newCheck.disbMode = "B";
		}
		
		newCheck.recordStatus = currentFunction == "Delete" ? -1 : currentFunction == "Add" ? 0 : 1;
		
		changeTag = 1;
		
		return newCheck;
	}
	
	// validations of details before saving/adding
	function validateCheckDetails(currentFunction){
		var isValid = true;
		
		if(currentFunction == "Add"){
			if($("rdoCheckDisbursement").checked == false && $("rdoBankTransfer").checked == false){
				isValid = false;
				showMessageBox("Please choose a disbursement mode between Check Disbursement and Bank Transfer.", "I");
			}
			
			var dvAmount = parseFloat(unformatCurrency("txtMIRForeignAmount"));
			var newTotalAmt = parseFloat(computeTotalAmountInTG(true)) + parseFloat(unformatCurrency("txtTGAmount")); //parseFloat(unformatCurrency("txtTGLocalCurrencyAmount"));
			
			if(newTotalAmt.toFixed(2) > dvAmount){
				showMessageBox("Total check amount should not be greater than DV amount.", "I");
				$("txtTGAmount").value = "";
				$("txtTGLocalCurrencyAmount").value = "";
				isValid = false;
			}
			
			//jeffDojello Enhancement SR-1069 11.05.2013
			if($("txtPayeeName").value == null || $("txtPayeeName").value == "" || $("txtPayeeNo").value == null || $("txtPayeeNo").value == "" || $("txtPayeeClassCd").value == null || $("txtPayeeClassCd").value == ""  ){
				showMessageBox("Please fill out Payee information.", "I");
				isValid = false;
			}
		}else if(currentFunction == "Delete"){
			//var dvAmount = parseFloat(unformatCurrency("txtMIRForeignAmount"));
			var newTotalAmt = parseFloat(computeTotalAmountInTG(true)) - parseFloat(unformatCurrency("txtTGLocalCurrencyAmount"));
			
			if(newTotalAmt < 0){
				showMessageBox("Total check amount must not be less than zero.", "I");
			}
		}
		
		return isValid;
	}
	
	function convertToLocalAmount(){
		var bool = true;
		
		if($F("txtTGAmount") != "" && $F("txtTGCurrencyRt") != ""){
			var localAmount = parseFloat(unformatCurrency("txtTGAmount")) * parseFloat($F("txtTGCurrencyRt"));
			$("txtTGLocalCurrencyAmount").value = formatCurrency(roundNumber(localAmount,2)); //benjo 03.09.2017 SR-21441
			$("txtTGAmount").value = formatCurrency($F("txtTGAmount"));
			//$("txtLocalAmount").value = formatCurrency(roundNumber((unformatCurrency("txtCurrencyRt") * unformatCurrency("txtForeignAmount")),2));			
		} else {
			$("txtTGAmount").focus();
			bool = false;
		}
		
		return bool;
	}
	
	function updateCheckTable(){
		try {
			for(var i = 0; i < objCheckArray.length; i++){
				if(objCheckArray[i].recordStatus = -1){
					objCheckArray[i].recordStatus == null;
					delete objCheckArray[i];
				} else {
					objCheckArray[i].recordStatus == null;
				}
			}	
		} catch(e) {
			showErrorMessage("updateCheckTable", e);		
		}
	}
	
	
	function showGIACS002BanksLOV(){
		LOV.show({
			controller : "AccountingLOVController", 
			urlParameters : {
				action : "getGIACS002BanksLOV",
				moduleId: "GIACS002",
				branchCd: $F("hidBranchCd"),
				mirBranchCd: $F("hidBranchCd"),
				page : 1
			},
			title : "Valid Values for Bank/Bank Account",
			width : 500,
			height : 400,
			columnModel : [ 
			{
				id : "bankCd",
				title : "Bank Code",
				width : '70px'
			},
			{
				id : "bankAcctCd",
				title : "Bank Acct Code",
				width : '100px'
			},
			{
				id : "bankName",
				title : "Bank Name",				
				width : '100px'
			},
			{
				id : "bankAcctNo",
				title : "Bank Acct No.",
				width : '200px'
			}],
			draggable : true,
			filterText : "%",
			onSelect : function(row) {
				$("txtTGBank").value = unescapeHTML2(row.bankAcctNo);	
				$("txtTGCurrencyCd").value = objGIACS002.foreignCurrency; //changed by steven 09.18.2014 objGIACS002.localCurrency;
				$("txtTGCurrencyRt").value = objGIACS002.currencyRt;
				$("hidBankCd").value = row.bankCd;
				$("hidBankAcctCd").value = row.bankAcctCd;
				$("hidBankSname").value = row.bankName;
				$("hidBankAcctNo").value = row.bankAcctNo;
				$("txtCheckNo").clear(); //addded by steven 09.11.2014
				fireEvent($("txtTGBank"), "change");
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, $("txtTGBank"));
			},
			onCancel: function(){
				$("txtTGBank").focus();
			}
		});
	}
	
	function showGIACS002CheckClassLOV(){
		try {
			LOV.show({
				controller : "AccountingLOVController", 
				urlParameters : {
					action : "getCheckClass3",
					page : 1,
					filterText : ($("txtCheckClass").readAttribute("lastValidValue").trim() != $F("txtCheckClass").trim() ? $F("txtCheckClass").trim() : "%"),
				},
				title : "Valid Values for Check Class",
				width : 350,
				height : 400,
				columnModel : [ 
				{
					id : "rvLowValue",
					title : "Check Class",
					align: 'right',
					width : '100px'
				},
				{
					id : "rvMeaning",
					title : "Check Class Meaning",
					align: 'right',
					width : '200px'
				}],
				draggable : true,
				autoSelectOneRecord : true,	
				//filterText : unescapeHTML2($F("txtCheckClass")),
				filterText : ($("txtCheckClass").readAttribute("lastValidValue").trim() != $F("txtCheckClass").trim() ? $F("txtCheckClass").trim() : "%"),
				onSelect : function(row) {
					$("txtCheckClass").value = unescapeHTML2(row.rvLowValue);	
					$("txtCheckClassMean").value = unescapeHTML2(row.rvMeaning);
					$("txtCheckClass").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));	
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtCheckClass").value = $("txtCheckClass").readAttribute("lastValidValue");
				},
				onCancel: function(){
					$("txtCheckClass").value = $("txtCheckClass").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch(e){
			showErrorMessage("showGIACS002CheckClassLOV", e);
		}
	}

	function showGIACS002CheckStatLOV(){
		try {
			LOV.show({
				controller : "AccountingLOVController", 
				urlParameters : {
					action : "getCheckStat",
					page : 1
				},
				title : "Valid Values for Check Status",
				width : 350,
				height : 400,
				columnModel : [ 
				{
					id : "rvLowValue",
					title : "Check Status",
					align: 'right',
					width : '150px'
				},
				{
					id : "rvMeaning",
					title : "Check Status Meaning",
					align: 'right',
					width : '200px'
				}],
				draggable : true,
				filterText : "%",
				onSelect : function(row) {
					$("txtCheckStat").value = unescapeHTML2(row.rvLowValue);	
					$("txtCheckStatMean").value = unescapeHTML2(row.rvMeaning);					
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, $("txtTGBank"));
				},
				onCancel: function(){
					$("txtCheckStat").focus();
				}
			});
		} catch(e){
			showErrorMessage("showGIACS002CheckStatLOV", e);
		}
	}
	
	function validateBankCd(){
		try {
			new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=validateBankCd", {
				parameters	: {
					checkNo		: $F("txtCheckNo"),
					checkPrefSuf: $F("txtCheckPrefSuf"),
					bankCd		: $F("hidBankCd"),
					bankAcctCd	: $F("hidBankAcctCd")
				},
				evalScripts: true,
				asynchronous: false,
				/*onCreate: function (){
					showNotice("Validating bank code, please wait...");
				},*/
				onComplete	: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						if(response.responseText == "SUCCESS"){
							//moved 05.24.2013
							isAmountAutoSet = true;
							$("txtTGAmount").value = getNewCheckAmount();
							fireEvent($("txtTGAmount"), "change");	
						} 
					}
				}
			});
		} catch(e){
			showErrorMessage("validateBankCd", e);
		}
	}
	
	function validateCheckNo(){
		try {
			new Ajax.Request(contextPath +"/GIACChkDisbursementController?action=validateCheckNo", {
				parameters	: {
					checkNo		: $F("txtCheckNo"),
					checkPrefSuf: $F("txtCheckPrefSuf"),
					bankCd		: $F("hidBankCd"),
					bankAcctCd	: $F("hidBankAcctCd")
				},
				evalScripts: true,
				asynchronous: false,
				/*onCreate: function (){
					showNotice("Validating bank code, please wait...");
				},*/
				onComplete	: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						if(response.responseText == "SUCCESS"){
							$("txtCheckNo").value =  formatNumberDigits( $F("txtCheckNo"),10);
						} 
					} else {
						$("txtCheckNo").value = "";
						$("txtCheckNo").focus();
					}
				}
			});
		} catch(e){
			showErrorMessage("validateCheckNo", e);
		}
	}
	
	function validateAcctEntriesBeforePrint(){
		try {
			new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=validateAcctEntriesBeforePrint", {
				parameters	: {
					gaccTranId	:$F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					showNotice("Validating accounting entries, please wait...");
				},
				onComplete	: function(response){
					hideNotice("");
					//showMesageBox(response.responseText, "");
					//response.responseText = "Geniisys Exception#imgMessage.INFO#Accounting entries are not balanced.";
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						if(response.responseText == "SUCCESS"){
							printDV();
						} 
					}
				}
			});
		} catch(e){
			showErrorMessage("validateAcctEntriesBeforePrint", e);
		}
	}
	
	function printDV(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
		
		// STEP 1: ASSIGN GLOBAL VARIABLES.
		// Note: other global variables were assigned already before proceeding to this page..
		getCheckCount();  
		
		
		
		
		
		/* STEP 2:
		** TO DO: 
		** call GIACS052 - should assign a  value for objACGlobal.cancelPrint
		** 				 - Y if cancelled; N otherwise.
		** then proceed to the lines of code below:
		*/
		// andrew 
		objGIACS052 = {};
		objGIACS052.gaccTranId = disbVoucherInfo.gaccTranId;
		objGIACS052.gibrGfunFundCd = disbVoucherInfo.gibrGfunFundCd;
		objGIACS052.fundDesc = disbVoucherInfo.fundDesc;
		objGIACS052.gibrBranchCd = disbVoucherInfo.gibrBranchCd;
		objGIACS052.branchName = disbVoucherInfo.branchName;
		objGIACS052.payee = unescapeHTML2(disbVoucherInfo.payee);
		objGIACS052.dvPref = disbVoucherInfo.dvPref;
		objGIACS052.dvNo = formatNumberDigits(disbVoucherInfo.dvNo, 10);
		objGIACS052.dvFlag = objGIACS002.dvFlag;
		objGIACS052.dvFlagMean = objGIACS002.dvFlagMean;
		objGIACS052.checkDVPrint = objGIACS002.checkDVPrint;
		objGIACS052.dvDate = objGIACS002.dvDate;
		objGIACS052.checkCnt = objACGlobal.checkCount;
		objGIACS052.disbVoucherInfo = disbVoucherInfo;
		
		showPrintCheckDVPage('.',objACGlobal.gaccTranId); // on accounting.js
		
		
		
		/* STEP 3:
		** after calling GIACS052, execute the following codes
		** uncomment the lines.
		*/
		/*if(objACGlobal.cancelPrint == "N"){
			// A.R.C. 06.29.2005
			// to delete workflow records of CSR to Accounting //
			deleteWorkflowRecords();
		} */
		
		// STEP 4: Reset global variables 
		/*objACGlobal.checkCount = null;
		objACGlobal.cancelPrint = null;*/
	}
	
	function deleteWorkflowRecords(){
		try {
			new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=deleteWorkflowRecords", {
				parameters	: {
					gaccTranId	:$F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					showNotice("Deleting workflow records, please wait...");
				},
				onComplete	: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){						
					}
				}
			});
		} catch(e){
			showErrorMessage("deleteWorkflowRecords", e);
		}
	}
	
	function getCheckCount(){
		try {
			new Ajax.Request(contextPath +"/GIACChkDisbursementController?action=getCheckCount", {
				parameters	: {
					gaccTranId	:$F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					showNotice("Getting check count, please wait...");
				},
				onComplete	: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						objACGlobal.checkCount = response.responseText;
					}
				}
			});
		} catch(e){
			showErrorMessage("getCheckCount", e);
		}		
	}
	
	function validateOnDelete(){
		if(validateCheckDetails("Delete")){
			try{
				var objCheckToDelete = createObjCheck("Delete");
				objCheckArray.splice(checkListSelectedIndex, 1, objCheckToDelete);
				checkListTableGrid.deleteVisibleRowOnly(checkListSelectedIndex);
				checkListTableGrid.onRemoveRowFocus();
				changeTag = 1;
				initializeFields(); // test/ ********
				
				//added by Halley 12.03.13
				getCurrentItemNoList();
				itemNoCtr++;
				getNextItemNo();
				populateChkFields(null, false);	
			}catch(e){
				showErrorMessage("validateOnDelete: " +e, imgMessage.ERROR);
			}	
		}
	}
	
	function getChkReleaseInfo(){ //getChkReleaseInfo
		try {
			new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=getChkReleaseInfo", {
				parameters	: {
					gaccTranId	:$F("hidGaccTranId"),
					itemNo : $F("txtTGItem")
				},
				evalScripts: true,
				asynchronous: false,
				/*onCreate: function (){
					showNotice("Getting check count, please wait...");
				},*/
				onComplete	: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var chk = new Object();
						chk = JSON.parse(response.responseText);
						objGIACS002.chkReleaseInfo = chk;						
					}
				}
			});
		} catch(e){
			showErrorMessage("getChkReleaseInfo", e);
		}		
	}
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	function proceedSaveChkDetails(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			// added condition so that message will only be displayed if record is not yet added in the tablegrid : shan 05.22.2014
			if(($F("txtTGBank") != "" || $F("txtTGAmount") != "") && $F("btnAdd") == "Add"){ 
				showMessageBox("You have changes in Check Details portion. Press Add button first to apply changes.", "I");	
			} else {
				saveChkDetails();
			}
			
			/* if(checkAllRequiredFieldsInDiv("disbursementVoucherInfoDiv") && checkAllRequiredFieldsInDiv("checkInformationSubDiv3")){
				saveChkDetails();
			} */
		}
		
	}
	
	function saveChkDetails(){
		try {
			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objCheckArray);
			objParams.delRows = getDeletedJSONObjects(objCheckArray);
			
			new Ajax.Request(contextPath+"/GIACChkDisbursementController?action=saveCheckDetails", {
				method: "POST",
				parameters: {
					parameters: JSON.stringify(objParams),
					dvTag	  : objGIACS002.dvTag,
					fundCd	  : $F("txtFundCd"),
					branchCd  : $F("hidBranchCd"),
					gaccTranId: $F("hidGaccTranId"),
					moduleId  : "GIACS002",
					checkDVPrint : paramCheckDVPrint, //added by steven 09.17.2014
					gidvPrintTag : gidvPrintTag //added by robert 01.26.15
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving check details, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							changeTag = 0;
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								if(objGIACS002.exitPage != null){
									objGIACS002.exitPage();
								}else{
									updateCheckTable();
									showCheckDetailsPage(disbVoucherInfo, $F("hidGaccTranId"));	
								}
							});
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					} 
				}
			});	
		} catch (e){
			showErrorMessage("saveCheck", e);
		}
	}
	
	function checkIfDuplicateItemNo(){
		var isExisting = false;
		
		for(var x=0; x<objCheckArray.length; x++){
			//isExisting = false;
			if(objGIACS002.itemNoList.length > 0){
				for(var y=0; y<objGIACS002.itemNoList.length; y++){
					if(objCheckArray[x].itemNo == objGIACS002.itemNoList[y] && objCheckArray[x].itemNo == $F("txtTGItem") && objCheckArray[x].recordStatus != -1){
						isExisting = true;			
						break;
					}
				}
			} else {
				if(objCheckArray[x].itemNo == $F("txtTGItem") && objCheckArray[x].recordStatus != -1){
					isExisting = true;			
					break;
				}
			}
			/* if(isExisting){
				showMessageBox("Item No. must be unique.", "I");					
			} */
		}
		
		if(!isExisting){
			for(var i=0; i<objGIACS002.itemNoList.length; i++){
				if(objGIACS002.itemNoList[i] == $F("txtTGItem")){
					isExisting = true;			
					break;
				}
			}
		}
		
		return isExisting;
	}


	function disableGIACS002CheckDetails(){
		try {
			$$("div#checkInformationListingFields div[name='reqDiv'], div#checkInformationListingFields input[type='text'].required, div#checkInformationListingFields div.required, div#checkInformationListingFields input[type='text']").each(function(txt){
				txt.removeClassName("required");
			});

			$$("div#checkInformationListingFields input[type='text']").each(function(txt){
				txt.writeAttribute("readonly", "readonly");
			});
			
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableButton("btnSpoilCheck");
			disableButton("btnPrintCheckDV");
			disableButton("btnCheckRelease");
			disableButton("btnSave");
			disableSearch("osCheckClass");
			disableSearch("osBankNo");
			
			//jeffDojello Enhancement SR-1069 11.05.2013
			if(paramUpdatePayeeName == "Y"){
				disableSearch("lovPayeeClassCd");
				disableSearch("lovPayeeNo");
			}
			$("txtParticulars").writeAttribute("readonly", "readonly");
		} catch(e){
			showErrorMessage("disableGIACS002CheckDetails", e);
		}
	}
	
	$("txtCheckPrefSuf").observe("keyup", function(){ //added by robert 01.26.15
		$("txtCheckPrefSuf").value = $F("txtCheckPrefSuf").toUpperCase();
	});
	
	function initializeBTDtls(pop){ //added by robert 01.26.15
		if(pop && paramGenBankTransferNo == "M") {
			$("txtCheckPrefSuf").addClassName("required");
			$("txtCheckNo").addClassName("required");
			$("dspDivCheckBTDate2").addClassName("required");
			$("txtCheckDate").addClassName("required");
			$("txtCheckStat").value = "2";
			$("txtCheckStatMean").value = "Printed";
			gidvPrintTag = "3";
		} else {
			$("txtCheckPrefSuf").removeClassName("required");
			$("txtCheckNo").removeClassName("required");
			$("dspDivCheckBTDate2").removeClassName("required");
			$("txtCheckDate").removeClassName("required");
			$("txtCheckStat").value = "1";
			$("txtCheckStatMean").value = "Unprinted";
			gidvPrintTag = objGIACS002.printTag;
		}
	}
	
	$("rdoCheckDisbursement").observe("click", function(){
		if($("rdoCheckDisbursement").disabled == false){
			chkDisbInfo.disbMode = "C";
			prevCheckInfoButtonsDiv = $("checkInformationButtonsDiv").innerHTML;
			//prevdspTDCheckClassLabel2 = $("dspTDCheckClassLabel2").innerHTML;
			//prevdspTDCheckPrintDate2 = $("dspTDCheckPrintDate2").innerHMTL;
			//prevdspTDCheckBTStatus2 = $("dspTDCheckBTStatus2").innerHTML;
			
			initializeCheckButton();
			initializeBTDtls(false); //added by robert 01.26.15
		}
	});
	
	$("rdoBankTransfer").observe("click", function(){
		if($("rdoBankTransfer").disabled == false){
			chkDisbInfo.disbMode = "B";
			prevCheckInfoButtonsDiv = $("checkInformationButtonsDiv").innerHTML;
			prevdspTDCheckClassLabel2 = $("dspTDCheckClassLabel2").innerHTML;
			prevdspTDCheckPrintDate2 = $("dspTDCheckPrintDate2").innerHTML;
			//prevdspTDCheckBTStatus2 = $("dspTDCheckBTStatus2").innerHTML;
			
			initializeCheckButton();
			initializeBTDtls(true); //added by robert 01.26.15
		}
		/*$("dspTDCheckClassLabel").hide();
		$("txtCheckClass").hide();
		$("txtCheckClassMean").hide();*/
	});
	
	/*$("txtTGItem").observe("click", function(){
		if($F("txtTGItem") != "" && $F("txtTGItem") != itemNoCtr){
			//checkListTableGrid.onRemoveRowFocus();
		}
	});*/
	
	$("txtTGItem").observe("change", function(){
		getCurrentItemNoList();
		if(checkIfDuplicateItemNo()){
			customShowMessageBox("Item No. must be unique.", "I", "txtTGItem");
			$("txtTGItem").value = "";
		}
	});
	
	$("txtTGBank").observe("change", function(){
		if($F("txtTGBank").trim() != ""){
			validateBankCd();
		}
	});
	
	/* $("txtTGAmount").observe("keyup", function(){
		if($("txtTGAmount").disabled == false || $("txtTGAmount").readonly == false){
			isAmountAutoSet = false;
		}
	}); */
	
	$("txtTGAmount").observe("change", function(){
		if($("txtTGAmount").disabled == false || $("txtTGAmount").readonly == false){
			isAmountAutoSet = false;
			if(parseFloat(unformatCurrency("txtTGAmount")) > parseFloat(0)){
				
				if(nvl(getNewCheckAmount(), "") != ""){ // added
					if(convertToLocalAmount()){
						if(paramCheckDVPrint == "1"){
							if(nvl(parseInt(unformatCurrency("txtMIRForeignAmount")),0) != nvl(parseInt(unformatCurrency("txtTGAmount")),0) && $F("txtTGItem") == "1"){
								showMessageBox("Check amount should be equal to DV Amount.", "I");
								$("txtTGAmount").value = "";
								$("txtTGAmount").focus();
								return;
							}
							$("txtTGLocalCurrencyAmount").focus();		
						}else{	// added to validate updates for unprinted check : shan 10.22.2014
							var dvAmount = parseFloat(unformatCurrency("txtMIRForeignAmount"));
							var newTotalAmt = parseFloat(computeTotalAmountInTG());
							
							if(newTotalAmt.toFixed(2) > dvAmount){
								showMessageBox("Total check amount should not be greater than DV amount.", "I");
								$("txtTGAmount").value = "";
								$("txtTGLocalCurrencyAmount").value = "";
							}else{
								var localAmount = parseFloat(unformatCurrency("txtTGAmount")) * parseFloat($F("txtTGCurrencyRt"));
								$("txtTGLocalCurrencyAmount").value = formatCurrency(roundNumber(localAmount,2)); //benjo 03.09.2017 SR-21441
								$("txtTGAmount").value = formatCurrency($F("txtTGAmount"));
							}
						}
					} else {
						if(parseFloat(unformatCurrency("txtTGAmount")) == parseFloat(0)){
							if(!isAmountAutoSet){
								showMessageBox("Check amount should not be zero.", "I");
							}else {
								if(getNewCheckAmount == ""){
									customShowMessageBox("Total check amount should not be greater than DV amount.", "I", "txtTGAmount");
								}
							}
						}
						$("txtTGAmount").focus();
						$("txtTGLocalCurrencyAmount").value = "";
					}	
				} else {
					//$("txtTGAmount").value = "";
					//customShowMessageBox("Total check amount should not be greater than DV amount.", "I", "txtTGAmount");
					var dvAmount = parseFloat(unformatCurrency("txtMIRForeignAmount"));
					var newTotalAmt = parseFloat(computeTotalAmountInTG()) + parseFloat(unformatCurrency("txtTGLocalCurrencyAmount"));
					
					if(newTotalAmt.toFixed(2) > dvAmount){
						showMessageBox("Total check amount should not be greater than DV amount.", "I");
						$("txtTGAmount").value = "";
						$("txtTGLocalCurrencyAmount").value = "";
					}else{
						var localAmount = parseFloat(unformatCurrency("txtTGAmount")) * parseFloat($F("txtTGCurrencyRt"));
						$("txtTGLocalCurrencyAmount").value = formatCurrency(roundNumber(localAmount,2)); //benjo 03.09.2017 SR-21441
						$("txtTGAmount").value = formatCurrency($F("txtTGAmount"));
					}
				}
			} else {
				if(parseFloat(unformatCurrency("txtTGAmount")) == parseFloat(0)){
					//showMessageBox("Check amount should not be equal to zero.", "I");
					if(!isAmountAutoSet){
						showMessageBox("Check amount should not be zero.", "I");
					} else {
						if(getNewCheckAmount == ""){
							customShowMessageBox("Total check amount should not be greater than DV amount.", "I", "txtTGAmount");
						}
					}
				} else {
					//showMessageBox("Check amount should not be less than zero.", "I");
					if(!isAmountAutoSet){
						showMessageBox("Check amount should not be zero.", "I");
					}
				}
				$("txtTGLocalCurrencyAmount").value = "";
				$("txtTGAmount").value = "";
				$("txtTGAmount").focus();			
			}
		}
		
		
		/*if(total > parseFloat($F("txtMIRForeignAmount"))){
			showMessageBox("Total check amount should not be greater than DV amount.", "I");
			return false;
		} else {
			return true;
		}*/
	});
	
	$("txtCheckPrintDate").observe("change", function(){
		validateDateFormat($F("txtCheckPrintDate"), "txtCheckPrintDate");
	});
	
	$("txtCheckDate").observe("change", validateCheckDateOnChange);
	function validateCheckDateOnChange(){
		if($F("txtCheckDate") != ""){
			if(validateDateFormat($F("txtCheckDate"), "txtCheckDate")){
				var dvDate = Date.parse(objGIACS002.dvDate); //.format("mm-dd-yyyy");
				var chkDate = Date.parse($F("txtCheckDate")); //.format("mm-dd-yyyy");
				var sysDate = new Date(); //.format("mm-dd-yyyy");
				
				if($("rdoCheckDisbursement").checked){
					if(chkDate < dvDate){
						message = "Check date should not be earlier than DV Date: " + objGIACS002.dvDateStrSp;
									//  dateFormat(dvDate, "mmmm") + " " + dateFormat(dvDate, "dd") + ", " + dateFormat(dvDate, "yyyy");
						customShowMessageBox(message, "I", "txtCheckDate");
						$("txtCheckDate").clear();
					}
				} else if($("rdoBankTransfer").checked){
					if(paramGenBankTransferNo == "M"){
						if(chkDate > sysDate){
							message = "Check date should not be later than today, " + new Date().format("mmmm dd, yyyy");
										//dateFormat(dvDate, "mmmm") + " " + dateFormat(dvDate, "dd") + ", " + dateFormat(dvDate, "yyyy");
							customShowMessageBox(message, "I", "txtCheckDate");
							$("txtCheckDate").clear();
						}
					}
				}
			}
		}
	}
	$("txtCheckNo").observe("change", function(){
		if($("txtCheckNo").hasClassName("required")){
			if($F("txtCheckNo") != "" && $F("hidBankAcctCd") != ""){
				validateCheckNo();
				/* var checkno = $F("txtCheckNo");
				$("txtCheckNo").value = formatNumberDigits(checkno,10); */
			} else {
				$("txtCheckNo").value = "";
				showMessageBox("Please select a bank first.", "I");
			}
		} else{
			if($F("hidBankAcctCd") != "" && $F("txtCheckNo") != ""  && $("txtCheckNo").hasAttribute("readonly") == false ){ //added by jeffdojello 11.14.2013 > $("txtCheckNo").hasAttribute("readonly") == false 
				validateCheckNo();
			} else {
				$("txtCheckNo").value = "";
				showMessageBox("Please select a bank first.", "I");
			}
		}
	});
	
	$("txtCheckClass").observe("change", function() {		
		if($F("txtCheckClass").trim() == "") {
			$("txtCheckClass").value = "";
			$("txtCheckClass").setAttribute("lastValidValue", "");
			$("txtCheckClassMean").value = "";
		} else {
			if($F("txtCheckClass").trim() != "" && $F("txtCheckClass") != $("txtCheckClass").readAttribute("lastValidValue")) {
				showGIACS002CheckClassLOV();
			}
		}
	});	 	
	
	// SEARCH ITEMS
	$("osBankNo").observe("click", showGIACS002BanksLOV);
	/* function(){
		if($("osBankNo").disabled != true){
			//populateChkFields(null, false);
			//checkListTableGrid.onRemoveRowFocus();
			showGIACS002BanksLOV("GIACS002", $F("hidBranchCd"), $F("hidBranchCd"));
		}
	}); */
	
	$("osCheckClass").observe("click", showGIACS002CheckClassLOV); 
	
	//jeffDojello Enhancement SR-1069 11.05.2013
	$("lovPayeeClassCd").observe("click", function(){
			showPayeeLOV("GIACS002");
	});
	
	$("lovPayeeNo").observe("click", function(){
			showPayeeLOV2("GIACS002", $F("txtPayeeClassCd"));
	});
	
	/*$("osCheckStat").observe("click", function(){
		if($("osCheckClass").disabled != true){
			showGIACS002CheckStatLOV();
		}
	});*/
		
	// BUTTONS BEHAVIOR
	$("btnAdd").observe("click", function(){
		var currentFunction = $F("btnAdd");
		//var divArray = ["checkInformationListingFields, "]
		
		if(checkAllRequiredFieldsInDiv("checkInformationListingFields") && checkAllRequiredFieldsInDiv("checkInformationSubDiv3")){	
			if(validateCheckDetails(currentFunction)){
				///
				// when-create-record trigger
				if(objGIACS002.cancelDV == "N"){
					/*if(objGIACS002.gcdbCreateRec == "Y"){
						if(objGIACS002.dvTag == "M"){
							//$("txtCheckPrefSuf").value = paramCheckPref == "" ? "" : paramCheckPref; //getCheckPrefSuf();
							$("txtCheckStat").value = "2";
							$("txtCheckStatMean").value = "Printed";
							if(paramCheckPref == "" || paramCheckPref == null){
								showMessageBox("Check Prefix not in giac_parameters.", "E");
							} 
							
						} else if (objGIACS002.dvTag == null){
							if(objGIACS002.checkDVPrint == "4"){
								//$("txtCheckPrefSuf").value = paramCheckPref == "" ? "" : paramCheckPref; //getCheckPrefSuf();
								$("txtCheckStat").value = "2";
								$("txtCheckStatMean").value = "Printed";
								if(paramCheckPref == "" || paramCheckPref == null){
									showMessageBox("Check Prefix not in giac_parameters.", "E");
								}
							} else {
								$("txtCheckStat").value = "1";
								$("txtCheckStatMean").value = "Unprinted";
							}
						}
						
						if(objGIACS002.itemSw == "Y"){
							if(objGIACS002.allowMultiCheck == "N"){
								if(objCheckArray.length == 1 && itemInc == 1){
									showMessageBox("Multiple Checks are not allowed.", "I");
								} else {
									//:gcdb.item_no := variables.item_inc + 1;
									itemInc++;
								}
							} else {
								//:gcdb.item_no := variables.item_inc + 1;
								itemInc++;
							}
						}
					}*/
					//jeffDojello Enhancement SR-1069 11.05.2013
					/*$("txtPayeeClassCd").value = disbVoucherInfo.payeeClassCd;
					$("txtPayeeNo").value = formatNumberDigits(disbVoucherInfo.payeeNo,12);
					$("txtPayeeName").value = unescapeHTML2(disbVoucherInfo.payee);*/
					$("txtUserID").value = varUserId;					
				}// end of when-create-record trigger				
				///
				//isNewLoad = false;
				var objCheckToAdd = createObjCheck($F("btnAdd"));
				if(currentFunction == "Add"){
					objCheckArray.push(objCheckToAdd);
					checkListTableGrid.addBottomRow(objCheckToAdd);
					changeTag = 1;
				} else if (currentFunction == "Update"){
					if(checkListSelectedRow == "" || checkListSelectedRow == null){ // no check to be updated is selected
						showMessageBox("Please select an item first.", "I");
					} else {
						objCheckArray.splice(checkListSelectedIndex, 1, objCheckToAdd);
						checkListTableGrid.updateVisibleRowOnly(objCheckToAdd, checkListSelectedIndex);
						checkListTableGrid.onRemoveRowFocus();
						changeTag = 1;
					}
				}
				//initTGFields();	
				isReset = true;
				getCurrentItemNoList();
				//itemNoCtr++;
				getNextItemNo();
				populateChkFields(null, false);				
			}
		} else {
			showMessageBox(objCommonMessage.REQUIRED, "I");
		} 		
	});
	
	function getNextItemNo(){
		var max = 0;
		for(var i=0; i<objCheckArray.length; i++){
			var currItem =  parseInt(objCheckArray[i].itemNo);
			if(currItem > max && objCheckArray[i].recordStatus != -1){
				max = currItem;
			}
		}
		
		itemNoCtr = max + 1;
		
		/*var max = parseInt(1);
		var isExisting = false;
		
		if(objGIACS002.itemNoList.length > 0){
			for(var i=0; i<objGIACS002.itemNoList.length; i++){
				var currItem =  parseInt(objGIACS002.itemNoList[i]);
				if(currItem == itemNoCtr && objCheckArray[i].recordStatus != -1){
					isExisting = true;
				}
				if(currItem > max){
					max = currItem;
				}			
			}
		} else {
			for(var i=0; i<objCheckArray.length; i++){
				var currItem =  parseInt(objCheckArray[i].itemNo);
				if(currItem == itemNoCtr && objCheckArray[i].recordStatus != -1){
					isExisting = true;
				}
				if(currItem > max){
					max = currItem;
				}			
			}
		}*/
		//if(isExisting){
			/*if(max == itemNoCtr){
				itemNoCtr++;	
			} else if(max > itemNoCtr){
				itemNoCtr = max + 1;
			}*/			
		/* } else {
			if(max == itemNoCtr){
				itemNoCtr++;	
			} else if(max > itemNoCtr){
				itemNoCtr = max + 1;
			}		
		} */
		
	}
	
	$("hrefCheckDate").observe("click", function(){
		scwShow($('txtCheckDate'),this, null); 
	});
	$("hrefCheckPrintDate").observe("click", function(){
		scwShow($('txtCheckPrintDate'),this, null); 
	});
	
	$("editParticulars").observe("click", function(){
		showOverlayEditor("txtParticulars", 500, $("txtParticulars").readOnly);
	});
	
	$("txtParticulars").observe("keyup", function(){
		if($F("txtParticulars").length > 500){
			showMessageBox("You have exceeded the maximum number of allowed characters (500) for this field.", "I");
		}
	});
	
	$("btnDelete").observe("click", function(){
		  if($F("txtTGItem") != "" && $F("txtTGAmount") != "" && $F("txtTGLocalCurrencyAmount") != "" && $F("txtTGBank") != "" && $F("txtTGCurrencyRt") != ""){
			getChkReleaseInfo();

			if(tranFlag == "C"){
				if(objGIACS002.dvFlag == "C"){
					showMessageBox("Delete not allowed. This transaction has been cancelled.", "I");
				} else {
					showMessageBox("Delete not allowed. This transaction has been closed.", "I");
				}
			} else if(tranFlag == "D"){
				showMessageBox("Deletion not allowed for a cancelled DV.", "I");
			} else if(tranFlag == "P"){
				if(objGIACS002.dvFlag == "C"){
					showMessageBox("Delete not allowed. This transaction has been cancelled.", "I");
				} else {
					showMessageBox("Delete not allowed. This transaction has been posted.", "I");
				}
			} else if(tranFlag == "O"){
				if (objGIACS002.dvFlag == "A" && $F("txtCheckStat") != "1"){	// added condition : shan 09.10.2014
					showMessageBox("Delete not allowed. This transaction has been approved.", "I");
				}else{
					if(nvl(objGIACS002.dvTag,null) == null){ //change by steven 09.10.2014
						if($F("txtCheckStat") == "1"){
							if(paramCheckDVPrint == "4"){
								showMessageBox("Error: Invalid check status for Check DV Print 4.", "E");
								return;
							}
							//delete_record
							//showConfirmBox("Confirmation", "Are you sure you want to delete Check?", "Yes", "No", validateOnDelete, "");
							showConfirmBox4("Confirmation", "Are you sure you want to delete?", "Yes", "No", "Cancel", validateOnDelete, function(){}, "", "");
						} else if($F("txtCheckStat") == "2"){
							if(paramCheckDVPrint == "4"){
								if(objGIACS002.chkReleaseInfo.checkReleaseDate == null){ // checkrelease date
									//delete_record
									//showConfirmBox("Confirmation", "Are you sure you want to delete Check?", "Yes", "No", validateOnDelete, "");
									showConfirmBox4("Confirmation", "Are you sure you want to delete?", "Yes", "No", "Cancel", validateOnDelete, function(){}, "", "");
								} else {
									showMessageBox("Delete not allowed. This check has already been released.", "I");
								}
							} else {
								showMessageBox("Delete not allowed. This check has already been printed.", "I");
							}
						} else if($F("txtCheckStat") == "3"){
							showMessageBox("Delete not allowed. This check has already been canceled.", "I");
						} else if($F("txtCheckStat") == "4"){
							showMessageBox("Delete not allowed. This check has already been replaced.", "I");
						}
					} else if(objGIACS002.dvTag == "M"){
						if($F("txtCheckStat") == "2"){
							if(objGIACS002.chkReleaseInfo.checkReleaseDate != null){
								showMessageBox("Delete not allowed. This check has already been released.", "I");
							}
							if($F("txtTGItem") != ""){
								// 1. bef_delete_manual_check
								// 2. delete_record..
								//showConfirmBox("Confirmation", "Are you sure you want to delete Check?", "Yes", "No", validateOnDelete, "");
								showConfirmBox4("Confirmation", "Are you sure you want to delete?", "Yes", "No", "Cancel", validateOnDelete, function(){}, "", "");
							} else if($F("txtCheckStat") == "3" || $F("txtCheckStat") == "4"){
								showMessageBox("Delete not allowed. This check has already been canceled or replaced.", "I");
							} else if($F("txtCheckStat") == "1"){
								showMessageBox("Error: Check status should not be '1' for a manual DV.", "E");
							}
						}
					}
				}
				isReset = true;
				//initializeCheckButton();
			} 
		} else {
			showMessageBox("Please select an item to delete.", "I");
		}	
		
	});
	
	$("btnSave").observe("click", proceedSaveChkDetails);
	$("btnCancel").observe("click", cancelGiacs002CheckDetails); 
	/* function(){
		changeTag = 0;
		checkListTableGrid.onRemoveRowFocus();
		checkListTableGrid.refresh();
	}); */
	
	$("btnSpoilCheck").observe("click", function(){
		if(objGIACS002.dvTag == "M"){
			showMessageBox("This function is not allowed for a manual DV.", "I");
			return false;
		}
		
		if(paramCheckDVPrint == "1" || paramCheckDVPrint == "2" || paramCheckDVPrint == "3"){
			objACGlobal.gaccTranId = $F("hidGaccTranId");
			objACGlobal.fundCd = $F("txtFundCd");
			objACGlobal.branchCd = $F("hidBranchCd");
			
			validateSpoilCheck();
		} else {
			showMessageBox("This function is not allowed.", "I");
			return false;
		}
	});
	
	$("btnPrintCheckDV").observe("click", function(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
		
		// remove multi-line comment when GIACS052 is available.
		var isValid = true;
		if(objGIACS002.dvTag != null && objGIACS002.dvTag == "M"){
			isValid = false;
			showMessageBox("This function is not allowed for a manual DV.", "I");
			return false;
		}
		if(objGIACS002.dvFlag == "C"){
			isValid = false;
			showMessageBox("Printing not allowed. This DV/check has already been cancelled.", "I");
			return false;
		} else if(objGIACS002.dvFlag == "D"){
			isValid = false;
			showMessageBox("Printing not allowed. This DV/check is tagged as deleted.", "I");
			return false;
		} else if(objGIACS002.dvFlag == "N"){
			if(nvl(paramAllowDVPrinting, "N") == "Y"){	
				isValid = true; //changed to true 
				//printDV();
			} else {
				isValid = false;
				showMessageBox("Printing not allowed. This DV/check has not yet been approved.", "I");
				return false;
			}
		} else if(objGIACS002.dvFlag == "A" || objGIACS002.dvFlag == "P"){
			if(changeTag != 0){  //RECORD _STATUS = CHANGED
				showMessageBox("Please save or clear your changes first.", "I");
				return false;
			}
		}
		if(paramCheckDVPrint == "1"){
			if(objGIACS002.dvFlag == "A" && $("rdoCheckDisbursement").readAttribute("checked") == "checked"){
				//getCheckToPrint(); ***
				//printDV(); //temporarily call this
			} else if(objGIACS002.dvFlag == "P" && $F("txtCheckStat") == "2"){
				showMessageBox("This is a printed Check/DV.", "I");
				return false;
			}
		} else if(paramCheckDVPrint == "2" || paramCheckDVPrint == "4"){
			//null >> allow reprting of DV.
			//printDV();
		} else if(paramCheckDVPrint == "2" && objGIACS002.dvFlag == "P" && $("rdoBankTransfer").readAttribute("checked") == "checked"){
			isValid = false;
			showMessageBox("This is a printed bank transfer DV.", "I");
			return false;
		} else if(paramCheckDVPrint == "3"){
			if(objGIACS002.dvFlag == "A"){
				isValid = false;
				showMessageBox("This should already be a printed DV.", "E");
				return false;
			} else if(objGIACS002.dvFlag == "P"){
				//getCheckToPrint(); ***
				//printDV(); //temporarily call this
			}
		}
		
		var dvAmount = unformatCurrencyValue(objGIACS002.foreignAmount);
		if(parseFloat(nvl(dvAmount,0)) != parseFloat(nvl(computeTotalAmountInTG(true),0)).toFixed(2)){ //added toFixed(2) jeffdojello 11.20.2013 to handle encountered cases like 83.04 != 83.039999999
			isValid = false;
			showMessageBox("The DV Amount and the Total Check Amount are not equal when button-pressed Print Check.", "I");
			return false;
		}
		if(isValid){
			validateAcctEntriesBeforePrint();
		}
		
		//validateAcctEntriesBeforePrint();		
	});
	
	$("btnCheckRelease").observe("click", function(){
		objGIACS002.gaccTranId = $F("hidGaccTranId");
		objGIACS002.itemNo = $F("txtTGItem");
		objGIACS002.isPrinted = ($F("txtCheckStatMean") == "Printed" ? true : false);
	
		if(checkListSelectedIndex == -1 && checkListSelectedRow == ""){
			showMessageBox("Please select an item first.", "I");
		} else {
			if(changeTag != 0){
				showMessageBox("Please save your changes first.", "I");
			} else {
				if($F("txtTGItem") != ""){
					try{
						overlayCheckReleaseInfo = Overlay.show(contextPath+"/GIACChkDisbursementController", { 
							urlContent: true,
							urlParameters: {action 		: "showCheckReleaseInformationPage",
											gaccTranId 	: $F("hidGaccTranId"),
											itemNo		: $F("txtTGItem"),
											checkPrefSuf: $F("txtCheckPrefSuf"),
											checkNo		: $F("txtCheckNo"),
											ajax 		: "1"},
							title: "Check Release Information",							
						    height: 230,
						    width: 720,
						    draggable: true,
						    onCompleteFunction : function(){
						    }
						});
						
					}catch(e){
						showErrorMessage("btnCheckRelease",e);
					}
				} else {
					showMessageBox("Please select an item first.", "I");
				}
				changeTag = 0;
			}
		}	
		
	});
	
	$("btnReturn").observe("click", function(){
		if(changeTag == 0){
			objGIACS002.previousPage = "checkDetails";
			//$("mainNav").show();
			$("acMenus").show();
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
		} else {
			showMessageBox("Please save or clear your changes first.", "I");
			/*if(objACGlobal.queryOnly == "Y"){
				changeTag = 0;
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			} else {
				//showMessageBox("Please save your changes first.", "I");
				if(changeTag == 1){
					showConfirmBox("Confirmation", "Leaving the page will discard changes. Do you want to continue?", 
							"Yes", "No", 
							function(){
								changeTag = 0;
								showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
							}, // if YES
							function(){}, // if NO
							"");
				} else {
					showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				}
			}*/
		}
	});
	$("acExit").stopObserving();
	$("acExit").observe("click", cancelGiacs002CheckDetails);
	
	function cancelGiacs002CheckDetails(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS002.exitPage = exitPage;
						proceedSaveChkDetails();
					}, function(){
						showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
					}, "");
		} else {
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
		}
	}
	
	function exitPage(){
		showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
	}
	
	/*observeCancelForm("btnReturn", 
			function() {}, 
			function() {showDisbursementVoucherPage(objGIACS002.cancelDV, "getGIACS002DisbVoucherList");});*/
	
	/*observeCancelForm("btnCancel", 
			function() {}, 
			function() {showDisbursementVoucherPage(objGIACS002.cancelDV, "getGIACS002DisbVoucherList");});*/
	
	/** The RELOAD FORM link in the inner div */
	observeReloadForm("reloadForm", function(){		
		showCheckDetailsPage(disbVoucherInfo, $F("hidGaccTranId"));
	});
			
	/*$("checkDetailsExit").observe("click", function(){
		if(changeTag == 0){
			// go to disbursementVoucher.jsp;
			objGIACS002.previousPage = "checkDetails";
			//showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		} else {
			
		}
	});	*/
	
	if( (objACGlobal.queryOnly == "Y" && objGIACS002.dvTag != "M") || objGIACS002.cancelDV == "Y"){
		disableGIACS002CheckDetails();
	} else {
		initializeChangeTagBehavior(proceedSaveChkDetails);
		initializeChangeAttribute();			
	}
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializeFields();
	getCurrentItemNoList();
	getNextItemNo();
	
	observeChangeTagOnDate("hrefCheckDate", "txtCheckDate", validateCheckDateOnChange);
</script>
