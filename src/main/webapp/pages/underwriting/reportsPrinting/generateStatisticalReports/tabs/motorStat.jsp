<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="motorStatMainDiv">
	<div class="" style="float: left; width: 920px; height: 430px;" align="center">
		<div id="fieldsDiv" class="sectionDiv" style="width: 500px; height: 150px; margin: 25px 0 1px 125px;">
			<table style="margin-top: 20px;">
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Area of Coverage/Peril</td>
					<td>
						<input id="hidCoverageCd" type="hidden"/>
						<div id="coverageDiv" style="border: 1px solid gray; width: 300px; height: 20px; float: left; margin-right: 7px;">
							<input id="txtCoverage" name="txtCoverage" class="leftAligned upper" type="text" maxlength="40" style="border: none; float: left; width: 270px; height: 13px; margin: 0px;" value="" tabindex="101"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCoverage" name="searchCoverage" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
				<tr>					
					<td class="rightAligned"></td>
					<td>
						<input value="LTO" title="LTO" type="radio" id="ltoRB" name="typeRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked"><label for="ltoRB" style="margin: 2px 0 4px 0" tabindex="102">LTO</label>
						<input value="NLTO" title="NLTO" type="radio" id="nltoRB" name="typeRG" style="margin: 2px 5px 4px 50px; float: left;"><label for="nltoRB" style="margin: 2px 0 4px 0" tabindex="103">NLTO</label>
					</td>
				</tr>
				<tr>
					<td>
						<input value="BD" title="By Date" type="radio" id="byDateRB" name="dateParamRG" style="margin: 2px 5px 4px 15px; float: left;" checked="checked"><label for="byDateRB" style="margin: 2px 0 4px 0" tabindex="104">By Date</label>
						<label style="margin: 2px 0 4px 25px;">From</label>
					</td>
					<td>
						<div id="fromDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 135px; height: 20px;">
							<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="withIcon required disableDelKey" maxlength="10" style="border: none; float: left; width: 110px; height: 13px; margin: 0px;" value="" tabindex="105"/>
							<img id="imgFromDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtFromDate').focus(); scwShow($('txtFromDate'),this, null);" />
						</div>
						<label style="float: left; padding-top: 2px; margin-right: 5px; padding-left: 8px;">To</label>
						<div id="toDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 135px; height: 20px;">
							<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="withIcon required disableDelKey" maxlength="10" style="border: none; float: left; width: 110px; height: 13px; margin: 0px;" value="" tabindex="106"/>
							<img id="imgToDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtToDate').focus(); scwShow($('txtToDate'),this, null);" />
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<input value="BY" title="By Year" type="radio" id="byYearRB" name="dateParamRG" style="margin: 2px 5px 4px 15px; float: left;"><label for="byYearRB" style="margin: 2px 0 4px 0" tabindex="107">By Year</label>
					</td>
					<td>	
						<input id="txtYear" type="text" class="required integerNpNegativeUnformattedNoComma" maxlength="4" style="width: 130px;" tabindex="108">				
					</td>
				</tr>
			</table>
		</div>
		
		<div id="dateTypeDiv" class="sectionDiv" style="width: 200px; height: 150px; margin: 25px 0 1px 2px;">
			<table style="margin: 15px 0 0 10px;">
				<tr>
					<td>
						<input value="AD" title="Acctg Entry Date" type="radio" id="acctEntDateRB" name="dateTypeRG" style="margin: 2px 5px 10px 5px; float: left;" checked="checked" ><label for="acctEntDateRB" style="margin: 2px 0 10px 0" tabindex="109">Accounting Entry Date</label>									
					</td>
				</tr>
				<tr>
					<td>
						<input value="ED" title="Effectivity Date" type="radio" id="effectivityDateRB" name="dateTypeRG" style="margin: 2px 5px 10px 5px; float: left;"><label for="effectivityDateRB" style="margin: 2px 0 10px 0" tabindex="110">Effectivity Date</label>									
					</td>
				</tr>
				<tr>
					<td>
						<input value="ID" title="Issue Date" type="radio" id="issueDateRB" name="dateTypeRG" style="margin: 2px 5px 10px 5px; float: left;" ><label for="issueDateRB" style="margin: 2px 0 10px 0" tabindex="111">Issue Date</label>									
					</td>
				</tr>
				<tr>
					<td>
						<input value="BD" title="Booking Date" type="radio" id="bookingDateRB" name="dateTypeRG" style="margin: 2px 5px 4px 5px; float: left;"><label for="bookingDateRB" style="margin: 2px 0 4px 0" tabindex="112">Booking Date</label>									
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv" id="printDialogFormDiv" style="margin: 1px 0 0 125px; width: 500px; height: 145px;" align="center">
			<table style="float: left; padding: 15px 0 0 95px;">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 200px;" tabindex="113">
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
						<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="114">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0" tabindex="115">Excel</label>
						<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0" tabindex="115">CSV</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 200px;" class="required" tabindex="116">
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
						<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="117">
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
		
		<div class="sectionDiv" style="width: 200px; height: 145px; margin: 1px 0 0 2px;">
			<table style="margin: 20px 0 0 0;">
				<tr>
					<td>
						<input type="checkbox" id="chkInward" style="margin: 12px 5px 14px 0px; float: left;"><label for="chkInward" style="margin: 12px 0 14px 3px" tabindex="118">Inward Reinsurance</label>
					</td>
				</tr>
				<tr>
					<td>
						<input value="L" title="Losses" type="radio" id="lossesRB" name="printTypeRG" style="margin: 2px 5px 6px 0px; float: left;" checked="checked"><label for="lossesRB" style="margin: 2px 0 6px 0" tabindex="119">Losses</label>									
					</td>
				</tr>
				<tr>
					<td>
						<input value="P" title="Premium" type="radio" id="premiumRB" name="printTypeRG" style="margin: 2px 5px 4px 0px; float: left;"><label for="premiumRB" style="margin: 2px 0 4px 0" tabindex="120">Premium</label>									
					</td>
				</tr>
			</table>
		</div>
					
		<div class="buttonsDiv" style="margin-top: 15px;">
		<input id="btnExtract" type="button" class="button" value="Extract Statistical Data" style="width: 160px;" tabindex="121">
		<input id="btnPrint" type="button" class="button" value="Print" style="width: 160px;" tabindex="122">
		</div>
		
	</div>	
