<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>


<div id="policyPrintingMainDiv" style="">
	<form id="formPolicyPrinting">
		<input type="hidden" id="printOrder" name="printOrder" value="${printOrder}" />
		<input type="hidden" id="ackReportVersion" name="ackReportVersion" value="${ackReportVersion}">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="printPageId">Policy Printing</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		 			<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="policyPrintingDiv" class="sectionDiv">
			<c:choose>
				<c:when test="${printOrder eq '1'}">
					<jsp:include page="/pages/underwriting/subPages/printPolicyDetails.jsp"></jsp:include>
				</c:when>
				<c:when test="${printOrder eq '2'}">
					<jsp:include page="/pages/underwriting/subPages/reprintPolicyDetails.jsp"></jsp:include>
				</c:when>
			</c:choose>
			<div id="forPrintsListingDiv" style="margin: 10px;">
				<div style="width: 100%;" id="forPrintsTableDiv">
					<div class="tableHeader">
						<label style="width: 20%; text-align: left; margin-left: 10px;"">Document Type</label>
						<label style="width: 20%; text-align: left; margin-left: 10px;">Invoice Format</label>
						<label style="width: 15%; text-align: left; margin-left: 10px;">Destination</label>
						<label style="width: 25%; text-align: left; margin-left: 10px;">Printer Name</label>
						<label style="text-align: left; margin-left: 10px;">No. of Copies</label>
					</div>
					<div id="forPrintsContainerDiv" class="tableContainer">
						
					</div>
				</div>
			</div>
			<table style="margin-top: 30px; width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 25%;">
						Document Type
					</td>
					<td class="leftAligned" style="width: 30%;" colspan="4">
						<select id="docType" class="leftAligned required" style="width: 80%;"/>
							<option value=""></option>
							<option value="ACK">ACK</option>
							<option value="AOJ">AOJ</option>
							<option value="BILL">BILL</option>
							<option value="BINDER">BINDER</option>
							<option value="COC">COC</option>
							<option value="ENDORSEMENT">ENDORSEMENT</option>
							<option value="FLEET TAG">FLEET TAG</option>
							<option value="INDEMNITY">INDEMNITY</option>
						 	<option value="POLICY">POLICY</option>
						 	<option value="POLICY_SU">POLICY (FACE)</option>
						 	<option value="RENEWAL">RENEWAL</option>
						 	<option value="WARRANTIES AND CLAUSES">WARRANTIES AND CLAUSES</option> <!--Dren 02.02.2016 SR-5266 -->
