<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="enterJournalEntriesMainDiv" name="enterJournalEntriesMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<c:if test="${'Y' eq isCancelJV}">
	   			<label>Cancel JV</label>
	   		</c:if>
	   		<c:if test="${'Y' ne isCancelJV}">
	   			<label>Enter Journal Entries</label>
	   		</c:if>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		   		<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div id="enterJournalEntriesDiv" name="enterJournalEntriesDiv">
		<div class="sectionDiv">
			<div id=journalEntriesHeader style="margin: 10px;">  <!-- changeTagAttr="true" --> 
				<table width="80%" align="center">
					<tr>
						<td class="rightAligned">Company</td>
						<td class="leftAligned">
<!-- 							<input type="text" style="width: 320px;" id="txtCompany" name="txtCompany" value="" readonly="readonly"/> -->
							<span class="required lovSpan" style="width: 320px;">
								<input type="hidden" id="txtTranId" name="txtTranId"/>
								<input type="hidden" id="txtFundCd" name="txtfundCd"/>
								<input type="text" id="txtCompany" name="txtCompany" style="width: 295px; float: left; border: none; height: 13px; margin: 0;" class="required disableDelKey" readonly="readonly" tabIndex = "101"></input>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundCd" name="searchFundCd" alt="Go" style="float: right;" tabIndex = "102"/>
							</span>
						</td>
						<td class="rightAligned">Branch</td>
						<td class="leftAligned">
<!-- 							<input type="text" style="width: 210px;" id="txtBranch" name="txtBranch" value=""/> -->
							<span class="required lovSpan" style="width: 210px;">
								<input type="hidden" id="txtBranchCd" name="txtBranchCd"/>
								<input type="text" id="txtBranch" name="txtBranch" style="width: 185px; float: left; border: none; height: 13px; margin: 0;" class="required disableDelKey" readonly="readonly" tabIndex = "103"></input>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;" tabIndex = "104"/>
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id=journalEntriesBody style="margin: 10px;"> <!-- changeTagAttr="true" -->
				<table cellspacing="0" width="100%" align="center">
					<tr>
						<td colspan="2" style="padding-left: 22%;">
							<input type="radio" name="byCash" id="rdoCash" title="Cash" style="float: left; margin-right: 6px" tabIndex = "105"/>
							<label for="rdoCash" style="float: left; height: 20px; padding-top: 4px; margin-right: 25px;">Cash</label>
							<input type="radio" name="byCash" id="rdoNonCash" title="Non Cash" style="float: left; margin-right: 6px;" tabIndex = "106"/>
							<label for="rdoNonCash" style="float: left; height: 20px; padding-top: 4px;">Non Cash</label>
						</td>
						<td colspan="2" valign="bottom" style="padding-left: 12%;">
							<input type="checkbox" title="SAP Include Tag" id="sapIncTag" name="sapIncTag" style="margin-right: 6px; float: left;" value="" tabIndex = "124"/>
							<label id="sapIncTagLabel" title="SAP Include Tag" for="sapIncTag">SAP Include Tag</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Tran No.</td>
						<td class="leftAligned">
							<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtTranYy" name="txtTranYr" maxlength="4" style="width: 79px;" tabIndex = "107"/>
							<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtTranMm" name=txtTranMm maxlength="2" style="width: 69px;" tabIndex = "108"/>
							<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranSeqNo" name="txtTranSeqNo" maxlength="5" style= "width: 78px;" tabIndex = "109"/>
						</td>
						<td colspan="2" valign="top" style="padding-left: 12%;">
							<input type="checkbox" title="Adjusting Entries" id="aeTag" name="aeTag" style="margin-right: 6px; float: left;" value="" tabIndex = "125"/>
							<label id="aeTagLabel" title="Adjusting Entries" for="aeTag">Adjusting Entries</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Tran Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 255px;" class="withIconDiv required">
								<input type="text" id="txtTranDate" name="txtTranDate" class="withIcon required disableDelKey" readonly="readonly" style="width: 231px;" tabIndex = "110"/>
								<img id="hrefTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Tran Date" tabIndex = "111"/>
							</div>
						</td>
						<td class="rightAligned">Create By</td>
						<td class="leftAligned"><input type="text" id="txtCreateBy" name="txtCreateBy" style="width: 249px;" readonly="readonly" tabIndex = "126"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Tran Class</td>
						<td class="leftAligned">
							<input type="text" id="txtTranClass" name="txtTranClass" style="width: 40px;" readonly="readonly" tabIndex = "112"/>
							<input type="text" id="txtMeanTranClass" name="txtMeanTranClass" style="width: 198px;" readonly="readonly" tabIndex = "113"/>
						</td>
						<td class="rightAligned">Tran Status</td>
						<td class="leftAligned">
							<input type="text" id="txtTranFlag" name="txtTranFlag" style="width: 40px;" readonly="readonly" tabIndex = "127"/>
							<input type="text" id="txtMeanTranFlag" name="txtMeanTranFlag" style="width: 198px;" readonly="readonly" tabIndex = "128"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">JV Tran Type/Mo/Yr</td>
						<td class="leftAligned">
							<div style="float: left; padding-top: 2px;">
								<span class="required lovSpan" style="width: 140px; height: 21px;">
									<input type="hidden" id="txtJVTranType" name="txtJVTranType"/>
									<input type="text" id="txtDspTranDesc" name="txtDspTranDesc" style="width: 115px; float: left; border: none; height: 14px; margin: 0;" class="required disableDelKey" tabIndex = "114"></input>								
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranType" name="searchTranType" alt="Go" style="float: right;" tabIndex = "115"/>
								</span>
							</div>
							<div style="padding-left: 4px; padding-top: 2px; float: left;">
								<select class="required" id="txtJVTranMm" name="txtJVTranMm" style="width: 55px; height: 23px;" tabIndex = "116"></select>
							</div>
							<div style="padding-left: 4px; float: left;">
								<input class="required integerNoNegativeUnformattedNoComma" class="rightAligned" type="text" id="txtJVTranYy" name="txtJVTranYy" maxlength="4" style="width: 44px;" tabIndex = "117"/>
							</div>
						</td>
						<td class="rightAligned">Tran Class No.</td>
						<td class="leftAligned">
							<input class="rightAligned" type="text" id="txtTranClassNo" name="txtTranClassNo" style="width: 249px;" readonly="readonly" tabIndex = "129"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reference JV No.</td>
						<td class="leftAligned">
							<input type="text" id="txtRefJVNo" name="txtRefJVNo" maxlength="15" style="width: 249px;" tabIndex = "118"/>
						</td>
						<td class="rightAligned">JV No.</td>
						<td class="leftAligned">
							<input type="text" id="txtJVPrefSuff" name="txtJVPrefSuff" style="width: 40px;" readonly="readonly" tabIndex = "130"/>
							<input class="rightAligned" type="text" id="txtJVNo" name="txtJVNo" style="width: 198px;" readonly="readonly" tabIndex = "131"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Particulars</td>
						<td class="leftAligned" colspan="3" style="padding-top:3px;">
							<div class="required" id="particularsDiv" style="border: 1px solid gray; height: 20px; width: 91.4%;">
								<textarea class="required disableDelKey" id="txtParticulars" name="txtParticulars" style="width: 94%; border: none; height: 13px;" maxlength="2000" tabIndex = "119"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" textField="txtParticulars" charLimit="2000" tabIndex = "120"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3" style="padding-top:5px; padding-bottom: 3px;">
							<div id="remarksDiv" style="border: 1px solid gray; height: 20px; width: 91.4%;">
								<textarea class="disableDelKey" id="txtRemarks" name="txtRemarks" style="width: 94%; border: none; height: 13px;" maxlength="2000" tabIndex = "121"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" textField="txtRemarks" charLimit="2000" tabIndex = "122"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned">
							<input type="text" id="txtUserId" name="txtUserId" style="width: 249px;" readonly="readonly" tabIndex = "123"/>
						</td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned">
							<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 249px;" readonly="readonly" tabIndex = "132"/>
						</td>
					</tr>
					<tr>
						<td colspan="4" style="padding-left: 64.3%;">
							<input type="checkbox" id="uploadTag" name="uploadTag" title="Upload Tag" style="margin-right: 6px; float: left; display: none;" value="" disabled="disabled" tabIndex = "133"/>
							<label id="uploadTagLabel" for="uploadTag"  title="Upload Tag" style="display: none;">Upload Tag</label>
						</td>
					</tr>
				</table>
			</div>
			<div id="journalEntriesButtonDiv" align="center" style="float: left; width: 100%; margin-top: 20px; margin-bottom: 15px;">
				<input type="button" class="button" id="btnDetails" name="btnDetails" value="Details" style="width: 90px;" tabIndex = "134"/>
				<input type="button" class="button" id="btnAccountingEntries" name="btnAccountingEntries" value="Accounting Entries" style="width: 120px;" tabIndex = "135"/>
				<input type="button" class="button" id="btnOrInfo" name="btnOrInfo" value="OP Info" style="width: 90px;" tabIndex = "136"/>
				<input type="button" class="button" id="btnDVInfo" name="btnDVInfo" value="DV Info" style="width: 90px;" tabIndex = "137"/>
				<input type="button" class="button" id="btnJVPrint" name="btnJVPrint" value="JV Print" style="width: 90px;" tabIndex = "138"/>
			</div>
		</div>
	</div>
	<div class="buttonsDiv" id="journalEntriesMainButtonDiv" align="center">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 90px;" tabIndex = "139"/>
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 90px;" tabIndex = "140"/>
	</div>
