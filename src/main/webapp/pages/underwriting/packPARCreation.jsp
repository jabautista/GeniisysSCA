<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="packPackCreationDiv" style="margin-top: 1px; display: none;" >
	<div id="packParCreationMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<input type="hidden" id="basicEnabled" name="basicEnabled" value="" />
				<ul>
					<li><a id="packBasicInformation">Basic Information</a></li>
					<li><a id="packParCreationExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label id="">Package PAR Information</label> 
			<span class="refreshers" style="margin-top: 0;">
			 	<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<form id="createPackPARForm">
		<div class="sectionDiv" id="packPARInformationDiv" changeTagAttr="true" >
			<div id="parInformationDiv" style="margin: 10px;">
				<table width="80%" align="center" cellspacing="1" border="0">
					<tr>
						<td class="rightAligned" style="width: 20%;">Line of Business </td>
						<td class="leftAligned" style="width: 30%;">
							<select id="packLineCdSel" name="packLineCdSel" style="width: 99%;" value="${txtLineCd}" class="required">
								<option></option>
								<c:forEach var="line" items="${lineListing}">
									<option value="${line.lineCd}">${line.lineName}</option>				
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width: 20%;">Issuing Source </td>
						<td class="leftAligned" style="width: 30%;">
							<select id="packIssCd" name="packIssCd" style="width: 99%;" class="required">
								<option></option>
								<c:forEach var="issource" items="${issourceListing}">
									<option value="${issource.issCd}" >${issource.issName}</option>				
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%;">Year </td>
						<td class="leftAligned" style="width: 30%;">
							<input id="year" class="leftAligned required" type="text" name="year" style="width: 95%;" value="${year}" maxlength="4"/>
						</td>						
						<td class="rightAligned" style="width: 20%;">Pack PAR Sequence No. </td>
						<td class="leftAligned" style="width: 30%;">
							<input id="parSeqNo" class="leftAligned" type="text" name="parSeqNo" style="width: 95%; text-align: right;" readonly="readonly" value="${savePackPAR.parSeqNo}"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%;">Quote Sequence No. </td>
						<td class="leftAligned" style="width: 30%;">
							<input id="quoteSeqNo" class="leftAligned" type="text" name="quoteSeqNo" style="width: 95%; text-align: right;" value="00" readonly="readonly"/>
						</td>							
						<td class="rightAligned" style="width: 20%;">Assured Name </td>
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
							<input id="remarks" class="leftAligned" type="text" name="remarks" style="width: 98.2%; height: 30px;" />
						</td>
					</tr>
				</table>	
			</div>
			<div id="hiddenDiv" name="hiddenDiv" style="display: none;">
				<input type="hidden" name="assuredNo"   id="assuredNo"/>
				<input type="hidden" name="address1" 	id="address1"/>
				<input type="hidden" name="address2" 	id="address2"/>
				<input type="hidden" name="address3" 	id="address3"/>
				<input type="hidden" name="vlineCd" 	id="vlineCd"/>
				<input type="hidden" name="vissCd" 	 	id="vissCd"/>
				<input type="hidden" name="sublineCd" 	id="sublineCd"/>
				<input type="hidden" name="defaultIssCd"	id="defaultIssCd"	value="${defaultIssCd}"/>
				<input type="hidden" name="parType"			id="parType" 		value="P"/>
				<input type="hidden" name="parYy"			id="parYy" 			value="${year}"/>
				<input type="hidden" name="keyWord" 	id="keyWord"/>
				<input type="hidden" name="defaultYear"	id="defaultYear"/>
				<input type="hidden"	name="packParId"	id="packParId"		value="0">
				<input type="hidden" id="packQuotationsLoaded"	name="packQuotationsLoaded" value="N"/>
				<input type="hidden" id="userOverrideAuthority" name="userOverrideAuthority" value="${userOverrideAuthority}"/>
				<input type="hidden" id=fromQuote name="fromQuote" value="N"/>
				<input type="hidden" id="fromPackQuotation" name="fromPackQuotation" value="N"/>
				<input type="hidden" id="alreadySaved"   name="alreadySaved" value="N"/> <!-- To prevent constraint when saving the selected quotation again. -->
				<input type="hidden" id="packQuoteId" name="packQuoteId" value=""/>
				
			</div>		
			<div id="quoteListingDiv" name="quoteListingDiv" class="sectionDiv" style="width: 98.7%; margin: 5px; display: none;">
				<div id="dummyDiv"></div>
			</div>
		</div>		
	</form>
	<div id="buttonsDiv" class="buttonsDiv">
		 <input id="btnSelectQuotation" class="button" type="button" value="Select Quotation" name="btnSelectQuotation"/>
		<input id="btnReturnToQuotation" class="button" type="button" value="Return to Quotation" name="btnReturnToQuotation"/>
		<input id="btnPackLineSubline" class="button" type="button" value="Package Line Subline" name="btnPackLineSubline"/>
		<input id="btnAssuredMaintenance" class="button" type="button" value="Assured Maintenance" name="btnAssuredMaintenance"/>
		<input id="btnCancel" class="button" type="button" value="Cancel" name="btnCancel"/>
		<input id="btnSavePack" class="button" type="button" value="Save" name="btnSavePack"/>
		<input id="btnCreateNew" class="button" type="button" value="Create New" name="btnCreateNew" style="display: none;"/>
	</div>
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
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>
<script type="text/javaScript">	
/*
 * Edited By Irwin tabisora 03.23.2011
 */
 	//set default isscd -- added by irwin, july 8, 2011
 	$("packIssCd").value = "${defaultIssCd}";
 	$("vissCd").value = $("packIssCd").value;
 	var selectedLine = "${selectedLineCd}";
 	
 	//
 	changeTag = 0;
 	objGIPIWPackLineSublineTemp = new Array();
 	objGIPIWPackLineSublineCreatePack = null;
 	hasLineSubline = 'N';
 	initializeChangeTagBehavior(preSave);
 	disableButton("btnReturnToQuotation");
 	$("btnReturnToQuotation").observe("click", function(){
 		showConfirmBox("Return to quotation", "This option will automatically delete the PAR as a result of Return to Quotation function. Do you want to continue?", 
 		 		"Yes", "No",returnPackParToQuotation,"");
 	});

	 function returnPackParToQuotation(){
		 try{
			 new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=returnPackParToQuotation",{
					parameters : {
						action : "showPackAdditionalENInfoPage",
						packQuoteId:  $F("packQuoteId"),
						packParId: $F("packParId")
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Returning to quotation...");
				},onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						showWaitingMessageBox("Return to quotation successful.", imgMessage.SUCCESS, reloadPackParCreation);
					}
				}
			 });
		}catch(e){

		}	 
	}

 	$("btnSelectQuotation").observe("click", function(){
 		try {
			var issCd = $F("packIssCd");
			if(issCd == ""){
				showMessageBox("Please choose issuing source.", imgMessage.INFO);	
			}else{
				if ("Y" != $F("fromPackQuotation")){
					/*
					if ("0" == $F("globalParId")){
						loadPackQuotationListing();
					} else {
						showMessageBox("Unable to update record ... permission denied.", "info");
					}*/
					if($F("alreadySaved") == 'Y'){
						showMessageBox("PAR has information already. If you want you can just create a new par from quotation.", imgMessage.INFO);
					}else{
						//loadPackQuotationListing();
						showPackQuotationLOV($F("packLineCdSel"), $F("packIssCd"));
					}
					
				}else {
					showMessageBox("PAR was already created from quotation. The system does not allow RECREATION of PAR from quotation.", imgMessage.INFO);
				}
			}	
		} catch(e) {
			showErrorMessage("btnSelectQuotation", e);
		}
	});
 	
 	function showPackQuotationLOV(lineCd, issCd){
 		try{
 			LOV.show({
 				controller : "UnderwritingLOVController",
 				urlParameters : {
 					action : "getGIPIPackQuoteLOV",
 					lineCd : lineCd,
 					issCd : issCd,
 					page : 1},
 				title : "Package Quotations",
 				width : 750,
 				height : 370,
 				columnModel : [{	id : "packQuoteId",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "issCd",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "lineCd",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "sublineCd",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "quotationYy",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "quotationNo",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "proposalNo",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "assdActiveTag",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "validDate",
 									title : "",
 									width : '0',
 									visible : false
 								},
 								{	id : "quoteNo",
 									title : "Quotation No.",
 									width : '200px'
 								},
 								{	id : "assdNo",
 									title : "Assured No.",
 									width : '100px',
 									align : 'right'
 								},
 								{	id : "assdName",
 									title : "Assured Name",
 									width : '410px'
 								}],
 				draggable : true,
 				onSelect : function(row){
 					objSelectedQuote = row;
 					checkIfValidDatePack(objSelectedQuote);
 				}
 			});		
 		} catch (e){
 			showErrorMessage("showPackQuotationLOV", e);
 		}
 	}
 	
 	function checkIfValidDatePack(row){
		var packQuoteId = row.packQuoteId;
		if ((packQuoteId == null)||(packQuoteId == "0")){
			showMessageBox("Please select a quotation.", imgMessage.ERROR);
		} else {
			var today = new Date();
			var validDate = new Date();
			validDate = 	Date.parse(row.validDate);
			if (validDate < today){
				showConfirmBox("Validity Date Verification", "Validity Date has expired.  Would you like to continue?", "OK", "Cancel", function(){
					checkUserOverride(row);}, "");
				
			} else {
				prepareQuotation2(row);
			}
		} 
	}
 	
 	function checkUserOverride(row){
		if ("TRUE" == $F("userOverrideAuthority")){
			prepareQuotation2(row);
		} else {
			showMessageBox("User has no override authority.", imgMessage.INFO);
		}
	}
 	
 	function prepareQuotation2(row){
		var packLineCdSel = $("packLineCdSel");
		var packIssCd = $("packIssCd");
		$("packIssCd").value = row.issCd;
		$("packLineCdSel").value = row.lineCd;
		$("packIssCd").disabled = true;
		$("packLineCdSel").disabled = true;
		showConfirmBox4("Create PAR from Quote ", "This option will automatically create a PAR record with all the information entered in the quotation.  Do you want to continue?", "Yes", "Exit","Cancel", 
				function(){turnPackQuoteToParTemp(row);},checkChangeTagBeforeUWMain, "");
	}
 	
 	function turnPackQuoteToParTemp(row){
		var selectedPackQuoteId			= row.packQuoteId;
		var issCd			= row.issCd;
		var lineCd			= row.lineCd;
		var sublineCd		= row.sublineCd;
		var quotationYy		= row.quotationYy;
		var quoteNo			= row.quoteNo;
		var proposalNo		= row.proposalNo;
		var assdNo			= row.assdNo;
		var assdName		= row.assdName;
		var assdActiveTag	= row.assdActiveTag;
		var vAssdFlag		= false;
		
		// assign values to hidden fields
		$("packQuoteId").value = selectedPackQuoteId;
		$("vlineCd").value = lineCd;
		$("vissCd").value = issCd;
		$("assuredName").value			= assdName;
		$("assuredNo").value			= assdNo;
		$("quoteSeqNo").value = "00";
		$("year").value = $("parYy").value;
		$("fromPackQuotation").value = "Y";
		if (($F("globalParId") == "0")||($F("globalParId") == "")){
			if (assdActiveTag == "N"){
				function showQuoteToParAssdLOV(){
					function reset(){							
						$("packLineCdSel").enable();
						$("year").enable();
						$("remarks").enable();
						$("parSeqNo").enable();
						$("assuredNo").enable();
						$("assuredName").enable();
						
						$("packLineCdSel").clear();
						$("parSeqNo").clear();
						$("assuredNo").clear();
						$("assuredName").clear();
						$("fromPackQuotation").clear();
					}
					
					showAssuredListingTG($F("vlineCd"),
							function() {
								if ($F("assuredNo") == "")	{
									reset();
								}else{
									getPackAssuredValues();
								}
							}, 
							function(){
								reset();
							});
				}
				
				
				if ((nvl(assdNo, "") == "") && (nvl(assdName, "") == "")){
					showWaitingMessageBox("Assured is required, please choose from the list.", "info", function(){
						hideOverlay(); 
						showQuoteToParAssdLOV();
					});
				} else {
					showWaitingMessageBox("The assured that was assigned in the quotation cannot be found, please assign a new one.", "info", function(){
						hideOverlay(); 
						showQuoteToParAssdLOV();
					});
				}
			} else { //if assdActiveTag is Y
				getPackAssuredValues();
			}
		}	
	}

 	function loadPackQuotationListing(){
 		showOverlayContent(contextPath+"/GIPIPackQuoteController?action=getSelectPackQuotationListing&pageNo=1&"+Form.serialize("createPackPARForm"), 
				"Select Quotation", function(){
					$("packQuotationsLoaded").value = "Y";
				}, 125, 20, 1);
 	}
 	
	/*$("btnAssuredMaintenance").observe("click", function(){
		//maintainAssured("packPackCreationDiv", $F("assuredNo"), false);
		showAssuredListing(); // andrew - 08.10.2011
		$("parInformationDiv").setStyle("margin: 10px;");
	});*///replaced by: Nica with codes below to consider access rights of user for assured maintenance module
	
	observeAccessibleModule(accessType.BUTTON, "GIISS006", "btnAssuredMaintenance", function(){ 
		exitCtr = 3;
		assuredListingTableGridExit = 3; //MarkS 04.08.2016 SR-21916
		showAssuredListingTableGrid();	// Nica 06.07.2012
	});

	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$("packBasicInformation").hide();
	$("defaultYear").value = $("year").value;
	clearObjectValues(objUWGlobal); // added by: nica 02.17.2011 - to clear objUWGlobal object
	setDocumentTitle("Package PAR Creation");
	setModuleId("GIPIS050A");

	$("packLineCdSel").observe("change", function(){
		$("vlineCd").value = $("packLineCdSel").value;
	});

	$("packIssCd").observe("change",
			function(){
			$("vissCd").value = $("packIssCd").value;
	});

	function validateBeforeSave(){
		var result = true;
		if ($F("year").blank()){
			result = false;
			$("year").focus();
			showMessageBox("Year is required.", imgMessage.ERROR);
		} else if($F("packLineCdSel") == ""){
			showWaitingMessageBox("Required fields must be entered.", imgMessage.ERROR, function(){$("packIssCd").focus();});
			result = false;
		}else if ($F("packIssCd") == ""){
			showWaitingMessageBox("Required fields must be entered.", imgMessage.ERROR, function(){$("packIssCd").focus();});
			result = false;
		} else if ($F("assuredNo").blank()){
			result = false;
			$("assuredName").focus();
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
		}else if(hasLineSubline == "N"){
			result = false;// && $F("packParId") == 0
			showMessageBox("At least 1 record must be entered in the Package Line/Subline.", imgMessage.ERROR);
		}
		return result;
	}

	function preSave(){
		if (validateBeforeSave()){
			var addRows = getAddedJSONObjects(objGIPIWPackLineSublineTemp);
			var delRows = getDeletedJSONObjects(objGIPIWPackLineSublineTemp);
			var objParameters = new Object();
	
			objParameters.addRows = prepareJsonAsParameter(addRows);
			objParameters.delRows = prepareJsonAsParameter(delRows);
			var strParameters = JSON.stringify(objParameters);
	 		savePackPAR('P', strParameters);
	 		
	 		objGIPIWPackLineSublineTemp = new Array();
	 		//objGIPIWPackLineSublineCreatePack = null;
		}
	}

	$("btnSavePack").observe("click", function(){
		if(changeTag == 0){
			noChanges();
		}else{
			preSave();		
		}	
	});
	
	$("btnSearchAssuredName").observe("click", showAssuredListingTG /*openSearchClientModal*/);
