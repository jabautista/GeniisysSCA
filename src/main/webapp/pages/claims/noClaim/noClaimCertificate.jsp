<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="noClaimCertMainDiv" name="noClaimCertMainDiv" style="margin-top: 1px;">
	<div id="noClaimCertMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="noClaimCertForm" name="noClaimCertForm">
		<div id="certOf NoClaimMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Certificate of No Claim</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="certOf NoClaimDetailsDiv"changeTagAttr="true">
				
				<table style="margin-top: 20px; margin-bottom: 15px;">
					<tr>
						<td class="rightAligned" width="100px">No Claim No.</td>
						<td class="leftAligned" width="360px">
							<input type="text" id="txtNoClaimNo" name="txtNoClaimNo" style="width: 347px;" readonly="readonly" />
						</td>
						<td class="rightAligned" width="100px">Incept Date</td>
						<td class="leftAligned" width="320px">
							<input type="text" id="txtInceptDate" name="txtInceptDate" style="width: 300px;"  readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Policy No.</td>
						<td class="leftAligned" width="360px">
							<div style="width: 43px; float: left;" class="withIconDiv">
								<input type="text" id="txtLineCd" name="txtLineCd" value="" style="width: 18px;" class="withIcon allCaps" maxlength="2">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtLineCdIcon" name="txtLineCdIcon" alt="Go" />
							</div>
							
							<div style="width: 75px; float: left;" class="withIconDiv">
								<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 50px;" class="withIcon allCaps" maxlength="7">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtSublineCdIcon" name="txtSublineCdIcon" alt="Go" />
							</div>
							
							<div style="width: 43px; float: left;" class="withIconDiv">
								<input type="text" id="txtIssCd" name="txtIssCd" value="" style="width: 18px;" class="withIcon allCaps" maxlength="2">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssCdIcon" name="txtIssCdIcon" alt="Go" />
							</div>
							
							<div style="width: 43px; float: left;" class="withIconDiv">
								<input type="text" id="txtIssueYy" name="txtIssueYy" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2" >
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssueYyIcon" name="txtIssueYyIcon" alt="Go" />
							</div>
							
							<div style="width: 75px; float: left;" class="withIconDiv">
								<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 50px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="7">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolSeqNoIcon" name="txtPolSeqNoIcon" alt="Go" />
							</div>
							
							<div style="width: 43px; float: left;" class="withIconDiv">
								<input type="text" id="txtRenewNo" name="txtRenewNo" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtRenewNoIcon" name="txtRenewNoIcon" alt="Go" />
							</div>
						</td>
						<td class="rightAligned" width="100px">Expiry Date</td>
						<td class="leftAligned" width="320px">
							<input type="text" id="txtExpiryDate" name="txtExpiryDate" style="width: 300px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Assured Name</td>
						<td class="leftAligned" width="360px">
							<input type="text" id="txtAssuredName" name="txtAssuredName" style="width: 347px;" readonly="readonly" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="itemInfoMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Item Information</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
					</span>
				</div>
			</div>
			<div id="noClmItmDtlsDiv" class="sectionDiv" changeTagAttr="true">
				<div style="margin-top: 10px; margin-bottom: 15px;  margin-left:80px; float: left; width: 740px;  "  changeTagAttr="true">
					<table align="center" style="margin-top: 10px;">
						<tr>
							<td class="rightAligned" width="63px">Item</td>
							<td class="leftAligned"  style="width: 560px;">
								<div style="width: 120px;" class="required withIconDiv">
									<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 90px;" class="required withIcon integerNoNegativeUnformattedNoComma" maxlength="9">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefItemIcon" name="hrefItemIcon" alt="Go" />
								</div>
								<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 415px;" readonly="readonly">
							</td>
							<td><input type="checkbox" id="chkCancelled" style="float: left;" value=""disabled="disabled"><label style="float: left; width: 60px; text-align: right; margin-top: 0px; margin-left: 4px;">Cancelled</label></input></td>
						</tr>
						</table>
						<table align="center">
						<tr>
							<td class="rightAligned" width="100px">Location</td>
							<td class="leftAligned" width="632px"colspan="4">
								<input type="text" id="txtLocation" name="txtLocation" style="width: 636px;" maxlength="500" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="100px">Date of Loss</td>
							<td class="leftAligned" width="240px">
								<div id="txtDateOfLossDiv" name="txtDateOfLossDiv" style="float: left; width: 120px;" class="withIconDiv required">
									<input style="width: 97px;" id="txtDateOfLoss" name="txtDateOfLoss" type="text" value="" class="withIcon required" readonly="readonly"/>
									<img id="hrefDateOfLoss" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date of Loss"  />
								</div>
								<label style="float: left; width: 33px; text-align: right; margin-top: 6px; margin-right: 8px;">Time</label>
								<input type="text" id="txtTimeOfLoss" name="txtTimeOfLoss" class="required" value="" style="width: 93px; float: left;" maxlength="11">
							</td>
							<td class="rightAligned" width="100px;">Amount</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtAmount" name="txtAmount" style="width: 260px;"  min="0" max="99999999999999.99" class="money2" errorMsg="Field must be of form 99,999,999,999,999.90."/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="100px">Date Issued</td>
							<td class="leftAligned" width="240px">
								<input type="text" id="txtDateIssued" name="txtDateIssued" style="width: 260px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="100px">Remarks</td>
							<td class="leftAligned" width="280px">
								<div style="border: 1px solid gray; height: 20px; width: 266px;" changeTagAttr="true">
									<input type="text" style="width: 240px; border: none; height: 12px;" name="txtRemarks" id="txtRemarks" value="" maxlength="4000"/>
									<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editRemarks" alt="Edit" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" />
									<%-- <textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 240px; border: none; height: 13px;"></textarea>
									<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" /> --%>
								</div>
							</td>
						</tr>
						<tr height="18px;"></tr>
						<tr>
							<td class="rightAligned" width="120px">Company</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtCompany" name="txtCompany" style="width: 260px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="100px">Basic Color</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtBasicColor" name="txtBasicColor" style="width: 260px;" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="120px">Make</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtMake" name="txtMake" style="width: 260px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="100px">Color</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtColor" name="txtColor" style="width: 260px;" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="120px">Plate No.</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtPlateNo" name="txtPlateNo" style="width: 260px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="100px">Serial No.</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtSerialNo" name="txtSerialNo" style="width: 260px;" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="120px">Motor No.</td>
							<td class="leftAligned" width="280px">
								<input type="text" id="txtMotorNo" name="txtMotorNo" style="width: 260px;" readonly="readonly" />
							</td>
						</tr>
					</table>
				</div>
			</div>	
		<div id="hidden" style="display: none;">
			<input type="hidden" id="txtAssuredNo" name="txtAssuredNo">
			<input type="hidden" id="txtModelYear" name="txtModelYear">
			<input type="hidden" id="txtMotcarCompCd" name="txtMotcarCompCd">
			<input type="hidden" id="txtMakeCd" name="txtMakeCd">
			<input type="hidden" id="txtBasicColorCd" name="txtBasicColorCd">	
			<input type="hidden" id="txtColorCd" name="txtColorCd">
			<input type="hidden" id="txtCancelTag" name="txtCancelTag">
			<input type="hidden" id="txtMenuLineCd" name="txtMenuLineCd">
			<input type="hidden" id="txtLineCdMC" name="txtLineCdMC">
			<input type="hidden" id="txtNoClaimId" name="txtNoClaimId">
		</div>
	</form>
	<div class="buttonsDiv"  style="margin-bottom: 55px;"  >
		<input type="button" class="button" id="btnActivate" name="btnActivate" value="Cancel No Claim" style=" width: 13%"/>
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style=" width: 13%"/>
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style=" width: 13%"/>
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style=" width: 13%"/>
	</div>
