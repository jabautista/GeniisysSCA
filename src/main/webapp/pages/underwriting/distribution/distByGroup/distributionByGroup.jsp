<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="distributionByGroupMainDiv" name="distributionByGroupMainDiv" style="margin-top: 1px;">
	<div id="distributionByGroupMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="distributionByGroupQuery">Query</a></li>
					<li><a id="distributionByGroupExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="preliminaryOneRiskDistForm" name="preliminaryOneRiskDistForm">
		<jsp:include page="/pages/underwriting/distribution/distrCommon/distrPolicyInfoHeader.jsp"></jsp:include>
		<input type="button" id="dummyShowListing" value="hiddenTrigger" style="display: none;"/>
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
						<label id="lblTotalShare" style="text-align:right; width:25%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalTsiAmt" style="text-align:right; width:24%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalPremAmt" style="text-align:right; width:24%; float:left;" class="money">&nbsp;</label>
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
			<input type="button" id="btnViewDist"		name="btnViewDist"		class="button"	value="View Distribution" />
			<input type="button" id="btnPostDist" 		name="btnPostDist" 		class="button"	value="Post Distribution" />			
			<input type="button" id="btnSave" 			name="btnSave" 			class="button"	value="Save" />			
		</div>
	</form>
</div>	
<div id="summarizedDistDiv" style="display: none;"></div>
<script>
initializeAccordion();
addStyleToInputs();
initializeAll();
initializeAllMoneyFields();
//objUW.requery = 'N';
objUW.isPosted = 'N';

//for getting takeupterm edgar 05/12/2014
var takeUpTerm = "";
var isSavePressed =true; // to check whether the [Save] button was pressed or not base on GIUWS003 edgar 05/12/2014
var postAdjust = "N"; // to manipulate adjustment when saving/posting due to error in distSpct1 edgar 05/12/2014
var nullDistSpct1Exist; // for determining null and non-null distSpct1 edgar 05/13/2014

