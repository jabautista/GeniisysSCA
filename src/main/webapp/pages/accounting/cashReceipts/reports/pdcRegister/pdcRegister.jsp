<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>


<div id="pdcRegisterMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="pdcRegisterExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Outstanding Post-Dated Checks</label>
		</div>
	</div>
	
	<div id="pdcRegisterFields" class="sectionDiv" style="width: 920px; height: 500px;">
		<div class="sectionDiv" style="width: 600px; height:400px; margin: 40px 20px 20px 150px;">
			<div id="dateCbDiv" class="sectionDiv" style="width: 515px; height: 20px; margin: 10px 10px 0 13px; padding: 20px 30px 20px 30px;"">
				<table align="center" style="height: 20px">
				<tr>
					<td>
						<div>
							<input id="chkRegister" type="checkbox" checked="checked" value="R" style="float: left;" tabindex="101">
							<label for="chkRegister" style="margin-left: 7px;" >PDC Register</label>
						</div>
					</td>
					<td>
						<div>
							<input id="chkOutstanding" type="checkbox" style="margin-left: 160px; float: left;" value="O" tabindex="102">
							<label for="chkOutstanding" style="margin-left: 7px;">Outstanding PDCs</label>
						</div>
					</td>
				</tr>
			</table>
			</div>
			
			<div id="fieldDiv" class="sectionDiv" style="width: 555px; height: 60px; margin: 2px 10px 0 13px; padding: 25px 10px 25px 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned" style="padding: 0 10px 0 10px;">As Of</td>
						<td>
							<div id="asOfDateDiv" class="required" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input id="txtAsOfDate" name="txtAsOfDate" readonly="readonly" type="text" class="required" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="103"/>
								<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>
						<td class="rightAligned" style="padding: 0 10px 0 60px;">Cut-Off Date</td>
						<td>
							<div id="cutOffDateDiv" class="required" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input id="txtCutOffDate" name="txtCutOffDate" readonly="readonly" type="text" class="required" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="104"/>
								<img id="imgCutOffDate" alt="imgCutOffDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtCutOffDate'),this, null);" />
							</div>
						</td>
					</tr>
				</table>
				<table align="center">
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Branch</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="branchDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="105">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<input id="txtBranchName" type="text" readonly="readonly" style="width: 345px;" tabindex="106">
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="width: 170px; height: 120px; margin: 2px 2px 10px 13px; padding: 15px 0 15px 0;">				
				<div style="margin: 50px 30px 50px 35px;">
					<input id="chkDetails" type="checkbox" value="O" style="float: left;" tabindex="107">
					<label style="margin-left: 7px;" >With Details</label>
				</div>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 370px; height: 120px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 7px 0 0 15px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="108">
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
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="109"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> commented out by CarloR SR-5519 06.28.2016-->
							<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label> <!-- Added by CarloR SR-5519 06.28.2016 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="111">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3" tabindex="112">
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
			
			<div id="buttonsDiv" class="buttonsDiv">
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 80px;" tabindex="113">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 80px;" tabindex="114">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS093");
	setDocumentTitle("Outstanding Post-Dated Checks");
	initializeAll();
	 
	var extractFlag = "FALSE";
	var beginExtract = null;
	var endExtract = null;
	var register = "R";
	var outstanding = "O";
	var details = "O";
	
	$("txtBranchName").value = "ALL BRANCHES";
	
	var prevExtAsOfDate = null;
	var prevExtCutOffDate = null;
	var prevExtBranchCd = null;
	var prevExtRegister = null;
	var prevExtOutstanding = null;
	
	if('${lastExtractParams.asOfDate}' != ""){
		$("txtAsOfDate").value = '${lastExtractParams.asOfDate}';
		$("txtCutOffDate").value = '${lastExtractParams.cutOffDate}';
		$("txtBranchCd").value = '${lastExtractParams.branchCd}';
		$("txtBranchName").value = ('${lastExtractParams.branchCd}' == "" ? "ALL BRANCHES" : '${lastExtractParams.branchName}');
		if ('${lastExtractParams.pdcType}' == "R"){
			$("chkRegister").checked = true;
			$("chkOutstanding").checked = false;
			register = "R";		// Dren 10.30.2015 SR: 0020692 - PDC Register is Extracted and Printed instead of Outstanding.
			outstanding = "R";  // Dren 10.30.2015 SR: 0020692 - PDC Register is Extracted and Printed instead of Outstanding.
		} else {
			$("chkOutstanding").checked = true;
			$("chkRegister").checked = false;
			register = "O";		// Dren 10.30.2015 SR: 0020692 - PDC Register is Extracted and Printed instead of Outstanding.	
			outstanding = "O";  // Dren 10.30.2015 SR: 0020692 - PDC Register is Extracted and Printed instead of Outstanding.
		}
	}
	
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
			//$("excelRB").disabled = true; CarloR SR 5519 06.28.2016
			$("csvRB").disabled = true; //CarloR SR 5519 06.28.2016
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
				//$("excelRB").disabled = false; CarloR SR 5519 06.28.2016
				$("csvRB").disabled = false; //CarloR SR 5519 06.28.2016
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true; CarloR SR 5519 06.28.2016
				$("csvRB").disabled = true; //CarloR SR 5519 06.28.2016
			}		
		}
	}
	
	function showBranchLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));	
		
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:		"getGIACS093BranchLOV",
				searchString: searchString+'%'
			},
			title: "Valid Values for Branches",
			width: 405,
			height: 386,
			draggable: true,
			filterText: escapeHTML2(searchString),
			autoSelectOneRecord: true,
			columnModel: [
				{
					id: "branchCd",
					title: "Branch Cd",
					width: "80px"
				},
				{
					id: "branchName",
					title: "Branch Name",
					width: "308px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
				}
			},
			onCancel: function(){
				$("txtBranchCd").focus();
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
			} 
		});
	}
	
	
	function validateBranchCd(){
		try{
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				parameters: {
					action:		"validateGiacs093BranchCd",
					branchCd:	$F("txtBranchCd")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText != ""){
							$("txtBranchName").value = unescapeHTML2(response.responseText);
						} else{
							$("txtBranchName").value = "ALL BRANCHES";
							clearFocusElementOnError("txtBranchCd","Invalid Value for BRANCH_CD");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBranchCd", e);
		}
	}
	
	function populateGiacPdc(){
		try{
			new Ajax.Request(contextPath + "/GIACCashReceiptsReportController",{
				parameters: {
					action:			"populateGiacPdc",
					asOfDate:		$F("txtAsOfDate"),
					cutOffDate:		$F("txtCutOffDate"),
					branchCd:		$F("txtBranchCd"),
					register:		register,
					outstanding:	outstanding
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Extracting, please wait.."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						extractFlag = json.extractFlag;
						beginExtract = json.beginExtract;
						endExtract = json.endExtract;
						if (json.extractFlag == "TRUE"){
							prevExtAsOfDate = $F("txtAsOfDate");
							prevExtCutOffDate = $F("txtCutOffDate");
							prevExtBranchCd = $F("txtBranchCd");
							prevExtRegister = register;
							prevExtOutstanding = outstanding;
						}else{
							prevExtAsOfDate = null;
							prevExtCutOffDate = null;
							prevExtBranchCd = null;
							prevExtRegister = null;
							prevExtOutstanding = null;
						}
						showMessageBox(json.msg, "I");
					}
				}
			});
		}catch(e){
			showErrorMessage("populateGiacPdc", e);
		}
	}
	
	function validateReportId(reportId, reportTitle){
		try{
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							showMessageBox("No data found in GIIS_REPORTS", "I");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateReportId", e);
		}
	}
	
	function printReport(reportId, reportTitle){
		try{
			if(reportId=="GIACR093A"){ //CarloR SR5519 06.28.2016 START
				if($F("selDestination") == "file" && $("csvRB").checked) {
					reportId = "GIACR093A_CSV";
				}else{
					reportId = "GIACR093A";
				}
			}else if(reportId=="GIACR093"){
				if($F("selDestination") == "file" && $("csvRB").checked) {
					reportId = "GIACR093A_CSV";
				}else{
					reportId = "GIACR093";
				}
			}//CarloR SR5519 06.28.2016 END
			var content = contextPath+"/CashReceiptsReportPrintController?action=printReport&reportId="+reportId+"&asOfDate="+$F("txtAsOfDate")
			  			  +"&cutOffDate="+$F("txtCutOffDate")+"&branchCd="+$F("txtBranchCd")+"&pdc="+register+"&beginExtract="+beginExtract
  			  			  +"&endExtract="+endExtract+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")
  			  			  +"&destination="+$F("selDestination");
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF"; //CarloR2 SR5346 06.27.2016 START
				
				if($("csvRB").checked){
					fileType = "CSV2";
				}else{
					fileType = "PDF";
				}//CarloR2 SR5346 06.27.2016 END
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  //fileType    : $("pdfRB").checked ? "PDF" : "XLS"}, commented out by CarloR2 SR5519 06.28.2016
									  fileType    : fileType }, //CarloR2 SR5519 06.28.2016
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
								if(fileType=="CSV2"){//CarloR2 SR5346 06.27.2016 START
									copyFileToLocal(response, "csv");
								}else{
									copyFileToLocal(response);
								}//CarloR2 SR5346 06.27.2016 END	
							}
						}
					});
			} else if("local" == $F("selDestination")){
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
			showErrorMessage("printReport", e);
		}
	}
	
	toggleRequiredFields("screen");
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no < 100){
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
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies") != ""){
			if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").value = "1";
				});			
			}
		}
	});
	
	
	$("chkRegister").observe("click", function(){
		if($("chkRegister").checked){
			register = "R";
			$("chkOutstanding").checked = false;
			outstanding = "R";
		}else{
			register = "O";
			$("chkOutstanding").checked = true;
			outstanding = "O";			
		}
		
		extractFlag = "FALSE";
	});
	
	$("chkOutstanding").observe("click", function(){
		if($("chkOutstanding").checked){
			outstanding = "O";
			$("chkRegister").checked = false;
			register = "O";
		}else{
			outstanding = "R";
			$("chkRegister").checked = true;
			register = "R";		
		}
		
		extractFlag = "FALSE";
	});
	
	
	$("txtAsOfDate").observe("blur", function(){
		extractFlag = "FALSE";
	});
	
	$("txtCutOffDate").observe("blur", function(){
		extractFlag = "FALSE";
	});
	
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $("txtBranchCd").value.toUpperCase();
	});

	$("txtBranchCd").observe("change", function(){	// changed from blur : shan 08.05.2014
		extractFlag = "FALSE";
		if ($F("txtBranchCd") != ""){
			showBranchLOV(false);
		}else{
			$("txtBranchName").value = 'ALL BRANCHES';
		}
	});
	
	$("searchBranchCdLOV").observe("click", function(){
		showBranchLOV(true);
	});
	
	$("chkDetails").observe("click", function(){
		if($("chkDetails").checked){
			details = "W";
		}else{
			details = "O";
		}
	});
	
	$("btnExtract").observe("click", function(){
		/*if ($F("txtAsOfDate") == "" && $F("txtCutOffDate") == ""){
			showMessageBox("Please specify the period covered and the Cut-off date.", "E");
		}else if($F("txtAsOfDate") == ""){
			showMessageBox("Please specify the period covered.", "E");
		}else if($F("txtCutOffDate") == ""){
			showMessageBox("Please specify the Cut-off date.", "E");
		}else{
			populateGiacPdc();
		}*/
		if (checkAllRequiredFieldsInDiv('fieldDiv')){
			//populateGiacPdc();
			var changed = false;
			if (prevExtAsOfDate != $F("txtAsOfDate")) changed = true;
			if (prevExtCutOffDate != $F("txtCutOffDate")) changed = true;
			if (unescapeHTML2(prevExtBranchCd) != $F("txtBranchCd")) changed = true;
			if (prevExtRegister != register) changed = true;
			if (prevExtOutstanding != outstanding) changed = true;
			
			if ( changed ){
				populateGiacPdc();				
			}else{
				showConfirmBox("CONFIRMATION", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",  
						function(){
							populateGiacPdc();	
						}
				);
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		//if (extractFlag == "TRUE"){
			/*if($F("selDestination") == "printer" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
				showMessageBox("Printer Name and No. of Copies are required.", "I");
			}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
			}else{
				if (details == "O"){
					validateReportId("GIACR093", "PDC Register");
				}else if (details == "W"){
					validateReportId("GIACR093A" , "PDC Register - Detailed");
				}
			}*/
			if (checkAllRequiredFieldsInDiv('fieldDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
				if (prevExtAsOfDate == null && prevExtCutOffDate == null){
					showMessageBox("Please extract records first.", "I");
					return;
				}
				var changed = false;
				if (prevExtAsOfDate != $F("txtAsOfDate")) changed = true;
				if (prevExtCutOffDate != $F("txtCutOffDate")) changed = true;
				if (unescapeHTML2(prevExtBranchCd) != $F("txtBranchCd")) changed = true;
				if (prevExtRegister != register) changed = true;
				if (prevExtOutstanding != outstanding) changed = true;
				
				if (changed){
					showConfirmBox("CONFIRMATION", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",  
									function(){
										populateGiacPdc();	
									}
					);
				}else{					
					if (details == "O"){
						validateReportId("GIACR093", "PDC Register");
					}else if (details == "W"){
						validateReportId("GIACR093A" , "PDC Register - Detailed");
					}
				}
			}
		/*}else{
			showMessageBox("Please extract records first.", "I");
		}*/
	});
	
	$("pdcRegisterExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
}catch(e){
	showErrorMessage("Page Error:", e);	
}	
</script>