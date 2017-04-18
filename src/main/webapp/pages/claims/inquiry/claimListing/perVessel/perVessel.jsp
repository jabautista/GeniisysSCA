<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="perVesselMainDiv" >
	<!-- <div id="perVesselSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>  -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Vessel</label>
	   	</div>
	</div>	
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 65px;">
				<tr>
					<td class="rightAligned">Vessel</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidVesselCd" name="hidVesselCd" value="">
							<input type="text" id="txtVessel" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchVessel" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 110px; margin-bottom: 10px;">
				<fieldset style="width: 387px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="103" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="104" />
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="105" checked="checked"/>
						<label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label>
					</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="106"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="107"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="108"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFrom">
							<input type="text" name="fromTo" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="109"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="110"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divTo">
							<input type="text" name="fromTo" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="112"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="perVesselTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perVesselTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div style="margin: 5px; float: right; margin-right: 20px;">
			<table>
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossReserve" style="width: 100px; text-align: right;" readonly="readonly" tabindex="202"/></td>
					<td class=""><input type="text" id="txtTotExpenseReserve" style="width: 100px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotLossesPaid" style="width: 100px; text-align: right;" readonly="readonly" tabindex="204"/></td>
					<td class=""><input type="text" id="txtTotExpensesPaid" style="width: 100px; text-align: right;" readonly="readonly" tabindex="205"/></td>
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
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>		
	</div>