</div>

<script type="text/javascript">
try{
	var inceptDate = null;
	var expiryDate = null;
	var dateOfLoss = null;
	var dateIssued = null;
	var ref = 'N';
	var needCommit = "N";
	var title = null;
	var reportVersion = null;
	
	var lineCdMsg			= "Please select Line Code first.";
	var sublineCdMsg 	= "Please select Subline Code first.";
	var polIssCdMsg 		= "Please select Issuing Source Code first.";
	var issueYyMsg 		= "Please select Issuing Year first.";
	var polSeqNoMsg 	= "Please select Policy Sequence No. first.";
	
	objCLM.noClaims = JSON.parse('${noClaimDtls}'.replace(/\\/g, '\\\\')); 
	
	objCLM.noClaims.lineCd = nvl(objCLM.noClaims.lineCd, objCLMGlobal.lineCd);	//added to return to listing based on selected Line if Add is clicked : shan 10.17.2013
							
	
	function newFormInstanceGICLS026(){
		if (objCLMGlobal.noClaimId == null){
			$("txtLineCd").addClassName("required");
			$("txtLineCd").up("div",0).addClassName("required");
			$("txtSublineCd").addClassName("required");
			$("txtSublineCd").up("div",0).addClassName("required");
			$("txtIssCd").addClassName("required");
			$("txtIssCd").up("div",0).addClassName("required");
			$("txtIssueYy").addClassName("required");
			$("txtIssueYy").up("div",0).addClassName("required");
			$("txtPolSeqNo").addClassName("required");
			$("txtPolSeqNo").up("div",0).addClassName("required");
			$("txtRenewNo").addClassName("required");
			$("txtRenewNo").up("div",0).addClassName("required");
			$("txtLineCd").value 					= nvl(objCLMGlobal.lineCd,null);
			disableButton("btnActivate");
			disableButton("btnPrint");
		}else{
			inceptDate = objCLM.noClaims.strEffDate;
			expiryDate = objCLM.noClaims.strExpiryDate;
			dateOfLoss = objCLM.noClaims.strNcLossDate;
			dateIssued = objCLM.noClaims.strNcIssueDate;
			var lossDate 						= nvl(objCLM.noClaims.strNcLossDate,null) != null ? objCLM.noClaims.strNcLossDate.substr(0, objCLM.noClaims.strNcLossDate.indexOf(" ")) :null;
			var lossTime 						= nvl(objCLM.noClaims.strNcLossDate,null) != null ? objCLM.noClaims.strNcLossDate.substr(objCLM.noClaims.strNcLossDate.indexOf(" ")+1, objCLM.noClaims.strNcLossDate.length) :null;
			$("txtNoClaimId").value 			= nvl(String(objCLM.noClaims.noClaimId),null) != null ? objCLM.noClaims.noClaimId :null;
			$("txtNoClaimNo").value 			= nvl(String(objCLM.noClaims.noClaimNo),null) != null ? objCLM.noClaims.noClaimNo :null;
			$("txtAssuredName").value 	= nvl(String(objCLM.noClaims.assdName),null) != null ? unescapeHTML2(objCLM.noClaims.assdName) :null; //added by steven 12/11/2012 "unescapeHTML2"
			$("txtAssuredNo").value 			= nvl(String(objCLM.noClaims.assdNo),null) != null ? objCLM.noClaims.assdNo :null;
			$("txtInceptDate").value 			= nvl(String(dateFormat(objCLM.noClaims.strEffDate, "mm-dd-yyyy hh:MM TT")),null) != null ? dateFormat(objCLM.noClaims.strEffDate, "mm-dd-yyyy hh:MM TT") :null;
			$("txtExpiryDate").value 			= nvl(String(dateFormat(objCLM.noClaims.strExpiryDate, "mm-dd-yyyy hh:MM TT")),null) != null ? dateFormat(objCLM.noClaims.strExpiryDate, "mm-dd-yyyy hh:MM TT") :null;
			$("txtItemTitle").value 			= nvl(String(objCLM.noClaims.itemTitle),null) != null ? unescapeHTML2(objCLM.noClaims.itemTitle) :null;  //added by steven 12/11/2012 "unescapeHTML2"
			$("txtItemNo").value 				= nvl(String(objCLM.noClaims.itemNo),null) != null ? formatNumberDigits(objCLM.noClaims.itemNo,5) :null;
			$("txtLocation").value 				= nvl(String(objCLM.noClaims.location),null) != null ? unescapeHTML2(objCLM.noClaims.location).replace(/\\\\/g, "\\") :null;
			$("txtDateIssued").value 			= nvl(String(dateFormat(objCLM.noClaims.strNcIssueDate, "mm-dd-yyyy hh:MM TT")),null) != null ? dateFormat(objCLM.noClaims.strNcIssueDate, "mm-dd-yyyy hh:MM TT") :null;
			$("txtDateOfLoss").value 			= lossDate;
			$("txtTimeOfLoss").value 		= dateFormat(lossTime, "hh:MM TT");
			$("txtAmount").value 				= nvl(String(objCLM.noClaims.amount),null) != null ? formatCurrency(objCLM.noClaims.amount) :null;
			$("txtRemarks").value 				= nvl(String(objCLM.noClaims.remarks),null) != null ? unescapeHTML2(objCLM.noClaims.remarks).replace(/\\\\/g, "\\") :null;  //added replace \ - Halley 10.09.13
			$("txtCompany").value 				= nvl(String(objCLM.noClaims.carCompany),null) != null ? unescapeHTML2(objCLM.noClaims.carCompany) :null;
			$("txtMake").value 					= nvl(String(objCLM.noClaims.make),null) != null ? unescapeHTML2(objCLM.noClaims.make) :null;
			$("txtPlateNo").value 				= nvl(String(objCLM.noClaims.plateNo),null) != null ? unescapeHTML2(objCLM.noClaims.plateNo) :null;
			$("txtMotorNo").value 				= nvl(String(objCLM.noClaims.motorNo),null) != null ? unescapeHTML2(objCLM.noClaims.motorNo) :null;
			$("txtBasicColor").value 			= nvl(String(objCLM.noClaims.basicColor),null) != null ? unescapeHTML2(objCLM.noClaims.basicColor) :null;
			$("txtColor").value 					= nvl(String(objCLM.noClaims.color),null) != null ? unescapeHTML2(objCLM.noClaims.color) :null;
			$("txtSerialNo").value 				= nvl(String(objCLM.noClaims.serialNo),null) != null ? unescapeHTML2(objCLM.noClaims.serialNo) :null;
			$("txtLineCd").value 					= nvl(String(objCLM.noClaims.lineCd),null) != null ? unescapeHTML2(objCLM.noClaims.lineCd) :null;
			$("txtSublineCd").value 			= nvl(String(objCLM.noClaims.sublineCd),null) != null ? unescapeHTML2(objCLM.noClaims.sublineCd) :null;
			$("txtIssCd").value 					= nvl(String(objCLM.noClaims.issCd),null) != null ? unescapeHTML2(objCLM.noClaims.issCd) :null;
			$("txtMotcarCompCd").value 	= nvl(String(objCLM.noClaims.motcarCompCd),null) != null ? objCLM.noClaims.motcarCompCd :null;
			$("txtIssueYy").value 				= nvl(String(formatNumberDigits(objCLM.noClaims.issueYy,2)),null) != null ? formatNumberDigits(objCLM.noClaims.issueYy,2) :null;
			$("txtPolSeqNo").value 			= nvl(String(formatNumberDigits(objCLM.noClaims.polSeqNo,7)),null) != null ? formatNumberDigits(objCLM.noClaims.polSeqNo,7) :null;
			$("txtRenewNo").value 			= nvl(String(formatNumberDigits(objCLM.noClaims.renewNo,2)),null) != null ? formatNumberDigits(objCLM.noClaims.renewNo,2) :null;
			$("txtMotcarCompCd").value 	= nvl(String(objCLM.noClaims.motcarCompCd),null) != null ? objCLM.noClaims.motcarCompCd :null;
			$("txtMakeCd").value 				= nvl(String(objCLM.noClaims.makeCd),null) != null ? objCLM.noClaims.makeCd :null;
			$("txtModelYear").value 			= nvl(String(objCLM.noClaims.modelYear),null) != null ? objCLM.noClaims.modelYear :null;
			$("txtBasicColorCd").value 		= nvl(String(objCLM.noClaims.basicColorCd),null) != null ? objCLM.noClaims.basicColorCd :null;
			$("txtColorCd").value 				= nvl(String(objCLM.noClaims.colorCd),null) != null ? objCLM.noClaims.colorCd :null;
			$("txtCancelTag").value 			= nvl(String( objCLM.noClaims.cancelTag),null) != null ?  objCLM.noClaims.cancelTag :null;
			$("txtMenuLineCd").value 		= nvl(String( objCLM.noClaims.menuLineCd),null) != null ?  objCLM.noClaims.menuLineCd :null;
			$("txtLineCdMC").value 			= nvl(String( objCLM.noClaims.lineCdMC),null) != null ?  unescapeHTML2(objCLM.noClaims.lineCdMC) :null;
			$("chkCancelled").checked 		= objCLM.noClaims.cancelTag == "Y" ? true : false;
			if(objCLM.noClaims.lineCd != 'MC'){
				$("txtCompany").disable();
				$("txtMake").disable();
				$("txtPlateNo").disable();
				$("txtMotorNo").disable();
				$("txtBasicColor").disable();
				$("txtColor").disable();
				$("txtSerialNo").disable();
			}
			if(nvl(objCLM.noClaims.cancelTag,"N")  == 'N'){
				$("btnActivate").value = "Cancel No Claim";
			}else{
				$("btnActivate").value = "Activate No Claim";
			}
			$("txtLineCd").readOnly 	= true;
			$("txtSublineCd").readOnly 	= true;
			$("txtIssCd").readOnly 	= true;
			$("txtIssueYy").readOnly 	= true;
			$("txtPolSeqNo").readOnly 	= true;
			$("txtRenewNo").readOnly 	= true;
			$("txtLineCdIcon").hide();
			$("txtLineCd").up("div",0).setStyle('width : 43px');
			$("txtSublineCdIcon").hide();
			$("txtSublineCd").up("div",0).setStyle('width : 75px');
			$("txtIssCdIcon").hide();
			$("txtIssueYyIcon").hide();
			$("txtPolSeqNoIcon").hide();
			$("txtPolSeqNo").up("div",0).setStyle('width : 75px');
			$("txtRenewNoIcon").hide();
			$("txtLineCd").focus();
		}
	}
	
	function clearPolicyNo(){
		$("txtLineCd").value 	= "";
		$("txtSublineCd").value 	= "";
		$("txtIssCd").value 	= "";
		$("txtIssueYy").value 	= "";
		$("txtPolSeqNo").value 	= "";
		$("txtRenewNo").value 	= "";
	}
	
	function checkPolicyGICLS026(){
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController?action=checkPolicyGICLS026", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						lineCd			: $F("txtLineCd"),
						sublineCd	: $F("txtSublineCd"),
						issCd			: $F("txtIssCd"),
						issueYy		: $F("txtIssueYy"),
						polSeqNo	: $F("txtPolSeqNo"),
						renewNo	: $F("txtRenewNo")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							var msg = result.msg;
							clearAllDtls(); //added by christian 02/07/2013
							if(msg == 'Policy does not exist.'){
								showWaitingMessageBox(msg, "I", function(){
									clearPolicyNo();
									$("txtLineCd").focus();
									//$("txtItemNo").removeClassName("required"); bakit nireremove?
									//$("txtItemNo").up("div",0).removeClassName("required");
								});
							}else if(msg == 'POLICY_EXIST'){
								showConfirmBox("Confirm","Claim for this policy already exists. Do you want to continue?","Yes","No",
										function(){
											getDetailsGICLS026();
											$("txtItemNo").addClassName("required");
											$("txtItemNo").up("div",0).addClassName("required");
										},function(){
											clearPolicyNo();
											$("txtItemNo").removeClassName("required");
											$("txtItemNo").up("div",0).removeClassName("required");
										});
							}else if(msg == 'GET_DETAILS'){
								getDetailsGICLS026();
								$("txtItemNo").addClassName("required");
								$("txtItemNo").up("div",0).addClassName("required");
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("checkPolicyGICLS026", e);
		}
	}
	
	function getDetailsGICLS026(){
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController?action=getDetailsGICLS026", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						lineCd				: $F("txtLineCd"),
						sublineCd		: $F("txtSublineCd"),
						issCd				: $F("txtIssCd"),
						issueYy			: $F("txtIssueYy"),
						polSeqNo		: $F("txtPolSeqNo"),
						renewNo		: $F("txtRenewNo"),
						ncLossDate	: $F("txtDateOfLoss")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = JSON.parse(response.responseText);//.toQueryParams(); replace by steven 12/12/2012
							$("txtAssuredNo").value = result.assdNo;
							$("txtAssuredName").value = unescapeHTML2(result.assdName);//added by steven 12/12/2012
							if (result.effDate != "") {
								$("txtInceptDate").value = dateFormat(Date.parse(result.effDate),"mm-dd-yyyy hh:MM TT");
								inceptDate = result.effDate;
							} else {
								$("txtInceptDate").value = null;
								inceptDate = null;
							}
							if (result.expiryDate != "") {
								$("txtExpiryDate").value = dateFormat(Date.parse(result.expiryDate),"mm-dd-yyyy hh:MM TT");
								expiryDate = result.expiryDate;
							} else {
								$("result.expiryDate").value = null;
								expiryDate = null;
							}
							$("hrefItemIcon").focus();
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("checkPolicyGICLS026", e);
		}
	}
	
	function checkItemGICLS026(){
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController?action=checkItemGICLS026", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						lineCd				: $F("txtLineCd"),
						sublineCd		: $F("txtSublineCd"),
						issCd				: $F("txtIssCd"),
						issueYy			: $F("txtIssueYy"),
						polSeqNo		: $F("txtPolSeqNo"),
						renewNo		: $F("txtRenewNo"),
						itemNo			: $F("txtItemNo"),
						ncLossDate	: $F("txtDateOfLoss")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							var msg = result.msg;
							if(msg == 'amount enterable'){
								
							}else{
								showWaitingMessageBox(msg, "W", function(){
									$("txtAmount").readOnly 	= true;
								});
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("checkPolicyGICLS026", e);
		}
	}
	
	function insertNewRecordGiCLS026(){
		var finalInceptDate = null;
		var finalExpiryDate = null;
		if (inceptDate != null) {
			finalInceptDate = dateFormat(Date.parse(inceptDate),"mm-dd-yyyy hh:MM TT");
		}
		if (expiryDate != null) {
			finalExpiryDate = dateFormat(Date.parse(expiryDate),"mm-dd-yyyy hh:MM TT");
		} 
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController?action=insertNewRecordGICLS026", {
					evalScripts: true,
					asynchronous: false,
					//method: "GET", //removed, causing issues with special characters - Halley 10.09.13
					parameters: {
						lineCd						: escapeHTML2($F("txtLineCd")),
						sublineCd				: escapeHTML2($F("txtSublineCd")),
						issCd						: escapeHTML2($F("txtIssCd")),
						issueYy					: $F("txtIssueYy"),
						polSeqNo				: $F("txtPolSeqNo"),
						renewNo				: $F("txtRenewNo"),
						itemNo					: $F("txtItemNo"),
						assdNo					: $F("txtAssuredNo"),
						assdName				: escapeHTML2($F("txtAssuredName")),
						effDate					: $F("txtInceptDate"),
						expiryDate			: $F("txtExpiryDate"),
						modelYear			: escapeHTML2($F("txtModelYear")),
						makeCd					: escapeHTML2($F("txtMakeCd")),
						itemTitle				: escapeHTML2($F("txtItemTitle")),
						motorNo				: escapeHTML2($F("txtMotorNo")),
						serialNo					: escapeHTML2($F("txtSerialNo")),
						plateNo					: escapeHTML2($F("txtPlateNo")),
						basicColorCd			: escapeHTML2($F("txtBasicColorCd")),
						colorCd					: escapeHTML2($F("txtColorCd")),
						amount					: unformatCurrencyValue($F("txtAmount")),
						location					: escapeHTML2($F("txtLocation")),
						//ncLossDate			: ($F("txtDateOfLoss")+" "+$F("txtTimeOfLoss")).strip(),
						ncLossDate			: $F("txtDateOfLoss")+" "+$F("txtTimeOfLoss"),
						cancelTag				: nvl($F("txtCancelTag"),"N"),
						remarks					: escapeHTML2($F("txtRemarks")),  //added escapeHTML2 - Halley 10.09.13
						motcarCompCd	: escapeHTML2($F("txtMotcarCompCd"))
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = JSON.parse(response.responseText);//.toQueryParams(); //added by steven 12/12/2012
							var msg = result.msg;
							if(msg != null){ 
								showMessageBox(msg,"I");
							}else{
								showWaitingMessageBox("Saving successful.", "S", function(){
									objCLMGlobal.noClaimId = result.noClaimId;
									changeTag = 0;	//added by shan 10.14.2013
									if(ref == "Y"){
										showNoClaimCertificate();
									}else{
										showNoClaimListing(objCLM.noClaims.lineCd);
									}
								});
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("insertNewRecordGiCLS026", e);
		}
	}
	

	function updateRecordGICLS026(){
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController?action=updateRecordGICLS026", {
					evalScripts: true,
					asynchronous: false,
					//method: "GET", //removed, causing issues with special characters - Halley 10.09.13
					parameters: {
						noClaimId				: objCLMGlobal.noClaimId,
						itemNo					: $F("txtItemNo"),
						location					: escapeHTML2($F("txtLocation")),
						cancelTag				: nvl($F("txtCancelTag"),"N"),
						ncLossDate			: $F("txtDateOfLoss")+" "+$F("txtTimeOfLoss"),
						amount					: $F("txtAmount").replace(/,/g, ""), //unformatCurrencyValue($F("txtAmount")), changed to prevent discrepancies in parseFloat shan 10.14.2013
						remarks					: escapeHTML2($F("txtRemarks")),  //added escapeHTML2 - Halley 10.09.13
						modelYear			: escapeHTML2($F("txtModelYear")),
		                makeCd				 	: escapeHTML2($F("txtMakeCd")),
		                itemTitle				: escapeHTML2($F("txtItemTitle")),
		                serialNo					: escapeHTML2($F("txtSerialNo")),
		                plateNo				    : escapeHTML2($F("txtPlateNo")),
		                basicColorCd	 		: escapeHTML2($F("txtBasicColorCd")),
		                colorCd					: escapeHTML2($F("txtColorCd")),
		                motorNo				: escapeHTML2($F("txtMotorNo")),
		                motcarCompCd   : escapeHTML2($F("txtMotcarCompCd"))
					},
					onCreate: showNotice("Updating record, please wait..."),
					onComplete: function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								changeTag = 0;	//added by shan 10.14.2013
								if(ref == "Y"){
									showNoClaimCertificate();
								}else{
									showNoClaimListing(objCLM.noClaims.lineCd);
								}
							} );
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("updateRecordGICLS026", e);
		}
	} 
	
	function checkVersionGICLS026(){
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController?action=checkVersionGICLS026", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					onCreate: showNotice("Loading, please wait..."),
					onComplete: function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var arr = response.responseText.split(",");
							var version = nvl(arr[0], 'CPI');
							var versionB = version;  
							var show = false;	//added : shan 10.16.2013
							if (nvl($F("txtMenuLineCd"),$F("txtLineCd")) == $F("txtLineCdMC")){
								objCLM.noClaims.reportId = "GICLR026";
								if(version == 'FPAC' || version == 'SEICI' || version == 'PNB' || version == 'UCPB'){
									title = "Print No Claim Certificate For Motor Car";
									//printNoClaimCert();	//commented out by shan 10.16.2013									
								}else{
									title = "Print No Claim Certificate";
									reportVersion = version;
									show = true;
									//printNoClaimCert();	//commented out by shan 10.16.2013	
								}
							}else{
								objCLM.noClaims.reportId = "GICLR026B";
								title  = "Print No Claim Certificate For Non Motor Car";
								//printNoClaimCert();	//commented out by shan 10.16.2013	
							}
							objCLM.noClaims.version = version; //GICLR026
							objCLM.noClaims.versionB = versionB; //GICLR026B
							objCLM.noClaims.noClaimId = $F("txtNoClaimId");
							objCLM.noClaims.noClaimNo = $F("txtNoClaimNo");
							
							showGenericPrintDialog(title, populateGICLR026, function(){ /* onLoad added : shan 10.14.2013 */
								onLoadPrintGICLS026(show);
							});
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("updateRecordGICLS026", e);
		}
	}
	
