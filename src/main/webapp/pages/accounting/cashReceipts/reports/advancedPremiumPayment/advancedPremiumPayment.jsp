<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>


<div id="advancedPremPaytMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li id="advancedPremPaytExit"><a>Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Advanced Premium Payment</label>
		</div>
	</div>
	
	<div class="sectionDiv" style="width: 920px; height: 500px;">
		<div class="sectionDiv" style="width: 600px; height: 420px; margin: 40px 20px 20px 150px;">
			<div id="dateParamDiv" class="sectionDiv" style="width: 515px; height: 16px; margin: 10px 10px 0 13px; padding: 17px 30px 17px 30px;">
				<table align="center">
					<tr>
						<td>
							<input id="chkPosting" type="checkbox" style="float: left;" tabindex="101">
							<label style="margin-left: 7px;">Posting Date</label>
						</td>
						<td>
							<input id="chkTran" type="checkbox" checked="checked" style="float: left; margin-left: 140px;" value="T" tabindex="101">
							<label style="margin-left: 7px;">Transaction Date</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="optDiv" class="sectionDiv" style="width: 465px; height: 135px; margin: 2px 10px 0 13px; padding: 14px 30px 14px 80px;">
				<table >
					<tr>
						<td style="padding-bottom: 25px;">
							<input id="paymentRB" name="paymentTakeupRG" type="radio" value="P" checked="checked" style="float: left;">
							<label for="paymentRB" style="margin: 2px 130px 2px 2px;">Payment Date</label>
						</td>
						<td style="padding-bottom: 30px;">
							<input id="takeupRB" name="paymentTakeupRG" type="radio" value="T" style="float: left;">
							<label for="takeupRB" style="margin: 2px 4px 2px 2px; ">Take-up Date</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="fromRB" name="dateRG" type="radio" value="F" checked="checked" style="float: left; margin-right: 7px;">
							<label for="fromRB" style="float: left; padding-top: 2px; margin-right: 7px;">From</label>
							<div id="fromDiv" class="required" style="width: 140px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtFromDate" name="txtFromDate" class="required" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 115px; height: 13px; margin: 0px;" value=""/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  />							
							</div>
						</td>
						<td>
							<label style="float: left; padding-top: 2px; margin-right: 5px; padding-left: 50px;">To</label>
							<div id="toDiv" class="required" style="width: 140px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtToDate" name="txtToDate" class="required" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 115px; height: 13px; margin: 0px;" value=""/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  />							
							</div>
						</td>
					</tr>					
					<tr>
						<td>
							<input id="asOfRB" name="dateRG" type="radio" value="A" style="float: left; margin-right: 7px;">
							<label for="asOfRB" style="float: left; padding-top: 2px; margin-right: 5px;">As Of</label>
							<div id="asOfDiv" style="width: 140px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtAsOfDate" name="txtAsOfDate" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 115px; height: 13px; margin: 0px;" value=""/>
								<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAsOfDate'),this, null);" />							
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
									<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" >
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<input id="txtBranchName" type="text" readonly="readonly" style="width: 280px;">
						</td>
					</tr>
				</table>
			</div>
			
			<div id="branchParamDiv" class="sectionDiv" style="width: 250px; height:140px; margin: 2px 0  0 13px;">
				<table>
					<tr>
						<td style="padding: 10px 0 20px 10px;"><label>Branch Parameter:</label></td>
					</tr>
					<tr>
						<td style="padding-bottom: 5px;">
							<input id="orRB" name="branchRG" type="radio" checked="checked" value="OR" style="float: left; margin: 1px 7px 0 50px;">
							<label for="orRB" style="margin: 0 4px 2px 2px; ">OR</label>
						</td>
					</tr>
					<tr>
						<td style="padding-bottom: 5px;">
							<input id="billInvoiceRB" name="branchRG" type="radio" value="BI" style="float: left; margin: 1px 7px 0 50px;">
							<label for="billInvoiceRB" style="margin: 0 4px 2px 2px; ">Bill / Invoice</label>
						</td>
					</tr>
					<tr>
						<td style="padding-bottom: 5px;">
							<input id="creditingBranchRB" name="branchRG" type="radio" value="CB" style="float: left; margin: 1px 7px 0 50px;">
							<label for="creditingBranchRB" style="margin: 0 4px 2px 2px; ">Crediting Branch</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 300px; height: 120px; margin: 2px 0 0 1px; padding: 10px 22px 10px 0;" align="center">
				<table style="float: left; padding: 7px 0 0 1px; width: 310px;">
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
							<!--<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>   comment out by carlo de guzman 3.07.2016-->
							<input value="CSV" title="Csv" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="110"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label> <!-- added by carlo de guzman 3.07.2016  -->
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="112">
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
			
			<div id="btnDiv" class="buttonsDiv">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 90px;">
			</div>
		</div>
	</div>

