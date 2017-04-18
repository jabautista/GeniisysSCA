<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outstandingTabMainDiv" name="outstandingTabMainDiv" class="" style="float: left; padding: 15px 0 15px 0">
	<div id="fieldsDiv" name="fieldsDiv" class="sectionDiv" style="margin-left: 15px; border: none; width: 605px; height: 433px;" align="center">
		<div id="bindersDiv" name="bindersDiv" align="left" class="sectionDiv" style="padding: 15px 0 0 35px; width: 567px; height: 145px;">
			<input id="chkBinder" name="chkBinder" type="checkbox" value=""><b>&nbsp Binders</b>
			<table id="bindersFieldDiv" style="margin-top: 20px;">
				<tr>
					<td class="rightAligned">Reinsurer Name &nbsp</td>
					<td>
						<input id="txtRiCdBinder" type="hidden">
						<div id="riNameBinderDiv" name="riNameBinderDiv" style="border: 1px solid gray; width: 405px; height: 20px; ">
							<input id="txtRiNameBinder" name="txtRiNameBinder" class="leftAligned upper" type="text" maxlength="50" style="border: none; float: left; width: 375px; height: 13px; margin: 0px;" value=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiNameBinder" name="searchRiNameBinder" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Period Covered &nbsp</td>
					<td>
						<div id="dateBinderDiv" name="dateBinderDiv" style="width: 410px;">
							<label style="float: left; padding-top: 5px;">&nbsp From &nbsp</label>
							<div id="fromDateBinderDiv" name="fromDateBinderDiv" style="float: left; border: 1px solid gray; width: 160px; height: 20px; ">
								<input id="txtFromDateBinder" name="txtFromDateBinder" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value=""/>
								<img id="imgFromDateBinder" alt="imgFromDateBinder" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDateBinder'),this, null);" />
							</div>
							<label style="float: left; padding-top: 5px;">&nbsp&nbsp To &nbsp&nbsp</label>
							<div id="toDateBinderDiv" name="toDateBinderDiv" style="float: left; border: 1px solid gray; width: 160px; height: 20px; ">
								<input id="txtToDateBinder" name="txtToDateBinder" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value=""/>
								<img id="imgToDateBinder" alt="imgToDateBinder" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDateBinder'),this, null);" />
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Line &nbsp</td>
					<td>
						<input id="txtLineCdBinder" type="hidden">
						<div id="lineBinderDiv" name="lineBinderDiv" style="border: 1px solid gray; width: 405px; height: 20px; ">
							<input id="txtLineBinder" name="txtLineBinder" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 375px; height: 13px; margin: 0px;" value=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineBinder" name="searchLineBinder" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="acceptancesDiv" name="acceptancesDiv" align="left" class="sectionDiv" style="padding: 15px 0 0 35px; width: 567px; height: 117px;">
			<input id="chkAccept" name="chkAccept" type="checkbox" value="" style="float: left;"><label for="chkAccept" style="font-weight: bold; margin: 2px 0 4px 0">&nbsp Acceptances</label>
			<input id="reportRB" name="acceptRG" type="radio" value="Report" title="Report" checked="checked" style="float: left; margin-left: 150px;"><label for="reportRB" style="margin: 2px 0 4px 0">Report</label>
			<input id="letterRB" name="acceptRG" type="radio" value="Letter" title="Letter" style="float: left; margin-left: 50px;"><label for="letterRB" style="margin: 2px 0 4px 0">Letter</label>
			
			<table id="acceptFieldDiv" style="margin-top: 35px;">
				<tr>
					<td class="rightAligned">Reinsurer Name &nbsp</td>
					<td>
						<input id="txtRiCdAccept" type="hidden">
						<div id="riNameAcceptDiv" name="riNameAcceptDiv" style="border: 1px solid gray; width: 405px; height: 20px; ">
							<input id="txtRiNameAccept" name="txtRiNameAccept" class="leftAligned upper" type="text" maxlength="50" style="border: none; float: left; width: 375px; height: 13px; margin: 0px;" value=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiNameAccept" name="searchRiNameAccept" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Line &nbsp</td>
					<td>
						<input id="txtLineCdAccept" type="hidden">
						<div id="lineAcceptDiv" name="lineAcceptDiv" style="border: 1px solid gray; width: 405px; height: 20px; ">
							<input id="txtLineAccept" name="txtLineAccept" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 375px; height: 13px; margin: 0px;" value=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineAccept" name="searchLineAccept" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="frpsDiv" name="frpsDiv" align="left" class="sectionDiv" style="padding: 15px 0 0 35px; width: 567px; height: 117px;">
			<input id="chkFrps" name="chkFrps" type="checkbox" value=""><b>&nbsp FRPS No.</b>	
			<table id="frpsFieldDiv" style="margin-top: 20px;">
				<tr>
					<td class="rightAligned" style="padding-left: 25px;">Incept Date &nbsp</td>
					<td>
						<div id="dateFrpsDiv" name="dateFrpsDiv" style="width: 410px;">
							<label style="float: left; padding-top: 5px;">&nbsp From &nbsp</label>
							<div id="fromDateFrpsDiv" name="fromDateFrpsDiv" style="float: left; border: 1px solid gray; width: 160px; height: 20px; ">
								<input id="txtFromDateFrps" name="txtFromDateFrps" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value=""/>
								<img id="imgFromDateFrps" alt="imgFromDateFrps" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDateFrps'),this, null);" />
							</div>
							<label style="float: left; padding-top: 5px;">&nbsp&nbsp To &nbsp&nbsp</label>
							<div id="toDateFrpsDiv" name="toDateFrpsDiv" style="float: left; border: 1px solid gray; width: 160px; height: 20px; ">
								<input id="txtToDateFrps" name="txtToDateFrps" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value=""/>
								<img id="imgToDateFrps" alt="imgToDateFrps" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDateFrps'),this, null);" />
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Line &nbsp</td>
					<td>
						<input id="txtLineCdFrps" type="hidden">
						<div id="lineFrpsDiv" name="lineFrpsDiv" style="border: 1px solid gray; width: 405px; height: 20px; ">
							<input id="txtLineFrps" name="txtLineFrps" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 375px; height: 13px; margin: 0px;" value=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineFrps" name="searchLineFrps" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div class="sectionDiv" id="printDialogFormDiv" style="padding-top: 5px; margin-bottom: 4px; width: 280px; height: 425px;" align="center">
		<table style="float: left; padding: 40px 0 0 10px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 150px;">
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
					<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> --> <!-- removed by carlo de guzman 02/10/16 -->
					<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 30px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label> <!-- added by carlo de guzman 02/10/16 -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 150px;" class="required">
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
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 125px;" class="required integerNoNegativeUnformattedNoComma">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
		<table style="padding-top: 30px;">
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	makeInputFieldUpperCase();
	observeReloadForm("reloadForm", function(){showGenerateRIReportsTabPage("outstandingTab");});
	
	objRiReports.oar.acceptRG = $("reportRB").value;

	
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
			//$("excelRB").disabled = true; //removed by carlo de guzman 02/10/16
			$("csvRB").disabled = true; //added by carlo de guzman 02/10/16			
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
				//$("excelRB").disabled = false; //removed by carlo de guzman 02/10/16
				$("csvRB").disabled = false; //added by carlo de guzman 02/10/16
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true; //removed by carlo de guzman 02/10/16
				$("csvRB").disabled = true; //added by carlo de guzman 02/10/16
			}
		}
	}
	
	// line name fields
	$("txtLineBinder").observe("blur", function(){
		if($F("txtLineBinder") != ""){
			validateRIReportsLineName("txtLineBinder", "txtLineCdBinder");
		}else {
			$("txtLineCdBinder").value = "";
		}
	});
	
	$("txtLineAccept").observe("blur", function(){
		if($F("txtLineAccept") != ""){
			validateRIReportsLineName("txtLineAccept", "txtLineCdAccept");
		}else {
			$("txtLineCdAccept").value = "";
		}
	});
	
	$("txtLineFrps").observe("blur", function(){
		if($F("txtLineFrps") != ""){
			validateRIReportsLineName("txtLineFrps", "txtLineCdFrps");
		}else {
			$("txtLineCdFrps").value = "";
		}
	});

	//reinsurer name fields
	$("txtRiNameBinder").observe("blur", function(){
		if($F("txtRiNameBinder") != ""){
			validateRIReportsReinsurerName("txtRiNameBinder", "txtRiCdBinder", "Invalid value for field REINSURER NAME.");
		}else{
			$("txtRiCdBinder").value = "";
		}
	});
	
	$("txtRiNameAccept").observe("blur", function(){
		if($F("txtRiNameAccept") != ""){
			validateRIReportsReinsurerName("txtRiNameAccept", "txtRiCdAccept", "Invalid value for field REINSURER NAME.");
		}else{
			$("txtRiCdAccept").value = "";
		}
	});
	
	//search reinsurer name buttons
	$("searchRiNameBinder").observe("click", function(){
		showRiReportsReinsurerLOV("txtRiNameBinder", "txtRiCdBinder");
	});
	
	$("searchRiNameAccept").observe("click", function(){
		showRiReportsReinsurerLOV("txtRiNameAccept", "txtRiCdAccept");
	});
	
	//search line name buttons
	$("searchLineBinder").observe("click", function(){
		showRiReportsOutAcceptLineLOV("txtLineBinder", "txtLineCdBinder");
	});
	
	$("searchLineAccept").observe("click", function(){
		showRiReportsOutAcceptLineLOV("txtLineAccept", "txtLineCdAccept");
	});
	
	$("searchLineFrps").observe("click", function(){
		showRiReportsOutAcceptLineLOV("txtLineFrps", "txtLineCdFrps");
	});
	
	//date fields
	$("txtFromDateBinder").observe("blur", function(){
		checkDateCovered("from_date", "Binder");
	});
	
	$("txtToDateBinder").observe("blur", function(){
		checkDateCovered("to_date", "Binder");
	});
	
	$("txtFromDateFrps").observe("blur", function(){
		checkDateCovered("from_date", "Frps");
	});
	
	$("txtToDateFrps").observe("blur", function(){
		checkDateCovered("to_date", "Frps");
	});
	
	
	$$("input[name='acceptRG']").each(function(radio){
		radio.observe("click", function(){
			objRiReports.oar.acceptRG = radio.value;
		});
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnPrint").observe("click", function(){	
		objRiReports.oar.show_alert = false;
		
		if($("chkBinder").checked == false && $("chkAccept").checked == false && $("chkFrps").checked == false){
			showMessageBox("Please indicate which report to print by checking the corresponding checkbox.", "I");
		}else if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer Name and No. of Copies are required.", "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			proceedOutAcceptPrint();
		}
	});
		
	function checkDateCovered(field, block){
		var fromDate = "txtFromDate"+block;
		var toDate = "txtToDate"+block;
		
		if(($F(fromDate) != "" && $F(toDate) != "")){
			if(Date.parse($F(fromDate)) > Date.parse($F(toDate))){
				if(field == "from_date"){
					showMessageBox("The ending period must not be earlier than the starting period.", "I");
					$(toDate).value = "";
				}else{
					showMessageBox("The starting period must not be later than the ending period.", "I");
					$(fromDate).value = "";
				}
			}	
		}
	};
	
	function proceedOutAcceptPrint(){
		var report = [{"content": contextPath+"/UWReinsuranceReportPrintController?action=printUWRiOutAcceptReport&reportId=GIRIR036"+
								  "&lineCd="+$F("txtLineCdBinder")+"&riCd="+$F("txtRiCdBinder")+"&fromDate="+$F("txtFromDateBinder")+
								  "&toDate="+$F("txtToDateBinder")+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+ 
								  "&destination="+$F("selDestination")},
					  {"content": contextPath+"/UWReinsuranceReportPrintController?action=printUWRiOutAcceptReport&reportId=GIRIR105&lineCd="+
						  		  $F("txtLineCdFrps")+"&fromDate="+$F("txtFromDateFrps")+"&toDate="+$F("txtToDateFrps")+"&noOfCopies="+
						  		  $F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")}];
					
		if($("chkFrps").checked){
			if($("chkBinder").checked){
				objRiReports.rep_type_sw = null;
			
				if($F("txtToDateBinder") == ""){
					showMessageBox("Please indicate (at least) the ending date of the period covered. UNCONFIRMED BINDERS cannot be printed without this parameter.", "I");
					objRiReports.oar.show_alert = false;
				}else{
					objRiReports.oar.reports.push({reportUrl: report[0].content, reportTitle: "GIRIR036"});	//GIRIR036 (Unconfirmed Binders Letter)
					objRiReports.oar.reports.push({reportUrl: report[1].content, reportTitle: "Outstanding FRPS Report"});	//GIRIR105 (outstanding frps report)					
					printUWRiOutstandingReports();
				}
			}else{					
				objRiReports.oar.reports.push({reportUrl: report[1].content, reportTitle: "Outstanding FRPS Report"}); //GIRIR105 (outstanding frps report)
				printUWRiOutstandingReports();
			}
		}else if($("chkBinder").checked == true && $("chkFrps").checked == false){
			objRiReports.rep_type_sw = null;
			
			if($F("txtToDateBinder") == ""){
				showMessageBox("Please indicate (at least) the ending date of the period covered. UNCONFIRMED BINDERS cannot be printed without this parameter.", "I");
				objRiReports.oar.show_alert = false;
			}else{					
				objRiReports.oar.reports.push({reportUrl: report[0].content, reportTitle: "GIRIR036"});  //GIRIR036 (Unconfirmed Binders Letter)
				printUWRiOutstandingReports();
			}
		}else {
			objRiReports.oar.show_alert = true;
		}
					
		if($("chkAccept").checked && objRiReports.oar.show_alert == true){
			objRiReports.oar.ri_cd_accept = $F("txtRiCdAccept");
			objRiReports.oar.line_cd_accept = $F("txtLineCdAccept");
			objRiReports.oar.no_of_copies = $F("txtNoOfCopies");
			objRiReports.oar.printer_name = $F("selPrinter");
			objRiReports.oar.dest = $F("selDestination");
			checkORA2010();
		}	
	}
	
	function checkORA2010(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController?action=checkORA2010Sw",{
				method: "GET",
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if(obj.ora2010 == "Y"){
							genericObjOverlay = Overlay.show(contextPath+"/GIRIGenerateRIReportsController",{
								urlContent: true,
								urlParameters: {
									action: "showOARPrintWindow"
								},
								title: "Outstanding Acceptances Print Date",
								height: 160,
								width: 300,
								draggable: true
							});
							
						}else {
							//report = GIRIR101(outstanding acceptances report); letter = GIRIR037 (outstanding outward binders)
							objRiReports.oar.more_than = 0;
							objRiReports.oar.less_than = 9000000;
							objRiReports.oar.date_sw = 0;
							objRiReports.oar.oar_print_date = "";
						
							prepareOARDate();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkORA2010", e);
		}
	}
	
	
	toggleRequiredFields("screen");
</script>