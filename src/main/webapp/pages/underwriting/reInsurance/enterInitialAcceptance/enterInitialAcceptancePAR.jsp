<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parCreationMainDiv">	
	<c:if test="${mode eq '0'}">
		<div id="parCreationMenu">
			<div id="mainNav" name="mainNav">
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
					<ul>
						<li><a id="basicInformation">Basic Information</a></li>
						<li><a id="parCreationExit">Exit</a></li>
					</ul>
				</div>
			</div>
		</div>
	</c:if>
	<div id="enterInitAcceptancePARDiv" name="enterInitAcceptancePARDiv">
		<input type="hidden" id="mode" name="mode" value="${mode}" />
		<input type="button" id="btnValidateGIPIWinvoice" value="hiddenTrigger" style="display: none;"/>
		<c:choose>
			<c:when test="${mode eq '1'}">
				<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
			</c:when>
			<c:otherwise>
				<jsp:include page="/pages/underwriting/reInsurance/enterInitialAcceptance/subPages/riParCreation.jsp"></jsp:include>
			</c:otherwise>
		</c:choose>
		
		<div id="initAcceptanceInfoDiv" name="initAcceptanceInfoDiv" class="sectionDiv" 
					style="margin-top: 1px; padding-bottom: 10px;" changeTagAttr="true">
			<table width="90%" style="margin-top: 10px; margin-left: 10px;">
				<tr>
					<td class="rightAligned" width="20%">Acceptance No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="acceptNo" name="acceptNo" style="width: 95%;" disabled="disabled" value="" />
					</td>
					<td class="rightAligned" width="20%">Ref. Accept. No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="refAcceptNo" name="refAcceptNo" style="width: 95%;" value="" maxlength="10"/>,<!-- edgar 11/17/2014 : added maxlength to prevent input greater than the specified length -->
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
						<input type="text" id="riPolicyNo" name="riPolicyNo" style="width: 95%;" maxlength="27"/><!-- edgar 11/17/2014 : added maxlength to prevent input greater than the specified length -->
					</td>
					<td class="rightAligned" width="20%">RI Binder No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="riBinderNo" name="riBinderNo" style="width: 95%;" maxlength="20"/><!-- edgar 11/17/2014 : added maxlength to prevent input greater than the specified length -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">RI Endt. No. </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="riEndtNo" name="riEndtNo" style="width: 95%;" maxlength="20"/><!-- edgar 11/17/2014 : added maxlength to prevent input greater than the specified length -->
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
					<td class="rightAligned" width="20%">Offered By </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="offeredBy" name="offeredBy" style="width: 95%;" />
					</td>
					<td class="rightAligned" width="20%">Amount Offered </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="amountOffered" name="amountOffered" class="money" style="width: 95%;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">Orig. TSI Amount </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="origTsiAmt" name="origTsiAmt" class="money" style="width: 95%;"/>
					</td>
					<td class="rightAligned" width="20%">Orig. Premium Amount </td>
					<td class="leftAligned" width="30%">
						<input type="text" id="origPremAmt" name="origPremAmt" class="money" style="width: 95%;"/> 
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="20%">Remarks </td>
					<td class="leftAligned" width="80%" colspan="3">
						<div style="width: 99%; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<!-- <input type="text" tabindex="3" style="width: 95%; height: ; float: left; border: none;" id="remarks2" name="remarks2" maxlength="2000" /> --><!--replaced by textarea - christian 04/16/2013-->
							<textarea tabindex="3" onKeyDown="limitText(this, 4000);" onKeyUp="limitText(this, 4000);" style="width: 95%; height:13px; float: left; border: none;" id="remarks2" name="remarks2" maxlength="2000" ></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditRemarks2" id="editRemarks2" class="hover" />
						</div>
					</td>
				</tr>	
			</table>
		</div>
		<div style="display: none;">
			<input type="hidden" name="assuredNo"   id="assuredNo"/>
			<input type="hidden" name="address1" 	id="address1"/>
			<input type="hidden" name="address2" 	id="address2"/>
			<input type="hidden" name="address3" 	id="address3"/>
			<input type="hidden" name="vlineCd" 	id="vlineCd"/>
			<input type="hidden" name="tempLineCd" 	id="tempLineCd"/>
			<input type="hidden" name="vlineName" 	id="vlineName"/>
			<input type="hidden" name="vissCd" 	 	id="vissCd"/>
			<input type="hidden" name="sublineCd" 	id="sublineCd"/>
			<input type="hidden" name="defaultIssCd" id="defaultIssCd"	value="${defaultIssCd}"/>
			<input type="hidden" name="parType"		 id="parType"   value="${parType}"/>
			<input type="hidden" name="parYy"		 id="parYy" 		value="${year}"/>
			<input type="hidden" name="quoteId"		 id="quoteId"		value="0"/>
			<input type="hidden" name="keyWord" 	 id="keyWord"/>
			<input type="hidden" name="defaultYear"	 id="defaultYear"/>
			<input type="hidden" name="cancelPressed" id="cancelPressed" value="N"/>
			<input type="hidden" id="fromQuote" name="fromQuote" value="N">
			<input type="hidden" id="userValidated" value="${userValidated}"/>
			<input type="hidden" id="override"	value="FALSE"/>
			<input type="hidden" id="quotationsLoaded"	value="N"/>
			<input type="hidden" id="hasGIPIWPolBasDetails"	name="hasGIPIWPolBasDetails" value="N"/>
			<input type="hidden" id="riFlag" name="riFlag" value="Y" />
		</div>
		<div id="buttonsRIParCreationDiv" class="buttonsDiv">
			<input id="btnAssuredMaintenance" class="button" type="button" value="Maintain Assured" name="btnAssuredMaintenance" style="width: 120px;"/>
			<input id="btnCancel" class="button" type="button" value="Cancel" name="btnCancel" style="width: 100px;"/>
			<input id="btnSave" class="button" type="button" value="Save" name="btnSave" style="width: 100px;"/>
			<input id="btnPrint" class="button" type="button" value="Print" name="btnPrint" style="width: 100px;"/>
		</div>
	</div>
