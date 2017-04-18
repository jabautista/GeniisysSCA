<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="enrolleeCertificate">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Extract / Print Policies per Risk Category</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>

<div class="sectionDiv" style="float: none; clear: both;">
	<div class="sectionDiv" style="float: none; padding: 10px; width: 500px; margin: 40px auto;">	
		<div class="sectionDiv" style="float: none; margin: auto;">
			<table align="center" style="margin: 20px auto;">
				<tr>
					<td><label for="txtFromDate" style="float: right;">From</label></td>
					<td style="	padding-left: 5px;">
						<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
							<input type="text" id="txtFromDate" ignoreDelKey="true" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="101" lastValue=""/>
							<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
						</div>
					</td>
					<td><label for="txtToDate" style="float: right; margin-left: 10px;">To</label></td>
					<td style="padding-left: 5px; width: 100px;">
						<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
							<input type="text" id="txtToDate" ignoreDelKey="true" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="102" lastValue=""/>
							<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
						</div>
					</td>
				</tr>
			</table>
			
			<table align="center" style="margin-bottom: 20px; width: 100%; margin-left: 10px;" border="0">
				<tr>
					<td style="width: 0;">
						<input type="radio" id="rdoAcctEntDate" name="rdoGroup"/> 
					</td>
					<td>
						<label for="rdoAcctEntDate">Acct Entry Date</label>
					</td>
					
					<td style="width: 0;">
						<input type="radio" id="rdoIssueDate" name="rdoGroup"/> 
					</td>
					<td>
						<label for="rdoIssueDate">Issue Date</label>
					</td>
					
					<td style="width: 0;">
						<input type="radio" id="rdoEffDate" name="rdoGroup"/> 
					</td>
					<td>
						<label for="rdoEffDate">Effectivity Date</label>
					</td>
					
					<td style="width: 0;">
						<input type="radio" id="rdoBookingDate" name="rdoGroup"/> 
					</td>
					<td>
						<label for="rdoBookingDate">Booking Date</label>
					</td>
				</tr>
			</table>
		</div>	
		<div id="printDiv" class="sectionDiv" style="float: none; margin: auto; margin-top: 3px; padding: 10px 0;">
			<table align="center">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 200px;" tabindex="305">
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
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="306" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
				   <!-- <input value="Excel" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> badz 3/29/2016 SR-5335 -->
						<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 200px;" class="required" tabindex="308">
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
						<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
		<div style="float: none; margin: auto; margin-top: 3px; text-align: center; padding-top: 15px;">
			<input type="button" class="button" value="Extract" id="btnExtract" style="width: 120px;" />
			<input type="button" class="button" value="Print" id="btnPrint" style="width: 120px;" />
		</div>	
	</div>
</div>

