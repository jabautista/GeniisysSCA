<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left; display: none;" id="printDialogFormDiv3"></div>
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
						<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> --> <!-- Dren 03.03.2016 Removed Excel radio button. To be applied to all Modules. -->
						<div id="csvOptionDiv" style="display: none;">
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
						</div>
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
					<!-- <input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma"> -->
					<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" lastValidValue="">
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
	<!-- do not delete this printDialogFormDiv2 --><div class="sectionDiv" style="float: left; display: none;" id="printDialogFormDiv2"></div>
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
				//$("rdoExcel").enable(); //Dren 03.03.2016 Removed Excel radio button
				$("rdoCsv").disable();
			}
		} else {
			if('${showFileOption}' == 'true'){ //condition added by: Nica 04.22.2013 - to prevent javascript error
				if(dest == "file"){
					$("rdoPdf").enable();
					//$("rdoExcel").enable(); //Dren 03.03.2016 Removed Excel radio button
					$("rdoCsv").enable();
				} else {
					$("rdoPdf").disable();
					//$("rdoExcel").enable(); //Dren 03.03.2016 Removed Excel radio button
					$("rdoCsv").disable();
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

	$("btnPrintCancel").observe("click", function(){
		overlayGenericPrintDialog.onCancel();
		overlayGenericPrintDialog.close();
	});
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){ //condition added for maximum no. of print copies john dolon 10.3.2013
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
	
	// bonok :: 02.13.2014
	$("txtNoOfCopies").observe("focus", function(){
		$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
	});
	
	//condition added for maximum no. of print copies john dolon 10.3.2013
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue"); // bonok :: 02.13.2014
			});			
		}
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	$("btnPrint").observe("click", function(){
		var dest = $F("selDestination");
		objGIACS070.dest = dest;	//added by shan 01.17.2014
		//if(dest == "printer" && checkAllRequiredFieldsInDiv("printDialogFormDiv")){
		//marco - 12.05.2012 - modified condition to prevent execution of else block when checkAllRequiredFieldsInDiv returns false
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				overlayGenericPrintDialog.onPrint();
			}
		}else{
			overlayGenericPrintDialog.onPrint();
		}	
	});
	
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
	
	//yosh
	var csvFileType;
	if($("rdoCsv") != null){
		$("rdoCsv").observe("click", function(){
			csvFileType = "CSV";
		});
	}		
	
	toggleRequiredFields("screen");
	overlayGenericPrintDialog.onLoad != null ? overlayGenericPrintDialog.onLoad() :null;	
</script>
