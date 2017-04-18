<!-- 
Remarks: GICLS202 - Bordereaux and Claims Register
Date : 03-13-2013
Developer: Bonok 
-->

<div id="claimsRegisterMainDiv">
	<div id="claimsRegisterMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
		<form id="claimsRegisterForm">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Bordereaux and Claims Register</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div id="groDiv" name="groDiv">
				<div class="sectionDiv" style="height: 470px;">
					<div class="sectionDiv" style="height: 434px; width: 330px; margin-top: 5px; margin-left: 20px; float: left;">
						<div id="brdrxTypeDiv">
							<table align="center" style="width: 100%;">
								<tr><td colspan="2"><label style="margin-top: 10px; margin-left: 15px;"><b>Reports</b></label></td></tr>
								<tr><td colspan="2" style="padding-top: 12px;"><input type="radio" id="rdoBordereaux" name="repName" checked="checked" style="float: left; margin-left: 15px;"/><label for="rdoBordereaux" style="margin-top: 3px;">Bordereaux</label></td></tr>
								<tr><td colspan="2"><input type="radio" id="rdoClaimsRegister" name="repName" style="float: left; margin-left: 15px;"/><label for="rdoClaimsRegister" style="margin-top: 3px;">Claims Register</label></td></tr>
							</table>
						</div>
						<div id="brdrxDiv">
							<table id="brdrxTable" align="center" style="width: 100%;">
								<tr>
									<td colspan="2" style="padding-top: 12px;">
										<input type="radio" id="rdoOutstanding" name="brdrxType" checked="checked" style="float: left; margin-left: 40px;"/><label for="rdoOutstanding" style="margin-top: 3px; ">Outstanding</label>
										<input type="checkbox" id="chkDspGrossTag" style="float: left; margin-top: 3px; margin-left: 45px;"/><label for="chkDspGrossTag" style="margin-top: 3px;">Reserve Tag</label>
									</td>
								</tr>
								<tr><td colspan="2" style="padding-top: 6px;"><input type="radio" id="rdoLossDate" name="brdrxDateOption" checked="checked" style="float: left; margin-left: 70px;"/><label for="rdoLossDate" style="margin-top: 3px;">Loss Date</label></td></tr>
								<tr><td colspan="2"><input type="radio" id="rdoClaimFileDate" name="brdrxDateOption" style="float: left; margin-left: 70px;"/><label for="rdoClaimFileDate" style="margin-top: 3px;">Claim File Date</label></td></tr>
								<tr><td colspan="2"><input type="radio" id="rdoBookingMonth" name="brdrxDateOption" style="float: left; margin-left: 70px;"/><label for="rdoBookingMonth" style="margin-top: 3px;">Booking Month</label></td></tr>
								<tr><td colspan="2" style="padding-top: 6px;"><input type="radio" id="rdoLossesPaid" name="brdrxType" style="float: left; margin-left: 40px;" /><label for="rdoLossesPaid" style="margin-top: 3px;">Losses Paid</label></td></tr>
								<tr><td colspan="2" style="padding-top: 6px;"><input type="radio" id="rdoTranDate" name="paidDateOption" style="float: left; margin-left: 70px;" checked="checked" /><label for="rdoTranDate" style="margin-top: 3px;">Tran Date</label></td></tr>
								<tr><td colspan="2"><input type="radio" id="rdoPostingDate" name="paidDateOption" style="float: left; margin-left: 70px;"/><label for="rdoPostingDate" style="margin-top: 3px;">Posting Date</label></td></tr>
								<tr>
									<td style="padding-top: 6px;">
										<input type="radio" id="rdoLoss" name="brdrxOption" style="float: left; margin-left: 40px;" checked="checked"/><label for="rdoLoss" style="margin-top: 3px;">Loss</label>
										<input type="radio" id="rdoExpense" name="brdrxOption" style="float: left; margin-left: 20px;" /><label for="rdoExpense" style="margin-top: 3px;">Expense</label>
									</td>
									<td style="padding-top: 6px;"><input type="radio" id="rdoLossExpense" name="brdrxOption" style="float: left;" /><label for="rdoLossExpense" style="margin-top: 3px;">Loss + Expense</label></td>
								</tr>
								<tr><td colspan="2" style="padding-top: 25px;"><input type="checkbox" id="chkPerBusinessSource" style="margin-left: 40px; float: left; "/><label for="chkPerBusinessSource">Per Business Source</label></td></tr>
								<tr><td colspan="2" style="padding-top: 5px;"><input type="checkbox" id="chkPerIssueSource" style="margin-left: 40px; float: left; "/><label for="chkPerIssueSource">Per Issue Source</label></td></tr>
								<tr><td colspan="2" style="padding-top: 5px;"><input type="checkbox" id="chkPerLineSubline" style="margin-left: 40px; float: left; "/><label for="chkPerLineSubline">Per Line/Subline</label></td></tr>
								<tr>
									<td colspan="2" style="padding-top: 5px;">
										<div id="chkPerPolicyDiv">
											<input type="checkbox" id="chkPerPolicy" style="margin-left: 40px; float: left; "/><label for="chkPerPolicy">Per Policy</label>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2" style="padding-top: 5px;">
										<div id="chkPerEnrolleeDiv">
											<input type="checkbox" id="chkPerEnrollee" style="margin-left: 40px; float: left; "/><label for="chkPerEnrollee">Per Enrollee</label>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div id="claimsRegisterDiv">
							<table align="center" style="width: 100%;">
								<tr><td style="padding-top: 40px;"><input type="radio" id="rdoPerLoss" name="regButton" checked="checked" style="margin-left: 30px; float: left;"/><label for="rdoPerLoss" style="margin-top: 3px;" checked="">Loss Date</label></td></tr>
								<tr><td style="padding-top: 4px;"><input type="radio" id="rdoPerFile" name="regButton" style="margin-left: 30px; float: left;"/><label for="rdoPerFile" style="margin-top: 3px;">Claim File Date</label></td></tr>
								<tr><td style="padding-top: 25px;"><input type="checkbox" id="chkPerLine" style="margin-left: 30px; float: left;" /><label for="chkPerLine">Per Line</label></td></tr>
								<tr><td style="padding-top: 5px;"><input type="checkbox" id="chkPerBranch" style="margin-left: 30px; float: left;" /><label for="chkPerBranch">Per Branch</label></td></tr>
								<tr><td style="padding-top: 5px;"><input type="checkbox" id="chkPerIntermediary" style="margin-left: 30px; float: left; "/><label for="chkPerIntermediary">Per Intermediary</label></td></tr>
								<tr id="trPerLossCategory"><td style="padding-top: 5px;"><input type="checkbox" id="chkPerLossCategory" style="margin-left: 30px; float: left; "/><label for="chkPerLossCategory">Per Loss Category</label></td></tr>
							</table>
						</div>
					</div>
					<div class="sectionDiv" style="height: 403px; width: 545px; margin-top: 5px; margin-left: 2px; float: left;">
						<div id="detailInnerDiv" style="margin-left: 20px; float: left;">
							<div id="detailDateDiv" style="height: 101px;">
								<div style="margin-top: 7px; margin-left: 15px; height: 18px;"><b>Parameters</b></div>
								<div style="height: 23px;">
									<div id="byPeriodDiv">
										<input type="radio" id="rdoByPeriod" name="dateOption" style="margin-left: 15px; float: left;" checked="checked"/><label for="rdoByPeriod" style="margin-top: 3px;">By Period</label>
									</div>
								</div>
								<div style="height: 23px;">
									<div id="byPeriodDateDiv">
										<label style="margin-left: 40px; margin-top: 8px;">From</label>
										<div id="txtDspFromDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 10px; margin-top: 5px;">
											<input type="text" id="txtDspFromDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtDspFromDate" readonly="readonly" />
											<img id="imgDspFromDate" alt="imgDspFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
										</div>
										<label style="margin-left: 40px; margin-top: 8px;">To</label>
										<div id="txtDspToDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 10px; margin-top: 5px;">
											<input type="text" id="txtDspToDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtDspToDate" readonly="readonly" />
											<img id="imgDspToDate" alt="imgDspToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
										</div>
									</div>	
								</div>
								<div style="margin-top: 8px; height: 23px;">
									<div id="asOfDiv">
										<input type="radio" id="rdoAsOf" name="dateOption" style="margin-top: 7px; margin-left: 15px; float: left;"/><label for="rdoAsOf" style="margin-top: 7px;">As of</label>
										<div id="txtDspAsOfDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 19px; margin-top: 2px;">
											<input type="text" id="txtDspAsOfDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtDspAsOfDate" readonly="readonly" />
											<img id="imgDspAsOfDate" alt="imgDspAsOfDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
										</div>
									</div>
								</div>
							</div>
							<div id="textLovDiv" class="sectionDiv" style="height: 198px; border: none;">
								<div id="textLovInnerDiv" class="sectionDiv" style="border: none;">
									<div id="outerPolicyDiv" style="margin-top: 5px; height: 23px;">
										<div id="policyDiv">
											<label style="margin-left: 90px; margin-top: 6px;">Policy</label>
											<div id="lineCdDiv" class="dspPolicy" style="float: left; width: 49px; height: 19px; margin-top: 2px; margin-left: 5px; border: 1px solid gray;">
												<input id="txtDspLineCd2" title="Line Code" type="text" maxlength="2" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;" lastValidValue="">
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
											</div>
											<div id="sublineCdDiv" class="dspPolicy" style="float: left; width: 74px; height: 19px; margin-left: 1px; margin-top: 2px; border: 1px solid gray;">
												<input id="txtDspSublineCd2" title="Subline Code" type="text" style="float: left; height: 12px; width: 46px; margin: 0px; border: none;" lastValidValue="">
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCdLOV" name="searchSublineCdLOV" alt="Go" style="float: right;"/>
											</div>
											<div id="issCdDiv" class="dspPolicy" style="float: left; width: 49px; height: 19px; margin-left: 1px; margin-top: 2px; border: 1px solid gray;">
												<input id="txtDspIssCd2" title="Issue Code" maxlength="2" type="text" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;" lastValidValue="">
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCdLOV" name="searchIssCdLOV" alt="Go" style="float: right; "/>
											</div>
											<div class="dspPolicy">
												<input id="txtDspIssueYy" title="Year" maxlength="2" type="text" style="float: left; width: 33px; margin-left: 1px;">
												<input id="txtDspPolSeqNo" title="Policy Sequence Number" maxlength="6" type="text" style="float: left; width: 53px; margin-left: 1px;" >
												<input id="txtDspRenewNo" title="Renew Number" maxlength="2" type="text" style="float: left; width: 33px; margin-left: 1px;">
											</div>
										</div>
									</div>
									<div id="textDiv">
										<div id="outerLineDiv" style="margin-top: 4px; height: 23px;">
											<div class="textDiv">
												<label style="margin-left: 100px; margin-top: 6px;">Line</label>
												<div id="dspLineCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
													<input id="txtDspLineCd" name="txtDspLineCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" lastValidValue="">
													<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;"/>
												</div>
												<span class="lovSpanText">
													<input id="txtDspLineName" type="text" style="width: 231px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
												</span>
											</div>
										</div>
										<div style="margin-top: 4px; height: 23px;">
											<div class="textDiv">
												<label style="margin-left: 81px; margin-top: 6px;">Subline</label>
												<div id="dspSublineCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
													<input id="txtDspSublineCd" name="txtDspSublineCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" lastValidValue="">
													<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;"/>
												</div>
												<span class="lovSpanText">
													<input id="txtDspSublineName"type="text" style="width: 231px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
												</span>
											</div>
										</div>
										<div style="margin-top: 4px; height: 23px;">
											<div class="textDiv">
												<label style="margin-left: 83px; margin-top: 6px;">Branch</label>
												<div id="dspIssCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
													<input id="txtDspIssCd" name="txtDspIssCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" lastValidValue="">
													<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchLOV" name="searchBranchLOV" alt="Go" style="float: right;"/>
												</div>
												<span class="lovSpanText">
													<input id="txtDspIssName" type="text" style="width: 231px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
												</span>
											</div>
										</div>
										<div id="outerlossCategoryDiv" style="margin-top: 4px; height: 23px;">
											<div id="lossCategoryDiv" class="textDiv">
												<label style="margin-left: 41px; margin-top: 6px;">Loss Category</label>
												<div id="dspLossCatCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
													<input id="txtDspLossCatCd" name="txtDspLossCatCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" lastValidValue="">
													<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLossCategoryLOV" name="searchLossCategoryLOV" alt="Go" style="float: right;"/>
												</div>
												<span class="lovSpanText">
													<input id="txtDspLossCtgry" type="text" style="width: 231px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
												</span>
											</div>
										</div>
										<div id="outerPerilDiv" style="margin-top: 4px; height: 23px;">
											<div class="textDiv">
												<label style="margin-left: 98px; margin-top: 6px;">Peril</label>
												<div id="dspPerilCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
													<input id="txtDspPerilCd" name="txtDspPerilCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" lastValidValue="">
													<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilLOV" name="searchPerilLOV" alt="Go" style="float: right;"/>
												</div>
												<span class="lovSpanText">
													<input id="txtDspPerilName" type="text" style="width: 231px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
												</span>
											</div>
										</div>
										<div style="margin-top: 4px; height: 23px;">
											<div id="intmDiv" class="textDiv">
												<label style="margin-left: 48px; margin-top: 6px;">Intermediary</label>
												<div id="dspIntmNoDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
													<input id="txtDspIntmNo" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" lastValidValue="">
													<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmLOV" name="searchIntmLOV" alt="Go" style="float: right;"/>
												</div>
												<span class="lovSpanText">
													<input id="txtDspIntmName" type="text" style="width: 231px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
												</span>
											</div>
										</div>
									</div>
								</div>
								<div id="textEnrolleeDiv">
									<div style="margin-top: 50px;">
										<label style="margin-left: 100px; margin-top: 6px;">Enrollee</label></td>
										<div id="dspEnrolleeDiv" style="float: left; width: 276px; height: 19px; margin-left: 5px; margin-top: 2px; border: 1px solid gray;">
											<input id="txtDspEnrollee" title="Enrollee" maxlength="50" type="text" style="float: left; height: 12px; width: 251px; margin: 0px; border: none;" lastValidValue="">
											<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDspEnrollee" name="imgDspEnrollee" alt="Go" style="float: right; "/>
										</div>
									</div>
									<div>
										<label style="margin-left: 72px; margin-top: 6px;">Control Type</label>
										<div id="dspControlTypeDiv" style="width: 64px; height: 19px; margin-top: 3px; margin-left: 5px; border: 1px solid gray; float: left;">
											<input id="txtDspControlType" name="txtDspControlType" type="text" style="border: none; float: left; width: 34px; height: 13px; margin: 0px;" value="" lastValidValue="">
											<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchControlTypeLOV" name="searchControlTypeLOV" alt="Go" style="float: right;"/>
										</div>
										<input type="text" id="txtDspControlTypeName" style="width: 203px; margin-left: 1px; margin-top: 3px;"/>
									</div>
									<div>
										<label style="margin-left: 55px; margin-top: 6px;">Control Number</label></td>
										<input type="text" id="txtDspControlNumber" style="margin-left: 5px; width: 270px;"/>
									</div>
								</div>
							</div>
							<div class="sectionDiv" style="border: none;">
								<div style="width: 250px; height: 100px; float: left;">
									<div align="center" style="margin-top: 10px;"><b>Branch Parameter</b></div>
									<div>
										<input type="radio" id="rdoClaimIssCd" name="branchOption" style="margin-top: 10px; margin-left: 90px; float: left;" checked="checked"><label for="rdoClaimIssCd" style="margin-top: 10px;">Claim Iss Cd</label>
										<input type="radio" id="rdoPolicyIssCd" name="branchOption" style="margin-top: 4px; margin-left: 90px; float: left;"><label for="rdoPolicyIssCd" style="margin-top: 4px;">Policy Iss Cd</label>
									</div>
								</div>
								<div class="sectionDiv" style="margin-left: 30px; width: 203px; height: 87px; float: left;">
									<table align="center" style="width: 100%;">
										<tr>
											<td colspan="2"><input type="checkbox" id="chkNetOfRecovery" style="margin-top: 5px; margin-left: 10px; float: left;"/><label for="chkNetOfRecovery" style="margin-top: 5px;">Net of Recovery</label></td>
										</tr>
										<tr>
											<td style="width: 40px;"><label style="margin-left: 10px; margin-top: 3px;">From</label></td>
											<td>
												<div id="dspRcvryFromDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-top: 5px;">
													<input type="text" id="txtDspRcvryFromDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtDspRcvryFromDate" readonly="readonly" />
													<img id="imgFmRcvryDate" alt="imgFmRcvryDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
												</div>
											</td>
										</tr>
										<tr>
											<td><label style="margin-left: 25px; margin-top: 3px;">To</label></td>
											<td>
												<div id="dspRcvryToDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px;">
													<input type="text"  id="txtDspRcvryToDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtDspRcvryToDate"readonly="readonly" />
													<img id="imgToRcvryDate" alt="imgToRcvryDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />						
												</div>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div id="buttonDiv" align="center" style="height: 25px; width: 545px; margin-top: 7px; margin-left: 2px; float: left;">
						<input type="button" class="button" id="btnExtract" value="Extract" style="width: 120px;"/>
						<input type="button" class="button" id="btnPrintGicls202" value="Print" style="width: 120px;"/>
					</div>
					<div>
						<input type="hidden" id="hidRiIssCd" />
						<input type="hidden" id="hidClmLossPayeeType" />
						<input type="hidden" id="hidClmExpPayeeType" />
						<input type="hidden" id="hidImplSw" />
						<input type="hidden" id="chkBrdrxHid" value="1" />
						<input type="hidden" id="chkDistRegHid" />
						<input type="hidden" id="chkSummaryHid" />
						<input type="hidden" id="chkXolHid" />
						<input type="hidden" id="chkAgingHid" />
						<input type="hidden" id="printDateOptionHid" value="1" />
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
<script type="text/JavaScript">
try{
	initializeAccordion();
	setModuleId("GICLS202");
	setDocumentTitle("Bordereaux and Claims Register");
	var currParam = 0;
	
	$("chkPerPolicyDiv").hide();
	$("chkPerEnrolleeDiv").hide();
	$("brdrxDiv").show();
	$("claimsRegisterDiv").hide();	
	$("policyDiv").hide();
	$("textEnrolleeDiv").hide();
	
	var mes = "";
	var mesType = "";

	function checkCustomErrorOnResponseGicls202(response, func) {
		if (response.responseText.include("Geniisys Exception")){
			var message = response.responseText.split("#");
			mes = message[2];
			mesType = message[1];
			showMessageBox(message[2], message[1]);
			if(func != null) func();
			return false;
		} else {
			return true;
		}
	}
	
	function whenNewFormInstanceGicls202(){
		new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=whenNewFormInstanceGicls202",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkCustomErrorOnResponseGicls202(response) && checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					$("hidClmExpPayeeType").value = res.clmExpPayeeType;
					$("hidClmLossPayeeType").value = res.clmLossPayeeType;
					$("hidRiIssCd").value = res.riIssCd;
					$("hidImplSw").value = res.implSw;
				}
				whenNewBlockE010Gicls202();
			}
		});
	}
	
	whenNewFormInstanceGicls202();
	
	var extractParam = new Object();
	var extract = false;
	
	function whenNewBlockE010Gicls202(repName){ //marco - 05.22.2015 - GENQA SR 4457 - added parameter
		new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=whenNewBlockE010Gicls202",{
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Initializing..."),
			onComplete: function(response){
				hideNotice("");
				var res = JSON.parse(response.responseText);
				extractParam = res;
				//if(!extract){
					if(nvl(repName, res.repName) == 1){ //marco - 05.22.2015 - GENQA SR 4457 - added repName
						$("brdrxDiv").show();
						$("claimsRegisterDiv").hide();
						$("rdoBordereaux").checked = true;
						if(res.brdrxType == 1){
							$("rdoOutstanding").checked = true;
							var showId = ["byPeriodDiv", "asOfDiv"];
							hideDiv(showId, "show");
							var enableId = ["rdoByPeriod", "rdoAsOf"];
							disableChkRdo(enableId, false);
							var disableId = ["rdoTranDate", "rdoPostingDate"];
							disableChkRdo(disableId, true);
						}else if(res.brdrxType == 2){
							$("rdoLossesPaid").checked = true;
							var hideId = ["byPeriodDiv", "asOfDiv"];
							hideDiv(hideId, "hide");
							var showId = ["chkPerPolicyDiv", "chkPerEnrolleeDiv"];
							hideDiv(showId, "show");
							var enableId = ["chkPerPolicy", "chkPerEnrollee"];
							disableChkRdo(enableId, false);
							if(res.perPolicy == 1 || res.perEnrollee == 1){
								var disableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "chkNetOfRecovery"];
								disableChkRdo(disableId, true);
								enableTxtLov(false);
								disableBranchOption(true);
								enableRcvryDate(false,"from");
								enableRcvryDate(false,"to");
								if(res.perPolicy == 1){
									$("chkPerPolicy").checked = true;
									var disableId = ["chkPerEnrollee"];
									disableChkRdo(disableId, true);
									var showId = ["policyDiv"];
									hideDiv(showId, "show");
									enablePolicyDiv(true);
									getPolicyNumberGicls202();
								}else if(res.perEnrollee == 1){
									$("chkPerEnrollee").checked = true;
									$("chkPerPolicy").disabled = true;
									$("textLovInnerDiv").hide();
									$("textEnrolleeDiv").show();
									enableEnrolleeDiv(true);
								}
							}
							if(res.perPolicy == 0){
								$("chkPerPolicy").checked = false;
								var enableId = ["chkPerEnrollee"];
								disableChkRdo(enableId, false);
								var hideId = ["policyDiv"];
								hideDiv(hideId, "hide");
								enablePolicyDiv(false);
							}
							if(res.perEnrollee == 0){
								$("chkPerEnrollee").checked = false;
								$("chkPerPolicy").disabled = false;
								$("textLovInnerDiv").show();
								$("textEnrolleeDiv").hide();
								enableEnrolleeDiv(false);
							}
						}
						if(res.dateOption == 1){
							$("rdoByPeriod").checked = true;
							enableByPeriodDate(true, "from");
							enableByPeriodDate(true, "to");
						}else{
							$("rdoAsOf").checked = true;
							enableAsOfDate(true);
							enableByPeriodDate(false, "from");
							enableByPeriodDate(false, "to");
						}
						$("outerlossCategoryDiv").hide();
						if(res.perPolicy == 0 && res.perEnrollee == 0){
							$("chkPerPolicy").checked = false;
							$("chkPerEnrollee").checked = false;
							$("chkNetOfRecovery").disabled = false;
							enableRcvryDate(true,"from");
							enableRcvryDate(true,"to");
						}
						if(res.perIntermediary == 0){
							$("chkPerBusinessSource").checked = false;
							$("intmDiv").hide();
						}else{
							$("chkPerBusinessSource").checked = true;
							$("intmDiv").show();
						}
					}else if(nvl(repName, res.repName) == 2){ //marco - 05.22.2015 - GENQA SR 4457 - added repName
						$("brdrxDiv").hide();
						$("claimsRegisterDiv").show();
						$("rdoClaimsRegister").checked = true;
						var hideId = ["byPeriodDiv", "asOfDiv"];
						hideDiv(hideId, "hide");
						enableByPeriodDate(true, "from");
						enableByPeriodDate(true, "to");
						$("chkNetOfRecovery").disabled = true;
						enableRcvryDate(false,"from");
						enableRcvryDate(false,"to");
						extractParam.perIntmParam == 1 ? $("chkPerIntermediary").checked = true : $("chkPerIntermediary").checked = false;
						extractParam.perLossCatParam == 1 ? $("chkPerLossCategory").checked = true : $("chkPerLossCategory").checked = false;
						if($("chkPerIntermediary").checked){
							$("intmDiv").show();
						}else{
							$("intmDiv").hide();
						}
						if($("chkPerLossCategory").checked){
							$("lossCategoryDiv").show();
							$("outerlossCategoryDiv").show();
							$("outerlossCategoryDiv").setStyle({height: '23px'});
						}else{
							$("lossCategoryDiv").hide();
							$("outerlossCategoryDiv").hide();
							$("outerlossCategoryDiv").setStyle({height: '0px'});
						}
					}
					if(res.brdrxType == 2){ //&& ($("").getStyle("display") != "none")){
						var disableId = ["rdoLossDate", "rdoClaimFileDate", "rdoBookingMonth"];
						disableChkRdo(disableId, true);
						var hideId = ["byPeriodDiv", "asOfDiv"];
						hideDiv(hideId, "hide");
					}
					/* if(nvl($F("hidImplSw"), "N") == "N" && res.repName == 2){
						$("outerlossCategoryDiv").hide();
						$("trPerLossCategory").hide();
					} */
					$("txtDspAsOfDate").value = res.dspAsOfDate;
					$("txtDspFromDate").value = res.dspFromDate;
					$("txtDspToDate").value = res.dspToDate;
					$("txtDspRcvryToDate").value = res.dspRcvryToDate;
					$("txtDspRcvryFromDate").value = res.dspRcvryFromDate;
					res.regButton == 1 ? $("rdoPerLoss").checked = true : $("rdoPerFile").checked = true;
					res.brdrxDateOption == 1 ? $("rdoLossDate").checked = true : res.brdrxDateOption == 2 ? $("rdoClaimFileDate").checked = true : $("rdoBookingMonth").checked = true;  
					res.dspGrossTag == 1 ? $("chkDspGrossTag").checked = true : $("chkDspGrossTag").checked = false;  
	 				res.branchOption == 1 ? $("rdoClaimIssCd").checked = true : $("rdoPolicyIssCd").checked = true;
	 				res.perIssource == 1 ? $("chkPerIssueSource").checked = true : $("chkPerIssueSource").checked = false;
	 				res.perLossCat == 1 ? $("chkPerLossCategory").checked = true : $("chkPerLossCategory").checked = false;
	 				res.brdrxOption == 1 ? $("rdoLoss").checked = true : res.brdrxOption == 2 ? $("rdoExpense").checked = true : $("rdoLossExpense").checked = true;
	 				res.paidDateOption == 1 ? $("rdoTranDate").checked = true : $("rdoPostingDate").checked = true;
	 				res.netRcvryChkbx == "Y" ? $("chkNetOfRecovery").checked = true : $("chkNetOfRecovery").checked = false;
	 				res.perIntermediary == 1 ? $("chkPerBusinessSource").checked = true : $("chkPerBusinessSource").checked = false;
	 				res.perLineSubline == 1 ? $("chkPerLineSubline").checked = true : $("chkPerLineSubline").checked = false;
	 				objGicls202.intmBreak = res.perIntermediary; 
	 				objGicls202.issdBreak = res.perIssource; 
	 				objGicls202.sublBreak = res.perLineSubline; 
					setDateParameter(2);
				//}
					
				//marco - 05.22.2015 - GENQA SR 4457 -  added condition
				if(nvl(repName, res.repName) == res.repName){
					extractParam.perLineParam == 1 ? $("chkPerLine").checked = true : $("chkPerLine").checked = false;
					extractParam.perBranchParam == 1 ? $("chkPerBranch").checked = true : $("chkPerBranch").checked = false;
					extractParam.perIntmParam == 1 ? $("chkPerIntermediary").checked = true : $("chkPerIntermediary").checked = false;
					extractParam.perLossCatParam == 1 ? $("chkPerLossCategory").checked = true : $("chkPerLossCategory").checked = false;
					extractParam.perBussParam == 1 ? $("chkPerBusinessSource").checked = true : $("chkPerBusinessSource").checked = false;
					extractParam.perIssourceParam == 1 ? $("chkPerIssueSource").checked = true : $("chkPerIssueSource").checked = false;
					extractParam.perLineSublineParam == 1 ? $("chkPerLineSubline").checked = true : $("chkPerLineSubline").checked = false;
					extractParam.perPolicyParam == 1 ? $("chkPerPolicy").checked = true : $("chkPerPolicy").checked = false;
					extractParam.perEnrolleeParam == 1 ? $("chkPerEnrollee").checked = true : $("chkPerEnrollee").checked = false;
				}else{
					$w("chkPerLine chkPerBranch chkPerIntermediary chkPerLossCategory chkPerBusinessSource chkPerIssueSource chkPerLineSubline chkPerPolicy chkPerEnrollee").each(function(e){
						$(e).checked = false;
					});
				}
				
				if($("chkNetOfRecovery").checked){
					$("rdoLossExpense").disabled = true;
				}				
			}
		});
	}
	
	function getPolicyNumberGicls202(){
		new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=getPolicyNumberGicls202",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				if(res.tooManyRows == "Y"){
					$("txtDspLineCd2").value = "";
					$("txtDspSublineCd2").value = "";
					$("txtDspIssCd2").value = "";
					$("txtDspIssueYy").value = "";
					$("txtDspPolSeqNo").value = "";
					$("txtDspRenewNo").value = "";
				}else{
					$("txtDspLineCd2").value = res.lineCd;
					$("txtDspSublineCd2").value = res.sublineCd;
					$("txtDspIssCd2").value = res.issCd;
					$("txtDspIssueYy").value = res.issueYy;
					$("txtDspPolSeqNo").value = res.polSeqNo;
					$("txtDspRenewNo").value = res.renewNo;
				}
			}
		});
	}
	
	function setDateParameter(settings){
		if(settings == 1){
			$("byPeriodDiv").show();
			$("byPeriodDateDiv").show();
			$("rdoByPeriod").disabled = false;
			$("rdoAsOf").disabled = false;
			enableAsOfDate(true);
			enableByPeriodDate(true,"from");
			enableByPeriodDate(true,"to");
		}else if(settings == 2){
			if($("rdoBookingMonth").checked && $("rdoBordereaux").checked && $("rdoOutstanding").checked){
				$("byPeriodDiv").hide();
				$("byPeriodDateDiv").hide();
				$("asOfDiv").show();
				$("rdoAsOf").disabled = false;
				enableAsOfDate(true);
				$("rdoAsOf").checked = true;
				$("txtDspFromDate").clear();
				$("txtDspToDate").clear();
			}
			if($("rdoByPeriod").checked){
				enableByPeriodDate(true,"from");
				enableByPeriodDate(true,"to");
				enableAsOfDate(false);
			}else{
				enableByPeriodDate(false,"from");
				enableByPeriodDate(false,"to");
				enableAsOfDate(true);
			}
		}
	}
	
	function enablePolicyDiv(enabled){
		if(enabled){
			var txtPolicy = $$('div#policyDiv .dspPolicy input');
			for(var i=0;i<txtPolicy.length;i++){
				txtPolicy[i].removeClassName("disabled");
				enableInputField(txtPolicy[i]);
			}
			$("lineCdDiv").removeClassName("disabled");
			$("sublineCdDiv").removeClassName("disabled");
			$("issCdDiv").removeClassName("disabled");
			enableSearch("searchLineCdLOV");
			enableSearch("searchSublineCdLOV");
			enableSearch("searchIssCdLOV");
		}else{
			var txtPolicy = $$('div#policyDiv .dspPolicy input');
			for(var i=0;i<txtPolicy.length;i++){
				txtPolicy[i].addClassName("disabled");
				disableInputField(txtPolicy[i]);
			}
			$("lineCdDiv").addClassName("disabled");
			$("sublineCdDiv").addClassName("disabled");
			$("issCdDiv").addClassName("disabled");
			disableSearch("searchLineCdLOV");
			disableSearch("searchSublineCdLOV");
			disableSearch("searchIssCdLOV");
		}
	}
	
	function enableLineDiv(enabled){
		if(enabled){
			$("dspLineCdDiv").removeClassName("disabled");
			$("txtDspLineCd").removeClassName("disabled");
			$("txtDspLineName").removeClassName("disabled");
			enableSearch("searchLineLOV");
			enableInputField("txtDspLineCd");
		}else{
			$("dspLineCdDiv").addClassName("disabled");
			$("txtDspLineCd").addClassName("disabled");
			$("txtDspLineName").addClassName("disabled");
			disableSearch("searchLineLOV");
			disableInputField("txtDspLineCd");
		}
	}
	
	function enableSublineDiv(enabled){
		if(enabled){
			$("dspSublineCdDiv").removeClassName("disabled");
			$("txtDspSublineCd").removeClassName("disabled");
			$("txtDspSublineName").removeClassName("disabled");
			enableInputField("txtDspSublineCd");
			enableSearch("searchSublineLOV");
		}else{
			$("dspSublineCdDiv").addClassName("disabled");
			$("txtDspSublineCd").addClassName("disabled");
			$("txtDspSublineName").addClassName("disabled");
			disableInputField("txtDspSublineCd");
			disableSearch("searchSublineLOV");
		}
	}
	
	function enableIssDiv(enabled){
		if(enabled){
			$("dspIssCdDiv").removeClassName("disabled");
			$("txtDspIssCd").removeClassName("disabled");
			$("txtDspIssName").removeClassName("disabled");
			enableInputField("txtDspIssCd");
			enableSearch("searchBranchLOV");
		}else{
			$("dspIssCdDiv").addClassName("disabled");
			$("txtDspIssCd").addClassName("disabled");
			$("txtDspIssName").addClassName("disabled");
			disableInputField("txtDspIssCd");
			disableSearch("searchBranchLOV");
		}
	}
	
	function enableLossCategoryDiv(enabled){
		if(enabled){
			$("txtDspLossCatCd").removeClassName("disabled");
			$("dspLossCatCdDiv").removeClassName("disabled");
			$("txtDspLossCtgry").removeClassName("disabled");
			enableInputField("txtDspLossCatCd");
			enableSearch("searchLossCategoryLOV");
		}else{
			$("txtDspLossCatCd").addClassName("disabled");
			$("dspLossCatCdDiv").addClassName("disabled");
			$("txtDspLossCtgry").addClassName("disabled");
			disableInputField("txtDspLossCatCd");
			disableSearch("searchLossCategoryLOV");
		}
	}
	
	function enablePerilDiv(enabled){
		if(enabled){
			$("txtDspPerilCd").removeClassName("disabled");
			$("dspPerilCdDiv").removeClassName("disabled");
			$("txtDspPerilName").removeClassName("disabled");
			enableInputField("txtDspPerilCd");
			enableSearch("searchPerilLOV");
		}else{
			$("txtDspPerilCd").addClassName("disabled");
			$("dspPerilCdDiv").addClassName("disabled");
			$("txtDspPerilName").addClassName("disabled");
			disableInputField("txtDspPerilCd");
			disableSearch("searchPerilLOV");
		}
	}
	
	function enableIntmDiv(enabled){
		if(enabled){
			$("txtDspIntmNo").removeClassName("disabled");
			$("dspIntmNoDiv").removeClassName("disabled");
			$("txtDspIntmName").removeClassName("disabled");
			enableInputField("txtDspIntmNo");
			enableSearch("searchIntmLOV");
		}else{
			$("txtDspIntmNo").addClassName("disabled");
			$("dspIntmNoDiv").addClassName("disabled");
			$("txtDspIntmName").addClassName("disabled");
			disableInputField("txtDspIntmNo");
			disableSearch("searchIntmLOV");
		}
	}
	
	function enableRcvryDate(enabled,period){
		if(period == "from"){
			if(enabled){
				$("txtDspRcvryFromDate").removeClassName("disabled");
				$("dspRcvryFromDateDiv").removeClassName("disabled");
				enableDate("imgFmRcvryDate");			
			}else{
				$("txtDspRcvryFromDate").addClassName("disabled");
				$("dspRcvryFromDateDiv").addClassName("disabled");
				disableDate("imgFmRcvryDate");
			}
		}else if(period == "to"){
			if(enabled){
				$("txtDspRcvryToDate").removeClassName("disabled");
				$("dspRcvryToDateDiv").removeClassName("disabled");
				enableDate("imgToRcvryDate");			
			}else{
				$("txtDspRcvryToDate").addClassName("disabled");
				$("dspRcvryToDateDiv").addClassName("disabled");
				disableDate("imgToRcvryDate");	
			}
		}
	}
	
	function enableByPeriodDate(enabled,period){
		if(period == "from"){
			if(enabled){
				$("txtDspFromDate").removeClassName("disabled");
				$("txtDspFromDateDiv").removeClassName("disabled");
				enableDate("imgDspFromDate");			
			}else{
				$("txtDspFromDate").addClassName("disabled");
				$("txtDspFromDateDiv").addClassName("disabled");
				disableDate("imgDspFromDate");
			}
		}else if(period == "to"){
			if(enabled){
				$("txtDspToDate").removeClassName("disabled");
				$("txtDspToDateDiv").removeClassName("disabled");
				enableDate("imgDspToDate");			
			}else{
				$("txtDspToDate").addClassName("disabled");
				$("txtDspToDateDiv").addClassName("disabled");
				disableDate("imgDspToDate");	
			}
		}
	}
	
	function enableAsOfDate(enabled){
		if(enabled){
			$("txtDspAsOfDate").removeClassName("disabled");
			$("txtDspAsOfDateDiv").removeClassName("disabled");
			enableDate("imgDspAsOfDate");			
		}else{
			$("txtDspAsOfDate").addClassName("disabled");
			$("txtDspAsOfDateDiv").addClassName("disabled");
			disableDate("imgDspAsOfDate");
		}
	}
	
	function enableTxtLov(enabled){
		enableLineDiv(enabled);
		enableSublineDiv(enabled);
		enableIssDiv(enabled);
		if($("lossCategoryDiv").getStyle("display") != "none"){
			enableLossCategoryDiv(enabled);
		}
		if($("intmDiv").getStyle("display") != "none"){
			enableIntmDiv(enabled);
		}
		enablePerilDiv(enabled);
	}
	
	function disableChkRdo(id, boolean){
		for(var i = 0; i < id.length; i++){
			$(id[i]).disabled = boolean;
		}
	}
	
	function hideDiv(id, display){
		if(display == "hide"){
			for(var i = 0; i < id.length; i++){
				$(id[i]).hide();
			}	
		}else if(display == "show"){
			for(var i = 0; i < id.length; i++){
				$(id[i]).show();
			}	
		}
	}
	
	function disableBranchOption(boolean){
		$("rdoClaimIssCd").disabled = boolean;
		$("rdoPolicyIssCd").disabled = boolean;
	}
	
	function disableBrdrxDateOption(boolean){
		$("rdoLossDate").disabled = boolean;
		$("rdoClaimFileDate").disabled = boolean;
		$("rdoBookingMonth").disabled = boolean;
	}
	
	function disableDateOption(boolean){
		$("rdoByPeriod").disabled = boolean;
		$("rdoAsOf").disabled = boolean;
	}
	
	function disablePaidDateOption(boolean){
		$("rdoTranDate").disabled = boolean;
		$("rdoPostingDate").disabled = boolean;
	}

	function clearTextFields(){
		$("txtDspFromDate").value = "";
		$("txtDspToDate").value = "";
		$("txtDspAsOfDate").value = "";
		var txtDiv = $$('div#textDiv .textDiv input');
		for(var i=0;i<txtDiv.length;i++){
			txtDiv[i].value = "";
		}
	}

	$("rdoBordereaux").observe("click", function(){
		setDateParameter(1);
		$("brdrxDiv").show();
		$("claimsRegisterDiv").hide();
		if($("rdoOutstanding").checked){
			$("byPeriodDiv").show();
			$("byPeriodDateDiv").show();
			$("asOfDiv").show();
			$("rdoByPeriod").disabled = false;
			$("rdoAsOf").disabled = false;
			$("txtDspAsOfDate").clear();
			$("rdoTranDate").disabled = true;
			$("rdoPostingDate").disabled = true;
		}else if($("rdoLossesPaid").checked){
			$("byPeriodDiv").hide();
			$("asOfDiv").hide();
		}
		
		$("txtDspToDate").removeClassName("disabled");
		$("txtDspAsOfDate").removeClassName("disabled");
		$("intmDiv").hide();
		$("outerlossCategoryDiv").hide();
		if($("chkPerPolicy").checked){
			$("policyDiv").show();
			enablePolicyDiv(true);
			enableTxtLov(false);
			disableBranchOption(true);
			$("chkNetOfRecovery").disabled = true;
			enableRcvryDate(false,"from");
			enableRcvryDate(false,"to");
			var txtDiv = $$('div#textDiv .textDiv input');
			for(var i=0;i<txtDiv.length;i++){
				txtDiv[i].value = "";
			}
		}
		if($("chkPerEnrollee").checked){
			$("textLovInnerDiv").hide();
			$("textEnrolleeDiv").show();
			enableTxtLov(false);
			enableRcvryDate(false,"from");
			enableRcvryDate(false,"to");
			var txtDiv = $$('div#textDiv .textDiv input');
			for(var i=0;i<txtDiv.length;i++){
				txtDiv[i].value = "";
			}
		}
		clearTextFields();
		$("chkPerBusinessSource").checked = false;
		if(!$("chkPerEnrollee").checked && !$("chkPerPolicy").checked){
			$("chkNetOfRecovery").disabled = false;
			enableRcvryDate(true,"from");
			enableRcvryDate(true,"to");
			if($("chkNetOfRecovery").checked){
				$("txtDspRcvryFromDate").value = $F("txtDspFromDate");
				$("txtDspRcvryToDate").value = $F("txtDspToDate");
			}
		}
		setDateParameter(2);
		
		whenNewBlockE010Gicls202(1); //marco - 05.22.2015 - GENQA SR 4457
	});
	
	$("rdoClaimsRegister").observe("click", function(){
		setDateParameter(1);
		$("claimsRegisterDiv").show();
		$("textLovInnerDiv").show();
		$("brdrxDiv").hide();
		$("textEnrolleeDiv").hide();
		$("byPeriodDiv").hide();
		$("asOfDiv").hide();
		$("rdoByPeriod").checked = true;
		$("txtDspFromDate").removeClassName("disabled");
		$("txtDspToDate").removeClassName("disabled");
		$("intmDiv").hide();
		if($("chkPerLossCategory").checked){
			$("outerlossCategoryDiv").show();
			enableLossCategoryDiv(true);
		}else{
			$("outerlossCategoryDiv").hide();
			enableLossCategoryDiv(false);
		}
		$("policyDiv").hide();
		clearTextFields();
		$("chkPerIntermediary").checked = false;
		enableTxtLov(true);
		disableBranchOption(false);
		$("chkNetOfRecovery").checked = false;
		$("chkNetOfRecovery").disabled = true;
		enableRcvryDate(false,"from");
		enableRcvryDate(false,"to");
		$("txtDspRcvryFromDate").clear();
		$("txtDspRcvryToDate").clear();
		/*if($F("hidImplSw") == "Y"){
			$("outerlossCategoryDiv").show();
			enableLossCategoryDiv(true);
		}else{
			$("outerlossCategoryDiv").hide();
			enableLossCategoryDiv(false);
			$("trPerLossCategory").hide();
		} */
		setDateParameter(2);
		
		whenNewBlockE010Gicls202(2); //marco - 05.22.2015 - GENQA SR 4457
	});
	
	$("rdoOutstanding").observe("click", function(){
		setDateParameter(1);
		$("chkDspGrossTag").disabled = false;
		disableBrdrxDateOption(false);
		disableDateOption(false);
		$("asOfDiv").show();
		$("byPeriodDiv").show();
		$("txtDspAsOfDate").value = "";
		disablePaidDateOption(true);
		$("chkPerPolicy").checked = false;
		$("chkPerEnrollee").checked = false;
		var hideId = ["textEnrolleeDiv", "chkPerPolicyDiv", "chkPerEnrolleeDiv", "policyDiv"];
		hideDiv(hideId, "hide");
		var disableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "rdoClaimIssCd", "rdoPolicyIssCd", "chkNetOfRecovery"];
		disableChkRdo(disableId, false);
		enableTxtLov(true);
		setDateParameter(2);
	});
	
	$("rdoLossesPaid").observe("click", function(){
		setDateParameter(1);
		var falseId = ["rdoTranDate", "rdoPostingDate", "chkPerPolicy", "chkPerEnrollee", "chkNetOfRecovery"];
		disableChkRdo(falseId, false);
		var trueId = ["chkDspGrossTag", "rdoLossDate", "rdoClaimFileDate", "rdoBookingMonth"];
		disableChkRdo(trueId, true);
		var hideId = ["byPeriodDiv", "asOfDiv"];
		hideDiv(hideId, "hide");
		var showId = ["chkPerPolicyDiv", "chkPerEnrolleeDiv"];
		hideDiv(showId, "show");
		$("rdoByPeriod").checked = true;
		$("txtDspFromDate").removeClassName("disabled");
		$("txtDspToDate").removeClassName("disabled");
		enableRcvryDate(true, "from");
		enableRcvryDate(true, "to");
		if($("chkNetOfRecovery").checked){
			$("txtDspRcvryFromDate").value = $F("txtDspFromDate");
			$("txtDspRcvryToDate").value = $F("txtDspToDate");
		}else{
			$("txtDspRcvryFromDate").value = "";
			$("txtDspRcvryToDate").value = "";
		}
		setDateParameter(2);
	});
	
	$("rdoLossDate").observe("click", function(){
		setDateParameter(1);
		setDateParameter(2);
	});
	
	$("rdoClaimFileDate").observe("click", function(){
		setDateParameter(1);
		setDateParameter(2);
	});
	
	$("rdoBookingMonth").observe("click", function(){
		setDateParameter(1);
		setDateParameter(2);
	});
	
	
	$("chkPerBusinessSource").observe("click", function(){
		if($("chkPerBusinessSource").checked){
			$("intmDiv").show();
			enableIntmDiv(true);
		}else{
			$("intmDiv").hide();
		}
	});
	
	function toggleIntmDiv(id, id2){
		if($(id).checked){
			if($(id2).checked){
				$("intmDiv").show();
			}else{
				$("intmDiv").hide();
			}
		}else{
			if($(id2).checked){
				$("intmDiv").show();
			}else{
				$("intmDiv").hide();
			}	
		}
	}
	
	$("chkPerIssueSource").observe("click", function(){
		toggleIntmDiv("chkPerIssueSource", "chkPerBusinessSource");
	});
	
	$("chkPerLineSubline").observe("click", function(){
		toggleIntmDiv("chkPerLineSubline", "chkPerBusinessSource");
	});
	
	$("chkPerPolicy").observe("click", function(){
		if($("chkPerPolicy").checked){
			$("policyDiv").show();
			enablePolicyDiv(true);
			enableTxtLov(false);
			var disableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "chkPerEnrollee", "rdoClaimIssCd", "rdoPolicyIssCd", "chkNetOfRecovery"];
			disableChkRdo(disableId, true);
			enableRcvryDate(false, "from");
			enableRcvryDate(false, "to");
			var txtDiv = $$('div#textDiv .textDiv input');
			for(var i=0;i<txtDiv.length;i++){
				txtDiv[i].value = "";
			}
			if($("chkPerBusinessSource").checked){
				$("intmDiv").hide();
			}
			$("chkPerBusinessSource").checked = false;
			$("chkPerIssueSource").checked = false;
			$("chkPerLineSubline").checked = false;
			$("chkNetOfRecovery").checked = false;
			$("rdoLossExpense").disabled = false;
		}else{
			$("policyDiv").hide();
			enableTxtLov(true);
			var enableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "chkPerEnrollee", "rdoClaimIssCd", "rdoPolicyIssCd", "chkNetOfRecovery"];
			disableChkRdo(enableId, false);
			enableRcvryDate(true, "from");
			enableRcvryDate(true, "to");
		}
	});
	
	function enableEnrolleeDiv(enabled){
		if(enabled){
			$("txtDspEnrollee").removeClassName("disabled");
			$("txtDspControlType").removeClassName("disabled");
			$("dspControlTypeDiv").removeClassName("disabled");
			$("txtDspControlTypeName").removeClassName("disabled");
			$("txtDspControlNumber").removeClassName("disabled");
			enableSearch("searchControlTypeLOV");
		}else{
			$("txtDspEnrollee").addClassName("disabled");
			$("txtDspControlType").addClassName("disabled");
			$("dspControlTypeDiv").addClassName("disabled");
			$("txtDspControlTypeName").addClassName("disabled");
			$("txtDspControlNumber").addClassName("disabled");
			disableSearch("searchControlTypeLOV");
		}
	}
	
	$("chkPerEnrollee").observe("click", function(){
		if($("chkPerEnrollee").checked){
			$("textEnrolleeDiv").show();
			$("textLovInnerDiv").hide();
			var disableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "chkPerPolicy"];
			disableChkRdo(disableId, true);
			enableTxtLov(false);
			enableEnrolleeDiv(true);
			$("rdoClaimIssCd").disabled = true;
			$("rdoPolicyIssCd").disabled = true;
			$("chkNetOfRecovery").disabled = true;
			enableRcvryDate(false, "from");
			enableRcvryDate(false, "to");
			$("chkPerBusinessSource").checked = false;
			$("chkPerIssueSource").checked = false;
			$("chkPerLineSubline").checked = false;
			$("chkNetOfRecovery").checked = false;
			$("rdoLossExpense").disabled = false;
		}else{
			$("textEnrolleeDiv").hide();
			$("textLovInnerDiv").show();
			var enableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "chkPerPolicy"];
			disableChkRdo(enableId, false);
			enableTxtLov(true);
			enableEnrolleeDiv(false);
			$("rdoClaimIssCd").disabled = false;
			$("rdoPolicyIssCd").disabled = false;
			$("chkNetOfRecovery").disabled = false;
		}
	});
	
	$("chkPerLine").observe("click", function(){
		toggleIntmDiv("chkPerLine", "chkPerIntermediary");
	});
	
	$("chkPerBranch").observe("click", function(){
		toggleIntmDiv("chkPerBranch", "chkPerIntermediary");
		$("chkPerBranch").checked == true ? $("chkPerLossCategory").checked = false : "";
		$("lossCategoryDiv").hide();
		$("outerlossCategoryDiv").setStyle({height: '0px'});
	});
	
	$("chkPerIntermediary").observe("click", function(){
		if($("chkPerIntermediary").checked){
			$("intmDiv").show();
			enableIntmDiv(true);
		}else{
			$("intmDiv").hide();
		}
	});
	
	$("chkPerLossCategory").observe("click", function(){
		if($("chkPerLossCategory").checked){
			$("chkPerBranch").checked = false;
			$("lossCategoryDiv").show();
			$("outerlossCategoryDiv").show();
			$("outerlossCategoryDiv").setStyle({height: '23px'});
			if($("chkPerIntermediary").checked){
				$("intmDiv").show();
				enableIntmDiv(true);
			}else{
				$("intmDiv").hide();
			}
		}else{
			$("lossCategoryDiv").hide();
			$("outerlossCategoryDiv").hide();
			$("outerlossCategoryDiv").setStyle({height: '0px'});
			if($("chkPerIntermediary").checked){
				$("intmDiv").show();
				enableIntmDiv(true);
			}else{
				$("intmDiv").hide();
			}
		}
	});
	
	$("rdoByPeriod").observe("click", function(){
		enableByPeriodDate(true, "from");
		enableByPeriodDate(true, "to");
		enableAsOfDate(false);
		$("txtDspAsOfDate").clear();
		var txtDiv = $$('div#textDiv .textDiv input');
		for(var i=0;i<txtDiv.length;i++){
			txtDiv[i].value = "";
		}
	});
	
	$("rdoAsOf").observe("click", function(){
		enableByPeriodDate(false, "from");
		enableByPeriodDate(false, "to");
		enableAsOfDate(true);
		$("txtDspFromDate").clear();
		$("txtDspToDate").clear();
		var txtDiv = $$('div#textDiv .textDiv input');
		for(var i=0;i<txtDiv.length;i++){
			txtDiv[i].value = "";
		}
	});	
	
	// GICLS202-LOV start
	function getLineCdGicls202LOV(lineId){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getLineCdGicls202LOV",
							issCd : $F("txtDspIssCd"),
							issCd2 : $F("txtDspIssCd2"),
							moduleId : "GICLS202",
							filterText : ($(lineId).readAttribute("lastValidValue").trim() != $F(lineId).trim() ? $F(lineId).trim() : ""),
							page : 1},
			title: "List of Lines",
			width : 370,
			height : 386,
			columnModel : [ {
								id : "lineCd",
								title : "Line Code",
								width : '90px',
							}, 
							{
								id : "lineName",
								title : "Line Name",
								width : '265px'
							}],
				autoSelectOneRecord: true,
				filterText : ($(lineId).readAttribute("lastValidValue").trim() != $F(lineId).trim() ? $F(lineId).trim() : ""),
				onSelect: function(row) {
					if($("chkPerPolicy").checked){
						$("txtDspLineCd2").value = row.lineCd;
						$("txtDspLineCd2").setAttribute("lastValidValue", row.lineCd);
						$("txtDspSublineCd2").value = "";
					}else{
						$("txtDspLineCd").value = row.lineCd;
						$("txtDspLineCd").setAttribute("lastValidValue", row.lineCd);
						$("txtDspLineName").value = row.lineName;
						$("txtDspSublineCd").value = "";
						$("txtDspSublineCd").setAttribute("lastValidValue", "");
						$("txtDspSublineName").value = "";
						$("txtDspLossCatCd").value = "";
						$("txtDspLossCatCd").setAttribute("lastValidValue", "");
						$("txtDspLossCtgry").value = "";
						$("txtDspPerilCd").value = "";
						$("txtDspPerilCd").setAttribute("lastValidValue", "");
						$("txtDspPerilName").value = "";
					}
				},
				onCancel: function (){
					$(lineId).value = $(lineId).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(lineId).value = $(lineId).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("searchLineLOV").observe("click", function(){
		getLineCdGicls202LOV("txtDspLineCd");
	});
	$("txtDspLineCd").observe("change", function() {
		if($F("txtDspLineCd").trim() == "") {
			$("txtDspLineCd").value = "";
			$("txtDspLineCd").setAttribute("lastValidValue", "");
			$("txtDspLineName").value = "ALL LINES";
			$("txtDspSublineName").value = "ALL SUBLINES";
			$("txtDspSublineCd").value = "";
			$("txtDspSublineCd").setAttribute("lastValidValue", "");
			$("txtDspPerilName").value = "ALL PERILS";
			$("txtDspPerilCd").value = "";
			$("txtDspLossCatCd").value = "";
			$("txtDspLossCatCd").setAttribute("lastValidValue", "");
			$("txtDspLossCtgry").value = "";
		} else {
			if($F("txtDspLineCd").trim() != "" && $F("txtDspLineCd") != $("txtDspLineCd").readAttribute("lastValidValue")) {
				getLineCdGicls202LOV("txtDspLineCd");
			}
		}
	});
	
	$("searchLineCdLOV").observe("click", function(){
		getLineCdGicls202LOV("txtDspLineCd2");
	});
	$("txtDspLineCd2").observe("change", function() {
		if($F("txtDspLineCd2").trim() == "") {
			$("txtDspLineCd2").value = "";
			$("txtDspLineCd2").setAttribute("lastValidValue", "");
			$("txtDspSublineCd2").value = "";
		} else {
			if($F("txtDspLineCd2").trim() != "" && $F("txtDspLineCd2") != $("txtDspLineCd2").readAttribute("lastValidValue")) {
				getLineCdGicls202LOV("txtDspLineCd2");
			}
		}
	});
	
	function getSublineCd2Gicls202LOV(sublineId){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getSublineCd2Gicls202LOV",
							lineCd : $F("txtDspLineCd"),
							lineCd2 : $F("txtDspLineCd2"),
							perPolicy : $("chkPerPolicy").checked == true ? 1 : 0,
							filterText : ($(sublineId).readAttribute("lastValidValue").trim() != $F(sublineId).trim() ? $F(sublineId).trim() : ""),
							page : 1},
			title: "List of Sublines",
			width : 370,
			height : 386,
			columnModel : [ {
								id : "sublineCd",
								title : "Subline Code",
								width : '90px',
							}, 
							{
								id : "sublineName",
								title : "Subline Name",
								width : '265px'
							}],
				autoSelectOneRecord: true,
				filterText : ($(sublineId).readAttribute("lastValidValue").trim() != $F(sublineId).trim() ? $F(sublineId).trim() : ""),
				onSelect: function(row) {
					if($("chkPerPolicy").checked){
						$("txtDspSublineCd2").value = row.sublineCd;
						$("txtDspSublineCd2").setAttribute("lastValidValue", row.sublineCd);
					}else{
						$("txtDspSublineCd").value = row.sublineCd;
						$("txtDspSublineCd").setAttribute("lastValidValue", row.sublineCd);
						$("txtDspSublineName").value = unescapeHTML2(row.sublineName);
					}
				},
				onCancel: function (){
					$(sublineId).value = $(sublineId).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(sublineId).value = $(sublineId).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("searchSublineCdLOV").observe("click", function(){
		if($F("txtDspLineCd2") == ""){
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspSublineCd2");
		}else{
			getSublineCd2Gicls202LOV("txtDspSublineCd2");
		}
	});
	$("txtDspSublineCd2").observe("change", function() {
		if($F("txtDspLineCd2") != ""){
			if($F("txtDspSublineCd2").trim() == "") {
				$("txtDspSublineCd2").value = "";
				$("txtDspSublineCd2").setAttribute("lastValidValue", "");
			} else {
				if($F("txtDspSublineCd2").trim() != "" && $F("txtDspSublineCd2") != $("txtDspSublineCd2").readAttribute("lastValidValue")) {
					getSublineCd2Gicls202LOV("txtDspSublineCd2");
				}
			}
		}else{
			$("txtDspSublineCd2").value = "";
			$("txtDspSublineCd2").setAttribute("lastValidValue", "");
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspSublineCd2");
		}
	});
	$("searchSublineLOV").observe("click", function(){
		if($F("txtDspLineCd") == ""){
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspSublineCd");
		}else{
			getSublineCd2Gicls202LOV("txtDspSublineCd");
		}
	});
	$("txtDspSublineCd").observe("change", function() {
		if($F("txtDspLineCd") != ""){
			if($F("txtDspSublineCd").trim() == "") {
				$("txtDspSublineCd").value = "";
				$("txtDspSublineCd").setAttribute("lastValidValue", "");
				$("txtDspSublineName").value = "";
			} else {
				if($F("txtDspSublineCd").trim() != "" && $F("txtDspSublineCd") != $("txtDspSublineCd").readAttribute("lastValidValue")) {
					getSublineCd2Gicls202LOV("txtDspSublineCd");
				}
			}	
		}else{
			$("txtDspSublineCd").value = "";
			$("txtDspSublineCd").setAttribute("lastValidValue", "");
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspSublineCd");
		}
	});
	
	function getIssCd2Gicls202LOV(IssId){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getIssCd2Gicls202LOV",
							lineCd : $F("txtDspLineCd"),
							lineCd2 : $F("txtDspLineCd2"),
							moduleId : "GICLS202",
							filterText : ($(IssId).readAttribute("lastValidValue").trim() != $F(IssId).trim() ? $F(IssId).trim() : ""),
							page : 1},
			title: "List of Branches",
			width : 370,
			height : 386,
			columnModel : [ {
								id : "issCd",
								title : "Issue Code",
								width : '90px',
							}, 
							{
								id : "issName",
								title : "Issue Source Name",
								width : '265px'
							}],
				autoSelectOneRecord: true,
				filterText : ($(IssId).readAttribute("lastValidValue").trim() != $F(IssId).trim() ? $F(IssId).trim() : ""),
				onSelect: function(row) {
					if($("chkPerPolicy").checked){
						$("txtDspIssCd2").value = row.issCd;
						$("txtDspIssCd2").setAttribute("lastValidValue", row.issCd);
					}else{
						$("txtDspIssCd").value = row.issCd;
						$("txtDspIssCd").setAttribute("lastValidValue", row.issCd);
						$("txtDspIssName").value = unescapeHTML2(row.issName);
					}
				},
				onCancel: function (){
					$(IssId).value = $(IssId).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(IssId).value = $(IssId).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	$("searchBranchLOV").observe("click", function(){
		getIssCd2Gicls202LOV("txtDspIssCd");
	});
	$("txtDspIssCd").observe("change", function() {
		if($F("txtDspIssCd").trim() == "") {
			$("txtDspIssCd").value = "";
			$("txtDspIssCd").setAttribute("lastValidValue", "");
			$("txtDspIssName").value = "ALL BRANCHES";
		} else {
			if($F("txtDspIssCd").trim() != "" && $F("txtDspIssCd") != $("txtDspIssCd").readAttribute("lastValidValue")) {
				getIssCd2Gicls202LOV("txtDspIssCd");
			}
		}
	});
	$("searchIssCdLOV").observe("click", function(){
		getIssCd2Gicls202LOV("txtDspIssCd2");
	});
	$("txtDspIssCd2").observe("change", function() {
		if($F("txtDspIssCd2").trim() == "") {
			$("txtDspIssCd2").value = "";
			$("txtDspIssCd2").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspIssCd2").trim() != "" && $F("txtDspIssCd2") != $("txtDspIssCd2").readAttribute("lastValidValue")) {
				getIssCd2Gicls202LOV("txtDspIssCd2");
			}
		}
	});
	
	function getPerilCdGicls202LOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getPerilCdGicls202LOV",
							lineCd : $F("txtDspLineCd"),
							filterText : ($("txtDspPerilCd").readAttribute("lastValidValue").trim() != $F("txtDspPerilCd").trim() ? $F("txtDspPerilCd").trim() : ""),
							page : 1},
			title: "List of Perils",
			width : 370,
			height : 386,
			columnModel : [ {
								id : "perilCd",
								title : "Peril Code",
								width : '90px',
								align : 'right'
							}, 
							{
								id : "perilName",
								title : "Peril Name",
								width : '265px'
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtDspPerilCd").readAttribute("lastValidValue").trim() != $F("txtDspPerilCd").trim() ? $F("txtDspPerilCd").trim() : ""),
				onSelect: function(row) {
					$("txtDspPerilCd").value = row.perilCd;	
					$("txtDspPerilCd").setAttribute("lastValidValue", row.perilCd);
					$("txtDspPerilName").value = unescapeHTML2(row.perilName);
				},
				onCancel: function (){
					$("txtDspPerilCd").value = $("txtDspPerilCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDspPerilCd").value = $("txtDspPerilCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("searchPerilLOV").observe("click", function(){
		if($F("txtDspLineCd") == ""){
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspLineCd");
		}else{
			getPerilCdGicls202LOV();
		}
	});
	$("txtDspPerilCd").observe("change", function() {
		if($F("txtDspLineCd") != ""){
			if($F("txtDspPerilCd").trim() == "") {
				$("txtDspPerilCd").value = "";
				$("txtDspPerilCd").setAttribute("lastValidValue", "");
				$("txtDspPerilName").value = "";
			} else {
				if($F("txtDspPerilCd").trim() != "" && $F("txtDspPerilCd") != $("txtDspPerilCd").readAttribute("lastValidValue")) {
					getPerilCdGicls202LOV();
				}
			}	
		}else{
			$("txtDspPerilCd").value = "";
			$("txtDspPerilCd").setAttribute("lastValidValue", "");
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspLineCd");
		}
	});
	
	function getLossCatCdGicls202LOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getLossCatCdGicls202LOV",
							lineCd : $F("txtDspLineCd"),
							filterText : ($("txtDspLossCatCd").readAttribute("lastValidValue").trim() != $F("txtDspLossCatCd").trim() ? $F("txtDspLossCatCd").trim() : ""),
							page : 1},
			title: "List of Loss Categories",
			width : 370,
			height : 386,
			columnModel : [ {
								id : "lossCatCd",
								title : "Loss Category Code",
								width : '120px',
							}, 
							{
								id : "lossCatDesc",
								title : "Loss Category Description",
								width : '235px'
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtDspLossCatCd").readAttribute("lastValidValue").trim() != $F("txtDspLossCatCd").trim() ? $F("txtDspLossCatCd").trim() : ""),
				onSelect: function(row) {
					$("txtDspLossCatCd").value = row.lossCatCd;	
					$("txtDspLossCatCd").setAttribute("lastValidValue", row.lossCatCd);
					$("txtDspLossCtgry").value = unescapeHTML2(row.lossCatDesc);
				},
				onCancel: function (){
					$("txtDspLossCatCd").value = $("txtDspLossCatCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDspLossCatCd").value = $("txtDspLossCatCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("searchLossCategoryLOV").observe("click", function(){
		if($F("txtDspLineCd") == ""){
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspLineCd");
		}else{
			getLossCatCdGicls202LOV();
		}
	});
	$("txtDspLossCatCd").observe("change", function() {
		if($F("txtDspLineCd") != ""){
			if($F("txtDspLossCatCd").trim() == "") {
				$("txtDspLossCatCd").value = "";
				$("txtDspLossCatCd").setAttribute("lastValidValue", "");
				$("txtDspLossCtgry").value = "";
			} else {
				if($F("txtDspLossCatCd").trim() != "" && $F("txtDspLossCatCd") != $("txtDspLossCatCd").readAttribute("lastValidValue")) {
					getLossCatCdGicls202LOV();
				}
			}	
		}else{
			$("txtDspLossCatCd").value = "";
			$("txtDspLossCatCd").setAttribute("lastValidValue", "");
			customShowMessageBox("Option not allowed for ALL LINES.", "I", "txtDspLineCd");
		}
	});
	
	function getIntmNoGicls202LOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getIntmNoGicls202LOV",
							filterText : ($("txtDspIntmNo").readAttribute("lastValidValue").trim() != $F("txtDspIntmNo").trim() ? $F("txtDspIntmNo").trim() : ""),
							page : 1},
			title: "List of Intermediaries",
			width : 420,
			height : 386,
			columnModel : [ {
								id : "intmNo",
								title : "Intermediary No.",
								align : 'right',
								width : '100px',
							}, 
							{
								id : "intmName",
								title : "Intermediary Name",
								width : '305px'
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtDspIntmNo").readAttribute("lastValidValue").trim() != $F("txtDspIntmNo").trim() ? $F("txtDspIntmNo").trim() : ""),
				onSelect: function(row) {
					$("txtDspIntmNo").value = row.intmNo;	
					$("txtDspIntmNo").setAttribute("lastValidValue", row.intmNo);
					$("txtDspIntmName").value = unescapeHTML2(row.intmName);
				},
				onCancel: function (){
					$("txtDspIntmNo").value = $("txtDspIntmNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDspIntmNo").value = $("txtDspIntmNo").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("searchIntmLOV").observe("click", getIntmNoGicls202LOV);
	
	$("txtDspIntmNo").observe("change", function() {
		if($F("txtDspIntmNo").trim() == "") {
			$("txtDspIntmNo").value = "";
			$("txtDspIntmNo").setAttribute("lastValidValue", "");
			$("txtDspIntmName").value = "";
		} else {
			if($F("txtDspIntmNo").trim() != "" && $F("txtDspIntmNo") != $("txtDspIntmNo").readAttribute("lastValidValue")) {
				getIntmNoGicls202LOV();
			}
		}	
	});
	
	function getControlTypeCdGicls202LOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getControlTypeCdGicls202LOV",
							filterText : ($("txtDspControlType").readAttribute("lastValidValue").trim() != $F("txtDspControlType").trim() ? $F("txtDspControlType").trim() : ""),
							page : 1},
			title: "List of Control Types",
			width : 370,
			height : 386,
			columnModel : [ {
								id : "controlTypeCd",
								title : "Control Type Code",
								width : '110px',
								align : 'right'
							}, 
							{
								id : "controlTypeDesc",
								title : "Control Type Description",
								width : '245px'
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtDspControlType").readAttribute("lastValidValue").trim() != $F("txtDspControlType").trim() ? $F("txtDspControlType").trim() : ""),
				onSelect: function(row) {
					$("txtDspControlType").value = row.controlTypeCd;
					$("txtDspControlType").setAttribute("lastValidValue", row.controlTypeCd);
					$("txtDspControlTypeName").value = unescapeHTML2(row.controlTypeDesc);
				},
				onCancel: function (){
					$("txtDspControlType").value = $("txtDspControlType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDspControlType").value = $("txtDspControlType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("searchControlTypeLOV").observe("click", getControlTypeCdGicls202LOV);
	$("txtDspControlType").observe("change", function() {
		if($F("txtDspControlType").trim() == "") {
			$("txtDspControlType").value = "";
			$("txtDspControlType").setAttribute("lastValidValue", "");
			$("txtDspControlTypeName").value = "";
		} else {
			if($F("txtDspControlType").trim() != "" && $F("txtDspControlType") != $("txtDspControlType").readAttribute("lastValidValue")) {
				getControlTypeCdGicls202LOV();
			}
		}
	});
	
	function getEnrolleeGicls202LOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getEnrolleeGicls202LOV",
							filterText : ($("txtDspEnrollee").readAttribute("lastValidValue").trim() != $F("txtDspEnrollee").trim() ? $F("txtDspEnrollee").trim() : ""),
							page : 1},
			title: "List of Enrollees",
			width: 400,
			height: 386,
			columnModel : [ {
								id: "groupedItemTitle",
								title: "Enrolleee",
								width : '387px',
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtDspEnrollee").readAttribute("lastValidValue").trim() != $F("txtDspEnrollee").trim() ? $F("txtDspEnrollee").trim() : ""),
				onSelect: function(row) {
					$("txtDspEnrollee").value = row.groupedItemTitle;
					$("txtDspEnrollee").setAttribute("lastValidValue", row.groupedItemTitle);
				},
				onCancel: function (){
					$("txtDspEnrollee").value = $("txtDspEnrollee").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDspEnrollee").value = $("txtDspEnrollee").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	
	$("imgDspEnrollee").observe("click", getEnrolleeGicls202LOV);
	$("txtDspEnrollee").observe("change", function() {
		if($F("txtDspEnrollee").trim() == "") {
			$("txtDspEnrollee").value = "";
			$("txtDspEnrollee").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspEnrollee").trim() != "" && $F("txtDspEnrollee") != $("txtDspEnrollee").readAttribute("lastValidValue")) {
				getEnrolleeGicls202LOV();
			}
		}
	});
	// GICLS202-LOV end
	
	function doKeyUp(id){
		$(id).observe("keyup", function(){
			$(id).value = $(id).value.toUpperCase();
		});
	}
	
	doKeyUp("txtDspLineCd2");
	doKeyUp("txtDspSublineCd2");
	doKeyUp("txtDspIssCd2");
	
	function validateNumberFields(id, decimal, form){
		if($F(id) != ""){
			if(isNaN($F(id))){
				$(id).clear();
				customShowMessageBox("Field must be of form "+ form + ".", "E", id);
			}else{
				$(id).value = formatNumberDigits($F(id), decimal);
			}
		}
	}
	$("txtDspIssueYy").observe("change", function(){validateNumberFields("txtDspIssueYy", 2, "09");});
	$("txtDspPolSeqNo").observe("change", function(){validateNumberFields("txtDspPolSeqNo", 6, "099999");});
	$("txtDspRenewNo").observe("change", function(){validateNumberFields("txtDspRenewNo", 2, "09");});
	
	doKeyUp("txtDspLineCd");
	doKeyUp("txtDspSublineCd");
	doKeyUp("txtDspIssCd");
	doKeyUp("txtDspLossCatCd");
	doKeyUp("txtDspIntmNo");
	doKeyUp("txtDspControlType");
	
	function validateIntmNo(intmNo){
		new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateIntmNoGicls202",{
			parameters: {
				intmNo : intmNo
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if($F("txtDspIntmNo") != ""){
					if(response.responseText != ""){
						$("txtDspIntmName").value = response.responseText;
					}else{
						$("txtDspIntmNo").clear();
						fireEvent($("searchIntmLOV"), "click");
					}
				}
			}
		});	
	}
	
	$("chkNetOfRecovery").observe("click", function(){
		if($("chkNetOfRecovery").checked){
			$("txtDspRcvryFromDate").value = $F("txtDspFromDate");
			$("txtDspRcvryToDate").value = $F("txtDspToDate");
			$("rdoLossExpense").disabled = true;
			if($("rdoLossExpense").checked){
				$("rdoLoss").checked = true;
			}
		}else{
			$("txtDspRcvryFromDate").value = "";
			$("txtDspRcvryToDate").value = "";
			$("rdoLossExpense").disabled = false;
		}
	});
	
	function checkDate(from, to){
		var result = false;
		if((from != "") && (to != "")){
			if(Date.parse(from) > Date.parse(to)){
				result = true;
			}
		}
		return result;
	}
	
	$("imgDspFromDate").observe("click", function(){
		scwShow($("txtDspFromDate"),this, null);
	});
	
	$("txtDspFromDate").observe("focus", function(){
		if(checkDate($F("txtDspFromDate"), $F("txtDspToDate"))){
			$("txtDspFromDate").clear();
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtDspFromDate");
		}
	});
	
	$("imgDspToDate").observe("click", function(){
		scwShow($("txtDspToDate"),this, null);
	});
	
	$("txtDspToDate").observe("focus", function(){
		if(checkDate($F("txtDspFromDate"), $F("txtDspToDate"))){
			$("txtDspToDate").clear();
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtDspToDate");
		}
	});
	
	$("imgDspAsOfDate").observe("click", function(){
		scwShow($("txtDspAsOfDate"),this, null);
	});
	
	$("imgFmRcvryDate").observe("click", function(){
		scwShow($("txtDspRcvryFromDate"),this, null);
	});
	
	$("txtDspRcvryFromDate").observe("blur", function(){
		if(checkDate($F("txtDspRcvryFromDate"), $F("txtDspRcvryToDate"))){
			$("txtDspRcvryFromDate").clear();
			customShowMessageBox("Starting date should not be greater than end date.", "I", "txtDspRcvryFromDate");
		}
	});
	
	$("imgToRcvryDate").observe("click", function(){
		scwShow($("txtDspRcvryToDate"),this, null);
	});
	
	$("txtDspRcvryToDate").observe("blur", function(){
		if(checkDate($F("txtDspRcvryFromDate"), $F("txtDspRcvryToDate"))){
			$("txtDspRcvryToDate").clear();
			customShowMessageBox("Starting date should not be greater than end date.", "I", "txtDspRcvryToDate");
		}
	});
	
	function checkExtractParams(){
		var branchOption = $("rdoClaimIssCd").checked == true ? 1 : 2;
		var brdrxDateOption = $("rdoLossDate").checked == true ? 1 : $("rdoClaimFileDate").checked == true ? 2 : 3;
		var brdrxOption = $("rdoLoss").checked == true ? 1 : $("rdoExpense").checked ? 2 : 3;
		var brdrxType = $("rdoOutstanding").checked == true ? 1 : 2;
		var dateOption = $("rdoByPeriod").checked == true ? 1 : 2;
						/* dspLineCd2 = $F("txtDspLineCd2");
						dspSublineCd2 = $F("txtDspSublineCd2");
						dspIssCd2 = $F("txtDspIssCd2");
						dspIssueYy = $F("txtDspIssueYy");
						dspPolSeqNo = $F("txtDspPolSeqNo");
						dspRenewNo = $F("txtDspRenewNo"); */
		var dspGrossTag = $("chkDspGrossTag").checked == true ? 1 : 0;
		var netRcvryChkbx = $("chkNetOfRecovery").checked == true ? "Y" : "N";
		var paidDateOption = $("rdoTranDate").checked == true ? 1 : 2;
		var perBuss = $("chkPerBusinessSource").checked == true ? 1 : 0;
		var perEnrollee = $("chkPerEnrollee").checked == true ? 1 : 0;
		var perIntermediary = $("chkPerIntermediary").checked == true ? 1 : 0;
		var perIss = $("chkPerBranch").checked == true ? 1 : 0;
		var perIssource = $("chkPerIssueSource").checked == true ? 1 : 0;
		var perLine = $("chkPerLine").checked == true ? 1 : 0;
		var perLineSubline = $("chkPerLineSubline").checked == true ? 1 : 0;
		var perLossCat = $("chkPerLossCategory").checked == true ? 1 : 0;
		var perPolicy = $("chkPerPolicy").checked == true ? 1 : 0;
		var regButton = $("rdoPerLoss").checked == true ? 1 : 2;
		var repName = $("rdoBordereaux").checked == true ? 1 : 2;
		
		if((extractParam.branchOption == branchOption) && (extractParam.brdrxDateOption == brdrxDateOption) && (extractParam.brdrxOption == brdrxOption)
				&& (extractParam.brdrxType == brdrxType) && (extractParam.dateOption == dateOption) && (extractParam.dspAsOfDate == nvl($F("txtDspAsOfDate"), null))
				&& (extractParam.dspFromDate == nvl($F("txtDspFromDate"), null)) && (extractParam.dspToDate == nvl($F("txtDspToDate"), null)) && (extractParam.dspGrossTag == dspGrossTag)
				&& (extractParam.intmNo == nvl($F("txtDspIntmNo"), null)) && (extractParam.issCd == nvl($F("txtDspIssCd"), null)) && (extractParam.lineCd == nvl($F("txtDspLineCd"), null))
				&& (extractParam.lossCatCd == nvl($F("txtDspLossCatCd"), null)) && (extractParam.perilCd == nvl($F("txtDspPerilCd"), null)) && (extractParam.dspRcvryFromDate == nvl($F("txtDspRcvryFromDate"), null))
				&& (extractParam.dspRcvryToDate == nvl($F("txtDspRcvryToDate"), null)) && (extractParam.sublineCd == nvl($F("txtDspSublineCd"), null)) && (extractParam.enrollee == nvl($F("txtDspEnrollee"), null))
				&& (extractParam.controlType == nvl($F("txtDspControlType"), null)) && (extractParam.controlNumber == nvl($F("txtDspControlNumber"), null)) && (extractParam.netRcvryChkbx == netRcvryChkbx)
				&& (extractParam.paidDateOption == paidDateOption) && (extractParam.perBussParam == perBuss) && (extractParam.perEnrolleeParam == perEnrollee)
				&& (extractParam.perIntmParam == perIntermediary) && (extractParam.perBranchParam == perIss) && (extractParam.perIssourceParam == perIssource)
				&& (extractParam.perLineParam == perLine) && (extractParam.perLineSublineParam == perLineSubline) && (extractParam.perLossCatParam == perLossCat)
				&& (extractParam.perPolicyParam == perPolicy) && (extractParam.regButton == regButton) && (extractParam.repName == repName)){
			
			showConfirmBox("", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No", extractGicls202, null, "");
		}else{
			extractGicls202();
		}
	}
	
	var objGicls202 = new Object();
	
	$("btnExtract").observe("click", function(){
		/* if(mes != ""){
			showMessageBox(mes, mesType);
			return false;
		} */
		if(!validateDate()){
			showMessageBox("Please specify the period for extraction.", "I");
		}else{
			objGicls202.intmBreak = $("chkPerBusinessSource").checked == true ? 1 : 0;
			objGicls202.issdBreak = $("chkPerIssueSource").checked == true ? 1 : 0;
			objGicls202.sublBreak = $("chkPerLineSubline").checked == true ? 1 : 0;
			if($("chkPerPolicy").checked == false){
				checkPerPolicy();	
			}
			checkExtractParams();
		}
	});
	
	function validateDate(){
		var result = true;
		if($("rdoByPeriod").checked){
			if($F("txtDspFromDate") == "" || $F("txtDspToDate") == ""){
				result = false;
			}
		}else if($("rdoAsOf").checked){
			if($F("txtDspAsOfDate") == ""){
				result = false;
			}
		}
		return result;
	}
	
	function checkPerPolicy(){
		//if($("chkPerPolicy").checked == false){
			if($F("txtDspLineCd") == ""){ $("txtDspLineName").value = "ALL LINES";}
			if($F("txtDspSublineCd") == ""){ $("txtDspSublineName").value = "ALL SUBLINES"; }
			if($F("txtDspIssCd") == ""){ $("txtDspIssName").value = "ALL BRANCHES"; }
			if($F("txtDspPerilCd") == ""){ $("txtDspPerilName").value = "ALL PERILS"; }
			if($F("txtDspIntmNo") == ""){ $("txtDspIntmName").value = "ALL INTERMEDIARIES"; }
			if($F("txtDspLossCatCd") == ""){ $("txtDspLossCtgry").value = "ALL LOSS CATEGORIES"; }
		//}
	}
	
	function extractGicls202(){
		try{
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=extractGicls202",{
				parameters: {
					branchOption : $("rdoClaimIssCd").checked == true ? 1 : 2,
					brdrxDateOption : $("rdoLossDate").checked == true ? 1 : $("rdoClaimFileDate").checked == true ? 2 : 3,
					brdrxOption : $("rdoLoss").checked == true ? 1 : $("rdoExpense").checked ? 2 : 3,
					brdrxType : $("rdoOutstanding").checked == true ? 1 : 2,
					clmExpPayeeType : $F("hidClmExpPayeeType"),
					clmLossPayeeType : $F("hidClmLossPayeeType"),
					dateOption : $("rdoByPeriod").checked == true ? 1 : 2,
					dspAsOfDate : $F("txtDspAsOfDate"),
					dspFromDate : $F("txtDspFromDate"),
					dspToDate : $F("txtDspToDate"),
					dspLineCd2 : $F("txtDspLineCd2"),
					dspSublineCd2 : $F("txtDspSublineCd2"),
					dspIssCd2 : $F("txtDspIssCd2"),
					dspIssueYy : $F("txtDspIssueYy"),
					dspPolSeqNo : $F("txtDspPolSeqNo"),
					dspRenewNo : $F("txtDspRenewNo"),
					dspGrossTag : $("chkDspGrossTag").checked == true ? 1 : 0,
					dspIntmNo : $F("txtDspIntmNo"),
					dspIssCd : $F("txtDspIssCd"),
					dspLineCd : $F("txtDspLineCd"),
					dspLossCatCd : $F("txtDspLossCatCd"),
					dspPerilCd : $F("txtDspPerilCd"),
					dspRcvryFromDate : $F("txtDspRcvryFromDate"),
					dspRcvryToDate : $F("txtDspRcvryToDate"),
					dspSublineCd : $F("txtDspSublineCd"),
					dspEnrollee : $F("txtDspEnrollee"),
					dspControlType : $F("txtDspControlType"),
					dspControlNumber : $F("txtDspControlNumber"),
					netRcvryChkbx : $("chkNetOfRecovery").checked == true ? "Y" : "N",
					paidDateOption : $("rdoTranDate").checked == true ? 1 : 2,
					perBuss : $("chkPerBusinessSource").checked == true ? 1 : 0,
					perEnrollee : $("chkPerEnrollee").checked == true ? 1 : 0,
					perIntermediary : $("chkPerIntermediary").checked == true ? 1 : 0,
					perIss : $("chkPerBranch").checked == true ? 1 : 0,
					perIssource : $("chkPerIssueSource").checked == true ? 1 : 0,
					perLine : $("chkPerLine").checked == true ? 1 : 0,
					perLineSubline : $("chkPerLineSubline").checked == true ? 1 : 0,
					perLossCat : $("chkPerLossCategory").checked == true ? 1 : 0,
					perPolicy : $("chkPerPolicy").checked == true ? 1 : 0,
					regButton : $("rdoPerLoss").checked == true ? 1 : 2,
					repName : $("rdoBordereaux").checked == true ? 1 : 2,
					riIssCd : $F("hidRiIssCd")
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Extracting... "),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						checkCount(response.responseText, "");					
					}
				}
			});
		}catch(e){
			showErrorMessage("GICLS202 - Extract: ", e);
		}
		
	}
	
	function checkCount(count, implSw){
		if(count > 0){
			showMessageBox("Extraction finished. " + count + " records extracted.", "I");
			currParam = 0;
			extract = true;
			toggleFormAfterExtract(implSw);
		}else if(count == 0){
			showMessageBox("Extraction finished.  No records extracted.", "I");
			currParam = 0;
		}
	}
	
	function toggleFormAfterExtract(implSw){
		if($("rdoBordereaux").checked){
			var disableId = ["chkPerBusinessSource", "chkPerIssueSource", "chkPerLineSubline", "rdoOutstanding", "rdoLossesPaid", "rdoLoss", 
			                "rdoExpense", "rdoLossExpense", "rdoLossDate", "rdoClaimFileDate", "rdoBookingMonth", "chkDspGrossTag", "rdoTranDate",
			                "rdoPostingDate", "rdoAsOf", "rdoByPeriod", "rdoBordereaux", "rdoClaimsRegister", "rdoClaimIssCd", "rdoPolicyIssCd"];
			disableChkRdo(disableId, true);
			enableAsOfDate(false);
			if($("rdoLossesPaid").checked){
				$("chkPerPolicy").disabled = true;
				$("chkPerEnrollee").disabled = true;
				if($("chkPerPolicy").checked){
					enablePolicyDiv(false);
				}
				if($("chkPerEnrollee").checked){
					$("txtDspEnrollee").addClassName("disabled");
					$("txtDspControlType").addClassName("disabled");
					$("dspControlTypeDiv").addClassName("disabled");
					disableSearch("searchControlTypeLOV");
					$("txtDspControlTypeName").addClassName("disabled");
					$("txtDspControlNumber").addClassName("disabled");
				}
			}
		}else if($("rdoClaimsRegister").checked){
			var disableId = ["chkPerLine", "chkPerBranch", "chkPerIntermediary", "chkPerLossCategory", "rdoBordereaux", "rdoClaimsRegister", 
				             "rdoClaimIssCd", "rdoPolicyIssCd", "rdoPerLoss", "rdoPerFile"];
			disableChkRdo(disableId, true);
		}
		enableByPeriodDate(false, "from");
		enableByPeriodDate(false, "to");
		enableTxtLov(false);
		$("btnPrintGicls202").focus();
	}
	
	$("btnPrintGicls202").observe("click", function(){
		/* if(mes != ""){
			showMessageBox(mes, mesType);
			return false;
		} */
		/* if((nvl(objGicls202.intmBreak, 0) != ($("chkPerBusinessSource").checked == true ? 1 : 0)) ||
			(nvl(objGicls202.issdBreak, 0) != ($("chkPerIssueSource").checked == true ? 1 : 0)) ||
			(nvl(objGicls202.sublBreak, 0) != ($("chkPerLineSubline").checked == true ? 1 : 0))){
			showConfirmBox("", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No", 
							function(){
								fireEvent("btnExtract", "click");
							}, null, "");
		}else */ if(currParam == 1){
			showConfirmBox("", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No", 
					function(){
						fireEvent($("btnExtract"), "click");
					}, null, "");
		}else{
			validatePrintGicls202();	
		}
	});
	
	function validatePrintGicls202(){
		new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=printGicls202",{
			parameters: {
				repName : $("rdoBordereaux").checked == true ? 1 : 2
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				objGicls202.exist = res.exist;
				objGicls202.sessionId = res.sessionId;
				if(res.message == null){
					printGicls202();
				}else{
					if(res.sessionId > 0){
						showConfirmBox("", res.message, "Ok", "Cancel", printGicls202, "", "");
					}else{
						showMessageBox(res.message, "I");	
					}
				}
			}
		});	
	}
	
	function printGicls202(){
		reportSelected = false;
		if($("chkPerEnrollee").checked == true){
			if($F("txtDspControlType") == ""){
				$("txtDspControlTypeName").value = "ALL CONTROL TYPES";			
			}
		}else{
			checkPerPolicy();
		}
		if($("rdoBordereaux").checked){
			showGenericPrintDialog("Print Bordereaux", onOkPrintBrdrxGicls202, onLoadPrintBrdrxGicls202, true);	
		}else{
			showGenericPrintDialog("Print Claims Register", onOkPrintClmsRegGicls202, onLoadPrintClmsRegGicls202, true);
		}
	}
	
	var addtlParams = "";
	
	function onOkPrintBrdrxGicls202(){
		if($("rdoBordereaux").checked){
			if($("rdoOutstanding").checked){ // brdrx_type - Outstanding
				if($("chkNetOfRecovery").checked == false){
					if($("rdoLoss").checked){ // brdrx_option - Loss
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR205L", "OUTSTANDING BORDEREAUX (LOSSES)");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR208L", "Outstanding Loss Distribution Register");
						}
						if($("chkSummary").checked){
							var checked = false;
							// bonok :: 1.17.2017 :: FGIC SR 23448 start
							$w("chkPerBusinessSource chkPerIssueSource chkPerLineSubline").each(function(c){
								if($(c).checked){
									addtlParams = "&chkOption="+c;
									printReportGicls202("GICLR208A", "Outstanding Loss Register");
									checked = true;
								}
							});
							if(!checked){
								addtlParams = "&chkOption=none";
								printReportGicls202("GICLR208A", "Outstanding Loss Register");
								checked = false;
							}
							// bonok :: 1.17.2017 :: FGIC SR 23448 end
						}
						if($("chkAging").checked){
							printReportGicls202("GICLR208C", "OUTSTANDING LOSS REGISTER WITH AGING");
						}
					}else if($("rdoExpense").checked){ // brdrx_option - Expense
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR205E", "OUTSTANDING BORDEREAUX (EXPENSES)");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR208E", "Outstanding Loss Expense Distribution Register");
						}
						if($("chkSummary").checked){
							printReportGicls202("GICLR208B", "Outstanding Loss Expense Register");
						}
						if($("chkAging").checked){
							printReportGicls202("GICLR208D", "OUTSTANDING LOSS EXPENSE REGISTER WITH AGING");
						}
					}else if($("rdoLossExpense").checked){ // brdrx_option - Loss+Expense
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR205LE", "OUTSTANDING BORDEREAUX (LOSSES & EXPENSES)");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR208LE", "OUTSTANDING LOSS AND EXPENSE DISTRIBUTION REGISTER");
						}
					}
				}else{ // net of recovery chkbx = Y
					if($("rdoLoss").checked){ // brdrx_option - Loss
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR205LR", "OUTSTANDING BORDEREAUX - NET OF RECOVERY (LOSSES)");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR208LR", "Outstanding Loss Distribution Register");
						}
						if($("chkSummary").checked){
							printReportGicls202("GICLR208AR", "Outstanding Loss Register");
						}
						if($("chkAging").checked){
							printReportGicls202("GICLR208CR", "OUTSTANDING LOSS REGISTER WITH AGING");
						}
					}else if($("rdoExpense").checked){ // brdrx_option - Expense
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR205ER", "OUTSTANDING BORDEREAUX - NET OF RECOVERY (LOSSES)");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR208ER", "Outstanding Loss Expense Distribution Register");
						}
						if($("chkSummary").checked){
							printReportGicls202("GICLR208BR", "Outstanding Loss Expense Register");
						}
						if($("chkAging").checked){
							printReportGicls202("GICLR208DR", "OUTSTANDING LOSS REGISTER WITH AGING");
						}
					}
				}
			}else if($("rdoLossesPaid").checked){ // brdrx_type - Losses Paid
				if($("chkNetOfRecovery").checked == false){
					if($("rdoLoss").checked){ // brdrx_option - Loss
						if($("chkBrdrx").checked){
							if($("chkPerPolicy").checked){
								printReportGicls202("GICLR222L", "LOSSES PAID BORDEREAUX (PER POLICY)");	
							}else if($("chkPerEnrollee").checked){
								printReportGicls202("GICLR221L", "LOSSES PAID BORDEREAUX (PER ENROLLEE)");
							}else{
								printReportGicls202("GICLR206L", "LOSSES PAID BORDEREAUX");
							}
						}
						if($("chkDistReg").checked && ($("chkPerPolicy").checked == false) && ($("chkPerEnrollee").checked == false)){
							printReportGicls202("GICLR209L", "Losses Paid Distribution Register");
						}
						if($("chkSummary").checked && ($("chkPerPolicy").checked == false) && ($("chkPerEnrollee").checked == false)){
							printReportGicls202("GICLR209A", "Losses Paid Register");
						}
					}else if($("rdoExpense").checked){ // brdrx_option - Expense
						if($("chkBrdrx").checked){
							if($("chkPerPolicy").checked){
								printReportGicls202("GICLR222E", "EXPENSES PAID BORDEREAUX (PER POLICY)");	
							}else if($("chkPerEnrollee").checked){
								printReportGicls202("GICLR221E", "EXPENSES PAID BORDEREAUX (PER ENROLLEE)");
							}else{
								printReportGicls202("GICLR206E", "LOSS EXPENSES PAID BORDEREAUX");
							}
						}
						if($("chkDistReg").checked && ($("chkPerPolicy").checked == false) && ($("chkPerEnrollee").checked == false)){
							printReportGicls202("GICLR209E", "Loss Expenses Paid Distribution Register");
						}
						if($("chkSummary").checked && ($("chkPerPolicy").checked == false) && ($("chkPerEnrollee").checked == false)){
							printReportGicls202("GICLR209B", "Loss Expenses Paid Register");
						}
					}else if($("rdoLossExpense").checked){ // brdrx_option - Loss+Expense
						if($("chkBrdrx").checked){
							if($("chkPerPolicy").checked){
								printReportGicls202("GICLR222LE", "LOSS EXPENSE PAID BORDEREAUX (PER POLICY)");	
							}else if($("chkPerEnrollee").checked){
								printReportGicls202("GICLR221LE", "LOSS EXPENSE PAID BORDEREAUX (PER ENROLLEE)");
							}else{
								printReportGicls202("GICLR206LE", "LOSSES & EXPENSES PAID BORDEREAUX");
							}
						}
						if($("chkDistReg").checked && ($("chkPerPolicy").checked == false) && ($("chkPerEnrollee").checked == false)){
							printReportGicls202("GICLR209LE", "LOSSES & EXPENSES PAID DISTRIBUTION REGISTER");
						}
					}
					if($("chkXol").checked && ($("chkPerPolicy").checked == false) && ($("chkPerEnrollee").checked == false)){
						printReportGicls202("GICLR206X", "XOL REGISTER");
					}
				}else{ // net of recovery chkbx = Y
					if($("rdoLoss").checked){ // brdrx_option - Loss
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR206LR", "LOSSES PAID BORDEREAUX NET OF RECOVERY");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR209LR", "LOSSES PAID DISTRIBUTION REGISTER NET OF RECOVERY");
						}
						if($("chkSummary").checked){
							printReportGicls202("GICLR209AR", "LOSSES PAID REGISTER NET OF RECOVERY");
						}
					}else if($("rdoExpense").checked){ // brdrx_option - Expense
						if($("chkBrdrx").checked){
							printReportGicls202("GICLR206ER", "LOSS EXPENSES PAID BORDEREAUX NET OF RECOVERY");
						}
						if($("chkDistReg").checked){
							printReportGicls202("GICLR209ER", "LOSS EXPENSES PAID DISTRIBUTION REGISTER NET OF RECOVERY");
						}
						if($("chkSummary").checked){
							showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
							//printReportGicls202("GICLR209BR", "LOSS EXPENSES PAID REGISTER NET OF RECOVERY");
						}
					}
					if($("chkXol").checked){
						printReportGicls202("GICLR206XR", "LOSSES PAID XOL DISTRIBUTION REGISTER NET OF RECOVERY");
					}
				}
			}
		}//$("rdoBordereaux").checked
		
		// apollo 08.07.2015 - SR#4846 - to prevent printing without a selected report
		if(!reportSelected) {
			showMessageBox("Please select at least one report to print.", "I");
			return;
		}
		
		reportSelected = false;
		
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
		$("btnPrintCancel").value = "OK";
		$("btnPrintCancel").style.width = "80px";
		
		if($("rdoOutstanding").checked){
			disableBrdrxDateOption(false);
			$("chkDspGrossTag").disabled = false;
			disablePaidDateOption(true);
		}else{
			disableBrdrxDateOption(true);
			$("chkDspGrossTag").disabled = true;
			disablePaidDateOption(false);
			$("byPeriodDiv").hide();
			$("asOfDiv").hide();
		}
		if($F("txtDspIssCd") == $F("hidRiIssCd")){
			$("intmDiv").hide();
		}else{
			if($("chkPerBusinessSource").checked){
				enableIntmDiv(true);
			}
		}
		var enableId = ["chkPerBusinessSource", "chkPerLineSubline", "chkPerIssueSource", "rdoOutstanding", "rdoLossesPaid", "rdoLoss", 
		                "rdoExpense", "rdoLossExpense", "rdoClaimIssCd", "rdoPolicyIssCd", "rdoBordereaux", "rdoClaimsRegister"];
		disableChkRdo(enableId, false);
		if($("byPeriodDateDiv").getStyle("display") != "none"){
			enableByPeriodDate(true, "from");
			enableByPeriodDate(true, "to");
		}
		enableLineDiv(true);
		enableSublineDiv(true);
		enableIssDiv(true);
		enablePerilDiv(true);
		enableButton("btnExtract");
		enableButton("btnPrintGicls202");
		
		whenNewBlockE010Gicls202();
	}
	
	function enableClmReg(){
		var enableId = ["chkPerLine", "chkPerBranch", "chkPerIntermediary", "chkPerLossCategory", "rdoPerLoss", "rdoPerFile",
		                "rdoBordereaux", "rdoClaimsRegister", "rdoClaimIssCd", "rdoPolicyIssCd", "chkNetOfRecovery"];
		disableChkRdo(enableId, false);
		
		enableLineDiv(true);
		enableSublineDiv(true);
		enableIssDiv(true);
		enablePerilDiv(true);
		enableIntmDiv(true);
		enableLossCategoryDiv(true);
		enableButton("btnExtract");
		enableButton("btnPrintGicls202");
	}
	
	function onOkPrintClmsRegGicls202(){
		if($("chkPerLossCategory").checked){
			printReportGicls202("GICLR203A", "CLAIMS REGISTER (PER LOSS CATEGORY)");
		}else{
			printReportGicls202("GICLR203", "CLAIMS REGISTER");
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
		$("btnPrintCancel").value = "OK";
		$("btnPrintCancel").style.width = "80px";
		
		enableClmReg();
		whenNewBlockE010Gicls202();
	}
	
	var reports = [];
	var reportSelected = false;
	function printReportGicls202(reportId, reportTitle){
		var content;
		if($F("selDestination") == "file"){ //start: SR-21723 Kevin 6-2-2016
			if($("rdoCsv").checked && reportId == "GICLR208LE"){
				reportId = reportId + "_CSV";
			}
		} //end: SR-21723 Kevin 6-2-2016
		content = contextPath+"/PrintBrdrxClmsRegisterController?action=printReportGicls202&reportId="+reportId+"&printerName="+$F("selPrinter")					
				+getParamsGicls202();
		
		// bonok :: 1.17.2017 :: FGIC SR 23448
		if(reportId == "GICLR208A"){
			content = content + addtlParams;
		}		
		
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
						showMessageBox("Printing complete.", "S");
					}
				}
			});
		}else if($F("selDestination") == "file"){
			//added by clperello | 06.09.2014
			 var fileType = "PDF";
		
			if($("rdoPdf").checked){
				fileType = "PDF";
			}
			else if (reportId == "GICLR208LE_CSV"){ //SR-21723 Kevin 6-2-2016
				fileType = "CSV2";
			}
			else if ($("rdoCsv").checked){
				fileType = "CSV"; 
			}
			//end here clperello | 06.09.2014
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType}, //$("rdoPdf").checked ? "PDF" : "XLS"}, commented by cherrie
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV" || fileType == "CSV2"){ //added by clperello | 06.05.2014 //SR-21723 Kevin 6-2-2016 CSV2
							copyFileToLocal(response, "csv");
							if(fileType == "CSV"){ //SR-21723 Kevin 6-2-2016
								deleteCSVFileFromServer(response.responseText);
							}
						}else
							copyFileToLocal(response);
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
		
		reportSelected = true;
	}
	
	function onLoadPrintBrdrxGicls202(){
		var content = "<label style='margin-top: 7px; margin-left: 10px; margin-right: 10px;'>Print Report</label>"+
					  "<table border='0' style='margin: auto; margin-top: 5px; margin-left: 5px;'>"+
					  "<tr height='17px'><td id='tdBrdrx'><input type='checkbox' id='chkBrdrx' style='float: left;'><label for='chkBrdrx' style='margin-left: 5px;'>Bordereaux</label></td></tr>"+
					  "<tr height='17px'><td id='tdDistReg'><input type='checkbox' id='chkDistReg' style='float: left;'><label for='chkDistReg' style='margin-left: 5px;'>Distribution Register</label></td></tr>"+
					  "<tr height='17px'><td id='tdSummary'><input type='checkbox' id='chkSummary' style='float: left;'><label id='lblSummary' for='chkSummary' style='margin-left: 5px;'>Outstanding Loss Register - Summary</label></td></tr>"+
					  "<tr id='trXol' height='17px'><td id='tdXol'><input type='checkbox' id='chkXol' style='float: left;'><label for='chkXol' style='margin-left: 5px;'>XOL Distribution Register</label></td></tr>"+
					  "<tr id='trAging' height='17px'><td id='tdAging'><input type='checkbox' id='chkAging' style='float: left;'><label for='chkAging' style='margin-left: 5px;'>Outstanding Loss Register with Aging</label></td></tr>"+
					  "<tr id='trAge' height='17px'><td id='tdAge'><label id='lblAge' style='margin-top: 7px;'>AGE</label>"+
					  "<div id='cutOffDateDiv' style='float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 10px; margin-top: 2px;'>"+
						"<input type='text' id='txtCutOffDate' style='float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;' name='txtCutOffDate' readonly='readonly' />"+
						"<img id='imgCutOffDate' alt='imgCutOffDate' style='margin-top: 1px; margin-left: 1px;' class='hover' src='${pageContext.request.contextPath}/images/misc/but_calendar.gif'/>"+
					  "</div></td></tr>"+
					  "<tr height='17px'><td id='tdDateOption'><input type='radio' id='rdoPrintLossDate' name='printDateOption' checked='checked' value='1' style='float: left;'><label for='rdoPrintLossDate' style='margin-left: 5px; margin-top: 3px;'>Loss Date</label>"+
					  "<input type='radio' id='rdoPrintClmFileDate' name='printDateOption' value='2' style='float: left; margin-left: 10px; margin-bottom: 8px;'><label for='rdoPrintClmFileDate' style='margin-left: 5px; margin-top: 3px;'>Claim File Date</label></td></tr>";
		$("printDialogFormDiv2").update(content); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "310px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "342px";
		
		$("imgCutOffDate").observe("click", function(){
			scwShow($("txtCutOffDate"),this, null);
		});
			
		//PRINT_BRDRX WHEN-NEW-BLOCK-INSTANCE start
		if($("rdoLossesPaid").checked){
			$("trXol").show();
			$("trAging").hide();
			$("tdAge").hide();
			$("tdDateOption").hide();
			if($("rdoLoss").checked){
				if(objGicls202.exist == "X"){
					//$("chkXol").checked = true;
					$("chkXol").disabled = false;
				}
			}else if($("rdoLossExpense").checked){
				$("trXol").hide();
			}
		}else{
			$("lblAge").innerHTML = "Aging Cut-off Date";
			$("trXol").hide();
			if($("rdoLossExpense").checked){
				$("tdAge").hide();
				$("tdAging").hide();
			}else{
				$("tdAge").show();
				$("tdAging").show();
				$("chkAging").disabled = false;
				enableCutOffDate(true);
			}
			$("tdDateOption").show();
			$("rdoPrintLossDate").disabled = false;
			$("rdoPrintClmFileDate").disabled = false;
		}
		if($F("txtDspToDate") == ""){
			$("txtCutOffDate").value = $F("txtDspAsOfDate");
		}
		if($F("txtDspAsOfDate") == ""){
			$("txtCutOffDate").value = $F("txtDspToDate");
		}
		
		if(($("chkPerPolicy").checked) || ($("chkPerEnrollee").checked)){
			$("tdDistReg").hide();
			$("tdSummary").hide();
			$("tdXol").hide();
			$("tdDateOption").hide();
		}
		//PRINT_BRDRX WHEN-NEW-BLOCK-INSTANCE end
		
		if($("rdoOutstanding").checked){
			$("lblSummary").innerHTML = "Outstanding Loss Register-Summary";
		}else if($("rdoLossesPaid").checked){
			$("lblSummary").innerHTML = "Claims Paid Register-Summary";
		}
		
		if($("rdoLossExpense").checked){
			$("tdSummary").hide();
			$("tdXol").hide();
			$("tdDateOption").hide();
		}else{
			if(!($("chkPerPolicy").checked == false) && !($("chkPerEnrollee").checked == false)){
				if($("tdDistReg").getStyle("display") == "none"){
					$("tdDistReg").show();
					$("chkDistReg").disabled = false;
				}
				$("tdSummary").show();
				$("tdXol").show();
				$("tdDateOption").show();
			}
			$("chkSummary").disabled = false;
			$("chkXol").disabled = false;
			$("rdoLossDate").disabled = false;
			$("rdoPrintClmFileDate").disabled = false;
		}
		
		$("chkBrdrx").checked = true;
		
		$("selPrinter").removeClassName("required");
		$("txtNoOfCopies").removeClassName("required");
		$("selDestination").observe("change", function(){
		if($F("selDestination") != "printer"){
				$("selPrinter").removeClassName("required");
				$("txtNoOfCopies").removeClassName("required");
			}else{
				$("selPrinter").addClassName("required");
				$("txtNoOfCopies").addClassName("required");
			}
		});
		
		$("btnPrintCancel").stopObserving();
		$("btnPrintCancel").observe("click", function(){
			overlayGenericPrintDialog.close();
			if($("rdoOutstanding").checked){
				disableBrdrxDateOption(false);
				$("chkDspGrossTag").disabled = false;
				disablePaidDateOption(true);
			}else{
				disableBrdrxDateOption(true);
				$("chkDspGrossTag").disabled = true;
				disablePaidDateOption(false);
				$("byPeriodDiv").hide();
				$("asOfDiv").hide();
			}
			if($F("txtDspIssCd") == $F("hidRiIssCd")){
				$("intmDiv").hide();
			}else{
				if($("chkPerBusinessSource").checked){
					enableIntmDiv(true);
				}
			}
			var enableId = ["chkPerBusinessSource", "chkPerLineSubline", "chkPerIssueSource", "rdoOutstanding", "rdoLossesPaid", "rdoLoss", 
			                "rdoExpense", "rdoLossExpense", "rdoClaimIssCd", "rdoPolicyIssCd", "rdoBordereaux", "rdoClaimsRegister"];
			disableChkRdo(enableId, false);
			if($("byPeriodDateDiv").getStyle("display") != "none"){
				enableByPeriodDate(true, "from");
				enableByPeriodDate(true, "to");
			}
			enableLineDiv(true);
			enableSublineDiv(true);
			enableIssDiv(true);
			enablePerilDiv(true);
			enableButton("btnExtract");
			enableButton("btnPrintGicls202");
			
			whenNewBlockE010Gicls202();
		});
		$F("chkBrdrxHid") == 1 ? $("chkBrdrx").checked = true : $("chkBrdrx").checked = false; 
		$F("chkDistRegHid") == 1 ? $("chkDistReg").checked = true : $("chkDistReg").checked = false;
		$F("chkSummaryHid") == 1 ? $("chkSummary").checked = true : $("chkSummary").checked = false;
		$F("chkXolHid") == 1 ? $("chkXol").checked = true : $("chkXol").checked = false;
		$F("chkAgingHid") == 1 ? $("chkAging").checked = true : $("chkAging").checked = false;
		$F("printDateOptionHid") == 1 ? $("rdoPrintLossDate").checked = true : $("rdoPrintClmFileDate").checked = true;
		
		initPrintCheckbox("chkBrdrx");
		initPrintCheckbox("chkDistReg");
		initPrintCheckbox("chkSummary");
		initPrintCheckbox("chkXol");
		initPrintCheckbox("chkAging");
		$$('input[name="printDateOption"]').each(function(a){
			a.observe("click", function(){
				$("printDateOptionHid").value = a.value;		
			});
		});
		
		$("csvOptionDiv").show(); //marco - 07.21.2014
	}
	
	function onLoadPrintClmsRegGicls202(){
		$("btnPrintCancel").stopObserving();
		$("btnPrintCancel").observe("click", function(){
			overlayGenericPrintDialog.close();
			enableButton("btnExtract");
			enableButton("btnPrintGicls202");
			enableClmReg();
			whenNewBlockE010Gicls202();
		});
		
		$("csvOptionDiv").show(); //marco - 07.21.2014
	}
	
	function initPrintCheckbox(id){
		$(id).observe("click", function(){
			if($(id).checked){
				$(id+"Hid").value = 1;
			}else{
				$(id+"Hid").value = 0;
			}
		});
	}
	
	function enableCutOffDate(enabled){
		if(enabled){
			$("txtCutOffDate").removeClassName("disabled");
			$("cutOffDateDiv").removeClassName("disabled");
			enableDate("imgCutOffDate");			
		}else{
			$("txtCutOffDate").addClassName("disabled");
			$("cutOffDateDiv").addClassName("disabled");
			disableDate("imgCutOffDate");
		}
	}
	
	function getParamsGicls202(){
		try{
			var repNameId = ["rdoBordereaux", "rdoClaimsRegister"];				
			var params = "&sessionId=" + objGicls202.sessionId + getRdoParams(repNameId, "repName");
			if($("rdoBordereaux").checked){
				params = params + getChkParams("chkPerBusinessSource", "intmBreak") 
						 + getChkParams("chkPerIssueSource", "issBreak") + getChkParams("chkPerLineSubline", "sublineBreak");
				var dateOptionId = ["rdoByPeriod", "rdoAsOf"];
				params = params + getRdoParams(dateOptionId, "dateOption") + "&fromDate=" + $F("txtDspFromDate") + "&toDate=" + $F("txtDspToDate")
						 + "&asOfDate=" + $F("txtDspAsOfDate") + "&cutOffDate=" + $F("txtCutOffDate");
				if($("rdoOutstanding").checked){
					var brdrxDateOptionId = ["rdoLossDate", "rdoClaimFileDate", "rdoBookingMonth"];
					params = params + "&amt=Outstanding" + getRdoParams(brdrxDateOptionId, "osDate");
					var dateOptionId = ["rdoPrintLossDate","rdoPrintClmFileDate"];
					params = params + getRdoParams(dateOptionId, "agingDate");
				}else if($("rdoLossesPaid").checked){
					var paidDateOptionId = ["rdoTranDate", "rdoPostingDate"];
					params = params + "&amt=Losses Paid" + getRdoParams(paidDateOptionId, "paidDate");
				}
			}else{
				var regButton = ["rdoPerLoss", "rdoPerFile"];
				params = params + "&lineCd=" + $F("txtDspLineCd") + "&sublineCd=" + $F("txtDspSublineCd") + "&issCd=" + $F("txtDspIssCd")
						 + "&perilCd=" + $F("txtDspPerilCd") + "&lossCatCd=" + $F("txtDspLossCatCd") + getRdoParams(regButton, "dateSw")
						 + getChkParams("chkPerLine", "lineCdTag") + getChkParams("chkPerBranch", "issCdTag") 
						 + getChkParams("chkPerIntermediary", "intermediaryTag") + "&fromDate=" + $F("txtDspFromDate") + "&toDate=" + $F("txtDspToDate");
			}
			return params;
		}catch(e){
			showErrorMessage("GICLS202 - getParamsGicls202: ", e);
		}
	}
	
	function getChkParams(id, paramName){
		var params = "";
		if($(id).checked){
			params = params + "&"+paramName+"=1";
		}else{
			params = params + "&"+paramName+"=0";
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
	
	doKeyUp("txtDspEnrollee");
	$$('input[type="radio"]').each(function(a){
		a.observe("change", function(){
			currParam = 1;		
		});
	});
	
	$$('input[type="checkbox"]').each(function(a){
		a.observe("click", function(){
			currParam = 1;		
		});
	});
	
	$w("txtDspFromDate txtDspToDate txtDspAsOfDate txtDspRcvryFromDate txtDspRcvryToDate").each(function(a){
		$(a).observe("blur", function(){
			currParam = 1;
		});
	});
	
	observeReloadForm("reloadForm", showBordereauxClaimsRegister);
	$("btnExit").observe("click", function(){
		if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
} catch(e){
	showErrorMessage("GICLS202 - Bordereaux and Claims Register page: ", e);
}
</script>
