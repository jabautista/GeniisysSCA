<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perThirdPartyMainDiv" name="perThirdPartyMainDiv" style="float: left; margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Third Party</label>
	   	</div>
	</div>	
	<div class="sectionDiv" id="thirdPartyFormDiv">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 10px;">
				<tr>
					<td class="rightAligned">Class</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 455px; margin-right: 10px;">
							<input type="hidden" id="txtPayeeClassCdHid" name="txtPayeeClassCdHid">
							<input type="text" id="txtClassDesc" name="txtClassDesc" style="width: 430px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchClassDesc" name="imgSearchClassDesc" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Name</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 455px; margin-right: 10px;">
							<input type="hidden" id="txtPayeeNoHid" name="txtPayeeNoHid" />
							<input type="text" id="txtName" name="txtName" style="width: 430px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="103"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchName" name="imgSearchName" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 10px; margin-bottom: 10px;">
				<fieldset style="width: 480px;">
					<table>
						<tr>
							<td>
								<input type="radio" name="searchByTp" id="rdoTP" style="float: left; margin: 3px 2px 3px 10px;" tabindex="105" />
								<label for="rdoTP" style="float: left; height: 20px; padding-top: 3px;" title="Third Party">Third Party</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchByTp" id="rdoAP" style="float: left; margin: 3px 2px 3px 10px;" tabindex="106" />
								<label for="rdoAP" style="float: left; height: 20px; padding-top: 3px;" title="Adverse Party">Adverse Party</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchByTp" id="rdoBITP" style="float: left; margin: 3px 2px 3px 10px;" tabindex="107"/>
								<label for="rdoBITP" style="float: left; height: 20px; padding-top: 3px;" title="Bodily Injury TP">Bodily Injured TP</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchByTp" id="rdoPDTP" style="float: left; margin: 3px 2px 3px 10px;" tabindex="108"/>
								<label for="rdoPDTP" style="float: left; height: 20px; padding-top: 3px;" title="Property Damage TP">Property Damage TP</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div style="float: left; width: 350px; margin-top: 10px;">
		<fieldset style="width: 350px;">
			<legend>Search By</legend>
			<table>	
				<tr>
					<td class="rightAligned">
						<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left;" tabindex="109" />
						<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
					</td>
					<td class="rightAligned">
						<input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="110"/>
						<label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio" name="searchBy" id="rdoLossDate" style="float: left;" tabindex="112"/>
						<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
					</td>
					<td class="rightAligned">
						<input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="113"/>
						<label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label>
					</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="114"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="115"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" colspan="2">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="116"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="117"/>
						</div>
					</td>
				</tr>
			</table>
		</fieldset>
		<input type="hidden" id="txtTpValue" value="">
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perThirdPartyTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perThirdPartyTable" style="height: 340px"></div>
		</div>
		<div style="float: left; width: 100%; margin: 10px;" align="center">
			<input type="hidden" id="txtSearchBy" name="txtSearchBy" value=""/>
			<input type="button" class="button" id="btnClaimDet" value="Claim Details" tabindex="401"/>
			<input type="button" class="button" id="btnRecDet" value="Recovery Details" tabindex="402"/>
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="403"/>
		</div>
	</div>
</div>

<script type="text/javascript">