/*
	$("reloadForm").observe("click", function(){
		reloadPackParCreation();
	});*/

	//showPackParBasicInfo
	observeReloadForm("reloadForm", reloadPackParCreation);
	$("btnCreateNew").observe("click", reloadPackParCreation);
	
	$("btnCancel").observe("click",checkChangeTagBeforeUWMain);

	function reloadPackParCreation(){
		showPackPARCreationPage($("packLineCdSel").value);
		clearParParameters();
	}

	// menus for par creation
	$("packParCreationExit").observe("click", function () {
	
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	$("packBasicInformation").observe("click", function () {
		try {
			creationFlag = true; // added by: nica 02.17.2011 - for UW menu exit to determine if PAR originates from creation
			showPackParBasicInfo();
		} catch (e) {
			showErrorMessage("packPARCreation.jsp - packBasicInformation", e);
		}
	});

	$("btnPackLineSubline").observe("click", showPackLineSubline);
	
	function showPackLineSubline(){
		try {
			var lineCd = $F("packLineCdSel");
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
			/*if(hasLineSubline == 'Y'){ 
				objGIPIWPackLineSublineTemp = new Array();
			 	objGIPIWPackLineSublineCreatePack = null;
			}*/
			// resets the temp obj
			if(objGIPIWPackLineSublineTemp.size() > 0){
				showConfirmBox4("Line/Subline", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
					fireEvent($("btnSavePack"), "click");
					//$("btnSavePack").fire
					}, function(){
						objGIPIWPackLineSublineTemp = new Array();
						//objGIPIWPackLineSublineCreatePack = null;
					
						Modalbox.show(contextPath+"/GIPIWPackLineSublineController?action=showPackParCreationLineSubline&packParId="+packParId+"&lineCd="+lineCd, {
							title: "Package Line/Subline",
							width: 500,
							overlayClose: false,
							asynchronous:false
							
						});
					}, "");
			}else{
				objGIPIWPackLineSublineTemp = new Array();
				//objGIPIWPackLineSublineCreatePack = null;
			
			//	fireEvent($("btnSavePack"), "click");
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
	
	// to assign selected line if called from Package PAR listing - Nica 08.18.2012
	for(var i=0; i<$("packLineCdSel").options.length; i++){
		if(selectedLine == $("packLineCdSel").options[i].value && !($("packLineCdSel").options[i].disabled)){
			$("packLineCdSel").value = selectedLine;
			fireEvent($("packLineCdSel"), "change");
		}
	}
	
	// added by: Nica 02.18.2013 - to limit text for remarks field
	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});
	
</script>