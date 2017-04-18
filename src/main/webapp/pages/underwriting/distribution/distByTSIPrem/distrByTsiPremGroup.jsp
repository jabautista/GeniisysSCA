<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="summarizedDistDiv">
</div>
<div id="distrByTsiPremGroupMainDiv" name="distributionByGroupMainDiv" style="margin-top: 1px;">
	<div id="distrByTsiPremGroupMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="distrByTsiPremGroupQuery">Query</a></li>
					<li><a id="distrByTsiPremGroupExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="distrByTsiPremGroupForm" name="distrByTsiPremGroupForm">
		<jsp:include page="/pages/underwriting/distribution/distrCommon/distrPolicyInfoHeader.jsp"></jsp:include>
		<input type="button" id="dummyShowListing" value="hiddenTrigger" style="display: none;"/>
		<div id="distrByTsiPremGroupDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Group</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistGroup" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			<div id="distrByTsiPremGroupMain" class="sectionDiv" style="border: 0px;">	
				<div id="distrByTsiPremGroupDiv1" class="sectionDiv" style="display: block;">
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
				<div id="distrByTsiPremGroupDiv2" class="sectionDiv" style="display: block;">
					<div id="distGroupListingTableDiv" style="width: 800px; margin:auto; margin-top:10px;">
						<div class="tableHeader">
							<label style="width: 12%; text-align: right; margin-right: 5px;">Group No.</label> <!-- Sequence</label> changed by robert SR 5053 12.21.15  -->
							<label style="width: 30%; text-align: right; margin-right: 5px;" id="grpTSIHdrLbl">Group TSI</label> <!-- Sum Insured</label>  changed by robert SR 5053 12.21.15 -->
							<label style="width: 30%; text-align: right; margin-right: 10px;">Group  Premium</label> <!-- changed by robert SR 5053 12.21.15 -->
							<label style="width: 25%; text-align: left; ">Currency</label>
						</div>
						<div id="distGroupListingDiv" name="distGroupListingDiv" class="tableContainer">
								
						</div>
					</div>
					<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
						<tr>
							<td class="rightAligned">Group No. <!-- Sequence --></td> <!-- changed by robert SR 5053 12.21.15 -->
							<td class="leftAligned">
								<input class="rightAligned" type="text" id="txtDistSeqNo" name="txtDistSeqNo" value="" style="width:90px;" readonly="readonly"/>
							</td>
							<td class="rightAligned" style="width: 120px;" id="grpTSILbl">Group TSI<!-- Sum Insured --></td> <!-- changed by robert SR 5053 12.21.15 -->
							<td class="leftAligned">
								<input type="text" id="txtTsiAmt" name="txtTsiAmt" value="" style="width:180px;" readonly="readonly" class="money"/>
							</td>
							<td class="rightAligned" style="width: 100px;">Group Premium</td> <!-- changed by robert SR 5053 12.21.15 -->
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
						<label style="width: 20%; text-align: left; margin-right: 3px; margin-left: 5px;">Share</label>
						<label style="width: 19.5%; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 19%; text-align: right; margin-right: 5px;" id="shareTSIHdrLbl">Sum Insured</label>
						<label style="width: 19.5%; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 19%; text-align: right; ">Premium</label>
					</div>
					<div id="distShareListingDiv" name="distShareListingDiv" style="margin:10px; margin-top:0px;" class="tableContainer">
							
					</div>
				</div>
				<div id="distShareTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
					<div id="distShareTotalAmtDiv" style="width:100%;">
						<label style="text-align:left; width:20%; margin-right: 3px; margin-left: 5px; float:left;">Total:</label>
						<label id="lblTotalTSIShare" style="text-align:right; width:19.5%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalTsiAmt" style="text-align:right; width:19%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalPremShare" style="text-align:right; width:19.5%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalPremAmt" style="text-align:right; width:19%; float:left;" class="money">&nbsp;</label>
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
							<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct1" name="txtDistSpct1" value="" style="width:250px;" maxlength="13" readonly="readonly"/>
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
			<input type="button" id="btnCancel" 	    name="btnCancel" 		class="button"	value="Cancel" />
			<input type="button" id="btnSave" 			name="btnSave" 			class="button"	value="Save" />	
		</div>
	</form>
