<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Policy Listing per Motor Type</label>
   		<span class="refreshers" style="margin-top: 0;">
	 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
		</span>
   	</div>
</div>
<div id="perMotorTypeParamDiv" class="sectionDiv" style="height: 108px;">
	<div style="margin-left: 15px; width: 429px; float: left;">
		<table style="margin-top: 6px;">
			<tr>
				<td class="rightAligned">Motor Type</td>
				<td>
					<div id="motorTypeDiv" class="sectionDiv required" style="float: left; width: 300px; height: 19px; margin-top: 2px; border: 1px solid gray;">
						<input id="motorType" title="Motor Type" type="text" class="required upper" maxlength="20" style="float: left; height: 12px; width: 274px; margin: 0px; border: none;" lastValidValue="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="motorTypeLOV" name="motorTypeLOV" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline</td>
				<td>
					<div id="sublineCdDiv" class="sectionDiv required" style="float: left; width: 300px; height: 19px; margin-top: 2px; border: 1px solid gray;">
						<input id="sublineCd" title="Subline Code" type="text" class="required upper" maxlength="7" style="float: left; height: 12px; width: 274px; margin: 0px; border: none;" lastValidValue="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sublineCdLOV" name="sublineCdLOV" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Crediting Branch</td>
				<td>
					<input type="text" id="credBranch" title="Crediting Branch" readonly="readonly"/> 
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="margin: 10px 0px 0px 0px; width: 465px; height: 88px;">
		<table style="margin-top: 4px; margin-left: 20px;">
			<tr>
				<td width="90px">Search By:</td>
				<td width="130px">
					<input type="radio" id="inceptDate" name="nbtDateType" style="float: left;" checked="checked"/>
					<label for="inceptDate" style="margin-top: 2px;">Incept Date</label>
				</td>
				<td width="53px">
					<input type="radio" id="asOf" name="date" style="float: left;" checked="checked"/>
					<label for="asOf" style="margin-top: 2px;">As of</label>
				</td>
				<td>
					<div id="asOfDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none; height: 13px;" name="asOfDate" id="asOfDate" readonly="readonly"/>
						<img id="imgAsOf" alt="" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>						
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="radio" id="effDate" name="nbtDateType" style="float: left;"/>
					<label for="effDate" style="margin-top: 2px;">Effectivity Date</label>
				</td>
				<td>
					<input type="radio" id="fromToDate" name="date" style="float: left;"/>
					<label for="fromToDate" style="margin-top: 2px;">From</label>
				</td>
				<td>
					<div id="fromDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none; height: 13px;" name="fromDate" id="fromDate" readonly="readonly"/>
						<img id="imgFrom" alt="" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>						
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="radio" id="issueDate" name="nbtDateType" style="float: left;"/>
					<label for="issueDate" style="margin-top: 2px;">Issue Date</label>
				</td>
				<td>
					<label style="margin-top: 2px; margin-left: 36px;">To</label>
				</td>
				<td>
					<div id="toDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none; height: 13px;" name="toDate" id="toDate" readonly="readonly"/>
						<img id="imgTo" alt="" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>						
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="perMotorTypeDiv" class="sectionDiv" style="margin-bottom: 25px;">
	<div id="perMotorTypeTGDiv" style="margin: 10px 0px 0px 10px; width: 900px; height: 329px;">
		
	</div>
	<div id="totalDiv" style="margin-top: 5px; margin-right: 11px; float: right;">
		<label style="margin-top: 6px; margin-right: 5px; ">Total</label>
		<input type="text" id="sumTsiAmt" style="width: 136px; text-align: right;" readonly="readonly"/>
		<input type="text" id="sumPremAmt" style="width: 136px; text-align: right;" readonly="readonly"/>
	</div>
	<div id="formDiv" class="sectionDiv" style="width: 898px; margin: 10px 0px 10px 10px;">
		<table>
			<tr>
				<td class="rightAligned">Policy No.</td>
				<td colspan="3">
					<input type="text" id="txtPolicyNo" name="detail" readonly="readonly" style="width: 596px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="3">
					<input type="text" id="txtAssured" name="detail" readonly="readonly" style="width: 596px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="180px">Inception Date</td>
				<td>
					<input type="text" id="txtInceptDate" name="detail" readonly="readonly" style="width: 200px;"/>
				</td>
				<td class="rightAligned" width="180px">Expiry Date</td>
				<td>
					<input type="text" id="txtExpiryDate" name="detail" readonly="readonly" style="width: 200px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Effectivity Date</td>
				<td>
					<input type="text" id="txtEffDate" name="detail" readonly="readonly" style="width: 200px;"/>
				</td>
				<td class="rightAligned">Issue Date</td>
				<td>
					<input type="text" id="txtIssueDate" name="detail" readonly="readonly" style="width: 200px;"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="float: left; margin-bottom: 10px;">
		<input type="button" class="button" id="btnPrintReport" value="Print Report" style="margin-left: 400px; width: 120px;"/>
	</div>