</div>
<script>
	setModuleId("GIACS003");
	initializeAll();
	initializeAccordion();
	initializeChangeTagBehavior(saveJournalEntries);
	var isCancelJV = '${isCancelJV}';
	var docTitle = isCancelJV == 'Y'? 'Cancel JV':'Enter Journal Entries';
	setDocumentTitle(docTitle);
	var objJournalEntries = JSON.parse('${objJournalEntries}');
	var journalEntriesRow = objJournalEntries.row[0];
	var month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",""];
	var fundCd = '${fundCd}';
	var branchCd = '${branchCd}';
	var tranId = '${tranId}';
	if(objACGlobal.giacs003PageStatus != "added"){
		objACGlobal.giacs003PageStatus = '${pageStatus}';
	}
	var checkORInfo = '${checkORInfo}';
	var checkOP = '${checkOP}';
	var uploadImplSw = '${uploadImplSw}';
	var sapIntegrationSw = nvl('${sapIntegrationSw}','N');
	var allowPrintForOpenJV = '${allowPrintForOpenJV}';
	var pFundCd = '${pFundCd}';
	var pBranchCd = '${pBranchCd}';
	var oldTranDate = null;
	objACGlobal.hidObjGIACS003 = {};
	$("btnJVPrint").value = isCancelJV == 'Y'? "Cancel JV":"JV Print";
	changeTag = 0;
	validate = null;

	addMonth(month);
	populateJournalEntries(objJournalEntries);
	function addMonth(monArray) {
		for ( var i = 0; i < monArray.length; i++) {
			 var opt = document.createElement('option');
             opt.text = monArray[i];
             opt.value = i+1;
             if(opt.value == 13){
            	 opt.value = "";
             }
			 $("txtJVTranMm").options.add(opt);
		}
	}
	function populateJournalEntries(obj) {
		try {
			if (obj.row[0] != undefined) {
				var row = obj.row[0];
				$("txtTranId").value 		= row.tranId == null ? "" : row.tranId;
				$("txtFundCd").value 		= row.fundCd == null ? "" : row.fundCd;
				$("txtBranchCd").value 		= row.branchCd == null ? "" : row.branchCd;
				$("txtCompany").value 		= row.fundCd == null ? "" : unescapeHTML2(row.fundCd +" - "+ row.fundDesc);
				$("txtBranch").value 		= row.branchCd == null ? "" : unescapeHTML2(row.branchCd +" - "+ row.branchName);
				$("txtTranYy").value 		= row == null ? "" : nvl(row.tranYy,"");
				$("txtTranMm").value 		= row == null ? "" : lpad(row.tranMm,2,0);
				$("txtTranSeqNo").value 	= row == null ? "" : lpad(row.tranSeqNo,5,0);
				$("txtTranDate").value		= row == null ? "" : row.strTrandate;
				$("txtTranClass").value		= row == null ? "" : nvl(row.tranClass,"");
				$("txtMeanTranClass").value	= row == null ? "" : unescapeHTML2(nvl(row.meanTranClass,""));
				$("txtJVTranType").value	= row == null ? "" : unescapeHTML2(nvl(row.jvTranType,""));
				$("txtDspTranDesc").value	= row == null ? "" : unescapeHTML2(nvl(row.jvTranDesc,""));
				$("txtJVTranMm").value		= row == null ? "" : row.jvTranMm;
				$("txtJVTranYy").value		= row == null ? "" : nvl(row.jvTranYy,"");
				$("txtRefJVNo").value		= row == null ? "" : unescapeHTML2(nvl(row.refJvNo,""));
				$("txtParticulars").value	= row == null ? "" : unescapeHTML2(nvl(row.particulars,""));
				$("txtRemarks").value		= row == null ? "" : unescapeHTML2(nvl(row.remarks,""));
				$("txtUserId").value		= row == null ? "" : nvl(row.userId,"");
				$("sapIncTag").checked		= row.sapIncTag == 'Y' ? true : false;
				$("aeTag").checked			= row.aeTag == 'Y' ? true : false;
				$("uploadTag").checked		= row.uploadTag == 'Y' ? true : false;
				if (row.jvTranTag == 'C') {
					$("rdoCash").checked = true;
				} else {
					$("rdoNonCash").checked = true;
					$("txtJVTranMm").removeClassName("required");
					if ($F("txtJVTranMm") != "") {
						$("txtJVTranYy").addClassName("required");
					} else {
						$("txtJVTranYy").removeClassName("required");
					}
				}
				$("txtCreateBy").value		= row == null ? "" : nvl(row.createBy,"");
				$("txtTranFlag").value		= row == null ? "" : nvl(row.tranFlag,"");
				$("txtMeanTranFlag").value	= row == null ? "" : unescapeHTML2(nvl(row.meanTranFlag,""));
				$("txtTranClassNo").value	= row == null ? "" : lpad(row.tranClassNo,5,0);
				$("txtJVPrefSuff").value	= row == null ? "" : nvl(row.jvPrefSuff,"");
				$("txtJVNo").value			= row == null ? "" : lpad(row.jvNo,6,0);
				$("txtLastUpdate").value	= row == null ? "" : row.strJournalLastUpdate;
			}
			
		} catch (e) {
			showErrorMessage("populateJournalEntries",e);
		}
	}
	function disableGIACS003Fields(reqDivArray){
		try{
			if (reqDivArray!= null){
				disableButton("btnSave");
				for ( var i = 0; i < reqDivArray.length; i++) {
					$$("div#"+reqDivArray[i]+" input[type='text'].required, div#"+reqDivArray[i]+" textarea.required, div#"+reqDivArray[i]+" select.required").each(function (a) {
						$(a).removeClassName("required");
						$(a).readOnly="true";
					});
					$$("div#"+reqDivArray[i]+" input[type='text'], div#"+reqDivArray[i]+" textarea").each(function (b) {
						$(b).readOnly="true";
					});
					$$("div#"+reqDivArray[i]+" input[type='checkbox'], div#"+reqDivArray[i]+" input[type='radio'], div#"+reqDivArray[i]+" select").each(function (b) {
						$(b).disable();
					});
					$$("div").each(function (c) {
						$(c).removeClassName("required");
					});
					$$("span").each(function (c) {
						$(c).removeClassName("required");
					});
					$$("div#"+reqDivArray[i]+" img").each(function (img) {
						var src = img.src;
						var id = img.id;
						if(nvl(img, null) != null){
							if(src.include("searchIcon.png")){
								disableSearch(img);
							}else if(src.include("but_calendar.gif")){
								disableDate(img); 
							}else if(src.include("edit.png")){
								makeTextEditorReadOnly(id,$(id).getAttribute("textField"),$(id).getAttribute("charLimit"));
							}
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("disableModuleFields", e);
		}
	}
	function makeTextEditorReadOnly(btnId, textField, charLimit){
		if(nvl($(btnId), null) != null && nvl($(btnId), null) != null){
			$(btnId).stopObserving("click");
			$(btnId).observe("click", function(){
				showEditor(textField, charLimit, "true");
			});
		}
	}
	function formatFields() {
		try {
			if (objACGlobal.workflowColVal != null) {
				objACGlobal.hidObjGIACS003.pFundCd = pFundCd;
				objACGlobal.hidObjGIACS003.pBranchCd = pBranchCd;
			}
			if (objACGlobal.callingForm == "GIACS230") {
				$("acExit").show();
				$("btnOrInfo").value = "OR Info";
			} else if (objACGlobal.callingForm == "GIACS051" || objACGlobal.callingForm == "GIACS603" || objACGlobal.callingForm == "GIACS604" || objACGlobal.callingForm == "GIACS607" || objACGlobal.callingForm == "GIACS608" || objACGlobal.callingForm2 == "GIACS609") {
				disableDate("hrefTranDate");
			} else{
				if (checkOP == "Y") {
					objACGlobal.opReqTag = "Y";
					objACGlobal.opTag = "S";
					objACGlobal.orTag = null;
				} else {
					objACGlobal.opReqTag = "N";
					objACGlobal.opTag = null;
					objACGlobal.orTag = "S";
					$("btnOrInfo").value = "OR Info";
				}
			}
			if (uploadImplSw == "Y") {
				$("uploadTagLabel").show();
				$("uploadTag").show();
			}
			if (sapIntegrationSw == "Y" || objACGlobal.giacs003PageStatus =="add") {
				$("sapIncTagLabel").show();
				$("sapIncTag").show();
				$("sapIncTag").disabled = false;
			}else if (sapIntegrationSw == "N" && objACGlobal.giacs003PageStatus =="added") {
				$("sapIncTagLabel").show();
				$("sapIncTag").show();
				$("sapIncTag").disabled = true;
			}else {
				$("sapIncTagLabel").hide();
				$("sapIncTag").hide();
			}
			if (objACGlobal.giacs003PageStatus =="edit" || objACGlobal.giacs003PageStatus =="added") {
				$("txtTranYy").readOnly = true;
				$("txtTranMm").readOnly = true;
				$("txtTranSeqNo").readOnly = true;
				var reqDivArray = ["journalEntriesHeader","journalEntriesBody"];
				if (journalEntriesRow != undefined && (journalEntriesRow.tranClass == 'JV' && isCancelJV != 'Y')){
					if (journalEntriesRow != undefined && (journalEntriesRow.tranFlag == "C" || journalEntriesRow.tranFlag == "P" || journalEntriesRow.tranFlag == "D")) {
						disableGIACS003Fields(reqDivArray);
					}else {
						if (journalEntriesRow != undefined && journalEntriesRow.tranFlag == "O") {
							disableSearch("searchFundCd");
							disableSearch("searchBranch");
							$("txtCompany").readOnly=true;
							$("txtBranch").readOnly=true;
							$("txtTranClassNo").readOnly=true;
							$("txtJVPrefSuff").readOnly=true;
							$("txtJVNo").readOnly=true;
						}
					}
				}else{
					disableGIACS003Fields(reqDivArray);
				}
				
				if (journalEntriesRow != undefined && (journalEntriesRow.tranClass != "COL" && journalEntriesRow.tranClass != "JV" && journalEntriesRow.tranClass != "DV")) {
					disableButton("btnDetails");
				}else {
					enableButton("btnDetails");
				}
				
				if (journalEntriesRow != undefined && journalEntriesRow.tranClass == "COL") {
					if (checkORInfo == "Y") {
						enableButton("btnOrInfo");
					} else {
						disableButton("btnOrInfo");
					}
					disableButton("btnDVInfo");
				}else if(journalEntriesRow != undefined && journalEntriesRow.tranClass == "DV") {
					disableButton("btnOrInfo");
					enableButton("btnDVInfo");
				}else if (journalEntriesRow != undefined && journalEntriesRow.tranClass == "JV") {
					disableButton("btnOrInfo");
					disableButton("btnDVInfo");
					if((journalEntriesRow != undefined && (journalEntriesRow.tranSeqNo != null || journalEntriesRow.tranSeqNo != "") && (journalEntriesRow.tranFlag == 'C' || journalEntriesRow.tranFlag == 'P'))){
						if (objACGlobal.callingForm == "GIACS230" && isCancelJV != "Y") {
							disableButton("btnJVPrint");
						}
					}
				}else{
					disableButton("btnOrInfo");
					disableButton("btnDVInfo");
				}
				
				if (isCancelJV != "Y") {
					if (allowPrintForOpenJV == "N") {
						if (journalEntriesRow != undefined && journalEntriesRow.tranFlag == "O") {
							disableButton("btnJVPrint");
						} else {
							enableButton("btnJVPrint");
						}
					} else {
						enableButton("btnJVPrint");
					}
				}
			}else{
				$("txtCompany").readOnly=false;
				$("txtBranch").readOnly=true;
				disableSearch("searchBranch");
				$$("div#journalEntriesButtonDiv input[type='button']").each(function (b) {
					disableButton(b);
				});
			}
		} catch (e) {
			showErrorMessage("formatFields",e);
		}
	}
	
	function setJournalEntries() {
		var obj 				= new Object();
		obj.fundCd 				= $F("txtFundCd");
		obj.tranId 				= $F("txtTranId");
		obj.branchCd 			= $F("txtBranchCd");
		obj.tranYy 				= $F("txtTranYy");
		obj.tranMm 				= $F("txtTranMm");
		obj.tranSeqNo 			= $F("txtTranSeqNo");
		obj.tranDate 			= $F("txtTranDate");
		obj.tranFlag 			= $F("txtTranFlag");
		
		if ($("rdoCash").checked) {
			obj.jvTranTag = "C";
		} else {
			obj.jvTranTag = "NC";
		}
		obj.tranClass 			= $F("txtTranClass");
		obj.tranClassNo 		= $F("txtTranClassNo");
		obj.jvPrefSuff 			= $F("txtJVPrefSuff");
		obj.jvNo 				= $F("txtJVNo");
		obj.particulars 		= $F("txtParticulars");
		obj.userId 				= $F("txtUserId");
		obj.journalLastUpdate 	= $F("txtLastUpdate");
		obj.remarks 			= $F("txtRemarks");
		obj.jvTranType 			= $F("txtJVTranType");
		obj.jvTranMm 			= $F("txtJVTranMm");
		obj.jvTranYy 			= $F("txtJVTranYy");
		obj.refJvNo 			= $F("txtRefJVNo");
		obj.createBy			= $F("txtCreateBy");
		obj.aeTag 				= $("aeTag").checked ? "Y" : "N";
		obj.sapIncTag 			= $("sapIncTag").checked ? "Y" : "N";
		obj.uploadTag 			= $("uploadTag").checked ? "Y" : "N";
		return obj;
	}
	
	function saveJournalEntries() {
		try {
			validate = null;
			if(validateLOVFields() && checkAllRequiredFieldsInDiv("enterJournalEntriesDiv") && validateTranDate()){
				//added changeTag by reymon 05062013
				if(changeTag == 0){
					showMessageBox(objCommonMessage.NO_CHANGES, "I");
				}else{
					if(checkAcctRecordStatus($F("txtTranId"), "GIACS003")){ //marco - SR-5715 - 11.03.2016
						var objParameters = new Object();
						var giacAcctransArray = [];
						giacAcctransArray.push(setJournalEntries());
						objParameters.setGiacAcctrans = giacAcctransArray;
						new Ajax.Request(contextPath+"/GIACJournalEntryController?action=setGiacAcctrans",{
							method: "POST",
							asynchronous: false,
							evalScripts: true,
							parameters:{
								params: JSON.stringify(objParameters)
							},
							onCreate: function(){
								showNotice("Saving Enter Journal Entries, please wait...");
							},
							onComplete: function(response){
								hideNotice();
								changeTag = 0;
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){
									var obj = eval(response.responseText);
									if(validate == null){
										if (objACGlobal.callingForm2 != "GIACS609") { //Deo: GIACS609 conversion
											showJournalListing("showJournalEntries","getJournalEntries","GIACS003",obj[0].fundCd,obj[0].branchCd,obj[0].tranId,null,objACGlobal.giacs003PageStatus);
										}
									}
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								}	
							}
						});
					}
				}
			}else{
				validate = "N";	
			}
		} catch(e){
			showErrorMessage("saveJournalEntries", e);
		}
	}
	
	function notAllowedKey(keyCode) {
		if(keyCode==32 || keyCode==8 || keyCode==46 || (keyCode>=48 && keyCode<=90) || (keyCode>=96 && keyCode<=111) || (keyCode>=186 && keyCode<=222)){
			return true;
		}
		return false;
	}
	//commented out by Steven 04.26.2013: moved to accounting-lov.js
	/*function showGIACS003CompanyLOV(findText2,moduleId){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS003CompanyLOV",
				searchString: findText2
			},
			title: "Valid Values for Fund",
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
			            	   width: '319px'
			               }
			              ],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				$("txtFundCd").value = unescapeHTML2(row.fundCd);
				$("txtCompany").value = unescapeHTML2(row.fundCd)+" - "+unescapeHTML2(row.fundDesc);
				$("txtBranchCd").clear();
				$("txtBranch").clear();
				$("txtBranch").focus();
				$("txtBranch").readOnly = false;
				enableSearch("searchBranch");
				changeTag = 1;
			},
	  		onCancel: function(){
  				$("txtCompany").focus();
	  		}
		});
	} */
	
	// commented out by Kris 04.11.2013: moved to accounting-lov.js
	/* function showGIACS003BranchLOV(moduleId, fundCd, findText2){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS003BranchLOV",
				fundCd: fundCd,
				moduleId: moduleId,
				searchString: findText2
			},
			title: "Valid Values for Branch",
			width: 455,
			height: 388,
			columnModel : [
			               {
			            	   id : "branchCd",
			            	   title: "Code",
			            	   width: '50px'
			               },
			               {
			            	   id : "fundDesc",
			            	   title: "Fund",
			            	   width: '200px'
			               },
			               {
			            	   id: "branchName",
			            	   title: "Branch",
			            	   width: '200px'
			               }
			              ],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtBranch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);
				if($F("txtJVTranType") != ""){
					enableButton("btnSave");
				}
				changeTag = 1;
			},
	  		onCancel: function(){
  				$("txtBranch").focus();
	  		}
		});
	} */

	function showJVTranTypeLOV(jvTranTag,findText2){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getJVTranTypeLOV",
				jvTranTag: jvTranTag,
				searchString: findText2
			},
			title: "Valid Values for JV tran type",
			width: 400,
			height: 388,
			columnModel : [
			               {
			            	   id : "jvTranCd",
			            	   title: "Code",
			            	   width: '80px'
			               },
			               {
			            	   id : "jvTranDesc",
			            	   title: "Description",
			            	   width: '320px'
			               }
			              ],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				$("txtJVTranType").value = unescapeHTML2(row.jvTranCd);
				$("txtDspTranDesc").value = unescapeHTML2(row.jvTranDesc);
				changeTag = 1;
			},
	  		onCancel: function(){
  				$("txtDspTranDesc").focus();
	  		}
		});
	}
	function validateCash() {
		try{
			if($("rdoCash").checked){
				if ($F("txtJVTranMm") == "") {
					var mm = dateFormat(new Date,'m');
					$("txtJVTranMm").value = mm;
				}
				if ($F("txtJVTranYy").trim() == "") {
					var yy = dateFormat(new Date,'yyyy');
					$("txtJVTranYy").value = yy;
				}
			}
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=validateCash",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					jvTranTag: $("rdoCash").checked ? 'C':'NC'
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						$("txtJVTranType").value = obj.row[0].jvTranCd;
						$("txtDspTranDesc").value = obj.row[0].jvTranDesc;
					}	
				}
			});
		} catch(e){
			showErrorMessage("validateCash", e);
		}
	}
	
	function validateTranDate() {
		try{
			var result = true;
			var closedTag = "";
			var allowTranClosedMm = "";
			var fmMonth = "";
			var year = "";
			var month = "";
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=validateTranDate",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					fundCd: $F("txtFundCd"),
					branchCd: $F("txtBranchCd"),
					tranDate: $F("txtTranDate")
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var array = [];
						var str = response.responseText;
						array = str.split(",");
						closedTag = array[0];
						allowTranClosedMm = array[1];
						fmMonth =  array[2];
						year =  array[3];
						month =  array[4];
					}	
				}
			});
			if (objACGlobal.giacs003PageStatus == "add" && $F("txtTranDate")!="") {
				if (closedTag == "T" && allowTranClosedMm == "N") {
					showMessageBox("You are no longer allowed to create a transaction for "
							+fmMonth+" "
							+year+". This transaction month is temporarily closed.","I");
					$("txtTranDate").value = dateFormat(new Date(),"mm-dd-yyyy");
					result = false;
				} else if (closedTag == "Y" && allowTranClosedMm == "N") {
					showMessageBox("You are no longer allowed to create a transaction for "
							+fmMonth+" "
							+year+". This transaction month is already closed.","I");
					$("txtTranDate").value = dateFormat(new Date(),"mm-dd-yyyy");
					result = false;
				}
			}
			if (oldTranDate != null &&  oldTranDate != $("txtTranDate").value) {
				oldTranDate = $("txtTranDate").value;
				var tranDateArray = $("txtTranDate").value.split("-");
				$("txtTranYy").value = tranDateArray[2];
	 			$("txtTranMm").value = tranDateArray[0];
			}

			return result;
		} catch(e){
			showErrorMessage("validateTranDate", e);
		}
	}
	
	function reloadPage() {
		if (isCancelJV == 'Y'){
			showJournalListing("showJournalEntries","getCancelJV","GIACS003",fundCd,branchCd,tranId,null);
		}else{
			showJournalListing("showJournalEntries","getJournalEntries","GIACS003",fundCd,branchCd,tranId,null,objACGlobal.giacs003PageStatus); 
		}
		changeTag = 0;
	}
	
	function addCheckbox(){
		var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td style='padding-right: 25px;'>Type of report</td><td><input type='radio' id='rdoSlCode' name='byCode' checked='checked' style='float: left; margin-top: 1px;'/><label for='rdoSlCode'>PER_SL_CODE</label></td></tr><tr><td></td><td><input type='radio' id='rdoGlAcctId' name='byCode' style='float: left; margin-top: 1px;'/><label for='rdoGlAcctId'>PER_GL_ACCT_ID</label></td></tr></table>"; 
		
		$("printDialogFormDiv2").update(htmlCode); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "250px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
// 		$$("div#printDialogFormDiv input[type='radio'], div#printDialogFormDiv label").each(function (a) { //to hide the excel and pdf radio button
// 			$(a).hide();
// 		});
			
	}
	
	function printReport() {
		try {
			//marco - 05.17.2013 - attached report
			var content = contextPath+"/GeneralLedgerPrintController?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
						+"&fileType=PDF&reportTitle=JOURNAL VOUCHER"
						+"&tranId="+tranId+"&branchCd="+branchCd
						+"&tranClass="+$F("txtTranClass");	//added tranClass for ucpb config doc ...kenneth L. 07.15.2013
			//added condition for reports reymmon 10092013 
			if ($("rdoSlCode").checked){
				content += "&reportId=GIAGR02A";
			}else if ($("rdoGlAcctId").checked){
				content +=  "&reportId=GIAGR03A";
			}
			//end 10092013
			printGenericReport(content, "JOURNAL VOUCHER");
			//showMessageBox("The report is not yet available.","I");
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function printJV() {
		try{
			if (journalEntriesRow.tranFlag == "C" || journalEntriesRow.tranFlag == "P" ) {
				objACGlobal.hidObjGIACS003.gaccTranId = journalEntriesRow.tranId;
				objACGlobal.hidObjGIACS003.giopGaccTranId = journalEntriesRow.tranId;
				objACGlobal.hidObjGIACS003.tranClass = journalEntriesRow.tranClass;
				objACGlobal.hidObjGIACS003.giopGaccFundCd = journalEntriesRow.fundCd;
				objACGlobal.hidObjGIACS003.giopGaccBranchCd = journalEntriesRow.branchCd;
				showGenericPrintDialog("JV Printing",printReport, addCheckbox, false); 
			} else if (journalEntriesRow.tranFlag == "O") {
				var obj = null;
				var objAmt = null;
				new Ajax.Request(contextPath+"/GIACJournalEntryController?action=printOpt",{
					method: "POST",
					asynchronous: false,
					evalScripts: true,
					parameters:{
						tranId: journalEntriesRow.tranId
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							obj = JSON.parse(response.responseText);
							objAmt = obj.row[0];
						}	
					}
				});
				if (objAmt.debitAmt == objAmt.creditAmt && objAmt.debitAmt != null && objAmt.creditAmt != null) {
					showConfirmBox("Confirmation", "Transaction is still open, would you like to continue printing the JV?", "Yes", "No",
									function() {
										objACGlobal.hidObjGIACS003.gaccTranId = journalEntriesRow.tranId;
										objACGlobal.hidObjGIACS003.giopGaccTranId = journalEntriesRow.tranId;
										objACGlobal.hidObjGIACS003.tranClass = journalEntriesRow.tranClass;
										objACGlobal.hidObjGIACS003.giopGaccFundCd = journalEntriesRow.fundCd;
										objACGlobal.hidObjGIACS003.giopGaccBranchCd = journalEntriesRow.branchCd;
										showGenericPrintDialog("JV Printing",printReport, addCheckbox, false); 
									}, "");
				} else if (objAmt.debitAmt != objAmt.creditAmt) {
					showMessageBox("The debit and credit entries are not yet balanced. JV Printing is not allowed.","I");
	
				}else if ((objAmt.debitAmt == null && objAmt.creditAmt == null) || (objAmt.debitAmt == 0 && objAmt.creditAmt == 0)) {
					showMessageBox("There are no accounting entries yet for this JV transaction. Kindly enter corresponding entries before printing the JV.","E");
				}
			}else {
				showMessageBox("This facility is for closed and posted transactions only.","E");
			}
		} catch(e){
			showErrorMessage("printJV", e);
		}
	}
	//move by steven to accounting.js
/* 	function checkUserPerIssCdAcctg(branchCd,moduleId) {
		try{
			var result = "0";
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=checkUserPerIssCdAcctg",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					branchCd: branchCd,
					moduleId: moduleId
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						result=response.responseText;
					}	
				}
			});
			return result;
		} catch(e){
			showErrorMessage("checkUserPerIssCdAcctg", e);
		}
	} */
	
	function checkCommPayts(tranId) {
		try{
			var result = false;
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=checkCommPayts",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					tranId: tranId
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var msg=response.responseText;
						if (msg != "0") {
							showMessageBox(msg,"I");
							result = true;
						}
					}	
				}
			});
			return result;
		} catch(e){
			showErrorMessage("checkCommPayts", e);
		}
	}
	
	function saveCancelOpt() {
		try{
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=saveCancelOpt",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					tranId: journalEntriesRow.tranId,
					fundCd: journalEntriesRow.fundCd,
					branchCd: journalEntriesRow.branchCd,
					jvNo: journalEntriesRow.jvNo
				},
				onCreate:function(){
					showNotice("Cancelling Enter Journal Entries, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj =  eval(response.responseText);
						showJournalListing("showJournalEntries","getCancelJV","GIACS003",obj[0].fundCd,obj[0].branchCd,obj[0].tranId,null);
						showMessageBox(obj[0].msg,"I");
					}	
				}
			});
		} catch(e){
			showErrorMessage("saveCancelOpt", e);
		}
	}
	function cancelOpt() {
		try{
			if (journalEntriesRow.tranFlag == "P") {
				showMessageBox("Posted transaction cannot be canceled.","E");
			} else {
				if (journalEntriesRow.tranClass == "JV" && journalEntriesRow.tranFlag == "D") {
					showMessageBox("JV is already cancelled.","I");
				} else if (journalEntriesRow.tranClass == "JV") {
					if (checkUserPerIssCdAcctg(journalEntriesRow.branchCd, "GIACS003") == "0") {
						showMessageBox("You are not allowed to cancel for this branch","I");
						return;
					}
					if (checkCommPayts(journalEntriesRow.tranId)) {
						return;
					}
					
					//added by John Daniel SR-5182
					var message = validateJVCancel(journalEntriesRow.tranId);
					if (message != "Y"){ 
						showMessageBox(message, "I");
						return;
					}
					
					showConfirmBox("Confirmation", "Proceed with JV cancellation?", "Ok", "Cancel",
							function() {
								saveCancelOpt();
							}, "");
	
				}else{
					showMessageBox("Only JV can be cancelled.","E");
				}
			}
		} catch(e){
			showErrorMessage("cancelOpt", e);
		}
	}
	
	//added by John Daniel SR-5128; validate JV if it can be canceled
	function validateJVCancel(id){
		var result = '';
		new Ajax.Request(contextPath+"/GIACJournalEntryController", {
			method: "POST",
			asynchronous: false,
			evalScripts: true,
			parameters:{
				action : "validateJVCancel",
				tranId : id
			},
			onComplete: function(response){
				console.log(response.responseText);
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					result = response.responseText;
				}	
			}
		});
		return result;
	}
	
	function updateGlobalValues(tranSource, callingForm,calledForm) {
		objACGlobal.branchCd = $F("txtBranchCd");
		objACGlobal.fundCd = $F("txtFundCd");
		objACGlobal.gaccTranId = journalEntriesRow.tranId;
		objACGlobal.tranSource = tranSource;
		objACGlobal.callingForm = callingForm;
// 		objACGlobal.documentName = "";
		objACGlobal.calledForm	= calledForm;
		objACGlobal.previousModule = "GIACS003";
		objACGlobal.hidObjGIACS003.isCancelJV = isCancelJV;
		objACGlobal.tranFlagState = journalEntriesRow.tranFlag;
		objAC.tranFlagState = journalEntriesRow.tranFlag;
		objACGlobal.hidObjGIACS003.journalEntriesRow = journalEntriesRow;
	}
	function showDetails() {
		try {
			var callModule = "DETAILS";
			var tranSource = "";
			if (journalEntriesRow.tranClass == "COL") {
				tranSource = "OP";
			} else if (journalEntriesRow.tranClass == "DV") {
				tranSource = "DV";
				new Ajax.Request(contextPath+"/GIACJournalEntryController?action=getDetailModule",{
					method: "POST",
					asynchronous: false,
					evalScripts: true,
					parameters:{
						tranId : journalEntriesRow.tranId
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							callModule =  response.responseText;
						}	
					}
				});
			}
			else {
				tranSource = "JV";
			}
			if (callModule == "DISB_REQ") {
				//to call GIACS021
			} else if(callModule == "DETAILS") { 
				if(changeTag == 1){
					showMessageBox("Please save the record first.");
					return false;
				} 	
				updateGlobalValues(tranSource,callModule,"");
				showORInfo();
			}
		} catch (e) {
			showErrorMessage("showDetails", e);
		}
	}
	function showAccountingEntries() {
		try {
			var tranSource = "JV";
			var callingForm = "ACCT_ENTRIES";
			var calledForm = "GIACS004";
			if(changeTag == 1){
				showMessageBox("Please save the record first.");
				return false;
			} 	
			updateGlobalValues(tranSource,callingForm,calledForm);
			showORInfoWithAcctEntries();
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
		} catch (e) {
			showErrorMessage("showAccountingEntries", e);
		}
	}
	function showOrInfo() {
		try {
			var tranSource = "OP";
			var callingForm = "ACCT_ENTRIES";
			var calledForm = "GIACS001";
			if(changeTag == 1){
				showMessageBox("Please save the record first.");
				return false;
			} 	
			updateGlobalValues(tranSource,callingForm,calledForm);
			editORInformation();
		} catch (e) {
			showErrorMessage("showOrInfo", e);
		}
	}
	function showDVInfo() {
		try {
			var tranSource = "DV";
			var callingForm = "ACCT_ENTRIES";
			var calledForm = null;
			var obj = null;
			if(changeTag == 1){
				showMessageBox("Please save the record first.");
				return false;
			} 	
			updateGlobalValues(tranSource,callingForm,calledForm);
			
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=showDVInfo",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					tranId: journalEntriesRow.tranId
				},
				onComplete: function(response){
					objACGlobal.dvTag = null;
					objACGlobal.calledForm = null;
					objACGlobal.cancelReq = null;
					objACGlobal.paytRequestMenu = null;
					objACGlobal.cancelDv = null;
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						obj =  eval(response.responseText);
						objACGlobal.dvTag = obj[0].dvTag;
						objACGlobal.refId = obj[0].refId;
						objACGlobal.calledForm = obj[0].calledForm;
						objACGlobal.cancelReq = obj[0].cancelReq;
						objACGlobal.paytRequestMenu = obj[0].paytRequestMenu;
						objACGlobal.cancelDv = obj[0].cancelDv;
						if (objACGlobal.calledForm == 'GIACS002') {
							//to call GIACS002
						} else if(objACGlobal.calledForm == 'GIACS016') {
							showDisbursementMainPage("", objACGlobal.refId,objACGlobal.branchCd);
						}
						
					}	
				}
			});
		} catch (e) {
			showErrorMessage("orDetails", e);
		}
	}
	function validateLOVFields() {
		if($F("txtFundCd") == ""){
			customShowMessageBox("Please enter a valid Company Name or Company Code.", "E","txtCompany");
			return false;
	  	}else if($F("txtBranchCd") == ""){
			customShowMessageBox("Please enter a valid Branch Name or Branch Code.", "E","txtBranch");
			return false;
		}else if($F("txtJVTranType") == ""){
			customShowMessageBox("Please enter a valid JV Tran Type Description or JV Tran Type Code.", "E","txtDspTranDesc");
			return false;
		}
		return true;
	}
	try {
		$("btnCancel").observe("click", function(){
			objACGlobal.giacs003PageStatus = null;
			validate = "Y";
			if(changeTag == 1){
				showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							saveJournalEntries();
							if(validate == "N"){
								return false;
							}else{
								if (isCancelJV == 'Y') {
									showJournalListing("showJournalListing","getCancelJVList","GIACS003",null,null,null,null,null,$F("txtTranFlag")); // andrew - 08282015 - SR 17425
								}else if(objACGlobal.callingForm2 == "GIACS607"){ //shan 06.09.2015 : conversion of GIACS607
									/*$("otherModuleDiv").innerHTML = "";
									$("otherModuleDiv").hide();
									$("processPremAndCommDiv").show();

									setModuleId("GIACS607");
														
									$("acExit").stopObserving();
									$("acExit").observe("click", function() {
										objACGlobal.callingForm = "";
										$("process").innerHTML = "";
										$("process").hide();
													
										setModuleId("GIACS601");
										$("convertFileMainDiv").show();
										$("acExit").show();
										$("acExit").stopObserving();
										$("acExit").observe("click", function() {
											goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
										});
									});*/
									showGiacs607();
								} else if(objACGlobal.callingForm2 == "GIACS603"){ //john : conversion of GIACS603
									/* nieko Accounting Uploading, replace code in calling GIACS603
									**
									$("otherModuleDiv").innerHTML = "";
									$("otherModuleDiv").hide();
									$("processDataPerPolicy").show();

									setModuleId("GIACS603");
														
									$("acExit").stopObserving();
									$("acExit").observe("click", function() {
										objACGlobal.callingForm = "";
										$("process").innerHTML = "";
										$("process").hide();
													
										setModuleId("GIACS601");
										$("convertFileMainDiv").show();
										$("acExit").show();
										$("acExit").stopObserving();
										$("acExit").observe("click", function() {
											goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
										});
									});*/
									showGiacs603();
									//nieko end
								} else if(objACGlobal.callingForm2 == "GIACS604"){ //nieko Accounting Uploading
									showGiacs604();
								} else if(objACGlobal.callingForm2 == "GIACS608"){ //nieko Accounting Uploading
									showGiacs608();
								} else if (objACGlobal.callingForm2 == "GIACS609") { //Deo: GIACS609 conversion
									showGiacs609();
								}else{
									if(objAC.fromMenu == "journalEntry"){
										goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
									} else {
										showJournalListing("showJournalListing","getJournalEntryList","GIACS003",null,null,null,null,null,$F("txtTranFlag")); // andrew - 08282015 - SR 17425
									}
								}
								return true;
							}
						}, function(){
							if (isCancelJV == 'Y') {
								showJournalListing("showJournalListing","getCancelJVList","GIACS003",null,null,null,null,null,$F("txtTranFlag")); // andrew - 08282015 - SR 17425
							}else if(objACGlobal.callingForm2 == "GIACS607"){ //shan 06.09.2015 : conversion of GIACS607
								/*$("otherModuleDiv").innerHTML = "";
								$("otherModuleDiv").hide();
								$("processPremAndCommDiv").show();

								setModuleId("GIACS607");
														
								$("acExit").stopObserving();
								$("acExit").observe("click", function() {
									objACGlobal.callingForm = "";
									$("process").innerHTML = "";
									$("process").hide();
									
									setModuleId("GIACS601");
									$("convertFileMainDiv").show();
									$("acExit").show();
									$("acExit").stopObserving();
									$("acExit").observe("click", function() {
										goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
									});
								});*/
								showGiacs607();
							} else if(objACGlobal.callingForm2 == "GIACS603"){ //john : conversion of GIACS603
								/* nieko Accounting Uploading, replace code in calling GIACS603
								**
								$("otherModuleDiv").innerHTML = "";
								$("otherModuleDiv").hide();
								$("processDataPerPolicy").show();

								setModuleId("GIACS603");
														
								$("acExit").stopObserving();
								$("acExit").observe("click", function() {
									objACGlobal.callingForm = "";
									$("process").innerHTML = "";
									$("process").hide();
									
									setModuleId("GIACS601");
									$("convertFileMainDiv").show();
									$("acExit").show();
									$("acExit").stopObserving();
									$("acExit").observe("click", function() {
										goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
									});
								});*/
								showGiacs603();
								//nieko end
							} else if(objACGlobal.callingForm2 == "GIACS604"){ //nieko Accounting Uploading
									showGiacs604();
							} else if(objACGlobal.callingForm2 == "GIACS608"){ //nieko Accounting Uploading
								showGiacs608();
							} else if (objACGlobal.callingForm2 == "GIACS609") { //Deo: GIACS609 conversion
								showGiacs609();
							} else{
								if(objAC.fromMenu == "journalEntry"){
									goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
								} else {
									showJournalListing("showJournalListing","getJournalEntryList","GIACS003",null,null,null,null,null,$F("txtTranFlag")); // andrew - 08282015 - SR 17425
								}
							}
							changeTag = 0;
						}, "");
				}else{
					if (isCancelJV == 'Y') {
						showJournalListing("showJournalListing","getCancelJVList","GIACS003",null,null,null,null,null,$F("txtTranFlag")); // andrew - 08282015 - SR 17425
					} else if (objACGlobal.callingForm == "GIACS051") { // pol 5.30.2013
						try{
							
							function funcNo(){
								delete objGIACS051;
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							}
							
							showConfirmBox("", "Process finished. Copy another journal voucher?", "Yes", "No", showGIACS051, funcNo, "");
						} catch (e){
							showErrorMessage("Error :", e);
						}
					} else if(objACGlobal.callingForm == "GIACS230"){ //shan 02.07.2014
						showGIACS230("N");				
						$("acExit").show();
					} else if(objACGlobal.callingForm2 == "GIACS607"){ //shan 06.09.2015 : conversion of GIACS607
						/*$("otherModuleDiv").innerHTML = "";
						$("otherModuleDiv").hide();
						$("processPremAndCommDiv").show();

						setModuleId("GIACS607");
									
						$("acExit").stopObserving();
						$("acExit").observe("click", function() {
							objACGlobal.callingForm = "";
							$("process").innerHTML = "";
							$("process").hide();
											
							setModuleId("GIACS601");
							$("convertFileMainDiv").show();
							$("acExit").show();
							$("acExit").stopObserving();
							$("acExit").observe("click", function() {
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							});
						});*/
					} else if(objACGlobal.callingForm2 == "GIACS603"){ //john conversion of GIACS603
						/* nieko Accounting Uploading, replace code in calling GIACS603
						**
						$("otherModuleDiv").innerHTML = "";
						$("otherModuleDiv").hide();
						$("processDataPerPolicy").show();

						setModuleId("GIACS603");
									
						$("acExit").stopObserving();
						$("acExit").observe("click", function() {
							objACGlobal.callingForm = "";
							$("process").innerHTML = "";
							$("process").hide();
											
							setModuleId("GIACS601");
							$("convertFileMainDiv").show();
							$("acExit").show();
							$("acExit").stopObserving();
							$("acExit").observe("click", function() {
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							});
						});*/
						showGiacs603();
						//nieko end
					} else if(objACGlobal.callingForm2 == "GIACS604"){ //nieko Accounting Uploading
						showGiacs604();
					} else if(objACGlobal.callingForm2 == "GIACS608"){ //nieko Accounting Uploading
						showGiacs608();
					} else if (objACGlobal.callingForm2 == "GIACS609") { //Deo: GIACS609 conversion
						showGiacs609();
					} else{
						if(objAC.fromMenu == "journalEntry"){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						} else {
							showJournalListing("showJournalListing","getJournalEntryList","GIACS003",null,null,null,null,null,$F("txtTranFlag")); // andrew - 08282015 - SR 17425
						}
					}
				}
		});
		
		function showGiacs609() { //Deo: GIACS609 conversion
			try {
				new Ajax.Request(contextPath+"/GIACUploadingController",{
					parameters: {
						action : "showGiacs609",
						sourceCd: objGIACS609.sourceCd,
						fileNo: objGIACS609.fileNo
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice("Loading, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							objACGlobal.callingForm2 = "";
							$("mainNav").hide();
							$("mainContents").update(response.responseText);
						}
					}
				});
			} catch (e) {
				showErrorMessage("showGiacs609", e);
			}
		}
		
		$("acExit").stopObserving();
		$("acExit").observe("click", function() {
			$("btnCancel").click();
		});
		$("editParticulars").observe("click",function() {
			showOverlayEditor("txtParticulars", 2000, $("txtParticulars").hasAttribute("readonly"));
		});
		$("editRemarks").observe("click",function() {
			showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
		});
		$("hrefTranDate").observe("click", function(){
			scwShow($('txtTranDate'),this, null);
		});
		$("searchFundCd").observe("click", function(){
			var findText2 = $F("txtCompany").trim() == "" ? "%" : $F("txtCompany");
			showGIACS003CompanyLOV(findText2,'GIACS003');
		});
		$("searchBranch").observe("click", function(){
			var findText2 = $F("txtBranch").trim() == "" ? "%" : $F("txtBranch");
			showGIACS003BranchLOV('GIACS003',$F("txtFundCd"),findText2);
		});
		$("searchTranType").observe("click", function(){
			var jvTranTag = "";
			var findText2 = $F("txtDspTranDesc").trim() == "" ? "%" : $F("txtDspTranDesc");
			if ($("rdoCash").checked) {
				jvTranTag = "C";
			} else {
				jvTranTag = "NC";
			}
			//showJVTranTypeLOV(jvTranTag,findText2);
			showJVTranTypeLOV(jvTranTag,'%'); // robert 10.21.2013 copy beahaviour of CS as per Maam Juday
		});
		$("btnSave").observe("click", function(){
			/* Commented out by reymon 05062013
			** move to saveJournalEntries
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			}else{
				saveJournalEntries();
			}*/
			saveJournalEntries();
		});
		$("reloadForm").observe("click",function(){
			if(changeTag == 1){
				showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
						reloadPage, "");
			}else{
				reloadPage();
			}
			
		});
		$("txtCompany").observe("keyup", function(e) {
			if(this.readOnly)return;
			if (notAllowedKey(e.keyCode)) {
				$("txtFundCd").clear();
				$("txtBranchCd").clear();
				$("txtBranch").clear();
				$("txtBranch").readOnly = true;
				disableSearch("searchBranch");
			}
			if (e.keyCode == 13) {
				var findText2 = $F("txtCompany").trim() == "" ? "%" : $F("txtCompany");
				var cond = validateTextFieldLOV("/AccountingLOVController?action=getGIACS003CompanyLOV",findText2,"Searching Fund, please wait...");
				if (cond == 2) {
					showGIACS003CompanyLOV(findText2,'GIACS003');
				} else if(cond == 0) {
					this.clear();
					showMessageBox("There's no record found.", imgMessage.INFO);
				}else{
					this.value = cond.rows[0].fundCd+" - "+unescapeHTML2(cond.rows[0].fundDesc);
					$("txtFundCd").value = cond.rows[0].fundCd;
					$("txtBranchCd").clear();
					$("txtBranch").clear();
					$("txtBranch").focus();
					$("txtBranch").readOnly = false;
					changeTag=1;
					enableSearch("searchBranch");
				}
			}
		});
		$("txtBranch").observe("keyup", function(e) {
			if(this.readOnly)return;
			if (notAllowedKey(e.keyCode)) {
				$("txtBranchCd").clear();
			}
			if (e.keyCode == 13) {
				var findText2 = $F("txtBranch").trim() == "" ? "%" : $F("txtBranch");
				var cond = validateTextFieldLOV("/AccountingLOVController?action=getGIACS003BranchLOV&moduleId=GIACS003&fundCd"+$F("txtFundCd"),findText2,"Searching Branch, please wait...");
				if (cond == 2) {
					showGIACS003BranchLOV('GIACS003',$F("txtFundCd"),findText2);
				} else if(cond == 0) {
					this.clear();
					showMessageBox("There's no record found.", imgMessage.INFO);
				}else{
					this.value = cond.rows[0].branchCd+" - "+unescapeHTML2(cond.rows[0].branchName);
					$("txtBranchCd").value = cond.rows[0].branchCd;
					changeTag=1;
				}
			}
		});
		$("txtDspTranDesc").observe("keyup", function(e) {
			if(this.readOnly)return;
			if (notAllowedKey(e.keyCode)) {
				$("txtJVTranType").clear();
			}
			if (e.keyCode == 13) {
				var jvTranTag = $("rdoCash").checked ? "C" : "NC";
				var findText2 = $F("txtDspTranDesc").trim() == "" ? "%" : $F("txtDspTranDesc");
				var cond = validateTextFieldLOV("/AccountingLOVController?action=getJVTranTypeLOV&jvTranTag="+jvTranTag,findText2,"Searching JV Tran Type, please wait...");
				if (cond == 2) {
					showJVTranTypeLOV(jvTranTag,findText2);
				} else if(cond == 0) {
					this.clear();
					showMessageBox("There's no record found.", imgMessage.INFO);
				}else{
					this.value = unescapeHTML2(cond.rows[0].jvTranDesc);
					$("txtJVTranType").value = cond.rows[0].jvTranCd;
					changeTag=1;
				}
			}
		});
		$("rdoCash").observe("change", function() {
			validateCash();
			$("txtJVTranMm").addClassName("required");
			$("txtJVTranYy").addClassName("required");
		});
		$("rdoNonCash").observe("change", function() {
			validateCash();
			$("txtJVTranMm").removeClassName("required");
			$("txtJVTranYy").removeClassName("required");
		});
		$("txtJVTranMm").observe("change", function() {
			if(this.value == ""){
				$("txtJVTranYy").clear();
			}
			if ($("rdoNonCash").checked) {
				if (this.value != "") {
					$("txtJVTranYy").addClassName("required");
				} else {
					$("txtJVTranYy").removeClassName("required");
				}
			}
		});
		$("txtJVTranYy").observe("change", function() {
			if ($("rdoNonCash").checked) {
				if ($F("txtJVTranMm") != "") {
					this.addClassName("required");
				} else {
					this.removeClassName("required");
				}
			}
		});
		$("txtTranSeqNo").observe("change", function() {
			this.value = lpad(this.value,5,0);
		});
		$("txtTranMm").observe("change", function() {
			this.value = lpad(this.value,2,0);
		});
		$("hrefTranDate").observe("click", function(){
			oldTranDate = $("txtTranDate").value;
		});
		$("txtTranDate").observe("blur", function(){
			if (oldTranDate != null &&  oldTranDate != this.value) {
				oldTranDate = this.value;
				var tranDateArray = this.value.split("-");
				$("txtTranYy").value = tranDateArray[2];
	 			$("txtTranMm").value = tranDateArray[0];
				changeTag=1;
			}
		});
		$("txtJVTranYy").observe("change", function(){
			if (parseInt(this.value) < 1000) {
				showMessageBox("Please enter a valid JV Tran Yr.","I");
				this.clear();
			}
		});
		$$("div#journalEntriesHeader, div#journalEntriesBody").each(function (a) {
			$(a).observe("change", function(){
				changeTag=1;
			});
		});
		$("btnJVPrint").observe("click", function(){
			if (isCancelJV == "Y") {
				cancelOpt();
			} else {
				printJV();
			}
		});	
		$$("div#enterJournalEntriesDiv input[type='text'].disableDelKey, div#enterJournalEntriesDiv textarea.disableDelKey").each(function (a) {
			$(a).observe("keydown",function(e){
				if($(a).readOnly && e.keyCode === 46){
					$(a).blur();
				}
			});
		});
		$("btnDetails").observe("click",function(){
			showDetails();
		});
		$("btnAccountingEntries").observe("click",function(){
			showAccountingEntries();
		});
		$("btnOrInfo").observe("click",function(){
			showOrInfo();
		});
		$("btnDVInfo").observe("click",function(){
			showDVInfo();
		});
	} catch (e) {
		showErrorMessage("enterJournalEntries.jsp observe",e);
	}
	formatFields();
	
	//nieko Accounting Uploading
	function showGiacs604(){
		objACGlobal.callingForm2 = "";
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			parameters: {
				action : "showGiacs604",
				sourceCd: objGIACS604.sourceCd,
				fileNo:   objGIACS604.fileNo
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainNav").hide();
					$("mainContents").update(response.responseText);
				}
			}
		});
	}
	
	function showGiacs603(){
		objACGlobal.callingForm2 = "";
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			parameters: {
				action : "showGiacs603",
				sourceCd: objGIACS603.sourceCd,
				fileNo:   objGIACS603.fileNo
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainNav").hide();
					$("mainContents").update(response.responseText);
				}
			}
		});
	}
	
	function showGiacs607(){
		objACGlobal.callingForm2 = "";
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			parameters: {
				action : "showGIACS607",
				sourceCd: objGIACS607.sourceCd,
				fileNo:   objGIACS607.fileNo
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainNav").hide();
					$("mainContents").update(response.responseText);
				}
			}
		});
	}
	
	function showGiacs608(){
		objACGlobal.callingForm2 = "";
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			parameters: {
				action : "showGIACS608",
				sourceCd: objGIACS608.sourceCd,
				fileNo:   objGIACS608.fileNo
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainNav").hide();
					$("mainContents").update(response.responseText);
				}
			}
		});
	}
	//nieko end
</script>
