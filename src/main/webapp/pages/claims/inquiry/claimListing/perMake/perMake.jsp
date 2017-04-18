<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="clmListingPerMakeMainDiv" name="clmListingPerMakeMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Listing per Make</label>
		</div>
	</div>
	<div id="clmListingPerMakeDiv" align="center" class="sectionDiv">
		<div
			style="margin: 5px; margin-left: 50px; width: 500px; float: left;">
			<table border="0" align="center">
				<tr>
					<td class="rightAligned" style="width: 75px;">Make</td>
					<td class="rightAligned">
						<div id="makeDiv" style="width: 400px; float: left;"
							class="withIconDiv">
							<input type="hidden" id="hidMakeCd" name="hidMakeCd" /> <input
								type="text" id="txtMake" name="txtMake" value=""
								style="width: 365px;" class="withIcon allCaps" tabindex="101">
							<img style="float: right;"
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchMake" name="imgSearchMake" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Company</td>
					<td class="rightAligned"><input type="hidden"
						id="hidCarCompanyCd" name="hidCarCompanyCd" /> <input
						style="float: left; width: 394px;" type="text" id="txtCompany"
						name="txtCompany" readonly="readonly" tabindex="107"></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<fieldset style="margin-left: 0; width: 386px;">
							<legend>Search by</legend>
							<table border="0" align="center">
								<tr>
									<td><input style="float: left; margin: 4px 5px 0 0;"
										type="radio" id="rdoClaimFileDate" name="searchBy"
										value="claimFileDate" checked="checked" tabindex="108">
									</td>
									<td><label for="rdoClaimFileDate">Claim File Date</label>
									</td>
									<td><input style="float: left; margin: 4px 5px 0 43px;"
										type="radio" id="rdoLossDate" name="searchBy" value="lossDate"
										tabindex="109"></td>
									<td><label for="rdoLossDate">Loss Date</label></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv"
			style="float: left; width: 255px; margin: 10px 60px 0 35px;">
			<table border="0" align="center" style="margin: 3px;">
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate"
						id="rdoAsOf" checked="checked" title="As of" style="float: left;"
						tabindex="105" /><label for="rdoAsOf" title="As of"
						style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv"
							id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOfDate"
								class="withIcon" readonly="readonly" style="width: 140px;"
								tabindex="106" /> <img id="hrefAsOfDate"
								src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
								alt="As of Date" tabindex="107" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate"
						id="rdoFrom" title="From" style="float: left;" tabindex="108" /><label
						for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv"
							id="divFrom">
							<input type="text" removeStyle="true" id="txtFromDate"
								class="withIcon" readonly="readonly" style="width: 140px;"
								tabindex="109" /> <img id="hrefFromDate"
								src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
								alt="From Date" tabindex="110" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv"
							id="divTo">
							<input type="text" removeStyle="true" id="txtToDate" class="withIcon"
								readonly="readonly" style="width: 140px;" tabindex="111" /> <img
								id="hrefToDate"
								src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
								alt="To Date" tabindex="112" />
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="clmListingPerMakeDiv"
			style="padding: 10px 0 0 5px; height: 503px; width: 911px;">
			<div id="clmPerMakeDetailsGrid"
				style="height: 300px; margin-left: 5px;  width: 911px;"></div>
			<div style="margin-top: 5px; width: 907px;">
				<table cellpadding="0" align="center"
					style="width: 907px; margin-bottom: 2px;">
					<tr id="trOne">
						<td style="width: 160px; margin-bottom: 2px;"></td>
						<td class="rightAligned" style="width: 175px;">Totals</td>
						<td style="width: 100px;"><input style="width: 122px;"
							id="txtTotLossResAmt" name="txtTotLossResAmt" type="text"
							readOnly="readonly" class="money" /></td>
						<td style="width: 95px;"><input style="width: 122px;"
							id="txtTotLossPdAmt" name="txtTotLossPdAmt" type="text"
							readOnly="readonly" class="money" /></td>
						<td style="width: 100px;"><input style="width: 122px;"
							id="txtTotExpResAmt" name="txtTotExpResAmt" type="text"
							readOnly="readonly" class="money" /></td>
						<td style="width: 140px;"><input style="width: 122px;"
							id="txtTotExpPdAmt" name="txtTotExpPdAmt" type="text"
							readOnly="readonly" class="money" /></td>
					</tr>
					<tr>
						<td colspan="6">
							<div id="clmPerMakeDetails" class="sectionDiv"
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
							<div style="float: left; width: 100%; margin: 15px 0 6px 0;"
								align="center">
								<input type="button" class="disabledButton"
									id="btnPrintClmPerMake" value="Print Report" tabindex="501" />
							</div>
							<tr>
								<input type="hidden" id="hidSearchBy" name="hidSearchBy" value=""/>				
							</tr>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GICLS263");
	setDocumentTitle("Claim Listing Per Make");
	filterOn = false;
	exec = false;

	function initializeGICLS263() {
		$("txtMake").focus();
		$("txtMake").removeAttribute("readonly");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		toggleCalendar(false);
	}

	initializeGICLS263();

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

	function resetForm() {
		try {
			if ($F("hidMakeCd") != "" || $F("txtMake") != ""
					|| $F("hidCarCompanyCd") != "" || $F("txtCompany") != "") {
				$("hidMakeCd").value = "";
				$("txtMake").value = "";
				$("txtMake").value = "";
				$("hidCarCompanyCd").value = "";
				$("txtCompany").value = "";
				enableSearch("imgSearchMake");
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				tbgClaimsPerMake.url = contextPath
						+ "/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
						+ $F("hidMakeCd") + "&carCompanyCd="
						+ $F("hidCarCompanyCd");
				tbgClaimsPerMake._refreshList();
				$("rdoAsOf").enable();
				$("rdoAsOf").checked = true;
				$("rdoFrom").enable();
				$("rdoClaimFileDate").checked = true;
				$("hrefAsOfDate").disabled = false;				
				toggleCalendar(false);
				$("txtMake").focus();
				$("txtMake").removeAttribute("readonly");
				executeQuery = false;	
				togglePrintButton(false);
				exec = false;
			}
		} catch (e) {
			showErrorMessage("resetForm", e);
		}
	}
	
	//set searchby parameter value
	function toggleSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("hidSearchBy").value = "claimFileDate";
			if(exec){
				setTbgParametersPerSearchBy();
			}
		}else {
			$("hidSearchBy").value = "lossDate";
			if(exec){
				setTbgParametersPerSearchBy();
			}
		}
	}

	var jsonMakeDetails = JSON.parse('${jsonMakeDetails}');
	perMakeTableModel = {
		url : contextPath
				+ "/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
				+ $F("hidMakeCd") + "&carCompanyCd=" + $F("hidCarCompanyCd"),
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					setDetailsForm(null);
					tbgClaimsPerMake.keys.removeFocus(
							tbgClaimsPerMake.keys._nCurrentFocus, true);
					tbgClaimsPerMake.keys.releaseKeys();
					filterOn = true;
					//togglePrintButton(false);
				}
			},
			width : '900px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				setDetailsForm(tbgClaimsPerMake.geniisysRows[y]);
				tbgClaimsPerMake.keys.removeFocus(
						tbgClaimsPerMake.keys._nCurrentFocus, true);
				tbgClaimsPerMake.keys.releaseKeys();
				//togglePrintButton(true);
			},
			prePager : function() {
				setDetailsForm(null);
				tbgClaimsPerMake.keys.removeFocus(
						tbgClaimsPerMake.keys._nCurrentFocus, true);
				tbgClaimsPerMake.keys.releaseKeys();
				//togglePrintButton(false);
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				setDetailsForm(null);
				//togglePrintButton(false);
			},
			onSort : function() {
				setDetailsForm(null);
				tbgClaimsPerMake.keys.removeFocus(
						tbgClaimsPerMake.keys._nCurrentFocus, true);
				tbgClaimsPerMake.keys.releaseKeys();
				//togglePrintButton(false);
			},
			onRefresh : function() {
				setDetailsForm(null);
				tbgClaimsPerMake.keys.removeFocus(
						tbgClaimsPerMake.keys._nCurrentFocus, true);
				tbgClaimsPerMake.keys.releaseKeys();
				//togglePrintButton(false);
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
			filterOptionType : 'number',
			align : "right",
			titleAlign : "right",
			renderer : function(value) {
		    	return lpad(value,5,0);
		    }
		}, {
			id : "itemTitle",
			title : "Item Title",
			width : '180px',
			filterOption : true
		}, {
			id : "plateNo",
			title : "Plate No.",
			width : '80px',
			filterOption : true
		}, {
			id : "lossResAmt",
			title : "Loss Reserve",
			width : '130px',
			filterOption : true,
			align : 'right',
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}, {
			id : "lossPaidAmt",
			title : "Losses Paid",
			width : '130px',
			filterOption : true,
			align : 'right',
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}, {
			id : "expResAmt",
			title : "Expense Reserve",
			width : '130px',
			filterOption : true,
			align : 'right',
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		}, {
			id : "expPaidAmt",
			title : "Expenses Paid",
			width : '130px',
			filterOption : true,
			align : 'right',
			titleAlign : 'right',
			filterOptionType : 'number',
			geniisysClass : 'money'
		} ],
		rows : jsonMakeDetails.rows
	};

	tbgClaimsPerMake = new MyTableGrid(perMakeTableModel);
	tbgClaimsPerMake.pager = jsonMakeDetails;
	tbgClaimsPerMake.render('clmPerMakeDetailsGrid');
	tbgClaimsPerMake.afterRender = function(){
		if(tbgClaimsPerMake.geniisysRows.length > 0){
			if (filterOn == true) {
				computeTotal();
			}else {
				var rec = tbgClaimsPerMake.geniisysRows[0];
	 			$("txtTotLossResAmt").value 	= formatCurrency(rec.totLossResAmt);
				$("txtTotLossPdAmt").value 	= formatCurrency(rec.totLossPaidAmt);
				$("txtTotExpResAmt").value 		= formatCurrency(rec.totExpResAmt);
				$("txtTotExpPdAmt").value 	= formatCurrency(rec.totExpPaidAmt);
			}
		} else {
			$("txtTotLossResAmt").value 	= "";
			$("txtTotLossPdAmt").value 	= "";
			$("txtTotExpResAmt").value 		= "";
			$("txtTotExpPdAmt").value 	= "";
		}
	};
	
	function computeTotal() {
		var totLossResAmt  = 0;
		var totLossPaidAmt = 0;
		var totExpResAmt   = 0;
		var totExpPaidAmt  = 0;
		for (var i = 0; i < tbgClaimsPerMake.geniisysRows.length; i++) {
			totLossResAmt 	= totLossResAmt  + parseFloat(tbgClaimsPerMake.geniisysRows[i].lossResAmt);
			totLossPaidAmt	= totLossPaidAmt + parseFloat(tbgClaimsPerMake.geniisysRows[i].lossPaidAmt);
			totExpResAmt	= totExpResAmt   + parseFloat(tbgClaimsPerMake.geniisysRows[i].expResAmt);
			totExpPaidAmt	= totExpPaidAmt  + parseFloat(tbgClaimsPerMake.geniisysRows[i].expPaidAmt);
		}
		$("txtTotLossResAmt").value  = formatCurrency(parseFloat(nvl(totLossResAmt, "0")));
		$("txtTotLossPdAmt").value = formatCurrency(parseFloat(nvl(totLossPaidAmt, "0")));
		$("txtTotExpResAmt").value	 = formatCurrency(parseFloat(nvl(totExpResAmt, "0")));
		$("txtTotExpPdAmt").value  = formatCurrency(parseFloat(nvl(totExpPaidAmt, "0")));
	}
	
	 function setClaimListingPerMake() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false; 
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchMake");
		disableButton("btnPrintClmPerMake");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		toggleCalendar(false);
	}
	
	//set tbg url per selected date params
 	function setTbgParametersPerDate() {
		if ($("rdoAsOf").checked == true) {
			tbgClaimsPerMake.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
											   + $F("hidMakeCd") + "&carCompanyCd=" + $F("hidCarCompanyCd")+"&searchBy="+ $F("hidSearchBy")
											   +"&asOfDate="+$F("txtAsOfDate");
			tbgClaimsPerMake._refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			tbgClaimsPerMake.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
			   								   + $F("hidMakeCd") + "&carCompanyCd=" + $F("hidCarCompanyCd")+"&searchBy="+ $F("hidSearchBy")
			   								   +"&asOfDate="+$F("txtAsOfDate");
			tbgClaimsPerMake._refreshList();
		}
	} 
	
	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("hidSearchBy").value = "claimFileDate";
			tbgClaimsPerMake.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
											   + $F("hidMakeCd") + "&carCompanyCd=" + $F("hidCarCompanyCd")+"&searchBy="+ $F("hidSearchBy")
											   +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMake._refreshList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("hidSearchBy").value = "lossDate";
			tbgClaimsPerMake.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
											   + $F("hidMakeCd") + "&carCompanyCd=" + $F("hidCarCompanyCd")+"&searchBy="+ $F("hidSearchBy")
											   +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMake._refreshList();
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
	
	function setFieldOnSearch() {
		if (validateDate()) {
			tbgClaimsPerMake.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
			+$F("hidMakeCd")+"&carCompanyCd="+$F("hidCarCompanyCd")+"&searchBy="+$F("hidSearchBy")
		    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerMake._refreshList();
			toggleDateFields();
			toggleSearchBy();
			setTbgParametersPerDate();
			setTbgParametersPerSearchBy();
			disableSearch("imgSearchMake");
			disableInputField("txtMake");
			//setClaimListingPerMake();
			disableFields(true);
			disableToolbarButton("btnToolbarExecuteQuery");
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
	
	//toggle toolbar buttons
	function togglePrintButton(enable) {
		if (nvl(enable, false) == true) {
			enableButton("btnPrintClmPerMake");
			enableToolbarButton("btnToolbarPrint");
		} else {
			disableButton("btnPrintClmPerMake");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	function executeQuery() {
		setFieldOnSearch();
		tbgClaimsPerMake.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMake&refresh=1&makeCd="
		+$F("hidMakeCd")+"&carCompanyCd="+$F("hidCarCompanyCd")+"&searchBy="+$F("hidSearchBy")
	    +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
		tbgClaimsPerMake._refreshList();
		exec = true;
		if (tbgClaimsPerMake.geniisysRows.length == 0) {
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtMake");
			disableButton("btnPrintClmPerMake");
		} else {
			togglePrintButton(true);
		}
	}

	//get Make LOV
	function showGICLS263MakeLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS263MakeLov",
					page : 1,
					searchString : $("txtMake").value
				},
				title : "Make",
				width : 400,
				height : 386,
				columnModel : [ {
					id : "makeCd",
					title : "Make Code",
					width : '120px',
				}, {
					id : "carCompanyCd",
					title : "Car Company Code",
					width : '0',
					visible : false,
				}, {
					id : "make",
					title : "Make Name",
					width : '260px',
					renderer : function(value) {
						return unescapeHTML2(value);
					}
				}, {
					id : "carCompany",
					title : "Company",
					width : '0',
					visible : false,
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtMake").value,
				onSelect : function(row) {
					$("txtMake").value = unescapeHTML2(row.make);
					$("hidMakeCd").value = row.makeCd;
					$("txtCompany").value = unescapeHTML2(row.carCompany);
					$("hidCarCompanyCd").value = row.carCompanyCd;
					$("txtMake").readOnly = true;
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
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
			showErrorMessage("showGICLS263MakeLOV", e);
		}
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

	$("btnToolbarPrint").observe(
			"click",
			function() {
				showGenericPrintDialog("Print Claim Listing per Make", printReport, "", true);
				$("csvOptionDiv").show(); //Dren Niebres SR-5374 04.26.2016
			});

	$("btnPrintClmPerMake").observe(
			"click",
			function() {
				showGenericPrintDialog("Print Claim Listing per Make", printReport, "", true);
				$("csvOptionDiv").show(); //Dren Niebres SR-5374 04.26.2016
			});
	
	$("rdoClaimFileDate").observe("click", function() {
		toggleSearchBy();
	});

	$("rdoLossDate").observe("click", function() {
		toggleSearchBy();
	});

	
	//Enter Query
	$("btnToolbarEnterQuery").observe("click", resetForm);

	//Execute Query
	$("btnToolbarExecuteQuery").observe("click", executeQuery);

	$("btnToolbarExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});

	//LOV
	$("imgSearchMake").observe("click", function() {
		showGICLS263MakeLOV();
	});

	$("txtMake").observe("keyup", function() {
		$("txtMake").value = $F("txtMake").toUpperCase();
	});
	
	$("rdoAsOf").observe("click", function() {		
		toggleCalendar(false);
	});
	
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
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
	
	var reports = [];
	function printReport(){
		var content;
		var searchBy;
		var reportId; //Dren Niebres SR-5374 04.26.2016
		
		if($F("selDestination") == "file") { //Dren Niebres SR-5374 04.26.2016 - Start
			if ($("rdoPdf").checked) 
				reportId = "GICLR263";
			else 
				reportId = "GICLR263_CSV";		
		} else {
			reportId = "GICLR263";
		} //Dren Niebres SR-5374 04.26.2016 - End
		
		if($("rdoClaimFileDate").checked){
			searchBy = "claimFileDate";
		}else{
			searchBy = "lossDate";
		}
		content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId="+reportId+"&makeCd="+$F("hidMakeCd")+"&carCompanyCd="+$F("hidCarCompanyCd")+"&searchBy="+searchBy //Dren Niebres SR-5374 04.26.2016
				+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&asOfDate="+$F("txtAsOfDate");
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : "Claim Listing Per Make"});		
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
						showMessageBox("Printing Completed.", "S");
					}
				}
			});
		}else if($F("selDestination") == "file"){
			
			var fileType = "PDF"; //Dren Niebres SR-5374 04.26.2016 - Start
			
			if ($("rdoPdf").checked)
				fileType = "PDF";
			else
				fileType = "CSV2"; //Dren Niebres SR-5374 04.26.2016 - End
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType},
							  //fileType    : $("rdoPdf").checked ? "PDF" : "XLS"}, //Dren Niebres SR-5374 04.26.2016							  
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV2"){ //Dren Niebres SR-5374 04.26.2016 - Start
							copyFileToLocal(response, "csv");
						} else 
							copyFileToLocal(response);
					} //Dren Niebres SR-5374 04.26.2016 - End
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
</script>