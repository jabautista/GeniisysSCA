<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="disbursementVoucherMainDiv">
	<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label id="lblMain">Generate Disbursement Voucher</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="reloadFormDV" name="reloadForm" style="margin-left: 5px">Reload Form</label>
				</span>				 
			</div>
	</div> 
	
	<div id="disbursementVoucherInfoDiv" name="disbursementVoucherInfoDiv" changeTagAttr="true">
	<form id="disbursementVoucherForm" name="disbursementVoucherForm">
		<div id="disbursementVoucherSubDiv1" name="disbursementVoucherSubDiv1" class="sectionDiv" style="align:center; ">
			<table border="0" style="width:800px; margin:20px auto 20px 35px;">
				<tr>
					<td align="right" width="120px">Company</td>
					<td width="280px">
						<div name="reqDiv" style="float:left; border: solid 1px gray; width: 400px; height: 23px; margin-right:0px; margin-top: 0px;" class="required" changeTagAttr="true">
							<input type="text" id="company" name="company" class="required" lastValidValue="" style="width:370px; border:none; float:left;" tabindex="101" changeTagAttr="true" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCompany" name="osCompany" alt="Go" changeTagAttr="true" />
						</div>
						<input type="hidden" id="txtFundCd" name="txtFundCd" />
						<input type="hidden" id="txtDspFundDesc" name="txtDspFundDesc" />	
					</td>
					<td align="right" width="120px">Branch</td>
					<td>
						<div name="reqDiv" style="float:left; border: solid 1px gray; width: 200px; height: 23px; margin-right:0px; margin-top: 0px;" class="required" changeTagAttr="true">
							<input type="text" id="txtBranch" name="txtBranch" readonly="readonly" class="required" style="width:170px; border:none; float:left;"  tabindex="102"  disabled="disabled" changeTagAttr="true" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranch" name="osBranch" alt="Go" changeTagAttr="true" />
						</div>	
						<input type="hidden" id="hidBranchCd" name="hidBranchCd" />
						<input type="hidden" id="hidBranchName" name="hidBranchName" />						
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="hidCurrencyCd" name="hidCurrencyCd" />
						<input type="hidden" id="hidGaccTranId" name="hidGaccTranId" class="reset" />						
						<input type="hidden" id="hidGoucOucId" name="hidGoucOucId" class="reset" />
						<input type="hidden" id="hidNbtLineCdTag" name="hidNbtLineCdTag" />
						<input type="hidden" id="hidNbtYyTag" name="hidNbtYyTag" />
						<input type="hidden" id="hidNbtMmTag" name="hidNbtMmTag" />
						<input type="hidden" id="hidDocumentName" name="hidDocumentName" />
						<input type="hidden" id="hidRefId" name="hidRefId" class="reset" />
						<input type="hidden" id="hidReqDtlNo" name="hidReqDtlNo" class="reset" />
						<input type="hidden" id="hidRequestDate" name="hidRequestDate" class="reset" />
						<input type="hidden" id="hidDVTag" name="hidDVTag" />
						<input type="hidden" id="hidPayeeNo" name="hidPayeeNo" />
						<input type="hidden" id="hidReplenishedTag" name="hidReplenishedTag" />
						<input type="hidden" id="hidCreateDate" name="hidCreateDate" />
						<input type="hidden" id="hidApproveDate" name="hidApproveDate" />
						<input type="hidden" id="hidPrintDate" name="hidPrintDate" />
						<input type="hidden" id="hidLastUpdate" name="hidLastUpdate" />
						
					</td>
				</tr>
			</table>
		</div>
		
		<div id="disbursementVoucherSubDiv2" name="disbursementVoucherSubDiv2" class="sectionDiv" changeTagAttr="true">
			<table border="0" style="width: 840px; margin:30px auto 20px auto;" cellpadding="0" cellspacing="2">
				<tr>
					<td align="right" width="140px">DV Date</td>
					<td colspan="2"  width="400px" align="left">
						<div name="reqDiv" style="border: solid 1px gray; width:389px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" class="required">
					    	<input type="text" id="txtDVDate" name="txtDVDate"  style="float:left;width:365px; border: none; height:12px;" class="required" changeTagAttr="true"  />
					    	<img name="hrefDVDate" id="hrefDVDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="DVDate" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<td align="right" width="120px">Reference No.</td>
					<td><input type="text" id="txtDVRefNo" name="txtDVRefNo" maxLength="15" style="float:left; margin-left:5px; width:200px;" changeTagAttr="true"  /></td>
				</tr>
				<tr>
					<td align="right">DV No.</td>
					<td>
						<input type="text" id="txtDVPref" name="txtDVPref" maxLength="5" style="width:90px;" />
						<input type="text" id="txtDVNo" name="txtDVNo" maxLength="10" style="text-align: right; width:282px;" />
										
					</td>
					<td><div id="lblDVTagDiv" name="lblDVTagDiv" style="width:7px;">
							<!-- <input type="text" id="lblDVTag" name="lblDVTag" style="float:left; width:10px; border: none; height:12px;" readonly="readonly" /> -->
							<label id="lblDVTag" name="lblDVTag" title="DV Tag" for="txtDVNo"></label>
						</div>		</td>
					<td align="right">DV Status</td>
					<td>
						<input type="text" id="txtDVFlag" name="txtDVFlag" style="float:left; margin-left:5px; text-align:center; width:50px;" readonly="readonly" />
						<input type="text" id="txtDVFlagMean" name="txtDVFlagMean" style="float:left; margin-left:4px; width:138px;" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td align="right">Payt Req. No.</td>
					<td width="400px" style="float:left; ">
						<div name="reqDiv" style="float:left; border: solid 1px gray; width:70px; height: 19px; margin-right:0px; margin-left:5px; margin-top: 2px;" class="required">
							<input type="text" id="txtDocumentCd" name="scheme" class="required" lastValidValue="" maxLength="5" style="width:40px; border:none; float:left; height:11px;" />
							<img style="float:right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osDocumentCd" name="osDocumentCd" alt="Go" changeTagAttr="true" />
						</div>	
						<!-- <input type="text" id="txtDocumentCd" name="txtDocumentCd" maxLength="5" style="width:70px;" readonly="readonly" /> -->
						
						<input type="text" id="txtBranchCd" name="txtBranchCd" maxLength="2" style="float:left; width:40px; height:13px; margin-left:4px; margin-top:2px;" readonly="readonly" />
						
						<!-- <input type="text" id="txtLineCd" name="txtLineCd" maxLength="2" style="width:35px;" readonly="readonly" /> -->
						<select id="selLineCd" name="scheme" title="Valid Values for Line Cd"  style="float:left; margin-left:4px; margin-top:2px; width:60px; height:21px;" readonly="readonly"></select>
												
						<!-- <input type="text" id="txtDocYear" name="txtDocYear" maxLength="4" style="text-align: right; width:35px;" readonly="readonly" /> -->
						<select id="selDocYear" name="scheme" title="Valid Values for Document Year" style="float:left; margin-left:4px; margin-top:2px; width:60px; height:21px;">
						</select>
						
						<!-- <input type="text" id="txtDocMonth" name="txtDocMonth" maxLength="2" style="text-align: right; width:35px;"  readonly="readonly" /> -->
						<select id="selDocMonth" name="scheme" title="Valid Values for Document Month"  style="float:left; margin-left:4px; margin-top:2px; width:60px; height:21px; margin-right:0px;"></select>
						
						<!-- <input type="text" id="txtDocSeqNo" name="txtDocSeqNo" maxLength="6" style="text-align: right; width:60px;" readonly="readonly" /> -->
						<div name="reqDiv" style="float:left; border: solid 1px gray; width:70px; height: 20px; margin-right:0px; margin-left:4px; margin-top: 2px;"  class="required"  >
							<input type="text" id="txtDocSeqNo" name="scheme" class="required integerNoNegativeUnformatted" lastValidValue="" maxLength="6" style="width:45px; border:none; float:left; height:11px;" readonly="readonly" />
							<img style="float:left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osDocSeqNo" name="osDocSeqNo" alt="Go" changeTagAttr="true" />
						</div>
					</td><td></td>
					<td align="right">DV Amount</td>
					<td>
						<input type="text" id="txtForeignCurrency" name="txtForeignCurrency" class="reset" style="float:left; margin-left:5px; width:50px;"  />
						<input type="text" id="txtForeignAmount" name="txtForeignAmount" style="float:left; margin-left:4px; text-align: right; width:138px;" class="reset money2" errorMsg="Field must be of form 99,999,999,999,990.99" min="-99999999999999.99" max="99999999999999.99" changeTagAttr="true"  />
					</td>
				</tr>
				<tr>
					<td align="right">Department</td>
					<td colspan="2"  align="left">
						<input type="text" id="txtOucCd" name="txtOucCd" style="margin-left:5px; text-align: right; width:90px;" readonly="readonly" class="reset" />
						<input type="text" id="txtOucName" name="txtOucName" style="width:282px;" readonly="readonly" class="reset" />
					</td>
					<td align="right">Currency Rate</td>
					<td><input type="text" id="txtCurrencyRt" name="txtCurrencyRt" style="float:left; margin-left:5px; text-align: right; width:200px;" class="reset"  /></td>
				</tr>
				<tr>
					<td align="right">Payee Class</td>
					<td>
						<input type="text" id="txtPayeeClassCd" name="txtPayeeClassCd" readonly="readonly"  class="reset" style="text-align:right; width:90px;" />
						<input type="text" id="txtPayeeClassDesc" name="txtPayeeClassDesc" readonly="readonly"  class="reset"  style="width:282px;" />
					</td><td></td>
					<td align="right">Local Amount</td>
					<td>
						<input type="text" id="txtLocalCurrency" name="txtLocalCurrency" style="float:left; margin-left:5px; width:50px;" class="reset"  />
						<input type="text" id="txtLocalAmount" name="txtLocalAmount" style="float:left; margin-left:4px; width:138px;" class="reset money2" errorMsg="Field must be of form 99,999,999,999,990.99" min="-99999999999999.99" max="99999999999999.99" changeTagAttr="true" />
					</td>
				</tr>
				<tr>
					<td align="right">Payee</td>
					<td colspan="4"><input type="text" id="txtPayeeName" name="txtPayeeName" maxlength="300" class="reset required" style="float:left; margin-left:5px; width:725px; height:13px;" /></td> <!-- added maxlength Halley 01.06.14 -->
				</tr>
				<tr>
					<td align="right">Particulars</td>
					<td colspan="4">
						<!-- <input type="text" id="txtParticulars" name="txtParticulars" style="width:680px;" /> -->
						<div name="reqDiv" class="required" style="float:left; border: solid 1px gray; width: 730px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" >
							<textarea id="txtParticulars" name="txtParticulars" class="reset required" style="float:left;  width:705px; border: none; height:13px;" maxlength="2000"  tabindex="106" changeTagAttr="true" ></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 15px; height: 15px; margin: 2px; float: left;" alt="EditParticulars" id="textParticulars" class="hover" />
						</div>	
					</td>
				</tr>
			</table>
			
			<div id="dvUserInformationDiv" name="dvUserInformationDiv" class="sectionDiv" style="text-align:left; width:530px; height:160px; float: left; margin: 10px 5px 20px 40px;">
				<br />&nbsp;&nbsp;&nbsp;DV User Information
				<table border="0" style="width: 510px; margin:15px 0 15px auto;">
					<tr>
						<td align="right">Created By</td>
						<td><input type="text" id="txtCreatedBy" name="txtCreatedBy" readonly="readonly" style="width:100px;" /></td>
						<td align="right">Create Date</td>
						<td><input type="text" id="txtCreateDate" name="txtCreateDate" readonly="readonly" style="width:150px;" /></td>
					</tr>
					<tr>
						<td align="right">Approved By</td>
						<td><input type="text" id="txtApprovedBy" name="txtApprovedBy" readonly="readonly" style="width:100px;" /></td>
						<td align="right">Approve Date</td>
						<td><input type="text" id="txtApproveDate" name="txtApproveDate" readonly="readonly" style="width:150px;" /></td>
					</tr>
					<tr>
						<td align="right">User ID</td>
						<td><input type="text" id="txtUserId" name="txtUserId" readonly="readonly" style="width:100px;" /></td>
						<td align="right">Last Update</td>
						<td><input type="text" id="txtLastUpdate" name="txtLastUpdate" readonly="readonly" style="width:150px;" /></td>
					</tr>
				</table>
			</div>
			
			<div id="dvUserInformationDiv" name="dvUserInformationDiv" class="sectionDiv" style="text-align:left; width:300px; height:160px; float:left; margin: 10px 20px 20px 0;">
				<br />&nbsp;&nbsp;&nbsp;DV/Check Print Information
				<table border="0" style="width: 270px; margin:15px 15px 15px 20px;">
					<tr>
						<td style="text-align:left;">
							DV Print Date/Time<br/>
							<input type="text" id="txtPrintDate" name="txtPrintDate" readonly="readonly" style="width:115px;" />
							<input type="text" id="txtPrintTime" name="txtPrintTime" readonly="readonly" style="width:115px;" /><br/>
						</td>
					</tr>
					<tr style="height:10px;"><td></td></tr>
					<tr>
						<td style="text-align:left;">
							DV/Check Print Status<br/>
							<input type="text" id="txtPrintTag" name="txtPrintTag" readonly="readonly" style="text-align: right; width:30px;" />
							<input type="text" id="txtPrintTagMean" name="txtPrintTagMean" readonly="readonly" style="width:200px;" />
						</td>
					</tr>					
				</table>
			</div>
			
			<div id="dvButtonsDiv" name="dvButtonsDiv" class="buttonsDiv" style="margin-bottom: 20px;">
				<input type="button" class="button noChangeTagAttr" id="btnApproveDV" name="btnApproveDV" value="Approve DV" />
				<input type="button" class="button noChangeTagAttr" id="btnDVDetails" name="btnDVDetails" value="DV Details" />
				<input type="button" class="button noChangeTagAttr" id="btnCheckDetails" name="btnCheckDetails" value="Check Details" />  
				<input type="button" class="button noChangeTagAttr" id="btnAccountingEntries" name="btnAccountingEntries" value="Accounting Entries" />
				<input type="button" class="button noChangeTagAttr" id="btnCancelDV" name="btnCancelDV" value="Cancel DV" /> 				
			</div> <!-- <input type="button" class="button noChangeTagAttr" id="btnCancelDV" name="btnCancelDV" value="Cancel DV" /> -->
			
		</div> <!-- end of div: disbursementVoucherSubDiv2 -->
		
		<div id="dvCancelSaveButtonsDiv" name="dvCancelSaveButtonsDiv" class="buttonsDiv" style="margin-bottom: 20px;">
			<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" />
			<input type="button" class="button" id="btnSave" name="btnSave" value="Save" />
		</div>	
		
	</form>	
	</div> <!-- end of div: disbursementVoucherInfoDiv -->
	
