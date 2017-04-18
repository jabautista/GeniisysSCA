<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="engineeringBasicQuotationInfoMainDiv" name="engineeringBasicQuotationInfoMainDiv" style="margin-top: 1px;">
	<input type="hidden" id="quoteId" />
	<input type="hidden" id="lineCd" value="EN"/>
	<input type="hidden" id="lineName" value="ENGINEERING"/>
	<div class="sectionDiv" id="engineeringBasicQuotationInfoDiv">
		<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" style="display: none;">Package No.</td>
				<td class="leftAligned" style="display: none;"><input type="text" style="width: 250px;" id="packageNo" readOnly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Quotation No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="quotationNo" value="${quoteDtls.quoteNo}" readOnly="readonly" /></td>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" value="${quoteDtls.assdName}" id="assured" readOnly="readonly" /></td>
			</tr>
		</table>
	</div>
</div>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Additional Engineering Basic Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="toggleENBasic" name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="engineeringBasicAdditionalDiv" name="engineeringBasicAdditionalDiv" style="margin-top: 1px;" changeTagAttr="true">
	<div class="sectionDiv" id="engineeringBasicAdditionalInfo">
		<table width="60%" align="center" cellspacing="1" border="0" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned">Subline</td>
				<td colspan="3" class="leftAligned">
					<input type="hidden" id="sublineCdParam" name="sublineCdParam" value="${engParamSublineCd}" />
					<input type="text" style="width: 90px;" id="sublineCd" value="${quoteDtls.sublineCd}" readOnly="readonly" />
					<input type="text" style="width: 273px;" id="sublineName" value="${quoteDtls.sublineName}" readOnly="readonly" />
				</td>
				<td></td>
			</tr>
			<tr>
				<td class="rightAligned">Inception</td>
				<td class="leftAligned" style="width: 160px;"><input type="text" style="width: 150px;" id="inception" value="${quoteDtls.inceptDate}" readOnly="readonly" /></td>
				<td class="rightAligned">Expiry</td>
				<td class="leftAligned"><input type="text" style="width: 150px;" value="${quoteDtls.expiryDate}" id="expiry" readOnly="readonly" /></td>
			</tr>
		</table>
		<table align="center" width="65%" style="margin-top: 30px; margin-left: 67px; margin-bottom: 10px;" border="0">
			<tr>
				<td width="32%"><label class="rightAligned" id="titleLbl"  style="float: right;">TITLE</label></td>
				<td class="leftAligned" width="72%" colspan="3">
					<div style="width: 97.8%; border: 1px solid gray; height: 24px;">
						<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" maxlength="250" id="enProjectName" name="enProjectName" style="width: 93%; border: none; height: 14px;"></textarea> <!-- modified by John Daniel 04.12.2016 SR-5297 -->
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditTitle" id="editProjText" />
					</div>
				</td>
			</tr>
			<tr>
				<td width="32%"><label class="rightAligned" id="siteLbl" style="float: right;">LOCATION</label></td>
				<td class="leftAligned" width="72%" colspan="3">
					<div style="width: 97.8%; border: 1px solid gray; height: 24px;">
						<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" maxlength="250" id="enSiteLoc" name="enSiteLoc" style="width: 93%; border: none; height: 14px;"></textarea> <!-- modified by John Daniel 04.12.2016 SR-5297 -->
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditSite" id="editSiteText" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><label class="rightAligned" id="prompt1Lbl"  style="float: right;">PROMPT1</label></td>
				<td class="leftAligned" style="width: 160px;">
					<input type="text" class="integerNoNegativeUnformatted" maxLength="3" id="weekTest" style="width: 50px; display: none;" value="${itemENDtls.weeksTest}"/>
					<input type="text" class="integerNoNegativeUnformatted" id="mbiPolicyNo" maxLength="30" style="width: 150px; display: none;" value="${itemENDtls.mbiPolicyNo}" />
					<div style="width: 150px;" class="required withIconDiv" id="prompt1TxtDiv">
						<input type="text" style="width: 80px; display: none;" class=" required withIcon" id="prompt1" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${itemENDtls.constructStartDate}" />" maxLength="12" />
						<img style="float: right; margin-right: 5px" alt="Date" src="/Geniisys/images/misc/but_calendar.gif" id="prompt1DateIco" name="prompt1DateIco" onclick="scwShow($('prompt1'),this, null);" class="hover" tabindex=308/>
					</div>
				</td>
				<td class="rightAligned"><label class="rightAligned" id="prompt3Lbl"  style="float: right; width: 10px; text-align: center;">PROMPT3</label></td>
				<td class="leftAligned" style="width: 160px;">
					<div style="width: 150px; float: right; margin-right: 7px;" class="required withIconDiv" id="prompt3TxtDiv">
						<input type="text" style="width: 80px; display: none;" id="prompt3" class=" required withIcon"  value="<fmt:formatDate pattern="MM-dd-yyyy" value="${itemENDtls.constructEndDate}" />" maxLength="12" />
						<img style="float: right; margin-right: 5px" alt="Date" src="/Geniisys/images/misc/but_calendar.gif" id="prompt3DateIco" name="prompt3DateIco" onclick="scwShow($('prompt3'),this, null);" class="hover" tabindex=308/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><label class="rightAligned" id="prompt2Lbl"  style="float: right;">PROMPT2</label></td>
				<td class="leftAligned" style="width: 160px;">
					<input type="text" class="integerNoNegativeUnformatted" id="timeExcess" maxLength="3" style="width: 150px; display: none;" value="${itemENDtls.timeExcess}" />
					<div style="float: left; height: 21px; margin-right: 5px; border: 1px solid gray; width: 150px;" id="prompt2TxtDiv">
						<input type="text" style="float: left; border: none; margin-top: 0px; width: 80px;" id="prompt2"  readonly="readonly" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${itemENDtls.maintainStartDate}" />"  maxLength="12" />
						<img style="float: right; margin-right: 5px" alt="To Date" src="/Geniisys/images/misc/but_calendar.gif" id="prompt2DateIco" name="prompt2DateIco" onclick="scwShow($('prompt2'),this, null);" class="hover" tabindex=308/>
					</div>
				</td>
				<td class="rightAligned"><label class="rightAligned" id="prompt4Lbl"  style="float: right; width: 10px; text-align: center;">PROMPT4</label></td><!-- added by agazarraga 4-18-2012 -->
				<td class="leftAligned" style="width: 150px;">
					<div style="float: right; height: 21px; margin-right: 7px; border: 1px solid gray; width: 150px;" id="prompt4TxtDiv">
						<input type="text" style="float: left; border: none; margin-top: 0px; width: 80px;" id="prompt4"  readonly="readonly" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${itemENDtls.maintainEndDate}" />" maxLength="12" />
						<img style="float: right; margin-right: 5px" alt="Date" src="/Geniisys/images/misc/but_calendar.gif" id="prompt4DateIco" name="prompt4DateIco" onclick="scwShow($('prompt4'),this, null);" class="hover" tabindex=308/>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="principalInfoDiv" name="principalInfoDiv" style="display: none;">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Principal</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="togglePrincipal" name="gro" style="margin-left: 5px;">Show</label>
			</span>
		</div>
	</div>
	<div id="enPrincipalInfo" class="sectionDiv" style="display: none; "></div>
	</div>
