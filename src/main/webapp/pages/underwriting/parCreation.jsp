<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parCreationMainDiv" name="parCreationMainDiv" style="display: none;">
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

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">PAR Information</label> 
			<span class="refreshers" style="margin-top: 0;">
			 	<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
	<form id="creatPARForm">
		<div class="sectionDiv" id="parInformationDiv" style="margin-bottom: 10px;" changeTagAttr="true">
			<div id="parInformation" style="width: 97.7%; display: none; margin: 10px;">
				<table width="80%" align="center" cellspacing="1" border="0">
					<tr>
						<td class="rightAligned" style="width: 20%;">Line of Business </td>
						<td class="leftAligned" style="width: 30%;">
							<select id="linecd" name="linecd" style="width: 99%;" value="${txtLineCd}" class="required">
								<option></option>
								<c:forEach var="line" items="${lineListing}">
									<option value="${line.lineCd}" menuLineCd="${line.menuLineCd}">${line.lineName}</option>				
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width: 20%; display: none;">Subline </td>
						<td class="leftAligned" style="width: 30%; display: none;">
							<select id="sublinecd" name="sublinecd" style="width: 99%;" class="required">
								<c:forEach var="subline" items="${subLineListing}">
									<option value="${subline.sublineCd}">${subline.sublineName}</option>				
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%;">Issuing Source </td>
						<td class="leftAligned" style="width: 30%;">
							<select id="isscd" name="isscd" style="width: 99%;" class="required">
								<option></option>
								<c:forEach var="issource" items="${issourceListing}">
									<option value="${issource.issCd}">${issource.issName}</option>				
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width: 20%;">Year </td>
						<td class="leftAligned" style="width: 30%;">
							<input id="year" class="leftAligned required" type="text" name="year" style="width: 95%;" value="${year}" maxlength="2"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%;">PAR Sequence No. </td>
						<td class="leftAligned" style="width: 30%;">
							<input id="inputParSeqNo" class="leftAligned" type="text" name="inputParSeqNo" style="width: 95%;" readonly="readonly" value="${savedPAR.parSeqNo}"/>
						</td>
						<td class="rightAligned" style="width: 20%;">Quote Sequence No. </td>
						<td class="leftAligned" style="width: 30%;">
							<input id="quoteSeqNo" class="leftAligned required" type="text" name="quoteSeqNo" style="width: 95%;" readonly="readonly" value="00"/>
						</td>
					</tr>
					<tr>
						<td id="assdTitle" class="rightAligned" style="width: 20%;">Assured Name </td>
						<td class="leftAligned" style="width: 30%;">
							<!-- <input id="assuredName" class="leftAligned required" type="text" name="assuredName" style="width: 95%;" />-->
							<span style="border: 1px solid gray; width: 98%; height: 21px; float: left;" class="required"> 
								<input type="text" id="assuredName" name="assuredName" style="border: none; float: left; width: 87%;" class="required" readonly="readonly" /> <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnSearchAssuredName" name="btnSearchAssuredName" alt="Go" />
							</span>	
						</td>
						<!-- <td class="leftAligned" style="width: 20%;">
							<input id="btnSearchAssuredName" class="button" type="button" value="Search" name="btnSearchAssuredName"/>
						</td>-->
					</tr>
					<tr>
						<td class="rightAligned" style="width:20%;">Remarks </td>
						<td class="leftAligned" colspan="3" style="width: 80%;">
							<div style="border: 1px solid gray; height: 20px; width: 99%;">
								<textarea id="remarks" class="leftAligned" name="remarks" style="width: 95%; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="buttonsParCreationDiv" align="center">
			<input id="btnSelectQuotation" class="disabledButton" type="button" value="Select Quotation" name="btnSelectQuotation"/>
			<input id="btnReturnToQuotation" class="button" type="button" value="Return to Quotation" name="btnReturnToQuotation"/>
			<input id="btnAssuredMaintenance" class="button" type="button" value="Assured Maintenance" name="btnAssuredMaintenance"/>
			<input id="btnCancel" class="button" type="button" value="Cancel" name="btnCancel"/>
			<input id="btnSave" class="button" type="button" value="Save" name="btnSave"/>
			<br/>
		</div>
		<!--div id="quoteListingDiv" name="quoteListingDiv" class="sectionDiv" style="width: 99%; margin: 5px; display: none;">
			<div id="dummyDiv"></div>
		</div-->
		<div id="hiddenDiv" name="hiddenDiv" style="display: none;">
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
			<input type="hidden" name="parType"		 id="parType" 		value="P"/>
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
			<input type="hidden" id="hidQuoteId" />
		</div>
		<div id="checkedLineIssourceListingDiv">
			<c:forEach items="${checkedLineIssourceListing}" var="a" varStatus="ctr">
				<div id="row${a.lineCd}${a.issCd}" name="issLine" lineCd="${a.lineCd}" lineName="${a.lineName}" issCd="${a.issCd}" issName="${a.issName}">
				</div>
			</c:forEach>
		</div>
	
	</form>

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

