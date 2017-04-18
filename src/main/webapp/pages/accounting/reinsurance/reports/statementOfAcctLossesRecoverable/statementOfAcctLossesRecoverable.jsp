<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>


<div id="soaLossesRecoverableMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li id="soaLossesRecExit"><a>Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Statement of Account - Losses Recoverable</label>
		</div>
	</div>
	
	<div id="soaLossesRecDiv" class="sectionDiv" style="width: 920px; height: 500px">
		<div class="sectionDiv" style="width: 650px; height: 350px; margin: 60px 20px 20px 150px;">
			<div id="fieldsDiv" class="sectionDiv" style="width: 630px; height: 150px; margin: 8px 10px 0 10px;">
				<table style="margin: 18px 10px 0 53px;">
					<tr>
						<td class="rightAligned">As Of Date</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" value="${asOfDate}" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>
				    <!--benjo 12.04.2015 UCPBGEN-SR-20083-->
				    <%--<td class="rightAligned" width="88px" style="padding-left: 27px;">Cut-Off Date</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" value="${cutOffDate}" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtCutOffDate'),this, null);" />
							</div>
						</td>--%>
						<td>
							<input id="rbFla" name="fcRG" type="radio" value="F" style="float: left;" checked="checked"><label for="rbFla" style="margin: 3px 0 0 2px;">FLA Date</label>
						</td>
						<td>
							<input id="rbCLaimPaid" name="fcRG" type="radio" value="C" style="float: left;"><label for="rbCLaimPaid" style="margin: 3px 0 0 2px;">Claim Paid Date</label>
						</td>
					</tr>
					<tr>
					    <td class="rightAligned">Cut-Off Date</td>
						<td>
							<div style="float: left; width: 160px;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" name="txtCutOffDate" value="${cutOffDate}" class="withIcon required" readonly="readonly" style="width: 135px;"/>
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" onClick="scwShow($('txtCutOffDate'),this, null);" />
							</div>
						</td>
						<td>
							<input id="rbTran" name="tpRG" type="radio" value="T" style="float: left;" checked="checked"><label for="rbTran" style="margin: 3px 0 0 2px;">Tran Date</label>
						</td>
						<td>
							<input id="rbPosting" name="tpRG" type="radio" value="P" style="float: left;"><label for="rbPosting" style="margin: 3px 0 0 2px;">Posting Date</label>
						</td>
					</tr>
					<!-- benjo end -->
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:87px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtRiCd" name="txtRiCd" value="${riCd}" maxlength="5" class="rightAligned integerUnformattedNoComma" style="width: 56px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCdLOV" name="searchRiCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtRiName" type="text" readonly="readonly" style="width: 350px;" value="${riName}">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="5">							
							<span class="lovSpan" style="width:87px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtLineCd" name="txtLineCd" value="${lineCd}" maxlength="2" style="width: 56px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
							</span>
							<input id="txtLineName" type="text" readonly="readonly" style="width: 350px;" value="${lineName}">
						</td>
					</tr> 
				</table>
			</div>
			
			<div id="chkboxDiv" class="sectionDiv" style="width: 180px; height: 130px; margin: 1px 1px 5px 10px;">
				<table style="margin: 20px 10px 0 10px;">
					<tr>
						<td style="padding-bottom: 15px;">
							<input id="chkClaims" type="checkbox" style="float: left;" value="${clmPaytTag}" checked="checked">
							<label for="chkClaims" style="margin-left: 7px;" >With Claims Payments</label>
						</td>
					</tr>
					<tr>
						<td style="padding-bottom: 15px;">
							<input id="chkAging" type="checkbox" style="float: left;" >
							<label for="chkAging" style="margin-left: 7px;" >With Aging</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkCurrency" type="checkbox" style="float: left;" >
							<label for="chkCurrency" style="margin-left: 7px;" >By Currency</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="rbDiv" class="sectionDiv" style="width: 111px; height: 130px; margin: 1px;">
				<table style="margin: 17px 10px 0 10px;">
					<tr>
						<td style="padding-bottom: 15px;">
							<input id="rbLoss" name="payeeTypeRG" type="radio" value="L" style="float: left;" checked="checked" >
							<label for="rbLoss" style="margin: 2px 0 0 7px;" >Loss</label>
						</td>
					</tr>
					<tr>
						<td style="padding-bottom: 15px;">
							<input id="rbExpense" name="payeeTypeRG" type="radio" value="E" style="float: left;" >
							<label for="rbExpense" style="margin: 2px 0 0 7px;" >Expense</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="rbBoth" name="payeeTypeRG" type="radio" value="B" style="float: left;" >
							<label for="rbBoth" style="margin: 2px 0 0 7px;" >Both</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 330px; height: 130px; margin: 1px;  align="center">
				<table style="float: left; padding: 7px 0 0 15px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" >
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
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" ><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" ><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> Dren Niebres 05.24.2016 SR-5349-->
							<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" ><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label> <!-- Dren Niebres 05.24.2016 SR-5349 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" >
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3">
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
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 100px; ">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px; " >
			</div>
		</div>
	</div>

