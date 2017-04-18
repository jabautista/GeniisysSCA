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
	<input type="hidden" id="initialSublineCd" value=""/>
	<form id="preliminayPerilDistForm" name="preliminaryPerilDistForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<c:choose>
			<c:when test="${isPack == 'Y'}">
				<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
			</c:when>
		</c:choose>
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
						<label style="width: 33%; text-align: left;  margin-right: 5px;">Peril</label>
						<label style="width: 32%; text-align: right; margin-right: 5px;">Peril Sum Insured</label>
						<label style="width: 32%; text-align: right; margin-right: 5px;">Peril Premium</label>
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
					<!--  c120 (GIUW_POL_DIST) block -->
					<tr>
						<td class="rightAligned">Share</td>
						<td class="leftAligned">
							<input type="hidden" id="shareCd" name="shareCd" value="" />
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
							<!-- changed nthDecimal from 14 to 9 and maxlength from 18 to 13 : shan 05.08.2014 -->
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct" name="txtDistSpct" value="" style="width:250px;" maxlength="13" /> 
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
							<!-- changed nthDecimal from 14 to 9 and maxlength from 18 to 13 : shan 05.08.2014 -->
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct1" name="txtDistSpct1" value="" style="width:250px;" maxlength="13" /> 
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistPrem" name="txtDistPrem" value="" style="width:250px;" maxlength="17"/>
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
			<input type="button" id="btnPostDist" 		name="btnPostDist" 	 	class="button" value="Post Distribution to RI" />
			<input type="button" id="btnCancel"			name="btnCancel"		style="width : 100px;" class="button"			value="Cancel" />
			<input type="button" id="btnSave" 			name="btnSave" 			style="width : 100px;" class="button"			value="Save" />			
		</div>
	</form>
