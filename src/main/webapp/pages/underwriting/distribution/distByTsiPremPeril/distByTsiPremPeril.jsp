<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="distByTsiPremPerilMainDiv" name="distByTsiPremPerilMainDiv">  <!-- style="margin-top : 1px;" -->
	<div id="distByTsiPremPerilMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="distByTsiPremPerilQuery">Query</a></li>
					<li><a id="distByTsiPremPerilExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="distByTsiPremPerilForm" name="distByTsiPremPerilForm">
		<jsp:include page="/pages/underwriting/distribution/distrCommon/distrPolicyInfoHeader.jsp"></jsp:include>
		<!-- used to load the GIUW_POL_DIST, GIUW_WPERILDS, GIUW_WPERILDS_DTL records -->
		<input type="button" id="btnLoadRecords" value="" style="display: none;"/>
		<div id="distGroupMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Group</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistGroup" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			<div id="distGroupMain" class="sectionDiv" style="border: 0px;">	
				<div id="distTableDiv" class="sectionDiv" style="display: block;">
					<div id="distListingTable" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 160px; text-align: right; margin-right: 15px;">Distribution No.</label>
							<label style="width: 280px; text-align: left; margin-right: 5px;">Distribution Status</label>
							<label style="width: 280px; text-align: left; ">Multi Booking Date</label>
						</div>
						<div id="distListing" name="distListing" class="tableContainer">
						</div>
					</div>	
				</div>
				<div id="distGroupListingDiv" class="sectionDiv" style="display: block;">
					<div id="distGroupListingTable" style="width: 800px; margin:auto; margin-top:10px;">
						<div class="tableHeader">
							<label style="width: 100px; text-align: right; margin-right: 50px;">Group No.</label>							
							<label style="width: 630px; text-align: left;">Currency</label>
						</div>
						<div id="distGroupListing" name="distGroupListing" class="tableContainer">
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="distPerilMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Listing</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistPeril" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			
			<div id="distPerilMain" class="sectionDiv" style="border: 0px;">	
				<div id="distPerilTableDiv" class="sectionDiv" style="display: block;">
					<div id="distPerilTable" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 250px; text-align: center; margin-right: 5px;">Peril</label>
						<label style="width: 250px; text-align: center; margin-right: 10px;">Peril Sum Insured</label>
						<label style="width: 250px; text-align: center; margin-right: 10px;">Peril Premium</label>
						</div>
						<div id="distPerilListing" name="distPerilListing" class="tableContainer">
						</div>
					</div>	
				</div>
			</div>
		</div>
		
		<div id="distShareMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Share</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistShare" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>					
			<div id="distShareDiv" class="sectionDiv" style="display: block;">
				<div id="distShareTable" style="margin: 10px; margin-bottom: 10px; margin-top: 5px; padding-top: 1px;">
					<div class="tableHeader" style="margin-top: 5px;">
						<label style="width: 20%; text-align: left; margin-right: 4px; margin-left: 5px;">Share</label>
						<label style="width: 19.5%; text-align: right; margin-right: 4px;">% Share</label>
						<label style="width: 19%; text-align: right; margin-right: 4px;">Sum Insured</label>
						<label style="width: 19.5%; text-align: right; margin-right: 4px;">% Share</label>
						<label style="width: 19%; text-align: right; margin-right: 4px;">Premium</label>
					</div>
					<div id="distShareListing" name="distShareListing" style="display: block;" class="tableContainer">							
					</div>
					<div id="distShareTotalAmtDiv" class="tableHeader"  style="display: block;">
						<label style="text-align:left; width: 20%; margin-right: 4px; margin-left: 5px; float:left;">Total:</label>
						<label id="totalDistSpct" style="text-align:right; width: 19.5%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistTsi" style="text-align:right; width: 19%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistSpct1" style="text-align:right; width: 19.5%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistPrem" style="text-align:right; width: 19%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
					</div>
				</div>			
								
				<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
					<tr>
						<td class="rightAligned">Share</td>
						<td class="leftAligned">
							<input type="hidden" id="shareCd" name="shareCd" value="" />
							<input type="hidden" id="c080lineCd" name="c080lineCd" value="" />
							<input class="required" type="text" id="txtDspTrtyName" name="txtDspTrtyName" value="" style="width:250px;" readonly="readonly"/>
						</td>
						<td class="leftAligned">
							<input type="button" id="btnTreaty" name="btnTreaty" 	class="button"	value="Treaty" style="width:75px;"/>			
							<input type="button" id="btnShare" 	name="btnShare" 	class="button"	value="Share" style="width:75px;"/>			
						</td>
					</tr>
					<tr>
						<td class="rightAligned">% Share Sum Insured</td>
						<td class="leftAligned">
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct" name="txtDistSpct" value="" style="width:250px;" maxlength="18" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Sum Insured</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistTsi" name="txtDistTsi" value="" style="width:250px;" maxlength="18" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">% Share Premium</td>
						<td class="leftAligned">
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct1" name="txtDistSpct1" value="" style="width:250px;" maxlength="18" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistPrem" name="txtDistPrem" value="" style="width:250px;" maxlength="14"/>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="3">
							<input type="button" id="btnAddShare"		name="btnAddShare"		class="button"			value="Add" />
							<input type="button" id="btnDeleteShare"	name="btnDeleteShare"	class="disabledButton"	value="Delete" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnViewDist"		name="btnViewDist"		class="disabledButton"	value="View Distribution" />
			<input type="button" id="btnPostDist" 		name="btnPostDist" 		class="disabledButton"	value="Post Distribution" />
			<input type="button" id="btnCancel" 		name="btnCancel" 		class="button"	value="Cancel" />			
			<input type="button" id="btnSave" 			name="btnSave" 			class="button"	value="Save" />			
		</div>
	</form>