</div>

<script type="text/javascript">
try{
	$("txtCoverage").focus();
	$("txtYear").readOnly = true;
	$("txtYear").removeClassName("required");
	
	var dateParam = "BD";
	var dateType = "AD";
	var motorStatType = "LTO";
	var printType = "L";
	var vIssCd = "F";
	
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
	
	function showCoverageLOV(){
		var searchString = '%'/* $F("txtCoverage") == "" ? '%' : escapeHTML2($F("txtCoverage").trim()) */;//Modified by pjsantos 12/15/2016, to be able to search for LOV's again GENQA 5892
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiisCoverageLOV",
				searchString : searchString,
				page : 1
			},
			title : "Coverage",
			width : 480,
			height : 386,
			columnModel : [ 
			 {
				id : "coverageDesc",
				title : "Coverage Desc",
				width : '345px'
			},{
				id : "coverageCd",
				title : "Coverage Code",
				width : '120px',
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			findText: searchString,
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("hidCoverageCd").value = row.coverageCd;
					$("txtCoverage").value = unescapeHTML2(row.coverageDesc);
				}
			},
			onCancel: function(){
				$("txtCoverage").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtCoverage");
			} 
		});
	}
	
	function showZoneTypeLOV(){
		var searchString = $F("txtCoverage") == "" ? '%' : escapeHTML2($F("txtCoverage").trim());
		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS901ZoneTypeLOV",
				page : 1
			},
			title : "Zone Types",
			width : 480,
			height : 386,
			columnModel : [ 
			 {
				id : "rvMeaning",
				title : "Rv Meaning",
				width : '345px'
			},{
				id : "rvLowValue",
				title : "",
				width : '120px',
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			findText: searchString,
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("hidCoverageCd").value = unescapeHTML2(row.rvLowValue);
					$("txtCoverage").value = unescapeHTML2(row.rvMeaning);
				}
			},
			onCancel: function(){
				$("txtCoverage").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtCoverage");
			} 
		});
	}
	
	function extractRecords(){
		try{
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters: {
					action:			"extractRecordsMotorStat",
					motorStatType:	motorStatType,
					zoneType:		$F("hidCoverageCd").trim(),
					dateParam:		dateParam,
					printType:		printType,
					dateType:		dateType,
					vIssCd:			vIssCd,
					dateFrom:		$F("txtFromDate"),
					dateTo:			$F("txtToDate"),
					year:			$F("txtYear")
				},
				onCreate: showNotice("Extracting records, please wait..."),
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						showMessageBox(response.responseText, "I");
					}
				}
			});
		}catch(e){
			showErrorMessage("extractRecords", e);
		}
	}
	
	function printReport(){
		var reportId = "";
		var reportTitle = "";
		
		if (printType == "L"){
			if (motorStatType == "NLTO"){
				reportId = "GIRIR118";
				reportTitle = "MOTOR CLAIM STATISTICS FOR NLTO";
			}else if (motorStatType == "LTO"){
				reportId = "GIRIR117";
				reportTitle = "MOTOR CLAIM STATISTICS FOR LTO";
			}
		}else if(printType == "P"){
			if (motorStatType == "NLTO"){
				reportId = "GIRIR116";
				reportTitle = "MOTOR STATISTICS FOR NLTO";
			}else if (motorStatType == "LTO"){
				reportId = "GIRIR115";
				reportTitle = "MOTOR STATISTICS FOR LTO";
			}
		}
		
		try{
			var content = contextPath+"/UWPrintStatisticalReportsController?action=printReportsMotorStatTab&reportId="+reportId+
						  "&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&year="+$F("txtYear")+"&dateParam="+dateParam+
						  "&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
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
				//added by clperello | 06.10.2014
				 var fileType = "PDF";
			
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV"; 
				//end here clperello | 06.10.2014	
				
				new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : fileType}, //$("pdfRB").checked ? "PDF" : "XLS"}, commented out by clperello 
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
								if (checkErrorOnResponse(response)){
									if (fileType == "CSV"){ //added by clperello | 06.10.2014
										copyFileToLocal(response, "csv");
										deleteCSVFileFromServer(response.responseText);
									} else 
										copyFileToLocal(response);
								}
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
	
	$$("input[name='typeRG']").each(function(rb){
		rb.observe("click", function(){
			$("hidCoverageCd").clear();
			$("txtCoverage").clear();
			$("txtCoverage").focus();
			
			motorStatType = rb.value;
		});
	});
	
	$$("input[name='dateParamRG']").each(function(rb){
		rb.observe("click", function(){
			dateParam = rb.value;
			
			if (rb.value == "BD"){
				$("fromDateDiv").addClassName("required");
				$("toDateDiv").addClassName("required");
				$("txtFromDate").addClassName("required");
				$("txtToDate").addClassName("required");
				$("txtFromDate").readOnly = false;
				$("txtToDate").readOnly = false;
				enableDate("imgFromDate");
				enableDate("imgToDate");
				$("txtYear").removeClassName("required");
				$("txtYear").readOnly = true;
				$("txtYear").clear();
				$("txtFromDate").focus();
			}else if (rb.value == "BY"){
				$("fromDateDiv").removeClassName("required");
				$("toDateDiv").removeClassName("required");
				$("txtFromDate").removeClassName("required");
				$("txtToDate").removeClassName("required");
				$("txtFromDate").readOnly = true;
				$("txtToDate").readOnly = true;
				disableDate("imgFromDate");
				disableDate("imgToDate");
				$("txtFromDate").clear();
				$("txtToDate").clear();
				$("txtYear").addClassName("required");
				$("txtYear").readOnly = false;
				$("txtYear").focus();
			}
		});
	});
	
	$$("input[name='dateTypeRG']").each(function(rb){
		rb.observe("click", function(){
			dateType = rb.value;
		});
	});
	
	$$("input[name='printTypeRG']").each(function(rb){
		rb.observe("click", function(){
			printType = rb.value;
		});
	});
	
	$("searchCoverage").observe("click", function(){
		if ($("nltoRB").checked){
			showCoverageLOV();
		}else if ($("ltoRB").checked){
			showZoneTypeLOV();
		}
	});

	$("txtCoverage").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			
			if ($("nltoRB").checked){
				var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGiisCoverageLOV",findText,"Searching Coverage, please wait...");
				
				if(cond == 0){
					$("hidCoverageCd").clear();
					this.clear();
					//showMessageBox("Invalid value for Coverage", imgMessage.INFO);
					fireEvent($("searchCoverage"), "click");
				}else if(cond == 2){
					showCoverageLOV();
				}else{
					$("hidCoverageCd").value = cond.rows[0].coverageCd;
					this.value = unescapeHTML2(cond.rows[0].coverageDesc);
				}
			}else if ($("ltoRB").checked){
				var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGIPIS901ZoneTypeLOV",findText,"Searching Zone Type, please wait...");
				
				if(cond == 0){
					$("hidCoverageCd").clear();
					this.clear();
					//showMessageBox("Invalid value for Coverage", imgMessage.INFO);
					fireEvent($("searchCoverage"), "click");
				}else if(cond == 2){
					showCoverageLOV();
				}else{
					$("hidCoverageCd").value = unescapeHTML2(cond.rows[0].rvLowValue);
					this.value = unescapeHTML2(cond.rows[0].rvMeaning);
				}
			}
		}else{
			$("hidCoverageCd").clear();
		}
	});
	
	$("txtFromDate").observe("blur", function(){
		checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
	});
	
	$("txtToDate").observe("blur", function(){
		checkInputDates("txtToDate", "txtFromDate", "txtToDate");
	});
	
	$("btnExtract").observe("click", function(){
		if ($F("txtCoverage") == ""){
			if ($("ltoRB").checked){
				showMessageBox("Peril must be entered", "E");
			}else if($("nltoRB").checked){
				showMessageBox("Area of Coverage must be entered", "E");				
			}
			
			$("txtCoverage").focus();
			return false;
		}
		 if (checkAllRequiredFieldsInDiv("fieldsDiv")){
			 if ($("chkInward").checked){
				 vIssCd = "T";
			 }else if ($("chkInward").checked == false){
				 vIssCd = "F";
			 }
			 
			 extractRecords();
		 }
	});
	
	$("btnPrint").observe("click", function(){
		if (checkAllRequiredFields("fieldsDiv") && checkAllRequiredFieldsInDiv("printDialogFormDiv")){
			printReport();
			/*new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController", {
				parameters: {
					action:			"chkExistingRecordMotorStat",
					motorStatType:	motorStatType,
					printType:		printType
				},
				onCreate: showNotice("Checking records for printing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (response.responseText == "N"){
							showMessageBox("No records to print", "I");
						}else{
							printReport();
						}
					}
				}
			});*/
		}
	});
	
	toggleRequiredFields("screen");
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>