try{
	initializeAll();
	setModuleId("GICLS277");
	setDocumentTitle("Claim Listing Per Third Party");
	filterOn = false;
	classResponse = "";
	nameResponse = "";
	var jsonClmListPerThirdParty = JSON.parse('${jsonClmListPerThirdParty}');
	var payeeClassCdIn = '()';
	var tempClass = '';
	var tempPayee = '';
	var recCount = 0;
	objRecovery = new Object();
	objPerIntm = new Object();
	objClaim = new Object();
	
	perThirdPartyTableModel = {
			url: contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerThirdParty&refresh=1",
			options: {
				toolbar:{
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter : function(){
					tbgClaimsPerThirdParty.keys.removeFocus(tbgClaimsPerThirdParty.keys._nCurrentFocus, true);
					tbgClaimsPerThirdParty.keys.releaseKeys();
					filterOn = true;
					togglePrintButton(false);
					toggleRecDetBtn(false);
					toggleClaimDetBtn(false);
				}
			},
			width: '900px',
			pager: {
			},
			onCellFocus : function(element, value, x, y, id) {	
				var rec = tbgClaimsPerThirdParty.geniisysRows[y];
				tbgClaimsPerThirdParty.keys.removeFocus(tbgClaimsPerThirdParty.keys._nCurrentFocus, true);
				tbgClaimsPerThirdParty.keys.releaseKeys();
				togglePrintButton(true);
				if(rec.claimId.length > 0){
					if(rec.recoveryDetails == "Y"){
						toggleRecDetBtn(true);
					}
					if(rec.perilCd != null && rec.itemNo != null){
						toggleClaimDetBtn(true);
					}
					objRecovery.claimId = rec.claimId;
					objPerIntm.claimId = rec.claimId;
					objPerIntm.perilCd = rec.perilCd;
 					objPerIntm.itemNo = rec.itemNo;
					objPerIntm.lineCd = rec.lineCd;
					objPerIntm.claimNo = rec.claimNumber;
					objPerIntm.policyNo = rec.policyNumber;
 					objPerIntm.lossCatDesc = rec.lossCatDes;
					objPerIntm.lossDate = rec.lossDate;
					objPerIntm.assuredName = rec.assuredName;
 					objPerIntm.clmStatDesc = rec.clmStatDesc;
				}
			},
			prePager: function(){
				tbgClaimsPerThirdParty.keys.removeFocus(tbgClaimsPerThirdParty.keys._nCurrentFocus, true);
				tbgClaimsPerThirdParty.keys.releaseKeys();
				togglePrintButton(false);
				toggleRecDetBtn(false);
				toggleClaimDetBtn(false);
			},
			onRemoveRowFocus : function(element, value, x, y, id){	
				togglePrintButton(false);
				toggleRecDetBtn(false);
				toggleClaimDetBtn(false);
			},
			onSort : function(){
				tbgClaimsPerThirdParty.keys.removeFocus(tbgClaimsPerThirdParty.keys._nCurrentFocus, true);
				tbgClaimsPerThirdParty.keys.releaseKeys();	
				togglePrintButton(false);
				toggleRecDetBtn(false);
				toggleClaimDetBtn(false);
			},
			onRefresh : function(){
				tbgClaimsPerThirdParty.keys.removeFocus(tbgClaimsPerThirdParty.keys._nCurrentFocus, true);
				tbgClaimsPerThirdParty.keys.releaseKeys();
				togglePrintButton(false);
				toggleRecDetBtn(false);
				toggleClaimDetBtn(false);
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
				id: 'claimId',
				width: '0',
				visible: false 
			},	
			{
				id: 'perilCd',
				width: '0',
				visible: false 
			},	
			{
				id: 'itemNo',
				width: '0',
				visible: false 
			},	
			{
				id: 'lossCatDes',
				width: '0',
				visible: false 
			},	
			{
				id: 'clmStatDesc',
				width: '0',
				visible: false 
			},
			{
				id: 'recoveryDetails',
          		title : 'R',
          		altTitle: 'Recovery Details',
              	width: '25px',
              	editable: false,
              	visible: true,
              	defaultValue: false,
				otherValue:	false,
				filterOption: true,
				filterOptionType: 'checkbox',
				editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	} 
	            })
			},				
			{
				id : "claimNumber",
				title: "Claim Number",
				width: '180px',
				filterOption : true
			},
			{
				id : "policyNumber",
				title: "Policy Number",
				width: '180px',
				filterOption : true
			},
			{
				id : "assuredName",
				title: "Assured Name",
				width: '270px',
				filterOption : true
			},
			{
				id : "lossDate",
				title: "Loss Date",
				width: '110px',
				filterOption : true,
				filterOptionType: 'formattedDate'
			},
			{
				id : "claimDate",
				title: "Claim Date",
				width: '110px',
				filterOption : true,
				filterOptionType: 'formattedDate'
			}
		],
		rows: jsonClmListPerThirdParty.rows
	};
	tbgClaimsPerThirdParty = new MyTableGrid(perThirdPartyTableModel);
	tbgClaimsPerThirdParty.pager = jsonClmListPerThirdParty;
	tbgClaimsPerThirdParty.render('perThirdPartyTable');
