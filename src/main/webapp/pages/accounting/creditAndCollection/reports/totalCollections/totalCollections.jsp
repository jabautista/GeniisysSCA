<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="totalCollectionsMainDiv" name="totalCollectionsMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul> 
				<li><a id="exitBtn">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Total Collections</label>
		</div>
	</div>
	
	<div id="totalCollectionsForm" name="totalCollectionsForm" class="sectionDiv" style="height: 425px; width:661px; padding-left: 130px; padding-right: 130px; padding-top: 55px;">
		<div class="sectionDiv" style="padding: 10px;">
			<div class="sectionDiv" style="padding: 25px; width:610px;">
				<table>
					<tr>
						<td class="rightAligned" style="width: 110px;">Collection Date</td>
						<td>
							<div id="fromDateDiv" class="required" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtCollFromDate" name="From Date." readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="101"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtCollFromDate'),this, null);" />
							</div>
						</td> 
						<td align="center" style="width: 100px;">To</td>
						<td>
							<div id="toDateDiv" class="required" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtCollToDate" name="To Date." readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="102"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtCollToDate'),this, null);" />
							</div>
						</td>
					</tr><tr id="hide">
						<td class="rightAligned">Production Date</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtProdFromDate" name="From Date." readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="103"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtProdFromDate'),this, null);" />
							</div>
						</td> 	
						<td align="center" style="width: 100px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtProdToDate" name="To Date." readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="104"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtProdToDate'),this, null);" />
							</div>
						</td>				
					</tr>
				</table>
				<table>
					<tr>
						<td class="rightAligned" style="width: 110px;">Official Receipt No</td>
						<td><input type="text" id="txtOrNo" maxlength="10" style="width: 180px; float: left; height: 14px; margin: 0;" class="rightAligned integerNoNegativeUnformattedNoComma" tabindex="105"/>  </td>
					</tr>
				</table>
				<table>
					<tr>
						<td class="rightAligned" style="width: 110px;">Intermediary</td>
						<td>
							<span class="lovSpan" style="width: 75px;">
								<input type="text" id="txtIntNo" maxlength="12" style="width: 50px; float: left; border: 1px; height: 14px; margin: 0;" class="integerNoNegativeUnformattedNoComma rightAligned" tabindex="106"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIntermediary" alt="Go" style="float: left;"/>
							</span>
						</td>
						<td>
							<input type="text" id="txtIntermediary" style="width: 386px; float: left;height: 14px; margin:0;" readonly="readonly"/>  
						</td>
					</tr><tr>
						<td class="rightAligned" style="width: 110px;">Assured</td>
						<td>
							<span class="lovSpan" style="width: 75px;">
								<input type="text" id="txtAssdNo" maxlength="12" style="width: 50px; float: left; border: 1px; height: 14px; margin: 0;" class="integerNoNegativeUnformattedNoComma rightAligned" tabindex="108"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchAssured" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td>
							<input type="text" id="txtAssured" style="width: 386px; float: left; margin: 0;height: 14px;" readonly="readonly"/>  
						</td>	
					</tr>
				</table>
			</div>
			<div>
				<div class="sectionDiv" id="rdoDiv" style="width: 162px; height:130px; margin-right: 5px; margin-top: 5px;">
					<table align = "center" style="padding: 10px; margin: 20px;">
						<tr>
							<td>
								<input type="radio" checked="checked" name="rdoBooked" id="rdoBooked" title="Booked" value="B" tabindex="201" style="float: left;"/>
							</td>	
							<td>
								<label for="rdoBooked" style="float: left;">&nbsp; Booked</label>
							</td>
						</tr>
						<tr></tr>
						<tr>
						<label>
							<td>
								<input type="radio" name="rdoBooked" id="rdoUnbooked" title="Unbooked" tabindex="202" value="U" style="float: left;"/>
							</td>
							<td>
								<label for="rdoUnbooked" style="float: left;">&nbsp; Unbooked</label>
							</td>
						</tr>
						</label>
						<tr></tr>
						<tr>
							<td>
								<input type="radio" name="rdoBooked" id="rdoAll" title="All" tabindex="203" value="A" style="float: left;"/>
							</td>
							<td>
								<label for="rdoAll" style="float: left;">&nbsp; All</label>
							</td>
						</tr>
					</table>
				</div>
				<div class="sectionDiv" id="printDiv" style="width: 490px; height:130px; margin-top: 5px;">
					<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
						<tr>
							<td style="text-align:right; width: 80px;">Destination</td>
							<td style="width: 150px;">
								<select id="selDestination" style="margin-left:5px; width:123px;" tabindex="301" >
									<option value="screen">Screen</option>
									<option value="printer">Printer</option>
									<option value="file">File</option>
									<option value="local">Local Printer</option>
								</select>
							</td>
						</tr>
						<tr id="trRdoFileType">
							<td style="width: 80px;">&nbsp;</td>
							<td style="width: 150px;">
								<table border="0">
									<tr>
										<td><input type="radio" style="margin-left:0px;" id="rdoPdf" name="rdoFileType" value="PDF" title="PDF" checked="checked" disabled="disabled" style="margin-left:10px;" tabindex="302"/></td>
										<td><label for="rdoPdf"> PDF</label></td>
										<td style="width:20px;">&nbsp;</td>
										<!-- modified by gab 06.29.2016 SR 22493 -->
										<!-- <td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" tabindex="303" /></td>
										<td><label for="rdoExcel"> Excel</label></td> -->
										<td><input type="radio" id="rdoCSV" name="rdoFileType" value="CSV" title="CSV" disabled="disabled" tabindex="303" /></td>
										<td><label for="rdoCSV"> CSV</label></td>
									</tr>									
								</table>
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">Printer Name</td>
							<td style="width: 123px">
								<select id="printerName" style="margin-left:5px; width:123px;" tabindex="304">
									<option></option>
										<c:forEach var="p" items="${printers}">
											<option value="${p.name}">${p.name}</option>
										</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">No. of Copies</td>
							<td style="width: 150px;">
								<input type="text" id="txtNoOfCopies" maxlength="3" style="margin-left:5px;float:left; text-align:right; width:100px;" class="integerNoNegativeUnformattedNoComma" tabindex="305">
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
			</div>
			<input id="btnPrint" type="button" class="button" value="Print" style="width: 120px; margin-top: 10px; margin-left: 280px; tabindex="221"/>
		</div>
	</div>
	
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setModuleId("GIACS148");
	setDocumentTitle("Total Collections");
	observeBackSpaceOnDate("txtCollFromDate");
	observeBackSpaceOnDate("txtCollToDate");
	observeBackSpaceOnDate("txtProdFromDate");
	observeBackSpaceOnDate("txtProdToDate");
	$("txtOrNo").focus();
	var objParam = new Object();
	
	$("exitBtn").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	function showIntermediaryLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action   : "getGiacIntmNameLOV",
					moduleId : "GIACS148",
					searchString : x,
						page : 1
				},
				title: "Search Intermediary",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'intmNo',
						title: 'Intermediary No.',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'intmName',
						title: 'Intermediary Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl(x, "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtIntNo").value = unescapeHTML2(row.intmNo);
						$("txtIntermediary").value = unescapeHTML2(row.intmName); 
						$("txtIntNo").setAttribute("lastValidValue", unescapeHTML2(row.intmNo));
						$("txtIntermediary").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
					}
				},
				onCancel: function(){
					$("txtIntNo").focus();
					$("txtIntermediary").clear();
					$("txtIntNo").value = $("txtIntNo").getAttribute("lastValidValue");
					$("txtIntermediary").value = $("txtIntermediary").getAttribute("lastValidValue");
		  		}
			});
		}catch(e){
			showErrorMessage("showIntermediaryLOV",e);
		}
	}
	
	$("imgSearchIntermediary").observe("click",function(){
		if(isNaN($("txtIntNo").value)){
			customShowMessageBox("Enter valid Intermediary No.", "I", "txtIntNo");
		}
		else {
			showIntermediaryLOV("");
		}
	});
	
	function showAssuredLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action   : "getGiacAssdNameLOV",
					moduleId : "GIACS148",
					assdNo   : x,
					//findText : $("txtAssdNo").value,
						page : 1
				},
				title: "Search Assured Name",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'assdNo',
						title: 'Assured No',
						width : '85px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'assuredName',
						title: 'Assured Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl(x, "%"), 
				draggable: true,
				autoSelectOneRecord : true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtAssdNo").value = unescapeHTML2(row.assdNo);
						$("txtAssured").value =  unescapeHTML2(row.assuredName); 
						$("txtAssdNo").setAttribute("lastValidValue", unescapeHTML2(row.assdNo));
						$("txtAssured").setAttribute("lastValidValue", unescapeHTML2(row.assuredName));
					}
				},
				onCancel: function(){
		  			$("txtAssdNo").focus();
		  			$("txtAssured").clear();
		  			$("txtAssdNo").value = $("txtAssdNo").getAttribute("lastValidValue");
					$("txtAssured").value = $("txtAssured").getAttribute("lastValidValue");
		  		}
			});
		}catch(e){
			showErrorMessage("showAssuredLOV",e);
		}
	}
	
	$("imgSearchAssured").observe("click",function(){
		if(isNaN($("txtAssdNo").value)){
			customShowMessageBox("Enter valid Assured No.", "I", "txtAssdNo");
		}
		else {
			showAssuredLOV("");
		}
	});
	
	

	//modified by gab 06.29.2016 SR 22493
	function togglePrintFields(destination) {
		if ($("selDestination").value == "printer") {
			$("printerName").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("printerName").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			//$("rdoExcel").disable();
			$("rdoCSV").disable();
		} else {
			if ($("selDestination").value == "file") {
				$("rdoPdf").enable();
				//$("rdoExcel").enable();
				$("rdoCSV").enable();
			} else {	
				$("rdoPdf").disable();
				//$("rdoExcel").disable();
				$("rdoCSV").disable();
			}
			$("printerName").value = "";
			$("txtNoOfCopies").value = "";
			$("printerName").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("printerName").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
		}
	}
	
	function validateCollFromAndTo(field) {
		var toDate = $F("txtCollToDate") != "" ? new Date($F("txtCollToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtCollFromDate") != "" ? new Date($F("txtCollFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			if (field == "txtCollFromDate") {
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtCollFromDate");
			} else {
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtCollToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	function validateProdFromAndTo(field) {
		var toDate = $F("txtProdToDate") != "" ? new Date($F("txtProdToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtProdFromDate") != "" ? new Date($F("txtProdFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			if (field == "txtProdFromDate") {
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtProdFromDate");
			} else {
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtProdToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	$("txtCollToDate").observe("focus", function() {
		validateCollFromAndTo("txtCollToDate");
	});
	
	$("txtCollFromDate").observe("focus", function() {
		validateCollFromAndTo("txtCollFromDate");
	});
	
	$("txtProdToDate").observe("focus", function() {
		validateProdFromAndTo("txtProdToDate");
	});
	
	$("txtProdFromDate").observe("focus", function() {
		validateProdFromAndTo("txtProdFromDate");
	});
	
	function checkRequiredPrintFields(){
		if($("selDestination").value == "printer" &&  $("printerName").value == "" ){
			customShowMessageBox("Required fields must be entered.", "I", "printerName");
			return false;
		}
		return true;
	}
	
	$("btnPrint").observe("click",function(){
		/*if(($("txtCollFromDate").value != "" && $("txtCollToDate").value != "" ) || ($("txtProdFromDate").value != "" && $("txtProdToDate").value != "")){
				if(checkRequiredPrintFields()){
					printReport();
				}
		} else{
			if($("txtCollFromDate").value != "" && $("txtCollToDate").value == "" || ($("txtProdFromDate").value != "" && $("txtProdToDate").value == "")){
				customShowMessageBox("Please Enter To Date.", "I", "txtCollToDate");
			} else {
				customShowMessageBox("Required fields must be entered.", "I", "txtCollFromDate");
			}
		}*/
		if (checkAllRequiredFieldsInDiv("totalCollectionsForm")){
			if ($("txtProdFromDate").value != "" && $("txtProdToDate").value == ""){
				customShowMessageBox("Please enter Production To Date.", "I", "txtCollToDate");
			}else if ($("txtProdFromDate").value == "" && $("txtProdToDate").value != ""){
				customShowMessageBox("Please enter Production From Date.", "I", "txtCollFromDate");
			}else{
				printReport();
			}
		}
	});
	
	togglePrintFields($("selDestination").value);
	
	$("selDestination").observe("change",function(){
		togglePrintFields($("selDestination").value);
	});
	
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
		}
	});

	$("imgSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no > 1) {
			$("txtNoOfCopies").value = no - 1;
		}
	});

	$("imgSpinUp").observe("mouseover", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgSpinDown").observe("mouseover", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	$("imgSpinUp").observe("mouseout", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});

	$("imgSpinDown").observe("mouseout", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("txtNoOfCopies").observe("change", function() {
		if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "1";
			});			
		}
	});
	
	$$("input[type='radio']").each(function(x) {
		x.observe("click",function(){
			if(($("rdoUnbooked").checked)){
				$("hide").hide();
				$("txtProdFromDate").clear(); 
				$("txtProdToDate").clear();
				$$("input[type='text']").each(function(x){
					$(x).clear();
				});
			}
			else{
				$("hide").show();
			}
		});
	});
	
	
	function getRdoValue(){
		var rdoValue = "";
		if($("rdoBooked").checked){
			rdoValue = "B";
		} else if($("rdoUnbooked").checked){
			rdoValue = "U";
		} else {
			rdoValue = "A";
		}
		return "&printCode="+rdoValue;
	}
	
	function getParams(){
		var params = "&collFromDate="+$F("txtCollFromDate")+
					 "&collToDate="+$F("txtCollToDate")+
					 "&prodFromDate="+$F("txtProdFromDate")+
					 "&prodToDate="+$F("txtProdToDate")+
					 "&orNo="+$F("txtOrNo")+
					 "&intmNo="+$F("txtIntNo")+
					 "&assdNo="+$F("txtAssdNo")+ getRdoValue();
		return params;
	}

	function printReport() {
		try {
			//added by gab 06.17.2016 SR 22493
			var reportParam = 'GIACR157';
			if ("file" == $F("selDestination")) {
				if($("rdoCSV").checked){
					if($("rdoBooked").checked){
						reportParam = 'GIACR157_BOOKED_CSV';
					} else if($("rdoUnbooked").checked){
						reportParam = 'GIACR157_UNBOOKED_CSV';
					} else {
						reportParam = 'GIACR157_ALL_CSV';
					}
				}
			}
			var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport" + "&reportId="+ reportParam + getParams();
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, "Total Collections");
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							
						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						//edited by gab 06.17.2016 SR 22493
						//fileType : $("rdoPdf").checked ? "PDF" : "XLS"
						fileType : $("rdoPdf").checked ? "PDF" : "CSV2"
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							//edited by gab 06.17.2016 SR 22493
							//copyFileToLocal(response);
							if (fileType = "CSV2"){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else{ 
								copyFileToLocal(response);
							}
						}
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "local"
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var message = printToLocalPrinter(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}
	
	$("txtIntNo").observe("change",function(){
		if($("txtIntNo").value == "" || $("txtIntNo").value == null){
			$("txtIntermediary").clear();
			$("txtIntNo").setAttribute("lastValidValue", "");
			$("txtIntermediary").setAttribute("lastValidValue", "");
		}
		else {
			showIntermediaryLOV($F("txtIntNo"));
		}
	});
	
	$("txtAssdNo").observe("change",function(){
		if($("txtAssdNo").value == "" || $("txtAssdNo").value == null){
			$("txtAssured").clear();
			$("txtAssdNo").setAttribute("lastValidValue", "");
			$("txtAssured").setAttribute("lastValidValue", "");
		}
		else {
			showAssuredLOV($F("txtAssdNo"));
		}
	});
	
</script>
