<div id="viewMotorCarInquiryMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Motor Car Item Inquiry</label>
	   	</div>
	</div>
	<div class="sectionDiv" style="height: 93px;">
		<div class="sectionDiv" id="inquiryParams" align="left" style="border-color: rgb(168,168,168); height: 70px; width: 898px; margin: 10px;">
			<table style="margin-left: 17px; margin-top: 6px;">
				<tr>
					<td class="rightAligned">Crediting Branch</td>
					<td class="leftAligned" colspan="7">
						<input type="text" id="txtCreditingBranch" name="txtCreditingBranch" class="upper" style="width: 115px;" tabindex="200"/>
					</td>
					<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoAsOf" style="float: left;" tabindex="201"/><label for="rdoAsOf" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 140px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="202"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" onClick="scwShow($('txtAsOf'),this, null);" tabindex="203"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Search By:</td>
					<td>
						<input type="radio" id="rdoInceptDate" name="rdoSearchBy" value="1" tabindex="204"/>
					</td>
					<td>
						<label for="rdoInceptDate">Incept Date</label>
					</td>
					<td>
						<input type="radio" id="rdoIssueDate" name="rdoSearchBy" value="3" tabindex="205" />
					</td>
					<td>
						<label for="rdoIssueDate">Issue Date</label>
					</td>
					<td>
						<input type="radio" id="rdoEffDate" name="rdoSearchBy" value="2" tabindex="206" />
					</td>
					<td>
						<label for="rdoEffDate">Effectivity Date</label>
					</td>
					<td style="width: 80px;"></td>
					<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoFrom" title="From" style="float: left;" tabindex="207"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 140px;" class="withIconDiv" id="divFrom">
							<input type="text" name="fromTo" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="109"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('txtFrom'),this, null);" tabindex="208"/>
						</div>
					</td>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 140px" class="withIconDiv" id="divTo">
							<input type="text" name="fromTo" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="111"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('txtTo'),this, null);" tabindex="209"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>		
	
	<div class="sectionDiv" style="height: 645px;">
		<div id="motorCarInquiryTable" style="height: 320px; margin: 10px; margin-bottom: 30px;"></div>
		<div>
			<table align="center">
				<tr>
					<td class="rightAligned">Assignee</td>
					<td class="leftAligned">
						<input type="text" id="txtAssignee" name="txtAssignee" class="upper" style="width: 280px;" readonly="readonly" tabindex="210"/>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">Acquired From</td>
					<td class="leftAligned">
						<input type="text" id="txtAcquiredFrom" name="txtAcquiredFrom" class="upper" style="width: 280px;" readonly="readonly" tabindex="211"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Type Of Body</td>
					<td class="leftAligned">
						<input type="text" id="txtTypeOfBody" name="txtTypeOfBody" class="upper" style="width: 280px;" readonly="readonly" tabindex="212"/>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">Subline Type</td>
					<td class="leftAligned">
						<input type="text" id="txtSublineType" name="txtSublineType" class="upper" style="width: 280px;" readonly="readonly" tabindex="213"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Basic Color</td>
					<td class="leftAligned">
						<input type="text" id="txtBasicColor" name="txtBasicColor" class="upper" style="width: 280px;" readonly="readonly" tabindex="214"/>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">Color</td>
					<td class="leftAligned">
						<input type="text" id="txtColor" name="txtColor" class="upper" style="width: 280px;" readonly="readonly" tabindex="215"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">MV File</td>
					<td class="leftAligned">
						<input type="text" id="txtMvFile" name="txtMvFile" class="upper" style="width: 280px;" readonly="readonly" tabindex="216"/>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">COC Serial No.</td>
					<td class="leftAligned">
						<input type="text" id="txtCocSerialNo" name="txtCocSerialNo" class="upper" style="width: 280px; text-align: right;" readonly="readonly" tabindex="217"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Motor Type</td>
					<td class="leftAligned">
						<input type="text" id="txtMotorType" name="txtMotorType" class="upper" style="width: 280px;" readonly="readonly" tabindex="218"/>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">Car Company</td>
					<td class="leftAligned">
						<input type="text" id="txtCarCompany" name="txtCarCompany" class="upper" style="width: 280px;" readonly="readonly" tabindex="219"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Incept Date</td>
					<td class="leftAligned">
						<input type="text" id="txtInceptDate" name="txtInceptDate" class="upper" style="width: 280px;" readonly="readonly" tabindex="220"/>
					</td>
					<td class="rightAligned" style="padding-left: 60px;">Issue Date</td>
					<td class="leftAligned">
						<input type="text" id="txtIssueDate" name=""txtIssueDate"" class="upper" style="width: 280px;" readonly="readonly" tabindex="221"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Effectivity Date</td>
					<td class="leftAligned" colspan="3">
						<input type="text" id="txtEffectivityDate" name="txtEffectivityDate" class="upper" style="width: 280px;" readonly="readonly" tabindex="222"/>
					</td>
				</tr>
			</table>
		</div>
	
		<div style="float: left; width: 100%; margin-bottom: 10px; margin-top: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnPolicyInformation" value="Policy Information" tabindex="223"/>
		</div>	
	</div>	
