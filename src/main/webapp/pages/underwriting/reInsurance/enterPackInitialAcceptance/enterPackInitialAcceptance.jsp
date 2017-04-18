<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packPackCreationDiv">	
	<c:if test="${mode eq '0'}">
		<div id="parCreationMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="packBasicInformation">Basic Information</a></li>
					<li><a id="packParCreationExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	</c:if>
	
	<div id="enterPackInitAcceptanceDiv" name="enterPackInitAcceptanceDiv">
		<c:choose>
			<c:when test="${mode eq 1 }">
				<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
			</c:when>
			<c:otherwise>
				<jsp:include page="/pages/underwriting/reInsurance/enterPackInitialAcceptance/subpages/riPackParCreation.jsp"></jsp:include>
			</c:otherwise>
		</c:choose>
		<div id="initAcceptanceInfoDiv" name="initAcceptanceInfoDiv" class="sectionDiv" 
					style="margin-top: 1px; padding-bottom: 10px;" changeTagAttr="true">
			<table width="90%" style="margin-top: 10px; margin-left: 10px;">
				<tr>
					<td class="rightAligned" width="20%">Acceptance No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="packAcceptNo" name="packAcceptNo" style="width: 95%;" disabled="disabled" value="" />
					</td>
					<td class="rightAligned" width="20%">Ref. Accept. No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="refAcceptNo" name="refAcceptNo" style="width: 95%;" value="" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">Accepted By </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="acceptBy" name="acceptBy" style="width: 95%;" />
					</td>
					<td class="rightAligned" width="20%">Accept Date </td>
					<td class="leftAligned" width="30%">
						<div style="width: 97.7%; border: 1px solid gray; height: 20px; float: left; padding-bottom: 0.5px; ">
							<input type="text" id="acceptDate" name="acceptDate" value="" style="border: none; height: 12px; width: 86%;" readonly="readonly" />
							<img id="imgAcceptDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('acceptDate').focus(); scwShow($('acceptDate'),this, null);" style="margin: 0;" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%"><label id="branchText" style="float: right;">Ceding Company </label></td>
					<td class="leftAligned" width="30%">
						<div style="width: 97.7%; border: 1px solid gray; height: 20px; float: left;" class="required">
							<input type="text" id="riSName2" name="riSName2" riCd="" class="required" value="" style="border: none; height: 15px; padding-top: 0px; width: 85%;" readonly="readonly" />
							<img id="searchRiSName2" name="searchRiSName2" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
						</div>
					</td>
					<td class="rightAligned" width="20%">Reassured </td>
					<td class="leftAligned" width="30%">
						<div style="width: 97.7%; border: 1px solid gray; height: 20px; float: left;">
							<input type="text" id="riSName" name="riSName" writerCd="" value="" style="border: none; height: 15px; padding-top: 0px; width: 85%;" readonly="readonly" />
							<img id="searchRiSName" name="searchRiSName" alt="Go" style="float: right; visibility: visible;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">RI Policy No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="riPolicyNo" name="riPolicyNo" style="width: 95%;" />
					</td>
					<td class="rightAligned" width="20%">RI Binder No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="riBinderNo" name="riBinderNo" style="width: 95%;" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">RI Endt. No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="riEndtNo" name="riEndtNo" style="width: 95%;" />
					</td>
					<td class="rightAligned" width="20%">Date Offered </td>
					<td class="leftAligned" width="30%">
						<div style="width: 97.7%; border: 1px solid gray; height: 20px; float: left; padding-bottom: 0.5px; ">
							<input type="text" id="offerDate" name="offerDate" value="" style="border: none; height: 12px; padding-top: 0px; width: 86%;" readonly="readonly" />
							<img id="imgOfferDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('offerDate').focus(); scwShow($('offerDate'),this, null);" style="margin: 0;" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">Orig. TSI Amount </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="origTsiAmt" name="origTsiAmt" class="money" style="width: 95%;" />
					</td>
					<td class="rightAligned" width="20%">Orig. Premium Amount </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="origPremAmt" name="origPremAmt" class="money" style="width: 95%;" /> 
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">Remarks </td>
					<td class="leftAligned" width="80%" colspan="3">
						<div style="width: 99%; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<!-- <input type="text" tabindex="3" style="width: 95%; height: ; float: left; border: none;" id="remarks" name="remarks"  onKeyDown="limitText(this, 4000);" onKeyUp="limitText(this, 4000);" /> -->
							<textarea id="remarks" name="remarks" style="width: 95%; resize:none;" class="withIcon" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);"> </textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditRemarks" id="editRemarks" class="hover" />
						</div>
					</td>
				</tr>	
			</table>
		</div>
		
		<div id="buttonsRIParCreationDiv" class="buttonsDiv">
			<input id="btnPackageLineSubline" class="button" type="button" value="Package Line/Subline" name=""btnPackageLineSubline""/>
			<input id="btnAssuredMaintenance" class="button" type="button" value="Maintain Assured" name="btnAssuredMaintenance"/>
			<input id="btnCancel" class="button" type="button" value="Cancel" name="btnCancel"/>
			<input id="btnSave" class="button" type="button" value="Save" name="btnSave"/>
		</div>
	</div>
	<!-- hidden values -->
	<input id="automaticParAssignmentFlag" value="${automaticParAssignmentFlag }" type="hidden" />
	<input id="packParId" type="hidden" value=""/>
	<input id="mode" value="${mode }"  type="hidden"/>
	<input id="parType" value="${parType }"  type="hidden"/>
	<input type="hidden" id="riFlag" name="riFlag" value="Y" />
	<input id="assuredNo" value=""  type="hidden"/>
	<input type="hidden" name="address1" 	id="address1"/>
	<input type="hidden" name="address2" 	id="address2"/>
	<input type="hidden" name="address3" 	id="address3"/>
	<input type="hidden" name="defaultYear"	 id="defaultYear"/>