</div>

<div id="parListingMainDiv" style="display: none;" module="parCreation">
	<div id="parListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="parListingTable" align="center" class="sectionDiv tableContainer" style="border: 1px solid #E0E0E0; width: 100%; height: 410px; margin-top: 1px; margin-bottom: 20px; display: none;">
	</div>
</div>
<div id="assuredDiv" style="display: none;">
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" style="display: none;">
</div>

<script type="text/javascript">
	setModuleId("GIRIS005");
	initializeAccordion();
	initializeAllMoneyFields();
	
	var mode = $F("mode");			// mode = 0, create ri par; mode = 0, edit initial acceptance, accessed from basic info menu
	var winPolbasObj = null;
	var parType = mode == "1" ? $F("globalParType") : "P";
	function loadRiParCreationFields() {
		$("defaultYear").value = $("year").value;
		$("basicInformation").hide();
		hideAllIssourceOptions();
		moderateIssourceOptionsBeginning();
		setIssCdToDefault();
		moderateLineOptionsByIssource();
		
	//	clearParParameters();
		clearObjectValues(objUWParList);
		clearObjectValues(objGIPIWPolbas);

		if($F("acceptNo") == "") {
			$("acceptBy").value = '${moduleUser}';
			$("acceptDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		}

	}

	function loadInitialAcceptanceFields() {
		winPolbasObj = JSON.parse('${winPolbas}'.replace(/\\/g, '\\\\'));
		$("btnAssuredMaintenance").hide();
		if(winPolbasObj != null) {
			$("acceptNo").value 		= nvl(winPolbasObj.acceptNo,"");
			$("refAcceptNo").value 		= nvl(winPolbasObj.refAcceptNo,"");
			//$F("globalParId") == null || $F("globalParId") == "") ? 0 : $F("globalParId");;
			$("riSName2").setAttribute("riCd", winPolbasObj.riCd);
			$("acceptDate").value 		= winPolbasObj.acceptDate == null ? dateFormat(new Date, 'mm-dd-yyyy') : (winPolbasObj.acceptDate);
			$("riPolicyNo").value 		= nvl(unescapeHTML2(winPolbasObj.riPolicyNo),""); //added unescapeHTML2 function to handle special characters edgar 12/17/2014
			$("riEndtNo").value 		= nvl(unescapeHTML2(winPolbasObj.riEndtNo),""); //added unescapeHTML2 function to handle special characters edgar 12/17/2014
			$("riBinderNo").value 		= nvl(unescapeHTML2(winPolbasObj.riBinderNo),""); //added unescapeHTML2 function to handle special characters edgar 12/17/2014
			$("riSName").setAttribute("writerCd", winPolbasObj.writerCd);
			$("offerDate").value 		= winPolbasObj.offerDate == null ? "" : (winPolbasObj.offerDate);
			$("acceptBy").value 		= nvl(unescapeHTML2(winPolbasObj.acceptBy),"");
			$("origPremAmt").value 		= formatCurrency(winPolbasObj.origPremAmt);
			$("origTsiAmt").value	    = formatCurrency(winPolbasObj.origTsiAmt);
			$("remarks2").value 		= nvl(unescapeHTML2(winPolbasObj.remarks),""); //used unescapeHTML2 function to handle html tags by MAC 04/04/2013.
			$("offeredBy").value 		= nvl(unescapeHTML2(winPolbasObj.offeredBy),""); //used unescapeHTML2 function to handle html tags by MAC 04/04/2013.
			$("amountOffered").value 	= formatCurrency(winPolbasObj.amountOffered);
	
			$("riSName2").value 		= unescapeHTML2(winPolbasObj.riCdName);
			$("riSName").value			= unescapeHTML2(winPolbasObj.writerCdName);
		}
	}
	//added by Patrick Cruz 12.28.2011
	
    function exit(){
    	changeTag = 0;
    	if(mode == 0){
    		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
    	}else if(mode == 1){
    		goBackToParListing();
    	}
    }
    
	if(mode == "0") {
		loadRiParCreationFields();
		//modified by Patrick Cruz 12.27.2011
		$("parCreationExit").observe("click", function () {
			onCancel();
			});
		
		//end
		$("basicInformation").observe("click", function () {
			$("globalParId").value = objUWParList.parId;
			try {
				creationFlag = true; 
				if ($F("linecd") == "SU"){
					if($("parType").value == "E"){
						showEndtBondBasicInfo();						
					}else{
						showBondBasicInfo();
					}
				}else{	
					showBasicInfo();
				}
			} catch (e) {
				showErrorMessage("riParCreation.jsp - basicInformation", e);
			}
		});
		
	} else if(mode == "1") {
		loadInitialAcceptanceFields();
	}
	
	function postedBinderExists(){ //Created by : J. Diago 09.11.2014 - Check for PAR's posted binder.
		try{
			var exists = false;
			var parId = null;
			if(objUWParList != null || objUWParList != undefined){
				parId = objUWParList.parId;
			}
			new Ajax.Request(contextPath+"/GIPIPARListController",{
				parameters:{
					action: "checkForPostedBinder",
					parId : parId,
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							exists = true;
							showWaitingMessageBox('There are posted binder(s). Update of Cedant is not allowed.', 'I', function(){
								// in case functions are to be added.
							});	
						}
					}
				}
			});
			return exists;
		} catch(e){
			showErrorMessage("postedBinderExists", e);
		}
	}
	
	$("riSName2").setAttribute("lastValidValue", $F("riSName2")); //added by J. Diago 09.11.2014 - Set value of riSname2
	$("searchRiSName2").observe("click", function() {
		if(!postedBinderExists()){
			var issCd = mode == "1" ? $F("globalIssCd") : $F("isscd");
			if(issCd == "RI") {
				showReinsurerLOV("", "GIRIS005sname2", "");
			} else if(issCd == "RB") {
				getGiriWinpolbasIssourceList("GIRIS005");
			}
			//showReinsurerLOV("", "GIRIS005sname2");	
		}
	});
	
	var promptSuccess = "Y";
	var updateCedant = "N"; // bonok :: 10.03.2014
	$("btnValidateGIPIWinvoice").observe("click", function(){ //create by J. Diago 09.15.2014
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController",{
				parameters:{
					action: "checkIfInvoiceExistsRI",
					parId : objUWParList.parId,
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							showConfirmBox2("Confirm", "Update of Cedant will recreate invoice and delete corresponding data on distribution and working binder, if applicable. Do you want to proceed?", "Yes", "No", 
							function(){ //if yes
								promptSuccess = "N";
								updateCedant = "Y"; // bonok :: 10.03.2014
							    $("btnSave").click();
							}, 
							function(){ //if no
								$("riSName2").value = $("riSName2").readAttribute("lastValidValue");
							}); 	
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateIfInvoiceExists", e);
		}
	});
	
	function recreateWInvoiceGiris005(){ //created by J. Diago 09.15.2014
		new Ajax.Request(contextPath + "/GIPIPARListController", {
			method : "POST",
			parameters : {
				action: "recreateWInvoiceGiris005",
				parId : objUWParList.parId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Recreating Invoice, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					showRIParCreationPage(mode,parType);
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("searchRiSName").observe("click", function() {
		showReinsurerLOV("", "GIRIS005sname1", "");
	});
	
	$("btnAssuredMaintenance").observe("click", function(){
		/* testing Patrick Cruz 12.21.2011
		*remarks*- maintainAssured not working
		maintainAssured("riParCreationMainDiv", $F("assuredNo")); */
		//showAssuredListing(); //removed by robert 10.14.14
		showAssuredListingTableGrid(); //added by robert 10.14.14
	});

	function setWInPolbasObj() {
		var newObj = new Object();
		newObj.acceptNo = ($F("acceptNo") == null || $F("acceptNo") == "") ? 0 : $F("acceptNo");
		newObj.refAcceptNo = $F("refAcceptNo");
		newObj.parId = ($F("globalParId") == null || $F("globalParId") == "") ? 0 : $F("globalParId");;
		newObj.riCd = $("riSName2").getAttribute("riCd");
		newObj.acceptDate = $F("acceptDate");
		newObj.riPolicyNo = $F("riPolicyNo");
		newObj.riEndtNo = $F("riEndtNo");
		newObj.riBinderNo = $F("riBinderNo");
		//newObj.writerCd = $("riSName").getAttribute("riCd"); comment out by MAC 03/06/2013.
		//replaced getAttribute("riCd") by getAttribute("writerCd") to get value of Reassured field and allow Reassured field to be saved as null by MAC 03/06/2013.
		newObj.writerCd = ($F("riSName") == null || $F("riSName") == "") ? null : $("riSName").getAttribute("writerCd");
		newObj.offerDate = $F("offerDate");
		newObj.acceptBy = $F("acceptBy");
		newObj.origTsiAmt = unformatCurrencyValue($F("origTsiAmt"));
		newObj.origPremAmt = unformatCurrencyValue($F("origPremAmt"));
		newObj.remarks = $F("remarks2");
		newObj.offeredBy = $F("offeredBy");
		newObj.amountOffered = unformatCurrencyValue($F("amountOffered"));
		newObj.updateCedant = updateCedant; // bonok :: 10.03.2014
		
		return newObj;
	}

	function validateInput() {
		var result = true;
		if(mode == "0") {
			if ($("linecd").selectedIndex == 0){
				result = false;
				$("linecd").focus();
				showMessageBox("Required fields must be entered.", imgMessage.INFO);
				//showMessageBox("Line of Business is required.", imgMessage.INFO);
			} else if ($("isscd").selectedIndex == 0){
				result = false;
				$("isscd").focus();
				showMessageBox("Issuing source is required.", imgMessage.INFO);
			} else if ($F("year")==""){
				result = false;
				$("year").focus();
				showMessageBox("Year is required.", imgMessage.INFO);
			} else if (($F("year").include(".")) || ($F("year").include(","))) {
				result = false;
				$("year").focus();
				showMessageBox("Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.INFO);
			} else if ((parseFloat($F("year")) < 00) || (parseFloat($F("year")) > 99) || (isNaN($F("year")))){
				result = false;
				$("year").focus();
				showMessageBox("Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.INFO);
			} else if (($F("quoteSeqNo")=="") || ($F("quoteSeqNo")!="00")){
				result = false;
				$("quoteSeqNo").focus();
				showMessageBox("Cannot create new PAR with quote not equal to zero.", imgMessage.INFO);
			} else if ($F("assuredNo")==""){
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

	function getAcceptNoBeforeSave() {
		new Ajax.Request(contextPath+"/GIPIPARListController?action=generateAcceptNo" , {
			method: "POST",
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
					showNotice("Saving PAR, please wait...");
				},
			onComplete : function(response) { 
					if(isNaN(parseInt(response.responseText))) {
						showMessageBox("No accept no. generated. ");
					} else {
						$("acceptNo").value = response.responseText;
						saveRiPar();
					}
				}
		});
	}

	function saveRiPar() {
		try {
			var objPar = new Object();
			if(mode == "0") {
				objPar.parId = "0";
				objPar.issCd = $F("isscd");
				objPar.lineCd = $F("linecd");
				objPar.parYy = $F("year");
				objPar.quoteSeqNo = $F("quoteSeqNo");
				objPar.underwriter = "";
				objPar.assdNo = $F("assuredNo");
				objPar.remarks = escapeHTML2($F("remarks"));
				objPar.parType = $F("parType");
				objPar.parId = ($F("globalParId") == null || $F("globalParId") == "") ? 0 : $F("globalParId");
				objPar.parSeqNo = parseFloat($F("inputParSeqNo") == ""? "0" : $F("inputParSeqNo"));
				objPar.quoteId = $F("quoteId");
				//objPar.address1 = escapeHTML2($F("address1")); commented out by reymon 02272013
				//objPar.address2 = escapeHTML2($F("address2")); commented out by reymon 02272013
				//objPar.address3 = escapeHTML2($F("address3")); commented out by reymon 02272013
			} else {
				objPar.parId = ($F("globalParId") == null || $F("globalParId") == "") ? 0 : $F("globalParId");
				objPar.issCd = $F("globalIssCd");
				objPar.lineCd = $F("globalLineCd");
			}
			objPar.wInPolbas = setWInPolbasObj();
			
			var lineName = mode == "1" ? $F("globalLineName") : $("linecd").options[$("linecd").selectedIndex].text;
			//new Ajax.Request(contextPath+"/GIPIPARListController?action=saveRIPar", {
			if(mode=="0") {
				new Ajax.Updater("uwParParametersDiv", contextPath+"/GIPIPARListController?action=saveRIPar", {
					method: "POST",
					parameters: {
						mode:		mode,
						vlineName:  lineName,
						parType:    $F("parType"),
						parameters: JSON.stringify(objPar)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
							showNotice("Saving PAR, please wait...");
						},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)){
							getParSeqNo("Y");
							objUWGlobal.lineCd = $F("vlineCd"); 
							objUWGlobal.menuLineCd = $("vlineCd").getAttribute("menuLineCd");  
							initializePARBasicMenu($F("parType"), $F("vlineCd"));				
							if ($F("cancelPressed")=="Y"){
								pressParCreateCancelButton();
							}
						/*	if ("P" != $F("parType")){
								if ($F("fromQuote")== "Y"){
									if ("N" == $F("hasGIPIWPolBasDetails")){
										insertGipiWPolbasicDetailsForPAR();
									}
								} 
							}	
							if (("Y" == $F("parType")) && ("Y" == $F("fromQuote"))){
								$("hasGIPIWPolBasDetails").value = "Y";
							}*/
							changeTag = 0;
						} else {
							hideNotice("");
							$$("div#buttonsParCreationDiv input[type='button']").each(function(b){
								enableButton(b.getAttribute("id"));
							});
							$("linecd").enable();
							$("isscd").enable();
							$("year").enable();
							$("remarks").enable();
							hideOverlay();
							//clearParParameters();
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			} else {
				new Ajax.Request(contextPath+"/GIPIPARListController?action=saveRIPar", {
					method: "POST",
					parameters: {
						mode:		mode,
						vlineName:  lineName,
						parType:    $F("parType"),
						parameters: JSON.stringify(objPar)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
							showNotice("Saving PAR, please wait...");
						},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)){
							hideNotice("");
							if(promptSuccess != "N"){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								showRIParCreationPage(mode,parType);
							} else if(promptSuccess == "N"){
								recreateWInvoiceGiris005();
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}
			
		} catch(e) {
			showErrorMessage("saveRiPar", e);
		}	
	}

	//observeBackSpaceOnDate("acceptDate");
	observeBackSpaceOnDate("offerDate");
	observeBackSpaceOnDate("riSName");
	observeBackSpaceOnDate("riSName2");
	
	//modified by Patrick Cruz 12.28.2011
	$("amountOffered").observe("change", function() {
		if($F("amountOffered") != "" && isNaN(parseFloat($F("amountOffered")))) {
			//clearFocusElementOnError("amountOffered", "Invalid value. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.");
			$("amountOffered").clear();		
		}/* else if(parseFloat($F("amountOffered")) > 99999999999999.99 || parseFloat($F("amountOffered")) < -99999999999999.99) {
			//clearFocusElementOnError("amountOffered", "Invalid value. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.");
			$("amountOffered").clear();
		} */
		
		//if (validateLength($F("amountOffered"), 14) && $F("amountOffered") > 0){ //replaced by codes below robert GENQA 4926 09.04.15 
		if (validateLength($F("amountOffered").replace(/-/g, ""), 14) && ($("parType").value == "E" || ($("parType").value == "P" && parseFloat($F("amountOffered")) > 0))){
			$("amountOffered").value = formatCurrency($F("amountOffered"));
	 	}else{
			//showWaitingMessageBox("Invalid value. Value should be from 0.01 to 99,999,999,999,999.99.","I", function(){ //replaced by codes below robert GENQA 4926 09.04.15 
			showWaitingMessageBox("Invalid value. Value should be from "
									+ ($F("parType") == "P" ? "0.01" : "-99,999,999,999,999.99")
									+ " to 99,999,999,999,999.99.","I", function(){
				$("amountOffered").clear();
				$("amountOffered").focus();	
			});
		}
	});	

	$("origTsiAmt").observe("change", function() {
		if($F("origTsiAmt") != "" && isNaN(parseFloat($F("origTsiAmt")))) {
			//clearFocusElementOnError("origTsiAmt", "Invalid value. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.");
			$("origTsiAmt").clear();
		} /* else if(parseFloat($F("origTsiAmt")) > 99999999999999.99 || parseFloat($F("origTsiAmt")) < -99999999999999.99) {
			//clearFocusElementOnError("origTsiAmt", "Invalid value. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.");
			$("origTsiAmt").clear();
		} */	
		
		//if (validateLength($F("origTsiAmt"), 14)  && $F("origTsiAmt") > 0){ //replaced by codes below robert GENQA 4926 09.04.15 
		if (validateLength($F("origTsiAmt").replace(/-/g, ""), 14) && ($("parType").value == "E" || ($("parType").value == "P" && parseFloat($F("origTsiAmt")) > 0))){ 
			$("origTsiAmt").value = formatCurrency($F("origTsiAmt"));
	 	}else{
			//showWaitingMessageBox("Invalid value. Value should be from 0.01 to 99,999,999,999,999.99.","I", function(){ //replaced by codes below robert GENQA 4926 09.04.15 
			showWaitingMessageBox("Invalid value. Value should be from "
									+ ($F("parType") == "P" ? "0.01" : "-99,999,999,999,999.99")
									+ " to 99,999,999,999,999.99.","I", function(){
				$("origTsiAmt").clear();
				$("origTsiAmt").focus();	
			});
		}
	});

	$("origPremAmt").observe("change", function() {
		if(parCtr == 0){	
			if($F("origPremAmt") != "" && isNaN(parseFloat($F("origPremAmt")))) {
				//clearFocusElementOnError("origPremAmt", "Invalid value. Value should be from -9,999,999,999.99 to 9,999,999,999.99.");
				$("origPremAmt").clear();
			} /* else if(parseFloat($F("origPremAmt")) > 9999999999.99 || parseFloat($F("origPremAmt")) < 0.01){
				//clearFocusElementOnError("origPremAmt", "Invalid value. Value should be from 0.01 to 9,999,999,999.99.");
				$("origPremAmt").clear();
			} */
			
			/* if (validateLength($F("origPremAmt"), 14)){ */
		    //if (validateLength($F("origPremAmt"), 10) && $F("origPremAmt") > 0){ // bonok :: 10.03.2014 :: changed length from 12 to 10 //replaced by codes below robert GENQA 4926 09.04.15 
		    if (validateLength($F("origPremAmt").replace(/-/g, ""), 10) && ($("parType").value == "E" || ($("parType").value == "P" && parseFloat($F("origPremAmt")) > 0))){ 
				$("origPremAmt").value = formatCurrency($F("origPremAmt"));
		 	}else{
				/* showWaitingMessageBox("Invalid value. Value should be from 0.01 to 99,999,999,999,999.99.","I", function(){ */
				//showWaitingMessageBox("Invalid value. Value should be from 0.01 to 9,999,999,999.99.","I", function(){ // bonok :: 10.03.2014 :: changed max range value from 99,999,999,999,999.99 to 9,999,999,999.99 //replaced by codes below robert GENQA 4926 09.04.15 
				showWaitingMessageBox("Invalid value. Value should be from "
										+ ($F("parType") == "P" ? "0.01" : "-9,999,999,999.99")
										+ " to 9,999,999,999.99.","I", function(){
					$("origPremAmt").clear();
					$("origPremAmt").focus();	
				});
			}
		}else if(parCtr == 1){
			if($F("origPremAmt") != "" && isNaN(parseFloat($F("origPremAmt")))) {
				//clearFocusElementOnError("origPremAmt", "Invalid value. Value should be from -9,999,999,999.99 to 9,999,999,999.99.");
				$("origPremAmt").clear();
				changeTag = 0;
			} /* else if(parseFloat($F("origPremAmt")) > 9999999999.99 || parseFloat($F("origPremAmt")) < -9999999999.99){
				//clearFocusElementOnError("origPremAmt", "Invalid value. Value should be from -9,999,999,999.99 to 9,999,999,999.99.");
				$("origPremAmt").clear();
				changeTag = 0;
			} */
			
			/* if (validateLength($F("origPremAmt"), 14)){ */
			//if (validateLength($F("origPremAmt"), 10)){ // bonok :: 10.03.2014 :: changed length from 12 to 10 //replaced by codes below robert GENQA 4926 09.04.15 
			if (validateLength($F("origPremAmt").replace(/-/g, ""), 10) && ($("parType").value == "E" || ($("parType").value == "P" && parseFloat($F("origPremAmt")) > 0))){ 
				$("origPremAmt").value = formatCurrency($F("origPremAmt"));
		 	}else{
				/* showWaitingMessageBox("Invalid value. Value should be from 0.01 to 99,999,999,999,999.99.","I", function(){ */
				//showWaitingMessageBox("Invalid value. Value should be from 0.01 to 9,999,999,999.99.","I", function(){ // bonok :: 10.03.2014 :: changed max range value from 99,999,999,999,999.99 to 9,999,999,999.99 //replaced by codes below robert GENQA 4926 09.04.15 
				showWaitingMessageBox("Invalid value. Value should be from "
										+ ($F("parType") == "P" ? "0.01" : "-9,999,999,999.99")
										+ " to 9,999,999,999.99.","I", function(){
					$("origPremAmt").clear();
					$("origPremAmt").focus();
					changeTag = 0;
				});
			}
		}
	});
	//end
	$("editRemarks2").observe("click", function () {
		showEditor("remarks2", 4000);
	});

	$("remarks2").observe("keyup", function () {
		limitText(this, 4000);
	});

	$("riBinderNo").observe("keyup", function () {
		limitText(this, 20);
	});

	$("riEndtNo").observe("keyup", function () {
		limitText(this, 20);
	});

	$("riPolicyNo").observe("keyup", function () {
		limitText(this, 27); //modified by J. Diago 09.11.2014 from 20 to 27
	});

	$("refAcceptNo").observe("keyup", function () {
		limitText(this, 10);
	});

	$("acceptBy").observe("keyup", function () {
		limitText(this, 40);
	});

	$("offeredBy").observe("keyup", function () {
		limitText(this, 40);
	});
	
	observeReloadForm("reloadForm", function() {showRIParCreationPage(mode,parType);});
	//observeCancelForm("btnCancel", function(){saveRiPar();}, pressParCreateCancelButton);
	
	//added by Patrick Cruz 12.26.2011
	function onSave(){
		/* var validate = validateInput();
		if(validate) { */
		if(checkAllRequiredFieldsInDiv("riParCreationSectionDiv")==true && checkAllRequiredFieldsInDiv("initAcceptanceInfoDiv")==true){
			/* if(mode == "1") {
				if($F("acceptNo") == "") {
					getAcceptNoBeforeSave();	
				} else {
					saveRiPar();
				}
			} else {
				getAcceptNoBeforeSave();
			} */
			if($F("acceptNo") == "") {
				getAcceptNoBeforeSave();	
			} else {
				saveRiPar();
			}
		}
	}
	
	function onCancel(){
		 if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						onSave();
						//if(checkAllRequiredFieldsInDiv("riParCreationSectionDiv")==true && checkAllRequiredFieldsInDiv("initAcceptanceInfoDiv")==true){
							if(mode == 1){
								goBackToParListing();
							}else{
								goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);										
							}
						//}
					},
					function(){
						//if(checkAllRequiredFieldsInDiv("riParCreationSectionDiv")==true && checkAllRequiredFieldsInDiv("initAcceptanceInfoDiv")==true){ // bonok :: 10.03.2014 :: comment out
							exit();
						//}
					}
					, "");
		}else{
			if(mode == 1){
				goBackToParListing();
			}else{
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);										
			}
		}
	 }
	
	$("btnSave").observe("click", function() {
		onSave();
	});
	
	$("btnCancel").observe("click", function () {
		onCancel();	
	});
	//end
	
	//Added by Joanne 03.06.13 to print GIRIR119
	$("btnPrint").observe("click", function () {
		if($F("acceptNo") == ""){
			showMessageBox("Please save records before printing.");
		}else{
			showGenericPrintDialog("Print Preliminary Inward Acceptance", printGIRIR119, "");
		}
	});
	
	function printGIRIR119(){
		var content = contextPath+"/InitialAcceptancePrintController?action=printGIRIR119&parId="+nvl($F("globalParId"), objUWParList.parId)+
								"&reportId=GIRIR119&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		printGenericReport(content, "PRELIMINARY ACCEPTANCE SLIP");
	}
	//end
	
	setCursor("default");
	changeTag = 0;
	
	initializeChangeTagBehavior(onSave);
	//initializeChangeTagBehavior(onCancel);
	//initializeChangeAttribute();
</script>