<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="preliminaryOneRiskDistMainDiv" name="preliminaryOneRiskDistMainDiv" style="margin-top: 1px;">
	<input type="hidden" id="initialParId" value="${parId}"/>
	<input type="hidden" id="initialLineCd" value=""/> 	
	<form id="preliminaryOneRiskDistForm" name="preliminaryOneRiskDistForm">
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
					<div id="distListingTableDiv" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 20%; text-align: right; margin-right: 15px;">Distribution No.</label>
							<label style="width: 35%; text-align: left; margin-right: 5px;">Distribution Status</label>
							<label style="width: 35%; text-align: left; ">Multi Booking Date</label>
						</div>
						<div id="distListingDiv" name="distListingDiv" class="tableContainer">
								
						</div>
					</div>	
				</div>
				<div id="distGroup2Div" class="sectionDiv" style="display: block;">
					<div id="distGroupListingTableDiv" style="width: 800px; margin:auto; margin-top:10px;">
						<div class="tableHeader">
							<label style="width: 12%; text-align: right; margin-right: 5px;">Group No.</label>
							<label style="width: 30%; text-align: right; margin-right: 5px;">Group TSI</label>
							<label style="width: 30%; text-align: right; margin-right: 10px;">Group Premium</label>
							<label style="width: 25%; text-align: left; ">Currency</label>
						</div>
						<div id="distGroupListingDiv" name="distGroupListingDiv" class="tableContainer">
								
						</div>
					</div>
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
				<div id="distShareListingTableDiv" style="width:100%; padding-bottom:5px;">
					<div class="tableHeader" style="margin:10px; margin-bottom:0px;">
						<label style="width: 25%; text-align: left; margin-right: 3px;">Share</label>
						<label style="width: 25%; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 24%; text-align: right; margin-right: 5px;">Sum Insured</label>
						<label style="width: 24%; text-align: right; ">Premium</label>
					</div>
					<div id="distShareListingDiv" name="distShareListingDiv" style="margin:10px; margin-top:0px;" class="tableContainer">
							
					</div>
				</div>
				<div id="distShareTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
					<div id="distShareTotalAmtDiv" style="width:100%;">
						<label style="text-align:left; width:25%; margin-right: 3px; float:left;">Total:</label>
						<label style="text-align:right; width:25%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label style="text-align:right; width:24%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label style="text-align:right; width:24%; float:left;" class="money">&nbsp;</label>
					</div>
				</div>
				<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
					<tr>
						<td class="rightAligned">Share</td>
						<td class="leftAligned">
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
							<!-- changed nthDecimal property from 14 to 9 and maxlength from 18 to 13 edgar 05/13/2014-->
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct" name="txtDistSpct" value="" style="width:250px;" maxlength="13" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Sum Insured</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistTsi" name="txtDistTsi" value="" style="width:250px;" maxlength="18" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium</td>
						<td class="leftAligned">
							<input class="required money" type="text" id="txtDistPrem" name="txtDistPrem" value="" style="width:250px;" maxlength="14" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="3">
							<input type="button" id="btnAddShare"		name="btnAddShare"		class="button"	value="Add" />
							<input type="button" id="btnDeleteShare"	name="btnDeleteShare"	class="button"	value="Delete" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnCreateItems"	name="btnCreateItems"	class="button"	value="Create Items" />
			<input type="button" id="btnViewDist"		name="btnViewDist"		class="button"	value="View Distribution" />
			<input type="button" id="btnPostDist" 		name="btnPostDist" 		class="button"	value="Post Distribution to RI" />		
			<input type="button" id="btnCancel"			name="btnCancel"		class="button"	value="Cancel" />
			<input type="button" id="btnSave" 			name="btnSave" 			class="button"	value="Save" />			
		</div>
	</form>