</div>	
<div id="summarizedDistDiv">
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$("summarizedDistDiv").hide(); //added by steven
	var enableViewDist = false;
	/** Variables **/
	var isMagic1 = false;
	var isMagic2 = false;
	var isMagic3 = false;
	var selectedGiuwPolDist = null;
	var selectedGiuwPolDistGroup = null;
	var selectedGiuwWPerilds = null;
	var selectedGiuwWPerildsDtl = {};

	var distShareRecordStatus = "INSERT";

	/*+ for treaty and share LOV's +*/
	var distListing = {};

	/*+ for computations +*/
	var distNo = "";
	var distSeqNo = "";
	var perilCd = "";
	var shareCd = "";

	/*+ for saving +*/
	var giuwPolDistRows = [];
	var giuwWPerildsRows = [];
	var giuwWPerildsDtlSetRows = [];
	var giuwWPerildsDtlDelRows = [];

	// for total amounts
	var totalDistSpct 	= 0;
	var totalDistTsi 	= 0;
	var totalDistSpct1 	= 0;
	var totalDistPrem 	= 0;
	
	/*+ VARIABLES in FMB +*/
	var varPostSw = "N";
	
	//for getting takeupterm
	var takeUpTerm = "";
	
	/** end of Variables **/
	
	/** Page Functions **/
	
	/* reset variables */
	function resetVariables() {
		selectedGiuwPolDist 		= null;
		selectedGiuwPolDistGroup 	= null;
		selectedGiuwWPerilds 		= null;
		selectedGiuwWPerildsDtl 	= {};

		distShareRecordStatus = "INSERT";

		distListing = {};

		distNo 			= "";
		distSeqNo 		= "";
		perilCd 		= "";
		shareCd 		= "";
	}

	function showGIUWS017PolDistV1LOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getV1ListDistByTsiPremPeril",
							moduleId : "GIUWS017",
							lineCd : $F("txtPolLineCd"),
							sublineCd : $F("txtPolSublineCd"),
							issCd : $F("txtPolIssCd"),
							issueYy : $F("txtPolIssueYy"),
							polSeqNo : $F("txtPolPolSeqNo"),
							renewNo : $F("txtPolRenewNo"),
				                page : 1},
			title: "Policy Listing",
			width: 910,
			height: 400,
			hideColumnChildTitle: true,
			filterVersion: "2",
			columnModel: [
							{	id: 'lineCd',
								title: 'Line Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'sublineCd',
								title: 'Subline Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'issCd',
								title: 'Issue Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'issueYy',
								width: '0',
								title: 'Issue Year',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'polSeqNo',
								width: '0',
								title: 'Pol. Seq No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'renewNo',
								width: '0',
								title: 'Renew No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'endtIssCd',
								width: '0',
								title: 'Endt Iss Code',
								visible: false,
								filterOption: true
							},
							{	id: 'endtYy',
								width: '0',
								title: 'Endt. Year',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'endtSeqNo',
								width: '0',
								title: 'Endt Seq No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'distNo',
								width: '0',
								title: 'Dist. No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{ 	id: 'policyNo',
								title : 'Policy No.',
								width : '180px'
							},
							{	id: 'assdName',
								title: 'Assured Name',
								width: '280px',
								filterOption: true
							},
							{ 	id: 'endtNo',
								title : 'Endt No.',
								width : '180px'
							},
							{ 	id: 'distNo',
								title : 'Dist No.',
								width : '75px'
							},
							{ 	id: 'meanDistFlag',
								title : 'Dist. Status',
								width : '149px'
							},	
						],
						draggable: true,
				  		onSelect: function(row){
							 if(row != undefined) {
							 	updateGIUWS017DistSpct1(row.distNo);
							 	objGIPIPolbasicPolDistV1 = row;
								populateDistrPolicyInfoFields(row);
								loadDistByTsiPremPeril();
								checkBinderExist("N");
							 }
				  		}
					});
	} 	
	
	function updateGIUWS017DistSpct1(distNo){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "updateGIUWS017DistSpct1",
					distNo : distNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Please wait ...");
				},
				onComplete:function(response){
					hideNotice();
					checkErrorOnResponse(response);
				}	
			});	
		}catch(e){
			showErrorMessage("getListing", e);
		}
	}
	
	/*+ Menu +*/
	$("distByTsiPremPerilExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});

	/*+ B2502 Block - GIPI_POLBASIC_POL_DIST_V1 +*/
	$("hrefPolicyNo").observe("click", function() {
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveDistByTsiPremPeril, 
				function(){
					changeTag = 0;
					//showPolbasicPolDistV1Listing("showV1ListDistByTsiPremPeril&ajax=1");
					showGIUWS017PolDistV1LOV(); // andrew - 12.5.2012
				},
				"");
		}else{
			//showPolbasicPolDistV1Listing("showV1ListDistByTsiPremPeril&ajax=1");
			showGIUWS017PolDistV1LOV(); // andrew - 12.5.2012
		}
	});

	$("lblBookingDateDist").show();
	$("bookingDateDist").show();

	/* sets form field values of dist share */
	function setDistShareFormFields(obj){
		try{
			selectedGiuwWPerildsDtl 	= obj == null ? {} : obj;	
			$("txtDspTrtyName").value 	= obj == null ? "" : unescapeHTML2(obj.trtyName);
			$("txtDistSpct").value 		= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 9);
			$("txtDistTsi").value 		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			$("txtDistSpct1").value 	= obj == null ? "" : obj.distSpct1 == null ? "" : formatToNthDecimal(obj.distSpct1, 9);
			$("txtDistPrem").value 		= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);
			$("shareCd").value			= obj == null ? "" : obj.shareCd == null ? "" : obj.shareCd;
			$("c080lineCd").value		= obj == null ? "" : obj.lineCd == null ? "" : obj.lineCd;
			
			$("btnAddShare").value		= obj == null ? "Add" : "Update";
			obj == null ? disableButton($("btnDeleteShare")) : enableButton($("btnDeleteShare"));

			if (obj == null){
				enableButton("btnTreaty");
				enableButton("btnShare");
				if (selectedGiuwPolDist != null){
					if (selectedGiuwPolDist.distFlag == 3 || selectedGiuwPolDist.distFlag == null || selectedGiuwPolDist.giuwWperildsExist == "N"){ //polDistGroup.distSeqNo == null){
						disableButton("btnTreaty");
						disableButton("btnShare");
						disableButton("btnAddShare");
						disableButton("btnDeleteShare");
						disableButton("btnPostDist");
					}
					if (selectedGiuwPolDist.distFlag == 2) {
						disableButton("btnPostDist");
					}
				}
			}else{
				disableButton("btnTreaty");
				disableButton("btnShare");
			}
		}catch(e){
			showErrorMessage("setDistShareFormFields", e);
		}
	}
	
	/* clear share fields */
	function clearShare(){
		try{
			setDistShareFormFields(null);
			unClickRow("distShareTable");
		}catch(e){
			showErrorMessage("clearShare", e);
		}
	}
	
	/* clear form */
	function clearForm(){
		try{
			unClickRow("distListingTable");
			unClickRow("distGroupListingTable");
			unClickRow("distPerilTable");
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}

	/* 
	* generate row content for distribution group
	* accepts a GIUW_WPERILDS object as parameter
	*/
	function prepareDistGroupRowContent(obj){
		try{
			var groupNo 	= obj == null ? "" : obj.distSeqNo;
			var currency 	= obj == null ? "" : nvl(obj.currencyDesc, "-");
			
			var content = 
				'<label style="width: 100px; text-align: right; margin-right: 50px;">'+ groupNo.toPaddedString(2) +'</label>' +				
				'<label style="width: 600px; text-align: left;">'+ unescapeHTML2(currency) +'</label>';

			return content;
		}catch(e){
			showErrorMessage("prepareDistGroupRowContent", e);
		}
	}
	
	/* creates dist group row */
	function createDistGroupRow(obj) {
		try{
			if($("rowDistGroup" + obj.distNo + "_" + obj.distSeqNo) == undefined){
				// create and add content div
				var content = prepareDistGroupRowContent(obj);
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowDistGroup" + obj.distNo + "_" + obj.distSeqNo);
				newDiv.setAttribute("name", "rowDistGroup");
				newDiv.setAttribute("distNo", obj.distNo);
				newDiv.setAttribute("groupNo", obj.distSeqNo);
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display : none;");

				newDiv.update(content);

				$("distGroupListing").insert({bottom : newDiv});

				// add observer
				loadRowMouseOverMouseOutObserver(newDiv);
				
				newDiv.observe("click",
						function() {
							newDiv.toggleClassName("selectedRow");

							if (newDiv.hasClassName("selectedRow")) {
								// remove classname of other rows							
								($$("div#distGroupListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");

								// deselect highlighted rows
								unClickRow("distPerilTable");
								unClickRow("distShareTable");

								// show groups with similar distNo						
								($("distPerilListing").childElements()).invoke("hide"); //distGroupListingTable
								($$("div#distPerilListing div[groupNo='"+ newDiv.readAttribute("groupNo") +"']")).invoke("show");

								// hide all sub-rows
								($("distShareListing").childElements()).invoke("hide");
								$("distShareTable").hide();

								// set selected pol dist group object
								selectedGiuwPolDistGroup = obj;
								// show tables
								resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");

								// reset share fields
								setDistShareFormFields(null);
								if (enableViewDist) {
									enableButton("btnViewDist");
								}else{
									disableButton("btnViewDist");
								}
							} else {
								selectedGiuwPolDistGroup = null;

								// deselect highlighted rows
								unClickRow("distPerilTable");
								unClickRow("distShareTable");

								// hide all rows in peril & show rows related to the selected group
								($("distPerilListing").childElements()).invoke("hide");
								($("distShareListing").childElements()).invoke("hide");
								$("distPerilTable").hide();
								$("distShareTable").hide();

								// reset share fields
								setDistShareFormFields(null);
								disableButton("btnViewDist");
							}
						});
			}	
		}catch(e){
			showErrorMessage("createDistGroupRow", e);
		}
	}

	/* 
	* generate row content for distribution peril
	* accepts a GIUW_WPERILDS object as parameter
	*/
	function prepareDistPerilRowContent(obj){
		try{			
			var perilName 	= obj == null ? "" : unescapeHTML2(obj.perilName); 
			var perilTsi 	= obj == null ? "" : obj.tsiAmt == null ? "" : formatCurrency(obj.tsiAmt);
			var perilPrem 	= obj == null ? "" : obj.premAmt == null ? "" : formatCurrency(obj.premAmt);
				
			var content =				
				'<label style="width: 250px; text-align: left; margin-right: 5px; ">'+ perilName +'</label>' +
				'<label style="width: 250px; text-align: right; margin-right: 10px;">'+ perilTsi +'</label>' +
				'<label style="width: 250px; text-align: right; margin-right: 10px;">'+ perilPrem +'</label>';

			return content;				
		}catch(e){
			showErrorMessage("prepareDistPerilRowContent", e);
		}
	}

	/* 
	* generate row content for dist share
	* accepts a GIUW_WPERILDS_DTL object as parameter
	*/
	function prepareDistShareRowContent(obj){
		try{			
			var treatyName 		= obj == null ? "" : unescapeHTML2(obj.trtyName); 
			var percentShare	= obj == null ? "" : obj.distSpct == null ? "&nbsp;" : formatToNthDecimal(obj.distSpct, 9);
			var sumInsured		= obj == null ? "" : obj.distTsi == null ? "&nbsp;" : formatCurrency(obj.distTsi);
			obj.distSpct1 		= obj.distSpct1 == null ? obj.distSpct : obj.distSpct1;
			var percentPremium	= obj == null ? "" : obj.distSpct1 == null ? "&nbsp;" : formatToNthDecimal(obj.distSpct1, 9);
			var premium			= obj == null ? "" : obj.distPrem == null ? "&nbsp;" : formatCurrency(obj.distPrem);
			var content =				
				'<label style="width: 20%; text-align: left; margin-right: 4px; margin-left: 5px;">' + treatyName + '</label>' +
				'<label style="width: 19.5%; text-align: right; margin-right: 4px;">' + percentShare + '</label>' +
				'<label style="width: 19%; text-align: right; margin-right: 4px;">' + sumInsured + '</label>' +
				'<label style="width: 19.5%; text-align: right; margin-right: 4px;">' + percentPremium + '</label>' +
				'<label style="width: 19%; text-align: right; margin-right: 4px;">' + premium + '</label>';
			return content;
		}catch(e){
			showErrorMessage("prepareDistShareRowContent", e);
		}
	}

	/* function to call when dist share row is clicked */
	function clickDistShareRow(newDiv, obj) {
		newDiv.toggleClassName("selectedRow");

		if (newDiv.hasClassName("selectedRow")) {
			// remove classname of other rows							
			($$("div#distShareListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");

			// set selected pol dist share object
			selectedGiuwWPerildsDtl = obj;

			setDistShareFormFields(obj);

			distShareRecordStatus = "QUERY";
		} else {
			selectedGiuwWPerildsDtl = {};

			setDistShareFormFields(null);

			distShareRecordStatus = "INSERT";
		}
	}	
	
	/* creates dist share row */
	function createDistShareRow(obj) {
		try{
			// create and add content div
			var content = prepareDistShareRowContent(obj);
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowDistShare" + obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd + "_" + obj.shareCd);
			newDiv.setAttribute("id1", obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd);
			newDiv.setAttribute("name", "rowDistShare");
			newDiv.setAttribute("distNo", obj.distNo);
			newDiv.setAttribute("groupNo", obj.distSeqNo);
			newDiv.setAttribute("perilCd", obj.perilCd);
			newDiv.setAttribute("shareCd", obj.shareCd);
			newDiv.setAttribute("lineCd", obj.lineCd);
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display : none;");
			
			newDiv.update(content);

			$("distShareListing").insert({bottom : newDiv});

			// add observer
			loadRowMouseOverMouseOutObserver(newDiv);
			
			newDiv.observe("click",
					function() {
						clickDistShareRow(newDiv, obj);
					});
			
			postQueryAll();			
		}catch(e){
			showErrorMessage("createDistShareRow", e);
		}
	}

	function computeTotalShareAmount(){
		try{
			if (selectedGiuwWPerilds == null) return;
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistSpct1 = 0;
			var sumDistPrem = 0;
			
			var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1 && nvl(selectedGiuwWPerilds.distNo,null) == objArray[a].distNo && objArray[a] != null){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1 && nvl(selectedGiuwWPerilds.distSeqNo,null) == objArray[a].giuwWPerilds[b].distSeqNo 
								&& objArray[a].giuwWPerilds[b] != null){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].perilCd == nvl(selectedGiuwWPerilds.perilCd,null) 
										&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 
										&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c] != null){
									sumDistSpct = (parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0)));
									sumDistTsi = (parseFloat(sumDistTsi) + parseFloat(nvl(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,"").replace(/,/g, ""),0)));
									sumDistSpct1 = (parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0)));
									sumDistPrem = (parseFloat(sumDistPrem) + parseFloat(nvl(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,"").replace(/,/g, ""),0)));
								}	
							}
						}
					}
				}
			}	
			sumDistSpct = roundNumber(sumDistSpct, 9);
			sumDistSpct1 = roundNumber(sumDistSpct1, 9);
			
			totalDistSpct = sumDistSpct;
			totalDistTsi = sumDistTsi;
			totalDistSpct1 = sumDistSpct1;
			totalDistPrem = sumDistPrem;

			$("totalDistSpct").innerHTML = formatToNthDecimal(sumDistSpct, 9);
			$("totalDistTsi").innerHTML = formatCurrency(sumDistTsi);
			$("totalDistSpct1").innerHTML = formatToNthDecimal(sumDistSpct1, 9);
			$("totalDistPrem").innerHTML = formatCurrency(sumDistPrem);
		}catch(e){
			showErrorMessage("computeTotalShareAmount", e);
		}
	}	
	
	/* creates peril row */
	function createDistPerilRow(obj) {
		try{
			// create and add content div
			var content = prepareDistPerilRowContent(obj);
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowDistPeril" + obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd);
			newDiv.setAttribute("name", "rowDistPeril");
			newDiv.setAttribute("distNo", obj.distNo);
			newDiv.setAttribute("groupNo", obj.distSeqNo);
			newDiv.setAttribute("perilCd", obj.perilCd);
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display : none;");

			newDiv.update(content);

			$("distPerilListing").insert({bottom : newDiv});

			// create dist share rows
			for (var i = 0; i < obj.giuwWPerildsDtl.length; i++) {
				i==(obj.giuwWPerildsDtl.length-1) ? isMagic3 = true : isMagic3 = false;
				createDistShareRow(obj.giuwWPerildsDtl[i]);
			}

			// add observer
			loadRowMouseOverMouseOutObserver(newDiv);
			
			newDiv.observe("click",
					function() {
						newDiv.toggleClassName("selectedRow");

						if (newDiv.hasClassName("selectedRow")) {
							var id1 = obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd;	
							// remove classname of other rows							
							($$("div#distPerilListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");

							// deselect highlighted rows
							unClickRow("distShareTable");

							// show groups with similar distNo
							($("distShareListing").childElements()).invoke("hide"); //distGroupListingTable
							($$("div#distShareListing div[id1='" + id1 + "']")).invoke("show");

							// set selected peril object
							selectedGiuwWPerilds = obj;

							// show tables
							resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

							// reset share fields
							setDistShareFormFields(null);

							if($("distShareTable").visible){
								computeTotalShareAmount();
								$("distShareTable").setStyle("height: " + ($("distShareTable").getHeight() + 31) + "px;");
							}
							enableOrDisableFields("enable");
						} else {
							selectedGiuwWPerilds = null;

							// deselect highlighted rows
							unClickRow("distShareTable");

							// hide all rows in peril & show rows related to the selected group
							($("distShareListing").childElements()).invoke("hide");
							$("distShareTable").hide();

							// reset share fields
							setDistShareFormFields(null);
							enableOrDisableFields("disable");
						}
					});
		}catch(e){
			showErrorMessage("createDistPerilRow", e);
		}
	}

	/* 
	* generate row content for distribution
	* accepts a GIUW_POL_DIST object as parameter
	*/
	function prepareDistRowContent(obj) {
		try{
			var content = 
				'<label style="width: 160px; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
				'<label style="width: 280px; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+'-'+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
				'<label style="width: 280px; text-align: left; ">'+nvl(obj.multiBookingMm,'')+'-'+nvl(obj.multiBookingYy,'')+'</label>';

			return content;				
		}catch(e){
			showErrorMessage("prepareDistRowContent", e);
		}
	}
	
	/* creates dist row */
	var selectedGiuwWPerilds = null;//added by steven 06.10.2014
	function createDistRow(pGiuwPolDist) {
		try{
			// create and add content div
			var content = prepareDistRowContent(pGiuwPolDist);
			var newDiv = new Element("div");
	
			newDiv.setAttribute("id", "rowDist" + pGiuwPolDist.parId + "_" + pGiuwPolDist.distNo);
			newDiv.setAttribute("name", "rowDist");
			newDiv.setAttribute("parId", pGiuwPolDist.parId);
			newDiv.setAttribute("distNo", pGiuwPolDist.distNo);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
	
			$("distListing").insert({bottom : newDiv});
	
			// create dist group rows and peril rows
			for (var i = 0; i < pGiuwPolDist.giuwWPerilds.length; i++) {
				i==(pGiuwPolDist.giuwWPerilds.length-1) ? isMagic2 = true : isMagic2 = false;
				createDistGroupRow(pGiuwPolDist.giuwWPerilds[i]);
				createDistPerilRow(pGiuwPolDist.giuwWPerilds[i]);
				if (isMagic1 == true && isMagic2 == true){
					if (nvl(pGiuwPolDist.giuwWperildsDtlExist,"N") == "N"){
						isMagic3 = true;
						postQueryAll();
					}	 
				}
			}
	
			// add observer
			loadRowMouseOverMouseOutObserver(newDiv);
			newDiv.observe("click",
				function() {
					newDiv.toggleClassName("selectedRow");
	
					if (newDiv.hasClassName("selectedRow")) {
						// remove classname of other rows							
						($$("div#distListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");
	
						// deselect highlighted rows
						unClickRow("distGroupListingTable");
						unClickRow("distPerilTable");
						unClickRow("distShareTable");
	
						// show groups with similar distNo						
						($("distGroupListing").childElements()).invoke("hide"); //distGroupListingTable
						($$("div#distGroupListing div[distNo='"+ newDiv.readAttribute("distNo") +"']")).invoke("show");
	
						// hide all rows in peril & show rows related to the selected group
						($("distPerilListing").childElements()).invoke("hide");
						($("distShareListing").childElements()).invoke("hide");
						$("distPerilTable").hide();
						$("distShareTable").hide();
	
						// set selected pol dist object
						selectedGiuwPolDist = pGiuwPolDist;
	
						// show tables
						resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
	
						// reset share fields
						setDistShareFormFields(null);
						
						selectedGiuwWPerilds = pGiuwPolDist.giuwWPerilds;//added by steven
					} else {
						selectedGiuwPolDist = null;
	
						// deselect highlighted rows
						unClickRow("distGroupListingTable");
						unClickRow("distPerilTable");
						unClickRow("distShareTable");
	
						// hide all rows in peril & show rows related to the selected group
						($("distGroupListing").childElements()).invoke("hide");
						($("distPerilListing").childElements()).invoke("hide");
						($("distShareListing").childElements()).invoke("hide");
						$("distGroupListingTable").hide();
						$("distPerilTable").hide();
						$("distShareTable").hide();
	
						// reset share fields
						setDistShareFormFields(null);
					}
					whenNewRecordInstanceB2502(selectedGiuwPolDist);
					postQueryC080(selectedGiuwPolDist);
				});
			
			resizeTableBasedOnVisibleRows("distListingTable", "distListing");
		}catch(e){
			showErrorMessage("createDistRow", e);	
		}
	}

	function postQueryAll(){
		try{
			if (isMagic1 && isMagic2 && isMagic3){
				if ($("distListing").down("div", 0) != null){ 
					if (!$("distListing").down("div", 0).hasClassName("selectedRow")){
						setTimeout(function(){fireEvent($("distListing").down("div", 0), "click");}, 200);
						setTimeout(function(){
							if ($("distGroupListing").down("div", 0) != null){ 
								if (!$("distGroupListing").down("div", 0).hasClassName("selectedRow") && $("distListing").down("div", 0).hasClassName("selectedRow")){
									fireEvent($("distGroupListing").down("div", 0), "click");
// 									createDistPerilRow2($("distGroupListing").down("div", 0).getAttribute("groupNo"));
								}
							}		
							}, 300);
						setTimeout(function(){
							if ($("distPerilListing").down("div", 0) != null){ 
								if (!$("distPerilListing").down("div", 0).hasClassName("selectedRow") && $("distListing").down("div", 0).hasClassName("selectedRow") && $("distGroupListing").down("div", 0).hasClassName("selectedRow")){
									fireEvent($("distPerilListing").down("div", 0), "click");
								}
							}		
							}, 400);
					}
				}
				isMagic1 = false;
				isMagic2 = false;
				isMagic3 = false;
			}
		}catch(e){
			showErrorMessage("postQueryAll", e);
		}		
	}	

	function postQueryC080(polDist){
		try{
			if (nvl(polDist,null) != null){
				if (nvl(polDist.giuwWperildsExist,"Y") == "Y"){
					if (nvl(polDist.giuwWperildsDtlExist,"Y") == "N"){
						if (objGIPIPolbasicPolDistV1.polFlag == 2 || objGIPIPolbasicPolDistV1.parType == "E" || $F("txtDistFlag") == 3){ //added by steven 06.16.2014
							null;
						}else{
							showMessageBox("There was an error encountered in distribution records, to correct this error please recreate using Set-Up Groups For Distribution(Item).", "I");
						}	
					}	
				}else if (nvl(polDist.giuwWperildsExist,"Y") == "N"){
					if (objGIPIPolbasicPolDistV1.polFlag == 2 || objGIPIPolbasicPolDistV1.parType == "E" || $F("txtDistFlag") == 3){ //added by steven 06.16.2014
						null;
					}else{
						showMessageBox("There was an error encountered in distribution records, to correct this error please recreate using Set-Up Groups For Distribution(Item).", "I");
					}		
				}	
			}
		}catch(e){
			showErrorMessage("postQueryC080", e);	
		}	
	}	

	function whenNewRecordInstanceB2502(polDist){
		try{
			var obj = objGIPIPolbasicPolDistV1;
			//var polDistGroup = selectedGiuwPolDistGroup;
			
			if (nvl(polDist,null) == null){
				disableButton("btnPostDist");
				disableButton("btnViewDist");
			}else{
				if (nvl(obj.endtSeqNo,"") != "" && nvl(obj.endtSeqNo,"") != "0"){
					if(checkUserModule('GIUWS017')){
						enableButton("btnViewDist");
						enableViewDist = true;
					}else{
						disableButton("btnViewDist");
						enableViewDist = false;
					}
				}else{
					disableButton("btnViewDist");
				}

				if (polDist.distFlag == 3 || polDist.distFlag == null || polDist.giuwWperildsExist == "N"){ //polDistGroup.distSeqNo == null){
					disableButton("btnTreaty");
					disableButton("btnShare");
					disableButton("btnAddShare");
					disableButton("btnDeleteShare");
					disableButton("btnPostDist");
				}else{
					enableButton("btnTreaty");
					enableButton("btnShare");
					if (nvl(polDist.giuwWpolicydsDtlExist,"N") == "Y"){
						enableButton("btnPostDist");
					}else{
						disableButton("btnPostDist");
					}		
				}		
			}
			if ($F("txtDistFlag") == 2) {
				disableButton("btnPostDist");
			}
		}catch(e){
			showErrorMessage("whenNewRecordInstanceB2502", e);	
		}
	}	
	
	$("btnLoadRecords").observe("click", function() {
		// remove all previous records first
		($("distListing").childElements()).each(function(row) {
			row.remove();
		});

		($("distGroupListing").childElements()).each(function(row) {
			row.remove();
		});
		
		($("distPerilListing").childElements()).each(function(row) {
			row.remove();
		});
		
		($("distShareListing").childElements()).each(function(row) {
			row.remove();
		});

		resizeTableBasedOnVisibleRows("distListingTable", "distListing");
		resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
		resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
		resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

		// reset variables
		resetVariables();

		// create new rows
		for (var i = 0; i < objUW.hidObjGIUWS017.GIUWPolDist.length; i++) {
			i==(objUW.hidObjGIUWS017.GIUWPolDist.length-1) ? isMagic1 = true : isMagic1 = false;
			createDistRow(objUW.hidObjGIUWS017.GIUWPolDist[i]);
			if (isMagic1 == true){
				if (nvl(objUW.hidObjGIUWS017.GIUWPolDist[i].giuwWperildsExist,"N") == "N"){
					isMagic2 = true;
					if (nvl(objUW.hidObjGIUWS017.GIUWPolDist[i].giuwWperildsDtlExist,"N") == "N"){
						isMagic3 = true;
						postQueryAll();
					}	 
				}	
			}
		}

		// clear form
		clearForm();
	});

	/* % Share Sum Insured*/ 
	initPreTextOnField("txtDistSpct");
	$("txtDistSpct").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012	
		try{
			if (!checkIfValueChanged("txtDistSpct")) return;
				
			var distSpct = $F("txtDistSpct");	
			if(!(distSpct.empty())){
				/*  Check that %Share is not greater than 100 */ 
				if(parseFloat(distSpct) > 100){
					customShowMessageBox("TSI %Share cannot exceed 100.", "I", "txtDistSpct");
					return false;
				}
				if(parseFloat(distSpct) < 0){
					customShowMessageBox("TSI %Share must be greater than zero.", "I", "txtDistSpct");
					return false;
				}

				//comment ko muna kasi wala sa forms ibalik nalang if kelangan - nok
				/*if ($F("btnAddShare") == "Update") totalDistSpct = nvl(totalDistSpct-parseFloat(nvl(selectedGiuwWPerildsDtl.distSpct,0)),0);
				if ((parseFloat(distSpct) + parseFloat(totalDistSpct)) > 100){
					$("txtDistSpct").value = getPreTextValue("txtDistSpct");
					customShowMessageBox("TSI %Share cannot exceed 100.", "I", "txtDistSpct");
					return false;
				}*/ 
				
				/* Compute DIST_TSI if the TSI amount of the master table
				 * is not equal to zero.  Otherwise, nothing happens.  */
	
				if(selectedGiuwWPerilds.tsiAmt != 0){
					var txtDistTsi = nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0);
					//comment ko muna kasi wala sa forms ibalik nalang if kelangan - nok
					/*if (txtDistTsi > unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt)){
						$("txtDistSpct").value = getPreTextValue("txtDistSpct");
						customShowMessageBox("TSI must not exceed "+formatCurrency(selectedGiuwWPerilds.tsiAmt)+".", "I", "txtDistSpct");
						return false;
					}*/
					$("txtDistTsi").value = formatCurrency(roundNumber(txtDistTsi,2));
					//comment ko muna kasi wala sa forms ibalik nalang if kelangan - nok
					/*if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){
						customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
						return false;
					}*/	
				}else{
					$("txtDistTsi").value = "0.00"; 
				}
				
				/* Compute dist_prem  */
				//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0));
			}
		}catch(e){
			showErrorMessage("% Share Sum Insured on blur.", e);
		}
	});	

	/* Sum Insured */ 
	initPreTextOnField("txtDistTsi");	
	$("txtDistTsi").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		try{
			if (!checkIfValueChanged("txtDistTsi")) return;
			
			var distTsi = $F("txtDistTsi");
			if(!(distTsi.empty())){
				/* Check that dist_tsi does is not greater than tsi_amt  */
				if(Math.abs(unformatCurrencyValue(distTsi)) > Math.abs(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt))){
					customShowMessageBox("Sum insured cannot exceed TSI.", "I", "txtDistTsi");
					return false;
				}

				//comment ko muna kasi wala sa forms ibalik nalang if kelangan - nok
				/*if ($F("btnAddShare") == "Update") totalDistTsi = nvl(totalDistTsi-parseFloat(nvl(selectedGiuwWPerildsDtl.distTsi,0)),0);
				if (selectedGiuwWPerilds.tsiAmt != 0){
					if ((totalDistTsi+unformatCurrency("txtDistTsi")) > unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt)){
						$("txtDistTsi").value = getPreTextValue("txtDistTsi");
						customShowMessageBox("Share cannot exceed "+formatCurrency(getPreTextValue("txtDistTsi"))+".", "I", "txtDistTsi");
						return false;
					}
				}*/
				
				/* Compute dist_spct if the TSI amount of the master table
				** is not equal to zero.  Otherwise, nothing happens.  */
				if(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt) > 0){
					if(unformatCurrencyValue(distTsi) < 0){
						customShowMessageBox("Sum insured must be greater than zero.", "I", "txtDistTsi");
						return false;
					}
					$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0) * 100 , 9);
				}else if(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt) < 0){
					if(unformatCurrencyValue(distTsi) >= 0){
						customShowMessageBox("Sum insured must be less than zero.", "I", "txtDistTsi");
						return false;
					}
					$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0) * 100 , 9);
				}else{
					$("txtDistTsi").value = formatCurrency("0");
				}
				
				/* Compute dist_prem  */
				//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0));			   
			}
		}catch(e){
			showErrorMessage("Sum Insured on blur.", e);
		}
	});

	/* % Share Premium*/ 
	initPreTextOnField("txtDistSpct1");
	$("txtDistSpct1").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012	
		try{
			if (!checkIfValueChanged("txtDistSpct1")) return;
				
			var distSpct1 = $F("txtDistSpct1");	
			if(!(distSpct1.empty())){
				/*  Check that %Share is not greater than 100 */ 
				if(parseFloat(distSpct1) > 100){
					customShowMessageBox("Premium %Share cannot exceed 100.", "I", "txtDistSpct1");
					return false;
				}
				if(parseFloat(distSpct1) < 0){
					customShowMessageBox("Premium %Share must be greater than zero.", "I", "txtDistSpct1");
					return false;
				}

				//comment ko muna kasi wala sa forms ibalik nalang if kelangan - nok
				/*if ($F("btnAddShare") == "Update") totalDistSpct1 = nvl(totalDistSpct1-parseFloat(nvl(selectedPerilDtl.distSpct1,0)),0);
				if ((parseFloat(distSpct1) + parseFloat(totalDistSpct1)) > 100){
					$("txtDistSpct1").value = getPreTextValue("txtDistSpct1");
					customShowMessageBox("%Share cannot exceed 100.", "I", "txtDistSpct1");
					return false;
				}*/
				
				
				/* Compute DIST_TSI if the TSI amount of the master table
				 * is not equal to zero.  Otherwise, nothing happens.  */
				//comment ko muna kasi wala sa forms ibalik nalang if kelangan - nok
				/*if(selectedGiuwWPerilds.premAmt != 0){
					var txtDistPrem = nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0);
					if (txtDistPrem > unformatCurrencyValue(selectedGiuwWPerilds.premAmt)){
						$("txtDistSpct1").value = getPreTextValue("txtDistSpct1");
						customShowMessageBox("TSI must not exceed "+formatCurrency(selectedGiuwWPerilds.premAmt)+".", "I", "txtDistSpct1");
						return false;
					}
					$("txtDistPrem").value = formatCurrency(roundNumber(txtDistPrem,2));
					if (roundNumber(unformatCurrency("txtDistPrem"), 2) == 0){
						customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistPrem");
						return false;
					}	
				}else{
					$("txtDistPrem").value = "0.00"; 
				}*/

				/* Compute dist_prem  */
				$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0));
			}
		}catch(e){
			showErrorMessage("% Share Premium on blur.", e);
		}
	});	

	/* Sum Insured */ 
	initPreTextOnField("txtDistPrem");	
	$("txtDistPrem").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		try{
			if (!checkIfValueChanged("txtDistPrem")) return;
			
			var distPrem = $F("txtDistPrem");
			if(!(distPrem.empty())){
				/* Check that dist_tsi does is not greater than tsi_amt  */
				if(Math.abs(unformatCurrencyValue(distPrem)) > Math.abs(unformatCurrencyValue(selectedGiuwWPerilds.premAmt))){
					customShowMessageBox("Premium amount cannot exceed Premium.", "I", "txtDistPrem");
					return false;
				}

				/* Compute dist_spct if the TSI amount of the master table
				** is not equal to zero.  Otherwise, nothing happens.  */
				if(unformatCurrencyValue(selectedGiuwWPerilds.premAmt) > 0){
					if(unformatCurrencyValue(distPrem) < 0){
						customShowMessageBox("Premium Amount must not be less than zero.", "I", "txtDistPrem");
						return false;
					}
					$("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrencyValue(distPrem),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0) * 100 , 9);
				}else if(unformatCurrencyValue(selectedGiuwWPerilds.premAmt) < 0){
					if(unformatCurrencyValue(distPrem) >= 0){
						customShowMessageBox("Premium must be less than zero.", "I", "txtDistPrem");
						return false;
					}
					$("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrencyValue(distPrem),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0) * 100 , 9);
				}else{
					$("txtDistPrem").value = formatCurrency("0");
				}
				
			}
		}catch(e){
			showErrorMessage("Premium on blur.", e);
		}
	});

	/* functions used in treaty LOV */
	function getListing(){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "getDistListing2", //modified by robert 04.22.2013
					globalParId: (selectedGiuwPolDist == null) ? 0 : selectedGiuwPolDist.parId,
					nbtLineCd: (selectedGiuwWPerildsDtl == null) ? null : selectedGiuwWPerildsDtl.lineCd,
					lineCd: ($("txtPolDistV1LineCd") == null || $("txtPolDistV1LineCd") == undefined) ? null : $F("txtPolDistV1LineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					distListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				}	
			});	
		}catch(e){
			showErrorMessage("getListing", e);
		}
	}

	function generateOverlayLovRow(id, objArray, width){
		try{
			for(var a=0; a<objArray.length; a++){
				var newDiv = new Element("div");
				newDiv.setAttribute("id", a);
				newDiv.setAttribute("name", id+"LovRow");
				newDiv.setAttribute("val", objArray[a].trtyName);
				newDiv.setAttribute("cd", nvl(objArray[a].shareCd,objArray[a].trtyCd));
				newDiv.setAttribute("lineCd", objArray[a].lineCd);
				newDiv.setAttribute("nbtShareType", objArray[a].shareType);
				newDiv.setAttribute("class", "lovRow");
				newDiv.setStyle("width:98%; margin:auto;");
				
				var codeDiv = new Element("label");
				codeDiv.setStyle("width:20%; float:left;");
				codeDiv.setAttribute("title", nvl(nvl(objArray[a].shareCd,objArray[a].trtyCd),''));
				codeDiv.update(nvl(nvl(objArray[a].shareCd,objArray[a].trtyCd),'&nbsp;'));
				
				var shareDiv = new Element("label");
				shareDiv.setStyle("width:60%; float:left;");
				shareDiv.setAttribute("title", nvl(objArray[a].trtyName,''));
				shareDiv.update(nvl(objArray[a].trtyName,'&nbsp;'));
	
				var lineDiv = new Element("label");
				lineDiv.setStyle("width:20%; float:left;");
				lineDiv.setAttribute("title", nvl(objArray[a].lineCd,''));
				lineDiv.update(nvl(objArray[a].lineCd,'&nbsp;'));
				
				newDiv.update(codeDiv);
				newDiv.insert({bottom: shareDiv});
				newDiv.insert({bottom: lineDiv});
				$("lovListingDiv").insert({bottom: newDiv});
				var header1 = generateOverlayLovHeader('20%', 'Code');
				var header2 = generateOverlayLovHeader('60%', 'Share');
				var header3 = generateOverlayLovHeader('20%', 'Line');
				$("lovListingDivHeader").innerHTML = header1+""+header2+""+header3;
				$("lovListingMainDivHeader").show();
			}
		}catch(e){
			showErrorMessage("generateOverlayLovRow", e);
		}
	}	

	function startLOV(id, title, objArray, width){
		try{
			if (selectedGiuwWPerilds == null) {
				showMessageBox("Please select peril first.", imgMessage.INFO);
			} else if (selectedGiuwWPerildsDtl == null) {
				return;
			} else {
				var copyObj = objArray.clone();	
				var copyObj2 = objArray.clone();	
				var selGrpObjArray = selectedGiuwWPerilds.giuwWPerildsDtl.clone(); //objGIUWWPerildsDtl.clone();
				selGrpObjArray = selGrpObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
				var share = selectedGiuwWPerildsDtl;
				for(var a=0; a<selGrpObjArray.length; a++){
					for(var b=0; b<copyObj.length; b++){
						if (selGrpObjArray[a].shareCd == copyObj[b].shareCd && selGrpObjArray[a].perilCd == selectedGiuwWPerilds.perilCd){
							copyObj.splice(b,1);
							b--;
						}	
					}	
				}
				if (nvl(share.recordStatus,null) == 0){
					for(var b=0; b<copyObj2.length; b++){
						if (nvl(share.shareCd,'') == copyObj2[b].shareCd) {
							copyObj.push(copyObj2[b]);
						}	
					}
				}
				if (nvl(copyObj.length,0) <= 0){
					customShowMessageBox("List of Values contains no entries.", "E", "txtDspTrtyName");
					return false;
				}
				if (($("contentHolder").readAttribute("src") != id)) {
					initializeOverlayLov(id, title, width);
					generateOverlayLovRow(id, copyObj, width);
					function onOk(){
						var trtyName = unescapeHTML2(getSelectedRowAttrValue(id+"LovRow", "val"));
						if (trtyName == ""){showMessageBox("Please select any share first.", "E"); return;};
						$("txtDspTrtyName").value = trtyName;
						$("txtDspTrtyName").focus();
						$("c080lineCd").value = getSelectedRowAttrValue(id+"LovRow", "lineCd");
						$("shareCd").value = getSelectedRowAttrValue(id+"LovRow", "cd");
						selectedGiuwWPerildsDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");
						selectedGiuwWPerildsDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
						selectedGiuwWPerildsDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");
						hideOverlay();
					}
					observeOverlayLovRow(id);
					observeOverlayLovButton(id, onOk);
					observeOverlayLovFilter(id, copyObj);
				}
				$("filterTextLOV").focus();
			}
		}catch(e){
			showErrorMessage("startLOV", e);
		}
	}
	
	/*
	* create new Object for Dist Share to be added on Object Array
	* if param is SHARE, set obj to selectedGIUWWPerildsDtl, else set to selectedPerilRow*/
	function setShareObject(param) {
		try {
			var objGroup = selectedGiuwPolDist;
			var obj = (param == "SHARE") ? selectedGiuwWPerildsDtl : selectedGiuwWPerilds;
			var newObj = new Object();
			newObj.recordStatus			= obj == null ? null :nvl(obj.recordStatus, null);
			newObj.distNo				= obj == null ? objGroup.distNo :nvl(obj.distNo, objGroup.distNo);
			newObj.distSeqNo 			= obj == null ? objGroup.distSeqNo :nvl(obj.distSeqNo, objGroup.distSeqNo);
			newObj.lineCd 				= obj == null ? "" :nvl($F("c080lineCd"), "");
			newObj.perilCd				= obj == null ? null : nvl(obj.perilCd, null);
			newObj.shareCd 				= obj == null ? "" :nvl($F("shareCd"), "");
			newObj.distSpct				= escapeHTML2($F("txtDistSpct"));
			newObj.distTsi				= escapeHTML2(unformatNumber($F("txtDistTsi")));
			newObj.distPrem				= escapeHTML2(unformatNumber($F("txtDistPrem")));
			newObj.annDistSpct			= escapeHTML2($F("txtDistSpct"));
			newObj.annDistTsi			= (nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100; //escapeHTML2(unformatNumber($F("txtDistTsi")));
			newObj.distGrp				= obj == null ? "1" :nvl(obj.distGrp, "1");
			newObj.distSpct1			= escapeHTML2($F("txtDistSpct1"));
			newObj.arcExtData			= obj == null ? "" :nvl(obj.arcExtData, "");
			newObj.trtyCd				= obj == null ? "" :nvl(obj.dspTrtyCd, "");
			newObj.trtyName 			= escapeHTML2($F("txtDspTrtyName"));
			newObj.trtySw				= obj == null ? "" :nvl(obj.dspTrtySw, "");
			return newObj; 
		}catch(e){
			showErrorMessage("setShareObject", e);
		}
	}
	
	/* add dist share */
	function addShare(){
		try{
			var changeMade = false;
			if (String(nvl((selectedGiuwPolDist == null) ? null : selectedGiuwPolDist.distNo, "")).blank()){
				showMessageBox("Please select distribution first.", "I");
				return false;
			}
			if (String(nvl((selectedGiuwPolDistGroup == null) ? null : selectedGiuwPolDistGroup.distNo, "")).blank()){
				showMessageBox("Please select distribution group first.", "I");
				return false;
			}	
			if (String(nvl((selectedGiuwWPerilds == null) ? null : selectedGiuwWPerilds.perilCd, "")).blank()){
				showMessageBox("Please select peril first.", "I");
				return false;
			}
			
			if(!checkAllRequiredFieldsInDiv("distShareDiv")){ //added by steven 06.10.2014
				return false;
			}
			
			if (parseFloat($F("txtDistSpct")) <= 0 && parseFloat($F("txtDistSpct1")) <= 0) {
				customShowMessageBox("TSI % Share and Premium % Share should not be both zero.", "E", "txtDistSpct1");
				return false;
			}
			if (parseFloat($F("txtDistSpct")) > 100){
				customShowMessageBox("TSI % Share cannot exceed 100.", "E", "txtDistSpct");
				return false;
			}	
// 			if (parseFloat($F("txtDistSpct")) <= 0){ //remove by steven 06.25.2014 base from TC
// 				customShowMessageBox("TSI % Share must be greater than zero.", "E", "txtDistSpct");
// 				return false;
// 			}
			if (parseFloat($F("txtDistSpct1")) > 100){
				customShowMessageBox("Premium % Share cannot exceed 100.", "E", "txtDistSpct1");
				return false;
			}	
// 			if (parseFloat($F("txtDistSpct1")) <= 0){ //remove by steven 06.25.2014 base from TC
// 				customShowMessageBox("Premium % Share must be greater than zero.", "E", "txtDistSpct1");
// 				return false;
// 			}
// 			if (unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)) != 0){ //remove by steven 07.01.2014 base from TC
// 				$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)),0));
// 				if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){
// 					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
// 					return false;
// 				}	
// 			}
			if (Math.abs($F("txtDistTsi")) > Math.abs(unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)))){
				customShowMessageBox("Sum insured cannot exceed TSI.", "E", "txtDistTsi");
				return false;
			}
// 			if (unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)) > 0){ //remove by steven 07.01.2014 base from TC
// 				if (unformatCurrency("txtDistTsi") <= 0){
// 					customShowMessageBox("Sum insured must be greater than zero.", "E", "txtDistTsi");
// 					return false;
// 				}	
// 			}else 
			if (unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)) < 0){
				if (unformatCurrency("txtDistTsi") >= 0){
					customShowMessageBox("Sum insured must be less than zero.", "E", "txtDistTsi");
					return false;
				}	
			}

			var exists = false;
			if (!exists){
				var newObj  = setShareObject("SHARE");
				if ($F("btnAddShare") == "Update" || $("rowDistShare"+newObj.distNo+"_"+newObj.distSeqNo+"_"+newObj.perilCd+"_"+newObj.shareCd)){
					//on UPDATE records
					var content = prepareDistShareRowContent(newObj);
					var id = nvl(getSelectedRowIdInTable_noSubstring("distShareListing", "rowDistShare"), "rowDistShare"+newObj.distNo+"_"+newObj.distSeqNo+"_"+newObj.perilCd+"_"+newObj.shareCd);
					var distNo = nvl(getSelectedRowAttrValue("rowDistShare", "distNo"), newObj.distNo);
					var distSeqNo = nvl(getSelectedRowAttrValue("rowDistShare", "groupNo"), newObj.distSeqNo);
					var perilCd = nvl(getSelectedRowAttrValue("rowDistShare", "perilCd"), newObj.perilCd);
					var shareCd = nvl(getSelectedRowAttrValue("rowDistShare", "shareCd"), newObj.shareCd);
					$(id).update(content);
					$(id).setAttribute("name", "rowDistShare");
					$(id).setAttribute("distNo", newObj.distNo);
					$(id).setAttribute("groupNo", newObj.distSeqNo);
					$(id).setAttribute("perilCd", newObj.perilCd);
					$(id).setAttribute("shareCd", newObj.shareCd);	
					$(id).setAttribute("id", "rowDistShare"+newObj.distNo+"_"+newObj.distSeqNo+"_"+newObj.perilCd+"_"+newObj.shareCd);

					var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
								if (objArray[a].giuwWPerilds[b].distNo == distNo && objArray[a].giuwWPerilds[b].distSeqNo == distSeqNo && objArray[a].giuwWPerilds[b].recordStatus != -1){
									//Share
									for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
										if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo == distNo 
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo == distSeqNo 
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].perilCd == perilCd 
												&& (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd == shareCd || objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd == newObj.shareCd)
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
											newObj.recordStatus = newObj.recordStatus == 0 ? 0 :1;
											objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c] = newObj;
											changeTag=1;
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
											selectedGiuwWPerilds = objArray[a].giuwWPerilds[b];
											// update click event of this dist share row
											$(id).stopObserving("click");
											loadRowMouseOverMouseOutObserver($(id));
											$(id).observe("click",
													function() {
														clickDistShareRow($(id), newObj);
														computeTotalShareAmount();
													});
											unClickRow("distShareTable");
											changeMade = true;
										}
									}
								}
							}
						}
					}
				}else{
					//on ADD records
					newObj  = setShareObject("PERIL");
					var content = prepareDistShareRowContent(newObj);
					var distNo = newObj.distNo;
					var distSeqNo = newObj.distSeqNo;
					var perilCd = newObj.perilCd;
					var shareCd = newObj.shareCd;
					var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
								if (objArray[a].giuwWPerilds[b].distNo == distNo && 
										objArray[a].giuwWPerilds[b].distSeqNo == distSeqNo && 
										objArray[a].giuwWPerilds[b].recordStatus != -1 &&
										objArray[a].giuwWPerilds[b].perilCd == newObj.perilCd){
									//Share
									addNewJSONObject(objArray[a].giuwWPerilds[b].giuwWPerildsDtl, newObj);
									objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
									selectedGiuwWPerilds = objArray[a].giuwWPerilds[b];
									computeTotalShareAmount();
									break;
								}
							}
						}
					}

					createDistShareRow(newObj);
					if (selectedGiuwPolDistGroup != null && selectedGiuwWPerilds != null) {
						checkTableItemInfoAdditional("distShareTable","distShareListing","rowDistShare","distNo",Number(newObj.distNo),"groupNo",Number(selectedGiuwPolDistGroup.distSeqNo),"perilCd",Number(selectedGiuwWPerilds.perilCd));
						resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
						if($("distShareTable").visible){
							computeTotalShareAmount();
							$("distShareTable").setStyle("height: " + ($("distShareTable").getHeight() + 31) + "px;");
						}
					}
					changeTag = 1;
					changeMade = true;
				}
				clearShare();
				if ($F("txtDistFlag") == 2 && changeMade) {
					enableButton("btnPostDist"); //added by steven 06.20.2014	
				}
			}
		}catch(e){
			showErrorMessage("addShare", e);
		}		
	}

	/* delete dist share */
	function deleteShare(){
		try{
			var changeMade = false;
			if (String(nvl((selectedGiuwPolDist == null) ? null : selectedGiuwPolDist.distNo, "")).blank()){
				showMessageBox("Please select distribution first.", "E");
				return false;
			}
			if (String(nvl((selectedGiuwPolDistGroup == null) ? null : selectedGiuwPolDistGroup.distNo, "")).blank() && varPostSw != "Y"){ // to check if a dist group is selected
				showMessageBox("Please select distribution group first.", imgMessage.ERROR);
				return false;
			}
			if (String(nvl((selectedGiuwWPerilds == null) ? null : selectedGiuwWPerilds.perilCd, "")).blank() && varPostSw != "Y") {
				showMessageBox("Please select peril first.", "E");
				return false;
			}
			if (String(nvl((selectedGiuwWPerildsDtl == null) ? null : selectedGiuwWPerildsDtl.perilCd, "")).blank()  && varPostSw != "Y") {
				showMessageBox("Please select share first.", "E");
				return false;
			}
			$$("div#distShareListing div[name='rowDistShare']").each(function(row){
				if (row.hasClassName("selectedRow")){
					var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
					var distNo = row.readAttribute("distNo");
					var distSeqNo = row.readAttribute("groupNo");
					var perilCd = row.readAttribute("perilCd");
					var shareCd = row.readAttribute("shareCd");
					var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
					
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
								if (objArray[a].giuwWPerilds[b].distNo == distNo && objArray[a].giuwWPerilds[b].distSeqNo == distSeqNo && objArray[a].giuwWPerilds[b].recordStatus != -1){
									//Share
									for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
										if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo == distNo 
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo == distSeqNo 
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].perilCd == perilCd 
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd == shareCd 
												&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
											var delObj = objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c];
											if(delObj.recordStatus != 0 || objArray[a].recordStatus == 0){
												delObj.recordStatus = -1;
											}else if(delObj.recordStatus == 0){
												objArray[a].giuwWPerilds[b].giuwWPerildsDtl.splice(c, 1); //to remove the newly added record that not exist in database
											} 
											changeTag=1;
											changeMade = true;
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
											Effect.Fade(row,{
												duration: .5,
												afterFinish: function(){
													row.remove();
													clearShare();
													computeTotalShareAmount();
													resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
													if($("distShareTable").visible){
														$("distShareTable").setStyle("height: " + ($("distShareTable").getHeight() + 31) + "px;");
													}
												}
											});
										}
									}
								}
							}
						}
					}				
				}
			});
			if ($F("txtDistFlag") == 2 && changeMade) {
				enableButton("btnPostDist"); //added by steven 06.20.2014	
			}
		}catch(e){
			showErrorMessage("deleteShare", e);
		}
	}

	/* the PRE-COMMIT function */
	function procedurePreCommit(){
		try{
			var ok 				= true;
			var ctr 			= 0;
			var sumDistSpct 	= 0;
			var sumDistTsi 		= 0;
			var sumDistSpct1 	= 0;
			var sumDistPrem 	= 0;
			var objArray 		= objUW.hidObjGIUWS017.GIUWPolDist;
			
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 &&
									objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].perilCd == objArray[a].giuwWPerilds[b].perilCd){
									ctr++;
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0));
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,0));
									sumDistSpct1 = parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0));
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0));
								}
							}
							function err(msg){
								var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowDist");
								dist == "rowDist"+nvl(objArray[a].distNo,'---') ? null : ($("rowDist"+nvl(objArray[a].distNo,'---')) ? fireEvent($("rowDist"+nvl(objArray[a].distNo,'---')), "click") :null);
								dist == "rowDist"+nvl(objArray[a].distNo,'---') ? null : ($("rowDist"+nvl(objArray[a].distNo,'---')) ? $("rowDist"+nvl(objArray[a].distNo,'---')).scrollIntoView() :null);
								showWaitingMessageBox(msg, imgMessage.ERROR, 
									function(){
										var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
										grp == "rowDistGroup"+nvl(objArray[a].giuwWPerilds[b].distNo,'---')+"_"+nvl(objArray[a].giuwWPerilds[b].distSeqNo,'---')? null :($("rowDistGroup"+nvl(objArray[a].giuwWPerilds[b].distNo,'---')+""+nvl(objArray[a].giuwWPerilds[b].distSeqNo,'---')? fireEvent($("rowDistGroup"+nvl(objArray[a].giuwWPerilds[b].distNo,'---')+"_"+nvl(objArray[a].giuwWPerilds[b].distSeqNo,'---')), "click") :null));
									}); 
								ok = false;
							}	
							if (varPostSw == "Y"){
								if (roundNumber(sumDistSpct, 9) != 100){
									err("Post distribution is only allowed if total percent share of TSI is equal to 100%.");
									varPostSw = "N";
									return false;
								}	
								if (roundNumber(sumDistSpct1, 9) != 100){
									err("Post distribution is only allowed if total percent share of premium is equal to 100%.");
									varPostSw = "N";
									return false;
								}	
								if (roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2)){
									err("Total sum insured must be equal to TSI Amount.");
									varPostSw = "N";
									return false;
								}	
								if (roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].premAmt,0), 2)){
									err("Total premium must be equal to premium amount.");
									varPostSw = "N";
									return false;
								}	
							}else{
								if (ctr == 0){
									err("Distribution share cannot be null.");
									return false;
								}
								if (roundNumber(sumDistSpct, 9) != 100 /* && roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2) */){
									err("Total TSI %Share should be equal to 100.");
									return false;
								}
								if (roundNumber(sumDistSpct1, 9) != 100 /* && roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].premAmt,0), 2) */){
									err("Total Prem %Share should be equal to 100.");
									return false;
								}
							}
							
							sumDistSpct 	= 0;
							sumDistTsi 		= 0;
							sumDistSpct1 	= 0;
							sumDistPrem 	= 0;
							ctr 			= 0;
						}	
					}
				}
			}
			return ok;
		}catch(e){
			showErrorMessage("procedurePreCommit", e);
		}
	}

	function checkC120TsiPremium(){
		try{
			var ok = true;
			var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								if (nvl(objArray[a].giuwWPerilds[b].recordStatus,0) != -1){
									if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 && $F("txtEndtNo").trim() == ""){
										var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowDist");
										dist == "rowDist" + objArray[a].parId + "_" + objArray[a].distNo ? null :fireEvent($("rowDist"+ objArray[a].parId + "_" + objArray[a].distNo), "click");
										dist == "rowDist" + objArray[a].parId + "_" + objArray[a].distNo ? null :$("rowDist"+ objArray[a].parId + "_" + objArray[a].distNo).scrollIntoView();
										//disableButton("btnPostDist");
										showWaitingMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" with a peril of "+objArray[a].giuwWPerilds[b].perilName+" cannot have both its TSI and premium share percentage equal to zero.", "E",
											function(){
												var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
												grp == "rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo? null :fireEvent($("rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo), "click");
												var peril = getSelectedRowIdInTable_noSubstring("distPerilListing", "rowDistPeril");
												peril == "rowDistPeril"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd ? null :fireEvent($("rowDistPeril"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd), "click");
											});
										ok = false;
										return false;
									}
								}