</div>

<script type="text/javascript">
try{
	setModuleId("GIACS170");
	setDocumentTitle("Advanced Premium Payment");
	initializeAll();
	
	disableDate("imgAsOfDate");
	$("txtBranchName").value = "ALL BRANCHES";
	$("txtFromDate").focus();
	
	var dateType = "T";
	var paymentTakeup = "P";
	var dateRg = "F";
	var branchParam = "OR";
	
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
			//$("excelRB").disabled = true; comment out carlo de guzman 3.07.2016 
			$("csvRB").disabled = true; // added by carlo de guzman 3.07.2016
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
				//$("excelRB").disabled = false;  comment out carlo de guzman 3.07.2016 
				$("csvRB").disabled = false; // added by carlo de guzman 3.07.2016
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true;  comment out carlo de guzman 3.07.2016
				$("csvRB").disabled = true; // added by carlo de guzman 3.07.2016
			}		
		}
	}
	
	function showBranchLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : escapeHTML2($F("txtBranchCd").trim());
		
		LOV.show({
			controller:	'AccountingLOVController',
			urlParameters: {
					action: 		'getGIACS170BranchLOV',
					searchString:	searchString
			},
			title: 'Valid Values for Branches',
			width: 405,
			height: 386,
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			columnModel:[
			  	{
			  		id: 'branchCd',
			  		title: 'Branch Cd',
			  		width: '80px'
			  	},
			  	{
			  		id: 'branchName',
			  		title: 'Branch Name',
			  		width: '380px'
			  	}
			],
			onSelect: function(row){
				if (row != undefined){
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
				}
			},
			onUndefinedRow : function(){
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
			},
			onCancel: function(){
				$("txtBranchCd").focus();
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			}
		});
	}
	
	function validateBranchCd(){
		try{
			new Ajax.Request(contextPath+"/GIACCashReceiptsReportController",{
				parameters: {
					action:		"validateGiacs170BranchCd",
					branchCd:	$F("txtBranchCd"),
					moduleId:	"GIACS170"
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText != ""){
							$("txtBranchName").value = unescapeHTML2(response.responseText);
						}else{
							//clearFocusElementOnError("txtBranchCd", "Invalid value for BRANCH_CD");
							$("txtBranchName").value = "ALL BRANCHES";
							showBranchLOV();	//shan 10.07.2013
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBranchCd", e);
		}
	}
	
	function printReport(reportId, reportTitle){
		try{
			var toDate = null;
			
			if (dateRg == "F"){
				toDate = $F("txtToDate");
			}else if(dateRg == "A"){
				toDate = $F("txtAsOfDate");
			}
			
			var content = contextPath+"/CashReceiptsReportPrintController?action=printReport&moduleId=GIACS170&reportId="+reportId
					      +"&fromDate="+$F("txtFromDate")+"&toDate="+toDate+"&dateType="+dateType+"&branchParam="+branchParam+"&branchCd="
					      +$F("txtBranchCd")+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="
					      +$F("selDestination");
			
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
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF";	  // added carlo de	guzman 3.07.2016				
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("csvRB").checked)
					fileType = "CSV"; // end
		
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "FILE",
				fileType    : fileType}, // added carlo de guzman 3.07.2016
				// $("pdfRB").checked ? "PDF" : "XLS"},  comment out carlo de guzman 3.07.2016
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV"){  // added by carlo de guzman 3.07.2016
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
							} else // end
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
	
	
	$("chkPosting").observe("click", function(){
		if($("chkPosting").checked){
			dateType = "P";
			$("chkTran").checked = false;
		}else{
			dateType = "T";
			$("chkTran").checked = true;
		}
	});
	
	$("chkTran").observe("click", function(){
		if($("chkTran").checked){
			dateType = "T";
			$("chkPosting").checked = false;
		}else{
			dateType = "P";
			$("chkPosting").checked = true;
		}
	});
	
	$$("input[name='paymentTakeupRG']").each(function(rb){
		rb.observe("click", function(){
			if(rb.id == "paymentRB"){
				paymentTakeup = "P";
				$("fromRB").checked = true;
				$("asOfRB").disabled = false;
				enableDate("imgFromDate");
				enableDate("imgToDate");
				disableDate("imgAsOfDate");
				$("orRB").disabled = false;
				$("billInvoiceRB").disabled = false;	
				
			}else if(rb.id == "takeupRB"){
				paymentTakeup = "T";
				$("fromRB").checked = true;
				$("asOfRB").disabled = true;
				enableDate("imgFromDate");
				enableDate("imgToDate");
				disableDate("imgAsOfDate");
				$("txtAsOfDate").value = "";
				$("orRB").disabled = true;
				$("billInvoiceRB").disabled = true;
				$("creditingBranchRB").checked = true;		
				branchParam = "CB";
				dateRg = "F";
				$("fromDiv").addClassName("required");
				$("txtFromDate").addClassName("required");
				$("toDiv").addClassName("required");
				$("txtToDate").addClassName("required");
				$("asOfDiv").removeClassName("required");
				$("txtAsOfDate").removeClassName("required");
			}
		});
	});
	
	
	$$("input[name='dateRG']").each(function(rb){
		rb.observe("click", function(){
			if (rb.id == "fromRB"){
				dateRg = "F";
				enableDate("imgFromDate");
				enableDate("imgToDate");
				disableDate("imgAsOfDate");
				$("txtAsOfDate").value = "";
				$("fromDiv").addClassName("required");
				$("txtFromDate").addClassName("required");
				$("toDiv").addClassName("required");
				$("txtToDate").addClassName("required");
				$("asOfDiv").removeClassName("required");
				$("txtAsOfDate").removeClassName("required");
			}else if(rb.id == "asOfRB"){
				dateRg = "A";
				disableDate("imgFromDate");
				disableDate("imgToDate");
				enableDate("imgAsOfDate");
				$("txtFromDate").value = "";
				$("txtToDate").value = "";
				$("fromDiv").removeClassName("required");
				$("txtFromDate").removeClassName("required");
				$("toDiv").removeClassName("required");
				$("txtToDate").removeClassName("required");
				$("asOfDiv").addClassName("required");
				$("txtAsOfDate").addClassName("required");
			}
		});
	});
	
	$("searchBranchCdLOV").observe("click", function(){
		showBranchLOV(true);
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $("txtBranchCd").value.toUpperCase();
	});
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") != ""){
			showBranchLOV(false); //validateBranchCd();
		}else{
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		}
	});
	
	$$("input[name='branchRG']").each(function(rb){
		rb.observe("click", function(){
			branchParam = rb.value;
		});
	});
	
	/*$("txtFromDate").observe("blur", function(){
		checkInputDates(this.id, this.id, "txtToDate");
	});
	
	$("txtToDate").observe("blur", function(){
		checkInputDates(this.id, "txtFromDate", this.id);
	});*/
	
	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	$("btnPrint").observe("click", function(){
		/*if(dateRg == "F"){
			if($F("txtFromDate") == "" && $F("txtToDate") == ""){
				showMessageBox("Please enter From Date and To Date", "E");
				return false;
			}else if($F("txtFromDate") == ""){
				showMessageBox("Please enter From Date", "E");
				return false;
			}else if($F("txtToDate") == ""){
				showMessageBox("Please enter To Date", "E");
				return false;
			}else if(compareDatesIgnoreTime(Date.parse($("txtFromDate").value),Date.parse($("txtToDate").value)) == -1){
				showMessageBox("From Date should be earlier than To Date", "E");
				return false;
			}
		}else if(dateRg == "A"){
			if($F("txtAsOfDate") == ""){
				showMessageBox("Please enter As Of Date", "E");
				return false;
			}	
		}*/
		if (checkAllRequiredFieldsInDiv('optDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){		
			if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
				return false;
			}
			
			if(paymentTakeup == "P"){
				printReport("GIACR170", "Advanced Premium Payment");
			}else if (paymentTakeup == "T"){
				printReport("GIACR170A", "Advanced Premium Payment Reversal");
			}

		}
	});
	
	$("advancedPremPaytExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
}catch(e){
	showErrorMessage("Page Error:",e);
}
</script>