<!-- 						 	<option value="RENEWAL CERTIFICATE">RENEWAL CERTIFICATE</option> commented out by Gzelle 12102014 SR3605 As per Ma'am Grace and Ma'am VJ, Renewal Certificate is no longer used. -->
						</select>
						<input type="text" class="required" id="txtDocType" name="txtDocType" style="display: none; width: 77%;" readonly="readonly"/>
						<input type="hidden" id="selectedDocType"/>
					</td>
					<td class="rightAligned" style="width: 10%;">
						Destination
					</td>
					<td class="leftAligned" style="width: 35%;">
						<select id="reportDestination" class="leftAligned required" style="width: 60%;"/>
							<option value=""></option>
							<option value="PRINTER">PRINTER</option>
							<option value="SCREEN">SCREEN</option>
							<option value="LOCAL PRINTER">LOCAL PRINTER</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 25%;">
					</td>
					<td class="rightAligned" style="width: 2%;">
						<input type="radio" id="perTakeUp" />
					</td>
					<td class="leftAligned" style="width: 13%;">
						<label id="lblPerTakeUp">Per Take Up</label>
					</td>
					<td class="rightAligned" style="width: 2%;">
						<input type="radio" id="summary"/>
					</td>
					<td class="leftAligned" style="width: 13%;">
						<label id="lblSummary">Summary</label>
					</td>
					<td class="rightAligned" style="width: 10%;">
					</td>
					<td class="leftAligned" style="width: 35%;">
						
					</td>
				</tr>
				<tr> <!-- belle 01.27.2012 -->
					<td class="rightAligned" style="width: 25%;">
					</td>
					<td class="rightAligned" style="width: 2%;">
						
					</td>
					<td class="leftAligned" style="width: 13%;">
						
					</td>
					<td class="rightAligned" style="width: 2%;">
						<input type="checkbox" id="details"/>
					</td>
					<td class="leftAligned" style="width: 13%;">
						<label id="lblDetails">Details</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 25%;">
						Printer Name
					</td>
					<td class="leftAligned" style="width: 30%;" colspan="4">
						<select id="printerName" class="leftAligned" style="width: 80%;"/>

						</select>
					</td>
					<td class="rightAligned" style="width: 10%;">
						No. of Copies
					</td>
					<td class="leftAligned" style="width: 35%;">
						<select id="noOfCopies" class="leftAligned" style="width: 60%;"/>
							<option value=""></option>
							<option value="1">1</option>
							<option value="2">2</option>
						 	<option value="3">3</option>
						 	<option value="4">4</option>
						 	<option value="5">5</option>
						</select>
					</td>
				</tr>
				<!-- a.alcantara, 08-15-2012 -->
				<tr>
					<td class="rightAligned" style="width: 25%;">
					</td>
					<td class="rightAligned" style="width: 2%;">
						<input type="checkbox" id="abbreviated" />
					</td>
					<td class="leftAligned" style="width: 13%;">
						<label id="lblAbbreviated">Abbreviated</label>
					</td>
					<td class="rightAligned" style="width: 2%;">
						<input type="checkbox" id="printPremium" checked="checked"/>
					</td>
					<td class="leftAligned" style="width: 13%;">
						<label id="lblPrintPremium" for="printPremium">Print Premium Details?</label>
					</td>
				</tr>
				<tr>
					<td colspan="7"></td>
				</tr>
				<tr style="text-align: center;">
					<td colspan="7" style="margin-left: 20px;">
						<input type="button" class="button" style="display: none; width: 20%; margin-left: 20px;" id="btnAddtlInfoSU" value="Additional Information" />
						<input type="button" class="button" id="btnAddPrint" value="Add" style="width: 10%;"/>
						<input type="button" class="button" id="btnDeletePrint" value="Delete"  style="width: 10%;"/>
					</td>
				</tr>
				<tr>
					<td colspan="7"></td>
				</tr>
			</table>
		</div>
		<div id="hiddenDiv">
			<input type="hidden" id="ctrlDestype" value="Printer"/>
			<input type="hidden" id="vValue" value="${vValue}"/>
			<!-- for SU additional info -->
			<div id="suAdditionalInfoDiv">
				<input type="hidden" id="withAddtlInfo" name="withAddtlInfo" value="" />
				<input type="hidden" id="hidRegDeedNo" 	name="hidRegDeedNo"	 value="" />
				<input type="hidden" id="hidRegDeed" 	name="hidRegDeed" 	 value="" />
				<input type="hidden" id="hidDateIssued" name="hidDateIssued" value="" />
				<input type="hidden" id="hidBondTitle" name="hidBondTitle" value="" />
				<input type="hidden" id="hidReason" name="hidReason" value="" />
				<input type="hidden" id="hidSavingsAcctNo" name="hidSavingsAcctNo" value="" />
				<input type="hidden" id="hidCaseNo" name="hidCaseNo" value="" />
				<input type="hidden" id="hidVersusA" name="hidVersusA" value="" />
				<input type="hidden" id="hidVersusB" name="hidVersusB" value="" />
				<input type="hidden" id="hidVersusC" name="hidVersusC" value="" />
				<input type="hidden" id="hidSheriffLoc" name="hidSheriffLoc" value="" />
				<input type="hidden" id="hidJudge" name="hidJudge" value="" />
				<input type="hidden" id="hidPartA" name="hidPartA" value="" />
				<input type="hidden" id="hidPartB" name="hidPartB" value="" />
				<input type="hidden" id="hidPartC" name="hidPartC" value="" />
				<input type="hidden" id="hidPartD" name="hidPartD" value="" />
				<input type="hidden" id="hidPartE" name="hidPartE" value="" />
				<input type="hidden" id="hidPartF" name="hidPartF" value="" />
				<input type="hidden" id="hidBranch" name="hidBranch" value="" />
				<input type="hidden" id="hidBranchLoc" name="hidBranchLoc" value="" />
				<input type="hidden" id="hidAppDate" name="hidAppDate" value="" />
				<input type="hidden" id="hidGuardian" name="hidGuardian" value="" />
				<input type="hidden" id="hidComplainant" name="hidComplainant" value="" />
				<input type="hidden" id="hidVersus" name="hidVersus" value="" />
				<input type="hidden" id="hidSection" name="hidSection" value="" />
				<input type="hidden" id="hidRule" name="hidRule" value="" />
				<input type="hidden" id="hidSignAJCL5" 		name="hidSignAJCL5"		 value="" />
				<input type="hidden" id="hidSignBJCL5" 		name="hidSignBJCL5"		 value="" />
				<input type="hidden" id="hidSignatory" 		name="hidSignatory"		 value="" />
				<input type="hidden" id="hidPeriod" 	name="hidPeriod" 	 value="" />
				<input type="hidden" id="hidSignA" 		name="hidSignA"		 value="" />
				<input type="hidden" id="hidSignB" 		name="hidSignB"		 value="" />
				<input type="hidden" id="hidAckLoc" 	name="hidAckLoc"	 value="" />
				<input type="hidden" id="hidAckDate" 	name="hidAckDate"	 value="" />
				<input type="hidden" id="hidDocNo" 		name="hidDocNo"		 value="" />
				<input type="hidden" id="hidPageNo" 	name="hidPageNo" 	 value="" />
				<input type="hidden" id="hidBookNo" 	name="hidBookNo"	 value="" />
				<input type="hidden" id="hidSeries" 	name="hidSeries" 	 value="" />			
			</div>			
			
			<input type="hidden" id="bondParType" 	name="bondParType" 	 value="P" />
			<input type="hidden" id="printPremiumHid" value="" />
			
			<input type="hidden" id="printSpoiledPolTag" value="${printSpoiledPolTag}" />
		</div>
		<div id="reportsDiv">
			<c:forEach items="${pol.lineReports}" var="rep" varStatus="ctr">
				<div id="row${rep.reportId}" name="report" reportId="${rep.reportId}" reportTitle="${rep.reportTitle}">
					<input type="hidden" id="reportId${rep.reportId}" value="${rep.reportId}"/>
					<input type="hidden" id="reportTitle${rep.reportId}" value="${rep.reportTitle}"/>
				</div>
			</c:forEach>
		</div>
		<div id="reportsDiv2">
			<c:forEach items="${reports2}" var="rep" varStatus="ctr">
				<div id="row${rep.reportId}" name="report2" reportId="${rep.reportId}" reportTitle="${rep.reportTitle}">
					<input type="hidden" id="reportId${rep.reportId}" value="${rep.reportId}"/>
					<input type="hidden" id="reportTitle${rep.reportId}" value="${rep.reportTitle}"/>
				</div>
			</c:forEach>
		</div>
		<div>
			<br/>
			<br/>
		</div>
		<div id="buttonsDiv" style="text-align: center;">
			<input type="button" class="button" id="btnCancel" value="Cancel"  style="width: 8%; margin-left: 20px;"/>
			<input type="button" class="button" id="btnPrint" value="Print"  style="width: 8%;"/>
		</div>
		<div>
			<br/>
			<br/>
		</div>
	</form>
</div>
<input type="hidden" id="vWarcla" value="${vWarcla}"><br> <!-- Dren 02.02.2016 SR-5266 -->
<input type="hidden" id="vWarcla3" value=""> <!-- Dren 02.02.2016 SR-5266 -->
<input type="hidden" id="printOrderHidden" value="${printOrder}"/>
<input type="hidden" id="packPolHidden" value="${packPol}"/>