<div id="contractorInfoDiv" name="contractorInfoDiv" style="display: none;">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Contractor</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="toggleContractor" name="gro" style="margin-left: 5px;">Show</label>
			</span>
		</div>
    </div>
	<div id="enContractorInfo" class="sectionDiv" style="display: none; "></div>
</div>		
<div class="buttonsDiv" id="addENInfoButtonsDiv">
	<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIIMM010");
	setDocumentTitle("Engineering Basic Information");
	changeTag = 0;
	lastAction = "";
	$("quoteId").value = '${quoteId}';
	$("enProjectName").innerHTML = unescapeHTML2('${itemENDtls.contractProjBussTitle}'); //added by christian 04/03/2013
	$("enSiteLoc").innerHTML = unescapeHTML2('${itemENDtls.siteLocation}'); //added by christian 04/03/2013
	
	var varsSubline = JSON.parse('${varsSubline}');
	
	function saveENInformation(){
		new Ajax.Request(contextPath + "/GIPIQuotationEngineeringController?action=saveENInformation" , {
			method: "POST",
			parameters: {
				quoteId: $F("quoteId"),
				enggBasicInfoNum: 1,
				contractProjBussTitle: $F("enProjectName"),
				siteLocation: $F("enSiteLoc"),
				constructStartDate: $F("prompt1"),
				constructEndDate: $F("prompt3"),
				maintainStartDate: $F("prompt2"),
				maintainEndDate: $F("prompt4"),
				weeksTest: $F("weekTest"),
				timeExcess: $F("timeExcess"),
				mbiPolicyNo: $F("mbiPolicyNo"),
				parameters: prepareParameters()
			},
			evalscripts: true,
			asynchronous: false,
			onCreate: showNotice("Saving information, please wait..."),
			onComplete: function (response) {
				if(checkErrorOnResponse(response)){
					$("togglePrincipal").innerHTML = "Show";
					$("enPrincipalInfo").hide();
					$("toggleContractor").innerHTML = "Show";
					$("enContractorInfo").hide();
					changeTag = 0;
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					lastAction();
					lastAction = "";
				}
			}
		});
	}

	function prepareParameters(){
		try {			
			var setAddedModifiedPrincipal		= getAddedModifiedPrincipalJSONObject();
			var delPrincipal					= getDeletedPrincipalJSONObject();
		
			// Sets the parameters
			var objParameters = new Object();
			objParameters.addModifiedPrincipal	 = prepareJsonAsParameter(setAddedModifiedPrincipal); // mark jm 04.26.2011 @UCPBGEN added prepareJsonAsParameter;
			objParameters.deletedPrincipal	     = prepareJsonAsParameter(delPrincipal); // mark jm 04.26.2011 @UCPBGEN added prepareJsonAsParameter;

			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
		}
	}
	//function getAddedModified
	function getAddedModifiedPrincipalJSONObject(){
		var tempObjArray = new Array();
		if (objGIPIQuote.objPrincipalArrayC != null || objGIPIQuote.objPrincipalArrayC != undefined){
			for(var i=0; i<objGIPIQuote.objPrincipalArrayC.length; i++) {	
				if (objGIPIQuote.objPrincipalArrayC[i].recordStatus == 0){
					tempObjArray.push(objGIPIQuote.objPrincipalArrayC[i]);
				}else if (objGIPIQuote.objPrincipalArrayC[i].recordStatus == 1){
					tempObjArray.push(objGIPIQuote.objPrincipalArrayC[i]);
				}
			}
		}
		if (objGIPIQuote.objPrincipalArrayP != null || objGIPIQuote.objPrincipalArrayP != undefined){
			for(var i=0; i<objGIPIQuote.objPrincipalArrayP.length; i++) {	
				if (objGIPIQuote.objPrincipalArrayP[i].recordStatus == 0){
					tempObjArray.push(objGIPIQuote.objPrincipalArrayP[i]);
				}else if (objGIPIQuote.objPrincipalArrayP[i].recordStatus == 1){
					tempObjArray.push(objGIPIQuote.objPrincipalArrayP[i]);
				}
			}
		}
		
		return tempObjArray;
	}

	function getDeletedPrincipalJSONObject(){
		var tempObjArray = new Array();
		
		if (objGIPIQuote.objPrincipalArrayC != null || objGIPIQuote.objPrincipalArrayC != undefined){
			for(var i=0; i<objGIPIQuote.objPrincipalArrayC.length; i++) {	
				if (objGIPIQuote.objPrincipalArrayC[i].recordStatus == -1){
					tempObjArray.push(objGIPIQuote.objPrincipalArrayC[i]);
				}
			}
		}
		
		if (objGIPIQuote.objPrincipalArrayP != null || objGIPIQuote.objPrincipalArrayP != undefined){
			for(var i=0; i<objGIPIQuote.objPrincipalArrayP.length; i++) {	
				if (objGIPIQuote.objPrincipalArrayP[i].recordStatus == -1){
					tempObjArray.push(objGIPIQuote.objPrincipalArrayP[i]);
				}
			}
		}
		
		return tempObjArray;
	}

	function showENPrincipal(pType) {
		var changeDiv = "";
		if(pType == "P") {
			changeDiv = "enPrincipalInfo";
		} else if(pType == "C") {
			changeDiv = "enContractorInfo";
		}
		try {
			new Ajax.Updater(changeDiv, contextPath+"/GIPIQuotationEngineeringController", {
				method: 		"GET",
				asynchronous: 	false,
				evalScripts: 	true,
				parameters: 	{
									action: "showPrincipalListing",
									pType: pType,
									quoteId : $F("quoteId")
								},
				onCreate: function() {
					showNotice("Getting information, please wait...");
				},
				onComplete: function() {
					hideNotice();
				}
				
			});
		} catch(e) {
			showErrorMessage("showENPrincipalModal", e);
		}
	}
