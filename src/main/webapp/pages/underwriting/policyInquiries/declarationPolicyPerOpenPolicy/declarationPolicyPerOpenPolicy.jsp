<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="declarationPolicyPerOpenPolicyMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>View Declaration Policy per Open Policy</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div class="sectionDiv" id="searchPolicyNoDiv" style="height: 120px;">
		<table style="margin: 10px; width:860px;">
			<tr>
				<td class="rightAligned" style="width:110px;">Policy No.</td>
				<td>
					<input type="hidden" id="txtPolicyId" lastValidValue=""  />
					<input type="text" id="txtOpLineCd" class="required" lastValidValue="" style="width:30px;" maxlength="2" tabindex="101" />
					<input type="text" id="txtOpSublineCd" class="" lastValidValue="" style="width:70px;" maxlength="7" tabindex="102" />
					<input type="text" id="txtOpIssCd" class="" lastValidValue="" style="width:30px;" maxlength="2" tabindex="103" />
					<input type="text" id="txtOpIssueYy" class="integerUnformatted" lastValidValue="" lpad="2" style="width:30px; text-align:right;" maxlength="2" tabindex="104" />
					<input type="text" id="txtOpPolSeqNo" class="integerUnformatted" lastValidValue="" lpad="7" style="width:60px; text-align:right;" maxlength="7" tabindex="105" />
					<input type="text" id="txtOpRenewNo" class="integerUnformatted" lastValidValue="" lpad="2" style="width:30px; text-align:right;" maxlength="2" tabindex="106" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osPolicyNo" name="osPolicyNo" style="cursor: pointer;"/>
				</td>
				<td class="rightAligned" style="width:80px;">Incept Date</td>
				<td>
					<div id="inceptDateDiv" style="float: left; width: 100px;" class="withIconDiv">
						<input type="text" id="txtInceptDate" name="txtInceptDate" class="withIcon" readonly="readonly" style="width: 75px;" tabindex="107" /> 
						<img id="hrefInceptDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Incept Date" />
					</div>
				</td>
				<td class="rightAligned" style="width:80px;">Expiry Date</td>
				<td>
					<div id="expiryDateDiv" style="float: right; width: 100px;" class="withIconDiv">
						<input type="text" id="txtExpiryDate" name="txtExpiryDate" class="withIcon" readonly="readonly" style="width: 75px;" tabindex="108" /> 
						<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="5"><input type="text" id="txtAssured" style="width:730px;" readonly="readonly" tabindex="109"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Limit of Liability</td>
				<td colspan="5"><input type="text" id="txtLimitOfLiability" class="money" style="width:155px; text-align:right;" readonly="readonly" tabindex="110"/></td>
				<!-- <td colspan="2"class="rightAligned">Crediting Branch</td>
				<td><input type="text" id="txtCredBranch" style="width:95px; float:right; margin-right:3px;" maxlength="2" readonly="readonly" tabindex="111"/></td> -->
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv">
		<div id="declarationPolicyTableDiv" style="padding-top: 10px;">
			<div id="declarationPolicyTable" style="height: 340px; margin:0 10px 10px 10px;"></div>
		</div>
		<div class="buttonsDiv" style="margin: 0 10px 40px 10px;">
			<input type="button" class="button" id="btnPolicyInformation" value="Policy Information" tabindex="201">
		</div>
	</div>
</div>
<div id="policyInfoDiv"></div>


