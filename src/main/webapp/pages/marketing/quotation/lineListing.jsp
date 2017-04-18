<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="lineCd" name="lineCd" />
<input type="hidden" id="lineName" name="lineName" />
<input type="hidden" id="riSwitch" name="riSwitch" value="${riSwitch}"/>
<div id="lineListingDiv" name="lineListingDiv" class="sectionDiv" style="display: none; width: 60%; margin: 20px 20%;" align="center">
	<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
	<div style="margin: 10px;">
		<div id="outerDiv" name="outerDiv" style="width: 100%;">
			<div id="innerDiv" name="innerDiv">
				<label id="lineListingInstruction" name="lineListingInstruction">Please select a line.</label>
			</div>
		</div>
		<div id="filterDiv" name="filterDiv" style="float: left; width: 100.6%; margin-top: 2px;">
			<label style="float: left; width: 12%; line-height: 20px;">Filter List</label> <input type="text" id="filterTextLine" name="filterTextLine" style="width: 86%;" />
		</div>
		<div id="lineListingTable" name="lineListingTable" style="width: 100%; height: 300px; overflow-y: auto;border: 1px solid #E0E0E0; float: left; padding: 10px 0;">
			<c:forEach var="line" items="${lineListing}">
				<div id="line${line.lineCd}" lineCd="${line.lineCd}" menuLineCd="${line.menuLineCd}" name="line" class="tableRow" style="margin: 0 10px;">
					<label style="margin-left: 10px;">${line.lineName}</label>
				</div>
			</c:forEach>
		</div>
		<div id="lines" style="display: none;">
			<json:object>
				<json:array name="lines" var="line" items="${lineListing}">
					<json:object>
						<json:property name="lineCd" value="${line.lineCd}" />
						<json:property name="lineName" value="${line.lineName}" />
						<json:property name="menuLineCd" value="${line.menuLineCd}"/>
					</json:object>
				</json:array>
			</json:object>
		</div>
		<div id="buttonContainerDiv" style="float: right; width: 100%; margin: 10px 0; text-align: right;">
			<input style="display: none;" type="button" class="button" id="btnCreateQuotationFromQuotationList" name="btnCreateQuotationFromQuotationList" value="Create Quotation" />
			<input style="display: none;" type="button" class="button" id="btnCreatePackQuotationFromList" name="btnCreatePackQuotationFromList" value="Create Quotation - Package" />
			<input style="display: none;" type="button" class="button" id="btnQuotationList" name="btnQuotationList" value="Quotation List" />
			<input style="display: none;" type="button" class="button" id="btnPARList" name="btnPARList" value="PAR List" />
			<input style="display: none;" type="button" class="button" id="btnEndtPARList" name="btnEndtPARList" value="Endt PAR List" />
			<input style="display: none;" type="button" class="button" id="btnPackParList" name="btnPackParList" value="Pack Par List"/>
			<input style="display: none;" type="button" class="button" id="btnEndtPackParList" name="btnEndtPackParList" value="Endt Pack Par List"/>
			<input style="display: none;" type="button" class="button" id="btnFRPSList" name="btnFRPSList" value="FRPS List"/>  <!-- belle-->
			<input style="display: none;" type="button" class="button" id="btnQuotationStatusList" name="btnQuotationStatusList" value="Quotation Status List"/> <!-- Rey 07.07.2011 -->
			<input style="display: none;" type="button" class="button" id="btnClaimListingList" name="btnClaimListingList" value="Claim Listing"/> <!-- Rey 09.08.2011 -->
			<input type="button" class="button" id="closeLineListing" name="closeLineListing" value="Close" style="width: 80px; display: none;" />
		</div>
	</div>
</div>

