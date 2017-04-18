<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="uwReportsMainDiv" name="uwReportsMainDiv">			
	<div id="uwReportsSubDiv" name="uwReportsSubDiv">
		<div class="" style="float: left; padding:15px 0 15px 0;">
			<div id="txtFieldsDiv" name="txtFieldsDiv" class="sectionDiv" style="padding-top: 5px; width: 890px; height: 251px; margin-left: 15px;" align="center">
				<table align="center" style="margin-top: 40px;">
					<tr>
						<td class="rightAligned">Include :</td>
						<td><input id="directBusinessPol" name="directBusinessPol" type="checkbox" style="margin: 0 5px 0 5px; float: left;"><label for="directBusinessPol" style="margin-right: 40px;">Direct Business Policies</label></td>
						<td class="rightAligned">Parameter :</td>
						<td><input value="1" title="Crediting Branch" type="radio" id="creditingBranch" name="parameterRG" style="margin: 0 5px 0 5px; float: left;"><label for="creditingBranch">Crediting Branch</label></td>
					</tr>
					<tr>
						<td></td>
						<td><input id="reinsurancePol" name="reinsurancePol" type="checkbox" style="margin: 0 5px 0 5px; float: left;"><label for="reinsurancePol">Reinsurance Policies</label></td>
						<td></td>
						<td><input value="2" title="Issue Source" type="radio" id="issueSource" name="parameterRG" style="margin: 0 5px 0 5px; float: left;"><label for="issueSource">Issue Source</label></td>
					</tr>
				</table>
			
				<table align="center" style="margin-top: 20px;">
					<tr>
						<td class="rightAligned" id="lblCreditingBranch" name="lblCreditingBranch">&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="issCd" name="issCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="issName" name="issName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
					</tr>
					<tr>
						<td class="rightAligned">Line :</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="lineCd" name="lineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="lineName" name="lineName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
					</tr>
				</table>
				
				<table align="center" style="margin-top: 20px;">
					<tr>
						<td><input id="consolidate" name="consolidate" type="checkbox" style="margin: 0 5px 0 5px; float: left;"><label for="consolidate">Consolidate All Branches</label></td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="float: left; width: 890px; height: 181px; margin-left: 15px;" id="printDialogFormDiv">
				<table style="float: left; padding: 30px 0 0 230px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;">
								<option value="SCREEN">Screen</option>
								<option value="PRINTER">Printer</option>
								<option value="FILE">File</option>
								<option value="LOCAL">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left; display: none;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0; display: none;">Excel</label> <!-- apollo cruz 05.06.2015 - hides excel option - GENQA SR# 4359 -->
								<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>					
						</td>
					</tr>
				</table>
				<table style="float: left; padding-top: 40px;">
					<!-- <tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnExtract" name="btnExtract" value="Extract"></td></tr> -->
					<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
					<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
				</table>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	toggleRequiredFields("screen");
	makeInputFieldUpperCase();
	initializeDefaultParameters();
	
	function initializeDefaultParameters(){
		$("directBusinessPol").checked = true;
		$("reinsurancePol").checked = false;
		$("consolidate").checked = true;
		$("issueSource").checked = true;
		$("issName").value = "ALL ISSUE SOURCE";
		$("lineName").value = "ALL LINES";
		document.getElementById("lblCreditingBranch").innerHTML = "&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :";
	}
	
	function toggleRequiredFields(dest){
		if(dest == "PRINTER"){			
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
			$("csvRB").disabled = true;
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
			if(dest == "FILE"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}
		}
	}
	
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
	
	$("issCd").observe("blur", function(){
		if($("issCd").value != ""){
			validateUwReportsIssCd();
		}else{
			$("issName").value = "ALL ISSUE SOURCE";
		}
	});
	
	$("lineCd").observe("blur", function(){
		if($("lineCd").value != ""){
			validateUwReportsLineCd2();
		}else{
			$("lineName").value = "ALL LINES";
		}
	});
	
	$("searchIssCd").observe("click", function(){
		showUwReportsIssLOV();
	});
	
	$("searchLineCd").observe("click", function(){
		showUndistributedLineLOV();
	});
	
	function showUndistributedLineLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getAllLineLOV",
								issCd: $("issCd").value,
								moduleId: "GIPIS901A"
							   },
				title: "Valid values for line",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "lineCd",
									title: "Line Cd",
									width: '80px'
								},
								{	id : "lineName",
									title: "Line Name",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("lineCd").value = row.lineCd;
						$("lineName").value = row.lineName;
					}
				}
			});
		}catch(e){
			showErrorMessage("showUwReportsLineLOV",e);
		}
	}
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("creditingBranch").observe("click", function(){
		document.getElementById("lblCreditingBranch").innerHTML = "Crediting Branch :";
	});
	
	$("issueSource").observe("click", function(){
		document.getElementById("lblCreditingBranch").innerHTML = "&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :";
	});
	
	$("btnPrint").observe("click", function(){
		if($("directBusinessPol").checked == false && $("reinsurancePol").checked == false){
			showMessageBox("Please check the policies to include.", "I");
		}else{
			proceedPrint();
		}
	});
	
	function proceedPrint(){
		if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox(objCommonMessage.REQUIRED, "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			printUwReports();
		}
	}
	
	function printUwReports(){
		if($("consolidate").checked){
			printProdReport("printGIPIR924C");
		}else{
			printProdReport("printGIPIR924D");
		}
	}
	
	function printProdReport(action){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		var direct = $("directBusinessPol").checked ? 1 : 0;
		var ri = $("reinsurancePol").checked ? 1 : 0;
		
		try {
			var content = contextPath+"/UWProductionReportPrintController?action="+action+"&issParam="+branchParam+
					"&issCd="+$F("issCd")+"&lineCd="+$F("lineCd")+"&direct="+direct+"&ri="+ri+
					"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
					"&reportId="+action.substring(5);
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "List of Undistributed Policies");
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("FILE" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV";
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
				         	      fileType    : fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("csvRB").checked){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
						}
					}
				});
			}else if("LOCAL" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("printProdReport: " + action, e);
		}
	}
	
	function validateUwReportsLineCd2(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			method: "GET",
			parameters: {action      : "validateLineCd",
						 lineCd	     : $("lineCd").value,
						 sublineCd   : "",
						 issCd	     : $("issCd").value,
						 sublineName : ""},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.found == "Y"){
						$("lineName").value = obj.lineName;
					}else{
						$("lineName").value = "ALL LINES";
						clearFocusElementOnError("lineCd", "Invalid value for field LINE_CD.");
					}
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", function(){showUWProductionReportsPage("showUndistributedTab");});
	
</script>