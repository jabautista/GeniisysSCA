<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="preliminayPerilDistMainDiv" name="preliminaryPerilDistMainDiv" style="margin-top : 1px;">
	<input type="hidden" id="initialParId" value="${parId}"/>
	<input type="hidden" id="initialLineCd" value=""/> 	
	<form id="preliminayPerilDistForm" name="preliminaryPerilDistForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<c:if test="${isPack eq 'Y'}">
			<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
		</c:if>
		
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
				<div id="distGroup1Div" class="sectionDiv" style="display: block;">
					<div id="distListingTable" name="distListingTable" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 160px; text-align: right; margin-right: 15px;">Distribution No.</label>
							<label style="width: 280px; text-align: left; margin-right: 5px;">Distribution Status</label>
							<label style="width: 280px; text-align: left; ">Multi Booking Date</label>
						</div>
						<div id="distListing" name="distListing" class="tableContainer">								
						</div>
					</div>	
				</div>
				
				<div id="distGroup2Div" class="sectionDiv" style="display: block;">
					<div id="distGroupListingTable" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 100px; text-align: right; margin-right: 50px;">Group No.</label>							
							<label style="width: 650px; text-align: left;">Currency</label>
						</div>
						<div id="distGroupListing" name="distGroupListing" class="tableContainer">								
						</div>
					</div>
					<!-- 
					<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
						<tr>
							<td class="rightAligned">Group No.</td>
							<td class="leftAligned">
								<input class="rightAligned" type="text" id="txtDistSeqNo" name="txtDistSeqNo" value="" style="width:90px;" readonly="readonly"/>
							</td>
							<td class="rightAligned" style="width: 85px;">Group TSI</td>
							<td class="leftAligned">
								<input type="text" id="txtTsiAmt" name="txtTsiAmt" value="" style="width:180px;" readonly="readonly" class="money"/>
							</td>
							<td class="rightAligned" style="width: 120px;">Group Premium</td>
							<td class="leftAligned">
								<input type="text" id="txtPremAmt" name="txtPremAmt" value="" style="width:180px;" readonly="readonly" class="money"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" colspan="6">
								<label id="lblCurrency" style="float:right; font-weight:bolder; text-transform:uppercase;">
								</label>
							</td>
						</tr>
					</table>
					 -->
				</div>				
			</div>
		</div>
		<div id="distPerilMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Peril Listing</label>
					<span class="refreshers" style="margin-top: 0px;">
						<label id="showPerilList" name="gro" style="margin-left: 5px;">Hide</label>
					</span>
				</div>
			</div>
			<div id="distPerilDiv" class="sectionDiv" style="display: block;">
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
				<div id="distShareTable" style="margin: 10px; margin-bottom:0px; margin-top: 5px;">
					<div class="tableHeader" style="margin-top: 5px;">
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
					<div id="distShareListing" name="distShareListing" style="display: block;" class="tableContainer">							
					</div>
				</div>			
				<div id="distShareTotalAmtDiv" class="tableHeader"  style="display: none; margin:10px; margin-top: 0px;">
					<div style="width:100%;">
						<!-- replaced by robert 10.13.15 GENQA 5053 				
						<label style="text-align:left; width: 220px; margin-right: 5px; margin-left: 5px; float:left;">Total:</label>
						<label id="totalDistSpct" style="text-align:right; width: 200px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistTsi" style="text-align:right; width: 210px; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistPrem" style="text-align:right; width: 210px; margin-right: 5px; float:left;" class="money">&nbsp;</label> -->
						<label style="text-align:left; width: 20%; margin-right: 4px; margin-left: 5px; float:left;">Total:</label>
						<label id="totalDistSpct" style="text-align:right; width: 19.5%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistTsi" style="text-align:right; width: 19%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistSpct1" style="text-align:right; width: 19.5%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
						<label id="totalDistPrem" style="text-align:right; width: 19%; margin-right: 4px; float:left;" class="money">&nbsp;</label>
					</div>
				</div>					
				<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
					<!--  c120 (GIUW_POL_DIST) block -->
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
						<td class="rightAligned">% Share</td>
						<td class="leftAligned">
							<!-- changed nthDecimal property from 14 to 9 and maxlength from 18 to 13 edgar 05/06/2014-->
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct" name="txtDistSpct" value="" style="width:250px;" maxlength="13" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Sum Insured</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistTsi" name="txtDistTsi" value="" style="width:250px;" maxlength="18" />
						</td>
					</tr>
					<tr> <!-- added by robert 10.13.15 GENQA 5053  -->
						<td class="rightAligned">% Share Premium</td>
						<td class="leftAligned">
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct1" name="txtDistSpct1" value="" style="width:250px;" maxlength="13" /> 
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistPrem" name="txtDistPrem" value="" style="width:250px;" maxlength="14"/>  <!-- readonly="readonly"/> removed readonly by robert 10.13.15 GENQA 5053  -->
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
			<input type="button" id="btnCreateItems"	name="btnCreateItems"	style="width : 100px;" class="button"			value="Create Items" />
			<input type="button" id="btnViewDist"		name="btnViewDist"		style="width : 100px;" class="disabledButton"	value="View Dist." />
			<!--  input type="button" id="btnPostDist" 		name="btnPostDist" 		style="width : 150px;" class="button"	value="Post Dist. to RI" /--> <!-- commented out to increase width for post button edgar 06/06/2014 -->			
			<input type="button" id="btnPostDist" 		name="btnPostDist" 		style="width : 180px;" class="button"	value="Post Dist. to RI" /><!-- edgar 06/06/2014 -->
			<input type="button" id="btnCancel"			name="btnCancel"		style="width : 100px;" class="button"			value="Cancel" />
			<input type="button" id="btnSave" 			name="btnSave" 			style="width : 100px;" class="button"			value="Save" />			
		</div>
	</form>
</div>
<div id="summarizedDistDiv1"></div>

