<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="taxDetailsRegisterMainDiv" name="taxDetailsRegisterMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Production Register with Tax Details</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="taxDetailsRegisterBody" >
		<div class="sectionDiv" id="taxDetailsRegister" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="taxDetailsRegisterInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">To</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtBranchCd" name="txtBranchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue="" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtBranchName" name="txtBranchName" style="width: 330px; float: left; text-align: left;" value="ALL BRANCHES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue="" maxlength="2"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtLineName" name="txtLineName" style="width: 330px; float: left; text-align: left;" value="ALL LINES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td colspan="3">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="allCaps"  type="text" id="txtSublineCd" name="txtSublineCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue="" maxlength="7"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtSublineName" name="txtSublineName" style="width: 330px; float: left; text-align: left;" value="ALL SUBLINES" readonly="readonly"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td><input checked="checked" type="radio" name="sortBy" id="rdoCredBranch" title="Crediting Branch" style="float: left; margin-right: 7px;"/><label for="rdoCredBranch" style="float: left; height: 20px; padding-top: 3px;">Crediting Branch</label></td>
						<td colspan="2"><input type="radio" name="sortBy" id="rdoIssSource" title="Issuing Source" style="float: left; margin-right: 7px;"/><label for="rdoIssSource" style="float: left; height: 20px; padding-top: 3px;">Issuing Source</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 97%; height:130px; margin: 0 8px 6px 8px;">
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
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" printerErrorMsg="Printer Name is required.">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" printerErrorMsg = "No. of Copies is required.">
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
			<div id="buttonsDiv" style="width: 100%; height: 50px; float: left;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px; margin-bottom: 10px; margin-top: 10px;">
			</div>
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS101");
	setDocumentTitle("Production Register with Tax Details");
	toggleRequiredFields("screen");
	
	/** 
	 * @author steven
	 * @date 09.02.2013
	 * @params divId - id of div containing the fields to be checked
	 * @returns true - if all required fields has a value else false
	 * Display Error Message if error occur, just create an attribute named 'errorMsg' (optional)
	 * Ex. <input type="text" class="integer" errorMsg="Input value is invalid!." />
	 */
	function checkAllRequiredFieldsWithCustomErrorMsg(divId) {
		try{
			var isComplete = true;
			$$("div#"+divId+" input[type='text'].required, div#"+divId+" textarea.required, div#"+divId+" select.required, div#"+divId+" input[type='file'].required").each(function (o) {
				if (o.value.blank()){
					isComplete = false;
					if (o.getAttribute("printerErrorMsg")){
						customShowMessageBox(o.getAttribute("printerErrorMsg"), "E",o.id);
					}else{
						customShowMessageBox(objCommonMessage.REQUIRED, "E", o.id);
					}
					throw $break;
				}
			});
			return isComplete;
		}catch(e){
			showErrorMessage("checkAllRequiredFieldsWithCustomErrorMsg",e);
		}
	}

	function printReport() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var branchType = $("rdoCredBranch").checked ? "1" : "";
			var content = contextPath+"/EndOfMonthPrintReportController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId=GIACR101"
						+"&reportTitle=PRODUCTION REGISTER WITH TAX DETAILS"
						+"&branchCd="+$F("txtBranchCd")
						+"&lineCd="+$F("txtLineCd")
						+"&sublineCd="+$F("txtSublineCd")
						+"&branchType="+branchType
						+"&fromDate="+$F("txtFromDate")	
						+"&toDate="+$F("txtToDate")
						+"&fileType="+fileType
						+"&moduleId="+"GIACS101"; 
			printGenericReport(content, "PRODUCTION REGISTER WITH TAX DETAILS");
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function extractRecord() {
		try{
			new Ajax.Request(contextPath+"/GIACEndOfMonthReportsController",{
				method: "POST",
				parameters : {action : "giacs101ExtractRecord",
					          issCd : $F("txtBranchCd"),
				        	  lineCd : $F("txtLineCd"),
			        		  sublineCd : $F("txtSublineCd"),
		        			  fromDate : $F("txtFromDate"),
        					  toDate : $F("txtToDate"),
       						  perBranch : $("rdoCredBranch").checked ? "C" : "I"},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						printReport();
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractRecord",e);
		}
	}
	function validateBeforePrint() {
		var dest = $F("selDestination");
		if ($F("txtFromDate") == "" && $F("txtToDate") == "") {
			showMessageBox("Please enter From Date and To Date.","E");
		}else if ($F("txtFromDate") == "") {
			showMessageBox("Please enter From Date.","E");
		}else if ($F("txtToDate") == "") {
			showMessageBox("Please enter To Date.","E");
		}else{
			if(dest == "printer"){
				if(checkAllRequiredFieldsWithCustomErrorMsg("printDiv")){
					if((isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
						showMessageBox("Invalid number of copies.", "I");
					}else{
						extractRecord();
					}
				}
			}else{
				extractRecord();
			}	
		}
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
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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
	
	function showGiacs101BranchLOV(){ //added by steven 09.04.2014
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs101BranchLOV",
								 findText2 : ($("txtBranchCd").readAttribute("lastValidValue") != $F("txtBranchCd") ? nvl($F("txtBranchCd"),"%") : "%"),
								 moduleId : 'GIACS101',
								 page : 1
				},
				title: "Lists of Branches",
				width: 390,
				height: 400,
				columnModel: [
					{
						id : 'branchCd',
						title: 'Branch Code',
						width : '100px',
						align: 'right'
					},
					{
						id : 'branchName',
						title: 'Branch Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord : true,
				filterText: ($("txtBranchCd").readAttribute("lastValidValue") != $F("txtBranchCd") ? nvl($F("txtBranchCd"),"%") : "%"),
				onSelect: function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
				},
				onCancel : function() {
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO,"txtBranchCd");	
					$("txtBranchCd").value = $("txtBranchCd").getAttribute("lastValidValue"); 	
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showGiacs101BranchLov",e);
		}
	}
	
	function showGiacs101LineLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs101LineLOV",
								 findText2 : ($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
								 issCd : $F("txtBranchCd"),
								 page : 1
				},
				title: "Lists of Lines",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'lineCd',
						title: 'Line Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'lineName',
						title: 'Line Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord : true,
				filterText: ($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
				onSelect: function(row) {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						$("txtSublineCd").value="";	
						$("txtSublineCd").setAttribute("lastValidValue","");
						$("txtSublineName").value="ALL SUBLINES";
				},
				onCancel : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO,"txtLineCd");	
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue"); 	
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showGiacs101LineLov",e);
		}
	}
	
	function showGiacs101SublineLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs101SublineLOV",
								 lineCd : $F("txtLineCd"),
								 findText2 : ($("txtSublineCd").readAttribute("lastValidValue") != $F("txtSublineCd") ? nvl($F("txtSublineCd"),"%") : "%"),
								 page : 1
				},
				title: "Lists of Sublines",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'sublineCd',
						title: 'Subline Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'sublineName',
						title: 'Subline Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord : true,
				filterText: ($("txtSublineCd").readAttribute("lastValidValue") != $F("txtSublineCd") ? nvl($F("txtSublineCd"),"%") : "%"),
				onSelect: function(row) {
					if(row != undefined){
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					}
				},
				onCancel : function() {
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO,"txtSublineCd");	
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue"); 	
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showGiacs101SublineLov",e);
		}
	}
	/* observe */
	$("searchBranchCd").observe("click", function(){
		showGiacs101BranchLOV();
	});
	
	$("searchLineCd").observe("click", function(){
		showGiacs101LineLov();
	});
	
	$("searchSublineCd").observe("click", function(){
		showGiacs101SublineLov();
	});
	
	$("txtBranchCd").observe("change", function() {
		if($F("txtBranchCd").trim()!=""&& $("txtBranchCd").value != $("txtBranchCd").readAttribute("lastValidValue")){						
			showGiacs101BranchLOV();			
		}else if($F("txtBranchCd").trim()==""){
			$("txtBranchCd").value="";	
			$("txtBranchCd").setAttribute("lastValidValue","");
			$("txtBranchName").value="ALL BRANCHES";			
		}		
	});
	
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim()!=""&& $("txtLineCd").value != $("txtLineCd").readAttribute("lastValidValue")){						
			showGiacs101LineLov();			
		}else if($F("txtLineCd").trim()==""){
			$("txtLineCd").value="";	
			$("txtLineCd").setAttribute("lastValidValue","");
			$("txtLineName").value="ALL LINES";		
			$("txtSublineCd").value="";	
			$("txtSublineCd").setAttribute("lastValidValue","");
			$("txtSublineName").value="ALL SUBLINES";	
		}		
	});
	
	$("txtSublineCd").observe("change", function() {
		if($F("txtSublineCd").trim()!=""&& $("txtSublineCd").value != $("txtSublineCd").readAttribute("lastValidValue")){						
			showGiacs101SublineLov();			
		}else if($F("txtSublineCd").trim()==""){
			$("txtSublineCd").value="";	
			$("txtSublineCd").setAttribute("lastValidValue","");
			$("txtSublineName").value="ALL SUBLINES";			
		}		
	});
	
	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		validateBeforePrint();
	});
	
	//for the print div
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
</script>