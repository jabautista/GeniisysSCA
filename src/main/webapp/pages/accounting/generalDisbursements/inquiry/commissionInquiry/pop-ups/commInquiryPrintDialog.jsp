<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv3">
		<table style="margin: 8px 0 8px 0;">
			<tr>
				<td><input type="radio" checked="checked" id="chkUnreleaseComm" name="byType" title="Unreleased Commissions" style="float: left; margin-bottom: 3px"/></td>
			    <td><label for="chkUnreleaseComm">Unreleased Commissions</label></td>
		        <td style="padding-left: 30px;"><input type="radio" id="chkNotStandardRt" name="byType" title="Not in standard rate" style="float: left; margin-bottom: 3px;"/></td>
		        <td><label for="chkNotStandardRt">Not in standard rate</label></td>
	        </tr>
        </table>
		<div id="buttonsDiv" style="float: left; width: 100%; margin-bottom: 10px;">
			<input type="button" class="button" id="btnParameters" name="btnParameters" value="Parameters" style="width: 100px;">
		</div>
	</div>
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
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
			<c:if test="${showFileOption eq 'true'}">
				<tr>
					<td></td>
					<td>
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<input value="CSV" title="Csv" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>  <!-- added csv option carlo de guzman 3.01.2016 -->
						<!-- removed print to excel option by robert SR 5019 02.22.16
						<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
					</td>
				</tr>
			</c:if>			
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
						<%-- <c:forEach var="p" items="${printers}">
							<option value="${p.printerNo}">${p.printerName}</option>
						</c:forEach> --%>
						<!-- installed printers muna gamitin - andrew - 02.27.2012 -->
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
	</div>
	<div class="sectionDiv" style="float: left; padding: 10px; width: 358px" id="printDialogFormDiv2">
		<input type="checkbox" id="chkUnpaidPrem" title="Include Unpaid Premium" style="float: left; margin-right: 5px;"/>
		<label for="chkUnpaidPrem">Include Unpaid Premium</label>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnPrintCancel" name="btnPrintCancel" value="Cancel">		
	</div>	
</div>
<script type="text/javascript">
	initializeAll();

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
			if('${showFileOption}' == 'true'){ //condition added by: Nica 04.22.2013 - to prevent javascript error
				$("rdoPdf").disable();
				//$("rdoExcel").disable();	removed print to excel option by robert SR 5019 02.22.16			
			}
		} else {
			if('${showFileOption}' == 'true'){ //condition added by: Nica 04.22.2013 - to prevent javascript error
				if(dest == "file"){
					$("rdoPdf").enable();
					$("rdoCsv").enable(); //added csv option carlo de guzman 3.01.2016
					//$("rdoExcel").enable(); removed print to excel option by robert SR 5019 02.22.16
				} else {
					$("rdoPdf").disable();
					$("rdoCsv").disable();  //added csv option carlo de guzman 3.01.2016
					//$("rdoExcel").disable(); removed print to excel option by robert SR 5019 02.22.16
				}				
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
	
	function printReport() {
		try {
			var repParams = null;
			var repTitle = null;
			var printPath = null; // added by carlo de guzman 3.02.2016			
			var obj = new Object();
			var unpaidPrem = $("chkUnpaidPrem").checked ? "Y" : "N";
			if ($("chkUnreleaseComm").checked) {
				obj = objACGlobal.hideGIACS221Obj.unreleaseComm;
				var vIntmNo = obj.intmNo == null || obj.intmNo == undefined ? "" : obj.intmNo //vondanix 10.05.2015 SR 5019
				repTitle = "UNRELEASED COMMISSIONS";
				repParams = "&reportId=GIACR221B"
						   +"&reportTitle=UNRELEASED COMMISSIONS"
						   +"&issCd="+obj.branchCd
						   +"&intmNo="+vIntmNo //vondanix 10.05.2015 SR 5019
						   +"&repGrp="+obj.branchType
						   +"&unpaidPrem="+unpaidPrem
						   +"&action=printGIACR221B";
			} else {
				obj = objACGlobal.hideGIACS221Obj.notStandardRt;
				if(nvl(obj.fromDate,'') == '' || nvl(obj.toDate,'') == ''){ //added by steven 11.10.2014
					customShowMessageBox(objCommonMessage.REQUIRED,'I','btnParameters');
					return;
				}
				repTitle = "COMMISSIONS NOT IN STANDARD RATE";
				repParams = "&reportId=GIACR259"
						   +"&reportTitle=COMMISSIONS NOT IN STANDARD RATE"
						   +"&branchCd="+obj.branchCd
						   +"&lineCd="+obj.lineCd
						   +"&intmCd="+obj.intmType
						   +"&intermediaryCd="+obj.intmNo
						   +"&branchParam="+obj.branchType
						   +"&dateParam="+obj.dateType
						   +"&fromDate="+obj.fromDate
						   +"&toDate="+obj.toDate
						   +"&action=printGIACR259";
			}
			var fileType = "PDF";
			if($("rdoPdf").checked){ // added by carlo de guzman 3.01.2016
				fileType = "PDF";
				}
			else if ($("rdoCsv").checked){
				fileType = "CSV";
			    printPath = "csv"; //added by carlo de guzman 3.02.2016
			}
			
			var content = contextPath+"/GeneralDisbursementPrintController?noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+repParams
						+"&fileType="+fileType
						+"&moduleId="+"GIACS221"; 
			printGenericReport(content, repTitle,null,printPath); // added params for csv printing carlo de guzman 3.01.2016
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function showUnreleaseCommOverlay(){
		unreleaseCommOverlay = Overlay.show(contextPath+"/GIACInquiryController", {
			urlContent : true,
			urlParameters: {action : "showUnreleaseCommOverlay"},
		    title: "Unreleased Commissions",
		    height: 185,  //vondanix 10.05.2015 replaced 160 SR 5019
		    width: 380 //vondanix 10.05.2015 replaced 350 SR 5019
		});
	}
	
	function showNotStandardRtOverlay(){
		notStandardRtOverlay = Overlay.show(contextPath+"/GIACInquiryController", {
			urlContent : true,
			urlParameters: {action : "showNotStandardRtOverlay"},
		    title: "Not In Standard Rate",
		    height: 400,
		    width: 420
		});
	}
	
	$("chkUnreleaseComm").observe("change", function(){
		if (this.checked) {
			$("chkUnpaidPrem").disabled = false;
		} else {
			$("chkUnpaidPrem").disabled = true;
		}
	});
	
	$("chkNotStandardRt").observe("change", function(){
		if (this.checked) {
			$("chkUnpaidPrem").disabled = true;
		} else {
			$("chkUnpaidPrem").disabled = false;
		}
	});
	
	$("btnPrintCancel").observe("click", function(){
		giacs221PrintDialogOverlay.close();
	});
	
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
	
	$("btnPrint").observe("click", function(){
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				printReport();
			}
		}else{
			printReport();
		}	
	});
	
	$("btnParameters").observe("click", function(){
		if ($("chkUnreleaseComm").checked) {
			showUnreleaseCommOverlay();
		} else {
			showNotStandardRtOverlay();
		}
	});
	
	toggleRequiredFields("screen");
</script>