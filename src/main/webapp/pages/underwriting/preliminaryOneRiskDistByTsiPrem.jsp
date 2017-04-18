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
						<label style="width: 20%; text-align: left; margin-right: 3px;">Share</label>
						<label style="width: 19%; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 20%; text-align: right; margin-right: 5px;">Sum Insured</label>
						<label style="width: 19%; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 19%; text-align: right; ">Premium</label>
					</div>
					<div id="distShareListingDiv" name="distShareListingDiv" style="margin:10px; margin-top:0px;" class="tableContainer">
							
					</div>
				</div>
				<div id="distShareTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
					<div id="distShareTotalAmtDiv" style="width:100%;">
						<label style="text-align:left; width:20%; margin-right: 3px; float:left;">Total:</label>
						<label style="text-align:right; width:19%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label style="text-align:right; width:20%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label style="text-align:right; width:19%; float:left;" class="money">&nbsp;</label>
						<label style="text-align:right; width:19%;  margin-left: 5px;" class="money">&nbsp;</label>
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
							<!-- changed nthDecimal from 14 to 9 and maxlength from 18 to 13 : shan 05.14.2014 -->
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
						<td class="rightAligned">% Share</td>
						<td class="leftAligned">
							<!-- changed nthDecimal from 14 to 9  and maxlength from 18 to 13 : shan 05.14.2014 -->
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct2" name="txtDistSpct" value="" style="width:250px;" maxlength="13" readonly="readonly"/>
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
objUW.hidObjGIUWS005 = {};
objUW.hidObjGIUWS005.GIUWPolDist = JSON.parse('${GIUWPolDistJSON}'.replace(/\\/g, '\\\\'));
objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated = [];
objUW.hidObjGIUWS005.selectedGIUWPolDist = {};
objUW.hidObjGIUWS005.selectedGIUWWpolicyds = {};
objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl = {};
objUW.hidObjGIUWS005.distListing = {};
objUW.hidObjGIUWS005.globalParId = null;
objUW.hidObjGIUWS005.lineCd = null;
objUW.hidObjGIUWS005.nbtLineCd = null;
objUW.hidObjGIUWS005.sumDistSpct = 0;
objUW.hidObjGIUWS005.sumDistTsi = 0;
objUW.hidObjGIUWS005.sumDistPrem = 0;
var overrideSwitch = "N"; // added by: shan 05.29.2014 - to check if a user override has been entered
objUW.recreatedFlag = false;
objUW.postTag = 'N';

objGIPIParList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
var isPack = "${isPack}";

