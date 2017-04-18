<div id="lossRatioMainDiv" class="sectionDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Loss Ratio</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div style="float:left;">
		<div id="parametersDiv" class="sectionDiv" style="border: none;">
			<fieldset style="width: 800px; margin-left: 50px;">
				<legend><b>Parameters</b></legend>
				<table> <!-- border=0 cellspacing=0 cellpadding=0> -->
					<tr>
						<td class="rightAligned" width="150px">Line</td>
						<td width="150px">
							<div id="lineCdDiv" style="float: left; width: 150px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtLineCd" title="Line Code" type="text" maxlength="2" style="float: left; width: 125px; margin: 0px; border: none;" tabindex="20401">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdLOV" name="imgLineCdLOV" alt="Go" style="float: right;"/>
							</div>
						<td>
						<td>
							<input type="text" id="txtLineName" style="width: 330px; height: 15px; margin: 0;" tabindex="20402" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="150px">Subline</td>
						<td width="150px">
							<div id="sublineCdDiv" style="float: left; width: 150px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtSublineCd" title="Subline Code" type="text" maxlength="7" style="float: left; width: 125px; margin: 0px; border: none;" tabindex="20403">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCdLOV" name="imgSublineCdLOV" alt="Go" style="float: right;"/>
							</div>
						<td>
						<td>
							<input type="text" id="txtSublineName" style="width: 330px; height: 15px; margin: 0;" tabindex="20404" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="150px">Branch</td>
						<td width="150px">
							<div id="branchCdDiv" style="float: left; width: 150px;   margin-left: 5px; border: 1px solid gray;">
								<input id="txtBranchCd" title="Branch Code" type="text" maxlength="2" style="float: left;   width: 125px; margin: 0px; border: none;" tabindex="20405">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdLOV" name="imgBranchCdLOV" alt="Go" style="float: right;"/>
							</div>
						<td>
						<td>
							<input type="text" id="txtBranchName" style="width: 330px; height: 15px; margin: 0;" tabindex="20406" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="150px">Intermediary</td>
						<td width="150px">
							<div id="intmNoDiv" style="float: left; width: 150px;   margin-left: 5px; border: 1px solid gray;">
								<input id="txtIntmNo" title="Intermediary Number" type="text" maxlength="12" style="float: left;   width: 125px; margin: 0px; border: none;" tabindex="20407">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntmNoLOV" name="imgIntmNoLOV" alt="Go" style="float: right;"/>
							</div>
						<td>
						<td>
							<input type="text" id="txtIntmName" style="width: 330px; height: 15px; margin: 0;" tabindex="20408" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="150px">Assured</td>
						<td width="150px">
							<div id="assuredNoDiv" style="float: left; width: 150px;   margin-left: 5px; border: 1px solid gray;">
								<input id="txtAssuredNo" title="Assured Number" type="text" maxlength="12" style="float: left;   width: 125px; margin: 0px; border: none;" tabindex="20409">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgAssuredNoLOV" name="imgAssuredNoLOV" alt="Go" style="float: right;"/>
							</div>
						<td>
						<td>
							<input type="text" id="txtAssuredName" style="width: 330px; height: 15px; margin: 0;" tabindex="20410" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="150px">Peril</td>
						<td width="150px">
							<div id="perilCdDiv" style="float: left; width: 150px;   margin-left: 5px; border: 1px solid gray;">
								<input id="txtPerilCd" title="Peril Code" type="text" maxlength="5" style="float: left;   width: 125px; margin: 0px; border: none;" tabindex="20411">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPerilCdLOV" name="imgPerilCdLOV" alt="Go" style="float: right;"/>
							</div>
						<td>
						<td>
							<input type="text" id="txtPerilName" style="width: 330px; height: 15px; margin: 0;" tabindex="20412" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">As of</td>
						<td colspan="2">
							<div id="asOfDateDiv" style="float: left; border: solid 1px gray; width: 150px; height: 20px; margin-left: 5px; margin-top: 2px;">
								<input type="text" id="txtAsOfDate" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 122px; border: none;" name="txtAsOfDate" readonly="readonly" tabindex="20413"/>
								<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
							</div>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
		<div style="float: left; width: 593px;">
			<div id="extractionTypeDiv" style="float: left;">
				<fieldset style="margin-left: 50px; width: 249px;">
					<legend><b>Extraction Type</b></legend>
					<div style="float: left; width: 180px; margin-left: 60px;">
						<input type="radio" id="rdoStraight" name="extracProc" style="float: left;" checked="checked"/><label for="rdoStraight" style="margin-top: 2px;">Straight</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px;">
						<input type="radio" id="rdoMethod24" name="extracProc" style="float: left;" /><label for="rdoMethod24" style="margin-top: 2px;">24th Method</label>
					</div>
				</fieldset>
			</div>
			<div id="claimBranchIsDiv" style="float: left;">
				<fieldset style="margin-left: 5px; width: 249px;">
					<legend><b>Claim Branch is</b></legend>
					<div style="float: left; width: 180px; margin-left: 60px;">
						<input type="radio" id="rdoClaimIssCd" name="issueOption" style="float: left;" checked="checked"/><label for="rdoClaimIssCd" style="margin-top: 2px;">Claim Issue Code</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px;">
						<input type="radio" id="rdoPolIssCd" name="issueOption" style="float: left;"/><label for="rdoPolIssCd" style="margin-top: 2px;">Policy Issue Code</label>
					</div>
				</fieldset>
			</div>
			<div style="float: left; width: 319px;">
				<div id="extractPolicyByDiv" style="float: left;">
					<fieldset style="margin-left: 50px; width: 249px;">
						<legend><b>Extract Policy By</b></legend>
						<div style="float: left; width: 180px; margin-left: 60px;">
							<input type="radio" id="rdoIssueDate" name="prntDate" style="float: left;" checked="checked"/><label for="rdoIssueDate" style="margin-top: 2px;">Issue Date</label>
						</div>
						<div style="float: left; width: 180px; margin-left: 60px;">
							<input type="radio" id="rdoEffDate" name="prntDate" style="float: left;"/><label for="rdoEffDate" style="margin-top: 2px;">Effectivity Date</label>
						</div>
						<div style="float: left; width: 180px; margin-left: 60px;">
							<input type="radio" id="rdoAcctEntryDate" name="prntDate" style="float: left;"/><label for="rdoAcctEntryDate" style="margin-top: 2px;">Accounting Entry Date</label>
						</div>
						<div style="float: left; width: 180px; margin-left: 60px;">
							<input type="radio" id="rdoBookingMoYear" name="prntDate" style="float: left;"/><label for="rdoBookingMoYear" style="margin-top: 2px;">Booking Month / Year</label>
						</div>
					</fieldset>
				</div>
				<div id="extractAmountByDiv" style="float: left;">
					<fieldset style="margin-left: 50px; width: 249px;">
						<legend><b>Extract Amount By</b></legend>
						<div style="float: left; width: 180px; margin-left: 60px;">
							<input type="radio" id="rdoNet" name="extractCat" style="float: left;" checked="checked"/><label for="rdoNet" style="margin-top: 2px;">Net</label>
						</div>
						<div style="float: left; width: 180px; margin-left: 60px;">
							<input type="radio" id="rdoGross" name="extractCat" style="float: left;"/><label for="rdoGross" style="margin-top: 2px;">Gross</label>
						</div>
					</fieldset>
				</div>
			</div>
			<div id="printReportDiv" style="float: left;">
				<fieldset style="margin-left: 5px; width: 249px; height: 134px;">
					<legend><b>Print Report</b></legend>
					<div style="float: left; width: 180px; margin-left: 60px; margin-top: 3px;">
						<input type="radio" id="rdoByLine" name="prntOption" class="prntOption" style="float: left;" checked="checked"/><label for="rdoByLine" style="margin-top: 2px;">By Line</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px; margin-top: 3px;">
						<input type="radio" id="rdoByLineSubline" name="prntOption" class="prntOption" style="float: left;"/><label for="rdoByLineSubline" style="margin-top: 2px;">By Line / Subline</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px; margin-top: 3px;">
						<input type="radio" id="rdoByIssSource" name="prntOption" class="prntOption" style="float: left;"/><label for="rdoByIssSource" style="margin-top: 2px;">By Issuing Source</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px; margin-top: 3px;">
						<input type="radio" id="rdoByIntm" name="prntOption" class="prntOption" style="float: left;"/><label for="rdoByIntm" style="margin-top: 2px;">By Intermediary</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px; margin-top: 3px;">
						<input type="radio" id="rdoByAssured" name="prntOption" class="prntOption" style="float: left;"/><label for="rdoByAssured" style="margin-top: 2px;">By Assured</label>
					</div>
					<div style="float: left; width: 180px; margin-left: 60px; margin-top: 3px;">
						<input type="radio" id="rdoByPeril" name="prntOption" class="prntOption" style="float: left;"/><label for="rdoByPeril" style="margin-top: 2px;">By Peril</label>
					</div>
				</fieldset>
			</div>
		</div>
		<div id="reportTypeDiv" style="float: left;">
			<fieldset style="margin-left: 5px; width: 250px; height: 193px;">
				<legend><b>Report Type</b></legend>
				<div style="float: left; width: 240px; margin-top: 5px; margin-bottom: 10px;">
					<input type="checkbox" id="chkSummary" style="float: left;"/><label for="chkSummary">Summary</label>
				</div>
				<div style="margin-bottom: 10px;">Detail</div>
				<div style="float: left; width: 200px; margin-left: 40px;">
					<div style="float: left;">
						<input type="checkbox" id="chkCurrPremDtl" style="float: left; "/><label for="chkCurrPremDtl">Premiums Written (C. Y.)</label>
					</div>
					<div style="float: left; margin-top: 6px;">
						<input type="checkbox" id="chkPrevPremDtl" style="float: left;"/><label for="chkPrevPremDtl">Premiums Written (P. Y.)</label>
					</div>
					<div style="float: left; margin-top: 6px;">
						<input type="checkbox" id="chkLossPaidDtl" style="float: left;"/><label for="chkLossPaidDtl">Losses Paid</label>
					</div>
					<div style="float: left; margin-top: 6px;">
						<input type="checkbox" id="chkCurrOsDtl" style="float: left;"/><label for="chkCurrOsDtl">Outstanding Loss (C. Y.)</label>
					</div>
					<div style="float: left; margin-top: 6px;">
						<input type="checkbox" id="chkPrevOsDtl" style="float: left;"/><label for="chkPrevOsDtl">Outstanding Loss (P. Y.)</label>
					</div>
					<div style="float: left; margin-top: 6px;">
						<input type="checkbox" id="chkCurrRecDtl" style="float: left;"/><label for="chkCurrRecDtl">Loss Recovery (C. Y.)</label>
					</div>
					<div style="float: left; margin-top: 6px;">
						<input type="checkbox" id="chkPrevRecDtl" style="float: left;"/><label for="chkPrevRecDtl">Loss Recovery (P. Y.)</label>
					</div>
				</div>
			</fieldset>
		</div>
	</div>
	<div id="buttonsDiv" text-align="center" style="float: left; margin-top: 16px; margin-bottom: 54px;">
		<input type="button" id="btnExtract" class="button" value="Extract" style="width: 150px; margin-left: 217px; "/>
		<input type="button" id="btnPrintReport" class="button" value="Print Report" style="width: 150px; margin-left: 10px;"/>
		<input type="button" id="btnViewLossRatioDtls" class="button" value="View Loss Ratio Details" style="width: 150px; margin-left: 10px;"/>
	</div>
	<div id="hiddenDiv">
		<input type="hidden" id="hidSessionId" />
		<input type="hidden" id="hidAsOfDate" />
		<input type="hidden" id="hidPrevYear" />
		<input type="hidden" id="hidCurr24" />
		<input type="hidden" id="hidCurr124" />
		<input type="hidden" id="hidPrev24" />
		<input type="hidden" id="hidPrev124" />
		<input type="hidden" id="hidLossPaidSw" />
		<input type="hidden" id="hidCurrPremSw" />
		<input type="hidden" id="hidPrevPremSw" />
		<input type="hidden" id="hidCurrOsSw" />
		<input type="hidden" id="hidPrevOsSw" />
		<input type="hidden" id="hidCurrRecSw" />
		<input type="hidden" id="hidPrevRecSw" />
		<input type="hidden" id="hidPrntOption" />
		<input type="hidden" id="hidPrntDate" />
	</div>
