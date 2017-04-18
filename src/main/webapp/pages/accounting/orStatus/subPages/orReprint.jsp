<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="reprintDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;">
		<table align="center" style="padding: 10px; padding-left: 35px;">
			<tr>
				<td class="rightAligned">OR No.</td>
				<td><input type="text" id="txtOrPref" name="txtOrPref" readonly="readonly" style="width: 53px;"/></td>
				<td><input type="text" id="txtOrPrefNo" name="txtOrPrefNo" readonly="readonly" style="width: 128px; text-align: right;"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="float: left;" id="reprintDialogFormDiv">
		<table id="reprintDialogMainTab" name="reprintDialogMainTab" align="center" style="padding: 10px;">
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
			<c:if test="${showFileOption eq 'true'}">
				<tr>
					<td></td>
					<td>
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
					</td>
				</tr>
			</c:if>
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
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
					</div>					
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="float: left; display: none;" id="reprintDialogFormDiv2"></div>
	<div id="reprintButtonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnReprint" name="btnReprint" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnReprintCancel" name="btnReprintCancel" value="Cancel">		
	</div>	
</div>

<script type="text/javascript">
	initializeAll();
	$("txtOrPref").value = $F("hidOrPref");
	$("txtOrPrefNo").value = $F("hidOrPrefNo");
	
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

	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){ //Kenneth 01.14.2014
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
	
	$("txtNoOfCopies").observe("change", function(){	//Kenneth 01.14.2014
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "";
			});			
		}
	});
	
	function reprintReport(){
		try {
			var content = contextPath + "/PrintGIACInquiryController?action=printReport"
							+"&reportId="+"GIACR050"
							+"&orPref="+$F("txtOrPref")
							+"&orNo="+$F("txtOrPrefNo")
							+"&tranId="+$F("hidTranId");
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Ordinary OR Printing");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : { noOfCopies : $F("txtNoOfCopies"),
								   printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");	//Kenneth 01.14.2014
						}
					}
				});
			}else if($F("selDestination") == "file"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if($F("selDestination") == "local"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "local"},
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
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	$("btnReprintCancel").observe("click", function(){
		overlayReprint.close();
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	$("btnReprint").observe("click", function(){
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("reprintDialogFormDiv")){
				overlayReprint.onPrint();
			}
		}else{
			overlayReprint.onPrint();
		}	
	});
	
	toggleRequiredFields("screen");
	overlayReprint.onLoad != null ? overlayReprint.onLoad() :null;	
	objPrintOr.reprintOr = reprintReport;
</script>