<script type="text/javaScript">
	setModuleId("GIPIS050");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$("btnSelectQuotation").disable();
	$("defaultYear").value = $("year").value;
	$("basicInformation").hide();
	
	for(var i=0; i<$("isscd").options.length; i++) { // added by: Nica 07.20.2012 - to remove RI issCd in the LOV
		if('${riCd}' == $("isscd").options[i].value || "RI" == $("isscd").options[i].value) {
			$("isscd").options[i].remove();
		}
	}
	
	hideAllIssourceOptions();
	moderateIssourceOptionsBeginning();
	setIssCdToDefault();
	hideAllLineOptions();
	moderateLineOptionsByIssource();
	$("parInformation").show();
	enableButton("btnSelectQuotation");
	clearParParameters();
	clearObjectValues(objUWParList);
	clearObjectValues(objGIPIWPolbas);
	initializeChangeTagBehavior(validateBeforeSavePAR); // added by irwin
	
	var selectedLine = "${selectedLineCd}";
	
	/*for(i=1; i<$("isscd").options.length; i++) {
		if("RI" == $("isscd").options[i].value) {
			$("isscd").options[i].hide();
			$("isscd").options[i].disabled = true;			
		}
	}*/ // replaced by: Nica 07.20.2012
	
	function loadQuotationListing(){
		showOverlayContent(contextPath+"/GIPIQuotationController?action=getSelectQuotationListingTable&pageNo=1&"+Form.serialize("creatPARForm"), 
				"Select Quotation", function(){
					$("quotationsLoaded").value = "Y";
				}, 125, 20, 1);
	}
	
	$("btnSelectQuotation").observe("click", function(){
		if ("Y" != $F("fromQuote")){
			if ("0" == $F("globalParId")){
				showQuotationLOV($F("vlineCd"), $F("vissCd"));
				//loadQuotationListing();
			} else {
				showMessageBox("Unable to update record... permission denied.", "info");
			}
		} else {
			showMessageBox("PAR was already created from quotation. The system does not allow RECREATION of PAR from quotation", imgMessage.INFO);
		}
	});
	
	$("btnReturnToQuotation").observe("click", function(){
		if ("N" == $F("fromQuote") && $F("hidQuoteId") == ""){ //Apollo 10.11.2014 - Added hidQuoteId
			showMessageBox("PAR record was not created from quotation.", imgMessage.INFO);
		} else if ("0" == $F("globalParId")){
			showMessageBox("PAR record does not exist in Gipi Parlist.", imgMessage.INFO);
		} else {
			showConfirmBox("Delete PAR", "This option will automatically delete the PAR as a result of Return to Quotation function. Do you want to continue?", "Yes", "No", returnToQuotation,"");
		}
	});
	
	$("linecd").observe("change", function(){
		$("vlineCd").value = $("linecd").value;
		$("vlineCd").writeAttribute("menuLineCd", $("linecd").options[$("linecd").selectedIndex].getAttribute("menuLineCd")); // andrew - 04.15.2011
		$("tempLineCd").value = $("linecd").value;
		$("vlineName").value = $("linecd").options[$("linecd").selectedIndex].text;
		var oldIssCd = $("vissCd").value;
		var iss 	 = $("isscd");
		hideAllIssourceOptions();
		moderateIssourceOptionsByLine();
		for (var y=0; y<iss.length; y++){
			if('${riCd}' == iss[y].value || "RI" == iss[y].value){ // Nica 07.20.2012 - to remove RI issCd for PAR Creation
				$("isscd").options[y].remove();
			}else if (iss[y].value == oldIssCd){
				if (checkLineCdIssCdMatch($F("vlineCd"), iss[y].value)){
					$("isscd").selectedIndex = y;
				} else {
					setIssCdToDefault();
				}
			}
		}
		if ($("linecd").value == objLineCds.SU || $("linecd").options[$("linecd").selectedIndex].getAttribute("menulinecd") == "SU"){
			$("assdTitle").innerHTML = "Principal Name";
		} else {
			$("assdTitle").innerHTML = "Assured Name";
		}
		//new Effect.Fade("quoteListingDiv", "blind", {duration: .2});
		//new Effect.BlindUp("quoteListingDiv", { duration: 0.2 });
		$("quotationsLoaded").value = "N";
		
	});

	$("year").observe("change", function(){
		//var yearCharacters = ($("year").value.split("")).length;
		if("" == $F("year")){
			showMessageBox( "Year is required.", imgMessage.ERROR);
			$("year").value = $("defaultYear").value;
			return false;
		}
		$("year").value = (parseFloat($F("year"))).toPaddedString(2); 
		var year = $("year").value;
		if(isNaN(year)){
			showMessageBox( "Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.ERROR);
			$("year").value = $("defaultYear").value;
		} else if((year < 0) || (checkIfDecimal2(year))){
			showMessageBox( "Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.ERROR);
			$("year").value = $("defaultYear").value;
		}
	});

	$("isscd").observe("change",function(){
		$("vissCd").value = $("isscd").value;
		var oldLineCd = $("vlineCd").value;
		var line 	  = $("linecd");
		hideAllLineOptions();
		moderateLineOptionsByIssource();
		for (var y=0; y<line.length; y++){
			if (line[y].value == oldLineCd){
				if (checkLineCdIssCdMatch(line[y].value, $F("vissCd"))){
					$("linecd").selectedIndex = y;
				} else {
					$("linecd").selectedIndex = 0;
				}
			}
		}
		if ($("isscd").value == ""){
			showAllLineOptions();
			$("linecd").value = oldLineCd;
			$("vlineCd").value = oldLineCd;
		}
		//new Effect.BlindUp("quoteListingDiv", { duration: 0.2 });
		$("quotationsLoaded").value = "N";
	});

	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});
	
	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});

	function returnToQuotation(){
		new Ajax.Request(contextPath+"/GIPIPARListController?action=returnPARToQuotation&retQuoteId="+$F("globalQuoteId"), {
			evalScripts: true,
			asynchronous: true,
			method: "POST",
			//postBody: Form.serialize("uwParParametersDiv"),
			onCreate: function(){
				//showNotice("Deleting PAR...");
				$("creatPARForm").disable();
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					//hideNotice(response.responseText);
					showMessageBox(response.responseText, imgMessage.INFO);
					clearParCreationFields();
					clearParParameters();
					$("fromQuote").value = "N";
					$("hidQuoteId").value == "";
				}
				$("creatPARForm").enable();
				$("basicInformation").hide();
			}
		});
	}
	
	

	function validateBeforeSave(){
		var result = true;
		if ($("linecd").selectedIndex == 0){
			result = false;
			$("linecd").focus();
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
		}
		else if ($("isscd").selectedIndex == 0){
			result = false;
			$("isscd").focus();
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
		}
		else if ($F("year")==""){
			result = false;
			$("year").focus();
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
		} else if (($F("year").include(".")) || ($F("year").include(","))) {
			result = false;
			$("year").focus();
			showMessageBox("Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.INFO);
		}
		else if ((parseFloat($F("year")) < 00) || (parseFloat($F("year")) > 99) || (isNaN($F("year")))){
			result = false;
			$("year").focus();
			showMessageBox("Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.INFO);
		} 
		else if (($F("quoteSeqNo")=="") || ($F("quoteSeqNo")!="00")){
			result = false;
			$("quoteSeqNo").focus();
			showMessageBox("Cannot create new PAR with quote not equal to zero.", imgMessage.ERROR);
		}
		else if ($F("assuredNo")==""){
			result = false;
			$("assuredNo").focus();
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
		}
		return result;
	}

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES);
		} else {
			validateBeforeSavePAR();
		}
	});

	function validateBeforeSavePAR(){
		if (validateBeforeSave()){
			saveCreatedPAR();
		}
	}

	$("btnCancel").observe("click", function(){
		$("cancelPressed").value = "Y";
		if (($F("quoteId") != "0") && ($F("assuredNo")!= "")){
			showConfirmBox4("Cancel PAR Creation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", checkIfValidDate, pressParCreateCancelButton);
		} else if (($F("linecd") != "")|| /*($("isscd").value != $F("defaultIssCd")) || */($F("assuredNo")!="") || ($F("remarks")!="")){
			showConfirmBox4("Cancel PAR Creation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", validateBeforeSavePAR, pressParCreateCancelButton);
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	});
	
	$("btnSearchAssuredName").observe("click", function(){showAssuredListingTG($("linecd").value);} /*openSearchClientModal*/);

	$("reloadForm").observe("click", function(){
		showPARCreationPage($("linecd").value);
		clearParParameters();
	});

	/*$("btnAssuredMaintenance").observe("click", function(){
		//maintainAssured("parCreationMainDiv", $F("assuredNo"));
		exitCtr = 2;
		showAssuredListingTableGrid(); //by bonok - test case 01.01.2012
	});*///replaced by: Nica with codes below to consider access rights of user for assured maintenance module
	
	observeAccessibleModule(accessType.BUTTON, "GIISS006", "btnAssuredMaintenance", function(){ 
		exitCtr = 2;
		assuredMaintainExitCtr = 3;
		assuredListingTableGridExit = 2; //MarkS 04.08.2016 SR-21916
		showAssuredListingTableGrid();	// Nica 06.07.2012
	});

	// menus for par creation
	$("parCreationExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	$("basicInformation").observe("click", function () {
		try {
			creationFlag = true; // added by: nica 02.17.2011 - for UW menu exit to determine if PAR originates from creation
			var lineCd = getLineCd(); // andrew - 05.18.2011
			//if ($F("globalLineCd") == "SU"){
			if(lineCd == "SU" || objUWGlobal.menuLineCd == "SU" || $("linecd").options[$("linecd").selectedIndex].getAttribute("menulinecd") == "SU"){ //added by steven 10.11.2014
				objUWGlobal.menuLineCd = "SU";
				showBondBasicInfo();
			}else{	
				showBasicInfo();
			}
		} catch (e) {
			showErrorMessage("parCreation.jsp - basicInformation", e);
		}
	});

	// menus for par listing
	$("parListingExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	function containsOnlyNumbers(str) {
		if (str == null || str.length() == 0){
			return false;
		}  
		for (var i = 0; i < str.length(); i++) {
			if (!Character.isDigit(str.charAt(i))){
				return false;
		  	}
		} 
		return true;
	}
	
	// to assign selected line if called from PAR listing - Nica 08.18.2012
	for(var i=0; i<$("linecd").options.length; i++){
		if(selectedLine == $("linecd").options[i].value && !($("linecd").options[i].disabled)){
			$("linecd").value = selectedLine;
			fireEvent($("linecd"), "change");
		}
	}
	
</script>