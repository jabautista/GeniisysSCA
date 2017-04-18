<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="modifiedCommissionsMainDiv" name="modifiedCommissionsMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Modified Commissions</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="modifiedCommissionsDiv" name="modifiedCommissionsDiv" class="sectionDiv">
		<div class="sectionDiv"  style="width: 70%; margin: 40px 138px 40px 138px; height: 405px;">
			<fieldset style="height: 70px; width: 46%; margin: 8px 4px 2px 8px; float: left; border: 1px solid #E0E0E0;">
				<legend>Transaction Status</legend>
				<table border="0" cellspacing="2" cellpadding="2" >
					<tr><td><input value="all" title="All" type="radio" id="all" name="tranStatusGroup" style="margin: 0 5px 0 5px; float: left;" tabindex="101"><label for="all">All</label></td></tr>
					<tr><td><input value="posted" title="Posted" type="radio" id="posted" name="tranStatusGroup" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label for="posted">Posted</label></td></tr>
					<tr><td><input value="unposted" title="Unposted" type="radio" id="unposted" name="tranStatusGroup" style="margin: 0 5px 0 5px; float: left;"><label for="unposted">Unposted</label></td></tr>
				</table>
			</fieldset>	
					
			<fieldset style="height: 70px; width: 46%; margin: 8px 4px 2px 8px; border: 1px solid #E0E0E0;">
				<legend>Branch Type</legend>
				<table border="0" cellspacing="2" cellpadding="2" >
					<tr><td><input value="I" title="Issue Branch" type="radio" id="issue" name="branchTypeGroup" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label for="issue">Issue Branch</label></td></tr>
					<tr><td><input value="C" title="Crediting Branch" type="radio" id="crediting" name="branchTypeGroup" style="margin: 0 5px 0 5px; float: left;" tabindex="102"><label for="crediting">Crediting Branch</label></td></tr>
				</table>
			</fieldset>
			
			<div class="sectionDiv" id = "paramDiv" style="height: 90px; width: 97%; margin: 6px 8px 2px 8px; padding: 15px 0 15px 0;">
				<table style="margin-left: 146px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;" class="required">
					    		<input style="height: 13px; width: 104px; border: none; float: left;" id="fromDate" name="fromDate" type="text" readonly="readonly" tabindex="103" class="required"/>
					    		<img name="hrefFromDate" id="hrefFromDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('fromDate'),this, null);"/>
							</div>
						</td>
						<td class="rightAligned" style="padding-left: 20px;">To</td>
						<td>
							<div style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;" class="required">
					    		<input style="height: 13px; width: 104px; border: none; float: left;" id="toDate" name="toDate" type="text" readonly="readonly" tabindex="104" class="required"/>
					    		<img name="hrefToDate" id="hrefToDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('toDate'),this, null);"/>
							</div>
						</td>
					</tr>
				</table>
				
				<table style="margin-left: 135px;">
					<tr>
						<td class="rightAligned">Branch</td>
						<td>
							<span class="lovSpan" style="width: 70px;" id="branchCdSpan">
								<input id="branchCd" name="branchCd" type="text" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" tabindex="105" lastValidValue="" class="upper" maxlength="2"/>
								<img id="searchBranch" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td><input id="branchName" type="text" readonly="readonly" value="ALL BRANCHES" style="height: 13px; width: 220px;" tabindex="106"></td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td>
							<span class="lovSpan" style="width: 70px;">
								<input id="lineCd" name="lineCd" type="text" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" tabindex="107" lastValidValue="" class="upper" maxlength="2"/>
								<img id="searchLine" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
							</span>
						</td>
						<td><input id="lineName" type="text" readonly="readonly" value="ALL LINES" style="height: 13px; width: 220px;" tabindex="108"></td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="width: 40%; height: 100px; margin: 8px 4px 2px 8px; padding: 25px 0px 0px 50px;">
				<div id="billDiv" name="billDiv">
					<table>
						<tr>
							<td class="rightAligned">Bill No</td>
							<td><input id="billNo" type="text" class="integerNoNegativeUnformatted" style="text-align: right;" tabindex="109" maxlength="100"></td>
						</tr>
						<tr>
							<td class="rightAligned">Tran No</td>
							<td><input id="tranNo" type="text" class="integerNoNegativeUnformatted" style="text-align: right;" tabindex="110" maxlength="100"></td>
						</tr>
					</table>
				</div>
			</div>
			
			<div id="printerDiv" class="sectionDiv" style="width: 45.4%; height: 115px; margin: 8px 8px 2px 4px; padding: 10px 0px 0px 14px;">
				<table>
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 180px;" tabindex="111">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="115">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 180px;" class="required" tabindex="113">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 156px;" class="required integerNoNegativeUnformatted" tabindex="114">
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
			
			<div id="buttonsDiv" align="center" style="float: left; margin: 8px 0 0 280px;">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 80px;" tabindex="115">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	function whenNewFormInstance(){
		$("acExit").show();
		$("fromDate").focus();
		setModuleId("GIACS056");
		setDocumentTitle("Modified Commissions");
		initializeAll();
		makeInputFieldUpperCase();
		observePrintFields();
		observeBackSpaceOnDate("fromDate");
		observeBackSpaceOnDate("toDate");
		observeBackSpaceOnDate("branchCd");
		observeBackSpaceOnDate("lineCd");
		observeReloadForm("reloadForm", reloadModifiedCommissions);
		toggleRequiredFields("SCREEN");
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
	}
	
	function validateBeforePrint(){
		var fromDate = nvl($F("fromDate"), "");
		var toDate = nvl($F("toDate"), "");
		if(fromDate == "" && toDate == ""){
			customShowMessageBox("Please enter From Date and To Date.", "I", "fromDate");
			return false;
		}else if(fromDate == ""){
			customShowMessageBox("Please enter From Date.", "I", "fromDate");
			return false;
		}else if(toDate == ""){
			customShowMessageBox("Please enter To Date.", "I", "toDate");
			return false;
		}
		/*else if(Date.parse(fromDate) > Date.parse(toDate)){
			customShowMessageBox("From Date should be earlier than To Date.", "I", "toDate");
			return false;
		}*/
		return true;
	}
	
	function showBranchLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS118BranchLOV",
					filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
					moduleId: "GIACS056"
				},
				title: "List of Branches",
				width: 400,
				height: 400,
				columnModel:[
								{	id: "branchCd",
									title: "Branch Code",
									width: "120px",
								},
				             	{	id: "branchName",
									title: "Branch Name",
									width: "260px"
								}
							],
				autoSelectOneRecord: true,
				filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
				onSelect : function(row){
					$("branchCd").value = unescapeHTML2(row.branchCd);
					$("branchName").value = unescapeHTML2(row.branchName);
					$("branchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
						
				},
				onCancel: function (){
					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("searchBranch", e);
		}
	}
	
	function showLineLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS056LineLOV",
					filterText : ($("lineCd").readAttribute("lastValidValue").trim() != $F("lineCd").trim() ? $F("lineCd").trim() : ""),
				},
				title: "List of Lines",
				width: 400,
				height: 400,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "120px",
								},
				             	{	id: "lineName",
									title: "Line Name",
									width: "260px"
								}
							],
				autoSelectOneRecord: true,
				filterText : ($("lineCd").readAttribute("lastValidValue").trim() != $F("lineCd").trim() ? $F("lineCd").trim() : ""),
				onSelect : function(row){
					$("lineCd").value = unescapeHTML2(row.lineCd);
					$("lineName").value = unescapeHTML2(row.lineName);
					$("lineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
				},
				onCancel: function (){
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("searchBranch", e);
		}
	}
	
	function reloadModifiedCommissions(){
		new Ajax.Request(contextPath+"/GIACCommPaytsController", {
			parameters: {
				action: "showModifiedCommissions"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response) {
				hideNotice("");
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
			}
		});
	}
	
	function printModifiedCommissions(){
		var fileType = $("pdfRB").checked ? "PDF" : "XLS";
		var tranStatus = $("all").checked ? "A" : ($("posted").checked ? "P" : "U");
		var branchType = $("issue").checked ? "I" : "C";
		var issCd = "";
		var credBranch = "";
		
		if(branchType == "I"){
			issCd = $F("branchCd");
		}else{
			credBranch = $F("branchCd");
		}
		
		var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR409&branchCd="+$F("branchCd")+
				"&branchType="+branchType+"&credBranch="+credBranch+"&tranStatus="+tranStatus+"&fromDate="+$F("fromDate")+
				"&toDate="+$F("toDate")+"&issCd="+issCd+"&lineCd="+$F("lineCd")+"&billNo="+$F("billNo")+"&tranNo="+$F("tranNo")+
				"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
				"&fileType="+fileType+"&reportId=GIACR409";
		
		printGenericReport(content, "MODIFIED COMMISSION INVOICE SUMMARY REPORT");
	}
	
	/* $("branchCd").observe("keyup", function(e){
		if (objKeyCode.BACKSPACE == e.keyCode){
			$("branchName").value = "ALL BRANCHES";
		}
	});
	
	$("lineCd").observe("keyup", function(e){
		if (objKeyCode.BACKSPACE == e.keyCode){
			$("lineName").value = "ALL LINES";
		}
	}); */
	
	$("branchCd").observe("change", function(e){
		if($F("branchCd").trim() == "") {
			$("branchCd").value = "";
			$("branchName").value = "ALL BRANCHES";
			$("branchCd").setAttribute("lastValidValue", "");
		} else {
			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
				showBranchLOV();
			}
		}
	});
	
	$("lineCd").observe("change", function(e){
		if($F("lineCd").trim() == "") {
			$("lineCd").value = "";
			$("lineName").value = "ALL LINES";
			$("lineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("lineCd").trim() != "" && $F("lineCd") != $("lineCd").readAttribute("lastValidValue")) {
				showLineLOV();
			}
		}
	});
	
	$("searchBranch").observe("click", function(){
		showBranchLOV();
	});
	
	$("searchLine").observe("click", function(){
		showLineLOV();
	});
	
	$("fromDate").observe("focus", function(){
		if ($("toDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("fromDate")),Date.parse($("toDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","fromDate");
				this.clear();
			}
		}
	});
	
	$("toDate").observe("focus", function(){
		if ($("fromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("fromDate")),Date.parse($("toDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","toDate");
				this.clear();
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(/*validateBeforePrint()*/ checkAllRequiredFieldsInDiv("paramDiv") && checkAllRequiredFieldsInDiv("printerDiv")){
			printModifiedCommissions();
		}
	});
	
	function setRequiredBranch(){
		if ($F("billNo") == "" && $F("tranNo") == ""){
			$("branchCd").removeClassName("required");
			$("branchCdSpan").removeClassName("required");
			$("branchCd").setStyle({backgroundColor: 'white'});
			$("branchCdSpan").setStyle({backgroundColor: 'white'});	
		}else{
			$("branchCd").addClassName("required");
			$("branchCdSpan").addClassName("required");
			$("branchCd").setStyle({backgroundColor: '#FFFACD'});
			$("branchCdSpan").setStyle({backgroundColor: '#FFFACD'});	
		}
	}
	
	$("billNo").observe("change", function(){
		setRequiredBranch();
	});
	
	$("tranNo").observe("change", function(){
		setRequiredBranch();
	});
	
	whenNewFormInstance();
</script>