//objUW.distList = JSON.parse('${gipiPolbasicPolDistV1TableGrid}'.replace(/\\/g, '\\\\'));


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
					   '<label style="width: 25%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct,'') == '' ? '-' :formatToNthDecimal(obj.distSpct, 9/*14*/))+'</label>'+//changed round off from 14 to 9 edgar 05/13/2014
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
				if ($F("txtDistFlag") == '1' || $F("txtDistFlag") == '2'){ // added condition for dist flag 2 - irwin
					showListPerObj(objArray[a], a);
				}
			}	
		}catch(e){
			showErrorMessage("showList", e);
		}	
	}

	//create observe on Main list
	function loadMainListObserve(){
		$$("div#distListingDiv div[name=rowPrelimDist]").each(function(row){
			loadRowMouseOverMouseOutObserver(row);
			setClickObserverPerRow(row, 'distListingDiv', 'rowPrelimDist', 
					function(){
						var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
						for(var a=0; a<objUW.hidObjGIUWS013.GIUWPolDist.length; a++){
							if (objUW.hidObjGIUWS013.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUWS013.GIUWPolDist[a].recordStatus != -1){
								supplyDist(objUW.hidObjGIUWS013.GIUWPolDist[a]);
							}
						}
					}, 
					clearForm);
		});

		$$("div#distGroupListingDiv div[name=rowGroupDist]").each(function(row){
			loadRowMouseOverMouseOutObserver(row);
			setClickObserverPerRow(row, 'distGroupListingDiv', 'rowGroupDist', function(){supplyGroupDistPerRow(row);}, function(){supplyGroupDist(null);});
		});

		$$("div#distShareListingDiv div[name=rowShareDist]").each(function(row){
			loadRowMouseOverMouseOutObserver(row);
			setClickObserverPerRow(row, 'distShareListingDiv', 'rowShareDist', function(){supplyShareDistPerRow(row);}, clearShare);
		});
	}

	function clearForm(){
		try{
			supplyDist(null);
			supplyGroupDist(null);
			deselectRows("distListingDiv", "rowPrelimDist");
			deselectRows("distGroupListingDiv", "rowGroupDist");
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",Number($("txtDistNo").value));
			checkTableItemInfo("distListingTableDiv","distListingDiv","rowPrelimDist");
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}	
	
	function supplyDist(obj){
		try{
			supplyGroupDist(null);
			objUW.hidObjGIUWS013.selectedGIUWPolDist 	= obj==null?{}:obj;
			$("txtDistNo").value 						= nvl(obj==null?null:obj.distNo,'') == '' ? null :formatNumberDigits(obj.distNo,8);
			$("txtDistFlag").value 						= nvl(obj==null?null:obj.distFlag,'');
			$("txtMeanDistFlag").value 					= nvl(obj==null?null:obj.meanDistFlag,'');
			//$("txtC080MeanDistFlag").value 			= nvl(obj==null?null:obj.meanDistFlag,'');
			//$("txtC080MultiBookingMm").value 			= nvl(obj==null?null:obj.multiBookingMm,'');
			//$("txtC080MultiBookingYy").value 			= nvl(obj==null?null:obj.multiBookingYy,'');
			//buttonLabel(obj);
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",nvl(obj==null?null:obj.distNo,''));
			//checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,'')); // comment out by andrew - 12.11.2012
		}catch(e){
			showErrorMessage("supplyDist", e);
		}
	}	

	function supplyGroupDist(obj){
		try{
			objUW.hidObjGIUWS013.selectedGIUWWpolicyds	= obj==null?{}:obj;
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
			computeTotalAmount($("txtDistSeqNo").value);
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,''));
		}catch(e){
			showErrorMessage("supplyGroupDist", e);
		}
	}

	function supplyShareDist(obj){
		try{
			objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl	= obj==null?{}:obj;
			$("txtDspTrtyName").value						= unescapeHTML2(nvl(obj==null?'':obj.dspTrtyName,''));
			$("txtDistSpct").value							= nvl(obj==null?null:obj.distSpct,'') == '' ? null :formatToNthDecimal(obj.distSpct, 9/*14*/);//changed round off from 14 to 9 edgar 05/13/2014
			$("txtDistTsi").value							= nvl(obj==null?null:obj.distTsi,'') == '' ? null :formatCurrency(obj.distTsi);
			$("txtDistPrem").value							= nvl(obj==null?null:obj.distPrem,'') == '' ? null :formatCurrency(obj.distPrem);
			if (obj != null){
				if (obj.recordStatus == 0){
					enableButton("btnTreaty"); 
					enableButton("btnShare");
				}
			}	
			computeTotalAmount($("txtDistSeqNo").value);
		}catch(e){
			showErrorMessage("supplyShareDist", e);
		}
	}

	function computeTotalAmount(distSeqNo){
		try{
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var distSeqNo = nvl(distSeqNo,'')==''?'':Number(distSeqNo);
			var ctr = 0;
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
			var currGrp = {};
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1 && objArray[a].distNo == Number($F("txtDistNo"))){
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
			sumDistSpct = roundNumber(sumDistSpct, 9);
			objUW.hidObjGIUWS013.sumDistSpct = sumDistSpct;
			objUW.hidObjGIUWS013.sumDistTsi = sumDistTsi;
			objUW.hidObjGIUWS013.sumDistPrem = sumDistPrem;
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
			$("distShareTotalAmtMainDiv").down("label",1).update(formatToNthDecimal(sumDistSpct,9/*14*/).truncate(30, "..."));//commented out changed rounding off to 9 edgar 05/13/2014
			$("distShareTotalAmtMainDiv").down("label",2).update(formatCurrency(sumDistTsi).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",3).update(formatCurrency(sumDistPrem).truncate(30, "..."));
		}catch(e){
			showErrorMessage("computeTotalAmount", e);
		}
	}

	function getShareDefaults(param){
		try{
			if (param){
				$("btnAddShare").value = "Add";
				disableButton("btnDeleteShare");
				enableButton("btnTreaty");
				enableButton("btnShare");
			}else{
				$("btnAddShare").value = "Update";
				if (objUW.isPosted == 'N'){
					enableButton("btnDeleteShare");
				}	
				disableButton("btnTreaty");
				disableButton("btnShare");
			}	
		}catch(e){
			showErrorMessage("getShareDefaults", e);
		}
	}

	function supplyGroupDistPerRow(row){
		try{
			//getDefaults();
			var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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

	function clearShare(){
		try{
			supplyShareDist(null);
			getShareDefaults(true);
			deselectRows("distShareListingDiv", "rowShareDist");
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtDistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
		}catch(e){
			showErrorMessage("clearShare", e);
		}
	}

	function supplyShareDistPerRow(row){
		try{
			getShareDefaults(false);
			if (objUW.isPosted == 'N'){
				enableButton("btnAddShare");
			}
			var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var lineCd = row.readAttribute("lineCd");
			var shareCd = row.readAttribute("shareCd");
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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

	initPreTextOnField("txtDistSpct");
	$("txtDistSpct").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		if ($F("txtDistSeqNo") == "" || $F("txtDistSpct") == "") return;
		if (!checkIfValueChanged("txtDistSpct")) return;
		
		/*  Check that %Share is not greater than 100 */ 
		if (parseFloat($F("txtDistSpct")) > 100){
			customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct");
			return false;
		}	
		if (parseFloat($F("txtDistSpct")) <= 0){
			customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct");
			return false;
		}
 
		/* Compute DIST_TSI if the TSI amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtTsiAmt") != 0){
			$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtTsiAmt"),0));
			if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){
				customShowMessageBox("%Share is not sufficient enough to produce a valid amount for the Sum Insured.", "E", "txtDistTsi");
				return false;
			}	
		}else{
			$("txtDistTsi").value = formatToNthDecimal(0, 14);
		}
		
		/* Compute dist_prem  */
		$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));		
	});	

	/* Sum Insured */ 
	initPreTextOnField("txtDistTsi");
	$("txtDistTsi").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
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


	function addShare(){
		try{
			if ($F("txtDistNo") == ""){
				customShowMessageBox("Distribution no. is required.", "E", "txtDistNo");
				return false;
			}
			if ($F("txtDistSeqNo") == ""){
				customShowMessageBox("Group no. is required.", "E", "txtDistSeqNo");
				return false;
			}	
			if ($F("txtDspTrtyName") == ""){
				customShowMessageBox("Share is required.", "E", "txtDspTrtyName");
				return false;
			}
			if ($F("txtDistSpct") == ""){
				customShowMessageBox("% Share is required.", "E", "txtDistSpct");
				return false;
			}
			if ($F("txtDistTsi") == ""){
				customShowMessageBox("Sum insured is required.", "E", "txtDistTsi");
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
				if (roundNumber(unformatCurrency("txtDistTsi"), 2) == 0){
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

					var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 : 1;
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
					var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].recordStatus != -1){
							//Group
							for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
								if (objArray[a].giuwWpolicyds[b].distNo == distNo && objArray[a].giuwWpolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwWpolicyds[b].recordStatus != -1){
									//Share
									addNewJSONObject(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl, newObj);
									objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
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
						checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtDistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
						}
					});
				}	
				clearShare();
			}	
		}catch(e){
			showErrorMessage("addShare", e);
		}		
	}		

	function setShareObject() {
		try {
			var objGroup = objUW.hidObjGIUWS013.selectedGIUWWpolicyds;
			var obj = objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl;
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
			//newObj.annDistTsi			= (nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100;	//obj == null ? "" :nvl(obj.annDistTsi, "");
			newObj.annDistTsi			= roundNumber((nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100, 2);
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

	$("btnDeleteShare").observe("click",function(){
		deleteShare();
	});

	//function delete record
	function deleteShare(){
		try{
			if ($F("txtDistNo") == ""){
				customShowMessageBox("Distribution no. is required.", "E", "txtDistNo");
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
					var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
													checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtDistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
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

	function startLOV(id, title, objArray, width){
		try{
			var copyObj = objArray.clone();	
			var copyObj2 = objArray.clone();	
			var selGrpObjArray = objUW.hidObjGIUWS013.selectedGIUWWpolicyds.giuwWpolicydsDtl.clone();
			selGrpObjArray = selGrpObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
			var share = objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl;
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
					objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");;
					objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
					objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");;
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
			if (objUW.hidObjGIUWS013.globalParId == objUW.hidObjGIUWS013.selectedGIUWPolDist.parId && 
					objUW.hidObjGIUWS013.nbtLineCd == objUW.hidObjGIUWS013.selectedGIUWWpolicyds.nbtLineCd && 
					objUW.hidObjGIUWS013.lineCd == objGIPIPolbasicPolDistV1.lineCd){ return;}
			objUW.hidObjGIUWS013.globalParId = objUW.hidObjGIUWS013.selectedGIUWPolDist.parId;
			objUW.hidObjGIUWS013.nbtLineCd = objUW.hidObjGIUWS013.selectedGIUWWpolicyds.nbtLineCd;
			objUW.hidObjGIUWS013.lineCd = objGIPIPolbasicPolDistV1.lineCd;
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "getDistListing",
					globalParId: objUW.hidObjGIUWS013.selectedGIUWPolDist.parId,
					nbtLineCd: objUW.hidObjGIUWS013.selectedGIUWWpolicyds.nbtLineCd,
					lineCd: objGIPIPolbasicPolDistV1.lineCd//$F("globalLineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					objUW.hidObjGIUWS013.distListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				}	
			});	
		}catch(e){
			showErrorMessage("getListing", e);
		}
	}

	function saveOneRiskDist(param){
		try{
			if(checkBinderExist()){
				return;	
			}
			
			if (!procedurePreCommit()){
				return false;	
			}	
			if (!checkC1407TsiPremium()){
				return false;
			}	
			//added edgar 01/20/2015 to correct updating of dist_spct1
			function updateDistSpct1ToNull1(){
				var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
							
							clearDistStatus(objUW.hidObjGIUWS013.GIUWPolDist);
							objUW.hidObjGIUWS013.GIUWPolDist = res.giuwPolDist;
							refreshForm(objUW.hidObjGIUWS013.GIUWPolDist);
							if (nullDistSpct1Exist == "E"){
								nullDistSpct1Exist = "";
								saveDistributionChanges();
							}
						}
					});
				}
			}
			// modified by Kenneth L. 05/19/2014
			function saveDistributionChanges(){
				prepareDistForSaving();
				
				var objParameters = new Object();
				objParameters = prepareObjParameters();
				new Ajax.Request(contextPath + "/GIUWPolDistController", {
					method : "POST",
					parameters : {
						action: "saveOneRiskDistGiuws013",
						parameters : JSON.stringify(objParameters)
					},
					asynchronous: false,
					//evalScripts: true,
					onCreate : function(){
						showNotice("Saving One-Risk Distribution, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						if (checkErrorOnResponse(response)){
							if (res.message != "SUCCESS"){
								showMessageBox(res.message, "E");
							}else{
								changeTag = 0;
								adjustAllWTablesGIUWS004();
								enableButton("btnPostDist");
								
								if (param == "saveWithPost") {
									postDist();
								}else{
									showMessageBox(objCommonMessage.SUCCESS, "S");
								}
							}
						}
					}
				});
			}
			
			function confirmMessage(){
				if (nullDistSpct1Exist == "NE"){
					/* showConfirmBox("Confirm", "There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed. Do you want to continue?", "Continue", "Cancel",
							function(){
								adjustDistPrem();
								saveDistributionChanges();
							}, null
					); */
					showWaitingMessageBox('There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.', 'I', function(){
						nullDistSpct1Exist = "";
						adjustDistPrem();
						saveDistributionChanges();
					});
				}else if (nullDistSpct1Exist == "E"){
					//nullDistSpct1Exist = "";
					//updateDistSpct1ToNull(); 
					//saveDistributionChanges();
					updateDistSpct1ToNull1(); //commented out codes aboves replace with this code : edgar 01/20/2015
				}else{
					saveDistributionChanges();
				}
			}
			
			function checkPostFlag(){
				var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
				if(objArray.length > 0){
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].postFlag == "P"){
							showWaitingMessageBox('Distribution has been created using Peril Distribution. Distribution records will be recreated.', 'I', function(){
								updateDistSpct1ToNull();
								deleteReinsertGIUWS004();
								confirmMessage();
							});
						} else {
							confirmMessage();
						}
					}	
				} else {
					confirmMessage();
				}
			}
			
			getDistScpt1Val();
			
			if (postAdjust == "N"){
				//confirmMessage();
				checkPostFlag();
				postAdjust = "N";
				isSavePressed = true;
			}else {
				//confirmMessage();
				checkPostFlag();
				postAdjust = "N";
				isSavePressed = false;
			}
		}catch(e){
			showErrorMessage("saveOneRiskDist", e);
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
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist.clone();
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != null){
					objArray[a].effDate = nvl(objArray[a].effDate,"")=="" ? "" :dateFormat((objArray[a].effDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].expiryDate = nvl(objArray[a].expiryDate,"")=="" ? "" :dateFormat((objArray[a].expiryDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].createDate = nvl(objArray[a].createDate,"")=="" ? "" :dateFormat((objArray[a].createDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].negateDate = nvl(objArray[a].negateDate,"")=="" ? "" :dateFormat((objArray[a].negateDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].acctEntDate = nvl(objArray[a].acctEntDate,"")=="" ? "" :dateFormat((objArray[a].acctEntDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].acctNegDate = nvl(objArray[a].acctNegDate,"")=="" ? "" :dateFormat((objArray[a].acctNegDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].lastUpdDate = nvl(objArray[a].lastUpdDate,"")=="" ? "" :dateFormat((objArray[a].lastUpdDate), "mm-dd-yyyy HH:MM:ss TT");
					objArray[a].postDate = nvl(objArray[a].postDate,"")=="" ? "" :dateFormat((objArray[a].postDate), "mm-dd-yyyy HH:MM:ss TT"); // bonok :: 10.08.2012
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

	function procedurePreCommit(param){
		try{
			var ok = true;
			var ctr = 0;
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
			var tempDistTsi = 0;
			var tempDistPrem = 0;
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
									tempDistTsi = (parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0)) / 100) * nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0);
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(tempDistTsi);//parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0));
									tempDistPrem = (parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1,0)) / 100) * nvl(objArray[a].giuwWpolicyds[b].premAmt,0);
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(tempDistPrem);//parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0));
								}
							}
							function err(msg){
								objUW.hidObjGIUWS013.preCommit = "N";
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
							
							if (ctr == 0 && param == null){
								err("Distribution share cannot be null.");
								return false;
							}
							if ((/*acceptedRound*/roundNumber(sumDistSpct, 9/*14*/) != 100 || acceptedRound(sumDistTsi, 2) != acceptedRound(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2))/* && ctr == 1*/){//changed acceptedRound to roundNumber : edgar 12/04/2014
								err("Total % Share should be equal to 100.");
								return false;
							}
							if (param == 'P' && parseFloat($("lblTotalTsiAmt").innerHTML.replace(/,/g, "")) != unformatCurrency("txtTsiAmt")){
								err("Total sum insured must be equal to sum insured amount.");
								return false;
							}
							if (param == 'P' && parseFloat($("lblTotalPremAmt").innerHTML.replace(/,/g, "")) != unformatCurrency("txtPremAmt")){
								err("Total premium must be equal to premium amount.");
								return false;
							}
							if (param == 'P' && parseFloat($("lblTotalShare").innerHTML.replace(/,/g, "")) != '100'){
								err("Post distribution is only allowed if total percent share is equal to 100%.");
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

	function checkC1407TsiPremium(proc){
		try{
			var ok = true;
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
			//var recStat = objArray[a].giuwWpolicyds[b].recordStatus == null ?  
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								if (objArray[a].giuwWpolicyds[b].recordStatus == 1 || changeTag == 1){ //||  alert only if there is any changes in Shares
									//if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
										var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowPrelimDist");
										dist == "rowPrelimDist"+a ? null :fireEvent($("rowPrelimDist"+a), "click");
										dist == "rowPrelimDist"+a ? null :$("rowPrelimDist"+a).scrollIntoView();
										//disableButton("btnPostDist");
										showWaitingMessageBox("A share in group no. "+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+" cannot have both its TSI and premium share % equal to zero.", "E",
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

	function prepareObjParameters(){
		try{
			var objParameters = new Object();
			objParameters.giuwPolDistPostedRecreated	= prepareJsonAsParameter(objUW.hidObjGIUWS013.GIUWPolDistPostedRecreated);
			objParameters.giuwPolDistRows 				= prepareJsonAsParameter(giuwPolDistRows);
			objParameters.giuwWpolicydsRows 			= prepareJsonAsParameter(giuwWpolicydsRows);
			objParameters.giuwWpolicydsDtlSetRows 		= prepareJsonAsParameter(giuwWpolicydsDtlSetRows);
			objParameters.giuwWpolicydsDtlDelRows 		= prepareJsonAsParameter(giuwWpolicydsDtlDelRows);
			objParameters.parId							= objGIPIPolbasicPolDistV1.parId;//$("globalParId").value;
			objParameters.lineCd						= objGIPIPolbasicPolDistV1.lineCd;//$("globalLineCd").value;
			objParameters.sublineCd						= objGIPIPolbasicPolDistV1.sublineCd;//$("globalSublineCd").value;
			objParameters.polFlag						= objGIPIPolbasicPolDistV1.polFlag;//$("globalPolFlag").value;
			objParameters.parType						= objGIPIPolbasicPolDistV1.parType;//$("globalParType").value;
			objParameters.batchId						= objGIPIPolbasicPolDistV1.batchId;
			objParameters.policyId						= objGIPIPolbasicPolDistV1.policyId;
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}

	function postDist(){
		if(checkBinderExist()){
			return;
		}
		
		if (!procedurePreCommit("P")) return false;
		
		if (!checkC1407TsiPremium("P"))return false;
		
		if (checkItemPerilAmountAndShare())return false;
		
		getDistScpt1Val();
		
		if (isDiffPerilGroupShare() == "Y"){
			showConfirmBox("Confirm", "There are perils whose share % are different from the group distribution shares. Posting this distribution will recompute the distribution records based on policyds_dtl. Do you want to continue posting?", "Continue", "Cancel",
					function(){
						updateDistSpct1ToNull();
						deleteReinsertGIUWS004();
						adjustWorkingTables();
					}, function(){
						return false;
					}
				);
		} else {
			adjustWorkingTables();
		}
		
		function adjustWorkingTables(){
			adjustAllWTablesGIUWS004();
			getTakeUpTerm();
			postAdjust = "Y";
			
			if (nullDistSpct1Exist == "NE"){
				showConfirmBox("Confirm", "There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed. Do you want to continue posting?", "Continue", "Cancel",
						function(){
							adjustDistPrem();
							proceedDistribution();
						}, function(){
							return false;
						}
					);
			} else {
				proceedDistribution();
			}	
		}
		
		function proceedDistribution(){
			var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].postFlag == "P"){
					showConfirmBox("Confirm", "Distribution has been created using Peril Distribution. Distribution records will be recreated. Do you want to continue posting?", "Continue", "Cancel",
							function(){
								updateDistSpct1ToNull();
								deleteReinsertGIUWS004();
								checkExpiredTreatyShare(continuePost);
							}, function(){
								null;
							}
						);
				}else{
					checkExpiredTreatyShare(continuePost);
				}
			}	
		}
	}
	
	function continuePost(){
		var objArray = objUW.hidObjGIUWS013.selectedGIUWPolDist;
			
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method: 'POST',
			parameters:{
				action: "postDistGiuws013",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo,
				endtSeqNo: objGIPIPolbasicPolDistV1.endtSeqNo,
				effDate:  dateFormat(objGIPIPolbasicPolDistV1.effDate, "mm-dd-yyyy"),
				batchId: objGIPIPolbasicPolDistV1.batchId,
				lineCd: objGIPIPolbasicPolDistV1.lineCd,
				sublineCd: objGIPIPolbasicPolDistV1.sublineCd,
				issCd:  objGIPIPolbasicPolDistV1.issCd,
				issueYy: objGIPIPolbasicPolDistV1.issueYy,
				polSeqNo: objGIPIPolbasicPolDistV1.polSeqNo,
				renewNo: objGIPIPolbasicPolDistV1.renewNo,
				lineCd: objGIPIPolbasicPolDistV1.lineCd,
				distSeqNo: $F("txtDistSeqNo"),
				parId: objGIPIPolbasicPolDistV1.parId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Posting please wait...");
			},
			onComplete: function (response){
				var result = response.responseText;
				var msg = nvl(result, "N") == "Y" || nvl(result, "N") == "N" ? "SUCCESS" : result; 
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (msg != "SUCCESS") {
						showMessageBox(msg);
					}else{
						showMessageBox("Post Distribution Complete.", imgMessage.SUCCESS);
						setStateToPosted(result);
					}	
				}
			}
		});
	}
	
	function setStateToPosted(withFacul){
		objUW.isPosted = 'Y';
		objUW.hidObjGIUWS013.GIUWPolDist[0].distFlag = nvl(withFacul, "N") == "Y" ?  2 : 3;
		objUW.hidObjGIUWS013.GIUWPolDist[0].meanDistFlag = nvl(withFacul, "N") == "Y" ?  "With Facultative" : "Distributed";
		$("txtDistFlag").value = objUW.hidObjGIUWS013.GIUWPolDist[0].distFlag;
		$("txtMeanDistFlag").value = objUW.hidObjGIUWS013.GIUWPolDist[0].meanDistFlag;
		disableEnableButtons();
		$$("div#distListingDiv div[name=rowPrelimDist]").each(function(row){
			if(row.hasClassName("selectedRow")){
				row.down("label", 1).innerHTML = ($F("txtDistFlag") + "-" + $F("txtMeanDistFlag")),truncate(30, '...');
			}
		});
	}
	
	function disableEnableButtons(){
		if ($F("txtDistFlag") != '1'){
			disableButton("btnPostDist");
			disableButton("btnSave");
			disableButton("btnAddShare");
			disableButton("btnTreaty");
			disableButton("btnShare");
			disableButton("btnDeleteShare");
			
			if($F("txtDistFlag") == "2"){
				if ($("showDistGroup").innerHTML == "Show") {
					fireEvent($("showDistGroup"), "click");
				}
				if ($("showDistShare").innerHTML == "Show") {
					fireEvent($("showDistShare"), "click");
				}
				//enableButton('btnPostDist');
				enableButton("btnSave");
			}else{
				if ($("showDistGroup").innerHTML == "Hide") {
					fireEvent($("showDistGroup"), "click");
				}
				if ($("showDistShare").innerHTML == "Hide") {
					fireEvent($("showDistShare"), "click");
				}
			}
			
		}else{
			enableButton('btnPostDist');
			enableButton("btnSave");
			if ($("showDistGroup").innerHTML == "Show") {
				fireEvent($("showDistGroup"), "click");
			}
			if ($("showDistShare").innerHTML == "Show") {
				fireEvent($("showDistShare"), "click");
			}
		}

		if ($F("txtEndtNo") != ""){
			if(checkUserModule("GIPIS130")) {
				enableButton("btnViewDist");
			}
		}else{
			disableButton("btnViewDist");
		}
	}
	
	function disableAllButtons(){
		disableButton("btnTreaty");
		disableButton("btnShare");
		disableButton("btnViewDist");
		disableButton("btnPostDist");
		disableButton("btnAddShare");
		disableButton("btnDeleteShare");
		disableButton("btnSave");
	}

	//started edgar 05/12/2014 for recomputation and adjusting on posting and saving	
	function getTakeUpTerm (){
		var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
	
	//compares the distribution tables to gipi_witemperil for discrepancies before posting edgar 05/02/2014
	function compareWitemPerilToDs (){
		var ok = true;
		for(var i=0, length=objUW.hidObjGIUWS013.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "comparePolItmperilToDs",
					policyId: objUW.hidObjGIUWS013.GIUWPolDist[i].policyId,
					distNo : objUW.hidObjGIUWS013.GIUWPolDist[i].distNo
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
		var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
		var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
					/* showWaitingMessageBox("There are records which have different distribution share % between TSI and premium. Distribution premium amounts will be recomputed.", "I", 
							function(){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								isSavePressed = false;
							}); */
					//clearForm();
					clearDistStatus(objUW.hidObjGIUWS013.GIUWPolDist);
					objUW.hidObjGIUWS013.GIUWPolDist = res.giuwPolDist;
					//refreshForm(objUW.hidObjGIUWS013.GIUWPolDist);
				}
			});
		}
	}
	
	//updates distSpct1 to null if all records have equal distSpct and distSpct1 edgar 05/13/2014
	function updateDistSpct1ToNull(){
		var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
					//var res = JSON.parse(response.responseText);	
					//clearForm();
					//clearDistStatus(objUW.hidObjGIUWS013.GIUWPolDist);
					//objUW.hidObjGIUWS013.GIUWPolDist = res.giuwPolDist;
					//refreshForm(objUW.hidObjGIUWS013.GIUWPolDist);
				}
			});
		}
	}
	
	//for adjusting distribution tables edgar 05/13/2014
	function adjustAllWTablesGIUWS004(){
		var ok = false;
		for(var i=0, length=objUW.hidObjGIUWS013.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustAllWTablesGIUWS004",
					distNo : objUW.hidObjGIUWS013.GIUWPolDist[i].distNo,
					parId : objUW.hidObjGIUWS013.GIUWPolDist[i].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Adjusting Preliminary Peril Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					objUW.hidObjGIUWS013.GIUWPolDistPostedRecreated.clear();
					clearDistStatus(objUW.hidObjGIUWS013.GIUWPolDist);
					rePopulateHidObjGIUWS013GIUWPoldist();
					ok = true;
				}
			});
			if(!ok){
				break;
			}
		}
		return ok;
	}
	
	//checking if distribution records is from peril distribution 05/13/2014
	function deleteReinsertGIUWS004 (){
		var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
					//var res = JSON.parse(response.responseText);
					//clearForm();
					//clearDistStatus(objUW.hidObjGIUWS013.GIUWPolDist);
					//objUW.hidObjGIUWS013.GIUWPolDist = res.giuwPolDist;
					//refreshForm(objUW.hidObjGIUWS013.GIUWPolDist);
					//rePopulateHidObjGIUWS013GIUWPoldist();
				}
			});
		}
	}

	//for checking of expired portfolio share edgar 05/14/2014
	function checkExpiredTreatyShare (funct){
		var ok = true;
		var objArray = objUW.hidObjGIUWS013.GIUWPolDist;
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
									parId: objArray[a].parId
								},
								asynchronous: false,
								evalScripts: true,
								onComplete : function(response){
									hideNotice();
									if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
										var comp = JSON.parse(response.responseText);
										/* if (dateFormat((comp.expiryDate), "mm-dd-yyyy") <  dateFormat((objArray[a].effDate), "mm-dd-yyyy") && comp.portfolioSw == "P"){ */
									    if(comp.vExpired == "Y"){
											showMessageBox("Treaty " + comp.treatyName + " has already expired. Replace the treaty with another one.", imgMessage.ERROR);
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
			if (adjustAllWTablesGIUWS004()){
				funct();
			}
		}
	}
	//ended edgar 05/12/2014
	
	$("btnPostDist").observe("click", function(){
		/* new Ajax.Request(contextPath + "/GIUWPolDistController", {
			parameters : {
				action : "validateRenumItemNos",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					if (changeTag == 0){
						postDist();
					}else{
						showConfirmBox2("Confirm", "Whatever changes made in the form will be saved.  Do you wish to continue?", "Ok", "Cancel", function () {
																																					saveOneRiskDist("saveWithPost");
						}, "");
					}
				}
			}
		}); */
		if (changeTag == 0){
			postDist();
		}else{
			showConfirmBox2("Confirm", "Whatever changes made in the form will be saved.  Do you wish to continue?", "Ok", "Cancel", function () {
																																		saveOneRiskDist("saveWithPost");
			}, "");
		}
	});	

	observeSaveForm("btnSave", saveOneRiskDist);

	
	$("btnAddShare").observe("click", function(){
		addShare();
	});

    /* 	$("btnShare").observe("click", function(){
		getListing();
		var objArray = objUW.hidObjGIUWS013.distListing.distShareListingJSON;
		startLOV("GIUWS013-Share", "Share", objArray, 540);
	}); */

	/*  $("btnTreaty").observe("click", function(){
		getListing();
		var objArray = objUW.hidObjGIUWS013.distListing.distTreatyListingJSON;
		startLOV("GIUWS013-Treaty", "Treaty", objArray, 540);	
	}); */

	// andrew - 05.17.2012 - changed to LOV.show
	$("btnShare").observe("click", function(){
		var notIn = "";
		$$("div#distShareListingDiv div[name='rowShareDist']").each(function(row){
			if(parseInt($F("txtDistSeqNo")) == parseInt(row.getAttribute("distseqno"))){ // added by jeffdojello 01.24.2014 SR-14853
				if(notIn != ""){
					notIn += ",";
				}
				notIn += row.getAttribute("shareCd");
			}
		});
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getDistShareLOV",
							nbtLineCd : objUW.hidObjGIUWS013.selectedGIUWWpolicyds.nbtLineCd,
							lineCd: objGIPIPolbasicPolDistV1.lineCd,
							notIn : notIn,
							page : 1},
			title: "Share",
			width: 500,
			height: 350,
			columnModel : [	{	id : "trtyCd",
								title: "Code",
								width: '100px'
							},
							{	id : "trtyName",
								title: "Share",
								width: '250px'
							},
							{	id : "lineCd",
								title: "Line",
								width: '100px',
								sortable: false
							}
						],
			draggable: true,
			onSelect: function(row){				
				$("txtDspTrtyName").value = unescapeHTML2(row.trtyName);
				$("txtDspTrtyName").focus();
				objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.lineCd = row.lineCd;
				objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.shareCd = nvl(row.shareCd, row.trtyCd);
				objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.nbtShareType = row.shareType;
			}
		  });
	});
	
	$("btnTreaty").observe("click", function(){
		var notIn = ""; // added by: Nica 1.17.2013
		$$("div#distShareListingDiv div[name='rowShareDist']").each(function(row){
			if(parseInt($F("txtDistSeqNo")) == parseInt(row.getAttribute("distseqno"))){ // added by jeffdojello 01.24.2014 SR-14853
				if(notIn != ""){
					notIn += ",";
				}
				notIn += row.getAttribute("shareCd");
			}
			
		});
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getDistTreatyLOV",
							policyId: objUW.hidObjGIUWS013.selectedGIUWPolDist.policyId,
							lineCd: objGIPIPolbasicPolDistV1.lineCd,
							notIn : notIn,
							page : 1},
			title: "Treaty",
			width: 500,
			height: 350,
			columnModel : [	{	id : "trtyCd",
								title: "Code",
								width: '100px'
							},
							{	id : "trtyName",
								title: "Share",
								width: '200px'
							},
							{	id : "trtyYy",
								title: "Year",
								width: '80px',
								align: 'right',
								titleAlign: 'right'
							},
							{	id : "lineCd",
								title: "Line",
								width: '80px',
								sortable: false
							}
						],
			draggable: true,
			onSelect: function(row){				
				$("txtDspTrtyName").value = unescapeHTML2(row.trtyName);
				$("txtDspTrtyName").focus();
				objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.lineCd = row.lineCd;
				objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.shareCd = nvl(row.shareCd, row.trtyCd);
				objUW.hidObjGIUWS013.selectedGIUWWpolicydsDtl.nbtShareType = row.shareType;
			}
		  });
	});
	
	$("dummyShowListing").observe("click", function(){
		($("distListingDiv").childElements()).each(function(row) {
			row.remove();
		});
		
		($("distGroupListingDiv").childElements()).each(function(row) {
			row.remove();
		});
		
		($("distShareListingDiv").childElements()).each(function(row) {
			row.remove();
		});
		
		showList(objUW.hidObjGIUWS013.GIUWPolDist);
		loadMainListObserve();
		objUW.isPosted = 'N';
		disableEnableButtons();
		fireEvent($("distListingDiv").down("div", 0), "click");
		fireEvent($("distGroupListingDiv").down("div", 0), "click");
	});
	
	function showGIUWS013PolbasicPolDistV1LOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIUWS013PolicyListing",
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
								//filterOption: true,
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
								 	//resetDivs();
								 	objGIPIPolbasicPolDistV1 = row;
									populateDistrPolicyInfoFields(row);
									loadDistributionByGroups();
							 }
				  		}
					});
	} 
	
	$("hrefPolicyNo").observe("click", function(){
		showGIUWS013PolbasicPolDistV1LOV(); // andrew - 11.29.2012 - changed the policy listing loading 
		//showPolbasicPolDistV1Listing("showPolbasicPolOneRiskDistV1Listing");
	});
	
	$("distributionByGroupExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});
	
	function refreshForm(objArray){
		try{
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareList(objArray[a]);
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				objArray[a].posted = "N";
				$("rowPrelimDist"+a) ? $("rowPrelimDist"+a).update(content) : null;
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
	
	$("btnViewDist").observe("click", function() {
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			callGIPIS130();
		}
	});
	
	function callGIPIS130(){
		objGIPIS130.details = {};
		objGIPIS130.details.withBinder = checkBinderExist("View") ? "Y" : "N";
		objGIPIS130.details.lineCd = $F("txtPolLineCd");
		objGIPIS130.details.sublineCd = $F("txtPolSublineCd");
		objGIPIS130.details.issCd = $F("txtPolIssCd");
		objGIPIS130.details.issueYy = $F("txtPolIssueYy");
		objGIPIS130.details.polSeqNo = $F("txtPolPolSeqNo");
		objGIPIS130.details.renewNo = $F("txtPolRenewNo");
		objGIPIS130.distNo = $F("txtDistNo");
		objGIPIS130.distSeqNo = $F("txtDistSeqNo");
		objUWGlobal.previousModule = "GIUWS013";
		showViewDistributionStatus();
	}
	
	function rePopulateHidObjGIUWS013GIUWPoldist(){
		new Ajax.Request(contextPath + "/GIUWPolDistController?action=loadDistByGroupsGIUWS013JSON", {
			method: "GET",
			parameters: {
				parId: objGIPIPolbasicPolDistV1.parId,
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				objUW.hidObjGIUWS013.GIUWPolDist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				refreshForm(objUW.hidObjGIUWS013.GIUWPolDist);
				computeTotalAmount($("txtDistSeqNo").value);
			}
		});
	}
	
	observeReloadForm("reloadForm", showDistributionByGroup);
	observeReloadForm("distributionByGroupQuery", showDistributionByGroup); // andrew - 12.5.2012
	initializeChangeTagBehavior(saveOneRiskDist);
	
	fireEvent($("showDistGroup"), "click");
	fireEvent($("showDistShare"), "click");
	disableAllButtons();
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
	
	if(nvl('${loadRecords}', 'N') == "Y"){
		populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
		loadDistributionByGroups();
		$("showDistGroup").innerHTML = "Show";
		$("showDistShare").innerHTML = "Show";
	}
	
	function checkBinderExist(param){
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
							if(param != "View"){
								postBinderExist();
								showWaitingMessageBox('Cannot update distribution records. There are distribution groups with posted binders.', 'I', function(){
									fireEvent($("showDistGroup"), "click");
									fireEvent($("showDistShare"), "click");
									disableEnableButtons();
								});	
							}
						}
					}
				}
			});
			return exists;
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
				distNo : $F("txtDistNo"),
				moduleId : "GIUWS013"
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
	
	function isDiffPerilGroupShare(){
		try{
			var isDiff = "N";
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "checkIfDiffPerilGroupShare",
					distNo : objGIPIPolbasicPolDistV1.distNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							isDiff = "Y";
						}
					}
				}
			});
			return isDiff;
		} catch(e){
			showErrorMessage("isDiffPerilGroupShare", e);
		}
	}
	
	function postBinderExist(){
		changeTag = 0;
		changeTagFunc = "";
		showDistributionByGroup();
		populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
		objUW.hidObjGIUWS013.GIUWPolDist = objUW.hidObjGIUWS013.GIUWPolDistClone;
		showList(objUW.hidObjGIUWS013.GIUWPolDist);
		loadMainListObserve();
	}
</script>