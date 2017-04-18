<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>


<div id="soaOutwardFaculRiMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="soaOutwardFaculRiExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Statement Of Account - Outward Facultative Binders</label>
		</div>
	</div>
	
	<div id="soaOutwardFaculRiDiv" class="sectionDiv" style="height: 460px; width: 920px;" >
		<div class="sectionDiv" style="width: 600px; height: 360px; margin: 40px 20px 20px 150px;">
			<div id="fieldsDiv" class="sectionDiv" style="width: 570px; height: 130px; margin: 10px 0 0 13px;">
				<table style="margin: 18px 10px 0 33px;">
					<tr>
						<td class="rightAligned">As of Date</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon required" value="${asOfDate }" readonly="readonly" style="width: 135px;"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>
						<td class="rightAligned" width="88px" style="padding-left: 20px;">Cut-off Date</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="withIcon required" value="${cutOffDate }" readonly="readonly" style="width: 135px;"/>
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtCutOffDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:87px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtRiCd" name="txtRiCd" maxlength="5" class="rightAligned integerUnformattedNoComma" style="width: 56px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCdLOV" name="searchRiCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtRiName" type="text" readonly="readonly" style="width: 350px;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:87px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtLineCd" name="txtLineCd" maxlength="2" style="width: 56px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtLineName" type="text" readonly="readonly" style="width: 350px;">
						</td>
					</tr> 
				</table>
			</div>
			
			<div id="chkboxDiv" class="sectionDiv" style="width: 220px; height: 120px; margin: 2px 2px 10px 13px; padding: 15px 0 15px 0;">
				<table style="margin: 0 30px 50px 35px;">
					<tr>
						<td>
							<input id="chkAging" type="checkbox" style="float: left;" >
							<label for="chkAging" style="margin-left: 7px;" >With Aging</label>
						</td>
					</tr>
					<tr>
						<td style="padding-top: 3px;">
							<input id="chkPremium" type="checkbox" style="float: left; margin-left: 25px;" >
							<label for="chkPremium" style="margin-left: 7px;" >With Premium</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkPaid" type="checkbox" style="float: left; margin-left: 45px;" >
							<label for="chkPaid" style="margin-left: 7px;" >Paid</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkUnpaid" type="checkbox" style="float: left; margin-left: 45px;" >
							<label for="chkUnpaid" style="margin-left: 7px;" >Unpaid</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkPartial" type="checkbox" style="float: left; margin-left: 45px;" >
							<label for="chkPartial" style="margin-left: 7px;" >Partially Paid</label>
						</td>
					</tr>
					<tr>
						<td style="padding-top: 8px;">
							<input id="chkCurrency" type="checkbox" style="float: left; ">
							<label for="chkCurrency" style="margin-left: 7px;" >By Currency</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 315px; height: 120px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
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
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 15px; float: left;" checked="checked" disabled="disabled" tabindex="109"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;display:none" disabled="disabled" tabindex="110"><label for="excelRB" style="margin: 2px 0 4px 0;display:none">Excel</label>  <!--  jhing GENQA 4099,4100,4103,4102,4101,5281 -->
							<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
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
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 100px; margin-right: 20px;" >
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;  ">
			</div>
			
			
		</div>
	</div>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS296");
	setDocumentTitle("Statement of Account - Outward Facultative Binders");
	initializeAll();
	
	$("txtRiName").value = "ALL REINSURERS";
	$("txtLineName").value = "ALL LINES";
	$("chkPremium").disabled = true;
	$("chkPaid").disabled = true;
	$("chkUnpaid").disabled = true;
	$("chkPartial").disabled = true;
	
	// SR-3876, 3879 : shan 08.27.2015
	var asOfDateParam = "${asOfDate}";
	var cutOffDateParam = "${cutOffDate}";
	
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
			$("csvRB").disabled = true;
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
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}		
		}
	}
	
	function showLineLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));
		
		LOV.show({
			controller:		'AccountingLOVController',
			urlParameters: {
				action:  'getGiisLineLOV3',
					searchString : searchString
			},
			title: 'List of Lines',
			width:	405,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			columnModel: [
				{
					id: 'lineCd',
					title: 'Line Cd',
					width: '80px'
				},
				{
					id: 'lineName',
					title: 'Line Name',
					width: '308px'
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
				}
			},
			onCancel: function(){
				$("txtLineCd").focus();
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
			} 
		});
	}
	
	function validateLineCd(){
		try{
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				parameters: {
					action: 	"validateGIACS296LineCd",
					lineCd:		$F("txtLineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "ERROR"){
							$("txtLineName").value = "ALL LINES";
							clearFocusElementOnError($("txtLineCd"), "Invalid value for LINE_CD");
						}else{
							$("txtLineName").value = unescapeHTML2(response.responseText);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateLineCd", e);
		}
	}
	
	function showRiLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtRiCd").trim() == "" ? "%" : $F("txtRiCd"));
		
		LOV.show({
			controller:		'AccountingLOVController',
			urlParameters: {
				action:  'getGIISReinsurerLOV5',
				searchString : searchString
			},
			title: 'List of Reinsurers',
			width:	405,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			columnModel: [
				{
					id: 'riCd',
					title: 'RI Code',
					width: '80px'
				},
				{
					id: 'riName',
					title: 'RI Name',
					width: '308px'
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtRiCd").setAttribute("lastValidValue", row.riCd);
					$("txtRiCd").value = row.riCd;
					$("txtRiName").value = unescapeHTML2(row.riName);
				}
			},
			onCancel: function(){
				$("txtRiCd").focus();
				$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtRiCd");
			} 
		});
	}
	
	function validateRiCd(){
		try{
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				parameters: {
					action: 	"validateGIACS296RiCd",
					riCd:		$F("txtRiCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == ""){
							$("txtRiName").value = "ALL REINSURERS";
							clearFocusElementOnError($("txtRiCd"), "Invalid value for RI_CD");
						}else{
							$("txtRiName").value = unescapeHTML2(response.responseText);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateRiCd", e);
		}
	}
	
	// SR-3876, 3879 : shan 08.27.2015
	function beforePrint(){
		try{
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				parameters: {
					action: 	"getExtractCountGIACS296"
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == 0){
							showMessageBox("You currently have no data in the extract table. Please extract the data by entering the desired parameters and clicking 'EXTRACT' button.", "I");
						}else{
							printReport();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("beforePrint", e);
		}
	}
	
	function getExtractDateParam(){
		try{
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				parameters: {
					action: 	"getExtractDateGIACS296"
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var dates = JSON.parse(response.responseText);
						asOfDateParam = dates.asOfDate;
						cutOffDateParam = dates.cutOffDate;
					}
				}
			});
		}catch(e){
			showErrorMessage("getExtractDateParam", e);
		}
	}
	// end :: SR-3876, 3879
	
	function checkDates(action){
		/*if($F("txtAsOfDate") == ""){
			showMessageBox("Please enter value for As Of Date", "E");
		}else if($F("txtCutOffDate") == ""){
			showMessageBox("Please enter value for Cut-off Date", "E");
		}*/
		if (checkAllRequiredFieldsInDiv('fieldsDiv')){
			if(compareDatesIgnoreTime(Date.parse($("txtAsOfDate").value),Date.parse($("txtCutOffDate").value)) == -1){
				showMessageBox("Cut-off Date must be later than or equal to As of Date.", "E");
			}else{
				if (action == "extract"){
					//extractRecords();	// replaced with codes below ::: SR-3876, 3879 : shan 08.27.2015
					if (nvl(asOfDateParam,"") == "" && nvl(cutOffDateParam,"") == ""){ //Edited by MarkS to handle undefined error SR-22127
						extractRecords();	
					}else{
						if (compareDatesIgnoreTime(Date.parse($F("txtAsOfDate")), Date.parse(asOfDateParam)) == 0
								&& compareDatesIgnoreTime(Date.parse($F("txtCutOffDate")), Date.parse(cutOffDateParam)) == 0){
							showConfirmBox("Confirmation", "The specified dates have already been extracted. Would you like to extract again?", "Yes", "Cancel",
									function(){
										extractRecords();
									},
									"");
						}else{
							extractRecords();								
						}	
					}
				}else if(action == "print" && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
					/*if($F("selDestination") == "printer" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
						showMessageBox("Printer Name and No. of Copies are required.", "I");
					}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
						showMessageBox("Invalid number of copies.", "I");
					}else{}*/
					//printReport();	// replaced with codes below ::: SR-3876, 3879 : shan 08.27.2015
					if (nvl(asOfDateParam,"") == "" && nvl(cutOffDateParam,"") == ""){
						beforePrint();	
					}else{
						if (compareDatesIgnoreTime(Date.parse($F("txtAsOfDate")), Date.parse(asOfDateParam)) == 0	// SR-3876, 3879 : shan 08.27.2015
								&& compareDatesIgnoreTime(Date.parse($F("txtCutOffDate")), Date.parse(cutOffDateParam)) == 0){
							beforePrint();
						}else{
							showConfirmBox("Confirmation", "The specified dates have not been extracted. Continue with extract?", "Yes", "Cancel",
									function(){
										extractRecords();
									},
									"");
						}
					}
				}
			}
		}
	}
	
	function extractRecords(){
		try{
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController", {
				parameters: {
					action:		"extractGIACS296",
					asOfDate:	$F("txtAsOfDate"),
					cutOffDate:	$F("txtCutOffDate"),
					riCd:		$F("txtRiCd"),
					lineCd:		$F("txtLineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onCreated: showNotice("Extracting, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						/*if(response.responseText == 0){
							showMessageBox("There were 0 records extracted for the dates specified.", "I");
						}else{
							showMessageBox("Extraction finished! " + response.responseText + " records extracted.", "I");
						}*/
						// SR-3876, 3879 : shan 08.27.2015
						var res = JSON.parse(response.responseText);
						showWaitingMessageBox("Extraction finished! " + res.recCount + " records extracted.", "I", getExtractDateParam);
					}
				}
			});
		}catch(e){
			showErrorMessage("extractRecords", e);
		}
	}
	
	function printReport(){
		try{
			var reportId = "";
			var reportTitle = "STATEMENT OF ACCOUNT: Premium Due to Reinsurer";
			var paid = "N";
			var unpaid = "N";
			var partial = "N";			
			
			if ($("chkPaid").checked){
				paid = "Y";
			}
			if($("chkUnpaid").checked){
				unpaid = "Y";
			}
			if($("chkPartial").checked){
				partial = "Y";						
			}
			
			if($("chkAging").checked){
				if($("chkPremium").checked){
					if($("chkCurrency").checked){
						return false;
					}else{	
						reportId = "GIACR296D";
						reportTitle = "STATEMENT OF ACCOUNT: Premium Due to Reinsurer (with premium)";
					}
				}else{
					if($("chkCurrency").checked){
						reportId = "GIACR296C";
					}else{
						reportId = "GIACR296A";
					}
				}
			}else{
				if($("chkCurrency").checked){
					reportId = "GIACR296B";
				}else{
					reportId = "GIACR296";
				}
			}
			
			var content = contextPath+"/ReinsuranceReportController?action=printReport&reportId="+reportId+"&reportTitle="+reportTitle
						  +"&asOfDate="+$F("txtAsOfDate")+"&cutOffDate="+$F("txtCutOffDate")+"&riCd="+$F("txtRiCd")+"&lineCd="+$F("txtLineCd")
						  +"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if ($("chkPremium").checked){
				content = content + "&paid="+paid+"&unpaid="+unpaid+"&partial="+partial;
			}
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "";
				
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV";
				
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
								//copyFileToLocal(response);
								
								if ($("csvRB").checked){
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
								}else
									copyFileToLocal(response);
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
	

	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies") != ""){
			if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").value = "1";
				});			
			}
		}
	});
	
	$("searchRiCdLOV").observe("click", function(){
		showRiLOV(true);
	});
	
	$("txtRiCd").observe("change", function(){
		if($F("txtRiCd") != ""){
			showRiLOV(false); //validateRiCd();
		}else{
			$("txtRiName").value = "ALL REINSURERS";
		}
	});
	
	
	$("searchLineCdLOV").observe("click", function(){
		showLineLOV(true);
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") != ""){
			showLineLOV(false); //validateLineCd();
		}else{
			$("txtLineName").value = "ALL LINES";
		}
	});
	
	$("chkAging").observe("click", function(){
		if ($("chkAging").checked){
			$("chkPremium").disabled = false;
			$("chkPaid").disabled = false;
			$("chkUnpaid").disabled = false;
			$("chkPartial").disabled = false;
			$("chkCurrency").disabled = false;
		}else{
			$("chkPremium").disabled = true;
			$("chkPaid").disabled = true;
			$("chkUnpaid").disabled = true;
			$("chkPartial").disabled = true;
			$("chkPremium").checked = false;
			$("chkPaid").checked = false;
			$("chkUnpaid").checked = false;
			$("chkPartial").checked = false;
			$("chkCurrency").disabled = false;
		}
	});
	
	$("chkPremium").observe("click", function(){
		if($("chkPremium").checked){
			$("chkPaid").checked = true;
			$("chkUnpaid").checked = true;
			$("chkPartial").checked = true;
			$("chkCurrency").disabled = true;
			$("chkCurrency").checked = false;
		}else{
			$("chkPaid").checked = false;
			$("chkUnpaid").checked = false;
			$("chkPartial").checked = false;
			$("chkCurrency").disabled = false;	
		}
	});
	
	$("chkPaid").observe("click", function(){
		if ($("chkPaid").checked || $("chkUnpaid").checked || $("chkPartial").checked){
			$("chkPremium").checked = true;
			$("chkCurrency").disabled = true;
		}else{
			$("chkPremium").checked = false;
			$("chkCurrency").disabled = false;
		}
	});
	
	$("chkUnpaid").observe("click", function(){
		fireEvent($("chkPaid"), "click");
	});
	
	$("chkPartial").observe("click", function(){
		fireEvent($("chkPaid"), "click");
	});
	
	
	$("btnExtract").observe("click", function(){
		checkDates("extract");
	});
	
	$("btnPrint").observe("click", function(){
		checkDates("print");
	});
	
	$("soaOutwardFaculRiExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$("imgCutOffDate").observe("click", function(){	// SR-3877 : shan 08.11.2015
		scwNextAction = function(){
							if(compareDatesIgnoreTime(Date.parse($("txtAsOfDate").value),Date.parse($("txtCutOffDate").value)) == -1){
								showMessageBox("Cut-off Date must be later than or equal to As of Date.", "E");
								$("txtCutOffDate").clear();
							}
						}.runsAfterSCW(this, null);
						
		scwShow($("txtCutOffDate"),this, null);
	});
	
}catch(e){
	showErrorMessage("Page Error:", e);
}
</script>