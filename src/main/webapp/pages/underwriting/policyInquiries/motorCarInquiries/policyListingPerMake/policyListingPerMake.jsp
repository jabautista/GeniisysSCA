<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="polListingPerMake" name="polListingPerMake" style="height: 740px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Policy Listing per Make</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="polListingPerMakeFormDiv" name="polListingPerMakeFormDiv">
		<table cellspacing="0" align="center" style="padding: 20px 20px 0px 20px; width: 900px;">
			<tr>
				<td class="rightAligned" style="width:30px;">Make</td>
				<td class="leftAligned" style="width:400px;">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtMakeCd" name="txtMakeCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" delkey="1" class="disableDelKey integerNoNegativeUnformattedNoComma rightAligned" maxlength="13" tabindex="107" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchMake" name="searchMake" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtMake" name="txtMake" ignoreDelKey="1" style="width: 300px; float: left; height: 15px;" class="allCaps" maxlength="50" readonly="readonly"/>
					</span>
				</td>
				<td class="rightAligned" style="width:80px;">Company</td>
				<td>
					<span class="lovSpan required" style="width: 325px; margin-right: 5px; margin-left:10px;">
						<input type="text" id="txtCompany" name="txtCompany" ignoreDelKey="1" style="width:300px; float: left; border: none; height: 14px; margin: 0;" delkey="1" class="required disableDelKey allCaps" tabindex="101"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompany" name="searchCompany" alt="Go" style="float: right;" tabindex="102"/>
					</span>
				</td>
			</tr>
		</table>
		<div class="sectionDiv" style="width: 880px; margin: 10px 20px 20px 20px;">
			<table cellspacing="0" align="center" style="float: left; padding-top: 10px; padding-left: 10px; padding-bottom: 10px;">
				<tr>
					<td class="rightAligned">Crediting Branch</td>
					<td>
						<input type="text" id="txtCredBranch" name="txtCredBranch" style="width:100px; margin-left:10px;" tabindex="101" maxlength="2"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Search By :</td>
					<td class="rightAligned" style="padding-top:3px;">
						<input type="radio" name="searchBy" id="rdoIncDate" style="float: left; margin: 6px 9px 3px 20px; padding-top: 10px;" checked="checked"/>
						<label for="rdoIncDate" style="float: left; height: 20px; padding-top: 6px;" title="Incept Date">Incept Date</label>
					</td>
					<td class="rightAligned" style="padding-top:3px;">
						<input type="radio" name="searchBy" id="rdoEffDate" style="float: left; margin: 6px 9px 3px 2px; padding-top: 10px;"/>
						<label for="rdoEffDate" style="float: left; height: 20px; padding-top: 6px;" title="Effectivity Date">Effectivity Date</label>
					</td>
					<td class="rightAligned" style="padding-top:3px;">
						<input type="radio" name="searchBy" id="rdoIssDate" style="float: left; margin: 6px 9px 3px 10px; padding-top: 10px;"/>
						<label for="rdoIssDate" style="float: left; height: 20px; padding-top: 6px;" title="Issue Date">Issue Date</label>
					</td>
				</tr>
			</table>
			<table cellspacing="0" align="center" style="float: right; padding-top: 10px; padding-right: 10px; padding-bottom: 10px;">
				<tr>
					<td class="rightAligned"  style="padding-top: 4px;">
						<input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="105" checked="checked"/>
						<label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label>
					</td>
					<td class="leftAligned">
						<div style="float: left; width: 145px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 120px;" tabindex="106"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="107" onClick="scwShow($('txtAsOfDate'),this, null);"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-top:7px;">
						<input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="108"/>
						<label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label>
					</td>
					<td class="leftAligned" style="padding-top:3px;">
						<div style="float: left; width: 145px;" class="withIconDiv" id="fromDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 120px;" tabindex="109"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="110" onClick="scwShow($('txtFromDate'),this, null);"/>
						</div>
					</td>
					<td class="rightAligned" style="padding-top:3px;">To</td>
					<td class="leftAligned"style="padding-top:3px;">
						<div style="float: left; width: 145px;" class="withIconDiv" id="toDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 120px;" tabindex="111"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="112" onClick="scwShow($('txtToDate'),this, null);"/>
						</div>
					</td>
				</tr>
			</table>	
		</div>
	</div>
	<div class="sectionDiv">
		<div id="tablePolListingPerMake" style="padding: 5px; height: 250px;">
			<div id="tablePolListingPerMakeDiv" style="height: 100%;"></div>
		</div>
		<div id="totals" style="padding: 5px; height: 25px; margin-right: 10px;">
			<div id="totalsDiv" style="height: 100%;" align="right" >
				<table style=" float: right;">
					<tr>
						<td class="rightAligned">Totals :</td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtTotTSI" style="width: 130px;" readonly="readonly" tabindex="301" value="0.00"/></td>
						<td class="leftAligned"><input class="rightAligned" type="text" id="txtTotPrem" style="width: 130px;" readonly="readonly" tabindex="304" value="0.00"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv" style="width: 909px; margin:5px;">
			<table style="margin: 20px; float: left;">
				<tr>
					<td class="rightAligned">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolNo" style="width: 350px;" readonly="readonly" tabindex="301"/></td>
					<td class="rightAligned" style="width: 140px">Effectivity Date</td>
					<td class="leftAligned"><input type="text" id="txtEffDate" style="width: 250px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned"><input type="text" id="txtAssdName" style="width: 350px;" readonly="readonly" tabindex="302"/></td>
					<td class="rightAligned">Expiry Date</td>
					<td class="leftAligned"><input type="text" id="txtExpDate" style="width: 250px;" readonly="readonly" tabindex="305"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Incept Date</td>
					<td class="leftAligned"><input type="text" id="txtIncDate" style="width: 250px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Issue Date</td>
					<td class="leftAligned"><input type="text" id="txtIssDate" style="width: 250px;" readonly="readonly" tabindex="306"/></td>
				</tr>
			</table>
		</div>
	<div style="float: left; width: 100%; margin-bottom: 10px; padding: 10px;" align="center">
		<input type="button" class="button" id="btnPrintReport" value="Print Report" style="width: 100px;" tabindex="402"/>
	</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setModuleId("GIPIS192");
	setDocumentTitle("Policy Listing Per Make");
	onPageLoadSetting();
	
	function onPageLoadSetting(){
		showTableGrid();
		$("rdoAsOf").checked = true;
		fireEvent($("rdoAsOf"), "click");
		$("txtMakeCd").focus();
		params = new Object();
		params.exec = false;
		toggleDateFields();
		toolbarButtonSwitch(false);
		printButtonSwitch(false);
		onSearchSetting(false);
		$("txtAsOfDate").value 		= getCurrentDate();
		$("txtFromDate").value 		= "";
		$("txtToDate").value 		= "";
		$("txtAsOfDate").disabled 	= false;
		$("txtFromDate").disabled 	= true;
		$("txtToDate").disabled 	= true;
		enableDate("hrefAsOfDate");
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
	}
	
	
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	function showTableGrid(){
		try {
			policyListingPerMakeTable = {
				url : contextPath+ "/GIPIVehicleController?action=showPolListingPerMake",
				id: "polListingPerMake",
				options : {
					height : '250px',
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						setPolicyDetails(tbgPolicyListingPerMake.geniisysRows[y]);
						tbgPolicyListingPerMake.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						setPolicyDetails(null);
						tbgPolicyListingPerMake.keys.releaseKeys();
					},
					onSort : function(){
						setPolicyDetails(null);
						tbgPolicyListingPerMake.keys.releaseKeys();
						populateTotals(tbgPolicyListingPerMake.geniisysRows);
					},
					afterRender : function() {
						setPolicyDetails(null);
						tbgPolicyListingPerMake.keys.releaseKeys();
						populateTotals(tbgPolicyListingPerMake.geniisysRows);
					}, 
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function(){
							tbgPolicyListingPerMake.keys.releaseKeys();
							setPolicyDetails(null);
						},
						onRefresh : function(){
							tbgPolicyListingPerMake.keys.releaseKeys();
							setPolicyDetails(null);
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
						id : "itemNo",
						title : "Item No.",
						align : "right",
						titleAlign: "right",
						width : '70px',
						filterOptionType: 'number',
						filterOption : true
					},
					{
						id : "itemTitle",
						title : "Item Title",
						align : "left",
						titleAlign: "left",
						width : '150px',
						filterOption : true
					},
					{
						id : "plateNo",
						title : "Plate No.",
						align : "left",
						titleAlign: "left",
						width : '130px',
						filterOption : true
					},
					{
						id : "motorNo",
						title : "Engine No.",
						align : "left",
						titleAlign: "left",
						width : '130px',
						filterOption : true
					},
					{
						id : "serialNo",
						title : "Serial No",
						align : "left",
						titleAlign: "left",
						width : '130px',
						filterOption : true,
					},
					{
						id : "tsiAmt",
						title : "TSI Amount",
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
						title : "Premium Amount",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
				],
				rows : []
			};
			tbgPolicyListingPerMake = new MyTableGrid(policyListingPerMakeTable);
			tbgPolicyListingPerMake.render('tablePolListingPerMakeDiv');
		} catch (e) {
			showErrorMessage("policyListingPerMake.jsp", e);
		}
	}
	
	function getParams(compCd){
		var params = "";
		var searchBy = "";
		if($("rdoIncDate").checked){
			searchBy = 1;
		} else if ($("rdoEffDate").checked){
			searchBy = 2;
		} else {
			searchBy = 3;
		}
		params ="&makeCd="+$F("txtMakeCd")+"&companyCd="+compCd+"&searchBy="+searchBy+"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&credBranch="+$F("txtCredBranch");
		return params;
	}
	
	function queryTable(){
		var credBranch = $F("txtCredBranch");
		tbgPolicyListingPerMake.url = contextPath +"/GIPIVehicleController?action=showPolListingPerMake&refresh=1"+getParams(params.compCd);
		tbgPolicyListingPerMake._refreshList();
		if (tbgPolicyListingPerMake.geniisysRows.length == 0){
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtMakeCd");
			return false;
		}
		
		disableToolbarButton("btnToolbarExecuteQuery");
		printButtonSwitch(true);
		onSearchSetting(true);
		populateTotals(tbgPolicyListingPerMake.geniisysRows);
		params.exec = true;
		$("txtCredBranch").value = credBranch;
	}
	
	function showMakeLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action   : "getGipis192MakeLOV",
					makeCd	: $("txtMakeCd").value,
					companyCd	: params.compCd==null?"":params.compCd,
					page : 1
				},
				title: "List of Make and Car Company",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'makeCd',
						title: 'Make Cd',
						width : '55px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'make',
						title: 'Make',
					    width: '198px',
					    align: 'left'
					},
					{
						id : 'company',
						title: 'Car Company',
					    width: '197px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtMakeCd").value = unescapeHTML2(row.makeCd);
						$("txtMake").value = unescapeHTML2(row.make); 
						$("txtCompany").value = unescapeHTML2(row.company); 
						params.compCd = unescapeHTML2(row.companyCd);
						toolbarButtonSwitch(true);
						//disableSearch("searchCompany");
						//$("txtCompany").readOnly = true;
					}
				},
				onCancel: function(){
					$("txtMakeCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showMakeLOV",e);
		}
	}
	
	function showCompanyLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action   : "getGipis192CompanyLOV",
					page : 1
				},
				title: "List of Car Company",
				width: 380,
				height: 400,
				columnModel: [
		 			{
						id : 'companyCd',
						title: 'Car Company Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'company',
						title: 'Car Company',
					    width: '250px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtCompany").value = unescapeHTML2(row.company); 
						params.compCd = unescapeHTML2(row.companyCd);
						toolbarButtonSwitch(true);
					}
				},
				onCancel: function(){
					$("txtCompany").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showCompanyLOV",e);
		}
	}
	
	function toggleDateFields() {
		if ($("rdoAsOf").checked == true) {
			disableDate("hrefAsOfDate");
			$("rdoAsOf").disabled 		= true;
			$("rdoFrom").disabled 		= true;
			$("txtAsOfDate").disabled 	= true;
			$("fromDiv").removeClassName("required");
			$("txtFromDate").removeClassName("required");
			$("toDiv").removeClassName("required");
			$("txtToDate").removeClassName("required");
		} else if ($("rdoFrom").checked == true) {
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("rdoFrom").disabled 		= true;
			$("rdoAsOf").disabled 		= true;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			$("fromDiv").addClassName("required");
			$("txtFromDate").addClassName("required");
			$("toDiv").addClassName("required");
			$("txtToDate").addClassName("required");
		}
	}
	
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").readOnly 	= false;
			$("txtToDate").readOnly 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("fromDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtFromDate").setStyle({backgroundColor: '#FFFACD'});
			$("toDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtToDate").setStyle({backgroundColor: '#FFFACD'});
		}else{	
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").readOnly 	= true;
			$("txtToDate").readOnly 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("fromDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("toDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
		}
	}
	
	function toolbarButtonSwitch(sw){
		if(sw){
			enableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		} else {
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		}
	}
	
	function printButtonSwitch(sw){
		if(sw){
			enableToolbarButton("btnToolbarPrint");
			enableButton("btnPrintReport");
		} else {
			disableToolbarButton("btnToolbarPrint");
			disableButton("btnPrintReport");
		}
		
	}
	
	function onSearchSetting(sw){
		if(sw){
			disableSearch("searchMake");
			disableSearch("searchCompany");
			disableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("txtMakeCd").readOnly = true;
			$("txtCompany").readOnly = true;
			$("rdoFrom").disabled = true;
			$("rdoAsOf").disabled = true;
			$("txtCredBranch").readOnly = true;
			$$("input[name='searchBy']").each(function(rb){
				rb.disabled = true;
			});
		} else {
			enableSearch("searchMake");
			enableSearch("searchCompany");
			enableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("txtMakeCd").readOnly = false;
			$("txtCompany").readOnly = false;
			$("rdoFrom").disabled = false;
			$("rdoAsOf").disabled = false;
			$("txtCredBranch").readOnly = false;
			$$("input[name='searchBy']").each(function(rb){
				rb.disabled = false;
			});
		}
	}
	
	function setPolicyDetails(row){
		try{
			$("txtCredBranch").value = row == null ? "" : unescapeHTML2(row.issCd);
			$("txtPolNo").value 	 = row == null ? "" : unescapeHTML2(row.policyNo);
			$("txtAssdName").value 	 = row == null ? "" : unescapeHTML2(row.assdName); 
			$("txtEffDate").value 	 = row == null ? "" : dateFormat(row.effDate, "mm-dd-yyyy"); 
			$("txtExpDate").value 	 = row == null ? "" : dateFormat(row.expiryDate, "mm-dd-yyyy"); 
			$("txtIncDate").value 	 = row == null ? "" : dateFormat(row.inceptDate, "mm-dd-yyyy"); 
			$("txtIssDate").value 	 = row == null ? "" : dateFormat(row.issueDate, "mm-dd-yyyy"); 
		}catch(e){	
			showErrorMessage("setPolicyDetails", e);
		}
	}
	
	function populateTotals(obj){
		var totTSI = 0;
		var totPrem = 0;
		/*if (obj != null){
			for(var i=0;i<obj.length;i++){
				totTSI = Number(totTSI) + Number(obj[i].tsiAmt);
				totPrem = Number(totPrem) + Number(obj[i].premAmt);
			}	commented out by Gzelle 07112014*/
		if (obj.length > 0){
			$("txtTotTSI").value 		= formatCurrency(obj[0].totTsiAmt);
			$("txtTotPrem").value 		= formatCurrency(obj[0].totPremAmt);
		}else {
			$("txtTotTSI").value 		= formatCurrency(nvl(totTSI, 0));
			$("txtTotPrem").value 		= formatCurrency(nvl(totPrem, 0));
		}
	}
	
	//Print Report
	function printReport(){
		try {
			var content = contextPath + "/PolicyInquiryPrintController?action=printGIPIR192"
							+"&reportId=GIPIR192"+getParams(params.compCd);
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Policy Listing per Make");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				
			//added here by Alejandro Burgos 02.05.2016
			var fileType = "PDF";
		
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV"; 
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV"){ 
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
						} else 
							copyFileToLocal(response);
					}
				}
			});
			//ended here by Alejandro Burgos 02.05.2016

			//comment out by Alejandro Burgos 02.05.2016
				/*new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				}); */
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
	
	$("searchMake").observe("click",showMakeLOV);
	$("searchCompany").observe("click",showCompanyLOV);
	
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
	});
	$("rdoAsOf").observe("click", function() {
		toggleCalendar(false);
	});
	
	$$("input[type='text'] #inputForm").each(function(a) {
		a.observe("change", function() {
			if($(a).value!=""){
				toolbarButtonSwitch(true);
			}
		});
	});
	
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
			customShowMessageBox("FROM Date should not be less than the TO date.", "I", "txtFromDate");
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
			customShowMessageBox("FROM Date should not be less than the TO date.", "I", "txtToDate");
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
	
	$("txtMakeCd").observe("change",function(){
		if($("txtMakeCd").value == ""){
			$("txtMake").clear();
			$("txtCompany").clear();
			params.compCd = "";
			enableSearch("searchCompany");
			$("txtCompany").readOnly = false;
		} else {
			validateMake();
		}
	});
	
	$("txtCompany").observe("change",function(){
		if($("txtCompany").value == ""){
			params.compCd = "";
		} else {
			validateCompany();
		}
	});
	
	$("txtCredBranch").observe("keyup", function() {
		$("txtCredBranch").value = $F("txtCredBranch").toUpperCase();
	});
	
	$("btnToolbarExecuteQuery").observe("click",function(){
		if(checkAllRequiredFieldsInDiv("polListingPerMakeFormDiv")){
			queryTable();
		}
	});
	
	$("btnToolbarEnterQuery").observe("click",function(){
		$("txtMakeCd").clear();
		$("txtMake").clear();
		$("txtCompany").clear();
		$("txtCredBranch").clear();
		$("txtTotTSI").value = "0.00";
		$("txtTotPrem").value = "0.00";
		delete params;
		onPageLoadSetting();
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Policy Listing per Make", printReport, "", true);
		$("csvOptionDiv").show(); //added by Alejandro Burgos 02.05.2016
	});
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Policy Listing per Make", printReport, "", true);
		$("csvOptionDiv").show(); //added by Alejandro Burgos 02.05.2016
	});
	
	$("rdoIncDate").observe("click",function(){
		if(params.exec){
			queryTable();
		}
	});
	$("rdoEffDate").observe("click",function(){
		if(params.exec){
			queryTable();
		}
	});
	$("rdoIssDate").observe("click",function(){
		if(params.exec){
			queryTable();
		}
	});
	
	function validateMake(){
		new Ajax.Request(contextPath+"/GIPIVehicleController", {
			method: "POST",
			parameters: {
				action: "validateGipis192Make",
				makeCd: $F("txtMakeCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.makeCd, "") == ""){
						showWaitingMessageBox("Invalid Value for Make.", "I", function(){
							$("txtMakeCd").focus();
							$("txtMake").value = "";
							$("txtCompany").value = "";
							params.compCd = "";
						});
					}else{
						$("txtMakeCd").value = unescapeHTML2(obj.makeCd);
						$("txtMake").value = unescapeHTML2(obj.make);
						$("txtCompany").value = unescapeHTML2(obj.company);
						params.compCd = obj.companyCd;
						toolbarButtonSwitch(true);
						//disableSearch("searchCompany");
						//$("txtCompany").readOnly = true;
					}
				}
			}
		});
	}
	
	function validateCompany(){
		new Ajax.Request(contextPath+"/GIPIVehicleController", {
			method: "POST",
			parameters: {
				action: "validateGipis192Company",
				company: $F("txtCompany")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.company, "") == ""){
						showWaitingMessageBox("Invalid Value for Company.", "I", function(){
							$("txtCompany").focus();
							params.compCd = "";
						});
					}else{
						$("txtCompany").value = unescapeHTML2(obj.company);
						params.compCd = obj.companyCd;
						toolbarButtonSwitch(true);
					}
				}
			}
		});
	}
</script>