</div>
<div>
	<input type="hidden" id="hidMotType" />
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIPIS194");
	setDocumentTitle("Policy Listing per Motor Type");
	var query = false;
	
	try{
		var objGIPIS194 = new Object();
		objGIPIS194.objPerMotorTypeTableGrid = JSON.parse('${json}');
		objGIPIS194.objPerMotorType = objGIPIS194.objPerMotorTypeTableGrid.rows || []; 
		
		var perMotorTypeModel = {
			url:contextPath+"/GIPIVehicleController?action=showPolListingPerMotorType&refresh=1",
			options:{
				width: '900px',
				height: '306px',
				onCellFocus: function(element, value, x, y, id){
					var obj = perMotorTypeTableGrid.geniisysRows[y];
					populateDetails(obj);
					
					perMotorTypeTableGrid.keys.removeFocus(perMotorTypeTableGrid.keys._nCurrentFocus, true);
					perMotorTypeTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					populateDetails(null);
					
					perMotorTypeTableGrid.keys.removeFocus(perMotorTypeTableGrid.keys._nCurrentFocus, true);
					perMotorTypeTableGrid.keys.releaseKeys();
				},
				prePager: function(){
					populateDetails(null);
					perMotorTypeTableGrid.keys.removeFocus(perMotorTypeTableGrid.keys._nCurrentFocus, true);
					perMotorTypeTableGrid.keys.releaseKeys();
				},
				onSort: function(){
					populateDetails(null);
					perMotorTypeTableGrid.keys.removeFocus(perMotorTypeTableGrid.keys._nCurrentFocus, true);
					perMotorTypeTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						populateDetails(null);
						perMotorTypeTableGrid.keys.removeFocus(perMotorTypeTableGrid.keys._nCurrentFocus, true);
						perMotorTypeTableGrid.keys.releaseKeys();
					},
					onFilter: function() {
						populateDetails(null);
						perMotorTypeTableGrid.keys.removeFocus(perMotorTypeTableGrid.keys._nCurrentFocus, true);
						perMotorTypeTableGrid.keys.releaseKeys();
					},
				},
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'itemNo',
					title: 'Item No.',
					titleAlign: 'right',
					align: 'right',
					width: '90px',
					visible: true,
					filterOption: true
				},
				{	id: 'itemTitle',
					title: 'Item Title',
					width: '200px',
					visible: true,
					filterOption: true
				},
				{	id: 'plateNo',
					title: 'Plate No.',
					width: '100px',
					visible: true,
					filterOption: true
				},
				{	id: 'motorNo',
					title: 'Engine No.',
					width: '110px',
					visible: true,
					filterOption: true
				},
				{	id: 'serialNo',
					title: 'Serial No.',
					width: '100px',
					visible: true,
					filterOption: true
				},
				{	id: 'tsiAmt',
					title: 'TSI Amount',
					width: '140px',
					titleAlign: 'right',
					align: 'right',
					visible: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{	id: 'premAmt',
					title: 'Premium Amount',
					width: '140px',
					titleAlign: 'right',
					align: 'right',
					visible: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
			],
			rows: objGIPIS194.objPerMotorType
		};
		
		perMotorTypeTableGrid = new MyTableGrid(perMotorTypeModel);
		perMotorTypeTableGrid.pager = objGIPIS194.objPerMotorTypeTableGrid;
		perMotorTypeTableGrid.render('perMotorTypeTGDiv');
		perMotorTypeTableGrid.afterRender = function(){
			try{
				if(perMotorTypeTableGrid.geniisysRows.length > 0){
					$("sumTsiAmt").value = formatCurrency(perMotorTypeTableGrid.geniisysRows[0].sumTsiAmt);	
					$("sumPremAmt").value = formatCurrency(perMotorTypeTableGrid.geniisysRows[0].sumPremAmt);
				}else{
					$("sumTsiAmt").value = formatCurrency(0);	
					$("sumPremAmt").value = formatCurrency(0);
				}
			}catch(e){
				showErrorMessage("perMotorTypeTableGrid.afterRender", e);
			}
		};
	}catch(e){
		showErrorMessage("perMotorTypeTableGrid",e);
	}
	
	function executeQuery(){
		try{
			if($("asOf").checked){
				if($F("asOfDate") == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, "I", "asOfDate");
					return false;
				}
			}
			if($("fromToDate").checked){
				if($F("fromDate") == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, "I", "fromDate");
					return false;
				}else if($F("toDate") == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, "I", "toDate");
					return false;
				}
			}
			
			query = true;
			
			perMotorTypeTableGrid.url = contextPath+"/GIPIVehicleController?action=showPolListingPerMotorType&refresh=1&moduleId=GIPIS194&motType="+$F("hidMotType")+"&sublineCd="+$F("sublineCd")
					+"&asOfDate="+$F("asOfDate")+"&fromDate="+$F("fromDate")+"&toDate="+$F("toDate")+"&dateType="
					+($("inceptDate").checked ? "1" : $("effDate").checked ? "2" : "3");	

			perMotorTypeTableGrid._refreshList();
			
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			
			disableSearch("motorTypeLOV");
			disableSearch("sublineCdLOV");
			$("motorType").setAttribute("readonly", "readonly");
			$("sublineCd").setAttribute("readonly", "readonly");
			
			$("asOfDate").addClassName("disabled");
			$("asOfDiv").addClassName("disabled");
			disableDate("imgAsOf");
			$("fromDate").addClassName("disabled");
			$("fromDiv").addClassName("disabled");
			disableDate("imgFrom");
			$("toDate").addClassName("disabled");
			$("toDiv").addClassName("disabled");
			disableDate("imgTo");
			
			$("inceptDate").disabled = true;
			$("effDate").disabled = true;
			$("issueDate").disabled = true;
			
			$("asOf").disabled = true;
			$("fromToDate").disabled = true;
			
			if(perMotorTypeTableGrid.geniisysRows.length == 0){
				customShowMessageBox("Query caused no record to be retrieved. Re-enter.", "I", "motorType");
			}
		}catch(e){
			showErrorMessage("btnToolbarExecuteQuery", e);
		}
	}	
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if($F("motorType") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "motorType");
		}else if($F("sublineCd") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "sublineCd");
		}else{
			executeQuery();	
		}
	});
	
	function enterQuery(){
		$$("input[type='text']").each(function(a){
			$(a.id).clear();
		});
		$("motorType").removeAttribute("readonly");
		$("sublineCd").removeAttribute("readonly");
		
		$("inceptDate").disabled = false;
		$("effDate").disabled = false;
		$("issueDate").disabled = false;
		$("inceptDate").checked = true;
		
		$("asOf").disabled = false;
		$("fromToDate").disabled = false;
		
		enableSearch("motorTypeLOV");
		enableSearch("sublineCdLOV");
		
		$("motorType").focus();
		
		if($("asOf").checked){
			setDateProperty("asOf");
		}else{
			setDateProperty("fromTo");
		}
		
		query = false;
		
		perMotorTypeTableGrid.url = contextPath+"/GIPIVehicleController?action=showPolListingPerMotorType&refresh=1";	
		perMotorTypeTableGrid._refreshList();
		
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	
	function executeQueryFromDateType(){
		if($F("asOfDate") == "" || $F("fromDate") == "" || $F("toDate") == ""){
			//$("asOf").checked = true;
			//$("asOfDate").value = new Date().toString('MM-dd-yyyy');
		}
		if(query){
			executeQuery();	
		}
		$$("input[name='detail']").each(function(a){
			$(a.id).clear();
		});
	}
	
	$("inceptDate").observe("click", executeQueryFromDateType);
	$("effDate").observe("click", executeQueryFromDateType);
	$("issueDate").observe("click", executeQueryFromDateType);
	
	function populateDetails(obj){
		$("credBranch").value = obj == null ? null : obj.credBranch;
		$("txtPolicyNo").value = obj == null ? null : obj.policyNo;
		$("txtAssured").value = obj == null ? null : unescapeHTML2(obj.assured);
		$("txtInceptDate").value = obj == null ? null : dateFormat(obj.inceptDate, 'mm-dd-yyyy');
		$("txtEffDate").value = obj == null ? null : dateFormat(obj.effDate, 'mm-dd-yyyy');
		$("txtExpiryDate").value = obj == null ? null : dateFormat(obj.expiryDate, 'mm-dd-yyyy');
		$("txtIssueDate").value = obj == null ? null : dateFormat(obj.issueDate, 'mm-dd-yyyy');
		
		obj == null ? disableButton("btnPrintReport") : enableButton("btnPrintReport");
		obj == null ? disableToolbarButton("btnToolbarPrint") : enableToolbarButton("btnToolbarPrint");
	}
	
	function showGIPIS194MotorTypeLOV(fieldId){	// added param : shan 07.10.2014
		var text = $(fieldId).readAttribute("lastValidValue").trim() != $F(fieldId).trim() ? $F(fieldId).trim() : "";	
	
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIPIS194MotorTypeLOV",
							filterText : text // changed by shan 07.10.2014 : ($("motorType").readAttribute("lastValidValue").trim() != $F("motorType").trim() ? $F("motorType").trim() : ""),
							},
			title: "List of Motor Types",
			width : 370,
			height : 386,
			columnModel : [
							{
								id : "motorTypeDesc",
								title: "Motor Type",
								width: '100px',
								filterOption: true,
								renderer: function(value) {	// shan 07.10.2014
									return unescapeHTML2(value);
								}
							},
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '255px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : text, // changed by shan 07.10.2014 : ($("motorType").readAttribute("lastValidValue").trim() != $F("motorType").trim() ? $F("motorType").trim() : ""),
				onSelect: function(row) {
					$("motorType").value = unescapeHTML2(row.motorTypeDesc);
					$("sublineCd").value = unescapeHTML2(row.sublineCd);
					$("hidMotType").value = row.motType;
					$("motorType").setAttribute("lastValidValue", $F("motorType"));	// shan 07.10.2014
					$("sublineCd").setAttribute("lastValidValue", $F("sublineCd"));	// shan 07.10.2014
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel: function (){
					$("motorType").value = $("motorType").readAttribute("lastValidValue");
					$("sublineCd").value = $("sublineCd").readAttribute("lastValidValue");	// shan 07.10.2014
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("motorType").value = $("motorType").readAttribute("lastValidValue");
					$("sublineCd").value = $("sublineCd").readAttribute("lastValidValue");	// shan 07.10.2014
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("motorTypeLOV").observe("click", function(){	// changed by shan 07.10.2014
		showGIPIS194MotorTypeLOV("motorType");
	});
	$("sublineCdLOV").observe("click", function(){	// changed by shan 07.10.2014
		showGIPIS194MotorTypeLOV("sublineCd");
	});
	
	function showGIPIS194SublineCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIPIS194SublineCdLOV",
							motorType : $F("motorType"),
							filterText : ($("motorType").readAttribute("lastValidValue").trim() != $F("motorType").trim() ? $F("motorType").trim() : ""),
							},
			title: "Subline Code",
			width : 370,
			height : 386,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '255px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("motorType").readAttribute("lastValidValue").trim() != $F("motorType").trim() ? $F("motorType").trim() : ""),
				onSelect: function(row) {
					$("sublineCd").value = row.sublineCd;
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel: function (){
					$("motorType").value = $("motorType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("motorType").value = $("motorType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	//$("motorTypeLOV").observe("click", showGIPIS194MotorTypeLOV);	// shan 07.10.2014
	
	$("imgAsOf").observe("click", function(){
		scwShow($("asOfDate"),this, null);
	});
	$("imgFrom").observe("click", function(){
		scwShow($("fromDate"),this, null);
	});
	$("imgTo").observe("click", function(){
		scwShow($("toDate"),this, null);
	});
	
	$("fromDate").observe("focus", function(){
		var from = Date.parse($F("fromDate"));
		var to = Date.parse($F("toDate"));
		
		if(!$F("toDate") == "" && !$F("fromDate") == ""){
			if(to < from){
				customShowMessageBox("From Date should not be later than To Date.", "I", "fromDate");
				$("fromDate").clear();
			}
		}
	});
	
	$("toDate").observe("focus", function(){
		var from = Date.parse($F("fromDate"));
		var to = Date.parse($F("toDate"));
		
		if(!$F("toDate") == "" && !$F("fromDate") == ""){
			if(to < from){
				customShowMessageBox("From Date should not be later than To Date.", "I", "toDate");
				$("toDate").clear();
			}
		}
	});
	
	$("asOf").observe("click", function(){
		$("asOfDate").value = new Date().toString('MM-dd-yyyy');
		$("fromDate").clear();
		$("toDate").clear();
		setDateProperty("asOf");
	});
	
	$("fromToDate").observe("click", function(){
		$("asOfDate").clear();
		$("fromDate").focus();
		setDateProperty("fromTo");
	});
	
	$("motorType").observe("change", function() {		
		if($F("motorType").trim() == "") {
			$("motorType").setAttribute("lastValidValue", "");
			$("sublineCd").clear();
			$("sublineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("motorType").trim() != "" && $F("motorType") != $("motorType").readAttribute("lastValidValue")) {
				showGIPIS194MotorTypeLOV("motorType");
			}
		}
	});
	
	$("sublineCd").observe("change", function() {		
		if($F("sublineCd").trim() == "") {
			$("sublineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("sublineCd").trim() != "" && $F("sublineCd") != $("sublineCd").readAttribute("lastValidValue")) {
				showGIPIS194MotorTypeLOV("sublineCd");
			}
		}
	});
	
	function whenNewFormInstance(){
		$("sumTsiAmt").value = formatCurrency(0);	
		$("sumPremAmt").value = formatCurrency(0);
		$("asOfDate").value = new Date().toString('MM-dd-yyyy');
		disableButton("btnPrintReport");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		$("motorType").focus();
		setDateProperty("asOf");
	}
	
	function setDateProperty(date){
		if(date == "asOf"){
			$("asOfDate").removeClassName("disabled");
			$("asOfDiv").removeClassName("disabled");
			enableDate("imgAsOf");
			$("asOfDate").addClassName("required");
			$("asOfDiv").addClassName("required");
			
			$("fromDate").addClassName("disabled");
			$("fromDiv").addClassName("disabled");
			disableDate("imgFrom");
			$("toDate").addClassName("disabled");
			$("toDiv").addClassName("disabled");
			disableDate("imgTo");
			$("fromDate").removeClassName("required");
			$("fromDiv").removeClassName("required");
			$("toDate").removeClassName("required");
			$("toDiv").removeClassName("required");
		}else{
			$("asOfDate").addClassName("disabled");
			$("asOfDiv").addClassName("disabled");
			disableDate("imgAsOf");
			$("asOfDate").removeClassName("required");
			$("asOfDiv").removeClassName("required");
			
			$("fromDate").removeClassName("disabled");
			$("fromDiv").removeClassName("disabled");
			enableDate("imgFrom");
			
			$("fromDate").removeClassName("disabled");
			$("fromDiv").removeClassName("disabled");
			enableDate("imgFrom");
			$("toDate").removeClassName("disabled");
			$("toDiv").removeClassName("disabled");
			enableDate("imgTo");
			$("fromDate").addClassName("required");
			$("fromDiv").addClassName("required");
			$("toDate").addClassName("required");
			$("toDiv").addClassName("required");
		}
	}
	
	function showPrintDialog(){
		showGenericPrintDialog("Policy Listing per Motor Type", printReport, "", true);
		$("csvOptionDiv").show(); //added by Alejandro Burgos 02.04.2016
	}
	
	$("btnPrintReport").observe("click", showPrintDialog);
	$("btnToolbarPrint").observe("click", showPrintDialog);
	
	function printReport(){
		try {
			var content = contextPath + "/PolicyInquiryPrintController?action=printGIPIR194&reportId=GIPIR194&motType=" + $F("hidMotType") + "&sublineCd=" + $F("sublineCd");
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Policy Listing per Motor Type");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
								  printerName : $F("selPrinter")
								 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF"; //Added by Carlo Rubenecia SR-5326 06.22.2016 --START
				if($("rdoPdf").checked){
					fileType = "PDF";
				} else if ($("rdoCsv").checked){
					fileType = "CSV"; 
				}//Added by Carlo Rubenecia SR-5326 06.22.2016 --end
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  //fileType : $("rdoPdf").checked ? "PDF" : "XLS"}, removed by Carlo Rubenecia 06.22.2016 SR 5326
								  fileType    : fileType},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV"){  //Added by Carlo Rubenecia SR-5326 06.22.2016 --START
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							} else { //Added by Carlo Rubenecia SR-5326 06.22.2016 --END
								copyFileToLocal(response);
							}					
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
			
		} catch (e){
			showErrorMessage("GIACS108 printReport", e);
		}
	}
	
	makeInputFieldUpperCase();
	whenNewFormInstance();
	observeReloadForm("reloadForm", showPolListingPerMotorType);
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
	});
}catch(e){
	showErrorMessage("showPolListingPerMotorType", e);	
}
</script>
