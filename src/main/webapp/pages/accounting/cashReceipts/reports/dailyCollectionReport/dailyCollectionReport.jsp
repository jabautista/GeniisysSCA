<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="dailyCollectionRepMainDiv" name="dailyCollectionRepMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Daily Collection Report</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="dailyCollectionRepBody" name=dailyCollectionRepBody>
		<table align="center" style="padding: 40px">
			<tr>
				<td class="rightAligned">DCB No.</td>
				<td class="leftAligned">
					<input type="text" class="allCaps" id="txtFundCd" style="width: 60px;" maxlength="3"/>
					<input type="text" class="allCaps" id="txtBranchCd" style="width: 75px;" maxlength="2"/>
					<input type="text" class="integerUnformatted" id="txtDCBYear" style="width: 60px; text-align: right;" maxlength="5"/>
					<input type="text" class="integerUnformatted" lpad="6" id="txtDCBNo" style="width: 75px; text-align: right;" maxlength="7"/>
				</td>
				<td class="rightAligned">
				    <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDCBNo" name="searchDCBNo" alt="Go"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">DCB Date</td>
				<td class="leftAligned" colspan="2">
					<div style="float: left; width: 312px;" class="withIconDiv">
						<input type="text" id="txtDspDate" name="txtDueDate" class="withIcon disableDelKey" readonly="readonly" style="width: 287px;"/>
						<img id="hrefDspDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cashier No.</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 66px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input class="disableDelKey" type="text" id="txtCashierCd" name="txtCashierCd" style="width: 41px; float: left; border: none; height: 13px; text-align: right;" readonly="readonly"/>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCashierCd" name="searchCashierCd" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtPrintName" style="width: 234px;" maxlength="30" readonly="readonly"/>
				</td>
			</tr>
		</table>
		<div id="printDialogMainDiv" style="width: 100%; float: left; padding: 10px 0px 40px 203px;" align="center">
			<div class="sectionDiv" style="float: left; width: 35%; height: 125px;" id="printDialogFormDiv">
				<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer Name</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Copies</td>
						<td class="leftAligned">
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>					
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="buttonsDiv" style="float: left; width: 20%; margin-left: 5px; padding: 50px 0px 51px;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;">
			</div>
		</div>
	</div>
</div>