</div>
	
<script>
	setModuleId("GIPIS116");
	setDocumentTitle("Motor Car Item Inquiry");
	initializeAll();
	makeInputFieldUpperCase();
	var searchBy = 1;
	$("rdoInceptDate").checked = true;
	$("rdoAsOf").checked = true;
	$("txtAsOf").value = getCurrentDate();
	var objMotorList = [];
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableFromToFields();
	objGIPIS116 = new Object();
	allowQuery = false;
	creditingBranch = "";
	
	function disableFromToFields() {
		$("txtAsOf").disabled = false;
		$("imgAsOf").disabled = false;
		$("txtFrom").disabled = true;
		$("txtTo").disabled = true;
		$("imgFrom").disabled = true;
		$("imgTo").disabled = true;
		$("txtFrom").value = "";
		$("txtTo").value = "";
		$("rdoAsOf").checked = true;
		$("txtAsOf").value = getCurrentDate();
		disableDate("imgFrom");
		disableDate("imgTo");
		enableDate("imgAsOf");
		$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOf").setStyle({backgroundColor: 'white'});
		$("divAsOf").setStyle({backgroundColor: 'white'});
	}
	function disableAsOfFields() {
		$("txtFrom").disabled = false;
		$("imgFrom").disabled = false;
		$("imgTo").disabled = false;
		$("txtTo").disabled = false;
		$("txtAsOf").disabled = true;
		$("imgAsOf").disabled = true;
		$("txtAsOf").value = "";
		$("rdoFrom").checked = true;
		disableDate("imgAsOf");
		enableDate("imgFrom");
		enableDate("imgTo");
		$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
		$("divFrom").setStyle({backgroundColor: '#FFFACD'});
		$("txtTo").setStyle({backgroundColor: '#FFFACD'});
		$("divTo").setStyle({backgroundColor: '#FFFACD'});
		$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
	}

	function disableFields() {
		$("txtAsOf").disabled = true;
		$("imgAsOf").disabled = true;
		$("txtFrom").disabled = true;
		$("txtTo").disabled = true;
		$("imgFrom").disabled = true;
		$("imgTo").disabled = true;
		disableDate("imgFrom");
		disableDate("imgTo");
		disableDate("imgAsOf");
		$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("rdoAsOf").disabled = true;
		$("rdoFrom").disabled = true;
		$("txtCreditingBranch").readOnly = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
	}

	var jsonMotorTable = JSON.parse('${jsonMotorTable}');
	motorInquiryTableModel = {
			url: contextPath+"/GIPIPolbasicController?action=getMotorCarInquiryRecords",	
			options: {
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '900px',
				height: '308px',
				onCellFocus : function(element, value, x, y, id) {
					objMotorList = tbgViewMotorInquiry.geniisysRows[y];
					tbgViewMotorInquiry.keys.removeFocus(tbgViewMotorInquiry.keys._nCurrentFocus, true);
					tbgViewMotorInquiry.keys.releaseKeys();
					populateFields(objMotorList);
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgViewMotorInquiry.keys.removeFocus(tbgViewMotorInquiry.keys._nCurrentFocus, true);
					tbgViewMotorInquiry.keys.releaseKeys();
					populateFields(null);
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
					id: 'plateNo',
					title : 'Plate No.',
					width : "150px",
					filterOption : true
				},
				{
					id: 'modelYear',
					title: 'Model Year',
					width: "115px",
					filterOption : true,
					align: "right",
					titleAlign: "right"
				},
				{
					id: 'make',
					title : 'Make',
					width: "150px",
					filterOption: true
				},
				{
					id: 'dspEngineSeries',
					title : 'Engine Series',
					width: "150px",
					filterOption: true
				}
				,
				{
					id: 'serialNo',
					title : 'Serial No.',
					width: "150px",
					filterOption: true
				}
				,
				{
					id: 'motorNo',
					title : 'Motor No.',
					width: "150px",
					filterOption: true
				}
				
			],
			rows: jsonMotorTable.rows
		};
	
	tbgViewMotorInquiry = new MyTableGrid(motorInquiryTableModel);
	tbgViewMotorInquiry.pager = jsonMotorTable;
	tbgViewMotorInquiry.render('motorCarInquiryTable');
	tbgViewMotorInquiry.afterRender = function() {
		populateFields(null);
	};

	function queryRecords(credBranch){
			tbgViewMotorInquiry.url = contextPath+"/GIPIPolbasicController?action=getMotorCarInquiryRecords&refresh=1&searchBy="+ searchBy + 
			"&credBranch=" + credBranch +
			"&asOfDate=" + $F("txtAsOf")+
			"&fromDate=" + $F("txtFrom")+
			"&toDate=" + $F("txtTo");
			tbgViewMotorInquiry._refreshList();
			enableToolbarButton("btnToolbarEnterQuery");
		 	if(tbgViewMotorInquiry.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}
	}

	function populateFields(obj){
		try {
			$("txtAssignee").value = obj == null ? "" : unescapeHTML2(obj.assignee);
			$("txtAcquiredFrom").value = obj == null ? "" : unescapeHTML2(obj.acquiredFrom);
			$("txtTypeOfBody").value = obj == null ? "" : unescapeHTML2(obj.dspTypeOfBody);
			$("txtSublineType").value = obj == null ? "" :unescapeHTML2(obj.dspSublineType);
			$("txtBasicColor").value = obj == null ? "" : unescapeHTML2(obj.dspBasicColor);
			$("txtColor").value = obj == null ? "" : unescapeHTML2(obj.color);
			$("txtMvFile").value = obj == null ? "" : unescapeHTML2(obj.mvFileNo);
			$("txtCocSerialNo").value = obj == null ? "" : unescapeHTML2(obj.cocYy + " - " + formatNumberDigits(obj.cocSerialNo,7));
			$("txtMotorType").value = obj == null ? "" : unescapeHTML2(obj.dspMotTypeDesc);
			$("txtCarCompany").value = obj == null ? "" : unescapeHTML2(obj.dspCarCompany);
			$("txtInceptDate").value = obj == null ? "" : dateFormat(obj.nbtInceptDate, 'mm-dd-yyyy');
			$("txtIssueDate").value = obj == null ? "" : dateFormat(obj.nbIssueDate, 'mm-dd-yyyy');
			$("txtEffectivityDate").value = obj == null ? "" : dateFormat(obj.nbtEffDate, 'mm-dd-yyyy');
			$("txtCreditingBranch").value = obj == null ? "" : unescapeHTML2(obj.credBranch);
			obj == null ? disableButton("btnPolicyInformation") : enableButton("btnPolicyInformation");
			objGIPIS116.itemNo = obj == null ? "" : unescapeHTML2(obj.itemNo);
			objGIPIS116.itemTitle = obj == null ? "" : unescapeHTML2(obj.itemTitle);
			objGIPIS116.fromDate = obj == null ? "" : dateFormat(obj.fromDate, 'mm-dd-yyyy');
			objGIPIS116.toDate = obj == null ? "" : dateFormat(obj.toDate, 'mm-dd-yyyy');
			objGIPIS116.annPremAmt = obj == null ? "" : formatCurrency(obj.annPremAmt);
			objGIPIS116.annTsiAmt = obj == null ? "" : formatCurrency(obj.annTsiAmt);
			objGIPIS116.policyNo = obj == null ? "" : unescapeHTML2(obj.policyNo);
			objGIPIS116.endtNo = obj == null ? "" : unescapeHTML2(obj.endtNo);
			objGIPIS116.assured = obj == null ? "" : unescapeHTML2(obj.assured);
			objGIPIS116.piadTag = obj == null ? "" : unescapeHTML2(obj.piadTag);
			objGIPIS116.claimTag = obj == null ? "" : unescapeHTML2(obj.claimTag);
		} catch (e) {
			showErrorMessage("populateFields", e);
		}
	}

	function validateRequiredDates(){
		if($("rdoFrom").checked){
			if($("txtFrom").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtFrom");
				return false;	
			}else if($("txtTo").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtTo");
				return false;
			}
		}
		return true;
	}

	function resetForm() {
		tbgViewMotorInquiry.url = contextPath+"/GIPIPolbasicController?action=getMotorCarInquiryRecords&refresh=1";
		tbgViewMotorInquiry._refreshList();
		$("rdoInceptDate").checked = true;
		$("rdoAsOf").checked = true;
		$("txtAsOf").value = getCurrentDate();
		$("rdoAsOf").disabled = false;
		$("rdoFrom").disabled = false;
		disableToolbarButton("btnToolbarEnterQuery");
		disableFromToFields();
		enableToolbarButton("btnToolbarExecuteQuery");
		$("txtCreditingBranch").readOnly = false;
		searchBy = 1;
		populateFields(null);
		allowQuery = false;
		creditingBranch = "";
	}

	$("btnToolbarExecuteQuery").observe("click", function(){
		if(validateRequiredDates())
			queryRecords($F("txtCreditingBranch"));
			disableFields();
			allowQuery = true;
	});
	
	$$("input[name='rdoSearchBy']").each(function(rdo) {
		rdo.observe("click", function() {
			searchBy = rdo.value;
			if(allowQuery){
				queryRecords(creditingBranch);
			}
		});
	});
	
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	$("txtCreditingBranch").observe("change", function(){
		creditingBranch = $F("txtCreditingBranch");
	});
	
	$("btnToolbarExit").observe("click", function(){
		if(objUWGlobal.callingForm == "GIPIS100"){
			objGIPIS100.callingForm = "GIPIS116";
			showMotorCarsPage();
		} else
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnPolicyInformation").observe("click", function() {
		overlayPolicyInformation = Overlay.show(contextPath+"/GIPIPolbasicController", {
			urlContent: true,
			urlParameters: {action : "getMotorCarPolicyInfo"},
			title: "Policy Information",
			height: 270,
			width: 800,
			draggable: true
		});
	});
	
	$$("input[name='fromTo']").each(function(field) {
		 field.observe("focus", function() {
			checkInputDates(field, "txtFrom", "txtTo");
		});
	});
		
	$("rdoAsOf").observe("click", disableFromToFields);
	$("rdoFrom").observe("click", disableAsOfFields);
	
	if(objUWGlobal.callingForm == "GIPIS100"){		
		disableFields();
	}
</script>
