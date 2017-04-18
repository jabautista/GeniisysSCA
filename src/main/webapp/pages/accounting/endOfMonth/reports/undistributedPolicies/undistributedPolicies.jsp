<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="undistributedPoliciesMainDiv" name="undistributedPoliciesMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Undistributed Policies</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>

	<div id="undistribuedPoliciesDiv" name="undistribuedPoliciesDiv" class="sectionDiv">
		<div class="sectionDiv"  style="width: 565px; margin: 40px 138px 40px 175px; height: 258px;">
			<div class="sectionDiv" style="height: 30px; width: 454px; margin: 8px 8px 2px 8px; padding: 15px 0 15px 92px;">
				<table>
					<tr>
						<td>
							<label style="margin: 4px 5px 0 0;">Line</label>
							<span class="lovSpan" style="width: 70px;">
								<input id="lineCd" name="lineCd" type="text" class="upper" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="2" tabindex="101" ignoreDelKey="" lastValidValue=""/>
								<img id="searchLine" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td>
							<input id="lineName" name="lineName" type="text" class="upper" value="ALL LINES" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 245px;" maxlength="20" tabindex="102" readonly="readonly"/>
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="width: 192px; height: 95px; margin: 8px 4px 2px 8px; padding: 30px 0px 0px 15px;">
				<table align="left" style="margin: 3px;">
					<tr>
						<td>
							<div style="margin-bottom: 25px;">
								<input value="1" title="Undistributed Policies" type="radio" id="undistributed" name="undistributedRG" style="margin: 0 5px 0 5px; float: left;" checked="checked" tabindex="103">
								<label for="undistributed">Undistributed Policies</label>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<input value="2" title="Undistributed RI Policies" type="radio" id="undistributedRI" name="undistributedRG" style="margin: 0 5px 0 5px; float: left;">
							<label for="undistributedRI">Undistributed RI Policies</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printerDiv" class="sectionDiv" style="width: 309px; height: 115px; margin: 8px 8px 2px 4px; padding: 10px 0px 0px 20px;">
				<table>
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="104">
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
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 8px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="105">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="106">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 176px;" class="required integerNoNegativeUnformatted" maxlength="3" tabindex="107" lastValidValue="">
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
			
			<div id="buttonsDiv" align="center" style="float: left; margin: 10px 0 0 240px;">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 80px;" tabindex="108">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
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
			if(no < 100){
				$("txtNoOfCopies").value = no + 1;
			}
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
					action: "getGIACS102LineLOV",
					filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
					moduleId: "GIACS102"
				},
				title: "List of Lines",
				width: 375,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "120px",
								},
				             	{	id: "lineName",
									title: "Line Name",
									width: "240px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText:  $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
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
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("searchLine", e);
		}
	}
	
	function printUndistributedPolicies(){
		var reportId = "";
		var reportTitle = "";
		var fileType = $("pdfRB").checked ? "PDF" : "XLS";
		
		if($("undistributed").checked){
			reportId = "GIACR102";
			reportTitle = "LIST OF UNDISTRIBUTED POLICIES";
		}else{
			reportId = "GIACR103";
			reportTitle = "LIST OF UNDISTRIBUTED REINSURANCE POLICIES";
		}
		
		var content = contextPath+"/EndOfMonthPrintReportController?action=printReport&reportId="+reportId+
						"&reportTitle="+reportTitle+"&lineCd="+$F("lineCd")+"&noOfCopies="+$F("txtNoOfCopies")+
						"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+"&fileType="+fileType;
		printGenericReport(content, reportTitle);
	}
	
	function checkRequiredPrinterFields(){
		if($F("selDestination") == "printer"){
			if($F("selPrinter") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "selPrinter");
				return false;
			}else if($F("txtNoOfCopies") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtNoOfCopies");
				return false;
			}
		}
		return true;
	}
	
	function reloadGIACS102(){
		try {
			new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController", {
				parameters : {
					action : "showUndistributedPolicies"
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading, please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					$("mainContents").update(response.responseText);
					hideAccountingMainMenus();
					$("acExit").show();
				}
			});
		} catch (e) {
			showErrorMessage("reloadGIACS102", e);
		}
	}
	
	$("txtNoOfCopies").observe("focus", function(){
		$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
			});			
		}
	});
	
	$("lineCd").observe("change", function(){
		if($F("lineCd") == ""){
			$("lineCd").setAttribute("lastValidValue", "");
			$("lineName").value = "ALL LINES";
		}else{
			showLineLOV();
		}
	});
	
	$("searchLine").observe("click", function(){
		showLineLOV();
	});
	
	$("btnPrint").observe("click", function(){
		if(checkRequiredPrinterFields()){
			if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 999)){
				showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 999.", "E");
			}else{
				printUndistributedPolicies();
			}
		}
	});
	
	$("lineCd").focus();
	initializeAll();
	observePrintFields();
	makeInputFieldUpperCase();
	toggleRequiredFields("SCREEN");
	observeReloadForm("reloadForm", reloadGIACS102);
	setModuleId("GIACS102");
	setDocumentTitle("Undistributed Policies");
</script>