</div>	
<script>
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	objUW.isPosted = 'N';
	objUW.hidObjGIUWS016 = {};
	objUW.hidObjGIUWS016.errorSw = "N";
	changeTag = 0;
	disableEnableButtons();
	$("summarizedDistDiv").hide();
	
	//for getting takeupterm
	var takeUpTerm = "";
	
	function prepareMainDistrList(obj){
		try{
			var list = '<label style="width: 20%; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
					   '<label style="width: 35%; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+'-'+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
					   '<label style="width: 35%; text-align: left; ">'+nvl(obj.multiBookingMm,'')+'-'+nvl(obj.multiBookingYy,'')+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareMainDistrList", e);
		}	
	}
	
	function prepareDistrGrpList(obj){
		try{
			var list = '<label style="width: 12%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSeqNo,'') == '' ? '-' :formatNumberDigits(obj.distSeqNo,5))+'</label>'+
					   '<label style="width: 30%; text-align: right; margin-right: 5px;">'+(nvl(obj.tsiAmt,'') == '' ? '-' :formatCurrency(obj.tsiAmt))+'</label>'+
					   '<label style="width: 30%; text-align: right; margin-right: 11px;">'+(nvl(obj.premAmt,'') == '' ? '-' :formatCurrency(obj.premAmt))+'</label>'+
					   '<label style="width: 25%; text-align: left; ">'+nvl(obj.currencyDesc,'-')+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareDistrGrpList", e);
		}	
	}
	
	function prepareDistrShareList(obj){
		try{
			var list = '<label style="width: 20%; text-align: left; margin-right: 3px; margin-left: 5px;">'+unescapeHTML2(nvl(obj.dspTrtyName,'-'))+'</label>'+
					   '<label style="width: 19.5%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct,'') == '' ? '-' :formatToNthDecimal(obj.distSpct, 9))+'</label>'+
					   '<label style="width: 19%; text-align: right; margin-right: 5px;">'+(nvl(obj.distTsi,'') == '' ? '-' :formatCurrency(obj.distTsi))+'</label>'+
					   '<label style="width: 19.5%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct1,'') == '' ? (nvl(obj.distSpct,'') == '' ? '-' : formatToNthDecimal(obj.distSpct, 9)) : formatToNthDecimal(obj.distSpct1, 9))+'</label>'+
					   '<label style="width: 19%; text-align: right; ">'+(nvl(obj.distPrem,'') == '' ? '-' :formatCurrency(obj.distPrem))+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList3", e);
		}	
	}
	
	function showDistrDetailsList(obj){
		var tableGroupContainer = $("distGroupListingDiv");
		var ctr = 0;
		
		//Group
		for(var b=0; b<obj.giuwWpolicyds.length; b++){
			var content = prepareDistrGrpList(obj.giuwWpolicyds[b]);
			var newDiv = new Element("div");
			obj.giuwWpolicyds[b].recordStatus = null;
			newDiv.setAttribute("id", "rowGroupDist"+obj.giuwWpolicyds[b].distNo+""+obj.giuwWpolicyds[b].distSeqNo);
			newDiv.setAttribute("name", "rowGroupDist");
			newDiv.setAttribute("distNo", obj.giuwWpolicyds[b].distNo);
			newDiv.setAttribute("distSeqNo", obj.giuwWpolicyds[b].distSeqNo);
			newDiv.addClassName("tableRow");
			newDiv.update(content);
			tableGroupContainer.insert({bottom : newDiv});
			setDistrGroupRowObserver(newDiv);
			ctr++;
	
			//Share
			if(nvl(objUW.hidObjGIUWS016.errorSw, "N") == "N"){
				for(var c=0; c<obj.giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
					createDistrShareRow(obj.giuwWpolicyds[b].giuwWpolicydsDtl[c]);
					obj.giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus = null;
				}
			}	
		}
		fireEvent($("distListingDiv").down("div", 0), "click");
		if(ctr>0){
			fireEvent($("distGroupListingDiv").down("div", 0), "click");
		}
		if ($("showDistGroup").innerHTML == "Show") {
			fireEvent($("showDistGroup"), "click");
		}
		if ($("showDistShare").innerHTML == "Show") {
			fireEvent($("showDistShare"), "click");
		} 
	}
	
	function createDistrShareRow(obj){
		var tableShareContainer = $("distShareListingDiv");
		var content = prepareDistrShareList(obj);
		var newDiv = new Element("div");
		
		newDiv.setAttribute("id", "rowShareDist"+obj.distNo+""+obj.distSeqNo+""+obj.lineCd+""+obj.shareCd);
		newDiv.setAttribute("name", "rowShareDist");
		newDiv.setAttribute("distNo", obj.distNo);
		newDiv.setAttribute("distSeqNo", obj.distSeqNo);
		newDiv.setAttribute("lineCd", obj.lineCd);
		newDiv.setAttribute("shareCd", obj.shareCd);
		newDiv.addClassName("tableRow");
		newDiv.update(content);
		tableShareContainer.insert({bottom : newDiv});
		setDistrShareRowObserver(newDiv);
	}
	
	function loadDistrListings(objArray){
		try{
			$("distListingDiv").update("");
			$("distGroupListingDiv").update("");
			$("distShareListingDiv").update("");
			
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareMainDistrList(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				objArray[a].posted = "N";
				newDiv.setAttribute("id", "rowDistr"+a);
				newDiv.setAttribute("name", "rowDistr");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				setMainDistrRowObserver(newDiv, objArray[a]);
				$("distListingDiv").insert({bottom : newDiv});
	
				// show giuw_wpolicyds and giuw_wpolicyds_dtl listings
				showDistrDetailsList(objArray[a]);
				
			}	
		}catch(e){
			showErrorMessage("loadDistrListings", e);
		}	
	}
	
	function setMainDistrRowObserver(row, obj){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distListingDiv', 'rowDistr', function(){supplyDist(obj);}, clearForm); 
	}
	
	function setDistrGroupRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distGroupListingDiv', 'rowGroupDist', function(){supplyGroupDistPerRow(row);}, function(){supplyGroupDist(null);});
	}
	
	function setDistrShareRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distShareListingDiv', 'rowShareDist', function(){supplyShareDistPerRow(row);}, clearShare);
	}
	
	function supplyDist(obj){
		try{
			supplyGroupDist(null);
			objUW.hidObjGIUWS016.selectedGIUWPolDist = obj==null?{}:obj;
			$("txtDistNo").value 					 = nvl(obj==null?null:obj.distNo,'') == '' ? null :formatNumberDigits(obj.distNo,8);
			$("txtDistFlag").value 					 = nvl(obj==null?null:obj.distFlag,'');
			$("txtMeanDistFlag").value 			     = nvl(obj==null?null:obj.meanDistFlag,'');
			disableEnableButtons();
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",nvl(obj==null?null:obj.distNo,''));
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,''));
		}catch(e){
			showErrorMessage("supplyDist", e);
		}
	}
	
	function supplyGroupDist(obj){
		try{
			objUW.hidObjGIUWS016.selectedGIUWWpolicyds	= obj==null?{}:obj;
			$("txtDistSeqNo").value 	= nvl(obj==null?null:obj.distSeqNo,'') == '' ? null :formatNumberDigits(obj.distSeqNo,5);
			$("txtTsiAmt").value 		= nvl(obj==null?null:obj.tsiAmt,'') == '' ? null :formatCurrency(obj.tsiAmt);
			$("txtPremAmt").value 		= nvl(obj==null?null:obj.premAmt,'') == '' ? null :formatCurrency(obj.premAmt);
			$("lblCurrency").innerHTML	= unescapeHTML2(nvl(obj==null?'&nbsp;':obj.currencyDesc,'&nbsp;'));
			supplyShareDist(null);
			getShareDefaults(true);
			if (obj == null || (objUW.isPosted == "Y" && $F("txtDistFlag") != '2')){
				disableButton("btnAddShare");
				disableButton("btnTreaty");
				disableButton("btnShare");
				$("txtDistSpct").readOnly = true;
				$("txtDistSpct1").readOnly = true;
				$("txtDistTsi").readOnly = true;
				$("txtDistPrem").readOnly = true;
			}else{
				enableButton("btnAddShare");
				enableButton("btnTreaty");
				enableButton("btnShare");
				$("txtDistSpct").readOnly = false;
				$("txtDistSpct1").readOnly = false;
				$("txtDistTsi").readOnly = false;
				$("txtDistPrem").readOnly = false;
			}	
			computeTotalAmount($("txtDistSeqNo").value);
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,''));
		}catch(e){
			showErrorMessage("supplyGroupDist", e);
		}
	}
	
	function supplyShareDist(obj){
		try{
			objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl	= obj==null?{}:obj;
			$("txtDspTrtyName").value						= unescapeHTML2(nvl(obj==null?'':obj.dspTrtyName,''));
			$("txtDistSpct").value							= nvl(obj==null?null:obj.distSpct,'') == '' ? null :formatToNthDecimal(obj.distSpct, 9);
			$("txtDistSpct1").value							= nvl(obj==null?null:nvl(obj.distSpct1,obj.distSpct) ,'') == '' ? null :formatToNthDecimal(nvl(obj.distSpct1,obj.distSpct), 9);
			$("txtDistTsi").value							= nvl(obj==null?null:obj.distTsi,'') == '' ? null :formatCurrency(obj.distTsi);
			$("txtDistPrem").value							= nvl(obj==null?null:obj.distPrem,'') == '' ? null :formatCurrency(obj.distPrem);
			if (obj != null){
				if (obj.recordStatus == 0){
					enableButton("btnTreaty"); 
					enableButton("btnShare");
				}
			}
			if(objUW.isPosted == "Y"){
				disableButton("btnTreaty"); 
				disableButton("btnShare");
			}
		}catch(e){
			showErrorMessage("supplyShareDist", e);
		}
	}
	
	function supplyGroupDistPerRow(row){
		try{
			var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
	
	function supplyShareDistPerRow(row){
		try{
			getShareDefaults(false);
			if (objUW.isPosted == 'N'){
				enableButton("btnAddShare");
			}
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var lineCd = row.readAttribute("lineCd");
			var shareCd = row.readAttribute("shareCd");
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
	
	function getShareDefaults(param){
		try{
			if (param){
				$("btnAddShare").value = "Add";
				disableButton("btnDeleteShare");
				if (nvl(objUW.isPosted,'N') == 'N'){
					enableButton("btnTreaty");
					enableButton("btnShare");
				}
			}else{
				if (nvl(objUW.isPosted,'N') == 'N'){
					$("btnAddShare").value = "Update";
					enableButton("btnDeleteShare");
				}	
				disableButton("btnTreaty");
				disableButton("btnShare");
			}	
		}catch(e){
			showErrorMessage("getShareDefaults", e);
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
	
	function clearForm(){
		try{
			supplyDist(null);
			supplyGroupDist(null);
			deselectRows("distListingDiv", "rowPrelimDist");
			deselectRows("distGroupListingDiv", "rowGroupDist");
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",Number($("txtDistNo").value));
			checkTableItemInfo("distListingTableDiv","distListingDiv","rowDistr");
			clearShare();
			disableButton("btnTreaty");
			disableButton("btnShare");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}
	
	function computeTotalAmount(distSeqNo){
		try{
			var sumDistSpct = 0;
			var sumDistSpct1 = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var distSeqNo = nvl(distSeqNo,'')==''?'':Number(distSeqNo);
			var ctr = 0;
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
									sumDistSpct1 = parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1, nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0)));
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0));
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0));
								}
							}
						}	
					}
				}
			}
			
			sumDistSpct = roundNumber(sumDistSpct, 9);
			sumDistSpct1 = roundNumber(sumDistSpct1, 9);
			objUW.hidObjGIUWS016.sumDistSpct = roundNumber(sumDistSpct, 9);
			objUW.hidObjGIUWS016.sumDistSpct1 = roundNumber(sumDistSpct1, 9);
			objUW.hidObjGIUWS016.sumDistTsi = sumDistTsi;
			objUW.hidObjGIUWS016.sumDistPrem = sumDistPrem;
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
			$("distShareTotalAmtMainDiv").down("label",1).update(formatToNthDecimal(sumDistSpct, 9).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",2).update(formatCurrency(sumDistTsi).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",3).update(formatToNthDecimal(sumDistSpct1, 9).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",4).update(formatCurrency(sumDistPrem).truncate(30, "..."));
		}catch(e){
			showErrorMessage("computeTotalAmount", e);
		}
	}
	
	function disableEnableButtons(){
		if(nvl(objUW.hidObjGIUWS016.errorSw, "N") != "N" || objUW.isPosted == "Y"){
			disableButton("btnAddShare");
			disableButton("btnDeleteShare");
			disableButton("btnTreaty");
			disableButton("btnShare");
			disableButton("btnPostDist");
			disableButton("btnViewDist");
			disableButton("btnSave");
		}else{
			if ($F("txtDistFlag") != '1'){
				disableButton("btnPostDist");
				disableButton("btnSave");
				disableButton("btnAddShare");
				disableButton("btnDeleteShare");
			}else{
				enableButton('btnPostDist');
				enableButton("btnSave");
			}
			
			if ($F("txtEndtNo") != ""){
				enableButton("btnViewDist");
			}else{
				disableButton("btnViewDist");
			}
		}
	}
	
	function startLOV(id, title, objArray, width){
		try{
			var copyObj = objArray.clone();	
			var copyObj2 = objArray.clone();	
			var selGrpObjArray = objUW.hidObjGIUWS016.selectedGIUWWpolicyds.giuwWpolicydsDtl.clone();
			selGrpObjArray = selGrpObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
			var share = objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl;
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
					objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");
					objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
					objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");
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
			if (objUW.hidObjGIUWS016.globalParId == objUW.hidObjGIUWS016.selectedGIUWPolDist.parId && 
			    objUW.hidObjGIUWS016.nbtLineCd == objUW.hidObjGIUWS016.selectedGIUWWpolicyds.nbtLineCd && 
			    objUW.hidObjGIUWS016.lineCd == objGIPIPolbasicPolDistV1.lineCd){ 
			   	return;
			}
			
			objUW.hidObjGIUWS016.globalParId = objUW.hidObjGIUWS016.selectedGIUWPolDist.parId;
			objUW.hidObjGIUWS016.nbtLineCd = objUW.hidObjGIUWS016.selectedGIUWWpolicyds.nbtLineCd;
			objUW.hidObjGIUWS016.lineCd = objGIPIPolbasicPolDistV1.lineCd;
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:{
					action: "getDistListing",
					globalParId: objUW.hidObjGIUWS016.selectedGIUWPolDist.parId,
					nbtLineCd: objUW.hidObjGIUWS016.selectedGIUWWpolicyds.nbtLineCd,
					lineCd: objGIPIPolbasicPolDistV1.lineCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					objUW.hidObjGIUWS016.distListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				}	
			});	
		}catch(e){
			showErrorMessage("getListing", e);
		}
	}	
	
	
	function checkIfToAddShare(){
		var isValid = true;
		
		if ($F("txtDistNo") == ""){
			customShowMessageBox("Distribution no. is required.", "E", "txtDistNo");
			isValid = false;
			return false;
		}else if ($F("txtDistSeqNo") == ""){
			customShowMessageBox("Group no. is required.", "E", "txtDistSeqNo");
			isValid = false;
			return false;
		}else if ($F("txtDspTrtyName") == ""){
			customShowMessageBox("Share is required.", "E", "txtDspTrtyName");
			isValid = false;
			return false;
		}else if ($F("txtDistSpct") == ""){
			customShowMessageBox("% Share is required.", "E", "txtDistSpct");
			isValid = false;
			return false;
		}else if ($F("txtDistSpct1") == ""){
			customShowMessageBox("% Share is required.", "E", "txtDistSpct1");
			isValid = false;
			return false;
		}else if ($F("txtDistTsi") == ""){
			customShowMessageBox("Sum insured is required.", "E", "txtDistTsi");
			isValid = false;
			return false;
		}else if ($F("txtDistPrem") == ""){
			customShowMessageBox("Premium is required.", "E", "txtDistPrem");
			isValid = false;
			return false;
		}else if (parseFloat($F("txtDistSpct")) > 100){
			customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct");
			isValid = false;
			return false;
		}else if (parseFloat($F("txtDistSpct")) < 0){
			customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct");
			isValid = false;
			return false;
		}else if (parseFloat($F("txtDistSpct1")) > 100){
			customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct1");
			isValid = false;
			return false;
		}else if (parseFloat($F("txtDistSpct1")) < 0){
			customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct1");
			isValid = false;
			return false;
		}else if (Math.abs(unformatCurrencyValue($F("txtDistTsi"))) > Math.abs(unformatCurrencyValue($F("txtTsiAmt")))){
			customShowMessageBox("Sum insured cannot exceed TSI.", "E", "txtDistTsi");
			isValid = false;
			return false;
		}else if (Math.abs(unformatCurrencyValue($F("txtDistPrem"))) > Math.abs(unformatCurrencyValue($F("txtPremAmt")))){
			customShowMessageBox("Premium amount cannot exceed Premium.", "E", "txtDistPrem");
			isValid = false;
			return false;
		}
		
		if (unformatCurrency("txtTsiAmt") > 0){
			if (unformatCurrency("txtDistTsi") < 0){
				customShowMessageBox("Sum insured must be greater than zero.", "E", "txtDistTsi");
				isValid = false;
				return false;
			}	
		}else if (unformatCurrency("txtTsiAmt") < 0){
			if (unformatCurrency("txtDistTsi") > 0){
				customShowMessageBox("Sum insured must be less than zero.", "E", "txtDistTsi");
				isValid = false;
				return false;
			}	
		}
	
		if (unformatCurrency("txtPremAmt") > 0){
			if (unformatCurrency("txtDistPrem") < 0){
				customShowMessageBox("Premium Amount must be greater than zero.", "E", "txtDistPrem");
				isValid = false;
				return false;
			}	
		}else if (unformatCurrency("txtPremAmt") < 0){
			if (unformatCurrency("txtDistPrem") > 0){
				customShowMessageBox("Premium Amount must be less than zero.", "E", "txtDistPrem");
				isValid = false;
				return false;
			}	
		}
		
		return isValid;
	}
	
	function setShareObject() {
		try {
			var objGroup = objUW.hidObjGIUWS016.selectedGIUWWpolicyds;
			var obj = objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl;
			var newObj = new Object();
			newObj.recordStatus			= obj == null ? null :nvl(obj.recordStatus, null);
			newObj.distNo				= obj == null ? objGroup.distNo :nvl(obj.distNo, objGroup.distNo);
			newObj.distSeqNo 			= obj == null ? objGroup.distSeqNo :nvl(obj.distSeqNo, objGroup.distSeqNo);
			newObj.lineCd 				= obj == null ? "" :nvl(obj.lineCd, "");
			newObj.shareCd 				= obj == null ? "" :nvl(obj.shareCd, "");
			newObj.distSpct				= escapeHTML2($F("txtDistSpct"));
			newObj.distTsi				= escapeHTML2(unformatNumber($F("txtDistTsi")));
			newObj.distPrem				= escapeHTML2(unformatNumber($F("txtDistPrem")));
			newObj.annDistSpct			= escapeHTML2($F("txtDistSpct"));
			newObj.annDistTsi			= (nvl(objGroup.annTsiAmt,0) * nvl(newObj.annDistSpct,0))/100;
			newObj.distGrp				= obj == null ? "1" : nvl(obj.distGrp, "1");
			newObj.distSpct1			= escapeHTML2($F("txtDistSpct1"));
			newObj.arcExtData			= obj == null ? "" :nvl(obj.arcExtData, "");
			newObj.dspTrtyCd			= obj == null ? "" :nvl(obj.dspTrtyCd, "");
			newObj.dspTrtyName 			= escapeHTML2($F("txtDspTrtyName"));
			newObj.dspTrtySw			= obj == null ? "" :nvl(obj.dspTrtySw, "");
			return newObj; 
		}catch(e){
			showErrorMessage("setShareObject", e);
		}
	}
	
	
	function addDistrShare(){
		try{
			if(checkIfToAddShare()){
				var newObj  = setShareObject();
				var content = prepareDistrShareList(newObj);
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
	
					var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
											computeTotalAmount(distSeqNo);
											break;
										}
									}
								}
							}
						}
					}
				}else{
					//on ADD records
					var distNo = newObj.distNo;
					var distSeqNo = newObj.distSeqNo;
					var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
				
					var newDiv = createDistrShareRow(newObj);
					checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtDistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
					computeTotalAmount(distSeqNo);
					changeTag=1;
				}	
				clearShare();
				if ($F("txtDistFlag") == 2) {
					enableButton("btnPostDist");
					enableButton("btnSave");	
				}
			}	
		}catch(e){
			showErrorMessage("addDistrShare", e);
		}
	}
	
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
					var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
											changeMade=1;
											objArray[a].recordStatus = objArray[a].recordStatus == 0 ? 0 :1;
											Effect.Fade(row,{
												duration: .5,
												afterFinish: function(){
													row.remove();
													clearShare();
													checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtDistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
													computeTotalAmount(distSeqNo);
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
			if ($F("txtDistFlag") == 2 && changeTag == 1) {
				enableButton("btnPostDist");
				enableButton("btnSave");
			}
		}catch(e){
			showErrorMessage("deleteShare", e);
		}
	}
	
	function procedurePreCommit(param){
		try{
			var ok = true;
			var ctr = 0;
			var sumDistSpct = 0;
			var sumDistSpct1 = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
									sumDistSpct1 = parseFloat(sumDistSpct1) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1, nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct,0)));
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi,0));
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem,0));
								}
							}
							function err(msg){
								objUW.hidObjGIUWS016.preCommit = "N";
								var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowDistr");
								dist == "rowDistr"+nvl(a,'---') ? null : ($("rowDistr"+nvl(a,'---')) ? fireEvent($("rowDistr"+nvl(a,'---')), "click") :null);
								dist == "rowDistr"+nvl(a,'---') ? null : ($("rowDistr"+nvl(a,'---')) ? $("rowDistr"+nvl(a,'---')).scrollIntoView() :null);
								
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
							//if (roundNumber(sumDistSpct, 9) != 100 /*&& roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2)*/ && param == null){ replaced by robert SR 5053 12.21.15
							if ((roundNumber(sumDistSpct, 9) < parseFloat("99.5") ) || (roundNumber(sumDistSpct, 9) > parseFloat("100.5")) || roundNumber(sumDistTsi, 2) != roundNumber(nvl(objArray[a].giuwWpolicyds[b].tsiAmt,0), 2) && param == null){
								//err("Total TSI %Share should be equal to 100."); replaced by robert SR 5053 12.21.15
								err("The total distribution sum insured should be equal to the Group Sum Insured."); 
								return false;
							}
							//if (roundNumber(sumDistSpct1, 9) != 100 && roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWpolicyds[b].premAmt,0), 2) && param == null){ replaced by robert SR 5053 12.21.15
							if ((roundNumber(sumDistSpct1, 9) < parseFloat("99.5") ) || (roundNumber(sumDistSpct1, 9) > parseFloat("100.5")) || roundNumber(sumDistPrem, 2) != roundNumber(nvl(objArray[a].giuwWpolicyds[b].premAmt,0), 2) && param == null){
								//err("Total Premium %Share should be equal to 100."); replaced by robert SR 5053 12.21.15
								err("The total distribution premium amount should be equal to the group premium amount.");
								return false;
							}
	
							if (param == 'P' && parseFloat($("lblTotalTSIShare").innerHTML.replace(/,/g, "")) != '100'){
								err("Post distribution is only allowed if total percent share of TSI is equal to 100%.");
								return false;
							}
							if (param == 'P' && parseFloat($("lblTotalPremShare").innerHTML.replace(/,/g, "")) != '100'){
								err("Post distribution is only allowed if total percent share of premium is equal to 100%.");
								return false;
							}
							/* if (param == 'P' && parseFloat($("lblTotalTsiAmt").innerHTML.replace(/,/g, "")) != unformatCurrency("txtTsiAmt")){							
								err("Total sum insured must be equal to sum insured amount.");
								return false;
							}
							if (param == 'P' && parseFloat($("lblTotalPremAmt").innerHTML.replace(/,/g, "")) != unformatCurrency("txtPremAmt")){
								err("Total premium must be equal to premium amount.");
								return false;
							} */
												
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
	
	function checkC1407TsiPremium(){
		try{
			var ok = true;
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
			  
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								if (objArray[a].giuwWpolicyds[b].recordStatus == 1 || changeTag == 1){ //||  alert only if there is any changes in Shares
									//if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									if(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1 == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
										function err(msg){
											var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowDistr");
											dist == "rowDistr"+nvl(a,'---') ? null : ($("rowDistr"+nvl(a,'---')) ? fireEvent($("rowDistr"+nvl(a,'---')), "click") :null);
											dist == "rowDistr"+nvl(a,'---') ? null : ($("rowDistr"+nvl(a,'---')) ? $("rowDistr"+nvl(a,'---')).scrollIntoView() :null);
											
											showWaitingMessageBox(msg, "E", 
												function(){
													var grp = getSelectedRowIdInTable_noSubstring("distGroupListingDiv", "rowGroupDist");
													grp == "rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')? null :($("rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')? fireEvent($("rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')), "click") :null));
												}); 
											ok = false;
										}
										var msg = "A share in group no. "+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+" cannot have both its TSI and Premium share % equal to zero.";
										err(msg);
										return false;
									}
								} else {
									//if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									if(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSpct1 == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
										function err(msg){
											var dist = getSelectedRowIdInTable_noSubstring("distListingDiv", "rowDistr");
											dist == "rowDistr"+nvl(a,'---') ? null : ($("rowDistr"+nvl(a,'---')) ? fireEvent($("rowDistr"+nvl(a,'---')), "click") :null);
											dist == "rowDistr"+nvl(a,'---') ? null : ($("rowDistr"+nvl(a,'---')) ? $("rowDistr"+nvl(a,'---')).scrollIntoView() :null);
											
											showWaitingMessageBox(msg, "E", 
												function(){
													var grp = getSelectedRowIdInTable_noSubstring("distGroupListingDiv", "rowGroupDist");
													grp == "rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')? null :($("rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')? fireEvent($("rowGroupDist"+nvl(objArray[a].giuwWpolicyds[b].distNo,'---')+""+nvl(objArray[a].giuwWpolicyds[b].distSeqNo,'---')), "click") :null));
												}); 
											ok = false;
										}
										var msg = "A share in group no. "+objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo+" cannot have both its TSI and Premium share % equal to zero.";
										err(msg);
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
	
	function deleteZeroTSIPremRecords(){
		try{
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
			var isZeroTSIPremExist = false;
			  
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
						if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
								if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distPrem == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distTsi == 0 && objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
									var delObj = objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c];
									if(delObj.recordStatus != 0 || objArray[a].recordStatus == 0){
										delObj.recordStatus = -1;
									}else if(delObj.recordStatus == 0){
										objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.splice(c, 1); //to remove the newly added record that not exist in database
									}
									objArray[a].recordStatus = 1;
									isZeroTSIPremExist = true;
								}
							}
						}	
					}
				}
			}
			return isZeroTSIPremExist;
		}catch(e){
			showErrorMessage("deleteZeroTSIPremRecords", e);
		}
	}
	
	var giuwPolDistRows = [];
	var giuwWpolicydsRows = [];
	var giuwWpolicydsDtlSetRows = [];
	var giuwWpolicydsDtlDelRows = [];
	
	function prepareDistParamsForSaving(){
		try{
			giuwPolDistRows.clear();
			giuwWpolicydsRows.clear();
			giuwWpolicydsDtlSetRows.clear();
			giuwWpolicydsDtlDelRows.clear();
	
			var objArray = objUW.hidObjGIUWS016.GIUWPolDist.clone();
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != null){
					//Pol Dist
					if (objArray[a].recordStatus != null){
						objArray[a].effDate = nvl(objArray[a].effDate,"")=="" ? "" :dateFormat((objArray[a].effDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].expiryDate = nvl(objArray[a].expiryDate,"")=="" ? "" :dateFormat((objArray[a].expiryDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].createDate = nvl(objArray[a].createDate,"")=="" ? "" :dateFormat((objArray[a].createDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].negateDate = nvl(objArray[a].negateDate,"")=="" ? "" :dateFormat((objArray[a].negateDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].acctEntDate = nvl(objArray[a].acctEntDate,"")=="" ? "" :dateFormat((objArray[a].acctEntDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].acctNegDate = nvl(objArray[a].acctNegDate,"")=="" ? "" :dateFormat((objArray[a].acctNegDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].lastUpdDate = nvl(objArray[a].lastUpdDate,"")=="" ? "" :dateFormat((objArray[a].lastUpdDate), "mm-dd-yyyy HH:MM:ss TT");
						objArray[a].postDate = nvl(objArray[a].postDate,"")=="" ? "" :dateFormat((objArray[a].postDate), "mm-dd-yyyy HH:MM:ss TT");
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
			}	
		}catch (e) {
			showErrorMessage("prepareDistParamsForSaving", e);
		}
	}
	
	function prepareObjParameters(param){
		try{
			var objParameters = new Object();
			objParameters.giuwPolDistRows 				= prepareJsonAsParameter(giuwPolDistRows);
			objParameters.giuwWpolicydsRows 			= prepareJsonAsParameter(giuwWpolicydsRows);
			objParameters.giuwWpolicydsDtlSetRows 		= prepareJsonAsParameter(giuwWpolicydsDtlSetRows);
			objParameters.giuwWpolicydsDtlDelRows 		= prepareJsonAsParameter(giuwWpolicydsDtlDelRows);
			objParameters.parId							= nvl(objGIPIPolbasicPolDistV1.parId, "");
			objParameters.lineCd						= nvl(objGIPIPolbasicPolDistV1.lineCd, "");
			objParameters.sublineCd						= nvl(objGIPIPolbasicPolDistV1.sublineCd, "");
			objParameters.polFlag						= nvl(objGIPIPolbasicPolDistV1.polFlag, "");
			objParameters.parType						= nvl(objGIPIPolbasicPolDistV1.parType, "");
			objParameters.batchId						= nvl(objGIPIPolbasicPolDistV1.batchId, "");
			objParameters.policyId						= nvl(objGIPIPolbasicPolDistV1.policyId, "");
			objParameters.postSw                        = param == "saveWithPost" ? "Y" : "N";
			return objParameters;
		}catch(e){
			showErrorMessage("prepareObjParameters", e);
		}
	}
	
	
	function saveOneRiskDistTsiPremGrp(param){
		try{
			if (param != "saveWithPost") {
				if (!procedurePreCommit()){
					return false;	
				}
				if (!checkC1407TsiPremium()){
					return false;
				}
			}
			
			if(checkBinder(true)){
				return;
			}
			
			if (!checkExpiredTreatyShare()){
				return false;
			}
			
			function saveRecord(){
				prepareDistParamsForSaving();
				
				var objParameters = new Object();
				objParameters = prepareObjParameters(param);
		
				new Ajax.Request(contextPath + "/GIUWPolDistController",{
					method: "POST",
					parameters:{
						action : "saveDistrByTSIPremGroup",
						parameters: JSON.stringify(objParameters)
					},
					onCreate: function(){
						showNotice("Saving One-Risk Distribution by TSI/Prem (Group), please wait ...");
					},
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							if (param == "saveWithPost") {
								loadDistributionByTsiPremGroup();
								postDistribution();
							}else{
								showMessageBox(objCommonMessage.SUCCESS, "S");
								adjustAllWTablesGIUWS004(); //added by robert SR 5053 12.21.15
								loadDistributionByTsiPremGroup();
								objUW.hidObjGIUWS016.GIUWPolDist = JSON.parse(objUW.hidObjGIUWS016.GIUWPolDistClone.replace(/\\/g, '\\\\')); //added by robert SR 5053 12.21.15
								loadDistrListings(objUW.hidObjGIUWS016.GIUWPolDist); //added by robert SR 5053 12.21.15
								fireEvent($("dummyShowListing"), "click"); //added by robert SR 5053 12.21.15
							}
							changeTag = 0;
							adjustAllWTablesGIUWS004();		//added by robert SR 5053 12.21.15
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				});
			}
			
			function checkPostFlag(){
				var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
				if(objArray.length > 0){
					for(var a=0; a<objArray.length; a++){
						if (objArray[a].postFlag == "P"){
							showWaitingMessageBox('Distribution has been created using Peril Distribution. Distribution records will be recreated.', 'I', function(){
								deleteReinsertGIUWS016();
								saveRecord();
							});
						} else {
							saveRecord();
						}
					}	
				} else {
					saveRecord();
				}
			}
			
			checkPostFlag();
			
		}catch(e){
			showErrorMessage("saveOneRiskDistTsiPremGrp", e);
		}
	}
	
	function askCommit(){
		showConfirmBox2("Confirm", "Whatever changes made in the form will be saved. Do you wish to continue?", "Ok", "Cancel", 
						function () {
							saveOneRiskDistTsiPremGrp("saveWithPost");
						}, 
						function(){
							showMessageBox("Distribution has been cancelled!", "I");
						});
	}
	
	function adjustWorkingTables(){
		//adjustAllWTablesGIUWS004();
		getPolicyTakeUp();
		postAdjust = "Y";
		var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].postFlag == "P"){
				showConfirmBox("Confirm", "Distribution has been created using Peril Distribution. Distribution records will be recreated. Do you want to continue posting?", "Continue", "Cancel",
						function(){
							deleteReinsertGIUWS016();
							postDistribution();
						}, function(){
							null;
						}
					);
			}else{
				postDistribution();
			}
		}	
	}
	
	function clickPostDist(){
		if(checkBinder(true)){
			return;
		}
		if (checkItemPerilAmountAndShare()){
			return false;
		}
		if (!procedurePreCommit("P")){
			return false;	
		}
		if (!checkC1407TsiPremium()){
			return false;
		}
		if (isDiffPerilGroupShare() == "Y"){
			showConfirmBox("Confirm", "There are perils whose share % are different from the group distribution shares. Posting this distribution will recompute the distribution records based on policyds_dtl. Do you want to continue posting?", "Continue", "Cancel",
					function(){
						deleteReinsertGIUWS016();
						adjustWorkingTables();
					}, function(){
						return false;
					}
				);
		} else {
			adjustWorkingTables();
		}
		
		/* if(!deleteZeroTSIPremRecords()){
			if (changeTag == 0){
				getPolicyTakeUp(); //get take up term
				if (takeUpTerm == "ST"){ //condition for excuting comparisons only if single take up
					if (!comparePolItmperilToDs()) return false; // for comparison of ds table to itemperil table
					//if (!recomputeAfterCompare()) return false;
				} 
				checkPostFlagBeforePost();
			}else{
				askCommit();
			}
		}else{
			if (changeTag == 0){
				saveOneRiskDistTsiPremGrp("saveWithPost");
			}else{
				askCommit();	
			}
		} */	 
	}
	
	function postDistribution(){
		if (!checkExpiredTreatyShare()){
			return false;
		}
		var selectedGiuwPolDist = objUW.hidObjGIUWS016.selectedGIUWPolDist;
		
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method: 'POST',
			parameters:{
				action: "postDistGiuws016",
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: (selectedGiuwPolDist == null) ? nvl(objGIPIPolbasicPolDistV1.distNo, 0) : selectedGiuwPolDist.distNo,
				parId: (selectedGiuwPolDist == null) ? nvl(objGIPIPolbasicPolDistV1.parId, 0) : selectedGiuwPolDist.parId,
				lineCd: objGIPIPolbasicPolDistV1.lineCd,
				sublineCd: objGIPIPolbasicPolDistV1.sublineCd,
				issCd: objGIPIPolbasicPolDistV1.issCd,
				issueYy: objGIPIPolbasicPolDistV1.issueYy,
				polSeqNo: objGIPIPolbasicPolDistV1.polSeqNo,
				renewNo: objGIPIPolbasicPolDistV1.renewNo,
				parType: objGIPIPolbasicPolDistV1.parType,
				polFlag: objGIPIPolbasicPolDistV1.polFlag,
				distSeqNo: (objUW.hidObjGIUWS016.selectedGIUWWpolicyds == null) ? "1" : objUW.hidObjGIUWS016.selectedGIUWWpolicyds.distSeqNo,
				effDate: dateFormat(objGIPIPolbasicPolDistV1.effDate, "mm-dd-yyyy"),
				batchId: (selectedGiuwPolDist == null) ? nvl(objGIPIPolbasicPolDistV1.batchId, "") : selectedGiuwPolDist.batchId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Posting please wait...");
			},
			onComplete: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					var param = {};
					
					try {
						param = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					} catch (e) {
						showMessageBox(response.responseText, "I");
						return;
					}
					
					if (nvl(param.msgAlert, "SUCCESS") != "SUCCESS") {
						showMessageBox(param.msgAlert);
					}else{
						var giuwPolDist = param.giuwPolDist;
						objUW.isPosted = "Y";
						if (param.vFaculSw == "Y") {
							for (var i = 0; i < objUW.hidObjGIUWS016.GIUWPolDist.length; i++) {
								var objPolDist = objUW.hidObjGIUWS016.GIUWPolDist[i];
	
								objUW.hidObjGIUWS016.GIUWPolDist[i].distFlag = "2";
								objUW.hidObjGIUWS016.GIUWPolDist[i].meanDistFlag = "with Facultative";
							}
							loadDistrListings(objUW.hidObjGIUWS016.GIUWPolDist);
							disableEnableButtons();
						} else {
							for (var i = 0; i < objUW.hidObjGIUWS016.GIUWPolDist.length; i++) {
								var objPolDist = objUW.hidObjGIUWS016.GIUWPolDist[i];
								objUW.hidObjGIUWS016.GIUWPolDist[i].distFlag = "3";
								objUW.hidObjGIUWS016.GIUWPolDist[i].meanDistFlag = "Distributed";
							}
							loadDistrListings(objUW.hidObjGIUWS016.GIUWPolDist);
							disableEnableButtons();
						}			
						objUW.isPosted = "N";
						showMessageBox("Posting complete.", imgMessage.SUCCESS);
					}	
				}
			}
		});
	}
	
	function showGIUWS016PolDistV1LOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIPIPolbasicPolDistV1TSIPremGrp",
							moduleId : "GIUWS016",
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
								 	updateDistSpct1(row.distNo);
								 	objGIPIPolbasicPolDistV1 = row;
									populateDistrPolicyInfoFields(row);
									loadDistributionByTsiPremGroup();
									//checkBinder(true);
							 }
				  		}
					});
	} 
	
	$("dummyShowListing").observe("click", function(){	
		loadDistrListings(objUW.hidObjGIUWS016.GIUWPolDist);
		objUW.isPosted = 'N';
		disableEnableButtons();
		//checkBinder(false);
	});
	
	$("hrefPolicyNo").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveOneRiskDistTsiPremGrp, 
				function(){
					changeTag = 0;
					//showPolbasicPolDistV1Listing("getGIPIPolbasicPolDistV1TSIPremGrp");
					showGIUWS016PolDistV1LOV(); // andrew - 12.5.2012
				},
				"");
		}else{
			//showPolbasicPolDistV1Listing("getGIPIPolbasicPolDistV1TSIPremGrp");
			showGIUWS016PolDistV1LOV(); // andrew - 12.5.2012
		}
	});
	
	/*$("btnShare").observe("click", function(){
		getListing();
		var objArray = objUW.hidObjGIUWS016.distListing.distShareListingJSON;
		startLOV("GIUWS016-Share", "Share", objArray, 540);
	});
	
	$("btnTreaty").observe("click", function(){
		getListing();
		var objArray = objUW.hidObjGIUWS016.distListing.distTreatyListingJSON;
		startLOV("GIUWS016-Treaty", "Treaty", objArray, 540);	
	});*/ // replaced by: Nica 05.18.2012
	
	$("btnShare").observe("click", function(){
		var notIn = "";
		$$("div#distShareListingDiv div[name='rowShareDist']").each(function(row){ 
			if(formatNumberDigits(row.getAttribute("distseqno"),5) == $F('txtDistSeqNo')){ //added condition, Cherrie Love Perello - 12.27.2013
				if(notIn != ""){
					notIn += ",";
				}
				notIn += row.getAttribute("shareCd");
			}
		});
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getDistShareLOV2",
							nbtLineCd : objUW.hidObjGIUWS016.selectedGIUWWpolicyds.nbtLineCd,
							lineCd: objGIPIPolbasicPolDistV1.lineCd,
							notIn : notIn,
							page : 1},
			title: "Share",
			width: 500,
			height: 350,
			columnModel : [	{	id : "shareCd",
								title: "Code",
								width: '100px'
							},
							{	id : "trtyName",
								title: "Share",
								width: '280px'
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
				objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.lineCd = row.lineCd;
				objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.shareCd = row.shareCd;
				objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.nbtShareType = row.shareType;
			}
		  });
	});
	
	$("btnTreaty").observe("click", function(){
		var notIn = "";
		$$("div#distShareListingDiv div[name='rowShareDist']").each(function(row){
			if(parseInt($F("txtDistSeqNo")) == parseInt(row.getAttribute("distseqno"))){ 
				if(notIn != ""){
					notIn += ",";
				}
				notIn += row.getAttribute("shareCd");
			}
		});
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getDistTreatyLOV2",
							policyId: nvl(objGIPIPolbasicPolDistV1.policyId, 0),
							lineCd: objGIPIPolbasicPolDistV1.lineCd,
							notIn : notIn,
							page : 1},
			title: "Treaty",
			width: 500,
			height: 350,
			columnModel : [	{	id : "shareCd",
								title: "Code",
								width: '100px'
							},
							{	id : "trtyName",
								title: "Share",
								width: '230px'
							},
							{	id : "trtyYy",
								title: "Year",
								width: '70px',
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
				objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.lineCd = row.lineCd;
				objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.shareCd = row.shareCd;
				objUW.hidObjGIUWS016.selectedGIUWWpolicydsDtl.nbtShareType = row.shareType;
			}
		  });
	});
	
	initPreTextOnField("txtDistSpct");
	$("txtDistSpct").observe(/*"blur"*/"change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		//if ($F("txtDistSeqNo") == "" || $F("txtDistSpct") == "") return; //removed by robert SR 5053 12.21.15
		//if (!checkIfValueChanged("txtDistSpct")) return; //removed by robert SR 5053 12.21.15
		if($F("txtDistSpct").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistSpct").value = 0;
		}
		/*  Check if %Share is not greater than 100 */ 
		if (parseFloat($F("txtDistSpct")) > 100){
			customShowMessageBox("TSI %Share cannot exceed 100.", "E", "txtDistSpct");
			return false;
		}	
		if (parseFloat($F("txtDistSpct")) < 0){
			customShowMessageBox("TSI %Share must be greater than zero.", "E", "txtDistSpct");
			return false;
		}
	
		/* Compute DIST_TSI if the TSI amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtTsiAmt") != 0){
			$("txtDistTsi").value = formatCurrency(nvl($F("txtDistSpct")/100,0) * nvl(unformatCurrency("txtTsiAmt"),0));	
		}else{
			$("txtDistTsi").value = formatToNthDecimal(0, 9);
		}
		
		$("txtDistSpct1").value = 	$F("txtDistSpct"); //added by robert SR 5053 11.11.15 //added by robert SR 5053 12.21.15
		fireEvent($("txtDistSpct1"), "change"); //added by robert SR 5053 11.11.15 //added by robert SR 5053 12.21.15
		fireEvent($("txtDistSpct1"), "blur"); //added by robert SR 5053 11.11.15 //added by robert SR 5053 12.21.15
	});
	
	initPreTextOnField("txtDistSpct1");
	$("txtDistSpct1").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		//if ($F("txtDistSeqNo") == "" || $F("txtDistSpct1") == "") return; //removed by robert SR 5053 12.21.15
		//if (!checkIfValueChanged("txtDistSpct1")) return;  //removed by robert SR 5053 12.21.15
		if($F("txtDistSpct1").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistSpct1").value = 0;
		}
		/*  Check if %Share is not greater than 100 */ 
		if (parseFloat($F("txtDistSpct1")) > 100){
			customShowMessageBox("Premium %Share cannot exceed 100.", "E", "txtDistSpct1");
			return false;
		}	
		if (parseFloat($F("txtDistSpct1")) < 0){
			customShowMessageBox("Premium %Share must be greater than zero.", "E", "txtDistSpct1");
			return false;
		}
	
		/* Compute DIST_PREM if the Premium amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtPremAmt") != 0){
			$("txtDistPrem").value = formatCurrency(nvl($F("txtDistSpct1")/100,0) * nvl(unformatCurrency("txtPremAmt"),0));
		}else{
			$("txtDistPrem").value = formatToNthDecimal(0, 9);
		}
		
	});
	
	/* Sum Insured */ 
	initPreTextOnField("txtDistTsi");
	$("txtDistTsi").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		//if ($F("txtDistSeqNo") == "" || $F("txtDistTsi") == "") return;  //removed by robert SR 5053 12.21.15
		//if (!checkIfValueChanged("txtDistTsi")) return;  //removed by robert SR 5053 12.21.15
		if($F("txtDistTsi").empty()){  //added by robert SR 5053 12.21.15
			$("txtDistTsi").value = 0;
		}
		/* Check if dist_tsi is not greater than tsi_amt  */
		if (Math.abs(unformatCurrency("txtDistTsi")) > Math.abs(unformatCurrency("txtTsiAmt"))){
			customShowMessageBox("Sum insured cannot exceed TSI.", "E", "txtDistTsi");
			return false;
		}	
	
		/* Compute dist_spct if the TSI amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtTsiAmt") > 0){
			if (unformatCurrency("txtDistTsi") < 0){
				customShowMessageBox("Sum insured must be greater than zero.", "E", "txtDistTsi");
				return false;
			}	
			$("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 , 9);
		}else if (unformatCurrency("txtTsiAmt") < 0){
			if (unformatCurrency("txtDistTsi") > 0){
				customShowMessageBox("Sum insured must be less than zero.", "E", "txtDistTsi");
				return false;
			}	
	      $("txtDistSpct").value = formatToNthDecimal(nvl(unformatCurrency("txtDistTsi"),0) / nvl(unformatCurrency("txtTsiAmt"),0) * 100 , 9);
		}else{
			$("txtDistTsi").value = formatCurrency("0");
		}	
		$("txtDistSpct1").value = 	$F("txtDistSpct"); //added by robert SR 5053 11.11.15  //added by robert SR 5053 12.21.15
		fireEvent($("txtDistSpct1"), "change"); //added by robert SR 5053 11.11.15 //added by robert SR 5053 12.21.15
		fireEvent($("txtDistSpct1"), "blur"); //added by robert SR 5053 11.11.15 //added by robert SR 5053 12.21.15
	});
	
	initPreTextOnField("txtDistPrem");
	$("txtDistPrem").observe(/*"blur"*/ "change", function(){ // replace observe 'blur' to 'change' - Nica 09.17.2012
		//if ($F("txtDistSeqNo") == "" || $F("txtDistPrem") == "") return; //removed by robert SR 5053 12.21.15
		//if (!checkIfValueChanged("txtDistPrem")) return; //removed by robert SR 5053 12.21.15
		if($F("txtDistPrem").empty()){ //added by robert SR 5053 12.21.15
			$("txtDistPrem").value = 0;
		}
		/* Check if dist_prem is not greater than prem_amt  */
		if (Math.abs(unformatCurrency("txtDistPrem")) > Math.abs(unformatCurrency("txtPremAmt"))){
			customShowMessageBox("Premium Amount cannot exceed Premium.", "E", "txtDistPrem");
			return false;
		}	
	
		/* Compute dist_spct1 if the Premium amount of the master table
		 * is not equal to zero.  Otherwise, nothing happens.  */
		if (unformatCurrency("txtPremAmt") > 0){
			if (unformatCurrency("txtDistPrem") < 0){
				customShowMessageBox("Premium Amount must be greater than zero.", "E", "txtDistPrem");
				return false;
			}	
			$("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrency("txtDistPrem"),0) / nvl(unformatCurrency("txtPremAmt"),0) * 100 , 9);
		}else if (unformatCurrency("txtPremAmt") < 0){
			if (unformatCurrency("txtDistPrem") > 0){
				customShowMessageBox("Premiun Amount must be less than zero.", "E", "txtDistPrem");
				return false;
			}	
	      $("txtDistSpct1").value = formatToNthDecimal(nvl(unformatCurrency("txtDistPrem"),0) / nvl(unformatCurrency("txtPremAmt"),0) * 100 , 9);
		}else{
			$("txtDistPrem").value = formatCurrency("0");
		}	
	
	});
	
	
	$("distrByTsiPremGroupExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});
	
	$("btnAddShare").observe("click", function(){
		addDistrShare();
	});
	
	$("btnDeleteShare").observe("click",function(){
		deleteShare();
	});
	
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
						clickPostDist();
					}else{
						showConfirmBox2("Confirm", "Whatever changes made in the form will be saved.  Do you wish to continue?", "Ok", "Cancel", function () {
							saveOneRiskDistTsiPremGrp("saveWithPost");
						}, "");
					}
				}
			}
		}); */
		
		if (changeTag == 0){
			clickPostDist();
		}else{
			/* showConfirmBox2("Confirm", "Whatever changes made in the form will be saved.  Do you wish to continue?", "Ok", "Cancel", function () {
				saveOneRiskDistTsiPremGrp("saveWithPost");
			}, ""); */
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
		} 
		
	});
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveOneRiskDistTsiPremGrp();
		}
	});
	
	observeReloadForm("reloadForm", showDistrByTsiPremGroup);
	observeReloadForm("distrByTsiPremGroupQuery", showDistrByTsiPremGroup); // andrew - 12.5.2012
	observeCancelForm("btnCancel", saveOneRiskDistTsiPremGrp, checkChangeTagBeforeUWMain);
	initializeChangeTagBehavior(saveOneRiskDistTsiPremGrp);
	hideNotice();
	
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
	
	function getPolicyTakeUp (){
		var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
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
	
	function comparePolItmperilToDs (){
		var ok = true;
		for(var i=0, length=objUW.hidObjGIUWS016.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "comparePolItmperilToDs",
					policyId: objUW.hidObjGIUWS016.GIUWPolDist[i].policyId,
					distNo : objUW.hidObjGIUWS016.GIUWPolDist[i].distNo
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
					} else {
						ok = false;	
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
	
	function updateDistSpct1(distNo){
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
	
	function checkPostFlagBeforePost (){
		if (objUW.hidObjGIUWS016.GIUWPolDist[0].postFlag == "P"){
			deleteReinsertGIUWS016();
		} else {
			postDistribution();
		}
	}
	
	function deleteReinsertGIUWS016 (){
		var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "deleteReinsertGIUWS004",
					distNo : objUW.hidObjGIUWS016.GIUWPolDist[a].distNo,
					parId : objArray[a].parId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						/* showWaitingMessageBox("Distribution has been created using Peril Distribution. Distribution records will be recreated.", "I", 
								function(){
									postDistribution();
								}
						); */
					}
				}
			});	
		}
	}
	
	$("btnViewDist").observe("click", function(){
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		objGIPIS130.details = {};
		objGIPIS130.details.withBinder = checkBinder(false) ? "Y" : "N";
		objGIPIS130.details.lineCd = $F("txtPolLineCd");
		objGIPIS130.details.sublineCd = $F("txtPolSublineCd");
		objGIPIS130.details.issCd = $F("txtPolIssCd");
		objGIPIS130.details.issueYy = $F("txtPolIssueYy");
		objGIPIS130.details.polSeqNo = $F("txtPolPolSeqNo");
		objGIPIS130.details.renewNo = $F("txtPolRenewNo");
		objGIPIS130.distNo = objUW.hidObjGIUWS016.selectedGIUWPolDist.distNo;
		objGIPIS130.distSeqNo = objUW.hidObjGIUWS016.selectedGIUWWpolicyds.distSeqNo;
		objUWGlobal.previousModule = "GIUWS016";
		showViewDistributionStatus();
	});
	
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
	
	function checkBinder(pressed){
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
							if(pressed){
								showWaitingMessageBox('Cannot update distribution records. There are distribution groups with posted binders.', 'I', function(){
									if (pressed) {
										/*var params = {};	// replaced with codes below : shan 06.26.2014
										params.lineCd = $F("txtPolLineCd");
										params.sublineCd = $F("txtPolSublineCd");
										params.issCd = $F("txtPolIssCd");
										params.issueYy = $F("txtPolIssueYy");
										params.polSeqNo = $F("txtPolPolSeqNo");
										params.renewNo = $F("txtPolRenewNo");
										params.distNo = $F("txtDistNo");
										showDistrByTsiPremGroup(params, 'Y');*/
										changeTag = 0;										
										objUW.hidObjGIUWS016.GIUWPolDist = JSON.parse(objUW.hidObjGIUWS016.GIUWPolDistClone.replace(/\\/g, '\\\\'));
										loadDistrListings(objUW.hidObjGIUWS016.GIUWPolDist);
										unClickRow("distListingTableDiv");
									}
								});	
							} else {
								objUW.hidObjGIUWS016.binderExist = 'Y';
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
	
	//for adjusting distribution tables edgar 05/13/2014
	function adjustAllWTablesGIUWS004(){
		var ok = false;
		for(var i=0, length=objUW.hidObjGIUWS016.GIUWPolDist.length; i < length; i++){
			new Ajax.Request(contextPath + "/GIUWPolDistController", {
				method : "POST",
				parameters : {
					action: "adjustAllWTablesGIUWS004",
					distNo : objUW.hidObjGIUWS016.GIUWPolDist[i].distNo,
					parId : objUW.hidObjGIUWS016.GIUWPolDist[i].parId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Adjusting Distribution, please wait ...");
				},
				onComplete : function(response){
					hideNotice();
					clearDistStatus(objUW.hidObjGIUWS016.GIUWPolDist);
					ok = true;
				}
			});
			if(!ok){
				break;
			}
		}
		return ok;
	}
	
	var loadRec = '${loadRec}'; 
	if(nvl(loadRec,'N') == 'Y'){
		var obj = JSON.parse(('${polRec}').replace(/\\/g, '\\\\'));
		var row = obj.rows[0];
		updateDistSpct1(obj.rows[0].distNo);
	 	objGIPIPolbasicPolDistV1 = row;
		populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
		loadDistributionByTsiPremGroup();
	} else {
		if ($("showDistGroup").innerHTML == "Hide") {
		fireEvent($("showDistGroup"), "click");
		}
		if ($("showDistShare").innerHTML == "Hide") {
			fireEvent($("showDistShare"), "click");
		}
	}
	
	function checkItemPerilAmountAndShare(){
		var result = true;		
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action: "checkItemPerilAmountAndShare",
				distNo : $F("txtDistNo"),
				moduleId : "GIUWS016"
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
	
	function checkExpiredTreatyShare(){
		var ok = true;
		var objArray = objUW.hidObjGIUWS016.GIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (objArray[a].recordStatus != -1){
				//Group
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
					if (objArray[a].giuwWpolicyds[b].recordStatus != -1){
						//Share
						for(var c=0; c<objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl.length; c++){
							if (objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].recordStatus != -1){
								new Ajax.Request(contextPath + "/GIUWPolDistController", {
									method : "POST",
									parameters : {
										action: "getTreatyExpiry",
										lineCd : objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].lineCd,
										shareCd : objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].shareCd,
										parId : objArray[a].parId
									},
									asynchronous: false,
									evalScripts: true,
									onComplete : function(response){
										hideNotice();
										if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
											var comp = JSON.parse(response.responseText);
											if (comp.vExpired == "Y"){
												showMessageBox("Treaty "+ comp.treatyName +" in group no." + objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl[c].distSeqNo + 
											               " is already expired. Replace the treaty with another one. ", imgMessage.ERROR);
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
</script>