</div>
<script type="text/javascript">
try{
	var onLOV = false;
	var vesselCd = "";
	setModuleId("GICLS262");
	setDocumentTitle("Claim Listing per Vessel");
	
	function initGICLS262(){
		$("txtVessel").focus();
		$("rdoAsOf").checked = true;
		$("rdoClaimFileDate").checked = true;
		$("txtAsOf").value = getCurrentDate();
		disableFromToFields();
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		setPrintButtons(false);
		onLOV = false;
	}
	
	function doPrint(){
		var content; 
		var searchBy;
		
		if($("rdoClaimFileDate").checked){
			searchBy = "claimFileDate";
		}else{
			searchBy = "lossDate";
		}

		content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId=GICLR262&printerName="+$F("selPrinter")
			+"&vesselCd="+$F("hidVesselCd")+"&searchBy="+searchBy+"&fromDate="+$F("txtFrom")+"&toDate="+$F("txtTo")+"&asOfDate="+$F("txtAsOf");
		if($F("selDestination") == "screen"){
			showPdfReport(content, "Claim Listing per Vessel");
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
			var fileType = "PDF"; //Dren 03.08.2016 SR-5373
			
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV"; 
			/* else if ($("rdoExcel").checked)
				fileType = "XLS";  */ //Dren 03.17.2016 SR-5373
			
			new Ajax.Request(content, {
				parameters : {destination : "file",
				fileType : fileType},
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response))
					{if (fileType == "CSV"){
						copyFileToLocal(response, "csv");
						deleteCSVFileFromServer(response.responseText);
						} else 
						copyFileToLocal(response);
					}
				}			  
			}); //Dren 03.08.2016 SR-5373		
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
	
	function executeQuery(){
		tbgClaimsPerVessel.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerVessel&refresh=1" + getParams();
		tbgClaimsPerVessel._refreshList();
		if(tbgClaimsPerVessel.geniisysRows.length == 0){
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtVessel");
			setPrintButtons(false);
		}else{
			setPrintButtons(true);
		}
		disableFields();
	}
	
	function changeSearchByOpt() {
		if($("txtVessel").readOnly){
 			tbgClaimsPerVessel.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerVessel&refresh=1" + getParams();
			tbgClaimsPerVessel._refreshList();
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
	
	function getParams(){
		var params = "";
		if($("rdoClaimFileDate").checked)
			params = "&searchByOpt=1";
		else
			params = "&searchByOpt=2";
		params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value + "&vesselCd="+$F("hidVesselCd");
		return params;
	}
	
	function setDetails(rec){
		try {
			$("txtPolicyNo").value = rec == null ? "" : rec.policyNumber;
 			$("txtAssured").value = rec == null ? "" : unescapeHTML2(rec.assuredName);
			$("txtLossDate").value = rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtClaimFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
			$("txtClaimNo").value = rec == null ? "" : rec.claimNumber;
			$("txtClaimStatus").value = rec == null ? "" : rec.clmStatDesc;
		} catch (e) {
			showErrorMessage("setDetails", e);
		}
	}
	
	function setPrintButtons(x){
		if(x){
			enableButton("btnPrintReport");
			enableToolbarButton("btnToolbarPrint");
		} else {
			disableButton("btnPrintReport");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
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
		$("rdoAsOf").disable();
		$("txtAsOf").disable();
		$("rdoFrom").disable();
		$("txtFrom").disable();
		$("txtTo").disable();
		$("imgAsOf").disabled = true;
		$("imgFrom").disabled = true;
		$("imgTo").disabled = true;
		disableSearch("imgSearchVessel");
		disableDate("imgAsOf");
		disableDate("imgFrom");
		disableDate("imgTo");
		$("txtVessel").readOnly = true;
		$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
	}

	function resetForm(){
		$("txtVessel").clear();
		$("hidVesselCd").clear();
		$("txtVessel").readOnly = false;
		enableSearch("imgSearchVessel");
		$("rdoAsOf").enable();
		$("rdoClaimFileDate").checked = true;
		$("rdoLossDate").checked = false;
		$("rdoFrom").disabled = false;
		setDetails(null);
		$("txtTotLossReserve").clear();
		$("txtTotExpenseReserve").clear();
		$("txtTotLossesPaid").clear();
		$("txtTotExpensesPaid").clear();
		tbgClaimsPerVessel.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerVessel&refresh=1&" + getParams();
		tbgClaimsPerVessel._refreshList();
		initGICLS262();
	}
	
	function showGICLS262VesselLOV(){
		onLOV = true;
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {
				action: "getClmVesselLOV",
				search: $F("txtVessel"),
				page: 1
			},
			title: "Vessel",
			width: 410,
			height: 386,
			columnModel : [{
				id: "vesselCd",
				title: "Vessel Cd",
				width: '80px'
			},{
				id: "vesselName",
				title: "Vessel Name",
				width: '310px',
				renderer : function(val){
					return escapeHTML2(val);
				}
			}],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: $F("txtVessel"),
			onSelect: function(row){
				onLOV = false;
				$("txtVessel").value = unescapeHTML2(row.vesselName);
				$("hidVesselCd").value = row.vesselCd;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel : function(){
				onLOV = false;
				$("txtVessel").focus();
			},
			onUndefinedRow: function(){
				onLOV = false;
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtVessel");
			}
		});
	}
	
	var jsonClmListPerVessel = JSON.parse('${jsonClmListPerVessel}');
	perVesselTableModel = {
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ]
			},
			width: '900px',
			height: '270px',
			onCellFocus: function(element, value, x, y, id){
				setDetails(tbgClaimsPerVessel.geniisysRows[y]);
				tbgClaimsPerVessel.keys.removeFocus(tbgClaimsPerVessel.keys._nCurrentFocus, true);
				tbgClaimsPerVessel.keys.releaseKeys();
			},
			onRemoveRowFocus: function(element, value, x, y, id){
				setDetails(null);
				tbgClaimsPerVessel.keys.removeFocus(tbgClaimsPerVessel.keys._nCurrentFocus, true);
				tbgClaimsPerVessel.keys.releaseKeys();
			}
		},
		columnModel : [{
			id: "recordStatus",
			title: "",
			width: "0",
			visible: false
		}, {
			id: "divCtrId",
			width: "0",
			visible: false
		}, {
			id: "claimNo",
			width: "0",
			visible: false
		}, {
			id: "vesselCd",
			width: "0",
			visible: false
		},
		{
			id: "clmStatDesc",
			width: "0",
			visible: false
		},
		{
			id: "lossDate",
			width: "0",
			visible: false
		},
		{
			id: "claimNumber",
			width: "0",
			visible: false
		},
		{
			id: "policyNumber",
			width: "0",
			visible: false
		},
		{
			id: "clmFileDate",
			width: "0",
			visible: false
		},
		{
			id: "assuredName",
			width: "0",
			visible: false
		},{
			id: "itemNo",
			width: "90px",
			visible: true,
			title: "Item No.",
			filterOption : true,
			filterOptionType : 'integerNoNegative',
			align : "right",
			titleAlign : "right",
			renderer 	 : function(value) {
				return formatNumberDigits(value, 9);
			}
		},{
			id: "itemTitle",
			width: "130px",
			visible: true,
			filterOption : true,
			title: "Item Title"
		},{
			id: "dryDate",
			width: "100px",
			visible: true,
			title: "Dry Date",
			filterOption : true,
			filterOptionType : 'formattedDate',
			renderer : function(value) {
				if(value == ""){
					return null;
				}else{
					return dateFormat(value, 'mm-dd-yyyy');
				}
			}
		},{
			id: "dryPlace",
			width: "95px",
			visible: true,
			title: "Dry Place",
			filterOption : true
		},{
			id: "lossResAmt",
			width: "110px",
			visible: true,
			title: "Loss Reserve",
			geniisysClass: 'money',
			filterOption : true,
			filterOptionType : 'number',
			align : "right",
			titleAlign : "right"
		},{
			id: "expResAmt",
			title: "Expense Reserve",
			width: "110px",
			visible: true,
			geniisysClass: 'money',
 			filterOption : true,
			filterOptionType : 'number',
			align : "right",
			titleAlign : "right"
		},{
			id: "losPaidAmt",
			title: "Losses Paid",
			width: "110px",
			visible: true,
			geniisysClass: 'money',
 			filterOption : true,
			filterOptionType : 'number',
			align : 'right',
			titleAlign : 'right'
		},{
			id: "expPaidAmt",
			title: "Expense Paid",
			width: "110px",
			visible: true,
			geniisysClass: 'money',
 			filterOption : true,
			filterOptionType : 'number',
			align : "right",
			titleAlign : "right"
		},],
		rows : jsonClmListPerVessel.rows
	};
	tbgClaimsPerVessel = new MyTableGrid(perVesselTableModel);
	tbgClaimsPerVessel.pager = jsonClmListPerVessel;
	tbgClaimsPerVessel.render("perVesselTable");
	tbgClaimsPerVessel.afterRender = function(){
		setDetails(null);
		if(tbgClaimsPerVessel.geniisysRows.length>0){
			var rec = tbgClaimsPerVessel.geniisysRows[0];
			$("txtTotLossReserve").value = formatCurrency(rec.totLossResAmt);
			$("txtTotExpenseReserve").value = formatCurrency(rec.totExpResAmt);
			$("txtTotLossesPaid").value = formatCurrency(rec.totLossPdAmt);
			$("txtTotExpensesPaid").value = formatCurrency(rec.totExpPdAmt);
		}else{
			$("txtTotLossReserve").clear();
			$("txtTotExpenseReserve").clear();
			$("txtTotLossesPaid").clear();
			$("txtTotExpensesPaid").clear();
		}
	};

	$("imgSearchVessel").observe("click", function(){
		if(onLOV)
			return;
		showGICLS262VesselLOV();
	});

	$("rdoAsOf").observe("click", disableFromToFields);
	$("rdoFrom").observe("click", disableAsOfFields);
	$("rdoClaimFileDate").observe("click", changeSearchByOpt);
	$("rdoLossDate").observe("click", changeSearchByOpt);

	$("imgAsOf").observe("click", function() {
		if ($("imgAsOf").disabled == true)
			return;
		scwShow($('txtAsOf'), this, null);
	});
	
	$("imgFrom").observe("click", function() {
		if ($("imgFrom").disabled == true)
			return;
		scwShow($('txtFrom'), this, null);
	});
	
	$("imgTo").observe("click", function() {
		if ($("imgTo").disabled == true)
			return;
		scwShow($('txtTo'), this, null);
	});	
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(validateRequiredDates())
			executeQuery();
	});

	$("txtVessel").observe("keypress", function(event){
		if(event.keyCode == Event.KEY_RETURN) {
	    	if(onLOV)
	    		return;
	    	showGICLS262VesselLOV();
	    } else
	    	disableToolbarButton("btnToolbarExecuteQuery");
	});	
	
	/* $("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	}); */
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Vessel", doPrint, "", true);
		$("csvOptionDiv").show(); //Dren 03.08.2016 SR-5373
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Vessel", doPrint, "", true);
		$("csvOptionDiv").show(); //Dren 03.08.2016 SR-5373
	});
	
	$$("input[name='fromTo']").each(function(field) {
	 field.observe("focus", function() {
		 var sysdate = new Date();
		 var fieldDate = $F(field) != "" ? new Date($F(field).replace(/-/g,"/")) : "";
			 if(fieldDate > sysdate && fieldDate != ""){
				 customShowMessageBox(field.id.substring(3) + " Date should not be later than Current Date.", "E", field);
				 $(field).clear();
				 return false;
			 }else{
				 checkInputDates(field, "txtFrom", "txtTo");
			 }
		});
	});
	 
	$("txtAsOf").observe("focus", function() {
		var sysdate = new Date();
		var fieldDate = $F("txtAsOf") != "" ? new Date($F("txtAsOf").replace(/-/g,"/")) : "";
		if(fieldDate > sysdate && fieldDate != ""){
			customShowMessageBox("As Of Date should not be later than Current Date.", "E", "txtAsOf");
			$("txtAsOf").clear();
			return false;
		}
	});
	
	initializeAll();
	initGICLS262();
	
}catch(e){
	showErrorMessage("Error in Claim Listing per Vessel: ", e);
}
</script>