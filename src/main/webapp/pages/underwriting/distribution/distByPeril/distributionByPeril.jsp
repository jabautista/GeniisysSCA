<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="distributionByPerilMainDiv" name="distributionByPerilMainDiv" style="margin-top : 1px;">
	<div id="distributionByGroupMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="distributionByPerilQuery">Query</a></li>
					<li><a id="distributionByPerilExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="distributionByPerilForm" name="distributionByPerilForm">
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
				<div id="distShareTable" style="width:100%; padding-bottom:5px;">
					<div class="tableHeader" style="margin:10px; margin-bottom:0px;">
						<!-- replaced by robert 10.13.15 GENQA 5053
						<label style="width: 220px; text-align: left; margin-right: 5px; margin-left: 5px;">Share</label>
						<label style="width: 200px; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 210px; text-align: right; margin-right: 5px;">Sum Insured</label>
						<label style="width: 210px; text-align: right; margin-right: 5px;">Premium</label> -->
						<label style="width: 20%; text-align: left; margin-right: 4px; margin-left: 5px;">Share</label>
						<label style="width: 19.5%; text-align: right; margin-right: 4px;">% Share</label>
						<label style="width: 19%; text-align: right; margin-right: 4px;">Sum Insured</label>
						<label style="width: 19.5%; text-align: right; margin-right: 4px;">% Share</label>
						<label style="width: 19%; text-align: right; margin-right: 4px;">Premium</label>
					</div>
					<div id="distShareListing" name="distShareListing" style="margin:10px; margin-top:0px;" class="tableContainer">
					</div>
				</div>
				<div id="distShareTotalAmtDiv" class="tableHeader"  style="margin-left:10px; margin-right: 10px; display: none;">
					<!-- replaced by robert 10.13.15 GENQA 5053
					<label style="text-align:left; width: 220px; margin-right: 5px; margin-left: 5px; float:left; margin-left: 5px;">Total:</label>
					<label id="totalDistSpct" style="text-align:right; width: 200px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistTsi" style="text-align:right; width: 210px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistPrem" style="text-align:right; width: 210px; margin-right: 5px; float:left;" class="money">&nbsp;</label> -->
					<label style="text-align:left; width: 20%; margin-right: 4px; margin-left: 5px; float:left;">Total:</label>
					<label id="totalDistSpct" style="text-align:right; width: 19.5%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistTsi" style="text-align:right; width: 19%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistSpct1" style="text-align:right; width: 19.5%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
					<label id="totalDistPrem" style="text-align:right; width: 19%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
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
							<input type="button" id="btnTreaty" name="btnTreaty" 	class="disabledButton"	value="Treaty" style="width:75px;"/>			
							<input type="button" id="btnShare" 	name="btnShare" 	class="disabledButton"	value="Share" style="width:75px;"/>			
						</td>
					</tr>
					<tr>
						<td class="rightAligned">% Share</td>
						<td class="leftAligned">
							<!-- changed nthDecimal property from 14 to 9 and maxlength from 18 to 13 Kenneth 05/06/2014-->
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct" name="txtDistSpct" value="" style="width:250px;" maxlength="13" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Sum Insured</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistTsi" name="txtDistTsi" value="" style="width:250px;" maxlength="18" readonly="readonly"/>
						</td>
					</tr>
					<tr> <!-- added by robert 10.13.15 GENQA 5053 -->
						<td class="rightAligned">% Share Premium</td>
						<td class="leftAligned">
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct1" name="txtDistSpct1" value="" style="width:250px;" maxlength="18" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistPrem" name="txtDistPrem" value="" style="width:250px;" maxlength="14" /> <!-- readonly="readonly" /> removed readonly by robert 10.13.15 GENQA 5053-->
						</td>
					</tr>
					<tr>
						<td align="center" colspan="3">
							<input type="button" id="btnAddShare"		name="btnAddShare"		class="disabledButton"	value="Add" />
							<input type="button" id="btnDeleteShare"	name="btnDeleteShare"	class="disabledButton"	value="Delete" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnViewDist"		name="btnViewDist"		class="disabledButton"	value="View Distribution" disabled/>
			<input type="button" id="btnPostDist" 		name="btnPostDist" 		class="disabledButton"	value="Post Distribution" disabled/>
			<input type="button" id="btnCancel" 		name="btnCancel" 		class="button"			value="Cancel" />			
			<input type="button" id="btnSave" 			name="btnSave" 			class="button"			value="Save" />			
		</div>
	</form>