//for getting takeupterm edgar 05/12/2014
var takeUpTerm = "";
var isSavePressed =true; // to check whether the [Save] button was pressed or not base on GIUWS003 edgar 05/12/2014
var postAdjust = "N"; // to manipulate adjustment when saving/posting due to error in distSpct1 edgar 05/12/2014
var nullDistSpct1Exist; // for determining null and non-null distSpct1 edgar 05/13/2014
var vProcess; //edgar 06/20/2014
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
					$("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
					showPreliminaryOneRiskDistByTsiPrem();
					if ($("distListingDiv").down("div", 0) != null){ 
						 fireEvent($("distListingDiv").down("div", 0), "click"); 
					}
				}else {
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function (){
																											$("initialParId").value = row.getAttribute("parId");
																											$("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
																											savePrelimOneRiskDist();
																											showPreliminaryOneRiskDistByTsiPrem();
																										  }, function () {
																											    $("initialParId").value = row.getAttribute("parId");
																											    $("initialLineCd").value = row.getAttribute("lineCd"); // andrew 10.03.2011
																											 	showPreliminaryOneRiskDistByTsiPrem();
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
//$("parNo").value = objUWParList.parNo;
//$("assuredName").value = changeSingleAndDoubleQuotes(objUWParList.assdName);

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
		var list = '<label style="width: 20%; text-align: left; margin-right: 3px;">'+nvl(obj.dspTrtyName,'-')+'</label>'+
				   '<label style="width: 19%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct,'') == '' ? '-' :formatToNthDecimal(obj.distSpct,9))+'</label>'+ //changed rounding off from 14, acceptedRound to formatToNthDecimal : shan 05/14/2014
				   '<label style="width: 20%; text-align: right; margin-right: 5px;">'+(nvl(obj.distTsi,'') == '' ? '-' :formatCurrency(obj.distTsi))+'</label>'+
				   '<label style="width: 19%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct1,'') == '' ? '-' :formatToNthDecimal(obj.distSpct1,9))+'</label>'+ //changed rounding off from 14, acceptedRound to formatToNthDecimal : shan 05/14/2014
				   '<label style="width: 19%; text-align: right; ">'+(nvl(obj.distPrem,'') == '' ? '-' :formatCurrency(obj.distPrem))+'</label>';
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
showList(objUW.hidObjGIUWS005.GIUWPolDist);

//create observe on Main list
$$("div#distListingDiv div[name=rowPrelimDist]").each(function(row){
	loadRowMouseOverMouseOutObserver(row);
	setClickObserverPerRow(row, 'distListingDiv', 'rowPrelimDist', 
			function(){
				var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
				for(var a=0; a<objUW.hidObjGIUWS005.GIUWPolDist.length; a++){
					if (objUW.hidObjGIUWS005.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUWS005.GIUWPolDist[a].recordStatus != -1){
						supplyDist(objUW.hidObjGIUWS005.GIUWPolDist[a]);
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
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
	setClickObserverPerRow(row, 'distGroupListingDiv', 'rowGroupDist', function(){supplyGroupDistPerRow(row);}, function(){supplyGroupDist(null);});
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
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
				if ((obj.distFlag != "2"/* && obj.distFlag != "3"*/) || nvl(obj.distFlag,"") == ""){
					enableButton("btnCreateItems");
				}else if(obj.distFlag == "2" || obj.distFlag == "3"){
					disableButton("btnCreateItems");
					disableButton("btnPostDist"); // shan : 06.20.2014 - btnPostDist will be disabled when Distribution is posted to RI
				}	
				if (nvl(obj.varShare,null) == "Y"){
					$("btnPostDist").value = "Post Distribution to RI";
					//enableButton("btnPostDist");	// shan : 06.20.2014 - btnPostDist will be disabled when Distribution is posted to RI
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
				disableButton("btnViewDist"); //enable button if PAR is endt.
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
				
				// bonok :: 09.24.2014 :: use dist_flag from giuw_pol_dist to check distribution status :: FGIC-WEB SR# 2432
				if(obj.distFlag == "2" && obj.recordStatus != -1){
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
		objUW.hidObjGIUWS005.selectedGIUWPolDist 	= obj==null?{}:obj;
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
		objUW.hidObjGIUWS005.selectedGIUWWpolicyds	= obj==null?{}:obj;
		$("txtDistSeqNo").value 					= nvl(obj==null?null:obj.distSeqNo,'') == '' ? null :formatNumberDigits(obj.distSeqNo,5);
		$("txtTsiAmt").value 						= nvl(obj==null?null:obj.tsiAmt,'') == '' ? null :formatCurrency(obj.tsiAmt);
		$("txtPremAmt").value 						= nvl(obj==null?null:obj.premAmt,'') == '' ? null :formatCurrency(obj.premAmt);
		$("lblCurrency").innerHTML					= nvl(obj==null?'&nbsp;':obj.currencyDesc,'&nbsp;');
		supplyShareDist(null);
		getShareDefaults(true);
		if (obj == null){
			disableButton("btnAddShare");
			disableButton("btnTreaty");
			disableButton("btnShare");
			$("txtDistSpct").readOnly = true;
			$("txtDistSpct2").readOnly = true;
			$("txtDistTsi").readOnly = true;
			$("txtDistPrem").readOnly = true;
		}else{
			enableButton("btnAddShare");
			enableButton("btnTreaty");
			enableButton("btnShare");
			$("txtDistSpct").readOnly = false;
			$("txtDistSpct2").readOnly = false;
			$("txtDistTsi").readOnly = false;
			$("txtDistPrem").readOnly = false;
		}	
		
		disableButton("btnViewDist");
		if (obj != null){
			if($F("globalParType") == "E"){
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
		//tonio
		objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl	= obj==null?{}:obj;
		$("txtDspTrtyName").value						= unescapeHTML2(nvl(obj==null?'':obj.dspTrtyName,''));
		$("txtDistSpct").value							= nvl(obj==null?null:obj.distSpct,'') == '' ? null :formatToNthDecimal(obj.distSpct,9); //changed rounding off from 14, acceptedRound to formatToNthDecimal shan 05/14/2014
		$("txtDistTsi").value							= nvl(obj==null?null:obj.distTsi,'') == '' ? null :formatCurrency(obj.distTsi);
		$("txtDistPrem").value							= nvl(obj==null?null:obj.distPrem,'') == '' ? null :formatCurrency(obj.distPrem);
		$("txtDistSpct2").value							= nvl(obj==null?null:obj.distSpct1,'') == '' ? null :formatToNthDecimal(obj.distSpct1,9); //changed rounding off from 14, acceptedRound to formatToNthDecimal shan 05/14/2014
		/* if (obj != null){ // bonok :: 9.24.2014 :: para nde mag enable ung buttons kapag may selected na share :: FGIC-WEB SR#2433
			if (obj.recordStatus == 0){
				enableButton("btnTreaty"); 
				enableButton("btnShare");
			}
		} */	
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
		var objGroup = objUW.hidObjGIUWS005.selectedGIUWWpolicyds;
		var obj = objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl;
		var newObj = new Object();
		newObj.recordStatus			= obj == null ? null :nvl(obj.recordStatus, null);
		newObj.distNo				= obj == null ? objGroup.distNo :nvl(obj.distNo, objGroup.distNo);
		newObj.distSeqNo 			= obj == null ? objGroup.distSeqNo :nvl(obj.distSeqNo, objGroup.distSeqNo);
		newObj.lineCd 				= obj == null ? "" :nvl(obj.lineCd, "");
		newObj.shareCd 				= obj == null ? "" :nvl(obj.shareCd, "");
		newObj.distSpct				= escapeHTML2($F("txtDistSpct"));
		newObj.distSpct1			= escapeHTML2($F("txtDistSpct2"));
		newObj.distTsi				= escapeHTML2(unformatNumber($F("txtDistTsi")));
		newObj.distPrem				= escapeHTML2(unformatNumber($F("txtDistPrem")));
		newObj.annDistSpct			= escapeHTML2($F("txtDistSpct")); //obj == null ? "" :nvl(obj.annDistSpct, "");
									// added roundNumber to prevent ORA-01438: value larger than specified precision allowed for this column : shan 05.28.2014
		newObj.annDistTsi			= roundNumber((nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100, 2);	//obj == null ? "" :nvl(obj.annDistTsi, "");
		newObj.distGrp				= obj == null ? "1" :"1"; //nvl(obj.distGrp, ""); //pre-insert block :C1407.dist_grp := 1;
		//newObj.distSpct1			= obj == null ? "" :nvl(obj.distSpct1, "");
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
			customShowMessageBox("Distribution no. is required.", imgMessage.ERROR, "txtC080DistNo");
			return false;
		}
		if ($F("txtDistSeqNo") == ""){
			customShowMessageBox("Group no. is required.", imgMessage.ERROR, "txtDistSeqNo");
			return false;
		}	
		if ($F("txtDspTrtyName") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "txtDspTrtyName"); //"Share is required."
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
		if ($F("txtDistSpct2") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtDistSpct2"); //"% Share Premium is required."
			return false;
		}
		if ($F("txtDistPrem") == ""){
			customShowMessageBox("Premium is required.", imgMessage.ERROR, "txtDistPrem");
			return false;
		}
		if (parseFloat($F("txtDistSpct")) > 100 || parseFloat($F("txtDistSpct2")) > 100){
			customShowMessageBox("%Share cannot exceed 100.", imgMessage.ERROR, "txtDistSpct");
			return false;
		}	
		if (parseFloat($F("txtDistSpct")) <= 0 && parseFloat($F("txtDistSpct2")) <= 0){
			customShowMessageBox("%Share must be greater than zero.", imgMessage.ERROR, "txtDistSpct");
			return false;
		}
		//if (unformatCurrency("txtTsiAmt") != 0){ //removed by robert SR 5053 12.21.15
		//	$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtTsiAmt"),0));
			/*if (acceptedRound(unformatCurrency("txtDistTsi"), 2) == 0 ){	
				customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", imgMessage.ERROR, "txtDistTsi");
				return false;
			}	*/
		//}
		if (Math.abs($F("txtDistTsi")) > Math.abs($F("txtTsiAmt"))){
			customShowMessageBox("Sum insured cannot exceed TSI.", imgMessage.ERROR, "txtDistTsi");
			return false;
		}
		if (unformatCurrency("txtTsiAmt") > 0){
			if (unformatCurrency("txtDistTsi") <= 0 && unformatCurrency("txtDistSpct2") <= 0){ // added condition : shan 05.23.2014
				customShowMessageBox("Sum insured must be greater than zero.", imgMessage.ERROR, "txtDistTsi");
				return false;
			}	
		}else if (unformatCurrency("txtTsiAmt") < 0){
			if (unformatCurrency("txtDistTsi") >= 0){
				customShowMessageBox("Sum insured must be less than zero.", imgMessage.ERROR, "txtDistTsi");
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

				var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
										changeTag=1;
										objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
										objArray[a].autoDist = "N"; //set autoDist to N to unpost distribution when posted - christian
									}
								}
							}
						}
					}
				}
				objUW.recreatedFlag = false;
			}else{
				//on ADD records
				var tableContainer = $("distShareListingDiv");
				var newDiv = new Element("div");
				var distNo = newObj.distNo;
				var distSeqNo = newObj.distSeqNo;
				var lineCd = newObj.lineCd;
				var shareCd = newObj.shareCd;
				//newObj.divCtrId = generateDivCtrId(objArray[a].giuwWpolicyds[b]);
				var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
				objUW.recreatedFlag = false;
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
			customShowMessageBox("Distribution no. is required.", imgMessage.ERROR, "txtC080DistNo");
			return false;
		}
		if ($F("txtDistSeqNo") == ""){
			customShowMessageBox("Group no. is required.", imgMessage.ERROR, "txtDistSeqNo");
			return false;
		}
		$$("div#distShareListingDiv div[name='rowShareDist']").each(function(row){
			if (row.hasClassName("selectedRow")){
				var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
				var distNo = row.readAttribute("distNo");
				var distSeqNo = row.readAttribute("distSeqNo");
				var lineCd = row.readAttribute("lineCd");
				var shareCd = row.readAttribute("shareCd");
				var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
										objUW.recreatedFlag = false;
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
	var objArray = objUW.hidObjGIUWS005.distListing.distShareListingJSON;
	startLOV("GIUWS004-Share", "Share", objArray, 540);
});	

$("btnTreaty").observe("click", function(){
	getListing();
	var objArray = objUW.hidObjGIUWS005.distListing.distTreatyListingJSON;
	startLOV("GIUWS004-Treaty", "Treaty", objArray, 540);	
});

function startLOV(id, title, objArray, width){
	try{
		var copyObj = objArray.clone();	
		var copyObj2 = objArray.clone();	
		var selGrpObjArray = objUW.hidObjGIUWS005.selectedGIUWWpolicyds.giuwWpolicydsDtl.clone();
		selGrpObjArray = selGrpObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
		var share = objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl;
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
				objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");;
				objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
				objUW.hidObjGIUWS005.selectedGIUWWpolicydsDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");;
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

function getListing(){
	try{
		if (objUW.hidObjGIUWS005.globalParId == objUW.hidObjGIUWS005.selectedGIUWPolDist.parId && 
				objUW.hidObjGIUWS005.nbtLineCd == objUW.hidObjGIUWS005.selectedGIUWWpolicyds.nbtLineCd && 
				objUW.hidObjGIUWS005.lineCd == $F("globalLineCd")){ return;}
		objUW.hidObjGIUWS005.globalParId = objUW.hidObjGIUWS005.selectedGIUWPolDist.parId;
		objUW.hidObjGIUWS005.nbtLineCd = objUW.hidObjGIUWS005.selectedGIUWWpolicyds.nbtLineCd;
		objUW.hidObjGIUWS005.lineCd = $F("globalLineCd");
		new Ajax.Request(contextPath+"/GIUWPolDistController",{
			parameters:{
				action: "getDistListing",
				globalParId: objUW.hidObjGIUWS005.selectedGIUWPolDist.parId,
				nbtLineCd: objUW.hidObjGIUWS005.selectedGIUWWpolicyds.nbtLineCd,
				lineCd: $F("globalLineCd")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				objUW.hidObjGIUWS005.distListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
			}	
		});	
	}catch(e){
		showErrorMessage("getListing", e);
	}
}	

/* % Share */ 
initPreTextOnField("txtDistSpct");
$("txtDistSpct").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012
	//if ($F("txtDistSeqNo") == "" || $F("txtDistSpct") == "") return; //removed by robert SR 5053 12.21.15
	//if (!checkIfValueChanged("txtDistSpct")) return; //removed by robert SR 5053 12.21.15
	if($F("txtDistSpct").empty()){ //added by robert SR 5053 12.21.15
		$("txtDistSpct").value = 0;
	}
	if ((parseFloat(this.value.replace(/,/g, "")) < parseFloat(0)) || (parseFloat(this.value.replace(/,/g, "")) > parseFloat(100))){
		showMessageBox("Entered % Share is invalid. Valid value is from 0 to 100.", "E");
		this.value = this.getAttribute("pre-text");
		return;
	}
	/*  Check that %Share is not greater than 100 */ 
	/* commented out by shan 06.03.2014
	if (parseFloat($F("txtDistSpct")) > 100){
		$("txtDistSpct").value = getPreTextValue("txtDistSpct");
		customShowMessageBox("%Share cannot exceed 100.", imgMessage.ERROR, "txtDistSpct");
		return false;
	}	
	if (parseFloat($F("txtDistSpct")) <= 0 && parseFloat($F("txtDistSpct2")) <= 0){	// added dist_spct1 condition : shan 05.23.2014
		$("txtDistSpct").value = getPreTextValue("txtDistSpct");
		customShowMessageBox("%Share must be greater than zero.", imgMessage.ERROR, "txtDistSpct");
		return false;
	}*/

	/* Compute DIST_TSI if the TSI amount of the master table
	 * is not equal to zero.  Otherwise, nothing happens.  */
	if (unformatCurrency("txtTsiAmt") != 0){
		$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtTsiAmt"),0));
		/*if (acceptedRound(unformatCurrency("txtDistTsi"), 2) == 0 ){	
			customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", imgMessage.ERROR, "txtDistTsi");
			return false;
		}	*/
	}else{
		$("txtDistTsi").value = acceptedRound(0, 2); //changed 14 to 2 decimal places - christian
	}
	
	/* Compute dist_prem  */
	//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct2")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));	removed by robert SR 5053 11.11.15
	$("txtDistSpct2").value = 	$F("txtDistSpct"); //added by robert SR 5053 11.11.15 //added by robert SR 5053 12.21.15
	fireEvent($("txtDistSpct2"), "change"); //added by robert SR 5053 11.11.15  //added by robert SR 5053 12.21.15
	fireEvent($("txtDistSpct2"), "blur"); //added by robert SR 5053 11.11.15  //added by robert SR 5053 12.21.15
});	

initPreTextOnField("txtDistSpct2");
$("txtDistSpct2").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012
	//if ($F("txtDistSeqNo") == "" || $F("txtDistSpct2") == "") return; removed by robert SR 5053 11.11.15
	//if (!checkIfValueChanged("txtDistSpct2")) return; removed by robert SR 5053 11.11.15
	if($F("txtDistSpct2").empty()){  //added by robert SR 5053 12.21.15
		$("txtDistSpct2").value = 0;
	}
	if ((parseFloat(this.value.replace(/,/g, "")) < parseFloat(0)) || (parseFloat(this.value.replace(/,/g, "")) > parseFloat(100))){
		showMessageBox("Entered % Share is invalid. Valid value is from 0 to 100.", "E");
		this.value = this.getAttribute("pre-text");
		return;
	}
	/*  Check that %Share is not greater than 100 */ 
	/* commented out by shan 06.03.2014
	if (parseFloat($F("txtDistSpct2")) > 100){
		$("txtDistSpct2").value = getPreTextValue("txtDistSpct2");
		customShowMessageBox("%Share cannot exceed 100.", imgMessage.ERROR, "txtDistSpct2");
		return false;
	}	
	if (parseFloat($F("txtDistSpct2")) <= 0 && parseFloat($F("txtDistSpct")) <= 0){	// added dist_spct1 condition : shan 05.23.2014
		$("txtDistSpct2").value = getPreTextValue("txtDistSpct2");
		customShowMessageBox("%Share must be greater than zero.", imgMessage.ERROR, "txtDistSpct2");
		return false;
	}*/

	/* Compute DIST_TSI if the TSI amount of the master table
	 * is not equal to zero.  Otherwise, nothing happens.  */
	if (unformatCurrency("txtPremAmt") != 0){
		$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct2")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));
		/*if (acceptedRound(unformatCurrency("txtDistPrem"), 2) == 0 ){	
			customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Premium.", imgMessage.ERROR, "txtDistPrem");
			return false;
		}	*/
	}else{
		$("txtDistPrem").value = acceptedRound(0, 2); //changed 14 to 2 decimal places - christian
	}
	
	/* Compute dist_prem  */
	$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct2")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));		
});	

/* Sum Insured */ 
initPreTextOnField("txtDistTsi");
$("txtDistTsi").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 06.21.2012
	//if ($F("txtDistSeqNo") == "" || $F("txtDistTsi") == "") return; removed by robert SR 5053 11.11.15
	//if (!checkIfValueChanged("txtDistTsi")) return; removed by robert SR 5053 11.11.15
	if($F("txtDistTsi").empty()){ //added by robert SR 5053 11.11.15
		$("txtDistTsi").value = 0;
	}
	/* Check that dist_tsi does is not greater than tsi_amt  */
	if (Math.abs(unformatCurrency("txtDistTsi")) > Math.abs(unformatCurrency("txtTsiAmt"))){
		customShowMessageBox("Sum insured cannot exceed TSI.", imgMessage.ERROR, "txtDistTsi");
		return false;
	}	

	/* Compute dist_spct if the TSI amount of the master table
	 * is not equal to zero.  Otherwise, nothing happens.  */
	if (unformatCurrency("txtTsiAmt") > 0){
		if (unformatCurrency("txtDistTsi") < 0){	// from >= to > : shan 06.03.2014
			customShowMessageBox("Sum insured must be less than zero.", imgMessage.ERROR, "txtDistTsi");
			return false;
		}	
		$("txtDistSpct").value = roundNumber(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 ,9); //changed rounding off from 14, acceptedRound to roundNumber shan 05/23/2014
	}else if (unformatCurrency("txtTsiAmt") < 0){
		if (unformatCurrency("txtDistTsi") > 0){ 
			customShowMessageBox("Sum insured must be greater than zero.", imgMessage.ERROR, "txtDistTsi");
			return false;
		}	
      $("txtDistSpct").value = roundNumber(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 ,9); //changed rounding off, acceptedRound to roundNumber shan 05/23/2014
	}else{
		$("txtDistTsi").value = formatCurrency("0");
	}	

	/* Compute dist_prem  */
	//$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct2")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));	
	$("txtDistSpct2").value = 	$F("txtDistSpct"); //added by robert SR 5053 11.11.15
	fireEvent($("txtDistSpct2"), "change"); //added by robert SR 5053 11.11.15
	fireEvent($("txtDistSpct2"), "blur"); //added by robert SR 5053 11.11.15
});

/* Premium */ 
initPreTextOnField("txtDistPrem");
$("txtDistPrem").observe(/*"blur"*/"change", function(){ 	// added by shan 07.03.2014
	//if ($F("txtDistSeqNo") == "" || $F("txtDistPrem") == "") return; removed by robert SR 5053 11.11.15
	//if (!checkIfValueChanged("txtDistPrem")) return; removed by robert SR 5053 11.11.15
	if($F("txtDistPrem").empty()){ //added by robert SR 5053 11.11.15
		$("txtDistPrem").value = 0;
	}
	/* Check that dist_tsi does is not greater than tsi_amt  */
	if (Math.abs(unformatCurrency("txtDistPrem")) > Math.abs(unformatCurrency("txtPremAmt"))){
		customShowMessageBox("Premium Amt cannot exceed Premium.", imgMessage.ERROR, "txtDistPrem");
		return false;
	}	

	/* Compute dist_spct if the TSI amount of the master table
	 * is not equal to zero.  Otherwise, nothing happens.  */
	if (unformatCurrency("txtPremAmt") > 0){
		if (unformatCurrency("txtDistPrem") < 0){	
			customShowMessageBox("Premium Amt must not be less than zero.", imgMessage.ERROR, "txtDistPrem");
			return false;
		}	
		$("txtDistSpct2").value = roundNumber(nvl(unformatCurrency("txtDistPrem"),0) / nvl(unformatCurrency("txtPremAmt"),0) * 100 ,9); 
	}else if (unformatCurrency("txtPremAmt") < 0){
		if (unformatCurrency("txtDistPrem") > 0){ 
			customShowMessageBox("Premium Amt must not be greater than zero.", imgMessage.ERROR, "txtDistTsi");
			return false;
		}	
      $("txtDistSpct2").value = roundNumber(nvl(unformatCurrency("txtDistPrem"),0) / nvl(unformatCurrency("txtPremAmt"),0) * 100 , 9);
	}else{
		$("txtDistPrem").value = formatCurrency("0");
	}				   		   
});

function checkC1407TsiPremium(){
	try{
		if((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E"){
			return true;
		}
		var ok = true;
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				//Group
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
					if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
						//Share
						for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
							//if (!objUW.recreatedFlag || (objUW.recreatedFlag && changeTag == 0)){
								if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowPrelimDist");
									dist == "rowPrelimDist"+a ? null :fireEvent($("rowPrelimDist"+a), "click");
									dist == "rowPrelimDist"+a ? null :$("rowPrelimDist"+a).scrollIntoView();
									//disableButton("btnPostDist");
									showWaitingMessageBox("A share in group no. "+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+" cannot have both its TSI and premium equal to zero.", imgMessage.ERROR,
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

function checkC1407TsiPremium2(){
	try{
		if((nvl('${isPack}',"N") == "Y" ? $F("parTypeFlag") :  $F("globalParType")) == "E"){
			return true;
		}
		var ok = true;
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				//Group
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
					if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
						//Share
						for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
							if (!objUW.recreatedFlag){
								if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowPrelimDist");
									dist == "rowPrelimDist"+a ? null :fireEvent($("rowPrelimDist"+a), "click");
									dist == "rowPrelimDist"+a ? null :$("rowPrelimDist"+a).scrollIntoView();
									//disableButton("btnPostDist");
									showWaitingMessageBox("A share in group no. "+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+" cannot have both its TSI and premium equal to zero.", imgMessage.ERROR,
										function(){
											var grp = getSelectedRowIdInTable_noSubstring("distGroupListingDiv", "rowGroupDist");
											grp == "rowGroupDist"+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo? null :fireEvent($("rowGroupDist"+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distNo+""+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo), "click");
										});
									ok = false;
									return false;
								}
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


function computeTotalAmount(distSeqNo){
	///tonio total
	try{
		var sumDistSpct = 0;
		var sumDistTsi = 0;
		var sumDistPrem = 0;
		var sumDistSpct1 = 0;
		var distSeqNo = nvl(distSeqNo,'')==''?'':Number(distSeqNo);
		var ctr = 0;
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
								sumDistSpct1 = parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1,0));
							}
						}
					}	
				}
			}
		}
		/* added to get correct rounded-off value : shan 05.23.2014 */
		sumDistSpct = roundNumber(sumDistSpct, 9);
		sumDistSpct1 = roundNumber(sumDistSpct1, 9);
		/* end 05.23.2014 */
		objUW.hidObjGIUWS005.sumDistSpct = sumDistSpct;
		objUW.hidObjGIUWS005.sumDistTsi = sumDistTsi;
		objUW.hidObjGIUWS005.sumDistPrem = sumDistPrem;
		objUW.hidObjGIUWS005.sumDistSpct1 = sumDistSpct1;
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
		$("distShareTotalAmtMainDiv").down("label",1).update(formatToNthDecimal(sumDistSpct,9).truncate(30, "...")); //changed rounding off from 14, acceptedRound to formatToNthDecimal shan 05/14/2014
		$("distShareTotalAmtMainDiv").down("label",2).update(formatCurrency(sumDistTsi).truncate(30, "..."));
		$("distShareTotalAmtMainDiv").down("label",3).update(formatToNthDecimal(sumDistSpct1,9).truncate(30, "...")); //changed rounding off from 14, acceptedRound to formatToNthDecimal shan 05/14/2014
		$("distShareTotalAmtMainDiv").down("label",4).update(formatCurrency(sumDistPrem).truncate(30, "..."));
	}catch(e){
		showErrorMessage("computeTotalAmount", e);
	}
}	

function procedurePreCommit(){
	try{
		var ok = true;
		var ctr = 0;
		var sumDistSpct = 0;
		var sumDistSpct1 = 0;
		var sumDistTsi = 0;
		var sumDistPrem = 0;
		var tempDistTsi = 0;	// shan 05.14.2014
		var tempDistPrem = 0;	// shan 05.14.2014
		var diffDistPrem = 0; //added by carlo SR 23761
		var diffDistPrem = 0; //added by carlo SR 23761
		var absDistTsi = 0; //added by carlo SR 23761
		var absDistPrem = 0;//added by carlo SR 23761
		
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
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
								sumDistSpct1 = parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1,0));
								// modified to handle disb share where Sum Insured and Premium have odd decimal value : shan 05.14.2014
								//tempDistTsi = (parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0)) / 100) * nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0); removed by robert SR 5053 11.11.15
								//sumDistTsi = parseFloat(sumDistTsi) + parseFloat(tempDistTsi); //parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0)); removed by robert SR 5053 11.11.15
								sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0)); //added by robert SR 5053 11.11.15
								//tempDistPrem = (parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1,0)) / 100) * nvl(objArray[a].giuwWpolicyds[b].premAmt,0); removed by robert SR 5053 11.11.15
								//sumDistPrem = parseFloat(sumDistPrem) + tempDistPrem; //parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0)); removed by robert SR 5053 11.11.15
								sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0)); //added by robert SR 5053 11.11.15
							}
						}
						function err(msg){
							objUW.hidObjGIUWS005.preCommit = "N";
							var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowPrelimDist");
							dist == "rowPrelimDist"+nvl(a,'---') ? null : ($("rowPrelimDist"+nvl(a,'---')) ? fireEvent($("rowPrelimDist"+nvl(a,'---')), "click") :null);
							dist == "rowPrelimDist"+nvl(a,'---') ? null : ($("rowPrelimDist"+nvl(a,'---')) ? $("rowPrelimDist"+nvl(a,'---')).scrollIntoView() :null);
							//disableButton("btnPostDist");
							showWaitingMessageBox(msg, imgMessage.ERROR, 
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
						//commented out ctr == 1 condition, error message should be prompted regardless of share cd; changed rounding off from 14, acceptedRound to roundNumber : shan 05.14.2014
						//if ((roundNumber(sumDistSpct, 9) != 100 || acceptedRound(sumDistTsi, 2) != acceptedRound(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2)) /*&& ctr==1*/){ replaced by robert SR 5053 11.11.15
						if ((roundNumber(sumDistSpct, 9) < parseFloat("99.5") ) || (roundNumber(sumDistSpct, 9) > parseFloat("100.5"))  || roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2) ){
							//err("Total %Share should be equal to 100.");
							//added by carlo to handle odd decimal value SR 23761 02.08.2016 
							diffDistTsi = roundNumber(sumDistTsi, 2) - roundNumber(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2);
							absDistTsi = diffDistTsi < 0 ? Math.abs(diffDistTsi) : diffDistTsi;
							if(sumDistSpct == 100){
								if(roundNumber(absDistTsi, 2) <= 0.05){//0.05 max adjustable value
									ok = true;
								}
							}else{
								err("The total distribution sum insured should be equal to the Group Sum Insured."); 
								return false;
							}
						}
						//if ((roundNumber(sumDistSpct1, 9) != 100 || acceptedRound(sumDistPrem, 2) != acceptedRound(nvl(objArray[a].giuwWpolicyds[b].premAmt,0), 2)) /*&& ctr==1*/){ replaced by robert SR 5053 12.21.15
						if ((roundNumber(sumDistSpct1, 9) < parseFloat("99.5") || roundNumber(sumDistSpct1, 9) > parseFloat("100.5") || roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWpolicyds[b].premAmt,0), 2))){	
							//err("Total %Share should be equal to 100.");
							//added by carlo to handle odd decimal value SR 23761 02.08.2016 
							diffDistPrem = roundNumber(sumDistPrem, 2) - roundNumber(nvl(objArray[a].giuwWpolicyds[b].premAmt,0), 2);
							absDistPrem = diffDistPrem < 0 ? Math.abs(diffDistPrem) : diffDistPrem;
							if(sumDistSpct1 == 100){
								if(roundNumber(absDistPrem, 2) <= 0.05){//0.05 max adjustable value
									ok = true;
								}
							}else{
								err("The total distribution premium amount should be equal to the group premium amount.");
								return false;
							}
						}
						sumDistSpct = 0;
						sumDistSpct1 = 0;
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
		var copyObj = objUW.hidObjGIUWS005.GIUWPolDist.clone();	
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
						customShowMessageBox("Distribution Flag = 2 and GIUW_WPOLICYDS_DTL has no record in group no. "+selGrpObjArray[b].distSeqNo+".", imgMessage.ERROR, "btnCreateItems");
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
	//start edgar 06/20/2014
	//if ($("btnCreateItems").value == "Recreate Items"){ // bonok :: 09.24.2014 :: to handle possible error when using multiple windows/tabs :: FGIC-WEB SR# 2432
		vProcess = "R";
		if (!checkPostedBinder()) return false; 
	//}
	// end edgar 06/20/2014
	if (!checkDistFlag()) return false;
	
	var vCopyDist = "N";
	var vPolFlag = "";
	if ($("globalPolFlag").value == "2"){
		vCopyDist = "Y";
		vPolFlag = "2";
	}	
	if ($("globalParType").value == "E"){
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

function onOkFunc(){
	try{
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
		var index = 0;
		var distNo = Number($F("txtC080DistNo"));
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].distNo == distNo && objArray[a].recordStatus != -1){
				index = a;
				objArray[a].recordStatus = -1;
				var recObj = new Object();
				recObj.distNo = distNo;
				recObj.parId = $("globalParId").value;
				recObj.lineCd = $("globalLineCd").value;
				recObj.sublineCd = $("globalSublineCd").value;
				recObj.issCd = $("globalIssCd").value;
				recObj.packPolFlag = $("globalPackPolFlag").value;
				recObj.polFlag = $("globalPolFlag").value;
				recObj.parType = $("globalParType").value;
				recObj.process = "R";
				recObj.processId = objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated.length;
				//objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated.push(recObj);
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
				action: "createItemsGiuws005",
				distNo: distNo,
				parId: $("globalParId").value,
				lineCd: $("globalLineCd").value,
				sublineCd: $("globalSublineCd").value,
				issCd: $("globalIssCd").value,
				packPolFlag: $("globalPackPolFlag").value,
				polFlag: $("globalPolFlag").value,
				parType: $("globalParType").value
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
						var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
						objArray[index] = obj;
						//checkAutoDist1(objArray[index]); commented out
						enableButton("btnPostDist"); // enable the button instead	
						$("btnPostDist").value = (nvl(obj.varShare,null) == "Y" ? "Post Distribution to RI" : "Post Distribution to Final");
						obj.autoDist = "N";
						objUW.hidObjGIUWS005.selectedGIUWPolDist = obj;
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
							//buttonLabel(objArray[index]);
							supplyGroupDist(null);
							deselectRows("distGroupListingDiv", "rowGroupDist");
							checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",Number($("txtC080DistNo").value));
							clearShare();
							disableButton("btnTreaty");
							disableButton("btnShare");
							//changeTag=1;
							showMessageBox(noticeMsg+" Items complete.", imgMessage.SUCCESS);
						}	
					}else{
						ok = false;
						customShowMessageBox(res.message, imgMessage.ERROR, "btnCreateItems");
						return false;
					}	
				}
			}	
		});	
		$("btnCreateItems").value = "Recreate Items";
		objUW.recreatedFlag = true;
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
var netOverride = "N";
var treatyOverride = "N";
function checkOverrideNetTreaty(){
	try{
		
		commonOverrideOkFunc = function(){
			changeTag=1;
			netOverride = postResult.paramFunction == "RO" ? "Y" :netOverride;
			treatyOverride = postResult.paramFunction == "TO" ? "Y" :treatyOverride;
			var id = getSelectedRowIdInTable("distListingDiv", "rowPrelimDist");
			objUW.hidObjGIUWS005.GIUWPolDist[id].varShare = postResult.newItems.varShare;	// changed from postResult : shan 06.17.2014
			objUW.hidObjGIUWS005.GIUWPolDist[id].postFlag = postResult.newItems.postFlag;	// changed from postResult : shan 06.17.2014
			objUW.hidObjGIUWS005.GIUWPolDist[id].distFlag = postResult.newItems.distFlag;	// changed from postResult : shan 06.17.2014
			objUW.hidObjGIUWS005.GIUWPolDist[id].meanDistFlag = postResult.newItems.meanDistFlag;	// changed from postResult : shan 06.17.2014
			objUW.hidObjGIUWS005.GIUWPolDist[id].autoDist = postResult.newItems.autoDist;	// added : shan 06.17.2014
			objUW.hidObjGIUWS005.GIUWPolDist[id].posted = "Y";
			objUW.hidObjGIUWS005.GIUWPolDist[id].recordStatus = 1;
			var content = prepareList(objUW.hidObjGIUWS005.GIUWPolDist[id]);
			$("rowPrelimDist"+id).update(content);
			$("txtC080DistFlag").value = postResult.distFlag;	// changed from postResult : shan 06.17.2014
			$("txtC080MeanDistFlag").value = postResult.meanDistFlag;	// changed from postResult : shan 06.17.2014
			checkAutoDist1(objUW.hidObjGIUWS005.GIUWPolDist[id]);
			//showMessageBox("Post Distribution Complete.", "S"); commented out edgar 05/13/2014
			for(var a=0; a<objUW.hidObjGIUWS005.GIUWPolDist[id].giuwWpolicyds.length; a++){
				var obj = new Object();
				obj.parId = objUW.hidObjGIUWS005.GIUWPolDist[id].parId;
				obj.distNo = objUW.hidObjGIUWS005.GIUWPolDist[id].giuwWpolicyds[a].distNo;
				obj.distSeqNo = objUW.hidObjGIUWS005.GIUWPolDist[id].giuwWpolicyds[a].distSeqNo;
				//obj.overrideSwitch = overrideSwitch;
				obj.process = "P";
				obj.processId = objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated.length;
				objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated.push(obj);
				//buttonLabel(objUW.hidObjGIUWS005.GIUWPolDist[id]);	
				//savePrelimOneRiskDist('P'); // moved to here - irwin 10.5.2012 //added by steven 2/19/2013;added a parameter 'P',nung nilipat siya kasi nakalimutang ilagay ung 'P'.
				if (a==(objUW.hidObjGIUWS005.GIUWPolDist[id].giuwWpolicyds.length-1)){	// added to call save function once checking is done : shan 05.29.2014
					if (nvl(postResult.donePosting,"N") == "Y"){
						checkAutoDist1(objUW.hidObjGIUWS005.GIUWPolDist[id]);
						buttonLabel(objUW.hidObjGIUWS005.GIUWPolDist[id]);
						postResult.donePosting = "N";
						postDistGiuws005Final(); //savePrelimOneRiskDist("P");	// changed by shan : 07.03.2014
						deselectRows("distListingDiv", "rowPrelimDist");
					}	
				}	
			}
			
		};
		commonOverrideNotOkFunc = function(){
			showWaitingMessageBox($("overideUserName").value+" does not have an overriding function for this module.", imgMessage.ERROR, 
					clearOverride);
		};	
		commonOverrideCancelFunc = function(){
			//overrideSwitch = "N";
		};
		function override(funcCode){	//added parameter : shan 06.17.2014
			try{
				/*objAC.funcCode = postResult.paramFunction;
				objACGlobal.calledForm = postResult.moduleId;
				getUserInfo();
				var title = postResult.netOverride != null ? postResult.netOverride :(postResult.treatyOverride != null ? postResult.treatyOverride :"Override");
				$("overlayTitle").innerHTML = title;*/	// replaced with codes below
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
														if (postResult.treatyOverride != null){
															if (postResult.overrideMsg != null){
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
																						postDistGiuws005Final();
																					}								
																				},
																				function(){
																					return false;
																				},
																				"Treaty Override");}, "");
															}
														}else{
															postDistGiuws005Final();
														}
												}, "");	
									}else{
										postDistGiuws005Final();
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
									postDistGiuws005Final();
								}								
							},
							function(){
								return false;
							},
							"Treaty Override");
				}
			}catch (e) {
				showErrorMessage("checkOverrideNetTreaty - override", e);
			}
		}	
		if (postResult.overrideMsg != null && ((netOverride == "N" && postResult.paramFunction == "RO") || (treatyOverride == "N" && postResult.paramFunction == "TO"))){
			/*overrideSwitch = "Y";
			/*showConfirmBox("Confirmation", postResult.overrideMsg, 
					"Override", "Cancel", override, "");*/ // replaced with codes below
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
		}else{
			//overrideSwitch = "N";
			//commonOverrideOkFunc();
			if (postResult.treatyMsg != null){
				showConfirmBox("Confirmation", postResult.treatyMsg, 
						"Yes", "No",
						function(){
									postDistGiuws005Final();
									commonOverrideOkFunc();
				},"");
			}else{
				commonOverrideOkFunc();
			}
		}	
		/*showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS, function (){//commented out showMessageBox("Post Distribution Complete.", "S") replaced with this edgar 05/13/2014
			isSavePressed = false;  // to indicate the [Save] button was not pressed edgar 05/13/2014
		});*/
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

		var objArray = objUW.hidObjGIUWS005.GIUWPolDist.clone();
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
		objParameters.giuwPolDistPostedRecreated	= prepareJsonAsParameter(objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated);
		objParameters.giuwPolDistRows 				= prepareJsonAsParameter(giuwPolDistRows);
		objParameters.giuwWpolicydsRows 			= prepareJsonAsParameter(giuwWpolicydsRows);
		objParameters.giuwWpolicydsDtlSetRows 		= prepareJsonAsParameter(giuwWpolicydsDtlSetRows);
		objParameters.giuwWpolicydsDtlDelRows 		= prepareJsonAsParameter(giuwWpolicydsDtlDelRows);
		objParameters.parId							= $("globalParId").value;
		objParameters.lineCd						= $("globalLineCd").value;
		objParameters.sublineCd						= $("globalSublineCd").value;
		objParameters.polFlag						= $("globalPolFlag").value;
		objParameters.parType						= $("globalParType").value;
		return objParameters;
	}catch(e){
		showErrorMessage("prepareObjParameters", e);
	}
}	