// 	var inputDate1 = nvl(Date.parse($F("prompt1")),Date.parse($F("inception")));
// 	var inputDate2 = nvl(Date.parse($F("prompt2")),"");
// 	var inputDate3 = nvl(Date.parse($F("prompt3")),Date.parse($F("expiry")));
// 	var inputDate4 = nvl(Date.parse($F("prompt4")),""); //remove by steven 10.02.2013
	//modified $F("sublineCdParam") to $F("sublineCd")
	//modified hardcoded subline codes to variables //robert 9.20.2012
	function initializeItemProperties(){
		//if  ($F("sublineCd") == "CAR") {
		if  ($F("sublineCd") == nvl(varsSubline.sublineCar,'CAR')) {	
			$("titleLbl").innerHTML = "Title of Contract";
			$("siteLbl").innerHTML = "Location of Contract Site";
			$("prompt1Lbl").innerHTML = "Construction Period From";
			$("prompt2Lbl").innerHTML = "Maintenance Period From";
			$("prompt3Lbl").innerHTML = "To";
			// $("prompt4Lbl").innerHTML = "End"; commented by agazarraga 4-18-2012, to replace "End" with "To"
			$("prompt4Lbl").innerHTML = "To"; //added by agazarraga 4-18-2012
			$("prompt1Lbl").show();
			$("prompt2Lbl").show();
			$("prompt3Lbl").show();
			$("prompt4Lbl").show();
			$("prompt1").show();
			$("prompt2").show();
			$("prompt3").show();
			$("prompt4").show();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").show();
			$("prompt2TxtDiv").show();
			$("prompt3TxtDiv").show();
			$("prompt4TxtDiv").show();
			//end
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").show();
			$("contractorInfoDiv").show();
			if ($F("prompt1") == "") {
				$("prompt1").value = $F("inception");
			}
			if ($F("prompt3") == "") {
				$("prompt3").value = $F("expiry");
			}
		//}else if ($F("sublineCd") == "EAR") {  //$F("sublineCd") == "EAR" || $F("sublineCdParam") == "EER"
		}else if  ($F("sublineCd") == nvl(varsSubline.sublineEar,'EAR')) {	
			$("titleLbl").innerHTML = "Project";
			$("siteLbl").innerHTML = "Site of Erection";
			$("prompt1Lbl").innerHTML = "Weeks Testing/Commissioning";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			$("prompt1Lbl").show();
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide(); //added by steven 12.11.2013
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required'); 
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").show();
			$("principalInfoDiv").show();
			$("contractorInfoDiv").show();
		//}else if ($F("sublineCd") == "EEI") {
		}else if  ($F("sublineCd") == nvl(varsSubline.sublineEei,'ECP')) {	
			$("titleLbl").innerHTML = "Description";
			$("siteLbl").innerHTML = "The Premises";
			$("prompt1Lbl").innerHTML = "";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();
		//}else if ($F("sublineCd") == "MB") {
		}else if  ($F("sublineCd") == nvl(varsSubline.sublineMbi,'EMB')) {
			$("titleLbl").innerHTML = "Nature of Business";
			$("siteLbl").innerHTML = "Work Site";
			$("prompt1Lbl").innerHTML = "";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();
		//}else if ($F("sublineCd") == "MLOP" || $F("sublineCd") == "LOP") {
		}else if  ($F("sublineCd") == nvl(varsSubline.sublineMlop,'MLOP') || $F("sublineCd") == "LOP") {
			$("titleLbl").innerHTML = "Nature of Business";
			$("siteLbl").innerHTML = "The Premises";
			$("prompt1Lbl").innerHTML = "MBI Policy No";
			$("prompt2Lbl").innerHTML = "Time Excess";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("timeExcess").show();
			$("mbiPolicyNo").show();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();
		//}else if ($F("sublineCd") == "DOS") {
		}else if  ($F("sublineCd") == nvl(varsSubline.sublineDos,'EDS')) {
			$("titleLbl").innerHTML = "Description";
			$("siteLbl").innerHTML = "Location of Refrigeration Plant";
			$("prompt1Lbl").innerHTML = "";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();	
		//}else if ($F("sublineCd") == "BPV" || $F("sublineCd") == "ECP") {
		}else if  ($F("sublineCd") == nvl(varsSubline.sublineBpv,'EBR')) {
			$("titleLbl").innerHTML = "Description";
			$("siteLbl").innerHTML = "The Premises";
			$("prompt1Lbl").innerHTML = "";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();
		//}else if ($F("sublineCd") == "PCP") {
		}else if  ($F("sublineCd") == nvl(varsSubline.sublinePcp,'PCP')) {
			$("titleLbl").innerHTML = "Description";
			$("siteLbl").innerHTML = "Territorial Limits";
			$("prompt1Lbl").innerHTML = "";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();
		}else {
			$("titleLbl").innerHTML = "Title";
			$("siteLbl").innerHTML = "Location";
			$("prompt1Lbl").innerHTML = "";
			$("prompt2Lbl").innerHTML = "";
			$("prompt3Lbl").innerHTML = "";
			$("prompt4Lbl").innerHTML = "";
			//added by agazarraga 4-24-2012 for the datePicker 
			$("prompt1TxtDiv").hide();
			$("prompt2TxtDiv").hide();
			$("prompt3TxtDiv").hide();
			$("prompt4TxtDiv").hide();
			//added by steven 12.11.2013
			$('prompt1TxtDiv').removeClassName('required');
			$('prompt1').removeClassName('required');
			$('prompt3TxtDiv').removeClassName('required');
			$('prompt3').removeClassName('required');
			//end
			$("prompt1").hide();
			$("prompt2").hide();
			$("prompt3").hide();
			$("prompt4").hide();
			$("timeExcess").hide();
			$("mbiPolicyNo").hide();
			$("weekTest").hide();
			$("principalInfoDiv").hide();
			$("contractorInfoDiv").hide();
		}	
	}

	$("btnCancel").stopObserving("click");
	$("btnCancel").observe("click", function () {
		if(changeTag > 0) {
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							function() {
								if($F("sublineCd") == "CAR"){
									if ($F("prompt2") == "" && $F("prompt4") != ""){
										customShowMessageBox(objCommonMessage.REQUIRED, "I", "prompt2");
									} else if ($F("prompt4") == "" && $F("prompt2")!= ""){
										customShowMessageBox(objCommonMessage.REQUIRED, "I", "prompt4");
									}else if (checkAllRequiredFieldsInDiv("engineeringBasicAdditionalInfo")) {
										saveENInformation();
										createQuotationFromLineListing();
										changeTag = 0;
									}
								}else{
									if (checkAllRequiredFieldsInDiv("engineeringBasicAdditionalInfo")) {
										saveENInformation();
										createQuotationFromLineListing();
										changeTag = 0;
									}
								}
								
							}, function(){
								createQuotationFromLineListing();
								changeTag = 0;
							}, "");
		}else{
			createQuotationFromLineListing();
			changeTag = 0;
		}
		enggBasicInfoExitCtr = 0;
	});

	$("gimmExit").stopObserving("click");
	$("gimmExit").observe("click", function () {
		fireEvent($("btnCancel"), "click");
	});

	$("btnSave").observe("click",function() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES,imgMessage.INFO);
			return;
		} 
		 if ($F("sublineCd") == "CAR") {
			if ($F("prompt2") == "" && $F("prompt4") != ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "prompt2");
			} else if ($F("prompt4") == "" && $F("prompt2")!= ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "prompt4");
			}else if (checkAllRequiredFieldsInDiv("engineeringBasicAdditionalInfo")) {
				saveENInformation();
				changeTag = 0;
			}
		}else {
			if (checkAllRequiredFieldsInDiv("engineeringBasicAdditionalInfo")) {
				saveENInformation();
				changeTag = 0;
			}
		}  
	});
	
	$("prompt1").observe("focus", function(){
		if ($F("sublineCd") == "CAR") {
			if ($("prompt3").value != "" && this.value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("prompt1")),Date.parse($("prompt3").value)) == -1) {
					customShowMessageBox("Construction Period From Date must  be earlier than Construction Period To Date.","I","prompt1");
					this.clear();
				}
			}
		}
	});
	
	$("prompt3").observe("focus", function(){
		if ($F("sublineCd") == "CAR") {
			if ($("prompt1").value != ""&& this.value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("prompt1")),Date.parse($("prompt3").value)) == -1) {
					customShowMessageBox("Construction Period To Date must not be earlier than Construction Period From Date.","I","prompt3");
					this.clear();
					return;
				}else if (compareDatesIgnoreTime(Date.parse($F("prompt3")),Date.parse($("expiry").value)) == -1) {
					customShowMessageBox("Construction To Date should not be later than Expiry Date.","I","prompt3");
					this.clear();
					return;
				}
			}
			if (this.value != "" && $("prompt2").value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("prompt2")),Date.parse($("prompt3").value)) == 1) {
					customShowMessageBox("Maintenance Period From Date must not be earlier than Construction Period To Date.","I","prompt3");
					this.clear();
					return;
				}
			}
		}
	});
	
	$("prompt2").observe("focus", function(){
		if ($F("sublineCd") == "CAR") {
			if ($("prompt4").value != "" && this.value != "") {
				if(compareDatesIgnoreTime(Date.parse($F("prompt2")),Date.parse($("prompt4").value)) == -1){
					customShowMessageBox("Maintenance Period From Date must be earlier than Maintenance Period To Date.","I","prompt2");
					this.clear();
					return;
				}
			}
			if (this.value != "" && $("prompt3").value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("prompt2")),Date.parse($("prompt3").value)) == 1) {
					customShowMessageBox("Maintenance Period From Date must not be earlier than Construction Period To Date.","I","prompt2");
					this.clear();
					return;
				}
			}
		}
	});
	
	$("prompt4").observe("focus", function(){
		if ($F("sublineCd") == "CAR") {
			if ($("prompt2").value != "" && this.value != "") {
				if(compareDatesIgnoreTime(Date.parse($F("prompt2")),Date.parse($("prompt4").value)) == -1){
					customShowMessageBox("Maintenance Period From Date must be earlier than Maintenance Period To Date.","I","prompt4");
					this.clear();
					return;
				}
			}
		}
	});
	
	observeBackSpaceOnDate("prompt1");
	observeChangeTagOnDate("prompt1DateIco", "prompt1");
	
	observeBackSpaceOnDate("prompt2");
	observeChangeTagOnDate("prompt2DateIco", "prompt2");
	
	observeBackSpaceOnDate("prompt3");
	observeChangeTagOnDate("prompt3DateIco", "prompt3");
	
	observeBackSpaceOnDate("prompt4");
	observeChangeTagOnDate("prompt4DateIco", "prompt4");

	$("editProjText").observe("click", function() {
		//showEditor("enProjectName", 250);
		showOverlayEditor("enProjectName", 250);
	});

	$("editSiteText").observe("click", function() {
		//showEditor("enSiteLoc", 250);
		showOverlayEditor("enSiteLoc", 250);
	});

	$("weekTest").observe("change",function() {
		if ($F("weekTest") != "" && isNaN(parseFloat($F("weekTest")))) {
			clearFocusElementOnError("weekTest", "Invalid Weeks Testing/ Commissioning. Valid value should be from 0 to 999.");//added by agazarraga 4-18-2012
		}
		$("weekTest").value = formatNumberDigits(parseInt($F("weekTest")), 0); //added by agazarraga 4-19-2012, removes the decimal point, including digits on the right side of the decimal point
	});

	$("mbiPolicyNo").observe("change",function() {
		if ($F("mbiPolicyNo") != ""
				&& isNaN(parseFloat($F("mbiPolicyNo")))) {
			clearFocusElementOnError("weekTest",
					"Invalid value. Value should be up to 3 numbers only.");
		}
	});

	$("timeExcess").observe("change",function() {
		if ($F("timeExcess") != ""
				&& isNaN(parseFloat($F("timeExcess")))) {
			clearFocusElementOnError("timeExcess",
					"Invalid Time Excess. Valid value should be from 0 to 999.");
		}
	});

