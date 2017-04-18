<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="budgetProductionMainDiv" name="budgetProductionMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Budget Production</label>
		</div>
	</div>
	
	<div class="sectionDiv">
		<div class="sectionDiv" style="width: 69%; margin: 40px 138px 40px 138px; height: 485px;">
			<div id="parameterDiv" class="sectionDiv" style="width: 613px; margin: 10px 0 5px 10px;">
				<table style="padding-top: 10px; margin-left: 86px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<select id="fromMonth" name="fromMonth" class="required" style="width: 140px;" tabindex="101">
								<option value="JAN">JANUARY</option>
								<option value="FEB">FEBRUARY</option>
								<option value="MAR">MARCH</option>
								<option value="APR">APRIL</option>
								<option value="MAY">MAY</option>
								<option value="JUN">JUNE</option>
								<option value="JUL">JULY</option>
								<option value="AUG">AUGUST</option>
								<option value="SEP">SEPTEMBER</option>
								<option value="OCT">OCTOBER</option>
								<option value="NOV">NOVEMBER</option>
								<option value="DEC">DECEMBER</option>
								<option value="" selected="selected"></option>
							</select>
						</td>
						<td>
							<input id="fromYear" name="fromYear" type="text" class="required integerNoNegativeUnformatted" style="width: 50px; height: 13px; margin-bottom: 3px;" maxlength="4" tabindex="102">
						</td>
						<td class="rightAligned" style="width: 40px;">To</td>
						<td>
							<select id="toMonth" name="toMonth" class="required" style="width: 140px;" tabindex="103">
								<option value="JAN">JANUARY</option>
								<option value="FEB">FEBRUARY</option>
								<option value="MAR">MARCH</option>
								<option value="APR">APRIL</option>
								<option value="MAY">MAY</option>
								<option value="JUN">JUNE</option>
								<option value="JUL">JULY</option>
								<option value="AUG">AUGUST</option>
								<option value="SEP">SEPTEMBER</option>
								<option value="OCT">OCTOBER</option>
								<option value="NOV">NOVEMBER</option>
								<option value="DEC">DECEMBER</option>
								<option value="" selected="selected"></option>
							</select>
						</td>
						<td>
							<input id="toYear" name="toYear" type="text" class="required integerNoNegativeUnformatted" style="width: 52px; height: 13px; margin-bottom: 3px;" maxlength="4" tabindex="104">
						</td>
					</tr>
				</table>
				<table style="margin: 0 0 10px 30px;">
					<tr>
						<td class="rightAligned">Line</td>
						<td>
							<span class="lovSpan" style="width: 70px;">
								<input id="lineCd" name="lineCd" type="text" class="upper" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="2" lastValidValue="" tabindex="105"/>
								<img id="searchLine" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td>
							<input id="lineName" type="text" readonly="readonly" style="height: 13px; width: 370px;" value="ALL LINES" tabindex="106">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Issuing Source</td>
						<td>
							<span class="lovSpan" style="width: 70px;">
								<input id="branchCd" name="branchCd" type="text" class="upper" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="2" lastValidValue="" tabindex="107"/>
								<img id="searchBranch" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td>
							<input id="branchName" type="text" readonly="readonly" style="height: 13px; width: 370px;" value="ALL ISSUE SOURCES" tabindex="108">
						</td>
					</tr>
				</table>
			</div>
			
			<fieldset style="width: 150px; height: 120px; margin: 5px 0 0 10px; float: left;">
				<legend style="font-weight: bold;">Branch Parameter</legend>
				<table style="margin: 30px 0 7px 0;">
					<tr>
						<td>
							<input id="credBranch" name="issParamRG" value="1" title="Crediting Branch" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="109">
							<label for="credBranch" style="margin: 2px 0 4px 0">Crediting Branch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="issCd" name="issParamRG" value="2" title="Issuing Source" type="radio" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" tabindex="109">
							<label for="issCd" style="margin: 2px 0 4px 0">Issuing Source</label>
						</td>
					</tr>
				</table>
			</fieldset>
			
			<fieldset style="width: 175px; margin: 5px 0 0 5px; float: left;">
				<legend style="font-weight: bold;">Date Parameter</legend>
				<table style="margin: 7px 0 7px 0;">
					<tr>
						<td>
							<input id="issueDate" name="dateParamRG" value="1" title="Issue Date" type="radio" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" tabindex="110">
							<label for="issueDate" style="margin: 2px 0 4px 0">Issue Date</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="inceptDate" name="dateParamRG" value="2" title="Incept Date" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="110">
							<label for="inceptDate" style="margin: 2px 0 4px 0">Incept Date</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="bookingDate" name="dateParamRG" value="3" title="Booking Date" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="110">
							<label for="bookingDate" style="margin: 2px 0 4px 0">Booking Date</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="acctEntDate" name="dateParamRG" value="4" title="Accounting Entry Date" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="110">
							<label for="acctEntDate" style="margin: 2px 0 4px 0">Accounting Entry Date</label>
						</td>
					</tr>
				</table>
			</fieldset>
			
			<fieldset style="width: 228px; margin: 5px 0 0 5px; float: left;">
				<legend style="font-weight: bold;">Report Type</legend>
				<table style="margin: 7px 0 7px 0;">
					<tr>
						<td>
							<input id="lineOnly" name="reportTypeRG" value="LO" title="Per Line" type="radio" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" tabindex="111">
							<label for="lineOnly" style="margin: 2px 0 4px 0">Per Line</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="lineIss" name="reportTypeRG" value="LI" title="Per Line Per Issuing Source" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="111">
							<label for="lineIss" style="margin: 2px 0 4px 0">Per Line Per Issuing Source</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="issOnly" name="reportTypeRG" value="IO" title="Per Issuing Source" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="111">
							<label for="issOnly" style="margin: 2px 0 4px 0">Per Issuing Source</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="issLine" name="reportTypeRG" value="IL" title="Per Issuing Source Per Line" type="radio" style="margin: 2px 5px 4px 5px; float: left;" tabindex="111">
							<label for="issLine" style="margin: 2px 0 4px 0">Per Issuing Source Per Line</label>
						</td>
					</tr>
				</table>
			</fieldset>
			
			<div id="printerDiv" class="sectionDiv" style="width: 613px; margin: 10px 0 5px 10px;">
				<table align="center" style="padding: 10px 0 10px 0;">
					<tr>
						<td colspan="2">
							<input id="specialPol" name="specialPol" title="Include Special Policies" type="checkbox" style="margin: 2px 5px 4px 86px; float: left;" tabindex="112">
							<label for="specialPol" style="margin: 2px 0 4px 0">Include Special Policies</label>						
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 180px;" tabindex="113">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 6px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="114">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="114"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 180px;" class="required" tabindex="115">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 156px;" class="required integerNoNegativeUnformatted" tabindex="116">
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
			
			<div id="buttonsDiv" align="center" style="float: left; margin: 8px 0 0 250px;">
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 100px;" tabindex="117">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="118">
			</div>
			
		</div>
	</div>