//started edgar 05/12/2014 for recomputation and adjusting on posting and saving	
function getTakeUpTerm (){
	var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;
	//for(var a=0; a<objArray.length; a++){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "getTakeUpTerm",
				parId : objArray.parId
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
	//}
	
}
//compares the distribution tables to gipi_witemperil for discrepancies before posting edgar 05/02/2014
function compareWitemPerilToDs (){
	var ok = true;
	//for(var i=0, length=objUW.hidObjGIUWS005.GIUWPolDist.length; i < length; i++){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "compareWitemPerilToDsGIUWS004",
				parId: objUW.hidObjGIUWS005.selectedGIUWPolDist.parId,
				distNo : objUW.hidObjGIUWS005.selectedGIUWPolDist.distNo
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
		/*if (!ok){
			break;
		}
	}*/
	if (!ok){
		return false;
	}else {
		return true;
	}
}


//checking if distribution records is from peril distribution 05/13/2014
function deleteReinsertGIUWS004 (){
	var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;
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
				/*clearForm();
				clearDistStatus(objUW.hidObjGIUWS005.GIUWPolDist);
				objUW.hidObjGIUWS005.GIUWPolDist = res.giuwPolDist;
				refreshForm(objUW.hidObjGIUWS005.GIUWPolDist);				
				var id = obj.divCtrId;
				for(var a=0; a<objUW.hidObjGIUWS005.GIUWPolDist.length; a++){
					if (objUW.hidObjGIUWS005.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUWS005.GIUWPolDist[a].recordStatus != -1){
						supplyDist(objUW.hidObjGIUWS005.GIUWPolDist[a]);
						$$("div[name='rowPrelimDist']").each(function(row){
							var ctrId = row.id.substr((row.id.length-1), row.id.length);
							fireEvent($("distListingDiv").down("div", ctrId), "click");
						});
					}
				}*/
			}
		});
	}
}
//for checking of expired portfolio share edgar 05/14/2014
function checkExpiredTreatyShare (){
	var ok = true;
	var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;
	//for(var a=0; a<objArray.length; a++){
			for(var b=0; b<objArray.giuwWpolicyds.length; b++){
					//Share
					for(var c=0; c<objArray.giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
						new Ajax.Request(contextPath + "/GIUWPolDistController", {
							method : "POST",
							parameters : {
								action: "getTreatyExpiry",
								lineCd : objArray.giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd,
								shareCd : objArray.giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd,
								parId: objArray.parId
							},
							asynchronous: false,
							evalScripts: true,
							onComplete : function(response){
								hideNotice();
								if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									var comp = JSON.parse(response.responseText);
									if (comp.vExpired == "Y"){
										showMessageBox("Treaty "+comp.treatyName +"  has already expired. Replace the treaty with another one.", imgMessage.ERROR);
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
				if (!ok){
					break;
				}
			}
			/*if (!ok){
				break;
			}
	}*/
	
	/*if (!ok){
		return false;
	}else {
		return true;
	}*/
	if (ok) {		
		if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up edgar 05/12/2014
			if (!compareWitemPerilToDs()) return false; // for comparison of ds table to itemperil table edgar 05/12/2014
		}
		var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;
		//for(var a=0; a<objArray.length; a++){
			if (objArray.postFlag == "P"){
				deleteReinsertGIUWS004();
				showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
						function(){
							//showMessageBox("Post Distribution Complete.", imgMessage.SUCCESS);
							isSavePressed = false;
							continuePost(); 
						});
			}else{
				//compareDelRinsrtWdistTable(); included in postDistGiuws005Final script
				continuePost(); 
			}
		//}			
	};
}
//ended edgar 05/12/2014

/*function compareDelRinsrtWdistTable(){
	//for(var i=0, length=objUW.hidObjGIUWS005.GIUWPolDist.length; i < length; i++){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "compareDelRinsrtWdistTable",
				distNo : objUW.hidObjGIUWS005.selectedGIUWPolDist.distNo
			},
			asynchronous: false,
			evalScripts: true,
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					
				}
			}
		});
	//}
}

function compareWdistTables(){
	var ok = false;
	//for(var i=0, length=objUW.hidObjGIUWS005.GIUWPolDist.length; i < length; i++){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "compareWdistTables",
				distNo : objUW.hidObjGIUWS005.selectedGIUWPolDist.distNo,
				parId : objUW.hidObjGIUWS005.selectedGIUWPolDist.parId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Comparing Working Distribution tables, please wait ...");
			},
			onComplete : function(response){
				hideNotice();
				ok = true;
			}
		});
		/*if(!ok){
			break;
		}
	}* /
	
	return ok;
}*/

//checks for posted binders edgar 06/20/2014
function checkPostedBinder (){
	var ok = true;
	//for(var i=0, length=objGIUWPolDist.length; i < length; i++){
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "checkPostedBinder",
				parId: objUW.hidObjGIUWS005.selectedGIUWPolDist.parId,
				distNo : objUW.hidObjGIUWS005.selectedGIUWPolDist.distNo,
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
		/*if (!ok){
			break;
		}
	}*/
	if (!ok){
		return false;
	}else {
		return true;
	}
}

function continuePost(){	//shan 05.16.2014
	try{				
		var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;
		prepareDistForSaving();
		var objParameters = new Object();
		objParameters = prepareObjParameters();			
		for(var a=0; a<objArray.giuwWpolicyds.length; a++){
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "postDistGiuws005",
					parId: $("globalParId").value,
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
						if(res.message.include("Geniisys Exception")){
							var message = res.message.split("#");
							showMessageBox(message[2], message[1]);
							return false;
						}
						if (res.message == "" && res.vMsgAlert == null){
							postResult = res;
							if (a==(objArray.giuwWpolicyds.length-1)) postResult.donePosting = "Y";
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
										"Yes", "No", checkOverrideNetTreaty, "");	//shan 06.17.2014 
							}else{
								if (/*res.treatyMsg*/ res.treatyOverride != null){
									netTreaty = "TREATY";
									showConfirmBox("Confirmation", res.treatyMsg, 
											"Yes", "No", checkOverrideNetTreaty, "");
								}else{
									checkOverrideNetTreaty();
								}	
							}	
							//savePrelimOneRiskDist('P'); moved	
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
	}catch(e){
		showErrorMessage("continuePost", e);
	}
}

function postDistGiuws005Final(){
	var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;
	prepareDistForSaving();
	var objParameters = new Object();
	objParameters = prepareObjParameters();	
	//for(var a=0; a<objArray.giuwWpolicyds.length; a++){
		new Ajax.Request(contextPath+"/GIUWPolDistController",{
			parameters:{
				action: "postDistGiuws005Final",
				parId: $("globalParId").value,
				distNo: objArray.distNo,//objArray.giuwWpolicyds[a].distNo,
				distSeqNo: null, //objArray.giuwWpolicyds[a].distSeqNo,
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
					var id = getSelectedRowIdInTable("distListingDiv", "rowPrelimDist");
					if (res.message != ""){
						changeTag = 0;
						var message = res.message.split("#"); 
						customShowMessageBox(message[2], message[1], "btnPostDist");
						return false; //showPreliminaryOneRiskDistByTsiPrem();
					}else{		
						postResult2 = res;	
						objUW.hidObjGIUWS005.GIUWPolDist[id].varShare = postResult2.newItems.varShare;
						objUW.hidObjGIUWS005.GIUWPolDist[id].postFlag = postResult2.newItems.postFlag;
						objUW.hidObjGIUWS005.GIUWPolDist[id].distFlag = postResult2.newItems.distFlag;
						objUW.hidObjGIUWS005.GIUWPolDist[id].meanDistFlag = postResult2.newItems.meanDistFlag;
						objUW.hidObjGIUWS005.GIUWPolDist[id].autoDist = postResult2.newItems.autoDist;
						showWaitingMessageBox("Post Distribution Complete.", imgMessage.SUCCESS, function (){
							isSavePressed = false;  // to indicate the [Save] button was not pressed edgar 05/13/2014
							savePrelimOneRiskDist("P");
						});
						refreshForm(objUW.hidObjGIUWS005.GIUWPolDist[id]);
					}
				}
			}
		});		
	//}	
}

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
					refreshForm(objUW.hidObjGIUWS005.selectedGIUWPolDist);
					disableButton("btnPostDist");
				}
			});
			if (objUW.hidObjGIUWS005.selectedGIUWPolDist != null) { //added call on checkAutoDist1 to change value of post button and auto dist flag edgar 05/12/2014
				checkAutoDist1(objUW.hidObjGIUWS005.selectedGIUWPolDist); 
			}
		}else {
			vProcess = "P"; //edgar 06/20/2014
			if (!checkPostedBinder()) return false;  //edgar 06/20/2014
			if (!checkDistFlag()) return false;
			if (!procedurePreCommit()) return false;
			if (!checkC1407TsiPremium()) return false;
			
			getTakeUpTerm(); //get take up term edgar 05/12/2014
			/*if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up edgar 05/12/2014; moved inside checkExpiredTreatyShare : shan 07.25.2014
				if (!compareWitemPerilToDs()) return false; // for comparison of ds table to itemperil table edgar 05/12/2014
			}*/
			postAdjust = "Y";// edgar for referencing adjustment of dist prem amounts edgar 05/13/2014			
			/*var objArray = objUW.hidObjGIUWS005.selectedGIUWPolDist;	// moved inside checkExpiredTreatyShare
			//for(var a=0; a<objArray.length; a++){
				if (objArray.postFlag == "P"){
					deleteReinsertGIUWS004();
					showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
							function(){
								//showMessageBox("Post Distribution Complete.", imgMessage.SUCCESS);
								isSavePressed = false;
								checkExpiredTreatyShare(continuePost);
							});
				}else{
					compareDelRinsrtWdistTable();
					checkExpiredTreatyShare(continuePost);
				}
			//}	*/
			checkExpiredTreatyShare();
		}
	}else{
		showMessageBox(/*"Changes is only available after changes have been saved."*/ objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
		return false;
	}
});	

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
	vProcess = "S"; //edgar 06/20/2014
	if (!checkPostedBinder()) return false; //edgar 06/20/2014
	if (param == null){	// added by shan 06.03.2014
		var objArray = objUW.hidObjGIUWS005.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			var reload = false;
			if (objArray.length == (a+1)){
				reload = true;
			}
			
			if (objArray[a].postFlag == "P"){
				deleteReinsertGIUWS004();
				showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
						function(){
							savePrelimOneRiskDist2(param, reload);
						}
				);
			}else{
				savePrelimOneRiskDist2(param, reload);
			}
		}	
	}else{
		savePrelimOneRiskDist2(param);
	}
	
}