<script type="text/javaScript">
	var printPremDetails = nvl('${printPremDetails}', 'N'); //marco - 11.19.2012
	initializeAccordion();
	disableButton("btnDeletePrint");
	disableButton("btnAddtlInfoSU"); 
	manageDocTypes(); 
	objPrintAddtl = new Object();
	objPrintAddtl.rowToPrint = null;
	
	if(getLineCd($F("policyLineCd")) != "SU") $("btnAddtlInfoSU").hide();
	
	insertPrinterNames();
	$("perTakeUp").disable();
	$("summary").disable(); 
	$("printerName").selectedIndex = 0;
	$("printerName").disable();
	$("noOfCopies").selectedIndex = 0;
	$("noOfCopies").disable();
	//belle 12.27.2012
	$("details").hide(); 
	$("lblDetails").hide();
	//d.alcantara 08/16/2012
	$("abbreviated").hide();
	$("lblAbbreviated").hide();
	
	if(printPremDetails == "N"){ //marco - 11.19.2012 - added condition
		$("printPremium").hide();
		$("lblPrintPremium").hide();
	}
	
	$("docType").observe("change", function(){
		if ($("docType").value != "BILL"){
			$("perTakeUp").disable();
			$("summary").disable();
			$("perTakeUp").checked = true;
			$("summary").checked = false;
			//$("lblPerTakeUp").disable();
			//$("lblSummary").disable();
			//belle 12.27.2012
			$("details").checked = false; 
			$("details").hide();  
			$("lblDetails").hide();
		} else {
			$("perTakeUp").enable();
			$("summary").enable();
			//$("lblPerTakeUp").enable();
			//$("lblSummary").enable();
		}
	});
	
	$("perTakeUp").checked = true;
	$("summary").checked = false;
	
	//belle 07.12.12
	$("reloadForm").observe("click", function(){
		showPolicyPrintingPage();	
	});
	
	
	$("perTakeUp").observe("click", function(){
		$("summary").checked = false;
		//belle 12.27.2012
		$("details").checked = false; 
		$("details").hide();  
		$("lblDetails").hide();
	});
	
	$("summary").observe("click", function(){
		$("perTakeUp").checked = false;
		//belle 12.27.2012
		$("details").show();  
		$("lblDetails").show();
	});
	
	$("reportDestination").observe("change", function(){
		checkPrintDestinationFields();
	});
	
	if ($("invoiceNo").options[1] != undefined) {
		$("invoiceNo").selectedIndex = 1;
	}
	
	$("btnDeletePrint").observe("click", function(){
		$$("div[name='forPrint']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				isSelectedExist = true;
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function ()	{
						row.remove();
						manageDocTypes();
						moderateDocTypeOptions();
						clearAddPrintFields();
						disableButton("btnDeletePrint");
						disableButton("btnAddtlInfoSU");						
					}
				});
			}
		});
	});
	
	$("btnAddPrint").observe("click", function(){
		if (validateBeforeSave()){
			var docType 	= $("docType").value;
			var destination	= $("reportDestination").value;
			var printerName = $("printerName").value;
			var noOfCopies 	= $("noOfCopies").value;
			var invoiceFormat = "";
			if ("BILL" == docType){
				if ($("perTakeUp").checked == true){
					invoiceFormat = "Per Takeup";
				}else if ($("summary").checked == true && $("details").checked == true){ //belle 01.27.2012 
					invoiceFormat = "Details";
				} else {
					invoiceFormat = "Summary";
				}
			} else {
				invoiceFormat = "---";
			}
			if ("" == printerName){
				printerName = "---";
			}
			if ("" == noOfCopies){
				noOfCopies = "---";
			}
			if((getLineCd($F("policyLineCd")) == "MC" || $F("packPolFlag") == "Y") && docType == "COC") {
				showEnterCOCOverlay();
			}

			if ($F("btnAddPrint") == "Update"){
				var oldDocType = $F("selectedDocType");
				$("row"+oldDocType).writeAttribute("id", "row"+docType);
				$("row"+docType).writeAttribute("name", "forPrint" /*printerName == "---" ? "printRow" : "forPrint"*/);
				$("row"+docType).writeAttribute("docType", docType);
				$("row"+docType).writeAttribute("destination", destination);
				$("row"+docType).writeAttribute("printerName", printerName);
				$("row"+docType).writeAttribute("noOfCopies", noOfCopies);
				$("row"+docType).writeAttribute("invoiceFormat", invoiceFormat);
				$("row"+docType).update("<label style='width: 20%; text-align: left; margin-left: 10px;'>"+docType+"</label>"
						+"<label style='width: 20%; text-align: left; margin-left: 10px;'>"+invoiceFormat+"</label>"
						+"<label style='width: 15%; text-align: left; margin-left: 10px;'>"+destination+"</label>"
						+"<label name='text' style='width: 25%; text-align: left; margin-left: 10px;'>"+printerName+"</label>"
						+"<label style='text-align: left; margin-left: 10px;'>"+noOfCopies+"</label>"
						+"<input type='hidden' id='docType"+docType.replace(" ", "_")+"' name='docType' value='"+docType+"'/>"
						+"<input type='hidden' id='invoiceFormat"+docType.replace(" ", "_")+"' name='invoiceFormat' value='"+invoiceFormat+"'/>"
						+"<input type='hidden' id='destination"+docType.replace(" ", "_")+"' name='destination' value='"+destination+"'/>"
						+"<input type='hidden' id='printerName"+docType.replace(" ", "_")+"' name='printerName' value='"+printerName+"'/>"
						+"<input type='hidden' id='noOfCopies"+docType.replace(" ", "_")+"' name='noOfCopies' value='"+noOfCopies+"'/>");
				manageDocTypes();
				moderateDocTypeOptions();
				clearAddPrintFields();
				$("row"+docType).removeClassName("selectedRow");
				if (("BILL" == docType) && ("BILL" != oldDocType)){
					$("row"+docType).observe("click", function ()	{
						if ($("row"+docType).hasClassName("selectedRow"))	{
							try {
								var InvoiceFormat		= $("row"+docType).down("label", 1).innerHTML;
								if ("Per Takeup" == InvoiceFormat){
									$("perTakeUp").enable();
									$("summary").enable();
									$("perTakeUp").checked = true;
									$("summary").checked = false;
								} else if ("Summary" == InvoiceFormat){
									$("perTakeUp").enable();
									$("summary").enable();
									$("perTakeUp").checked = false;
									$("summary").checked = true;
									//belle 01.27.2012
									$("details").show();
									$("lblDetails").show();
								}else if ("Details" ==  InvoiceFormat){ // belle 01.27.2012
									$("perTakeUp").enable();
									$("summary").enable();
									$("details").show();
									$("lblDetails").show();
									$("perTakeUp").checked = false;
									$("summary").checked = true;
									$("details").checked = true;
								}else {
									$("perTakeUp").disable();
									$("summary").disable();
									$("perTakeUp").checked = true;
									$("summary").checked = false;
									//belle 01.27.2012
									$("details").checked = false; 
									$("details").hide();  
									$("lblDetails").hide();
								}	
							} catch (e){
								showErrorMessage("policyPrinting.jsp - btnAddPrint", e);
							}
						} else {
							
						}
					});
				}
				
			} else { // if Add
				var newDiv 		= new Element("div");
				newDiv.setAttribute("id", "row"+docType);
				newDiv.setAttribute("name", "forPrint");
				newDiv.addClassName("tableRow");
				newDiv.setAttribute("docType", docType);
				newDiv.setAttribute("destination", destination);
				newDiv.setAttribute("printerName", printerName);
				newDiv.setAttribute("noOfCopies", noOfCopies);
				newDiv.setAttribute("invoiceFormat", invoiceFormat);
				newDiv.setStyle("display: none;");
				newDiv.update("<label style='width: 20%; text-align: left; margin-left: 10px;'>"+docType+"</label>"
					+"<label style='width: 20%; text-align: left; margin-left: 10px;'>"+invoiceFormat+"</label>"
					+"<label style='width: 15%; text-align: left; margin-left: 10px;'>"+destination+"</label>"
					+"<label name='text' style='width: 25%; text-align: left; margin-left: 10px;'>"+printerName+"</label>"
					+"<label style='text-align: left; margin-left: 10px;'>"+noOfCopies+"</label>"
					+"<input type='hidden' id='docType"+docType.replace(" ", "_")+"' name='docType' value='"+docType+"'/>"
					+"<input type='hidden' id='invoiceFormat"+docType.replace(" ", "_")+"' name='invoiceFormat' value='"+invoiceFormat+"'/>"
					+"<input type='hidden' id='destination"+docType.replace(" ", "_")+"' name='destination' value='"+destination+"'/>"
					+"<input type='hidden' id='printerName"+docType.replace(" ", "_")+"' name='printerName' value='"+printerName+"'/>"
					+"<input type='hidden' id='noOfCopies"+docType.replace(" ", "_")+"' name='noOfCopies' value='"+noOfCopies+"'/>");
				$("forPrintsContainerDiv").insert({bottom: newDiv});

				loadRowMouseOverMouseOutObserver(newDiv);				
	
				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						var selectedRowExists = false;
						$$("div[name='forPrint']").each(function (r)	{
							if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
								selectedRowExists = true;
								r.removeClassName("selectedRow");
							}
						});

						var DocType				= newDiv.getAttribute("docType");//newDiv.down("input", 0).value;
						var InvoiceFormat		= newDiv.getAttribute("invoiceFormat");//newDiv.down("input", 1).value;
						var Destination			= newDiv.getAttribute("destination");//newDiv.down("input", 2).value;
						var PrinterName			= newDiv.getAttribute("printerName");//newDiv.down("input", 3).value;
						var NoOfCopies			= newDiv.getAttribute("noOfCopies");//newDiv.down("input", 4).value;
						
						//display doctype
						var a 					= $("docType");
						for (var w=0; w<a.length; w++){
							if (a.options[w].value == DocType){
								$("docType").selectedIndex = w;
							}
						}
	
						//destination
						var b 					= $("reportDestination");
						for (var x=0; x<b.length; x++){
							if (b.options[x].value == Destination){
								$("reportDestination").selectedIndex = x;
							}
						}
	
	
						//printerName & noOfCopies
						var c = $("printerName");
						var d = $("noOfCopies");
						if ("SCREEN" == Destination || "LOCAL PRINTER" == Destination){ //marco - 06.21.2013 - added local
							$("printerName").removeClassName("required");
							$("noOfCopies").removeClassName("required");
							$("printerName").disable();
							$("noOfCopies").disable();
							$("printerName").selectedIndex = 0;
							$("noOfCopies").selectedIndex = 0;
						} else {
							$("printerName").enable();
							$("noOfCopies").enable();
							$("printerName").addClassName("required");
							$("noOfCopies").addClassName("required");
							for (var y=0; y<c.length; y++){
								if (c.options[y].value == PrinterName){
									$("printerName").selectedIndex = y;
								}
							}
							for (var z=0; z<d.length; z++){
								if (d.options[z].value == NoOfCopies){
									$("noOfCopies").selectedIndex = z;
								}
							}
						}
	
						//invoiceFormat
						if ("Per Takeup" == InvoiceFormat){
							$("perTakeUp").enable();
							$("summary").enable();
							$("perTakeUp").checked = true;
							$("summary").checked = false;
						} else if ("Summary" == InvoiceFormat){
							$("perTakeUp").enable();
							$("summary").enable();
							$("perTakeUp").checked = false;
							$("summary").checked = true;
							//belle 01.27.2012
							$("details").show();
							$("lblDetails").show();
						}else if ("Details" ==  InvoiceFormat){ // belle 01.27.2012
							$("perTakeUp").enable();
							$("summary").enable();
							$("details").show();
							$("lblDetails").show();
							$("perTakeUp").checked = false;
							$("summary").checked = true;
							$("details").checked = true;
						} else {
							$("perTakeUp").disable();
							$("summary").disable();
							$("perTakeUp").checked = true;
							$("summary").checked = false;
							//belle 01.27.2012
							$("details").checked = false; 
							$("details").hide();  
							$("lblDetails").hide();
						}
	
						togglePKFieldView("docType", "txtDocType", newDiv.getAttribute("docType"), selectedRowExists);
						$("selectedDocType").value = newDiv.getAttribute("docType");
						$("btnAddPrint").value	= "Update";
						enableButton("btnDeletePrint");
						enableButton("btnAddtlInfoSU");
					} else {
						disableButton("btnDeletePrint");
						disableButton("btnAddtlInfoSU");						
						clearAddPrintFields();
					}
				});
			}
			if ("" == noOfCopies){
				noOfCopies = 0;
			}
			
			Effect.Appear("row"+docType, {
				duration: .2,
				afterFinish: function () {
				//cleadAddBankFields();
				manageDocTypes();
				moderateDocTypeOptions();
				clearAddPrintFields();
				}
			});
		}
		$$("label[name='text']").each(function (label)	{
			if ((label.innerHTML).length > 30)	{
				label.update((label.innerHTML).truncate(30, "..."));
			}
		});
	});
	
	if ($F("billNotPrinted")=="Y"){
		showMessageBox("Total Amount Due is 0, bill will not be printed.", "info");
		$("docType").childElements().each(function (o) {
			if (o.value == "BILL"){
				o.hide();
			}
		});
	}
	
	reports = []; //marco - 06.25.2013 - for showMultiPdfReport
	$("btnPrint").observe("click", function(){
		showNotice("Preparing to print...");
		if($F("printSpoiledPolTag") == "N" && $F("polFlag") == "5") { //hardcoded muna si spoiledpolicy tag
			showMessageBox("This policy is already spoiled.", "error");
		} else {
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getExtractId", {
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					$("extractId").value = response.responseText;
					//hideNotice("");
					startPrinting();
					hideNotice("");
				}
			});
		}
		
	});
	
	function startPrinting(){
		try{
			var forPrintCount  = 0;
			var forPrintExists = false;
			var policyPrints	= false;
			var printToPrinter	= false;		
			var lineCd 		   = getLineCd($F("policyLineCd")); //$F("policyLineCd"); // <-- mark jm 04.25.2011 @UCPBGEN used getLineCd instead		
			var issCd		   = $F("issCd");
			var sublineCd	   = $F("sublineCd");
			var vShowField	   = $F("vShowField");
			var compulsoryDeath = $F("compulsoryDeath");
			var cocType			= $F("cocType");
			var endtTax			= $F("endtTax");
			var itmperilCount	= $F("itmperilCount");
			$("printPremiumHid").value = $("printPremium").checked ? "Y" : "N";
			var withCoc = false;
			
			//checks each report for printing
			$$("div[name='forPrint']").each(function(r){
				var docType 		= r.getAttribute("docType");//r.down("input", 0).value;
				var invoiceFormat 	= r.getAttribute("invoiceFormat");//r.down("input", 1).value;
				var destination 	= r.getAttribute("destination");//r.down("input", 2).value;
				var printerName 	= r.getAttribute("printerName");//r.down("input", 3).value;
				var noOfCopies 		= ((r.getAttribute("noOfCopies") == "---" || r.getAttribute("noOfCopies") == "") 
						? 0 : r.getAttribute("noOfCopies"));//r.down("input", 4).value;
				var chkAck		   = false;
				var chkAoj		   = false;
				var chkBill		   = false;
				var chkBinder	   = false;
				var chkCoc		   = false;
				var chkEndorse	   = false;
				var chkFleetTag	   = false;
				var chkIndem	   = false;
				var chkPolicy	   = false;
				var chkRen		   = false;
				var chkWarcla      = false; //Dren 02.02.2016 SR-5266
				//var chkRenCert	   = false;	commented out by Gzelle 12102014
				var printAllowed = false;				

				forPrintExists = true;
				if ("ACK" == docType){
					chkAck = true;
				} else if ("AOJ" == docType){
					chkAoj = true;
				} else if ("INDEM" == docType){
					chkIndem = true;	
				} else if ("BILL" == docType){
					chkBill = true;
				} else if ("BINDER" == docType){
					chkBinder = true;
				} else if ("COC" == docType){
					chkCoc = true;
				} else if ("ENDORSEMENT" == docType){
					chkEndorse = true;
				} else if ("FLEET TAG" == docType){
					chkFleetTag = true;
				} else if ("INDEMNITY" == docType){
					chkIndem = true;
				} else if (("POLICY" == docType) || ("POLICY_SU" == docType)){
					chkPolicy = true;
				} else if ("RENEWAL" == docType){
					chkRen = true;
				} else if ("WARRANTIES AND CLAUSES" == docType){
					chkWarcla = true; //Dren 02.02.2016 SR-5266
				}
				//} else if ("RENEWAL CERTIFICATE" == docType){	commented out by Gzelle 12102014 SR3605
				//	chkRenCert = true; As per Ma'am Grace and Ma'am VJ, Renewal Certificate is no longer used.

				if (("SU" == lineCd)					        
						&& ((chkPolicy)
						|| (chkAck)
						|| (chkAoj)
						|| (chkIndem)
						|| (chkEndorse))){
					//sublineCd in ('S1','JCL15','G15','G14','G28','JCL5', 'JCL13', 'JCL6', 'OWR')
					if (true) { //may iallagay pang condition dito pero di ko magets kasi     
							var printBinder = true;
							$$("div[name='report']").each(function(r){     
							var printAllowed = false;
							var reportId = r.getAttribute("reportId");//r.down("input", 0).value;
							var reportTitle = r.getAttribute("reportTitle");//r.down("input", 1).value;
							
							//this portion checks if the reports will be allowed to be printed or not
							//FOR COC PRINTING
							if ((chkCoc) && (("GIPIR914" == reportId) || ("GIPIR915" == reportId))){
								if ("Y" == compulsoryDeath){
									if (("LTO" == cocType) && ("GIPIR914" == reportId)){
										printAllowed = true;
									} else if (("NLTO" == cocType) && ("GIPIR915" == reportId)) {
										printAllowed = true;
									}
								}
							}
		
							//FOR INVOICE PRINTING
							else if ((chkBill) && ("GIRIR009" == reportId)
									&& (("RI" == issCd) || ("RB" == issCd))
									&& ("N" == $F("vAccSlip"))){
								printAllowed = true;
							}
							else if ((chkBill) && ("GIRIR120" == reportId)
									&& (("RI" == issCd) || ("RB" == issCd))
									&& ("Y" == $F("vAccSlip"))){
								printAllowed = true;
							}
							else if ((chkBill) && ("GIPIR025" == reportId)
									&& (!(("RI" == issCd) || ("RB" == issCd)))
									&& ("SU" == lineCd)){
								printAllowed = true;
							}
		
							//FOR RENEWAL PRINTING
							else if ((chkRen) && (("GIPIR933" == reportId))){
								printAllowed = true;
							}
							else if ((chkRen) && (("GIPIR152" == reportId))){
								printAllowed = false;
								forPrintCount = parseFloat(forPrintCount) + 1; 
								policyPrints = true;
								populateGixxTables(reportId, destination, printerName, noOfCopies, lineCd);
							}
							else if ((chkAoj) && ("AOJ" == reportId) && $F("ackReportVersion") != "RSIC"){ // andrew - 06.01.2012 - to handle special case of republic
								printAllowed = true;
							}
							else if ((chkAck) && ("ACK" == reportId)){
								printAllowed = true;
							}
							else if((chkIndem) && ( "INDEM" == reportId || "INDEMNITY" == reportId)){
								printAllowed = true;
							}
							else if((chkEndorse) && ( "BONDS" == reportId)) {
								$("bondParType").value = "E";
								printAllowed = false;
								// added by d.alcantara, 11-11-11, to prevent printing the report twice
								forPrintCount = parseFloat(forPrintCount) + 1; 
								policyPrints = true;
								// - - - 
								populateGixxTables(reportId, destination, printerName, noOfCopies, lineCd); //It seems the blank report that is generated is caused by not populating the GIIX_POLBASIC table. The other lines might need this function too. - irwin 10.10.11
							}
							else if((chkBinder) && ("BINDER" == reportId)){
								printAllowed = true;
							}						
							//PRINTING PROCESS
							if (printAllowed){
								if(reportId == "GIPIR914" || reportId == "GIPIR915") {
									for(var i=0; i<objPrintAddtl.printRows.length; i++) {
										objPrintAddtl.rowToPrint = objPrintAddtl.printRows[i];
										printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, sublineCd, 'Y'); 
										forPrintCount = parseFloat(forPrintCount) + 1;
									}
								} else {
									printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, sublineCd, 'Y'); 
									forPrintCount = parseFloat(forPrintCount) + 1;
								}
								
							}
							
							//BINDER --marco - 04.24.2013
							if((chkBinder) && (printBinder)){
								printBinder = false;
								new Ajax.Request(contextPath+"/GIRIBinderController?action=getBinders&policyId="+$F("policyId"),{
									method: "GET",
									evalScripts: true,
									asynchronous: true,
									onComplete: function(response){
										if(checkErrorOnResponse(response)){
											var obj = eval(response.responseText);
											for(var i = 0; i < obj.length; i++){
												printBinderReport("GIRIR001", obj[i].LINE_CD, obj[i].BINDER_YY, obj[i].BINDER_SEQ_NO, obj[i].FNL_BINDER_ID, noOfCopies, printerName, destination);
											}
										}
									}
								});
								forPrintCount = parseFloat(forPrintCount) + 1;
							}
						});
					}
					if (chkPolicy){
						forPrintCount++;
						bondsPrinting(destination, printerName, noOfCopies, 0);
						forPrintExists = true;
					}
				} else {//other line codes
					if ("Y" == $F("packPolFlag")){
						$$("div[name='report2']").each(function(r){
							var printAllowed = false;
							var reportId = r.down("input", 0).value;
							var reportTitle = r.down("input", 1).value;							
							//FOR POLICY DOCS
							if (((chkEndorse)||(chkPolicy)) && ("PACKAGE" == reportId)){
								printAllowed = false;
								forPrintCount = parseFloat(forPrintCount) + 1;
								populateGixxTables(reportId, destination, printerName, noOfCopies);
								policyPrints = true;
							} 
							//FOR COC PRINTING
 							else if ((chkCoc) && (("GIPIR914" == reportId) || ("GIPIR915" == reportId))){
 								withCoc = true;
								/* if ("Y" == compulsoryDeath){
									if (("LTO" == cocType) && ("GIPIR914" == reportId)){
										printAllowed = true;
									} else if (("NLTO" == cocType) && ("GIPIR915" == reportId)) {
										printAllowed = true;
									}
								} */
							} 
							
							//FOR INVOICE PRINTING
							else if ((chkBill) && (("GIPIR913" == reportId) || ("GIPIR913A" == reportId))
									&& (!(("RI" == issCd) || ("RB" == issCd)))){
								if ("GIPIR913" == reportId){
									if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = true;
									} else { printAllowed = false;}
								} else if ("GIPIR913A" == reportId) {
									if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = false;
									} else { printAllowed = true;}
								}
							}
							else if ((chkBill) && ("GIPIR913B" == reportId.toUpperCase())
									&& (!(("RI" == issCd) || ("RB" == issCd)))){
								//if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){ //$F("endtTax2") belle 07.12.12
							    /* Comment out by Joms Diago 03132013
							    ** As confirmed, endt_tax Y must be allowed for print.
							    */
							    //balik sa dati, sorry joms :) by robert 
								if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = false;
								} else { 
										printAllowed = true;
									}
							}
							else if ((chkBill) && ("GIRIR009A" == reportId) 
									&& (("RI" == issCd) || ("RB" == issCd))){
								printAllowed = true;
							}
							else if((chkBinder) && ("BINDER" == reportId)){
								printAllowed = true;
							}
							//PRINTING PROCESS
							if (printAllowed){
								printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, sublineCd, 'Y'); 
								forPrintCount = parseFloat(forPrintCount) + 1;
							}														
						});
						
						if(withCoc) {
							if(objPrintAddtl.printRows != null){
								for(var i=0; i<objPrintAddtl.printRows.length; i++) {
									objPrintAddtl.rowToPrint = objPrintAddtl.printRows[i];
									if ("Y" == objPrintAddtl.rowToPrint.compulsoryFlag){
										if (("LTO" == objPrintAddtl.rowToPrint.cocType)){
											reportId = "GIPIR914";
											printAllowed = true;
										} else if (("NLTO" == objPrintAddtl.rowToPrint.cocType)) {
											reportId = "GIPIR915";
											printAllowed = true;
										}
									}
									if(printAllowed) {
										printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, sublineCd, 'Y'); 
										forPrintCount = parseFloat(forPrintCount) + 1;
									}
								}
							}
						}
					} // end for PACKAGES
					else { //if non-PACK
						// assigns a value XX to lineCd unidentified by DB
						if (!(("AC" == lineCd) 
								|| ("AV" == lineCd) || ("CA" == lineCd) 
								|| ("EN" == lineCd) || ("FI" == lineCd) || ("MN" == lineCd) 
								|| ("MH" == lineCd) || ("MC" == lineCd) || ("SU" == lineCd) 
								|| ("MD" == lineCd))){
							lineCd = "XX"; 
						}
						var printBinder = true;
						$$("div[name='report']").each(function(r){
							var printAllowed = false;
							var reportId = r.getAttribute("reportId");//r.down("input", 0).value;
							var reportTitle = r.getAttribute("reportTitle");//r.down("input", 1).value;
							
							//FOR COC PRINTING
							if ((chkCoc) && (("GIPIR914" == reportId) || ("GIPIR915" == reportId))){
								if ("Y" == compulsoryDeath){
									if (("LTO" == cocType) && ("GIPIR914" == reportId)){
										printAllowed = true;
									} else if (("NLTO" == cocType) && ("GIPIR915" == reportId)) {
										printAllowed = true;
									}
								}
							}
							//FOR INVOICE PRINTING
							//for Summary
							else if ((chkBill) && ("Summary" == invoiceFormat)
									&& (("GIPIR913C" == reportId) || ("GIPIR913D" == reportId))
				                    && (!(("RI" == issCd) || ("RB" == issCd)))
									&& ("SU" != lineCd)){
								if ( "GIPIR913C" == reportId ){ //belle 01.27.2012
									if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = false;
									}
									else {printAllowed = true;}
								}
							}
							//for Details belle 01.27.2012
							else if ((chkBill) && ("Details" == invoiceFormat)
									&& (("GIPIR913D" == reportId))
				                    && (!(("RI" == issCd) || ("RB" == issCd)))
									&& ("SU" != lineCd)){
								if ( "GIPIR913D" == reportId ){
									if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = false;
									}
									else {printAllowed = true;}
								}
							}
							//for Per Takeup
							else if ((chkBill) && ("Per Takeup" == invoiceFormat)
									&& (("GIPIR913" == reportId) || ("GIPIR913A" == reportId) 
										|| ("GIPIR025" == reportId)/*  || ("GIPIR913B" == reportId) */) // andrew - 11.22.2012 - GIPIR913B is for package policy
									&& (!(("RI" == issCd) || ("RB" == issCd)))
				                    && ("SU" != lineCd)){
								if ("GIPIR913A" == reportId){
									if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = true;
									} else {
										printAllowed = false;
										}
								} else if ("GIPIR913" == reportId){
									if (("Y" == endtTax) && (0 == parseFloat(itmperilCount))){
										printAllowed = false;
									}
									else {printAllowed = true;}
								} else if (("GIPIR025" == reportId) || ("GIPIR913B" == reportId)){
									printAllowed = true;
								}
							}
		
							else if ((chkBill) && ("GIRIR009" == reportId)
									&& (("RI" == issCd) || ("RB" == issCd))
									&& ("N" == $F("vAccSlip"))){
								printAllowed = true;
							}
							else if ((chkBill) && ("GIRIR120" == reportId)
									&& (("RI" == issCd) || ("RB" == issCd))
									&& ("Y" == $F("vAccSlip"))){
								printAllowed = true;
							}
							else if ((chkBill) && ("GIPIR025" == reportId)
									&& (!(("RI" == issCd) || ("RB" == issCd)))
									&& ("SU" == lineCd)){
								printAllowed = true;
							}
							
							//FOR RENEWAL PRINTING
							else if ((chkRen) && (("GIPIR933" == reportId))){
								printAllowed = true;
							}
							else if ((chkRen) && (("GIPIR152" == reportId))){
								printAllowed = false;
								forPrintCount = parseFloat(forPrintCount) + 1; 
								policyPrints = true;
								populateGixxTables(reportId, destination, printerName, noOfCopies, lineCd);
							}
							
							//FLEET POLICY PRINTING
							/* else if ((chkFleetTag) && ("GIPIR049" == reportId)){ comment out muna, wala pang paper size na field sa web and wala pang GIPIR049 na jasper - andrew 1.24.2013
								printAllowed = true;
							} */
							else if ((chkFleetTag) && ("GIPIR049A" == reportId)){
								printAllowed = true;
							}
		
							//POLICY OR ENDORSEMENT
							else if (((chkPolicy) || (chkEndorse))
									&& (("ACCIDENT" == reportId) || ("AVIATION" == reportId) || ("CASUALTY" == reportId)
											 || ("ENGINEERING" == reportId) || ("MEDICAL" == reportId) || ("FIRE" == reportId)
											 || ("MARINE_CARGO" == reportId) || ("MARINE_HULL" == reportId) || ("MOTORCAR" == reportId)
											 || ("OTHER" == reportId))){
								printAllowed = false;
								forPrintCount = parseFloat(forPrintCount) + 1;
								populateGixxTables(reportId, destination, printerName, noOfCopies, lineCd);	//added lineCd by Gzelle 09082014
								policyPrints = true;
							}
							
							//WARRANTIES AND CLAUSES
							else if ((chkWarcla) && (("GIPIR153" == reportId))){
								printAllowed = false; //true								
								populateGixxTables(reportId, destination, printerName, noOfCopies, lineCd);
								forPrintExists = true;
								forPrintCount = parseFloat(forPrintCount) + 1; 
							} //Dren 02.02.2016 SR-5266
		
							//PRINTING PROCESS
							if (printAllowed){
								if(reportId == "GIPIR914" || reportId == "GIPIR915") {
									for(var i=0; i<objPrintAddtl.printRows.length; i++) {
										objPrintAddtl.rowToPrint = objPrintAddtl.printRows[i];
										printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, sublineCd, 'Y'); 
										forPrintCount = parseFloat(forPrintCount) + 1;
									}									
								} else {
									printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, sublineCd, 'Y'); 
									forPrintCount = parseFloat(forPrintCount) + 1;
								}
							}
							
							//BINDER --marco - 04.24.2013
							if((chkBinder) && (printBinder)){
								printBinder = false;
								new Ajax.Request(contextPath+"/GIRIBinderController?action=getBinders&policyId="+$F("policyId"),{
									method: "GET",
									evalScripts: true,
									asynchronous: true,
									onComplete: function(response){
										if(checkErrorOnResponse(response)){
											var obj = eval(response.responseText);
											for(var i = 0; i < obj.length; i++){
												printBinderReport("GIRIR001", obj[i].LINE_CD, obj[i].BINDER_YY, obj[i].BINDER_SEQ_NO, obj[i].FNL_BINDER_ID, noOfCopies, printerName, destination);
											}
										}
									}
								});
								forPrintCount = parseFloat(forPrintCount) + 1;
							}
						});
					}
				}
				if (("PRINTER" == destination || "LOCAL PRINTER" == destination) && ((printAllowed) || (policyPrints))){ //marco - 06.21.2013 - local printer
					printToPrinter = true;
				}
			});	
			
			//marco - 06.25.2013
			if(parseInt(reports.length) > 0){
				showMultiPdfReport(reports);
			}
			reports = [];
			
			//if after evaluation, no reports for print were found this will execute
			if (parseFloat(forPrintCount) == 0){
				forPrintExists = false;
			}
			
			if (!(forPrintExists)){
				showMessageBox("There is nothing to print.", "error");
			} else {
				if (printToPrinter){
					//adds 1 to polendt_printed_cnt in GIPI_POLBASIC for every successful printing to printer
					new Ajax.Request(contextPath+"/GIPIPolbasicController?action=updatePrintedCount&policyId="+$F("policyId"), {
						method: "GET",
						evalScripts: true,
						asynchronous: false
					});
				}
			}
		} catch(e){
			showMessageBox("startPrinting: "+e.message, imgMessage.ERROR);
		}
	}
	
	function validateBeforeSave(){
		var result = true;
		if ($("docType").selectedIndex == 0){
			result = false;
			$("docType").focus();
			showMessageBox("Document Type is required.", "error");
		} else if ($("reportDestination").selectedIndex == 0){
			result = false;
			$("reportDestination").focus();
			showMessageBox("Destination is required.", "error");
		} else if (($("printerName").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
			result = false;
			$("printerName").focus();
			showMessageBox("Printer Name is required.", "error");
		} else if (($("noOfCopies").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
			result = false;
			$("noOfCopies").focus();
			showMessageBox("No. of Copies is required.", "error");
		} else if($F("printSpoiledPolTag") == "N" && $F("polFlag") == "5") { //hardcoded muna si spoiledpolicy tag
			result = false;
			showMessageBox("This policy is already spoiled.", "error");
		}
		return result;
	}
	
	function clearAddPrintFields(){
		$("docType").selectedIndex = 0;
		$("reportDestination").selectedIndex = 0;
		$("printerName").selectedIndex = 0;
		$("noOfCopies").selectedIndex = 0;
		$("noOfCopies").disable();
		$("selectedDocType").value = "";
		$("perTakeUp").disable();
		$("summary").disable();
		$("perTakeUp").checked = true;
		$("summary").checked = false;
		$("printerName").selectedIndex = 0;
		$("printerName").disable();
		$("btnAddPrint").value = "Add";
		$("btnDeletePrint").disable();
		$("noOfCopies").removeClassName("required");
		$("printerName").removeClassName("required");
		$("docType").show();
		$("docType").selectedIndex = 0;
		$("txtDocType").hide();
		$("txtDocType").value = "";
		//belle 01.27.2012
		$("details").hide();
		$("lblDetails").hide();
		$("details").checked = false;
		
	}
	
	function removeSpaces(string) {
		return string.split(" ").join("");
	}
	
	function openPdfInAWindow(fileName){
		//window.open(fileName, "haha", "location=no,toolbar=no,menubar=no");
		showPdfReport(content, ""); // andrew - 12.12.2011
	}
	
	function bondsPrinting(destination, printerName, noOfCopies, isDraft){
		try{
			//var lineCd 		   = $F("policyLineCd");
			var lineCd 		   = getLineCd($F("policyLineCd"));
			var sublineCd	   = $F("sublineCd");
			if ("SU" == lineCd){
				populateGixxTables("BONDS", destination, printerName, noOfCopies, lineCd);
				//printCurrentReport("SURETYSHIP", destination, printerName, noOfCopies, isDraft);
			}
		} catch(e){
			showMessageBox("bondsPrinting: "+e.message, imgMessage.ERROR); 
		}
	}

	function showSUAdditionalInfo(){
		try {
			if(getLineCd($F("policyLineCd")) == "SU") { 
				var height = 370;
				var width = 425;
				
				if($F("txtDocType") == "POLICY_SU") {
					if($F("sublineCd") == "G15" || $F("sublineCd") == "G(15)" || $F("sublineCd") == "G14" || $F("sublineCd") == "G(14)"){
						height = 180;
					} else if($F("sublineCd") == "G28" || $F("sublineCd") == "G(28)" || $F("sublineCd") == "JCL6" || $F("sublineCd") == "JCL(6)" || $F("sublineCd") == "JCL06" || $F("sublineCd") == "JCL(06)"){
						height = 210;
					} else if($F("sublineCd") == "JCL15" || $F("sublineCd") == "JCL(15)"){
						height = 280;
					} else if($F("sublineCd") == "JCL(13)" || $F("sublineCd") == "JCL13"){
						height = 340;
					} else if($F("sublineCd") == "JCL(5)" || $F("sublineCd") == "JCL5" || $F("sublineCd") == "JCL(05)" || $F("sublineCd") == "JCL05"){
						height = 520;
						width = 450;
					} 
				}
				
				overlayAddtlInfo = Overlay.show(contextPath+"/GIPIPolbasicController", {
					urlContent: true,
					urlParameters: {action 	: 	"showSUAddtlInfo",
									reportId : $F("txtDocType"),
									sublineCd : $F("sublineCd"),
									period	:	$F("hidPeriod"),
									signA	:   escapeHTML2($F("hidSignA")),
									signB	:	escapeHTML2($F("hidSignB")),
									ackLoc	:	$F("hidAckLoc"),
									ackDate	:	$F("hidAckDate"),
									docNo	:	$F("hidDocNo"),
									pageNo	:	$F("hidPageNo"),
									bookNo	:	$F("hidBookNo"),
									series	:	$F("hidSeries"),
									regDeedNo : $F("hidRegDeedNo"),
									dateIssued : $F("hidDateIssued"),
									regDeed : $F("hidRegDeed"),
									bondTitle : $F("hidBondTitle"),
									reason : $F("hidReason"),
									savingsAcctNo : $F("hidSavingsAcctNo"),
									caseNo : $F("hidCaseNo"),
									versusA : $F("hidVersusA"),
									versusB : $F("hidVersusB"),
									versusC : $F("hidVersusC"),
									sheriffLoc : $F("hidSheriffLoc"),
									judge : $F("hidJudge"),
									partA : $F("hidPartA"),
									partB : $F("hidPartB"),
									partC : $F("hidPartC"),
									partD : $F("hidPartD"),
									partE : $F("hidPartE"),
									partF : $F("hidPartF"),
									branch : $F("hidBranch"),
									branchLoc : $F("hidBranchLoc"),
									appDate : $F("hidAppDate"),
									guardian : $F("hidGuardian"),
									complainant : $F("hidComplainant"),
									versus : $F("hidVersus"),
									section : $F("hidSection"),
									rule : $F("hidRule"),
									signAJCL5	:   escapeHTML2($F("hidSignAJCL5")),
									signBJCL5	:	escapeHTML2($F("hidSignBJCL5")),
									signatory : $F("hidSignatory")
									},
				    title: "Additional Information",
				    height: height,
				    width: width,
				    draggable: true
				}); 
			}
		} catch(e){
			showErrorMessage("showSUAdditionalInfo", e);
		}
	}
	
	$("btnAddtlInfoSU").observe("click", showSUAdditionalInfo);

	function showEnterCOCOverlay() {
		overlayPolicyNumber = Overlay.show(contextPath+"/GIPIVehicleController", {
			urlContent: true,
			urlParameters: {
							action 	: 	"loadCOCOverlay",
							policyId :  $F("policyId"),
							packPolFlag :  $F("packPolFlag"), // andrew - 12.11.2012
							page:		1,
							act:		"show"
						},
		    title: "Enter COC Number",
		    height: 370,
		    width: 700,
		    draggable: true,
		    showNotice: true, //marco - 06.25.2013
		    noticeMessage: "Getting list, please wait..."
		});
	}
	
	//marco - 04.23.2013 - for binder printing
	function printBinderReport(reportId, lineCd, binderYy, binderSeqNo, fnlBinderId, noOfCopies, printerName, destination){
		try{
			var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiBinderReport&reportId="+reportId+
		      			  "&lineCd="+lineCd+"&binderYy="+binderYy+"&binderSeqNo="+binderSeqNo+
			  			  "&noOfCopies="+noOfCopies+"&printerName="+printerName+"&destination="+destination;
			
			if("SCREEN" == destination){						
				window.open(content, '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
			
				hideNotice("");
				if (!(Object.isUndefined($("reportGeneratorMainDiv")))){
					hideOverlay();
				}
			}else{
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							//update giri_binder
							new Ajax.Request(contextPath+"/GIRIBinderController?action=updateBinderPrintDateCnt&fnlBinderId="+fnlBinderId, {
								method: "GET",
								evalScripts: true,
								asynchronous: true
							});
						}
					}
				});
				if(!(Object.isUndefined($("reportGeneratorMainDiv")))){
					hideOverlay();
				}
			}
			
			//update giri_binder
			/* if(nvl(printerName, "") != "---"){
				new Ajax.Request(contextPath+"/GIRIBinderController?action=updateBinderPrintDateCnt&fnlBinderId="+fnlBinderId, {
					method: "GET",
					evalScripts: true,
					asynchronous: true
				});
			} */
		}catch (e){
			showErrorMessage("printBinderReport", e);
		}
	}

	$("btnCancel").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