</div>

<div id="packParListingTableGridMainDiv" style="display: none;" module="parCreation">
	<div id="parListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="endtParListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<div id="assuredDiv" style="display: none;">
	
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include> <!-- temp muna galing par -->
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>
<script>
	changeTag = 0;
	objGIPIWPackLineSublineTemp = new Array();
 	objGIPIWPackLineSublineCreatePack = null;
 	hasLineSubline = 'N';
	
	function loadRiPackParCreationFields() {
		$("defaultYear").value = $("packYear").value;
		$("packBasicInformation").hide();
		creationFlag = true; 
		//$("packBasicInformation").observe("click",showPackParBasicInfo); replaced by: Nica 04.24.2013 - to call correct function for endt PAR
		$("packBasicInformation").observe("click", $F("parType") == "E"  ? showEndtPackParBasicInfo : showPackParBasicInfo);
		
		if($F("packAcceptNo") == "") {
			$("acceptBy").value = userId;
			$("acceptDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		}

	}
	
	if($F("mode") == "0"){
		loadRiPackParCreationFields();
		$("packParCreationExit").observe("click", function () {
			onCancel();
		});
		clearObjectValues(objUWGlobal);
	}else{
		//changed obj objGIPIWPolbas to objGIRIPackWInPolbas -- irwin 11.13.2012
		$("packAcceptNo").value 	= nvl(objGIRIPackWInPolbas.packAcceptNo,"");
		$("refAcceptNo").value 		= unescapeHTML2(nvl(objGIRIPackWInPolbas.refAcceptNo,""));
		//$F("globalParId") == null || $F("globalParId") == "") ? 0 : $F("globalParId");;
		$("riSName2").setAttribute("riCd", objGIRIPackWInPolbas.riCd);
		$("acceptDate").value 		= objGIRIPackWInPolbas.acceptDate == null ? dateFormat(new Date, 'mm-dd-yyyy') : (objGIRIPackWInPolbas.acceptDate);
		$("riPolicyNo").value 		= unescapeHTML2(nvl(objGIRIPackWInPolbas.riPolicyNo,""));
		$("riEndtNo").value 		= unescapeHTML2((nvl(objGIRIPackWInPolbas.riEndtNo,"")));
		$("riBinderNo").value 		= unescapeHTML2(nvl(objGIRIPackWInPolbas.riBinderNo,""));
		$("riSName").setAttribute("writerCd", objGIRIPackWInPolbas.writerCd);
		$("offerDate").value 		= objGIRIPackWInPolbas.offerDate == null ? "" : (objGIRIPackWInPolbas.offerDate);
		$("acceptBy").value 		= unescapeHTML2(nvl(objGIRIPackWInPolbas.acceptBy,""));
		$("origPremAmt").value 		= formatCurrency(objGIRIPackWInPolbas.origPremAmt);
		$("origTsiAmt").value	    = formatCurrency(objGIRIPackWInPolbas.origTsiAmt);
		$("remarks").value 			= unescapeHTML2(nvl(objGIRIPackWInPolbas.remarks,""));

		$("riSName2").value 		= unescapeHTML2(objGIRIPackWInPolbas.riSName2);
		$("riSName").value			= unescapeHTML2(objGIRIPackWInPolbas.riSName);
		
		$("btnAssuredMaintenance").hide();
		$("btnPackageLineSubline").hide();
		
	}
	
	if($F("parType") == "E"){
		$("btnPackageLineSubline").hide();
	}
	
	function onCancel(){
		 if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function() {
					preSave(); 
				},
				exit , "");
		}else{
			if($F("mode") == "1"){
				//goBackToParListing();
			}else{
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);										
			}
		}
	 }

	function exit(){
    	changeTag = 0;
    	if($F("mode") == "0"){
    		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
    	}else if($F("mode") == 1){
    		//goBackToParListing();
    	}
    }
	
	function validateInput() {
		var result = true;
		if(mode == "0") {
			if ($("linecd").selectedIndex == 0){
				result = false;
				$("linecd").focus();
				showMessageBox("Line of Business is required.", imgMessage.INFO);
			} else if ($("isscd").selectedIndex == 0){
				result = false;
				$("isscd").focus();
				showMessageBox("Issuing source is required.", imgMessage.INFO);
			} else if ($F("year")==""){
				result = false;
				$("year").focus();
				showMessageBox("Year is required.", imgMessage.INFO);
			}else if ($F("assuredNo")==""){
				result = false;
				$("assuredNo").focus();
				showMessageBox("Assured name is required.", imgMessage.INFO);
			}
		}
		
		if ($F("riSName2") == "" && $("riSName2").getAttribute("riCd") == "") {
			result = false;
			$("riSName2").focus();
			showMessageBox(document.getElementById("branchText").innerHTML + " is required. ", imgMessage.INFO);
		} 
		
		return result;
	}
	
	function preSave(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			if($F("mode") == "0"){
				if(checkAllRequiredFieldsInDiv("riPackParCreationSectionDiv")==true && checkAllRequiredFieldsInDiv("initAcceptanceInfoDiv")==true){
					if($F("parType") == "P" && hasLineSubline == "N"){
						showMessageBox("At least 1 record must be entered in the Package Line/Subline.", imgMessage.ERROR);
					}else{
						saveRiPackPar();	
					}
					
				}
			}else{
				if(checkAllRequiredFieldsInDiv("initAcceptanceInfoDiv")==true){
					saveRiPackPar();	
				}
			}	
		}
		
	}
	
	function setPackWInPolbasObj() {
		var newObj = new Object();
		
		newObj.packAcceptNo = ($F("packAcceptNo") == null || $F("packAcceptNo") == "") ? 0 : $F("packAcceptNo");
		newObj.refAcceptNo = escapeHTML2($F("refAcceptNo"));
		newObj.parId = ($F("packParId") == null || $F("packParId") == "") ? 0 : $F("packParId");;
		newObj.riCd = $("riSName2").getAttribute("riCd");
		newObj.acceptDate = $F("acceptDate");
		newObj.riPolicyNo = escapeHTML2($F("riPolicyNo"));
		newObj.riEndtNo = $F("riEndtNo");
		newObj.riBinderNo = escapeHTML2($F("riBinderNo"));
		newObj.writerCd = nvl($("riSName").getAttribute("writerCd"), "");
		newObj.offerDate = $F("offerDate");
		newObj.acceptBy = escapeHTML2($F("acceptBy"));
		newObj.origTsiAmt = unformatCurrencyValue($F("origTsiAmt"));
		newObj.origPremAmt = unformatCurrencyValue($F("origPremAmt"));
		newObj.remarks = escapeHTML2($F("remarks"));
		newObj.riSName =escapeHTML2($F("riSName"));
		newObj.riSName2 = escapeHTML2($F("riSName2"));

		return newObj;
	}
	
	function saveRiPackPar(){
		try{
			var objPackPar = {};
			
			if($F("mode") == "0"){
				objPackPar.issCd = $F("packIssCd");
				objPackPar.lineCd = $F("packLineCd");
				
				objPackPar.parYy = $F("packYear");
				objPackPar.quoteSeqNo = $F("packQuoteSeqNo");
				objPackPar.underwriter = "";
				objPackPar.assdNo = $F("assuredNo");
				objPackPar.remarks = escapeHTML2($F("packRemarks"));
				objPackPar.parType = $F("parType");
				objPackPar.packParId = ($F("packParId") == null || $F("packParId") == "") ? 0 : $F("packParId");
				objPackPar.parSeqNo = parseFloat($F("packParSeqNo") == ""? "0" : $F("packParSeqNo"));
				objPackPar.address1 = escapeHTML2($F("address1"));
				objPackPar.address2 = escapeHTML2($F("address2"));
				objPackPar.address3 = escapeHTML2($F("address3"));
				
				if($F("parType") == "P"){
					var addRows = getAddedJSONObjects(objGIPIWPackLineSublineTemp);
					var delRows = getDeletedJSONObjects(objGIPIWPackLineSublineTemp);
					objPackPar.addRows = prepareJsonAsParameter(addRows);
					objPackPar.delRows = prepareJsonAsParameter(delRows);
				}
			}else{
				objPackPar.packParId = ($F("globalPackParId") == null || $F("globalPackParId") == "") ? 0 : $F("globalPackParId");
				objPackPar.issCd = objUWParList.issCd;
				objPackPar.lineCd = objUWParList.lineCd;
			}
			objPackPar.packWInPolbas = setPackWInPolbasObj();
			
			new Ajax.Request(contextPath+"/GIPIPackPARListController?action=saveRIPackPar", {
				method: "POST",
				parameters: {
					mode:		$F("mode"),
					parType:    $F("parType"),
					automaticParAssignmentFlag : $F("automaticParAssignmentFlag"),
					parameters: JSON.stringify(objPackPar)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
						showNotice("Saving Pack PAR, please wait...");
					},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)){
						hideNotice("");
						$("uwParParametersDiv").update(response.responseText);			
						 
						if($F("mode") == "0"){
							$("packParSeqNo").value = $F("globalParSeqNo");
							$("packAcceptNo").value = $F("globalPackAcceptNo");
							$("packLineCd").disable();
							$("packYear").readOnly = true;
							$("packBasicInformation").show();
							$("packParId").value = $F("globalPackParId");
							initializePackPARBasicMenu();
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							objGIPIWPackLineSublineTemp = new Array();
							changeTag = 0;
						}else{
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, 
									function(){
										showRIPackParCreationPage($F("mode"),$F("parType"));
									}		
								);
						}
						
						
						
						//updatePackParParameters();
						
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveRiPackPar",e);
		}
	}
	
	if(( $F("mode") == "1" ? objUWParList.issCd : $F("packIssCd")) == "RI"){
		$("branchText").innerHTML = 'Ceding Company';
	}else{
		$("branchText").innerHTML = 'Branch';
	}
	
	$("searchRiSName2").observe("click", function() {
		var issCd = $F("mode") == "1" ? objUWParList.issCd : $F("packIssCd");
		if(issCd == "RI") {
			showReinsurerLOV("", "GIRIS005sname2");
		} else if(issCd == "RB") {
			getGiriWinpolbasIssourceList("GIRIS005A");
		}
	});
	
	$("searchRiSName").observe("click", function() {
		showReinsurerLOV("", "GIRIS005sname1");
	});
	
	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});
	
	$("riBinderNo").observe("keyup", function () {
		limitText(this, 20);
	});

	$("riEndtNo").observe("keyup", function () {
		limitText(this, 20);
	});

	$("riPolicyNo").observe("keyup", function () {
		limitText(this, 20);
	});

	$("refAcceptNo").observe("keyup", function () {
		limitText(this, 10);
	});
	
	observeChangeTagOnDate("imgAcceptDate", "acceptDate"); // added by: Nica 04.27.2013
	observeChangeTagOnDate("imgOfferDate", "offerDate");

	$("origTsiAmt").observe("change", function() {
		if ($F("origTsiAmt") != null && !isNaN($F("origTsiAmt").replace(/,/g, "")) && unformatCurrency("origTsiAmt") > -1){
			if (validateLength($F("origTsiAmt"), 14)){
				$("origTsiAmt").value = formatCurrency($F("origTsiAmt"));
		 	}else{
				showWaitingMessageBox("Field must be of form 99,999,999,990.99.","I", function(){
					$("origTsiAmt").select();	
				});
			} 
			
		}else{
			showWaitingMessageBox("Field must be of form 99,999,999,990.99.","I", function(){
				$("origTsiAmt").select();	
			});	
		}	
	});
	
	$("origPremAmt").observe("change", function() {
		if ($F("origPremAmt") != null && !isNaN($F("origPremAmt").replace(/,/g, "")) && unformatCurrency("origPremAmt") > -1){
			if (validateLength($F("origPremAmt"), 14)){
				$("origPremAmt").value = formatCurrency($F("origPremAmt"));
		 	}else{
				showWaitingMessageBox("Field must be of form 99,999,999,990.99.","I", function(){
					$("origPremAmt").select();	
				});
			} 
			
		}else{
			showWaitingMessageBox("Field must be of form 99,999,999,990.99.","I", function(){
				$("origPremAmt").select();	
			});	
		}	
	});
	
	$("btnSave").observe("click", function() {
		preSave();
	});
	
	$("btnAssuredMaintenance").observe("click", function(){
		showAssuredListing(); // andrew - 08.10.2011
		$("parInformationDiv").setStyle("margin: 10px;");
	});
	
	
	$("btnPackageLineSubline").observe("click", showPackLineSubline);
	
	function showPackLineSubline(){
		try {
			var lineCd = $F("packLineCd");
			var packParId = isNull(objUWGlobal.packParId) ?"0": objUWGlobal.packParId;
			if(lineCd == ""){
				showMessageBox("Please choose line of business.", imgMessage.INFO);	
			}else{
				showPackParCreationLineSubline(lineCd, packParId);
			}	
		} catch(e) {
			showErrorMessage("showPackLineSubline", e);
		}
	}

	function showPackParCreationLineSubline(lineCd, packParId){
		try{
		
			// resets the temp obj
			if(objGIPIWPackLineSublineTemp.size() > 0){
				showConfirmBox4("Line/Subline", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
					fireEvent($("btnSave"), "click");
					}, function(){
						objGIPIWPackLineSublineTemp = new Array();
					
						Modalbox.show(contextPath+"/GIPIWPackLineSublineController?action=showPackParCreationLineSubline&packParId="+packParId+"&lineCd="+lineCd, {
							title: "Package Line/Subline",
							width: 500,
							overlayClose: false,
							asynchronous:false
							
						});
					}, "");
			}else{
				objGIPIWPackLineSublineTemp = new Array();
			
				Modalbox.show(contextPath+"/GIPIWPackLineSublineController?action=showPackParCreationLineSubline&packParId="+packParId+"&lineCd="+lineCd, {
					title: "Package Line/Subline",
					width: 500,
					overlayClose: false,
					asynchronous:false
					
				});
			}
		}catch(e){
			showErrorMessage("showPackParCreationLineSubline", e);
		}	
	}
	
	/*J. Diago 10.01.2013*/
	$("btnCancel").observe("click", function(){
		onCancel();
	});
	
	observeBackSpaceOnDate("offerDate");
	observeBackSpaceOnDate("acceptDate");
	observeBackSpaceOnDate("riSName");
	observeBackSpaceOnDate("riSName2");
	initializeChangeTagBehavior(preSave);
	
	setModuleId("GIRIS005A");
	initializeAccordion();
	initializeAllMoneyFields();
	observeReloadForm("reloadForm", function() {showRIPackParCreationPage($F("mode"),$F("parType"));});
</script>