</div>
<div id="summarizedDistDiv" style="display: none;"></div>
<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIUWS012");
	setDocumentTitle("Distribution by Peril");

	resizeTableBasedOnVisibleRows("distListingTable", "distListing");
	resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
	resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
	resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

	/** Variables **/
	objUW.hidObjGIUWS012 = {};
	objUW.hidObjGIUWS012.giuwPolDistPostQuerySw = "N"; // bonok :: 12.10.2012
	changeTag = 0;

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

	/*+ VARIABLES in FMB +*/
	var varPostSw = "N";
	
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

		computeDistShareFieldsTotalValues(null);
	}
	
	//for getting takeupterm edgar 05/08/2014
	var takeUpTerm = "";
	var isSavePressed =true; 
	var paramDistNo = "";
	
	/* checks item info additional for share dist, with three attributes to compare */
	function checkTableItemInfoAdditional(tableName,tableRow,rowName,attr,pkValue,attr2,pkValue2,attr3,pkValue3){
		var exist = 0;
		$$("div#"+tableName+" div[name='"+rowName+"']").each(function (div) {
			div.removeClassName("selectedRow");
			if (div.getAttribute(attr) == pkValue && div.getAttribute(attr2) == pkValue2 && div.getAttribute(attr3) == pkValue3){
				exist = exist + 1;
				div.show();
			}else{
				div.hide();
			}
		});
		if (exist > 5) {
			$(tableName).setStyle("height: 186px;");
			$(tableName).down("div",0).setStyle("padding-right:17px");
	     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");
	    } else if (exist == 0) {
	     	$(tableRow).setStyle("height: 31px;");
	     	$(tableName).down("div",0).setStyle("padding-right:0px");
	    } else {
	    	var tableHeight = (exist*31)+31;
	    	if(tableHeight == 0){
	    		tableHeight = 31;
	    	}

	    	// removed, because the div for the sum is being removed by this part (emman 06.07.2011)
	    	$(tableRow).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).down("div",0).setStyle("padding-right:0px");
		}

		if (exist == 0){
			Effect.Fade(tableName, {
				duration: .001
			});
		} else {
			Effect.Appear(tableName, {
				duration: .001
			});
		}
	}

	/* clear form */
	function clearForm(){
		try{
			unClickRow("distListingTable");
			unClickRow("distGroupListingTable");
			unClickRow("distPerilTable");
			//checkTableItemInfoAdditional("distGroupListingTable","distGroupListing","rowDistGroup","groupNo",Number($("txtC080DistNo").value));
			//checkTableItemInfo("distListingTable","distListing","rowPrelimPerilDist");
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}
	
	/* sets form field values of dist share */
	function setDistShareFormFields(obj){
		try{
			selectedGiuwWPerildsDtl 	= obj == null ? {} : obj;	
			$("txtDspTrtyName").value 	= obj == null ? "" : unescapeHTML2(obj.trtyName);
			$("txtDistSpct").value 		= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 9/*14*/);//changed rounding off to 9 decimals
			$("txtDistTsi").value 		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			$("txtDistSpct1").value 	= obj == null ? "" : obj.distSpct1 == null ? "" : formatToNthDecimal(obj.distSpct1, 9); //added by robert 10.13.15 GENQA 5053
			$("txtDistPrem").value 		= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);
			$("shareCd").value			= obj == null ? "" : obj.shareCd == null ? "" : obj.shareCd;
			$("c080lineCd").value		= obj == null ? "" : obj.lineCd == null ? "" : obj.lineCd;
			
			if($F("txtDistFlag") != "3"){
				$("btnAddShare").value = obj == null ? "Add" : "Update";
				obj == null ? disableButton("btnDeleteShare") : enableButton("btnDeleteShare");
				selectedGiuwWPerilds == null ? disableButton("btnAddShare") : enableButton("btnAddShare");
			}else{
				$("btnAddShare").value = "Add";
				disableButton("btnDeleteShare");
				disableButton("btnAddShare");
			}
			
			if (obj == null){
				if (selectedGiuwPolDist != null) {
					if(selectedGiuwPolDist.distFlag == "3" || selectedGiuwPolDist.distFlag == null || selectedGiuwPolDist.giuwWPerilds.length == 0) {
						disableButton("btnTreaty");
						disableButton("btnShare");
					}else{
						if(selectedGiuwWPerilds != null && $F("txtDistFlag") != "3"){ //marco - 06.10.2014 - added condition
							enableButton("btnTreaty");
							enableButton("btnShare");
							enableInputField("txtDistSpct");
							enableInputField("txtDistTsi");
						}else{
							disableButton("btnTreaty");
							disableButton("btnShare");
							disableInputField("txtDistSpct");
							disableInputField("txtDistTsi");
						}
					}
				} else {
					disableButton("btnTreaty");
					disableButton("btnShare");
				}
			}else{
				disableButton("btnTreaty");
				disableButton("btnShare");
			}
		}catch(e){
			showErrorMessage("setDistShareFormFields", e);
		}
	}
	
	/* 
	* generate row content for distribution
	* accepts a GIUW_POL_DIST object as parameter
	*/
	function prepareDistRowContent(obj) {
		try{
			var multiBookingDate = nvl(getMultiBookingDateByPolicy(objGIPIPolbasicPolDistV1.policyId, objGIPIPolbasicPolDistV1.distNo), "-");

			var content = 
				'<label style="width: 160px; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
				'<label style="width: 280px; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+' - '+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
				'<label style="width: 280px; text-align: left; ">'+multiBookingDate+'</label>';

			return content;				
		}catch(e){
			showErrorMessage("prepareDistRowContent", e);
		}
	}

	/* 
	* generate row content for distribution group
	* accepts a GIUW_WPERILDS object as parameter
	*/
	function prepareDistGroupRowContent(obj){
		try{
			var groupNo 	= obj == null ? "" : obj.distSeqNo;
			var currency 	= ""; //obj == null ? "" : nvl(obj.currencyDesc, "-");

			new Ajax.Request(contextPath+"/GIPIPolbasicPolDistV1Controller?action=getGiuws012Currency", {
				method: "GET",
				asynchronous: false,
				evalScripts: true,
				parameters: {
					policyId: (objGIPIPolbasicPolDistV1 == null) ? 0 : objGIPIPolbasicPolDistV1.policyId,
					distNo: (obj == null) ? 0 : obj.distNo,
					distSeqNo: (obj == null) ? 0 : obj.distSeqNo
				},
				onComplete: function(response) {
					var currObj = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));

					currency =  currObj == null ? "-" : nvl(currObj.currencyDesc, "-");
				}
			});
			
			var content = 
				'<label style="width: 100px; text-align: right; margin-right: 50px;">'+ groupNo.toPaddedString(2) +'</label>' +				
				'<label style="width: 600px; text-align: left;">'+ currency +'</label>';

			return content;
		}catch(e){
			showErrorMessage("prepareDistGroupRowContent", e);
		}
	}

	/* 
	* generate row content for distribution peril
	* accepts a GIUW_WPERILDS object as parameter
	*/
	function prepareDistPerilRowContent(obj){
		try{			
			var perilName 	= obj == null ? "" : obj.perilName; 
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
			var treatyName 		= obj == null ? "" : obj.trtyName;
			var percentShare	= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 9/*14*/);//changed round off from 14 to 9 Kenneth 05/07/2014
			var sumInsured		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			obj.distSpct1 		= obj.distSpct1 == null ? obj.distSpct : obj.distSpct1; //added by robert 10.13.15 GENQA 5053
			var percentPremium	= obj == null ? "" : obj.distSpct1 == null ? "" : formatToNthDecimal(obj.distSpct1, 9); //added by robert 10.13.15 GENQA 5053
			var premium			= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);

			var content =				
				/* replaced by robert 10.13.15 GENQA 5053
				'<label style="width: 220px; text-align: left; margin-right: 5px; margin-left: 5px;">' + treatyName + '</label>' +
				'<label style="width: 200px; text-align: right; margin-right: 5px;">' + percentShare + '</label>' +
				'<label style="width: 210px; text-align: right; margin-right: 5px;">' + sumInsured + '</label>' +
				'<label style="width: 19.5%; text-align: right; margin-right: 4px;">' + percentPremium + '</label>' +
				'<label style="width: 210px; text-align: right; margin-right: 5px;">' + premium + '</label>'; */
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
		}catch(e){
			showErrorMessage("createDistShareRow", e);
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

							// show total amount div
							$("distShareTotalAmtDiv").show();
						} else {
							selectedGiuwWPerilds = null;

							// deselect highlighted rows
							unClickRow("distShareTable");

							// hide all rows in peril & show rows related to the selected group
							($("distShareListing").childElements()).invoke("hide");
							$("distShareTable").hide();

							// reset share fields
							setDistShareFormFields(null);

							// hide total amount div
							$("distShareTotalAmtDiv").hide();
						}

						computeDistShareFieldsTotalValues(id1);
					});
		}catch(e){
			showErrorMessage("createDistPerilRow", e);
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
								//marco - 06.09.2014 - replaced distNo attribute with groupNo
								//($$("div#distPerilListing div[distNo='"+ newDiv.readAttribute("distNo") +"']")).invoke("show");
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
							}
						});
			}	
		}catch(e){
			showErrorMessage("createDistGroupRow", e);
		}
	}

	/* creates dist row */
	function createDistRow(pGiuwPolDist) {
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
			createDistGroupRow(pGiuwPolDist.giuwWPerilds[i]);
			createDistPerilRow(pGiuwPolDist.giuwWPerilds[i]);
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

					// enable/disable dist view button
					if (objGIPIPolbasicPolDistV1.endtSeqNo != null && objGIPIPolbasicPolDistV1.endtSeqNo != 0) {
						if(checkUserModule("GIPIS130")){
							enableButton("btnViewDist");
						}else{
							disableButton("btnViewDist");
						}
					} else {
						disableButton("btnViewDist");
					}

					// enable/disable posting
					if(pGiuwPolDist.distFlag == "3" || pGiuwPolDist.distFlag == null || pGiuwPolDist.giuwWPerilds.length == 0) {
						disableButton("btnPostDist");
					} else {
						if (nvl(pGiuwPolDist.giuwWpolicydsDtlExist, "N") != "Y") {
							disableButton("btnPostDist");
						} else {
							if($F("txtDistFlag") == "2"){
								disableButton("btnPostDist");
							}else{
								enableButton("btnPostDist");
							}
						}
					}
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

					// disable dist view button
					disableButton("btnViewDist");
					
					// disable posting
					disableButton("btnPostDist");
				}
			});
		
		resizeTableBasedOnVisibleRows("distListingTable", "distListing");
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

	function assignAmtToObj(amt, objPre, objSca, index){
		try{
			objPre[index] = parseInt(nvl(amt[0], "0"));
			//objSca[index] = (nvl(amt[1], "0")).replace(/^0/, "");
			objSca[index] = (nvl(amt[1], "0")); // SR-23254 JET OCT-21-2016
		}catch(e){
			showErrorMessage("assignAmtToObj", e);
		}						
	}

	function addDeciNumObject(preciseObj, scaleObj, divisor){
		/* try{
			var addends1 = 0;
			var addends2 = 0;

			for(att in preciseObj){
				addends1 = addends1 + preciseObj[att];
				addends2 = parseInt(addends2) + parseInt(scaleObj[att]);				
			}		
			
			if(addends2 >= divisor){
				addends1 = addends1 + parseInt(addends2 / divisor);
				addends2 = addends2 % divisor;
			}
			
			//marco - 06.25.2014 - added lpad
			return (addends1 + "." + formatNumberDigits(lpad(addends2.abs(), 2, 0), (divisor.length - 1)));
		}catch(e){
			showErrorMessage("addDeciNumObject", e);
		} */
		
		/* SR-23254 JET OCT-21-2016; to handle addition of negative numbers */
		var total = 0;
		
		for (i in preciseObj) {
			total += parseFloat(preciseObj[i] + "." + scaleObj[i]);
		}
		
		return total;
	}

	/* compute dist share total values */
	function computeDistShareFieldsTotalValues(id1){
		try{
			if (id1 == null) {
				$("totalDistSpct").innerHTML = formatToNthDecimal(0, 9);
				$("totalDistTsi").innerHTML = formatCurrency(0);
				$("totalDistSpct1").innerHTML = formatToNthDecimal(0, 9); //added by robert 10.13.15 GENQA 5053
				$("totalDistPrem").innerHTML = formatCurrency(0);
				return true;
			}
			
			var amount;
			var objPreDistSpct 	= new Object();
			var objScaDistSpct 	= new Object();
			var objPreDistTsi	= new Object();
			var objScaDistTsi	= new Object();
			var objPreDistSpct1 = new Object(); //added by robert 10.13.15 GENQA 5053
			var objScaDistSpct1 = new Object(); //added by robert 10.13.15 GENQA 5053
			var objPreDistPrem	= new Object();
			var objScaDistPrem	= new Object();
			var count = 0;			
			
			$$("div#distShareListing div[id1=" + id1 + "]").each(function(row){				
				amount = ((row.down("label", 1)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistSpct, objScaDistSpct, count);
				
				amount = ((row.down("label", 2)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistTsi, objScaDistTsi, count);
				
				amount = ((row.down("label", 3)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistSpct1, objScaDistSpct1, count);  //added by robert 10.13.15 GENQA 5053
				
				amount = ((row.down("label", 4)).innerHTML).replace(/,/g, "").split(".");  //added by robert 10.13.15 GENQA 5053
				assignAmtToObj(amount, objPreDistPrem, objScaDistPrem, count);
				
				count++;
			});
			
			$("totalDistSpct").innerHTML = formatToNthDecimal(addDeciNumObject(objPreDistSpct, objScaDistSpct, 1000000000), 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014
			$("totalDistTsi").innerHTML = formatCurrency(addDeciNumObject(objPreDistTsi, objScaDistTsi, 100));
			$("totalDistSpct1").innerHTML = formatToNthDecimal(addDeciNumObject(objPreDistSpct1, objScaDistSpct1, 1000000000), 9); //added by robert 10.13.15 GENQA 5053
			$("totalDistPrem").innerHTML = formatCurrency(addDeciNumObject(objPreDistPrem, objScaDistPrem, 100));
		}catch(e){
			showErrorMessage("computeDistShareFieldsTotalValues", e);
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
			newObj.annDistTsi			= escapeHTML2(unformatNumber($F("txtDistTsi")));
			newObj.distGrp				= obj == null ? (param == "PERIL" ? "1" : selectedGiuwWPerildsDtl.distGrp) :"1";
			newObj.distSpct1			= escapeHTML2($F("txtDistSpct1")); //obj == null ? null :nvl(obj.distSpct1, null); //changed by robert 10.13.15 GENQA 5053
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
			if(!checkAllRequiredFieldsInDiv("distShareDiv")){
				return;
			}
			if (String(nvl((selectedGiuwPolDistGroup == null) ? null : selectedGiuwPolDistGroup.distNo, "")).blank()){
				showMessageBox("Please select distribution group first.", imgMessage.ERROR);
				return false;
			}	
			if (selectedGiuwWPerilds == null) {
				showMessageBox("Please select peril first.", imgMessage.ERROR);
				return false;
			}
			if (parseFloat($F("txtDistSpct")) > 100){
				customShowMessageBox("TSI %Share cannot exceed 100.", imgMessage.ERROR, "txtDistSpct");
				return false;
			}
			/* if (parseFloat($F("txtDistSpct")) <= 0){ //removed by robert 11.11.15 GENQA 5053
				customShowMessageBox("%Share must be greater than zero.", imgMessage.ERROR, "txtDistSpct");
				return false;
			} */
			//if (unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)) != 0){
			//	$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)),0));
				/* if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){ //removed by robert 11.11.15 GENQA 5053
					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", imgMessage.ERROR, "txtDistTsi");
					return false;
				}	 */
			//}
			if (Math.abs($F("txtDistTsi")) > Math.abs(unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)))){
				customShowMessageBox("Sum insured cannot exceed TSI.", imgMessage.ERROR, "txtDistTsi");
				return false;
			}
			if (unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)) > 0){
				/* if (unformatCurrency("txtDistTsi") <= 0){ //removed by robert 11.11.15 GENQA 5053
					customShowMessageBox("Sum insured must be greater than zero.", imgMessage.ERROR, "txtDistTsi");
					return false;
				} */	
			}else if (unformatCurrencyValue(String(selectedGiuwWPerilds.tsiAmt)) < 0){
				if (unformatCurrency("txtDistTsi") >= 0){
					customShowMessageBox("Sum insured must be less than zero.", imgMessage.ERROR, "txtDistTsi");
					return false;
				}	
			}

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

				var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
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

										computeDistShareFieldsTotalValues(objArray[a].giuwWPerilds[b].distNo + "_" + objArray[a].giuwWPerilds[b].distSeqNo + "_" + objArray[a].giuwWPerilds[b].perilCd);

										// update click event of this dist share row
										$(id).stopObserving("click");
										
										loadRowMouseOverMouseOutObserver($(id));

										$(id).observe("click",
												function() {
													clickDistShareRow($(id), newObj);
												});
										
										unClickRow("distShareTable");
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
				var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
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
								break;
							}
						}
					}
				}

				createDistShareRow(newObj);
				computeDistShareFieldsTotalValues(newObj.distNo + "_" + newObj.distSeqNo + "_" + newObj.perilCd);
				if (selectedGiuwPolDistGroup != null && selectedGiuwWPerilds != null) {
					checkTableItemInfoAdditional("distShareTable","distShareListing","rowDistShare","distNo",Number(newObj.distNo),"groupNo",Number(selectedGiuwPolDistGroup.distSeqNo),"perilCd",Number(selectedGiuwWPerilds.perilCd));
				}
				changeTag = 1;
				clearShare();
			}
			enableButton("btnPostDist");
		}catch(e){
			showErrorMessage("addShare", e);
		}		
	}

	/* delete dist share */
	function deleteShare(){
		try{
			if (String(nvl((selectedGiuwPolDistGroup == null) ? null : selectedGiuwPolDistGroup.distNo, "")).blank()){ // to check if a dist group is selected
				showMessageBox("Please select distribution group first.", imgMessage.ERROR);
				return false;
			}
			$$("div#distShareListing div[name='rowDistShare']").each(function(row){
				if (row.hasClassName("selectedRow")){
					var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
					var distNo = row.readAttribute("distNo");
					var distSeqNo = row.readAttribute("groupNo");
					var perilCd = row.readAttribute("perilCd");
					var shareCd = row.readAttribute("shareCd");
					var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
					
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
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
											Effect.Fade(row,{
												duration: .5,
												afterFinish: function(){
													row.remove();
													clearShare();
													computeDistShareFieldsTotalValues(distNo + "_" + distSeqNo + "_" + perilCd);
													resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
													enableButton("btnPostDist");
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
		}catch(e){
			showErrorMessage("deleteShare", e);
		}
	}

	/* functions used in treaty LOV */
	function getListing(){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					//action: "getDistListing", // bonok :: 11.27.2012
					action: "getDistListing2",
					globalParId: (selectedGiuwPolDist == null) ? 0 : selectedGiuwPolDist.parId,
					nbtLineCd: (selectedGiuwPolDistGroup == null) ? null : selectedGiuwPolDistGroup.lineCd,
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
				newDiv.setAttribute("cd", objArray[a].shareCd);
				newDiv.setAttribute("lineCd", objArray[a].lineCd);
				newDiv.setAttribute("nbtShareType", objArray[a].shareType);
				newDiv.setAttribute("class", "lovRow");
				newDiv.setStyle("width:98%; margin:auto;");
				
				var codeDiv = new Element("label");
				codeDiv.setStyle("width:20%; float:left;");
				codeDiv.setAttribute("title", nvl(objArray[a].trtyCd,''));
				codeDiv.update(nvl(objArray[a].trtyCd,'&nbsp;'));
				
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
					customShowMessageBox("List of Values contains no entries.", imgMessage.ERROR, "txtDspTrtyName");
					return false;
				}
				if (($("contentHolder").readAttribute("src") != id)) {
					initializeOverlayLov(id, title, width);
					generateOverlayLovRow(id, copyObj, width);
					function onOk(){
						var trtyName = unescapeHTML2(getSelectedRowAttrValue(id+"LovRow", "val"));
						if (trtyName == ""){showMessageBox("Please select any share first.", imgMessage.ERROR); return;};
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

	/* PROCEDURE check_c120_tsi_premium */
	function checkC120TsiPremium(){
		try{
			var ok = true;
			var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
			var tsiAmt = (selectedGiuwWPerilds == null) ? null : selectedGiuwWPerilds.tsiAmt;
			var premAmt = (selectedGiuwWPerilds == null) ? null : selectedGiuwWPerilds.premAmt;
			
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								/*removed by robert SR 5053 11.11.15
								 if (((parseFloat(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct) == 0) && (tsiAmt != 0 || premAmt != 0)) &&
									(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus == 0 || nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus, 2) != -1)){
									var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowDist");
									dist == "rowDist" + objArray[a].parId + "_" + objArray[a].distNo ? null : fireEvent($("rowDist"+ objArray[a].parId + "_" + objArray[a].distNo), "click");
									dist == "rowDist" + objArray[a].parId + "_" + objArray[a].distNo ? null : $("rowDist"+ objArray[a].parId + "_" + objArray[a].distNo).scrollIntoView();
									showWaitingMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" with a peril of "+objArray[a].giuwWPerilds[b].perilName+" cannot have a share percent equal to zero.", "E",
										function(){
											var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
											grp == "rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo? null :fireEvent($("rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo), "click");
											var peril = getSelectedRowIdInTable_noSubstring("distPerilListing", "rowDistPeril");
											peril == "rowDistPeril"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd ? null :fireEvent($("rowDistPeril"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd), "click");
										});
									ok = false;
									return false;
								} */
								//added by robert SR 5053 11.11.15
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi == 0 && 
										(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != undefined && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != "undefined")){
										showMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" with peril of "+objArray[a].giuwWPerilds[b].perilName+
												       " cannot have both its TSI and premium equal to zero.", "I");
										var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowDist");
										dist == "rowDist" + objArray[a].parId + "_" + objArray[a].distNo ? null : fireEvent($("rowDist"+ objArray[a].parId + "_" + objArray[a].distNo), "click");
										dist == "rowDist" + objArray[a].parId + "_" + objArray[a].distNo ? null : $("rowDist"+ objArray[a].parId + "_" + objArray[a].distNo).scrollIntoView();
										var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
										grp == "rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo? null :fireEvent($("rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo), "click");
										var peril = getSelectedRowIdInTable_noSubstring("distPerilListing", "rowDistPeril");
										peril == "rowDistPeril"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd ? null :fireEvent($("rowDistPeril"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd), "click");
										ok = false;
										return false;
								}
								// end robert SR 5053 11.11.15
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

	/* the PRE-COMMIT function */
	function procedurePreCommit(param){
		try{
			var ok = true;
			var ctr = 0;
			var sumDistSpct = 0;
			var sumDistSpct1 = 0; //added by robert SR 5053 11.11.15
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
			var withNullTsi = false;
			var withNullSpct = false;
			
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
									
									if(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi == null){
										withNullTsi = true;
									}
									if(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct == null){
										withNullSpct = true;
									}
									
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0));
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,0));
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0));
									sumDistSpct1 = parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0));  //added by robert SR 5053 11.11.15
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
							if (ctr == 0){
								err("Distribution share cannot be null.");
								return false;
							}
							//changed rounding off from 14 to 9 Kenneth 05/06/2014
							/*if (parseFloat(roundNumber(sumDistSpct, 9)) != parseFloat(100) && parseFloat(roundNumber(sumDistTsi, 2)) != parseFloat(roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2))){*/ //edgar 12/10/2014
							//if (roundNumber(sumDistSpct, 9) != 100 ){ //edgar 12/20/2014 //replaced by robert SR 5053 12.21.15 
							if ((roundNumber(sumDistSpct, 9) < parseFloat("99.5") ) || (roundNumber(sumDistSpct, 9) > parseFloat("100.5")) && roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2) ){ //Modified by Jerome Bautista 06.01.2016 SR 22401
								if (param == "P") {
									if(!withNullTsi && !withNullSpct){
										err("The total distribution sum insured should be equal to the Peril Sum Insured."); //changed by robert SR 5053 12.21.15 
										return false;
									}
								} else {
									if(!withNullTsi && !withNullSpct){
										err("The total distribution sum insured should be equal to the Peril Sum Insured.");  //changed by robert SR 5053 12.21.15 
										return false;
									}
								}
							}
							//added by robert SR 5053 11.11.15
							//if (roundNumber(sumDistSpct1, 9) != 100 ){
							if ((roundNumber(nvl(sumDistSpct1,sumDistSpct), 9) < parseFloat("99.5") || roundNumber(nvl(sumDistSpct1,sumDistSpct), 9) > parseFloat("100.5") && roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].premAmt,0), 2))){ //Modified by Jerome Bautista 06.01.2016 SR 22401
								err("The total distribution premium amount should be equal to the peril premium amount.");
								return false;
							}
							//end robert SR 5053 11.11.15
							sumDistSpct = 0;
							sumDistSpct1 = 0; //added by robert SR 5053 11.11.15
							sumDistTsi = 0;
							sumDistPrem = 0;
							ctr = 0;
						}
						withNullTsi = false;
						withNullSpct = false;
					}
				}
			}
			return ok;
		}catch(e){
			showErrorMessage("procedurePreCommit", e);
		}
	}

	/* prepare distribution for saving */
	function prepareDistForSaving(){
		try{
			giuwPolDistRows.clear();
			giuwWPerildsRows.clear();
			giuwWPerildsDtlSetRows.clear();
			giuwWPerildsDtlDelRows.clear();

			var objArray = objUW.hidObjGIUWS012.GIUWPolDist.clone();
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
			objParameters.parId							= objGIPIPolbasicPolDistV1.parId;
			objParameters.distNo						= objGIPIPolbasicPolDistV1.distNo;
			objParameters.policyId						= objGIPIPolbasicPolDistV1.policyId;
			objParameters.postSw						= varPostSw;
			objParameters.polFlag						= nvl(objGIPIPolbasicPolDistV1.polFlag, ""); //added by robert 10.13.15 GENQA 5053
			/*objParameters.parId							= globalParId;
			objParameters.lineCd						= globalLineCd;
			objParameters.sublineCd						= globalSublineCd;
			objParameters.polFlag						= varVPolFlag; //globalPolFlag;
			objParameters.parType						= globalParType;*/
			
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}

	//for adjustment of distribution tables edgar 04/28/2014
	function adjustPerilDistTables(){
		for(var i=0, length=objUW.hidObjGIUWS012.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustPerilDistTables",
					distNo : objUW.hidObjGIUWS012.GIUWPolDist[i].distNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Adjusting Peril Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
				}
			});
		}
	}
	
	//for recomputation of dist_prem Kenneth 04/29/2014
	function recomputePerilDistPrem(func){
		var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
		isSavePressed = true;
		
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					if (objArray[a].giuwWPerilds[b].recordStatus != -1){
						for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
							if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1 != null &&
									parseFloat(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1) != parseFloat(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct)){
									paramDistNo = objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo;
									isSavePressed = false;
									break;
								}
							}
						}
					}
				}
			}
		}
		return true;
	}
	
	//added by Kenneth L. 05.09.2014
	function proceedRecompute(){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "recomputePerilDistPrem",
				distNo : paramDistNo,
				parId: "0"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Recomputing Distribution Premium Amounts, please wait ...");
			},
			onComplete : function(response){
				hideNotice();
				adjustPerilDistTables(); 
				showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
				objUW.hidObjGIUWS012.giuwPolDistPostQuerySw = "N"; 
				fireEvent($("btnLoadRecords"), "click");
				changeTag = 0;
				clearDistStatus(objUW.hidObjGIUWS012.GIUWPolDist);
				isSavePressed = true;
			}
		});
	}
	
	//for checking of expired portfolio share edgar 05/02/2014
	function checkExpiredTreatyShare (){
		var ok = true;
		var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				//Group
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					if (objArray[a].giuwWPerilds[b].recordStatus != -1){
						//Share
						for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
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
										if (comp.vExpired == "Y"){
											showMessageBox("Treaty " + comp.treatyName + " has already expired. Replace the treaty with another one.", imgMessage.ERROR);
										 	ok = false;	
										}
									}else{
										ok = false;
									}
								}
							});
							if (!ok){
								break;
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
	
	//compares the distribution tables to gipi_witemperil for discrepancies before posting edgar 05/02/2014
	function compareWitemPerilToDs (){
		var ok = true;
		for(var i=0, length=objUW.hidObjGIUWS012.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "comparePolItmperilToDs",
					policyId: objUW.hidObjGIUWS012.GIUWPolDist[i].policyId,
					distNo : objUW.hidObjGIUWS012.GIUWPolDist[i].distNo
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
					}else{
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
	}
	
	//checks for endorsements with only TSI of allied perils are being endorsed before posting edgar 05/05/2014
	function checkZeroPremAllied(){
		var ok = true;
		var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
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
										showMessageBox("Cannot post Distribution with Allied peril(s) whose TSI is only endorsed.", imgMessage.ERROR);
									 	ok = false;	
									}
								}else{
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
	}
	
	function recomputeAfterCompare (){
		var ok = true;
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "recomputeAfterCompare",
				distNo : Number($F("txtDistNo"))
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
				}else{
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
	
	function getTakeUpTerm (){
		var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
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
					}
				}
			});
		}
		
	}
	//end of code for adjustment/recomputation edgar 04/28/2014
	
	function preparePerilDs(){
		var objArray = objUW.hidObjGIUWS012.GIUWPolDist;
		var objParams = new Object();
		objParams.perilDsList = [];
		objParams.perilDsDtlList = [];
		
		for(var a = 0; a < objArray.length; a++){
			if(objArray[a].recordStatus != -1){
				for(var b = 0; b < objArray[a].giuwWPerilds.length; b++){
					if (objArray[a].giuwWPerilds[b].recordStatus != -1){
						objParams.perilDsList.push(objArray[a].giuwWPerilds[b]);
						for(var c = 0; c < objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
							if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
								objParams.perilDsDtlList.push(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c]);
							}
						}
					}
				}
			}
		}
		return objParams;
	}
	
	function preSaveDistributionByPeril(){
		if (!procedurePreCommit("S")){
			return false;	
		}
		
		if (!checkC120TsiPremium()) {
			return false;
		}
		
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "preSaveOuterDist",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo,
				parType: objGIPIPolbasicPolDistV1.parType,
				params: JSON.stringify(preparePerilDs()),
				mode: "save",
				moduleId: "GIUWS012"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Processing, please wait ...");
			},
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					/* if(response.responseText.include("Geniisys Confirmation")){ removed by robert SR 5053 11.11.15
						showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", function(){
							saveDistributionByPeril("N");
						});
					}else{ */ 
						saveDistributionByPeril("N");
					//} //removed by robert SR 5053 11.11.15
				}else if(response.responseText.include("There are distribution groups with posted binders")){
					showDistributionByPeril("Y");
				}
			}
		});
	}
	
	function saveDistributionByPeril(param){
		try{
			prepareDistForSaving();

			var objParameters = new Object();
			objParameters = prepareObjParameters();

			function saveByPeril(){
				new Ajax.Request(contextPath + "/GIUWPolDistController", {
					method : "POST",
					parameters : {
						action: "saveDistributionByPeril",
						parameters : JSON.stringify(objParameters)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
						showNotice("Saving Distribution by Peril, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){ //added checkCustomErrorOnResponse by robert SR 5053 11.11.15
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	//added by robert SR 5053 11.11.15
							if (res.message != "SUCCESS"){
								showMessageBox(res.message, imgMessage.ERROR);
							}else{
								adjustPerilDistTables();
								if (param == "saveWithPost") {
									prePostDist("Y");
								} else {
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
										$("txtDistFlag").value = nvl(res.giuwPolDist[0].distFlag, $F("txtDistFlag"));
										$("txtMeanDistFlag").value = nvl(res.giuwPolDist[0].meanDistFlag, $F("txtMeanDistFlag"));
										loadDistributionByPeril();
										
										$$("div#distListing div[name='rowDist']").each(function(row){
											row.down("label", 1).innerHTML = $F("txtDistFlag") + " - " + $F("txtMeanDistFlag");
										});
									});
								}
							}
						}
					}
				});
			}
			
			//recomputePerilDistPrem();  //removed by robert SR 5053 11.11.15
			//if(isSavePressed){  //removed by robert SR 5053 11.11.15
				saveByPeril();
				proceedRecompute(); //Added by Jerome Bautista 06.01.2016 SR 22401
				objUW.hidObjGIUWS012.giuwPolDistPostQuerySw = "N"; 
				fireEvent($("btnLoadRecords"), "click");
				changeTag = 0;
				clearDistStatus(objUW.hidObjGIUWS012.GIUWPolDist);
			//}else{  //removed by robert SR 5053 11.11.15
				//marco - 06.30.2014 - moved to pre_save_outer_dist
				//showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", function(){
			//		saveByPeril();  //removed by robert SR 5053 11.11.15
			//		proceedRecompute();  //removed by robert SR 5053 11.11.15
				//});
			//}  //removed by robert SR 5053 11.11.15
		}catch(e){
			showErrorMessage("saveDistributionByPeril", e);
		}
	}
	
	function checkBinderExist(){
		try{
			var exists = false;
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
							exists = true;
							showMessageBox('Cannot update distribution records. There are distribution groups with posted binders.', 'I');
						}
					}
				}
			});
			return exists;
		} catch(e){
			showErrorMessage("checkBinderExist", e);
		}
	}
	
	function prePostDist(){
		if (!procedurePreCommit("P")){
			return false;	
		}
		
		if (!checkC120TsiPremium()) {
			return false;
		}
		
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "preSaveOuterDist",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo,
				parType: objGIPIPolbasicPolDistV1.parType,
				params: JSON.stringify(preparePerilDs()),
				mode: "post",
				moduleId: "GIUWS012"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Processing, please wait ...");
			},
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText.include("Geniisys Confirmation")){
						showConfirmBox("Confirmation", "There are records which have different distribution share % between TSI and premium. " + 
								"Distribution premium amounts will be recomputed. Do you want to continue posting?", "Continue", "Cancel", recomputeBeforePost,
								function(){
									showMessageBox("Posting of distribution has been cancelled.", "I");
								}, "1");
					}else{
						postDist();
					}
				}
			}
		});
	}
	
	function recomputeBeforePost(){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "recomputePerilDistPrem",
				distNo : selectedGiuwPolDist.distNo,
				parId: "0"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Recomputing Distribution Premium Amounts, please wait ...");
			},
			onComplete : function(response){
				postDist();
			}
		});
	}
	
	function postDist() {
		 new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method: 'POST',
			parameters:{
				action: "postDistGiuws012",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: (selectedGiuwPolDist == null) ? 0 : selectedGiuwPolDist.distNo,
				parId: (selectedGiuwPolDist == null) ? 0 : selectedGiuwPolDist.parId,
				lineCd: objGIPIPolbasicPolDistV1.lineCd,
				sublineCd: objGIPIPolbasicPolDistV1.sublineCd,
				issCd: objGIPIPolbasicPolDistV1.issCd,
				issueYy: objGIPIPolbasicPolDistV1.issueYy,
				polSeqNo: objGIPIPolbasicPolDistV1.polSeqNo,
				renewNo: objGIPIPolbasicPolDistV1.renewNo,
				endtSeqNo: objGIPIPolbasicPolDistV1.endtSeqNo,
				parType: objGIPIPolbasicPolDistV1.parType,
				effDate: dateFormat(objGIPIPolbasicPolDistV1.effDate, "mm-dd-yyyy"),
				batchId: (selectedGiuwPolDist == null) ? 0 : selectedGiuwPolDist.batchId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Posting, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var param = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (nvl(param.msgAlert,"SUCCESS") != "SUCCESS") { //added nvl by robert 10.13.15 GENQA 5053
						showMessageBox(param.msgAlert);
					}else{
						objUW.hidObjGIUWS012.giuwPolDistPostQuerySw = "N";
						
						showWaitingMessageBox("Posting complete.", imgMessage.SUCCESS, function(){
							$$("div#distShareListing div[name='rowDistShare']").each(function(row){
								if (row.hasClassName("selectedRow")){
									fireEvent($("rowDistShare" + row.readAttribute("distNo") + "_" + row.readAttribute("groupNo") + "_" +
											row.readAttribute("perilCd") + "_" + row.readAttribute("shareCd")), "click");
								}
							});
							
							$("txtDistFlag").value = nvl(param.giuwPolDist[0].distFlag, $F("txtDistFlag"));
							$("txtMeanDistFlag").value = nvl(param.giuwPolDist[0].meanDistFlag, $F("txtMeanDistFlag"));
							
							if($F("txtDistFlag") == "3"){
								$w("btnViewDist btnPostDist btnTreaty btnShare btnAddShare btnDeleteShare").each(function(e){
									disableButton(e);
								});
								
								disableInputField("txtDistSpct");
								disableInputField("txtDistTsi");
							}else if($F("txtDistFlag") == "2"){
								if (objGIPIPolbasicPolDistV1.endtSeqNo != null && objGIPIPolbasicPolDistV1.endtSeqNo != 0) {
									if(checkUserModule("GIPIS130")){
										enableButton("btnViewDist");
									}
								}
								disableButton("btnPostDist");
							}
							
							$$("div#distListing div[name='rowDist']").each(function(row){
								row.down("label", 1).innerHTML = $F("txtDistFlag") + " - " + $F("txtMeanDistFlag");
							});
						});
					}	
				}
			}
		}); 
	}
	
	/** end of Page Functions **/

	/** Field events **/
	
	/*+ Menu +*/
	
	$("distributionByPerilExit").observe("click", function(){
		objUWGlobal.previousModule = null;
		checkChangeTagBeforeUWMain();
	});

	/*+ Main Fields +*/
	
	function callGIPIS130(){
		objGIPIS130.details = {};
		objGIPIS130.details.withBinder = checkBinderExist() ? "Y" : "N";
		objGIPIS130.details.lineCd = $F("txtPolLineCd");
		objGIPIS130.details.sublineCd = $F("txtPolSublineCd");
		objGIPIS130.details.issCd = $F("txtPolIssCd");
		objGIPIS130.details.issueYy = $F("txtPolIssueYy");
		objGIPIS130.details.polSeqNo = $F("txtPolPolSeqNo");
		objGIPIS130.details.renewNo = $F("txtPolRenewNo");
		objGIPIS130.distNo = selectedGiuwPolDist.distNo;
		objGIPIS130.distSeqNo = selectedGiuwPolDistGroup.distSeqNo;
		objUWGlobal.previousModule = "GIUWS012";
		showViewDistributionStatus();
	}
	
	$("btnViewDist").observe("click", function() {
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			callGIPIS130();
		}
	});
	
	$("btnPostDist").observe("click", function() {
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			if(selectedGiuwPolDist != null){
				//prePostDist(); //removed by robert 10.13.15 GENQA 5053
				postDist(); //added by robert 10.13.15 GENQA 5053
			}
		}
	});

	$("btnCancel").observe("click", function() {
		checkChangeTagBeforeUWMain();
	});

	/*+ B2502 Block - GIPI_POLBASIC_POL_DIST_V1 +*/
	
	function showGIUWS012PolbasicPolDistV1LOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIUWS012PolicyListing",
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
								 	updateGIUWS017DistSpct1(row.distNo); //added by robert SR 5053 11.11.15
								 	objGIPIPolbasicPolDistV1 = row;
									populateDistrPolicyInfoFields(row);
									loadDistributionByPeril();
							 }
				  		}
					});
	} 	
	//added by robert SR 5053 11.11.15
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
	//end robert SR 5053 11.11.15
	$("hrefPolicyNo").observe("click", function() {
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", preSaveDistributionByPeril, 
			function(){
				showGIUWS012PolbasicPolDistV1LOV(); // andrew - 12.5.2012
				//showPolbasicPolDistV1ListingForPerilDist();
			},"");
		} else {
			showGIUWS012PolbasicPolDistV1LOV();  // andrew - 12.5.2012
			//showPolbasicPolDistV1ListingForPerilDist();
		}
		
	});

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
		for (var i = 0; i < objUW.hidObjGIUWS012.GIUWPolDist.length; i++) {
			// POST-QUERY
			new Ajax.Request(contextPath+"/GIPIPolbasicPolDistV1Controller?action=postQueryGiuws012", {
				method: "GET",
				asynchronous: false,
				evalScripts: true,
				parameters: {
					policyId: (objGIPIPolbasicPolDistV1 == null) ? 0 : objGIPIPolbasicPolDistV1.policyId,
					distNo: (objUW.hidObjGIUWS012.GIUWPolDist[i].distNo == null) ? 0 : objUW.hidObjGIUWS012.GIUWPolDist[i].distNo,
					meaning: (objGIPIPolbasicPolDistV1 == null) ? null : objUW.hidObjGIUWS012.GIUWPolDist[i].meanDistFlag,
					domain: "GIUW_POL_DIST.DIST_FLAG"
				},
				onComplete: function(response) {
					var polDistObj = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));

					//objUW.hidObjGIUWS012.GIUWPolDist[i].distFlag = polDistObj.distFlag;
					objUW.hidObjGIUWS012.GIUWPolDist[i].batchId = polDistObj.batchId;
					objUW.hidObjGIUWS012.GIUWPolDist[i].distFlag = polDistObj.pValue;
					objUW.hidObjGIUWS012.GIUWPolDist[i].meanDistFlag = polDistObj.pMeaning;

					createDistRow(objUW.hidObjGIUWS012.GIUWPolDist[i]);

					if(objUW.hidObjGIUWS012.giuwPolDistPostQuerySw == "Y"){ // bonok :: 12.10.2012
						if (nvl(polDistObj.isExistGiuwWPerilds, "N") != "Y") {
							showMessageBox("There was an error encountered in distribution records, to correct this error please recreate using Set-Up Groups For Distribution(Item).", imgMessage.INFO);
						}
					}
				}
			});
		}

		// clear form
		clearForm();

		// reset change tag
		changeTag = 0;

		// hide total amount div
		$("distShareTotalAmtDiv").hide();

		// disable dist view button
		disableButton("btnViewDist");
		
		// disable post dist button
		disableButton("btnPostDist");

		// automatically select first GIUW_POL_DIST record
		if (objUW.hidObjGIUWS012.GIUWPolDist.length > 0) {
			// dist row
			var pGiuwPolDist = objUW.hidObjGIUWS012.GIUWPolDist[0];
			fireEvent($("rowDist" + pGiuwPolDist.parId + "_" + pGiuwPolDist.distNo), "click");
			if (pGiuwPolDist.giuwWPerilds.length > 0) {
				var pGiuwWPerilds = pGiuwPolDist.giuwWPerilds[0];

				// dist group row
				fireEvent($("rowDistGroup" + pGiuwWPerilds.distNo + "_" + pGiuwWPerilds.distSeqNo), "click");

				// dist peril row
				fireEvent($("rowDistPeril" + pGiuwWPerilds.distNo + "_" + pGiuwWPerilds.distSeqNo + "_" + pGiuwWPerilds.perilCd), "click");
			}
		}
	});

	/*+ C120 Block - GIUW_WPERILDS_DTL +*/
	
	$("btnTreaty").observe("click", function() {
		if (selectedGiuwPolDist != null) {
			if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
				getListing();
				var objArray = distListing.distTreatyListingJSON;
				startLOV("GIUWS012-Treaty", "Treaty", objArray, 540);
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
				startLOV("GIUWS003-Treaty", "Share", objArray, 540);
			} else {
				showMessageBox("Field is protected against update.", imgMessage.INFO);
			}
		}
	});

	$("txtDistSpct").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		if (selectedGiuwWPerilds == null) return false;
		if($F("txtDistSpct").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistSpct").value = 0;
		}	
		var distSpct = $F("txtDistSpct");		
		
		if(!(distSpct.empty())){
			/*  Check that %Share is not greater than 100 */ 
			if(parseFloat(distSpct) > 100){
				customShowMessageBox("%Share cannot exceed 100.", imgMessage.INFO, "txtDistSpct");
				return false;
			/* }else if(parseFloat(distSpct) < 0){ //removed by robert SR 5053 11.11.15
				customShowMessageBox("%Share must be greater than zero.", imgMessage.INFO, "txtDistSpct"); */
			}
			
			/* Compute DIST_TSI if the TSI amount of the master table
			 * is not equal to zero.  Otherwise, nothing happens.  */

			distNo 		= ($$("div#distListingTable .selectedRow"))[0].getAttribute("distNo");
			distSeqNo 	= ($$("div#distGroupListingTable .selectedRow"))[0].getAttribute("groupNo");
			perilCd 	= ($$("div#distPerilTable .selectedRow"))[0].getAttribute("perilCd");
			
			if(selectedGiuwWPerilds.tsiAmt != 0){
				$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0));
				/* if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){ //removed by robert SR 5053 11.11.15
					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", imgMessage.ERROR, "txtDistTsi");
					return false;
				} */
			}else{
				$("txtDistTsi").value = "0.00";
			}
			
			/* Compute dist_prem  */
			//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0)); //removed by robert 10.13.15 GENQA 5053
			$("txtDistSpct1").value = 	$F("txtDistSpct"); //added by robert 10.13.15 GENQA 5053
			fireEvent($("txtDistSpct1"), "blur"); //added by robert 10.13.15 GENQA 5053
		}
	});

	$("txtDistTsi").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		if($F("txtDistTsi").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistTsi").value = 0;
		}
		var distTsi = $F("txtDistTsi");
		
		if(!(distTsi.empty())){
			/* Check that dist_tsi does is not greater than tsi_amt  */
			distNo 		= ($$("div#distListingTable .selectedRow"))[0].getAttribute("distNo");
			distSeqNo 	= ($$("div#distGroupListingTable .selectedRow"))[0].getAttribute("groupNo");
			perilCd 	= ($$("div#distPerilTable .selectedRow"))[0].getAttribute("perilCd");
			
			if(Math.abs(unformatCurrencyValue(distTsi)) > Math.abs(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt))){
				//customShowMessageBox("Sum insured cannot exceed TSI.", imgMessage.INFO, "txtDistTsi"); //replaced by robert SR 5053 12.21.15
				customShowMessageBox("Distribution Sum Insured cannot exceed Peril Sum Insured.", imgMessage.INFO, "txtDistTsi");
				return false;
			}
			
			/* Compute dist_spct if the TSI amount of the master table
			** is not equal to zero.  Otherwise, nothing happens.  */
			if(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt) > 0){
				/* if(unformatCurrencyValue(distTsi) <= 0){  //removed by robert 10.13.15 GENQA 5053
					customShowMessageBox("Sum insured must be greater than zero.", imgMessage.INFO, "txtDistTsi");
					return false;
				} */
				
				//$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0) * 100 ,14); //commented out changed rounding off to 9 Kenneth 05/06/2014
				$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0) * 100 ,9);
			}else if(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt) < 0){
				if(unformatCurrencyValue(distTsi) >= 0){
					customShowMessageBox("Sum insured must be less than zero.", imgMessage.INFO, "txtDistTsi");
					return false;
				}
				//$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0) * 100 ,14);//commented out to change rounding off to 9 Kenneth 05/06/2014
				$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.tsiAmt),0) * 100 ,9);//changed rounding off to 9 Kenneth 05/06/2014
			}else{
				$("txtDistTsi").value = formatCurrency("0");
			}
			
			/* Compute dist_prem  */
			//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0));	//removed by robert SR 5053 12.21.15
			$("txtDistSpct1").value = 	$F("txtDistSpct"); //added by robert 10.13.15 GENQA 5053
			fireEvent($("txtDistSpct1"), "blur"); //added by robert 10.13.15 GENQA 5053
		}
	});
	//added by robert 10.13.15 GENQA 5053
	initPreTextOnField("txtDistSpct1");
	$("txtDistSpct1").observe("blur", function(){	
		try{
			if (parseFloat(this.value.replace(/,/g, "")) < parseFloat(0)){
				showMessageBox("Entered % Share is invalid. Valid value is from 0 to 100.", "E");
				this.value = this.getAttribute("pre-text");
				return;
			}
			if (parseFloat(this.value.replace(/,/g, "")) > parseFloat(100)){
				showMessageBox("Prem %Share cannot exceed 100.", "E");
				this.value = this.getAttribute("pre-text");
				return;
			}
			if($F("txtDistSpct1").empty()){
				$("txtDistSpct1").value = 0;
			}	
			var distSpct1 = $F("txtDistSpct1");	
			if(!(distSpct1.empty())){
				/*  Check that %Share is not greater than 100 */ 
				if(parseFloat(distSpct1) > 100){
					$("txtDistSpct1").value = getPreTextValue("txtDistSpct1");
					customShowMessageBox("%Share cannot exceed 100.", "I", "txtDistSpct1");
					return false;
				}
				
				if(selectedGiuwWPerilds.premAmt != 0){
					var txtDistPrem = nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0);

					$("txtDistPrem").value = formatCurrency(roundNumber(txtDistPrem,2));
					$("txtDistPrem").writeAttribute("distPrem", txtDistPrem); 

				}else{
					$("txtDistPrem").value = "0.00";
					$("txtDistPrem").writeAttribute("distPrem", "0.00"); 
				}
			}
		}catch(e){
			showErrorMessage("% Share Premium on blur.", e);
		}
	});	
	initPreTextOnField("txtDistPrem");	
	$("txtDistPrem").observe( "change", function(){ 
		try{
			if($F("txtDistPrem").empty()){
				$("txtDistPrem").value = 0;
			}
			var distPrem = $F("txtDistPrem");
			if(!(distPrem.empty())){
				if(Math.abs(unformatCurrencyValue(distPrem)) > Math.abs(unformatCurrencyValue(selectedGiuwWPerilds.premAmt))){
					customShowMessageBox("Distribution Premium Amount cannot be greater than the peril premium amount.", "I", "txtDistPrem");
					$("txtDistPrem").value = getPreTextValue("txtDistPrem");
					return false;
				}

				if(unformatCurrencyValue(selectedGiuwWPerilds.premAmt) > 0){
					if(unformatCurrencyValue(distPrem) < 0){
						customShowMessageBox("Premium Amount must not be less than zero.", "I", "txtDistPrem");
						return false;
					}
					$("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrencyValue(distPrem),0) / nvl(unformatCurrencyValue(selectedGiuwWPerilds.premAmt),0) * 100 , 9);
				}else if(unformatCurrencyValue(selectedGiuwWPerilds.premAmt) < 0){
					if(unformatCurrencyValue(distPrem) >= 0){
						customShowMessageBox("Premium must be less than zero.", "I", "txtDistPrem");
						$("txtDistPrem").value = getPreTextValue("txtDistPrem");
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
	//end robert 10.13.15 GENQA 5053
	$("btnAddShare").observe("click", function() {
		addShare();
	});

	$("btnDeleteShare").observe("click", function() {
		deleteShare();
	});
	
	/** end of Field events **/
	
	initializeChangeTagBehavior(preSaveDistributionByPeril);
	window.scrollTo(0,0); 	
	hideNotice("");
	observeReloadForm("reloadForm", showDistributionByPeril);
	observeReloadForm("distributionByPerilQuery", showDistributionByPeril); // andrew - 12.5.2012
	observeSaveForm("btnSave", preSaveDistributionByPeril);
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
	
	//marco - 06.10.2014 - query policy from GIPIS130
	if(nvl('${loadRecords}', 'N') == "Y"){
		populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
		loadDistributionByPeril();
	}
</script>