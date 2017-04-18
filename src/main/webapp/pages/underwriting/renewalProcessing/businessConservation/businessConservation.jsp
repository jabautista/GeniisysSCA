<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="busConservationMainDiv" name="busConservationMainDiv" style="margin-top: 1px; display: none;">
	<div id="busConservation">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit" name="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<form id="busConservationForm" name="busConservationForm">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Business Conservation</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="groDiv" name="groDiv">
		<input type="hidden">
		<div id="extractByDateDiv" name="extractByDateDiv" class="sectionDiv" style="width: 65%; height: 217px; margin-right: 1px;"> <!-- changed height to 215px to align reportsDiv section jmm -->
			<div id="sortByDiv" name="sortByDiv" style="display: block; float: left; margin-left: 75px; margin-top: 15px; margin-bottom: 10px;">
				<table>
					<tr>
						<td style="text-align: right;" colspan="4">
							<input title="By Month/Year" type="radio" id="byMonthYear" name="sortBy" value="byMonth" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label for="byMonthYear">By Month/Year</label>
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"><td>
						<td style="text-align: right;">From:</td>
						<td>
							<select id="fromMonth" name="fromMonth" style="width: 100px;">
								<option value=""></option>
								<option value="JAN">January</option>
								<option value="FEB">February</option>
								<option value="MAR">March</option>
								<option value="APR">April</option>
								<option value="MAY">May</option>
								<option value="JUN">June</option>
								<option value="JUL">July</option>
								<option value="AUG">August</option>
								<option value="SEP">September</option>
								<option value="OCT">October</option>
								<option value="NOV">November</option>
								<option value="DEC">December</option>
							</select>
						</td>
						<td>
							<input id="fromYear" name="fromYear" type="text" style="width: 30px; margin-bottom: 4px;">
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"><td>
						<td style="text-align: right;">To:</td>
						<td>
							<select id="toMonth" name="toMonth" style="width: 100px;">
								<option value=""></option>
								<option value="JAN">January</option>
								<option value="FEB">February</option>
								<option value="MAR">March</option>
								<option value="APR">April</option>
								<option value="MAY">May</option>
								<option value="JUN">June</option>
								<option value="JUL">July</option>
								<option value="AUG">August</option>
								<option value="SEP">September</option>
								<option value="OCT">October</option>
								<option value="NOV">November</option>
								<option value="DEC">December</option>
							</select>
						</td>
						<td>
							<input id="toYear" name="toYear" type="text" style="width: 30px; margin-bottom: 4px;">
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td style="text-align: right;" colspan="3">
							<input title="By Date" type="radio" id="byDate" name="sortBy" value="byDate" style="margin: 0 5px 0 5px; float: left;"><label for="byDate">By Date</label>
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"></td>
						<td style="text-align: right; padding-left: 5px;">From:</td>
						<td>
							<div style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none; height: 13px;" name="fromDate" id="fromDate" readonly="readonly" disabled="disabled" />
								<img id="imgFmDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fromDate'),this, null);"/>						
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"></td>
						<td style="text-align: right; padding-left: 5px;">To:</td>
						<td>
							<div style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none; height: 13px;" name="toDate" id="toDate" readonly="readonly" disabled="disabled" />
								<img id="imgToDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('toDate'),this, null);"/>						
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="listDiv" name="listDiv" style="float: left; width: 35%; height: 50%; padding-top: 40px; margin-left: 30px;">
				<table>
					<tr>
						<td>
							<input title="List of Expiring Policies" id="expiringPol" name="listPol" style="margin: 0 5px 5px 5px; float: left;" type="radio" value="E" checked="checked"><label for="expiringPol">List of Expiring Policies</label>
						</td>
					</tr>
					<tr>
						<td>
							<input title="List Of Unrenewed Policies" id="unrenewedPol" name="listPol" type="radio" value="U" style="margin: 0 5px 0 5px; float: left;"><label for="unrenewedPol">List of Unrenewed Policies</label>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="dataDiv" name="dataDiv" style="float: left; width: 317px; height: 71px;" class="sectionDiv">
			<table>
				<tr>
					<td colspan="2"><label style="padding-left: 4px; padding-top: 2px;">Data</label></td>
				</tr>
				<tr>
					<td style="width: 25px;"></td>
					<td>
						<input title="Policy Count" type="radio" id="policyCount" name="data" value="pc" style="margin: 0 5px 5px 5px; float: left;" checked="checked"><label for="policyCount">Policy Count</label>
					</td>
				</tr>
				<tr>
					<td style="width: 25px;"></td>
					<td>
						<input title="Premium" type="radio" id="premium" name="data" value="pa" style="margin: 0 5px 0 5px; float: left;"><label for="premium">Premium</label>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="float: left; width: 317px; height: 143px;" id="printDialogFormDiv"> <!-- changed height to 141px to align this div -->
			<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px;">Reports</label>
			<table align="center" style="padding: 10px; padding-top: 0px;">
				<tr>
					<td colspan="2" style="padding-left: 18px;">
						<input title="Summary" type="radio" id="summary" name="reports" value="summary" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label for="summary">Summary</label>
						<input title="Detail" type="radio" id="detail" name="reports" value="detail" style="margin: 0 5px 0 25px; float: left;" enabled="enabled"><label for="detail">Detail</label> <!-- Enabled by Jerome Bautista 07.02.2015 SR 3399 -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 200px;">
							<option value="SCREEN">Screen</option>
							<option value="PRINTER">Printer</option>
							<option value="FILE">File</option>
							<option value="LOCAL">Local Printer</option>
							<option value=""></option>
						</select>
					</td>
				</tr>
				
				<tr><!-- start: added by kevin 4-6-2016 SR-5498 -->
					<td></td>
					<td>
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
					</td>
				</tr> <!-- end: added by kevin 4-6-2016 SR-5498 -->

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
		</div>
		<div id="extractByLineDiv" name="extractByLineDiv" class="sectionDiv">
			<div id="sortByLineDiv" name="sortByLineDiv" style="padding-left: 200px; padding-top: 10px; padding-bottom: 10px;">
				<table>
					<tr>
						<td class="rightAligned" style="width: 110px;">Line</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="lineLOV" name="lineLOV" type="text" readonly="readonly" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="ALL">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;"/>
							</span>
						</td><td>
							<input id="lineName" name="lineName" type="text" style="width: 225px; height: 14px; margin-bottom: 4px;" readonly="readonly" value="ALL LINES">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 110px;">Subline</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="sublineLOV" name="sublineLOV" type="text" readonly="readonly" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="ALL">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td>
							<input id="sublineName" name="sublineName" type="text" style="width: 225px; height: 14px; margin-bottom: 4px;" readonly="readonly" value="ALL SUBLINES">
						</td>
					</tr>
					<tr>
						<td class="rightAligned "style="width: 110px;">Issue Source</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="issueLOV" name="issueLOV" type="text" readonly="readonly" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="ALL">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssueLOV" name="searchIssueLOV" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td>
							<input id="issueName" name="issueName" type="text" style="width: 225px; height: 14px; margin-bottom: 4px;" readonly="readonly" value="ALL ISSUE SOURCES">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 110px;">Crediting Branch</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="creditingLOV" name="creditingLOV" type="text" readonly="readonly" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="ALL">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCreditingLOV" name="searchCreditingLOV" alt="Go" style="float: right;"/>
							</span>
						</td><td>
							<input id="creditingName" name="creditingName" type="text" style="width: 225px; height: 14px; margin-bottom: 4px;" readonly="readonly" value="ALL CREDITING BRANCH">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 110px;">Intermediary Type</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="intmTypeLOV" name="intmTypeLOV" type="text" readonly="readonly" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="ALL">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmTypeLOV" name="searchIntmTypeLOV" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td>
							<input id="intmTypeName" name="intmTypeName" type="text" style="width: 225px; height: 14px; margin-bottom: 4px;" readonly="readonly" value="ALL INTM TYPE">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 110px;">Intermediary</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="intmLOV" name="intmLOV" type="text" readonly="readonly" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="ALL">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmLOV" name="searchIntmLOV" alt="Go" style="float: right;"/>
							</span>
						</td><td>
							<input id="intmName" name="intmName" type="text" style="width: 225px; height: 14px; margin-bottom: 4px;" readonly="readonly" value="ALL INTERMEDIARIES">
						</td>
					</tr>
					<tr style="text-align: center;">
						<td></td>
						<td style="text-align: right;">
							<input id="incPack" name="incPack" type="checkbox" checked="checked" disabled="disabled">
						</td>
						<td><label>Include Package</label></td>
					<tr>
				</table>
			</div>
		</div>
		</div>
		<div id="busConservationButtonsDiv" name="busConservationButtonsDiv" class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" style="width: 90px;" id="btnExtract" name="btnExtract" value="Extract">
						<input type="button" class="button" style="width: 90px;" id="btnPrint" name="btnPrint" value="Print">
						<input type="button" class="button" style="width: 90px;" id="btnViewDetails" name="btnViewDetails" value="View Details">
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setDocumentTitle("Business Conservation");
	setModuleId("GIEXS009");
	
	$("fromDate").disable();
	$("toDate").disable();
	$("imgFmDate").hide();
	$("imgToDate").hide();
	$("toDate").setStyle('width : 134px');
	$("fromDate").setStyle('width : 134px');
	
	var startingDate = null;
	var endingDate = null;
	var lastFromDate = null;
	var lastToDate = null;
	var origin = null;
	var extractChangeTag = 1;
	changeTag = 0;

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
			$("rdoPdf").disable(); /* start: added by Kevin 4-6-2016 SR-5498 */
			$("rdoCsv").disable(); /* end SR-5498 */
		} else {
			if(dest == "FILE"){ /* start: added by Kevin 4-6-2016 SR-5498 */
				$("rdoPdf").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoCsv").disable();
			}					/* end SR-5498 */
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
	
	observeReloadForm("reloadForm", showBusinessConservationPage);
	toggleRequiredFields("SCREEN");
	
	$("byDate").observe("click", function(){
		$("fromDate").enable();
 		$("toDate").enable();
 		$("fromMonth").disable();
 		$("toMonth").disable();
 		$("fromYear").disable();
 		$("toYear").disable();
 		$("toDate").setStyle('width : 111px');
 		$("fromDate").setStyle('width : 111px');
 		$("imgFmDate").show();
 		$("imgToDate").show();
	});
	
	$("byMonthYear").observe("click", function(){
		$("fromDate").disable();
 		$("toDate").disable();
 		$("fromMonth").enable();
 		$("toMonth").enable();
 		$("fromYear").enable();
 		$("toYear").enable();
 		$("toDate").setStyle('width : 134px');
 		$("fromDate").setStyle('width : 134px');
 		$("imgFmDate").hide();
 		$("imgToDate").hide();
	});
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("searchLineLOV").observe("click",function(){
		showBusConservationLOV();
	});
	
	$("searchSublineLOV").observe("click",function(){
		showBusSublineLOV($("lineLOV").value);
	});
	
	$("searchIssueLOV").observe("click",function(){
		showBusIssueLOV();
	});
	
	$("searchCreditingLOV").observe("click",function(){
		showBusCreditLOV();
	});
	
	$("searchIntmTypeLOV").observe("click",function(){
		showBusIntmTypeLOV();
	});
	
	$("searchIntmLOV").observe("click",function(){
		showBusIntmLOV($("intmTypeLOV").value);
	});
	
	$("btnExtract").observe("click",function(){
		var byMonthYear = $("byMonthYear").checked;
		var incPack = $("incPack").checked;
		checkRequiredDates(byMonthYear, incPack);
	});
	
	$("btnPrint").observe("click",function(){
		var fromDate;
		var toDate;
		
		if($("byMonthYear").checked){
			fromDate = "01-" + $F("fromMonth") + "-" + $("fromYear").value;
			toDate = "01-" + $F("toMonth") + "-" + $("toYear").value;
		}else{
			fromDate = $("fromDate").value;
			toDate = $("toDate").value;
		}
		
		if(lastFromDate != fromDate || lastToDate != toDate){
			showMessageBox("Please extract before printing.", imgMessage.INFO);
		}else{
			if(validatePrint()){
				if($("unrenewedPol").checked && $("summary").checked){
					printUnrenewedSummary();	
				}else if($("unrenewedPol").checked && $("detail").checked){
					printUnrenewedDetail();
				}else if($("summary").checked == true && $("policyCount").checked == true && $("expiringPol").checked == true){
					var lineCd = $("lineLOV").value=="ALL" ? "" : $("lineLOV").value;
					var issCd = $("issueLOV").value=="ALL" ? "" : $("issueLOV").value;
					var sublineCd = $("sublineLOV").value=="ALL" ? "" : $("sublineLOV").value;;
					var fromDate;
					var toDate;	
					if($("byMonthYear").checked){
						fromDate = dateFormat($("fromMonth").value + " " + $("fromYear").value, "mmmm yyyy");
						toDate = dateFormat($("toMonth").value + " " + $("toYear").value, "mmmm yyyy");
					}else{
						fromDate = dateFormat($("fromDate").value, "mmmm dd, yyyy");
						toDate = dateFormat($("toDate").value, "mmmm dd, yyyy");
					}
					printPolicyCount(issCd,lineCd,sublineCd,fromDate,toDate);
				}else if($("summary").checked == true && $("premium").checked == true && $("expiringPol").checked == true){
					var lineCd = $("lineLOV").value=="ALL" ? "" : $("lineLOV").value;
					var issCd = $("issueLOV").value=="ALL" ? "" : $("issueLOV").value;
					var fromDate;
					var toDate;	
					if($("byMonthYear").checked){
						fromDate = dateFormat($("fromMonth").value + " " + $("fromYear").value, "mmmm yyyy");
						toDate = dateFormat($("toMonth").value + " " + $("toYear").value, "mmmm yyyy");
					}else{
						fromDate = dateFormat($("fromDate").value, "mmmm dd, yyyy");
						toDate = dateFormat($("toDate").value, "mmmm dd, yyyy");
					}
					printPremium(issCd,lineCd,fromDate,toDate);
				}else if($("expiringPol").checked && $("detail").checked && ($("policyCount").checked || $("premium").checked)){ //Added by Jerome Bautista SR 3399 07.03.2015
					if($("byMonthYear").checked){
						fromDate = dateFormat("01-" + $F("fromMonth") + "-" + $("fromYear").value, "mm-dd-yyyy");
						toDate = dateFormat("01-" + $F("toMonth") + "-" + $("toYear").value, "mm-dd-yyyy");
					}else{
						fromDate = dateFormat($("fromDate").value, "mm-dd-yyyy");
						toDate = dateFormat($("toDate").value, "mm-dd-yyyy");
					}
					printExpiringDetail(fromDate, toDate);
				}
			}
		}
	});

	function validatePrint(){
		var result = true;
		if(($("selPrinter").selectedIndex == 0) && ($("selDestination").value == "PRINTER")){
			result = false;
			$("selPrinter").focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		}else if(($("txtNoOfCopies").value == "") && ($("selDestination").value == "PRINTER")){
			result = false;
			$("txtNoOfCopies").focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		}
		return result;
	}
	
	$("txtNoOfCopies").observe("blur", function() {
		var nCopy = parseInt($F("txtNoOfCopies"));
		if(isNaN(parseInt($F("txtNoOfCopies")))) {
			showMessageBox("Legal characters are 0 - 9 + E.");
			$("txtNoOfCopies").value = "";
			return false;
		} else if(nCopy > 999 || nCopy < 1) {
			showMessageBox("Must be in range 1 to 999.");
			$("txtNoOfCopies").value = "";
			return false;
		}
	});
	
	function printPolicyCount(issCd,lineCd,sublineCd,fromDate,toDate){
		
		var reportId; // John Michael Mabini SR 5497 04/06/2016
		if($F("selDestination") == "FILE"){
			if($("rdoPdf").checked){
				reportId = "GIEXR109_MAIN";
			}else{
				reportId = "GIEXR109_MAIN_CSV";
			}
			
		}else{
			reportId = "GIEXR109_MAIN";
		}		
		
		if(getPrintParams() == true){
			var content = contextPath+"/GIEXBusinessConservationPrintController?action=printBusinessConservationReport&issCd="+issCd
					+"&lineCd="+lineCd+"&sublineCd="+sublineCd+"&fromDate="+fromDate+"&toDate="+toDate+"&report="+reportId // John Michael Mabini SR 5497 04/06/2016
					+"&printerName="+$("selPrinter").value+"&filename=BUSINESS_CONSERVATION_SUMMARY_POLICY";
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "BUSINESS CONSERVATION RATIO - Policy Count");
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
				         		 printerName : $("selPrinter").value
				         		 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){

						}
					}
				});
			}else if("FILE" == $F("selDestination")){				
				var fileType = "PDF"; //John Michael Mabini SR 5497 04/06/2016 - Start
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV2";			
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
								  fileType: fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(fileType == "CSV2")
							copyFileToLocal(response, "csv");
						else
							copyFileToLocal(response); //John Michael Mabini SR 5497 04/06/2016 - End
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
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		}
	}
	
	function printExpiringDetail(fromDate, toDate){ //Added by Jerome Bautista SR 3399 07.03.2015
		if(getPrintParams() == true){
			var content = contextPath+"/GIEXBusinessConservationPrintController?action=printBusinessConservationReport&fromDate="+fromDate
					+"&toDate="+toDate+"&issCd=&credCd=&intmNo=&lineCd=&report=GIEXR108"+"&printerName="+$("selPrinter").value
					+"&filename=BUSINESS_CONSERVATION_DETAIL";
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "BUSINESS CONSERVATION DETAIL");
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
				         		 printerName : $("selPrinter").value
				         		 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){

						}
					}
				});
			}else if("FILE" == $F("selDestination")){
				var fileType = "PDF"; /* added by Kevin 4-6-2016 SR-5491 */
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV";				
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
					           	  fileType    : fileType}, /* added by Kevin 4-6-2016 SR-5491 */
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (fileType == "CSV"){ 
							copyFileToLocal(response, "csv");
						} else 
							copyFileToLocal(response); /* added by Kevin 4-6-2016 SR-5491 */
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
		}
	}
	
	function printPremium(issCd,lineCd,fromDate,toDate){
		if(getPrintParams() == true){
			
			var reportId; //Dren Niebres SR-5493 05.30.2016
			
			/* if($("summary").checked && $("premium").checked && $F("selDestination") == "FILE" && $("rdoCsv").checked) { //Dren Niebres SR-5493 05.30.2016 - Start */
			if($F("selDestination") == "FILE" && $("rdoCsv").checked) { //Dren Niebres SR-5493 05.30.2016 - Start
				reportId = "GIEXR110_MAIN_CSV";	
			} else {
				reportId = "GIEXR110_MAIN";
			} //Dren Niebres SR-5493 05.30.2016 - End				
			
			var content = contextPath+"/GIEXBusinessConservationPrintController?action=printBusinessConservationReport&issCd="+issCd
					+"&lineCd="+lineCd+"&fromDate="+fromDate+"&toDate="+toDate+"&report="+reportId+"&printerName="+$("selPrinter").value //Dren Niebres SR-5493 05.30.2016
					+"&filename=BUSINESS_CONSERVATION_SUMMARY_PREMIUM";
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "BUSINESS CONSERVATION RATIO - Premium");
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
				         		 printerName : $("selPrinter").value
				         		 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){

						}
					}
				});
			}else if("FILE" == $F("selDestination")){
				
				var fileType = "PDF"; //Dren Niebres SR-5493 05.30.2016 - Start
				
				if ($("rdoPdf").checked)
					fileType = "PDF";
				else
					fileType = "CSV2"; 	
				
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
							if (fileType == "CSV2"){ 
								copyFileToLocal(response, "csv");
							} else 
								copyFileToLocal(response);
						} //Dren Niebres SR-5493 05.30.2016 - End
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
		}
	}
	
	function printUnrenewedSummary(){
		try {
			var reportId; // SR-5498 5-02-2016
			
			if($F("selDestination") == "FILE") { // start: SR-5498 5-02-2016
				if ($("rdoPdf").checked){
					reportId = "GIEXR111_MAIN";
				}
				else {
					reportId = "GIEXR111_MAIN_CSV";
				}
			} else {
				reportId = "GIEXR111_MAIN";
			} // end: SR-5498 5-02-2016
			
			var content = contextPath+"/GIEXBusinessConservationPrintController?action=printBusinessConservationReport&fromDate="
					+"&toDate=&lineCd=&issCd=&noOfCopies="+$("txtNoOfCopies").value+"&printerName="+$("selPrinter").value
					+"&report="+reportId+"&filename=LIST_OF_UNRENEWED_POLICIES(SUMMARY)";
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "Unrenewed Policies - Summarized");
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
				         		 printerName : $("selPrinter").value
				         		 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){

						}
					}
				});
			}else if("FILE" == $F("selDestination")){
				var fileType = "PDF"; /* start: added by Kevin 4-6-2016 SR-5498 */
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV2"; /* end: added by Kevin 4-6-2016 SR-5498 */
					
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
								  fileType    : fileType}, /* fileType added by Kevin 4-6-2016 SR-5498 */	
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (fileType == "CSV2"){ // end: SR-5498 5-02-2016
							copyFileToLocal(response, "csv");
						} else 
							copyFileToLocal(response);
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
		} catch(e){
			showErrorMessage("printUnrenewedSummary", e);
		}
	}
	
	function printUnrenewedDetail(){
		if(getPrintParams() == true){
			try {
				var content = contextPath+"/GIEXBusinessConservationPrintController?action=printBusinessConservationReport&fromDate="+startingDate
						+"&toDate="+endingDate+"&issCd=&lineCd=&sublineCd=&policyId=&issCd=&assdNo=&intmNo="+"&noOfCopies="+$("txtNoOfCopies").value
						+"&printerName="+$("selPrinter").value+"&origin="+origin+"&destination="+$F("selDestination")+"&report=GIEXR112_MAIN"
						+"&filename=LIST_OF_UNRENEWED_POLICIES(DETAIL)";
				
				if($F("selDestination") == "SCREEN"){
					showPdfReport(content, "Unrenewed Policies - Detailed");
				}else if($F("selDestination") == "PRINTER"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {noOfCopies : $F("txtNoOfCopies"),
					         		 printerName : $("selPrinter").value
					         		 },
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){

							}
						}
					});
				}else if("FILE" == $F("selDestination")){
					//START csv printing SR5499 hdrtagudin 04072016
					var fileType = "PDF";
					
					if($("rdoPdf").checked)
						fileType = "PDF";
					else if ($("rdoCsv").checked)
						fileType = "CSV";
					//END csv printing SR5499 hdrtagudin 04072016					
					new Ajax.Request(content, {
						method: "POST",
						parameters : {
						      destination : "FILE",
	       	      		   	  fileType    : fileType	//csv printing SR5499 hdrtagudin 04072016
						},
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								//START csv printing SR5499 hdrtagudin 04072016
								if ($("rdoCsv").checked){
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
								}else {
									copyFileToLocal(response);
								}
								//END csv printing SR5499 hdrtagudin 04072016
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
				showErrorMessage("printUnrenewedDetail", e);
			}
		}
	}
	
	function getPrintParams(){
		var byMonthYear = $("byMonthYear").checked;
		var fromMonth = "Y";
		var proceedPrint = false;
		origin = null;
		
		if(byMonthYear){
			fromMonth = "N";
			if($("fromMonth").value == '' || $("fromYear").value == ''){
				showMessageBox("Please enter a From Date.", imgMessage.ERROR);
			}else if($("toYear").value == '' || $("toYear").value == ''){
				showMessageBox("Please enter a To Date.", imgMessage.ERROR);
			}else{
				if($F("fromYear").length != 4 || isNaN($F("fromYear")) || $F("fromYear") <= 0){
					showMessageBox("Invalid Year.", imgMessage.ERROR);
					$("fromYear").value = "";
				}else if($F("toYear").length != 4 || isNaN($F("toYear")) || $F("toYear") <= 0){
					showMessageBox("Invalid Year.", imgMessage.ERROR);
					$("toYear").value = "";
				}else{
					proceedPrint = getPrintDates(byMonthYear, fromMonth);	
				}
			}
		}else{
			fromMonth = "N";
			if($("fromDate").value == ''){
				showMessageBox("Please enter a From Date.", imgMessage.ERROR);
			}else if($("toDate").value == ''){
				showMessageBox("Please enter a To Date.", imgMessage.ERROR);
			}else{
				proceedPrint = getPrintDates(byMonthYear, fromMonth);
			}
		}
		return proceedPrint;
	}
	
	function getPrintDates(byMonthYear, fromMonth){
		var fromDate;
		var toDate;
		var proceedPrint = false;
		if(byMonthYear){
			origin = "M";
			fromDate = "01-" + $F("fromMonth") + "-" + $("fromYear").value;
			toDate = "01-" + $F("toMonth") + "-" + $("toYear").value;
		}else{
			origin = "Y";
			fromDate = $("fromDate").value;
			toDate = $("toDate").value;
		}
		if(Date.parse(toDate) < Date.parse(fromDate)){
			showMessageBox("From Date must not be greater than To Date.", imgMessage.ERROR);
		}else{
			if(fromMonth == "Y"){
				if(months_between() >= 12){
					showMessageBox("Date must be within one year.", imgMessage.ERROR);
				}else{
					startingDate = fromDate;
					endingDate = toDate;
					proceedPrint = true;
				}
			}else{
				if((Date.parse(toDate)-Date.parse(fromDate)) >= 31536000000){
					showMessageBox("Date must be within one year.", imgMessage.ERROR);
				}else{
					startingDate = fromDate;
					endingDate = toDate;
					proceedPrint = true;
				}
			}
		}
		return proceedPrint;
	}
	
	$("btnViewDetails").observe("click",function(){
		getBusConservationDetails();
	});
	
	function showBusConservationLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getBusConservationLOV"
							   },
				title: "Line",
				width: 405,
				height: 386,
				columnModel:[
				             	{
				             		id: "packPolFlag",
				             		title: "",
				             		width: "0px",
				             		visible: false
				             	},
				             	{	id : "lineCd",
									title: "Line Code",
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
						$("lineLOV").value = unescapeHTML2(row.lineCd);
						$("lineName").value = unescapeHTML2(row.lineName);
						$("sublineLOV").value = 'ALL';
						$("sublineName").value = 'ALL SUBLINES';
						
						if(row.lineCd == 'ALL'){
							$("incPack").checked = true;
							$("incPack").disabled = true;
						}else{
							if(row.packPolFlag == 'Y'){
								$("incPack").checked = true;
								$("incPack").disabled = true;
							}else{
								$("incPack").checked = true;
								$("incPack").disabled = false;
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("showBusConservationLOV",e);
		}
	}
	
	function showBusSublineLOV(mainLineCd){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getBusSublineLOV",
								mainLineCd: mainLineCd
							   },
				title: "Subline",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "sublineCd",
									title: "Subline Code",
									width: '80px'
								},
								{	id : "sublineName",
									title: "Subline Name",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("sublineLOV").value = unescapeHTML2(row.sublineCd);
						$("sublineName").value = unescapeHTML2(row.sublineName);
					}
				}
			});
		}catch(e){
			showErrorMessage("showBusSublineLOV",e);
		}
	}
	
	function showBusIssueLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getBusIssueLOV"
							   },
				title: "Issuing Source",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "issCd",
									title: "Issue Code",
									width: '80px'
								},
								{	id : "issName",
									title: "Issue Name",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("issueLOV").value = unescapeHTML2(row.issCd);
						$("issueName").value = unescapeHTML2(row.issName);
					}
				}
			});
		}catch(e){
			showErrorMessage("showBusIssueLOV",e);
		}
	}
	
	function showBusCreditLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getBusCreditLOV"
							   },
				title: "Crediting Branch",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "issCd",
									title: "Issue Code",
									width: '80px'
								},
								{	id : "issName",
									title: "Issue Name",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("creditingLOV").value = unescapeHTML2(row.issCd);
						$("creditingName").value = unescapeHTML2(row.issName);
					}
				}
			});
		}catch(e){
			showErrorMessage("showBusCreditLOV",e);
		}
	}
	
	function showBusIntmTypeLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getBusIntmTypeLOV"
							   },
				title: "Intermediary Type",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "intmType",
									title: "Intm. Type",
									width: '80px'
								},
								{	id : "intmDesc",
									title: "Description",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("intmTypeLOV").value = unescapeHTML2(row.intmType);
						$("intmTypeName").value = unescapeHTML2(row.intmDesc);
						$("intmLOV").value = 'ALL';
						$("intmName").value = 'ALL INTERMEDIARIES';
					}
				}
			});
		}catch(e){
			showErrorMessage("showBusCreditLOV",e);
		}
		
	}function showBusIntmLOV(intmMainType){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getBusIntmLOV",
								intmMainType: intmMainType
							   },
				title: "Intermediary",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "busIntmNo",
									title: "Intm. No",
									width: '80px',
									type: 'number'
								},
								{	id : "intmName",
									title: "Intm. Name",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("intmLOV").value = unescapeHTML2(row.busIntmNo);
						$("intmName").value = unescapeHTML2(row.intmName);
					}
				}
			});
		}catch(e){
			showErrorMessage("showBusCreditLOV",e);
		}
	}
	
	function getBusConservationDetails(){
		busConservationDetails = Overlay.show(contextPath+"/GIEXBusinessConservationController", {
			urlContent : true,
			draggable: true,
			showNotice : true,
			urlParameters: {action: "getBusConservationDetails"},
		    title: "Business Conservation Details",
		    height: 450,
		    width: 815
		});
	}
	
	function checkRequiredDates(byMonthYear, incPack){
		if(byMonthYear){
			if($("fromMonth").value == '' || $("fromYear").value == ''){
				showMessageBox("Please enter a From Date.", imgMessage.ERROR);
			}else if($("toYear").value == '' || $("toYear").value == ''){
				showMessageBox("Please enter a To Date.", imgMessage.ERROR);
			}else{
				if($F("fromYear").length != 4 || isNaN($F("fromYear")) || $F("fromYear") <= 0){
					showMessageBox("Invalid Year.", imgMessage.ERROR);
					$("fromYear").value = "";
				}else if($F("toYear").length != 4 || isNaN($F("toYear")) || $F("toYear") <= 0){
					showMessageBox("Invalid Year.", imgMessage.ERROR);
					$("toYear").value = "";
				}else{
					getRange(byMonthYear, incPack);	
				}
			}
		}else{
			if($("fromDate").value == ''){
				showMessageBox("Please enter a From Date.", imgMessage.ERROR);
			}else if($("toDate").value == ''){
				showMessageBox("Please enter a To Date.", imgMessage.ERROR);
			}else{
				getRange(byMonthYear, incPack);
			}
		}
	}
	
	function getRange(byMonthYear, incPack){ 	
		var fromDate;
		var toDate;
		var includePack;
		var fromMonth;
		if(byMonthYear){
			fromMonth = "Y";
			fromDate = "01-" + $F("fromMonth") + "-" + $("fromYear").value;
			toDate = "01-" + $F("toMonth") + "-" + $("toYear").value;
		}else{
			fromMonth = "N";
			fromDate = $("fromDate").value;
			toDate = $("toDate").value;
		}
		if(incPack){
			includePack = 'Y';
		}else{
			includePack = 'N';
		}
		if(Date.parse(toDate) < Date.parse(fromDate)){
			showMessageBox("From Date must not be greater than To Date.", imgMessage.ERROR);
		}else{
			if(fromMonth == "Y"){
				if(months_between() >= 12){
					showMessageBox("Date must be within one year.", imgMessage.ERROR);
				}else{
					extractPolicies(fromDate, toDate, includePack, fromMonth);
					lastFromDate = fromDate;
					lastToDate = toDate;
				}
			}else{
				if((Date.parse(toDate)-Date.parse(fromDate)) >= 31536000000){
					showMessageBox("Date must be within one year.", imgMessage.ERROR);
				}else{
					extractPolicies(fromDate, toDate, includePack, fromMonth);
					lastFromDate = fromDate;
					lastToDate = toDate;
				}
			}
		}	
	}
	
	function months_between(){
		var months = ($F("toYear") - $F("fromYear"))*12;
		var from;
		var to;
		
		if($F("fromMonth") == "JAN"){
			from = 1;
		}else if($F("fromMonth") == "FEB"){
			from = 2;
		}else if($F("fromMonth") == "MAR"){
			from = 3;
		}else if($F("fromMonth") == "APR"){
			from = 4;
		}else if($F("fromMonth") == "MAY"){
			from = 5;
		}else if($F("fromMonth") == "JUN"){
			from = 6;
		}else if($F("fromMonth") == "JUL"){
			from = 7;
		}else if($F("fromMonth") == "AUG"){
			from = 8;
		}else if($F("fromMonth") == "SEP"){
			from = 9;
		}else if($F("fromMonth") == "OCT"){
			from = 10;
		}else if($F("fromMonth") == "NOV"){
			from = 11;
		}else if($F("fromMonth") == "DEC"){
			from = 12;
		}
		
		if($F("toMonth") == "JAN"){
			to = 1;
		}else if($F("toMonth") == "FEB"){
			to = 2;
		}else if($F("toMonth") == "MAR"){
			to = 3;
		}else if($F("toMonth") == "APR"){
			to = 4;
		}else if($F("toMonth") == "MAY"){
			to = 5;
		}else if($F("toMonth") == "JUN"){
			to = 6;
		}else if($F("toMonth") == "JUL"){
			to = 7;
		}else if($F("toMonth") == "AUG"){
			to = 8;
		}else if($F("toMonth") == "SEP"){
			to = 9;
		}else if($F("toMonth") == "OCT"){
			to = 10;
		}else if($F("toMonth") == "NOV"){
			to = 11;
		}else if($F("toMonth") == "DEC"){
			to = 12;
		}
		
		months -= from;
		months += to;
		return months;
	}
	
	function extractPolicies(fromDate, toDate, includePack, fromMonth){
		new Ajax.Request(contextPath+"/GIEXBusinessConservationController", {
			method: "POST",
			parameters: {action: "extractPolicies",
					     lineCd: $("lineLOV").value,
					     sublineCd: $("sublineLOV").value,
					     issCd: $("issueLOV").value,
					     credCd: $("creditingLOV").value,
					     intmType: $("intmTypeLOV").value,
					     intmNo: $("intmLOV").value,
					     fromDate: fromDate,
					     toDate: toDate,
					     incPack: includePack,
					     fromMonth: fromMonth},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var result = JSON.parse(response.responseText);
					showMessageBox("Extraction Complete. " + result['msg'], "S"); //modified by Daniel Marasigan SR 22330
				}
			}
		});
	}
	
	$("expiringPol").observe("click", function(){
		$("summary").checked = true;
		$("detail").enable(); //Added by Jerome Bautista SR 3399 07.03.2015
		$("premium").enable();
		$("policyCount").enable();
	});
	
	$("unrenewedPol").observe("click", function(){
		$("policyCount").checked = true;
		$("detail").enable();
		$("premium").disable();
		$("policyCount").disable();
	});
</script>