/*  	$("prompt1").observe("blur",function() {
 		if (this.value != "") {
 			if(inputDate1==null){
 				inputDate1 = Date.parse($F("inception"));
 			}
 			var inputDate = Date.parse($F("prompt1"));
 			if(inputDate3.format("mm-dd-yyyy")!=inputDate.format("mm-dd-yyyy")){
 				$("prompt1").value = inputDate.format("mm-dd-yyyy");
 				inputDate1 =  inputDate;
 				changeTag = 1;
 			}else{
 				changeTag = 0;
 			}
 		}
	});

	$("prompt2").observe("blur",function() {
		if (this.value != "") {
			if ($F("prompt2")!=""){
				var inputDate = Date.parse($F("prompt2"));
				if(inputDate2!=inputDate){
					inputDate2 =  inputDate;
					$("prompt2").value = inputDate.format("mm-dd-yyyy");
					changeTag = 1;
				}else{
					changeTag = 0;
				}
			}else{
				$("prompt2").value = inputDate2;
			}
 		}
	}); 

	$("prompt3").observe("blur",function() {
		if (this.value != "") {
			if(inputDate3==null){
				inputDate3 = Date.parse($F("expiry"));
			}
			var inputDate = Date.parse($F("prompt3"));
			if(inputDate3.format("mm-dd-yyyy")!=inputDate.format("mm-dd-yyyy")){
				$("prompt3").value = inputDate.format("mm-dd-yyyy");
				inputDate3 =  inputDate;
				changeTag = 1;
			}else{
				changeTag = 0;
			}
 		}	
	});

	$("prompt4").observe("blur",function() {
		if (this.value != "") {
			if ($F("prompt4")!=""){
				var inputDate = Date.parse($F("prompt4"));
				if(inputDate4!=inputDate){
					inputDate4 =  inputDate;
					$("prompt4").value = inputDate.format("mm-dd-yyyy");
					changeTag = 1;
				}else{
					changeTag = 0;
				}
			}else{
				$("prompt4").value = inputDate4;
			}
 		}
	});  remove by steven 10.02.2013*/
	
	//end
	$("togglePrincipal").observe("click", function() {
		if ($("togglePrincipal").innerHTML == "Show") {
			showENPrincipal("P");
			$("enPrincipalInfo").show();
			$("togglePrincipal").innerHTML = "Hide";
		} else {
			$("togglePrincipal").innerHTML = "Show";
			$("enPrincipalInfo").hide();
		}
	});

	$("toggleContractor").observe("click", function() {
		if ($("toggleContractor").innerHTML == "Show") {
			showENPrincipal("C");
			$("enContractorInfo").show();
			$("toggleContractor").innerHTML = "Hide";
		} else {
			$("toggleContractor").innerHTML = "Show";
			$("enContractorInfo").hide();
		}
	});

	$("toggleENBasic").observe("click", function() {
		if ($("toggleENBasic").innerHTML == "Show") {
			$("engineeringBasicAdditionalDiv").show();
			$("toggleENBasic").innerHTML = "Hide";
		} else {
			$("toggleENBasic").innerHTML = "Show";
			$("engineeringBasicAdditionalDiv").hide();
		}
	});

	$("hideForm").observe("click", function() {
		if ($("hideForm").innerHTML == "Show") {
			$("engineeringBasicQuotationInfoDiv").show();
			$("hideForm").innerHTML = "Hide";
		} else {
			$("hideForm").innerHTML = "Show";
			$("engineeringBasicQuotationInfoDiv").hide();
		}
	});

	$("reloadForm").observe("click",function() {
		if (changeTag > 0) {
			showConfirmBox(
					"Reload Engineering Basic Info.",
					"Reloading form will disregard all changes. Proceed?",
					"Yes", "No", showQuotationEngineeringInfo,
					"");
		} else {
			showQuotationEngineeringInfo();
		}
	});

	initializeItemProperties();
	initializeChangeTagBehavior(saveENInformation);
</script>
