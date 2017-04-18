<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perNatureOfLossMainDiv" name="perNatureOfLossMainDiv" style="float: left; margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Nature Of Loss</label>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 60px;">
				<tr>
					<td class="rightAligned">Line</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 400px; margin-right: 30px;">
<!-- 							<input type="hidden" id="hidCargoClassDesc" name="hidCargoClassDesc"> -->
							<input type="hidden" id="txtLineCdHid" name="txtLineCdHid">
							<input type="text" id="txtLineName" name="txtLineName" ignoreDelKey="1" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="required" maxlength="20" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineName" name="imgSearchLineName" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Loss Category</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="txtLossCatCdHid" name="txtLossCatCdHid" />
							<input type="text" id="txtLossCatDesc" name="txtLossCatDesc" ignoreDelKey="1" maxlength="25" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="103" readonly="readonly"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLossCatDesc" name="imgSearchLossCatDesc" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 150px; margin-bottom: 10px;">
				<fieldset style="width: 386px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="105" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="106"/>
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: left; width: 255px; margin: 12px;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="107"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perNatureOfLossTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perNatureOfLossTable" style="height: 340px"></div>
		</div>
		<div>
			<table style="margin: 5px; float: right; margin-right: 20px;">
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossResAmt" style="width: 110px; text-align: right;" readonly="readonly" tabindex="201"/></td>
					<td class=""><input type="text" id="txtTotLossPaidAmt" style="width: 110px; text-align: right;" readonly="readonly" tabindex="202"/></td>
					<td class=""><input type="text" id="txtTotExpResAmt" style="width: 110px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotExpPaidAmt" style="width: 110px; text-align: right;" readonly="readonly" tabindex="204"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Claim No</td>
					<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 325px;" readonly="readonly" tabindex="301"/></td>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 325px;" readonly="readonly" tabindex="305"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 325px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 325px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					
					<td class="rightAligned" style="width: 110px;">Claim Status</td>
					<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 325px;" readonly="readonly" tabindex="302"/></td>
					<td class="rightAligned">Claim Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 325px;" readonly="readonly" tabindex="306"/></td>
				</tr>
				<tr>
					<input type="hidden" id="txtSearchBy" name="txtSearchBy" value=""/>				
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>
	</div>
</div>

<script type="text/javascript">