<script type="text/JavaScript">
	var rowHeight = 31;
	var lineIndex = -1;
	var lineCount = $$("div[name='line']").length;
	
	$("filterTextLine").observe("keypress", function(event){
		doKeyPress(event);
	});

	function doKeyPress(event){
		if(event.keyCode == 40 && lineIndex < lineCount-1){
			lineIndex++;
			fireEvent($("lineListingTable").down("div", lineIndex), "click");
			//if (lineIndex > 9){
				var objDiv = $("lineListingTable");
				objDiv.scrollTop = (lineIndex * rowHeight) - (rowHeight);
			//} modified by: nica 02.11.2011 to allow scrollbar to go down
		} else if (event.keyCode == 38 && lineIndex > 0){
			lineIndex--;
			fireEvent($("lineListingTable").down("div", lineIndex), "click");
			//if (lineIndex > 9){
				var objDiv = $("lineListingTable");
				objDiv.scrollTop = lineIndex * rowHeight;
			///modified by: nica 02.11.2011 to allow scrollbar to go up	
		} else if (event.keyCode == 13 && !$F("lineCd").blank()) {
			$$("div#buttonContainerDiv input[type='button']").each(
				function(btn){
					if (btn.getStyle("display") != "none"){
						fireEvent(btn, "click");
					}
				}
			);
		}
	}
	
	$("overlayTitleDiv").hide();

	$$("div[name='line']").each(
		function (line)	{
			line.observe("mouseover", function () {
				line.addClassName("lightblue");
			});
			
			line.observe("mouseout", function () {
				line.removeClassName("lightblue");
			});
			
			line.observe("click", function ()	{
				$("filterTextLine").focus();
				line.toggleClassName("selectedRow");
				if (line.hasClassName("selectedRow")) {
					$("lineCd").value = line.getAttribute("id").substring(4);					
					$("lineName").value = line.down("label", 0).innerHTML.replace(/&amp;/g, '&');
					objUWGlobal.lineCd = line.getAttribute("lineCd"); // andrew - 10.05.2010 - sets the menu line code here
					objUWGlobal.menuLineCd = line.getAttribute("menuLineCd"); // andrew - 10.05.2010 - sets the menu line code here
					objGIPIQuote.lineCd = line.getAttribute("lineCd");
					objGIPIQuote.lineName = line.down("label", 0).innerHTML; // andrew - 01.17.2012 - set the line name
					objGIPIQuote.menuLineCd = line.getAttribute("menuLineCd");
					objCLMGlobal.lineCd = line.getAttribute("lineCd");
					objCLMGlobal.menuLineCd = line.getAttribute("menuLineCd");
					objCLMGlobal.lineName = line.down("label", 0).innerHTML;
					$$("div[name='line']").each(function (li) {
						if (line.getAttribute("id") != li.getAttribute("id")) {
							li.removeClassName("selectedRow");
						}
					});
				} else {
					$("lineCd").value = "";
				}
			});

			line.observe("line:selected", function () {
				line.toggleClassName("selectedRow");
				if (line.hasClassName("selectedRow")) {
					$("lineCd").value = line.getAttribute("id").substring(4);
					$("lineName").value = line.down("label", 0).innerHTML;					
					$$("div[name='line']").each(function (li) {
						if (line.getAttribute("id") != li.getAttribute("id")) {
							li.removeClassName("selectedRow");
						}
					});
				} else {
					$("lineCd").value = "";
				}
			});
		}
	);

	$("btnCreateQuotationFromQuotationList").observe("click", createQuotationFromLineListing);
	$("btnCreatePackQuotationFromList").observe("click",creationPackQuotationFromListing);
	
	
	if (modules.all(function (mod) {return mod != 'GIIMM016';})) {
		$("btnCreateQuotationFromQuotationList").hide();
	}

	//$("btnCreateQuotationFromQuotationList").setStyle("margin-left: 410px;");
	
	$("btnQuotationList").observe("click", function () {
		if (!createQuotationFromLineListing2()) {	//marco - changed from createQuotationFromLineListing()
			showMessageBox("Please select a line first.", imgMessage.ERROR); //Patrick - 02/09/2012
			return false;
		}
		hideOverlay();
	});
	
	$("closeLineListing").observe("click", function () {
		hideOverlay();
		fromReassignQuotation = 0;
	});

	var lines = ($("lines").innerHTML).evalJSON();
	$("filterTextLine").observe("keyup", function (evt)	{
		if (evt.keyCode == 27) {
			$("filterTextLine").clear();
			$$("div[name='line']").each(function (div)	{
				div.show();
			});
		} else {
			// modified by: nica 01.31.2011
			var text = replaceSpecialCharsInFilterText2($F("filterTextLine").strip());
			if ("" != text)	{
				for (var i=0; i<lines.lines.length; i++)	{
					if (changeSingleAndDoubleQuotes(lines.lines[i].lineName.unescapeHTML()).toUpperCase().match(text.toUpperCase()) != null) {
						//|| (lines.lines[i].lineCd.toUpperCase().match(text.toUpperCase()) != null))	{
						//commented out by grace 11.3.10
						//only the line name should be filtered using the entered filter criteria
						$("line"+lines.lines[i].lineCd.unescapeHTML()).show();
					} else	{
						$("line"+lines.lines[i].lineCd.unescapeHTML()).hide();
					}
				}
			} else {
				$$("div[name='line']").each(function (div)	{
					div.show();
				});
			}
		}
	});
	
	/* marco - added $ ^ | . */
	function replaceSpecialCharsInFilterText2(str){
		return str.replace(/\[/g, "[\[]").replace(/\(/g, "[(]").replace(/\)/g, "[)]").replace(/\+/g, "[+]").
				   replace(/\*/g, "[*]").replace(/\?/g, "[?]").replace(/\\/g, "[\]").replace(/\|/g, "[|]").
				   replace(/\./g, "[.]").replace(/\^/g, "[.]").replace(/\\$/g, "[$]");
	}

	function doBtnParListClick() {
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			if (objUWGlobal.module == 'GIPIS207') {
				showBatchPosting($F("lineCd"));
			}else {
				updateMainContentsDiv("/GIPIPARListController?action=showParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+$F("riSwitch"),
						  "Getting PAR listing, please wait...",
						  function(){},[]);
				//setDocumentTitle("Policy Action Records");
				//$("underwritingMainMenu").hide();
				//$("parMenu").hide();
				//$("parListingMenu").show();	
			}
		}		
	}
	
	$("btnPARList").observe("click", doBtnParListClick);
	$("btnEndtPARList").observe("click", function () {
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			updateMainContentsDiv("/GIPIPARListController?action=showEndtParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+$F("riSwitch"),
					  "Getting Endorsement PAR listing, please wait...",
					  function(){},[]);
			//setDocumentTitle("Policy Action Records");
			//$("underwritingMainMenu").hide();
			//$("underwritingPARMenu").show();
		}
	});

	// added by: nica 11.04.2010
	$("btnPackParList").observe("click", function () {
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			updateMainContentsDiv("/GIPIPackPARListController?action=showPackParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+$F("riSwitch"),
					  "Getting Package PAR listing, please wait...",
					  function(){},[]);  
			//setDocumentTitle("Package Policy Action Records");
		}
	});

	// added by: nica 11.22.2010
	$("btnEndtPackParList").observe("click", function () {
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			updateMainContentsDiv("/GIPIPackPARListController?action=showEndtPackParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+$F("riSwitch"),
					  "Getting Endorsement Package PAR listing, please wait...",
					  function(){},[]);
			//setDocumentTitle("Endorsement Package Policy Action Records");
			$("parTypeFlag").value = "E";
		}
	});

	// added by belle 07062011 
	$("btnFRPSList").observe("click", function () {
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"),
			  "Getting FRPS listing, please wait...");
		}
	});
	
	/*
	*@author Rey
	*@date 07-11-2011
	*Quotation Line Listing
	*/
	$("btnQuotationStatusList").observe("click",function() { 
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			updateMainContentsDiv("/GIPIQuotationController?action=viewQuotationStatusListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&moduleId=GIIMM004",
			"Getting Quotation Status listing, please wait...");
		}
	});
	/*
	* Rey Jadlocon
	* 09-08-2011
	* Claim Line Listing
	*/
	$("btnClaimListingList").observe("click",function() { 
		if ($F("lineCd").blank()) {
			showMessageBox("Please select a line first.", imgMessage.ERROR);
			return false;
		} else {
			$("dynamicDiv").down("div",0).hide(); //hide claims menu
			
			if(objCLMGlobal.callingForm == "GICLS053"){ // irwin
				showUpdateLossRecoveryTagListing($F("lineCd"));
			}else if(objCLMGlobal.callingForm == "GICLS052"){ // christian
				showLossRecoveryListing($F("lineCd"));
			}else if(objCLMGlobal.callingForm == "GICLS026"){ //added by steven 8/23/2012
				showNoClaimListing($F("lineCd"));
			}else if(objCLMGlobal.callingForm == "GICLS260"){ //Nica 3.14.2013
				showClaimInformationListing($F("lineCd"), $F("lineName"));
			}else if(objCLMGlobal.callingForm == "GICLS044"){ //added by Kenneth L. 05.23.2013
				showReassignClaimRecord($F("lineCd"));
			}else if(objCLMGlobal.callingForm == "GICLS125"){ //added by Gzelle 09102015 SR3292
				showReOpenRecovery($F("lineCd"));		
			}else {
				updateMainContentsDiv("/GICLClaimsController?action=getClaimTableGridListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"),
				"Getting Claims listing, please wait...");	
			}
		
			
		}
	});
	
	//christian 07.09.2012
	//set btnClaimListingList value depending on callingForm
	if(objCLMGlobal.callingForm == "GICLS052"){
		$("btnClaimListingList").value = "Loss Recovery Listing";
	}else if(objCLMGlobal.callingForm == "GICLS026"){		//added by steven 8/30/2012
		$("btnClaimListingList").value = "No Claim Listing";
	}else if(objCLMGlobal.callingForm == "GICLS044"){ 	    //added by Kenneth L. 05.23.2013
		$("btnClaimListingList").value = "Reassign Claim Listing";
	}else if(objCLMGlobal.callingForm == "GICLS125"){ 	    //added by Gzelle 09102015 SR3292
		$("btnClaimListingList").value = "Re-Open Loss Recovery Listing";	
	}else{
		$("btnClaimListingList").value = "Claim Listing";
	}
	
	
	initializeAll();
	addStyleToInputs();	
	setModuleId("");//added to remove module id display when in quotation BJGA12.22.2010
</script>