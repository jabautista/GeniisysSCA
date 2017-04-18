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

<div id="treatyTabMainDiv" style="float: left; padding: 15px 0 5px 0">
	<div id="fieldsDiv" name="fieldsDiv" class="sectionDiv" style="margin-left: 15px; padding-top: 5px; width: 657px; height: 180px;">
		<table id="fieldsTbl" style="padding: 50px 0 0 250px;">
			<tr>
				<td style="text-align: right; padding-right: 10px;">Report Month</td>
				<td>
					<select id="selReportMonth" style="width: 186px;">
						<option id=""></option>
						<option id="JAN">January</option>
						<option id="FEB">February</option>
						<option id="MAR">March</option>
						<option id="APR">April</option>
						<option id="MAY">May</option>
						<option id="JUN">June</option>
						<option id="JUL">July</option>
						<option id="AUG">August</option>
						<option id="SEP">September</option>
						<option id="OCT">October</option>
						<option id="NOV">November</option>
						<option id="DEC">December</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="text-align: right; padding-right: 10px;">Report Year</td>
				<td><input id="txtReportYear" name="txtReportYear" type="text" class="integerNoNegativeUnformattedNoComma" maxlength="4" value="" style="width: 178px; text-align: right;" errorMsg="Legal characrters are 0-9."></td>
			</tr>
		</table>
	</div>
	
	<!-- benjo 08.03.2016 SR-5512 -->
	<div id="reportDiv" name="reportDiv" class="sectionDiv" style="padding-top: 5px; width: 230px; height: 86px;" align="center">
		<table id="reportTbl" align="left" style="margin-top: 10px; margin-left: 15px;">
			<tr>
				<td>
					<input id="inwardRB" name="reportRG" type="radio" value="Inward" checked="checked" style="float: left; margin: 2px 5px 10px 0;"><label for="inwardRB" style="margin: 2px 0 4px 0;">Inward</label> 
				</td>
			</tr>
			<tr>
				<td>
					<input id="outwardRB" name="reportRG" type="radio" value="Outward" style="float: left; margin: 2px 5px 10px 0;"><label for="outwardRB" style="margin: 2px 0 4px 0;">Outward</label>
				</td>
			</tr>
		</table>
	</div>
	<div id="tranDiv" name="tranDiv" class="sectionDiv" style="padding-top: 5px; width: 230px; height: 86px;" align="center">
		<table id="tranTbl" align="left" style="margin-top: 10px; margin-left: 15px;">
			<tr>
				<td>
					<input id="bookedRB" name="tranRG" type="radio" value="Booked" checked="checked" style="float: left; margin: 2px 5px 10px 0;"><label for="bookedRB" style="margin: 2px 0 4px 0;">Booked Transactions</label> 
				</td>
			</tr>
			<tr>
				<td>
					<input id="unbookedRB" name="tranRG" type="radio" value="Unbooked" style="float: left; margin: 2px 5px 10px 0;"><label for="unbookedRB" style="margin: 2px 0 4px 0;">Unbooked Transactions</label>
				</td>
			</tr>
		</table>
	</div>
	<!-- end -->

	<div class="sectionDiv" id="printDialogFormDiv" style="margin-left: 15px; margin-bottom: 5px; float: left; width: 890px; height: 251px;" >
		<table style="float: left; padding: 55px 0 0 220px;">
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
					<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 25px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
					<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> -->
					<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label> <!-- benjo 01.24.2017 5917 -->
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
		<table style="float: left; padding: 65px 0 0 25px;">
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	toggleRequiredFields("screen");
	observeReloadForm("reloadForm", function(){showGenerateRIReportsTabPage("treatyTab");});
	
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
			$("csvRB").disabled = true; //benjo 01.24.2017 SR-5917
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
				$("csvRB").disabled = false; //benjo 01.24.2017 SR-5917
			}else{
				$("pdfRB").disabled = true;
				$("csvRB").disabled = true; //benjo 01.24.2017 SR-5917
			}
		}
	}
	
	$("selReportMonth").observe("blur", function(){
		if ($F("selReportMonth") != ""){
			$("txtReportYear").value = new Date().getFullYear();
		}else{
			$("txtReportYear").value = "";
		}
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnPrint").observe("click", function(){
		if ($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer and No. of Copies are required.", "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			/* benjo 08.03.2016 SR-5512 */
			var reportId = "";
			
			if ($("inwardRB").checked){
				if($F("selDestination")=="FILE" && $("csvRB").checked){ //benjo 01.24.2017 SR-5917
					reportId = "GIRIR124_CSV";
				}else{
					reportId = "GIRIR124";
				}
			}else if($("outwardRB").checked){
				reportId = "GIRIR109";
			}
			
			var transaction = "";
			
			if ($("bookedRB").checked){
				transaction = "BOOKED";
			}else if($("unbookedRB").checked){
				transaction = "UNBOOKED";
			}
			/* end */

			var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiTreatyReport&reportId="+reportId+"&transaction="+transaction+ //benjo 08.03.2016 SR-5512
						  "&reportMonth="+$F("selReportMonth")+"&reportYear="+$F("txtReportYear")+"&noOfCopies="+$F("txtNoOfCopies")+
						  "&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "Treaty Bordereaux");
			} else if($F("selDestination") == "PRINTER"){
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
			}else if("FILE" == $F("selDestination")){ //benjo 01.24.2017 SR-5917 added csv
				var fileType = "";
				
				if($("csvRB").checked){
					fileType = "CSV2";
				}else{
					fileType = "PDF";
				}
				
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
							/*var message = $("fileUtil").copyFileToLocal(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}*/
							if (fileType == "CSV2"){
								copyFileToLocal(response, "csv");
							}else{
								copyFileToLocal(response);
							}
						}
					}
				});
			} else if("LOCAL" == $F("selDestination")){
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
				
			objRiReports.rep_type_sw = null;
		}
	});
</script>