// 								if (varPostSw == "Y"){
// 									if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi == 0){
// 										if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus == -1) return ok;
// 										$("rowDistShare"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].perilCd+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd).addClassName("selectedRow");
// 										deleteShare();
// 									}	
// 								} //comment-out by steven; pag may 0 kasi kahit na posting siya dapat di pa rin daw tumuloy.	
							}
						}	
					}
				}
			}
			return ok;
		}catch(e){
			showErrorMessage("checkC120TsiPremium", e);
		}
	}	

	/* prepare distribution for saving */
	function prepareDistForSaving(){
		try{
			giuwPolDistRows.clear();
			giuwWPerildsRows.clear();
			giuwWPerildsDtlSetRows.clear();
			giuwWPerildsDtlDelRows.clear();

			var objArray = objUW.hidObjGIUWS017.GIUWPolDist.clone();
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != null){
					objArray[a].effDate = nvl(objArray[a].effDate,"")=="" ? "" :dateFormat((objArray[a].effDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].expiryDate = nvl(objArray[a].expiryDate,"")=="" ? "" :dateFormat((objArray[a].expiryDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].createDate = nvl(objArray[a].createDate,"")=="" ? "" :dateFormat((objArray[a].createDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].negateDate = nvl(objArray[a].negateDate,"")=="" ? "" :dateFormat((objArray[a].negateDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].acctEntDate = nvl(objArray[a].acctEntDate,"")=="" ? "" :dateFormat((objArray[a].acctEntDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].acctNegDate = nvl(objArray[a].acctNegDate,"")=="" ? "" :dateFormat((objArray[a].acctNegDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].lastUpdDate = nvl(objArray[a].lastUpdDate,"")=="" ? "" :dateFormat((objArray[a].lastUpdDate), "mm-dd-yyyy HH:MM:ss TT");
					giuwPolDistRows.push(objArray[a]);
				}
				//Group
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					if (objArray[a].giuwWPerilds[b].recordStatus != null){
						giuwWPerildsRows.push(objArray[a].giuwWPerilds[b]);
					}
					//Share
					for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
						if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus == 0 || objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus == 1){
							//for insert
							giuwWPerildsDtlSetRows.push(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c]);
						}else if(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus == -1){
							//for deletion
							giuwWPerildsDtlDelRows.push(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c]);
						}		
					}	
				}	
			}	
		}catch (e) {
			showErrorMessage("prepareDistForSaving", e);
		}
	}

	/* prepare object parameters for saving */
	function prepareObjParameters(){
		try{
			var objParameters = new Object();
			//objParameters.giuwPolDistPostedRecreated	= prepareJsonAsParameter(giuwPolDistPostedRecreated);
			objParameters.giuwPolDistRows 				= prepareJsonAsParameter(giuwPolDistRows);
			objParameters.giuwWPerildsRows 				= prepareJsonAsParameter(giuwWPerildsRows);
			objParameters.giuwWPerildsDtlSetRows 		= prepareJsonAsParameter(giuwWPerildsDtlSetRows);
			objParameters.giuwWPerildsDtlDelRows 		= prepareJsonAsParameter(giuwWPerildsDtlDelRows);
			objParameters.policyId 						= objGIPIPolbasicPolDistV1.policyId;
			objParameters.distNo 						= objGIPIPolbasicPolDistV1.distNo;
			objParameters.polFlag 						= objGIPIPolbasicPolDistV1.polFlag;
			objParameters.parType 						= objGIPIPolbasicPolDistV1.parType;
			objParameters.parId 						= objGIPIPolbasicPolDistV1.parId;
			objParameters.lineCd 						= objGIPIPolbasicPolDistV1.lineCd;
			objParameters.sublineCd 					= objGIPIPolbasicPolDistV1.sublineCd;
			objParameters.issCd 						= objGIPIPolbasicPolDistV1.issCd;
			objParameters.issueYy						= objGIPIPolbasicPolDistV1.issueYy;
			objParameters.polSeqNo						= objGIPIPolbasicPolDistV1.polSeqNo;
			objParameters.renewNo						= objGIPIPolbasicPolDistV1.renewNo;
			objParameters.effDate						= dateFormat(objGIPIPolbasicPolDistV1.effDate, "mm-dd-yyyy");
			objParameters.packPolFlag 					= objGIPIPolbasicPolDistV1.packPolFlag;
			objParameters.postSw						= varPostSw;
			objParameters.endtIssCd 					= ""; //objGIPIPolbasicPolDistV1.endtIssCd;
			objParameters.endtYy 						= ""; //objGIPIPolbasicPolDistV1.endtYy;
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}
	
	/* start  */
	function adjustPerilDistTables(){
		for(var i=0, length=objUW.hidObjGIUWS017.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustPerilDistTables",
					distNo : objUW.hidObjGIUWS017.GIUWPolDist[i].distNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Adjusting Preliminary Peril Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					//refreshForm(objGIUWPolDist);
				}
			});
		}
	}
	
	//for checking of expired portfolio share
	function checkExpiredTreatyShare (){
		var ok = true;
		var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				//Group
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					if (objArray[a].giuwWPerilds[b].recordStatus != -1){
						//Share
						for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
							if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
								new Ajax.Request(contextPath + "/GIUWPolDistController", {
									method : "POST",
									parameters : {
										action: "getTreatyExpiry",
										lineCd : objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].lineCd,
										shareCd : objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd,
										parId : objArray[a].parId
									},
									asynchronous: false,
									evalScripts: true,
									onComplete : function(response){
										hideNotice();
										if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
											var comp = JSON.parse(response.responseText);
//	 										if (dateFormat((comp.expiryDate), "mm-dd-yyyy") <  dateFormat((objArray[a].effDate), "mm-dd-yyyy") && comp.portfolioSw == "P"){
//	 											showMessageBox("Treaty "+ comp.treatyName +" in group no." + objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo + 
//	 										               " under peril " + objArray[a].giuwWPerilds[b].perilName +
//	 										               " is already expired. Replace the treaty with another one. ", imgMessage.ERROR);
//	 										 	ok = false;	
//	 										}
											if (comp.vExpired == "Y"){
												showMessageBox("Treaty "+ comp.treatyName +" in group no." + objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo + 
											               " under peril " + objArray[a].giuwWPerilds[b].perilName +
											               " is already expired. Replace the treaty with another one. ", imgMessage.ERROR);
											 	ok = false;	
											}
										}else{ //added by steven 06.10.2014
											ok = false;	
										}
									}
								});
								if (!ok){
									break;
								}
							}
						}
					}
					if (!ok){
						break;
					}
				}
				if (!ok){
					break;
				}
			}
			if (!ok){
				break;
			}
		}
		if (!ok){
			return false;
		}else {
			return true;
		}
	}
	//compares the distribution tables to gipi_witemperil for discrepancies before posting
	/* function comparePolItmperilToDs (){
		var ok = true;
		for(var i=0, length=objUW.hidObjGIUWS017.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "comparePolItmperilToDs",
					policyId: objUW.hidObjGIUWS017.GIUWPolDist[i].policyId,
					distNo : objUW.hidObjGIUWS017.GIUWPolDist[i].distNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Comparing Distribution and Itemperil tables, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var comp = JSON.parse(response.responseText);
						if (comp.isBalance == "N"){
							showMessageBox("There are discrepancies in distribution master tables. Set-up Groups for Distribution to correct this.", imgMessage.ERROR);
						 	ok = false;	
						}
					}else{ //added by steven 06.10.2014
						ok = false;	
					}
					//refreshForm(objGIUWPolDist);
				}
			});
			if (!ok){
				break;
			}
		}
		if (!ok){
			return false;
		}else {
			return true;
		}
	} */
	//checks for endorsements with only TSI of allied perils are being endorsed before posting
	/* function checkZeroPremAllied(){
		var ok = true;
		var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					if (objArray[a].giuwWPerilds[b].recordStatus != -1){
						new Ajax.Request(contextPath + "/GIUWPolDistController", {
							method : "POST",
							parameters : {
								action: "getPerilType",
								lineCd: objArray[a].giuwWPerilds[b].lineCd,
								perilCd : objArray[a].giuwWPerilds[b].perilCd
							},
							asynchronous: false,
							evalScripts: true,
							onComplete : function(response){
								hideNotice();
								if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									var comp = JSON.parse(response.responseText);
									if (comp.perilType == "A" && objArray[a].giuwWPerilds[b].tsiAmt != 0 && objArray[a].giuwWPerilds[b].premAmt == 0){
										showMessageBox("Cannot post distribution. Please distribute by group.", imgMessage.ERROR);
									 	ok = false;	
									}
								}else{ //added by steven 06.10.2014
									ok = false;	
								}
								//refreshForm(objGIUWPolDist);
							}
						});
						if (!ok){
							break;
						}
					}
				}
			}
			if (!ok){
				break;
			}
		}
		if (!ok){
			return false;
		}else {
			return true;
		}
	} */
	
	function recomputeAfterCompare (){
		var ok = true;
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "recomputeAfterCompare",
				distNo : removeLeadingZero($F("txtDistNo"))
			},
			asynchronous: false,
			evalScripts: true,
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
					var recomp = JSON.parse(response.responseText);
					if (recomp.vMsgAlert != null){
						showMessageBox(recomp.vMsgAlert, imgMessage.ERROR);
						ok = false;
					}
				}else{ //added by steven 06.10.2014
					ok = false;	
				}
			}
		});
		if (!ok){
			return false;
		}else {
			return true;
		}
	}
	
	function getPolicyTakeUp (){
		var objArray = objUW.hidObjGIUWS017.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "getPolicyTakeUp",
					policyId : objArray[a].policyId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
						var takeUp = JSON.parse(response.responseText);
						takeUpTerm = takeUp.takeUpTerm;
					}else{ //added by steven 06.10.2014
						return false;	
					}
				}
			});
		}
		
	}
	
	function enableOrDisableFields(param) {
		if (param == "enable") {
			$("txtDistSpct").readOnly = false;
			$("txtDistTsi").readOnly = false;
			$("txtDistSpct1").readOnly = false;
			$("txtDistPrem").readOnly = false;
			enableButton("btnTreaty");
			enableButton("btnShare");
			enableButton("btnAddShare");
		}else{
			$("txtDspTrtyName").readOnly = true;
			$("txtDistSpct").readOnly = true;
			$("txtDistTsi").readOnly = true;
			$("txtDistSpct1").readOnly = true;
			$("txtDistPrem").readOnly = true;
			disableButton("btnTreaty");
			disableButton("btnShare");
			disableButton("btnAddShare");
		}
	}
	
	function checkBinderExist(reload){
		try{
			var result = false;
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "checkBinderExist",
					policyId : objGIPIPolbasicPolDistV1.policyId,
					distNo : objGIPIPolbasicPolDistV1.distNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == '1'){
							result = true;
							showWaitingMessageBox('Cannot update distribution records. There are distribution groups with posted binders.', 'I', function(){
								if (reload == "Y") {
									var params = {};
									params.lineCd = $F("txtPolLineCd");
									params.sublineCd = $F("txtPolSublineCd");
									params.issCd = $F("txtPolIssCd");
									params.issueYy = $F("txtPolIssueYy");
									params.polSeqNo = $F("txtPolPolSeqNo");
									params.renewNo = $F("txtPolRenewNo");
									params.distNo = $F("txtDistNo");
									showDistByTsiPremPeril(params,'Y');
								}
							});
						}
					}
				}	
			});
			return result;
		} catch(e){
			showErrorMessage("checkBinderExist", e);
		}
	}
	
	function checkItemPerilAmountAndShare(){
		var result = true;		
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "checkItemPerilAmountAndShare",
				moduleId: 'GIUWS017',
				distNo : $F("txtDistNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete : function(response){
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
					result = false;	
				}
			}
		});
		return result;
	}
	
	function saveDistByTsiPremPeril(){  
		try{
			if (checkItemPerilAmountAndShare()) {
				varPostSw = "N";
				return false;
			}
			if (!procedurePreCommit()){
				varPostSw = "N";
				return false;	
			}
			if (!checkC120TsiPremium()){
				varPostSw = "N";
				return false;
			}
			
			if (checkBinderExist("Y")){ //added by steven 
				varPostSw = "N";
				return false;
			}
			
			prepareDistForSaving();

			var objParameters = new Object();
			objParameters = prepareObjParameters();
			getPolicyTakeUp(); //get take up term
// 			if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up //remove by steven 06.30.2014
// 				if (!comparePolItmperilToDs()){
// 					varPostSw = "N";
// 					return false; // for comparison of ds table to itemperil table
// 				}
// 			}
			if (!checkExpiredTreatyShare()){
				varPostSw = "N";
				return false;// for checking of expired treaty			
			}
// 			if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up //remove by steven 06.30.2014 cause some discrepancy in the ann_tsi_amt
// 				if (!recomputeAfterCompare()){
// 					varPostSw = "N";
// 					return false; // for recomputing and adjustment, prevents posting if there's still discrepancies
// 				}
// 			}
// 			if (objGIPIPolbasicPolDistV1.parType == "E" && varPostSw == "Y"){ //remove by steven 08.05.2014 this validation was transferred.
// 				if (!checkZeroPremAllied()){
// 					varPostSw = "N";
// 					return false;//for checking of zero premium for endorsements
// 				}
// 			}
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "saveDistByTsiPremPeril",
					parameters : JSON.stringify(objParameters)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice((varPostSw == "Y" ? "Posting Peril Distribution - TSI/Prem, please wait ..." :"Saving Peril Distribution - TSI/Prem, please wait ..."));
				},
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response)  && checkCustomErrorOnResponse(response)){
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, "E");
						}else{
							showWaitingMessageBox((varPostSw == "Y" ? "Posting successful." :objCommonMessage.SUCCESS), "S",function(){
								//added by steven 06.11.2014
								clearDistStatus(objUW.hidObjGIUWS017.GIUWPolDist);
								objUW.hidObjGIUWS017.GIUWPolDist = res.giuwPolDist;
								$("txtDistFlag").value 			= nvl(objUW.hidObjGIUWS017.GIUWPolDist.length,0) == 0 ? $("txtDistFlag").value : objUW.hidObjGIUWS017.GIUWPolDist[0].distFlag;
								$("txtMeanDistFlag").value 		= nvl(objUW.hidObjGIUWS017.GIUWPolDist.length,0) == 0 ? $("txtMeanDistFlag").value : unescapeHTML2(objUW.hidObjGIUWS017.GIUWPolDist[0].meanDistFlag);
								
								if ($F("txtDistFlag") != 1) {
									disableButton("btnPostDist"); 
								}
								if($F("txtDistFlag") == 3){
									showDistByTsiPremPeril();
								}else{
									if (nvl(res.gipiPolbasicPolDistV1.length,0) > 0){ 
										objGIPIPolbasicPolDistV1 = res.gipiPolbasicPolDistV1[0];
										populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
									}
									fireEvent($("btnLoadRecords"), "click");
								}
								
							});
							adjustPerilDistTables();
							changeTag = 0;
						}
					}
					varPostSw = "N";
				}
			});
		}catch(e){
			showErrorMessage("saveDistByTsiPremPeril", e);
		}	
	}
	
	/* observe */
	$("btnDeleteShare").observe("click", function() {
		deleteShare();
	});
	
	$("btnAddShare").observe("click", function() {
		addShare();
	});
	
	$("btnTreaty").observe("click", function() {
		if (selectedGiuwPolDist != null) {
			if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
				getListing();
				var objArray = distListing.distTreatyListingJSON;
				startLOV("GIUWS017-Treaty", "Treaty", objArray, 540);
			} else {
				showMessageBox("Field is protected against update.", imgMessage.INFO);
			}
		}
	});

	$("btnShare").observe("click", function() {
		if (selectedGiuwPolDist != null) {
			if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
				getListing();
				var objArray = distListing.distShareListingJSON;
				startLOV("GIUWS017-Treaty", "Share", objArray, 540);
			} else {
				showMessageBox("Field is protected against update.", imgMessage.INFO);
			}
		}
	});

	$("btnViewDist").observe("click", function() {
		// show GIPIS130 (View Distribution) - page under construction 
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		objGIPIS130.details = {};
		objGIPIS130.details.withBinder = checkBinderExist("N") ? "Y" : "N";
		objGIPIS130.details.lineCd = $F("txtPolLineCd");
		objGIPIS130.details.sublineCd = $F("txtPolSublineCd");
		objGIPIS130.details.issCd = $F("txtPolIssCd");
		objGIPIS130.details.issueYy = $F("txtPolIssueYy");
		objGIPIS130.details.polSeqNo = $F("txtPolPolSeqNo");
		objGIPIS130.details.renewNo = $F("txtPolRenewNo");
		objGIPIS130.distNo = selectedGiuwPolDistGroup.distNo;
		objGIPIS130.distSeqNo = selectedGiuwPolDistGroup.distSeqNo;
		objUWGlobal.previousModule = "GIUWS017";
		showViewDistributionStatus();

	});
	
	$("btnPostDist").observe("click", function() {
		if (changeTag == 1){
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
			varPostSw = "N";
			return;
		}
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			parameters : {
				action : "validateRenumItemNos",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					varPostSw = "Y";
					saveDistByTsiPremPeril();
				}
			}
		});
	});
	
	observeCancelForm("btnCancel", saveDistByTsiPremPeril, checkChangeTagBeforeUWMain);
	observeReloadForm("reloadForm", showDistByTsiPremPeril); 
	observeReloadForm("distByTsiPremPerilQuery", showDistByTsiPremPeril); // andrew - 12.5.2012
	observeSaveForm("btnSave", saveDistByTsiPremPeril);
	
	/* end  */	
	
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GIUWS017");
	setDocumentTitle("Peril Distribution - TSI/Prem");
	changeTag = 0;
	initializeChangeTagBehavior(saveDistByTsiPremPeril);
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
	var loadRec = '${loadRec}'; //steven 06.11.2014
	if(nvl(loadRec,'N') == 'Y'){
		var obj = JSON.parse(('${polRec}').replace(/\\/g, '\\\\'));
		if (obj.rows.length > 0) {
			var row = obj.rows[0];
			updateGIUWS017DistSpct1(row.distNo);
		 	objGIPIPolbasicPolDistV1 = row;
			populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
			loadDistByTsiPremPeril();
		}
	}else{
	 	fireEvent($("showDistGroup"), "click");
	 	fireEvent($("showDistPeril"), "click");
	 	fireEvent($("showDistShare"), "click");
	}
}catch(e){
	showErrorMessage("GIUWS017 page", e);
}	
</script>