function savePrelimOneRiskDist2(param, reload){
	try{
		if (!procedurePreCommit()){
			return false;	
		}	
		if (!checkC1407TsiPremium2()){
			return false;
		}	

		//for recomputation of distribution premium amounts if posting edgar 05/12/2014
		if (postAdjust == "N"){			
			postAdjust = "N";
			isSavePressed = true;
		}else {
			postAdjust = "N";
			isSavePressed = false;
		}
		
		//ended edgar 05/13/2014	
		
		prepareDistForSaving();
		
		var objParameters = new Object();
		objParameters = prepareObjParameters();
		objParameters.savePosting = nvl(param,null) == null ? "N" :"Y";
		objParameters.distNo = parseInt($F("txtC080DistNo"));
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "savePrelimOneRiskDistByTsiPrem",
				parameters : JSON.stringify(objParameters)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Saving Preliminary One-Risk Distribution by Tsi/Prem, please wait ...");
			},
			onComplete : function(response){
				hideNotice();
				var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
				if (checkErrorOnResponse(response)){
					if (res.message != "SUCCESS"){
						showMessageBox(res.message, imgMessage.ERROR);
					}else{
						objUW.hidObjGIUWS005.GIUWPolDistPostedRecreated.clear();
						changeTag = 0;
						if(isSavePressed){  // "Saving complete" should not be displayed if Post Distribution to Final/RI is pressed edagr 05/12/2014
							//adjustDistPrem(); //for recomputation of distribution premium amounts edgar 05/12/2014
							if (param != "P") showMessageBox(objCommonMessage.SUCCESS, "S");	
						}
						clearForm();
						clearDistStatus(objUW.hidObjGIUWS005.GIUWPolDist);
						objUW.hidObjGIUWS005.GIUWPolDist = res.giuwPolDist;
						refreshForm(objUW.hidObjGIUWS005.GIUWPolDist);
						if (reload) showPreliminaryOneRiskDistByTsiPrem();					
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("savePrelimOneRiskDist2", e);
	}
}	

observeReloadForm("reloadForm", showPreliminaryOneRiskDistByTsiPrem);
observeCancelForm("btnCancel", savePrelimOneRiskDist, (isPack == "Y") ? showPackParListing : showParListing);

observeSaveForm("btnSave", savePrelimOneRiskDist);

clearForm();
changeTag = 0;
initializeChangeTagBehavior(savePrelimOneRiskDist);
setDocumentTitle("Preliminary One-Risk Distribution by TSI/Prem");
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

$("summarizedDistDiv").hide();
</script>	