</div>


<script type="text/javascript">
try{
	setModuleId("GIACS279");
	setDocumentTitle("Statement of Account - Losses Recoverable");
	initializeAll();
	
	var payeeType = "L";
	var chkClaims = "Y";
	var fcParam = "F"; //benjo 12.04.2015 UCPBGEN-SR-20083
	var tpParam = "T"; //benjo 12.04.2015 UCPBGEN-SR-20083
	var chkAging = 0;
	var asOfDate = $F("txtAsOfDate");
	var cutOffDate = $F("txtCutOffDate");
	
	$("chkClaims").checked = true;
	$("rbFla").disabled = false; //benjo 12.04.2015 UCPBGEN-SR-20083
	$("rbCLaimPaid").disabled = false; //benjo 12.04.2015 UCPBGEN-SR-20083

	if($F("chkClaims") != "Y" && $F("chkClaims") != ""){
		$("chkClaims").checked = false;
		chkClaims = "N";
		$("rbFla").disabled = true; //benjo 12.04.2015 UCPBGEN-SR-20083
		$("rbCLaimPaid").disabled = true; //benjo 12.04.2015 UCPBGEN-SR-20083
	}
	
	if ($F("txtRiName") == ""){
		$("txtRiName").value = "ALL REINSURERS";
	}
	
	if($F("txtLineName") == ""){
		$("txtLineName").value = "ALL LINES";	
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
			//$("excelRB").disabled = true; //Dren Niebres 05.24.2016 SR-5349
			$("csvRB").disabled = true; //Dren Niebres 05.24.2016 SR-5349
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
				//$("excelRB").disabled = false; //Dren Niebres 05.24.2016 SR-5349
				$("csvRB").disabled = false; //Dren Niebres 05.24.2016 SR-5349
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true; //Dren Niebres 05.24.2016 SR-5349
				$("csvRB").disabled = true; //Dren Niebres 05.24.2016 SR-5349
			}		
		}
	}
	
	function showLineLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));
		
		LOV.show({
			controller:		'AccountingLOVController',
			urlParameters: {
				action:  'getGiisLineLOV',
				searchString: searchString
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
				action:  'getGIISReinsurerLOV5', // 'getGIISReinsurerLOV4'
				searchString: searchString
			},
			title: 'List of Reinsurers',
			width:	405,
			height: 386,
			draggable: true,
			filterText: escapeHTML2(searchString),
			autoSelectOneRecord: true,
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
					$("txtRiCd").value = row.riCd;
					$("txtRiName").value = row.riName;
					$("txtRiCd").setAttribute("lastValidValue", row.riCd);
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
	
	function checkDates(btn){
		try{
			new Ajax.Request(contextPath+"/GIACReinsuranceReportsController",{
				parameters: {
							action:	"checkGIACS279Dates",
							btn: 	btn
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if(btn == "extract"){
							if (json.asOfDate == null && json.cutOffDate == null){
								extractTable();	
							}else{
								if(compareDatesIgnoreTime(Date.parse(json.asOfDate), Date.parse($F("txtAsOfDate"))) != 0 || 
										compareDatesIgnoreTime(Date.parse(json.cutOffDate), Date.parse($F("txtCutOffDate"))) != 0){
									extractTable();		
								}else{
									showConfirmBox("Confirmation", "The specified dates have already been extracted. Would you like to begin extraction?", "Yes", "Cancel",
											function(){
												extractTable();
											},
											"");	
								}
							}							
						}else if(btn == "print"){
								if(json.asOfDate == null && json.cutOffDate == null) {
									if(compareDatesIgnoreTime(Date.parse(nvl(json.asOfDate, asOfDate)), Date.parse($F("txtAsOfDate"))) != 0 || 
										compareDatesIgnoreTime(Date.parse(nvl(json.cutOffDate, cutOffDate)), Date.parse($F("txtCutOffDate"))) != 0){
										showConfirmBox("Confirmation", "The specified dates have not been extracted. Continue with extract?", "Yes", "Cancel",
												function(){
													extractTable();
													asOfDate = $F("txtAsOfDate");
													cutOffDate = $F("txtCutOffDate");
													
												},
												"");
									}else{
										showMessageBox("Please extract records first.", "I");		
									}
								}else{
									if(compareDatesIgnoreTime(Date.parse(nvl(json.asOfDate, asOfDate)), Date.parse($F("txtAsOfDate"))) != 0 || 
											compareDatesIgnoreTime(Date.parse(nvl(json.cutOffDate, cutOffDate)), Date.parse($F("txtCutOffDate"))) != 0){
										showConfirmBox("Confirmation", "The specified dates have not been extracted. Continue with extract?", "Yes", "Cancel",
														function(){
															extractTable();
															asOfDate = $F("txtAsOfDate");
															cutOffDate = $F("txtCutOffDate");
														},
														"");
									}else{
										beforePrint();
									}
								}
						}					
					}
				}
			});
		}catch(e){
			showErrorMessage("checkDates", e);
		}
	}
	
	function extractTable(){
		try{
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
				parameters: {
					action:		"extractGIACS279",
					asOfDate:	$F("txtAsOfDate"),
					cutOffDate:	$F("txtCutOffDate"),
					riCd:		$F("txtRiCd"),
					lineCd:		$F("txtLineCd"),
					payeeType:	payeeType,
					chkClaims:	chkClaims,
					chkAging:	chkAging,
					fcParam:    fcParam, //benjo 12.04.2015 UCPBGEN-SR-20083
					tpParam:    tpParam  //benjo 12.04.2015 UCPBGEN-SR-20083
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Extracting, please wait..."),
				onComplete: function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						showMessageBox(json.msg, "I");
					}
				}
			});
		}catch(e){
			showErrorMessage("extractTable", e);
		}
	}
	
	function beforePrint(){
		/*if($F("selDestination") == "printer" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer Name and No. of Copies are required.", "I");
		}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{*/
			
		if(checkAllRequiredFieldsInDiv('printDialogFormDiv')){ //Dren Niebres 05.24.2016 SR-5349 - Start
			if($F("selDestination") == "file" && $("csvRB").checked) {	
				if ($("chkAging").checked == false && $("chkCurrency").checked == false){
					printReport("GIACR279_CSV", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE");
				}else if ($("chkAging").checked && $("chkCurrency").checked == false){
					printReport("GIACR279A_CSV", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE, WITH AGING");
				}else if ($("chkAging").checked == false && $("chkCurrency").checked){
					printReport("GIACR279B_CSV", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE, WITH CLAIM PAYMENTS BY CURRENCY");
				}else if ($("chkAging").checked && $("chkCurrency").checked){
					printReport("GIACR279C_CSV", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE, (by currency) WITH AGING");
				}							
			} else {
				if ($("chkAging").checked == false && $("chkCurrency").checked == false){
					printReport("GIACR279", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE");
				}else if ($("chkAging").checked && $("chkCurrency").checked == false){
					printReport("GIACR279A", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE, WITH AGING");
				}else if ($("chkAging").checked == false && $("chkCurrency").checked){
					printReport("GIACR279B", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE, WITH CLAIM PAYMENTS BY CURRENCY");
				}else if ($("chkAging").checked && $("chkCurrency").checked){
					printReport("GIACR279C", "STATEMENT OF ACCOUNT - LOSSES RECOVERABLE, (by currency) WITH AGING");
				} //Dren Niebres 05.24.2016 SR-5349 - End						
			}
		}
	}
	
	
	function printReport(reportId, reportTitle){
		try{
			var payeeType1 = "";
			var payeeType2 = "";
			
			if (payeeType == "B"){
				payeeType1 = "L";
				payeeType2 = "E";
			}else{
				payeeType1 = payeeType;
			}		
			
			var content = contextPath+"/ReinsuranceReportController?action=printReport&reportId="+reportId+"&reportTitle="+reportTitle
						  +"&asOfDate="+$F("txtAsOfDate")+"&cutOffDate="+$F("txtCutOffDate")+"&riCd="+$F("txtRiCd")+"&lineCd="
						  +$F("txtLineCd")+"&payeeType="+payeeType1+"&payeeType2="+payeeType2+"&noOfCopies="+$F("txtNoOfCopies")
						  +"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
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
				
				var fileType = "PDF"; //Dren Niebres 05.24.2016 SR-5349 - Start
				
				if ($("pdfRB").checked)
					fileType = "PDF";
				else
					fileType = "CSV2"; //Dren Niebres 05.24.2016 SR-5349 - End				
			
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : fileType}, //$("pdfRB").checked ? "PDF" : "XLS"}, //Dren Niebres 05.24.2016 SR-5349
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
								
								if (fileType == "CSV2"){ //Dren Niebres 05.24.2016 SR-5349 - Start
									copyFileToLocal(response, "csv");
								} else 
									copyFileToLocal(response);
							} //Dren Niebres 05.24.2016 SR-5349 - End								
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
					$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
				});			
			}else{
				$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
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
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtRiName").value = "ALL REINSURERS";
		}
	});
	
	$("searchLineCdLOV").observe("click", function(){
		showLineLOV(true);	
	});
		
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") != ""){
			showLineLOV(false); //validateLineCd();
		}else{
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
		}
	});	

	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();
	});
	
	$("chkClaims").observe("click", function(){
		if($("chkClaims").checked){
			chkClaims = "Y";
			$("rbFla").disabled = false; //benjo 12.04.2015 UCPBGEN-SR-20083
			$("rbCLaimPaid").disabled = false; //benjo 12.04.2015 UCPBGEN-SR-20083
		}else{
			chkClaims = "N";
			$("rbFla").disabled = true; //benjo 12.04.2015 UCPBGEN-SR-20083
			$("rbCLaimPaid").disabled = true; //benjo 12.04.2015 UCPBGEN-SR-20083
		}
	});
	
	$("chkAging").observe("click", function(){
		if($("chkAging").checked){
			chkAging = 1;
		}else{
			chkAging = 0;
		}
	});
	
	$$("input[name='payeeTypeRG']").each(function(rb){
		rb.observe("click", function(){
			payeeType = rb.value;
		});
	});
	
	//benjo 12.04.2015 UCPBGEN-SR-20083
	$$("input[name='fcRG']").each(function(rb){
		rb.observe("click", function(){
			fcParam = rb.value;
		});
	});
	
	//benjo 12.04.2015 UCPBGEN-SR-20083
	$$("input[name='tpRG']").each(function(rb){
		rb.observe("click", function(){
			tpParam = rb.value;
		});
	});
	
	$("txtAsOfDate").observe("focus", function() {
		if ($("txtAsOfDate").value != "" && this.value != "") {
			if ((Date.parse($F("txtAsOfDate")) > new Date())) {
				customShowMessageBox("Invalid value for As Of Date. Please enter date that is not greater than the system date.", "I", "txtAsOfDate");
				this.clear();
			}
		}
	});

	
	$("txtCutOffDate").observe("focus", function() {
		if ($("txtCutOffDate").value != "" && this.value != "") {
			if ((Date.parse($F("txtCutOffDate")) > new Date())) {
				customShowMessageBox("Invalid value for Cut Off Date. Please enter date that is not greater than the system date.", "I", "txtCutOffDate");
				this.clear();
			}
		}
	});
	
	$("btnExtract").observe("click", function(){
		/*if($F("txtAsOfDate") == "" && $F("txtCutOffDate") != ""){
			showMessageBox("Please enter As Of Date", "I");
		}else if($F("txtAsOfDate") != "" && $F("txtCutOffDate") == ""){
			showMessageBox("Please enter Cut-off Date", "I");
		}else if($F("txtAsOfDate") == "" && $F("txtCutOffDate") == ""){
			showMessageBox("Please enter As Of and Cut-off Dates", "I");*/
		if($F("txtAsOfDate")==""||$F("txtCutOffDate")==""){
			showMessageBox("Required fields must be entered.","I");
		}else{
			if(checkAllRequiredFieldsInDiv('fieldsDiv')){
				if((Date.parse($F("txtAsOfDate")) > new Date()) && (Date.parse($F("txtCutOffDate")) <= new Date())){
					showMessageBox("As Of Date must not be beyond the date today", "I");
				}else if((Date.parse($F("txtAsOfDate")) <= new Date()) && (Date.parse($F("txtCutOffDate")) > new Date())){
					showMessageBox("Cut-off Date must not be beyond the date today", "I");
				}else{
					checkDates("extract");
				}
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		if($F("txtAsOfDate")==""||$F("txtCutOffDate")==""){
			showMessageBox("Required fields must be entered.","I");
		}else{
			checkDates("print");
		}	
	});
	
	$("soaLossesRecExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>