<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="overridingCommVoucherMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Overriding Commission Voucher</label>				
		</div>
	</div>	
	
	<div id="commVoucherDiv">
		<div id="intmDiv" class="sectionDiv" style="width: 920px; height: 105px;">
			<table style="margin: 5px 0 0 35px;">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Intermediary</td>
					<td>
						<span class="lovSpan required" style="width:130px; height: 21px; float: left; margin-top: 1px;">
							<input type="text" id="txtIntmNo" name="txtIntmNo" maxlength="12" class="integerUnformattedNoComma rightAligned required" style="width: 100px; float: left; margin-right: 4px; border: none; height: 13px; " tabindex="101"/>	
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmLOV" name="searchIntmLOV" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtIntmName" class="required" readonly="readonly" style="width: 550px;" tabindex="103"/>
					</td>
					<td>
						<input type="text" id="txtCoIntmType" class="required" readonly="readonly"  style="width: 50px;" tabindex="104"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Fund</td>
					<td colspan="4">
						<span class="lovSpan" style="width: 70px; height: 21px; float: left; margin-top: 1px;">
							<input type="text" id="txtFundCd" name="txtFundName" maxlength="3" style="width: 40px; float: left; margin-right: 4px; border: none; height: 13px;"tabindex="105"/>	
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundLOV" name="searchFundLOV" alt="Go" style="float: right;"tabindex="106"/>
						</span>
						<input type="text" id="txtFundName" name="txtFundName" maxlength="50" style="width: 265px; float: left; margin: 1px 4px 0 5px;" tabindex="107"/>	
							
						
						<label style="padding: 5px 5px 0 25px; float:left;">Branch</label>
						<input type="text" id="txtBranchCd" style="width: 50px; float: left;" readonly="readonly" tabindex="108"/>
						<!-- <span class="lovSpan" style="width:330px; height: 21px; margin: 2px 4px 0 0; float: left;">  -->
						<input type="text" id="txtBranchName" name="txtBranchName" maxlength="50" readonly="readonly" style="width: 260px; float: left; margin: 2px 0px 0 5px;" tabindex="109"/>	
						<!--	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchLOV" name="searchBranchLOV" alt="Go" style="float: right;"tabindex="108"/>
						</span> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">From</td>
					<td colspan="4">
						<div style="float: left; width: 150px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 125px;"tabindex="110"/>
							<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtFromDate'),this, null);" tabindex="111"/>
						</div>										
						<label style="padding: 5px 8px 0 20px; float:left;">To</label>
						<div style="float: left; width: 150px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 125px;"tabindex="112"/>
							<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtToDate'),this, null);" tabindex="113"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="commVoucherDiv" class="sectionDiv" style="width: 920px; height: 400px;">
			<div id="commVoucherTableDiv" style="padding-top: 10px;">
				<div id="commVoucherTGDiv" name="commVoucherTGDiv" style="height: 280px; margin: 10px 20px 0 10px;"></div>
			</div>
			
			<div style="width: 910px; margin: 25px 20px 20px 10px;">
				<div class="buttonsDiv" style="width: 370px;  float:left;">
					<input type="button" class="button" id="btnPrintList"value="Print List" style="width: 100px;"/>
					<input type="button" class="button" id="btnPrintOCV" value="Print OCV" style="width: 100px;"/>
					<input type="button" class="button" id="btnDetails" value="Details" style="width: 100px;"/>
				</div>
				
				<div id="totalsDiv" style="width: 420px; margin: 0 0 0 80px; float:right;">
					<table>
						<tr>
							<td class="rightAligned" style="padding-right: 5px;">Tagged Totals</td>
							<td>
								<input id="txtTaggedTotalPrem" type="text" readonly="readonly" class="money2" style="width: 150px;"/>
							</td>
							<td>
								<input id="txtTaggedTotalComm" type="text" readonly="readonly" class="money2" style="width: 150px;"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="padding-right: 5px;">Grand Totals</td>
							<td>
								<input id="txtGrandTotalPrem" type="text" readonly="readonly" class="money2" style="width: 150px;"/>
							</td>
							<td>
								<input id="txtGrandTotalComm" type="text" readonly="readonly" class="money2" style="width: 150px;"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<div id="commVoucherDetailsMainDiv" class="sectionDiv" style="width: 920px; height: 505px;">
		<div id="cvDetailsDiv" class="sectionDiv" style="width: 750px; height: 450px; margin: 30px 0 0 100px;"/>
			<table style="width: 700px; margin: 20px 0 10px 25px;">
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Transaction Date</td>
					<td><input id="txtTranDate" type="text" readonly="readonly" style="width: 200px" tabindex="201"/> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Ref. No.</td>
					<td>
						<input id="txtRefNo" type="text" readonly="readonly" style="width: 145px" tabindex="202"/> 
						<input id="txtTranClass" type="text" readonly="readonly" style="width: 43px" tabindex="203"/> 
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Invoice No./Inst No</td>
					<td>
						<input id="txtIssCd" type="text" readonly="readonly" style="width: 40px" tabindex="204"/> 
						<input id="txtPremSeqNo" type="text" readonly="readonly" style="width: 95px" tabindex="205"/> 
						<input id="txtInstNo" type="text" readonly="readonly" style="width: 40px" tabindex="206"/> 
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Collection Amount</td>
					<td><input id="txtCollectionAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="207"/> </td>
					<td class="rightAligned" style="padding-right: 7px;">Commission Amount</td>
					<td><input id="txtCommissionAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="208"/> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Premium Amount</td>
					<td><input id="txtPremiumAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="209"/> </td>
					<td class="rightAligned" style="padding-right: 7px;"><label>&nbsp; + &nbsp;&nbsp;&nbsp;&nbsp; Input VAT</label></td>
					<td><input id="txtInputVat" type="text" readonly="readonly" class="rightAligned money" style="width: 200px" tabindex="210"/> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Tax Amount</td>
					<td><input id="txtTaxAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="211"/> </td>
					<td class="rightAligned" style="padding-right: 7px;"><label>&nbsp; - &nbsp;&nbsp;&nbsp;&nbsp; Withholding Tax</label></td>
					<td><input id="txtWholdingTax" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="212"/> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Notarial Fee</td>
					<td><input id="txtNotarialFee" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="213"/> </td>
					<td class="rightAligned" style="padding-right: 7px;"><label>&nbsp; - &nbsp;&nbsp;&nbsp;&nbsp; Advances</label></td>
					<td><input id="txtAdvances" type="text" value="" readonly="readonly" class="rightAligned " style="width: 200px" min="0" max="999,999,999,999,999.99" errorMsg="Invalid Advances. Valid value should be from 0 to 999,999,999,999,999.99." tabindex="214" hasOwnBlur=""/> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Other Charges</td>
					<td><input id="txtOtherCharges" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="215" /> </td>
					<td class="rightAligned" style="padding-right: 7px;"> Net Commission Due</td>
					<td><input id="txtNetCommDue" type="text" readonly="readonly" class="rightAligned" style="width: 200px" tabindex="216"/> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding: 35px 7px 0 0;">Intermediary</td>
					<td colspan="3" style="padding-top: 35px;">
						<input id="txtIntmNo2" type="text" readonly="readonly" class="rightAligned" style="width: 50px" tabindex="217"/>
						<input id="txtIntmName2" type="text" readonly="readonly" style="width: 500px" tabindex="218"/> 
				 	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px">Assured</td>
					<td colspan="3">
						<input id="txtAssdName" type="text" readonly="readonly"style="width: 562px" tabindex="219"/> 
				 	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Child Intm No</td>
					<td colspan="3">
						<input id="txtChldIntmNo" type="text" readonly="readonly" class="rightAligned" style="width: 50px" tabindex="220"/>
						<input id="txtChldIntmName" type="text" readonly="readonly" style="width: 500px" tabindex="221"/> 
				 	</td>
				</tr>
			</table>
			
			<div class="buttonsDiv" style="width: 750px; height: 30px;">
				<input id="btnReturn" type="button" class="button" value="Return" style="width: 90px; margin-right: 20px;" tabindex="222" />
				<!-- <input id="btnSave" type="button" class="button" value="Save"> -->
			</div>
		</div>
	</div>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS149");
	setDocumentTitle("Overriding Commission Voucher");
	initializeAll();
	initializeAllMoneyFields();
	
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	disableButton("btnPrintOCV");
	disableButton("btnPrintList");
	disableButton("btnDetails");
	
	$("txtIntmNo").focus();
	$("commVoucherDetailsMainDiv").hide();
	
	
	var varFundCd = '${fundCd}';
	var cntTagged = 0;
	
	changeTag = 0;
		
	var selectedIndex = null;
	var tempSelectedRow = null;
	
	var objOvrdComm = new Object();
	objOvrdComm.commVoucherTG = JSON.parse('${overrideCommVoucherTableGrid}'.replace(/\\/g, '\\\\'));
	objOvrdComm.commVoucherObjRows = objOvrdComm.commVoucherTG.rows || [];
	objOvrdComm.commVoucherList = [];	//holds all geniisys rows
	
	try{
		var commVoucherTableModel = {
			url: contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1&vUpdate=N",
			options: {
				width: '900px',
				//height: '200px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					objGIACS149.selectedRow = commVoucherTG.geniisysRows[y];
					setCommVoucherDtlFields();
				},
				/*onCellBlur: function(element, value, x, y, id){
					observeChangeTagInTableGrid(commVoucherTG);
				},*/
				onRowDoubleClick: function(y){
					selectedIndex = y;
					objGIACS149.selectedRow = commVoucherTG.geniisysRows[y];
					commVoucherTG.keys.releaseKeys();
					showCommVoucherDetails();
				},
				onRemoveRowFocus: function(){
					commVoucherTG.keys.releaseKeys();
					selectedIndex = null;
					objGIACS149.selectedRow = null;
					setCommVoucherDtlFields();
				},		
				beforeSort: function(){
					commVoucherTG.onRemoveRowFocus();
					changeTag = 0;
					return true;
				},
				onSort: function(){
					commVoucherTG.onRemoveRowFocus();
				},
				prePager: function(){
					commVoucherTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					commVoucherTG.onRemoveRowFocus();
					computeGrandTotals();
				},
				validateChangesOnPrePager: function(){
					return false;
				},
				checkChanges: function(){
					if (cntTagged > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return true;
					}else{
						return false;
					}
				},
				masterDetailRequireSaving: function(){
					if (cntTagged > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return true;
					}else{
						return false;
					}
				},
				masterDetailValidation: function(){
					if (cntTagged > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return true;
					}else{
						return false;
					}
				},
				masterDetail: function(){
					if (cntTagged > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return true;
					}else{
						return false;
					}					
				},
				masterDetailSaveFunc: function() {
					if (cntTagged > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return true;
					}else{
						return false;
					}
				},
				masterDetailNoFunc: function(){
					if (cntTagged > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return true;
					}else{
						return false;
					}
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){				
						commVoucherTG.onRemoveRowFocus();
					}
				}
			},			
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},       
				{
					id: 'gfunFundCd',
					width: '0px',
					visible: false
				},       
				{
					id: 'fundDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'gibrBranchCd',
					width: '0px',
					visible: false
				},       
				{
					id: 'branchName',
					width: '0px',
					visible: false
				},
				{
					id: 'gaccTranId',
					width: '0px',
					visible: false
				},
				{
					id: 'transactionType',
					width: '0px',
					visible: false
				},
				{
					id: 'policyId',
					width: '0px',
					visible: false
				},
				{
					id: 'instNo',
					width: '0px',
					visible: false
				},
				{
					id: 'collectionAmt',
					width: '0px',
					visible: false
				},
				{
					id: 'commissionDue',
					width: '0px',
					visible: false
				},
				{
					id: 'inputVat',
					width: '0px',
					visible: false
				},
				{
					id: 'taxAmt',
					width: '0px',
					visible: false
				},
				{
					id: 'withholdingTax',
					width: '0px',
					visible: false
				},
				{
					id: 'notarialFee',
					width: '0px',
					visible: false
				},
				{
					id: 'advances',
					width: '0px',
					visible: false
				},
				{
					id: 'otherCharges',
					width: '0px',
					visible: false
				},
				{
					id: 'netCommDue',
					width: '0px',
					visible: false
				},
				{
					id: 'intmNo',
					width: '0px',
					visible: false
				},
				{
					id: 'intmName',
					width: '0px',
					visible: false
				},
				{
					id: 'assdName',
					width: '0px',
					visible: false
				},
				{
					id: 'chldIntmNo',
					width: '0px',
					visible: false
				},
				{
					id: 'chldIntmName',
					width: '0px',
					visible: false
				},
				{
					id: 'printTag',
					width: '0px',
					visible: false
				},
				{
					id: 'printTag',
					width: '0px',
					visible: false
				},
				{
					id: 'dspPrintTag',
					title: 'I',
					titleAlign: 'center',
					width: '25px',
					//sortable: true,
					filterOption: false,
					editable: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked){
		            		if (checked){
		            			//objGIACS149.checkedVouchers.push(objGIACS149.selectedRow);  //gpcv_pk_add_row in CS ; moved inside savePrintTagChanges 01.28.2014
		            			if (objGIACS149.selectedRow.dspRefNo == null && objGIACS149.selectedRow.tranClass == "COL"){
		        					showMessageBox("Reference document has not been printed for this bill yet.", "I");
		        					$("mtgInput"+commVoucherTG._mtgId+"_26,"+selectedIndex).checked = false;
		        					$("mtgInput"+commVoucherTG._mtgId+"_26,"+selectedIndex).value = "N";
		        					commVoucherTG.setValueAt("N", commVoucherTG.getColumnIndex('dspPrintTag'), selectedIndex);
		        					return;
		        				}/*else{
		        					computeTaggedTotals(value); 
		        				}*/
		        				
		            			savePrintTagChanges(null, "Y");
		            		}else{
		            			for (var i = 0; i<objGIACS149.checkedVouchers.length; i++){
		            				if (objGIACS149.checkedVouchers[i].divCtrId == objGIACS149.selectedRow.divCtrId){
		            					objGIACS149.checkedVouchers.splice(i, 1);	//gpcv_pk_del_row in CS
		            					break;
		            				}
		            			}
		            			//computeTaggedTotals(value);

	        					savePrintTagChanges(null, "N");
		            		}
						}
		            })									
				},
				{
					id: 'tranDate',
					title: 'Tran Date',
					width: '80px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{
					id: 'dspRefNo',
					title: 'Ref No.',
					titleAlign: 'right',
					width: '95px',
					filterOption: true,
					//filterOptionType: 'integerNoNegative'
				},
				{
					id: 'policyNo',
					title: 'Policy No.',
					width: '180px',
					filterOption: true
				},
				{
					id: 'issCd premSeqNo',
					title: 'Bill No.',
					width: '130px',
					children: [
						{
							id: 'issCd',
							title: 'Iss Cd',
							width: 40,
							filterOption: true,
							sortable: false,
							editable: false
						},     
						{
							id: 'premSeqNo',
							title: 'Prem Seq No',
							width: 75,
							filterOption: true,
			        	  	filterOptionType: 'integerNoNegative',
							sortable: false,
							editable: false
						}      
					]
				},
				{
					id: 'ocvPrefSuf ocvNo',
					title: 'OCV No.',
					align: 'right',
					titleAlign: 'right',
					//width: '80px',
					children: [
						{
							id: 'ocvPrefSuf',
							title: 'OCV Pref Suf',
							width: 50,
							filterOption: true,
							sortable: false,
							editable: false
						},     
						{
							id: 'ocvNo',
							title: 'OCV No',
							width: 85,
							filterOption: true,
						  	filterOptionType: 'integerNoNegative',
							sortable: false,
							editable: false
						}      
					]
				},
				{
					id: 'tranClass',
					title: 'Class',
					width: '50px',
					filterOption: true
				},
				{
					id: 'premMinusOthers',
					title: 'Premium Amount',
					width: '150px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					geniisysMaxValue: '999,999,999,999.99'
				},
				{
					id: 'netCommAmtDue',
					title: 'Commission Due',
					width: '150px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					geniisysMaxValue: '999,999,999,999.99'
				},
				{
					id: 'grandTotalPrem',
					visible: false,
					width: '0px'
				},
				{
					id: 'grandTotalComm',
					visible: false,
					width: '0px'
				}
			],
			rows: objOvrdComm.commVoucherObjRows
		};
		
		commVoucherTG = new MyTableGrid(commVoucherTableModel);
		commVoucherTG.pager = objOvrdComm.commVoucherTG;
		commVoucherTG.render('commVoucherTGDiv');
		commVoucherTG.afterRender = function(){
			if (commVoucherTG.geniisysRows.length == 0){
				$("txtGrandTotalPrem").value = formatCurrency("0");
				$("txtGrandTotalComm").value = formatCurrency("0");	
			}else{
				$("txtGrandTotalPrem").value = formatCurrency(commVoucherTG.geniisysRows[0].grandTotalPrem);
				$("txtGrandTotalComm").value = formatCurrency(commVoucherTG.geniisysRows[0].grandTotalComm);
			}
		};
		
	}catch(e){
		showErrorMessage("ovrdCommVoucherTableGrid", e);
	}
	
	function resetGlobalVars(){
		objACGlobal.previousModule = null;
		objACGlobal.calledForm = null;
		objACGlobal.callingForm = null;
		objACGlobal.gaccTranId = null;
		objACGlobal.fundCd = null;
		objACGlobal.branchCd = null;
		objACGlobal.queryOnly = null;
		
		objGIACS149.intmNo = null;
		objGIACS149.intmName = null;
		objGIACS149.coIntmType = null;
		objGIACS149.gfunFundCd = null;
		objGIACS149.fund = null;
		objGIACS149.gibrBranchCd = null;
		objGIACS149.branch = null;
		objGIACS149.fromDate = null;
		objGIACS149.toDate = null;
		objGIACS149.fromMainMenu = true;	
		objGIACS149.callingForm = null;
		objGIACS149.reprint = null;
		objGIACS149.voucherNo = null;
		objGIACS149.voucherDate = null;
		objGIACS149.voucherPrefSuf = null;
		objGIACS149.gpcvSelect = [];
		objGIACS149.url = null;
		objGIACS149.selectedCommDue = null;
		objGIACS149.selectedNetCommDue = null;
		objGIACS149.ocvNo = null;
		objGIACS149.ocvPrefSuf = null;
		objGIACS149.checkedVouchers = [];
		objGIACS149.ocvBranch = null;
	}
	
	function setGIACS149Fields(action){
		if(action == "enterQuery"){
			$("txtIntmNo").clear();
			$("txtIntmName").clear();
			$("txtCoIntmType").clear();
			$("txtFundName").clear();
			$("txtFundCd").clear();
			$("txtBranchName").clear();
			$("txtBranchCd").clear();
			$("txtFromDate").clear();
			$("txtToDate").clear();
			
			$("txtIntmNo").readOnly = false;
			$("txtFundName").readOnly = false;
			$("txtBranchName").readOnly = false;
			enableDate("imgFromDate");
			enableDate("imgToDate");
			enableSearch("searchIntmLOV");
			enableSearch("searchFundLOV");
			//enableSearch("searchBranchLOV");
			
			$("txtTaggedTotalPrem").value = formatToNthDecimal(0, 2);
			$("txtTaggedTotalComm").value = formatToNthDecimal(0, 2);
			$("txtGrandTotalPrem").value = formatToNthDecimal(0, 2);
			$("txtGrandTotalComm").value = formatToNthDecimal(0, 2);
			
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			
			disableButton("btnPrintOCV");
			disableButton("btnPrintList");
			disableButton("btnDetails");
			
			$("txtIntmNo").focus();
			
			resetGlobalVars();
			
		}else if(action == "executeQuery"){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			
			$("txtIntmNo").readOnly = true;
			$("txtFundName").readOnly = true;
			$("txtBranchName").readOnly = true;
			disableDate("imgFromDate");
			disableDate("imgToDate");
			disableSearch("searchIntmLOV");
			disableSearch("searchFundLOV");
			//disableSearch("searchBranchLOV");	
			
			/*if(commVoucherTG.geniisysRows.length == 0){
				disableButton("btnPrintOCV");
				disableButton("btnPrintList");
				disableButton("btnDetails");
			}else{*/
				enableButton("btnPrintOCV");
				enableButton("btnPrintList");
				enableButton("btnDetails");
			//}
			
			objGIACS149.intmNo = $F("txtIntmNo");
			objGIACS149.intmName = $F("txtIntmName");
			objGIACS149.coIntmType = $F("txtCoIntmType");
			objGIACS149.gfunFundCd = $F("txtFundCd");
			objGIACS149.fund = $F("txtFundName");
			objGIACS149.gibrBranchCd = $F("txtBranchCd");
			objGIACS149.branch = $F("txtBranchName");
			objGIACS149.fromDate = $F("txtFromDate");
			objGIACS149.toDate = $F("txtToDate");
		}		
	}

	function computeTaggedTotals(cbValue){
		try{
			if (objGIACS149.selectedRow != null && objGIACS149.selectedRow.ocvPrefSuf == null && objGIACS149.selectedRow.ocvNo == null ){
				if (cbValue == "Y"){
					$("txtTaggedTotalPrem").value = formatCurrency(parseFloat(unformatCurrency("txtTaggedTotalPrem")) + parseFloat(objGIACS149.selectedRow.premMinusOthers));
					$("txtTaggedTotalComm").value = formatCurrency(parseFloat(unformatCurrency("txtTaggedTotalComm")) + parseFloat(objGIACS149.selectedRow.netCommAmtDue));
				}else{
					if (parseFloat($F("txtTaggedTotalPrem")) > parseFloat(0) && parseFloat($F("txtTaggedTotalComm")) > parseFloat(0) ){
						$("txtTaggedTotalPrem").value = formatCurrency(parseFloat(unformatCurrency("txtTaggedTotalPrem")) - parseFloat(objGIACS149.selectedRow.premMinusOthers));
						$("txtTaggedTotalComm").value = formatCurrency(parseFloat(unformatCurrency("txtTaggedTotalComm")) - parseFloat(objGIACS149.selectedRow.netCommAmtDue));
					}
				}
			}else{
				var prem = 0;
				var net = 0;
				for (var i=0; i < commVoucherTG.geniisysRows.length; i++){
					if (commVoucherTG.getValueAt(commVoucherTG.getColumnIndex('dspPrintTag'), i) == cbValue){
						
						if (cbValue == "Y"){
							prem = prem + parseFloat(commVoucherTG.geniisysRows[i].premMinusOthers);
							net = net + parseFloat(commVoucherTG.geniisysRows[i].netCommAmtDue);
							$("txtTaggedTotalPrem").value = formatCurrency(prem);
							$("txtTaggedTotalComm").value = formatCurrency(net);
						}else{
							if (parseFloat($F("txtTaggedTotalPrem")) > parseFloat(0)){
								prem = prem - parseFloat(commVoucherTG.geniisysRows[i].premMinusOthers);
								$("txtTaggedTotalPrem").value = formatCurrency(parseFloat(unformatCurrency("txtTaggedTotalPrem")) - parseFloat(commVoucherTG.geniisysRows[i].premMinusOthers));						
							}
							if (parseFloat($F("txtTaggedTotalComm")) > parseFloat(0) ){
								net = net - parseFloat(commVoucherTG.geniisysRows[i].netCommAmtDue);
								$("txtTaggedTotalComm").value = formatCurrency(parseFloat(unformatCurrency("txtTaggedTotalComm")) - parseFloat(commVoucherTG.geniisysRows[i].netCommAmtDue));
							}
						}
					}
				}
			}					
		}catch(e){
			showErrorMessage("computeTaggedTotals", e);
		}
	}
	
	/* added fromDate and toDate to handle queries with date parameters.
	 pol cruz 02.02.2014 SR#661 */
	function computeGrandTotals(){
		try{
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				parameters: {
					action:		"computeGIACS149Totals",
					intmNo:		$F("txtIntmNo"),
					fromDate: 	$F("txtFromDate"),
					toDate: 	$F("txtToDate")
				},
				asynchonous: true,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						$("txtTaggedTotalPrem").value = formatCurrency(json.taggedPrem);
						$("txtTaggedTotalComm").value = formatCurrency(json.taggedComm);
						/*$("txtGrandTotalPrem").value = formatCurrency(json.grandPrem);
						$("txtGrandTotalComm").value = formatCurrency(json.grandComm);	//moved inside tablegrid afterRender */					
					}
				}
			});
		}catch(e){
			showErrorMessage("computeGrandTotals", e);
		}
	}
	
	function showCommVoucherDetails(){
		try{
			$("commVoucherDiv").hide();
			$("commVoucherDetailsMainDiv").show();
			
			$("txtTranDate").focus();
			setCommVoucherDtlFields();
			disableToolbarButton("btnToolbarEnterQuery");
		}catch(e){
			showErrorMessage("showCommVoucherDetails", e);
		}
	}
	
	function setCommVoucherDtlFields(){
		$("txtTranDate").value = objGIACS149.selectedRow == null? "" : dateFormat(objGIACS149.selectedRow.tranDate, 'mm-dd-yyyy');
		$("txtRefNo").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.dspRefNo;
		$("txtTranClass").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.tranClass;
		$("txtIssCd").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.issCd;
		$("txtPremSeqNo").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.premSeqNo;
		$("txtInstNo").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.instNo;
		$("txtCollectionAmt").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.collectionAmt);
		$("txtCommissionAmt").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.commissionAmt);
		$("txtPremiumAmt").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.premMinusOthers);
		$("txtCollectionAmt").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.collectionAmt);
		$("txtInputVat").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.inputVat);
		$("txtTaxAmt").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.taxAmt);
		$("txtWholdingTax").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.withholdingTax);
		$("txtNotarialFee").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.notarialFee);
		$("txtAdvances").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.varAdvances);
		$("txtAdvances").writeAttribute("origAdvances", objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.varAdvances);
		$("txtOtherCharges").value = objGIACS149.selectedRow == null? "" : formatCurrency(objGIACS149.selectedRow.otherCharge);
		$("txtNetCommDue").value = objGIACS149.selectedRow == null? "" :  formatCurrency(objGIACS149.selectedRow.netCommDue);
		$("txtIntmNo2").value = objGIACS149.selectedRow == null? "" : $F("txtIntmNo");
		$("txtIntmName2").value = objGIACS149.selectedRow == null? "" : unescapeHTML2($F("txtIntmName"));
		$("txtAssdName").value = objGIACS149.selectedRow == null? "" : unescapeHTML2(objGIACS149.selectedRow.assdName);
		$("txtChldIntmNo").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.chldIntmNo;
		$("txtChldIntmName").value = objGIACS149.selectedRow == null? "" : objGIACS149.selectedRow.chldIntmName;
		
		/*if(objGIACS149.selectedRow != null && objGIACS149.selectedRow.cancelTag == "Y"){
			//$("txtInputVat").readOnly = true;
			$("txtAdvances").readOnly = true;
		}else{
			//$("txtInputVat").readOnly = false;
			$("txtAdvances").readOnly = false;
		}*/
		
		objGIACS149.selectedCommDue = objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.commissionDue;
		objGIACS149.selectedNetCommDue = objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.netCommDue;
	}
	
	function formExit(){
		objGIACS149.reportFromDate = null;
		objGIACS149.reportToDate = null;
		objGIACS149.reportInclItems = null;
		resetGlobalVars();
		changeTag = 0;
		commVoucherTG.onRemoveRowFocus();
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function savePrintTagChanges(btn, value){
		try{
			for(var i=0; i < commVoucherTG.geniisysRows.length; i++){
				if ((objGIACS149.selectedRow.ocvNo != null && objGIACS149.selectedRow.ocvNo == commVoucherTG.geniisysRows[i].ocvNo) &&
						(objGIACS149.selectedRow.ocvPrefSuf != null && objGIACS149.selectedRow.ocvPrefSuf == commVoucherTG.geniisysRows[i].ocvPrefSuf)){
					commVoucherTG.setValueAt(value, commVoucherTG.getColumnIndex('dspPrintTag'), i);
				}
			}
			
			var objVouchers = commVoucherTG.getModifiedRows();
			var strParams = prepareJsonAsParameter(objVouchers);
			
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				parameters: {
					action:		"updateGIACS149PrintTag",
					vouchers:	strParams,
					fromDate:	$F("txtFromDate"),
					toDate: 	$F("txtToDate"),
					workflowColValue:	null,
				},
				evalScripts: true,
				asynchonous: false,
				onCreate: showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						objGIACS149.checkedVouchers = json;
						cntTagged = json.length;
						
						if (json.length == 0){
							objGIACS149.ocvNo = null;
							objGIACS149.ocvPrefSuf = null;
						}else{
							objGIACS149.ocvNo = json[0].ocvNo;
							objGIACS149.ocvPrefSuf = json[0].ocvPrefSuf;
						}
						
						computeGrandTotals();
						changeTag = 0;
						
						/*if (response.responseText == "SUCCESS"){
							/*if (btn != null){
								showMessageBox("Update Successful.", "S");
							}
														
							computeGrandTotals();
							changeTag = 0;
							
							/*if (btn == "X"){	//exit
								formExit();
								commVoucherTG.onRemoveRowFocus();
							}else if(btn == "S"){	//save
								commVoucherTG._refreshList();
								commVoucherTG.onRemoveRowFocus();
							}else if (btn == "E"){	//enter query
								setGIACS149Fields("enterQuery");
								commVoucherTG.url = contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1";
								commVoucherTG._refreshList();
								commVoucherTG.onRemoveRowFocus();
							}else if(btn == "D"){	//Details button
								tempSelectedRow = objGIACS149.selectedRow;
								commVoucherTG.onRemoveRowFocus();
								commVoucherTG._refreshList();
								showGIACS030();
							}
							
						}*/
					}
				}
			});
		}catch(e){
			showErrorMessage("savePrintTagChanges", e);
		}
	}
	
	var checkedVoucherLength = 0;
	
	function checkOcvNo(){
		var ocvNo = null;
		var ocvPrefSuf = null;
		var nullCount = 0;
		var ocvCount = 0;
		var initial = "Y";
		
		new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
			method: "POST",
			parameters: {
				action:			"getGpcvGIACS149",
				intmNo:			objGIACS149.intmNo,
				printOCV:		"N"
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var json = JSON.parse(response.responseText);
					checkedVoucherLength = json.length;
					
					for(var i=0; i < json.length; i++){
						ocvNo = json[i].ocvNo;
						ocvPrefSuf = json[i].ocvPrefSuf;
						
						if (ocvNo == null){
							nullCount = nullCount + 1;
						}else{
							if (initial == "Y"){
								ocv = ocvPrefSuf + "-" + ocvNo;
								ocvCount = ocvCount + 1;
								initial = "N";
							}else{
								if (ocv != ocvPrefSuf+"-"+ocvNo){
									ocvCount = ocvCount + 1;
								}
							}
						}						
					}
					
					if (nullCount != 0 && ocvCount != 0){
						showMessageBox("Cannot combine unprinted records with printed records.", "E");
						return false;
					}else if(ocvCount > 1){
						showMessageBox("Cannot combine records with different comm voucher numbers.", "E");
						return false;
					}
				}
			}
		});
		/*for(var i=0; i < commVoucherTG.geniisysRows.length; i++){
			if (commVoucherTG.getValueAt(commVoucherTG.getColumnIndex('dspPrintTag', i), i) != "N"){
				ocvNo = commVoucherTG.geniisysRows[i].ocvNo;
				ocvPrefSuf = commVoucherTG.geniisysRows[i].ocvPrefSuf;
				
				if (ocvNo == null){
					nullCount = nullCount + 1;
				}else{
					if (initial == "Y"){
						ocv = ocvPrefSuf + "-" + ocvNo;
						ocvCount = ocvCount + 1;
						initial = "N";
					}else{
						if (ocv != ocvPrefSuf+"-"+ocvNo){
							ocvCount = ocvCount + 1;
						}
					}
				}
			}
		}*/
		return true;
	}
	
	
	function getCVPref(btn){
		try{
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				parameters: {
					action:		"getCvPrefGIACS149",
					gfunFundCd:	objGIACS149.gfunFundCd //objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gfunFundCd
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if (json.length == 0 || json.DOC_PREF_SUF == ""){
							showMessageBox("No data in GIAC_DOC_SEQUENCE for overriding commission voucher.", "E");
							return false;
						}else{
							if(btn == "PRINT_OCV"){
								objGIACS149.ocvBranch = json.BRANCH_CD;
								checkCvSeq(json.DOC_PREF_SUF, "OCV");
							}							
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getCVPref",e);
		}
	}
	
	function checkCvSeq(cvPref, docName){
		try{
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController", {
				method: "POST",
				parameters: {
					action:		"checkCvSeqGIACS149",
					gfunFundCd:	objGIACS149.gfunFundCd, //objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gfunFundCd,
					docName:	docName
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if(json.found == "Y"){
							var ocvNo = null;
							var printDate = null;
							
							for (var i=0; i < commVoucherTG.geniisysRows.length; i++){
								if (commVoucherTG.getValueAt(commVoucherTG.getColumnIndex('dspPrintTag'), i) == "Y"){
									if (nvl(commVoucherTG.geniisysRows[i].ocvNo,0) != 0){
										ocvNo = commVoucherTG.geniisysRows[i].ocvNo;
										printDate = commVoucherTG.geniisysRows[i].printDate;
										break;
									}									
								}	
							}
							
							//if(objGIACS149.selectedRow != null && nvl(objGIACS149.selectedRow.ocvNo,0) != 0)
							if(ocvNo != null && printDate != null){
								objGIACS149.voucherNo = ocvNo;							
								objGIACS149.voucherDate = printDate;								
							}else{
								objGIACS149.voucherNo = json.maxNo;
								objGIACS149.voucherDate = dateFormat(new Date(), "mm-dd-yyyy");
							}
							
							objGIACS149.voucherPrefSuf = cvPref;
						}else{
							objGIACS149.voucherNo = 1;
							objGIACS149.voucherDate = dateFormat(new Date(), "mm-dd-yyyy");
							objGIACS149.voucherPrefSuf = cvPref;
						}						
					}

					updateVat();
				}					
			});
		}catch(e){
			showErrorMessage("checkCvSeq",e);
		}
	}

	function updateVat(){
		try{
			var strParams = prepareJsonAsParameter(objGIACS149.checkedVouchers);
			
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				method: "POST",
				parameters: {
					action:		"updateVatGIACS149",
					checkedVouchers:	strParams
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "SUCCESS"){
							showPrintCommDialog("Print Commission Voucher");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("updateVat", e);
		}
	}
	
	function showPrintCommDialog(title){
		printCommDialog = Overlay.show(contextPath+"/GIACGenearalDisbReportController",{
			urlContent: true,
			urlParameters: { action: "showPrintCommDialog"},
			title:	title,
			height: 300,
			width:	530,
			draggable: true
		});
	}
	
	function showGIACS030(){
		if (tempSelectedRow != null && tempSelectedRow.gaccTranId != null){
			if (tempSelectedRow.tranClass == "JV"){
				objACGlobal.tranSource = "JV";	
			}else if (tempSelectedRow.tranClass == "COL"){
				objACGlobal.tranSource = "OR";	
			}else if (tempSelectedRow.tranClass == "DV"){
				objACGlobal.tranSource = "DV";	
			}
			
			objACGlobal.previousModule = "GIACS149";
			objACGlobal.calledForm = null;
			objACGlobal.callingForm = "ACCT_ENTRIES";
			objACGlobal.gaccTranId = tempSelectedRow.gaccTranId;
			objACGlobal.fundCd = tempSelectedRow.gfunFundCd;
			objACGlobal.branchCd = tempSelectedRow.branchCd;
			objACGlobal.queryOnly = "Y";			
			
			objGIACS149.fromMainMenu = false;
			showORInfoWithAcctEntries();
			$$("div[name='subMenuDiv']").each(function(row){
				row.hide();
			});
			$$("div.tabComponents1 a").each(function(a){
				if(a.id == "acctEntries") {
					$("acctEntries").up("li").addClassName("selectedTab1");					
				}else{
					a.up("li").removeClassName("selectedTab1");	
				}	
			});
		}else if(tempSelectedRow == null){
			showMessageBox("Please select a record first.", "I");
		}
	}
	
	function showIntmLOV(isIconClicked){
		var searchString = isIconClicked ? '%' : ($F("txtIntmNo").trim() == "" ? '%' : $F("txtIntmNo"));
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action: 		"getGIACS149IntmLOV",
				workflowColVal:	objACGlobal.workflowColVal,
				searchString:	searchString
			},
			title: "List of Intermediaries",
			width: 450,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			columnModel: [
				{
					id: 'intmNo',
					title: 'Intm No',
					width: '80px'
				},
				{
					id: 'intmName',
					title: 'Intm Name',
					width: '380px'
				},
				{
					id: 'coIntmType',
					title: 'Co Intm Type',
					width: '40px'
				},
				{
					id: 'issCd',
					width: '0px',
					visible: false
				},
				{
					id: 'issName',
					width: '0px',
					visible: false
				}
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName).toUpperCase();
					$("txtCoIntmType").value = unescapeHTML2(row.coIntmType);
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = unescapeHTML2(row.issName);
					fireEvent($("txtIntmNo"), "keyup");
				}
			},
			onUndefinedRow : function(){
				/*$("txtIntmNo").clear();
				$("txtIntmName").clear();
				$("txtCoIntmType").clear();
				disableToolbarButton("btnToolbarExecuteQuery");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmNo");*/
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmNo");
			},
			onCancel: function(){
				$("txtIntmNo").focus();
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			}
		});
	}
	
	function showFundLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtFundName").trim() == "" ? "%" : $F("txtFundName"));
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action: 	"getGIACS149FundLOV",
				keyword:	$F("txtFundName")
			},
			title: "List of Funds",
			width: 580,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			columnModel: [
				{
					id: 'fundCd',
					title: 'Fund Cd',
					width: '60px'
				},
				{
					id: 'fundDesc',
					title: 'Fund Desc',
					width: '300px'
				} 
				/*{
					id: 'branchCd',
					title: 'Branch Cd',
					width: '60px'
				},
				{
					id: 'branchName',
					title: 'Branch Name',
					width: '140px'
				}*/
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtFundCd").setAttribute("lastValidValue", row.fundCd);
					$("txtFundCd").value = row.fundCd;
					$("txtFundName").value = row.fundCd + " - " + unescapeHTML2(row.fundDesc);
					/*$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = unescapeHTML2(row.branchName);*/
					fireEvent($("txtIntmNo"), "keyup");
					enableToolbarButton("btnToolbarEnterQuery");
				}
			},
			onCancel: function(){
				$("txtFundCd").focus();
				$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				disableToolbarButton("btnToolbarExecuteQuery");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundCd");
			} 
		});
	}
	
	function showBranchLOV(){
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action: 	"getGIACS149BranchLOV",
				keyword:	$F("txtBranchName")
			},
			title: "List of Branches",
			width: 450,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			columnModel: [
				{
					id: 'branchCd',
					title: 'Branch Cd',
					width: '80px'
				},
				{
					id: 'branchName',
					title: 'Branch Name',
					width: '420px'
				}
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchCd + " - " + unescapeHTML2(row.branchName);
					fireEvent($("txtIntmNo"), "keyup");
					enableToolbarButton("btnToolbarEnterQuery");
				}
			},
			onUndefinedRow : function(){
				$("txtBranchCd").clear();
				$("txtBranchName").clear();
				disableToolbarButton("btnToolbarExecuteQuery");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchName");
			},
			onCancel: function(){
				$("txtBranchName").focus();
			}	
		});
	}
	
	
	if (objGIACS149.fromMainMenu == false){
		$("txtIntmNo").value = objGIACS149.intmNo;
		$("txtIntmName").value = objGIACS149.intmName;
		$("txtCoIntmType").value = objGIACS149.coIntmType;	
		$("txtFundCd").value = objGIACS149.gfunFundCd;
		$("txtFundName").value = objGIACS149.fund;	
		$("txtBranchCd").value = objGIACS149.gibrBranchCd;
		$("txtBranchName").value = objGIACS149.branch;
		$("txtFromDate").value = objGIACS149.fromDate;
		$("txtToDate").value = objGIACS149.toDate;
		computeGrandTotals();
		commVoucherTG.url = contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1"+"&intmNo="+$F("txtIntmNo")
		+"&gfunFundCd="+$F("txtFundCd")+"&gibrBranchCd="+$F("txtBranchCd")+"&fromDate="+$F("txtFromDate")
		+"&toDate="+$F("txtToDate");
		
		setGIACS149Fields("executeQuery");
	}
	
	
	
	$("searchIntmLOV").observe("click", function(){
		showIntmLOV(true);
	});
	
	$("txtIntmNo").observe("keyup", function(){
		if($F("txtIntmNo") != "" ){ //&& $F("txtFundCd") != "" && $F("txtBranchCd") != "")
			enableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	
	$("txtIntmNo").observe("change", function(){
		if (this.value == ""){
			$("txtIntmName").clear();
			$("txtCoIntmType").clear();
			$("txtBranchCd").clear();
			$("txtBranchName").clear();
		}else{
			showIntmLOV(false);
		}
		
	});
	
	/*$("txtIntmNo").observe("blur", function(){
		if ($F("txtIntmNo") == ""){
			$("txtIntmName").clear();
			$("txtCoIntmType").clear();
		}
	});*/
	
	$("searchFundLOV").observe("click", function(){
		showFundLOV(true);
	});
	
	$("txtFundName").observe("keyup", function(){
		$("txtFundName").value = $("txtFundName").value.toUpperCase();
	});
	
	/*$("txtFundName").observe("change", function(){
		$("txtFundCd").clear();
		showFundLOV();
	});*/
	
	$("txtFundName").observe("change", function(){
		if($F("txtFundName") == ""){
			$("txtFundCd").clear();	
			/*$("txtBranchCd").clear();
			$("txtBranchName").clear();*/
		}else{
			showFundLOV(false);
		}
	});
	
	/*$("searchBranchLOV").observe("click", showBranchLOV);
	
	$("txtBranchName").observe("keyup", function(){
		$("txtBranchName").value = $("txtBranchName").value.toUpperCase();
	});
	
	$("txtBranchName").observe("change", function(){
		$("txtBranchCd").clear();
		showBranchLOV();
	});*/
	
	$("txtBranchName").observe("blur", function(){
		if($F("txtBranchName") == ""){
			$("txtBranchCd").clear();	
		}
	});
	
	$("txtInputVat").observe("blur", function(){
		if ($F("txtInputVat") == ""){
			$("txtInputVat").value = formatCurrency(0);
		}
	});
	
	/////////////////////////////
	/*var advances = objGIACS149.selectedRow == null ? 0 : objGIACS149.selectedRow.varAdvances;
	
	$("txtAdvances").observe("select", function(){
		advances = $F("txtAdvances");
	});
	
	$("txtAdvances").observe("change", function(){
		if(isNaN(parseFloat($F("txtAdvances").replace(/,/g, "")))){
			$("txtAdvances").value = formatCurrency($("txtAdvances").readAttribute("origAdvances"));
		}else{
			$("txtAdvances").writeAttribute("origAdvances", $F("txtAdvances"));
		}
	});
	
	$("txtAdvances").observe("blur", function(){
		if ($F("txtAdvances") == ""){
			$("txtAdvances").value = formatCurrency(0);
			advances = 0;
		}else{
			if(advances != unformatCurrency("txtAdvances")){
				var netCommDue = parseFloat(objGIACS149.selectedRow.netCommDue) + parseFloat(objGIACS149.selectedRow.varAdvances) 
								 - parseFloat($F("txtAdvances"));
				
				$("txtNetCommDue").value = formatCurrency(netCommDue);
			}
		}
	});*/
	
	$("btnReturn").observe("click", function(){
		if (commVoucherTG.getValueAt(commVoucherTG.getColumnIndex('netCommAmtDue', selectedIndex), selectedIndex) != $F("txtNetCommDue")){
			commVoucherTG.setValueAt($F("txtNetCommDue"), commVoucherTG.getColumnIndex('netCommAmtDue', selectedIndex), selectedIndex);
		}
		
		$("commVoucherDetailsMainDiv").hide();
		$("commVoucherDiv").show();
		enableToolbarButton("btnToolbarEnterQuery");
	});
	
	///////////////////////////////////
	
	$("btnPrintOCV").observe("click", function(){
		/*if(objGIACS149.selectedRow == null){
			showMessageBox("Please select a record first.", "I");
			return false;
		}else {*/
		
			//CHECK_OCV_NO program_unit
			var ocvNo = null;
			var ocvPrefSuf = null;
			var nullCount = 0;
			var ocvCount = 0;
			var initial = "Y";
			
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				method: "POST",
				parameters: {
					action:			"getGpcvGIACS149",
					intmNo:			objGIACS149.intmNo,
					printOCV:		"N"
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						for(var i=0; i < json.length; i++){
							ocvNo = json[i].ocvNo;
							ocvPrefSuf = json[i].ocvPrefSuf;
							
							if (ocvNo == null){
								nullCount = nullCount + 1;
							}else{
								if (initial == "Y"){
									ocv = ocvPrefSuf + "-" + ocvNo;
									ocvCount = ocvCount + 1;
									initial = "N";
								}else{
									if (ocv != ocvPrefSuf+"-"+ocvNo){
										ocvCount = ocvCount + 1;
									}
								}
							}						
						}
						
						if (nullCount != 0 && ocvCount != 0){
							showMessageBox("Cannot combine unprinted records with printed records.", "E");
							return false;
						}else if(ocvCount > 1){
							showMessageBox("Cannot combine records with different comm voucher numbers.", "E");
							return false;
						}
						
						// end CHECK_OCV_NO
						var ocvNoExist = false;
						for ( var i = 0; i < json.length; i++) {
							if (nvl(json[i].ocvNo,null) != null) {
								ocvNoExist = true;
							}else{
								ocvNoExist = false;
								break;
							}
						}
						
						if(json.length == 0){
							showMessageBox("Please check record(s) to print.", "I");
							return false;
						}else{
							if (ocvNoExist /*json.length == 1 && json[0].ocvNo != null && json[0].ocvNo != ""*/) { //added by steven 10.08.2014
								commVoucherTG.keys.releaseKeys();
								objGIACS149.callingForm = "PRINT_OCV";
								getCVPref("PRINT_OCV");
							} else {
								showConfirmBox("Caution", "WARNING! This will update tagged transactions upon printing commission voucher. Do you wish to continue?",
										"Yes", "No",
										function(){
											commVoucherTG.keys.releaseKeys();
											objGIACS149.callingForm = "PRINT_OCV";
											getCVPref("PRINT_OCV");
										},
										null);
							}
						}	
					}
				}
			});			
		//}
	});
	
	$("btnPrintList").observe("click", function(){
		objGIACS149.callingForm = "PRINT_LIST";
		objGIACS149.reportFromDate = $F("txtFromDate"); //added by steven 10.08.2014
		objGIACS149.reportToDate = $F("txtToDate"); //added by steven 10.08.2014
		commVoucherTG.keys.releaseKeys();
		showPrintCommDialog("Print Commission List");	
	});
	
	$("btnDetails").observe("click", function(){
		tempSelectedRow = objGIACS149.selectedRow;
		commVoucherTG.onRemoveRowFocus();
		showGIACS030();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		/*setGIACS149Fields("enterQuery");
		commVoucherTG.url = contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1";
		commVoucherTG._refreshList();*/
		new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
			method: "POST",
			parameters:{
				action:		"countTaggedVouchers",
				intmNo:		$F("txtIntmNo")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if (response.responseText > 0){
						showMessageBox("Please untag transactions first before querying.", "I");
						return false;
					}else{
						setGIACS149Fields("enterQuery");
						commVoucherTG.url = contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1&vUpdate=Y";
						commVoucherTG._refreshList();
						$("txtIntmNo").focus();
					}
				}
			}
		});
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		computeGrandTotals();
		commVoucherTG.url = contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1&vUpdate=N"+"&intmNo="+$F("txtIntmNo")
							+"&gfunFundCd="+$F("txtFundCd")+"&gibrBranchCd="+$F("txtBranchCd")+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate");
		commVoucherTG._refreshList();
		
		if($F("txtFundCd") == ""){
			$("txtFundCd").value = commVoucherTG.geniisysRows.length == 0 ? null : commVoucherTG.geniisysRows[0].gfunFundCd;
			$("txtFundName").value = commVoucherTG.geniisysRows.length == 0 ? null : commVoucherTG.geniisysRows[0].gfunFundCd + " - " + commVoucherTG.geniisysRows[0].fundDesc;
		}
		/*if($F("txtBranchCd") == ""){
			$("txtBranchCd").value = commVoucherTG.geniisysRows.length == 0 ? null : commVoucherTG.geniisysRows[0].gibrBranchCd;
			$("txtBranchName").value = commVoucherTG.geniisysRows.length == 0 ? null : commVoucherTG.geniisysRows[0].gibrBranchCd + " - " + commVoucherTG.geniisysRows[0].branchName;
		}*/
		
		setGIACS149Fields("executeQuery");
		
		if (commVoucherTG.geniisysRows.length == 0){
			showMessageBox("Query caused no records to be retrieved.", "I");
		}
	});		
	
	$("btnToolbarExit").observe("click", function(){
		formExit();
	});
	
	$("txtIntmNo").focus();
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>