/*	function preparePrintAddtlInfoSU() {
		try {
			var sublineCd = $F("sublineCd");
			var obj = new Object();
			obj.period = $F("hidPeriod") == "" ? "" : escapeHTML2($F("hidPeriod"));
			obj.signA = $F("hidSignA") == "" ? "" : escapeHTML2($F("hidSignA"));
			obj.signB = $F("hidSignB") == "" ? "" : escapeHTML2($F("hidSignB"));
			obj.ackLoc = $F("hidAckLoc") == "" ? "" : changeSingleAndDoubleQuotes2($F("hidAckLoc"));
			obj.ackDate = $F("hidAckDate") == "" ? "" : $F("hidAckDate");
			obj.docNo = $F("docNo") == "" ? "" : $F("docNo");
			obj.pageNo = $F("hidPageNo") == "" ? "" : $F("hidPageNo");
			obj.bookNo = $F("hidBookNo") == "" ? "" : $F("hidBookNo");
			obj.series = $F("hidSeries") == "" ? "" : $F("hidSeries");

			if(sublineCd == "G28" || sublineCd == "G(28)") {
				//
			}

			return obj;
		} catch(e) {
			showErrorMessage("preparePrintAddtlInfoSU", e);
		}
	}*/

	if ($F("printOrderHidden") == "1") { // added by irwin
		if ($F("packPol") == "1") {
			setModuleId("GIPIS090A");
		}else{
			setModuleId("GIPIS090");
		}
	}else{
	
		setModuleId("GIPIS091");
		objUWGlobal.menuLineCd = null; //added by jeffdojello 06.06.2013
	}
	
	

</script>