// 	tbgClaimsPerThirdParty.afterRender = function(){
// 		if(tbgClaimsPerThirdParty.geniisysRows.length > 0){
// 			tbgClaimsPerThirdParty.selectRow('0');
// 		}
// 	};
	
	function setFieldOnSearch() {
		if (validateDate()) {
			toggleDateFields();
			toggleSearchBy();
			setTbgParametersPerDate();
			setTbgParametersPerSearchBy();
			toggleTpSearchByParameter();
			disableSearch("imgSearchClassDesc");
			disableSearch("imgSearchName");
			disableInputField("txtClassDesc");
			disableInputField("txtName");
	 		if (tbgClaimsPerThirdParty.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtClassDesc");
				disableButton("btnPrintReport");
				disableButton("btnClaimDet");
				disableButton("btnRecDet");
			}
		}
	}
	
	function resetHeaderForm(){
		try {
			if($F("txtPayeeClassCdHid") != "" || $F("txtClassDesc") != "" || $F("txtPayeeNoHid") != "" || $F("txtName") != ""){
				$("txtPayeeClassCdHid").value = "";
				$("txtClassDesc").value= "";
				$("txtName").value= "";
				$("txtPayeeNoHid").value= "";
				enableInputField("txtClassDesc");
				enableInputField("txtName");
				classResponse = "";
				nameResponse = "";
				setClaimListingPerThirdParty();
				tbgClaimsPerThirdParty.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerThirdParty&refresh=1&payeeClassCd="+$F("txtPayeeClassCdHid")
											+"&payeeNo="+$F("txtPayeeNoHid") + "&tpType="+$F('txtTpValue') + "&searchBy="+$F('txtSearchBy') 
											+ "&asOfDate="+$F("txtAsOfDate") + "&fromDate=" + $F('txtFromDate') + "&toDate=" + $F('txtToDate');
				tbgClaimsPerThirdParty._refreshList();
				$("txtClassDesc").focus();
				executeQuery = false;
				tempClass = '';
				tempPayee = '';
				recCount = 0;
				
				objRecovery = new Object();
				objClaim = new Object();
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
			refreshTgbList();
		}
		
		if ($("rdoFrom").checked == true) {
			refreshTgbList();
		}
	}
	
 	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
			refreshTgbList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("txtSearchBy").value = "lossDate";
			refreshTgbList();
		}
	}
 	
 	function toggleTpSearchByParameter(){
 		if($("rdoTP").checked == true){
 			$("txtTpValue").value = 'T';
 			refreshTgbList();
 		}
 		
 		if($("rdoAP").checked == true){
 			$("txtTpValue").value = 'A';
 			refreshTgbList();
 		}
 		
 		if($("rdoBITP").checked == true){
 			$("txtTpValue").value = 'B';
 			refreshTgbList();
 		}
 		
 		if($("rdoPDTP").checked == true){
 			$("txtTpValue").value = 'P';
 			refreshTgbList();
 		}
 	}
 	
 	function refreshTgbList(){
 		tbgClaimsPerThirdParty.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerThirdParty&refresh=1&payeeClassCd="+$F("txtPayeeClassCdHid")
												+"&payeeNo="+$F("txtPayeeNoHid") + "&tpType="+$F("txtTpValue") + "&searchBy="+$F('txtSearchBy') 
												+ "&asOfDate="+$F("txtAsOfDate") + "&fromDate=" + $F('txtFromDate') + "&toDate=" + $F('txtToDate');
		tbgClaimsPerThirdParty._refreshList();
 	};
	
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
			$("txtFromDate").removeClassName("required");
			$("txtToDate").removeClassName("required");
		}
	}
	
	$("txtAsOfDate").observe("blur", function(){
		if($("txtAsOfDate").value == ""){
			$("txtAsOfDate").value = getCurrentDate();
		}
	});
	
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
	
	//toggle detail buttons
	function toggleClaimDetBtn(enable){
		if(nvl(enable,false) == true){
			enableButton("btnClaimDet");
		}else{
			disableButton("btnClaimDet");
		}
	}
	
	function toggleRecDetBtn(enable){
		if(nvl(enable,false) == true){
			enableButton("btnRecDet");
		}else{
			disableButton("btnRecDet");
		}
	}
	
	//initialize default ClaimListingPerThirdParty settings
	function setClaimListingPerThirdParty() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoTP").checked 				= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchClassDesc");
		disableSearch("imgSearchName");
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
				enableToolbarButton("btnToolbarExecuteQuery");
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtToDate");
				enableToolbarButton("btnToolbarExecuteQuery");
				return false;
			}
		}
		return true;
	}

	function fetchValidThirdParty(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "fetchValidThirdParty"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var jsonValidThirdParty= JSON.parse(response.responseText);
				if(jsonValidThirdParty.length > 0){
					var temp = '';
					var prevIn = false;
					for(var i = 0; i < jsonValidThirdParty.length; i++){
						if(prevIn)
							temp += ",";
						temp += "'"+jsonValidThirdParty[i].payeeClassCd+"'";
						prevIn = true;
					}
					payeeClassCdIn = "("+temp+")".toUpperCase();
				}
			}
		});
	}
	
	function showGICLS277ClassDescLOV(){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getGiisPayeeClassLOV",
				//findText : tempClass.length > 0 ? tempClass : ($F("txtClassDesc").length > 0 ? $F("txtClassDesc") : '%'),
				//payeeClassCdIn : payeeClassCdIn,
				page : 1
			},
			title : "List of Classes",
			width : 421,
			height : 386,
			columnModel : [ {
				id : "payeeClassCd",
				title : "Class",
				width : '50px',
				titleAlign: 'right',
				align: 'right'
			}, {
				id : "classDesc",
				title : "Class Description",
				width : '355px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $F("txtClassDesc"),
			onSelect : function(row) {
				tempClass = unescapeHTML2(row.classDesc);
				$("txtClassDesc").value = unescapeHTML2(row.classDesc);
				$("txtPayeeClassCdHid").value = unescapeHTML2(row.payeeClassCd);
				fetchPayeeName();
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel: function(){
				$("txtClassDesc").focus();
				tempClass = '';
			},
			onShow: function(row){
				$(this.id + "_txtLOVFindText").focus();
			}
		});
	}
	
	
	function validateClassPerClass(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateClassPerClass",
				filter : $F("txtClassDesc"),
				//payeeClassCdIn: payeeClassCdIn
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				recCount = 0;
				var jsonParse = JSON.parse(response.responseText);
				for(var i = 0; jsonParse.length > i; i++){
					if(jsonParse[i].payeeClassCd != undefined){
						recCount = recCount+1;
					}
				}
				if (recCount == 0) {
					tempClass = '';
					classResponse = response.responseText;
					$("txtClassDesc").value = "";
					$("txtName").value = "";
					$("txtPayeeClassCdHid").value = "";
					$("txtPayeeNoHid").value = "";
					customShowMessageBox("No Such Class Exist.", imgMessage.INFO, "txtClassDesc");
				} else if(recCount == 1) {
					/* if(validateDate()){ */
						classResponse = JSON.parse(response.responseText);
						tempClass = classResponse[0].classDesc;
						//$("txtClassDesc").value = classResponse[0].payeeClassCd+ '-' +classResponse[0].classDesc;
						$("txtClassDesc").value = classResponse[0].classDesc;
						$("txtPayeeClassCdHid").value = classResponse[0].payeeClassCd;
						fetchPayeeName();
						enableToolbarButton("btnToolbarEnterQuery");
						if($("txtName").value != ""){
							enableToolbarButton("btnToolbarExecuteQuery");
						}/* else{
							disableToolbarButton("btnToolbarExecuteQuery");
						} */
					/* } */
				} else if(recCount > 1) {
					/* if(validateDate()){ */
						classResponse = JSON.parse(response.responseText);
						showGICLS277ClassDescLOV();
						enableToolbarButton("btnToolbarEnterQuery");
						if($("txtName").value != ""){
							enableToolbarButton("btnToolbarExecuteQuery");
						}/* else{
							disableToolbarButton("btnToolbarExecuteQuery");
						} */
					/* } */
				} else if (response.responseText.include("Sql Exception")) {
					classResponse = "Y";
					showGICLS277ClassDescLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtClassDesc").value != "" && $("txtName").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	function fetchPayeeName(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validatePayeePerClassCd",
				payeeClassCd : $F('txtPayeeClassCdHid').length > 0 ? $F('txtPayeeClassCdHid') : '%'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				recCount = 0;
				var jsonParse = JSON.parse(response.responseText);
				for(var i = 0; jsonParse.length > i; i++){
					if(jsonParse[i].id != undefined){
						recCount = recCount+1;
					}
				}
				enableSearch("imgSearchName");
				if(recCount == 1){
					tempPayee = jsonParse[0].desc;
					//$("txtName").value =jsonParse[0].id+'-'+jsonParse[0].desc;
					$("txtName").value =jsonParse[0].desc;
					$("txtPayeeNoHid").value = jsonParse[0].id;
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				}else{
					$("txtName").value = '';
					$("txtPayeeNoHid").value = '';
				}
			}
		});
	}
	
	function showGICLS277PayeeNameLOV(){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getPayeesByClassLOV",
				payeeClassCd : $F("txtPayeeClassCdHid"),
				payeeNo: $F('txtPayeeNoHid').length > 0 ? $F('txtPayeeNoHid') : '%' ,
				filterDesc: $F('txtName').length > 0 ? $F('txtName') : '%',
				page : 1
			},
			title : "List of Payee",
			width : 480,
			height : 400,
			columnModel : [ {
				id : "id",
				title : "Payee No",
				width : '120px',
			}, {
				id : "desc",
				title : "Payee Name",
				width : '320px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : $F("txtName"),
			onSelect : function(row) {
				tempPayee = unescapeHTML2(row.desc);
				$("txtName").value = unescapeHTML2(row.desc);
				$("txtPayeeNoHid").value = row.id;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	}
	
	function validatePayeePerClass(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validatePayeePerClassCd",
				filter : $F("txtName"),
				payeeClassCd : $F("txtPayeeClassCdHid"),
				classDesc:	tempClass.length > 0 ? tempClass : ($F("txtClassDesc").length > 0 ? $F("txtClassDesc") : '%')
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				
				recCount = 0;
				recCount = response.responseText.length;
				
				if (recCount == 0) {
					nameReponse = response.responseText;
					$("txtName").value = "";
					customShowMessageBox("No Such Payee Exist.", imgMessage.INFO, "txtName");
				} else if(recCount == 1) {
					nameResponse = response.responseText;
					tempPayee = nameResponse[0].desc;
					//$('txtName').value = nameResponse[0].id +'-'+nameResponse[0].desc;
					$('txtName').value = nameResponse[0].desc;
					$('txtPayeeNoHid').value = nameResponse[0].id;
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtClassDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}/* else {
						disableToolbarButton("btnToolbarExecuteQuery");
					} */
				} else if(recCount > 1){
					nameResponse = response.responseText;
					showGICLS277PayeeNameLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtClassDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}/* else {
						disableToolbarButton("btnToolbarExecuteQuery");
					} */
				} else if (response.responseText.include("Sql Exception")) {
					nameReponse = "Y";
					showGICLS277PayeeNameLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtClassDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}/* else {
						disableToolbarButton("btnToolbarExecuteQuery");
					} */
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
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
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
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
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
			$("txtAsOfDate").value = getCurrentDate();
			return false;
		} else if (asOfDate == ""){
			$("txtAsOfDate").value = getCurrentDate();
		}
	});
	
	//field onchange
	$("txtClassDesc").observe("change", function() {
		if ($("txtClassDesc").value != "") {
			validateClassPerClass();
		}
	});
	
	$("txtClassDesc").observe("change", function() {
		if ($("txtClassDesc").value == "") {
			$("txtPayeeClassCdHid").value = "";
			$("txtName").value = "";
			$("txtPayeeNoHid").value = "";
		}
	});
	
	$("txtName").observe("change", function() {
		if ($("txtName").value != "") {
			//validatePayeePerClass();
			validatePayee();
		}
	});
	
	$("txtName").observe("change", function() {
		if ($("txtName").value == "") {
			$("txtName").value = "";
			$("txtPayeeNoHid").value = "";
		}
	});
	
	//tbg setting per searchby radio btn
	$("rdoClaimFileDate").observe("click", function() {
		if ($F("txtClassDesc") != "" && classResponse != '0' && nameResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	$("rdoLossDate").observe("click", function() {
		if ($F("txtClassDesc") != "" && classResponse != '0' && nameResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	
	$("rdoTP").observe("click", function(){
		if ($F("txtClassDesc") != "" && classResponse != '0' && nameResponse != '0' && executeQuery) {
			toggleTpSearchByParameter();
		}
	});
	
	$("rdoAP").observe("click", function(){
		if ($F("txtClassDesc") != "" && classResponse != '0' && nameResponse != '0' && executeQuery) {
			toggleTpSearchByParameter();
		}
	});
	
	$("rdoBITP").observe("click", function(){
		if ($F("txtClassDesc") != "" && classResponse != '0' && nameResponse != '0' && executeQuery) {
			toggleTpSearchByParameter();
		}
	});
	
	$("rdoPDTP").observe("click", function(){
		if ($F("txtClassDesc") != "" && classResponse != '0' && nameResponse != '0' && executeQuery) {
			toggleTpSearchByParameter();
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
	
	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		//if(checkAllRequiredFieldsInDiv("thirdPartyFormDiv")){
			if ($("txtClassDesc").value == "") {
				customShowMessageBox("Required fields must be entered.", "I", "txtClassDesc");
			} else if ($("txtName").value == ""){
				customShowMessageBox("Required fields must be entered.", "I", "txtName");
			} else {
				executeQuery = true;
				disableToolbarButton("btnToolbarExecuteQuery");
				setFieldOnSearch();
			}
		//}
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Third Party", printReport, "", true);
		$("csvOptionDiv").show(); //SR-5413
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//LOV btn
	$("imgSearchClassDesc").observe("click", function() {
		showGICLS277ClassDescLOV();
	});
	$("imgSearchName").observe("click", function() {
		showGICLS277PayeeNameLOV();
	});
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Third Party", printReport, "", true);
		$("csvOptionDiv").show(); //SR-5413
	});
	
	$('btnRecDet').observe("click", function(){
		showRecoveryDetails();
	});
	
	$("btnClaimDet").observe("click", function(){
		showClaimDetails();
	});
	
	function showRecoveryDetails() {
		try {
		overlayRecoveryDetails = 
			Overlay.show(contextPath+"/GICLClaimListingInquiryController", {
				urlContent: true,
				urlParameters: {action : "showRecoveryDetails",																
								ajax : "1",
								claimId : objRecovery.claimId
				},
			    title: "Recovery Details",
			    height: 500,
			    width: 820,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("overlay error: " , e);
		}
	}
	
	function showClaimDetails() {
		try {
			overlayClaimDetails = Overlay.show(contextPath
					+ "/GICLClaimListingInquiryController", {
				urlContent : true,
				urlParameters : {
					action : "showClaimDetails",
					ajax : "1",
					claimId : objPerIntm.claimId,
					perilCd : objPerIntm.perilCd,
					itemNo  : objPerIntm.itemNo,
					lineCd  : objPerIntm.lineCd,
					claimNo : objPerIntm.claimNo,
					policyNo : objPerIntm.policyNo,
					lossCatDesc : objPerIntm.lossCatDesc,
					lossDate : objPerIntm.lossDate,
					assuredName : objPerIntm.assuredName,
					clmStatDesc : objPerIntm.clmStatDesc
				},
				title : "Claim Details",
				height : 365,
				width : 797,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	function printReport(){
		try {
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
							+"&reportId=GICLR277"
							+"&payeeClassCd="+$F("txtPayeeClassCdHid")
							+"&payeeNo="+$F("txtPayeeNoHid")
							+"&tpType="+$F("txtTpValue")
							+"&asOfDate="+$F("txtAsOfDate")
							+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate")
							+"&searchBy="+$F("txtSearchBy");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Claim Listing per Third Party");
				overlayGenericPrintDialog.close();
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showWaitingMessageBox("Printing complete.", "S", function(){
								overlayGenericPrintDialog.close();
							});
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV";  
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "CSV"},//jm
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var repType = fileType == "CSV" ? "csv" : "reports";
							if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
								showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
							} else {
								var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, repType);
								if(fileType == "CSV"){
									deleteCSVFileFromServer(response.responseText);
								}// jm
								if(message.include("SUCCESS")){
									showWaitingMessageBox("Report file generated to " + message.substring(9), "I", function(){
										if(nvl(afterPrintFunc, null) != null){
											afterPrintFunc();
										}
									});	
								} else {
									showMessageBox(message, "E");
								}
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
							} else {
								showWaitingMessageBox("Printing complete.", "S", function(){
									overlayGenericPrintDialog.close();
								});
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	function validatePayee(){
		new Ajax.Request(contextPath+"/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action: "validateGicls277PayeeName",
				searchPayee: $F("txtName"),
				payeeClass : $F("txtPayeeClassCdHid")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.payeeName, "") == ""){
						showWaitingMessageBox("No record found.", "I", function(){
							$("txtName").focus();
							$("txtName").value = "";
							$("txtPayeeNoHid").value = "";
						});
					}else if (obj.payeeName == "---"){
						showGICLS277PayeeNameLOV();
					}
					else{
						$("txtName").value = unescapeHTML2(obj.payeeName);
						$("txtPayeeNoHid").value = unescapeHTML2(obj.payeeNo);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				}
			}
		});
	}
	
	$("txtClassDesc").focus();
	setClaimListingPerThirdParty();
	fetchValidThirdParty();
	initializeAccordion();
	var executeQuery = false;
	
}catch(e){
	showErrorMessage("Claim Listing Per Third Party page has errors.", e);	
}	
</script>