<script>
    /* Modified by : J. Diago 
    ** Modified Date : 05.12.2014
    ** Modifications : Added LOV search for DCB Nos.
    */
	initializeAll();
	var preDspDateValue = "";
	var objDailyCollectionRecord = [];
	resetAllFields();
	setModuleId("GIARDC01");
	setDocumentTitle("Daily Collection Report");
	$("mainNav").hide(); // added by jdiago 05.07.2014
	
	function resetAllFields() {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		//disableToolbarButton("btnToolbarPrint"); removed by jdiago 05.07.2014
		hideToolbarButton("btnToolbarPrint"); // added by jdiago 05.07.2014
		$("selDestination").value = "screen";
		disableSearch("searchCashierCd");
		disableButton("btnPrint");
		toggleRequiredFields("screen");
		preDspDateValue = "";
		$$("div#dailyCollectionRepBody input[type='text']").each(function (a) {
			$(a).clear();
			if ($(a).id != "txtCashierCd" && $(a).id != "txtDspDate") {
				$(a).readOnly = false;
			}
		});
		enableDate("hrefDspDate");
		enableSearch("searchDCBNo");
	}
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			$("rdoExcel").disable();	
			$("rdoCsv").disable();
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disable();
			}				
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}
	
	function showGIACS003CompanyLOV(findText2,branchCd,fundCd,dcbNo,dcbDate,dcbYear){ //Added parameters - Jerome Bautista 09.16.2015 SR 20162
		LOV.show({
			controller: "ACCashReceiptsReportsLOVController", //Controller changed by Jerome Bautista 09.16.2015 SR 20162
			urlParameters: {
				action: "getGIARDC01CashierLOV",
				findText2: findText2,
				branchCd: branchCd,
				fundCd: fundCd,
				dcbNo: dcbNo,
				dcbDate: dcbDate, //Added by Jerome Bautista 09.16.2015 SR 20162
				dcbYear: dcbYear //Added by Jerome Bautista 09.16.2015 SR 20162
			},
			title: "Valid Values for Cashier",
			width: 455,
			height: 388,
			autoSelectOneRecord: true, 
			columnModel : [
			               {
			            	   id : "cashierCd",
			            	   title: "Cashier",
			            	   align: 'right',
							   titleAlign : 'right',
			            	   width: '120px'
			               },
			               {
			            	   id: "printName",
			            	   title: "Name",
			            	   width: '319px'
			               }
			              ],
			draggable: true,
			onSelect: function(row) {
				$("txtCashierCd").value = row.cashierCd;
				$("txtPrintName").value = unescapeHTML2(row.printName);
				enableToolbarButton("btnToolbarEnterQuery");
			},
	  		onCancel: function(){
	  		}
		});
	}

	function setObjFilter() {
		try{
			var obj = new Object();
			obj.dcbYear = $F("txtDCBYear").trim();
			obj.fundCd = $F("txtFundCd").trim();
			obj.branchCd = $F("txtBranchCd").trim();
			return obj;
		}catch (e) {
			showErrorMessage("setObjFilter",e);
		}
	}
	
	function getDailyCollectionRecord(dspDate,dcbNo) {
		try {
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				parameters:{
							action:"getDailyCollectionRecord",
							dspDate: dspDate,
							dcbNo: dcbNo,
							objFilter : JSON.stringify(setObjFilter())
						   },
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						objDailyCollectionRecord = JSON.parse(response.responseText);
						if (objDailyCollectionRecord.rows.length > 0) {
							enableSearch("searchCashierCd");
							enableButton("btnPrint");
							enableToolbarButton("btnToolbarPrint");
							populateDailyCollection(objDailyCollectionRecord.rows[0]);
							disableSearch("searchDCBNo");
						} else {
							disableSearch("searchCashierCd");
							showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
						}
					}
				}
			});
			preDspDateValue = $F("txtDspDate");
			disableDate("hrefDspDate");  
			disableToolbarButton("btnToolbarExecuteQuery");
			$$("div#dailyCollectionRepBody input[type='text']").each(function (a) {
				$(a).readOnly = true;
			});
		} catch (e){
			showErrorMessage("getDailyCollectionRecord", e);
		}
	}
	
	function populateDailyCollection(obj) {
		try{
			$("txtFundCd").value 		= obj == null ? "" : nvl(obj.fundCd,"");
			$("txtBranchCd").value 		= obj == null ? "" : nvl(obj.branchCd,"");
			$("txtDCBYear").value 		= obj == null ? "" : nvl(obj.dcbYear,"");
			$("txtDCBNo").value 		= obj == null ? "" : lpad(nvl(obj.dcbNo,0),6,'0');
			$("txtDspDate").value 		= obj == null ? "" : nvl(obj.sdfTranDate,"");
			//$("txtCashierCd").value 	= obj == null ? "" : nvl(obj.cashierCd,"");
			//$("txtPrintName").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.printName,""));
		}catch (e) {
			showErrorMessage("populateDailyCollection",e);
		}
	}
	
	function printReport() {
		try {
			/* var fileType = $("rdoPdf").checked ? "PDF" : "XLS"; */
			var fileType = "";	
			var withCsv = null;
			if ($("rdoPdf").checked){
			    fileType = "PDF";
			}else if ($("rdoExcel").checked){
			    fileType = "XLS";
			}else {
			    fileType = "CSV";
			    withCsv = "Y";
			}	
			var content = contextPath+"/CashReceiptsReportPrintController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId=GIARR01A"
						+"&fileType="+fileType
						+"&reportTitle=DAILY COLLECTION REPORT"
						+"&fundCd="+$F("txtFundCd")
						+"&branchCd="+$F("txtBranchCd")
						+"&cashierCd="+$F("txtCashierCd")
						+"&dcbNo="+$F("txtDCBNo")
						+"&dcbYear="+$F("txtDCBYear")
						+"&dspDate="+$F("txtDspDate");
			  printGenericReport(content, "DAILY COLLECTION REPORT", null, withCsv);			
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	/* observe */
	/*$$("div#dailyCollectionRepBody input[type='text']").each(function (a) {
		$(a).observe("change", function(){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
			if ($F("txtFundCd").trim() != "" && $F("txtBranchCd").trim() != "" && $F("txtDCBNo").trim() != "") {
				enableSearch("searchCashierCd");
			}
			if ($F("txtFundCd").trim() != "" && $F("txtBranchCd").trim() != "" && $F("txtDCBYear").trim() != "" &&
			    $F("txtDCBNo").trim() != "" && $F("txtDspDate").trim() != "") {
					enableButton("btnPrint");
					enableToolbarButton("btnToolbarPrint");
			}
		});
	});*/
	
	$("hrefDspDate").observe("click", function(){
		scwShow($('txtDspDate'),this, null);
		preDspDateValue = $F("txtDspDate");
	});
	
	$("txtDspDate").observe("focus", function(){
		/*if (preDspDateValue != $F("txtDspDate")) {
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}
		if ($F("txtFundCd").trim() != "" && $F("txtBranchCd").trim() != "" && $F("txtDCBYear").trim() != "" &&
			    $F("txtDCBNo").trim() != "" && $F("txtDspDate").trim() != "") {
					enableButton("btnPrint");
					enableToolbarButton("btnToolbarPrint");
		}*/
		enableToolbarButton("btnToolbarEnterQuery");
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		resetAllFields();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		//getDailyCollectionRecord($F("txtDspDate"), $F("txtDCBNo").trim()==""? 0 : $F("txtDCBNo")); removed by jdiago 05.07.2014
		getDailyCollectionRecord($F("txtDspDate"), $F("txtDCBNo")); // added by jdiago 05.07.2014
	});
	
	$("btnPrint").observe("click", function(){
		printReport();
	});
	
	$("btnToolbarPrint").observe("click", function(){
		printReport();
	});
	
	$("searchCashierCd").observe("click", function(){
// 		var findText2 = $F("txtCashierCd").trim() == "" ? "%" : $F("txtCashierCd");
		showGIACS003CompanyLOV("%", $F("txtBranchCd"), $F("txtFundCd"), $F("txtDCBNo"), $F("txtDspDate"),$F("txtDCBYear")); //Added parameters - Jerome Bautista 09.16.2015 SR 20162
	});
	
	/* $("txtCashierCd").observe("change", function(e) {
		var findText2 = $F("txtCashierCd").trim() == "" ? "%" : $F("txtCashierCd");
		var cond = validateTextFieldLOV("/AccountingLOVController?action=getGIARDC01CashierLOV&branchCd="+$F("txtBranchCd")+"&fundCd="+$F("txtFundCd")+"&dcbNo="+$F("txtDCBNo"),findText2,"Searching, please wait...");
		if (cond == 2) {
			showGIACS003CompanyLOV(findText2, $F("txtBranchCd"), $F("txtFundCd"), $F("txtDCBNo"));
		} else if(cond == 0) {
			this.clear();
			$("txtPrintName").clear();
			showMessageBox("There's no record found.", imgMessage.INFO);
		}else{
			$("txtCashierCd").value = cond.rows[0].cashierCd;
			$("txtPrintName").value = unescapeHTML2(cond.rows[0].printName);
		}
	}); */
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	$("btnToolbarExit").observe("click", function() {
		$("acExit").click();
	});
	
	$$("div#dailyCollectionRepBody input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	
	$("searchDCBNo").observe("click", function(){
		showDCBNoLov();
	});
	
	function showDCBNoLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiardc01DcbNoLov",
				fundCd : $F("txtFundCd"),
				branchCd : $F("txtBranchCd"),
				dcbYear : $F("txtDCBYear"),
				dcbNo : $F("txtDCBNo"),
				dcbDate : $F("txtDspDate"),
				cashierCd : $F("txtCashierCd"),
				cashierName : $F("txtPrintName"),
				page : 1},
			title: "List of DCB Numbers",
			width: 525, //Modified by Jerome Bautista 09.16.2015 SR 20162
			height: 400,
			filterVersion: '2',
			columnModel : [
				{
					id : "fundCd",
					title: "DCB Fund",
					width: '100px',
					filterOption: true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : "branchCd",
					title: "DCB Branch",
					width: '100px',
					filterOption: true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : "dcbYear",
					title: "DCB Year",
					width: '100px',
					filterOption: true,
					align: 'right',
					titleAlign : 'right',
					filterOptionType : "integerNoNegative"
				},
				{
					id : "dcbNo",
					title: "DCB No",
					width: '100px',
					filterOption: true,
					align: 'right',
					titleAlign : 'right',
					filterOptionType : "integerNoNegative",
					renderer : function(value){
						return lpad(value,6,'0');
					}
				},
				{
					id : "dcbDate",
					title: "DCB Date",
					width: '104px', //Modified by Jerome Bautista 09.16.2015 SR 20162
					filterOption: true,
					filterOptionType : "formattedDate",
					align: 'center',
					titleAlign : 'center',
					renderer: function(value){
						return dateFormat(value, "mm-dd-yyyy");
					}
				}
				/* { //Commented out by Jerome Bautista 09.16.2015 SR 20162
					id : "cashierCd",
					title: "Cashier Code",
					width: '100px',
					filterOption: true,
					align: 'right',
					titleAlign : 'right',
					filterOptionType: "integerNoNegative"
				},
				{
					id : "cashierName",
					title: "Cashier Name",
					width: '100px',
					filterOption: true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				} */ //End of modification - Jerome Bautista
		    ],
		    autoSelectOneRecord: true,
		    onSelect: function(row) {
				$("txtFundCd").value = unescapeHTML2(row.fundCd);
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtDCBYear").value = row.dcbYear;
				$("txtDCBNo").value = lpad(row.dcbNo,6,'0');
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
		    }
		});
	}
</script>