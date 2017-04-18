<div id="lossRatioDetailsMainDiv" class="sectionDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExitLossRatioDetails">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Loss Ratio Detail</label>
		</div>
	</div>
	<div id="parametersDiv" class="sectionDiv" style="margin-top: 10px; margin-bottom: 10px; border: none;">
		<table>
			<tr>
				<td class="rightAligned" width="112px">Line</td>
				<td>
					<input type="text" id="txtDspLineCd" style="width: 60px;" readonly="readonly"/>
					<input type="text" id="txtDspLineName" style="width: 250px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" width="100px">Intermediary</td>
				<td>
					<input type="text" id="txtDspIntmNo" style="width: 60px; text-align: right;" readonly="readonly"/>
					<input type="text" id="txtDspIntmName" style="width: 250px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline</td>
				<td>
					<input type="text" id="txtDspSublineCd" style="width: 60px;" readonly="readonly"/>
					<input type="text" id="txtDspSublineName" style="width: 250px;" readonly="readonly"/>
				</td>
				<td class="rightAligned">Peril</td>
				<td>
					<input type="text" id="txtDspPerilCd" style="width: 60px; text-align: right;" readonly="readonly"/>
					<input type="text" id="txtDspPerilName" style="width: 250px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Issuing Source</td>
				<td>
					<input type="text" id="txtDspIssCd" style="width: 60px;" readonly="readonly"/>
					<input type="text" id="txtDspIssName" style="width: 250px;" readonly="readonly"/>
				</td>
				<td class="rightAligned">As of</td>
				<td>
					<input type="text" id="txtDspAsOfDate" style="width: 120px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td>
					<input type="text" id="txtDspAssdNo" style="width: 60px; text-align: right;" readonly="readonly"/>
					<input type="text" id="txtDspAssdName" style="width: 250px;" readonly="readonly"/>
				</td>
			<tr>
		</table>
	</div>
	<div id="tabComponentsDiv1" class="tabComponents1" style="align:center;width:100%">
		<ul>
			<li class="tab1 selectedTab1" style="width:16.3%"><a id="lossRatioSummaryTab">Loss Ratio Summary</a></li>
			<li class="tab1" style="width:14.6%"><a id="premiumsWrittenTab">Premiums Written</a></li>
			<li class="tab1" style="width:14%"><a id="outstandingLossTab">Outstanding Loss</a></li>
			<li class="tab1" style="width:8.5%"><a id="lossPaidTab">Loss Paid</a></li>
			<li class="tab1" style="width:12.1%"><a id="lossRecoveryTab">Loss Recovery</a></li>
		</ul>			
	</div>
	<div id="tabBorderBottom" class="tabBorderBottom1"></div>
	<div id="tabComponentsDiv2" class="tabComponents2" style="align:center;width:100%">
		<ul>
			<li class="tab2 selectedTab2" style="width:8.2%"><a id="premWrittenCurrTab">Current Year</a></li>
			<li class="tab2" style="width:8.7%"><a id="premWrittenPrevTab">Previous Year</a></li>
		</ul>			
	</div>
	<div id="tabComponentsDiv3" class="tabComponents2" style="align:center;width:100%">
		<ul>
			<li class="tab2 selectedTab2" style="width:8.2%"><a id="outLossCurrTab">Current Year</a></li>
			<li class="tab2" style="width:8.7%"><a id="outLossPrevTab">Previous Year</a></li>
		</ul>			
	</div>
	<div id="tabComponentsDiv4" class="tabComponents2" style="align:center;width:100%">
		<ul>
			<li class="tab2 selectedTab2" style="width:8.2%"><a id="lossRecCurrTab">Current Year</a></li>
			<li class="tab2" style="width:8.7%"><a id="lossRecPrevTab">Previous Year</a></li>
		</ul>			
	</div>
	<div class="tabBorderBottom1"></div>
	<div id="tabPageContents1" name="tabPageContents1" style="width: 100%; float: left;">	
		<div id="lossRatioDetailDiv" name="lossRatioDetailDiv" style="width: 100%; float: left;"></div>
	</div>
