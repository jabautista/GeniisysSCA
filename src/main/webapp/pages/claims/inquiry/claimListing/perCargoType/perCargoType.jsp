<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perCargoTypeMainDiv" name="perCargoTypeMainDiv" style="float: left; margin-bottom: 50px;">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="clmPerCargoTypeExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Cargo Type</label>
	   		<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<div style="float: left;">
			<table style="margin: 10px 60px 5px 55px;" border="0">
				<tr>
					<td class="rightAligned">Cargo Class</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 100px; margin: 0;">
							<input type="text" id="txtCargoClassCd" style="text-align: right; width: 70px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101" lastValidValue=""/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCargoClassDesc" name="imgSearchCargoClassDesc" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtCargoClassDesc" style="width: 287px; float: left; margin: 0; height: 14px;" readonly="readonly" lastValidValue=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Type</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 100px; margin: 0;">
							<input type="text" id="txtCargoType" name="txtCargoTypeDesc" style="width: 70px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="102" lastValidValue=""/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCargoTypeDesc" name="imgSearchCargoTypeDesc" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtCargoTypeDesc" style="width: 287px; height: 14px; float: left; margin: 0;" readonly="readonly" lastValidValue=""/>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 134px; margin-bottom: 10px;">
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
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOfDate">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFromDate">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divToDate">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perCargoTypeTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perCargoTypeTable" style="height: 340px"></div>
		</div>
		<div>
			<table style="margin: 5px; float: right; margin-right: 20px;">
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossResAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="201"/></td>
					<td class=""><input type="text" id="txtTotLossPaidAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="202"/></td>
					<td class=""><input type="text" id="txtTotExpResAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotExpPaidAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="204"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Claim No</td>
					<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 400px;" readonly="readonly" tabindex="301"/></td>
					<td class="rightAligned" style="width: 110px;">Claim Status</td>
					<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 250px;" readonly="readonly" tabindex="302"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 400px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 250px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 400px;" readonly="readonly" tabindex="305"/></td>
					<td class="rightAligned">Claim File Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 250px;" readonly="readonly" tabindex="306"/></td>
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
	
	$("mainNav").hide();
	
	initializeAll();
	setModuleId("GICLS265");
	setDocumentTitle("Claim Listing Per Cargo Type");
	filterOn = false;
	cargoClassResponse = "";
	cargoTypeResponse = "";
	var jsonClmListPerCargoType = JSON.parse('${jsonClmListPerCargoType}');
	var cargosIn = '()';
	
	perCargoTypeTableModel = {
			url: contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerCargoType&refresh=1",
			options: {
				toolbar:{
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter : function(){
					setDetailsForm(null);
					tbgClaimsPerCargoType.keys.removeFocus(tbgClaimsPerCargoType.keys._nCurrentFocus, true);
					tbgClaimsPerCargoType.keys.releaseKeys();
					filterOn = true;
					//togglePrintButton(false);
				}
			},
			width: '900px',
			pager: {
			},
			onCellFocus : function(element, value, x, y, id) {
				setDetailsForm(tbgClaimsPerCargoType.geniisysRows[y]);					
				tbgClaimsPerCargoType.keys.removeFocus(tbgClaimsPerCargoType.keys._nCurrentFocus, true);
				tbgClaimsPerCargoType.keys.releaseKeys();
				//togglePrintButton(true);
			},
			prePager: function(){
				setDetailsForm(null);
				tbgClaimsPerCargoType.keys.removeFocus(tbgClaimsPerCargoType.keys._nCurrentFocus, true);
				tbgClaimsPerCargoType.keys.releaseKeys();
				//togglePrintButton(false);
			},
			onRemoveRowFocus : function(element, value, x, y, id){					
				setDetailsForm(null);
				//togglePrintButton(false);
			},
			onSort : function(){
				setDetailsForm(null);
				tbgClaimsPerCargoType.keys.removeFocus(tbgClaimsPerCargoType.keys._nCurrentFocus, true);
				tbgClaimsPerCargoType.keys.releaseKeys();	
				//togglePrintButton(false);
			},
			onRefresh : function(){
				setDetailsForm(null);
				tbgClaimsPerCargoType.keys.removeFocus(tbgClaimsPerCargoType.keys._nCurrentFocus, true);
				tbgClaimsPerCargoType.keys.releaseKeys();
				//togglePrintButton(false);
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
				title: "Item No.",
				width: '80px',
				filterOption : true,
				filterOptionType: "number",
				align : "right",
				titleAlign : "right",
				renderer: function(val){
					return formatNumberDigits(val, 9);
				}
			},				
			{
				id : "groupedItemNo",
				title: "Item Title.",
				width: '150px',
				filterOption : true
			},
			{
				id : "vesselCd",
				title: "Vessel",
				width: '120px',
				filterOption : true
			},
			{
				id : "lossResAmt",
				title: "Loss Reserve",
				width: '130px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "lossPaidAmt",
				title: "Loss Paid",
				width: '130px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "expResAmt",
				title: "Expense Reserve",
				width: '130px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "expPaidAmt",
				title: "Expense Paid",
				width: '130px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			}
		],
		rows: jsonClmListPerCargoType.rows
	};
	tbgClaimsPerCargoType = new MyTableGrid(perCargoTypeTableModel);
	tbgClaimsPerCargoType.pager = jsonClmListPerCargoType;
	tbgClaimsPerCargoType.render('perCargoTypeTable');
	tbgClaimsPerCargoType.afterRender = function(){
		if(tbgClaimsPerCargoType.geniisysRows.length > 0){
			if (filterOn == true) {
				computeTotal();
			}else {
				var rec = tbgClaimsPerCargoType.geniisysRows[0];
	 			$("txtTotLossResAmt").value 	= formatCurrency(rec.totLossResAmt);
				$("txtTotLossPaidAmt").value 	= formatCurrency(rec.totLossPaidAmt);
				$("txtTotExpResAmt").value 		= formatCurrency(rec.totExpResAmt);
				$("txtTotExpPaidAmt").value 	= formatCurrency(rec.totExpPaidAmt);
			}
		} else {
			$("txtTotLossResAmt").value 	= "";
			$("txtTotLossPaidAmt").value 	= "";
			$("txtTotExpResAmt").value 		= "";
			$("txtTotExpPaidAmt").value 	= "";
		}
	};
	
	function computeTotal() {
		var totLossResAmt  = 0;
		var totLossPaidAmt = 0;
		var totExpResAmt   = 0;
		var totExpPaidAmt  = 0;

		for (var i = 0; i < tbgClaimsPerCargoType.geniisysRows.length; i++) {
			totLossResAmt 	= totLossResAmt  + parseFloat(tbgClaimsPerCargoType.geniisysRows[i].lossResAmt);
			totLossPaidAmt	= totLossPaidAmt + parseFloat(tbgClaimsPerCargoType.geniisysRows[i].lossPaidAmt);
			totExpResAmt	= totExpResAmt   + parseFloat(tbgClaimsPerCargoType.geniisysRows[i].expResAmt);
			totExpPaidAmt	= totExpPaidAmt  + parseFloat(tbgClaimsPerCargoType.geniisysRows[i].expPaidAmt);
		}
		$("txtTotLossResAmt").value  = formatCurrency(parseFloat(nvl(totLossResAmt, "0")));
		$("txtTotLossPaidAmt").value = formatCurrency(parseFloat(nvl(totLossPaidAmt, "0")));
		$("txtTotExpResAmt").value	 = formatCurrency(parseFloat(nvl(totExpResAmt, "0")));
		$("txtTotExpPaidAmt").value  = formatCurrency(parseFloat(nvl(totExpPaidAmt, "0")));
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
		if (validateDate()) {
			disableToolbarButton("btnToolbarExecuteQuery");
			toggleDateFields();
			toggleSearchBy();
			setTbgParametersPerDate();
			setTbgParametersPerSearchBy();
			disableSearch("imgSearchCargoClassDesc");
			disableSearch("imgSearchCargoTypeDesc");
			disableInputField("txtCargoClassDesc");
			disableInputField("txtCargoTypeDesc");
			$("txtCargoClassCd").readOnly = true;
			$("txtCargoType").readOnly = true;
			togglePrintButton(true);			
	 		if (tbgClaimsPerCargoType.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtCargoClassDesc");
				togglePrintButton(false);
			}
		}
	}
	
	function resetHeaderForm(){
		try {
				$("txtCargoClassCd").value = "";
				$("txtCargoClassDesc").value= "";
				$("txtCargoTypeDesc").value= "";
				$("txtCargoType").value= "";
				
				$("txtCargoClassCd").readOnly = false;
				$("txtCargoType").readOnly = false;
				
				$("txtCargoClassCd").setAttribute("lastValidValue", "");
				$("txtCargoClassDesc").setAttribute("lastValidValue", "");
				$("txtCargoTypeDesc").setAttribute("lastValidValue", "");
				$("txtCargoType").setAttribute("lastValidValue", "");
				
				enableInputField("txtCargoTypeDesc");
				enableInputField("txtCargoClassDesc");
				cargoTypeResponse = "";
				cargoClassResponse = "";
				setClaimListingPerCargoType();
				tbgClaimsPerCargoType.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerCargoType&refresh=1&cargoClassCd="+removeLeadingZero($F("txtCargoClassCd"))
											+"&cargoType="+$F("txtCargoType");
				tbgClaimsPerCargoType._refreshList();
				$("txtCargoClassDesc").focus();
				executeQuery = false;
				togglePrintButton(false);
			//}
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
			refrelishTgbList();
		}
		
		if ($("rdoFrom").checked == true) {
			refrelishTgbList();
		}
	}
	
 	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
			refrelishTgbList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("txtSearchBy").value = "lossDate";
			refrelishTgbList();
		}
	}
 	
 	function refrelishTgbList(){
		tbgClaimsPerCargoType.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerCargoType&refresh=1&cargoClassCd="+removeLeadingZero($F("txtCargoClassCd"))
												+"&cargoType="+$F("txtCargoType")+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate") 
												+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
		tbgClaimsPerCargoType._refreshList();
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
			$("txtAsOfDate").clear();
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			
			$("txtAsOfDate").removeClassName("required");
			$("divAsOfDate").removeClassName("required");
			$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			
			$("txtFromDate").style.backgroundColor = "";
			$("divFromDate").style.backgroundColor = "";
			$("txtToDate").style.backgroundColor = "";
			$("divToDate").style.backgroundColor = "";			
			
			$("txtFromDate").addClassName("required");
			$("divFromDate").addClassName("required");
			$("txtToDate").addClassName("required");
			$("divToDate").addClassName("required");
			
		}else{	
			$("txtAsOfDate").value = getCurrentDate();
			$("txtFromDate").clear();
			$("txtToDate").clear();
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			
			$("txtFromDate").removeClassName("required");
			$("divFromDate").removeClassName("required");
			$("txtToDate").removeClassName("required");
			$("divToDate").removeClassName("required");			
			$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("divFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
			$("divToDate").setStyle({backgroundColor: '#F0F0F0'});
			
			$("txtAsOfDate").style.backgroundColor = "";
			$("divAsOfDate").style.backgroundColor = "";	
			
			$("txtAsOfDate").addClassName("required");
			$("divAsOfDate").addClassName("required");			
			
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
	
	//initialize default ClaimListingPerCargoType settings
	function setClaimListingPerCargoType() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchCargoClassDesc");
		disableSearch("imgSearchCargoTypeDesc");
		disableButton("btnPrintReport");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		toggleCalendar(false);
	}
	
	function validateDate() {
		if ($("rdoFrom").checked == true) {
			if ($("txtFromDate").value == "") {
				customShowMessageBox("Required fields must be entered.", imgMessage.INFO, "txtFromDate");
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Required fields must be entered.", imgMessage.INFO, "txtToDate");
				return false;
			}
		}
		return true;
	}
	
	function showGICLS265CargoClassDescLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCargoClassLOV",
				filterDesc: $("txtCargoClassDesc").value.length > 0 ? $F("txtCargoClassDesc") : '%',
				filterText : ($F("txtCargoClassCd") == $("txtCargoClassCd").readAttribute("lastValidValue") ? "" : $F("txtCargoClassCd")),
				cargosIn: cargosIn,
				page : 1
			},
			title : "List of Cargo Classes",
			width : 421,
			height : 386,
			columnModel : [ {
				id : "cargoClassCd",
				title : "Class",
				width : '50px',
				align: "right",
				titleAlign: "right",
				renderer: function(val){
					return formatNumberDigits(val, 4);
				}
			}, {
				id : "cargoClassDesc",
				title : "Description",
				width : '355px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtCargoClassCd") == $("txtCargoClassCd").readAttribute("lastValidValue") ? "" : $F("txtCargoClassCd")),
			onSelect : function(row) {
				$("txtCargoClassDesc").value = unescapeHTML2(row.cargoClassDesc);
				$("txtCargoClassCd").value = formatNumberDigits(row.cargoClassCd, 4);
				$("txtCargoClassDesc").setAttribute("lastValidValue", $F("txtCargoClassDesc"));
				$("txtCargoClassCd").setAttribute("lastValidValue", $F("txtCargoClassCd"));
				fetchCargoType();
				//enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				$("txtCargoType").focus();
			},
			onCancel: function(){
				$("txtCargoClassCd").value = $("txtCargoClassCd").readAttribute("lastValidValue");
				$("txtCargoClassDesc").value = $("txtCargoClassDesc").readAttribute("lastValidValue");
				$("txtCargoClassCd").focus();
			},
			onUndefinedRow : function(){
				$("txtCargoClassCd").value = $("txtCargoClassCd").readAttribute("lastValidValue");
				$("txtCargoClassDesc").value = $("txtCargoClassDesc").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", "I", "txtCargoClassCd");
			},
			onShow: function(){
				$(this.id + "_txtLOVFindText").focus();
			}
		});
	}
	
	function fetchValidCargo(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "fetchValidCargo",
				moduleId: 'GICLS265'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var jsonValidCargoTypes= JSON.parse(response.responseText);
				if(jsonValidCargoTypes.length > 0){
					var temp = '';
					var prevIn = false;
					for(var i = 0; i < jsonValidCargoTypes.length; i++){
						if(prevIn)
							temp += ",";
						temp += jsonValidCargoTypes[i].cargoClassCd;
						prevIn = true;
					}
					cargosIn = '('+temp+')';
				}
			}
		});
	}
	
	function fetchCargoType(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "fetchCorrespondingCargoTypeBasedOnClassCd",
				cargoClassCd : $F('txtCargoClassCd')
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var json = JSON.parse(response.responseText);
				if(json.cargoTypeDesc != null){
					enableSearch("imgSearchCargoTypeDesc");
				}
				if(json.cargoTypeDesc != 'F'){
					$("txtCargoTypeDesc").value = json.cargoTypeDesc;
					$("txtCargoType").value = json.cargoType;
					enableToolbarButton("btnToolbarExecuteQuery");
				}else{
					$("txtCargoTypeDesc").value = '';
					$("txtCargoType").value = '';
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			}
		});
	}
	
	function validateCargoClassPerCargoClass(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateCargoClassPerCargoClass",
				cargoClassDesc : $F("txtCargoClassDesc")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					cargoClassResponse = response.responseText;
					$("txtCargoClassDesc").value = "";
					$("txtCargoTypeDesc").value = "";
					$("txtCargoClassCd").value = "";
					$("txtCargoType").value = "";
					customShowMessageBox("There is no record of this Class_Desc in GIIS_CARGO_CLASS.", imgMessage.INFO, "txtCargoClassDesc");
				} else if(response.responseText == '1') {
					validateDate();
					if(validateDate()){
						cargoClassResponse = response.responseText;
						showGICLS265CargoClassDescLOV();
						if($("txtCargoTypeDesc").value != ""){
							enableToolbarButton("btnToolbarExecuteQuery");
						}else{
							disableToolbarButton("btnToolbarExecuteQuery");
						}
					}
				}else if (response.responseText.include("Sql Exception")) {
					cargoClassResponse = "Y";
					showGICLS265CargoClassDescLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtCargoClassDesc").value != "" && $("txtCargoTypeDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	function showGICLS265CargoTypeDescLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCargoTypeLOV",
				cargoClassCd : removeLeadingZero($F('txtCargoClassCd')),
				//filterDesc: $('txtCargoTypeDesc').value.length > 0 ? $F('txtCargoTypeDesc') : null,
				filterText : ($F("txtCargoType") == $("txtCargoType").readAttribute("lastValidValue") ? "" : $F("txtCargoType")),
				page : 1
			},
			title : "List of Cargo Types",
			width : 400,
			height : 386,
			columnModel : [ {
				id : "cargoType",
				title : "Cargo Type",
				width : '100px'
			}, {
				id : "cargoTypeDesc",
				title : "Description",
				width : '260px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtCargoType") == $("txtCargoType").readAttribute("lastValidValue") ? "" : $F("txtCargoType")),
			onSelect : function(row) {
				if (row != undefined) {
					$("txtCargoType").value = row.cargoType;
					$("txtCargoTypeDesc").value = unescapeHTML2(row.cargoTypeDesc);
					$("txtCargoType").setAttribute("lastValidValue", $F("txtCargoType"));
					$("txtCargoTypeDesc").setAttribute("lastValidValue", $F("txtCargoTypeDesc"));
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
			onCancel : function(){
				$("txtCargoType").value = $("txtCargoType").readAttribute("lastValidValue");
				$("txtCargoTypeDesc").value = $("txtCargoTypeDesc").readAttribute("lastValidValue");
				$("txtCargoType").focus();
			},
			onUndefinedRow : function(){
				$("txtCargoType").value = $("txtCargoType").readAttribute("lastValidValue");
				$("txtCargoTypeDesc").value = $("txtCargoTypeDesc").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", "I", "txtCargoType");
			}
		});
	}
	
	function validateCargoTypePerCargoClass(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateCargoTypePerCargoClass",
				cargoClassCd : $F("txtCargoClassCd"),
				cargoTypeDesc : $F("txtCargoTypeDesc")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					cargoTypeResponse = response.responseText;
					$("txtCargoTypeDesc").value = "";
					customShowMessageBox("There is no record of cargo_class_cd with this cargo_type in GIIS_CARGO_TYPE.", imgMessage.INFO, "txtCargoTypeDesc");
				} else if(response.responseText == '1') {
					cargoTypeResponse = response.responseText;
					showGICLS265CargoTypeDescLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtCargoClassDesc").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}else if (response.responseText.include("Sql Exception")) {
					cargoTypeResponse = "Y";
					showGICLS265CargoTypeDescLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtCargoClassDesc").value != "") {
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
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
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
			customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtToDate");
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
	
	//field onchange
	$("txtCargoClassDesc").observe("change", function() {
		if ($("txtCargoClassDesc").value != "") {
			validateCargoClassPerCargoClass();
		}
	});
	$("txtCargoTypeDesc").observe("change", function() {
		if ($("txtCargoTypeDesc").value != "") {
			validateCargoTypePerCargoClass();
		}
	});
	
	//tbg setting per searchby radio btn
	$("rdoClaimFileDate").observe("click", function() {
		if ($F("txtCargoClassDesc") != "" && cargoClassResponse != '0' && cargoTypeResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	$("rdoLossDate").observe("click", function() {
		if ($F("txtCargoClassDesc") != "" && cargoClassResponse != '0' && cargoTypeResponse != '0' && executeQuery) {
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
	
	//Observe Exit BUTTON
	$("clmPerCargoTypeExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtCargoClassDesc").value != "") {
			setFieldOnSearch();	
			executeQuery = true;
		}
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Cargo Type", printReport, "", true);
		$("csvOptionDiv").show(); // added by carlo de guzman 3.08.2016
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//LOV btn
	$("imgSearchCargoClassDesc").observe("click", function() {
		showGICLS265CargoClassDescLOV();
	});
	$("imgSearchCargoTypeDesc").observe("click", function() {
		showGICLS265CargoTypeDescLOV();
	});
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Cargo Type", printReport, "", true);
		$("csvOptionDiv").show();  // added by carlo de guzman 3.08.2016
	});
	
	function printReport(){
		var months = {'01':'jan' , '02':'feb', '03':'mar', '04':'apr', '05':'may',
				'06':'jun','07':'jul', '08':'aug','09':'sep','10':'oct','11':'nov',
				'12':'dec'};
		var tempAsOfDate = "";
		var tempFromDate = "";
		var tempToDate = "";
		
		if($F("txtAsOfDate").length > 0){
			var split = $("txtAsOfDate").value.split('-');
			tempAsOfDate = [split[1], months[split[0]], split[2].substring(2,4)].join('-');
		}
		
		if($F("txtFromDate").length > 0){
			var split = $("txtFromDate").value.split('-');
			tempFromDate = [split[1], months[split[0]], split[2].substring(2,4)].join('-');
		}
		
		if($F("txtToDate").length > 0){
			var split = $("txtToDate").value.split('-');
			tempToDate = [split[1], months[split[0]], split[2].substring(2,4)].join('-');
		}
		
		try {
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
							+"&reportId=GICLR265"
							+"&cargoClassCd="+($F("txtCargoClassCd"))
							+"&cargoType="+($F("txtCargoType"))
							+"&searchBy="+($F("rdoClaimFileDate") ? 1 : 2)
							+"&asOfDate="+tempAsOfDate
							+"&fromDate="+tempFromDate
							+"&toDate="+tempToDate
							+"&noOfCopies=" + $F("txtNoOfCopies")
			                +"&printerName=" + $F("selPrinter")
			                +"&destination=" + $F("selDestination");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Claim Listing per Cargo Type");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF"; //added by carlo de guzman 3.08.2016
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV";// end
			
			new Ajax.Request(content, {
				parameters : {destination : "file",
							  fileType : fileType},
							  //$("rdoPdf").checked ? "PDF" : "XLS"}, comment out by carlo de guzman 3.08.2016
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response))
						{if (fileType == "CSV"){  // added by carlo de guzman 3.08.2016
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
							} else // end
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
	$("txtCargoClassDesc").focus();
	setClaimListingPerCargoType();
	//fetchValidCargo();
	//initializeAccordion();
	var executeQuery = false;
	
	function reloadForm (){
		objCLMGlobal.callingForm = ""; 
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
		    parameters : {action : "showClaimListingPerCargoType"},
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showClaimListingPerCargoType - onComplete : ", e);
				}								
			} 
		});
	}
	
	$("btnReloadForm").observe("click", reloadForm);
	/* $("btnReloadForm").observe("click", function(){
		$("btnToolbarEnterQuery").click();
	}); */
	
	/* $("txtCargoClassDesc").observe("keypress", function(event){
		if(this.readOnly)
			return;
		
		if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtCargoTypeDesc").clear();
			disableSearch("imgSearchCargoTypeDesc");
		}
	}); */
	
	/* $("txtCargoTypeDesc").observe("keypress", function(event){
		if(this.readOnly)
			return;
		
		if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}); */
	
	togglePrintButton(false);
	
	$("txtCargoClassCd").observe("change", function(){
		if($F("txtCargoClassCd").trim() == ""){
			$("txtCargoClassCd").clear();
			$("txtCargoClassDesc").clear();
			$("txtCargoClassCd").setAttribute("lastValidValue", "");
			$("txtCargoClassDesc").setAttribute("lastValidValue", "");
			
			$("txtCargoType").clear();
			$("txtCargoTypeDesc").clear();
			$("txtCargoType").setAttribute("lastValidValue", "");
			$("txtCargoTypeDesc").setAttribute("lastValidValue", "");
			disableSearch("imgSearchCargoTypeDesc");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			$("imgSearchCargoClassDesc").click();
		}
	});
	
	$("txtCargoType").observe("change", function(){
		if($F("txtCargoType").trim() == ""){			
			$("txtCargoType").clear();
			$("txtCargoTypeDesc").clear();
			$("txtCargoType").setAttribute("lastValidValue", "");
			$("txtCargoTypeDesc").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			$("imgSearchCargoTypeDesc").click();
		}
	});
	
}catch(e){
	showErrorMessage("Claim Listing Per Cargo page has errors.", e);	
}	
</script>