</div>
<div id="lossRatioDetailsDiv">
	<jsp:include page="/pages/claims/reports/lossRatio/lossRatioDetails/lossRatioDetails.jsp"></jsp:include>
</div>
<script type="text/JavaScript">
try{
	setModuleId("GICLS204");
	setDocumentTitle("Loss Ratio");
	
	var sessionId;
	var extract = false;
	$("txtLineCd").focus();
	
	function doKeyUp(id){
		$(id).observe("keyup", function(){
			$(id).value = $(id).value.toUpperCase();
		});
	}
	
	function enableExtractOnly(){
		enableButton("btnExtract");
		disableButton("btnPrintReport");
		disableButton("btnViewLossRatioDtls");
		$("chkSummary").checked = false;
		$("chkCurrPremDtl").checked = false;
		$("chkPrevPremDtl").checked = false;
		$("chkLossPaidDtl").checked = false;
		$("chkCurrOsDtl").checked = false;
		$("chkPrevOsDtl").checked = false;
		$("chkCurrRecDtl").checked = false;
		$("chkPrevRecDtl").checked = false;
		$("chkSummary").disabled = false;
		$("chkCurrPremDtl").disabled = false;
		$("chkPrevPremDtl").disabled = false;
		$("chkLossPaidDtl").disabled = false;
		$("chkCurrOsDtl").disabled = false;
		$("chkPrevOsDtl").disabled = false;
		$("chkCurrRecDtl").disabled = false;
		$("chkPrevRecDtl").disabled = false;
	}
	
	function showGicls204LineLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls204LineLOV",
					moduleId : "GICLS204",
					issCd : $F("txtBranchCd")
				},
				title : "Lines",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '90px',
				}, 
				{
					id : "lineName",
					title : "Line Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtSublineCd").clear();
					$("txtSublineName").value = "ALL SUBLINES";
					enableExtractOnly();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls204LineLOV", e);
		}
	}
	
	$("imgLineCdLOV").observe("click", showGicls204LineLOV);
	
	function showGicls204SublineLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls204SublineLOV",
					lineCd : $F("txtLineCd")
				},
				title : "Subline",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Code",
					width : '90px',
				}, 
				{
					id : "sublineName",
					title : "Subline Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					enableExtractOnly();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls204SublineLOV", e);
		}
	}
	
	$("imgSublineCdLOV").observe("click", function(){
		if($F("txtLineCd") == ""){
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtLineCd");			
		}else{
			showGicls204SublineLOV();	
		}
	});
	
	function showGicls204IssLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls204IssLOV",
					lineCd : $F("txtLineCd"),
					moduleId : "GICLS204"
				},
				title : "Branches",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '90px',
				}, 
				{
					id : "issName",
					title : "Branch Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = unescapeHTML2(row.issName);
					enableExtractOnly();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls204IssLOV", e);
		}
	}
	
	$("imgBranchCdLOV").observe("click", showGicls204IssLOV);
	
	function showGicls204IntmLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls204IntmLOV"
				},
				title : "Intermediary",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "intmNo",
					title : "Intermediary Number",
					width : '90px',
				}, 
				{
					id : "intmName",
					title : "Intermediary Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					enableExtractOnly();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls204IntmLOV", e);
		}
	}
	
	$("imgIntmNoLOV").observe("click", showGicls204IntmLOV);
	
	function showGicls204AssdLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls204AssdLOV"
				},
				title : "Assured",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "assdNo",
					title : "Assured Number",
					width : '90px',
				}, 
				{
					id : "assdName",
					title : "Assured Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtAssuredNo").value = row.assdNo;
					$("txtAssuredName").value = unescapeHTML2(row.assdName);
					enableExtractOnly();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls204AssdLOV", e);
		}
	}
	
	$("imgAssuredNoLOV").observe("click", showGicls204AssdLOV);
	
	function showGicls204PerilLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls204PerilLOV",
					lineCd : $F("txtLineCd")
				},
				title : "Peril",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "perilCd",
					title : "Peril Code",
					width : '90px',
				}, 
				{
					id : "perilName",
					title : "Peril Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtPerilCd").value = row.perilCd;
					$("txtPerilName").value = unescapeHTML2(row.perilName);
					enableExtractOnly();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls204PerilLOV", e);
		}
	}
	
	$("imgPerilCdLOV").observe("click", function(){
		if($F("txtLineCd") == ""){
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtLineCd");
		}else{
			showGicls204PerilLOV();	
		}
	});
	
	doKeyUp("txtLineCd");
	var prevLineCd;
	var prevLineName;
	$("txtLineCd").observe("focus", function(){
		prevLineCd = $F("txtLineCd");
		prevLineName = $F("txtLineName");
	});
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") == ""){
			$("txtLineName").value = "ALL LINES";
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtPerilCd").value = "";
			$("txtPerilName").value = "ALL PERILS";
			enableExtractOnly();
		}else{
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateLineCdGicls202",{
				parameters: {
					lineCd : $F("txtLineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("txtLineCd").value = prevLineCd;
						$("txtLineName").value = prevLineName; 
						customShowMessageBox("Line Code entered does not exist.", "I", "txtLineCd");
					}else{
						$("txtLineName").value = response.responseText;
						enableExtractOnly();
					}
				}
			});
		}
	});
	
	doKeyUp("txtSublineCd");
	var prevSublineCd;
	var prevSublineName;
	$("txtSublineCd").observe("focus", function(){
		prevSublineCd = $F("txtSublineCd");
		prevSublineName = $F("txtSublineName");
	});
	$("txtSublineCd").observe("change", function(){
		if($F("txtSublineCd") == ""){
			$("txtSublineName").value = "ALL SUBLINES";
			enableExtractOnly();
		}else{
			if($F("txtLineCd") == ""){
				$("txtSublineCd").clear();
				$("txtSublineName").value = "ALL SUBLINES";
				customShowMessageBox("Subline code cannot be entered if line code is not specified.", "I", "txtLineCd");
			}else{
				new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateSublineCdGicls202",{
					parameters: {
						lineCd : $F("txtLineCd"),
						sublineCd : $F("txtSublineCd")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(response.responseText == ""){
							$("txtSublineCd").value = prevSublineCd;
							$("txtSublineName").value = prevSublineName;
							customShowMessageBox("Subline Code entered does not exist.", "I", "txtSublineCd");
						}else{
							$("txtSublineName").value = response.responseText;
							enableExtractOnly();
						}
					}
				});	
			}
		}
	});
	
	doKeyUp("txtBranchCd");
	var prevBranchCd;
	var prevBranchName;
	$("txtBranchCd").observe("focus", function(){
		prevBranchCd = $F("txtBranchCd");
		prevBranchName = $F("txtBranchName");
	});
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") == ""){
			$("txtBranchCd").value = "";
			$("txtBranchName").value = "ALL BRANCHES";
			enableExtractOnly();
		}else{
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateIssCdGicls202",{
				parameters: {
					issCd : $F("txtBranchCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("txtBranchCd").value = prevBranchCd;
						$("txtBranchName").value = prevBranchName; 
						customShowMessageBox("Branch Code entered does not exist.", "I", "txtBranchCd");
					}else{
						$("txtBranchName").value = response.responseText;
						enableExtractOnly();
					}
				}
			});	
		}
	});
	
	doKeyUp("txtIntmNo");
	var prevIntmNo;
	var prevIntmName;
	$("txtIntmNo").observe("focus", function(){
		prevIntmNo = $F("txtIntmNo");
		prevIntmName = $F("txtIntmName");
	});
	$("txtIntmNo").observe("change", function(){
		if($F("txtIntmNo") == ""){
			$("txtIntmNo").value = "";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
			enableExtractOnly();
		}else{
			if(isNaN($F("txtIntmNo"))){
				$("txtIntmNo").value = prevIntmNo;
				$("txtIntmName").value = prevIntmName;
				customShowMessageBox("Invalid Intermediary Number. Valid value should be from 1 to 999999999999.", "I", "txtIntmNo");
			}else{
				new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateIntmNoGicls202",{
					parameters: {
						intmNo : $F("txtIntmNo")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(response.responseText != ""){
							$("txtIntmName").value = response.responseText;
							enableExtractOnly();
						}else{
							customShowMessageBox("Intermediary Code entered does not exist.", "I", "txtIntmNo");
							$("txtIntmNo").value = prevIntmNo;
							$("txtIntmName").value = prevIntmName;
						}
					}
				});	
			}
		}
	});
	
	var prevAssuredNo;
	var prevAssuredName;
	$("txtAssuredNo").observe("focus", function(){
		prevAssuredNo = $F("txtAssuredNo");
		prevAssuredName = $F("txtAssuredName");
	});
	$("txtAssuredNo").observe("change", function(){
		if($F("txtAssuredNo") == ""){
			$("txtAssuredNo").value = "";
			$("txtAssuredName").value = "ALL ASSURED";
			enableExtractOnly();
		}else{
			if(isNaN($F("txtAssuredNo"))){
				$("txtAssuredNo").value = prevAssuredNo;
				$("txtAssuredName").value = prevAssuredName;
				customShowMessageBox("Invalid Assured Number. Valid value should be from 1 to 999999999999.", "I", "txtAssuredNo");
			}else{
				new Ajax.Request(contextPath+"/GICLLossRatioController?action=validateAssdNoGicls204",{
					parameters: {
						assdNo : $F("txtAssuredNo")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(response.responseText != ""){
							$("txtAssuredName").value = response.responseText;
							enableExtractOnly();
						}else{
							customShowMessageBox("Assured Number entered does not exist.", "I", "txtAssuredNo");
							$("txtAssuredNo").value = prevAssuredNo;
							$("txtAssuredName").value = prevAssuredName;
						}
					}
				});	
			}
		}
	});
	
	var prevPerilCd;
	var prevPerilName;
	$("txtPerilCd").observe("focus", function(){
		prevPerilCd = $F("txtPerilCd");
		prevPerilName = $F("txtPerilName");
	});
	$("txtPerilCd").observe("change", function(){
		if($F("txtLineCd") == ""){
			$("txtPerilCd").clear();
			$("txtPerilName").value = "ALL PERILS";
			customShowMessageBox("Peril code cannot be entered if line code is not specified.", "I", "txtLineCd");
		}else{
			if($F("txtPerilCd") == ""){
				$("txtPerilCd").value = "";
				$("txtPerilName").value = "ALL PERILS";
				enableExtractOnly();
			}else{
				if(isNaN($F("txtPerilCd"))){
					$("txtPerilCd").value = prevPerilCd;
					$("txtPerilName").value = prevPerilName;
					customShowMessageBox("Invalid Peril Code. Valid value should be from 1 to 99999.", "I", "txtPerilCd");
				}else{
					new Ajax.Request(contextPath+"/GICLLossRatioController?action=validatePerilCdGicls204",{
						parameters: {
							lineCd : $F("txtLineCd"),
							perilCd : $F("txtPerilCd")
						},
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							if(response.responseText != ""){
								$("txtPerilName").value = response.responseText;
								enableExtractOnly();
							}else{
								customShowMessageBox("Peril Code entered does not exist.", "I", "txtPerilCd");
								$("txtPerilCd").value = prevPerilCd;
								$("txtPerilName").value = prevPerilName;
							}
						}
					});	
				}
			}
		}
	});
	
	$("rdoStraight").observe("click", function(){
		$("txtAsOfDate").value = new Date().toString('MM-dd-yyyy');
		$("hidAsOfDate").value = $F("txtAsOfDate");
	});
	
	$("rdoMethod24").observe("click", function(){
		if($F("txtAsOfDate").length != 7){
			$("hidAsOfDate").value = $F("txtAsOfDate");
			var substring = $F("txtAsOfDate").substring(3, 6);
			$("txtAsOfDate").value = $F("txtAsOfDate").replace(substring, "");	
		}
	});
	
	$("txtAsOfDate").observe("focus", function(){
		$("hidAsOfDate").value = $F("txtAsOfDate");
		var newDate = new Date().toString('MM-dd-yyyy');
		var date24 = newDate.replace(newDate.substring(3, 6), "");
		if($("rdoMethod24").checked){
			if($F("hidAsOfDate") > newDate){
				$("hidAsOfDate").value = newDate;
			}
			var newDateMo = newDate.substring(0, 2);
			var newDateYr = newDate.substring(6, 10);
			var date24Mo = $F("txtAsOfDate").substring(0, 2);
			var date24Yr;
			if($F("txtAsOfDate").length < 8){
				date24Yr = $F("txtAsOfDate").substring(3, 7);
			}else{
				date24Yr = $F("txtAsOfDate").substring(6, 10);
			}
			if(parseFloat(newDateYr) < parseFloat(date24Yr)){
				customShowMessageBox("Value entered cannot be greater than the current date.", "I", "txtAsOfDate");
				$("txtAsOfDate").value = date24;
			}else{
				if(newDateMo < date24Mo){
					customShowMessageBox("Value entered cannot be greater than the current date.", "I", "txtAsOfDate");
					$("txtAsOfDate").value = date24;
				}else{
					if($F("txtAsOfDate").length > 8){
						var substring = $F("txtAsOfDate").substring(3, 6);
						$("txtAsOfDate").value = $F("txtAsOfDate").replace(substring, "");	
					}
				}
			}
		}else{
			//if($F("txtAsOfDate") > newDate){
			if(Date.parse($F("txtAsOfDate"),"mm-dd-yyyy") > Date.parse(newDate,"mm-dd-yyyy")){ // bonok :: 7.27.2015 :: SR19948
				customShowMessageBox("Value entered cannot be greater than the current date.", "I", "txtAsOfDate");
				$("txtAsOfDate").value = new Date().toString('MM-dd-yyyy');
				return false;
			}
		}
		if(vDate != $F("txtAsOfDate")){
			enableExtractOnly();
		}
	});
	
	var vDate;
	$("imgAsOfDate").observe("click", function(){
		vDate = $F("txtAsOfDate");
		scwShow($("txtAsOfDate"),this, null);
	});
	
	function validateExtractGicls204(){
		if($("rdoByLineSubline").checked){
			if($F("txtLineCd") == ""){
				customShowMessageBox("Line code should be entered if printing is by line/subline.", "I", "txtLineCd");
				return false;
			}
		}
		if($("rdoByPeril").checked){
			if($F("txtLineCd") == ""){
				customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtLineCd");
				return false;
			}
		}
		extractGicls204();
	}
	
	function extractGicls204(){
		try{
			new Ajax.Request(contextPath+"/GICLLossRatioController?action=extractGicls204",{
				parameters: {
					assdNo : $F("txtAssuredNo"),
					date : $F("hidAsOfDate"),
					date24th : $F("txtAsOfDate"),
					extractCat : $("rdoNet").checked ? "N" : "G",
					extractProc : $("rdoStraight").checked ? "S" : "M",
					intmNo : $F("txtIntmNo"),	
					issCd : $F("txtBranchCd"),
					issueOption : $("rdoClaimIssCd").checked ? "1" : "2",
					lineCd : $F("txtLineCd"),
					perilCd : $F("txtPerilCd"),
					prntDate : $("rdoIssueDate").checked ? "1" : $("rdoEffDate").checked ? "2" : $("rdoAcctEntryDate").checked ? "3" : "4",
					prntOption : $("rdoByLine").checked ? "1" : $("rdoByLineSubline").checked ? "2" : $("rdoByIssSource").checked ? "3" : $("rdoByIntm").checked ? "4" : $("rdoByAssured").checked ? "5" : "6",
					sublineCd : $F("txtSublineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Extracting... "),
				onComplete: function(response){
					hideNotice("");
					var res = JSON.parse(response.responseText);
					if(res.count > 0){
						sessionId = res.sessionId;
						$("hidSessionId").value = res.sessionId;
						toggleReportTypeChk();
						toggleReportType(res);
					}else{
						showMessageBox("No records have been extracted.", "I");
					}
				}
			});
		}catch(e){
			showErrorMessage("GICLS204 - Extract: ", e);
		}
	}
	
	function toggleReportType(res){
		res.lossPaidSw == "Y" ? $("chkLossPaidDtl").disabled = false : $("chkLossPaidDtl").disabled = true; 
		res.currPremSw == "Y" ? $("chkCurrPremDtl").disabled = false : $("chkCurrPremDtl").disabled = true;
		res.prevPremSw == "Y" ? $("chkPrevPremDtl").disabled = false : $("chkPrevPremDtl").disabled = true;
		res.currOsSw == "Y" ? $("chkCurrOsDtl").disabled = false : $("chkCurrOsDtl").disabled = true;
		res.prevOsSw == "Y" ? $("chkPrevOsDtl").disabled = false : $("chkPrevOsDtl").disabled = true;
		res.currRecSw == "Y" ? $("chkCurrRecDtl").disabled = false : $("chkCurrRecDtl").disabled = true;
		res.prevRecSw == "Y" ? $("chkPrevRecDtl").disabled = false : $("chkPrevRecDtl").disabled = true;
		$("hidLossPaidSw").value = res.lossPaidSw;
		$("hidCurrPremSw").value = res.currPremSw;
		$("hidPrevPremSw").value = res.prevPremSw;
		$("hidCurrOsSw").value = res.currOsSw;
		$("hidPrevOsSw").value = res.prevOsSw;
		$("hidCurrRecSw").value = res.currRecSw;
		$("hidPrevRecSw").value = res.prevRecSw;
		$("hidPrevYear").value = res.prevYear;
		$("hidCurr24").value = res.curr24;
		$("hidCurr124").value = res.curr124;
		$("hidPrev24").value = res.prev24;
		$("hidPrev124").value = res.prev124;
		extract = true;
		showMessageBox("Finished extracting "+res.count+" record(s).", "I");
		clearPrevTabs();
 	}
	
	function toggleReportTypeChk(){
		$("chkSummary").checked = false;
		$("chkLossPaidDtl").checked = false;
		$("chkCurrPremDtl").checked = false;
		$("chkPrevPremDtl").checked = false;
		$("chkCurrOsDtl").checked = false;
		$("chkPrevOsDtl").checked = false;
		$("chkCurrRecDtl").checked = false;
		$("chkPrevRecDtl").checked = false;
		vDate = $F("txtAsOfDate");	
		disableButton("btnExtract");
		enableButton("btnPrintReport");
		if(checkUserModule('GICLS205')){
			enableButton("btnViewLossRatioDtls");
		}
	}
	
	$("btnExtract").observe("click", validateExtractGicls204);
	
	function getChkParams(id, paramName){
		var params = "";
		if($(id).checked){
			params = params + "&"+paramName+"=Y";
		}else{
			params = params + "&"+paramName+"=N";
		}
		return params;
	}
	
	function getRdoParams(id, paramName){
		var params = "";
		var j = 1;
		for(var i = 0 ; i < id.length; i++){
			if($(id[i]).checked){		
				params = params + "&"+paramName+"="+j;
				return params;
			}	
			j++;
		}
	}
	
	var lastDay;
	var detailReportDate;
	function getDetailReportDate(){
		var params = "";
		new Ajax.Request(contextPath+"/GICLLossRatioController?action=getDetailReportDate",{
			parameters: {
				date : $F("txtAsOfDate"),
				extractProc : $("rdoStraight").checked ? "S" : "M"
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				params = params + "&prevYear=" + res.prevYear + "&currYear=" + res.currYear + "&currStartDate=" + res.curr1Date 
		         				+ "&currEndDate=" + res.curr2Date + "&prevEndDate=" + res.prev2Date;
				detailReportDate = params;	
				lastDay = res.date;
			}
		});
	}
	
	function getParamsGicls204(reportId){
		var params = "&sessionId="+sessionId+"&lineCd="+$F("txtLineCd")+"&sublineCd="+$F("txtSublineCd")+"&issCd="+$F("txtBranchCd")
					 +"&intmNo="+$F("txtIntmNo")+"&assdNo="+$F("txtAssuredNo")+"&perilCd="+$F("txtPerilCd");
		if($("rdoStraight").checked){
			params = params + "&date=" + $F("txtAsOfDate");
		}else{
			getDetailReportDate();
			params = params + "&date=" + lastDay;
		}
		if(reportId == "GICLR204A2" || reportId == "GICLR204A3" || reportId == "GICLR204B2" || reportId == "GICLR204B3" || reportId == "GICLR204C2"
		   || reportId == "GICLR204C3" || reportId == "GICLR204D2" || reportId == "GICLR204D3" || reportId == "GICLR204E2" || reportId == "GICLR204E3"
		   || reportId == "GICLR204F2" || reportId == "GICLR204F3"
		   || reportId == "GICLR204A2_PREM_WRIT_CY" || reportId == "GICLR204A2_PREM_WRIT_PY" || reportId == "GICLR204A2_OS_LOSS_CY" || reportId == "GICLR204A2_OS_LOSS_PY" // added by kevin 4-8-2016 SR-5384
		   || reportId == "GICLR204A2_LOSSES_PAID" || reportId == "GICLR204A2_LOSS_RECO_CY" || reportId == "GICLR204A2_LOSS_RECO_PY" // added by kevin 4-8-2016 SR-5384
		   || reportId == "GICLR204C2_Premiums_Written_CY" || reportId == "GICLR204C2_Premiums_Written_PY" || reportId == "GICLR204C2_Outstanding_Loss_CY" //added by Kevin 4-12-2016 SR-5389
		   || reportId == "GICLR204C2_Outstanding_Loss_PY" ||  reportId =="GICLR204C2_Losses_Paid" ||  reportId == "GICLR204C2_Loss_Recovery_CY" ||  reportId == "GICLR204C2_Loss_Recovery_PY" //added by Kevin 4-12-2016 SR-5389
		   || reportId == "GICLR204A3_PREM_WRITTEN_CY" || reportId == "GICLR204A3_PREM_WRITTEN_PY" || reportId == "GICLR204A3_LOSSES_PAID" // start: added by Kevin 4-11-2016 SR-5385
		   || reportId == "GICLR204A3_OS_LOSS_CY" || reportId == "GICLR204A3_OS_LOSS_PY" || reportId == "GICLR204A3_LOSS_RECO_CY" || reportId == "GICLR204A3_LOSS_RECO_PY" //end: kevin SR-5385
		   || reportId == "GICLR204F2" || reportId == "GICLR204F3" || reportId == "GICLR204F2_PW_CY" || reportId == "GICLR204F2_PW_PY" // added by carlo de guzman 3.28.2016 for SR5395 --start
		   || reportId == "GICLR204F2_OS_LOSS_CY" || reportId == "GICLR204F2_OS_LOSS_PY" || reportId == "GICLR204F2_LOSSES_PAID" || reportId == "GICLR204F2_LOSS_RECO_CY"
		   || reportId == "GICLR204F2_LOSS_RECO_PY" // added by carlo de guzman 3.28.2016 for SR5395 --end 
		   || reportId == "GICLR204F2" || reportId == "GICLR204F3"  || reportId == "GICLR204D2_PW_CY" || reportId == "GICLR204D2_PW_PY" 
		   || reportId == "GICLR204D2_OS_CY" || reportId == "GICLR204D2_OS_PY" || reportId == "GICLR204D2_LP" 
		   || reportId == "GICLR204D2_LR_CY" || reportId == "GICLR204D2_LR_PY" //added GICLR204D2_* reports - John Daniel Marasigan 03/22/2016
		   || reportId == "GICLR204F2" || reportId == "GICLR204F3" 
		   || reportId == "GICLR204E2_LP" || reportId == "GICLR204E2_PW_CY" || reportId == "GICLR204E2_PW_PY" //added by Mary Cris Invento 3/23/2016 SR 5392
		   || reportId == "GICLR204E2_OS_CY" || reportId == "GICLR204E2_OS_PY" || reportId == "GICLR204E2_LR_CY" || reportId == "GICLR204E2_LR_PY" //added by Mary Cris Invento 3/23/2016 SR 5392
		   || reportId == "GICLR204E3_LP" || reportId == "GICLR204E3_PW_CY" || reportId == "GICLR204E3_PW_PY" //Added by Carlo Rubenecia SR 5393 05.31.2016 -START
		   || reportId == "GICLR204E3_OS_CY" || reportId == "GICLR204E3_OS_PY" || reportId == "GICLR204E3_LR_CY" || reportId == "GICLR204E3_LR_PY"  //Added by Carlo Rubenecia SR 5393 05.31.2016 -END
		   || reportId == "GICLR204B2_Loss_Recovery_CY_CSV" || reportId == "GICLR204B2_Loss_Recovery_PY_CSV" || reportId == "GICLR204B2_Losses_Paid_CSV" //added by Kevin SR-5387 6-17-2016
		   || reportId == "GICLR204B2_Outstanding_Loss_CY_CSV" || reportId == "GICLR204B2_Outstanding_Loss_PY_CSV" || reportId == "GICLR204B2_Premiums_Written_CY_CSV" || reportId == "GICLR204B2_Premiums_Written_PY_CSV" //added by Kevin SR-5387 6-17-2016
		   || reportId == "GICLR204F3_PW_CY" || reportId == "GICLR204F3_PW_PY" || reportId == "GICLR204F3_OS_LOSS_CY" // added by carlo de guzman 3.28.2016 for SR5395 --START
		   || reportId == "GICLR204F3_OS_LOSS_PY" || reportId == "GICLR204F3_LOSSES_PAID" || reportId == "GICLR204F3_LOSS_RECO_CY"
		   || reportId == "GICLR204F3_LOSS_RECO_PY"  // added by carlo de guzman 3.28.2016 for SR5396 --END
		   || reportId == "GICLR204B3_PREV_RECOVERY_CSV" || reportId == "GICLR204B3_PREV_PREM_CSV" || reportId == "GICLR204B3_LOSSES_PAID_CSV" //SR-5388
		   || reportId == "GICLR204B3_CURR_RECOVERY_CSV" || reportId == "GICLR204B3_CURR_LOSS_CSV" || reportId == "GICLR204B3_CURR_PREM_CSV" || reportId == "GICLR204B3_PREV_LOSS_CSV"){
			getDetailReportDate();
			var prntDate = ["rdoIssueDate", "rdoEffDate", "rdoAcctEntryDate", "rdoBookingMoYear"];
			params = params + getChkParams("chkCurrPremDtl", "currPrem") + getChkParams("chkPrevPremDtl", "prevPrem")
				+ getChkParams("chkCurrOsDtl", "currOs") + getChkParams("chkPrevOsDtl", "prevOs")
				+ getChkParams("chkLossPaidDtl", "lossPaid") + getChkParams("chkCurrRecDtl", "currRec")
				+ getChkParams("chkPrevRecDtl", "prevRec") + "&prevYear=" + $F("hidPrevYear")
				+ getRdoParams(prntDate, "prntDate") + detailReportDate;
			if($("rdoMethod24").checked){
				params = params + "&curr24=" + $F("hidCurr24") + "&curr124=" + $F("hidCurr124") + "&prev24=" + $F("hidPrev24") + "&prev124=" + $F("hidPrev124");
			}
		}
		return params;
	}
	
	var reports = [];
	function printReportGicls204(reportId, reportTitle){
		var content;
		content = contextPath+"/PrintLossRatioController?action=printReportGicls204&reportId="+reportId+"&printerName="+$F("selPrinter")					
				+getParamsGicls204(reportId);
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : reportTitle});		
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						showMessageBox("Printing Completed.", "S");
					}
				}
			});
		}else if("file" == $F("selDestination")){
			var fileType = "PDF";
			
			if($("rdoPdf").checked){
				fileType = "PDF";
			/*else if ($("rdoExcel").checked) removed by carlo de guzman 3.18.2016
				fileType = "XLS";*/
			}else if ($("rdoCsv").checked && reportId.contains("_CSV")){ //added by Kevin SR-5387 6-17-2016
				fileType = "CSV2";
			}else if ($("rdoCsv").checked){
				fileType = "CSV";
			}
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
			         	      fileType    : fileType},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var repType = (fileType == "CSV" || fileType == "CSV2") ? "csv" : "reports"; // CSV2 added by Kevin SR-5387 6-17-2016
						
						if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
							showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
						} else {
							var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, repType);
							if(fileType == "CSV"){
								deleteCSVFileFromServer(response.responseText);
							}
							if(message.include("SUCCESS")){
								showMessageBox("Report file generated to " + message.substring(9), "I");	
							} else {
								showMessageBox(message, "E");
							}
						}
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
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
		
	}
	
	function onOkPrintGicls204(){
		if($("chkSummary").checked){
			if($("rdoByLine").checked){
				printReportGicls204("GICLR204A", "Loss Ratio");
			}else if($("rdoByLineSubline").checked){
				printReportGicls204("GICLR204B", "Loss Ratio");
			}else if($("rdoByIssSource").checked){
				printReportGicls204("GICLR204C", "Loss Ratio");
			}else if($("rdoByIntm").checked){
				printReportGicls204("GICLR204D", "Loss Ratio");
			}else if($("rdoByAssured").checked){
				printReportGicls204("GICLR204E", "Loss Ratio Assured");
			}else if($("rdoByPeril").checked){
				printReportGicls204("GICLR204F", "Loss Ratio Per Peril");
			}
		}
		if($("chkLossPaidDtl").checked || $("chkCurrPremDtl").checked || $("chkPrevPremDtl").checked ||
		   $("chkCurrOsDtl").checked || $("chkPrevOsDtl").checked || $("chkCurrRecDtl").checked || $("chkPrevRecDtl").checked){
			if($("rdoByLine").checked){
				if($("rdoStraight").checked){
					if($("rdoCsv").checked && $F("selDestination") == "file"){ // start: added by carlo de guzman 3.21.2016 SR-5384
						var report = []; 
						if($("chkCurrOsDtl").checked){
					    	report.push({reportId:"GICLR204A2_OS_LOSS_CY", reportTitle:"Loss Ratio Per Line Detail Report"});
						}
	 					if($("chkPrevOsDtl").checked){
	 						report.push({reportId:"GICLR204A2_OS_LOSS_PY", reportTitle:"Loss Ratio Per Line Detail Report"});
	 					}
	 					if($("chkCurrPremDtl").checked){
	 						report.push({reportId:"GICLR204A2_PREM_WRIT_CY", reportTitle:"Loss Ratio Per Line Detail Report"});	
	 					}
	 					if($("chkPrevPremDtl").checked){
	 						report.push({reportId:"GICLR204A2_PREM_WRIT_PY", reportTitle:"Loss Ratio Per Line Detail Report"});
		 				}
	 					if($("chkLossPaidDtl").checked){
	 						report.push({reportId:"GICLR204A2_LOSSES_PAID", reportTitle:"Loss Ratio Per Line Detail Report"});
		 				}
	 					if($("chkCurrRecDtl").checked){
	 						report.push({reportId:"GICLR204A2_LOSS_RECO_CY", reportTitle:"Loss Ratio Per Line Detail Report"});
		 				}
	 					if($("chkPrevRecDtl").checked){
	 						report.push({reportId:"GICLR204A2_LOSS_RECO_PY", reportTitle:"Loss Ratio Per Line Detail Report"});
		 				}
	 					for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}
				    }else{
						printReportGicls204("GICLR204A2", "Loss Ratio Per Line Detail Report");
					} // end: carlo de guzman SR-5384
				}else{
					if($("rdoCsv").checked){    // start: added by carlo de guzman SR-5385
						var report = [];
						if($("chkCurrOsDtl").checked && $F("selDestination") == "file"){
					    	report.push({reportId:"GICLR204A3_OS_LOSS_CY", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});
						}
	 					if($("chkPrevOsDtl").checked){
	 						report.push({reportId:"GICLR204A3_OS_LOSS_PY", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});
	 					}
	 					if($("chkCurrPremDtl").checked){
	 						report.push({reportId:"GICLR204A3_PREM_WRITTEN_CY", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});	
	 					}
	 					if($("chkPrevPremDtl").checked){
	 						report.push({reportId:"GICLR204A3_PREM_WRITTEN_PY", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});
		 				}
	 					if($("chkLossPaidDtl").checked){
	 						report.push({reportId:"GICLR204A3_LOSSES_PAID", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});
		 				}
	 					if($("chkCurrRecDtl").checked){
	 						report.push({reportId:"GICLR204A3_LOSS_RECO_CY", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});
		 				}
	 					if($("chkPrevRecDtl").checked){
	 						report.push({reportId:"GICLR204A3_LOSS_RECO_PY", reportTitle:"Loss Ratio Per Line Detail Report(24 Method)"});
		 				}
	 					for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}						
					}else{
						printReportGicls204("GICLR204A3", "Loss Ratio Per Line Detail Report(24 Method)");
					} // end carlo de guzman SR-5385
				}
			}else if($("rdoByLineSubline").checked){
				if($("rdoStraight").checked){
					if ($("rdoCsv").checked && $F("selDestination") == "file") {
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204B2_Losses_Paid_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204B2_Premiums_Written_CY_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204B2_Premiums_Written_PY_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204B2_Outstanding_Loss_CY_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204B2_Outstanding_Loss_PY_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204B2_Loss_Recovery_CY_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204B2_Loss_Recovery_PY_CSV", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}													
					}else{
						printReportGicls204("GICLR204B2", "Loss Ratio Per Line/Subline Report");
					}
				}else if($("rdoMethod24").checked){
					if ($("rdoCsv").checked && $F("selDestination")=="file"){
						var report = []; 
						if($("chkCurrOsDtl").checked){
					    	report.push({reportId:"GICLR204B3_CURR_LOSS_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});
						}
	 					if($("chkPrevOsDtl").checked){
	 						report.push({reportId:"GICLR204B3_PREV_LOSS_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});
	 					}
	 					if($("chkCurrPremDtl").checked){
	 						report.push({reportId:"GICLR204B3_CURR_PREM_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});	
	 					}
	 					if($("chkPrevPremDtl").checked){
	 						report.push({reportId:"GICLR204B3_PREV_PREM_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});
		 				}
	 					if($("chkLossPaidDtl").checked){
	 						report.push({reportId:"GICLR204B3_LOSSES_PAID_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});
		 				}
	 					if($("chkCurrRecDtl").checked){
	 						report.push({reportId:"GICLR204B3_CURR_RECOVERY_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});
		 				}
	 					if($("chkPrevRecDtl").checked){
	 						report.push({reportId:"GICLR204B3_PREV_RECOVERY_CSV", reportTitle:"Loss Ratio Per Line/Subline Report(24 Method)"});
		 				}
	 					for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}
					}else{
						printReportGicls204("GICLR204B3", "Loss Ratio Per Line/Subline Report(24 Method)");
					}
				}
			}else if($("rdoByIssSource").checked){
				if($("rdoStraight").checked){
					if ($("rdoCsv").checked && $F("selDestination") == "file") {			// added for CSV PRINT GICLR204C2 by Elar Campañano 3/23/2016 SR-5389
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204C2_Losses_Paid", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204C2_Premiums_Written_CY", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204C2_Premiums_Written_PY", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204C2_Outstanding_Loss_CY", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204C2_Outstanding_Loss_PY", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204C2_Loss_Recovery_CY", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204C2_Loss_Recovery_PY", reportTitle:"Loss Ratio Per Issuing Source Detail Report"});
						}
						
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}													
					}else {		
						printReportGicls204("GICLR204C2", "Loss Ratio Per Issuing Source Detail Report");
					}	//end of GICLR204C2 SR-5389
				}else{					
					if ($("rdoCsv").checked) {
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204C3_LP", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204C3_PW_CY", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204C3_PW_PY", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204C3_OS_CY", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204C3_OS_PY", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204C3_LR_CY", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204C3_LR_PY", reportTitle:"Loss Ratio Per Issuing Source Detail Report(24 Method)"});
						}
						
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}													
					}else {		
						printReportGicls204("GICLR204C3", "Loss Ratio Per Issuing Source Detail Report(24 Method)");
					}
				}
			}else if($("rdoByIntm").checked){
				if($("rdoStraight").checked){
					if ($("rdoCsv").checked) { //start: added for GICLR204D2 csv printing - John Daniel Marasigan
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204D2_LP", reportTitle:"Loss Ratio Per Intermediary Detail Report"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204D2_PW_CY", reportTitle:"Loss Ratio Per Intermediary Detail Report"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204D2_PW_PY", reportTitle:"Loss Ratio Per Intermediary Detail Report"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204D2_OS_CY", reportTitle:"Loss Ratio Per Intermediary Detail Report"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204D2_OS_PY", reportTitle:"Loss Ratio Per Intermediary Detail Report"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204D2_LR_CY", reportTitle:"Loss Ratio Per Intermediary Detail Report"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204D2_LR_PY", reportTitle:"Loss Ratio Per Intermediarys Detail Report"});
						}
						
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}
					} else {
						printReportGicls204("GICLR204D2", "Loss Ratio Per Intermediary Detail Report");
					}
					// end: GICLR204D2 csv printing
				}else{
					if ($("rdoCsv").checked) {
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204D3_LP", reportTitle:"Loss Ratio Per Intermediary Detail Report(24 Method)"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204D3_PW_CY", reportTitle:"Loss Ratio Per Intermediary Detail Report(24 Method)"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204D3_PW_PY", reportTitle:"Loss Ratio Per Intermediary Detail Report(24 Method)"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204D3_OS_CY", reportTitle:"Loss Ratio Per Intermediary Detail Report(24 Method)"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204D3_OS_PY", reportTitle:"Loss Ratio Per Intermediary Detail Report(24 Method)"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204D3_LR_CY", reportTitle:"Loss Ratio Per Intermediary Detail Report(24 Method)"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204D3_LR_PY", reportTitle:"Loss Ratio Per Intermediarys Detail Report(24 Method)"});
						}
						
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}													
					}else {		
						printReportGicls204("GICLR204D3", "Loss Ratio Per Intermediary Detail Report(24 Method)");
					}
				}
			}else if($("rdoByAssured").checked){
				if($("rdoStraight").checked){
					//printReportGicls204("GICLR204E2", "Loss Ratio Per Assured Detail Report"); removed by Mary Cris Invento 3/23/2016 SR 5392
					if ($("rdoCsv").checked && $F("selDestination") == "file") { //added by Mary Cris Invento 3/23/2016 SR 5392 --start
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204E2_LP",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204E2_PW_CY",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204E2_PW_PY",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204E2_OS_CY",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204E2_OS_PY",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204E2_LR_CY",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204E2_LR_PY",
							reportTitle:"Loss Ratio Per Assured Detail Report"});
						}
						
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}
						
					}else{
						printReportGicls204("GICLR204E2", "Loss Ratio Per Assured Detail Report"); //added by Mary Cris Invento 3/23/2016 SR 5392 --end
					}
				}else{
					if ($("rdoCsv").checked) {//Added by Carlo Rubenecia 5393 05.31.2016 Start
						var report = [];
						if ($("chkLossPaidDtl").checked == true){
							report.push({reportId:"GICLR204E3_LP", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						if ($("chkCurrPremDtl").checked == true){
							report.push({reportId:"GICLR204E3_PW_CY", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						if ($("chkPrevPremDtl").checked == true){
							report.push({reportId:"GICLR204E3_PW_PY", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						if ($("chkCurrOsDtl").checked == true){
							report.push({reportId:"GICLR204E3_OS_CY", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						if ($("chkPrevOsDtl").checked == true){
							report.push({reportId:"GICLR204E3_OS_PY", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						if ($("chkCurrRecDtl").checked == true){
							report.push({reportId:"GICLR204E3_LR_CY", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						if ($("chkPrevRecDtl").checked == true){
							report.push({reportId:"GICLR204E3_LR_PY", reportTitle:"Loss Ratio Per Assured Detail Report(24 Method)"});
						}
						
						for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}//Added by Carlo Rubenecia 5393 05.31.2016 End	
					}else{
					printReportGicls204("GICLR204E3", "Loss Ratio Per Assured Detail Report(24 Method)");
					}
				}
			}else if($("rdoByPeril").checked){
				if($("rdoStraight").checked){
					// printReportGicls204("GICLR204F2", "Loss Ratio Per Peril Detail Report"); removed by carlo de guzman 3.23.2016 for SR5395
					if($("rdoCsv").checked && $F("selDestination") == "file"){ // added by carlo de guzman 3.23.2016 for SR5395
					var report = []; 
					 
					if($("chkCurrOsDtl").checked){
				    report.push({reportId:"GICLR204F2_OS_LOSS_CY", reportTitle:"Loss Ratio Per Peril Detail Report"});
					}
 					if($("chkPrevOsDtl").checked){
 					report.push({reportId:"GICLR204F2_OS_LOSS_PY", reportTitle:"Loss Ratio Per Peril Detail Report"});
 					}
 					if($("chkCurrPremDtl").checked){
 					report.push({reportId:"GICLR204F2_PW_CY", reportTitle:"Loss Ratio Per Peril Detail Report"});	
 					}
 					if($("chkPrevPremDtl").checked){
 					report.push({reportId:"GICLR204F2_PW_PY", reportTitle:"Loss Ratio Per Peril Detail Report"});
	 				}
 					if($("chkLossPaidDtl").checked){
 					report.push({reportId:"GICLR204F2_LOSSES_PAID", reportTitle:"Loss Ratio Per Peril Detail Report"});
	 				}
 					if($("chkCurrRecDtl").checked){
 					report.push({reportId:"GICLR204F2_LOSS_RECO_CY", reportTitle:"Loss Ratio Per Peril Detail Report"});
	 				}
 					if($("chkPrevRecDtl").checked){
 					report.push({reportId:"GICLR204F2_LOSS_RECO_PY", reportTitle:"Loss Ratio Per Peril Detail Report"});
	 				}
 					for(var i=0; i < report.length; i++){
						printReportGicls204(report[i].reportId, report[i].reportTitle);	
					}	
 					
				    }else{
						printReportGicls204("GICLR204F2", "Loss Ratio Per Peril Detail Report");
				         } // end for SR5395
				}else{
					//	printReportGicls204("GICLR204F3", "Loss Ratio Per Peril Detail Report(24 Method)"); removed by carlo de guzman 3.23.2016 for SR5396
					 if($("rdoCsv").checked){ // added by carlo de guzman 3.23.2016 for SR5396 -START
						var report = [];
						 
						if($("chkCurrOsDtl").checked && $F("selDestination") == "file"){
					    report.push({reportId:"GICLR204F3_OS_LOSS_CY", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});
						}
	 					if($("chkPrevOsDtl").checked){
	 					report.push({reportId:"GICLR204F3_OS_LOSS_PY", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});
	 					}
	 					if($("chkCurrPremDtl").checked){
	 					report.push({reportId:"GICLR204F3_PW_CY", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});	
	 					}
	 					if($("chkPrevPremDtl").checked){
	 					report.push({reportId:"GICLR204F3_PW_PY", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});
		 				}
	 					if($("chkLossPaidDtl").checked){
	 					report.push({reportId:"GICLR204F3_LOSSES_PAID", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});
		 				}
	 					if($("chkCurrRecDtl").checked){
	 					report.push({reportId:"GICLR204F3_LOSS_RECO_CY", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});
		 				}
	 					if($("chkPrevRecDtl").checked){
	 					report.push({reportId:"GICLR204F3_LOSS_RECO_PY", reportTitle:"Loss Ratio Per Peril Detail Report(24 Method)"});
		 				}
	 					for(var i=0; i < report.length; i++){
							printReportGicls204(report[i].reportId, report[i].reportTitle);	
						}						
					}else{
							printReportGicls204("GICLR204F3", "Loss Ratio Per Peril Detail Report(24 Method)");
					 } // end for SR5395for SR5396
				}
			}		
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
		
	}
	
	function validatePrintGicls204(){
		if(vDate == $F("txtAsOfDate")){
			if($("chkSummary").checked || $("chkLossPaidDtl").checked || $("chkCurrPremDtl").checked || $("chkPrevPremDtl").checked ||
			   $("chkCurrOsDtl").checked || $("chkPrevOsDtl").checked || $("chkCurrRecDtl").checked || $("chkPrevRecDtl").checked){
				showGenericPrintDialog("Print Loss Ratio", onOkPrintGicls204, function(){
					$("csvOptionDiv").show(); //marco - 07.21.2014
				}, true);	
			}else{
				customShowMessageBox("Please select what report(s) you want to print.", "I", "chkCurrPremDtl");
			}	
		}else{
			enableExtractOnly();
			customShowMessageBox("Parameter for date is changed. Please press EXTRACT button first.", "I", "btnExtract");
		}
	}
	
	$("btnPrintReport").observe("click", validatePrintGicls204);
	
	function toggleRadioButtons(){
		$$("input[type='radio']").each(function(c){
			$(c).observe("change", function(){
				enableExtractOnly();
			});
		});
	}
	
	toggleRadioButtons();
	$("txtAsOfDate").value = new Date().toString('MM-dd-yyyy');
	$("hidAsOfDate").value = $F("txtAsOfDate");
	$("txtLineName").value = "ALL LINES";
	$("txtSublineName").value = "ALL SUBLINES";
	$("txtBranchName").value = "ALL BRANCHES";
	$("txtIntmName").value = "ALL INTERMEDIARIES";
	$("txtAssuredName").value = "ALL ASSURED";
	$("txtPerilName").value = "ALL PERILS";
	disableButton("btnPrintReport");
	disableButton("btnViewLossRatioDtls");
	observeReloadForm("reloadForm", showGICLS204);
	$("lossRatioDetailsDiv").hide();
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	});
	
	function setCurrentTab1(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	function setCurrentTab2(id){
		$$("div.tabComponents2 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab2");					
			}else{
				a.up("li").removeClassName("selectedTab2");	
			}	
		});
	}
	
	var tabs = [];
	function toggleTab(mainTab, currSw, prevSw, currTab, prevTab){
		if(currSw != "Y" && prevSw != "Y"){
			disableTab(mainTab);
			$(mainTab+"Disabled").setStyle('margin-top: 5px');
			tabs.push(mainTab);			
		}
		if(currSw != "Y"){
			disableTab2(currTab);
			$(currTab+"Disabled").setStyle('margin-top: 2px');
			tabs.push(currTab);
		}
		if(prevSw != "Y"){
			disableTab2(prevTab);
			$(prevTab+"Disabled").setStyle('margin-top: 2px');
			tabs.push(prevTab);
		}
	}
	
	function setYearTab(currSw, currTab, prevTab){
		if(currSw == "Y"){
			//fireEvent($(currTab), "click");
			setCurrentTab2(currTab);
		}else{
			//fireEvent($(prevTab), "click");
			setCurrentTab2(prevTab);
		}
	}
	
	function toggleTabs(){
		toggleTab("premiumsWrittenTab", $F("hidCurrPremSw"), $F("hidPrevPremSw"), "premWrittenCurrTab", "premWrittenPrevTab");
		toggleTab("outstandingLossTab", $F("hidCurrOsSw"), $F("hidPrevOsSw"), "outLossCurrTab", "outLossPrevTab");
		toggleTab("lossRecoveryTab", $F("hidCurrRecSw"), $F("hidPrevRecSw"), "lossRecCurrTab", "lossRecPrevTab");
		
		if($F("hidLossPaidSw") != "Y"){
			disableTab("lossPaidTab");
			$("lossPaidTabDisabled").setStyle('margin-top: 5px');
			tabs.push("lossPaidTab");
		}
		
		setYearTab($F("hidCurrPremSw"), "premWrittenCurrTab", "premWrittenPrevTab");
		setYearTab($F("hidCurrOsSw"), "outLossCurrTab", "outLossPrevTab");
		setYearTab($F("hidCurrRecSw"), "lossRecCurrTab", "lossRecPrevTab");
	}
	
	function clearPrevTabs(){
		for(var i = 0; i < tabs.length; i++){
			$(tabs[i]+"Disabled").remove();
			$(tabs[i]).show();
		}
		tabs = [];
	}
	
	$("btnViewLossRatioDtls").observe("click", function(){
		fireEvent($("lossRatioSummaryTab"), "click");
		$("lossRatioMainDiv").hide();
		$("lossRatioDetailsDiv").show();
		if(extract){
			toggleTabs();	
		}
		extract = false;
		setModuleId("GICLS205");
		setDocumentTitle("Loss Ratio Details");
	});
}catch(e){
	showErrorMessage("Error on Loss Ratio page.",e);
}
</script>