/* 	function printNoClaimCert(){
			Modalbox.show(contextPath+"/PrintNoClaimCertificateController?action=showPrintNC&ajaxModal=1&reportVersion="+reportVersion,
					{title: title,
					 width: 500});
	} */
	
	function saveRecordGICLS026(){
		if(checkAllRequiredFieldsInDiv('noClaimCertMainDiv')){		//shan 10.14.2013
			if (objCLMGlobal.noClaimId != null){
				updateRecordGICLS026();
			}else{
				insertNewRecordGiCLS026();
			}
		}		
	}
	
	function getNonMCItemTitle(){
		new Ajax.Request(contextPath+"/GIPIItemMethodController?action=getNonMCItemTitle",{
			method: "POST",
			parameters: {itemNo			: $F("txtItemNo"),
									lineCd				: $F("txtLineCd"),
									sublineCd		: $F("txtSublineCd"),
									issCd				: $F("txtIssCd"),
									issueYy			: $F("txtIssueYy"),
									polSeqNo		: $F("txtPolSeqNo"),
									renewNo		: $F("txtRenewNo")
			},
			evalScripts: true,
			asynchronous: false,
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					var title = response.responseText;
					if(title == ""){
						clearFocusElementOnError("txtItemNo", "Item number is not existing for the policy.");
						//$("txtItemTitle").value = "";
						clearPopulatedDtls(); //added by christian 02/07/2013
					}else{
						$("txtItemTitle").value = response.responseText;
						$("txtItemNo").value = formatNumberDigits($F("txtItemNo"),5);
					}
				}
			}
		});	
	}
	
	function populateGICLR026(){
		try {
			//added by shan 10.16.2013
			var ncTag1 = $("chkNcTag1").checked ? "Y" : "N";
			var ncTag2 = $("chkNcTag2").checked ? "Y" : "N";
			var ncTag3 = $("chkNcTag3").checked ? "Y" : "N";
			var ncTag4 = $("chkNcTag4").checked ? "Y" : "N";
			
			var action = (nvl($F("txtMenuLineCd"),$F("txtLineCd")) == $F("txtLineCdMC") ? "populateGICLR026" : "populateGICLR026B");
			var content = contextPath+"/PrintNoClaimCertificateController?action="+action+"&noClaimId="+objCLM.noClaims.noClaimId
																						 +"&noClaimNo="+objCLM.noClaims.noClaimNo
																						 +"&printerName="+$F("selPrinter")			//added by steven 8/23/2012
																						 +"&destination="+$F("selDestination")
																						 +"&ncTag1="+ncTag1
																						 +"&ncTag2="+ncTag2
																						 +"&ncTag3="+ncTag3
																						 +"&ncTag4="+ncTag4;
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, "CNC - "+objCLM.noClaims.noClaimNo);
				hideNotice("");
			} else if ("printer" == $F("selDestination")) {
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
									          printerName : $F("selPrinter")},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "S");  //added by steven 11/15/2012
						}
					}
				});
			} else  if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
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
		} catch(e){
			showErrorMessage("populateGICLR026", e);
		}
	}	
	
		
	function onLoadPrintGICLS026(show){	// added for menu line/line MC and report version not in FPAC, UCPB, SEICI and PNB : shan 10.14.2013
		try{
			//if (show){	// moved below : shan 11.20.2013
			var content = "<div class='sectionDiv' style='height: 103px; border: none;'>"+
				"<table style='margin-top: 5px;'>"+
				"<tr><td>"+
				"<input type='checkbox' id='chkNcTag1' name='chkNcTag1' title='is insured with us against CTPL/BI only' style='margin-left: 5px; margin-top: 6px; float: left;'/>"+ 
				"<label for='chkNcTag1' style='margin: 7px 0 0 4px;'>is insured with us against CTPL/BI only</label>"+
				"</td></tr>"+
				"<tr><td>"+
				"<input type='checkbox' id='chkNcTag2' name='chkNcTag2' title='was not involved in any accident' style='margin-left: 5px; margin-top: 6px; float: left;'/>"+ 
				"<label for='chkNcTag2' style='margin: 7px 0 0 4px;'>was not involved in any accident</label>"+
				"</td></tr>"+
				"<tr><td>"+
				"<input type='checkbox' id='chkNcTag3' name='chkNcTag3' title='was involved in an accident but wishes to claim against the adverse party' style='margin-left: 5px; margin-top: 6px; float: left;'/>"+ 
				"<label for='chkNcTag3' style='margin: 7px 0 0 4px;'>was involved in an accident but wishes to claim against the adverse party</label>"+
				"</td></tr>"+
				"<tr><td>"+
				"<input type='checkbox' id='chkNcTag4' name='chkNcTag4' title='did not file a claim with us in connection with an accident' style='margin-left: 5px; margin-top: 6px; float: left;'/>"+ 
				"<label for='chkNcTag4' style='margin: 7px 0 0 4px;'>did not file a claim with us in connection with an accident</label>"+
				"</td></tr>"+
				"</tr></table>"+
				"</div>";
				
			$("printDialogFormDiv2").update(content); 

			if (show){	
				$("printDialogFormDiv2").show();
				$("printDialogMainDiv").up("div",1).style.height = "265px";
				$("printDialogMainDiv").up("div",1).style.width = "100%";
				$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "297px";
				$($("printDialogMainDiv").up("div",1).id).up("div",0).style.width = "475px";				
			}
		}catch(e){
			showMessageBox("onLoadPrintGICLS026", e);
		}
	}
	
	$("btnActivate").observe("click", function(){
		changeTag = 1;
		needCommit = "Y";
		if($("chkCancelled").checked == false){
			 showConfirmBox("Confirm","Do you want to cancel this transaction?",
					 "Yes","No",
			function(){
				 $("btnActivate").value = "Activate No Claim";
				 $("txtCancelTag").value = "Y";
				 $("chkCancelled").checked = true;
			 },'');
		}else{
			showConfirmBox("Confirm","Are you sure to activate this transaction?",
					 "Yes","No",
			function(){
				 $("btnActivate").value = "Cancel No Claim";
				 $("txtCancelTag").value = "N";
				 $("chkCancelled").checked = false;
			 },'');
		}
	});
	
	$("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveRecordGICLS026();
			}, function(){
				changeTag = 0;
				if(objCLM.noClaims.lineCd == null){
					goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
				}else{
					showNoClaimListing(objCLM.noClaims.lineCd);
				}
			}, "");
		} else {
			changeTag = 0;
			if(objCLM.noClaims.lineCd == null){
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			}else{
				showNoClaimListing(objCLM.noClaims.lineCd);
			}
		}
		//changeTag = 0;	//moved inside the functions by shan 10.14.2013
	});
	
	$("btnExit").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveRecordGICLS026();
			}, function(){
				changeTag = 0;
				if(objCLM.noClaims.lineCd == null){
					goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
				}else{
					showNoClaimListing(objCLM.noClaims.lineCd);
				}
			}, "");
		} else {
			changeTag = 0;
			if(objCLM.noClaims.lineCd == null){
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			}else{
				showNoClaimListing(objCLM.noClaims.lineCd);
			}
		}
		//changeTag = 0;	//moved inside the functions by shan 10.14.2013
	});
	
	$("hrefDateOfLoss").observe("click", function(){
		try{
			if($F("txtLineCd") != "" ||  $F("txtSublineCd") != "" ||  $F("txtIssCd") != "" ||  $F("txtIssueYy") != "" ||   $F("txtPolSeqNo") != "" ||  $F("txtRenewNo") != ""){
				if($F("txtItemNo") != ""){
					scwShow($('txtDateOfLoss'),this, null);
					needCommit = "Y";
					changeTag = 1;
					$("txtDateOfLoss").observe("blur", function(){
						if($F("txtTimeOfLoss") == ''){
							 $("txtTimeOfLoss").value = dateFormat(inceptDate, 'hh:MM TT') ;
						} 
					});
				}else{
					showWaitingMessageBox("Please select an item first", "I", function(){
						if($F("txtLineCd") == 'MC'){
							getMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
						}else{
							getNonMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
						}
					});
				}
			}else{
				customShowMessageBox("Policy No must be entered first.", "I", "txtLineCd");
			}
		}catch(e) {
			showErrorMessage("observe hrefDateOfLoss", e);
		}
	});
	
	$("txtDateOfLoss").observe("blur", function(){
		if($F("txtLineCd") != "" ||  $F("txtSublineCd") != "" ||  $F("txtIssCd") != "" ||  $F("txtIssueYy") != "" ||   $F("txtPolSeqNo") != "" ||  $F("txtRenewNo") != ""){
			if($F("txtItemNo") != ""){
				if($F("txtDateOfLoss") != ""){
					var sysdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM TT');
					if( Date.parse(dateFormat($F("txtDateOfLoss"), 'mm-dd-yyyy hh:MM TT')) > Date.parse(sysdate) /* Date.parse($F("txtDateOfLoss")) > Date.parse(sysdate) */){ //edited by steven 12/12/2012
						 showWaitingMessageBox("Loss date and time should not be later than the current date and time.", "I", function(){
							 $("txtDateOfLoss").value = "";
							 $("txtTimeOfLoss").value = "";
							 return false;
						 });
					 }else{
						 if($F("txtInceptDate")=="" || $F("txtExpiryDate")==""){
							 showMessageBox("Cannot proceed, incept date / expiry date must not be null.", imgMessage.ERROR);
							 $("txtDateOfLoss").value = "";
							 return false;
						 }else{
							 checkItemGICLS026();
							 /* if(Date.parse($F("txtDateOfLoss")) >  Date.parse(inceptDate)){ //commented-out by steven 2.6.2013;base on google docs UCPBGEN - UAT Errors Encountered Feb. 06, 2013.this message should be shown only after pressing <Save>
								 
							 }else{
								 showWaitingMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
										 dateFormat(inceptDate, 'mm-dd-yyyy hh:MM TT')+ " to "+dateFormat(expiryDate, 'mm-dd-yyyy hh:MM TT'), "I", function(){
									 $("txtDateOfLoss").value = "";
									 $("txtTimeOfLoss").value = "";
									 $("txtDateOfLoss").focus();
									 return false;
								 });
							 } */
						 }
					 }
				}
			}else{
				showWaitingMessageBox("Please select an item first", "I", function(){
					if($F("txtLineCd") == 'MC'){
						getMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
					}else{
						getNonMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
					}
				});
			}
		}else{
			customShowMessageBox("Policy No must be entered first.", "I", "txtLineCd");
		}
	});
	
	$("txtTimeOfLoss").observe("blur", function(){
		if($F("txtLineCd") != "" ||  $F("txtSublineCd") != "" ||  $F("txtIssCd") != "" ||  $F("txtIssueYy") != "" ||   $F("txtPolSeqNo") != "" ||  $F("txtRenewNo") != ""){
			if($F("txtItemNo") != ""){
				if($F("txtDateOfLoss") != ""){
						var sysdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM TT');
						if( Date.parse(dateFormat($F("txtDateOfLoss")+" "+$F("txtTimeOfLoss"), 'mm-dd-yyyy hh:MM TT')) > Date.parse(sysdate) ){ //robert 02.08.2013 
							 showWaitingMessageBox("Loss date and time should not be later than the current date and time.", "I", function(){
								 $("txtDateOfLoss").value = "";
								 $("txtTimeOfLoss").value = "";
								 return false;
							 });
						 }else{
							if($F("txtTimeOfLoss") == ""){
								 $("txtTimeOfLoss").value = dateFormat(inceptDate, 'hh:MM TT') ;
							} 
							var time = isValidTime("txtTimeOfLoss", "AM", true, false);
							if (!time){
								$("txtTimeOfLoss").value = "12:00 AM";
							} 
						 }
						 /* commented out by robert 02.08.2013
						 if(Date.parse($F("txtDateOfLoss")) >  Date.parse(inceptDate)){
							 
						 }else{
							 showWaitingMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
									 dateFormat(inceptDate, 'mm-dd-yyyy hh:MM TT')+ " to "+dateFormat(expiryDate, 'mm-dd-yyyy hh:MM TT'), "I", function(){
								 $("txtDateOfLoss").value = "";
								 $("txtDateOfLoss").focus();
								 return false;
							 });
						 } */
				}else{
					showWaitingMessageBox("Date of Loss must be entered first.", "I", function(){
						scwShow($('txtDateOfLoss'),this, null);
					});
				}
			}else{
				showWaitingMessageBox("Please select an item first", "I", function(){
					if($F("txtLineCd") == 'MC'){
						getMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
					}else{
						getNonMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
					}
				});
			}
		}else{
			customShowMessageBox("Policy No must be entered first.", "I", "txtLineCd");
		}
	});
	
	$("txtTimeOfLoss").observe("change", function(){
		needCommit = "Y";
	});
	
	$("txtAmount").observe("change", function(){
		needCommit = "Y";
	});
	
	$("txtRemarks").observe("change", function(){
		needCommit = "Y";
	});
		
	$("txtLineCdIcon").observe("click", function(){
		getPolbasicLineLOV("GICLS026", $F("txtIssCd"));	// parameters added by shan 10.14.2013
	});
	
	$("txtSublineCdIcon").observe("click", function(){
		if (nvl($F("txtLineCd"),null) != null){
			getPolbasicSublineLOV($F("txtLineCd"));
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
		
	$("txtIssCdIcon").observe("click", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
					getPolbasicIssLOV($F("txtLineCd"), $F("txtSublineCd"));
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				$("txtIssCd").clear();
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			$("txtIssCd").clear();
			return false;
		}
	});
	
	//added by shan 10.14.2013
	$("txtIssCd").observe("change", function(){
		if (this.value != ""){
			fireEvent($("txtIssCdIcon"), "click");
		}		
	});
	
	$("txtIssueYyIcon").observe("click", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
				if ($F("txtIssCd") != ""){			
					getPolbasicIssueYyLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"));
				}else{
					customShowMessageBox(polIssCdMsg, "I", "txtIssCd");
					return false;
				}	
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
	
	$("txtPolSeqNoIcon").observe("click", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
				if ($F("txtIssCd") != ""){			
					if ($F("txtIssueYy") != ""){	
						getPolbasicPolSeqNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"), $F("txtIssueYy"));
					}else{
						customShowMessageBox(issueYyMsg, "I", "txtIssueYy");
						return false;
					}	
				}else{
					customShowMessageBox(polIssCdMsg, "I", "txtIssCd");
					return false;
				}	
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
	
	$("txtRenewNoIcon").observe("click", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
				if ($F("txtIssCd") != ""){			
					if ($F("txtIssueYy") != ""){	
						if ($F("txtPolSeqNo") != ""){
							getPolbasicRenewNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"));
						}else{
							customShowMessageBox(polSeqNoMsg, "I", "txtPolSeqNo");
							return false;
						}
					}else{
						customShowMessageBox(issueYyMsg, "I", "txtIssueYy");
						return false;
					}	
				}else{
					customShowMessageBox(polIssCdMsg, "I", "txtIssCd");
					return false;
				}	
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
	
	$("hrefItemIcon").observe("click", function(){
		if($F("txtLineCd") == "" ||  $F("txtSublineCd") == "" ||  $F("txtIssCd") == "" ||  $F("txtIssueYy") == "" ||   $F("txtPolSeqNo") == "" ||  $F("txtRenewNo") == ""){
			customShowMessageBox("Policy No must be entered first.", "I", "txtLineCd");
		}else{
			if($F("txtLineCd") == 'MC'){
				getMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
			}else{
				getNonMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
			}
			changeTag = 1;
			needCommit = "Y";
		}
	});
	
	$("txtSublineCd").observe("blur", function(){
		if (nvl($F("txtLineCd"),null) != null){
			
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
	
	$("txtIssCd").observe("blur", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
					
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
	
	$("txtIssueYy").observe("blur", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
				if ($F("txtIssCd") != ""){			
					$("txtIssueYy").value = formatNumberDigits($F("txtIssueYy"),2);
				}else{
					customShowMessageBox(polIssCdMsg, "I", "txtIssCd");
					return false;
				}	
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	}); 
	
	$("txtPolSeqNo").observe("blur", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
				if ($F("txtIssCd") != ""){			
					if ($F("txtIssueYy") != ""){	
						$("txtPolSeqNo").value = formatNumberDigits($F("txtPolSeqNo"), 7);
					}else{
						customShowMessageBox(issueYyMsg, "I", "txtIssueYy");
						return false;
					}	
				}else{
					customShowMessageBox(polIssCdMsg, "I", "txtIssCd");
					return false;
				}	
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	}); 
	
	$("txtRenewNo").observe("blur", function(){
		if (nvl($F("txtLineCd"),null) != null){
			if ($F("txtSublineCd") != ""){
				if ($F("txtIssCd") != ""){			
					if ($F("txtIssueYy") != ""){	
						if ($F("txtPolSeqNo") != ""){
							$("txtRenewNo").value = formatNumberDigits($F("txtRenewNo"),2);
							if (objCLMGlobal.noClaimId == null){
								checkPolicyGICLS026();
							}
						}else{
							customShowMessageBox(polSeqNoMsg, "I", "txtPolSeqNo");
							return false;
						}
					}else{
						customShowMessageBox(issueYyMsg, "I", "txtIssueYy");
						return false;
					}	
				}else{
					customShowMessageBox(polIssCdMsg, "I", "txtIssCd");
					return false;
				}	
			}else{
				customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
				return false;
			}
		}else{
			customShowMessageBox(lineCdMsg, "I", "txtLineCd");
			return false;
		}
	});
	
	$("editRemarks").observe("click", function () {
		//showEditor("txtRemarks", 4000);
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("btnSave").observe("click", function(){
		var isComplete = checkAllRequiredFields();
		
		if (isComplete == true){
			 if(changeTag == 0){
				showMessageBox("No changes to save.", imgMessage.INFO);
				return false;
			}else{
				var sysdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM TT');
				if( Date.parse(dateFormat($F("txtDateOfLoss")+" "+$F("txtTimeOfLoss"), 'mm-dd-yyyy hh:MM TT')) > Date.parse(sysdate) ){ //robert 02.08.2013 
					 showWaitingMessageBox("Loss date and time should not be later than the current date and time.", "I", function(){
						 $("txtDateOfLoss").value = "";
						 $("txtTimeOfLoss").value = "";
						 return false;
					 });
				}
				if($F("txtTimeOfLoss").charAt(0) == "1" && $F("txtTimeOfLoss").charAt(1) == "2" && $F("txtTimeOfLoss").charAt(6) == "P"){//modified condition for time js error by robert 04.02.2013 sr12719
					if(Date.parse($F("txtDateOfLoss")+" "+$F("txtTimeOfLoss").replace(" PM","")) >=  Date.parse(inceptDate)){ 
						ref = 'Y';
						saveRecordGICLS026();
					}else{
						 showWaitingMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
								 dateFormat(inceptDate, 'mm-dd-yyyy hh:MM TT')+ " to "+dateFormat(expiryDate, 'mm-dd-yyyy hh:MM TT'), "I", function(){
							 $("txtDateOfLoss").value = "";
							 $("txtTimeOfLoss").value = "";
							 $("txtDateOfLoss").focus();
						 });
					} 
				}else{
					if(Date.parse($F("txtDateOfLoss")+" "+$F("txtTimeOfLoss")) >=  Date.parse(inceptDate)){ 
						if($F("txtDateOfLoss") == dateFormat(inceptDate, 'mm-dd-yyyy')){
							if($F("txtTimeOfLoss").charAt(0) == "1" && $F("txtTimeOfLoss").charAt(1) == "2" && $F("txtTimeOfLoss").charAt(6) == "A"){
								if(Date.parse($F("txtDateOfLoss")+" "+$F("txtTimeOfLoss").replace("12:","00:")) >=  Date.parse(inceptDate)){ 
									ref = 'Y';
									saveRecordGICLS026();
								}else{
									 showWaitingMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
											 dateFormat(inceptDate, 'mm-dd-yyyy hh:MM TT')+ " to "+dateFormat(expiryDate, 'mm-dd-yyyy hh:MM TT'), "I", function(){
										 $("txtDateOfLoss").value = "";
										 $("txtTimeOfLoss").value = "";
										 $("txtDateOfLoss").focus();
									 });
								}
							}else{
								ref = 'Y';
								saveRecordGICLS026();
							}
						}else{
							ref = 'Y';
							saveRecordGICLS026();
						}
					}else{
						 showWaitingMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
								 dateFormat(inceptDate, 'mm-dd-yyyy hh:MM TT')+ " to "+dateFormat(expiryDate, 'mm-dd-yyyy hh:MM TT'), "I", function(){
							 $("txtDateOfLoss").value = "";
							 $("txtTimeOfLoss").value = "";
							 $("txtDateOfLoss").focus();
						 });
					}
				} 
			}
		} 
	});
	
	$("btnPrint").observe("click", function(){
		 if(needCommit=="Y"){
			showMessageBox("Save changes first before printing.","I");
		}else{
			 if($F("txtCancelTag") == "Y"){
					showMessageBox("Cannot print cancelled transaction.", imgMessage.INFO);
					return false;
				}
			checkVersionGICLS026();	// uncommented : shan 10.16.2013
			// andrew - 08.13.2012			
			//showGenericPrintDialog("Print No Claim Certificate", populateGICLR026);	// moved to checkVersionGICLS026() : shan 10.16.2013
		}
	});
	
	function getMotcarItemDtls(){
		try{
			new Ajax.Request(contextPath+"/GICLNoClaimController",{
				parameters:{
					action   : "getMotcarItemDtls",
					itemNo			: $F("txtItemNo"),
					lineCd				: $F("txtLineCd"),
					sublineCd		: $F("txtSublineCd"),
					issCd				: $F("txtIssCd"),
					issueYy			: $F("txtIssueYy"),
					polSeqNo		: $F("txtPolSeqNo"),
					renewNo		: $F("txtRenewNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == ''){
							clearPopulatedDtls();//added by christian 02/07/2013
							getMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
						}else{
							var result = response.responseText.toQueryParams();
							populateMcDtls(result);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getMotcarItemDtls", e);
		}
	}
	
	function populateMcDtls(row){
		$("txtItemTitle").value = unescapeHTML2(row.itemTitle);
		$("txtCompany").value = unescapeHTML2(row.carCompany);
		$("txtMake").value = unescapeHTML2(row.make);
		$("txtMotorNo").value = unescapeHTML2(row.motorNo);
		$("txtSerialNo").value = unescapeHTML2(row.serialNo);
		$("txtPlateNo").value = unescapeHTML2(row.plateNo);
		$("txtBasicColor").value = unescapeHTML2(row.basicColor);
		$("txtColor").value = unescapeHTML2(row.color);
		$("txtModelYear").value = unescapeHTML2(row.modelYear);
		$("txtMotcarCompCd").value = unescapeHTML2(row.carCompanyCd);
		$("txtMakeCd").value = unescapeHTML2(row.makeCd);
		$("txtItemNo").value = formatNumberDigits(row.itemNo,5);
		$("txtBasicColorCd").value = unescapeHTML2(row.basicColorCd);
		$("txtColorCd").value = unescapeHTML2(row.colorCd);
	}
	
	//To clear details if itemNo doesn't exist - christian 02/07/2013
	function clearPopulatedDtls(){
		$("txtItemNo").value		= "";
		$("txtItemTitle").value 	= "";
		$("txtCompany").value 		= "";
		$("txtMake").value 			= "";
		$("txtMotorNo").value		= "";
		$("txtSerialNo").value 		= "";
		$("txtPlateNo").value 		= "";
		$("txtBasicColor").value 	= "";
		$("txtColor").value			= "";
		$("txtModelYear").value 	= "";
		$("txtMotcarCompCd").value 	= "";
		$("txtMakeCd").value 		= "";
		$("txtBasicColorCd").value 	= "";
		$("txtColorCd").value 		= "";
	}
	
	//Error yung sa CS nakakapagsave siya ng policy na yung item niya ay para sa iba, iclear nalang kapag nagpalit ng policy. - christian 02-07-2013
	function clearAllDtls(){
		$("txtAssuredName").value	= "";
		$("txtInceptDate").value	= "";
		$("txtExpiryDate").value	= "";
		clearPopulatedDtls();
	}
	
	/*$("txtItemNo").observe("blur", function(){
		if($F("txtItemNo") == ""){
// 			customShowMessageBox("Field must be entered.", "I", "txtItemNo");
			showWaitingMessageBox("Field must be entered.", "I", function(){ //added by steven 2.6.2013
							if($F("txtLineCd") == 'MC'){
								getMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
							}else{
								getNonMotCarItemLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"));
							}
					});
			$("txtItemTitle").value = "";
		}else{
			if($F("txtLineCd") == 'MC'){
				getMotcarItemDtls();
			}else{
				getNonMCItemTitle();
			}
		}
	});*///commented out by christian 02/07/2013
	
	$("txtItemNo").observe("change", function(){ 	//added by christian 02/07/2013
		if($F("txtLineCd") == 'MC'){
			getMotcarItemDtls();
		}else{
			getNonMCItemTitle();
		}
	});
	
	//clearObjectValues(objCLM.noClaims);
	observeReloadForm("reloadForm", showNoClaimCertificate);
	setModuleId("GICLS026");
	newFormInstanceGICLS026();
	changeTag = 0;
	initializeChangeTagBehavior(function(){
		ref = "Y";		// added to stay on No Claim Certificate and prevent navigating to No Claim Listing : shan 10.14.2013
		saveRecordGICLS026();
	});
	initializeChangeAttribute();
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
}catch(e){
	showErrorMessage("GICLS026 page", e);
}
</script>