<script>
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIUWS003");
	setDocumentTitle("Preliminary Peril Distribution");	

	var objSelected = null;
	var distNo = "";
	var distSeqNo = "";
	var perilCd = "";
	var shareCd = "";
	var isSavePressed =true; // to check whether the [Save] button was pressed or not -  jeffdojello 04192013
	
	objGIUWPolDist = JSON.parse('${giuwPolDist}');
	objGIUWWPerilds = [];
	objGIUWWPerildsDtl = [];

	var selectedDistGroupRow = null; // added by emman (05.26.2011)
	var selectedGIUWWPerildsDtl = {}; // added by emman (05.26.2011)
	var distShareRecordStatus = "INSERT";
	var distListing = {};
	var giuwPolDistPostedRecreated = [];
	var selectedPerilRow = null;

	// for saving
	var giuwPolDistRows = [];
	var giuwWPerildsRows = [];
	var giuwWPerildsDtlSetRows = [];
	var giuwWPerildsDtlDelRows = [];

	// for posting
	var postResult = {};
	var netOverride = "N";
	var treatyOverride = "N";

	// VARIABLES
	
	var varVPolFlag = 1;
	var varVChanges = "N";
	var varVPostSw = "Y";

	// for package (emman 07.13.2011)
	var isPack = '${isPack}';

	// Global Variables (emman 07.12.2011)
	var globalParType = (isPack != "Y") ? $F("globalParType") : objUWGlobal.parType;
	var globalLineCd = (isPack != "Y") ? $F("globalLineCd") : null;
	var globalParId = (isPack != "Y") ? $F("globalParId") : objUWGlobal.packParId;
	var globalPackParId = (isPack != "Y") ? $F("globalPackParId") : objUWGlobal.packParId;
	var globalSublineCd = (isPack != "Y") ? $F("globalSublineCd") : null;
	var globalIssCd = (isPack != "Y") ? $F("globalIssCd") : null;
	var globalPackPolFlag = (isPack != "Y") ? $F("globalPackPolFlag") : null;
	var globalPolFlag = (isPack != "Y") ? $F("globalPolFlag") : null;

	//for getting takeupterm edgar 05/08/2014
	var takeUpTerm = "";
	var netTreaty;//added variable netTreaty edgar 06/10/2014
	var netOverrideOk; //edgar 06/19/2014
	var treatyOverrideOk; //edgar 06/19/2014
	var postingOk; //edgar 06/19/2014
	var vProcess; //edgar 06/20/2014
	var vFound = 'N';//edgar 07/02/2014
	var distScpt1Null = 'Y';//edgar 07/02/2014
	
	buttonLabel(null); // added to disable create item button when page is loaded (emman 06.24.2011)

	// Execute WHEN-NEW-BLOCK instance enabling View Distribution button when par is endt (emman 06.01.2011)
	/**if (globalParType == "E") {
		enableButton("btnViewDist");
	} else {
		disableButton("btnViewDist");
	}*/ //commented out so that View Dist button will only enable if a group is selected : edgar 06/25/2014 

	/** page functions */

	function prepareDistRow(obj){
		try{
			var content = 
				'<label style="width: 160px; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
				'<label style="width: 280px; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+'-'+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
				'<label style="width: 280px; text-align: left; ">'+nvl(obj.multiBookingMm,'')+'-'+nvl(obj.multiBookingYy,'')+'</label>';

			return content;				
		}catch(e){
			showErrorMessage("prepareDistRow", e);
		}
	}

	function prepareDistPerilRow(obj){
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
			showErrorMessage("prepareDistPerilRow", e);
		}
	}

	function prepareDistGroupRow(obj){
		try{
			var groupNo 	= obj == null ? "" : obj.distSeqNo;
			var currency 	= obj == null ? "" : nvl(obj.currencyDesc, "-");
			
			var content = 
				'<label style="width: 100px; text-align: right; margin-right: 50px;">'+ groupNo.toPaddedString(2) +'</label>' +				
				'<label style="width: 600px; text-align: left;">'+ currency +'</label>';

			return content;
		}catch(e){
			showErrorMessage("prepareDistGroupRow", e);
		}
	}

	function prepareDistShareRow(obj){
		try{		
			var treatyName 		= obj == null ? "" : obj.trtyName; 
			var percentShare	= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 9/*14*/);//changed round off from 14 to 9 edgar 05/07/2014
			var sumInsured		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			var percentPremium	= obj == null ? "" : obj.distSpct1 == null ?  formatToNthDecimal(obj.distSpct, 9) : formatToNthDecimal(obj.distSpct1, 9); //added by robert 10.13.15 GENQA 5053
			var premium			= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);

			var content =				
				/* 	replaced by robert 10.13.15 GENQA 5053
				'<label style="width: 220px; text-align: left; margin-right: 5px; margin-left: 5px;">' + treatyName + '</label>' +
				'<label style="width: 200px; text-align: right; margin-right: 5px;">' + percentShare + '</label>' +
				'<label style="width: 210px; text-align: right; margin-right: 5px;">' + sumInsured + '</label>' +
				'<label style="width: 210px; text-align: right; margin-right: 5px;">' + premium + '</label>'; */
				
				'<label style="width: 20%; text-align: left; margin-right: 4px; margin-left: 5px;">' + treatyName + '</label>' +
				'<label style="width: 19.5%; text-align: right; margin-right: 4px;">' + percentShare + '</label>' +
				'<label style="width: 19%; text-align: right; margin-right: 4px;">' + sumInsured + '</label>' +
				'<label style="width: 19.5%; text-align: right; margin-right: 4px;">' + percentPremium + '</label>' +
				'<label style="width: 19%; text-align: right; margin-right: 4px;">' + premium + '</label>';

			return content;
		}catch(e){
			showErrorMessage("prepareDistShareRow", e);
		}
	}

	function setRowObserver(row, onClickFunc){
		try{
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", onClickFunc);
		}catch(e){
			showErrorMessage("setRowOberver", e);
		}
	}
	
	function unselectRow(tableId){
		try{
			$(tableId).hide();
			
			unClickRow(tableId);
		}catch(e){
			showErrorMessage("unselectRow", e);
		}
	}
	
	function createDistGroupRow(obj){
		try{
			if($("rowDistGroup" + obj.distNo + "_" + obj.distSeqNo) == undefined){
				var content = prepareDistGroupRow(obj);
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowDistGroup" + obj.distNo + "_" + obj.distSeqNo);
				newDiv.setAttribute("name", "rowDistGroup");
				newDiv.setAttribute("distNo", obj.distNo);
				newDiv.setAttribute("groupNo", obj.distSeqNo);
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display : none;");

				newDiv.update(content);

				observeDistGroupRowClick(obj, newDiv);

				$("distGroupListing").insert({bottom : newDiv});
			}			
		}catch(e){
			showErrorMessage("createDistGroupRow", e);
		}
	}

	// click function for Dist Group (emman 05.31.2011)
	function observeDistGroupRowClick(obj, newDiv) {
		setRowObserver(newDiv,
				function(){
					newDiv.toggleClassName("selectedRow");

					if(newDiv.hasClassName("selectedRow")){
						// remove classname of other rows							
						($$("div#distGroupListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");
						// deselect highlighted peril rows
						unClickRow("distPerilTable");
						// hide all rows in peril & show rows related to the selected group
						($("distPerilListing").childElements()).invoke("hide");								
						//($$("div#distPerilListing div[groupNo='" + newDiv.getAttribute("groupNo") + "']")).invoke("show");
						$$("div#distPerilListing div[groupNo='" + newDiv.getAttribute("groupNo") + "']").each(function (distPerilRow) {
							if (distPerilRow.getAttribute("distNo") == newDiv.getAttribute("distNo")) {
								distPerilRow.show();
							}
						});
						// resize & show the peril table
						resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");

						selectedDistGroupRow = obj;
						//added by edgar 06/25/2014 to enable View Dist when endorsement
						if (obj != null){
							if (globalParType == "E") { 
								enableButton("btnViewDist");
							} else {
								disableButton("btnViewDist");
							}
						}
						//edgar 06/25/2014
						selectedPerilRow = null;
					}else{								
						//unselectRow("distPerilTable");
						unClickRow("distPerilTable");
						$("distPerilTable").hide();
						selectedDistGroupRow = null;
						selectedPerilRow = null;
						disableButton("btnViewDist");//added by edgar 06/25/2014
					}
				});
	}

	function createDistPerilRow(obj){
		try{			
			var content = prepareDistPerilRow(obj);
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowDistPeril" + obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd);
			newDiv.setAttribute("name", "rowDistPeril");
			newDiv.setAttribute("distNo", obj.distNo);
			newDiv.setAttribute("groupNo", obj.distSeqNo);
			newDiv.setAttribute("perilCd", obj.perilCd);
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display : none;");

			newDiv.update(content);

			setRowObserver(newDiv,
					function(){
						newDiv.toggleClassName("selectedRow");

						if (selectedPerilRow != null) {
							populateDistAndRiTables();
						}
						
						if(newDiv.hasClassName("selectedRow")){
							var id1 = obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd;						
							($$("div#distPerilListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");								

							($("distShareListing").childElements()).invoke("hide");
							($$("div#distShareListing div[id1='" + id1 + "']")).invoke("show");
							// resize & show the peril table
							resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
							
							if($("distShareTable").visible){
								computeDistShareFieldsTotalValues(id1);
								//$("distShareTable").setStyle("height: " + ($("distShareTable").getHeight() + 31) + "px;");
							}
							
							selectedPerilRow = obj;

							enableButton("btnTreaty");
							enableButton("btnShare");

							unClickRow("distShareTable");
						}else{							
							selectedPerilRow = null;
							selectedGIUWWPerildsDtl = {};
							disableButton("btnTreaty");
							disableButton("btnShare");
							unClickRow("distShareTable");
							$("distShareTable").hide();
							$("distShareTotalAmtDiv").hide();
						}
					});

			$("distPerilListing").insert({bottom : newDiv});

			//unselectRow("distShareTable");
			unClickRow("distShareTable");
		}catch(e){
			showErrorMessage("createDistPerilRow", e);
		}
	}
	
	function assignAmtToObj(amt, objPre, objSca, index){
		try{
			objPre[index] = parseInt(nvl(amt[0], "0"));
			objSca[index] = (nvl(amt[1], "0")).replace(/^0/, "");//parseInt(nvl(((parseInt(amt[0]) < 0) ? "-" : "") + amt[1], "0"));			
		}catch(e){
			showErrorMessage("assignAmtToObj", e);
		}						
	}
	
	function computeDistShareFieldsTotalValues(id1){
		try{
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
				assignAmtToObj(amount, objPreDistSpct1, objScaDistSpct1, count); //added by robert 10.13.15 GENQA 5053
				
				amount = ((row.down("label", 4)).innerHTML).replace(/,/g, "").split("."); //added by robert 10.13.15 GENQA 5053
				assignAmtToObj(amount, objPreDistPrem, objScaDistPrem, count);
				
				count++;
			});
			
			$("totalDistSpct").innerHTML = formatToNthDecimal(addDeciNumObject(objPreDistSpct, objScaDistSpct, 1000000000/*00000*/), 9/*14*/);//changed rounding off from 14 to 9 and reduce zeros to 9 edgar 05/06/2014
			$("totalDistTsi").innerHTML = formatCurrency(addDeciNumObject(objPreDistTsi, objScaDistTsi, 100));
			$("totalDistSpct1").innerHTML = formatToNthDecimal(addDeciNumObject(objPreDistSpct1, objScaDistSpct1, 1000000000), 9); //added by robert 10.13.15 GENQA 5053
			$("totalDistPrem").innerHTML = formatCurrency(addDeciNumObject(objPreDistPrem, objScaDistPrem, 100));
			if(count > 0){
				$("distShareTotalAmtDiv").show();
			}else{
				$("distShareTotalAmtDiv").hide();
			}
		}catch(e){
			showErrorMessage("computeDistShareFieldsTotalValues", e);
		}
	}
	
	function addDeciNumObject(preciseObj, scaleObj, divisor){
		try{
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
			
			return (addends1 + "." + formatNumberDigits(addends2.abs(), (divisor.toString().length - 1))); //added toString() in divisor by robert 09182013
		}catch(e){
			showErrorMessage("addDeciNumObject", e);
		}
		
	}

	function createDistShareRow(obj){
		try{
			var content = prepareDistShareRow(obj);
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

			setRowObserver(newDiv, 
					function() {
						clickDistShareRow(newDiv, obj);
					});

			$("distShareListing").insert({bottom : newDiv});
		}catch(e){
			showErrorMessage("createDistShareRow", e);
		}
	}
	
	function setDistShareFormFields(obj){
		try{
			selectedGIUWWPerildsDtl 	= obj == null ? {} : obj;	
			$("txtDspTrtyName").value 	= obj == null ? "" : unescapeHTML2(obj.trtyName);
			$("txtDistSpct").value 		= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 9/*14*/);//changed rounding off to 9 decimals
			$("txtDistTsi").value 		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			$("txtDistSpct1").value 	= obj == null ? "" : obj.distSpct1 == null ? formatToNthDecimal(obj.distSpct, 9) : formatToNthDecimal(obj.distSpct1, 9);  //added by robert 10.13.15 GENQA 5053
			$("txtDistPrem").value 		= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);
			$("shareCd").value			= obj == null ? "" : obj.shareCd == null ? "" : obj.shareCd;
			$("c080lineCd").value		= obj == null ? "" : obj.lineCd == null ? "" : obj.lineCd;
			
			$("btnAddShare").value		= obj == null ? "Add" : "Update";
			
			obj == null ? disableButton($("btnDeleteShare")) : enableButton($("btnDeleteShare"));

			if (obj == null){
				enableButton("btnTreaty");
				enableButton("btnShare");
			}else{
				disableButton("btnTreaty");
				disableButton("btnShare");
			}
		}catch(e){
			showErrorMessage("setDistShareFormFields", e);
		}
	}

	function createAdditionalList(objArr){
		try{
			for(var i=0, length=objArr.length; i < length; i++){
				createDistGroupRow(objArr[i]);
				createDistPerilRow(objArr[i]);
				
				// add giuwWPerilds to the list
				objGIUWWPerilds.push(objArr[i]);

				for(var x=0, y=objArr[i].giuwWPerildsDtl.length; x < y; x++){					
					createDistShareRow(objArr[i].giuwWPerildsDtl[x]);
					
					// add giuwWPerildsDtl to the list
					objGIUWWPerildsDtl.push(objArr[i].giuwWPerildsDtl[x]);
				}				
			}
		}catch(e){
			showErrorMessage("createAdditionalList", e);
		}		
	}

	function showDistributionList(){
		try{
			for(var i=0, length=objGIUWPolDist.length; i < length; i++){
				var content = prepareDistRow(objGIUWPolDist[i]);
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowPrelimPerilDist" + objGIUWPolDist[i].distNo);
				newDiv.setAttribute("name", "rowPrelimPerilDist");
				newDiv.setAttribute("distNo", objGIUWPolDist[i].distNo);
				newDiv.setAttribute("parId", objGIUWPolDist[i].parId);
				newDiv.addClassName("tableRow");

				if (isPack == "Y") {
					newDiv.setStyle("display : none");
				}
				
				newDiv.update(content);
				
				loadRowMouseOverMouseOutObserver(newDiv);
				
				/*newDiv.observe("click", function() {
					clickPrelimPerilRow(newDiv);
				});*/

				$("distListing").insert({bottom : newDiv});				
				
				createAdditionalList(objGIUWPolDist[i].giuwWPerilds);							
			}

			resizeTableBasedOnVisibleRows("distListingTable", "distListing");
			resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
			resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
			resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");

			$$("div#distListingTable div[name='rowPrelimPerilDist']").each(function(row){
				row.observe("click", function() {		
					clickPrelimPerilRow(row);
				});
			});
		}catch(e){
			showErrorMessage("showDistributionList", e);
		}
	}

	showDistributionList();

	// parlist observer (emman 07.13.2011)
	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setPackParPolicyObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}

	function setPackParPolicyObserver(row) {
		try {
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){					
					($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");

					($("distListing").childElements()).invoke("hide");
					($$("div#distListing div[parId='"+ row.readAttribute("parId") +"']")).invoke("show");

					unClickRow("distListingTable");
					unClickRow("distGroupListingTable");
					unClickRow("distPerilTable");
					unClickRow("distShareTable");

					// set global vars
					globalLineCd = row.readAttribute("lineCd");
					globalSublineCd = row.readAttribute("sublineCd");
					globalIssCd = row.readAttribute("issCd");
					globalPolFlag = row.readAttribute("polFlag");
					globalPackPolFlag = row.readAttribute("packPolFlag");

					resizeTableBasedOnVisibleRows("distListingTable", "distListing");

					$("distGroupListingTable").hide();
					$("distPerilTable").hide();
					$("distShareTable").hide();

					// set global variables in pack par parameter form (emman 07.15.2011)
					if($("globalParId") != null) $("globalParId").value = row.readAttribute("parId"); // andrew - 10.02.2011					
					if($("globalLineCd") != null) $("globalLineCd").value = globalLineCd;  // andrew - 10.02.2011
					$("initialParId").value = row.readAttribute("parId"); //andrew - 10.03.2011
					$("initialLineCd").value = globalLineCd; //andrew - 10.03.2011
				} else {
					$("distListingTable").hide();
					$("distGroupListingTable").hide();
					$("distPerilTable").hide();
					$("distShareTable").hide();	
					supplyDistribution(null);
					buttonLabel(null);

					objSelected = null;
					selectedDistGroupRow = null;
					selectedPerilRow = null;

					unClickRow("distListingTable");
					unClickRow("distGroupListingTable");
					unClickRow("distPerilTable");
					unClickRow("distShareTable");

					// reset global vars
					globalLineCd = null;
					globalSublineCd = null;
					globalIssCd = null;
					globalPolFlag = null;
					globalPackPolFlag = null;

					// reset global variables in pack par parameter form (emman 07.15.2011)
					if($("globalParId") != null) $("globalParId").value = ""; // andrew - 10.02.2011
					if($("globalLineCd") != null) $("globalLineCd").value = ""; // andrew - 10.02.2011
					objCurrPackPar = null;
				}
			});
		} catch(e){
			showErrorMessage("setPackParPolicyRowObserver", e);
		}
	}

	function supplyDistribution(obj){
		try{
			$("txtC080DistNo").value			= obj == null ? null : nvl(obj.distNo, "") == "" ? null : formatNumberDigits(obj.distNo,8);
			$("txtC080DistFlag").value			= obj == null ? null : nvl(obj.distFlag, "");
			$("txtC080MeanDistFlag").value		= obj == null ? null : nvl(obj.meanDistFlag, "");
			$("txtC080MultiBookingMm").value	= obj == null ? null : nvl(obj.multiBookingMm, "");
			$("txtC080MultiBookingYy").value	= obj == null ? null : nvl(obj.multiBookingYy, "");
		}catch(e){
			showErrorMessage("supplyDistribution", e);
		}
	}


	
	function getListing(){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "getDistListing",
					globalParId: (objSelected == null) ? 0 : objSelected.parId,
					nbtLineCd: (selectedDistGroupRow == null) ? null : selectedDistGroupRow.lineCd,
					lineCd: globalLineCd
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

	function startLOV(id, title, objArray, width){
		try{
			if (selectedPerilRow == null) {
				showMessageBox("Please select peril first.", imgMessage.INFO);
			} else if (selectedGIUWWPerildsDtl == null) {
				return;
			} else {
				var copyObj = objArray.clone();	
				var copyObj2 = objArray.clone();	
				var selGrpObjArray = selectedPerilRow.giuwWPerildsDtl.clone(); //objGIUWWPerildsDtl.clone();
				selGrpObjArray = selGrpObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
				var share = selectedGIUWWPerildsDtl;
				for(var a=0; a<selGrpObjArray.length; a++){
					for(var b=0; b<copyObj.length; b++){
						if (selGrpObjArray[a].shareCd == copyObj[b].shareCd && selGrpObjArray[a].perilCd == selectedPerilRow.perilCd){
							copyObj.splice(b,1);
							b--;
						}	
					}	
				}
				if (nvl(share.recordStatus,null) == 0){
					for(var b=0; b<copyObj2.length; b++){
						if (nvl(share.shareCd,'') == copyObj2[b].shareCd) {// && nvl(share.perilCd,'') == copyObj2[b].perilCd){
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
						selectedGIUWWPerildsDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");
						selectedGIUWWPerildsDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
						selectedGIUWWPerildsDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");
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
				/* codeDiv.setAttribute("title", nvl(objArray[a].trtyCd,''));
				codeDiv.update(nvl(objArray[a].trtyCd,'&nbsp;')); */
				codeDiv.setAttribute("title", nvl(nvl(objArray[a].shareCd,objArray[a].trtyCd),'')); //robert 09192013
				codeDiv.update(nvl(nvl(objArray[a].shareCd,objArray[a].trtyCd),'&nbsp;')); //robert 09192013
				
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

	function checkDistFlag() {
		var ok = true;

		new Ajax.Request(contextPath+"/GIUWPolDistController?action=checkDistFlagGiuws003", {
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				distNo: (selectedGIUWWPerildsDtl == null) ? null : nvl(selectedGIUWWPerildsDtl.distNo, null),
				distSeqNo: (selectedGIUWWPerildsDtl == null) ? null : nvl(selectedGIUWWPerildsDtl.distSeqNo, null),
				perilCd: (selectedGIUWWPerildsDtl == null) ? null : nvl(selectedGIUWWPerildsDtl.perilCd, null)
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					var vCount = result.pCount;
					var vCount2 = result.pCount2;

					if(vCount == 0 && vCount2 != 0 && $F("txtC080DistFlag") == "2"){
						showMessageBox("Distribution Flag = 2 and GIUW_WPERILDS_DTL has no record.", imgMessage.INFO);
						ok = false;
						return false;
					}
				}
			}
		});

		return ok;
	}

	function onOkFunc(){
		try{
			var objArray = objGIUWPolDist;
			var index = 0;
			var distNo = Number($F("txtC080DistNo"));

			for(var a=0; a<objArray.length; a++){
				if (objArray[a].distNo == distNo && objArray[a].recordStatus != -1){
					index = a;
					objArray[a].recordStatus = -1;
					var recObj = new Object();
					recObj.distNo = distNo;
					recObj.parId = (objSelected == null) ? 0 : objSelected.parId;//globalParId;
					recObj.lineCd = globalLineCd;
					recObj.sublineCd = globalSublineCd;
					recObj.issCd = globalIssCd;
					recObj.packPolFlag = globalPackPolFlag;
					recObj.polFlag = globalPolFlag;
					recObj.parType = globalParType;
					recObj.itemGrp = (objSelected == null) ? null : nvl(objSelected.itemGrp, null);
					recObj.process = "R";
					recObj.processId = giuwPolDistPostedRecreated.length;
					recObj.label = $("btnCreateItems").value; //added by robert 10.13.15 GENQA 5053
					
					giuwPolDistPostedRecreated.push(recObj);
					$("rowPrelimPerilDist"+distNo).update("");
					$$("div#distGroupListing div[name=rowDistGroup]").each(function(row){
						if (row.readAttribute("distNo") == objArray[a].distNo){
							row.remove();
						}	
					});
					$$("div#distPerilListing div[name=rowDistPeril]").each(function(row){
						if (row.readAttribute("distNo") == objArray[a].distNo){
							row.remove();
						}	
					});
					$$("div#distShareListing div[name=rowDistShare]").each(function(row){
						if (row.readAttribute("distNo") == objArray[a].distNo){
							row.remove();
						}	
					});

					resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
					resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
				}	
			}

			createItems(index, distNo);
			clearForm();
		}catch(e){
			showErrorMessage("onOkFunc", e);
		}
	}

	function createItems(index, distNo){
		try{
			var ok = true;
			var noticeMsg = $("btnCreateItems").value == "Recreate Items" ? "Recreating" :"Creating";
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "createItemsGiuws006", //"createItemsGiuws003", replaced by robert SR 5053 11.11.15
					distNo: distNo,
					parId: (objSelected == null) ? 0 : objSelected.parId,//globalParId,
					lineCd: globalLineCd,
					sublineCd: globalSublineCd,
					issCd: globalIssCd,
					packPolFlag: globalPackPolFlag,
					polFlag: globalPolFlag,
					parType: globalParType,
					itemGrp: (objSelected == null) ? null : nvl(objSelected.itemGrp, null),
					label: $("btnCreateItems").value	 //added by robert SR 5053 11.11.15
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice(noticeMsg+" Items, please wait...");
				},	
				onComplete: function(response){
					hideNotice("");
					//var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					var res = JSON.parse(response.responseText);
					if (checkErrorOnResponse(response)){
						if (res.message == ""){
							obj = res.newItems;
							obj.divCtrId = index;
							obj.recordStatus = 0;
							var objArray = objGIUWPolDist;
							objArray[index] = obj;
							//checkAutoDist1(objArray[index]); commented out
							enableButton("btnPostDist"); // enable the button instead	
							$("btnPostDist").value = (nvl(obj.varShare,null) == "Y" ? "Post Distribution to RI" : "Post Distribution to Final");
							obj.autoDist = "N";
							objSelected = obj;
							var content = prepareDistRow(objArray[index]);
							$("rowPrelimPerilDist"+distNo).update(content);
							//showListPerObj(objArray[index], index);

							//Group
							createAdditionalList(objArray[index].giuwWPerilds);

							// show groups with similar distNo						
							/*($("distGroupListing").childElements()).invoke("hide"); //distGroupListingTable
							($$("div#distGroupListing div[distNo='"+ objArray[index].distNo +"']")).invoke("show");*/

							$("distGroupListingTable").hide();
							$("distPerilTable").hide();
							$("distShareTable").hide();		
							supplyDistribution(null);
							//buttonLabel(null);

							// resize & show the group table
							resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");

							// enable View Distribution button if PAR is endt.
							if (globalParType == "E") {
								enableButton("btnViewDist");
							} else {
								disableButton("btnViewDist");
							}

							//changeTag=1; //edgar 06/19/2014
							//varVChanges = "Y"; //edgar 06/19/2014
							showMessageBox(noticeMsg+" Items complete.", imgMessage.SUCCESS);
						}else{
							ok = false;
							customShowMessageBox(res.message, imgMessage.ERROR, "btnCreateItems");
							return false;
						}	
					}
				}	
			});	
			$("btnCreateItems").value = "Recreate Items";
			return ok;
		}catch (e) {
			showErrorMessage("createItems", e);
		}	
	}

	function checkAutoDist1(obj){
		if (nvl(obj.varShare,'N') == "Y"){
			obj.autoDist = "N";
			$("btnPostDist").value = "Post Distribution to RI";
		}else{
			if ($("btnPostDist").value == "Post Distribution to Final" && nvl(obj.autoDist,'N') == "N"){
				obj.autoDist = "Y";
				$("btnPostDist").value = "Unpost Distribution to Final";
			}else if ($("btnPostDist").value == "Unpost Distribution to Final" && nvl(obj.autoDist,'N') == "Y"){
				obj.autoDist = "N";
				if (nvl(obj.varShare,'N') == "Y"){
					$("btnPostDist").value = "Post Distribution to RI";
				}else{
					$("btnPostDist").value = "Post Distribution to Final";
				}
			}
		}
	}

	function procedurePreCommit(){
		try{
			var ok = true;
			var ctr = 0;
			var sumDistSpct = 0;
			var sumDistSpct1 = 0; //added by robert SR 5053 11.11.15
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var tempDistTsi = 0;//added for handling share with TSI and Premium having odd decimal values edgar 05/14/2014
			var tempDistPrem = 0;//added for handling share with TSI and Premium having odd decimal values edgar 05/14/2014
			var diffDistPrem = 0; //added by carlo SR 23761
			var diffDistTsi = 0; //added by carlo SR 23761
			var absDistTsi = 0; //added by carlo SR 23761
			var absDistPrem = 0;//added by carlo SR 23761
			
			var objArray = objGIUWPolDist;
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
									if(parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,0)) == 0 && parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0)) == 0
										 &&	globalParType != "E" //added by robert per maam grace 6.6.2013
									){//modified distGrp to distSeqNo edgar 06/09/2014
										showMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo/*distGrp*/+" with peril of "+objArray[a].giuwWPerilds[b].perilName+
												       " cannot have both its TSI and premium equal to zero.", "I");
										return false;
									//removed by robert SR 5053 11.11.15
									//}else if(parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0)) == 0 /*&& globalParType == "E"*/){	// commented checking of parType : shan 08.14.2014
									//	showMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" with peril of "+objArray[a].giuwWPerilds[b].perilName+
									//		       " cannot have a share percent equal to zero.", "I");
									//	return false;
									}//added else if condition above to handle endorsements with zero share % edgar 06.09.2014
									objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1 = nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1, objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct); //added by robert SR 5053 11.11.15
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0));
									sumDistSpct1 = (parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0))); //added by robert SR 5053 11.11.15
									// modified to handle dist share with odd decimal value on Sum Insured and Premium edgar 06/06/2014
									//tempDistTsi = (parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0)) / 100) * nvl(objArray[a].giuwWPerilds[b].tsiAmt,0); removed by robert SR 5053 12.21.15
									//sumDistTsi = parseFloat(sumDistTsi) + tempDistTsi;//parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,0)); removed by robert SR 5053 12.21.15
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,0)); //added by robert SR 5053 12.21.15
									//tempDistPrem = (parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0)) / 100) * nvl(objArray[a].giuwWPerilds[b].premAmt,0); //removed by robert SR 5053 11.11.15
									//tempDistPrem = (parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0)) / 100) * nvl(objArray[a].giuwWPerilds[b].premAmt,0); //added by robert SR 5053 11.11.15
									//sumDistPrem = parseFloat(sumDistPrem) + tempDistPrem;//parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0)); //removed by robert SR 5053 12.21.15
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0)); //added by robert SR 5053 12.21.15
									// end of modification edgar 06/06/2014
								}
							}
							function err(msg){
								var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowPrelimPerilDist");
								dist == "rowPrelimPerilDist"+nvl(objArray[a].distNo,'---') ? null : ($("rowPrelimPerilDist"+nvl(objArray[a].distNo,'---')) ? fireEvent($("rowPrelimPerilDist"+nvl(objArray[a].distNo,'---')), "click") :null);
								dist == "rowPrelimPerilDist"+nvl(objArray[a].distNo,'---') ? null : ($("rowPrelimPerilDist"+nvl(objArray[a].distNo,'---')) ? $("rowPrelimPerilDist"+nvl(objArray[a].distNo,'---')).scrollIntoView() :null);
								//disableButton("btnPostDist");
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
							//changed && to || - to handle dist with allied peril with 0 TSI - christian
							//added condition ctr == 1 to promt the error message only if the sharecd is 1 and recompute share if more than
							//changed rounding off from 14 to 9 and commented out condition ctr == 1 edgar 05/06/2014
							//if ((roundNumber(sumDistSpct, 9/*14*/) != 100 || roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2)) /*&& ctr == 1*/){ removed by robert SR 5053 12.21.15
							if ((roundNumber(sumDistSpct, 9) < parseFloat("99.5") ) || (roundNumber(sumDistSpct, 9) > parseFloat("100.5"))  || roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2) ){
								//err("Total TSI %Share should be equal to 100."); //added TSI by robert SR 5053 11.11.15 
								//added by carlo to handle odd decimal value SR 23761 02.08.2016 
								diffDistTsi = roundNumber(sumDistTsi, 2) - roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2);
								absDistTsi = diffDistTsi < 0 ? Math.abs(diffDistTsi) : diffDistTsi;
								if(sumDistSpct == 100.00){
									if(roundNumber(absDistTsi, 2) <= 0.05){//0.05 max adjustable value
										ok = true;
									}
								}else{//end SR 23761
									err("The total distribution sum insured should be equal to the Peril Sum Insured."); 
									return false;
								}
							}
							//added by robert SR 5053 11.11.15
							if ((roundNumber(nvl(sumDistSpct1,sumDistSpct), 9) < parseFloat("99.5") || roundNumber(nvl(sumDistSpct1,sumDistSpct), 9) > parseFloat("100.5") || roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].premAmt,0), 2))){
								//added by carlo to handle odd decimal value SR 23761 02.08.2016
								diffDistPrem = roundNumber(sumDistPrem, 2) - roundNumber(nvl(objArray[a].giuwWPerilds[b].premAmt,0), 2);
								absDistPrem = diffDistPrem < 0 ? Math.abs(diffDistPrem) : diffDistPrem;
								if(sumDistSpct1 == 100.00){
									if(roundNumber(absDistPrem, 2) <= 0.05){//0.05 max adjustable value
										ok =  true;
									}
								}else{//end SR 23761
									err("The total distribution premium amount should be equal to the peril premium amount.");
									return false;
									}
							}
							sumDistSpct = 0;
							sumDistSpct1 = 0; //added by robert SR 5053 11.11.15
							sumDistTsi = 0;
							sumDistPrem = 0;
							ctr = 0;
						}	
					}
				}
			}
			return ok;
		}catch(e){
			showErrorMessage("procedurePreCommit", e);
		}
	}

	function checkC1407TsiPremium(){
		try{
			if((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E"){
				return true;
			}
			var ok = true;
			var objArray = objGIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi == 0 && 
										(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != undefined && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != "undefined")){
									var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowPrelimPerilDist");
									dist == "rowPrelimPerilDist"+objArray[a].distNo ? null :fireEvent($("rowPrelimPerilDist"+objArray[a].distNo), "click");
									dist == "rowPrelimPerilDist"+objArray[a].distNo ? null :$("rowPrelimPerilDist"+objArray[a].distNo).scrollIntoView();
									//disableButton("btnPostDist");
									showWaitingMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" cannot have both its TSI and premium equal to zero.", imgMessage.ERROR,
										function(){
											var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
											grp == "rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo? null :fireEvent($("rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo), "click");
										});
									ok = false;
									return false;
								}
							}
						}	
					}
				}
			}
			return ok;
		}catch(e){
			showErrorMessage("checkC1407TsiPremium", e);
		}
	}

	function prepareDistForSaving(){
		try{
			giuwPolDistRows.clear();
			giuwWPerildsRows.clear();
			giuwWPerildsDtlSetRows.clear();
			giuwWPerildsDtlDelRows.clear();

			var objArray = objGIUWPolDist.clone();
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

	function prepareObjParameters(){
		try{
			var objParameters = new Object();
			var tempGiuwPolDistRows = giuwPolDistRows;
			
			for(var i=0; i<tempGiuwPolDistRows.length; i++){
				tempGiuwPolDistRows[i].perilName = "";
				for(var j=0; j<tempGiuwPolDistRows[i].giuwWPerilds.length; j++){
					tempGiuwPolDistRows[i].giuwWPerilds[j].perilName = "";
				}			
			}
						
			objParameters.giuwPolDistPostedRecreated	= prepareJsonAsParameter(giuwPolDistPostedRecreated);
			objParameters.giuwPolDistRows 				= prepareJsonAsParameter(tempGiuwPolDistRows);
			objParameters.giuwWPerildsRows 				= prepareJsonAsParameter(giuwWPerildsRows);
			objParameters.giuwWPerildsDtlSetRows 		= prepareJsonAsParameter(giuwWPerildsDtlSetRows);
			objParameters.giuwWPerildsDtlDelRows 		= prepareJsonAsParameter(giuwWPerildsDtlDelRows);
			objParameters.parId							= globalParId;
			objParameters.lineCd						= globalLineCd;
			objParameters.sublineCd						= globalSublineCd;
			objParameters.polFlag						= varVPolFlag; //globalPolFlag;
			objParameters.parType						= globalParType;
			objParameters.postSw						= varVPostSw;
			
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}

	function buttonLabel(obj){
		try{
			if (obj == null){
				disableButton("btnCreateItems");
				$("btnCreateItems").value = "Create Items";
				disableButton("btnViewDist"); //enable button if PAR is endt.
				disableButton("btnPostDist");
				$("btnPostDist").value = "Post Distribution to Final";	//Changed RI to Final	
			}else{
				var giuwWpolicydsDtlExist = "N";
				for(var b=0; b<obj.giuwWPerilds.length; b++){
					if (obj.giuwWPerilds[b].giuwWPerildsDtl.length > 0){
						giuwWpolicydsDtlExist = "Y";
					}		
				}
				if (giuwWpolicydsDtlExist == "Y"){
					enableButton("btnCreateItems");
					$("btnCreateItems").value = "Recreate Items";
					enableButton("btnPostDist");
					if (obj.distFlag != "2" || nvl(obj.distFlag,"") == ""){
						enableButton("btnCreateItems");
					}else if(obj.distFlag == "2"){
						disableButton("btnCreateItems");
						disableButton("btnPostDist");//edgar 06/20/2014
					}	
					if (nvl(obj.varShare,null) == "Y"){
						$("btnPostDist").value = "Post Distribution to RI";
						enableButton("btnPostDist");
						if(obj.distFlag == "2"){//added if edgar 06/20/2014
							disableButton("btnPostDist"); 
						}
					}else{
						$("btnPostDist").value = "Post Distribution to Final";
						enableButton("btnPostDist"); 
					}	
					if (nvl(obj.autoDist,null) == "Y"){
						$("btnPostDist").value = "Unpost Distribution to Final";
						enableButton("btnPostDist"); 
					}			
				}else{
					enableButton("btnCreateItems");
					$("btnCreateItems").value = "Create Items";
					var vPolicydsRecExists = "N";
					for(var b=0; b<obj.giuwWPerilds.length; b++){
						if (obj.giuwWPerilds[b].distFlag == "2" && obj.giuwWPerilds[b].recordStatus != -1){
							vPolicydsRecExists = "Y";
						}	
					}	
					disableButton("btnPostDist"); 
					if (vPolicydsRecExists == "Y"){
						disableButton("btnCreateItems");
					}else{
						enableButton("btnCreateItems");
					}	
				}
				if(obj.distFlag == "3" || (nvl(obj.reverseDate,null) == null && nvl(obj.reverseSw,null) == "N")){
					disableButton("btnCreateItems");
				}	
			}	
		}catch(e){
			showErrorMessage("buttonLabel", e);
		}
	}

	function checkOverrideNetTreaty(){
		try{
			commonOverrideOkFunc = function(){
				changeTag=1;
				netOverride = postResult.paramFunction == "RO" ? "Y" :netOverride;
				treatyOverride = postResult.paramFunction == "TO" ? "Y" :treatyOverride;
				var id = getSelectedRowIdInTable("distListing", "rowPrelimPerilDist");
				objSelected.varShare = postResult.newItems.varShare;
				objSelected.postFlag = postResult.newItems.postFlag;
				objSelected.distFlag = postResult.newItems.distFlag;
				objSelected.autoDist = postResult.newItems.autoDist; // added (emman 06.24.2011)
				objSelected.meanDistFlag = postResult.newItems.meanDistFlag; //commneted out code edgar 06/11/2014
				//start edgar 06/11/2014
				//objSelected.varShare = postResult2.newItems.varShare;
				//objSelected.postFlag = postResult2.newItems.postFlag;
				//objSelected.distFlag = postResult2.newItems.distFlag;
				//objSelected.autoDist = postResult2.newItems.autoDist;
				//objSelected.meanDistFlag = postResult2.newItems.meanDistFlag;
				//end edgar 06/11/2014
				objSelected.posted = "Y";
				objSelected.recordStatus = 1;
				var content = prepareDistRow(objSelected);
				$("rowPrelimPerilDist"+id).update(content);
				$("txtC080DistFlag").value = postResult.distFlag;
				$("txtC080MeanDistFlag").value = postResult.meanDistFlag;//commneted out code edgar 06/11/2014
				//start edgar 06/11/2014
				//$("txtC080DistFlag").value = postResult2.distFlag;
				//$("txtC080MeanDistFlag").value = postResult2.meanDistFlag;
				//end edgar 06/11/2014
				//showMessageBox("Post Distribution Complete.", imgMessage.SUCCESS);
				varVPostSw = "Y";
				for(var a=0; a<objSelected.giuwWPerilds.length; a++){
					var obj = new Object();
					obj.parId = objSelected.parId;
					obj.distNo = objSelected.giuwWPerilds[a].distNo;
					obj.distSeqNo = objSelected.giuwWPerilds[a].distSeqNo;
					obj.process = "P";
					obj.processId = giuwPolDistPostedRecreated.length;
					giuwPolDistPostedRecreated.push(obj);
				}
				buttonLabel(objSelected);	
				
			};
			commonOverrideNotOkFunc = function(){
				showWaitingMessageBox($("overideUserName").value+" does not have an overriding function for this module.", imgMessage.ERROR, 
						clearOverride);
			};	
			function override(funcCode){//added funcCode edgar 06/10/2014
				try{
					/*objAC.funcCode = postResult.paramFunction;
					objACGlobal.calledForm = postResult.moduleId;
					getUserInfo();
					var title = postResult.netOverride != null ? postResult.netOverride :(postResult.treatyOverride != null ? postResult.treatyOverride :"Override");
					$("overlayTitle").innerHTML = title;*/ //commented out edgar 06/10/2014
					//start of modification edgar 06/10/2014
					if (funcCode == "RO"){
						objAC.funcCode = funcCode;
						objACGlobal.calledForm = postResult.moduleId;
						showGenericOverride(
								"GIUWS003",
								"RO",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showMessageBox("User "+userId+" is not allowed to override.", imgMessage.ERROR);
										return false;
									} else if(result == 'TRUE') {	
										ovr.close();
										delete ovr;
										if (postResult.treatyMsg != null){
											showConfirmBox("Confirmation", postResult.treatyMsg, 
													"Yes", "No",
													function(){
																if (postResult.treatyOverride != null){
																	if (postResult.overrideMsg != null){
																		showConfirmBox("Confirmation", postResult.overrideMsg, 
																				"Override", "Cancel", 	
																				function(){showGenericOverride(
																						"GIUWS003",
																						"TO",
																						function(ovr, userId, result){
																							if(result == "FALSE"){
																								showMessageBox("User "+userId+" is not allowed to override.", imgMessage.ERROR);
																								return false;
																							} else if(result == 'TRUE') {	
																								ovr.close();
																								delete ovr;
																								if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
																									postDistGiuws003Final();
																								}
																								netOverrideOk = "N";
																								treatyOverrideOk = "N";
																								postingOk = "N";
																							}								
																						},
																						function(){
																							return false;
																						}, "Treaty Override");}, "");
																	}else{
																		if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
																			postDistGiuws003Final();
																		}
																		netOverrideOk = "N";
																		treatyOverrideOk = "N";
																		postingOk = "N";
																	}
																}else{
																	if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
																		postDistGiuws003Final();
																	}
																	netOverrideOk = "N";
																	treatyOverrideOk = "N";
																	postingOk = "N";
																}
													}, "");	
										}else{
											if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
												postDistGiuws003Final();
											}
											netOverrideOk = "N";
											treatyOverrideOk = "N";
											postingOk = "N";
										}
									}								
								},
								function(){
									return false;
								},"Net Retention Override");
					}else if (funcCode == "TO"){
						objAC.funcCode = funcCode;
						objACGlobal.calledForm = postResult.moduleId;
						showGenericOverride(
								"GIUWS003",
								"TO",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showMessageBox("User "+userId+" is not allowed to override.", imgMessage.ERROR);
										return false;
									} else if(result == 'TRUE') {	
										ovr.close();
										delete ovr;
										if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
											postDistGiuws003Final();
										}
										netOverrideOk = "N";
										treatyOverrideOk = "N";
										postingOk = "N";
									}								
								},
								function(){
									return false;
								}, "Treaty Override");
					}
					//end of modification edgar 06/10/2014
				}catch (e) {
					showErrorMessage("checkOverrideNetTreaty - override", e);
				}
			}	
			if (postResult.overrideMsg != null && ((netOverride == "N" && postResult.paramFunction == "RO") || (treatyOverride == "N" && postResult.paramFunction == "TO"))){
				/*showConfirmBox("Confirmation", postResult.overrideMsg, 
						"Override", "Cancel", override, "");*/ // commented out edgar 06/10/2014
				//added by edgar 06/10/2014
				if (netTreaty == "NET"){
					if (postResult.netOverride != null){
						showConfirmBox("Confirmation", postResult.overrideMsg, 
							"Override", "Cancel", 
							function(){
										override("RO");
									  }, "");
					}else{
						if (postResult.treatyMsg != null){
							showConfirmBox("Confirmation", postResult.treatyMsg, 
									"Yes", "No",
									function(){
										showConfirmBox("Confirmation", postResult.overrideMsg, 
												"Override", "Cancel", 
												function(){
															override("TO");
														  }, "");
							},"");
						}
					}
				}else if (netTreaty == "TREATY"){
					showConfirmBox("Confirmation", postResult.overrideMsg, 
							"Override", "Cancel", 
							function(){
										override("TO");
									  }, "");
				}
				//end of addition edgar 06/10/2014
			}else{
				if (postResult.treatyMsg != null && postResult.netMsg != null){
					showConfirmBox("Confirmation", postResult.treatyMsg, 
							"Yes", "No",
							function(){
										if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
											commonOverrideOkFunc();
											postDistGiuws003Final();
										}
										netOverrideOk = "N";
										treatyOverrideOk = "N";
										postingOk = "N";
										
					},"");
				}else if (postResult.treatyMsg != null && postResult.netMsg == null){
					if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
						commonOverrideOkFunc();
						postDistGiuws003Final();
					}
					netOverrideOk = "N";
					treatyOverrideOk = "N";
					postingOk = "N";
				
				}else if (postResult.treatyMsg == null && postResult.netMsg != null){
					if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
						commonOverrideOkFunc();
						postDistGiuws003Final();
					}
					netOverrideOk = "N";
					treatyOverrideOk = "N";
					postingOk = "N";
				
				}else{
					//if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
						commonOverrideOkFunc();
						//postDistGiuws003Final();
					//}
					netOverrideOk = "O";
					//treatyOverrideOk = "Y";
					//postingOk = "Y";
				}
			}
			/*showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS, function (){
				isSavePressed = false;  // to indicate the [Save] button was not pressed jeffdojello 04192013
				fireEvent($("btnSave"), "click"); // andrew - 10.11.2011 - workaround, added to autosave after posting distribution
				isSavePressed = true; // back to default jeffdojello 04192013
			});*/ //commented out edgar 06/25/2014
			//isSavePressed = true; //edgar 06/25/2014
		}catch (e) {
			showErrorMessage("checkOverrideNetTreaty", e);
		}
	}

	function setWPerildsDtl(){
		try{
			var newobj = new Object();
			
			newObj.distNo 		= $F("txDistNo");
			newObj.distSeqNo	= ($$("div#distGroupListingTable .selectedRow"))[0].down("label", 0).innerHTML;
			newObj.lineCd		= globalLineCd;
			newObj.perilCd		= ($$("div#distPerilTable .selectedRow"))[0].down("label", 0).innerHTML;
			newObj.shareCd		= $F("shareCd");
			newObj.distSpct		= $F("txtDistSpct");
			newObj.distTsi		= $F("txtDistTsi");
			newObj.distPrem		= $F("txtDistPrem");		
			newObj.distGrp		= 1;
			newObj.trtyName		= changeSingleAndDoubleQuotes2($F("txtDspTrtyName"));		
			
			return newObj;
		}catch(e){
			showErrorMessage("setWPerildsDtl", e);
		}
	}

	function clearForm(){
		try{
			supplyDistribution(null);
			setDistShareFormFields(null);
			//unselectRow("distListingTable");
			//unselectRow("distGroupListingTable");
			unClickRow("distListingTable");
			unClickRow("distGroupListingTable");
			checkTableItemInfoAdditional("distGroupListingTable","distGroupListing","rowDistGroup","groupNo",Number($("txtC080DistNo").value));
			checkTableItemInfo("distListingTable","distListing","rowPrelimPerilDist");
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}
	
	function clearShare(){
		try{
			setDistShareFormFields(null);
			getShareDefaults(true);
			//unselectRow("distShareTable");
			unClickRow("distShareTable");
			if (selectedDistGroupRow != null && selectedPerilRow != null) {
				checkTableItemInfoAdditional("distShareTable","distShareListing","rowDistShare","distNo",Number($("txtC080DistNo").value),"groupNo",Number(selectedDistGroupRow.distSeqNo),"perilCd",Number(selectedPerilRow.perilCd));
			}
		}catch(e){
			showErrorMessage("clearShare", e);
		}
	}

	//get the default Share value
	function getShareDefaults(param){
		try{
			if (param){
				$("btnAddShare").value = "Add";
				disableButton("btnDeleteShare");
				enableButton("btnTreaty");
				enableButton("btnShare");
			}else{
				$("btnAddShare").value = "Update";
				enableButton("btnDeleteShare");
				disableButton("btnTreaty");
				disableButton("btnShare");
			}	
		}catch(e){
			showErrorMessage("getShareDefaults", e);
		}
	}

	function refreshForm(objArray){
		try{
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareDistRow(objArray[a]);
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				objArray[a].posted = "N";
				$("rowPrelimPerilDist"+objArray[a].distNo) ? $("rowPrelimPerilDist"+objArray[a].distNo).update(content) :null;
				//Group
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					var content2 = prepareDistGroupRow(objArray[a].giuwWPerilds[b]);
					objArray[a].giuwWPerilds[b].recordStatus = null;
					$("rowDistGroup"+objArray[a].giuwWPerilds[b].distNo+"_"+objArray[a].giuwWPerilds[b].distSeqNo) ? $("rowDistGroup"+objArray[a].giuwWPerilds[b].distNo+"_"+objArray[a].giuwWPerilds[b].distSeqNo).update(content2) :null;
					//Share
					for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
						var content3 = prepareDistShareRow(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c]);
						objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus = null;
						$("rowDistShare"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].lineCd+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd) ? $("rowDistShare"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].lineCd+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd).update(content3) :null;
					}						
				}	
			}
			
			// refresh all the listings, since the objects we are using now is recreated
			// this is to avoid problems on accessing currently selected objects (emman 06.23.2011)
			
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
			
			showDistributionList();
		}catch(e){
			showErrorMessage("refreshForm", e);
		}	
	}
	
	//for recomputation of dist_prem edgar 04/29/2014
	function recomputePerilDistPrem(){
	    vFound = 'N';
	    distScpt1Null = 'Y';
		var objArray = objGIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
				for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
					if ((objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1 != null) &&
							roundNumber(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,9) != roundNumber(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,9)){
						vFound = 'Y';
						distScpt1Null = 'N';
						new Ajax.Request(contextPath + "/GIUWPolDistController", {
							method : "POST",
							parameters : {
								action: "recomputePerilDistPrem",
								distNo : objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo,
								parId : objArray[a].parId,
								isPack : isPack
							},
							asynchronous: false,
							evalScripts: true,
							onCreate : function(){
								showNotice("Recomputing Distribution Premium Amounts, please wait ...");
							},
							onComplete : function(response){
								hideNotice();
								var res = JSON.parse(response.responseText);
								showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", 
									function(){
											if (vProcess == 'P' || vProcess == 'R'){
												postAfterValidations();
											}else if (vProcess == 'S'){
												showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
												clearForm();
												clearDistStatus(objGIUWPolDist);
												objGIUWPolDist = res.giuwPolDist;
												refreshForm(objGIUWPolDist);
											}
										});
								
								//objGIUWPolDist = res.giuwPolDist;
								//refreshForm(objGIUWPolDist);
							}
						});
					}else if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1 != null){
						vFound = 'N';
						distScpt1Null = 'N';
					}
					if (vFound == 'Y') {
						break;
					}
				}
				if (vFound == 'Y') {
					break;
				}
			}
			if (vFound == 'N' && distScpt1Null == 'N') {
				new Ajax.Request(contextPath + "/GIUWPolDistController", {
					method : "POST",
					parameters : {
						action: "recomputePerilDistPrem",
						distNo : objArray[a].distNo,
						parId : objArray[a].parId,
						isPack : isPack
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
						showNotice("Recomputing Distribution Premium Amounts, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						var res = JSON.parse(response.responseText);
						if (vProcess == 'P' || vProcess == 'R'){
							postAfterValidations();
						}else if (vProcess == 'S'){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							clearForm();
							clearDistStatus(objGIUWPolDist);
							objGIUWPolDist = res.giuwPolDist;
							refreshForm(objGIUWPolDist);
						}
					}
				});
			}else if  (vFound == 'N' && distScpt1Null == 'Y'){
				new Ajax.Request(contextPath + "/GIUWPolDistController", {
					method : "POST",
					parameters : {
						action: "recomputePerilDistPrem",
						distNo : objArray[a].distNo,
						parId : objArray[a].parId,
						isPack : isPack
					},
					asynchronous: false,
					evalScripts: true,
					onComplete : function(response){
						hideNotice();
						var res = JSON.parse(response.responseText);
						if (vProcess == 'P' || vProcess == 'R'){
							postAfterValidations();
						}else if (vProcess == 'S'){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							clearForm();
							clearDistStatus(objGIUWPolDist);
							objGIUWPolDist = res.giuwPolDist;
							refreshForm(objGIUWPolDist);
						}
					}
				});
			}
		}
	}
	//for checking of expired portfolio share edgar 05/02/2014
	function checkExpiredTreatyShare (){
		var ok = true;
		var objArray = objGIUWPolDist;
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
											showMessageBox("Treaty "+comp.treatyName +" has already expired. Replace the treaty with another one.", imgMessage.ERROR);
										 	ok = false;	
										}
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
		for(var i=0, length=objGIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "compareWitemPerilToDs",
					parId: objGIUWPolDist[i].parId,
					distNo : objGIUWPolDist[i].distNo
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
							showMessageBox("There are discrepancies in distribution master tables. Set-up Groups for Preliminary Distribution (GIUWS001) to correct this.", imgMessage.ERROR);
						 	ok = false;	
						}
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
	//checks for posted binders edgar 06/20/2014
	function checkPostedBinder (){
		var ok = true;
		for(var i=0, length=objGIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "checkPostedBinder",
					parId: objGIUWPolDist[i].parId,
					distNo : objGIUWPolDist[i].distNo,
					vProcess : vProcess
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Checking Posted Binders, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var comp = JSON.parse(response.responseText);
						if (comp.vAlert != null){
							showMessageBox(comp.vAlert, imgMessage.ERROR);
						 	ok = false;	
						}
					}
					if (vProcess == "S"){
						null; //pending for reloading the form
					}
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
	
	function getTakeUpTerm (){
		var objArray = objGIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "getTakeUpTerm",
					parId : objArray[a].parId
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
	
	function postDistGiuws003Final(){
		var objArray = objSelected;
		prepareDistForSaving();
		var objParameters = new Object();
		objParameters = prepareObjParameters();
		
		for(var a=0; a<objArray.giuwWPerilds.length; a++){
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "postDistGiuws003Final",
					parId: objArray.parId,//globalParId,
					distNo: objArray.giuwWPerilds[a].distNo,
					distSeqNo: objArray.giuwWPerilds[a].distSeqNo,
					parameters : JSON.stringify(objParameters)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice($("btnPostDist").value.replace("ost","osting")+", please wait...");
				},	
				onComplete: function(response){
					hideNotice("");
					var res = JSON.parse(response.responseText);	
					if(checkErrorOnResponse(response)){
						if (res.message != ""){
							var message = res.message.split("#"); 
							customShowMessageBox(message[2], message[1], "btnPostDist");
							changeTag = 0;
							varVChanges = "N";
							return false;
						}else{
							
							postResult2 = res;
							objSelected.varShare = postResult2.newItems.varShare;
							objSelected.postFlag = postResult2.newItems.postFlag;
							objSelected.distFlag = postResult2.newItems.distFlag;
							objSelected.autoDist = postResult2.newItems.autoDist;
							objSelected.meanDistFlag = postResult2.newItems.meanDistFlag;
							refreshForm(objSelected);
							disableButton("btnPostDist");
							disableButton("btnViewDist");
							disableButton("btnCreateItems");
							if (objSelected != null) {
								checkAutoDist1(objSelected); //to set post button value
							}
							showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS,function(){
								changeTag = 0;
								varVChanges = "N";
								fireEvent($("reloadForm"), "click");
							});
							
						}
					}
				}
			});
			break;
		}
	}
	//transferred from btnPostDist observe click edgar 07/02/2014  
	function postAfterValidations(){
		netOverrideOk = "Y";
		treatyOverrideOk = "Y";
		postingOk = "Y";
		var objArray = objSelected;
		prepareDistForSaving();
		var objParameters = new Object();
		objParameters = prepareObjParameters();
		
		for(var a=0; a<objArray.giuwWPerilds.length; a++){
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "postDistGiuws003",
					parId: objArray.parId,//globalParId,
					distNo: objArray.giuwWPerilds[a].distNo,
					distSeqNo: objArray.giuwWPerilds[a].distSeqNo,
					parameters : JSON.stringify(objParameters)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice($("btnPostDist").value.replace("ost","osting")+", please wait...");
				},	
				onComplete: function(response){
					hideNotice("");
					//var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	 removed by robert SR 5053 11.11.15
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){ //added checkCustomErrorOnResponse by robert SR 5053 11.11.15
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	//added by robert SR 5053 11.11.15
						if (res.message == "" && res.vMsgAlert == null){
							postResult = res;
							if (res.netMsg != null){
								/*showConfirmBox("Confirmation", res.netMsg, 
										"Yes", "No", 
										function(){// dating naka comment out, tinanggal ko ung comment - irwin 10.5.2012
											if (res.treatyMsg != null){
												showConfirmBox("Confirmation", res.treatyMsg, 
														"Yes", "No", checkOverrideNetTreaty, "");
											} 
											checkOverrideNetTreaty();
										}, "");*/ //commented out edgar 06/10/2014
								netTreaty = "NET";
								showConfirmBox("Confirmation", res.netMsg, 
										"Yes", "No", checkOverrideNetTreaty, "");//edgar 06/10/2014 
							}else{
								if (res.treatyMsg != null){
									netTreaty = "TREATY";
									showConfirmBox("Confirmation", res.treatyMsg, 
											"Yes", "No", checkOverrideNetTreaty, "");
								}else{
									checkOverrideNetTreaty();
								}	
							}		
						}else{
							if (res.message != ""){
								customShowMessageBox(res.message, imgMessage.ERROR, "btnPostDist");
								return false;
							}else if(res.vMsgAlert != null){
								customShowMessageBox(res.vMsgAlert, imgMessage.ERROR, "btnPostDist");
								return false;
							}	
						}	
					}		
				}
			});	
		}
		
		if (netOverrideOk == "O"/* && treatyOverrideOk == "Y" && postingOk == "Y"*/){
			postDistGiuws003Final();
		}
	}
	//end of code for adjustment/recomputation edgar 04/28/2014
	
	function savePrelimPerilDist(){
		try{
			vProcess = "S"; //edgar 06/20/2014
			if (!checkPostedBinder()) return false; //edgar 06/20/2014
			if (!procedurePreCommit()){
				return false;	
			}	
			
			if (globalParType == "P"){// added condition par type edgar 06/18/2014
				if (!checkC1407TsiPremium()){
					return false;
				}	
			}

			if (selectedPerilRow != null) {
				populateDistAndRiTables();
			}
			
			prepareDistForSaving();
			
			var objParameters = new Object();
			objParameters = prepareObjParameters();
			objParameters.savePosting = isSavePressed ? "N" :"Y"; //added by robert 10.13.15 GENQA 5053
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "savePrelimPerilDist",
					parameters : JSON.stringify(objParameters),
					isPack: isPack
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Saving Preliminary Peril Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
						//var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\')); //commented out by jeff dojello 04232013
						var res = JSON.parse(response.responseText); //added by jeff dojello 04232013
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, imgMessage.ERROR);
						}else{						
							giuwPolDistPostedRecreated.clear();
							changeTag = 0;
							if(isSavePressed){  // "Saving complete" should not be displayed if Post Distribution to Final/RI is presses as per SR-12333 jeff dojello 04192013
								//recomputePerilDistPrem(); //for recomputation of distribution premium amounts edgar 04/29/2014 //removed by robert 10.13.15 GENQA 5053
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								clearForm(); //added by robert SR 5053 12.21.15
								clearDistStatus(objGIUWPolDist); //added by robert SR 5053 12.21.15
								objGIUWPolDist = res.giuwPolDist; //added by robert SR 5053 12.21.15
								refreshForm(objGIUWPolDist); //added by robert SR 5053 12.21.15
							}else{
								clearForm();
								clearDistStatus(objGIUWPolDist);
								objGIUWPolDist = res.giuwPolDist;
								refreshForm(objGIUWPolDist);
							}
							varVChanges = "N";
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
			
		}catch(e){
			showErrorMessage("savePrelimPerilDist", e);
		}
	}

	//create new Object for Dist Share to be added on Object Array
	// if param is SHARE, set obj to selectedGIUWWPerildsDtl, else set to selectedPerilRow
	function setShareObject(param) {
		try {
			var objGroup = objSelected;
			var obj = (param == "SHARE") ? selectedGIUWWPerildsDtl : selectedPerilRow;
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
			newObj.annDistSpct			= escapeHTML2($F("txtDistSpct")); //obj == null ? "" :nvl(obj.annDistSpct, "");
			newObj.annDistTsi			= escapeHTML2(unformatNumber($F("txtDistTsi"))); //obj == null ? "" :nvl(obj.annDistTsi, ""); //(nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100; (emman 06.22.2011)
			newObj.distGrp				= obj == null ? "1" :"1"; //nvl(obj.distGrp, ""); //pre-insert block :C1407.dist_grp := 1;
			newObj.distSpct1			= escapeHTML2($F("txtDistSpct1")); //obj == null ? null :nvl(obj.distSpct1, null); //changed by robert 10.13.15 GENQA 5053
			newObj.arcExtData			= obj == null ? "" :nvl(obj.arcExtData, "");
			newObj.trtyCd			= obj == null ? "" :nvl(obj.dspTrtyCd, "");
			newObj.trtyName 			= escapeHTML2($F("txtDspTrtyName"));
			newObj.trtySw			= obj == null ? "" :nvl(obj.dspTrtySw, "");
			return newObj; 
		}catch(e){
			showErrorMessage("setShareObject", e);
		}
	}

	// delete dist share
	function deleteShare(){
		try{
			if ($F("txtC080DistNo") == ""){
				customShowMessageBox("Distribution no. is required.", imgMessage.ERROR, "txtC080DistNo");
				return false;
			}
			if (String(nvl((selectedDistGroupRow == null) ? null : selectedDistGroupRow.distNo, "")).blank()){ // to check if a dist group is selected
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
					var objArray = objGIUWPolDist;
					
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
													//checkTableItemInfoAdditional("distShareTable","distShareListing","rowDistShare","distNo",Number($("txtC080DistNo").value),"groupNo",Number(selectedDistGroupRow.distSeqNo),"perilCd",Number(selectedPerilRow.perilCd));
													computeDistShareFieldsTotalValues(distNo + "_" + distSeqNo + "_" + perilCd); // added by: Nica 06.06.2013 - to recompute totals after deletion
												}
											});
											
											varVChanges = "Y";
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

	//function add record
	function addShare(){
		try{
			if ($F("txtC080DistNo") == ""){
				customShowMessageBox("Distribution no. is required.", imgMessage.ERROR, "txtC080DistNo");
				return false;
			}
			if (String(nvl((selectedDistGroupRow == null) ? null : selectedDistGroupRow.distNo, "")).blank()){
				showMessageBox("Please select distribution group first.", imgMessage.ERROR);
				return false;
			}	
			if (selectedPerilRow == null) {
				showMessageBox("Please select peril first.", imgMessage.ERROR);
				return false;
			}
			if ($F("txtDspTrtyName") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtDspTrtyName");  //"Share is required."
				return false;
			}
			if ($F("txtDistSpct") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtDistSpct"); //"% Share is required."
				return false;
			}
			if ($F("txtDistTsi") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtDistTsi"); //"Sum insured is required."
				return false;
			}
			if ($F("txtDistSpct1") == ""){ //added by robert 10.13.15 GENQA 5053
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtDistSpct1"); 
				return false;
			}
			if ($F("txtDistPrem") == ""){
				customShowMessageBox("Premium is required.", imgMessage.ERROR, "txtDistPrem");
				return false;
			}
			if (parseFloat($F("txtDistSpct")) > 100){
				customShowMessageBox("%Share cannot exceed 100.", imgMessage.ERROR, "txtDistSpct");
				return false;
			}	
			/* if (parseFloat($F("txtDistSpct")) <= 0){  //removed by robert 10.13.15 GENQA 5053
				customShowMessageBox("%Share must be greater than zero.", imgMessage.ERROR, "txtDistSpct");
				return false;
			} */
			//if (unformatCurrencyValue(String(selectedPerilRow.tsiAmt)) != 0){
			//	$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(String(selectedPerilRow.tsiAmt)),0));
				/* if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){ //removed by robert 10.13.15 GENQA 5053
					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", imgMessage.ERROR, "txtDistTsi");
					return false;
				}	 */
			//}
			if (Math.abs($F("txtDistTsi")) > Math.abs(unformatCurrencyValue(String(selectedPerilRow.tsiAmt)))){
				customShowMessageBox("Sum insured cannot exceed TSI.", imgMessage.ERROR, "txtDistTsi");
				return false;
			}
			if (unformatCurrencyValue(String(selectedPerilRow.tsiAmt)) > 0){
				/* if (unformatCurrency("txtDistTsi") <= 0){ //removed by robert 10.13.15 GENQA 5053
					customShowMessageBox("Sum insured must be greater than zero.", imgMessage.ERROR, "txtDistTsi");
					return false;
				} */	
			}else if (unformatCurrencyValue(String(selectedPerilRow.tsiAmt)) < 0){
				if (unformatCurrency("txtDistTsi") >= 0){
					customShowMessageBox("Sum insured must be less than zero.", imgMessage.ERROR, "txtDistTsi");
					return false;
				}	
			}

			var exists = false;
			if (!exists){
				var newObj  = setShareObject("SHARE");
				if ($F("btnAddShare") == "Update" || $("rowDistShare"+newObj.distNo+"_"+newObj.distSeqNo+"_"+newObj.perilCd+"_"+newObj.shareCd)){
					//on UPDATE records
					var content = prepareDistShareRow(newObj);
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

					var objArray = objGIUWPolDist;
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
											objArray[a].autoDist = "N"; //set autoDist to N to unpost distribution when posted - christian
											computeDistShareFieldsTotalValues(objArray[a].giuwWPerilds[b].distNo + "_" + objArray[a].giuwWPerilds[b].distSeqNo + "_" + objArray[a].giuwWPerilds[b].perilCd);

											// update click event of this dist share row
											$(id).stopObserving("click");
											setRowObserver($(id), 
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
					var content = prepareDistShareRow(newObj);
					var distNo = newObj.distNo;
					var distSeqNo = newObj.distSeqNo;
					var perilCd = newObj.perilCd;
					var shareCd = newObj.shareCd;
					var objArray = objGIUWPolDist;
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
									objArray[a].autoDist = "N"; //set autoDist to N to unpost distribution when posted - christian
									objGIUWWPerildsDtl.push(newObj);
									break;
								}
							}
						}
					}

					createDistShareRow(newObj);
					computeDistShareFieldsTotalValues(newObj.distNo + "_" + newObj.distSeqNo + "_" + newObj.perilCd);
					if (selectedDistGroupRow != null && selectedPerilRow != null) {
						checkTableItemInfoAdditional("distShareTable","distShareListing","rowDistShare","distNo",Number(newObj.distNo),"groupNo",Number(selectedDistGroupRow.distSeqNo),"perilCd",Number(selectedPerilRow.perilCd));
					}
					changeTag = 1;
					clearShare();
				}

				varVChanges = "Y";
				varVPostSw = "N";
			}
		}catch(e){
			showErrorMessage("addShare", e);
		}		
	}

	// checks item info additional for share dist, with three attributes to compare
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
	
	function clickPrelimPerilRow(row) {
			row.toggleClassName("selectedRow");

			if (selectedPerilRow != null) {
				populateDistAndRiTables();
			}

			if(row.hasClassName("selectedRow")){
				($$("div#distListingTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				
				var objArr = objGIUWPolDist.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	});
				for(var i=0, length=objArr.length; i < length; i++){
					if(objArr[i].distNo == row.getAttribute("distNo")){
						objSelected = objArr[i];
						unClickRow("distGroupListingTable");
						unClickRow("distPerilTable");
						unClickRow("distShareTable");
						selectedDistGroupRow = null;
						selectedPerilRow = null;
						// show groups with similar distNo						
						($("distGroupListing").childElements()).invoke("hide"); //distGroupListingTable
						($$("div#distGroupListing div[distNo='"+ objArr[i].distNo +"']")).invoke("show");

						// resize & show the group table
						resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
						$("distPerilTable").hide();
						$("distShareTable").hide();
						$("distShareTotalAmtDiv").hide();
						
						break;
					}
				}
				supplyDistribution(objSelected);
				buttonLabel(objSelected);
			}else{
				$("distGroupListingTable").hide();
				$("distPerilTable").hide();
				$("distShareTable").hide();
				$("distShareTotalAmtDiv").hide();
				supplyDistribution(null);
				buttonLabel(null);

				objSelected = null; // added (emman 07.13.2011)
				selectedDistGroupRow = null;
				selectedPerilRow = null;
			}
	}

	function clickDistShareRow(div, obj) {
		div.toggleClassName("selectedRow");
		if(div.hasClassName("selectedRow")){
			($$("div#distShareListing div:not([id=" + div.id + "])")).invoke("removeClassName", "selectedRow");

			setDistShareFormFields(obj);
			distShareRecordStatus = "QUERY";					
		}else{
			setDistShareFormFields(null);
			distShareRecordStatus = "INSERT";						
		}
	}

	// execute POPULATE_DIST_AND_RI_TABLES procedure in GIUWS003
	function populateDistAndRiTables() {
		if (varVPolFlag != 2 && globalParType == "P" && nvl(varVChanges, "N") == "Y") {
			//adjustWPerildsDtl(); --commented out by edgar 06/05/2014
			null;
		}

		varVChanges = "N";
	}

	// execute ADJUST_WPERILDS_DTL procedure in GIUWS003
	function adjustWPerildsDtl() {
		var vExist = false;
		var vDistTsi = 0;
		var vDistPrem = 0;
		var vDistSpct = 0;
		var vAnnDistTsi = 0;
		var vSumDistTsi = 0;
		var vSumDistPrem = 0;
		var vSumDistSpct = 0;
		var vSumAnnDistTsi = 0;
		var vSumAnnDistSpct = 0;
		var vCorrectDistTsi = 0;
		var vCorrectDistPrem = 0;
		var vCorrectDistSpct = 0;
		var vCorrectAnnDistTsi = 0;
		var vCorrectAnnDistSpct = 0;
		
		if (selectedPerilRow == null) return;

		for (var i = 0; i < selectedPerilRow.giuwWPerildsDtl.length; i++) {
			if (selectedPerilRow.giuwWPerildsDtl[i].recordStatus != -1) {
				vExist = true;
				vDistTsi = vDistTsi + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[i].distTsi, 0));
				vDistPrem = vDistPrem + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[i].distPrem, 0));
				vDistSpct = vDistSpct + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[i].distSpct, 0));
				vAnnDistTsi = vAnnDistTsi + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[i].annDistTsi, 0));
			}
		}

		if (!vExist) {
			return false;
		}

		if ((100 != vDistSpct) || (selectedPerilRow.tsiAmt != vDistTsi) || (selectedPerilRow.premAmt != vDistPrem) || (selectedPerilRow.annTsiAmt != vAnnDistTsi)) {
			vExist = false;

			for (var i = 0; i < selectedPerilRow.giuwWPerildsDtl.length; i++) {
				if (selectedPerilRow.giuwWPerildsDtl[i].shareCd == 1 && selectedPerilRow.giuwWPerildsDtl[i].recordStatus != -1) {
					for (var a = 0; a < selectedPerilRow.giuwWPerildsDtl.length; a++) {
						if (selectedPerilRow.giuwWPerildsDtl[a].shareCd != 1 && selectedPerilRow.giuwWPerildsDtl[a].recordStatus != -1) {
							vExist = true;
							vSumDistTsi = vSumDistTsi + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].distTsi, 0));
							vSumDistPrem = vSumDistPrem + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].distPrem, 0));
							vSumDistSpct = vSumDistSpct + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].distSpct, 0));
							vSumAnnDistTsi = vSumAnnDistTsi + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].annDistTsi, 0));
							vSumAnnDistSpct = vSumAnnDistSpct + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].annDistSpct, 0));
						}
					}

					if (!vExist) {
						break;;
					}

					// round
					vSumDistTsi = roundNumber(vSumDistTsi, 2);
					vSumDistPrem = roundNumber(vSumDistPrem, 2);
					vSumDistSpct = roundNumber(vSumDistSpct, 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014
					vSumAnnDistTsi = roundNumber(vSumAnnDistTsi, 2);
					vSumAnnDistSpct = roundNumber(vSumAnnDistSpct, 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014

					vCorrectDistTsi = roundNumber(Math.abs(selectedPerilRow.tsiAmt) - Math.abs(vSumDistTsi), 2);
					vCorrectDistPrem = roundNumber(Math.abs(selectedPerilRow.premAmt) - Math.abs(vSumDistPrem), 2);
					vCorrectDistSpct = roundNumber(100 - vSumDistSpct, 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014
					vCorrectAnnDistTsi = roundNumber(Math.abs(selectedPerilRow.annTsiAmt) - Math.abs(vSumAnnDistTsi), 2);
					vCorrectAnnDistSpct = roundNumber(100 - vSumAnnDistSpct, 2);

					if (selectedPerilRow.tsiAmt < 0) {
						vCorrectDistTsi = vCorrectDistTsi * -1;
					}

					if (selectedPerilRow.premAmt < 0) {
						vCorrectDistPrem = vCorrectDistPrem * -1;
					}

					if (selectedPerilRow.annTsiAmt < 0) {
						vCorrectAnnDistTsi = vCorrectAnnDistTsi * -1;
					}

					selectedPerilRow.giuwWPerildsDtl[i].distTsi = vCorrectDistTsi;
					selectedPerilRow.giuwWPerildsDtl[i].distPrem = vCorrectDistPrem;
					selectedPerilRow.giuwWPerildsDtl[i].distSpct = vCorrectDistSpct;
					selectedPerilRow.giuwWPerildsDtl[i].annDistTsi = vCorrectAnnDistTsi;
					selectedPerilRow.giuwWPerildsDtl[i].annDistSpct = vCorrectAnnDistSpct;
				}
			}

			if (!vExist) {
				vSumDistTsi = 0;
				vSumDistPrem = 0;
				vSumDistSpct = 0;
				vSumAnnDistTsi = 0;
				vSumAnnDistSpct = 0;
				
				for (var i = 0; i < selectedPerilRow.giuwWPerildsDtl.length; i++) {
					if (i == 0) {
						for (var a = 0; a < selectedPerilRow.giuwWPerildsDtl.length; a++) {
							if (a != 0 && selectedPerilRow.giuwWPerildsDtl[a].recordStatus != -1) {
								vSumDistTsi = vSumDistTsi + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].distTsi, 0));
								vSumDistPrem = vSumDistPrem + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].distPrem, 0));
								vSumDistSpct = vSumDistSpct + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].distSpct, 0));
								vSumAnnDistTsi = vSumAnnDistTsi + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].annDistTsi, 0));
								vSumAnnDistSpct = vSumAnnDistSpct + parseFloat(nvl(selectedPerilRow.giuwWPerildsDtl[a].annDistSpct, 0));
							}
						}

						// round
						vSumDistTsi = roundNumber(vSumDistTsi, 2);
						vSumDistPrem = roundNumber(vSumDistPrem, 2);
						vSumDistSpct = roundNumber(vSumDistSpct, 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014
						vSumAnnDistTsi = roundNumber(vSumAnnDistTsi, 2);
						vSumAnnDistSpct = roundNumber(vSumAnnDistSpct, 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014

						vCorrectDistTsi = roundNumber(Math.abs(selectedPerilRow.tsiAmt) - Math.abs(vSumDistTsi), 2);
						vCorrectDistPrem = roundNumber(Math.abs(selectedPerilRow.premAmt) - Math.abs(vSumDistPrem), 2);
						vCorrectDistSpct = roundNumber(100 - vSumDistSpct, 9/*14*/);//changed rounding off from 14 to 9 edgar 05/06/2014
						vCorrectAnnDistTsi = roundNumber(Math.abs(selectedPerilRow.annTsiAmt) - Math.abs(vSumAnnDistTsi), 2);
						vCorrectAnnDistSpct = roundNumber(100 - vSumAnnDistSpct, 2);

						if (selectedPerilRow.tsiAmt < 0) {
							vCorrectDistTsi = vCorrectDistTsi * -1;
						}

						if (selectedPerilRow.premAmt < 0) {
							vCorrectDistPrem = vCorrectDistPrem * -1;
						}

						if (selectedPerilRow.annTsiAmt < 0) {
							vCorrectAnnDistTsi = vCorrectAnnDistTsi * -1;
						}

						selectedPerilRow.giuwWPerildsDtl[i].distTsi = vCorrectDistTsi;
						selectedPerilRow.giuwWPerildsDtl[i].distPrem = vCorrectDistPrem;
						selectedPerilRow.giuwWPerildsDtl[i].distSpct = vCorrectDistSpct;
						selectedPerilRow.giuwWPerildsDtl[i].annDistTsi = vCorrectAnnDistTsi;
						selectedPerilRow.giuwWPerildsDtl[i].annDistSpct = vCorrectAnnDistSpct;
					}
				}
			}
		}
	}

	/** end of page functions */
	
	/*$$("div#distListingTable div[name='rowPrelimPerilDist']").each(function(row){		
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function() {
			clickPrelimPerilRow(row);
		});
	});*/

	$("btnCreateItems").observe("click", function(){
		/*var objWPerilds = objGIUWPolDist.filter(function(obj){	return obj.distNo == $F("txtC080DistNo") && obj.distSeqNo == $F("txtDistSeqNo") && obj.perilCd == "" ;});
		var objWPerildsDtl = (objWPerilds == null) ? null :  objWPerilds.filter(function(obj){	return obj.distNo == $F("txtC080DistNo") && obj.distSeqNo == $F("txtDistSeqNo") && obj.perilCd == "" ;});
		var objDistFrps = objGIUWPolDist.filter(function(obj){	return obj.distNo == $F("txtC080DistNo") && obj.distSeqNo == $F("txtDistSeqNo");	});
		var vCount = (objWPerildsDtl == null) ? 0 : objWPerildsDtl.length;
		var vCount2 = (objDistFrps == null) ? 0 : objDistFrps.length;*/

		if (objSelected != null) {
			//start edgar 06/20/2014
				vProcess = "R";
				if (!checkPostedBinder()) return false; 
			//end edgar 06/20/2014
			if (checkDistFlag()) {
				new Ajax.Request(contextPath+"/GIUWPolDistController?action=getVPolFlag", {
					method: "GET",
					evalScripts: true,
					asynchronous: false,
					parameters: {
						polFlag: '2',
						parId: objSelected.parId
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							varVPolFlag = parseInt(nvl(response.responseText, "1"));

							if (!compareGipiItemItmperil()) return false;

							if ($("btnCreateItems").value == "Recreate Items"){
								showConfirmBox("Recreate Items", "All pre-existing data associated with this distribution record will be deleted. Are you sure you want to continue?", 
										"Yes", "No", onOkFunc, "");
							}else{
								onOkFunc();
							}		
						}
					}
				}); 
			}
		} else {
			showMessageBox("Please select distribution group first.", imgMessage.INFO);
		}
	});

	$("btnViewDist").observe("click", function() {
		// show GIPIS130 (View Distribution) - page under construction
		//edgar added codes below to call GIPIS130 base on Ms Shan's codes in GIUWS005
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		new Ajax.Request(contextPath+"/GIUWPolDistController",{
			parameters:{
				action: "getWpolbasGIUWS005",
				parId: $F("globalParId")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Retreiving information, please wait...");
			},	
			onComplete: function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					objGIPIS130.details = JSON.parse(response.responseText);
					objGIPIS130.distNo = $("txtC080DistNo").value;
					objGIPIS130.distSeqNo = nvl(selectedDistGroupRow.distSeqNo, null); 
					objUWGlobal.previousModule = "GIUWS003";
					showViewDistributionStatus();
				}
			}
		});
	});

	$("btnPostDist").observe("click", function() {
		if (objSelected == null) {
			showMessageBox("Please select distribution group first.", imgMessage.INFO);
			return false;
		} else if (varVChanges == "Y") {
			showMessageBox("Option is only available after changes have been made.", imgMessage.INFO);
			return false;
		} else {
			//added if condition to check if user is posting/unposting. Unposting will delete distribution master tables edgar 05/06/2014
			if ($("btnPostDist").value == "Unpost Distribution to Final"){
				new Ajax.Request(contextPath+"/GIUWPolDistController",{
					parameters:{
						action: "unpostDist",
						distNo: Number($F("txtC080DistNo"))
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						showNotice($("btnPostDist").value.replace("ost","osting")+", please wait...");
					},	
					onComplete: function(response){
						hideNotice("");
						showMessageBox("Unpost Distribution Complete.", imgMessage.SUCCESS);
						if (objSelected != null) {
							checkAutoDist1(objSelected); //to set post button value
						}
						//refreshForm(objSelected);
						changeTag = 0;
						varVChanges = "N";
						fireEvent($("reloadForm"), "click");
						disableButton("btnPostDist");
						disableButton("btnViewDist");
						disableButton("btnCreateItems");
					}
				});
			}else {
				vProcess = "P"; //edgar 06/20/2014
				if (!checkPostedBinder()) return false;  //edgar 06/20/2014
				if (!checkDistFlag()) return false;
				if (!procedurePreCommit()) return false;
				
				if (selectedPerilRow != null) {
					populateDistAndRiTables();
				}
				//start edgar 06/20/2014
				netOverrideOk = "Y"; 
				treatyOverrideOk = "Y"; 
				postingOk = "Y"; 
				// end edgar 06/20/2014
				getTakeUpTerm(); //get take up term edgar 05/08/2014
				if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up edgar 05/08/2014
					if (!compareWitemPerilToDs()) return false; // for comparison of ds table to itemperil table edgar 05/05/2014
				}
				
				if (!checkExpiredTreatyShare()) return false;// for checking of expired treaty edgar 05/02/2014
				if (globalParType == "P"){// added condition par type edgar 06/18/2014
					if (!checkC1407TsiPremium())return false; //uncommented edgar 05/08/2014
				}
				postAfterValidations(); //added by robert 10.13.15 GENQA 5053
				//recomputePerilDistPrem();//edgar 06/18/2014 //removed by robert 10.13.15 GENQA 5053
				/*var objArray = objSelected;
				prepareDistForSaving();
				var objParameters = new Object();
				objParameters = prepareObjParameters();
				
				for(var a=0; a<objArray.giuwWPerilds.length; a++){
					new Ajax.Request(contextPath+"/GIUWPolDistController",{
						parameters:{
							action: "postDistGiuws003",
							parId: objArray.parId,//globalParId,
							distNo: objArray.giuwWPerilds[a].distNo,
							distSeqNo: objArray.giuwWPerilds[a].distSeqNo,
							parameters : JSON.stringify(objParameters)
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function(){
							showNotice($("btnPostDist").value.replace("ost","osting")+", please wait...");
						},	
						onComplete: function(response){
							hideNotice("");
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
							if (checkErrorOnResponse(response)){
								if (res.message == "" && res.vMsgAlert == null){
									postResult = res;
									if (res.netMsg != null){
										/*showConfirmBox("Confirmation", res.netMsg, 
												"Yes", "No", 
												function(){// dating naka comment out, tinanggal ko ung comment - irwin 10.5.2012
													if (res.treatyMsg != null){
														showConfirmBox("Confirmation", res.treatyMsg, 
																"Yes", "No", checkOverrideNetTreaty, "");
													} 
													checkOverrideNetTreaty();
												}, "");*/ //commented out edgar 06/10/2014
					/*					netTreaty = "NET";
										showConfirmBox("Confirmation", res.netMsg, 
												"Yes", "No", checkOverrideNetTreaty, "");//edgar 06/10/2014 
									}else{
										if (res.treatyMsg != null){
											netTreaty = "TREATY";
											showConfirmBox("Confirmation", res.treatyMsg, 
													"Yes", "No", checkOverrideNetTreaty, "");
										}else{
											checkOverrideNetTreaty();
										}	
									}		
								}else{
									if (res.message != ""){
										customShowMessageBox(res.message, imgMessage.ERROR, "btnPostDist");
										return false;
									}else if(res.vMsgAlert != null){
										customShowMessageBox(res.vMsgAlert, imgMessage.ERROR, "btnPostDist");
										return false;
									}	
								}	
							}		
						}
					});	
				}

				if (netOverrideOk == "Y" && treatyOverrideOk == "Y" && postingOk == "Y"){
					postDistGiuws003Final();
				} *///transferred codes to function postAfterValidations() edgar 07/02/2014
			}
			/*if (objSelected != null) {
				checkAutoDist1(objSelected); //to avoid repetitive function call (emman 06.24.2011)
			}*/
		}
	});
	
	initPreTextOnField("txtDistSpct");
	$("txtDistSpct").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012		
		if($F("txtDistSpct").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistSpct").value = 0;
		}
		var distSpct = $F("txtDistSpct");			
		
		if(!(distSpct.empty())){
			/*  Check that %Share is not greater than 100 */ 
			if(parseFloat(distSpct) > 100){
				$("txtDistSpct").value = getPreTextValue("txtDistSpct");
				customShowMessageBox("%Share cannot exceed 100.", imgMessage.INFO, "txtDistSpct");
				return false;
            /* 	}else if(parseFloat(distSpct) < 0){ removed by robert SR 5053 11.11.15
				$("txtDistSpct").value = getPreTextValue("txtDistSpct");
				customShowMessageBox("%Share must be greater than zero.", imgMessage.INFO, "txtDistSpct");
				return false; */
			}
			
			/* Compute DIST_TSI if the TSI amount of the master table
			 * is not equal to zero.  Otherwise, nothing happens.  */

			distNo 		= ($$("div#distListingTable .selectedRow"))[0].getAttribute("distNo");
			distSeqNo 	= ($$("div#distGroupListingTable .selectedRow"))[0].getAttribute("groupNo");
			perilCd 	= ($$("div#distPerilTable .selectedRow"))[0].getAttribute("perilCd");
			//shareCd 	= ($$("div#distShareTable .selectedRow"))[0].getAttribute("shareCd"); // removed by emman, variable is not used (emman 05.31.2011)
			
			var giuwWPerilds = objGIUWWPerilds.filter(function(obj){	return obj.distNo == distNo && obj.distSeqNo == distSeqNo && obj.perilCd == perilCd;	});
			
			if(giuwWPerilds[0].tsiAmt != 0){
				$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0));
				/* if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){ //removed by robert SR 5053 11.11.15
					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", imgMessage.ERROR, "txtDistTsi");
					return false;
				}	 */
			}else{
				//$("txtDistTsi").value = formatToNthDecimal(0, 14);
				$("txtDistTsi").value = "0.00"; // changed format to Currency (emman 05.26.2011)
			}
			
			/* Compute dist_prem  */
			//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(giuwWPerilds[0].premAmt),0)); //removed by robert 10.13.15 GENQA 5053
			$("txtDistSpct1").value = 	$F("txtDistSpct"); //added by robert 10.13.15 GENQA 5053
			fireEvent($("txtDistSpct1"), "blur"); //added by robert 10.13.15 GENQA 5053
		}
		
	});
	
	$("txtDistTsi").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012
		if($F("txtDistTsi").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistTsi").value = 0;
		}
		var distTsi = $F("txtDistTsi");
		
		if(!(distTsi.empty())){
			/* Check that dist_tsi does is not greater than tsi_amt  */
			distNo 		= ($$("div#distListingTable .selectedRow"))[0].getAttribute("distNo");
			distSeqNo 	= ($$("div#distGroupListingTable .selectedRow"))[0].getAttribute("groupNo");
			perilCd 	= ($$("div#distPerilTable .selectedRow"))[0].getAttribute("perilCd");
			//shareCd 	= ($$("div#distShareTable .selectedRow"))[0].getAttribute("shareCd"); // removed by emman, variable is not used (emman 05.31.2011)
			
			var giuwWPerilds = objGIUWWPerilds.filter(function(obj){	return obj.distNo == distNo && obj.distSeqNo == distSeqNo && obj.perilCd == perilCd;	});
			
			if(Math.abs(unformatCurrencyValue(distTsi)) > Math.abs(unformatCurrencyValue(giuwWPerilds[0].tsiAmt))){
				//customShowMessageBox("Sum insured cannot exceed TSI.", imgMessage.INFO, "txtDistTsi"); //replaced by robert SR 5053 12.21.15
				customShowMessageBox("Distribution Sum Insured cannot exceed Peril Sum Insured.", imgMessage.INFO, "txtDistTsi");
				return false;
			}
			
			/* Compute dist_spct if the TSI amount of the master table
			** is not equal to zero.  Otherwise, nothing happens.  */
			if(unformatCurrencyValue(giuwWPerilds[0].tsiAmt) > 0){
				/* if(unformatCurrencyValue(distTsi) <= 0){ //removed by robert 10.13.15 GENQA 5053
					customShowMessageBox("Sum insured must be greater than zero.", imgMessage.INFO, "txtDistTsi");
					return false;
				} */
				//$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0) * 100 ,14); //commented out changed rounding off to 9 edgar 05/06/2014
				$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0) * 100 ,9);
			}else if(unformatCurrencyValue(giuwWPerilds[0].tsiAmt) < 0){
				if(unformatCurrencyValue(distTsi) >= 0){
					customShowMessageBox("Sum insured must be less than zero.", imgMessage.INFO, "txtDistTsi");
					return false;
				}
				//$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0) * 100 ,14);//commented out to change rounding off to 9 edgar 05/06/2014
				$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(giuwWPerilds[0].tsiAmt),0) * 100 ,9);//changed rounding off to 9 edgar 05/06/2014
			}else{
				$("txtDistTsi").value = formatCurrency("0");
			}
			
			/* Compute dist_prem  */
			//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(giuwWPerilds[0].premAmt),0)); //removed by robert SR 5053 12.21.15
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
				
				if(selectedPerilRow.premAmt != 0){
					var txtDistPrem = nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.premAmt),0);
					$("txtDistPrem").value = formatCurrency(roundNumber(txtDistPrem,2));
					$("txtDistPrem").writeAttribute("distPrem", txtDistPrem); // andrew - 05.28.2012 - SR# 9261, discrepancy in total

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
	$("txtDistPrem").observe("change", function(){
		try{
			if($F("txtDistPrem").empty()){
				$("txtDistPrem").value = 0;
			}
			
			var distPrem = $F("txtDistPrem");
			var distTsi = $F("txtDistTsi"); //ralphsantiago SR-24085 03-27-2017    ----added by SHARIE 03/31/2017 SR-24085
			if(!(distPrem.empty())){
				
				if(Math.abs(unformatCurrencyValue(distPrem)) > Math.abs(unformatCurrencyValue(selectedPerilRow.premAmt))){
					$("txtDistPrem").value = getPreTextValue("txtDistPrem");
					customShowMessageBox("Distribution Premium Amount cannot be greater than the peril premium amount.", "I", "txtDistPrem");
					return false;
				}

				if(unformatCurrencyValue(selectedPerilRow.premAmt) > 0){
					if(unformatCurrencyValue(distPrem) <= 0){
						$("txtDistPrem").value = getPreTextValue("txtDistPrem");
				
						
						customShowMessageBox("Premium Amount must not be less than zero.", "I", "txtDistPrem");
						return false;
					}
					$("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrencyValue(distPrem),0) / nvl(unformatCurrencyValue(selectedPerilRow.premAmt),0) * 100 ,9);					
				}else if(unformatCurrencyValue(selectedPerilRow.premAmt) < 0){
					if(unformatCurrencyValue(distTsi) >= 0){
						$("txtDistPrem").value = getPreTextValue("txtDistPrem");
						customShowMessageBox("Premium Amount must be less than zero.", "I", "txtDistPrem");
						return false;
					}
					$("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrencyValue(distPrem),0) / nvl(unformatCurrencyValue(selectedPerilRow.premAmt),0) * 100 ,9);
				}else{
					$("txtDistPrem").value = formatCurrency("0");
				}
				
				$("txtDistPrem").writeAttribute("distPrem", $F("txtDistPrem"));    
			}
		}catch(e){
			showErrorMessage("Premium on change.", e);
		}
	});
	//end robert 10.13.15 GENQA 5053	
	/*$("btnAddShare").observe("click", function(){
		var distSpct = "0";
		var amount;
		var count = 0;
		var objPreDistSpct = new Object();
		var objScaDistSpct = new Object();
		
		// check if total distSpct is equal to 100%
		$$("div#distShareListing div[style='']").each(function(row){
			if(!(row.hasClassName("selected"))){
				amount = ((row.down("label", 1)).innerHTML).replace(/,/g, "").split(".");
				assignAmtToObj(amount, objPreDistSpct, objScaDistSpct, count);
				count++;
			}
		});
		//amount = (($F("txtDistSpct")).replace(/,/g, "")).split
		//objPreDist[count] = 
		
		if ($F("txtDspTrtyName") == ""){
			customShowMessageBox("Share is required.", imgMessage.ERROR, "txtDspTrtyName");
			return false;
		}
		if ($F("txtDistSpct") == ""){
			customShowMessageBox("% Share is required.", imgMessage.ERROR, "txtDistSpct");
			return false;
		}
		if ($F("txtDistTsi") == ""){
			customShowMessageBox("Sum insured is required.", imgMessage.ERROR, "txtDistTsi");
			return false;
		}
		if ($F("txtDistPrem") == ""){
			customShowMessageBox("Premium is required.", imgMessage.ERROR, "txtDistPrem");
			return false;
		}
		
		if($F("txtC080DistFlag") == "1" || $F("txtC080DistFlag") == "2"){
			
		}
	});*/

	$("btnDeleteShare").observe("click", function() {
		deleteShare();
	});

	$("btnAddShare").observe("click", function() {
		addShare();
	});

	$("btnShare").observe("click", function() {
		if (objSelected != null) {
			if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
				getListing();
				var objArray = distListing.distShareListingJSON;
				startLOV("GIUWS003-Treaty", "Share", objArray, 540);
			} else {
				showMessageBox("Field is protected against update.", imgMessage.INFO);
			}
		}
	});

	$("btnTreaty").observe("click", function() {
		if (objSelected != null) {
			if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
				getListing();
				var objArray = distListing.distTreatyListingJSON;
				startLOV("GIUWS003-Treaty", "Treaty", objArray, 540);
			} else {
				showMessageBox("Field is protected against update.", imgMessage.INFO);
			}
		}
	});

	// added for package. (emman 07.12.2011)
	if (isPack == "Y") {
		objGIPIParList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
		$("parNo").value = "${packParNo}";
		$("assuredName").value = unescapeHTML2("${packAssdName }"); //unescapeHTML2 added by jeffdojello04182013
		showPackagePARPolicyList(objGIPIParList);
		loadPackageParPolicyRowObserver();
	}

	initializeChangeTagBehavior(savePrelimPerilDist);
	window.scrollTo(0,0); 	
	hideNotice("");
	observeReloadForm("reloadForm", showPreliminaryPerilDist);
	observeCancelForm("btnCancel", savePrelimPerilDist, (isPack == "Y") ? showPackParListing : showParListing);
	observeSaveForm("btnSave", savePrelimPerilDist);
	
	$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
		if (row.getAttribute("parId") == $F("initialParId")){
			row.addClassName("selectedRow");
		}				
	});
</script>