</div>
<div id="summarizedDistDiv"></div>
<script>
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	objGIUWPolDist = JSON.parse('${giuwPolDist}');	
	objGIUWWPerilds = [];
	objGIUWWPerildsDtl = [];

	var objSelected 		= null;
	var selectedGroupRow 	= null;
	var selectedPerilRow 	= null;
	var selectedPerilDtl 	= {};
	var distShareRecordStatus = "INSERT";
	var distListing 		= {};

	// for total amounts
	var totalDistSpct 	= 0;
	var totalDistTsi 	= 0;
	var totalDistSpct1 	= 0;
	var totalDistPrem 	= 0;
	
	// for saving
	var giuwPolDistRows 	= [];
	var giuwWPerildsRows 	= [];
	var giuwWPerildsDtlSetRows = [];
	var giuwWPerildsDtlDelRows = [];
	var giuwPolDistPostedRecreated = [];

	// for posting
	var postResult = {};
	var netOverride = "N";
	var treatyOverride = "N";
	
	// VARIABLES
	var varVPolFlag = 1;
	
	objGIPIParList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
	var isPack = "${isPack}";
	
	// for handling package PAR - added by: Nica 09.10.2012
	var globalParType = (isPack != "Y") ? $("globalParType").value : objUWGlobal.parType;
	var globalIssCd = (isPack != "Y") ? $("globalIssCd").value : objUWGlobal.issCd;
	var globalPolFlag = (isPack != "Y") ? $("globalPolFlag").value : $("globalPackPolFlag").value;
	
	//for getting takeupterm edgar 05/08/2014
	var takeUpTerm = "";
	var netTreaty; //added variable netTreaty shan 06.13.2014
	
	var postNoCommitSw = ""; // shan 06.09.2014
	
	if (/*$("globalParType").value*/ globalParType == "E") {
		//enableButton("btnViewDist");
	} else {
		disableButton("btnViewDist");
	}
	
	if(isPack == "Y"){
		for ( var i=0; i<objGIPIParList.length; i++) {
			if (objGIPIParList[i].parId == $("initialParId").value){
				$("initialLineCd").value = objGIPIParList[i].lineCd;
				$("initialSublineCd").value = objGIPIParList[i].sublineCd;
			}
		}
	}

	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setPackParPolicyObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}

	function setPackParPolicyObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){												
					($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");			
					
					if (changeTag == 0){
						$("initialParId").value = row.getAttribute("parId");
						$("initialLineCd").value = row.getAttribute("lineCd");
						$("initialSublineCd").value = row.getAttribute("sublineCd");
						showPreliminaryPerilDistByTsiPrem();
						if ($("distListing").down("div", 0) != null){ 
							 fireEvent($("distListing").down("div", 0), "click"); 
						}
					}else {
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function (){
																												$("initialParId").value = row.getAttribute("parId");
																												$("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
																												$("initialSublineCd").value = row.getAttribute("sublineCd");
																												savePrelimOneRiskDist();
																												showPreliminaryPerilDistByTsiPrem();
																											  }, function () {
																												    $("initialParId").value = row.getAttribute("parId");
																												    $("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
																												    $("initialSublineCd").value = row.getAttribute("sublineCd");
																												    showPreliminaryPerilDistByTsiPrem();
																											  }, function () {
																												  	$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
																														if (row.getAttribute("parId") == $F("initialParId")){
																															row.addClassName("selectedRow");
																														}else{
																															row.removeClassName("selectedRow");
																														}				
																													});
																											  });
					}
				}else{
					//clearDivs();
				}			
			});
		}catch(e){
			showErrorMessage("setPackParPolicyRowObserver", e);
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
	    	/*$(tableRow).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).down("div",0).setStyle("padding-right:0px");*/
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

	function prepareDistGroupRow(obj){
		try{
			var groupNo 	= obj == null ? "" : obj.distSeqNo;
			var currency 	= obj == null ? "" : obj.currencyDesc;
			var content = 
				'<label style="width: 100px; text-align: right; margin-right: 50px;">'+ groupNo.toPaddedString(2) +'</label>' +				
				'<label style="width: 600px; text-align: left;">'+ currency +'</label>';
			return content;
		}catch(e){
			showErrorMessage("prepareDistGroupRow", e);
		}
	}

	function prepareDistPerilRow(obj){
		try{			
			var perilName 	= obj == null ? "" : unescapeHTML2(obj.perilName); 
			var perilTsi 	= obj == null ? "" : obj.tsiAmt == null ? "" : formatCurrency(obj.tsiAmt);
			var perilPrem 	= obj == null ? "" : obj.premAmt == null ? "" : formatCurrency(obj.premAmt);
			var content =				
				'<label style="width: 33%; text-align: left; margin-right: 5px;">'+ perilName +'</label>' +
				'<label style="width: 32%; text-align: right; margin-right: 5px;">'+ perilTsi +'</label>' +
				'<label style="width: 32%; text-align: right; margin-right: 5px;">'+ perilPrem +'</label>';
			return content;				
		}catch(e){
			showErrorMessage("prepareDistPerilRow", e);
		}
	}

	function prepareDistShareRow(obj){
		try{			
			var treatyName 		= obj == null ? "" : unescapeHTML2(obj.trtyName); 
			var percentShare	= obj == null ? "" : obj.distSpct == null ? "&nbsp;" : formatToNthDecimal(obj.distSpct, 9); // changed rounding off from 14 to 9 : shan 05.08.2014
			var sumInsured		= obj == null ? "" : obj.distTsi == null ? "&nbsp;" : formatCurrency(obj.distTsi);
			var percentPremium	= obj == null ? "" : obj.distSpct1 == null ? /*"&nbsp;"*/ formatToNthDecimal(obj.distSpct, 9) : formatToNthDecimal(obj.distSpct1, 9); // changed rounding off from 14 to 9 : shan 05.08.2014
			var premium			= obj == null ? "" : obj.distPrem == null ? "&nbsp;" : formatCurrency(obj.distPrem);
			var content =				
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

	function assignAmtToObj(amt, objPre, objSca, index){
		try{
			objPre[index] = Number(nvl(amt[0], "0"));
			objSca[index] = (nvl(amt[1], "0")).replace(/^0/, "");//parseInt(nvl(((parseInt(amt[0]) < 0) ? "-" : "") + amt[1], "0"));
		}catch(e){
			showErrorMessage("assignAmtToObj", e);
		}						
	}

	function addDeciNumObject(preciseObj, scaleObj, divisor){
		try{
			var addends1 = 0;
			var addends2 = 0;

			for(att in preciseObj){
				addends1 = addends1 + preciseObj[att];
				addends2 = Number(addends2) + Number(scaleObj[att]);				
			}		
			
			if(addends2 >= divisor){
				addends1 = addends1 + Number(addends2 / divisor);
				addends2 = addends2 % divisor;
			}
			
			return (addends1 + "." + formatNumberDigits(addends2.abs(), (divisor.length - 1)));
		}catch(e){
			showErrorMessage("addDeciNumObject", e);
		}
	}
	
	// click function for Dist Group
	function observeDistGroupRowClick(obj, newDiv) {
		try{
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
						checkTableItemInfoAdditional("distPerilTable","distPerilListing","rowDistPeril","distNo",newDiv.getAttribute("distNo"),"groupNo",newDiv.getAttribute("groupNo"));
						// resize & show the peril table
						resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");

						selectedGroupRow = obj;
						disableButton("btnViewDist");
						if (obj != null){
							if($F("globalParType") == "E"){
								enableButton("btnViewDist"); 
							}
						}
					}else{								
						unselectRow("distPerilTable");
						selectedGroupRow = null;
						disableButton("btnViewDist");
					}
				});
		}catch(e){
			showErrorMessage("observeDistGroupRowClick", e);
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

	function computeTotalShareAmount(){
		try{
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistSpct1 = 0;
			var sumDistPrem = 0;

			var objArray = objGIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1 && nvl(selectedPerilRow.distNo,null) == objArray[a].distNo){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1 && nvl(selectedPerilRow.distSeqNo,null) == objArray[a].giuwWPerilds[b].distSeqNo){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].perilCd == nvl(selectedPerilRow.perilCd,null) 
										&& objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
									sumDistSpct = (parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0)));
									sumDistTsi = (parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi.replace(/,/g, ""),0)));
									sumDistSpct1 = (parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct)));
									sumDistPrem = (parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0))); //.replace(/,/g, "")
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
			
			$("totalDistSpct").innerHTML = formatToNthDecimal(sumDistSpct, 9); // changed rounding off from 14 to 9 : shan 05.08.2014
			$("totalDistTsi").innerHTML = formatCurrency(sumDistTsi);
			$("totalDistSpct1").innerHTML = formatToNthDecimal(sumDistSpct1, 9); // changed rounding off from 14 to 9 : shan 05.08.2014
			$("totalDistPrem").innerHTML = formatCurrency(sumDistPrem);
		}catch(e){
			showErrorMessage("computeTotalShareAmount", e);
		}
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
						if(newDiv.hasClassName("selectedRow")){
							selectedPerilRow = obj;
							var id1 = obj.distNo + "_" + obj.distSeqNo + "_" + obj.perilCd;						
							($$("div#distPerilListing div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");								

							($("distShareListing").childElements()).invoke("hide");
							($$("div#distShareListing div[id1='" + id1 + "']")).invoke("show");
							// resize & show the peril table
							resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
							
							if($("distShareTable").visible){
								computeTotalShareAmount();
								$("distShareTable").setStyle("height: " + ($("distShareTable").getHeight() + 31) + "px;");
							}
							enableButton("btnTreaty");
							enableButton("btnShare");

							enableButton("btnAddShare");
							$("txtDistSpct").readOnly = false;
							$("txtDistSpct1").readOnly = false;
							$("txtDistTsi").readOnly = false;
							$("txtDistPrem").readOnly = false;							
						}else{							
							unselectRow("distShareTable");
							selectedPerilRow = null;
							disableButton("btnTreaty");
							disableButton("btnShare");
							
							disableButton("btnAddShare");
							$("txtDistSpct").readOnly = true;
							$("txtDistSpct1").readOnly = true;
							$("txtDistTsi").readOnly = true;
							$("txtDistPrem").readOnly = true;
						}
						unClickRow("distShareTable");
					});

			$("distPerilListing").insert({bottom : newDiv});						
		}catch(e){
			showErrorMessage("createDistPerilRow", e);
		}
	}

	function setDistShareFormFields(obj){
		try{
			selectedPerilDtl 	= obj == null ? {} : obj;	
			$("txtDspTrtyName").value 	= obj == null ? "" : unescapeHTML2(obj.trtyName);
			$("txtDistSpct").value 		= obj == null ? "" : obj.distSpct == null ? "" : formatToNthDecimal(obj.distSpct, 9); // changed rounding off from 14 to 9 : shan 05.08.2014 
			$("txtDistTsi").value 		= obj == null ? "" : obj.distTsi == null ? "" : formatCurrency(obj.distTsi);
			$("txtDistTsi").writeAttribute("distTsi",obj == null ? "" : obj.distTsi == null ? "" : obj.distTsi); // andrew - 05.30.2012
			$("txtDistSpct1").value 	= obj == null ? "" : obj.distSpct1 == null ? formatToNthDecimal(obj.distSpct, 9) : formatToNthDecimal(obj.distSpct1, 9); // changed rounding off from 14 to 9 : shan 05.08.2014
			$("txtDistPrem").value 		= obj == null ? "" : obj.distPrem == null ? "" : formatCurrency(obj.distPrem);
			$("txtDistPrem").writeAttribute("distPrem",obj == null ? "" : obj.distPrem == null ? "" : obj.distPrem); // andrew - 05.30.2012
			$("shareCd").value			= obj == null ? "" : obj.shareCd == null ? "" : obj.shareCd;
			if(nvl($("lineCd"), null) != null){		//added by christian 09.24.2012
				$("lineCd").value			= obj == null ? "" : obj.lineCd == null ? "" : obj.lineCd;				
			}

			$("btnAddShare").value		= obj == null ? "Add" : "Update";
			
			obj == null ? disableButton($("btnDeleteShare")) : enableButton($("btnDeleteShare"));

			if (obj == null){
				enableButton("btnTreaty");
				enableButton("btnShare");
				//disableButton("btnAddShare");
			}else{
				disableButton("btnTreaty");
				disableButton("btnShare");
				enableButton("btnAddShare");
			}
		}catch(e){
			showErrorMessage("setDistShareFormFields", e);
		}
	}
	
	function clickDistShareRow(div, obj) {
		try{
			div.toggleClassName("selectedRow");
			if(div.hasClassName("selectedRow")){
				($$("div#distShareListing div:not([id=" + div.id + "])")).invoke("removeClassName", "selectedRow");
	
				setDistShareFormFields(obj);
				distShareRecordStatus = "QUERY";					
			}else{
				setDistShareFormFields(null);
				distShareRecordStatus = "INSERT";						
			}
		}catch(e){
			showErrorMessage("clickDistShareRow", e);
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
	
	function createAdditionalList(objArr){
		try{
			for(var i=0, length=objArr.length; i < length; i++){
				objArr[i].recordStatus = null;
				createDistGroupRow(objArr[i]);
				createDistPerilRow(objArr[i]);
				// add giuwWPerilds to the list
				objGIUWWPerilds.push(objArr[i]);
				for(var x=0, y=objArr[i].giuwWPerildsDtl.length; x < y; x++){		
					objArr[i].giuwWPerildsDtl[x].recordStatus = null;			
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
				objGIUWPolDist[i].divCtrId = i;
				objGIUWPolDist[i].recordStatus = null;
				objGIUWPolDist[i].posted = "N";
				newDiv.setAttribute("id", "rowPrelimPerilDistByTsiPrem" + objGIUWPolDist[i].distNo);
				newDiv.setAttribute("name", "rowPrelimPerilDistByTsiPrem");
				newDiv.setAttribute("distNo", objGIUWPolDist[i].distNo);
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				$("distListing").insert({bottom : newDiv});				
				createAdditionalList(objGIUWPolDist[i].giuwWPerilds);							
			}
			resizeTableBasedOnVisibleRows("distListingTable", "distListing");
			resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
			resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
			resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
		}catch(e){
			showErrorMessage("showDistributionList", e);
		}
	}

	showDistributionList();

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
					globalParId: objSelected.parId,
					nbtLineCd: (selectedGroupRow == null) ? null : selectedGroupRow.lineCd,
					lineCd: (isPack != "Y") ? $("globalLineCd").value : $("initialLineCd").value//$F("globalLineCd")
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
			var copyObj = objArray.clone();	
			var copyObj2 = objArray.clone();
			if (selectedPerilRow == null) return;	
			var peril = selectedPerilRow.giuwWPerildsDtl.clone();
			var share = selectedPerilDtl;
			for(var a=0; a<peril.length; a++){
				if (nvl(peril[a].recordStatus, 0) != -1){
					for(var b=0; b<copyObj.length; b++){
						if (peril[a].shareCd == copyObj[b].shareCd){
							copyObj.splice(b,1);
							b--;
						}	
					}	
				}
			}
			if (nvl(share.recordStatus,null) == 0){
				for(var b=0; b<copyObj2.length; b++){
					if (nvl(share.shareCd,'') == copyObj2[b].shareCd){
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
					$("shareCd").value = getSelectedRowAttrValue(id+"LovRow", "cd");
					selectedPerilDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");
					selectedPerilDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
					selectedPerilDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");
					hideOverlay();
				}
				observeOverlayLovRow(id);
				observeOverlayLovButton(id, onOk);
				observeOverlayLovFilter(id, copyObj);
			}
			$("filterTextLOV").focus();
		}catch(e){
			showErrorMessage("startLOV", e);
		}
	}
	
	function buttonLabel(obj){
		try{
			if (obj == null){
				disableButton("btnCreateItems");
				$("btnCreateItems").value = "Create Items";
				disableButton("btnViewDist"); //enable button if PAR is endt.
				disableButton("btnPostDist");
				$("btnPostDist").value = "Post Distribution to Final"; //changed "RI" to "Final" - Christian 11/07/20212
			}else{
				var giuwWPerildsDtlExist = "N";
				for(var b=0; b<obj.giuwWPerilds.length; b++){
					if (obj.giuwWPerilds[b].giuwWPerildsDtl.length > 0){
						giuwWPerildsDtlExist = "Y";
					}		
				}
				if (giuwWPerildsDtlExist == "Y"){
					enableButton("btnCreateItems");
					$("btnCreateItems").value = "Recreate Items";
					enableButton("btnPostDist");
					if (obj.distFlag != "2" || nvl(obj.distFlag,"") == ""){
						enableButton("btnCreateItems");
					}else if(obj.distFlag == "2"){
						disableButton("btnCreateItems");
						disableButton("btnPostDist"); // shan : 06.23.2014 - btnPostDist will be disabled when Distribution is posted to RI
					}	
					
					if (nvl(obj.varShare,null) == "Y"){
						$("btnPostDist").value = "Post Distribution to RI";
						//enableButton("btnPostDist");	// shan : 06.23.2014 - btnPostDist will be disabled when Distribution is posted to RI
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

	function mainObserver(){
		try{	
			$$("div#distListingTable div[name='rowPrelimPerilDistByTsiPrem']").each(function(row){	
				loadRowMouseOverMouseOutObserver(row);
		
				row.observe("click", function(){
					row.toggleClassName("selectedRow");
					
					if(row.hasClassName("selectedRow")){
						($$("div#distListingTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
						
						var objArr = objGIUWPolDist.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	});
						for(var i=0, length=objArr.length; i < length; i++){
							if(objArr[i].distNo == row.getAttribute("distNo")){
								objSelected = objArr[i];
								unClickRow("distGroupListingTable");
								// show groups with similar distNo						
								($("distGroupListing").childElements()).invoke("hide"); //distGroupListingTable
								($$("div#distGroupListing div[distNo='"+ objArr[i].distNo +"']")).invoke("show");
		
								// resize & show the group table
								resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
								
								break;
							}
						}
						supplyDistribution(objSelected);
						buttonLabel(objSelected);
					}else{
						$("distGroupListingTable").hide();
						$("distPerilTable").hide();
						$("distShareTable").hide();		
						supplyDistribution(null);
						clearForm();
						buttonLabel(null);			
					}
				});
			});
		}catch(e){
			showErrorMessage("mainObserver", e);
		}
	}	
	
	//Observe for main listing
	mainObserver();

	$("btnShare").observe("click", function() {
		try{
			if (objSelected != null) {
				if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
					getListing();
					var objArray = distListing.distShareListingJSON;
					startLOV("GIUWS006-Share", "Share", objArray, 540);
				} else {
					showMessageBox("Field is protected against update.", "I");
				}
			}
		}catch(e){
			showErrorMessage("Share button onclick.", e);
		}
	});

	$("btnTreaty").observe("click", function() {
		try{
			if (objSelected != null) {
				if ($F("txtDspTrtyName").blank() || distShareRecordStatus == "INSERT") {
					getListing();
					var objArray = distListing.distTreatyListingJSON;
					startLOV("GIUWS006-Treaty", "Treaty", objArray, 540);
				} else {
					showMessageBox("Field is protected against update.", "I");
				}
			}
		}catch(e){
			showErrorMessage("Treaty button onclick.", e);
		}
	});

	/* % Share Sum Insured*/ 
	initPreTextOnField("txtDistSpct");
	$("txtDistSpct").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012	
		try{
			if (!checkIfValueChanged("txtDistSpct")) return;
			
			// shan 06.24.2014
			if (parseFloat(this.value.replace(/,/g, "")) < parseFloat(0)){
				showMessageBox("Entered % Share is invalid. Valid value is from 0 to 100.", "E");
				this.value = this.getAttribute("pre-text");
				return;
			}
			if (parseFloat(this.value.replace(/,/g, "")) > parseFloat(100)){
				showMessageBox("TSI %Share cannot exceed 100.", "E");
				this.value = this.getAttribute("pre-text");
				return;
			}
			// end 06.24.2014
			
			var distSpct = $F("txtDistSpct");	
			if(!(distSpct.empty())){
				/*  Check that %Share is not greater than 100 */ 
				if(parseFloat(distSpct) > 100){
					$("txtDistSpct").value = getPreTextValue("txtDistSpct");
					customShowMessageBox("%Share cannot exceed 100.", "I", "txtDistSpct");
					return false;
				}
				/*if(parseFloat(distSpct) < 0){
					$("txtDistSpct").value = getPreTextValue("txtDistSpct");
					customShowMessageBox("%Share must be greater than zero.", "I", "txtDistSpct");
					return false;
				}
				if ($F("btnAddShare") == "Update") totalDistSpct = nvl(totalDistSpct-parseFloat(nvl(selectedPerilDtl.distSpct,0)),0);
				if ((parseFloat(distSpct) + parseFloat(totalDistSpct)) > 100){
					$("txtDistSpct").value = getPreTextValue("txtDistSpct");
					customShowMessageBox("%Share cannot exceed 100.", "I", "txtDistSpct");
					return false;
				}	*/
				
				/* Compute DIST_TSI if the TSI amount of the master table
				 * is not equal to zero.  Otherwise, nothing happens.  */
	
				if(selectedPerilRow.tsiAmt != 0){
					var txtDistTsi = nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0);
					/*if (txtDistTsi > unformatCurrencyValue(selectedPerilRow.tsiAmt)){
						$("txtDistSpct").value = getPreTextValue("txtDistSpct");
						customShowMessageBox("TSI must not exceed "+formatCurrency(selectedPerilRow.tsiAmt)+".", "I", "txtDistSpct");
						return false;
					}*/
					$("txtDistTsi").value = formatCurrency(roundNumber(txtDistTsi,2));
					$("txtDistTsi").writeAttribute("distTsi", txtDistTsi); // andrew - 05.28.2012 - SR# 9575, discrepancy in total
					/*if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){
						customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
						return false;
					}	*/
				}else{
					$("txtDistTsi").value = "0.00";
					$("txtDistTsi").writeAttribute("distTsi", "0.00"); // andrew - 05.28.2012 - SR# 9575, discrepancy in total
				}
				
				/* Compute dist_prem  */
				//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0));
			}
		}catch(e){
			showErrorMessage("% Share Sum Insured on blur.", e);
		}
	});	

	/* Sum Insured */ 
	initPreTextOnField("txtDistTsi");	
	//$("txtDistTsi").observe("blur", function(){ // andrew - 05.31.2012 - to avoid recomputation of %share when the user press tab key in txtDistTsi field 
	$("txtDistTsi").observe("change", function(){
		try{
			if (!checkIfValueChanged("txtDistTsi")) return;
			
			var distTsi = $F("txtDistTsi");
			if(!(distTsi.empty())){
				/* Check that dist_tsi does is not greater than tsi_amt  */
				
				if(Math.abs(unformatCurrencyValue(distTsi)) > Math.abs(unformatCurrencyValue(selectedPerilRow.tsiAmt))){
					$("txtDistTsi").value = getPreTextValue("txtDistTsi");
					customShowMessageBox("Sum insured cannot exceed TSI.", "I", "txtDistTsi");
					return false;
				}

				if ($F("btnAddShare") == "Update") totalDistTsi = nvl(totalDistTsi-parseFloat(nvl(selectedPerilDtl.distTsi,0)),0);
				if (selectedPerilRow.tsiAmt != 0){
					//if ((totalDistTsi+unformatCurrency("txtDistTsi")) > unformatCurrencyValue(selectedPerilRow.tsiAmt)){
					// andrew - modified, added "toFixed()" to round the total dist tsi to 2 decimals - 05.28.2012
					if (parseFloat(totalDistTsi) + parseFloat(unformatCurrency("txtDistTsi").toFixed(2)) > unformatCurrencyValue(selectedPerilRow.tsiAmt)){
						$("txtDistTsi").value = getPreTextValue("txtDistTsi");
						customShowMessageBox("Share cannot exceed "+formatCurrency(getPreTextValue("txtDistTsi"))+".", "I", "txtDistTsi");
						return false;
					}
				}	
				
				/* Compute dist_spct if the TSI amount of the master table
				** is not equal to zero.  Otherwise, nothing happens.  */
				if(unformatCurrencyValue(selectedPerilRow.tsiAmt) > 0){
					if(unformatCurrencyValue(distTsi) <= 0){
						$("txtDistTsi").value = getPreTextValue("txtDistTsi");
						customShowMessageBox("Sum insured must be greater than zero.", "I", "txtDistTsi");
						return false;
					}
					// changed rounding off from 14 to 9 : shan 05.08.2014
					$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0) * 100 ,9);					
				}else if(unformatCurrencyValue(selectedPerilRow.tsiAmt) < 0){
					if(unformatCurrencyValue(distTsi) >= 0){
						$("txtDistTsi").value = getPreTextValue("txtDistTsi");
						customShowMessageBox("Sum insured must be less than zero.", "I", "txtDistTsi");
						return false;
					}
					// changed rounding off from 14 to 9 : shan 05.08.2014
					$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrencyValue(distTsi),0) / nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0) * 100 ,9);
				}else{
					$("txtDistTsi").value = formatCurrency("0");
				}

				/* Compute dist_prem  */
				//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0));	
				$("txtDistTsi").writeAttribute("distTsi", $F("txtDistTsi")); 		   
			}
		}catch(e){
			showErrorMessage("Sum Insured on blur.", e);
		}
	});
	
	/* Premium */
	initPreTextOnField("txtDistPrem");
	$("txtDistPrem").observe("change", function(){
		try{
			if (!checkIfValueChanged("txtDistPrem")) return;
			
			var distPrem = $F("txtDistPrem");
			if(!(distPrem.empty())){
				/* Check that dist_tsi does is not greater than tsi_amt  */
				
				if(Math.abs(unformatCurrencyValue(distPrem)) > Math.abs(unformatCurrencyValue(selectedPerilRow.premAmt))){
					$("txtDistPrem").value = getPreTextValue("txtDistPrem");
					customShowMessageBox("Premium Amount cannot exceed Premium.", "I", "txtDistPrem");
					return false;
				}

				/*if ($F("btnAddShare") == "Update") totalDistPrem = nvl(totalDistPrem-parseFloat(nvl(selectedPerilDtl.distPrem,0)),0);
				if (selectedPerilRow.premAmt != 0){
					//if ((totalDistTsi+unformatCurrency("txtDistTsi")) > unformatCurrencyValue(selectedPerilRow.tsiAmt)){
					// andrew - modified, added "toFixed()" to round the total dist tsi to 2 decimals - 05.28.2012
					if ((totalDistPrem+unformatCurrency("txtDistPrem").toFixed(2)) > unformatCurrencyValue(selectedPerilRow.premAmt)){
						$("txtDistPrem").value = getPreTextValue("txtDistPrem");
						customShowMessageBox("Share cannot exceed "+formatCurrency(getPreTextValue("txtDistPrem"))+".", "I", "txtDistPrem");
						return false;
					}
				}	*/
				
				/* Compute dist_spct if the TSI amount of the master table
				** is not equal to zero.  Otherwise, nothing happens.  */
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
				
				/* Compute dist_prem  */
				//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0));			
				$("txtDistPrem").writeAttribute("distPrem", $F("txtDistPrem"));    
			}
		}catch(e){
			showErrorMessage("Premium on change.", e);
		}
	});

	/* % Share Premium*/ 
	initPreTextOnField("txtDistSpct1");
	$("txtDistSpct1").observe("blur", function(){	
		try{
			if (!checkIfValueChanged("txtDistSpct1")) return;
			
			// shan 06.24.2014
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
			// end 06.24.2014
				
			var distSpct1 = $F("txtDistSpct1");	
			if(!(distSpct1.empty())){
				/*  Check that %Share is not greater than 100 */ 
				if(parseFloat(distSpct1) > 100){
					$("txtDistSpct1").value = getPreTextValue("txtDistSpct1");
					customShowMessageBox("%Share cannot exceed 100.", "I", "txtDistSpct1");
					return false;
				}
				/*if(parseFloat(distSpct1) < 0){
					customShowMessageBox("%Share must be greater than zero.", "I", "txtDistSpct1");
					return false;
				}
				if ($F("btnAddShare") == "Update") totalDistSpct1 = nvl(totalDistSpct1-parseFloat(nvl(selectedPerilDtl.distSpct1,0)),0);
				if ((parseFloat(distSpct1) + parseFloat(totalDistSpct1)) > 100){
					$("txtDistSpct1").value = getPreTextValue("txtDistSpct1");
					customShowMessageBox("%Share cannot exceed 100.", "I", "txtDistSpct1");
					return false;
				}	*/
				
				
				/* Compute DIST_TSI if the TSI amount of the master table
				 * is not equal to zero.  Otherwise, nothing happens.  */
	
				if(selectedPerilRow.premAmt != 0){
					var txtDistPrem = nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.premAmt),0);
					/*if (txtDistPrem > unformatCurrencyValue(selectedPerilRow.premAmt)){
						$("txtDistSpct1").value = getPreTextValue("txtDistSpct1");						
						customShowMessageBox("TSI must not exceed "+formatCurrency(selectedPerilRow.premAmt)+".", "I", "txtDistSpct1");
						return false;
					}*/
					$("txtDistPrem").value = formatCurrency(roundNumber(txtDistPrem,2));
					$("txtDistPrem").writeAttribute("distPrem", txtDistPrem); // andrew - 05.28.2012 - SR# 9261, discrepancy in total
					/*if (roundNumber(unformatCurrency("txtDistPrem"), 2) == 0){
						customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistPrem");
						return false;
					}*/	
				}else{
					$("txtDistPrem").value = "0.00";
					$("txtDistPrem").writeAttribute("distPrem", "0.00"); // andrew - 05.30.2012
				}
				
				/* Compute dist_prem  */
				//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrencyValue(selectedPerilRow.tsiAmt),0));
			}
		}catch(e){
			showErrorMessage("% Share Premium on blur.", e);
		}
	});	

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
	
	function clearShare(){
		try{
			setDistShareFormFields(null);
			getShareDefaults(true);
			unselectRow("distShareTable");
			if (selectedPerilRow != null) {
				deselectRows("distPerilListing", "rowDistPeril");
				fireEvent($("rowDistPeril" + selectedPerilRow.distNo + "_" + selectedPerilRow.distSeqNo + "_" + selectedPerilRow.perilCd), "click");
			}
		}catch(e){
			showErrorMessage("clearShare", e);
		}
	}
	
	// delete dist share
	function deleteShare(){
		try{
			if ($F("txtC080DistNo") == ""){
				customShowMessageBox("Distribution no. is required.", "E", "txtC080DistNo");
				return false;
			}
			if (String(nvl((selectedGroupRow == null) ? null : selectedGroupRow.distNo, "")).blank()){ // to check if a dist group is selected
				showMessageBox("Please select distribution group first.", "E");
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
											selectedPerilRow = objArray[a].giuwWPerilds[b];
											Effect.Fade(row,{
												duration: .5,
												afterFinish: function(){
													row.remove();
													clearShare();
													computeTotalShareAmount();
													//checkTableItemInfoAdditional("distShareTable","distShareListing","rowDistShare","distNo",Number($("txtC080DistNo").value),"groupNo",Number(selectedGroupRow.distSeqNo),"perilCd",Number(selectedPerilRow.perilCd));
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
	
	$("btnDeleteShare").observe("click", function() {
		deleteShare();
	});

	//create new Object for Dist Share to be added on Object Array
	// if param is SHARE, set obj to selectedPerilDtl, else set to selectedPerilRow
	function setShareObject(param) {
		try {
			var objGroup = objSelected;
			var obj = (param == "SHARE") ? selectedPerilDtl : selectedPerilRow;
			var newObj = new Object();
			newObj.recordStatus			= obj == null ? null :nvl(obj.recordStatus, null);
			newObj.distNo				= obj == null ? objGroup.distNo :nvl(obj.distNo, objGroup.distNo);
			newObj.distSeqNo 			= obj == null ? objGroup.distSeqNo :nvl(obj.distSeqNo, objGroup.distSeqNo);
			newObj.lineCd 				= obj == null ? "" :nvl(obj.lineCd ,nvl(objGroup.lineCd, nvl(selectedPerilRow.lineCd, (isPack != "Y") ? $("globalLineCd").value : $("initialLineCd").value/*$F("globalLineCd")*/)));
			newObj.perilCd				= obj == null ? null : nvl(obj.perilCd, null);
			newObj.shareCd 				= obj == null ? "" :nvl($F("shareCd"), "");
			newObj.distSpct				= escapeHTML2($F("txtDistSpct"));
			//newObj.distTsi				= escapeHTML2(unformatNumber($F("txtDistTsi")));
			newObj.distTsi				= $("txtDistTsi").readAttribute("distTsi");		// andrew - 05.28.2012 - SR# 9575, discrepancy in total tsi
			//newObj.distPrem				= escapeHTML2(unformatNumber($F("txtDistPrem"))); // andrew - 05.28.2012 - SR# 9261, discrepancy in total prem
			newObj.distPrem				= $("txtDistPrem").readAttribute("distPrem");
			newObj.annDistSpct			= escapeHTML2($F("txtDistSpct")); //obj == null ? "" :nvl(obj.annDistSpct, "");
			//newObj.annDistTsi			= (nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100;	//obj == null ? "" :nvl(obj.annDistTsi, "");
			newObj.annDistTsi			= selectedPerilRow == null ? nvl(newObj.distTsi,0) : (nvl(selectedPerilRow.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100; // Nica 05.29.2013
			newObj.distGrp				= obj == null ? "1" :"1"; //nvl(obj.distGrp, ""); //pre-insert block :C1407.dist_grp := 1;
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
	
	//function add record
	function addShare(){
		try{
			if ($F("txtC080DistNo") == ""){
				customShowMessageBox("Distribution no. is required.", "E", "txtC080DistNo");
				return false;
			}
			if (String(nvl((selectedGroupRow == null) ? null : selectedGroupRow.distNo, "")).blank()){
				showMessageBox("Please select distribution group first.", "E");
				return false;
			}	
			if ($F("txtDspTrtyName") == ""){
				customShowMessageBox("Share is required.", "E", "txtDspTrtyName");
				return false;
			}
			if ($F("txtDistSpct") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDistSpct"); //"% Share Sum insured is required.""
				return false;
			}
			if ($F("txtDistTsi") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDistTsi"); //"Sum insured is required."
				return false;
			}
			if ($F("txtDistSpct1") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDistSpct1"); //"% Share Premium is required."
				return false;
			}
			if ($F("txtDistPrem") == ""){
				customShowMessageBox("Premium is required.", "E", "txtDistPrem");
				return false;
			}
			if (parseFloat($F("txtDistSpct")) > 100){
				customShowMessageBox("%Share Sum insured cannot exceed 100.", "E", "txtDistSpct");
				return false;
			}	
			if (parseFloat($F("txtDistSpct")) <= 0 && parseFloat($F("txtDistSpct1")) <= 0){
				//customShowMessageBox("%Share Sum insured must be greater than zero.", "E", "txtDistSpct");
				customShowMessageBox("TSI %Share and Premium %Share should not be both zero.", "E", "txtDistSpct");
				return false;
			}
			if (parseFloat($F("txtDistSpct1")) > 100){
				customShowMessageBox("%Share Premium cannot exceed 100.", "E", "txtDistSpct1");
				return false;
			}	
			/*if (parseFloat($F("txtDistSpct1")) <= 0){
				customShowMessageBox("%Share Premium must be greater than zero.", "E", "txtDistSpct1");
				return false;
			}*/
			/*if (unformatCurrencyValue(String(objSelected.tsiAmt)) != 0){
				$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrencyValue(String(objSelected.tsiAmt)),0));
				if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){
					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
					return false;
				}	
			}*/
			if (Math.abs($F("txtDistTsi")) > Math.abs(unformatCurrencyValue(String(/*objSelected*/selectedPerilRow.tsiAmt)))){	// changed by shan 06.24.2014
				customShowMessageBox("Sum insured cannot exceed TSI.", "E", "txtDistTsi");
				return false;
			}
			if (unformatCurrencyValue(String(objSelected.tsiAmt)) > 0){
				if (unformatCurrency("txtDistTsi") <= 0 && unformatCurrency("txtDistSpct1") <= 0){
					customShowMessageBox("Sum insured must be greater than zero.", "E", "txtDistTsi");
					return false;
				}	
			}else if (unformatCurrencyValue(String(objSelected.tsiAmt)) < 0){
				if (unformatCurrency("txtDistTsi") >= 0){
					customShowMessageBox("Sum insured must be less than zero.", "E", "txtDistTsi");
					return false;
				}	
			}
			
			if($F("btnAddShare") == "Add"){
				if(parseFloat($("totalDistSpct").innerHTML) + parseFloat($F("txtDistSpct")) > 100){
					showMessageBox("TSI %Share cannot exceed 100.");
					return false;
				};
				
				if(parseFloat($("totalDistSpct1").innerHTML) + parseFloat($F("txtDistSpct1")) > 100){
					showMessageBox("Premium %Share cannot exceed 100.");
					return false;
				};
			} else {
				var tempDistSpct = 0;
				var tempDistSpct1 = 0;
				
				if(parseFloat($F("txtDistSpct")) > parseFloat(selectedPerilDtl.distSpct)){
					tempDistSpct = parseFloat($F("txtDistSpct")) - parseFloat(selectedPerilDtl.distSpct);
					if(parseFloat($("totalDistSpct").innerHTML) + tempDistSpct > 100){
						showMessageBox("TSI %Share cannot exceed 100.");
						return false;
					}
				}
				
				if(parseFloat($F("txtDistSpct1")) > parseFloat(selectedPerilDtl.distSpct1)){
					tempDistSpct1 = parseFloat($F("txtDistSpct1")) - parseFloat(selectedPerilDtl.distSpct1);
					if(parseFloat($("totalDistSpct1").innerHTML) + tempDistSpct1 > 100){
						showMessageBox("Premium %Share cannot exceed 100.");
						return false;
					}
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
											objArray[a].autoDist = "N"; // unpost distribution when posted : shan 06.16.2014
											objArray[a].giuwWPerilds[b].recordStatus = 1;
											selectedPerilRow = objArray[a].giuwWPerilds[b];
											// update click event of this dist share row
											$(id).stopObserving("click");
											setRowObserver($(id), 
													function() {
														clickDistShareRow($(id), newObj);
														computeTotalShareAmount();
													});
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
										objArray[a].giuwWPerilds[b].perilCd == perilCd &&  
										objArray[a].giuwWPerilds[b].recordStatus != -1){
									//Share
									addNewJSONObject(objArray[a].giuwWPerilds[b].giuwWPerildsDtl, newObj);
									objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
									selectedPerilRow = objArray[a].giuwWPerilds[b];
									objGIUWWPerildsDtl.push(newObj);
									computeTotalShareAmount();
									break;
								}
							}
						}
					}
					
					createDistShareRow(newObj);
					changeTag = 1;
				}	
				clearShare();
			}	
		}catch(e){
			showErrorMessage("addShare", e);
		}		
	}
	
	$("btnAddShare").observe("click", function() {
		addShare();
	});

	function procedurePreCommit(){
		try{
			var ok = true;
			var ctr = 0;
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistSpct1 = 0;
			var sumDistPrem = 0;
			var tempDistTsi = 0;	// shan 05.14.2014
			var tempDistPrem = 0;	// shan 05.14.2014
			var objArray = objGIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
								if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1){
									ctr++;
									objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1 = nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1, objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct); // shan 06.09.2014
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0));
									sumDistSpct1 = (parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0))); // andrew - 05.22.2012 - for computation of sumDistSpct1 / SR # 0009261
									// modified to handle disb share where Sum Insured and Premium have odd decimal value : shan 06.10.2014
									tempDistTsi = (parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct,0)) / 100) * nvl(objArray[a].giuwWPerilds[b].tsiAmt,0);
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(tempDistTsi); //parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi,0));
									tempDistPrem = (parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1,0)) / 100) * nvl(objArray[a].giuwWPerilds[b].premAmt,0);
									sumDistPrem = parseFloat(sumDistPrem) + tempDistPrem; //parseFloat(nvl(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem,0));
								}
							}
							function err(msg){
								var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowPrelimPerilDistByTsiPrem");
								dist == "rowPrelimPerilDistByTsiPrem"+nvl(objArray[a].distNo,'---') ? null : ($("rowPrelimPerilDistByTsiPrem"+nvl(objArray[a].distNo,'---')) ? fireEvent($("rowPrelimPerilDistByTsiPrem"+nvl(objArray[a].distNo,'---')), "click") :null);
								dist == "rowPrelimPerilDistByTsiPrem"+nvl(objArray[a].distNo,'---') ? null : ($("rowPrelimPerilDistByTsiPrem"+nvl(objArray[a].distNo,'---')) ? $("rowPrelimPerilDistByTsiPrem"+nvl(objArray[a].distNo,'---')).scrollIntoView() :null);
								//disableButton("btnPostDist");
								showWaitingMessageBox(msg, "E", 
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
							// changed rounding off from 14 to 9 : shan 05.08.2014; removed ctr == 1 condition 06.09.2014
							if ((roundNumber(sumDistSpct, 9) != 100 || roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].tsiAmt,0), 2)) /*&& ctr==1*/){
								err("Total %Share should be equal to 100.");
								return false;
							}
							// changed rounding off from 14 to 9 : shan 05.08.2014; removed ctr == 1 condition 06.09.2014
							if ((roundNumber(sumDistSpct1, 9) != 100 || roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWPerilds[b].premAmt,0), 2)) /*&& ctr==1*/){								
								err("Total %Share should be equal to 100.");
								return false;
							}
							sumDistSpct = 0;
							sumDistTsi = 0;
							sumDistSpct1 = 0;
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

	function checkC120TsiPremium(){
		try{
			/* if((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E"){
				return true;
			} */
			postNoCommitSw = "N";
			var ok = true;
			var objArray = objGIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
						if (objArray[a].giuwWPerilds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){								
								//if (nvl(objArray[a].giuwWPerilds[b].recordStatus,0) == 1){ // andrew - 05.28.2012 - comment out to show validation
									if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distPrem == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distTsi == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 && !((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E")){
										var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowPrelimPerilDistByTsiPrem");
										dist == "rowPrelimPerilDistByTsiPrem"+objArray[a].distNo ? null :fireEvent($("rowPrelimPerilDistByTsiPrem"+objArray[a].distNo), "click");
										dist == "rowPrelimPerilDistByTsiPrem"+objArray[a].distNo ? null :$("rowPrelimPerilDistByTsiPrem"+objArray[a].distNo).scrollIntoView();
										//disableButton("btnPostDist");
										postNoCommitSw = "Y";
										showWaitingMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" with a peril of "+objArray[a].giuwWPerilds[b].perilName+" cannot have both its TSI and Premium share % equal to zero.", "E",
											function(){
												var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
												grp == "rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo? null :fireEvent($("rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo), "click");
											});
										ok = false;
										return false;
									} else if (objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSpct1 == 0 && objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus != -1 && ((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E")){
										var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowPrelimPerilDistByTsiPrem");
										dist == "rowPrelimPerilDistByTsiPrem"+objArray[a].distNo ? null :fireEvent($("rowPrelimPerilDistByTsiPrem"+objArray[a].distNo), "click");
										dist == "rowPrelimPerilDistByTsiPrem"+objArray[a].distNo ? null :$("rowPrelimPerilDistByTsiPrem"+objArray[a].distNo).scrollIntoView();
										//disableButton("btnPostDist");
										postNoCommitSw = "Y";
										showWaitingMessageBox("A share in group no. "+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+" with a peril of "+objArray[a].giuwWPerilds[b].perilName+" cannot have both its TSI and Premium share % equal to zero.", "E",
											function(){
												var grp = getSelectedRowIdInTable_noSubstring("distGroupListing", "rowDistGroup");
												grp == "rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo? null :fireEvent($("rowDistGroup"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+"_"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo), "click");
											});
										ok = false;
										return false;
									}
								//}
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
			objParameters.giuwPolDistPostedRecreated	= prepareJsonAsParameter(giuwPolDistPostedRecreated);
			objParameters.giuwPolDistRows 				= prepareJsonAsParameter(giuwPolDistRows);
			objParameters.giuwWPerildsRows 				= prepareJsonAsParameter(giuwWPerildsRows);
			objParameters.giuwWPerildsDtlSetRows 		= prepareJsonAsParameter(giuwWPerildsDtlSetRows);
			objParameters.giuwWPerildsDtlDelRows 		= prepareJsonAsParameter(giuwWPerildsDtlDelRows);
			objParameters.parId							= (isPack != "Y") ? $("globalParId").value : $("initialParId").value;
			objParameters.lineCd						= (isPack != "Y") ? $("globalLineCd").value : $("initialLineCd").value;
			objParameters.sublineCd						= (isPack != "Y") ? $("globalSublineCd").value : $("initialSublineCd").value;
			objParameters.polFlag						= varVPolFlag; //$("globalPolFlag").value;
			objParameters.parType						= globalParType; //$("globalParType").value;
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}

	function clearForm(){
		try{
			selectedGroupRow = null;
			selectedPerilRow = null; 
			selectedPerilDtl = {};
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
			disableButton("btnPostDist"); //added by christian 03/16/2013
		}catch(e){
			showErrorMessage("clearForm", e);
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
				$("rowPrelimPerilDistByTsiPrem"+objArray[a].distNo) ? $("rowPrelimPerilDistByTsiPrem"+objArray[a].distNo).update(content) :null;
				//Group
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					var content2 = prepareDistGroupRow(objArray[a].giuwWPerilds[b]);
					objArray[a].giuwWPerilds[b].recordStatus = null;
					$("rowDistGroup"+objArray[a].giuwWPerilds[b].distNo+"_"+objArray[a].giuwWPerilds[b].distSeqNo) ? $("rowDistGroup"+objArray[a].giuwWPerilds[b].distNo+"_"+objArray[a].giuwWPerilds[b].distSeqNo).update(content2) :null;
					//Peril
					var content2b = prepareDistPerilRow(objArray[a].giuwWPerilds[b]);
					$("rowDistPeril"+objArray[a].giuwWPerilds[b].distNo+"_"+objArray[a].giuwWPerilds[b].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd) ? $("rowDistPeril"+objArray[a].giuwWPerilds[b].distNo+"_"+objArray[a].giuwWPerilds[b].distSeqNo+"_"+objArray[a].giuwWPerilds[b].perilCd).update(content2b) :null;
						//Share
						for(var c=0; c<objArray[a].giuwWPerilds[b].giuwWPerildsDtl.length; c++){
							var content3 = prepareDistShareRow(objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c]);
							objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].recordStatus = null;
							$("rowDistShare"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].lineCd+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd) ? $("rowDistShare"+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].lineCd+""+objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].shareCd).update(content3) :null;
						}						
				}	
				if (objArray[a].distNo == Number($F("txtC080DistNo"))){
					objSelected = objArray[a];
					buttonLabel(objSelected);
				}	
			}	
		}catch(e){
			showErrorMessage("refreshForm", e);
		}	
	}
	
	//for adjustment of distribution tables edgar 04/28/2014
	function adjustPerilDistTables(){
		for(var i=0, length=objGIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustPerilDistTables",
					distNo : objGIUWPolDist[i].distNo
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
		
	//for checking of expired portfolio share edgar 05/02/2014
	function checkExpiredTreatyShare (func){
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
									parId:	objArray[a].parId
								},
								asynchronous: false,
								evalScripts: true,
								onComplete : function(response){
									hideNotice();
									if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
										var comp = JSON.parse(response.responseText);
										/*if (dateFormat((comp.expiryDate), "mm-dd-yyyy") <  dateFormat((objArray[a].effDate), "mm-dd-yyyy") && comp.portfolioSw == "P"){
											showMessageBox(comp.treatyName +" share in group no." + objArray[a].giuwWPerilds[b].giuwWPerildsDtl[c].distSeqNo + 
										               " with a peril of " + objArray[a].giuwWPerilds[b].perilName +
										               " is already expired. Please do necessary changes before posting the distribution.", imgMessage.ERROR);
										 	ok = false;	
										}*/if (comp.vExpired == "Y"){
											showMessageBox("Treaty "+comp.treatyName +"  has already expired. Replace the treaty with another one.", imgMessage.ERROR);
										 	ok = false;	
										}else{
											ok = true;
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
		/*if (!ok){
			return false;
		}else {
			return true;
		}*/
		if(ok){
			func();
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
		var objArray = objGIUWPolDist;
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
				distNo : Number($F("txtC080DistNo"))
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
	//end of code for adjustment/recomputation edgar 04/28/2014	
	
	function savePrelimPerilDistByTsiPrem(param){
		try{
			//if (globalParType == "E"){	// fires only when an endorsement added condition : shan 06.10.2014
				if (!checkC120TsiPremium())return false;	
			//}
			checkNullDistPrem("S", param);			
		}catch(e){
			showErrorMessage("savePrelimPerilDistByTsiPrem", e);
		}
	}	

	function checkDistFlag() {
		var ok = true;

		new Ajax.Request(contextPath+"/GIUWPolDistController?action=checkDistFlagGiuws003", {
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				distNo: (selectedPerilDtl == null) ? null : nvl(selectedPerilDtl.distNo, null),
				distSeqNo: (selectedPerilDtl == null) ? null : nvl(selectedPerilDtl.distSeqNo, null),
				perilCd: (selectedPerilDtl == null) ? null : nvl(selectedPerilDtl.perilCd, null)
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					var vCount = result.pCount;
					var vCount2 = result.pCount2;

					if(vCount == 0 && vCount2 != 0 && $F("txtC080DistFlag") == "2"){
						showMessageBox("Distribution Flag = 2 and GIUW_WPERILDS_DTL has no record.", "I");
						ok = false;
						return false;
					}
				}else{
					ok = false;
					return false;
				}
			}
		});

		return ok;
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

	function createItems(index, distNo){
		try{
			var ok = true;
			var noticeMsg = $("btnCreateItems").value == "Recreate Items" ? "Recreating" :"Creating";
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "createItemsGiuws006",
					distNo: distNo,
					parId: (isPack != "Y") ? $("globalParId").value : $("initialParId").value,
					lineCd: (isPack != "Y") ? $("globalLineCd").value : $("initialLineCd").value, //$("globalLineCd").value,
					sublineCd: (isPack != "Y") ? $("globalSublineCd").value : $("initialSublineCd").value, //$("globalSublineCd").value,
					issCd: globalIssCd, //$("globalIssCd").value,
					packPolFlag: $("globalPackPolFlag").value,
					polFlag: globalPolFlag, //$("globalPolFlag").value,
					parType: globalParType, //$("globalParType").value,
					itemGrp: (objSelected == null) ? null : nvl(objSelected.itemGrp, null),
					label: $("btnCreateItems").value		
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice(noticeMsg+" Items, please wait...");
				},	
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
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
							//buttonLabel(objArray[index]);
							objSelected = obj;
							var content = prepareDistRow(objArray[index]);
							$("rowPrelimPerilDistByTsiPrem"+distNo).update(content);

							//Group
							createAdditionalList(objArray[index].giuwWPerilds);

							// show groups with similar distNo						
							($("distGroupListing").childElements()).invoke("hide"); 
							($$("div#distGroupListing div[distNo='"+ objArray[index].distNo +"']")).invoke("show");
							unClickRow("distGroupListingTable");
							($("distPerilListing").childElements()).invoke("hide"); 
							
							// resize & show the table
							resizeTableBasedOnVisibleRows("distGroupListingTable", "distGroupListing");
							resizeTableBasedOnVisibleRows("distPerilTable", "distPerilListing");
							resizeTableBasedOnVisibleRows("distShareTable", "distShareListing");
							
							// enable View Distribution button if PAR is endt.
							if (/*$("globalParType").value*/ globalParType == "E") {
								enableButton("btnViewDist");
							} else {
								disableButton("btnViewDist");
							}
							clearShare();
							//changeTag=1;
							showMessageBox(noticeMsg+" Items complete.", "S");
						}else{
							ok = false;
							customShowMessageBox(res.message, "E", "btnCreateItems");
							return false;
						}	
					}else{
						ok = false;
					}
				}	
			});	
			$("btnCreateItems").value = "Recreate Items";
			return ok;
		}catch (e) {
			showErrorMessage("createItems", e);
		}	
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
					recObj.parId = (isPack != "Y") ? $("globalParId").value : $("initialParId").value, //$("globalParId").value;
					recObj.lineCd = (isPack != "Y") ? $("globalLineCd").value : $("initialLineCd").value, //$("globalLineCd").value;
					recObj.sublineCd = (isPack != "Y") ? $("globalSublineCd").value : $("initialSublineCd").value, //$("globalSublineCd").value;
					recObj.issCd = globalIssCd, //$("globalIssCd").value;
					recObj.packPolFlag = $("globalPackPolFlag").value;
					recObj.polFlag = globalPolFlag, //$("globalPolFlag").value;
					recObj.parType = globalParType, //$("globalParType").value;
					recObj.itemGrp = (objSelected == null) ? null : nvl(objSelected.itemGrp, null);
					recObj.process = "R";
					recObj.processId = giuwPolDistPostedRecreated.length;
					recObj.label = $("btnCreateItems").value;
					//giuwPolDistPostedRecreated.push(recObj);
					
					$("rowPrelimPerilDistByTsiPrem"+distNo).update("");
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
					clearForm();
				}	
			}

			createItems(index, distNo);
			//adjustPerilDistTables(); //for adjusting distribution tables edgar 04/28/2014; uncommented, moved inside GIUWPolDistDAOImpl : shan 07.25.2014
		}catch(e){
			showErrorMessage("onOkFunc", e);
		}
	}	
	
	$("btnCreateItems").observe("click", function(){
		if (objSelected != null) {
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

							if (!compareGipiItemItmperil("1")) return false;

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
			showMessageBox("Please select distribution group first.", "I");
		}
	});

	function checkOverrideNetTreaty(){
		try{
			commonOverrideOkFunc = function(){
				changeTag=1;
				netOverride = postResult.paramFunction == "RO" ? "Y" :netOverride;
				treatyOverride = postResult.paramFunction == "TO" ? "Y" :treatyOverride;
				var id = objSelected.divCtrId; 
				objSelected = postResult.newItems;
				objSelected.divCtrId = id;
				var id2 = getSelectedRowIdInTable("distListing", "rowPrelimPerilDistByTsiPrem");
				var dist = getSelectedRowIdInTable_noSubstring("distListing", "rowPrelimPerilDistByTsiPrem");
				objGIUWPolDist[id].varShare = postResult2.newItems.varShare; 	// changed from postResult : shan 06.13.2014
				objGIUWPolDist[id].postFlag = postResult2.newItems.postFlag; 	// changed from postResult : shan 06.13.2014
				objGIUWPolDist[id].distFlag = postResult2.newItems.distFlag; 	// changed from postResult : shan 06.13.2014
				objGIUWPolDist[id].meanDistFlag = postResult2.newItems.meanDistFlag; 	// changed from postResult : shan 06.13.2014
				objGIUWPolDist[id].autoDist = postResult2.newItems.autoDist; 	// added : shan 06.16.2014
				objGIUWPolDist[id].posted = "Y";
				objGIUWPolDist[id].recordStatus = 1;
				var content = prepareDistRow(objGIUWPolDist[id]);
				$("rowPrelimPerilDistByTsiPrem"+id2).update(content);
				$("txtC080DistFlag").value = postResult2.distFlag;	// changed from postResult : shan 06.13.2014
				$("txtC080MeanDistFlag").value = postResult2.meanDistFlag; 	// changed from postResult : shan 06.13.2014
				//showMessageBox("Post Distribution Complete.", "S"); 
				for(var a=0; a<objGIUWPolDist[id].giuwWPerilds.length; a++){
					var obj = new Object();
					obj.parId = objGIUWPolDist[id].parId;
					obj.distNo = objGIUWPolDist[id].giuwWPerilds[a].distNo;
					obj.distSeqNo = objGIUWPolDist[id].giuwWPerilds[a].distSeqNo;
					obj.process = "P";
					obj.processId = giuwPolDistPostedRecreated.length;
					giuwPolDistPostedRecreated.push(obj);
				}
				if (nvl(postResult.donePosting,"N") == "Y"){
					checkAutoDist1(objGIUWPolDist[id]);
					postResult.donePosting = "N";
					savePrelimPerilDistByTsiPrem("P");
					dist == "rowPrelimPerilDistByTsiPrem"+nvl(id2,'---') ? null : ($("rowPrelimPerilDistByTsiPrem"+nvl(id2,'---')) ? fireEvent($("rowPrelimPerilDistByTsiPrem"+nvl(id2,'---')), "click") :null);
					dist == "rowPrelimPerilDistByTsiPrem"+nvl(id2,'---') ? null : ($("rowPrelimPerilDistByTsiPrem"+nvl(id2,'---')) ? $("rowPrelimPerilDistByTsiPrem"+nvl(id2,'---')).scrollIntoView() :null);
				}
			};
			commonOverrideNotOkFunc = function(){
				showWaitingMessageBox($("overideUserName").value+" does not have an overriding function for this module.", "E", 
						clearOverride);
			};	
			function override(funcCode){	// added parameter : shan 06.13.2014
				try{
					/*objAC.funcCode = postResult.paramFunction;
					objACGlobal.calledForm = postResult.moduleId;
					getUserInfo();
					var title = postResult.netOverride != null ? postResult.netOverride :(postResult.treatyOverride != null ? postResult.treatyOverride :"Override");
					$("overlayTitle").innerHTML = title;*/ // replaced with codes below
					//start of modification edgar 06/10/2014
					if (funcCode == "RO"){
						objAC.funcCode = funcCode;
						objACGlobal.calledForm = postResult.moduleId;
						showGenericOverride(
								"GIUWS006",
								"RO",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showConfirmBox("Confirmation", "User "+userId+" is not allowed to override.", 
												"Yes", "No","","");
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
																					"GIUWS006",
																					"TO",
																					function(ovr, userId, result){
																						if(result == "FALSE"){
																							showConfirmBox("Confirmation", "User "+userId+" is not allowede to override.", 
																									"Yes", "No","","");
																							return false;
																						} else if(result == 'TRUE') {	
																							ovr.close();
																							delete ovr;
																							postDistGiuws006Final();
																						}								
																					},
																					function(){
																						return false;
																					},
																					"Treaty Override");}, "");
																}
															}else{
																postDistGiuws006Final();
															}
													}, "");	
										}else{
											postDistGiuws006Final();
										}
									}								
								},
								function(){
									return false;
								},
								"Net Retention Override");
					}else if (funcCode == "TO"){
						objAC.funcCode = funcCode;
						objACGlobal.calledForm = postResult.moduleId;
						showGenericOverride(
								"GIUWS006",
								"TO",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showConfirmBox("Confirmation", "User "+userId+" is not allowede to override.", 
												"Yes", "No","","");
										return false;
									} else if(result == 'TRUE') {	
										ovr.close();
										delete ovr;
										postDistGiuws006Final();
									}								
								},
								function(){
									return false;
								},
								"Treaty Override");
					}
					//end of modification edgar 06/10/2014
				}catch (e) {
					showErrorMessage("checkOverrideNetTreaty - override", e);
				}
			}	
			if (postResult.overrideMsg != null && ((netOverride == "N" && postResult.paramFunction == "RO") || (treatyOverride == "N" && postResult.paramFunction == "TO"))){
				/*showConfirmBox("Confirmation", postResult.overrideMsg, 
						"Override", "Cancel", override, "");*/ // replaced with codes below
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
				if (postResult.treatyMsg != null){
					showConfirmBox("Confirmation", postResult.treatyMsg, 
							"Yes", "No",
							function(){
										postDistGiuws006Final();
										commonOverrideOkFunc();
					},"");
				}else{
					postDistGiuws006Final();
					commonOverrideOkFunc();
				}
			}	
			isSavePressed = false;
			/* showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS, function (){
				isSavePressed = false;  // to indicate the [Save] button was not pressed edgar 05/13/2014
			});  */
					
		}catch (e) {
			showErrorMessage("checkOverrideNetTreaty", e);
		}
	}	
	
	function checkNullDistPrem(btnSw, param){
		var ok = true;
		new Ajax.Request(contextPath+"/GIUWPolDistController",{
			parameters:{
				action: "checkNullDistPremGIUWS006",
				distNo: Number($F("txtC080DistNo")),
				btnSw:  btnSw					
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.counter == "Y"){
						showMessageBox("Some records have null distribution prem amount. Distribution records will be recomputed.","I");
					}
					
					if (btnSw == "P"){
						if (!checkDistFlag()) return false;
						if (!procedurePreCommit()) return false;
						
						getTakeUpTerm(); //get take up term edgar 05/08/2014
						if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up edgar 05/08/2014
							if (!compareWitemPerilToDs()) return false; // for comparison of ds table to itemperil table edgar 05/05/2014
						}
						
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
									refreshForm(objSelected);
									enableButton("btnPostDist");
								}
							});
							
							if (objSelected != null) {
								checkAutoDist1(objSelected); // to avoid repetitive function call 
							}
						}else {
							checkExpiredTreatyShare(continuePost);// for checking of expired treaty edgar 05/02/2014						
						}
						
					}else if (btnSw == "S"){
						if (!procedurePreCommit()){
							return false;	
						}
						checkNullDistPrem("W", param);
						
					}else if(btnSw == "W"){
						prepareDistForSaving();
			
						var objParameters = new Object();
						objParameters = prepareObjParameters();
						objParameters.savePosting = nvl(param,null) == null ? "N" :"Y";
						
						new Ajax.Request(contextPath + "/GIUWPolDistController", {
							method : "POST",
							parameters : {
								action: "savePrelimPerilDistByTsiPrem",
								parameters : JSON.stringify(objParameters)
							},
							asynchronous: false,
							evalScripts: true,
							onCreate : function(){
								showNotice("Saving Preliminary Peril Distribution by TSI/Prem, please wait ...");
							},
							onComplete : function(response){
								hideNotice();
								if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){						
									var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
									/* if(res.message.include("Geniisys Exception")){
										var message = res.message.split("#");
										showMessageBox(message[2], message[1]);
										return false;
									}
									if (res.message != "SUCCESS"){
										showMessageBox(res.message, "E");
									}else{ */
										giuwPolDistPostedRecreated.clear();
										changeTag = 0;
										if (param != "P") showMessageBox(objCommonMessage.SUCCESS, "S");
										clearForm();
										clearDistStatus(objGIUWPolDist);
										objGIUWPolDist = res.giuwPolDist;
										refreshForm(objGIUWPolDist);
										unClickRow("distGroupListingTable");
										showPreliminaryPerilDistByTsiPrem();
									//}
								}
							}
						});
						
						//adjustPerilDistTables(); //for adjusting distribution tables edgar 04/28/2014; uncommented, moved inside GIUWPolDistDAOImpl : shan 07.25.2014
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
	
	function checkSumInsuredPrem(func){
		var ok = true;
		
		new Ajax.Request(contextPath+"/GIUWPolDistController",{
			parameters:{
				action: "checkSumInsuredPremGIUWS006",
				distNo: Number($F("txtC080DistNo")),
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					func();
				}
			}
		});
	}

	var distinctDistSeqNos = [];	// shan 07.25.2014
	function validateB4Post(){
		var ok = false;
		if (objGIUWPolDist[0].premAmt == 0 || objGIUWPolDist[0].premAmt == "") {
			showMessageBox("Cannot post distribution. Please distribute by group.");
			return false;
		}
		
		for(var i=0, length=objGIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "validateB4PostGIUWS006",
					distNo : objGIUWPolDist[i].distNo,
					parId : objGIUWPolDist[i].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Validating records, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var objArray = objSelected;
						prepareDistForSaving();
						var objParameters = new Object();
						objParameters = prepareObjParameters();
						
						/* apollo cruz 6.26.2014
						added the ff. variables to be used in optimization of posting */						
						var uniqueDistNoSize = 0;
						var uniqueDistSeqNo = "";
						var uniqueDistSeqNoPosition = 0;
						
						//gets the size of distinct distSeqNo
						for(var a=0; a<objArray.giuwWPerilds.length; a++){
							var newDistSeqNo = false;
							
							if(uniqueDistSeqNo == ""){
								uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
								newDistSeqNo = true;
							} else if(objArray.giuwWPerilds[a].distSeqNo == uniqueDistSeqNo){
								newDistSeqNo = false;
							} else
								newDistSeqNo = true;
							
							uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
							
							if(newDistSeqNo)
								uniqueDistNoSize += 1;
						}	
						
						uniqueDistSeqNo = "";
						
						// used to store unique distSeqNo per distNo
						for(var a=0; a<objArray.giuwWPerilds.length; a++){
							distinctDistSeqNos.push({"distNo": objArray.giuwWPerilds[a].distNo, "distSeqNo" : objArray.giuwWPerilds[a].distSeqNo});
						}						
						for (var i=0; i < distinctDistSeqNos.length; i++){
							for (var j=0; j < distinctDistSeqNos.length; j++){
								if(distinctDistSeqNos[i].distNo == distinctDistSeqNos[j].distNo &&
										distinctDistSeqNos[i].distSeqNo == distinctDistSeqNos[j].distSeqNo){
									distinctDistSeqNos.pop();
								}
							}
						}
						
						/*for(var a=0; a<objArray.giuwWPerilds.length; a++){
							var newDistSeqNo = false;
							
							if(uniqueDistSeqNo == ""){
								uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
								newDistSeqNo = true;
							} else if(objArray.giuwWPerilds[a].distSeqNo == uniqueDistSeqNo){
								newDistSeqNo = false;
							} else
								newDistSeqNo = true;
							
							uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
							
							//postDistGiuws006 will be called only per unique distSeqNo
							if(newDistSeqNo){*/
							for(var a=0; a<distinctDistSeqNos.length; a++){
								uniqueDistSeqNoPosition += 1;
							
								new Ajax.Request(contextPath+"/GIUWPolDistController",{
									parameters:{
										action: "postDistGiuws006",
										parId: (isPack != "Y") ? $("globalParId").value : $("initialParId").value, //$("globalParId").value,
										distNo: /*objArray.giuwWPerilds*/distinctDistSeqNos[a].distNo,
										distSeqNo: /*objArray.giuwWPerilds*/distinctDistSeqNos[a].distSeqNo,
										parameters : JSON.stringify(objParameters)
									},
									asynchronous: false,
									evalScripts: true,
									onCreate: function(){
										//showNoticeSw = "Y";
										showNotice($("btnPostDist").value.replace("ost","osting")+", please wait...");
									},	
									onComplete: function(response){
										//hideNotice("");
										var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
										if (checkErrorOnResponse(response)){
											if (res.message == "" && res.vMsgAlert == null){
												postResult = res;
												
												//if (a==(objArray.giuwWPerilds.length-1)) postResult.donePosting = "Y";
												
												if (uniqueDistSeqNoPosition == /*uniqueDistNoSize*/distinctDistSeqNos.length)
													postResult.donePosting = "Y";
												
												if (res.netMsg != null){
													/*showConfirmBox("Confirmation", res.netMsg, 
															"Yes", "No", 
															function(){
																if (res.treatyMsg != null){
																	showConfirmBox("Confirmation", res.treatyMsg, 
																			"Yes", "No", checkOverrideNetTreaty, "");
																}else{
																	checkOverrideNetTreaty();
																}
															}, "");*/
													netTreaty = "NET";
													showConfirmBox("Confirmation", res.netMsg, 
															"Yes", "No", checkOverrideNetTreaty, "");//shan 06.13.2014 
												}else{
													if (res.treatyOverride != null){
														netTreaty = "TREATY";
														showConfirmBox("Confirmation", res.treatyMsg, 
																"Yes", "No", checkOverrideNetTreaty, "");
													}else{
														checkOverrideNetTreaty();
													}	
												}		
											}else{
												if (res.message != ""){
													customShowMessageBox(res.message, "E", "btnPostDist");
													return false;
												}else if(res.vMsgAlert != null){
													customShowMessageBox(res.vMsgAlert, "E", "btnPostDist");
													return false;
												}	
												if (objSelected != null) {
													checkAutoDist1(objSelected); // to avoid repetitive function call 
												}
											}	
										}		
									}
								});	
							}
						//}						
					}
					
				}
			});
		}
		
		return ok;
	}
	
	
	function postDistGiuws006Final(){
		try {
			var objArray = objSelected;
			prepareDistForSaving();
			var objParameters = new Object();
			objParameters = prepareObjParameters();
			
			/* apollo cruz 6.26.2014
			added the ff. variables to be used in optimization of posting */						
			var uniqueDistNoSize = 0;
			var uniqueDistSeqNo = "";
			var uniqueDistSeqNoPosition = 0;
			
			//gets the size of distinct distSeqNo
			for(var a=0; a<objArray.giuwWPerilds.length; a++){
				var newDistSeqNo = false;
				
				if(uniqueDistSeqNo == ""){
					uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
					newDistSeqNo = true;
				} else if(objArray.giuwWPerilds[a].distSeqNo == uniqueDistSeqNo){
					newDistSeqNo = false;
				} else
					newDistSeqNo = true;
				
				uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
				
				if(newDistSeqNo)
					uniqueDistNoSize += 1;
			}
			
			uniqueDistSeqNo = "";
			
			/*for(var a=0; a<objArray.giuwWPerilds.length; a++){
				
				var newDistSeqNo = false;
				
				if(uniqueDistSeqNo == ""){
					uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
					newDistSeqNo = true;
				} else if(objArray.giuwWPerilds[a].distSeqNo == uniqueDistSeqNo){
					newDistSeqNo = false;
				} else
					newDistSeqNo = true;
				
				uniqueDistSeqNo = objArray.giuwWPerilds[a].distSeqNo;
				
				//postDistGiuws006Final will be called only per unique distSeqNo
				if(newDistSeqNo){*/
				for(var a=0; a<distinctDistSeqNos.length; a++){	
					uniqueDistSeqNoPosition += 1;	
					
					new Ajax.Request(contextPath+"/GIUWPolDistController",{
						parameters:{
							action: "postDistGiuws006Final",
							parId: (isPack != "Y") ? $("globalParId").value : $("initialParId").value, //$("globalParId").value,
							distNo: /*objArray.giuwWPerilds*/distinctDistSeqNos[a].distNo,
							distSeqNo: /*objArray.giuwWPerilds*/distinctDistSeqNos[a].distSeqNo,
							parameters : JSON.stringify(objParameters)
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function(){
							//showNotice($("btnPostDist").value.replace("ost","osting")+", please wait...");
						},	
						onComplete: function(response){
							//hideNotice("");
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
							if (checkErrorOnResponse(response)){
								postResult2 = res;		
								var id = objSelected.divCtrId; 	
								objGIUWPolDist[id].varShare = postResult2.newItems.varShare; 
								objGIUWPolDist[id].postFlag = postResult2.newItems.postFlag; 	
								objGIUWPolDist[id].distFlag = postResult2.newItems.distFlag; 	
								objGIUWPolDist[id].meanDistFlag = postResult2.newItems.meanDistFlag; 
								objGIUWPolDist[id].autoDist = postResult2.newItems.autoDist;
								
								if(uniqueDistSeqNoPosition == /*uniqueDistNoSize*/distinctDistSeqNos.length && nvl(postResult.donePosting,"N") == "Y"){
									showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS,function(){
										isSavePressed = false;  // to indicate the [Save] button was not pressed jeffdojello 04192013
										//savePrelimPerilDistByTsiPrem("P");
										if($F("btnPostDist") == "Post Distribution to RI")
											disableButton("btnPostDist");
										else
											$("btnPostDist").value = "Unpost Distribution to Final";
									});
								}
								
								refreshForm(objGIUWPolDist[id]);
								/* if (objGIUWPolDist[id] != null) {
									checkAutoDist1(objGIUWPolDist[id]); // to avoid repetitive function call 
								}	 */					
							}		
						}
					});
				}	
			//}
			
		} catch (e) {
			showErrorMessage("postDistGiuws006Final", e);
		}
	}
	
	$("btnPostDist").observe("click", function() {
		if (changeTag == 0){
			if (objSelected == null) {
				showMessageBox("Please select distribution group first.", "I");
				return false;
			} else {
				if (globalParType == "E"){	
					if (!checkC120TsiPremium())return false;	
				}
				
				checkNullDistPrem("P");
			}
		}else{
			showMessageBox(/*"Changes is only available after changes have been saved."*/ objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
			return false;
		}	
	});	
	
	function continuePost(){
		/* if (globalParType == "E"){
			if (!checkZeroPremAllied()) return false;//for checking of zero premium for endorsements edgar 05/05/2014	
		} */
		if (globalParType == "P"){	
			if (!checkC120TsiPremium())return false;	
		}
		
		/* if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up edgar 05/08/2014
			if (!recomputeAfterCompare()) return false; // for recomputing and adjustment, prevents posting if there's still discrepancies edgar 05/07/2014
		} */
		
		if (globalParType == "E"){	
			//checkSumInsuredPrem(validateB4Post); //apollo cruz 
			validateB4Post();
		}else{
			if (takeUpTerm == "ST"){
				validateB4Post();
			}
			
		}		
	}
	
	$("btnViewDist").observe("click", function(){
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
					objGIPIS130.distSeqNo = selectedGroupRow == null ? null : selectedGroupRow.distSeqNo;
					objUWGlobal.previousModule = "GIUWS006";
					showViewDistributionStatus();
				}
			}
		});
	});
	
	observeReloadForm("reloadForm", showPreliminaryPerilDistByTsiPrem);
	observeCancelForm("btnCancel", savePrelimPerilDistByTsiPrem, (isPack == "Y") ? showPackParListing : showParListing);
	observeSaveForm("btnSave", savePrelimPerilDistByTsiPrem);

	clearForm();
	
	changeTag = 0;
	initializeChangeTagBehavior(savePrelimPerilDistByTsiPrem);
	setModuleId("GIUWS006");
	setDocumentTitle("Preliminary Peril Distribution by TSI/Prem");	
	window.scrollTo(0,0);
	hideNotice("");

	if (isPack == 'Y'){
		showPackagePARPolicyList(objGIPIParList);
		loadPackageParPolicyRowObserver();
		$("parNo").value = objUWGlobal.parNo;
	}

	$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
		if (row.getAttribute("parId") == $F("initialParId")){
			row.addClassName("selectedRow");
		}				
	});


	if ($("distListing").down("div", 0) != null && isPack != 'Y'){ // Tonio 07/11/2011 Added condition to handle error div is not loaded
		 fireEvent($("distListing").down("div", 0), "click"); 
	}

	$("summarizedDistDiv").hide();
}catch(e){
	showErrorMessage("Prelim Peril Dist By TSI/Prem page.", e);
}
</script>	