<script type="text/javascript">
	setModuleId("GIPIS199");
	setDocumentTitle("View Declaration Policy per Open Policy");
	initializeAll();
	initializeAllMoneyFields();
	makeAllInputFieldsUpperCase();
	addStyleToInputs();
	
	function initFields(){
		$("btnToolbarPrint").hide();
		$("txtOpLineCd").focus();
		if(objGIPIS100.callingForm == "GIPIS199"){
			$("txtOpLineCd").value = objGIPIS199.lineCd;
			$("txtOpSublineCd").value = objGIPIS199.opSublineCd;
			$("txtOpIssCd").value = objGIPIS199.opIssCd;
			$("txtOpIssueYy").value = objGIPIS199.opIssueYy;
			$("txtOpPolSeqNo").value = objGIPIS199.opPolSeqNo;
			$("txtOpRenewNo").value = objGIPIS199.opRenewNo;
			fireEvent($("btnToolbarExecuteQuery"), "click");
		} else {
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableButton("btnPolicyInformation");	
			freezeFields(false);
		}
	}
	
	// TOOLBAR BUTTONS
	$("btnToolbarEnterQuery").observe("click", function(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		freezeFields(false); // disable = false		
		populateFields(null, true);
		executeQuery();
		$("txtOpLineCd").focus();
		disableButton("btnPolicyInformation");
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("searchPolicyNoDiv")){
			freezeFields(true); // disable = true		
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			populateFields(objGIPIS199.selectedOp, true);
			disableButton("btnPolicyInformation");
			executeQuery();
		} 
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	});
	
	function populateFields(row, isChild){
		$("txtPolicyId").value = row == null ? "" : row.policyId;
		$("txtOpLineCd").value = row == null ? "" : row.lineCd, 
		$("txtOpSublineCd").value = row == null ? "" : row.opSublineCd, 
		$("txtOpIssCd").value = row == null ? "" : row.opIssCd;
		$("txtOpIssueYy").value = row == null ? "" : formatNumberDigits(row.opIssueYy, 2); 
		$("txtOpPolSeqNo").value = row == null ? "" : formatNumberDigits(row.opPolSeqNo, 7);
		$("txtOpRenewNo").value = row == null ? "" : formatNumberDigits(row.opRenewNo, 2);
		
		if(isChild){ // populate info after execute query
			//$("txtCredBranch").value = row == null ? "" : row.credBranch;
			$("txtInceptDate").value = row == null ? "" : row.inceptDate;
			$("txtExpiryDate").value = row == null ? "" : row.expiryDate;
			$("txtAssured").value = row == null ? "" : unescapeHTML2(row.assdName);
			$("txtLimitOfLiability").value = row == null ? "" : formatCurrency(row.limitLiability);
		}
	}
	
	function executeQuery(){
		tbgOpenPolicy.url = contextPath  + "/GIPIOpenPolicyController?action=viewDeclarationPolicyPerOpenPolicy&refresh=1"
										 + "&lineCd=" 		+ $F("txtOpLineCd")
										 + "&opSublineCd=" 	+ $F("txtOpSublineCd")
										 + "&opIssCd=" 		+ $F("txtOpIssCd")
										 + "&opIssueYy=" 	+ $F("txtOpIssueYy")
										 + "&opPolSeqNo=" 	+ $F("txtOpPolSeqNo")
										 + "&opRenewNo=" 	+ $F("txtOpRenewNo")
										 //+ "&credBranch="	+ $F("txtCredBranch")
										 //+ "&inceptDate="	+ $F("txtInceptDate")
										 //+ "&expiryDate="	+ $F("txtExpiryDate")
										 //+ "&assdName="		+ $F("txtAssured") //commented out by gab 11.29.2016 SR 5855
										 + "&limitLiability="+ unformatCurrencyValue($F("txtLimitOfLiability"));
		tbgOpenPolicy._refreshList();		
	}
	
	function freezeFields(isDisabled){
		isDisabled ? disableSearch("osPolicyNo") : enableSearch("osPolicyNo");
		
		isDisabled ? disableInputField("txtOpLineCd") : enableInputField("txtOpLineCd");
		isDisabled ? disableInputField("txtOpSublineCd") : enableInputField("txtOpSublineCd");
		isDisabled ? disableInputField("txtOpIssCd") : enableInputField("txtOpIssCd");
		isDisabled ? disableInputField("txtOpIssueYy") : enableInputField("txtOpIssueYy");
		isDisabled ? disableInputField("txtOpPolSeqNo") : enableInputField("txtOpPolSeqNo");
		isDisabled ? disableInputField("txtOpRenewNo") : enableInputField("txtOpRenewNo");
		//isDisabled ? disableInputField("txtAssured") : enableInputField("txtAssured");
		//isDisabled ? disableInputField("txtLimitOfLiability") : enableInputField("txtLimitOfLiability");
		// ? disableInputField("txtCredBranch") : enableInputField("txtCredBranch");
		
		isDisabled ? disableDate("hrefInceptDate") : enableDate("hrefInceptDate");
		isDisabled ? disableDate("hrefExpiryDate") : enableDate("hrefExpiryDate");
		
		if(!isDisabled){
			$("txtPolicyId").setAttribute("lastValidValue", "");
			$("txtOpLineCd").setAttribute("lastValidValue", "");
			$("txtOpSublineCd").setAttribute("lastValidValue", "");
			$("txtOpIssCd").setAttribute("lastValidValue", "");
			$("txtOpIssueYy").setAttribute("lastValidValue", "");
			$("txtOpPolSeqNo").setAttribute("lastValidValue", "");
			$("txtOpRenewNo").setAttribute("lastValidValue", "");
		}
	}
	
	initFields();

	var rowIndex = -1;
	var objCurrOpenPolicy = null;
	var objOpenPolicy = {};
	objOpenPolicy.opList = JSON.parse('${jsonOpList}');
	
	var openPolicyTable = {
		url : contextPath + "/GIPIOpenPolicyController?action=viewDeclarationPolicyPerOpenPolicy&refresh=1"
						 + "&lineCd=" 		+ $F("txtOpLineCd")
						 + "&opSublineCd=" 	+ $F("txtOpSublineCd")
						 + "&opIssCd=" 		+ $F("txtOpIssCd")
						 + "&opIssueYy=" 	+ $F("txtOpIssueYy")
						 + "&opPolSeqNo=" 	+ $F("txtOpPolSeqNo")
						 + "&opRenewNo=" 	+ $F("txtOpRenewNo")
						 //+ "&credBranch="	+ $F("txtCredBranch")
						 //+ "&inceptDate="	+ $F("txtInceptDate")
						 //+ "&expiryDate="	+ $F("txtExpiryDate")
						 //+ "&assdName="		+ $F("txtAssured") //commented out by gab 11.29.2016 SR 5855
						 + "&limitLiability="+ unformatCurrencyValue($F("txtLimitOfLiability")),
		options : {
			width : '900px',
			hideColumnChildTitle: true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				objCurrOpenPolicy = tbgOpenPolicy.geniisysRows[y];
				enableButton("btnPolicyInformation");
				tbgOpenPolicy.keys.removeFocus(tbgOpenPolicy.keys._nCurrentFocus, true);
				tbgOpenPolicy.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				disableButton("btnPolicyInformation");
				tbgOpenPolicy.keys.removeFocus(tbgOpenPolicy.keys._nCurrentFocus, true);
				tbgOpenPolicy.keys.releaseKeys();
			},
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					tbgOpenPolicy.keys.removeFocus(tbgOpenPolicy.keys._nCurrentFocus, true);
					tbgOpenPolicy.keys.releaseKeys();
				}
			},
		},
		columnModel : [
			{ 								// this column will only use for deletion
			    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			    width: '0',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},	
			{
				id : "policyNo",
				title : "Policy No",
				width : '170px',
				filterOption: true
			},
			{
				id : 'assdName',
				title: "Assured Name",
				width : '250px',
				filterOption: true
			},
			{
				id : 'credBranch',
				title: "Cred. Branch",
				width : '80px',
				filterOption: true
			},
			{
				id : 'inceptDate',
				title: "Incept Date",
				width : '75px',
				filterOption: true,
				filterOptionType: "formattedDate"
			},
			{
				id : 'expiryDate',
				title: "Expiry Date",
				width : '75px',
				filterOption: true,
				filterOptionType: "formattedDate"
				
			},
			{
				id : 'tsiAmt',
				title: "TSI Amount",
				titleAlign: 'right',
				align: 'right',
				width : '110px',
				filterOption: true,
				filterOptionType: "number",
				geniisysClass: "money",
				renderer: function(value){
					return formatCurrency(value);
				}
			},
			{
				id : 'premAmt',
				title: "Premium",
				titleAlign: 'right',
				align: 'right',
				width : '110px',
				filterOption: true,
				filterOptionType: "number",
				geniisysClass: "money",
				renderer: function(value){
					return formatCurrency(value);
				}				
			}
		],
		rows : objOpenPolicy.opList.rows || []
	};

	tbgOpenPolicy = new MyTableGrid(openPolicyTable);
	tbgOpenPolicy.pager = objOpenPolicy.opList;
	tbgOpenPolicy.render("declarationPolicyTable");
	
	function searchPolicy(){
		if(checkAllRequiredFieldsInDiv("searchPolicyNoDiv")){
			showOpPolicyLOV();
		}
	}
	
	function showOpPolicyLOV(){
		var filterPolicyNo = ($("txtOpLineCd").readAttribute("lastValidValue").trim() != $F("txtOpLineCd").trim() ? $F("txtOpLineCd").trim() : "") + "-" +
							 ($("txtOpSublineCd").readAttribute("lastValidValue").trim() != $F("txtOpSublineCd").trim() ? $F("txtOpSublineCd").trim() : "") + "-" +
							 ($("txtOpIssCd").readAttribute("lastValidValue").trim() != $F("txtOpIssCd").trim() ? $F("txtOpIssCd").trim() : "") + "-" +
							 ($("txtOpIssueYy").readAttribute("lastValidValue").trim() != $F("txtOpIssueYy").trim() ? $F("txtOpIssueYy").trim() : "") + "-" +
							 ($("txtOpPolSeqNo").readAttribute("lastValidValue").trim() != $F("txtOpPolSeqNo").trim() ? $F("txtOpPolSeqNo").trim() : "") + "-" +
							 ($("txtOpRenewNo").readAttribute("lastValidValue").trim() != $F("txtOpRenewNo").trim() ? $F("txtOpRenewNo").trim() : "");
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action 		: "getOpPolicyLOV",
							moduleId	: "GIPIS199",
							filterText  : ($("txtOpLineCd").readAttribute("lastValidValue").trim() != $F("txtOpLineCd").trim() ? filterPolicyNo : ""),
							//filterText  : ($("txtOpLineCd").readAttribute("lastValidValue").trim() != $F("txtOpLineCd").trim() ? $F("txtOpLineCd").trim() : "%"),
							lineCd 		: ($("txtOpLineCd").readAttribute("lastValidValue").trim() != $F("txtOpLineCd").trim() ? $F("txtOpLineCd").trim() : ""),
							opSublineCd : ($("txtOpSublineCd").readAttribute("lastValidValue").trim() != $F("txtOpSublineCd").trim() ? $F("txtOpSublineCd").trim() : ""),
							opIssCd		: ($("txtOpIssCd").readAttribute("lastValidValue").trim() != $F("txtOpIssCd").trim() ? $F("txtOpIssCd").trim() : ""),
							opIssueYy 	: ($("txtOpIssueYy").readAttribute("lastValidValue").trim() != $F("txtOpIssueYy").trim() ? $F("txtOpIssueYy").trim() : ""),
							opPolSeqNo 	: ($("txtOpPolSeqNo").readAttribute("lastValidValue").trim() != $F("txtOpPolSeqNo").trim() ? $F("txtOpPolSeqNo").trim() : ""),
							opRenewNo 	: ($("txtOpRenewNo").readAttribute("lastValidValue").trim() != $F("txtOpRenewNo").trim() ? $F("txtOpRenewNo").trim() : ""),
							inceptDate	: $F("txtInceptDate").trim(),
							expiryDate	: $F("txtExpiryDate").trim(),
							page 		: 1},
			title: "List of Open Policies",
			width: 470,
			height: 400,
			hideColumnChildTitle: true,
			columnModel : [ {
								id: 'policyId',
								width : '0px',
								visible: false								
							},{
								id : 'lineCd opSublineCd opIssCd opIssueYy opPolSeqNo opRenewNo',
								title: 'Policy No.',
								width: 400,
								filterOption: true,
								sortable: true,
								children: [
												{
													id: 'lineCd',
													title: 'Line Cd',
													width: 60/* ,
													filterOption: true */
												},{
													id: 'opSublineCd',
													title: 'Subline Cd',
													width: 100,	
													filterOption: true
												},{
													id: 'opIssCd',
													title: 'Issue Cd',
													width: 60,
													filterOption: true
												},{
													id: 'opIssueYy',
													title: 'Issue Yr',
													width: 40,
													align: 'right',
													filterOption: true,
													filterOptionType: 'number',
													renderer: function(value){
														return formatNumberDigits(value, 2);
													}													
												},{
													id: 'opPolSeqNo',
													title: 'Pol Seq No.',
													width: 90,
													align: 'right',
													filterOption: true,
													filterOptionType: 'number',
													renderer: function(value){
														return formatNumberDigits(value, 7);
													}
												},{
													id: 'opRenewNo',
													title: 'Renew No.',
													width: 40,
													align: 'right',
													filterOption: true,
													filterOptionType: 'number',
													renderer: function(value){
														return formatNumberDigits(value, 2);
													}					
												}
								]
							},{
								id: 'inceptDate',
								width: '0px',
								visible: false
							},{
								id: 'expiryDate',
								width: '0px',
								visible: false
							},{
								id: 'assdNo',
								width: '0px',
								visible: false
							},{
								id: 'assdName',
								width: '0px',
								visible: false
							},{
								id: 'limitLiability',
								width: '0px',
								visible: false
							},{
								id: 'credBranch',
								width: '0px',
								visible: false
							}],
				autoSelectOneRecord: true,
				filterVersion: "2",
				filterText  : ($("txtOpLineCd").readAttribute("lastValidValue").trim() != $F("txtOpLineCd").trim() ? filterPolicyNo : ""),
				//filterText  : ($("txtOpLineCd").readAttribute("lastValidValue").trim() != $F("txtOpLineCd").trim() ? $F("txtOpLineCd").trim() : "%"),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					//populateFields(row, false);
					objGIPIS199.selectedOp = row;
					populateFields(objGIPIS199.selectedOp, true);
					$("txtPolicyId").setAttribute("lastValidValue", row.policyId);
					$("txtOpLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtOpSublineCd").setAttribute("lastValidValue", row.opSublineCd);
					$("txtOpIssCd").setAttribute("lastValidValue", row.opIssCd);
					$("txtOpIssueYy").setAttribute("lastValidValue", formatNumberDigits(row.opIssueYy, 2));
					$("txtOpPolSeqNo").setAttribute("lastValidValue", formatNumberDigits(row.opPolSeqNo, 7));
					$("txtOpRenewNo").setAttribute("lastValidValue", formatNumberDigits(row.opRenewNo, 2));
				},
				onCancel: function (){
					$("txtPolicyId").value = $("txtPolicyId").readAttribute("lastValidValue");
					$("txtOpLineCd").value = $("txtOpLineCd").readAttribute("lastValidValue");
					$("txtOpSublineCd").value = $("txtOpSublineCd").readAttribute("lastValidValue");
					$("txtOpIssCd").value = $("txtOpIssCd").readAttribute("lastValidValue");
					$("txtOpIssueYy").value = $("txtOpIssueYy").readAttribute("lastValidValue");
					$("txtOpPolSeqNo").value = $("txtOpPolSeqNo").readAttribute("lastValidValue");
					$("txtOpRenewNo").value = $("txtOpRenewNo").readAttribute("lastValidValue");
					$("txtInceptDate").value = "";
					$("txtExpiryDate").value = "";
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPolicyId").value = $("txtPolicyId").readAttribute("lastValidValue");
					$("txtOpLineCd").value = $("txtOpLineCd").readAttribute("lastValidValue");
					$("txtOpSublineCd").value = $("txtOpSublineCd").readAttribute("lastValidValue");
					$("txtOpIssCd").value = $("txtOpIssCd").readAttribute("lastValidValue");
					$("txtOpIssueYy").value = $("txtOpIssueYy").readAttribute("lastValidValue");
					$("txtOpPolSeqNo").value = $("txtOpPolSeqNo").readAttribute("lastValidValue");
					$("txtOpRenewNo").value = $("txtOpRenewNo").readAttribute("lastValidValue");
					$("txtInceptDate").value = "";
					$("txtExpiryDate").value = "";
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}

	observeReloadForm("reloadForm", function(){
		objGIPIS199 = {};
		objGIPIS100.callingForm = "GIPIS000";
		showViewDeclarationPolicyPerOpenPolicy();
	});
	
	$("txtOpLineCd").observe("change", function() {		
		if($F("txtOpLineCd").trim() != "" && $F("txtOpLineCd") != $("txtOpLineCd").readAttribute("lastValidValue")   && $("txtOpLineCd").readAttribute("lastValidValue") != ""    ) {
			searchPolicy();
		}
	});
	$("txtOpSublineCd").observe("change", function() {		
		if($F("txtOpSublineCd").trim() != "" && $F("txtOpSublineCd") != $("txtOpSublineCd").readAttribute("lastValidValue") && $("txtOpSublineCd").readAttribute("lastValidValue") != "") {
			searchPolicy();
		}
	});
	$("txtOpIssCd").observe("change", function() {		
		if($F("txtOpIssCd").trim() != "" && $F("txtOpIssCd") != $("txtOpIssCd").readAttribute("lastValidValue") && $("txtOpIssCd").readAttribute("lastValidValue") != "") {
			searchPolicy();
		}
	});
	$("txtOpIssueYy").observe("change", function() {		
		if($F("txtOpIssueYy").trim() != "" && $F("txtOpIssueYy") != $("txtOpIssueYy").readAttribute("lastValidValue") && $("txtOpIssueYy").readAttribute("lastValidValue") != "") {
			searchPolicy();
		}
	});
	$("txtOpPolSeqNo").observe("change", function() {		
		if($F("txtOpPolSeqNo").trim() != "" && $F("txtOpPolSeqNo") != $("txtOpPolSeqNo").readAttribute("lastValidValue") && $("txtOpPolSeqNo").readAttribute("lastValidValue") != "") {
			searchPolicy();
		}
	});
	$("txtOpRenewNo").observe("change", function() {		
		if($F("txtOpRenewNo").trim() != "" && $F("txtOpRenewNo") != $("txtOpRenewNo").readAttribute("lastValidValue") ) {
			searchPolicy();
		}
	});	
	
	
	$("txtLimitOfLiability").observe("change", function(){
		$("txtLimitOfLiability").value = formatCurrency($F("txtLimitOfLiability"));
	});
	
	$("osPolicyNo").observe("click", searchPolicy);
	
	$("hrefInceptDate").observe("click", function() {
		scwNextAction = function(){
							checkInputDates("txtInceptDate");
						}.runsAfterSCW(this, null);
		scwShow($('txtInceptDate'), this, null);
	});
	$("hrefExpiryDate").observe("click", function() {
		scwNextAction = function(){
							checkInputDates("txtExpiryDate");
						}.runsAfterSCW(this, null);
		scwShow($('txtExpiryDate'), this, null);
	});
	
	$("btnPolicyInformation").observe("click", function(){
		if(objCurrOpenPolicy != null){
			objGIPIS199.policyId = objCurrOpenPolicy.policyId;
			objGIPIS199.lineCd = $F("txtOpLineCd");
			objGIPIS199.opSublineCd = $F("txtOpSublineCd");
			objGIPIS199.opIssCd = $F("txtOpIssCd");
			objGIPIS199.opIssueYy = $F("txtOpIssueYy");
			objGIPIS199.opPolSeqNo = $F("txtOpPolSeqNo");
			objGIPIS199.opRenewNo = $F("txtOpRenewNo");
			objGIPIS100.callingForm = "GIPIS199";
			showViewPolicyInformationPage(objCurrOpenPolicy.policyId);	
			$("declarationPolicyPerOpenPolicyMainDiv").hide();
		} else {
			showMessageBox("Please select a record first.", "I");
		}
	});
	
	function checkInputDates(currentFieldId){
		if ($F("txtInceptDate") != "" && $F("txtExpiryDate") != ""){
			if(compareDatesIgnoreTime(Date.parse($F("txtInceptDate")), Date.parse($F("txtExpiryDate"))) == -1){
				$(currentFieldId).value = "";
				showWaitingMessageBox("Incept Date should not be later than Expiry Date.", "I", 
						function(){
							$(currentFieldId).focus();
						}
					);
			}
		}
	}
</script>