</div>	
<div id="summarizedDistDiv"></div>
<script type="text/JavaScript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIUWS004");
	objUW.hidObjGIUWS004 = {};
	objUW.hidObjGIUWS004.GIUWPolDist = JSON.parse('${GIUWPolDistJSON}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated = [];
	objUW.hidObjGIUWS004.selectedGIUWPolDist = {};
	objUW.hidObjGIUWS004.selectedGIUWWpolicyds = {};
	objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl = {};
	objUW.hidObjGIUWS004.distListing = {};
	objUW.hidObjGIUWS004.globalParId = null;
	objUW.hidObjGIUWS004.lineCd = null;
	objUW.hidObjGIUWS004.nbtLineCd = null;
	objUW.hidObjGIUWS004.sumDistSpct = 0;
	objUW.hidObjGIUWS004.sumDistTsi = 0;
	objUW.hidObjGIUWS004.sumDistPrem = 0;
	var overrideSwitch = "N"; // added by: Nica 05.24.2012 - to check if a user override has been entered
	// for pack par
	var tempLineCd;
	var tempSublineCd;
	var tempIssCd;
	var tempPackPolFlag;
	var tempPolFlag;
	//for getting takeupterm edgar 05/12/2014
	var takeUpTerm = "";
	var isSavePressed =true; // to check whether the [Save] button was pressed or not base on GIUWS003 edgar 05/12/2014
	var postAdjust = "N"; // to manipulate adjustment when saving/posting due to error in distSpct1 edgar 05/12/2014
	var nullDistSpct1Exist; // for determining null and non-null distSpct1 edgar 05/13/2014
	var netTreaty;
	/*
		Added by Tonio July 11, 2011
		For Package Handling
	*/
	objGIPIParList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
	var isPack = "${isPack}";
	setInfoForPack(); // added by: Nica 09.10.2012 - to set necessary parameters for handline package policies
	var vProcess; //added by Gzelle 06232014
	
	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setPackParPolicyObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}
	
	function setInfoForPack(){
		if('${isPack}' == "Y"){
			for ( var p = 0; p < objGIPIParList.length; p++) {
				if (objGIPIParList[p].parId == $F("initialParId")){
					tempLineCd = objGIPIParList[p].lineCd;
					tempSublineCd = objGIPIParList[p].sublineCd;
					tempIssCd = objGIPIParList[p].issCd;
					tempPackPolFlag = 	objGIPIParList[p].packPolFlag;
					tempPolFlag = objGIPIParList[p].polFlag;
				}
			}
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
						$("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
						showPreliminaryOneRiskDist();
					}else {
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function (){
																												$("initialParId").value = row.getAttribute("parId");
																												$("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
																												savePrelimOneRiskDist();
																												showPreliminaryOneRiskDist();
																											  }, function () {
																												    $("initialParId").value = row.getAttribute("parId");
																												    $("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
																												    showPreliminaryOneRiskDist();
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
					clearDivs();
				}			
			});
		}catch(e){
			showErrorMessage("setPackParPolicyRowObserver", e);
		}
	}	

	function clearDivs(){
		if ($("distListingDiv").down("div", 0) != null){ 
			 $$("div[name='distListingDiv']").each(function(row){
				 row.remove();
			 });
			 $$("div[name='distShareListingDiv']").each(function(row){
				 row.remove();
			 });
			 fireEvent($("showDistGroup"), "click");
			 fireEvent($("showDistShare"), "click");
		}
	}
	
	// End package Handling
	
		
	//prepare listing for Main distribution
	function prepareList(obj){
		try{
			var list = '<label style="width: 20%; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
					   '<label style="width: 35%; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+'-'+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
					   '<label style="width: 35%; text-align: left; ">'+nvl(obj.multiBookingMm,'')+'-'+nvl(obj.multiBookingYy,'')+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList", e);
		}	
	}

	//prepare listing for Group distribution
	function prepareList2(obj){
		try{
			var list = '<label style="width: 12%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSeqNo,'') == '' ? '-' :formatNumberDigits(obj.distSeqNo,5))+'</label>'+
					   '<label style="width: 30%; text-align: right; margin-right: 5px;">'+(nvl(obj.tsiAmt,'') == '' ? '-' :formatCurrency(obj.tsiAmt))+'</label>'+
					   '<label style="width: 30%; text-align: right; margin-right: 11px;">'+(nvl(obj.premAmt,'') == '' ? '-' :formatCurrency(obj.premAmt))+'</label>'+
					   '<label style="width: 25%; text-align: left; ">'+nvl(obj.currencyDesc,'-')+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList2", e);
		}	
	}
	
	//prepare listing for Group distribution
	function prepareList3(obj){
		try{
			var list = '<label style="width: 25%; text-align: left; margin-right: 3px;">'+unescapeHTML2(nvl(obj.dspTrtyName,'-'))+'</label>'+
					   '<label style="width: 25%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct,'') == '' ? '-' /*:acceptedRound*/:formatToNthDecimal(obj.distSpct, 9/*14*/))+'</label>'+//changed round off from 14 to 9 edgar 05/13/2014
					   '<label style="width: 24%; text-align: right; margin-right: 5px;">'+(nvl(obj.distTsi,'') == '' ? '-' :formatCurrency(obj.distTsi))+'</label>'+
					   '<label style="width: 24%; text-align: right; ">'+(nvl(obj.distPrem,'') == '' ? '-' :formatCurrency(obj.distPrem))+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList3", e);
		}	
	}

	function showListPerObj(obj,a){
		var tableContainer = $("distListingDiv");
		var tableGroupContainer = $("distGroupListingDiv");
		var tableShareContainer = $("distShareListingDiv");

		//Group
		for(var b=0; b<obj.giuwWpolicyds.length; b++){
			var content = prepareList2(obj.giuwWpolicyds[b]);
			var newDiv = new Element("div");
			//obj.giuwWpolicyds[b].divCtrId = b;
			obj.giuwWpolicyds[b].recordStatus = null;
			newDiv.setAttribute("id", "rowGroupDist"+obj.giuwWpolicyds[b].distNo+""+obj.giuwWpolicyds[b].distSeqNo);
			newDiv.setAttribute("name", "rowGroupDist");
			newDiv.setAttribute("distNo", obj.giuwWpolicyds[b].distNo);
			newDiv.setAttribute("distSeqNo", obj.giuwWpolicyds[b].distSeqNo);
			newDiv.addClassName("tableRow");
			newDiv.update(content);
			tableGroupContainer.insert({bottom : newDiv});

			//Share
			for(var c=0; c<obj.giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
				var content = prepareList3(obj.giuwWpolicyds[b].giuwWpolicydsDtl[c]);
				var newDiv = new Element("div");
				//obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].divCtrId = c;
				obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus = null;
				newDiv.setAttribute("id", "rowShareDist"+obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+""+obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd+""+obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd);
				newDiv.setAttribute("name", "rowShareDist");
				newDiv.setAttribute("distNo", obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo);
				newDiv.setAttribute("distSeqNo", obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo);
				newDiv.setAttribute("lineCd", obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd);
				newDiv.setAttribute("shareCd", obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd);
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				tableShareContainer.insert({bottom : newDiv});
			}	
		}
	}	
	
	//show all listing
	function showList(objArray){
		try{
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareList(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				objArray[a].posted = "N";
				newDiv.setAttribute("id", "rowPrelimDist"+a);
				newDiv.setAttribute("name", "rowPrelimDist");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				$("distListingDiv").insert({bottom : newDiv});
				showListPerObj(objArray[a], a);
			}	
		}catch(e){
			showErrorMessage("showList", e);
		}	
	}

	//to show/generate the table listing
	showList(objUW.hidObjGIUWS004.GIUWPolDist);
	
	//create observe on Main list
	$$("div#distListingDiv div[name=rowPrelimDist]").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distListingDiv', 'rowPrelimDist', 
				function(){
					var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
					for(var a=0; a<objUW.hidObjGIUWS004.GIUWPolDist.length; a++){
						if (objUW.hidObjGIUWS004.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUWS004.GIUWPolDist[a].recordStatus != -1){
							supplyDist(objUW.hidObjGIUWS004.GIUWPolDist[a]);
						}
					}
				}, 
				clearForm);
	});

	function supplyGroupDistPerRow(row){
		try{
			//getDefaults();
			var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].distNo == distNo && objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
							supplyGroupDist(objArray[a].giuwWpolicyds[b]);
						}
					}
				}
			}
		}catch(e){
			showErrorMessage("supplyGroupDistPerRow", e);
		}	
	}	
	
	//create observe on Group list
	$$("div#distGroupListingDiv div[name=rowGroupDist]").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distGroupListingDiv', 'rowGroupDist', function(){supplyGroupDistPerRow(row);}, function(){supplyGroupDist(row);});
	});

	function supplyShareDistPerRow(row){
		try{
			getShareDefaults(false);
			enableButton("btnAddShare");
			var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var lineCd = row.readAttribute("lineCd");
			var shareCd = row.readAttribute("shareCd");
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].distNo == distNo && objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo == distNo 
										&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo == distSeqNo 
										&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd == lineCd 
										&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd == shareCd 
										&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									supplyShareDist(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c]);
								}	
							}	
						}
					}
				}
			}
		}catch(e){
			showErrorMessage("supplyShareDistPerRow", e);
		}
	}	
	
	//create observe on Share list
	$$("div#distShareListingDiv div[name=rowShareDist]").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distShareListingDiv', 'rowShareDist', function(){supplyShareDistPerRow(row);}, clearShare);
	});

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
				for(var b=0; b<obj.giuwWpolicyds.length; b++){
					if (obj.giuwWpolicyds[b].giuwWpolicydsDtl.length > 0){
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
						disableButton("btnPostDist"); // andrew - 07.23.2012 - btnPostDist will be disabled when Distribution is posted to RI
					}	
					
					if (nvl(obj.varShare,null) == "Y"){
						$("btnPostDist").value = "Post Distribution to RI";
						//enableButton("btnPostDist");  // andrew - 07.23.2012 - btnPostDist will be disabled when Distribution is posted to RI
					}else {
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
					for(var b=0; b<obj.giuwWpolicyds.length; b++){
						if (obj.giuwWpolicyds[b].distFlag == "2" && obj.giuwWpolicyds[b].recordStatus != -1){
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
	
	function supplyDist(obj){
		try{
			supplyGroupDist(null);
			objUW.hidObjGIUWS004.selectedGIUWPolDist 	= obj==null?{}:obj;
			$("txtC080DistNo").value 					= nvl(obj==null?null:obj.distNo,'') == '' ? null :formatNumberDigits(obj.distNo,8);
			$("txtC080DistFlag").value 					= nvl(obj==null?null:obj.distFlag,'');
			$("txtC080MeanDistFlag").value 				= nvl(obj==null?null:obj.meanDistFlag,'');
			$("txtC080MultiBookingMm").value 			= nvl(obj==null?null:obj.multiBookingMm,'');
			$("txtC080MultiBookingYy").value 			= nvl(obj==null?null:obj.multiBookingYy,'');
			buttonLabel(obj);
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",nvl(obj==null?null:obj.distNo,''));
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,''));
		}catch(e){
			showErrorMessage("supplyDist", e);
		}
	}	

	function supplyGroupDist(obj){
		try{
			objUW.hidObjGIUWS004.selectedGIUWWpolicyds	= obj==null?{}:obj;
			$("txtDistSeqNo").value 					= nvl(obj==null?null:obj.distSeqNo,'') == '' ? null :formatNumberDigits(obj.distSeqNo,5);
			$("txtTsiAmt").value 						= nvl(obj==null?null:obj.tsiAmt,'') == '' ? null :formatCurrency(obj.tsiAmt);
			$("txtPremAmt").value 						= nvl(obj==null?null:obj.premAmt,'') == '' ? null :formatCurrency(obj.premAmt);
			$("lblCurrency").innerHTML					= unescapeHTML2(nvl(obj==null?'&nbsp;':obj.currencyDesc,'&nbsp;'));
			supplyShareDist(null);
			getShareDefaults(true);
			if (obj == null){
				disableButton("btnAddShare");
				disableButton("btnTreaty");
				disableButton("btnShare");
				$("txtDistSpct").readOnly = true;
				$("txtDistTsi").readOnly = true;
			}else{
				enableButton("btnAddShare");
				enableButton("btnTreaty");
				enableButton("btnShare");
				$("txtDistSpct").readOnly = false;
				$("txtDistTsi").readOnly = false;
			}	
			
			disableButton("btnViewDist");
			if (obj != null){
				//if($F("globalParType") == "E"){	/*commented out by Gzelle 06232014 - replaced with code below*/
				if(('${isPack}' == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E"){
					enableButton("btnViewDist"); 
				}
			}
			computeTotalAmount($("txtDistSeqNo").value);
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,''));
		}catch(e){
			showErrorMessage("supplyGroupDist", e);
		}
	}	

	function supplyShareDist(obj){
		try{
			objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl	= obj==null?{}:obj;
			$("txtDspTrtyName").value						= unescapeHTML2(nvl(obj==null?'':obj.dspTrtyName,''));
			$("txtDistSpct").value							= nvl(obj==null?null:obj.distSpct,'') == '' ? null /*:acceptedRound*/:formatToNthDecimal(obj.distSpct,9/*14*/);//changed round off from 14 to 9 edgar 05/13/2014
			$("txtDistTsi").value							= nvl(obj==null?null:obj.distTsi,'') == '' ? null :formatCurrency(obj.distTsi);
			$("txtDistPrem").value							= nvl(obj==null?null:obj.distPrem,'') == '' ? null :formatCurrency(obj.distPrem);
			if (obj != null){
				//if (obj.recordStatus == 0){
				//	enableButton("btnTreaty"); 
				//	enableButton("btnShare");
				//} //commented out replaced with codes below to disable buttons when a share is selected from the list edgar 09/17/2014
				disableButton("btnTreaty");//edgar 09/17/2014
				disableButton("btnShare");//edgar 09/17/2014
			}	
			computeTotalAmount($("txtDistSeqNo").value);
		}catch(e){
			showErrorMessage("supplyShareDist", e);
		}
	}	

	function clearForm(){
		try{
			supplyDist(null);
			supplyGroupDist(null);
			deselectRows("distListingDiv", "rowPrelimDist");
			deselectRows("distGroupListingDiv", "rowGroupDist");
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",Number($("txtC080DistNo").value));
			checkTableItemInfo("distListingTableDiv","distListingDiv","rowPrelimDist");
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}	

	function clearShare(){
		try{
			supplyShareDist(null);
			getShareDefaults(true);
			deselectRows("distShareListingDiv", "rowShareDist");
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtC080DistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
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

	//create new Object for Dist Share to be added on Object Array
	function setShareObject() {
		try {
			var objGroup = objUW.hidObjGIUWS004.selectedGIUWWpolicyds;
			var obj = objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl;
			var newObj = new Object();
			newObj.recordStatus			= obj == null ? null :nvl(obj.recordStatus, null);
			newObj.distNo				= obj == null ? objGroup.distNo :nvl(obj.distNo, objGroup.distNo);
			newObj.distSeqNo 			= obj == null ? objGroup.distSeqNo :nvl(obj.distSeqNo, objGroup.distSeqNo);
			newObj.lineCd 				= obj == null ? "" :nvl(obj.lineCd, "");
			newObj.shareCd 				= obj == null ? "" :nvl(obj.shareCd, "");
			newObj.distSpct				= escapeHTML2($F("txtDistSpct"));
			newObj.distTsi				= escapeHTML2(unformatNumber($F("txtDistTsi")));
			newObj.distPrem				= escapeHTML2(unformatNumber($F("txtDistPrem")));
			newObj.annDistSpct			= escapeHTML2($F("txtDistSpct")); //obj == null ? "" :nvl(obj.annDistSpct, "");
			newObj.annDistTsi			= (nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100;	//obj == null ? "" :nvl(obj.annDistTsi, "");
			newObj.distGrp				= obj == null ? "1" :"1"; //nvl(obj.distGrp, ""); //pre-insert block :C1407.dist_grp := 1;
			newObj.distSpct1			= obj == null ? "" :nvl(obj.distSpct1, "");
			newObj.arcExtData			= obj == null ? "" :nvl(obj.arcExtData, "");
			newObj.dspTrtyCd			= obj == null ? "" :nvl(obj.dspTrtyCd, "");
			newObj.dspTrtyName 			= escapeHTML2($F("txtDspTrtyName"));
			newObj.dspTrtySw			= obj == null ? "" :nvl(obj.dspTrtySw, "");
			return newObj; 
		}catch(e){
			showErrorMessage("setShareObject", e);
		}
	}
	
	//when Add/Update button click
	$("btnAddShare").observe("click", function(){
		addShare();
	});
	
	//function add record
	function addShare(){
		try{
			if ($F("txtC080DistNo") == ""){
				customShowMessageBox("Distribution no. is required.", "E", "txtC080DistNo");
				return false;
			}
			if ($F("txtDistSeqNo") == ""){
				customShowMessageBox("Group no. is required.", "E", "txtDistSeqNo");
				return false;
			}	
			if ($F("txtDspTrtyName") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDspTrtyName"); //"Share is required."
				return false;
			}
			if ($F("txtDistSpct") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDistSpct"); //"% Share is required."
				return false;
			}
			if ($F("txtDistTsi") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDistTsi"); //"Sum insured is required."
				return false;
			}
			if ($F("txtDistPrem") == ""){
				customShowMessageBox("Premium is required.", "E", "txtDistPrem");
				return false;
			}
			if (parseFloat($F("txtDistSpct")) > 100){
				customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct");
				return false;
			}	
			if (parseFloat($F("txtDistSpct")) <= 0){
				customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct");
				return false;
			}
			if (unformatCurrency("txtTsiAmt") != 0){
				$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtTsiAmt"),0));
				if (acceptedRound(unformatCurrency("txtDistTsi"), 2) == 0){
					customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
					return false;
				}	
			}
			if (Math.abs($F("txtDistTsi")) > Math.abs($F("txtTsiAmt"))){
				customShowMessageBox("Sum insured cannot exceed TSI.", "E", "txtDistTsi");
				return false;
			}
			if (unformatCurrency("txtTsiAmt") > 0){
				if (unformatCurrency("txtDistTsi") <= 0){
					customShowMessageBox("Sum insured must be greater than zero.", "E", "txtDistTsi");
					return false;
				}	
			}else if (unformatCurrency("txtTsiAmt") < 0){
				if (unformatCurrency("txtDistTsi") >= 0){
					customShowMessageBox("Sum insured must be less than zero.", "E", "txtDistTsi");
					return false;
				}	
			}
		
			var exists = false;
			if (!exists){
				var newObj  = setShareObject();
				var content = prepareList3(newObj);
				if ($F("btnAddShare") == "Update" || $("rowShareDist"+newObj.distNo+""+newObj.distSeqNo+""+newObj.lineCd+""+newObj.shareCd)){
					//on UPDATE records
					var id = nvl(getSelectedRowIdInTable_noSubstring("distShareListingDiv", "rowShareDist"), "rowShareDist"+newObj.distNo+""+newObj.distSeqNo+""+newObj.lineCd+""+newObj.shareCd);
					var distNo = nvl(getSelectedRowAttrValue("rowShareDist", "distNo"), newObj.distNo);
					var distSeqNo = nvl(getSelectedRowAttrValue("rowShareDist", "distSeqNo"), newObj.distSeqNo);
					var lineCd = nvl(getSelectedRowAttrValue("rowShareDist", "lineCd"), newObj.lineCd);
					var shareCd = nvl(getSelectedRowAttrValue("rowShareDist", "shareCd"), newObj.shareCd);
					$(id).update(content);
					$(id).setAttribute("name", "rowShareDist");
					$(id).setAttribute("distNo", newObj.distNo);
					$(id).setAttribute("distSeqNo", newObj.distSeqNo);
					$(id).setAttribute("lineCd", newObj.lineCd);
					$(id).setAttribute("shareCd", newObj.shareCd);	
					$(id).setAttribute("id", "rowShareDist"+newObj.distNo+""+newObj.distSeqNo+""+newObj.lineCd+""+newObj.shareCd);

					var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
								if (objArray[a].giuwWpolicyds[b].distNo == distNo && objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
									//Share
									for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
										if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo == distNo 
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo == distSeqNo 
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd == lineCd 
												&& (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd == shareCd || objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd == newObj.shareCd)
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
											newObj.recordStatus = newObj.recordStatus == 0 ? 0 :1;
											objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c] = newObj;
											objArray[a].giuwWpolicyds[b].recordStatus = 1;
											changeTag=1;
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
											objArray[a].autoDist = "N"; //set autoDist to N to unpost distribution when posted - christian
										}
									}
								}
							}
						}
					}
				}else{
					//on ADD records
					var tableContainer = $("distShareListingDiv");
					var newDiv = new Element("div");
					var distNo = newObj.distNo;
					var distSeqNo = newObj.distSeqNo;
					var lineCd = newObj.lineCd;
					var shareCd = newObj.shareCd;
					//newObj.divCtrId = generateDivCtrId(objArray[a].giuwWpolicyds[b]);
					var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
								if (objArray[a].giuwWpolicyds[b].distNo == distNo && objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
									//Share
									addNewJSONObject(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl, newObj);
									objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
									objArray[a].autoDist = "N"; //set autoDist to N to unpost distribution when posted - christian
								}
							}
						}
					}
					
					newDiv.setAttribute("id", "rowShareDist"+distNo+""+distSeqNo+""+lineCd+""+shareCd);
					newDiv.setAttribute("name", "rowShareDist");
					newDiv.setAttribute("distNo", distNo);
					newDiv.setAttribute("distSeqNo", distSeqNo);
					newDiv.setAttribute("lineCd",lineCd);
					newDiv.setAttribute("shareCd", shareCd);
					newDiv.addClassName("tableRow");
					newDiv.update(content);
					tableContainer.insert({bottom : newDiv});

					loadRowMouseOverMouseOutObserver(newDiv);
					setClickObserverPerRow(newDiv, 'distShareListingDiv', 'rowShareDist', function(){supplyShareDistPerRow(newDiv);}, clearShare);
					changeTag=1;
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function(){
						checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtC080DistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
						}
					});
				}	
				clearShare();
			}	
		}catch(e){
			showErrorMessage("addShare", e);
		}		
	}		
	
	//when DELETE Share button click
	$("btnDeleteShare").observe("click",function(){
		deleteShare();
	});

	//function delete record
	function deleteShare(){
		try{
			if ($F("txtC080DistNo") == ""){
				customShowMessageBox("Distribution no. is required.", "E", "txtC080DistNo");
				return false;
			}
			if ($F("txtDistSeqNo") == ""){
				customShowMessageBox("Group no. is required.", "E", "txtDistSeqNo");
				return false;
			}
			$$("div#distShareListingDiv div[name='rowShareDist']").each(function(row){
				if (row.hasClassName("selectedRow")){
					var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
					var distNo = row.readAttribute("distNo");
					var distSeqNo = row.readAttribute("distSeqNo");
					var lineCd = row.readAttribute("lineCd");
					var shareCd = row.readAttribute("shareCd");
					var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
								if (objArray[a].giuwWpolicyds[b].distNo == distNo && objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
									//Share
									for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
										if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo == distNo 
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo == distSeqNo 
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd == lineCd 
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd == shareCd 
												&& objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
											var delObj = objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c];
											if(delObj.recordStatus != 0 || objArray[a].recordStatus == 0){
												delObj.recordStatus = -1;
											}else if(delObj.recordStatus == 0){
												objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.splice(c, 1); //to remove the newly added record that not exist in database
											} 
											changeTag=1;
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
											Effect.Fade(row,{
												duration: .5,
												afterFinish: function(){
													row.remove();
													clearShare();
													checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtC080DistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
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

	$("btnShare").observe("click", function(){
		getListing();
		var objArray = objUW.hidObjGIUWS004.distListing.distShareListingJSON;
		startLOV("GIUWS004-Share", "Share", objArray, 540);
	});	

	$("btnTreaty").observe("click", function(){
		getListing();
		var objArray = objUW.hidObjGIUWS004.distListing.distTreatyListingJSON;
		startLOV("GIUWS004-Treaty", "Treaty", objArray, 540);	
	});

	function startLOV(id, title, objArray, width){
		try{
			var copyObj = objArray.clone();	
			var copyObj2 = objArray.clone();	
			var selGrpObjArray = objUW.hidObjGIUWS004.selectedGIUWWpolicyds.giuwWpolicydsDtl.clone();
			selGrpObjArray = selGrpObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
			var share = objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl;
			for(var a=0; a<selGrpObjArray.length; a++){
				for(var b=0; b<copyObj.length; b++){
					if (selGrpObjArray[a].shareCd == copyObj[b].shareCd){
						copyObj.splice(b,1);
						b--;
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
					objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");;
					objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
					objUW.hidObjGIUWS004.selectedGIUWWpolicydsDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");;
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
	
	function getListing(){
		try{
			var lineCd = ('${isPack}' == "Y" ? tempLineCd :  $("globalLineCd").value); // added by: Nica 09.10.2012 - to consider package line
			
			if (objUW.hidObjGIUWS004.globalParId == objUW.hidObjGIUWS004.selectedGIUWPolDist.parId && 
					objUW.hidObjGIUWS004.nbtLineCd == objUW.hidObjGIUWS004.selectedGIUWWpolicyds.nbtLineCd && 
					objUW.hidObjGIUWS004.lineCd == lineCd/*$F("globalLineCd")*/){ return;}
			objUW.hidObjGIUWS004.globalParId = objUW.hidObjGIUWS004.selectedGIUWPolDist.parId;
			objUW.hidObjGIUWS004.nbtLineCd = objUW.hidObjGIUWS004.selectedGIUWWpolicyds.nbtLineCd;
			objUW.hidObjGIUWS004.lineCd = lineCd; //$F("globalLineCd");
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "getDistListing",
					globalParId: objUW.hidObjGIUWS004.selectedGIUWPolDist.parId,
					nbtLineCd: objUW.hidObjGIUWS004.selectedGIUWWpolicyds.nbtLineCd,
					lineCd: lineCd //$F("globalLineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					objUW.hidObjGIUWS004.distListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				}	
			});	
		}catch(e){
			showErrorMessage("getListing", e);
		}
	}	

	/* % Share */ 
	initPreTextOnField("txtDistSpct");
	$("txtDistSpct").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012
		if ($F("txtDistSeqNo") == "" || $F("txtDistSpct") == "") return;
		if (!checkIfValueChanged("txtDistSpct")) return;
		
		/*  Check that %Share is not greater than 100 */ 
		if (parseFloat($F("txtDistSpct")) > 100){
			$("txtDistSpct").value = getPreTextValue("txtDistSpct");
			customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct");
			return false;
		}	
		if (parseFloat($F("txtDistSpct")) <= 0){
			$("txtDistSpct").value = getPreTextValue("txtDistSpct");
			customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct");
			return false;
		}
 
		/* Compute DIST_TSI if the TSI amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtTsiAmt") != 0){
			$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtTsiAmt"),0));
			if (acceptedRound(unformatCurrency("txtDistTsi"), 2) == 0){
				customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
				return false;
			}	
		}else{
			$("txtDistTsi").value = acceptedRound(0, 2); // changed 14 to 2 decimal places - christian
		}
		
		/* Compute dist_prem  */
		$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));		
	});	

	/* Sum Insured */ 
	initPreTextOnField("txtDistTsi");
	$("txtDistTsi").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012
		if ($F("txtDistSeqNo") == "" || $F("txtDistTsi") == "") return;
		if (!checkIfValueChanged("txtDistTsi")) return;
		
		/* Check that dist_tsi does is not greater than tsi_amt  */
		if (Math.abs(unformatCurrency("txtDistTsi")) > Math.abs(unformatCurrency("txtTsiAmt"))){
			customShowMessageBox("Sum insured cannot exceed TSI.", "E", "txtDistTsi");
			return false;
		}	

		/* Compute dist_spct if the TSI amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtTsiAmt") > 0){
			if (unformatCurrency("txtDistTsi") <= 0){
				customShowMessageBox("Sum insured must be greater than zero.", "E", "txtDistTsi");
				return false;
			}	
			//$("txtDistSpct").value = acceptedRound(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 ,14);//commented out changed rounding off to 9 edgar 05/13/2014
			$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 ,9);
		}else if (unformatCurrency("txtTsiAmt") < 0){
			if (unformatCurrency("txtDistTsi") >= 0){
				customShowMessageBox("Sum insured must be less than zero.", "E", "txtDistTsi");
				return false;
			}	
	      //$("txtDistSpct").value = acceptedRound(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 ,14);//commented out changed rounding off to 9 edgar 05/13/2014
	      $("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 ,9);
		}else{
			$("txtDistTsi").value = formatCurrency("0");
		}	

		/* Compute dist_prem  */
		$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));				   		   
	});

	function checkC1407TsiPremium(proc){
		try{
			var parType	= ('${isPack}' == "Y" ? $F("parTypeFlag") :  $F("globalParType"));
			var message = null;	//modified by Gzelle 06252014 -  should not allow 0 % share for Policy and Endt.
			if(parType == "E"){ // added by andrew - 09.06.2012 - should allow 0 tsi and prem
				message = " cannot have a share percentage equal to zero.";
			}else {
				message = " cannot have both its TSI and premium equal to zero.";
			}
			var ok = true;
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								//if (nvl(proc,"") != "E"/*nvl(proc,"") == "P"*/ || nvl(objArray[a].giuwWpolicyds[b].recordStatus,0) == 1){ //alert only if there is any changes in Shares
									//if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){//commented out replace with codes below edgar 09/16/2014
									if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){	//added considers dist_spct instead of TSi and Prem amounts edgar 09/16/2014
										var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowPrelimDist");
										dist == "rowPrelimDist"+a ? null :fireEvent($("rowPrelimDist"+a), "click");
										dist == "rowPrelimDist"+a ? null :$("rowPrelimDist"+a).scrollIntoView();
										//disableButton("btnPostDist");
										showWaitingMessageBox("A share in group no. "+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+message, "E",
											function(){
												var grp = getSelectedRowIdInTable_noSubstring("distGroupListingDiv", "rowGroupDist");
												grp == "rowGroupDist"+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo? null :fireEvent($("rowGroupDist"+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo), "click");
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
			showErrorMessage("checkC1407TsiPremium", e);
		}
	}	

	function computeTotalAmount(distSeqNo){
		try{
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var distSeqNo = nvl(distSeqNo,'')==''?'':Number(distSeqNo);
			var ctr = 0;
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			var currGrp = {};
			
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1 && objArray[a].distNo == Number($F("txtC080DistNo"))){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							currGrp = objArray[a].giuwWpolicyds[b];
							currGrp.currDistNoIndex = a;
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									ctr++;
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0));
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0));
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0));
								}
							}
						}	
					}
				}
			}
			/*Added by Gzelle 06112014 - roundNumber*/
			sumDistSpct = roundNumber(sumDistSpct, 9);
			objUW.hidObjGIUWS004.sumDistSpct = sumDistSpct;
			objUW.hidObjGIUWS004.sumDistTsi = sumDistTsi;
			objUW.hidObjGIUWS004.sumDistPrem = sumDistPrem;
			if (parseInt(ctr) <= 5){
				$("distShareTotalAmtMainDiv").setStyle("padding-right:2px");
			}else{
				$("distShareTotalAmtMainDiv").setStyle("padding-right:19px");
			}	
			if (parseInt(ctr) > 0){
				$("distShareTotalAmtMainDiv").show();
			}else{
				$("distShareTotalAmtMainDiv").hide();
			}
			$("distShareTotalAmtMainDiv").down("label",1).update(/*acceptedRound*/formatToNthDecimal(sumDistSpct,9/*14*/).truncate(30, "..."));//commented out changed rounding off to 9 edgar 05/13/2014
			$("distShareTotalAmtMainDiv").down("label",2).update(formatCurrency(sumDistTsi).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",3).update(formatCurrency(sumDistPrem).truncate(30, "..."));
		}catch(e){
			showErrorMessage("computeTotalAmount", e);
		}
	}	
	
	function procedurePreCommit(){
		try{
			var ok = true;
			var ctr = 0;
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var tempDistTsi = 0;//added for handling share with TSI and Premium having odd decimal values edgar 05/14/2014
			var tempDistPrem = 0;//added for handling share with TSI and Premium having odd decimal values edgar 05/14/2014
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									ctr++;
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0));
									// modified to handle dist share with odd decimal value on Sum Insured and Premium edgar 05/14/2014
									tempDistTsi = (parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0)) / 100) * nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0);
									sumDistTsi = parseFloat(sumDistTsi) + tempDistTsi;//parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0));
									tempDistPrem = (parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1,0)) / 100) * nvl(objArray[a].giuwWpolicyds[b].premiAmt,0);
									sumDistPrem = parseFloat(sumDistPrem) + tempDistPrem;//parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0));
								}
							}
							function err(msg){
								objUW.hidObjGIUWS004.preCommit = "N";
								var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowPrelimDist");
								dist == "rowPrelimDist"+nvl(a,'---') ? null : ($("rowPrelimDist"+nvl(a,'---')) ? fireEvent($("rowPrelimDist"+nvl(a,'---')), "click") :null);
								dist == "rowPrelimDist"+nvl(a,'---') ? null : ($("rowPrelimDist"+nvl(a,'---')) ? $("rowPrelimDist"+nvl(a,'---')).scrollIntoView() :null);
								//disableButton("btnPostDist");
								showWaitingMessageBox(msg, "E", 
									function(){
										var grp = getSelectedRowIdInTable_noSubstring("distGroupListingDiv", "rowGroupDist");
										grp == "rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')? null :($("rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')? fireEvent($("rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')), "click") :null));
									}); 
								ok = false;
							}	
							if (ctr == 0){
								err("Distribution share cannot be null.");
								return false;
							}
							//changed && to || - to handle dist with allied peril with 0 TSI - christian
							//added condition ctr == 1 to promt the error message only if the sharecd is 1 and recompute share if more than
							
							//Apollo Cruz - removed ' && ctr == 1'
							//As per Ma'am Nica, validation should be done regardless of how many dist. share
							//changed rounding off from 14 to 9 edgar 05/13/2014
							//changed to roundNumber by Gzelle 06112014
							if ((/*acceptedRound*//*formatToNthDecimal*/roundNumber(sumDistSpct, 9/*14*/) != 100 || acceptedRound(sumDistTsi, 2) != acceptedRound(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2))/* && ctr == 1*/){
								err("Total % Share should be equal to 100.");
								return false;
							}
							
							sumDistSpct = 0;
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
	
	function checkDistFlag(){
		try{
			var ok = true;
			var copyObj = objUW.hidObjGIUWS004.GIUWPolDist.clone();	
			for(var a=0; a<copyObj.length; a++){
				if (copyObj[a].recordStatus != -1 && copyObj[a].distNo == Number($F("txtC080DistNo"))){
					//Group
					var selGrpObjArray = copyObj[a].giuwWpolicyds.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
					for(var b=0; b<selGrpObjArray.length; b++){
						//Share
						var selShrObjArray = selGrpObjArray[b].giuwWpolicydsDtl.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
						var shareCount = 0;
						var distfrpsCount = 0;
						shareCount = shareCount + selShrObjArray.length;	
						new Ajax.Request(contextPath+"/GIUWPolDistController",{
							parameters:{
								action: "checkDistFlag",
								distNo: selGrpObjArray[b].distNo,
								distSeqNo: selGrpObjArray[b].distSeqNo
							},
							asynchronous: false,
							evalScripts: true,
							onComplete: function(response){
								if (checkErrorOnResponse(response)){
									distfrpsCount = distfrpsCount + Number(response.responseText);
								}
							}	
						});	
						if (shareCount == 0 && distfrpsCount != 0 && $F("txtC080DistFlag") == "2"){
							customShowMessageBox("Distribution Flag = 2 and GIUW_WPOLICYDS_DTL has no record in group no. "+selGrpObjArray[b].distSeqNo+".", "E", "btnCreateItems");
							ok = false;
							$break;
							return false;
						}
					}
				}	
			}	
			return ok;
		}catch(e){
			showErrorMessage("checkDistFlag", e);
		}
	}	
	$("btnCreateItems").observe("click", function(){
		//Added by Gzelle 06232014
		if ($("btnCreateItems").value == "Recreate Items"){
			vProcess = "R";
			if (!checkPostedBinder()) return false; 
		}
		
		if (!checkDistFlag()) return false;
		
		var vCopyDist = "N";
		var vPolFlag = "";
		if ((nvl('${isPack}',"N") == "Y" ? $F("globalPackPolFlag") :  $F("globalPolFlag")) =="2"){ // never read ung variable so not sure para saan pero nag add nlng ako pang pack - irwin
			vCopyDist = "Y";
			vPolFlag = "2";
		}	
		
		if((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E"){// same here - irwin
			vCopyDist = "Y";
		}
		
		if (!compareGipiItemItmperil()) return false;
		if ($("btnCreateItems").value == "Recreate Items"){
			showConfirmBox("Recreate Items", "All pre-existing data associated with this distribution record will be deleted. Are you sure you want to continue?", 
					"Yes", "No", onOkFunc, "");
		}else{
			onOkFunc();
		}	
		
	});
	
	// for pack par
	//var tempLineCd;
	//var tempSublineCd;
	//var tempIssCd;
	//var tempPackPolFlag;
	//var tempPolFlag; moved by: Nica 09.10.2012
	
	function onOkFunc(){
		try{
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			var index = 0;
			var distNo = Number($F("txtC080DistNo"));
			
			if('${isPack}' == "Y"){
				for ( var p = 0; p < objGIPIParList.length; p++) {
					if (objGIPIParList[p].parId == $F("initialParId")){
						tempLineCd = objGIPIParList[p].lineCd;
						tempSublineCd = objGIPIParList[p].sublineCd;
						tempIssCd = objGIPIParList[p].issCd;
						tempPackPolFlag = 	objGIPIParList[p].packPolFlag;
						tempPolFlag = objGIPIParList[p].polFlag;
					}
				}
			}
			
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].distNo == distNo && objArray[a].recordStatus != -1){
					index = a;
					objArray[a].recordStatus = -1;
					var recObj = new Object();
					recObj.distNo = distNo;
					recObj.parId = ('${isPack}' == "Y" ? $("initialParId").value :  $("globalParId").value);
					recObj.lineCd = ('${isPack}' == "Y" ? tempLineCd :  $("globalLineCd").value);
					recObj.sublineCd = ('${isPack}' == "Y" ? tempSublineCd :  $("globalSublineCd").value) ;
					recObj.issCd = ('${isPack}' == "Y" ? tempIssCd :  $("globalIssCd").value) ;
					recObj.packPolFlag =  ('${isPack}' == "Y" ? tempPackPolFlag :  $("globalPackPolFlag").value);
					recObj.polFlag = ('${isPack}' == "Y" ? tempPolFlag :  $("globalPolFlag").value);
					recObj.parType = ('${isPack}' == "Y" ? $F("parTypeFlag") :  $F("globalParType"));
					recObj.process = "R";
					recObj.processId = objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.length;
					//objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.push(recObj);		commented out by Gzelle 06192014
					$("rowPrelimDist"+a).update("");
					$$("div#distGroupListingDiv div[name=rowGroupDist]").each(function(row){
						if (row.readAttribute("distNo") == objArray[a].distNo){
							row.remove();
						}	
					});
					$$("div#distShareListingDiv div[name=rowShareDist]").each(function(row){
						if (row.readAttribute("distNo") == objArray[a].distNo){
							row.remove();
						}	
					});		
					//clearForm();
				}	 
			}
			
			createItems(index, distNo);
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
					action: "createItems",
					distNo: distNo,
					parId: ('${isPack}' == "Y" ? $("initialParId").value :  $("globalParId").value),
					lineCd: ('${isPack}' == "Y" ? tempLineCd :  $("globalLineCd").value),
					sublineCd: ('${isPack}' == "Y" ? tempSublineCd :  $("globalSublineCd").value),
					issCd: ('${isPack}' == "Y" ? tempIssCd :  $("globalIssCd").value),
					packPolFlag: ('${isPack}' == "Y" ? tempPackPolFlag :  $("globalPackPolFlag").value),
					polFlag: ('${isPack}' == "Y" ? tempPolFlag :  $("globalPolFlag").value),
					parType: ('${isPack}' == "Y" ? $F("parTypeFlag") :  $F("globalParType")),
					label: $("btnCreateItems").value
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice(noticeMsg+" Items, please wait...");
				},	
				onComplete: function(response){
					hideNotice("");
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message == ""){
							obj = res.newItems;
							obj.divCtrId = index;
							obj.recordStatus = 0;
							obj.process = "R";
							var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
							objArray[index] = obj;
							//checkAutoDist1(objArray[index]); commented out
							enableButton("btnPostDist"); // enable the button instead	
							$("btnPostDist").value = (nvl(obj.varShare,null) == "Y" ? "Post Distribution to RI" : "Post Distribution to Final");
							obj.autoDist = "N";
							objUW.hidObjGIUWS004.selectedGIUWPolDist = obj;
							var content = prepareList(objArray[index]);
							$("rowPrelimDist"+index).update(content);
							showListPerObj(objArray[index], index);

							//Group
							for(var b=0; b<objArray[index].giuwWpolicyds.length; b++){
								objArray[index].giuwWpolicyds[b].recordStatus = 0;
								if (objArray[index].giuwWpolicyds[b].recordStatus != -1){
									//create observe on Group list
									$$("div#distGroupListingDiv div[name=rowGroupDist]").each(function(row){
										if (row.id == ("rowGroupDist"+objArray[index].distNo+""+objArray[index].giuwWpolicyds[b].distSeqNo)){
											loadRowMouseOverMouseOutObserver(row);
											setClickObserverPerRow(row, 'distGroupListingDiv', 'rowGroupDist', function(){supplyGroupDistPerRow(row);}, function(){supplyGroupDist(null);});
										}
									});
	
									//Share
									for(var c=0; c<objArray[index].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
										objArray[index].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus = 0;
										if (objArray[index].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
											//create observe on Share list
											$$("div#distShareListingDiv div[name=rowShareDist]").each(function(row){
												if (row.id == ("rowShareDist"+objArray[index].distNo+""+objArray[index].giuwWpolicyds[b].distSeqNo+""+objArray[index].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd+""+objArray[index].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd)){
													loadRowMouseOverMouseOutObserver(row);
													setClickObserverPerRow(row, 'distShareListingDiv', 'rowShareDist', function(){supplyShareDistPerRow(row);}, clearShare);
												}
											});
										}
									}
								}
								//buttonLabel(objArray[index]);//cxc commented out
								supplyGroupDist(null);
								deselectRows("distGroupListingDiv", "rowGroupDist");
								checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",Number($("txtC080DistNo").value));
								clearShare();
								disableButton("btnTreaty");
								disableButton("btnShare");
								//changeTag=1; 	commented out by Gzelle 06192014
								showMessageBox(noticeMsg+" Items complete.", "S");
							}	
						}else{
							ok = false;
							customShowMessageBox(res.message, "E", "btnCreateItems");
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
	
	var postResult = {};
	var postResult2 = {};
	var netOverride = "N";
	var treatyOverride = "N";
	var isOkPressed = "";
	function checkOverrideNetTreaty(){
		try{
			commonOverrideOkFunc = function(){
				isOkPressed = "Y";
				changeTag=1;
				netOverride = postResult.paramFunction == "RO" ? "Y" :netOverride;
				treatyOverride = postResult.paramFunction == "TO" ? "Y" :treatyOverride;
				var id = getSelectedRowIdInTable("distListingDiv", "rowPrelimDist");
				objUW.hidObjGIUWS004.GIUWPolDist[id].varShare = postResult2.newItems.varShare;
				objUW.hidObjGIUWS004.GIUWPolDist[id].postFlag = postResult2.newItems.postFlag;
				objUW.hidObjGIUWS004.GIUWPolDist[id].distFlag = postResult2.newItems.distFlag;
				objUW.hidObjGIUWS004.GIUWPolDist[id].autoDist = postResult2.newItems.autoDist;
				objUW.hidObjGIUWS004.GIUWPolDist[id].meanDistFlag = postResult2.newItems.meanDistFlag;
				/*objUW.hidObjGIUWS004.GIUWPolDist[id].varShare = postResult.newItems.varShare;
				objUW.hidObjGIUWS004.GIUWPolDist[id].postFlag = postResult.newItems.postFlag;
				objUW.hidObjGIUWS004.GIUWPolDist[id].distFlag = postResult.newItems.distFlag;
				objUW.hidObjGIUWS004.GIUWPolDist[id].meanDistFlag = postResult.newItems.meanDistFlag;		commented out by Gzelle 06132014*/
				objUW.hidObjGIUWS004.GIUWPolDist[id].posted = "Y";
				objUW.hidObjGIUWS004.GIUWPolDist[id].recordStatus = 1;
				var content = prepareList(objUW.hidObjGIUWS004.GIUWPolDist[id]);
				$("rowPrelimDist"+id).update(content);
				$("txtC080DistFlag").value = postResult2.distFlag;
				$("txtC080MeanDistFlag").value = postResult2.meanDistFlag;
				/*$("txtC080DistFlag").value = postResult.distFlag;
				$("txtC080MeanDistFlag").value = postResult.meanDistFlag;		commented out by Gzelle 06132014*/
				//showMessageBox("Post Distribution Complete.", "S"); //commented out edgar 05/13/2014
				for(var a=0; a<objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds.length; a++){
					var obj = new Object();
					obj.parId = objUW.hidObjGIUWS004.GIUWPolDist[id].parId;
					obj.distNo = objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds[a].distNo;
					obj.distSeqNo = objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds[a].distSeqNo;
					obj.overrideSwitch = overrideSwitch;
					obj.process = "P";
					obj.processId = objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.length;
					objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.push(obj);
					if (a==(objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds.length-1)){
						if (nvl(postResult.donePosting,"N") == "Y"){
							checkAutoDist1(objUW.hidObjGIUWS004.GIUWPolDist[id]);
							buttonLabel(objUW.hidObjGIUWS004.GIUWPolDist[id]);
							postResult.donePosting = "N";
							isSavePressed = false;	//added by Gzelle 06102014
							savePrelimOneRiskDist("P");
							deselectRows("distListingDiv", "rowPrelimDist");
							//$("rowPrelimDist"+id) ? fireEvent($("rowPrelimDist"+id), "click") :null; //commented out - christian 
						}	
					}	
				}
				
			};
			commonOverrideNotOkFunc = function(){
				showWaitingMessageBox($("overideUserName").value+" does not have an overriding function for this module.", "E", 
						clearOverride);
			};
			commonOverrideCancelFunc = function(){
				overrideSwitch = "N";
			};
			function override(funcCode){
				try{
					/*objAC.funcCode = postResult.paramFunction;
					objACGlobal.calledForm = postResult.moduleId;
					getUserInfo();
					var title = postResult.netOverride != null ? postResult.netOverride :(postResult.treatyOverride != null ? postResult.treatyOverride :"Override");
					$("overlayTitle").innerHTML = title;		commented out by Gzelle 06132014*/
					if (funcCode == "RO"){
						objAC.funcCode = funcCode;
						objACGlobal.calledForm = postResult.moduleId;
						showGenericOverride(
								"GIUWS004",
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
																if (postResult.overrideMsg != null && postResult.treatyOverride == "Treaty Retention Override"){
																	showConfirmBox("Confirmation", postResult.overrideMsg, 
																			"Override", "Cancel", 	
																			function(){showGenericOverride(
																					"GIUWS004",
																					"TO",
																					function(ovr, userId, result){
																						if(result == "FALSE"){
																							showConfirmBox("Confirmation", "User "+userId+" is not allowed to override.", 
																									"Yes", "No","","");
																							return false;
																						} else if(result == 'TRUE') {	
																							ovr.close();
																							delete ovr;
																							isSavePressed = false;
																							isOkPressed = "N";
																							postDistGiuws004Final();
																						}								
																					},
																					function(){
																						return false;
																					},"Treaty Retention Override");}, "");
																}else {
																	isSavePressed = false;
																	isOkPressed = "N";
																	postDistGiuws004Final();
																}
																}, function() {
																	refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
																});	
										}else{
											isSavePressed = false;
											isOkPressed = "N";
											postDistGiuws004Final();
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
								"GIUWS004",
								"TO",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showConfirmBox("Confirmation", "User "+userId+" is not allowed to override.", 
												"Yes", "No","","");
										return false;
									} else if(result == 'TRUE') {	
										ovr.close();
										delete ovr;
										isOkPressed = "N";
										postDistGiuws004Final();
									}								
								},
								function(){
									return false;
								},"Treaty Retention Override");
					}
				}catch (e) {
					showErrorMessage("checkOverrideNetTreaty - override", e);
				}
			}	
			if (postResult.overrideMsg != null && ((netOverride == "N" && postResult.paramFunction == "RO") || (treatyOverride == "N" && postResult.paramFunction == "TO"))){
				overrideSwitch = "Y";
				/*showConfirmBox("Confirmation", postResult.overrideMsg, 
						"Override", "Cancel", override, commonOverrideCancelFunc);	commented out by Gzelle 06132014*/
				if (netTreaty == "NET"){
					showConfirmBox("Confirmation", postResult.overrideMsg, 
							"Override", "Cancel", 
							function(){
										override("RO");
									  }, "");
				}else if (netTreaty == "TREATY"){
					if (postResult.treatyMsg != null){	//modified by Gzelle 06162014
						showConfirmBox("Confirmation", postResult.treatyMsg, 
								"Yes", "No",
								function(){
											showConfirmBox("Confirmation", postResult.overrideMsg, 
													"Override", "Cancel", 
													function(){
																override("TO");
															  }, "");
										   }, function() {
											   refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
										});
					}
				}
			}else{
				if (postResult.treatyMsg != null){
					showConfirmBox("Confirmation", postResult.treatyMsg, 
							"Yes", "No",
							function(){
										postDistGiuws004Final();
										commonOverrideOkFunc();
					}, function() {
						refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
					});
				}else{
					overrideSwitch = "N";
					postDistGiuws004Final();
					commonOverrideOkFunc();
				}
			}	
			showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS, function (){//commented out showMessageBox("Post Distribution Complete.", "S") replaced with this edgar 05/13/2014
				isSavePressed = true;  // to indicate the [Save] button was not pressed edgar 05/13/2014	modified by Gzelle 06102014 changed to true
			});
		}catch (e) {
			showErrorMessage("checkOverrideNetTreaty", e);
		}
	}	

	var giuwPolDistRows = [];
	var giuwWpolicydsRows = [];
	var giuwWpolicydsDtlSetRows = [];
	var giuwWpolicydsDtlDelRows = [];
	function prepareDistForSaving(){
		try{
			giuwPolDistRows.clear();
			giuwWpolicydsRows.clear();
			giuwWpolicydsDtlSetRows.clear();
			giuwWpolicydsDtlDelRows.clear();

			var objArray = objUW.hidObjGIUWS004.GIUWPolDist.clone();
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
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
					if (objArray[a].giuwWpolicyds[b].recordStatus != null){
						giuwWpolicydsRows.push(objArray[a].giuwWpolicyds[b]);
					}
					//Share
					for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
						if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus == 0 || objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus == 1){
							//for insert
							giuwWpolicydsDtlSetRows.push(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c]);
						}else if(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus == -1){
							//for deletion
							giuwWpolicydsDtlDelRows.push(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c]);
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
			objParameters.giuwPolDistPostedRecreated	= prepareJsonAsParameter(objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated);
			objParameters.giuwPolDistRows 				= prepareJsonAsParameter(giuwPolDistRows);
			objParameters.giuwWpolicydsRows 			= prepareJsonAsParameter(giuwWpolicydsRows);
			objParameters.giuwWpolicydsDtlSetRows 		= prepareJsonAsParameter(giuwWpolicydsDtlSetRows);
			objParameters.giuwWpolicydsDtlDelRows 		= prepareJsonAsParameter(giuwWpolicydsDtlDelRows);
			objParameters.parId							= ('${isPack}' == "Y" ? $("initialParId").value :  $("globalParId").value);
			objParameters.lineCd						= ('${isPack}' == "Y" ? tempLineCd :  $("globalLineCd").value);
			objParameters.sublineCd						= ('${isPack}' == "Y" ? tempSublineCd :  $("globalSublineCd").value);
			objParameters.polFlag						= ('${isPack}' == "Y" ? tempPolFlag :  $("globalPolFlag").value);
			objParameters.parType						= ('${isPack}' == "Y" ? $F("parTypeFlag") :  $F("globalParType"));
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}	
	//started edgar 05/12/2014 for recomputation and adjusting on posting and saving	
	function getTakeUpTerm (){
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
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
	//compares the distribution tables to gipi_witemperil for discrepancies before posting edgar 05/02/2014
	function compareWitemPerilToDs (){
		var ok = true;
		for(var i=0, length=objUW.hidObjGIUWS004.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "compareWitemPerilToDsGIUWS004",
					parId: objUW.hidObjGIUWS004.GIUWPolDist[i].parId,
					distNo : objUW.hidObjGIUWS004.GIUWPolDist[i].distNo
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
						if (comp.vMsgAlert != null){
							showMessageBox(comp.vMsgAlert, imgMessage.ERROR);
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
	function getDistScpt1Val(){
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "getDistScpt1Val",
					distNo : objArray[a].distNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText);
					nullDistSpct1Exist = res.vExist;
				}
			});
		}
	}
	//updates distSpct1 to null and recomputes distPrem if there are records with differet distSpct and distSpct1 edgar 05/13/2014
	function adjustDistPrem(){
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustDistPremGIUWS004",
					distNo : objArray[a].distNo,
					parId : objArray[a].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Recomputing Distribution Premium Amounts, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText);	
					/*showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", 
							function(){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								isSavePressed = false;
							}); commented out by Gzelle 06102014*/ 
					//clearForm();
					clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
					objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
					//refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
				}
			});
		}
	}
	//updates distSpct1 to null if all records have equal distSpct and distSpct1 edgar 05/13/2014
	function updateDistSpct1ToNull(){
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "updateDistSpct1ToNull",
					distNo : objArray[a].distNo,
					parId : objArray[a].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Recomputing Distribution Premium Amounts, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText);	
					//clearForm();
					clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
					objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
					//refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
				}
			});
		}
	}
	//for adjusting distribution tables edgar 05/13/2014
	function adjustAllWTablesGIUWS004(){
		for(var i=0, length=objUW.hidObjGIUWS004.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustAllWTablesGIUWS004",
					distNo : objUW.hidObjGIUWS004.GIUWPolDist[i].distNo,
					parId : objUW.hidObjGIUWS004.GIUWPolDist[i].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Adjusting Preliminary Peril Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText);
					clearForm();
					clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
					objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
					refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
					//refreshForm(objGIUWPolDist);
				}
			});
		}
	}
	//for saving first if ever records are changed before adjustments and recomputations occur then saved again by savePrelimOneRiskDist() edgar 05/13/2014
	/*function savePrelimOneRiskDist2(param){		commented out by Gzelle 06102014
		try{
			if (!procedurePreCommit()){
				return false;	
			}	
			if (!checkC1407TsiPremium()){
				return false;
			}	

			prepareDistForSaving();
			
			var objParameters = new Object();
			objParameters = prepareObjParameters();
			objParameters.savePosting = nvl(param,null) == null ? "N" :"Y";
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "savePrelimOneRiskDist",
					parameters : JSON.stringify(objParameters)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Saving Preliminary One-Risk Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, "E");
						}else{
							objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.clear();
							changeTag = 0;
							clearForm();
							clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
							objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
							refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("savePrelimOneRiskDist", e);
		}
	}*/
	//checking if distribution records is from peril distribution 05/13/2014
	function deleteReinsertGIUWS004 (){
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "deleteReinsertGIUWS004",
					distNo : objArray[a].distNo,
					parId : objArray[a].parId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText);
					//clearForm();	commented out by Gzelle 06182014
					clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
					objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
					//refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);	commented out by Gzelle 06182014
				}
			});
		}
	}
	// for checking of post flag if "P" edgar 05/14/2014
	/*function checkPostFlagBeforePost (){
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].postFlag == "P"){
				updateDistSpct1ToNull();
				deleteReinsertGIUWS004();
				showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
						function(){
							showMessageBox("Post Distribution Complete.", imgMessage.SUCCESS);
							isSavePressed = false;
						});
			}
		}
	}		commented out by Gzelle 06102014*/
	//for checking of expired portfolio share edgar 05/14/2014
	function checkExpiredTreatyShare (funct){
		var ok = true;
		var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						//Share
						for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
							new Ajax.Request(contextPath + "/GIUWPolDistController", {
								method : "POST",
								parameters : {
									action: "getTreatyExpiry",
									lineCd : objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd,
									shareCd : objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd,
									parId :	objArray[a].parId	//added by Gzelle 06172014
								},
								asynchronous: false,
								evalScripts: true,
								onComplete : function(response){
									hideNotice();
									if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
										var comp = JSON.parse(response.responseText);
										if (comp.vExpired == "Y"){	//commented out by Gzelle 06162014 replaced with this code
										//if (dateFormat((comp.expiryDate), "mm-dd-yyyy") <  dateFormat((objArray[a].effDate), "mm-dd-yyyy") && comp.portfolioSw == "P"){
											showMessageBox("Treaty "+comp.treatyName +"  has already expired. Replace the treaty with another one.", imgMessage.ERROR);
										 	ok = false;	
										}
									}
								}
							});
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
		if(ok){
			funct();
		}
		/*if (!ok){
			return false;
		}else {
			return true;
		}	commented out by Gzelle 06102014*/
	}
	//ended edgar 05/12/2014
	$("btnPostDist").observe("click", function(){
		if (changeTag == 0){
			//added if condition to check if user is posting/unposting. Unposting will delete distribution master tables edgar 05/12/2014
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
						postAdjust = "Y";
						savePrelimOneRiskDist();
						disableButton("btnPostDist");
					}
				});
			}else {
				vProcess = "P"; 
				if (!checkPostedBinder()) return false;  
				if (!checkDistFlag()) return false;
				if (!procedurePreCommit()) return false;
				if (!checkC1407TsiPremium("P"))return false;
				getTakeUpTerm(); //get take up term edgar 05/12/2014
				if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up edgar 05/12/2014
					if (!compareWitemPerilToDs()) return false; // for comparison of ds table to itemperil table edgar 05/12/2014
				}
				postAdjust = "Y";// edgar for referencing adjustment of dist prem amounts edgar 05/13/2014
				//checkPostFlagBeforePost();// for checking of post flag edgar 05/14/2014	commented out by Gzelle 06102014
				//if (!checkExpiredTreatyShare()) return false; // for checking of expire Treaty portfolio share edgar 05/14/2014
				//replaced with codes below Gzelle 06172014
				var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
				for(var a=0; a<objArray.length; a++){
					if (objArray[a].postFlag == "P"){
						deleteReinsertGIUWS004();
						showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
								function(){
									isSavePressed = false;
									updateDistSpct1ToNull();
									checkExpiredTreatyShare(continuePost);
								});
					}else if(objArray[a].postFlag == "O") {
						getDistScpt1Val();
						if (nullDistSpct1Exist == "N") {
							compareDelRinsrtWdistTableGIUWS004();
						}else {
							cmpareDelRinsrtWdistTbl1GIUWS004();
						}
						if (nullDistSpct1Exist == "NE"){
							showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", 
									function(){
										adjustDistPrem();
										checkExpiredTreatyShare(continuePost);
									});
						}else if (nullDistSpct1Exist == "E"){
							updateDistSpct1ToNull();
							checkExpiredTreatyShare(continuePost);
						}else {
							checkExpiredTreatyShare(continuePost);
						}
					}
				}
			}
			/*if (objUW.hidObjGIUWS004.selectedGIUWPolDist != null) { //added call on checkAutoDist1 to change value of post button and auto dist flag edgar 05/12/2014
				checkAutoDist1(objUW.hidObjGIUWS004.selectedGIUWPolDist); 
			}	commented out by Gzelle 06162014*/
		}else{
			//showMessageBox("Changes is only available after changes have been saved.", imgMessage.INFO); commented out by Gzelle 06182014 replaced with codes below
			showMessageBox(objCommonMessage.SAVE_CHANGES,imgMessage.INFO);
			return false;
		}	
	});	
	
	//Added by Gzelle 06102014
	function continuePost() {
// 		var obj = objUW.hidObjGIUWS004.selectedGIUWPolDist;
// 		var id = obj.divCtrId;
// 		for(var a=0; a<objUW.hidObjGIUWS004.GIUWPolDist.length; a++){
// 			if (objUW.hidObjGIUWS004.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUWS004.GIUWPolDist[a].recordStatus != -1){
// 				supplyDist(objUW.hidObjGIUWS004.GIUWPolDist[a]);
// 				$$("div[name='rowPrelimDist']").each(function(row){
// 					var ctrId = row.id.substr((row.id.length-1), row.id.length);
// 					fireEvent($("distListingDiv").down("div", ctrId), "click");
// 				});
// 			}
// 		}
		for(var i=0, length=objUW.hidObjGIUWS004.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustAllWTablesGIUWS004",
					distNo : objUW.hidObjGIUWS004.GIUWPolDist[i].distNo,
					parId : objUW.hidObjGIUWS004.GIUWPolDist[i].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Adjusting Preliminary Peril Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText);
					objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
				}
			});
		}		
		
		var objArray = objUW.hidObjGIUWS004.selectedGIUWPolDist;
		prepareDistForSaving();
		var objParameters = new Object();
		objParameters = prepareObjParameters();
		for(var a=0; a<objArray.giuwWpolicyds.length; a++){
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "postDist",
					parId: ('${isPack}' == "Y" ? $("initialParId").value :  $("globalParId").value),
					distNo: objArray.giuwWpolicyds[a].distNo,
					distSeqNo: objArray.giuwWpolicyds[a].distSeqNo,
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
							if (a==(objArray.giuwWpolicyds.length-1)) postResult.donePosting = "Y";
							if (res.netMsg != null){
								/*showConfirmBox("Confirmation", res.netMsg, 		commented out by Gzelle 06132014
										"Yes", "No", 									replaced with codes below
										function(){
											//irwin
											if (res.treatyMsg != null){
												showConfirmBox("Confirmation", res.treatyMsg, 
														"Yes", "No", checkOverrideNetTreaty, "");
											}else{
												checkOverrideNetTreaty();
											}	
										}, "");*/
								if (res.netOverride == "Net Retention Override") {	//modified by Gzelle 06162014
									netTreaty = "NET";
								}else if (res.treatyOverride == "Treaty Retention Override") {
									netTreaty = "TREATY";
								}
								showConfirmBox("Confirmation", res.netMsg, 
										"Yes", "No", checkOverrideNetTreaty, function() {
											refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
										});
							}else{
								if (res.treatyMsg != null){
									netTreaty = "TREATY";	//added by Gzelle 06132014
									checkOverrideNetTreaty();
									//showConfirmBox("Confirmation", "2 "+res.treatyMsg, 
									//		"Yes", "No", checkOverrideNetTreaty, "");
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
						}	
					}		
				}
			});		
		}
	}

	function postDistGiuws004Final(){
		var objArray = objUW.hidObjGIUWS004.selectedGIUWPolDist;
		prepareDistForSaving();
		var objParameters = new Object();
		objParameters = prepareObjParameters();
		for(var a=0; a<objArray.giuwWpolicyds.length; a++){
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "postDistGiuws004Final",
					parId: objArray.parId,//globalParId,
					distNo: objArray.giuwWpolicyds[a].distNo,
					distSeqNo: objArray.giuwWpolicyds[a].distSeqNo,
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
					if (checkErrorOnResponse(response)){						
						if(res.message.include("Geniisys Exception")){
							var message = res.message.split("#");
							showMessageBox(message[2], message[1]);
							return false;
						}else {
							postResult2 = res;
							objUW.hidObjGIUWS004.selectedGIUWPolDist.varShare = postResult2.newItems.varShare;
							objUW.hidObjGIUWS004.selectedGIUWPolDist.postFlag = postResult2.newItems.postFlag;
							objUW.hidObjGIUWS004.selectedGIUWPolDist.distFlag = postResult2.newItems.distFlag;
							objUW.hidObjGIUWS004.selectedGIUWPolDist.autoDist = postResult2.newItems.autoDist;
							showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS,function(){
								if (isOkPressed == "N") {
									var id = getSelectedRowIdInTable("distListingDiv", "rowPrelimDist");
									for(var a=0; a<objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds.length; a++){
										var obj = new Object();
										obj.parId = objUW.hidObjGIUWS004.GIUWPolDist[id].parId;
										obj.distNo = objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds[a].distNo;
										obj.distSeqNo = objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds[a].distSeqNo;
										obj.overrideSwitch = overrideSwitch;
										obj.process = "P";
										obj.processId = objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.length;
										objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.push(obj);
										if (a==(objUW.hidObjGIUWS004.GIUWPolDist[id].giuwWpolicyds.length-1)){
											if (nvl(postResult.donePosting,"N") == "Y"){
												postResult.donePosting = "N";
												isSavePressed = false;	//added by Gzelle 06102014
												savePrelimOneRiskDist("P");
											}	
										}	
									}								
								}
								isSavePressed = true; 
							});
							//disableButton("btnPostDist");		//commented out by Gzelle 06102014
						}
					}
				}
			});
		}
	}
	
	function refreshForm(objArray){
		try{
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareList(objArray[a]);
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				objArray[a].posted = "N";
				$("rowPrelimDist"+a) ? $("rowPrelimDist"+a).update(content) :null;
				//Group
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
					var content2 = prepareList2(objArray[a].giuwWpolicyds[b]);
					objArray[a].giuwWpolicyds[b].recordStatus = null;
					$("rowGroupDist"+objArray[a].giuwWpolicyds[b].distNo+""+objArray[a].giuwWpolicyds[b].distSeqNo) ? $("rowGroupDist"+objArray[a].giuwWpolicyds[b].distNo+""+objArray[a].giuwWpolicyds[b].distSeqNo).update(content2) :null;
					//Share
					for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
						var content3 = prepareList3(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c]);
						objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus = null;
						$("rowShareDist"+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd) ? $("rowShareDist"+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd).update(content3) :null;
					}						
				}	
			}	
		}catch(e){
			showErrorMessage("updateForm", e);
		}	
	}	

	function savePrelimOneRiskDist(param){
		try{
			vProcess = "S";
			if (!checkPostedBinder()) {
				return false;
			}
			if (!procedurePreCommit()){
				return false;	
			}	
			if (!checkC1407TsiPremium((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")))){	/*modified by Gzelle 06092014*/
				return false;
			}	
			//for recomputation of distribution premium amounts if posting edgar 05/12/2014
			/*savePrelimOneRiskDist2();*/ //to  records on screen first before adjusting commented out by Gzelle 06102014
			function saveDistributionChanges(param, distSpct, postFlag){		//added by Gzelle 06102014
				prepareDistForSaving();
				
				var objParameters = new Object();
				objParameters = prepareObjParameters();
				objParameters.savePosting = nvl(param,null) == null ? "N" :"Y";
				objParameters.distSpctChk = nvl(distSpct,null) == null ? "N" : distSpct;
				objParameters.postFlag = nvl(postFlag,null) == null ? "O" : postFlag;
				new Ajax.Request(contextPath + "/GIUWPolDistController", {
					method : "POST",
					parameters : {
						action: "savePrelimOneRiskDist",
						parameters : JSON.stringify(objParameters)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
						showNotice("Saving Preliminary One-Risk Distribution, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						if (checkErrorOnResponse(response)){
							if (res.message != "SUCCESS"){
								showMessageBox(res.message, "E");
							}else{
								objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.clear();
								changeTag = 0;
								if(isSavePressed){  // "Saving complete" should not be displayed if Post Distribution to Final/RI is pressed edgar 05/12/2014
									showMessageBox(objCommonMessage.SUCCESS, "S");	
								}
								clearForm();
								clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
								objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
								refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
							}
						}
					}
				});
			}
			
			function confirmMessage(param,postFlag){
				if (nullDistSpct1Exist == "NE"){
					showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", 
							function(){
								saveDistributionChanges(param, "NE");
							});
				}else if (nullDistSpct1Exist == "E"){
					saveDistributionChanges(param, "E");
				}else{
					saveDistributionChanges(param, "N");
				}
			}
			
			var objArray = objUW.hidObjGIUWS004.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].postFlag == "P"){
					showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
							function(){
								getDistScpt1Val();
								if (postAdjust == "N"){
									confirmMessage(param,"P");
									postAdjust = "N";
									isSavePressed = true;
								}else {
									confirmMessage(param,"P");
									postAdjust = "N";
									isSavePressed = false;
								} 
							}
					);
				}else {
					getDistScpt1Val();
					if (postAdjust == "N"){
						confirmMessage(param);
						postAdjust = "N";
						isSavePressed = true;
					}else {
						confirmMessage(param);
						postAdjust = "N";
						isSavePressed = false;
					} 
				}
			}
			
			/*if (postAdjust == "N"){		commented out by Gzelle 06102014 replaced with codes above
				if (nullDistSpct1Exist == "NE"){
					adjustDistPrem();
				}else if (nullDistSpct1Exist == "E"){
					updateDistSpct1ToNull();
				}
				postAdjust = "N";
				isSavePressed = true;
			}else {
				if (nullDistSpct1Exist == "NE"){
					adjustDistPrem();
				}else if (nullDistSpct1Exist == "E"){
					updateDistSpct1ToNull();
				}
				postAdjust = "N";
				isSavePressed = false;
			}
			
			adjustAllWTablesGIUWS004();// for adjusting dist tables edgar 05/13/2014
			//ended edgar 05/13/2014	
			prepareDistForSaving();
			
			var objParameters = new Object();
			objParameters = prepareObjParameters();
			objParameters.savePosting = nvl(param,null) == null ? "N" :"Y";
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "savePrelimOneRiskDist",
					parameters : JSON.stringify(objParameters)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Saving Preliminary One-Risk Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, "E");
						}else{
							objUW.hidObjGIUWS004.GIUWPolDistPostedRecreated.clear();
							changeTag = 0;
							if(isSavePressed){  // "Saving complete" should not be displayed if Post Distribution to Final/RI is pressed edgar 05/12/2014
								showMessageBox(objCommonMessage.SUCCESS, "S");	
							}
							clearForm();
							clearDistStatus(objUW.hidObjGIUWS004.GIUWPolDist);
							objUW.hidObjGIUWS004.GIUWPolDist = res.giuwPolDist;
							refreshForm(objUW.hidObjGIUWS004.GIUWPolDist);
						}
					}
				}
			});*/
		}catch(e){
			showErrorMessage("savePrelimOneRiskDist", e);
		}
	}	
	
	//added by Gzelle 06112014
	function compareDelRinsrtWdistTableGIUWS004(){
		for(var i=0, length=objUW.hidObjGIUWS004.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "compareDelRinsrtWdistTableGIUWS004",
					distNo : objUW.hidObjGIUWS004.GIUWPolDist[i].distNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						
					}
				}
			});
		}
	}
	
	function cmpareDelRinsrtWdistTbl1GIUWS004(){
		for(var i=0, length=objUW.hidObjGIUWS004.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "cmpareDelRinsrtWdistTbl1GIUWS004",
					distNo : objUW.hidObjGIUWS004.GIUWPolDist[i].distNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						
					}
				}
			});
		}
	}

	function checkPostedBinder (){
		var ok = true;
		for(var i=0, length=objUW.hidObjGIUWS004.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "checkPostedBinder",
					parId: objUW.hidObjGIUWS004.GIUWPolDist[i].parId,
					distNo : objUW.hidObjGIUWS004.GIUWPolDist[i].distNo,
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

	observeReloadForm("reloadForm", showPreliminaryOneRiskDist);
	observeCancelForm("btnCancel", savePrelimOneRiskDist, (isPack == "Y") ? showPackParListing : showParListing);
	observeSaveForm("btnSave", savePrelimOneRiskDist);
	
	clearForm();
	changeTag = 0;
	initializeChangeTagBehavior(savePrelimOneRiskDist);
	setDocumentTitle("Preliminary One-Risk Distribution");
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
	
	if ($("distListingDiv").down("div", 0) != null && isPack != 'Y'){ // Tonio 07/11/2011 Added condition to handle error div is not loaded
		 fireEvent($("distListingDiv").down("div", 0), "click"); // andrew - 05.01.2011 - first record in distribution will be selected by default
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
					objGIPIS130.distSeqNo = $("txtDistSeqNo").value;
					objUWGlobal.previousModule = "GIUWS004";
					showViewDistributionStatus();
				}
			}
		});
	});
	
	$("summarizedDistDiv").hide();
</script>	