</div>
<div id="dvDetailsDiv"></div>
<script>	
	$("mainNav").show();
	setModuleId("GIACS002");
	changeTag = 0;
	objGIACS002.itemNoList = null;
	objGIACS002.exitPage = null;
	var giacParamsObj = new Object();
	
	if (objACGlobal.previousModule != null && objGIACS002.previousPage != "checkDetails" ){
		objGIACS002.prevModule = objACGlobal.previousModule;	//added by shan 08.27.2013: to hold orig previous module
		objGIACS002.queryOnly = objACGlobal.queryOnly;
	}
	
	try {
		var disbVoucherInfo = JSON.parse('${disbVoucherInfo}');
		var defaultFundCd = '${defaultFundCd}';
		//var tranFlag = JSON.parse('${tranFlag}');
		var tranFlag = '${tranFlag}';
		var tranSeqNo = '${tranSeqNo}';
		var loggedUser = '${userId}'; //added by robert to get the correct user when validating user function
	} catch(e){
		showErrorMessage("disbursementVoucher.jsp", e);
	}
	
	var origdvButtonsDivInnerHTML = $("dvButtonsDiv").innerHTML;
	var prevDocumentCd = null;
	var prevPaytLineCd = null;
	var prevPaytDocYear = null;
	var prevPaytDocMonth = null;
	var prevPaytDocSeqNo = null;
	var resetOn  = null;
	
	objACGlobal.tranFlagState = tranFlag;
	if(objGIACS002.cancelDV == "N" || objACGlobal.queryOnly == "Y" || objGIACS002.queryOnly == "Y"){	// objGIACS002.queryOnly added by shan 08.28.2013
		if(objGIACS002.dvTag == null || objACGlobal.previousModule == "GIACS230"){
			setDocumentTitle("Generate Disbursement Voucher");
			$("lblMain").innerHTML = "Generate Disbursement Voucher";
		}
		if(objACGlobal.previousModule == "GIACS237"){ //added by steven 10.09.2014
			disableButton("btnApproveDV");
		}
		/*else if(objGIACS002.dvTag == "M" ||){
			setDocumentTitle("Enter Manual DV/Check");
			$("lblMain").innerHTML = "Enter Manual DV/Check";
		}*/
		$("btnCancelDV").hide();
	} else {
		setDocumentTitle("Cancel DV/Check");
		$("lblMain").innerHTML = "Cancel DV/Check"; //added by steven 06.05.2013
		$("btnCancelDV").show();
		disableButton("btnApproveDV");
		/*var reqDivArray = [];
		disableChkFields(reqDivArray, true);*/	
	}
	
	function initializeFields(){
		$("hidGaccTranId").value = disbVoucherInfo.gaccTranId == null ? "" : disbVoucherInfo.gaccTranId;
		$("txtFundCd").value = disbVoucherInfo.gibrGfunFundCd == null ? "" : disbVoucherInfo.gibrGfunFundCd;
		$("txtDspFundDesc").value = disbVoucherInfo.fundDesc == null ? "" : disbVoucherInfo.fundDesc;
		$("hidBranchCd").value = disbVoucherInfo.gibrBranchCd == null ? "" : disbVoucherInfo.gibrBranchCd;
		$("hidBranchName").value = disbVoucherInfo.branchName == null ? "" : disbVoucherInfo.branchName;
		$("hidGoucOucId").value = disbVoucherInfo.goucOucId == null ? "" : disbVoucherInfo.goucOucId;
		$("hidNbtLineCdTag").value = disbVoucherInfo.nbtLineCdTag == null ? "" : disbVoucherInfo.nbtLineCdTag;
		$("hidNbtYyTag").value = disbVoucherInfo.nbtYyTag == null ? "" : disbVoucherInfo.nbtYyTag;
		$("hidNbtMmTag").value = disbVoucherInfo.nbtMmTag == null ? "" : disbVoucherInfo.nbtMmTag;	
		$("hidDVTag").value = disbVoucherInfo.dvTag == null ? "" : disbVoucherInfo.dvTag;
		if(objGIACS002.dvTag != "M"){	// added as to prevent resetting variable if from Enter Manual DV menu : shan 09.12.2014 
			objGIACS002.dvTag = disbVoucherInfo.dvTag == null ? "" : (disbVoucherInfo.dvTag == "*" ? "M" : objGIACS002.dvTag);
		}
		
		$("hidPayeeNo").value = disbVoucherInfo.payeeNo == null ? "" : disbVoucherInfo.payeeNo; // hindi kasama sa new screen design
		$("hidReplenishedTag").value = disbVoucherInfo.replnishedTag == null ? "" : disbVoucherInfo.replnishedTag;
		$("hidCurrencyCd").value = disbVoucherInfo.currencyCd == null ? "" : disbVoucherInfo.currencyCd;
		$("hidCreateDate").value = disbVoucherInfo.dvCreateDate == null ? "" : disbVoucherInfo.dvCreateDate; //new Date.parse(disbVoucherInfo.dvCreateDate, 'mm-dd-yyyy h:MM:ss TT'); //disbVoucherInfo.dvCreateDate;
		$("hidPrintDate").value = disbVoucherInfo.printDate == null ? "" : disbVoucherInfo.printDate;
		$("hidApproveDate").value = disbVoucherInfo.dvApproveDate == null ? "" : disbVoucherInfo.dvApproveDate;
		$("hidLastUpdate").value = disbVoucherInfo.lastUpdate == null ? "" : disbVoucherInfo.lastUpdate;
		$("hidRefId").value = disbVoucherInfo.gprqRefId == null ? "" : disbVoucherInfo.gprqRefId;
		$("hidReplenishedTag").value = disbVoucherInfo.replnishedTag == null ? "" : disbVoucherInfo.replnishedTag;
		$("hidReqDtlNo").value = disbVoucherInfo.redDtlNo == null ? "" : disbVoucherInfo.reqDtlNo;
		
		$("company").value = $F("txtDspFundDesc");//disbVoucherInfo.gibrGfunFundCd + " - " + disbVoucherInfo.fundDesc;
		$("txtBranch").value = $F("hidBranchName"); //disbVoucherInfo.gibrBranchCd + " - " + disbVoucherInfo.branchName;
		var initDVDate = new Date();
		$("txtDVDate").value = /*disbVoucherInfo.dvDateStr == null ? "" :*/ (disbVoucherInfo.dvDateStr == null ? dateFormat(initDVDate, 'mm-dd-yyyy') : disbVoucherInfo.dvDateStr); //dateFormat(disbVoucherInfo.dvDate, 'mm-dd-yyyy'); //new Date.parse(disbVoucherInfo.dvDate), "mm-dd-yyyy"); //disbVoucherInfo.dvDate;
		$("txtDVRefNo").value = disbVoucherInfo.refNo == null ? "" : disbVoucherInfo.refNo;
		$("txtDVPref").value = disbVoucherInfo.dvPref == null ? "" : disbVoucherInfo.dvPref;
		$("txtDVNo").value = disbVoucherInfo.dvNo == null ? "" : formatNumberDigits(disbVoucherInfo.dvNo, 10);		
		$("txtDVFlag").value = disbVoucherInfo.dvFlag == null ? "" :  disbVoucherInfo.dvFlag;
		$("txtDVFlagMean").value = disbVoucherInfo.dvFlagMean == null ? "" : disbVoucherInfo.dvFlagMean;		
		$("txtDocumentCd").value = disbVoucherInfo.gprqDocumentCd == null ? "" : disbVoucherInfo.gprqDocumentCd;
		$("txtBranchCd").value = disbVoucherInfo.gprqBranchCd == null ? "" : nvl(disbVoucherInfo.gprqBranchCd, objACGlobal.branchCd);

		$("selLineCd").innerHTML = disbVoucherInfo.gprqLineCd == null ? "" : "<option value=" + disbVoucherInfo.gprqLineCd +" selected='selected'>"+ disbVoucherInfo.gprqLineCd +"</option>";
		$("selDocYear").innerHTML = disbVoucherInfo.gprqDocYear == null ? "" : "<option value=" + disbVoucherInfo.gprqDocYear +" selected='selected'>"+ disbVoucherInfo.gprqDocYear +"</option>";
		$("selDocMonth").innerHTML = disbVoucherInfo.gprqDocMonth == null ? "" : "<option value=" + disbVoucherInfo.gprqDocMonth +" selected='selected'>"+ disbVoucherInfo.gprqDocMonth +"</option>";
		
		$("txtDocSeqNo").value = disbVoucherInfo.gprqDocSeqNo == null ? "" : formatNumberDigits(disbVoucherInfo.gprqDocSeqNo, 6);		
		$("txtForeignCurrency").value = disbVoucherInfo.foreignCurrency == null ? "" : disbVoucherInfo.foreignCurrency;
		$("txtForeignAmount").value = disbVoucherInfo.dvFcurrencyAmt == null ? null /*disbVoucherInfo.dvFcurrencyAmt*/ : formatCurrency(disbVoucherInfo.dvFcurrencyAmt);
		$("txtLocalCurrency").value = disbVoucherInfo.localCurrency == null ? "" : disbVoucherInfo.localCurrency;
		$("txtLocalAmount").value = disbVoucherInfo.dvAmt == null ? null /*disbVoucherInfo.dvAmt*/ : formatCurrency(disbVoucherInfo.dvAmt);
		
		$("txtOucCd").value = disbVoucherInfo.oucCd == null ? "" : formatNumberDigits(disbVoucherInfo.oucCd, 3);
		$("txtOucName").value = disbVoucherInfo.oucName == null ? "" : unescapeHTML2(disbVoucherInfo.oucName);
		
		$("txtCurrencyRt").value = disbVoucherInfo.currencyRt == null ? "" : formatToNineDecimal(disbVoucherInfo.currencyRt);
		$("txtPayeeClassCd").value = disbVoucherInfo.payeeClassCd == null ? "" : disbVoucherInfo.payeeClassCd;
		$("txtPayeeClassDesc").value = disbVoucherInfo.payeeClassDesc == null ? "" : disbVoucherInfo.payeeClassDesc;
		
		$("txtPayeeName").value = disbVoucherInfo.payee == null ? "" : unescapeHTML2(disbVoucherInfo.payee);
		$("txtParticulars").value = disbVoucherInfo.particulars == null ? "" : unescapeHTML2(disbVoucherInfo.particulars);		
		$("txtCreatedBy").value = disbVoucherInfo.dvCreatedBy == null ? userId : disbVoucherInfo.dvCreatedBy;
		$("txtCreateDate").value = disbVoucherInfo.strCreateDate == null ? dateFormat(new Date(), "mm-dd-yyyy hh:MM:ss TT") : disbVoucherInfo.strCreateDate; //disbVoucherInfo.dvCreateDate;
		$("txtApprovedBy").value = disbVoucherInfo.dvApprovedBy == null ? "" : disbVoucherInfo.dvApprovedBy;
		$("txtApproveDate").value = disbVoucherInfo.strApproveDate == null ? "" : disbVoucherInfo.strApproveDate; //disbVoucherInfo.dvApproveDate;
		$("txtUserId").value = disbVoucherInfo.userId == null ? userId : disbVoucherInfo.userId;
		$("txtLastUpdate").value = disbVoucherInfo.strLastUpdate == null ? dateFormat(new Date(), "mm-dd-yyyy hh:MM:ss TT") : disbVoucherInfo.strLastUpdate; //disbVoucherInfo.lastUpdate;
		$("txtPrintDate").value = disbVoucherInfo.dspPrintDate == null ? "" : disbVoucherInfo.dspPrintDate;
		$("txtPrintTime").value = disbVoucherInfo.dspPrintTime == null ? "" : disbVoucherInfo.dspPrintTime;
		$("txtPrintTag").value = disbVoucherInfo.printTag == null ? "" : disbVoucherInfo.printTag;
		$("txtPrintTagMean").value = disbVoucherInfo.printTagMean == null ? "" : disbVoucherInfo.printTagMean;	
		//added by steven 09.09.2014
		if(objGIACS002.cancelDV == "Y"){
			$("txtParticulars").readOnly = true;
		}
		
		objACGlobal.gaccTranId = $F("hidGaccTranId");
		objACGlobal.fundCd = $F("txtFundCd");
		objACGlobal.branchCd = $F("hidBranchCd");
		
		updateProperties();
		
		/*if(objGIACS002.previousPage == "checkDetails" && objGIACS002.spoiledCheck == true){
			if(objGIACS002.checkDVPrint == "1"){ //assigning the global values frm checkDetails.jsp
	        	$("hidPrintDate").value = objGIACS002.printDate;
				$("txtPrintDate").value = "";
				$("txtPrintTime").value = "";
				$("txtDVFlag").value = objGIACS002.dvFlag;
				$("txtDVFlagMean").value = objGIACS002.dvFlagMean;
	    		$("txtPrintTag").value = objGIACS002.printTag;
	    		$("txtPrintTagMean").value = objGIACS002.printTagMean;
				$("txtUserId").value = objGIACS002.userId;
				$("hidLastUpdate").value = objGIACS002.lastUpdate;
				$("txtLastUpdate").value = objGIACS002.lastUpdateStr;	    		 
	        }
			//objGIACS002.previousPage = "";
			//objGIACS002.spoiledCheck = false;
			saveDV(); // to save the changes made when fields were updated by hte global variables from  checkDetails.
		}*/
	}
	
	function updateProperties(){
		// for branchCd LOV
		if($F("hidBranchCd") != ""){
			if(disbVoucherInfo.checkUserPerIssCdAcctg == 0){
				enableSearch($("osBranch"));
			} else {
				disableSearch($("osBranch"));
			}
		}
		disableInputField("txtDVPref");
		disableInputField("txtDVNo");
		disableInputField("txtDVFlag");
		disableInputField("txtDVFlagMean");
		disableInputField("txtForeignCurrency");
		disableInputField("txtForeignAmount");
		disableInputField("txtCurrencyRt");
		disableInputField("txtLocalCurrency");
		disableInputField("txtLocalAmount");
		
		$("selLineCd").disabled = true;
		$("selDocYear").disabled = true;
		$("selDocMonth").disabled = true;
		disableInputField("txtDocSeqNo");
		disableSearch("osDocSeqNo");
		
		if($F("txtDVNo") != "" && $F("txtDVPref") != "" && $F("hidGaccTranId") != ""){ // RECORD_STATUS = QUERY
			enableFields(false);
			setApproveDVButton();
		}
	}
	
	function enableFields(flag){
		flag ? enableInputField("txtDVDate") : disableInputField("txtDVDate");
		flag ? enableInputField("txtDVDate") : disableInputField("txtDVDate");
		flag ? enableInputField("txtDocumentCd") : disableInputField("txtDocumentCd");
		flag ? enableInputField("txtBranchCd") : disableInputField("txtBranchCd"); 
		//flag ? enableInputField("selLineCd") : disableInputField("selLineCd");
		//flag ? enableInputField("selDocYear") : disableInputField("selDocYear");
		//flag ? enableInputField("selDocMonth") : disableInputField("selDocMonth");
		flag ? enableInputField("txtDocSeqNo") : disableInputField("txtDocSeqNo");
		//flag ? enableInputField("txtBranchCd") : disableInputField("txtBranchCd");
		
		flag ? enableInputField("txtPrintDate") : disableInputField("txtPrintDate");
		flag ? enableInputField("txtPrintTime") : disableInputField("txtPrintTime");
		
		flag ? enableDate("hrefDVDate") : disableDate("hrefDVDate");
		flag ? enableSearch("osCompany") : disableSearch("osCompany");
		flag ? enableSearch("osDocumentCd") : disableSearch("osDocumentCd");
		flag ? enableSearch("osDocSeqNo") : disableSearch("osDocSeqNo");
	}
	
	function setApproveDVButton(){
		// this is the first version of setApproveDVButton
		/*if(objGIACS002.dvTag == null){
			if($F("txtDVFlag") == "N" && (objGIACS002.dvApproval == "TRUE" || disbVoucherInfo.dvApproval == "TRUE")){
				enableButton("btnApproveDV");
			} else if($F("txtDVFlag") == "P" && (objGIACS002.dvApproval == "TRUE" || disbVoucherInfo.dvApproval == "TRUE")){
				if($F("txtApprovedBy") == ""){
					enableButton("btnApproveDV");
				} else {
					disableButton("btnApproveDV");
				}
			} else if($F("txtDVFlag") == "A"){
				disableButton("btnApproveDV");
			}
		} */
		
		// this is the second version of setApproveDVButton
		// set_approve_dv_button program unit
		if(objGIACS002.dvTag == null || objGIACS002.dvTag == ""){
			if($F("txtDVFlag") == "N" && (objGIACS002.dvApproval == "TRUE" || disbVoucherInfo.dvApproval == "TRUE") && objGIACS002.cancelDV != "Y"){ //objGIACS002.dvApproval == "TRUE"	// added cancelDV : shan 09.15.2014
				if(objGIACS002.recordStatus == null){  //:SYSTEM.RECORD_STATUS = 'QUERY'
					if(validateUserFunc3(loggedUser, "UD", "GIACS002") == true && objACGlobal.queryOnly != "Y"){
						enableButton("btnApproveDV");
					}
				} else {
					disableButton("btnApproveDV");
				}
			} 
			// if DV is printed and there is no approval and the user has authority to approve the approve button must be enabled
			else if ($F("txtDVFlag") == "P" && objGIACS002.dvApproval == "TRUE" && $F("txtApprovedBy") == "" && objACGlobal.queryOnly != "Y"){ 
				enableButton("btnApproveDV");
			} else {
				disableButton("btnApproveDV");
			}
		}
		if(objACGlobal.callingForm == "GIACS237" || objACGlobal.fromDvStatInq == 'Y'){ //added by Robert SR 5189 12.22.15
			disableButton("btnApproveDV");
		}
	}
	
	function executeTriggers(){
		executePreForm();
		executeWhenNewFormInstance();
		//executeWhenButtonPressedGIDV();		
	}
	
	function executePreForm(){
		if(objACGlobal.workflowEventDesc != null){
			objACGlobal.transaction = "Disbursement";
			objGIACS002.dvTag = null;
			objGIACS002.cancelDV = "N";
			objACGlobal.branchCd = disbVoucherInfo.grpIssCd;
			objACGlobal.fundCd = disbVoucherInfo.gibrGfunFundCd;
			
			if(objACGlobal.workflowEventDesc != "CREATE DV"){
				objACGlobal.giopGaccTranId = objACGlobal.workflowColVal;
			}
		}
		
		objGIACS002.checkDVPrint = disbVoucherInfo.checkDVPrint;
	}
	
	function executeWhenNewFormInstance(){
		objACGlobal.branchCd = disbVoucherInfo.gibrBranchCd;
		objACGlobal.fundCd = disbVoucherInfo.gibrGfunFundCd;
		objGIACS002.allowMultiCheck = disbVoucherInfo.allowMultiCheck;
		
		/*  Added by Dinahbots  14 January 1998
		**  If called by another form, display the corresponding DV record
		**  of the current tran_id when the button DV Info is pressed.
		*/
		if(objACGlobal.callingForm == "GIACS230" || objACGlobal.callingForm == "GIACS237" || objACGlobal.queryOnly == "Y" || objACGlobal.fromDvStatInq == 'Y'  //added condition by robert 11.27.2013
			    || objACGlobal.previousModule == "GIACS070" || objGIACS002.prevModule == "GIACS070"){
			// added by shan 04.29.2013
			//$("acExit").hide();		
			$("textParticulars").stopObserving("click");
			$("textParticulars").observe("click", function(){
				showEditor("txtParticulars", 2000, "true");
			});
			$$("div#disbursementVoucherSubDiv1 div[name='reqDiv'], div#disbursementVoucherSubDiv1 input[type='text'].required, div#disbursementVoucherSubDiv2 div[name='reqDiv'], div#disbursementVoucherSubDiv2 input[type='text']").each(function(txt){
				txt.removeClassName("required");
			});
			$("txtParticulars").removeClassName("required");
			disableButton("btnSave");
		} else if (objACGlobal.callingForm == "BANNER_SCREEN"){
			// NULL;
		} else {
			objGIACS002.preQuery = true;
			objACGlobal.queryOnly = "N";
		}

		//commented out by jeffdojello 12.18.2013 > causes Print DV/Check to malfunction
/* 	if(disbVoucherInfo.dvFlag == "P" || disbVoucherInfo.dvFlag == "C"){ //koks 12.16.13
			objACGlobal.queryOnly = "Y";
		} */
	
		/*** Set DV_NO to 'enabled' and 'updateable' if :GLOBAL.dv_tag is   'M' (Manual DV)    ***/
		if(objGIACS002.dvTag == "M" || disbVoucherInfo.dvTag == "*" || objACGlobal.dvTag == "M"){
			// moved outside of the if condition below.
			setDocumentTitle("Enter Manual DV/Check");
			$("lblMain").innerHTML = "Enter Manual DV/Check";
			$("lblDVTag").innerHTML = $F("hidDVTag") == "" ? "*" : $F("hidDVTag"); //"*";
			
			if(objACGlobal.queryOnly != "Y") {
				//enableInputField("txtPrintDate");
				$("txtPrintDate").addClassName("required");
				//$("txtPrintDate").disabled = false;
				//$("txtPrintDate").readonly = false;
				
				//enableInputField("txtPrintTime");
				$("txtPrintTime").addClassName("required");
				//$("txtPrintTime").disabled = false;
				//$("txtPrintTime").readonly = false;
				
				disableButton("btnApproveDV");
				//$("lblDVTag").innerHTML = $F("hidDVTag") == "" ? "*" : $F("hidDVTag"); //"*"; 
				//$("hidDVTag").value = "*";
				objACGlobal.dvTag = "M";
			} else {
				disableInputField("txtPrintDate");
				disableInputField("txtPrintTime");
			}
		} else if (objGIACS002.dvTag == null || objGIACS002.dvTag == ""){
			if(objGIACS002.checkDVPrint == 3){
				enableInputField("txtPrintDate");
				$("txtPrintDate").addClassName("required");
				$("txtPrintDate").disabled = false;
				
				enableInputField("txtPrintTime");
				$("txtPrintTime").addClassName("required");
				$("txtPrintTime").disabled = false;
			} else {
				$("txtPrintDate").disabled = false;
				disableInputField("txtPrintDate");
				
				$("txtPrintTime").disabled = false;
				disableInputField("txtPrintTime");
			}
			
			if(objGIACS002.cancelDV == "N"){
				objGIACS002.dvApproval = disbVoucherInfo.dvApproval;
				if(objACGlobal.callingForm == "GIACS048" || objACGlobal.callingForm == "GIACS237" || 
						objACGlobal.callingForm == "GIACS070" || objACGlobal.callingForm == "GIACS054" ){
					//  SET_BLOCK_PROPERTY('GIDV', DEFAULT_WHERE, 'dv_tag IS NULL and gacc_tran_id = :GLOBAL.CG$GIOP_GACC_TRAN_ID');  
				} else {
					// SET_BLOCK_PROPERTY('GIDV', DEFAULT_WHERE, 'dv_tag IS NULL');
				}
				// EXECUTE_QUERY;
			} else if(objGIACS002.cancelDV == "Y"){
				// set GCDB items
				
				// display cancel_dv button:
				/*var newDiv = origdvButtonsDivInnerHTML + "<input type='button' class='button noChangeTagAttr' id='btnCancelDV' name='btnCancelDV' value='Cancel DV' />";
				$("dvButtonsDiv").innerHTML = newDiv;*/
				
				//SET_ITEM_PROPERTY('gidv.dv_tag', DISPLAYED, PROPERTY_TRUE);                                            
			    //SET_BLOCK_PROPERTY('gidv', DEFAULT_WHERE, 'dv_flag <> ''C''');
			    //EXECUTE_QUERY;  
			}
		} else if(objGIACS002.dvTag == "I"){ /*added for when GIACS002 is called by GIACS230.*/
			disableButton("btnApproveDV");
			//SET_BLOCK_PROPERTY('GIDV', DEFAULT_WHERE, 'gacc_tran_id = :GLOBAL.CG$GIOP_GACC_TRAN_ID');
		    //EXECUTE_QUERY;
		} else {
			showMessageBox("objGIACS002.dvTag has an invalid value.", imgMessage.ERROR);
		}
		
		// A.R.C. 10.21.2005 
		// if form is called by workflow assign col_value to request no.
		if(objACGlobal.workflowColVal != null && objACGlobal.workflowEventDesc == "CREATE DV"){
			getGIACS002PaytRequests(objACGlobal.workflowColVal);
		}
		
		/*if(disbVoucherInfo.updatePayeeName == "N"){
			//set GCDB items
			//SET_ITEM_PROPERTY('gcdb.payee_no',enabled,PROPERTY_FALSE);
			//SET_ITEM_PROPERTY('gcdb.payee',enabled,PROPERTY_FALSE);
			//SET_ITEM_PROPERTY('gcdb.payee_class_cd',enabled,PROPERTY_FALSE);
		}*/
	}
	
	function getGIACS002PaytRequests(refId){
		try {
			new Ajax.Request(contextPath +"/GIACPaytRequestsController?action=getGIACS002PaytRequests", {
				parameters	: {
					refId	:	refId
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					showNotice("Getting payment request information, please wait...");
				},
				onComplete	: function(response){
					hideNotice("");
					var paytInfo = new Object();
					paytInfo = JSON.parse(response.responseText);
					$("txtDocumentCd").value = paytInfo.documentCd;
					/*$("txtBranchCd").value = paytInfo.branchCd;
					$("txtLineCd").value = paytInfo.lineCd;
					$("txtDocYear").value = paytInfo.docYear;
					$("txtDocMonth").value = paytInfo.docMm;
					$("txtDocSeqNo").value = paytInfo.docSeqNo;*/
				}
			});
		} catch(e){
			showErrorMessage("getGIACPaytRequests", e);
		}
	}
	
	function executeWhenButtonPressedGIDV(){
		if($F("txtDocumentCd") == nvl(disbVoucherInfo.clmDocCd, giacParamsObj.clmDocCd)){
			objACGlobal.documentName = "CLM_PAYT_REQ_DOC";
		} else if($F("txtDocumentCd") == nvl(disbVoucherInfo.riDocCd, giacParamsObj.riDocCd)){
			objACGlobal.documentName = "FACUL_RI_PREM_PAYT_DOC";
		} else if($F("txtDocumentCd") == nvl(disbVoucherInfo.commDocCd, giacParamsObj.commDocCd)){
			objACGlobal.documentName = "COMM_PAYT_DOC";
		} else if($F("txtDocumentCd") == nvl(disbVoucherInfo.bcsrDocCd, giacParamsObj.bcsrDocCd)){
			objACGlobal.documentName = "BATCH_CSR_DOC";
		} else {
			objACGlobal.documentName = "OTHERS";
		}
	}
	
	function executeWhenNewRecordInstanceGIDV(){
		setDVItems();
		
		// set_approve_dv_button program unit
		/*if(objGIACS002.dvTag == null || objGIACS002.dvTag == ""){
			if($F("txtDVFlag") == "N" && objGIACS002.dvApproval == "TRUE"){
				if(objGIACS002.recordStatus == null){  //:SYSTEM.RECORD_STATUS = 'QUERY'
					if(validateUserFunc3($F("txtUserId"), "UD", "GIACS002") == true){
						//("executeWhenNewRecordInstanceGIDV: validateUserfunc3 = true");
						enableButton("btnApproveDV");
					}
				} else {
					disableButton("btnApproveDV");
				}
			} 
			// if DV is printed and there is no approval and the user has authority to approve the approve button must be enabled
			else if ($F("txtDVFlag") == "P" && objGIACS002.dvApproval == "TRUE" && $F("txtApprovedBy") == ""){ 
				enableButton("btnApproveDV");
			} else {
				disableButton("btnApproveDV");
			}
		}*/
		setApproveDVButton();
		
		// prevent_update_of_payt_req_no program unit
		if($F("txtDVNo") != "" && $F("txtDVPref") != ""){ //:SYSTEM.RECORD_STATUS IN ('QUERY', 'CHANGED') /* objGIACS002.recordStatus == null || objGIACS002.recordStatus == 1 */ //$F("hidGaccTranId") != ""
			disableInputField("txtDocumentCd");
			disableInputField("txtDocSeqNo");
			
			$("selLineCd"). disabled = $F("hidNbtLineCdTag") == "Y" ? false : true;   //disbVoucherInfo.nbtLineCdTag
			$("selDocYear").disabled = $F("hidNbtYyTag") == "Y" ? false : true;
			$("selDocMm").disabled = $F("hidNbtMmTag") == "Y" ? false : true;
			
		}
		
		// set_print_dt_time program unit
		//if((objACGlobal.dvTag == null && objACGlobal.checkDVPrint == "3") || objACGlobal.dvTag == "M"){
		if((objGIACS002.dvTag == null && objACGlobal.checkDVPrint == "3") ){ //|| objGIACS002.dvTag == "M"
			if(objGIACS002.recordStatus == null || objGIACS002.recordStatus == 1){ //:SYSTEM.RECORD_STATUS IN ('QUERY', 'CHANGED')
				disableInputField("txtPrintDate");
				disableInputField("txtPrintTime");
			} else {
				enableInputField("txtPrintDate");
				enableInputField("txtPrintTime");
			}
		}
	}
	
	function setDVItems(){
		if (objGIACS002.dvTag == "M"){	// added condition : shan 09.12.2014
			$("txtPayeeName").removeClassName("required");
			disableInputField("txtPayeeName");
		}else {
			if($F("txtPrintTag") == "1" || $F("txtPrintTag") == "2" || $F("txtPrintTag") == "3"){
				enableInputField("txtDVRefNo");
			} else {
				disableInputField("txtDVRefNo");
				disableInputField("txtPrintDate");
				disableInputField("txtPrintTime");
			}
			
			if(validateUserFunc3(loggedUser, "UD", "GIACS002") == true){
				if($F("txtDVFlag") == "N"){
					if($F("txtPrintTag") == 1){
						enableInputField("txtParticulars");
						enableInputField("txtPayeeName");
						objGIACS002.overrideTag = true;
					} else {
						disableInputField("txtParticulars");
						disableInputField("txtPayeeName");
						objGIACS002.overrideTag = false;
					}
				} else {
					disableInputField("txtParticulars");
					disableInputField("txtPayeeName");
					objGIACS002.overrideTag = false;
				}
			} else {
				disableInputField("txtParticulars");
				disableInputField("txtPayeeName");
				objGIACS002.overrideTag = false;
			}
		}
	} 
	
	function executeKeyCreRecGIDV(){
		if(objACGlobal.dvTag == null || objACGlobal.dvTag == "M"){
		//if(objGIACS002.dvTag == null || objGIACS002.dvTag == "M"){
			if(objACGlobal.callingForm == "GIACS048" || objACGlobal.callingForm == "GIACS237"){
				showMessageBox("You cannot create records here.", imgMessage.INFO);
			}else if(objACGlobal.callingForm == "GIACS230"){
				
			}else {
				// proceed with creating new record
				executeWhenCreateRecordGIDV();				
			}
		} else {
			showMessageBox("objACGlobal.dvTag is invalid.", imgMessage.ERROR);
		}
	}
	
	function executeWhenCreateRecordGIDV(){
		if(objGIACS002.gidvCreateRec == "Y"){
			if(objGIACS002.cancelDV == "N"){
				$("txtFundCd").value = objACGlobal.fundCd;
				$("hidBranchCd").value = objACGlobal.branchCd; // for branchcd
				$("txtBranchCd").value = objACGlobal.branchCd; // for qprg_branchcd
				checkFundBranchFK();
				
				if(objGIACS002.dvTag == "M"){
					$("lblDVTag").innerHTML = "*";
					$("txtPrintDate").value = disbVoucherInfo.strPrintDate;
					$("txtPrintTime").value = disbVoucherInfo.strPrintTime;
					$("txtDVFlag").value = "P";
					$("txtDVFlagMean").value = "Printed";
					$("txtApprovedBy").value = "MANUAL";
					$("txtApproveDate").value = disbVoucherInfo.strLastUpdate;
					$("txtPrintTag").value = "6";
				} else if(objGIACS002.dvTag == null || objGIACS002.dvTag == ""){
					$("txtPrintDate").readOnly = true;
					$("txtPrintTime").readOnly = true;
					if(objGIACS002.checkDVPrint == "3"){
						$("txtPrintDate").value = disbVoucherInfo.strPrintDate;
						$("txtPrintTime").value = disbVoucherInfo.strPrintTime;
						$("txtDVFlag").value = "P";
						$("txtDVFlagMean").value = "Printed";
						$("txtApprovedBy").value = disbVoucherInfo.userId;
						$("txtApproveDate").value = disbVoucherInfo.strLastUpdate;
						$("txtPrintTag").value = "4";
					} else if (objGIACS002.checkDVPrint == "4"){
						$("txtDVFlag").value = "N";
						$("txtDVFlagMean").value = "New";
						$("txtPrintTag").value = "3";
					} else {
						$("txtDVFlag").value = "N";
						$("txtDVFlagMean").value = "New";
						$("txtPrintTag").value = "1";
					}					
				}
				getPrintTagMean();
			}
		}
	}
	
	function checkFundBranchFK(){
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=checkFundBranchFK", {
				parameters	: {
					fundCd		:	$F("txtFundCd"),
					branchCd	:	$F("hidBranchCd")
				},
				evalScripts: true,
				asynchronous: false,
				/*onCreate: function (){
					showNotice("Checking fund and branch codes, please wait...");
				},*/
				onComplete	: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var fundBranchInfo = new Object();
						fundBranchInfo = JSON.parse(response.responseText);
						$("hidBranchName").value = fundBranchInfo.branchName;
						$("txtDspFundDesc").value = fundBranchInfo.fundDesc;
					}
										
				}
				
			});
		} catch(e){
			showErrorMessage("checkFundBranchFK", e);
		}
	}
	
	function getPrintTagMean(){
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=getPrintTagMean", {
				parameters : {
					printTag : $F("txtPrintTag")
				},
				evalScripts : true,
				asynchronous : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						$("txtPrintTagMean").value = response.responseText;
					}
				}
			});
		} catch (e){
			showErrorMessage("getPrintTagMean", e);
		}
	}
	
	function getClosedTag(){
		try{
			new Ajax.Request(contextPath + "/GIACTranMmController?action=getClosedTag", {
				parameters : {
					fundCd	 : $F("txtFundCd"),  
					branchCd : $F("hidBranchCd"),
					dvDate   : $F("txtDVDate")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						validateDVDate(response.responseText);
					}
				}
			});
		} catch(e){
			showErrorMessage("getClosedTag", e);
		}
	}
	
	function validateDVDate(closedTag){
		var message = "";
		var dvDate = Date.parse($F("txtDVDate"));
		var isTranMonthClosed = false;
		
		if($F("txtDVDate") != ""){
			// transaction month temporarily closed
			if( closedTag == "T" && disbVoucherInfo.allowTranForClosedMonthTag == "N"){
				message = "You are no longer allowed to create a transaction for " + 
							dateFormat(dvDate, "mmmm") + " " + dateFormat(dvDate, "yyyy") + 
							". This transaction month is temporarily closed.";
				isTranMonthClosed = true;
			} 
			// transaction month already closed
			else if(closedTag == "Y" && disbVoucherInfo.allowTranForClosedMonthTag == "N"){
				message = "You are no longer allowed to create a transaction for " + 
							dateFormat(dvDate, "mmmm") + " " + dateFormat(dvDate, "yyyy") + 
							". This transaction month is already closed.";
				isTranMonthClosed = true;
			} 		
		}	
		
		if(isTranMonthClosed){
			customShowMessageBox(message, imgMessage.INFO, "txtDVDate");
			$("txtDVDate").value = new Date().format("mm-dd-yyyy");
		}else{
			$("txtDVRefNo").focus();				
		}	
	}
	
	
	function validateAcctEntriesBeforeApproving(){
		var totalAmount = getAccountingEntries();
		
		var temp = parseFloat(nvl(totalAmount, 0));
		var message = "temp: " + temp;
		
		
		if(temp > 0){
			message = "There is a debit balance of " + formatCurrency(totalAmount) +". Approve DV?";	
		} else if (temp < 0){
			message = "There is a credit balance of " + formatCurrency(totalAmount) +". Approve DV?";
		} else if(temp == 0){
			message = "Approve DV?";
		}
		
		showConfirmBox("Approve DV", message, "Yes", "No", approveValidatedDV, "", "");
	}
	
	function getAccountingEntries(){
		var output = null;
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=validateAcctEntriesBeforeApproving", {
				parameters :{
					gaccTranId : $F("hidGaccTranId")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating accounting entries, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var params = JSON.parse(response.responseText);
						output = params.creditDebitTotalAmount;
					}
				}
			});
		} catch(e){
			showErrorMessage("validateAcctEntriesBeforeApproving", e);
		}
		return output;
	}
	
	function approveValidatedDV(){
		if(objGIACS002.dvTag == "" || objGIACS002.dvTag == null){
			try{
				new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=approveValidatedDV", {
					parameters :{
						gaccTranId 	: $F("hidGaccTranId"),
						dvFlag	   	: $F("txtDVFlag"),
						moduleId	: "GIACS002",
						eventDesc	: "APPROVE DV",
						colValue	: $F("hidGaccTranId")
					},
					evalScripts: true,
					asynchronous: false,
					onCreate : function(){
						showNotice("Approving DV, please wait...");
					},
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							var params = JSON.parse(response.responseText);
							$("txtDVFlag").value = params.dvFlag;
							$("txtDVFlagMean").value = params.dvFlagMean;
							$("txtApprovedBy").value = params.approvedBy;
							$("txtApproveDate").value = params.approveDateStr;
							$("hidApproveDate").value = params.approveDate;
							disableButton("btnApproveDV");
							/*if(response.responseText == "SUCCESS"){
								showMessageBox("DV successfully approved.", imgMessage.INFO);
								
							}*/
							
						}
					}
				});
			} catch(e){
				showErrorMessage("approveValidatedDV", e);
			}
		}
	}
	
	function getDocList(yearOrMonth){		
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=getDoc" + yearOrMonth + "List", {
				parameters : {
					fundCd : $F("txtFundCd"),
					branchCd : $F("txtBranchCd"),
					documentCd : $F("txtDocumentCd"),
					moduleId : "GIACS002",
					lineCd : $F("selLineCd"),
					docYear : $F("selDocYear")
					
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response,null)){
						// function to populate the options in the selDocYY
						populateSelectDocList(JSON.parse(response.responseText), yearOrMonth);
					}
				}
			});
		} catch(e){
			showErrorMessage("selDocYear ", e);
		}
	}
	
	function populateSelectDocList(docList, yearOrMonth){
		if(yearOrMonth == "Year"){
			for (var i = 0; i < docList.length; i++) {
				var opt = document.createElement('option');
	            opt.text = docList[i].docYear;
	            opt.value = docList[i].docYear;  
				$("selDocYear").options.add(opt);
			}
		} else if(yearOrMonth == "Month") {
			for (var i = 0; i < docList.length; i++) {
				var opt = document.createElement('option');
	            opt.text = docList[i].docMm;
	            opt.value = docList[i].docMm;  
				$("selDocMonth").options.add(opt);
			}
		} else if(yearOrMonth == "Line"){
			for (var i = 0; i < docList.length; i++) {
				var opt = document.createElement('option');
	            opt.text = docList[i].lineCd; // +"\t-\t" + docList[i].lineName;
	            opt.value = docList[i].lineCd;  
				$("selLineCd").options.add(opt);
			}
		}
	}
	
	//Shows Company LOV based from giac_parameters
	function showGIACS002CompanyLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS002CompanyLOV",
				filterText : ($("company").readAttribute("lastValidValue").trim() != $F("company").trim() ? $F("company").trim() : "%")
			},
			title: "Valid Values for Companies",
			width: 455,
			height: 388,
			columnModel : [
			               {
			            	   id : "fundCd",
			            	   title: "Code",
			            	   width: '120px'
			               },
			               {
			            	   id: "fundDesc",
			            	   title: "Description",
			            	   width: '310px',
			            	   renderer: function(value) {
			       					return unescapeHTML2(value);
			       				}
			               }
			              ],
			autoSelectOneRecord : true,	
			draggable: true,
			filterText : ($("company").readAttribute("lastValidValue").trim() != $F("company").trim() ? $F("company").trim() : "%"),
			onSelect: function(row) {
				$("txtFundCd").value = unescapeHTML2(row.fundCd);
				$("txtDspFundDesc").value = unescapeHTML2(row.fundDesc);
				$("company").value = unescapeHTML2(row.fundDesc);
				$("company").setAttribute("lastValidValue", row.fundDesc);
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "company");
				$("company").value = $("company").readAttribute("lastValidValue");
			},
	  		onCancel: function(){
	  			$("company").focus();
	  			$("company").value = $("company").readAttribute("lastValidValue");
	  		},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	/**
	* Shows list of branches
	* @author Kris Felipe
	* @date 06.04.2012
	*/
	function showGIACS002BranchLOV(moduleId, fundCd, branchCd){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS002BranchLOV",
				fundCd: fundCd,
				branchCd: branchCd
			},
			title: "",
			width: 455,
			height: 388,
			columnModel : [
			               {
			            	   id : "branchCd",
			            	   title: "Code",
			            	   width: '120px'
			               },
			               {
			            	   id: "branchName",
			            	   title: "Branch Name",
			            	   width: '199px',
			            	   renderer: function(value) {
			       					return unescapeHTML2(value);
			       				}
			               },
			               {
			            	   id: "gfunFundCd",
			            	   title: "Fund Cd",
			            	   width: '120px'
			               }
			              ],
			//autoSelectOneRecord : true,	
			draggable: true,
			filterText: $F("hidBranchCd"),
			onSelect: function(row) {
				if(moduleId == "GIACS002"){
					$("hidBranchCd").value = unescapeHTML2(row.branchCd);
					$("hidBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);				
				}
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, $("branch"));
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS002"){
	  				$("txtBranch").focus();
	  			}
	  		}
		});
	}

	/**
	* Shows list of document_cd for GIACS002
	* @author Kris Felipe
	* @date 04.16.2013
	*/
	function showGIACS002DocumentLOV(moduleId, fundCd, branchCd){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS002DocumentLOV",
				fundCd: fundCd,
				branchCd: branchCd,
				moduleId : moduleId,
				filterText : ($("txtDocumentCd").readAttribute("lastValidValue").trim() != $F("txtDocumentCd").trim() ? $F("txtDocumentCd").trim() : "%"),
			},
			title: "Valid Values for Document Code",
			width: 455,
			height: 388,
			columnModel : [
			               {
			            	   id : "documentCd",
			            	   title: "Document Code",
			            	   width: '120px'
			               },
			               {
			            	   id: "documentName",
			            	   title: "Document Name",
			            	   width: '320px',
			            	   renderer: function(value) {
			       					return unescapeHTML2(value);
			       				}
			               }
			              ],
			autoSelectOneRecord : true,	
			draggable: true,
			//filterText: unescapeHTML2($F("txtDocumentCd")),
			filterText : ($("txtDocumentCd").readAttribute("lastValidValue").trim() != $F("txtDocumentCd").trim() ? $F("txtDocumentCd").trim() : "%"),
			onSelect: function(row) {
				if(moduleId == "GIACS002"){
					$("txtDocumentCd").value = unescapeHTML2(row.documentCd);
					$("txtDocumentCd").setAttribute("lastValidValue", row.documentCd);
					//if($F("txtDocumentCd") != ""){
						//updatePaytNumberingScheme();
						//if($F("hidGaccTranId") == ""){ // RECORD_STATUS  NOT IN ('QUERY', 'CHANGED')
							getPaytNumberingScheme();	
						//}
					//}	
					
				}
			},
			onUndefinedRow : function(){
				$("txtDocumentCd").value = $("txtDocumentCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocumentCd");
			},
	  		onCancel: function(){
	  			$("txtDocumentCd").value = $("txtDocumentCd").readAttribute("lastValidValue");
	  			$("txtDocumentCd").focus();
	  			$("selDocYear").disabled = true;
	  		},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	/*function updatePaytNumberingScheme(){
		if(changeTag == 0 && $F("hidGaccTranId") == 0){ // RECORD_STATUS  NOT IN ('QUERY', 'CHANGED')
			getPaytNumberingScheme();	
		}
	}*/
	
	function getPaytNumberingScheme(){
		try{
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=getPaytReqNumberingScheme", {
				parameters : {
					fundCd: $F("txtFundCd"),
					branchCd: $F("txtBranchCd"),
					documentCd: $F("txtDocumentCd")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var scheme = JSON.parse(response.responseText);
						$("hidNbtLineCdTag").value = scheme.lineCdTag;
						$("hidNbtYyTag").value = scheme.yyTag;
						$("hidNbtMmTag").value = scheme.mmTag;	
						
						$("selLineCd").disabled = scheme.lineCdTag == "Y" ? false : true;
						$("selDocYear").disabled = scheme.yyTag == "Y" ? false : true;
						$("selDocMonth").disabled = scheme.mmTag == "Y" ? false : true;
						
						/*if(scheme.lineCdTag == "Y"){
							$("selLineCd").disabled = false;
						} else {
							if(scheme.yyTag == "Y"){
								$("selLineCd").disabled = true;
								$("selDocYear").disabled = false;
							}
						}*/
						
						scheme.lineCdTag == "Y" ? $("selLineCd").addClassName("required") : $("selLineCd").removeClassName("required");
						scheme.yyTag == "Y" ? $("selDocYear").addClassName("required") : $("selDocYear").removeClassName("required");
						scheme.mmTag == "Y" ? $("selDocMonth").addClassName("required") : $("selDocMonth").removeClassName("required");						
						
						updateTags();												
					}
				}
			});
		}catch(e){
			showErrorMessage("getPaytNumberingScheme", e);
		}
	}

	
	
	function updateTags(){
		if($F("txtDVPref") == "" && $F("txtDVNo") == ""){								 
			$$("div#disbursementVoucherSubDiv1 input[class='reset'], div#disbursementVoucherSubDiv2 input[class='reset'], div#disbursementVoucherSubDiv2 input[class='reset required'], div#disbursementVoucherSubDiv2 input[class='reset money2'], div#disbursementVoucherSubDiv2 textarea[class='reset money2']").each(function(elem){
				$(elem).value = "";
			});
			changeTag = 1;
		
			var resetArr = ["txtDocumentCd", "selLineCd", "selDocYear", "selDocMonth", "txtDocSeqNo"];
			var newIndex = 0;
			for(var i=0; i<resetArr.length; i++){
				if(resetOn == resetArr[i]){
					newIndex = i+1;
					break;
				}
			}
			for(var x = newIndex; x<resetArr.length; x++){
				if(x < resetArr.length-1){
					$(resetArr[x]).options.length = 0;
				}
				$(resetArr[x]).value = "";
			}
		}		
	}
	
	function showGIACS002DocSeqNoLOV(moduleId, fundCd, branchCd, documentCd, lineCd, docYear, docMm){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getDocSeqNoLOV",
				fundCd: fundCd,
				moduleId : moduleId,
				branchCd: branchCd,
				documentCd: documentCd,
				lineCd: nvl(lineCd, ""),
				docYear : docYear,
				docMm : docMm,
				filterText : ($("txtDocSeqNo").readAttribute("lastValidValue").trim() != $F("txtDocSeqNo").trim() ? $F("txtDocSeqNo").trim() : "%")
			},
			title: "Valid Values for Document Sequence No",
			width: 800,
			height: 388,
			columnModel : [
			               {
			            	   id : "docSeqNo",
			            	   title: "Doc. Seq. No.",
			            	   titleAlign: 'right',
			            	   align: 'right',
			            	   width: '80px',
			            	   geniisysClass: 'number'
			               },
			               {
			            	   id: "fundCd",
			            	   title: "Company",
			            	   width: '100px'
			               },
			               {
			            	   id : "paytReqNo",
			            	   title: "Payment Request Number",
			            	   width: '150px'
			               },
			               {
			            	   id : "documentName",
			            	   title: "Document Name",
			            	   width: '150px'/* ,
			            	   renderer: function(value){
			            		   return unescapeHTML2(value);
			            	   } */
			               },
			               {
			            	   id : "requestDate",
			            	   title: "Request Date",
			            	   width: '120px',
			            	   geniisysClass: 'date',
			            	   filterOption: true,
							   filterOptionType: 'formattedDate',
							   sortable: true,
							   renderer: function(value){
									return dateFormat(value, 'dd-mmm-yy').toUpperCase();
								}
			               },
			               {
			            	   id : "dspDeptCd",
			            	   title: "Dept. Code",
			            	   titleAlign: 'right',
			            	   align: 'right',
			            	   width: '70px'
			               },
			               {
			            	   id : "dspOucName",
			            	   title: "Dept. Name",
			            	   width: '150px'/* ,
			            	   renderer: function(value){l
			            		   return unescapeHTML2(value);
			            	   } */
			               },
			               {
			            	   id : "payeeClassCd",
			            	   title: "Payee Class Cd",
			            	   width: '100px'
			               },
			               {
			            	   id : "classDesc",
			            	   title: "Class Desc",
			            	   width: '180px'
			               },
			               {
			            	   id : "payeeCd",
			            	   title: "Payee No.",
			            	   titleAlign: 'right',
			            	   align: 'right',
			            	   width: '60px'
			               },
			               {
			            	   id : "payee",
			            	   title: "Payee",
			            	   width: '180px'/* ,
			            	   renderer: function(value){
			            		   return escapeHTML2(value); //unescapeHTML2(value)
			            	   } */
			               },
			               {
			            	   id : "paytAmt",
			            	   title: "Payment Amt",
			            	   titleAlign: 'right',
			            	   align: 'right',
			            	   width: '120px',
			            	   geniisysClass: 'money'
			               },
			               {
			            	   id : "particulars",
			            	   title: "Particulars",
			            	   width: '150px'/* ,
			            	   renderer: function(value){
			            		   return escapeHTML2(value); //unescapeHTML2(value)
			            	   } */
			               },
			               {
			            	   id : "currencyCd",
			            	   title: "Currency",
			            	   titleAlign: 'right',
			            	   align: 'right',
			            	   width: '80px',
			            	   geniisysClass: 'number'
			               },
			               {
			            	   id : "dvFcurrencyAmt",
			            	   title: "Payment Amount",
			            	   titleAlign: 'right',
			            	   align: 'right',
			            	   width: '120px',
			            	   geniisysClass: 'money'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord : true,
			//filterText: unescapeHTML2($F("txtDocSeqNo")),
			filterText : ($("txtDocSeqNo").readAttribute("lastValidValue").trim() != $F("txtDocSeqNo").trim() ? $F("txtDocSeqNo").trim() : "%"),
			onSelect: function(row) {
				if(moduleId == "GIACS002"){
					validateDocSeqNo(fundCd, branchCd, documentCd, lineCd, docYear, docMm, row.docSeqNo);
					$("txtDocSeqNo").value = formatNumberDigits(row.docSeqNo, 6);	
					/*$("txtOucCd").value = row.dspDeptCd;
					$("txtOucName").value = unescapeHTML2(row.dspOucName);
					$("txtPayeeClassCd").value = row.payeeClassCd;
					$("txtPayeeClassDesc").value = unescapeHTML2(row.classDesc);
					$("txtPayeeName").value = unescapeHTML2(row.payee);
					//$("hidPayeeCd").value = row.payeeCd;
					$("txtParticulars").value = unescapeHTML2(row.particulars);
					$("txtForeignCurrency").value = row.currencyDesc;
					$("txtForeignAmount").value = formatCurrency(row.dvFcurrencyAmt);
					$("txtCurrencyRt").value = formatToNineDecimal(row.currencyRt);
					$("txtLocalAmount").value = formatCurrency(row.paytAmt);
					$("txtLocalCurrency").value = disbVoucherInfo.localCurrency;
					$("hidGaccTranId").value = row.tranId;
					objACGlobal.gaccTranId = row.tranId;*/
				}
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocSeqNo");
				$("txtDocSeqNo").value = $("txtDocSeqNo").readAttribute("lastValidValue");
			},
	  		onCancel: function(){
	  			$("txtDocSeqNo").value = $("txtDocSeqNo").readAttribute("lastValidValue");
	  		},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function validateDocSeqNo(fundCd, branchCd, documentCd, lineCd, docYear, docMm, docSeqNo){
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=validateDocSeqNo", {
				parameters :{
					fundCd : fundCd, 		//$F("txtFundCd"),
					branchCd: branchCd, 	//$F("txtBranchCd"),
					documentCd: documentCd, //$F("txtDocumentCd"),
					lineCd: lineCd, 		//$F("txtLineCd"),
					docYear: docYear, 		//$F("selDocYear"),
					docMm: docMm, 			//$F("selDocMm"),
					docSeqNo: docSeqNo 		//$F("txtDocSeqNo")
				},
				evalScripts: true,
				asynchronous: false,
				/*onCreate: function(){
					showNotice("Validating document sequence number, please wait...");
				},*/
				onComplete: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var row = JSON.parse(response.responseText);
						$("txtDocSeqNo").value = formatNumberDigits(row.docSeqNo, 6);	
						$("hidGoucOucId").value = row.goucOucId;
						$("txtOucCd").value = formatNumberDigits(row.dspDeptCd, 3);
						$("txtOucName").value = unescapeHTML2(row.dspOucName);
						$("txtPayeeClassCd").value = row.payeeClassCd;
						$("txtPayeeClassDesc").value = unescapeHTML2(row.classDesc);
						$("txtPayeeName").value = unescapeHTML2(row.payee);
						$("hidPayeeNo").value = row.payeeCd;
						//$("hidPayeeCd").value = row.payeeCd;
						$("txtParticulars").value = unescapeHTML2(row.particulars);
						$("txtForeignCurrency").value = row.currencyDesc;
						$("txtForeignAmount").value = formatCurrency(row.dvFcurrencyAmt);
						$("txtCurrencyRt").value = formatToNineDecimal(row.currencyRt);
						$("txtLocalAmount").value = formatCurrency(row.paytAmt);
						$("txtLocalCurrency").value = disbVoucherInfo.localCurrency;
						$("hidGaccTranId").value = row.tranId;
						//objACGlobal.gaccTranId = row.tranId;
						$("hidRefId").value = row.refId;
						$("hidReqDtlNo").value = row.reqDtlNo;
						$("hidRequestDate").value = row.requestDate;
						$("hidCurrencyCd").value = row.currencyCd;
					}
				}
			});
		}catch(e){
			showErrorMessage("validateDocSeqNo", e);
		}
	}
	
	function proceedSaveDV(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			if(checkAllRequiredFieldsInDiv("disbursementVoucherInfoDiv")){
				// If called by another form, display the corresponding OP record of the current tran_id when the button OP Info is pressed.
				if(objACGlobal.callingForm == "BANNER_SCREEN"){ 
					//checkGaccTranIdInAcctrans();
					// commented out, function will be done in validate_insert
				} else {
					//$("hidGaccTranId").value = objACGlobal.gaccTranId;
					$("hidBranchCd").value = objACGlobal.branchCd;
				}				
				 
				/* Clear foreign key columns if any optional columns are null */
				if($F("txtOucCd") == "" && $F("txtOucName") == ""){
					$("hidGoucOucId").value = "";
				}
				
				if($F("hidGaccTranId") != ""){
					//objACGlobal.gaccTranId = $("hidGaccTranId").value;
					objACGlobal.fundCd = $("txtFundCd").value;
					objACGlobal.branchCd = $("hidBranchCd").value;
				} else {
					showMessageBox("Pre-Insert: Tran ID not found.", "E");
				}
				saveDV();
			}
		}
	}
	
	function saveDV(){
		try {
			 new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=saveVoucher", {
				 method: "POST",
				 postBody: Form.serialize("disbursementVoucherForm") + "&callingForm=" + objACGlobal.callingForm + "&dvTag="+  (objGIACS002.dvTag == "M" ? "*" : "")
				 				+ "&globalDVTag=" + objACGlobal.dvTag + "&foreignAmount=" + unformatCurrencyValue($F("txtForeignAmount"))
				 				+ "&localAmount=" + unformatCurrencyValue($F("txtLocalAmount")) +"&moduleId=GIACS002" 
				 				+ "&selDocYear=" + $F("selDocYear") + "&selLineCd=" +$F("selLineCd") + "&selDocMonth=" + $F("selDocMonth")
				 				+ "&txtDocSeqNo=" + $F("txtDocSeqNo") + "&txtDocumentCd=" + $F("txtDocumentCd"),
				 evalScripts: true,
				 asynchronous: false,
				 onCreate: function(){
					 showNotice("Saving voucher, please wait...");
				 },
				 onComplete: function(response){
					 hideNotice("");
					 if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						 var voucher = JSON.parse(response.responseText);
						 // set the dv_pref and dv_no and other attributes returned that should be updated
						 $("txtDVPref").value = voucher.dvPref;
						 $("txtDVNo").value = formatNumberDigits(voucher.dvNo, 10);
						 objACGlobal.gaccTranId = voucher.gaccTranId;
						 objACGlobal.fundCd = voucher.gibrGfunFundCd;
						 objACGlobal.branchCd = voucher.gibrBranchCd;
						 $("hidGaccTranId").value = voucher.gaccTranId;
						 
						 giacParamsObj.clmDocCd = voucher.clmDocCd;
						 giacParamsObj.riDocCd = voucher.riDocCd;
						 giacParamsObj.commDocCd = voucher.commDocCd;
						 giacParamsObj.bcsrDocCd = voucher.bcsrDocCd;
						 
						 disbVoucherInfo.tranNo = voucher.tranNo;
						 disbVoucherInfo.dvNo = voucher.dvNo;
						 tranSeqNo = voucher.tranSeqNo;
						 
						/* if(objGIACS002.previousPage == "checkDetails" && objGIACS002.spoiledCheck == true){
							 objGIACS002.previousPage = "";
							 showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						 } else {*/
							 objGIACS002.previousPage = "";
							 showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								 changeTag = 0;
								 if(objGIACS002.exitPage != null){
									 objGIACS002.exitPage();
								 } else {
									 showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");	 
								 }
							 });
						//}
					 }
				 }
			 });
		 } catch(e){
			 showErrorMessage("saveDV", e);
		 }
	}
	
	//function validatePaytLineCd(){
	function validatePaytNumberScheme(code){
		var ins = code == "line" ? "line code" : (code == "docYy" ? "document year" : "document month"); 
		var message = "Validating " + ins + ", please wait...";
		var action = code == "line" ? "validatePaytLineCd" : (code == "docYy" ? "validatePaytDocYear" : "validatePaytDocMm");
		var item = code == "line" ? "selDocYear" : (code == "docYy" ? "selDocMonth" : "txtDocSeqNo");
				
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=" + action, {
				parameters:{
					fundCd		: $F("txtFundCd"),
					branchCd	: $F("txtBranchCd"),
					documentCd	: $F("txtDocumentCd"),
					lineCd		: $F("selLineCd"),
					lineCdTag	: $F("hidNbtLineCdTag"),
					docYear		: nvl($F("selDocYear"), 0),
					nbtYyTag	: $F("hidNbtYyTag"),
					docMm		: nvl($F("selDocMonth"), 0),
					nbtMmTag	: $F("hidNbtMmTag")
				},
				evalScripts: true, 
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						if(response.responseText == "SUCCESS"){
							// line code/docyy/docmm is valid.
							$(item).focus();							
						}	
					}
				}
			});
		}catch(e){
			showErrorMessage("validatePaytNumberScheme", e);
		}
	}
	
	
	/*function checkIfAutoSelectDocSeqNo(){
		try {
			new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=getDocSeqNoList", {
				parameters	: {
					fundCd		: $F("txtFundCd"),
					branchCd	: $F("txtBranchCd"),
					moduleId 	: "GIACS002",
					documentCd	: $F("txtDocumentCd"),
					lineCd		: nvl($F("selLineCd"), ""),
					docYear 	: $F("selDocYear"),
					docMm 		: $F("selDocMonth")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete	: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var docSeqNoList = [];
						docSeqNoList = JSON.parse(response.responseText);
						var listSize = docSeqNoList.lenght;
					}
				}
			});
		} catch(e){
			showErrorMessage("checkIfAutoSelectDocSeqNo", e);
		}
	}*/
	
	function showUserOverride(){
		showGenericOverride( // this is the original function
				"GIACS002",
				"UD",
				function(ovr, userId, result){
					if(result == "FALSE"){
						//showMessageBox( userId + " is not allowed to edit the DV Payee and Particulars.", imgMessage.ERROR);
						showMessageBox("Invalid username/password.", imgMessage.ERROR);
						$("txtOverrideUserName").clear();
						$("txtOverridePassword").clear();
						objGIACS002.overrideTag = false;
						return false;
					} else {
						if(result == "TRUE"){
							enableInputField("txtParticulars");
							enableInputField("txtPayeeName");
							objGIACS002.overrideTag = true;
							//addAccountingEntry();	
							ovr.close();
							delete ovr;	
						}
						// 	ovr.close();
						// 	delete ovr;	
					}
				},
				""
		);		
	}
	
	// added by Kris 04.22.2013: to show appropriate message for invalid day and/or month of dv date
	function validateDVDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		return status;
	}
	
	function checkIfOfppr(){
		var answer = "";
		try {
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=checkIfOfppr", {
				parameters : {
					gaccTranId: $F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				/* onCreate: function(){
					showNotice("Checking if document code is OFPPR, please wait...");
				}, */
				onComplete: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response)){
						answer = response.responseText;
					}
				}
			});
		}catch(e){
			showErrorMessage("checkIfOfppr", e);
		}
		return answer;
	}
	
	function proceedCancelDV(memo){
		var message = "";
		var transactionFlag = getTranFlag();
		if(transactionFlag == "P"){
			message = "This DV has a related CM (" + memo.memoType + "-" + memo.memoYear + "-" + lpad(memo.memoSeqNo, 6, 0) +") " +
						"that is already POSTED.  Cancel first the CM before cancelling the DV.";
			showMessageBox(message, "I");
		} else if(transactionFlag == "C"){
			message = "This DV has a related CM (" + memo.memoType + "-" + memo.memoYear + "-" + lpad(memo.memoSeqNo, 6, 0) +") " +
						").  Would you like to proceed with the cancellation?";
			showConfirmBox(message, "Yes", "No", checkCollectionDtl, "", "");
		}
	}
	
	function checkCollectionDtl(){
		try{
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=checkCollectionDtl", {
				parameters : {
					gaccTranId: $F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function(){
					showNotice("Checking collection details, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && customCheckErrorOnResponse(response, null)){
						var memo = JSON.parse(response.responseText);
						
						if(memo.orFound == "TRUE"){
							showMessageBox(param.message, "I");
						} else {
							showConfirmBox(param.message, "Ok", "Cancel", function(){preCancelDV(memo);}, "", "");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkCollectionDtl", e);
		}
	}
	
	// cancelDV(memo)
	function preCancelDV(memo){
		try{
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=preCancelDV", {
				parameters:{
					gaccTranId: $F("hidGaccTranId"),
					memoType: memo.memoType,
					memoYear: memo.memoYear,
					memoSeqNo: memo.memoSeqNo
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && customCheckErrorOnResponse(response, null)){
						cancelDV();
					}
				}
			});
		}catch(e){
			showErrorMessage("preCancelDV", e);
		}
	}
	
	function cancelDV(){
		try{
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=cancelDV", {
				parameters:{
					gaccTranId	: $F("hidGaccTranId"),
					fundCd		: $F("txtFundCd"),
					branchCd	: $F("txtBranchCd"),
					dvDate		: $F("txtDVDate"),
					dvFlag		: $F("txtDVFlag"),
					dvPref		: $F("txtDVPref"),
					dvNo		: $F("txtDVNo")				
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function(){
					showNotice("Cancelling disbursement voucher, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var dv = JSON.parse(response.responseText);
						$("txtDVFlag").value = dv.dvStatus;
						$("txtDVFlagMean").value = dv.dvStatusMean;
						$("txtLastUpdate").value = dv.dvLastUpdateStr;
						$("hidLastUpdate").value = dv.lastUpdate;
						$("txtUserId").value = dv.userId; //dito ung last
						objACGlobal.queryOnly = "Y";
						showMessageBox("Cancellation Successful!", imgMessage.SUCCESS); //added by John Daniel 04.12.2016
					}
				}
			});
		}catch(e){
			showErrorMessage("getTranFlag", e);
		}
	}
	
	function getTranFlag(){
		var answer = "";
		try{
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=getTranFlag", {
				parameters:{
					gaccTranId: $F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				/*onCreate: function(){
					showNotice("Getting tran flag, please wait...");
				},*/
				onComplete: function(response){
					//hideNotice("");
					if(checkErrorOnResponse(response)){
						answer = response.responseText;
					}
				}
			});
		}catch(e){
			showErrorMessage("getTranFlag", e);
		}
		return answer;
	}
	
	function verifyOfpprTrans(){
		try{
			new Ajax.Request(contextPath + "/GIACDisbVouchersController?action=verifyOfpprTrans", {
				parameters:{
					gaccTranId: $F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText != "{}"){
							var memo = JSON.parse(response.responseText);
							if(memo.exists != null || memo.exists != ""){
								showConfirmBox("Do you want to cancel this DV?", 
											   "Yes", 
											   "No", 
											   function(){
													proceedCancelDV(memo);
											   },
											   function(){}, 
											   "");
							}
						} else {
							showConfirmBox("Cancel DV", "Do you want to cancel this DV?", "Yes", "No", cancelDV, "", "");
						}
					}
				}
			});
		
			
		}catch(e){
			showErrorMessage("verifyOfpprTrans", e);
		}
		
	}
	
	/*function checkGaccTranIdInAcctrans(){
		try {
			new Ajax.Request(contexPath + "/GIACDisbVouchersController?action=checkGaccTranIdInAcctrans", {
				parameters:{
					gaccTranId: $F("hidGaccTranId")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function(){
					showNotice("Checking gacc Tran ID in giac_acctrans, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						// do nothing.
					}
				}
			});
		}catch(e){
			showErrorMessage("checkGaccTranIdInAcctrans", e);
		}
	}*/
	
	
	// observe items
	$("txtDVDate").observe("change", function(){
		var inputDate = Date.parse($F("txtDVDate")); 
		var prevDate = dateFormat(disbVoucherInfo.dvDate, 'mm-dd-yyyy');
		
		if($F("txtFundCd") == ""){
			customShowMessageBox("Please choose a company first.", imgMessage.INFO, "company");
			return false;
		} else {
			if($F("txtDVDate") == ""){
				//customShowMessageBox("Please specify a date.", "I", "txtDVDate");
			} else {
				if(validateDVDateFormat($F("txtDVDate"), "txtDVDate")){
					if(inputDate != null){
						$("txtDVDate").value = inputDate.format("mm-dd-yyyy");
						if(dateFormat($F("txtDVDate"), 'mm-dd-yyyy') != prevDate){
							getClosedTag();	
						}
					} else {
						$("txtDVDate").value = "";
						customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "txtDVDate");
					}
				} else {$("txtDVDate").value = "";}
				
				/*var prevDate = dateFormat(disbVoucherInfo.dvDate, 'mm-dd-yyyy');
				if($F("txtDVDate") != prevDate){
						getClosedTag();	
				}*/
				if((objGIACS002.dvTag == null && objGIACS002.checkDVPrint == "3") || objGIACS002.dvTag == "M"){
					if(prevDate != dateFormat($F("txtDVDate"), 'mm-dd-yyyy')){
						$("txtPrintDate").value = $F("txtDVDate");
					}
				}
			}
		}
	});
	
	$("hrefDVDate").observe("click", function(){
		if($F("txtDVPref") == "" && $F("txtDVNo") == ""){
			scwShow($('txtDVDate'),this, null);
		} 
	});
	
	$("txtPrintDate").observe("change", function(){
		if(!validateDVDateFormat($F("txtPrintDate"), "txtPrintDate")){
			$("txtPrintDate").clear();
		}
	});
	
	$("txtPrintTime").observe("change", function(){
		isValidTime("txtPrintTime", "PM", true, false);
	});
	$("txtPrintTime").observe("keyup", function(){
		$("txtPrintTime").value = $F("txtPrintTime").toUpperCase();
	});
	
	$("selLineCd").observe("click", function(){
		if($("selLineCd").disabled == false){
			//if($F("txtDocumentCd") != ""  && $F("txtBranchCd") != "" && $("selLineCd").options.length == 0){ orig
			if($F("txtDocumentCd") != ""  && $F("txtBranchCd") != ""){
				if($("selLineCd").options.length == 0){
					getDocList("Line");		
				} else {
					//prevPaytLineCd = $F("selLineCd");			
					resetOn = "selLineCd";
				}						
			} else {
				customShowMessageBox("Please select a Document Code first.", "I", "txtDocumentCd");
			}
		}
		if($F("selLineCd") != "" && $F("hidNbtYyTag") == "Y"){
			enableInputField("selDocYear");
		}
	});
	
	$("selLineCd").observe("change", function(){ // blur
		//prevPaytLineCd = $F("selLineCd");
	
		if($("selLineCd").disabled == false){
			if($F("txtDVNo") == "" && $F("txtDVPref") == "" && changeTag > 0){ // RECORD_STATUS = INSERT
				if($F("txtDocumentCd") != "" && $F("txtBranchCd") != ""){ // needed parameters should not be empty
					if($F("selLineCd") != ""){
						if(resetOn == "selLineCd"){
							updateTags();
						} 
						validatePaytNumberScheme("line");
						/* else {
							if(prevPaytLineCd != currLineCd){
								("magkaibang line");
								$("selDocYear").value = "";
								$("selDocYear").options.length = 0;
								$("selDocMonth").value = "";
								$("selDocMonth").options.length = 0;
								$("txtDocSeqNo").value = "";
							} 
						} */
						
					} else {
						customShowMessageBox("Field must be entered.", "I", "selLineCd");
					}
				}
			}
		}
		if($F("selLineCd") != "" && $F("hidNbtYyTag") == "Y"){
			enableInputField("selDocYear");
		}
	});
	
	$("selDocYear").observe("click", function(){
		if($("selDocYear").disabled == false){
			if($F("txtDocumentCd") != "" && $F("txtBranchCd") != ""){
				if(($F("hidNbtLineCdTag") == "Y" && $F("selLineCd") != null && $F("selLineCd") != "") || $F("hidNbtLineCdTag") == "N"){
					if($("selDocYear").options.length == 0){
						getDocList("Year");
					} else {
						resetOn = "selDocYear";
					}
				} else if ($F("hidNbtLineCdTag") == "Y" && $F("selLineCd") == null){
					customShowMessageBox("Please select a Line Code first.", "I", "selLineCd");
				}
				
				
				/* if($("selLineCd").disabled == true){
					getDocList("Year");
				} else {
					getDocList("Year");
				} */
			}	
		}
		
		if($F("selDocYear") != "" && $F("hidNbtMmTag") == "Y"){
			enableInputField("selDocYear");
		}
	});
	
	$("selDocYear").observe("change", function(){ //blur
		if($("selDocYear").disabled == false){
			if($F("txtDVNo") == "" && $F("txtDVPref") == "" && changeTag > 0){ // RECORD_STATUS = INSERT
				if($F("txtDocumentCd") != "" && $F("txtBranchCd") != "" && $F("selLineCd") != ""){ // needed parameters should not be empty
					if($F("selDocYear") != ""){
						if(resetOn == "selDocYear"){
							updateTags();
						} 
						validatePaytNumberScheme("docYy");
					} else {
						customShowMessageBox("Field must be entered.", "I", "selDocYear");
					}
				}
			}
		}
	});
	
	$("selDocMonth").observe("click", function(){
		if($("selDocYear").disabled == false){
			if($F("txtDocumentCd") != "" && $F("txtBranchCd") != ""){
				if( ($F("hidNbtYyTag") == "Y" && $F("selDocYear") != "" && $F("selDocYear") != null) || $F("hidNbtYyTag") == "N" ){
					if(($F("hidNbtLineCdTag") == "Y" && $F("selLineCd") != null && $F("selLineCd") != "") || ($F("hidNbtLineCdTag") == "N")){
						if($("selDocMonth").options.length == 0){
							getDocList("Month");	
						} else {
							resetOn = "selDocMonth";					
						}
					}
				} else if ($F("hidNbtLineCdTag") == "Y" && $F("selLineCd") == null){
					customShowMessageBox("Please select a Line Code first.", "I", "selLineCd");
				} else if($F("selDocYear") == null){
					customShowMessageBox("Please select a Document Year first.", "I", "selDocYear");
				}				
			}
		} 
		if($F("selDocMonth") != ""){
			enableSearch("osDocSeqNo");
			enableInputField("txtDocSeqNo");
		}
	});
	
	$("selDocMonth").observe("change", function(){
		if($("selDocMonth").disabled == false){
			if($F("txtDVNo") == "" && $F("txtDVPref") == "" && changeTag > 0){ // RECORD_STATUS = INSERT
				if($F("txtDocumentCd") != "" && $F("txtBranchCd") != "" && $F("selLineCd") != "" && $F("selDocYear") != ""){ // needed parameters should not be empty
					if($F("selDocMonth") != ""){
						if(resetOn == "selDocMonth"){
							updateTags();
						} 
						validatePaytNumberScheme("docMm");
					} else {
						customShowMessageBox("Field must be entered.", "I", "selDocMm");
					}
				}
			}
		}
	});
	
	/*$("selDocMonth").observe("change", function(){
		var reqFields = ["txtFundCd", "txtBranchCd", "txtDocumentCd", "selLineCd", "selLineCd", "selDocMonth"];
		isNull = false;
		for(var i=0; i<reqFields.length; i++){
			var val = $(i).value;
			isNull = val.trim() == "" ? true : false;
		}
	
		if(!isNull){
			try {
				new Ajax.Request(contextPath +"/GIACDisbVouchersController?action=getDocSeqNoList", {
					parameters	: {
						fundCd		: $F("txtFundCd"),
						branchCd	: $F("txtBranchCd"),
						moduleId 	: "GIACS002",
						documentCd	: $F("txtDocumentCd"),
						lineCd		: nvl($F("selLineCd"), ""),
						docYear 	: $F("selDocYear"),
						docMm 		: $F("selDocMonth")
					},
					evalScripts: true,
					asynchronous: false,
					onComplete	: function(response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							var docSeqNoList = [];
							docSeqNoList = JSON.parse(response.responseText);
							var listSize = docSeqNoList.lenght;
						}
					}
				});
			} catch(e){
				showErrorMessage("validateIfReleasedCheck", e);
			}
		}
	});*/
	
	
	/*$("txtDocSeqNo").observe("blur", function(){
		if($("txtDocSeqNo").disabled == false){
			if($F("txtDVNo") == "" && $F("txtDVPref") == "" && changeTag > 0){ // RECORD_STATUS = INSERT
				if($F("txtDocumentCd") != "" && $F("txtBranchCd") != ""  && $F("selDocYear") != "" && $F("selDocMonth") != ""){ // needed parameters should not be empty
					if($F("selLineCd") != ""){
						if( ($F("hidNbtLineCdTag") == "Y" && $F("selLineCd") != "") || $F("hidNbtLineCdTag") == "N"){
							
						}
						validatePaytNumberScheme("line");
					} else {
						//showMessageBox("Please enter a value for Line Code.", "I");
						customShowMessageBox("Field must be entered.", "I", "selLineCd");
					}
				}
			}
		}
	});*/
	
	$("txtOucCd").observe("click", function(){
		if($F("txtOucCd") == "" && $F("txtOucName") == ""){
			$("hidGoucOucId").value = "";
		}
	});
	
	$("txtPayeeName").observe("keyup", function(){
		if($F("txtDVFlag") == "N") { // RECORD_STATUS = NEW
			//if($("txtPayeeName").readonly == true){
			if(objGIACS002.overrideTag == false && !(objACGlobal.callingForm == "GIACS237" || objACGlobal.fromDvStatInq == 'Y')){ //added by Robert SR 5189 12.22.15
				//function show override_user not yet done.
				//showUserOverride();
				showConfirmBox("Update Not Allowed", "You are not allowed to update the payee/particulars of this DV. Would you like to override?", "Yes", "No",showUserOverride,"","");
			}
		}
		
		
	});
	
	function checkForOverride(){
		//if( $("txtParticulars").readonly == true || $("txtParticulars").readAttribute("readonly") == "readonly" ){
		if(objGIACS002.overrideTag == false){
// 			if($F("txtDVNo") != "" && $F("txtDVPref") != "") { // RECORD_STATUS = UPDATE //commented-out by steven 09.09.2014; 
				if(objGIACS002.dvTag == "M"){
					//$("txtPrintDate").focus();
					showOverlayEditor("txtParticulars", 2000, $("txtParticulars").readOnly);
				} else if($F("txtDVFlag") == "N") {
					showConfirmBox("Update Not Allowed", "You are not allowed to update the payee/particulars of this DV. Would you like to override?", "Yes", "No",showUserOverride,"","");					
				}
// 			} // if RECORD_STATUS = N, particulars can be edited.
		} else { // else user can freely update particulars.
			if(objGIACS002.cancelDV == "Y"){
				showOverlayEditor("txtParticulars", 2000, 'true');
			} else {
				showOverlayEditor("txtParticulars", 2000, $("txtParticulars").readOnly);
			}
		}
	}
		
	$("txtParticulars").observe("keyup", function() {
		if(objGIACS002.overrideTag == false){ //added by steven 09.09.2014
			if(objGIACS002.dvTag == "M"){
				//$("txtPrintDate").focus();	// in FMB this code is in KEY_NEXT_ITEM trigger
			} else if($F("txtDVFlag") == "N"  && !(objACGlobal.callingForm == "GIACS237" || objACGlobal.fromDvStatInq == 'Y')) { //added by Robert SR 5189 12.22.15
				showConfirmBox("Update Not Allowed", "You are not allowed to update the payee/particulars of this DV. Would you like to override?", "Yes", "No",showUserOverride,"","");					
			}
		}
	});
	
	$("textParticulars").observe("click", checkForOverride);
	
	$("company").observe("change", function(){
		if($F("company").trim() == "") {
			$("company").value = "";
			$("company").setAttribute("lastValidValue", "");
		} else {
			if($F("company").trim() != "" && $F("company") != $("company").readAttribute("lastValidValue")) {
				showGIACS002CompanyLOV();
			}
		}
	});
	$("company").observe("keyup", function(){
		$("company").value = $F("company").toUpperCase();
	});
	
	// SEARCH ICONS behavior
	$("osCompany").observe("click", showGIACS002CompanyLOV);
	
	$("osBranch").observe("click", function(){
		if($("osBranch").disabled != true){
			if($F("company") != ""){
				showGIACS002BranchLOV('GIACS002', $F("txtFundCd"), $F("hidBranchCd"));
			}
		}
	});
	
	$("osDocumentCd").observe("click", function(){
		//prevDocumentCd = $F("txtDocumentCd");
		if($F("txtDocumentCd").trim() != ""){
			resetOn = "txtDocumentCd";
		}
		showGIACS002DocumentLOV('GIACS002', $F("txtFundCd"), $F("txtBranchCd"));		
		
	});
	
	$("txtDocumentCd").observe("change", function() {
		resetOn = "txtDocumentCd";
		
		if($F("txtDocumentCd").trim() == "") {
			$("txtDocumentCd").value = "";
			$("txtDocumentCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDocumentCd").trim() != "" && $F("txtDocumentCd") != $("txtDocumentCd").readAttribute("lastValidValue")) {
				showGIACS002DocumentLOV('GIACS002', $F("txtFundCd"), $F("txtBranchCd"));
			}
		}
	});	 
	
	$("txtDocumentCd").observe("keyup", function() {
		$("txtDocumentCd").value = $F("txtDocumentCd").toUpperCase();
	});
	
	$("txtDocSeqNo").observe("change", function() {
		if($F("txtDocSeqNo").trim() == "") {
			$("txtDocSeqNo").value = "";
			$("txtDocSeqNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDocSeqNo").trim() != "" && $F("txtDocSeqNo") != $("txtDocSeqNo").readAttribute("lastValidValue")) {
				showGIACS002DocSeqNoLOV("GIACS002", $F("txtFundCd"), $F("txtBranchCd"), $F("txtDocumentCd"), $F("selLineCd"), $F("selDocYear"), $F("selDocMonth"));
			}
		}
	});	 
	
	$("osDocSeqNo").observe("click", function(){
		//if($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtDocumentCd") != "" /* && $F("txtLineCd") != "" */ && $F("selDocYear") != "" && $F("selDocMonth") != ""){
		//	showGIACS002DocSeqNoLOV("GIACS002", $F("txtFundCd"), $F("txtBranchCd"), $F("txtDocumentCd"), $F("selLineCd"), $F("selDocYear"), $F("selDocMonth"));
		//}
		
		if($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtDocumentCd") != ""){
			if( ($F("hidNbtLineCdTag") == "Y" && $F("selLineCd") != "" && $F("selLineCd") != null)  || ($F("hidNbtLineCdTag") == "N" && $("selLineCd").disabled == true) ){
				if( ($F("hidNbtYyTag") == "Y" && $F("selDocYear") != "" && $F("selDocYear") != null)  || ($F("hidNbtYyTag") == "N" && $("selDocYear").disabled == true) ){
					if(($F("hidNbtMmTag") == "Y" && $F("selDocMonth") != "" && $F("selDocMonth") != null)  || ($F("hidNbtMmTag") == "N" && $("selDocMonth").disabled == true)){
						showGIACS002DocSeqNoLOV("GIACS002", $F("txtFundCd"), $F("txtBranchCd"), $F("txtDocumentCd"), $F("selLineCd"), $F("selDocYear"), $F("selDocMonth"));
					} else {
						showMessageBox("Please select Document Month first.", "I");
					}
				} else {
					showMessageBox("Please select Document Year first.", "I");
				}
			} else {
				showMessageBox("Please select Line Code first.", "I");
			}
		}
	});
	
	
	// BUTTONS behavior
	$("btnApproveDV").observe("click", function(){
		if(disbVoucherInfo.checkUserPerIssCdAcctg == 0){
			showMessageBox("User is not allowed to approve DV for this branch.", imgMessage.ERROR);
		}
		if(changeTag == 0 && $F("txtDVPref") == "" && $F("txtDVNo") == ""){  //record is NEW // $F("hidGaccTranId") == ""
			showMessageBox("Please create a DV record first.", imgMessage.INFO);
		} else if(changeTag == 1 && $F("txtDVPref") == "" && $F("txtDVNo") == ""){ // record is INSERT //$F("hidGaccTranId") == ""
			showMessageBox("Please save this new record first.", imgMessage.INFO);
		} else if(changeTag == 1 && $F("txtDVPref") != "" && $F("txtDVNo") != ""){ // record is changed //  $F("hidGaccTranId") != ""
			showMessageBox("Please save or clear your changes first.", imgMessage.INFO);
		} else {
			validateAcctEntriesBeforeApproving();
		}
	});
	
	
	function updateGlobalVars(){
		objACGlobal.calledForm = "";
		objACGlobal.tranSource = "DV";
		objACGlobal.gaccTranId = $F("hidGaccTranId");
		objACGlobal.fundCd = $("txtFundCd").value;
		objACGlobal.branchCd = $("hidBranchCd").value;
		objACGlobal.previousModule = "GIACS002";
		objACGlobal.giopGaccTranId = $F("hidGaccTranId");
		objACGlobal.transaction = "Disbursement";
		
		objGIACS002.fundCd = $F("txtFundCd");
		objGIACS002.branchCd = $F("txtBranchCd");
		objGIACS002.tranNo = disbVoucherInfo.tranNo + "-" + formatNumberDigits(tranSeqNo,6);
						/*new Date.parse($F("txtDVDate"), "mm-dd-yyyy").format("yyyy") + "-" + 
							 new Date.parse($F("txtDVDate"), "mm-dd-yyyy").format("mm") + "-" + formatNumberDigits(tranSeqNo,6);*/
		objGIACS002.dvNo = formatNumberDigits(disbVoucherInfo.dvNo, 6);
		objGIACS002.dvStatus = $F("txtDVFlagMean");
		objGIACS002.dvDateStrSp = disbVoucherInfo.dvDateStrSp;
		objGIACS002.dvDate = $F("txtDVDate");
		objGIACS002.localCurrency = $F("txtLocalCurrency");
		objGIACS002.localCurrencyCd = $F("hidCurrencyCd");
		objGIACS002.currencyRt = $F("txtCurrencyRt");
		objGIACS002.localAmount = $F("txtLocalAmount");
		objGIACS002.foreignCurrency = $F("txtForeignCurrency");
		objGIACS002.foreignAmount = $F("txtForeignAmount");
		objGIACS002.payee = $F("txtPayeeName");
		
		// for check spoil.. dapat iupdate ung text fields based sa value ng global na nireturn from checkDetails
		objGIACS002.spoiledCheck = false; 				// if check spoilage procedure executed while in checkDetails page
		objGIACS002.printDate = $F("hidPrintDate"); 	// if null > make str time and date = ""
		objGIACS002.dvFlag = $F("txtDVFlag");
		objGIACS002.dvFlagMean = $F("txtDVFlagMean");
		objGIACS002.printTag = $F("txtPrintTag");
		objGIACS002.printTagMean = $F("txtPrintTagMean");
		objGIACS002.userId = $F("txtUserId");
		objGIACS002.lastUpdate = $F("hidLastUpdate");
		objGIACS002.lastUpdateStr = $F("txtLastUpdate");
		// end for checkspoil
		
		///// temporary
		objACGlobal.withPdc = "N"; //$("withPdc").value == "" ? 'N' : 'Y';
		//objACGlobal.documentName = "";
		objACGlobal.implSwParam = "Y"; //$F("implSwParam");
		//////
		
		executeWhenButtonPressedGIDV();
	}

	function disableChkFields(reqDivArray, flag){
		// if flag == true > disable
		try{
			if (reqDivArray!= null){
				for ( var i = 0; i < reqDivArray.length; i++) {
					$$("div#"+reqDivArray[i]+" input[type='text']").each(function (a) {
						$(a).readOnly = flag;
						//$(a).disable();
					});
					$$("div#"+reqDivArray[i]+" img").each(function (c) {
						flag ? disableSearch(c) : enableSearch(c);
					});
					$$("div#"+reqDivArray[i]+" input[type='button']").each(function (d) {
						if(d == "btnAdd"){
							flag ? disableButton(d) : enableButton(d);
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("disableModuleFields", e);
		}
	}
	
	function showOtherTransTaxPayts(){
		try {
			//new Ajax.Request(contextPath +"/GIACCollnsForOtherOfficeController?action=showCollnsForOtherOfficesTableGrid",{
			new Ajax.Updater("mainContents", contextPath+"/GIACCollnsForOtherOfficeController?action=showCollnsForOtherOfficesTableGrid&" ,{
					method: "GET",
					parameters	: {
						gaccTranId	: objACGlobal.gaccTranId,
						ajax		: 1
					},
					evalScripts: true,
					asynchronous: false,
					onCreate: function (){
						showNotice("Getting tax payment information, please wait...");
					},
					onComplete	: function(response){
						hideNotice("");
						
					}
			});			
		} catch(e){
			showErrorMessage("showOtherTransTaxPayts", e);
		}
	}
	
	function goToDVDetails(){
		objACGlobal.callingForm = "DETAILS";
		updateGlobalVars();
		
		if(objGIACS002.dvTag == "M"){
			objACGlobal.allowCloseTrans = "Y";
		} else {
			objACGlobal.allowCloseTrans = "N";
		}
		
		var dvId = objGIACS002.fromGIACS054 ? "dvDetailsDiv" : "mainContents";	// shan 09.26.2014
		$("disbursementVoucherMainDiv").hide();
		$("dvDetailsDiv").show();
		
		// call the details
		new Ajax.Updater(dvId, contextPath+"/GIACOrderOfPaymentController?action=showORDetails&" ,{
			method: "GET",
			parameters : {
				gaccTranId : objACGlobal.gaccTranId
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Loading Transaction Basic Information. Please wait...");
			},
			onComplete: function() {
				hideNotice("");
				objACGlobal.queryOnly = "Y";	// added by shan 09.10.2014					
			}
		}); 
		
		/* if(objACGlobal.documentName == "CLM_PAYT_REQ_DOC" || objACGlobal.documentName == "BATCH_CSR_DOC"){
			// direct trans >> direct claim payments
		} else if(objACGlobal.documentName == "FACUL_RI_PREM_PAYT_DOC"){
			// ri trans >> 	
		} else if(objACGlobal.documentName == "COMM_PAYT_DOC"){
			// direct trans >> commission payts
		} else {
			// other trans >> taxpayts
			
			if(objACGlobal.implSwParam == "Y"){
				//implementation_sw == Y
				//add tab 7 = PDC Collections
			}
		} */
	}

	$("btnDVDetails").observe("click", function(){
		var proceed = true;
	
		if($F("txtDVPref") == "" && $F("txtDVNo") == "" && changeTag == 0){
			//showMessageBox("Please create a DV record  first.", imgMessage.INFO);
			proceed = false;
		} else if($F("txtDVPref") == "" && $F("txtDVNo") == "" && changeTag == 1){
			//showMessageBox("Please save this new record first.", imgMessage.INFO);
			proceed = false;
		} else if($F("txtDVPref") != "" && $F("txtDVNo") != "" && changeTag == 1){
			//showMessageBox("Please save or clear your changes first.", imgMessage.INFO);
			proceed = false;
		}
		// if statement above replaced with the following if.
		if(!proceed){
			showConfirmBox4("Confirmation", "Do you want to save the changes you have made?", "Yes", "No", "Cancel", 
								function(){
									objGIACS002.exitPage = goToDVDetails;
									proceedSaveDV();
								}, 
								function(){}, "", "");
		} else {
			goToDVDetails();
		}
	});
	
	function goToCheckDetails(){
		objGIACS002.dvFlag = $F("txtDVFlag");
		updateGlobalVars();
		showCheckDetailsPage(disbVoucherInfo, $F("hidGaccTranId"));
		objGIACS002.disbVoucherInfo = disbVoucherInfo;
	}
	
	$("btnCheckDetails").observe("click", function(){
		objGIACS002.previousPage = "";
		objGIACS002.disbVoucherInfo = null;
		var proceed = true;
		if($F("txtDVPref") == "" && $F("txtDVNo") == "" && changeTag == 0){
			//showMessageBox("Please create a DV record  first.", imgMessage.INFO);
			proceed = false;
		} else if($F("txtDVPref") == "" && $F("txtDVNo") == "" && changeTag == 1){
			//showMessageBox("Please save this new record first.", imgMessage.INFO);
			proceed = false;
		} else if($F("txtDVPref") != "" && $F("txtDVNo") != "" && changeTag == 1){
			//showMessageBox("Please save or clear your changes first.", imgMessage.INFO);
			proceed = false;
		}
		
		if(!proceed){
			showConfirmBox4("Confirmation", "Do you want to save the changes you have made?", "Yes", "No", "Cancel", 
								function(){
									objGIACS002.exitPage = goToCheckDetails;
									proceedSaveDV();
								}, 
								function(){}, "", "");
		} else {
			goToCheckDetails();
		}
	});
	
	function goToDVAcctgEntries(){
		objACGlobal.callingForm = "ACCT_ENTRIES";
		updateGlobalVars();
		// acctg entries page
		showORInfoWithAcctEntries();
		objACGlobal.queryOnly = "Y";	// added by shan 09.10.2014
		
		if (objGIACS002.dvTag == "M"){	// added by shan 09.15.2014
			objGIACS002.allowCloseTrans = "Y";
		}else{
			objGIACS002.allowCloseTrans = "N";
		}
		
		$$("div[name='subMenuDiv']").each(function(row){
			row.hide();
		});
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == "acctEntries") {
				$("acctEntries").up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});	
	}
	
	$("btnAccountingEntries").observe("click", function(){
		objGIACS002.previousPage = "";
		var proceed = true;
		if($F("txtDVPref") == "" && $F("txtDVNo") == "" && changeTag == 0){
			//showMessageBox("Please create a DV record  first.", imgMessage.INFO);
			proceed = false;
		} else if($F("txtDVPref") == "" && $F("txtDVNo") == "" && changeTag == 1){
			//showMessageBox("Please save this new record first.", imgMessage.INFO);
			proceed = false;
		} else if($F("txtDVPref") != "" && $F("txtDVNo") != "" && changeTag == 1){
			//showMessageBox("Please save or clear your changes first.", imgMessage.INFO);
			proceed = false;
		}
		
		if(!proceed){
			showConfirmBox4("Confirmation", "Do you want to save the changes you have made?", "Yes", "No", "Cancel", 
								function(){
									objGIACS002.exitPage = goToDVAcctgEntries;
									proceedSaveDV();
								}, 
								function(){}, "", "");
		} else {
			goToDVAcctgEntries();
		}
	});
	
	$("btnCancelDV").observe("click", function(){
		if(objGIACS002.cancelDV == "Y"){
			if(disbVoucherInfo.checkUserPerIssCdAcctg == 0){
				showMessageBox("User is not allowed to cancel DV for this branch.", "E");
				return false;
			}
			
			if(checkIfOfppr() == "TRUE"){
				verifyOfpprTrans();
			} else {
				//cancelDV();
				showConfirmBox("Cancel DV", "Do you want to cancel this DV?", "Yes", "No", cancelDV, "", "");
			}
		}
	});
	
	$("btnSave").observe("click", function(){
		proceedSaveDV();
	});
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	observeCancelForm("btnCancel", 
			function() {
				objGIACS002.exitPage = exitPage;
				proceedSaveDV();
			}, 
			function() {
				if(objACGlobal.callingForm == "GIACS054"){
					//showBatchCheckPrinting(); // replaced by codes below : shan 09.26.2014
					$("checkBatchPrintingMainDiv").show();
					$("GIACS002Div").hide();
					$("mainNav").hide();
					objGIACS002.fromGIACS054 = false;
					objACGlobal.callingForm = null;
					objGIACS002.prevModule = null;
				}else if(objACGlobal.callingForm == "GIACS230"){
					showGIACS230("N");				
					$("acExit").show();
				} else if(objACGlobal.previousModule == "GIACS070" || objGIACS002.prevModule == "GIACS070"){	//added by shan 08.27.2013
					objACGlobal.previousModule = null;
					objGIACS002.prevModule = null;
					showGIACS070Page();
				} else if(objACGlobal.callingForm == "GIACS237" || objACGlobal.fromDvStatInq == 'Y'){ //added condition by robert 11.27.2013
					objAC.fromMenu = 'N';
					objACGlobal.callingForm = "";
					showGIACS237();	
				}else{
					if(objAC.fromMenu == "menuOtherBranchGenerateDV" || objAC.fromMenu == "menuOtherBranchManualDV") {
						objGIACS002.dvTAg = null;
						showOtherBranchRequests();
					} else if(objAC.fromMenu == "menuOtherBranchCancelDV" || objAC.fromMenu == "menuCancelDV"){
						showDisbursementVoucherPage("Y", "getGIACS002DisbVoucherList");
					} else if(objAC.fromMenu == "menuDVListing" || objAC.fromMenu == "menuOtherBranchDVListing"){
						showDisbursementVoucherPage('N', 'getGIACS002DisbVoucherList'); 
					} else if(objGIACS002.fromGIACS054){	// shan 09.26.2014
						objGIACS002.fromGIACS054 = false;
						objACGlobal.callingForm = null;
						objGIACS002.prevModule = null;
						$("checkBatchPrintingMainDiv").show();
						$("GIACS002Div").hide();
						$("mainNav").hide();
					}else {
						clearObjectValues(objACGlobal); //added by robert 01.29.2015 
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}
				}
			}
	);

	
	/** The RELOAD FORM link in the inner div */
	observeReloadForm("reloadFormDV", function(){
		/*if(objGIACS002.dvTag == "M"){
			//showDisbursementVoucherPage('N', 'showGenerateDisbursementVoucher');
			showDisbursementVoucherPage('N', "getDisbVoucherInfo");
		} /*else {
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
		}*/
		
		if(objGIACS002.cancelDV == "Y"){
			showDisbursementVoucherPage('Y', "getDisbVoucherInfo");
		} else {
			//if($F("hidGaccTranId") != ""){
			if(objACGlobal.gaccTranId != ""){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");  //replaced 'Y' to objGIACS002.cancelDV - Halley 11.27.13
			} else { 
				showDisbursementVoucherPage('N', "showGenerateDisbursementVoucher");
			}
		}
	});
	
	function forceData(){
		$('txtDocumentCd').value = 'CSR';
		$('txtBranchCd').value = 'CE';
		$('selLineCd').innerHTML = '<option selected="selected" value="AV">AV</option>';
		$('selDocYear').innerHTML = '<option selected="selected" value="2013">2013</option>';
		$('selDocMonth').innerHTML = '<option selected="selected" value="5">5</option>';
		$('txtDocSeqNo').value = '3';
	}
	
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializeFields();
	executeTriggers();
	executeWhenButtonPressedGIDV();
	if(objACGlobal.queryOnly != "Y"){
		initializeChangeTagBehavior(proceedSaveDV);
		initializeChangeAttribute();
	}
	
	
	if((objACGlobal.gaccTranId == "" || objACGlobal.gaccTranId == null) && $F("hidGaccTranId") == "" && $F("txtDVNo") == "" && $F("txtDVPref") == ""){
		//executeWhenButtonPressedGIDV();
		executeWhenNewRecordInstanceGIDV();
		executeKeyCreRecGIDV();
		//executeWhenCreateRecordGIDV();
		enableInputField("txtParticulars");
		$("txtParticulars").addClassName("required");
		enableInputField("txtDVRefNo");
		//enableInputField("txtPrintDate");
		//enableInputField("txtPrintTime");
		if(objGIACS002.dvTag == "M" || disbVoucherInfo.dvTag == "*"){
			enableInputField("txtPrintDate");
			enableInputField("txtPrintTime");
		}
	}

	$("acExit").stopObserving();
	$("acExit").observe("click", function() {		
		$("btnCancel").click();
	});
	

	if (objACGlobal.previousModule == "GIACS230"){	//shan 02.07.2014
		$("acExit").show();
		var divArray = ['disbursementVoucherSubDiv1','disbursementVoucherSubDiv2'];
		disableChkFields(divArray, true);
		$("txtParticulars").readOnly = true;
		$("txtParticulars").removeClassName("required");
	}
	setDVItems(); //added by stevne 09.09.2014
	$("dvDetailsDiv").hide();
</script>