try{
	initializeAll();
	setModuleId("GICLS256");
	setDocumentTitle("Claim Listing Per Nature Of Loss");
	filterOn = false;
	lineNameResponse = "";
	lossCatDescResponse = "";
	var jsonClmListPerNatureOfLoss = JSON.parse('${jsonClmListPerNatureOfLoss}');
	var lineCdIn = '()';
	
	perNatureOfLossTableModel = {
			url: contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerNatureOfLoss&refresh=1",
			options: {
				toolbar:{
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter : function(){
					setDetailsForm(null);
					tbgClaimsPerNatureOfLoss.keys.removeFocus(tbgClaimsPerNatureOfLoss.keys._nCurrentFocus, true);
					tbgClaimsPerNatureOfLoss.keys.releaseKeys();
					filterOn = true;
				}
			},
			width: '900px',
			pager: {
			},
			onCellFocus : function(element, value, x, y, id) {
				setDetailsForm(tbgClaimsPerNatureOfLoss.geniisysRows[y]);					
				tbgClaimsPerNatureOfLoss.keys.removeFocus(tbgClaimsPerNatureOfLoss.keys._nCurrentFocus, true);
				tbgClaimsPerNatureOfLoss.keys.releaseKeys();
			},
			prePager: function(){
				setDetailsForm(null);
				tbgClaimsPerNatureOfLoss.keys.removeFocus(tbgClaimsPerNatureOfLoss.keys._nCurrentFocus, true);
				tbgClaimsPerNatureOfLoss.keys.releaseKeys();
			},
			onRemoveRowFocus : function(element, value, x, y, id){					
				setDetailsForm(null);
			},
			onSort : function(){
				setDetailsForm(null);
				tbgClaimsPerNatureOfLoss.keys.removeFocus(tbgClaimsPerNatureOfLoss.keys._nCurrentFocus, true);
				tbgClaimsPerNatureOfLoss.keys.releaseKeys();
				
			},
			onRefresh : function(){
				setDetailsForm(null);
				tbgClaimsPerNatureOfLoss.keys.removeFocus(tbgClaimsPerNatureOfLoss.keys._nCurrentFocus, true);
				tbgClaimsPerNatureOfLoss.keys.releaseKeys();
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
				id : "itemNo",
				title: "Item No",
				width: '80px',
				filterOption : true,
				filterOptionType: 'integerNoNegative',
				align : "right",
				titleAlign : "right"
			},				
			{
				id : "item",
				title: "Item Title",
				width: '200px',
				filterOption : true
			},
			{
				id : "perilName", //"PerilName", replaced by robert SR 4876 09.09.15
				title: "Peril",
				width: '110px',
				filterOption : true
			},
			{
				id : "lossResAmt",
				title: "Loss Reserve",
				width: '120px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "lossPaidAmt",
				title: "Losses Paid",
				width: '120px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "expResAmt",
				title: "Expense Reserve",
				width: '120px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "expPaidAmt",
				title: "Expenses Paid",
				width: '120px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id: 'clmStatDesc',
				width: '0',
				visible: false 
			}
		],
		rows: jsonClmListPerNatureOfLoss.rows
	};
	tbgClaimsPerNatureOfLoss = new MyTableGrid(perNatureOfLossTableModel);
	tbgClaimsPerNatureOfLoss.pager = jsonClmListPerNatureOfLoss;
	tbgClaimsPerNatureOfLoss.render('perNatureOfLossTable');
	tbgClaimsPerNatureOfLoss.afterRender = function(){
		if(tbgClaimsPerNatureOfLoss.geniisysRows.length > 0){
			//computeTotal();
		} else {
			$("txtTotLossResAmt").value 	= "";
			$("txtTotLossPaidAmt").value 	= "";
			$("txtTotExpResAmt").value 		= "";
			$("txtTotExpPaidAmt").value 	= "";
		}
	};
	
	function computeTotal() {
		new Ajax.Request(contextPath+"/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action: "populateGicls256Totals",
				lineCd  : $F("txtLineCdHid"),
				lossCatCd :  $F("txtLossCatCdHid"),
				searchBy :  $F("txtSearchBy"),
				asOfDate :  $F("txtAsOfDate"),
				fromDate :  $F("txtFromDate"),
				toDate :  $F("txtToDate"),
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("txtTotLossResAmt").value  = formatCurrency(nvl(obj.totLossRes, "0"));
					$("txtTotLossPaidAmt").value = formatCurrency(nvl(obj.totLossPd, "0"));
					$("txtTotExpResAmt").value	 = formatCurrency(nvl(obj.totExpRes, "0"));
					$("txtTotExpPaidAmt").value  = formatCurrency(nvl(obj.totExpPd, "0"));
				}
			}
		});
	}
	
	function setDetailsForm(rec){
		try{
			$("txtClaimNo").value 		= rec == null ? "" : rec.claimNumber;
			$("txtPolicyNo").value		= rec == null ? "" : rec.policyNumber;
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assuredName);
			$("txtClaimStatus").value	= rec == null ? "" : rec.clmStatDesc;
			$("txtLossDate").value		= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtClaimFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
		} catch(e){
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function setFieldOnSearch() {
		validateDate();
		if (validateDate()) {
			toggleDateFields();
			toggleSearchBy();
			//setTbgParametersPerDate();
			setTbgParametersPerSearchBy();
			togglePrintButton(true);
			disableSearch("imgSearchLineName");
			disableSearch("imgSearchLossCatDesc");
			disableInputField("txtLineName");
			disableInputField("txtLossCatDesc");
	 		if (tbgClaimsPerNatureOfLoss.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtLineName");
				disableButton("btnPrintReport");
				togglePrintButton(false);
			}
		}
	}
	
	function resetHeaderForm(){
		try {
			if($F("txtLineCdHid") != "" || $F("txtLineName") != "" || $F("txtLossCatCdHid") != "" || $F("txtLossCatDesc") != ""){
				$("txtLineCdHid").value = "";
				$("txtLineName").value= "";
				$("txtLossCatDesc").value= "";
				$("txtLossCatCdHid").value= "";
				//enableInputField("txtLossCatDesc");
				$("txtLossCatDesc").readOnly = true;
				enableInputField("txtLineName");
				lossCatDescResponse = "";
				cargoClassResponse = "";
				setClaimListingPerNatureOfLoss();
				tbgClaimsPerNatureOfLoss.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerNatureOfLoss&refresh=1&lineCd="+$F("txtLineCdHid")
											+"&lossCatCd="+$F("txtLossCatCdHid");
				tbgClaimsPerNatureOfLoss._refreshList();
				$("txtLineName").focus();
				executeQuery = false;
			}
		} catch (e) {
			showErrorMessage("resetHeaderForm", e);
		}
	}
	
	//set searchby parameter value
	function toggleSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
		}else {
			$("txtSearchBy").value = "lossDate";
		}
	}
	
	//set tbg url per selected date params
 	function setTbgParametersPerDate() {
		if ($("rdoAsOf").checked == true) {
			refreshTbglist();
		}
		
		if ($("rdoFrom").checked == true) {
			refreshTbglist();
		}
	}
	
 	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
			
			refreshTbglist();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("txtSearchBy").value = "lossDate";
			refreshTbglist();
		}
	}
	
	function refreshTbglist(){
		tbgClaimsPerNatureOfLoss.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerNatureOfLoss&refresh=1&lineCd="+$F("txtLineCdHid")
												   +"&lossCatCd="+$F("txtLossCatCdHid")+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate") 
												   +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");

		tbgClaimsPerNatureOfLoss._refreshList();
		computeTotal();
	}
	
	//enable/disable date fields based on selected radio button
	function toggleDateFields() {
		if ($("rdoAsOf").checked == true) {
			disableDate("hrefAsOfDate");
			$("rdoAsOf").disabled 		= true;
			$("rdoFrom").disabled 		= true;
			$("txtAsOfDate").disabled 	= true;
		} else if ($("rdoFrom").checked == true) {
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("rdoFrom").disabled 		= true;
			$("rdoAsOf").disabled 		= true;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
		}
	}
	
	//enable/disable calendar icon
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			//enable asof calendar
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("txtFromDate").addClassName("required");
			$("txtToDate").addClassName("required");
		}else{	
			//disable asof calendar
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("txtToDate").removeClassName("required");
			$("txtFromDate").removeClassName("required");
		}
	}
	
	//toggle toolbar buttons
	function togglePrintButton(enable) {
		if (nvl(enable,false) == true){
			enableButton("btnPrintReport");
			enableToolbarButton("btnToolbarPrint");
		}else {
			disableButton("btnPrintReport");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	//initialize default ClaimListingPerNatureOfLoss settings
	function setClaimListingPerNatureOfLoss() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchLineName");
		disableSearch("imgSearchLossCatDesc");
		disableButton("btnPrintReport");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		toggleCalendar(false);
	}
	
	function validateDate() {
		if ($("rdoFrom").checked == true) {
			if ($("txtFromDate").value == "") {
				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtFromDate");
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtToDate");
				return false;
			}
		}
		return true;
	}
	
	function showGICLS256LineNameLOV(){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getClmLineLOV", 
				moduleId : 'GICLS256',
				searchString : $F("txtLineName"),
				lineCdIn: lineCdIn,
				filterText: nvl($("txtLineName").value, "%"),
				page : 1
			},
			title : "List of Lines",
			width : 421,
			height : 386,
			columnModel : [ {
				id : "code",
				title : "Line Code",
				width : '100px',
			}, {
				id : "codeDesc",
				title : "Line Name",
				width : '290px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtLineName").value,
			onSelect : function(row) {
				$("txtLineName").value = unescapeHTML2(row.codeDesc);
				$("txtLineCdHid").value = row.code;
				fetchValidCatDesc();
				//enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				disableSearch("imgSearchLineName");
				$("txtLineName").readOnly = true;
				$("txtLossCatDesc").readOnly = false;
			},
			onCancel: function(){
				$("txtLineName").focus();
			},
			onShow: function(){
				$(this.id + "_txtLOVFindText").focus();
			}
		});
	}
	
	function fetchValidLineCd(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "fetchValidLineCd",
				moduleId: 'GICLS256'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var jsonValidLines= JSON.parse(response.responseText);
				if(jsonValidLines.length > 0){
					var temp = '';
					var prevIn = false;
					for(var i = 0; i < jsonValidLines.length; i++){
						if(prevIn)
							temp += ",";
						temp += jsonValidLines[i].lineCd;
						prevIn = true;
					}
					lineCdIn = '('+temp+')';
				}
			}
		});
	}
	
	function fetchValidCatDesc(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "fetchValidLossCatDesc",
				lineCd : $F('txtLineCdHid')
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var json = JSON.parse(response.responseText);
				if(json.lossCatDesc != null){
					enableSearch("imgSearchLossCatDesc");
				}
				if(json.lossCatDesc != 'F'){
					$("txtLossCatDesc").value = json.lossCatDesc;
					$("txtLossCatCdHid").value = json.lossCatCd;
				}else{
					$("txtLossCatDesc").value = '';
					$("txtLossCatCdHid").value = '';
				}
			}
		});
	}
	
	function validateLineCdByLineName(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateLineCdByLineName",
				lineName : $F("txtLineName")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					lineNameResponse = response.responseText;
					$("txtLineName").value = "";
					$("txtLossCatDesc").value = "";
					$("txtLineCdHid").value = "";
					$("txtLossCatCdHid").value = "";
					customShowMessageBox("No record is found.", imgMessage.INFO, "txtLineName");
					//showGICLS256LineNameLOV();
				} else if(response.responseText == '1') {
					validateDate();
					if(validateDate()){
						lineNameResponse = response.responseText;
						showGICLS256LineNameLOV();
						if($("txtLossCatDesc").value != ""){
							enableToolbarButton("btnToolbarExecuteQuery");
						}else{
							disableToolbarButton("btnToolbarExecuteQuery");
						}
					}
				}else if (response.responseText.include("Sql Exception")) {
					lineNameResponse = "Y";
					showGICLS256LineNameLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtLineName").value != "" && $("txtLossCatDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	function showGICLS256LossCatDescLOV(){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getLossCatCdDtlLOV",
				lineCd : $F("txtLineCdHid"),
				filterDesc: $("txtLossCatDesc").value.length > 0 ? $F("txtLossCatDesc") : '%',
				filterText: nvl($("txtLossCatDesc").value, "%"),
				page : 1
			},
			title : "List of Loss Category",
			width : 400,
			height : 386,
			columnModel : [ {
				id : "id",
				title : "Loss Cat Code",
				width : '100px'
			}, {
				id : "desc",
				title : "Loss Cat Desc.",
				width : '260px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $F("txtLossCatDesc"),
			onSelect : function(row) {
				if (row != undefined) {
					$("txtLossCatCdHid").value = row.id;
					$("txtLossCatDesc").value = unescapeHTML2(row.desc);
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					disableSearch("imgSearchLossCatDesc");
					$("txtLossCatDesc").readOnly = true;
				}
			},
			onCancel : function(){
				$("txtLossCatDesc").focus();
			}
		});
	}
	
	function validateLossCatDescPerLineCd(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateLossCatDescPerLineCd",
				lineCd : $F("txtLineCdHid"),
				lossCatDesc : $F("txtLossCatDesc")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					lossCatDescResponse = response.responseText;
					$("txtLossCatDesc").value = "";
					customShowMessageBox("No record is found.", imgMessage.INFO, "txtLossCatDesc");
					//showGICLS256LossCatDescLOV();
				} else if(response.responseText == '1') {
					lossCatDescResponse = response.responseText;
					showGICLS256LossCatDescLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtLossCatDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}else if (response.responseText.include("Sql Exception")) {
					lossCatDescResponse = "Y";
					showGICLS256LossCatDescLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtLossCatDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	//enable backspace on date fields
	observeBackSpaceOnDate("txtAsOfDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	
	//date field validations
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("hrefToDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("txtAsOfDate").observe("focus", function(){
		if ($("hrefAsOfDate").disabled == true) return;
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
			return false;
		}
	});
	
	$("txtAsOfDate").observe("blur", function(){
		if($("txtAsOfDate").value == ""){
			$("txtAsOfDate").value = getCurrentDate();
		}
	});
	