<script type="text/javascript">
	try {
		
		var dateBasis = 1;
		var lastFromDate;
		var lastToDate;
		var noOfExtractedRecords = 0;
		var isExtracted = false;
		
		var params = JSON.parse('${params}');
		
		function initGIPIS191(){
			setModuleId("GIPIS191");
			setDocumentTitle("Extract / Print Policies per Risk Category");
			//$("rdoAcctEntDate").checked = true;
			//disableButton("btnPrint");
			
			$("txtFromDate").value = params.fromDate != null ? params.fromDate : "";
			$("txtToDate").value = params.toDate != null ? params.toDate : "";
			
			noOfExtractedRecords = params.noOfRecs;
			
			if(noOfExtractedRecords != 0)
				isExtracted = true;
			else
				isExtracted = false;
			
			if(params.dateBasis == 1)
				$("rdoAcctEntDate").checked = true;
			else if (params.dateBasis == 2)
				$("rdoIssueDate").checked = true;
			else if (params.dateBasis == 3)
				$("rdoEffDate").checked = true;
			else if (params.dateBasis == 4)
				$("rdoBookingDate").checked = true;
			else
				$("rdoAcctEntDate").checked = true;
			
			$("txtFromDate").focus();
		}
		
		function setDateBasis(){
			var basis;
			noOfExtractedRecords = 0;
			isExtracted = false;
			
			if($("rdoAcctEntDate").checked)
				basis = 1;
			else if($("rdoIssueDate").checked)
				basis = 2;
			else if($("rdoEffDate").checked)
				basis = 3;
			else
				basis = 4;
			
			/* if(dateBasis != basis)
				disableButton("btnPrint"); */
			
			dateBasis = basis;
		}
		
		$("rdoAcctEntDate").observe("click", setDateBasis);
		$("rdoIssueDate").observe("click", setDateBasis);
		$("rdoEffDate").observe("click", setDateBasis);
		$("rdoBookingDate").observe("click", setDateBasis);
		
		$("btnExtract").observe("click", function(){
			
			if($("txtFromDate").value == "" || $("txtToDate").value == ""){
				showMessageBox(objCommonMessage.REQUIRED, "I");
				return;
			}
			
			if(isExtracted){
				showConfirmBox("", "Data has been extracted within this specified period. Do you wish to continue extraction?",
						"Yes", "No",
						function(){
					$("txtFromDate").setAttribute("lastValue", $F("txtFromDate"));
					$("txtToDate").setAttribute("lastValue", $F("txtToDate"));
					extract(dateBasis);
					}, null);
				return;
			}
			$("txtFromDate").setAttribute("lastValue", $F("txtFromDate"));
			$("txtToDate").setAttribute("lastValue", $F("txtToDate"));
			extract(dateBasis);
			
		});
		
		function extract(basis){
			new Ajax.Request(contextPath + "/GIPIUwreportsExtController",{
				method: "POST",
				parameters: {
						     action : "gipis191ExtractRiskCategory",
						     fromDate : $F("txtFromDate"),
						     toDate : $F("txtToDate"),
						     basis : basis						     
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Extracting...please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText.trim() == ""){
							noOfExtractedRecords = 0;
							showMessageBox("Extraction finished. No records extracted.", "I");
						}
						else {
							
							if(response.responseText.trim() == "1"){
								showMessageBox("Extraction finished. 1 record extracted.", "I");
								noOfExtractedRecords = 1;
							}								
							else{
								showMessageBox("Extraction finished. " + response.responseText.trim() + " records extracted.", "I");
								noOfExtractedRecords = response.responseText.trim();
							}
								
							
							//enableButton("btnPrint");
						}
						isExtracted = true;
						enableButton("btnPrint");
					}
				}
			});
		}
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgToDate").observe("click", function(){
			scwShow($("txtToDate"), this, null);
		});
		
		$("txtFromDate").observe("focus", function(){
			if ($("imgFromDate").disabled == true) return;
			if(this.readAttribute("lastValue")){
				this.setAttribute("lastValue", "");
				$("txtToDate").setAttribute("lastValue", "");
				noOfExtractedRecords = 0;
				isExtracted = false;
			}
			
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			
			/* if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
				$("txtFromDate").clear();
				disableButton("btnPrint");
				return false;
			} */
			
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
				$("txtFromDate").clear();
				//disableButton("btnPrint");
				return false;
			}
			
			/* if(this.value != lastFromDate)
				disableButton("btnPrint"); */
			
			lastFromDate = this.value;
				
			if(params.fromDate != this.value)
				isExtracted = false;
		});
	 	
	 	$("txtToDate").observe("focus", function(){
			if ($("imgToDate").disabled == true) return;
			if(this.readAttribute("lastValue")){
				this.setAttribute("lastValue", "");
				$("txtFromDate").setAttribute("lastValue", "");
				noOfExtractedRecords = 0;
				isExtracted = false;
			}
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			
			/* if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
				$("txtToDate").clear();
				disableButton("btnPrint");
				return false;
			} */
			
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtToDate");
				$("txtToDate").clear();
				//disableButton("btnPrint");
				return false;
			}
			
			/* if(this.value != lastToDate)
				disableButton("btnPrint"); */
			
			lastToDate = this.value;
				
			if(params.toDate != this.value)
				isExtracted = false;
		});
	 	
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
				//	$("rdoExcel").disable();	Badz 03.31.2016 SR-5335
					$("rdoCsv").disable();					
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
				//	$("rdoExcel").enable();	    Badz 03.31.2016 SR-5335
					$("rdoCsv").enable();
				} else {
					$("rdoPdf").disable();
		        //	$("rdoExcel").disable();	    Badz 03.31.2016 SR-5335
					$("rdoCsv").disable();
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
		
		toggleRequiredFields("screen");
		
		function printReport(){
			try {				
				var content = contextPath + "/GIUTSPrintReportController?action=printReport"
						                  + "&reportId=GIPIR950"
						                  + "&fromDate=" + $F("txtFromDate")
						                  + "&toDate=" + $F("txtToDate")
						                  + "&basis=" + dateBasis
						                  + "&noOfCopies=" + $F("txtNoOfCopies")
						                  + "&printerName=" + $F("selPrinter")
						                  + "&destination=" + $F("selDestination");
								
				if("screen" == $F("selDestination")){
					showPdfReport(content, "");
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing complete.", "S");
							}
						}
					});
				}else if("file" == $F("selDestination")){
					var fileType = "PDF"; //added by carlo rubenecia 04.11.2016 SR 5335
					
					if($("rdoPdf").checked)//added by carlo rubenecia 04.11.2016 SR 5335
						fileType = "PDF";
					
					else if ($("rdoCsv").checked)//added by carlo rubenecia 04.11.2016 SR 5335
						fileType = "CSV"; 
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : fileType}, //added by carlo rubenecia 04.11.2016 SR 5335
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								//copyFileToLocal(response, "reports"); removed by carlo rubenecia 04.11.2016 SR 5335
								if ($("rdoCsv").checked){ // added by carlo rubenecia - start 04.11.2016 SR 5335
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
								}else
									copyFileToLocal(response, "reports");
								// added by carlo rubenecia - end 04.11.2016 SR 5335
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content, {
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
		
		$("btnPrint").observe("click", function(){
			if($("txtFromDate").value == "" || $("txtToDate").value == ""){
				showMessageBox(objCommonMessage.REQUIRED, "I");
				return;
			}
			
			if(!isExtracted){
				showConfirmBox("", "The specified period has not been extracted. Do you want to extract the data using the specified period?",
						"Yes", "No",
						function(){
					$("txtFromDate").setAttribute("lastValue", $F("txtFromDate"));
					$("txtToDate").setAttribute("lastValue", $F("txtToDate"));
					extract(dateBasis);
					}, null);
			} else {
				if(noOfExtractedRecords == 0){
					showMessageBox("The table has no entries. Please re-enter parameter, then extract using the extract button.", "I");
					return;
				}
				
				var dest = $F("selDestination");
				
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						if($F("txtNoOfCopies") > 100 || $F("txtNoOfCopies") < 1){
							showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I");
							return;
						}
						printReport();
					}
				}else{
					printReport();
				}
			}
		});
		
		$("btnReloadForm").observe("click", showGIPIS191RiskCategory);		
		
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
		function observeBackspaceDelete(id){
			$(id).observe("keypress", function(event){
				if(event.keyCode == objKeyCode.BACKSPACE || event.keyCode == 46){
					//disableButton("btnPrint");
					$(id).clear();
				}
			});
		}
		
		observeBackspaceDelete("txtFromDate");
		observeBackspaceDelete("txtToDate");
		
		initGIPIS191();
		initializeAll();
	} catch (e) {
		showErrorMessage("Risk Category", e);
	}
</script>