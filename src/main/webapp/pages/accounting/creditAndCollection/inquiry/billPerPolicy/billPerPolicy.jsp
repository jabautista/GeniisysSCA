<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="billPerPolicyMainDiv" name="billPerPolicyMainDiv" style="height: 805px;">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Bill Inquiry per Policy</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		   		<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="billPerPolicyFormDiv">
		<table cellspacing="0" align="center" style="padding: 20px; width: 900px;">
			<tr>
				<td class="rightAligned" style="width:90px;">Policy No.</td>
				<td class="leftAligned" style="border: none; width:410px;">
					<input class="polNoReq allCaps required" type="text" id="txtPolLineCd" name="txtPolLineCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="101" />
					<input class="polNoReq allCaps" type="text" id="txtPolSublineCd" name="txtPolSublineCd" style="width: 80px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="102" />
					<input class="polNoReq allCaps" type="text" id="txtPolIssCd" name="txtPolIssCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="103" />
					<input class="polNoReq integerUnformatted" lpad="2" type="text" id="txtPolIssueYy" name="txtPolIssueYy" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="104" />
					<input class="polNoReq integerUnformatted" lpad="7" type="text" id="txtPolSeqNo" name="txtPolSeqNo" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="105" />
					<input class="polNoReq integerUnformatted" lpad="2" type="text" id="txtPolRenewNo" name="txtPolRenewNo" style="width: 30px; float: left;" maxlength="3" tabindex="106" />
					<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sPolicyNo" name="sPolicyNo" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
					</span>
				</td>
				<td class="rightAligned" style="width:100px;">Reference No</td>
				<td class="leftAligned"><input class="rightAligned" type="text" id="txtRefNo" name="txtRefNo" style="width: 208px; float: left; margin: 2px 4px 0 0" maxlength="30" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="4" class="leftAligned">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtAssuredNo" name="txtAssuredNo" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey integerNoNegativeUnformattedNoComma rightAligned" maxlength="12" tabindex="107" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredNo" name="searchAssuredNo" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan" style="border: none; width: 581px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtAssuredName" name="txtAssuredName" style="width: 650px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="500" readonly="readonly" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Intermediary</td>
				<td colspan="4" class="leftAligned">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtIntmNo" name="txtIntmNo" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey integerNoNegativeUnformattedNoComma rightAligned" maxlength="12" tabindex="108" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan" style="border: none; width: 581px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtIntmName" name="txtIntmName" style="width: 650px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="500" readonly="readonly" />
					</span>	
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div id="tableBillPerPolicy" style="padding: 5px; height: 260px;">
			<div id="tableBillPerPolicyDiv" style="height: 100%;"></div>
		</div>
		<div>
			<fieldset class="sectionDiv" style="width:880px; margin:20px; margin-top: 0;">
				<legend style="font-weight: bold; font-size: 11px;">Totals</legend>
				<div id="totalsDiv" class="" style="padding:20px;">
					<table>
						<tr>
							<td class="rightAligned" style="width:80px;">Prem OS</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPremOS" name="txtPremOS" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned" style="width:100px;">Comm Paid</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtCommPaid" name="txtCommPaid" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned" style="width:100px;">Receivable</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtReceivable" name="txtReceivable" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned" style="width:100px;">Input VAT</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtInputVAT" name="txtInputVAT" style="width:100px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Prem Paid</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPremPaid" name="txtPremPaid" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned">Premium</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPremium" name="txtPremium" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned">Commission</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtCommission" name="txtCommission" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned">Net Comm</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtNetComm" name="txtNetComm" style="width:100px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Comm OS</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtCommOS" name="txtCommOS" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned">Taxes</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtTaxes" name="txtTaxes" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned">Withholding</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtWithholding" name="txtWithholding" style="width:100px;" value="0.00" readonly="readonly"></td>
							<td class="rightAligned">Net Receivable</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtNetReceivable" name="txtNetReceivable" style="width:100px;" value="0.00" readonly="readonly"></td>
						</tr>						
					</table>
				</div>
			</fieldset>
		</div>
		<table style="float: left; margin-left: 20px; margin-bottom: 10px;">
			<tr>
				<td>
					<input type="checkbox" name="chkZeroPrem" id="chkZeroPrem" value="">
				</td>
				<td>
					<label for="chkZeroPrem">Exclude Zero OS Premiums</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" name="chkZeroPremAndComm" id="chkZeroPremAndComm" value="" >
				</td>
				<td>
					<label for="chkZeroPremAndComm">Exclude Zero OS Premiums and Commissions</label>
				</td>
			</tr>
		</table>
		<table style="float: left; margin-bottom: 10px; margin-left: 20px;" align="center">
			<tr>
				<td>
					<input type="button" class="button" id="btnPremPaymts" value="Premium Payments" tabindex="401" style="width: 150px;"/>
				</td><td>
					<input type="button" class="button" id="btnCommPaymts" value="Commission Payments" tabindex="402" style="width: 150px;"/>
				</td>
			</tr>
		</table>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setModuleId("GIACS289");
	setDocumentTitle("Bill Inquiry per Policy");
	resetForm();
	
	var jsonBillPerPolicy = JSON.parse('${jsonTbgBillPerPolicy}');
	var premSeqNo = "";
	var exec = false;
	
	function showTableGrid(){
		try {
			billPerPolicyTableModel = {
				url : contextPath+ "/GIACInquiryController?action=showBillPerPolicy",
				id: "billPerPolicyTable",
				options : {
					height : '250px',
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						tbgBillPerPolicy.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tbgBillPerPolicy.keys.releaseKeys();
					},
					onSort : function(){
						tbgBillPerPolicy.keys.releaseKeys();
					},
					postPager : function() {
						tbgBillPerPolicy.keys.releaseKeys();
					},
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function(){
							tbgBillPerPolicy.keys.releaseKeys();
						},
						onRefresh : function(){
							tbgBillPerPolicy.keys.releaseKeys();
						}
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "endtNo",
						title : "Endorsement No",
						width : '120px',
						children : [ {
							id : 'endtIssCd',
							title : 'Endt Iss Cd',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'endtYy',
							title : 'Endt Year',
							width : 30,
							align : "right",
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							editable : false,
							renderer : function(value) {
						    	return lpad(value,2,0);
						    }
						},
						{
							id : 'endtSeqNo',
							title : 'Endt Seq No',
							align : "right",
							width : 60,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							editable : false
						} ]
					}, 
					{
						id : "billNo",
						title : "Bill No",
						width : '110px',
						children : [ {
							id : 'tbgIssCd',
							title : 'Iss Cd',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'premSeqNo',
							title : 'Prem Seq No',
							align : "right",
							width : 80,
							filterOption : true,
							filterOptionType: 'number',
							editable : false,
							renderer : function(value) {
						    	return lpad(value,12,0);
						    }
						} ]
					},
					{
						id : "premOs",
						title : "Premium OS",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "premPaid",
						title : "Prem Paid",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "commOs",
						title : "Comm OS",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "commPaid",
						title : "Comm Paid",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "premAmt",
						title : "Premium",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "taxAmt",
						title : "Taxes",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "receivable",
						title : "Receivable",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "comm",
						title : "Commission",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "wTax",
						title : "Withholding",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "iVat",
						title : "Input VAT",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "netComm",
						title : "Net Comm",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "netRecv",
						title : "Net Receivable",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "premOsTot",
						width: '0',
					    visible: false
					},
					{
						id : "premPaidTot",
						width: '0',
					    visible: false
					},
					{
						id : "commOsTot",
						width: '0',
					    visible: false
					},
					{
						id : "commPaidTot",
						width: '0',
					    visible: false
					},
					{
						id : "premAmtTot",
						width: '0',
					    visible: false
					},
					{
						id : "taxAmtTot",
						width: '0',
					    visible: false
					},
					{
						id : "receivableTot",
						width: '0',
					    visible: false
					},
					{
						id : "commTot",
						width: '0',
					    visible: false
					},
					{
						id : "wTaxTot",
						width: '0',
					    visible: false
					},
					{
						id : "iVatTot",
						width: '0',
					    visible: false
					},
					{
						id : "netCommTot",
						width: '0',
					    visible: false
					},
					{
						id : "netRecvTot",
						width: '0',
					    visible: false
					},
				],
				rows : []
			};
			tbgBillPerPolicy = new MyTableGrid(billPerPolicyTableModel);
			//tbgBillPerPolicy.pager = jsonBillPerPolicy;
			tbgBillPerPolicy.render('tableBillPerPolicyDiv');
		} catch (e) {
			showErrorMessage("billPerPolicy.jsp", e);
		}
	}
	
	function showBillPerPolicyLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "showBillPerPolicyLOV",
								 lineCd	  : $("txtPolLineCd").value,
								 sublineCd: $("txtPolSublineCd").value,
								 issCd    : $("txtPolIssCd").value,
								 issueYy  : $("txtPolIssueYy").value,
								 polSeqNo : $("txtPolSeqNo").value,
								 renewNo  : $("txtPolRenewNo").value,
								 intmNo   : $("txtIntmNo").value,
								 assdNo	  : $("txtAssuredNo").value,
								 moduleId : "GIACS289"
				},
				title: "List of Policy Number",
				width: 820, //SR19537 Lara 07/13/2015 
				height: 390,
				hideColumnChildTitle : true,
				columnModel: [
		 			{
						id : 'policyId',
						title: 'Policy ID',
						align: 'right',
						titleAlign : 'center',
						children : [ {
							id : 'lineCd',
							title : 'Line Code',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'sublineCd',
							title : 'Subline Code',
							width : 50,
							filterOption : true,
							editable : false
						}, {
							id : 'issCd',
							title : 'Issue Issue Code',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'issueYy',
							title : 'Issue Year',
							type : 'number',
							align : 'right',
							width : 30,
							filterOption : true,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
							editable : false
						}, {
							id : 'polSeqNo',
							title : 'Policy Sequence No.',
							type : 'number',
							align : 'right',
							width : 60,
							filterOption : true,
							renderer : function(value) {
								return formatNumberDigits(value, 7);
							},
							editable : false
						},{
							id : 'renewNo',
							title : 'Renew No',
							type : 'number',
							align : 'right',
							width : 30,
							filterOption : true,
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
							editable : false
						} ]
					},
					{
						id : 'intmName',
						title: 'Intermediary',
						width : '220px',
						align: 'left'
					},
					{
						id : 'assdName',
						title: 'Assured',
					    width: '200px', //SR19537 Lara 07/13/2015 
					    align: 'left'
					},                  //SR19537 Lara 07/13/2015 
					{                  
						id : 'refPolNo',
						title: 'Reference No.',
						align : 'left',
						width : '140px', //end SR19537
					}
				],
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtPolLineCd").value = unescapeHTML2(row.lineCd);
						$("txtPolSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtPolIssCd").value = unescapeHTML2(row.issCd);
						$("txtPolIssueYy").value = formatNumberDigits(row.issueYy,2);
						$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo,7);
						$("txtPolRenewNo").value = formatNumberDigits(row.renewNo,2);
						$("txtRefNo").value = unescapeHTML2(row.refPolNo);
						$("txtAssuredNo").value = unescapeHTML2(row.assdNo);
						$("txtAssuredName").value = unescapeHTML2(row.assdName);
						$("txtIntmNo").value = unescapeHTML2(row.intmNo);
						$("txtIntmName").value = unescapeHTML2(row.intmName);
						setFieldsToReadOnly(true);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtPolLineCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showBillPerPolicyLOV",e);
		}
	}
	
	function showAssuredLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action   : "getGiacAssdNameLOV",
					moduleId : "GIACS289",
					//findText : $("txtAssuredNo").value,
						page : 1
				},
				title: "Search Assured Name",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'assdNo',
						title: 'Assured No',
						width : '85px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'assuredName',
						title: 'Assured Name',
					    width: '335px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord : true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtAssuredNo").value = unescapeHTML2(row.assdNo);
						$("txtAssuredName").value =  unescapeHTML2(row.assuredName); 
					}
				},
				onCancel: function(){
		  			$("txtAssuredNo").focus();
		  			$("txtAssuredName").clear();
		  		}
			});
		}catch(e){
			showErrorMessage("showAssuredLOV",e);
		}
	}
	
	$("searchAssuredNo").observe("click",function(){
		if(isNaN($("txtAssuredNo").value)){
			customShowMessageBox("Enter valid Assured No.", "I", "txtAssuredNo");
		}
		else {
			showAssuredLOV();
		}
	});
	
	function showIntermediaryLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action   : "getGiacIntmNameLOV",
					moduleId : "GIACS289",
					//findText : $("txtIntmNo").value,
						page : 1
				},
				title: "Search Intermediary",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'intmNo',
						title: 'Intermediary No.',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'intmName',
						title: 'Intermediary Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtIntmNo").value = unescapeHTML2(row.intmNo);
						$("txtIntmName").value = unescapeHTML2(row.intmName); 
					}
				},
				onCancel: function(){
					$("txtIntmNo").focus();
					$("txtIntmName").clear();
		  		}
			});
		}catch(e){
			showErrorMessage("showIntermediaryLOV",e);
		}
	}
	
	function setFieldsToReadOnly(sw){
		$("txtPolLineCd").readOnly = sw;
		$("txtPolSublineCd").readOnly = sw;
		$("txtPolIssCd").readOnly = sw;
		$("txtPolIssueYy").readOnly = sw;
		$("txtPolSeqNo").readOnly = sw;
		$("txtPolRenewNo").readOnly = sw;
		$("txtAssuredNo").readOnly = sw;
		$("txtIntmNo").readOnly = sw;
		if(sw){
			disableSearch("sPolicyNo");
			disableSearch("searchAssuredNo");
			disableSearch("searchIntmNo");
		}
		else{
			enableSearch("sPolicyNo");
			enableSearch("searchAssuredNo");
			enableSearch("searchIntmNo");
		}
	}
	
	function resetForm(){
		$$("input[type='text']").each(function(x){
			x.clear();
		});
		setFieldsToReadOnly(false);
		disableButton("btnPremPaymts");
		disableButton("btnCommPaymts");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		showTableGrid();
		$$("div#totalsDiv input[type='text']").each(function(a){
			$(a).value = "0.00";
		});
		$$("input[type='checkbox']").each(function(a){
			$(a).disable();
			$(a).checked = false;
		});
		$("txtPolLineCd").focus();
	}
	
	function queryTable(str){
		tbgBillPerPolicy.url = contextPath +"/GIACInquiryController?action=showBillPerPolicy&refresh=1&lineCd="+$F("txtPolLineCd")+"&sublineCd="+$F("txtPolSublineCd")+
				"&issCd="+$F("txtPolIssCd")+"&issueYy="+$F("txtPolIssueYy")+"&polSeqNo="+$F("txtPolSeqNo")+"&renewNo="+$F("txtPolRenewNo")+"&intmNo="+$F("txtIntmNo")+str;
		tbgBillPerPolicy._refreshList();
		
		populateTotal(tbgBillPerPolicy.geniisysRows);
	}
	//edited by MarkS 04.25.2016 SR-22136
	function populateTotal(obj){
		try{
			var totPremOS = 0;
			var totCommPaid = 0;
			var totReceivable = 0;
			var totIVat = 0;
			var totPremPaid = 0;
			var totPrem = 0;
			var totComm = 0;
			var totNetComm = 0;
			var totCommOS = 0;
			var totTaxes = 0;
			var totWtax = 0;
			var totNetRecv = 0;
			if (obj[0] != null && obj[0] !== undefined){
				$("txtPremOS").value 		= formatCurrency(nvl(obj[0].premOsTot, 0));
				$("txtCommPaid").value 		= formatCurrency(nvl(obj[0].commPaidTot, 0));
				$("txtReceivable").value 	= formatCurrency(nvl(obj[0].receivableTot, 0));
				$("txtInputVAT").value 		= formatCurrency(nvl(obj[0].iVatTot,0));
				$("txtPremPaid").value 		= formatCurrency(nvl(obj[0].premPaidTot, 0));
				$("txtPremium").value		= formatCurrency(nvl(obj[0].premAmtTot, 0));
				$("txtCommission").value 	= formatCurrency(nvl(obj[0].commTot, 0));
				$("txtNetComm").value 		= formatCurrency(nvl(obj[0].netCommTot,0));
				$("txtCommOS").value  		= formatCurrency(nvl(obj[0].commOsTot, 0));
				$("txtTaxes").value 	 	= formatCurrency(nvl(obj[0].taxAmtTot, 0));
				$("txtWithholding").value  	= formatCurrency(nvl(obj[0].wTaxTot, 0));
				$("txtNetReceivable").value	= formatCurrency(nvl(obj[0].netRecvTot, 0));
			}
			
		} catch(e) {
			showErrorMessage("populateTotal", e);
		}
	}
	//end SR-22136
	
	function showPaymentsOverlay(action,title,height,width) {
		try {
			overlayPayments = Overlay.show(contextPath
					+ "/GIACInquiryController", {
				urlContent : true,
				urlParameters : {
					action : action,
					ajax : "1",
					lineCd: $F("txtPolLineCd") ,
					sublineCd: $F("txtPolSublineCd") ,
					issCd: $F("txtPolIssCd"),
					issueYy: $F("txtPolIssueYy"),
					polSeqNo: $F("txtPolSeqNo"),
					renewNo: $F("txtPolRenewNo"),
					premSeqNo: premSeqNo,
					intmNo:		$F("txtIntmNo")	// shan 11.24.2014
					},
				title : title,
				 height: height,
				 width: width,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	$("reloadForm").observe("click", function(){
		if(!exec){
			resetForm();
		}
		else{
			resetForm();
		}
	});
	$("btnToolbarEnterQuery").observe("click", resetForm);
	$("btnToolbarExecuteQuery").observe("click", function(){
		exec = true;
		queryTable("");
		$$("input[type='checkbox']").each(function(a){
			$(a).enable();
		});
		tbgBillPerPolicy.geniisysRows.length > 0 ? premSeqNo = tbgBillPerPolicy.geniisysRows[0].premSeqNo : premSeqNo = "";
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnPremPaymts");
		enableButton("btnCommPaymts");
	});
	
	//Policy Number Validations
	$("txtPolSublineCd").observe("change", function(event){
		if (trim($("txtPolLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			$("txtPolSublineCd").value = '';
		}
	});
	
	$("txtPolIssCd").observe("change", function(event){
		if(trim($("txtPolLineCd").value) == ""){
			$("txtPolIssCd").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
		}			
	});
	
	$("txtPolIssueYy").observe("change", function(event){
		if(trim($("txtPolLineCd").value) == ""){
			$("txtPolIssueYy").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
		}			
	});
	
	$("txtPolSeqNo").observe("change", function(event){
		if(trim($("txtPolLineCd").value) == ""){
			$("txtPolSeqNo").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
		}			
	});
	
	$("txtPolRenewNo").observe("change", function(event){
		if(trim($("txtPolLineCd").value) == ""){
			$("txtPolRenewNo").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
		}			
	});
	
	
	$("sPolicyNo").observe("click", function() {
		if(trim($("txtPolLineCd").value) == ""){
			$("txtPolLineCd").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");	
			return false;
		}
		showBillPerPolicyLOV();
	});	
	
	$("searchIntmNo").observe("click",function(){
		if(isNaN($("txtIntmNo").value)){
			customShowMessageBox("Enter valid Intermediary No.", "I", "txtIntmNo");
		}
		else {
			showIntermediaryLOV();
		}
	});
	
	$("txtAssuredNo").observe("change",function(){
		if($("txtAssuredNo").value == ""){
			$("txtAssuredName").clear();
		}
	});
	
	$("txtIntmNo").observe("change",function(){
		if($("txtIntmNo").value == ""){
			$("txtIntmName").clear();
		}
	});
	
	$$("div#billPerPolicyFormDiv input[type='text']").each(function(a){
		$(a).observe("change",function(){
			if($(a).value != ""){
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});
	
	$("chkZeroPrem").observe("click",function(){
		if($("chkZeroPremAndComm").checked == true){
			$("chkZeroPremAndComm").checked = false;
		}
		if($("chkZeroPrem").checked && $("chkZeroPremAndComm").checked == false){
			var str = "&premOsCheck=0";
			queryTable(str);
		}
		else if($("chkZeroPrem").checked == false && $("chkZeroPremAndComm").checked)  {
			return false;
		}
		else if($("chkZeroPrem").checked == false && $("chkZeroPremAndComm").checked == false) {
			queryTable("");
		}
	});
	
	$("chkZeroPremAndComm").observe("click",function(){
		if($("chkZeroPrem").checked == true){
			$("chkZeroPrem").checked = false;
		}
		if($("chkZeroPremAndComm").checked && $("chkZeroPrem").checked == false){
			var str = "&premAndCommOsCheck=0";
			queryTable(str);
		}
		else if($("chkZeroPremAndComm").checked == false && $("chkZeroPrem").checked)  {
			return false;
		}
		else if($("chkZeroPremAndComm").checked == false && $("chkZeroPrem").checked == false) {
			queryTable("");
		}
	});
	
	$("btnToolbarExit").observe("click",function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	$("btnPremPaymts").observe("click",function(){
		showPaymentsOverlay("showPremPayments","Premium Payments",300,600);
	});
	$("btnCommPaymts").observe("click",function(){
		showPaymentsOverlay("showCommPayments","Commission Payments",300,800);
	});
	
</script>