// 	//field onchange
	$("txtLineName").observe("change", function() {
		if ($("txtLineName").value != "") {
			validateLineCdByLineName();
		}
	});
	$("txtLossCatDesc").observe("change", function() {
		if ($("txtLossCatDesc").value != "") {
			validateLossCatDescPerLineCd();
		}
	});
	
	//tbg setting per searchby radio btn
	$("rdoClaimFileDate").observe("click", function() {
		if ($F("txtLineName") != "" && lineNameResponse != '0' && lossCatDescResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	$("rdoLossDate").observe("click", function() {
		if ($F("txtLineName") != "" && lineNameResponse != '0' && lossCatDescResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	
	//calendar icon setting per radio btn
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
	});
	$("rdoAsOf").observe("click", function() {
		toggleCalendar(false);
	});
	
	//date fields calendar
	$("hrefFromDate").observe("click", function() {
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function() {
		if($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});
	$("hrefAsOfDate").observe("click", function() {
		if ($("hrefAsOfDate").disabled == true) return;
		scwShow($('txtAsOfDate'),this, null);
	});
	
// 	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtLineName").value != "") {
			setFieldOnSearch();	
			executeQuery = true;
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Nature Of Loss", printReport, "", true);
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//LOV btn
	$("imgSearchLineName").observe("click", function() {
		showGICLS256LineNameLOV();
	});
	$("imgSearchLossCatDesc").observe("click", function() {
		showGICLS256LossCatDescLOV();
	});
	
	$("btnPrintReport").observe("click", function(){
		//showMessageBox("The report you are trying to generate is not yet available.", imgMessage.INFO);
		showGenericPrintDialog("Print Claim Listing per Nature Of Loss", printReport, "", true);
	});
	
	function printReport(){
 		try {
 			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
 							+"&reportId=GICLR256"
 							+"&lineCd="+($F("txtLineCdHid"))
 							+"&lossCatCd="+($F("txtLossCatCdHid"))
 							+"&searchBy="+($F("rdoAsOf") ? 1 : 2)
 							+"&asOfDate="+$F("txtAsOfDate")
 							+"&fromDate="+$F("txtFromDate")
 							+"&toDate="+$F("txtToDate");
			
 			if("screen" == $F("selDestination")){
 				showPdfReport(content, "Claim Listing per Nature Of Loss");
 				overlayGenericPrintDialog.close();
 			}else if($F("selDestination") == "printer"){
 				new Ajax.Request(content, {
 					parameters : {noOfCopies : $F("txtNoOfCopies"),
 						  	      printerName : $F("selPrinter")},
 					onCreate: showNotice("Processing, please wait..."),				
 					onComplete: function(response){
 						hideNotice();
 						if (checkErrorOnResponse(response)){
 							showWaitingMessageBox("Printing Completed.", imgMessage.SUCCESS, function(){
 								overlayGenericPrintDialog.close();
 							});
 						}
 					}
 				});
 			}else if("file" == $F("selDestination")){
 				new Ajax.Request(content, {
 					parameters : {destination : "file",
 								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
 					onCreate: showNotice("Generating report, please wait..."),
 					onComplete: function(response){
 						hideNotice();
 						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
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
 			showErrorMessage("printReport", e);
 		}
	}
	$("txtLineName").focus();
	setClaimListingPerNatureOfLoss();
	fetchValidLineCd();
	initializeAccordion();
	var executeQuery = false;
	
}catch(e){
	showErrorMessage("Claim Listing Per Nature Of Loss page has errors.", e);	
}	
</script>