</div>

<script type="text/javascript">
	var params = {};
	
	function newFormInstance(){
		initializeAll();
		makeInputFieldUpperCase();
		observePrintFields();
		
		setModuleId("GIACS450");
		setDocumentTitle("Budget Production");
		toggleRequiredFields("screen");
		
		$("fromMonth").focus();
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
			$("pdfRB").disabled = true;
			$("excelRB").disabled = true;
		} else {
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
			if(dest == "file"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
			}
		}
	}

	function observePrintFields(){
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
	}

	function showLineLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGiisLineLOV",
					searchString: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
				},
				title: "List of Line Codes",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "75px",
								},
				             	{	id: "lineName",
									title: "Line Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("lineCd").value = unescapeHTML2(row.lineCd);
						$("lineName").value = unescapeHTML2(row.lineName);
						$("lineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					}
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showLineLOV", e);
		}
	}
	
	function showIssourceLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getBasicIsSourceLOV",
					moduleId: "GIACS450",
					searchString: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%"
				},
				title: "List of Issue Sources",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "issCd",
									title: "Issue Code",
									width: "75px",
								},
				             	{	id: "issName",
									title: "Issource Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("branchCd").value = unescapeHTML2(row.issCd);
						$("branchName").value = unescapeHTML2(row.issName);
						$("branchCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
					}
				},
				onCancel: function(){
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showIssourceLOV", e);
		}
	}
	
	function checkYear(id){
		if($F(id) != "" && parseInt(removeLeadingZero($F(id)).length) != 4){
			showWaitingMessageBox("Invalid year.", "I", function(){
				$(id).value = "";
				$(id).focus();
			});
			return false;
		}else{
			return true;
		}
	}
	
	function checkDates(id){
		if($F("fromMonth") != "" && $F("fromYear") != "" && $F("toMonth") != "" && $F("toYear") != ""){
			var fromDate = new Date(dateFormat($F("fromMonth") + " " + $F("fromYear"))).moveToFirstDayOfMonth();
			var toDate = new Date(dateFormat($F("toMonth") + " " + $F("toYear"))).moveToLastDayOfMonth();
			
			if(fromDate > toDate){
				showWaitingMessageBox("From Date should not be later than To Date", "I", function(){
					$(id).value = "";
					$(id).focus();
				});
			}
		}
	}
	
	function getDateParam(){
		var dateParam = "";
		$$("input[name='dateParamRG']").each(function(i){
			if(i.checked){
				dateParam = i.value;
			}
		});
		return dateParam;
	}
	
	function getFromDate(){
		return dateFormat(new Date(dateFormat($F("fromMonth") + " " + $F("fromYear"))).moveToFirstDayOfMonth(), 'mm-dd-yyyy');
	}
	
	function getToDate(){
		return dateFormat(new Date(dateFormat($F("toMonth") + " " + $F("toYear"))).moveToFirstDayOfMonth(), 'mm-dd-yyyy');
	}
	
	function checkLastExtractParams(){
		if(nvl(params.fromDate, null) != null){
			if(nvl(params.lineCd, "---") == nvl($F("lineCd"), "---") && nvl(params.issCd, "---") == nvl($F("branchCd"), "---") &&
			   params.dateParam ==  getDateParam() && params.issParam == ($("credBranch").checked ? "1" : "2") &&
			   params.fromDate == getFromDate() && params.toDate == getToDate()){
				showConfirmBox("Confirmation", "Data based from the given parameters were already extracted. Do you still want to continue?",
								"OK", "Cancel", prepareExtractionParams, null, "2");
				return false;
			}
		}
		return true;
	}
	
	function prepareExtractionParams(){
		params.issCd = $F("branchCd");
		params.lineCd = $F("lineCd");
		params.issParam = $("credBranch").checked ? "1" : "2";
		params.specialPol = $("specialPol").checked ? "Y" : "N";
		
		params.dateParam = getDateParam();
		params.fromDate = getFromDate();
		params.toDate = getToDate();
		
		extractBudgetProduction();
	}
	
	function extractBudgetProduction(){
		try{
			new Ajax.Request(contextPath+"/GIXXProdBudgetController",{
				method: "POST",
				parameters:{
					action: "extractBudgetProduction",
					issCd: params.issCd,
					lineCd: params.lineCd,
					fromDate: params.fromDate,
					toDate: params.toDate,
					dateParam: params.dateParam,
					issParam: params.issParam,
					specialPol: params.specialPol,
					moduleId: "GIACS450"
					
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if(parseInt(obj.count) == 1){
							showMessageBox("Extraction finished. 1 record extracted.", "I");
						}else if(parseInt(obj.count) > 1){
							showMessageBox("Extraction finished. " + obj.count + " records extracted.", "I");
						}else{
							showMessageBox("Extraction finished. No records extracted.", "I");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("extractBudgetProduction", e);
		}
	}
	
	function preparePrintParams(){
		var printParams = {};
		printParams.fileType = $("pdfRB").checked ? "PDF" : "XLS";
		
		if($("lineOnly").checked){
			printParams.reportId = "GIACR450";
			printParams.reportTitle = "Production Budget Per Line";
		}else if($("lineIss").checked){
			printParams.reportId = "GIACR451";
			printParams.reportTitle = "Production Budget Per Line Per Issuing Source";
		}else if($("issOnly").checked){
			printParams.reportId = "GIACR452";
			printParams.reportTitle = "Production Budget Per Issuing Source";
		}else{
			printParams.reportId = "GIACR453";
			printParams.reportTitle = "Production Budget Per Issuing Source Per Line";
		}
		
		return printParams;
	}
	
	function printBudgetProduction(){
		var printParams = preparePrintParams();
		
		var content = contextPath+"/GeneralLedgerPrintController?action=printReport&reportId="+printParams.reportId+
						"&lineCd="+$F("lineCd")+"&issCd="+$F("branchCd")+
						"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
						"&fileType="+printParams.fileType;
		
		printGenericReport(content, printParams.reportTitle);
	}
	
	$("lineCd").observe("change", function(){
		if($F("lineCd") != ""){
			showLineLOV();
		}else{
			$("lineCd").setAttribute("lastValidValue", "");
			$("lineName").value = "ALL LINES";
		}
	});
	
	$("branchCd").observe("change", function(){
		if($F("branchCd") != ""){
			showIssourceLOV();
		}else{
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "ALL ISSUE SOURCES";
		}
	});
	
	$("searchLine").observe("click", function(){
		showLineLOV();
	});
	
	$("searchBranch").observe("click", function(){
		showIssourceLOV();
	});
	
	$("fromMonth").observe("change", function(){
		checkDates("fromMonth");
	});
	
	$("fromYear").observe("change", function(){
		if(checkYear("fromYear")){
			checkDates("fromYear");
		}
	});
	
	$("toMonth").observe("change", function(){
		checkDates("toMonth");
	});
	
	$("toYear").observe("change", function(){
		if(checkYear("toYear")){
			checkDates("toYear");
		}
	});
	
	$("btnExtract").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("parameterDiv") && checkLastExtractParams()){
			prepareExtractionParams();
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("printerDiv")){
			if($F("selDestination") == "printer" && ($F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
			}else{
				printBudgetProduction();
			}
		}
	});
	
	newFormInstance();
</script>