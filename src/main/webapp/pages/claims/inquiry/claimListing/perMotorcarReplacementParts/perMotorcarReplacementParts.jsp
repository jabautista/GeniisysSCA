<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="clmListingPerMCReplacementPartMainDiv"
	name="clmListingPerMCReplacementPartMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Motor Car Replacement Part Inquiry</label>
		</div>
	</div>
	<div id="clmListingPerMCReplacementPartDiv" class="sectionDiv">
		<div
			style="margin-left: 15px; margin-top: 7px; width: 510px; float: left;">
			<table style="width: 510px; margin-left: 10px;">
				<tr>
					<td class="rightAligned">Car Company</td>
					<td class="rightAligned">
						<div id="companyDiv" style="width: 410px; float: left;"
							class="withIconDiv">
							<input type="hidden" id="hidCarCompanyCd" name="hidCarCompanyCd" />
							<input type="text" id="txtCarCompany" name="txtCarCompany"
								value="" style="width: 375px;" class="withIcon allCaps"
								tabindex="101"> <img style="float: right;"
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchCarCompanyCd" name="imgSearchCarCompanyCd" alt="Go"
								tabindex="102" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Make</td>
					<td class="rightAligned">
						<div id="makeDiv" style="width: 410px; float: left;"
							class="withIconDiv">
							<input type="hidden" id="hidMakeCd" name="hidMakeCd" /> <input
								type="text" id="txtMake" name="txtMake" value=""
								style="width: 375px;" class="withIcon allCaps" tabindex="103">
							<img style="float: right;"
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchMake" name="imgSearchMake" alt="Go" tabindex="104" />
						</div>
					</td>
				</tr>
			</table>
			<table style="width: 510px; margin-left: 25px;">
				<tr>
					<td class="rightAligned">Model Year</td>
					<td class="rightAligned">
						<div id="modelYrDiv" style="width: 65px; float: left;"
							class="withIconDiv">
							<input type="hidden" id="hidModelYr" name="hidModelYr" /> <input
								type="text" id="txtModelYear" name="txtModelYear" value=""
								style="width: 40px;" class="withIcon allCaps" tabindex="106">
							<img style="float: right;"
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchYear" name="imgSearchYear" alt="Go" tabindex="107" />
						</div>
					</td>
					<td class="rightAligned" style="width: 52px;">Parts</td>
					<td class="rightAligned">
						<div id="partsDiv" style="width: 274px; float: left;"
							class="withIconDiv">
							<input type="hidden" id="hidPartCd" name="hidPartCd" /> <input
								type="text" id="txtPart" name="txtPart" value=""
								style="width: 239px;" class="withIcon allCaps" tabindex="106">
							<img style="float: right;"
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchPart" name="imgSearchPart" alt="Go" tabindex="107" />
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; width: 255px; margin: 0px 60px 0 15px;">
			<table border="0" align="center" style="margin: 3px;">
				<tr>
					<td>
						<fieldset style="width: 340px;">
							<legend>Search by</legend>
							<table border="0" align="left">
								<tr style="border: 1px;">
									<td style="padding-bottom: 5px;"><input style="float: left; margin: 4px 0 0 0;"
										type="radio" id="rdoClaimFileDate" name="searchBy"
										value="claimFileDate" checked="checked" tabindex="108">
									</td>
									<td><label for="rdoClaimFileDate">Claim File Date</label></td>
									<td style="padding-bottom: 5px;"><input style="float: left; margin: 4px 0 0 10px;"
										name="byDate" type="radio" id="rdoAsOf" checked="checked"
										title="As of" style="float: left;" tabindex="110" />
									<td><label for="rdoAsOf">As of</label></td>
									<td class="leftAligned">
										<div style="float: left; width: 155px;" class="withIconDiv"
											id="divAsOf">
											<input type="text" removeStyle="true" id="txtAsOfDate"
												class="withIcon" readonly="readonly" style="width: 130px;"
												tabindex="106" /> <img id="hrefAsOfDate"
												src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
												alt="As of Date" tabindex="111" />
										</div>
									</td>
								</tr>
								<tr>
									<td style="padding-bottom: 5px;"><input style="float: left; margin: 4px 0 0 0;"
										type="radio" id="rdoLossDate" name="searchBy" value="lossDate"
										tabindex="109"></td>
									<td><label for="rdoLossDate">Loss Date</label></td>
									<td style="padding-bottom: 5px;"><input style="float: left; margin: 4px 0 0 10px;"
										name="byDate" type="radio" id="rdoFrom" title="From"
										style="float: left;" tabindex="105" /></td>
									<td><label for="rdoFrom">From</label></td>
									<td class="leftAligned">
										<div style="float: left; width: 155px;" class="withIconDiv"
											id="divFrom">
											<input type="text" removeStyle="true" id="txtFromDate"
												class="withIcon" readonly="readonly" style="width: 130px;"
												tabindex="109" /> <img id="hrefFromDate"
												src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
												alt="From Date" tabindex="110" />
										</div>
									</td>
								</tr>
								<tr style="border: 1px;">
									<td></td>
									<td></td>
									<td></td>
									<td class="rightAligned">To</td>
									<td class="leftAligned">
										<div style="float: left; width: 155px;" class="withIconDiv"
											id="divTo">
											<input type="text" removeStyle="true" id="txtToDate"
												name="byDate" class="withIcon" readonly="readonly"
												style="width: 130px;" tabindex="106" /> <img
												id="hrefToDate"
												src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
												alt="To Date" tabindex="107" />
										</div>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="clmListingPerMCReplacementPartDiv"
			style="padding: 10px 0 0 5px; height: 515px; width: 911px;">
			<div id="clmPerMCReplacementPartDetailsGrid"
				style="height: 300px; margin-left: 5px; width: 911px;"></div>
			<div style="margin-top: 5px; width: 907px;">
				<table cellpadding="0" align="center"
					style="width: 907px; margin-bottom: 2px;">
					<tr>
						<td colspan="6">
							<div style="float: left; width: 100%; margin: 15px 0 6px 0;"
								align="center">
								<input type="button" class="disabledButton"
									id="btnShowLossDetails" value="Loss Details"
									tabindex="501" />
							</div>
							<div id="clmPerMCReplacementPartDetails" class="sectionDiv"
								style="height: 100px; margin-top: 10px;">
								<table align="left" style="margin-top: 5px; margin-left: 5px;">
									<tr>
										<td class="rightAligned">Claim No</td>
										<td class="rightAligned"><input style="width: 410px;"
											id="txtClaimNo" name="txtClaimNo" type="text"
											readOnly="readonly" /></td>
										<td style="width: 23px;"></td>
										<td class="rightAligned">Claim Status</td>
										<td class="rightAligned"><input style="width: 253px;"
											id="txtClaimStatus" name="txtClaimStatus" type="text"
											readOnly="readonly" /></td>
									</tr>
									<tr>
										<td class="rightAligned">Policy No</td>
										<td class="rightAligned"><input style="width: 410px;"
											id="txtPolicyNo" name="txtPolicyNo" type="text"
											readOnly="readonly" /></td>
										<td style="width: 23px;"></td>
										<td class="rightAligned">Loss Date</td>
										<td class="rightAligned"><input style="width: 253px;"
											id="txtLossDate" name="txtLossDate" type="text"
											readOnly="readonly" /></td>
									</tr>
									<tr>
										<td class="rightAligned">Assured Name</td>
										<td class="rightAligned"><input style="width: 410px;"
											id="txtAssured" name="txtAssured" type="text"
											readOnly="readonly" /></td>
										<td style="width: 23px;"></td>
										<td class="rightAligned">Claim File Date</td>
										<td class="rightAligned"><input style="width: 253px;"
											id="txtClaimFileDate" name="txtClaimFileDate" type="text"
											readOnly="readonly" /></td>
									</tr>
								</table>
							</div>
							<div style="float: left; width: 100%; margin: 15px 0 10px 0;"
								align="center">
								<input type="button" class="disabledButton"
									id="btnPrintClmPerMCReplacementPart" value="Print Report"
									tabindex="501" />
							</div>
					<tr>
						<input type="hidden" id="hidSearchBy" name="hidSearchBy" value="" />
					</tr>
					</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GICLS275");
	setDocumentTitle("Claim Listing Per Motor Car Replacement Part");
	var exec = false;
	
	function initializeGICLS275() {
		$("txtCarCompany").focus();
		$("txtCarCompany").removeAttribute("readonly");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		toggleSearchBy();
		toggleCalendar(false);
		objMtrcarRepPart = new Object();
		validateExec = new Object();
		validateExec.obj = 0;
	}	

	function toggleCalendar(disable){
		if (disable){
			//disable asof calendar
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			$("txtFromDate").setStyle({backgroundColor: '#FFFACD'});
			$("divFrom").setStyle({backgroundColor: '#FFFACD'});
			$("txtToDate").setStyle({backgroundColor: '#FFFACD'});
			$("divTo").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("hrefFromDate").disabled = false;
			$("hrefToDate").disabled = false;
		}else{	
			//enable asof calendar
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOfDate").setStyle({backgroundColor: 'white'});
			$("divAsOf").setStyle({backgroundColor: 'white'});
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		}
	}
	
	//set searchby parameter value
	function toggleSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("hidSearchBy").value = "claimFileDate";
		}else {
			$("hidSearchBy").value = "lossDate";
		}
	}
	
	function setFieldOnSearch() {
		if (validateDate()) {
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
			toggleDateFields();
			toggleSearchBy();
			exec = true;
			//setTbgParametersPerDate();
			//setTbgParametersPerSearchBy();
			disableSearch("imgSearchMake");
			disableInputField("txtMake");
			disableSearch("imgSearchYear");
			disableInputField("txtModelYear");
			disableSearch("imgSearchPart");
			disableInputField("txtPart");
			disableSearch("imgSearchCarCompanyCd");
			disableInputField("txtCarCompany");
			disableFields(true);
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	//set tbg url per selected date params
 	function setTbgParametersPerDate() {
		if ($("rdoAsOf").checked == true) {
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
		}
	} 
	
 	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("hidSearchBy").value = "claimFileDate";
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("hidSearchBy").value = "lossDate";
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
		}
	}
 	
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
	
	function setDetailsForm(rec) {
		try {
			$("txtClaimNo").value = rec == null ? "" : rec.claimNumber;
			$("txtPolicyNo").value = rec == null ? "" : rec.policyNo;
			$("txtAssured").value = rec == null ? ""
					: unescapeHTML2(rec.assdName);
			$("txtClaimStatus").value = rec == null ? "" : rec.clmStatDesc;
			$("txtLossDate").value = rec == null ? "" : dateFormat(
					rec.lossDate, "mm-dd-yyyy");
			$("txtClaimFileDate").value = rec == null ? "" : dateFormat(
					rec.clmFileDate, "mm-dd-yyyy");
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
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
	
	function disableFields(enable) {
		$("rdoAsOf").disable();
		$("txtAsOfDate").disable();
		$("rdoFrom").disable();
		$("txtFromDate").disable();
		$("txtToDate").disable();
		$("hrefAsOfDate").disabled = true;
		$("hrefFromDate").disabled = true;
		$("hrefToDate").disabled = true;
		disableSearch("imgSearchMake");
		$("txtMake").readOnly = true;
		disableDate("hrefToDate");
		disableDate("hrefFromDate");
		disableDate("hrefAsOfDate");
		$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		disableToolbarButton("btnToolbarExecuteQuery");
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
			customShowMessageBox("From Date should not be later the To Date.", "I", "txtFromDate");
			$("txtToDate").clear();
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
			customShowMessageBox("From Date should not be later the To Date.", "I", "txtToDate");
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
	
	var jsonMCReplacementPartDetails = JSON.parse('${jsonMCReplacementPartDetails}');
	perMCReplacementPartTableModel = {
		url : contextPath
				+ "/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
				+ $F("hidCarCompanyCd") + "&makeCd=" + $F("hidMakeCd") + "&modelYear=" + $F("hidModelYr") + "&lossExpCd=" + $F("hidPartCd"),
		options : {
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					setDetailsForm(null);
					tbgClaimsPerMCReplacementPart.keys.removeFocus(
						tbgClaimsPerMCReplacementPart.keys._nCurrentFocus, true);
					tbgClaimsPerMCReplacementPart.keys.releaseKeys();
					//filterOn = true;
					togglePrintButton(false);
					toggleLossButton(false);
				}
			},
			width : '900px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				setObjMtrcarRepPart(tbgClaimsPerMCReplacementPart.geniisysRows[y]);
				setDetailsForm(tbgClaimsPerMCReplacementPart.geniisysRows[y]);
				tbgClaimsPerMCReplacementPart.keys.removeFocus(
						tbgClaimsPerMCReplacementPart.keys._nCurrentFocus, true);
				tbgClaimsPerMCReplacementPart.keys.releaseKeys();
				togglePrintButton(true);
				toggleLossButton(true);
			},
			prePager : function() {
				setDetailsForm(null);
				tbgClaimsPerMCReplacementPart.keys.removeFocus(
						tbgClaimsPerMCReplacementPart.keys._nCurrentFocus, true);
				tbgClaimsPerMCReplacementPart.keys.releaseKeys();
				togglePrintButton(false);
				toggleLossButton(false);
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				setDetailsForm(null);
				togglePrintButton(false);
				toggleLossButton(false);
			},
			onSort : function() {
				setDetailsForm(null);
				tbgClaimsPerMCReplacementPart.keys.removeFocus(
						tbgClaimsPerMCReplacementPart.keys._nCurrentFocus, true);
				tbgClaimsPerMCReplacementPart.keys.releaseKeys();
				togglePrintButton(false);
				toggleLossButton(false);
			},
			onRefresh : function() {
				setDetailsForm(null);
				tbgClaimsPerMCReplacementPart.keys.removeFocus(
						tbgClaimsPerMCReplacementPart.keys._nCurrentFocus, true);
				tbgClaimsPerMCReplacementPart.keys.releaseKeys();
				togglePrintButton(false);
				toggleLossButton(false);
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "itemNo",
			title : "Item No.",
			width : '80px',
			filterOption : true,
			filterOptionType: 'integerNoNegative',
			align : "right",
			titleAlign : "right"
		}, {
			id : "perilName",
			title : "Peril",
			width : '95px',
			filterOption : true
		}, {
			id : "classDesc payeeLastName",
			title : "Payee",
			width : '670px',		
			children : [{
			                id : 'classDesc',
			                title:'Class Desc',
			                width: 80,
			                filterOption: true
			            },{
			                id : 'payeeLastName',
			                title: 'Payee Last Name',
			                width: 190,
			                filterOption: true
			            }]
		}, {
			id : "histSeqNo",
			title : "Hist No",
			width : '50px',
			filterOption : true,
			filterOptionType: 'integerNoNegative',
			align : 'right',
			titleAlign : 'right'
		}, {
			id : "leStatDesc",
			title : "Status",
			width : '130px',
			filterOption : true,
			align : 'left',
			titleAlign : 'left'
		}, {
			id : "dtlAmt",
			title : "Amount",
			width : '95px',
			filterOption : true,
			align : 'right',
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}, {
			id : "userId",
			title : "User",
			width : '60px',
			filterOption : true,
			align : 'left',
			titleAlign : 'left'
		} ,{
			id : "lastUpdate",
			title : "Last Update",
			width : '90px',
			filterOption : true,
			align : 'center',
			titleAlign : 'center',
			filterOptionType: 'formattedDate'
		} ],
		rows : jsonMCReplacementPartDetails.rows
	};

	tbgClaimsPerMCReplacementPart = new MyTableGrid(perMCReplacementPartTableModel);
	tbgClaimsPerMCReplacementPart.pager = jsonMCReplacementPartDetails;
	tbgClaimsPerMCReplacementPart.render('clmPerMCReplacementPartDetailsGrid');

	function resetForm() {
		try {
			if ($F("hidCarCompanyCd") != "" || $F("txtCarCompany") != ""
					|| $F("hidMakeCd") != "" || $F("txtMake") != "" || $F("hidModelYr") != "" || $F("txtModelYear") != ""
					|| $F("hidPartCd") != "" || $F("txtPart") != "") {
				validateExec.obj = 0;
				$("hidPartCd").value = "";
				$("txtCarCompany").value = "";
				$("hidMakeCd").value = "";
				$("txtMake").value = "";
				$("hidModelYr").value = "";
				$("txtModelYear").value = "";
				$("hidPartCd").value = "";
				$("txtPart").value = "";
				enableSearch("imgSearchMake");
				enableSearch("imgSearchYear");
				enableSearch("imgSearchPart");
				enableSearch("imgSearchCarCompanyCd");
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				tbgClaimsPerMCReplacementPart.url = contextPath
				+ "/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
				+ $F("hidCarCompanyCd") + "&makeCd=" + $F("hidMakeCd") + "&modelYear=" + $F("hidModelYr") + "&lossExpCd=" + $F("hidPartCd");
				tbgClaimsPerMCReplacementPart._refreshList();
				$("rdoAsOf").enable();
				$("rdoAsOf").checked = true;
				$("rdoFrom").enable();
				$("rdoClaimFileDate").checked = true;
				$("hrefAsOfDate").disabled = false;				
				toggleCalendar(false);
				$("txtCarCompany").focus();
				$("txtCarCompany").removeAttribute("readonly");
				$("txtMake").removeAttribute("readonly");
				$("txtModelYear").removeAttribute("readonly");
				$("txtPart").removeAttribute("readonly");
				exec = false;			
			}
		} catch (e) {
			showErrorMessage("resetForm", e);
		}
	}
	
	function showCarCompanyCdLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS275CompanyLov",
					searchString : $F("txtCarCompany"),
					carMake : $F("txtMake"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
					carPart : $F("txtPart"), 
					modelYear : $F("txtModelYear"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End
					page : 1
				},
				title : "Car Company",
				width : 403,
				height : 390,
				columnModel : [ {
					id : "carCompanyCd",
					title : "Car Company Code",
					width : '110px'
				}, {
					id : "carCompany",
					title : "Car Company",
					width : '260px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtCarCompany").value,
				onSelect : function(row) {
					$("txtCarCompany").value = unescapeHTML2(row.carCompany);
					$("hidCarCompanyCd").value = row.carCompanyCd;
					$("txtCarCompany").readOnly = true;
					$("txtMake").focus();
					enableToolbarButton("btnToolbarEnterQuery");
					validateExec.obj = validateExec.obj + 1;
					if(validateExec.obj == 3){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					onLOV = false;
					$("txtCarCompany").focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.",
							imgMessage.INFO, "txtCarCompany");
					onLOV = false;
					$("txtCarCompany").focus();
					$("txtCarCompany").removeAttribute("readonly");
				}
			});
		} catch (e) {
			showErrorMessage("showCarCompanyCdLOV", e);
		}
	}

	function showMakeCdLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS275MakeLov",
					searchString : $F("txtMake"),
					carCompany : $F("txtCarCompany"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
					carPart : $F("txtPart"), 
					modelYear : $F("txtModelYear"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End
					page : 1
				},
				title : "Make",
				width : 403,
				height : 390,
				columnModel : [ {
					id : "makeCd",
					title : "Make Code",
					width : '110px'
				}, {
					id : "make",
					title : "Make",
					width : '260px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtMake").value,
				onSelect : function(row) {
					$("txtMake").value = unescapeHTML2(row.make);
					$("hidMakeCd").value = row.makeCd;
					$("txtMake").readOnly = true;
					$("txtModelYear").focus();
					enableToolbarButton("btnToolbarEnterQuery");
					validateExec.obj = validateExec.obj + 1;
					if(validateExec.obj == 3){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					onLOV = false;
					$("txtMake").focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.",
							imgMessage.INFO, "txtMake");
					onLOV = false;
					$("txtMake").focus();
					$("txtMake").removeAttribute("readonly");
				}
			});
		} catch (e) {
			showErrorMessage("showMakeCdLOV", e);
		}
	}
	
	function showModelYearLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS275YearLov",
					searchString : $F("txtModelYear"),
					carCompany : $F("txtCarCompany"),
					make : $F("txtMake"),
					carPart : $F("txtPart"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters.
					page : 1
				},
				title : "Model Year",
				width : 403,
				height : 390,
				columnModel : [ {
					id : "modelYear",
					title : "Model Year",
					width : '110px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtModelYear").value,
				onSelect : function(row) {
					$("txtModelYear").value = unescapeHTML2(row.modelYear);
					$("hidModelYr").value = row.modelYear;
					$("txtModelYear").readOnly = true;
					$("txtPart").focus();
					enableToolbarButton("btnToolbarEnterQuery");
					if(validateExec.obj == 3){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					onLOV = false;
					$("txtModelYear").focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.",
							imgMessage.INFO, "txtModelYear");
					onLOV = false;
					$("txtModelYear").focus();
					$("txtModelYear").removeAttribute("readonly");
				}
			});
		} catch (e) {
			showErrorMessage("showModelYearLOV", e);
		}
	}
	
	function showPartsLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS275PartsLov",
					searchString : $F("txtPart"),
					carCompany : $F("txtCarCompany"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
					make : $F("txtMake"),
					modelYear : $F("txtModelYear"), // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End
					page : 1
				},
				title : "Parts",
				width : 403,
				height : 390,
				columnModel : [ {
					id : "lossExpCd",
					title : "Code",
					width : '110px'
				}, {
					id : "lossExpDesc",
					title : "Description",
					width : '260px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtPart").value,
				onSelect : function(row) {
					$("txtPart").value = unescapeHTML2(row.lossExpDesc);
					$("hidPartCd").value = row.lossExpCd;
					$("txtPart").readOnly = true;
					enableToolbarButton("btnToolbarEnterQuery");
					validateExec.obj = validateExec.obj + 1;
					if(validateExec.obj == 3){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					onLOV = false;
					$("txtPart").focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.",
							imgMessage.INFO, "txtPart");
					onLOV = false;
					$("txtPart").focus();
					$("txtPart").removeAttribute("readonly");
				}
			});
		} catch (e) {
			showErrorMessage("showPartsLOV", e);
		}
	}
	
	
	function executeQuery() {
		setFieldOnSearch();
		//tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
		//+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
	    //+"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
		//tbgClaimsPerMCReplacementPart._refreshList();
		if (tbgClaimsPerMCReplacementPart.geniisysRows.length == 0) {
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtCarCompany");
			disableSearch("imgSearchCarCompanyCd");
			disableSearch("imgSearchMake");
			disableSearch("imgSearchYear");
			disableSearch("imgSearchPart");
			disableButton("btnPrintClmPerMCReplacementPart");
		}
	}
	
	//toggle toolbar buttons
	function togglePrintButton(enable) {
		if (nvl(enable, false) == true) {
			enableButton("btnPrintClmPerMCReplacementPart");
			enableToolbarButton("btnToolbarPrint");
		} else {
			disableButton("btnPrintClmPerMCReplacementPart");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	function toggleLossButton(enable) {
		if (nvl(enable, false) == true) {
			enableButton("btnShowLossDetails");
		} else {
			disableButton("btnShowLossDetails");
		}
	}
	
	function setObjMtrcarRepPart(obj) {		
		objMtrcarRepPart.claimId = obj.claimId;
		objMtrcarRepPart.clmLossId = obj.clmLossId;
		objMtrcarRepPart.lossExpCd = obj.lossExpCd;
	}
	
	function showLossDtls() {		
		try {
			overlayLossDtls = Overlay.show(contextPath
					+ "/GICLClaimListingInquiryController", {
				urlContent : true,
				urlParameters : {
					action : "getLossDtlsField",
					claimId : objMtrcarRepPart.claimId,
					clmLossId : objMtrcarRepPart.clmLossId,					
					lossExpCd : objMtrcarRepPart.lossExpCd
				},
				title : "Loss/Expense Details",
				height : '320px',
				width : '820px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	var reports = [];
	function printReport(){
		var content;
		var searchBy;
		if($("rdoClaimFileDate").checked){
			searchBy = "claimFileDate";
		}else{
			searchBy = "lossDate";
		}
		content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId=GICLR275&printerName="+
				$F("selPrinter")+"&carCompanyCd="+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+"&lossExpCd="+$F("hidPartCd")+"&searchBy="+searchBy					
				+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&asOfDate="+$F("txtAsOfDate");
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : "Claim Listing Per Motor Car Replacement Part"});		
			showMultiPdfReport(reports);
			reports = [];
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
					
					}
				}
			});
		}else if($F("selDestination") == "file"){
			var fileType = "PDF"; // added by carlo de guzman 4.01.2016 SR 5409
			
			if($("rdoPdf").checked) 
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV";  // end
				
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							//fileType    : $("rdoPdf").checked ? "PDF" : "XLS"}, removed by carlo de guzman 4.01.2016 SR5409
							  fileType : fileType}, // added by carlo de guzman 4.01.2016 SR5409
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV"){  // added by carlo de guzman 4.01.2016 SR 5409
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
							} else  // end						
						copyFileToLocal(response);
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
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
	}
	
	$("rdoClaimFileDate").observe("click", function() {
		toggleSearchBy();
		if(exec){
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
		}
	});

	$("rdoLossDate").observe("click", function() {
		toggleSearchBy();
		if(exec){
			tbgClaimsPerMCReplacementPart.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorcarReplacementParts&refresh=1&carCompanyCd="
			+$F("hidCarCompanyCd")+"&makeCd="+$F("hidMakeCd")+"&modelYear="+$F("hidModelYr")+ "&lossExpCd=" + $F("hidPartCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMCReplacementPart._refreshList();
		}
	});
	
	$("rdoAsOf").observe("click", function() {		
		toggleCalendar(false);
	});
	
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
	});
	
	$("imgSearchPart").observe("click", function() {
		showPartsLOV();
	});
	
	$("imgSearchYear").observe("click", function() {
		showModelYearLOV();
	});

	$("imgSearchCarCompanyCd").observe("click", function() {
		showCarCompanyCdLOV();
	});

	$("imgSearchMake").observe("click", function() {
		showMakeCdLOV();
	});

	$("txtCarCompany").observe("keyup", function() {
		$("txtCarCompany").value = $F("txtCarCompany").toUpperCase();
	});

	$("txtMake").observe("keyup", function() {
		$("txtMake").value = $F("txtMake").toUpperCase();
	});

	$("txtPart").observe("keyup", function() {
		$("txtPart").value = $F("txtPart").toUpperCase();
	});
	
	//Enter Query
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	//Execute Query
	$("btnToolbarExecuteQuery").observe("click", executeQuery);

	$("btnToolbarExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
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
	
 	$("btnShowLossDetails").observe("click", function() {
 		showLossDtls();
	});
 	
 	$("btnToolbarPrint").observe(
			"click",
			function() {
				showGenericPrintDialog("Print Claim Listing per Motor Car Replacement Part", printReport, "", true);
				$("csvOptionDiv").show(); // added by carlo de guzman 4.01.2016 SR5409
			});

	$("btnPrintClmPerMCReplacementPart").observe(
			"click",
			function() {
				showGenericPrintDialog("Print Claim Listing per Motor Car Replacement Part", printReport, "", true);
				$("csvOptionDiv").show(); // added by carlo de guzman 4.01.2016 SR5409
			});
	
	initializeGICLS275();
</script>