</div>
<script type="text/JavaScript">
try{
	initializeTabs();
	
	function initializeLossRatioDetails(){
		$("txtDspLineCd").value = $F("txtLineCd");
		$("txtDspLineName").value = $F("txtLineCd") == "" ? "" : $F("txtLineName"); 
		$("txtDspSublineCd").value = $F("txtSublineCd");
		$("txtDspSublineName").value = $F("txtSublineCd") == "" ? "" : $F("txtSublineName"); 
		$("txtDspIssCd").value = $F("txtBranchCd");
		$("txtDspIssName").value = $F("txtBranchCd") == "" ? "" : $F("txtBranchName");
		$("txtDspAssdNo").value = $F("txtAssuredNo");
		$("txtDspAssdName").value = $F("txtAssuredNo") == "" ? "" : $F("txtAssuredName");
		$("txtDspIntmNo").value = $F("txtIntmNo");
		$("txtDspIntmName").value = $F("txtIntmNo") == "" ? "" : $F("txtIntmName");
		$("txtDspPerilCd").value = $F("txtPerilCd");
		$("txtDspPerilName").value = $F("txtPerilCd") == "" ? "" : $F("txtPerilName");
		$("txtDspAsOfDate").value = $F("hidAsOfDate");
	}
	
	function getRadioOption(id){
		var j = 1;
		for(var i = 0 ; i < id.length; i++){
			if($(id[i]).checked){		
				return j;
			}	
			j++;
		}
	}
	
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
	
	$("lossRatioSummaryTab").observe("click", function () {
		var prntOption = ["rdoByLine", "rdoByLineSubline", "rdoByIssSource", "rdoByIntm", "rdoByAssured", "rdoByPeril"];
		$("hidPrntOption").value = getRadioOption(prntOption);
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showLossRatioSummary",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				prntOption : $F("hidPrntOption")
			}
		});

		$("tabComponentsDiv2").hide();
		$("tabComponentsDiv3").hide();
		$("tabComponentsDiv4").hide();
		$("tabBorderBottom").hide();
		initializeLossRatioDetails();
	});
	
	var queryAction;
	var prntDate = ["rdoIssueDate", "rdoEffDate", "rdoAcctEntryDate", "rdoBookingMoYear"];
	
	$("premiumsWrittenTab").observe("click", function () {
		$("tabComponentsDiv2").show();
		$("tabComponentsDiv3").hide();
		$("tabComponentsDiv4").hide();
		$("tabBorderBottom").show();
		setCurrentTab1("premiumsWrittenTab");
		if($F("hidCurrPremSw") == "Y"){
			fireEvent($("premWrittenCurrTab"), "click");	
		}else{
			fireEvent($("premWrittenPrevTab"), "click");
		}
	});
	
	$("outstandingLossTab").observe("click", function () {
		$("tabComponentsDiv2").hide();
		$("tabComponentsDiv3").show();
		$("tabComponentsDiv4").hide();
		$("tabBorderBottom").show();
		setCurrentTab1("outstandingLossTab");
		if($F("hidCurrOsSw") == "Y"){
			fireEvent($("outLossCurrTab"), "click");	
		}else{
			fireEvent($("outLossPrevTab"), "click");
		}
	});
	
	$("lossPaidTab").observe("click", function () {
		queryAction = $("rdoByPeril").checked ? "getLossPaidPrl" : $("rdoByIntm").checked ? "getLossPaidIntm" : "getLossPaid";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showLossPaid",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				queryAction : queryAction
			}
		});
		
		$("tabComponentsDiv2").hide();
		$("tabComponentsDiv3").hide();
		$("tabComponentsDiv4").hide();
		$("tabBorderBottom").hide();
		setCurrentTab1("lossPaidTab");
	});
	
	$("lossRecoveryTab").observe("click", function () {
		$("tabComponentsDiv2").hide();
		$("tabComponentsDiv3").hide();
		$("tabComponentsDiv4").show();
		$("tabBorderBottom").show();
		setCurrentTab1("lossRecoveryTab");
		if($F("hidCurrRecSw") == "Y"){
			fireEvent($("lossRecCurrTab"), "click");	
		}else{
			fireEvent($("lossRecPrevTab"), "click");
		}
	});
	
	$("premWrittenCurrTab").observe("click", function () {
		$("hidPrntDate").value = getRadioOption(prntDate);
		queryAction = $("rdoByPeril").checked ? "getPremiumsWrittenCurrPrl" : $("rdoByIntm").checked ? "getPremiumsWrittenCurrIntm" : "getPremiumsWrittenCurr";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showPremiumsWrittenCurr",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				prntDate : $F("hidPrntDate"),
				queryAction : queryAction
			}
		});
	});
	
	$("premWrittenPrevTab").observe("click", function () {
		$("hidPrntDate").value = getRadioOption(prntDate);
		queryAction = $("rdoByPeril").checked ? "getPremiumsWrittenPrevPrl" : $("rdoByIntm").checked ? "getPremiumsWrittenPrevIntm" : "getPremiumsWrittenPrev";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showPremiumsWrittenPrev",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				prntDate : $F("hidPrntDate"),
				queryAction : queryAction
			}
		});
	});
	
	$("outLossCurrTab").observe("click", function () {
		queryAction = $("rdoByPeril").checked ? "getOutLossCurrPrl" : $("rdoByIntm").checked ? "getOutLossCurrIntm" : "getOutLossCurr";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showOutLoss",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				queryAction : queryAction,
				year : "curr"
			}
		});
	});
	
	$("outLossPrevTab").observe("click", function () {
		queryAction = $("rdoByPeril").checked ? "getOutLossPrevPrl" : $("rdoByIntm").checked ? "getOutLossPrevIntm" : "getOutLossPrev";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showOutLoss",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				queryAction : queryAction,
				year : "prev"
			}
		});
	});
	
	$("lossRecCurrTab").observe("click", function () {
		queryAction = $("rdoByPeril").checked ? "getLossRecCurrPrl" : $("rdoByIntm").checked ? "getLossRecCurrIntm" : "getLossRecCurr";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showLossRec",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				queryAction : queryAction,
				year : "curr"
			}
		});
	});
	
	$("lossRecPrevTab").observe("click", function () {
		queryAction = $("rdoByPeril").checked ? "getLossRecPrevPrl" : $("rdoByIntm").checked ? "getLossRecPrevIntm" : "getLossRecPrev";
		new Ajax.Updater("lossRatioDetailDiv", "GICLLossRatioController?action=showLossRec",{
			method:"get",
			evalScripts: true,
			parameters:{
				sessionId : $F("hidSessionId"),
				queryAction : queryAction,
				year : "prev"
			}
		});
	});
	
	$("btnExitLossRatioDetails").observe("click", function(){
		$("lossRatioDetailsDiv").hide();
		$("lossRatioMainDiv").show();
		setModuleId("GICLS204");
		setDocumentTitle("Loss Ratio");
	});
	
}catch(e){
	showErrorMessage("Loss Ratio Details overlay", e);
}
</script>