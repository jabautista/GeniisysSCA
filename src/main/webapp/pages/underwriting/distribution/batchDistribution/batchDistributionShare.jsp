<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="batchDistributionShareMainDiv" name="batchDistributionShareMainDiv" class="sectionDiv" style="margin-bottom: 10px; width: 595px;">
	<div id="batchDistInfo" name="batchDistInfo" class="sectionDiv" style="border: none;">
		<table cellspacing="2" border="0" style="margin: 10px auto">
			<tr>
				<td class="rightAligned" style="width: 80px;">Batch No.</td>
				<td class="leftAligned" style="width: 220px;"><input type="text" id="txtBatchNo" style="width: 180px;" value="" readonly="readonly"/></td>
				<td class="rightAligned" style="width: 80px;">Batch Date</td>
				<td class="leftAligned" style="width: 220px;"><input type="text" id="txtBatchDate" style="width: 180px;" value="" readonly="readonly"/></td>
			</tr>
		</table>
	</div>
	<div id="ditributionShareDiv" name="distributionShareDiv" class="sectionDiv" style="border: none;">
		<input type="button" id="showBatchShareBtn" value="hiddenTrigger" style="display: none;"/>
		<div id="distShareListingTableDiv" style="width:80%; padding-bottom:15px; margin: 0 10%">
			<div class="tableHeader" style="margin:10px; margin-bottom:0px;">
				<label style="width: 50%; text-align: left; margin: 0 20px;">Share</label>
				<label style="width: 35%; text-align: right; margin-right: 5px;">% Share</label>
			</div>
			<div id="distShareListingDiv" name="distShareListingDiv" style="margin: 0 10px;" class="tableContainer"></div>
			<div class="tableHeader" style="margin:10px; margin-top:0px;">
				<div id="distShareTotalAmtDiv" name="distShareTotalAmtDiv">
					<label style="text-align:left; width:50%; margin: 0 20px; float:left;">Total:</label>
					<label id="lblTotalShare" style="text-align:right; width:35%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
				</div>
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
					<input class="required nthDecimal" nthDecimal="9" type="text" id="txtDistSpct" name="txtDistSpct" value="" style="width:250px;" maxlength="13"/>
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
<div align="center" style="margin: 10px;">
	<input type="button" id="btnPostDist" 	name="btnPostDist" 	  		class="button hover"	style="width: 120px;"	value="Post Distribution" />
	<input type="button" id="btnSaveShare" 	name="btnSaveBatchShare" 	class="button hover"  	style="width: 90px;"	value="Save"/>
	<input type="button" id="btnClose" 		name="btnClose" 	  		class="button hover"	style="width: 90px;"	value="Close"/>
</div>

<script type="text/javascript">
	var giuwDistBatch = JSON.parse('${giuwDistBatch}'.replace(/\\/g, '\\\\'));
	var giuwDistBatchClone = '${giuwDistBatch}';	// shan 08.11.2014
	var giuwPolDistPolbasicV = objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV;
	var shareChangeTag = 0;

	if(giuwPolDistPolbasicV.distFlag == 3 || giuwDistBatch.batchFlag == 2){
		disableButton("btnPostDist");
	}else{
		enableButton("btnPostDist");
	}
	
	function populateDistShare(obj){
		objUW.hidObjGIUWS015.selectedGiuwDistBatch = obj == null ? {} : obj;
		$("txtBatchNo").value = obj == null ? "" : nvl(formatNumberDigits(obj.batchId, 9), "");
		$("txtBatchDate").value = obj == null ? "" : nvl(obj.batchDate, "");
		fireEvent($("showBatchShareBtn"), "click");
	}
	
	$("showBatchShareBtn").observe("click", function(){
		var shareList = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;
		$("distShareListingDiv").update("");
		for(var i=0; i<shareList.length; i++){
			if(shareList[i].recordStatus != -1){
				createBatchDistShareRow(shareList[i]);
			}
		}
		
		resizeTableBasedOnVisibleRowsWithTotalAmount("distShareListingTableDiv", "distShareListingDiv");
		checkTableIfEmptyinModalbox("shareDistRow", "distShareListingTableDiv");
		computeTotalSpct();
		clearShare();
	});

	function prepareShareRowContent(obj){
		var content = '<label style="width: 50%; text-align: left; margin: 0 20px;">'+unescapeHTML2(nvl(obj.dspTrtyName,'-'))+'</label>'+
			  		  '<label style="width: 35%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct,'') == '' ? '-' :formatToNthDecimal(obj.distSpct,9))+'</label>'; // changed decimal places from 14 to 9 : shan 08.12.2014
		return content;
	}

	function createBatchDistShareRow(obj){
		var tableShareContainer = $("distShareListingDiv");
		var content = prepareShareRowContent(obj);
		var newRow = new Element("div");
		newRow.setAttribute("id", "shareDistRow"+obj.batchId+obj.lineCd+obj.shareCd);
		newRow.setAttribute("name", "shareDistRow");
		newRow.setAttribute("batchId", obj.batchId);
		newRow.setAttribute("lineCd", obj.lineCd);
		newRow.setAttribute("shareCd", obj.shareCd);
		newRow.addClassName("tableRow");
		newRow.update(content);
		tableShareContainer.insert({bottom : newRow});
		setBatchDistShareRowObserver(newRow);
		return newRow;
	}

	function setBatchDistShareRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distShareListingDiv', 'shareDistRow', function(){supplyShareDistPerRow(row);}, clearShare);
	}

	function supplyShareDist(obj){
		try{
			objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl	= obj==null?{}:obj;
			$("txtDspTrtyName").value						= unescapeHTML2(nvl(obj==null?'':obj.dspTrtyName,''));
			$("txtDistSpct").value							= nvl(obj==null?null:obj.distSpct,'') == '' ? null :formatToNthDecimal(obj.distSpct,9); // changed decimal places from 14 to 9 : shan 08.12.2014
			$("btnAddShare").value 							= obj==null ? "Add" : "Update";
			
			if (obj == null){
				enableButton("btnTreaty"); 
				enableButton("btnShare");
				disableButton("btnDeleteShare");	
			}else{
				enableButton("btnDeleteShare");
				if (obj.recordStatus == 0){
					enableButton("btnTreaty"); 
					enableButton("btnShare");
				}else{
					disableButton("btnTreaty"); 
					disableButton("btnShare");
				}
			}
				
		}catch(e){
			showErrorMessage("supplyShareDist", e);
		}
	}

	function clearShare(){
		try{
			supplyShareDist(null);
			deselectRows("distShareListingDiv", "shareDistRow");
			$("txtDspTrtyName").focus;
		}catch(e){
			showErrorMessage("clearShare", e);
		}
	}

	function computeTotalSpct(){
		var shareList = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;
		var sumDistSpct = 0;
		for(var i=0; i<shareList.length; i++){
			if(shareList[i].recordStatus != -1){
				sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(shareList[i].distSpct, 0));
			}
		}
		
		$("lblTotalShare").update(formatToNthDecimal(sumDistSpct,9).truncate(30, "..."));  // changed decimal places from 14 to 9 : shan 08.12.2014
	}

	function supplyShareDistPerRow(row){
		try{
			var batchId = row.readAttribute("batchId");
			var lineCd = row.readAttribute("lineCd");
			var shareCd = row.readAttribute("shareCd");
			var objArray = objUW.hidObjGIUWS015.selectedGiuwDistBatch;
			
			for(var i=0; i<objArray.giuwDistBatchDtlList.length; i++){
				if (objArray.giuwDistBatchDtlList[i].batchId == batchId 
					&& objArray.giuwDistBatchDtlList[i].lineCd == lineCd 
					&& objArray.giuwDistBatchDtlList[i].shareCd == shareCd 
					&& objArray.giuwDistBatchDtlList[i].recordStatus != -1){
					supplyShareDist(objArray.giuwDistBatchDtlList[i]);
				}	
			}	
				
		}catch(e){
			showErrorMessage("supplyShareDistPerRow", e);
		}
	}

	function startLOV(id, title, objArray, width){
		try{
			var copyObj = objArray.clone();	
			var copyObj2 = objArray.clone();	
			var selBatchObjArray = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList.clone();
			selBatchObjArray = selBatchObjArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
			var share = objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl;
			for(var a=0; a<selBatchObjArray.length; a++){
				for(var b=0; b<copyObj.length; b++){
					if (selBatchObjArray[a].shareCd == copyObj[b].shareCd){
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
					objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.lineCd = getSelectedRowAttrValue(id+"LovRow", "lineCd");
					objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.shareCd = getSelectedRowAttrValue(id+"LovRow", "cd");
					objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.nbtShareType = getSelectedRowAttrValue(id+"LovRow", "nbtShareType");
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

	function getTreatyShareListing(obj){
		new Ajax.Request(contextPath+"/GIUWPolDistController", {
			parameters : {
				action: "getDistTrtyShareListing",
				lineCd: obj.lineCd,
				sublineCd: obj.sublineCd,
				issCd: obj.isscd,
				issueYy: obj.issueYy,
				polSeqNo: obj.polSeqNo,
				renewNo: obj.renewNo
			},
			asynchronous: false,
			onComplete: function(response){
				objUW.hidObjGIUWS015.distListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
			}
		});
	}

	function checkIfToAddShare(){
		var isValid = true;

		if ($F("txtDspTrtyName") == ""){
			customShowMessageBox("Share is required.", "E", "txtDspTrtyName");
			isValid = false;
			return false;
		}else if ($F("txtDistSpct") == ""){
			customShowMessageBox("% Share is required.", "E", "txtDistSpct");
			isValid = false;
			return false;
		}else if (parseFloat($F("txtDistSpct")) > 100){
			customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct");
			isValid = false;
			return false;
		}else if (parseFloat($F("txtDistSpct")) <= 0){
			customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct");
			isValid = false;
			return false;
		}
		return isValid;
	}

	function setBatchShareObj(){
		var obj = objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl;
		var newObj = new Object();
		newObj.batchId 		= objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.batchId;
		newObj.lineCd 		= obj == null ? "" : obj.lineCd;
		newObj.shareCd 		= obj == null ? "" : obj.shareCd;
		newObj.distSpct 	= escapeHTML2($F("txtDistSpct"));
		newObj.arcExtData	= obj == null ? "" : nvl(obj.arcExtData, "");
		newObj.dspTrtyCd 	= obj == null ? "" : obj.dspTrtyCd;
		newObj.dspTrtyName 	= escapeHTML2($F("txtDspTrtyName"));
		newObj.dspTrtySw	= obj == null ? "" :nvl(obj.dspTrtySw, "");
		return newObj;
	}

	function addDistBatchShare(){
		try{
			if(checkIfToAddShare()){
				var newObj = setBatchShareObj();
				if($("btnAddShare").value == "Add"){
					var newRow = createBatchDistShareRow(newObj);
					newObj.recordStatus = 0;
					objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList.push(newObj);
					shareChangeTag = 1;
					
				}else if($("btnAddShare").value == "Update"){
					var objArray = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;
					for(var i=0; i<objArray.length; i++){
						if(objArray[i].batchId == newObj.batchId  
						   && objArray[i].lineCd == newObj.lineCd 
						   && objArray[i].shareCd == newObj.shareCd
						   && parseFloat(nvl(objArray[i].distSpct, 0)) != parseFloat(nvl(newObj.distSpct,0))){
							   var selectedRow = getSelectedRow("shareDistRow");
							   var content = prepareShareRowContent(newObj);
							   objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList.splice(i,1);
							   newObj.recordStatus = 1;
							   objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList.push(newObj);
							   selectedRow.update(content);
							   shareChangeTag = 1;
							   break;
						}
					}
				}
				
				resizeTableBasedOnVisibleRowsWithTotalAmount("distShareListingTableDiv", "distShareListingDiv");
				checkTableIfEmptyinModalbox("shareDistRow", "distShareListingTableDiv");
				computeTotalSpct();
				clearShare();
			}
		}catch(e){
			showErrorMessage("addDistBatchShare", e);
		}
	}

	function delDistBatchShare(){
		try{
			var selectedRow = getSelectedRow("shareDistRow");
			var objArray = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;

			for(var i=0; i<objArray.length; i++){
				if(objArray[i].batchId == selectedRow.getAttribute("batchId") &&
				   objArray[i].lineCd == selectedRow.getAttribute("lineCd") &&
				   objArray[i].shareCd == selectedRow.getAttribute("shareCd")){
					   if(objArray[i].recordStatus == 0){
						   objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList.splice(i,1);
					   }else{
						   objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList[i].recordStatus = -1;
					   }
					   Effect.Fade(selectedRow,{
							duration: .5,
							afterFinish: function(){
						   		shareChangeTag = 1;
							    selectedRow.remove();
								resizeTableBasedOnVisibleRowsWithTotalAmount("distShareListingTableDiv", "distShareListingDiv");
								checkTableIfEmptyinModalbox("shareDistRow", "distShareListingTableDiv");
								computeTotalSpct();
								clearShare();
							}
						});
					
				}
			}

		}catch(e){
			showErrorMessage("delDistBatchShare", e);
		}
	}

	function validateBeforeSave(){
		var shareList = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;
		var sumDistSpct = 0;
		for(var i=0; i<shareList.length; i++){
			if(shareList[i].recordStatus != -1){
				sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(shareList[i].distSpct, 0));
			}
		}

		if(sumDistSpct != 100 && sumDistSpct != 0){
			showMessageBox("Total %Share should be equal to 100.", "E");
			return false;
		}else{
			return true;
		}
	}

	function checkExistingBinder(postSw){	// shan 08.07.2014
		var ok = true;
		
		new Ajax.Request(contextPath + "/GIUWDistBatchController", {
			method : "POST",
			parameters : {
				action: "checkExistingBinder",
				moduleId: "GIUWS015",
				batchId : nvl(objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.batchId, "")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function(){
				showNotice("Checking Posted Binders, please wait ...");
			},
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if (response.responseText != "SUCCESS"){
						shareChangeTag = 0;
						changeTag = 0;
						changeTagFunc = "";
						populateDistShare(JSON.parse(giuwDistBatchClone.replace(/\\/g, '\\\\')));					 	
						var action = (postSw == null ? "Cannot update" : "Cannot post");
						showMessageBox(action + ' distribution records' +   // of Policy No. ' + response.responseText + 
										'. There are distribution groups with posted binders.', imgMessage.INFO);
						ok = false;	
					}
				}
			}
		});		
		
		if (!ok){
			return false;
		}else {
			return true;
		}	
	}

	function saveBatchDistributionShare(postSw){
		if(!validateBeforeSave()){
			return;
		}
		if(!checkExistingBinder(postSw)){	// shan 08.07.2014
			return;
		}
		var objArray = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;
		
		var objParameters = new Object();
		objParameters.setDistBatchDtl = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objArray));
		objParameters.delDistBatchDtl = prepareJsonAsParameter(getDeletedJSONObjects(objArray));

		new Ajax.Request(contextPath+"/GIUWDistBatchController", {
			method: "POST",
			asynchronous: false,
			parameters :{
				action: "saveBatchDistrShare",
				parameters : JSON.stringify(objParameters),
				batchId:	objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.batchId,	// shan 08.08.2014
				moduleId:	"GIUWS015",													// shan 08.08.2014
				lineCd: 	objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.lineCd	// shan 08.11.2014
			},
			onCreate: function(){
				showNotice("Saving Batch Distribution Share");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);	// shan 08.11.2014
					if(/*response.responseText*/ res.msg == "SUCCESS"){
						if(postSw == "withPost"){
							postBatchDistribution();
						}else{
							if (res.batchFlag == "1"){	// shan 08.11.2014
								enableButton("btnPostDist");
							}
							showMessageBox(objCommonMessage.SUCCESS, "S");
						}						
						clearObjectRecordStatus(objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList);
						shareChangeTag = 0;
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}

	$("txtDistSpct").observe("blur", function(){
		
		/*  Check if %Share is not greater than 100 */ 
		if (parseFloat($F("txtDistSpct")) > 100){
			customShowMessageBox("%Share cannot exceed 100.", "E", "txtDistSpct");
			return false;
		}	
		if (parseFloat($F("txtDistSpct")) <= 0){
			customShowMessageBox("%Share must be greater than zero.", "E", "txtDistSpct");
			return false;
		}

		$("txtDistSpct").value = formatToNthDecimal($("txtDistSpct").value, 9); // changed decimal places from 14 to 9 : shan 08.12.2014
		
	});

	$("btnShare").observe("click", function(){
		/*getTreatyShareListing(objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV);
		var objArray = objUW.hidObjGIUWS015.distListing.distShareListingJSON;
		startLOV("GIUWS015-Share", "Share", objArray, 540);*/ // replaced by: Nica 05.18.2012
		
		var notIn = "";
		$$("div#distShareListingDiv div[name='shareDistRow']").each(function(row){
			if(notIn != ""){
				notIn += ",";
			}
			notIn += row.getAttribute("shareCd");
		});
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getBatchDistShareLOV",
							lineCd: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.lineCd,
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
				objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.lineCd = row.lineCd;
				objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.shareCd = row.shareCd;
				objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.nbtShareType = row.shareType;
			}
		  });
	});

	$("btnTreaty").observe("click", function(){
		/*getTreatyShareListing(objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV);
		var objArray = objUW.hidObjGIUWS015.distListing.distTreatyListingJSON;
		startLOV("GIUWS015-Treaty", "Treaty", objArray, 540);*/
		var notIn = "";
		$$("div#distShareListingDiv div[name='shareDistRow']").each(function(row){
			if(notIn != ""){
				notIn += ",";
			}
			notIn += row.getAttribute("shareCd");
		});
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getBatchDistTreatyLOV",
							lineCd: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.lineCd,
							sublineCd: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.sublineCd,
							issCd: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.isscd,
							issueYy: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.issueYy,
							polSeqNo: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.polSeqNo,
							renewNo: objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.renewNo,
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
				objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.lineCd = row.lineCd;
				objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.shareCd = row.shareCd;
				objUW.hidObjGIUWS015.selectedGiuwDistBatchDtl.nbtShareType = row.shareType;
			}
		  });
	});

	$("btnAddShare").observe("click", function(){
		addDistBatchShare();
	});

	$("btnDeleteShare").observe("click", function(){
		delDistBatchShare();
	});

	$("btnSaveShare").observe("click", function(){
		if(shareChangeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveBatchDistributionShare();
		}
	});

	$("btnPostDist").observe("click", function(){
		if(shareChangeTag == 1){
			showConfirmBox3("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No",
						function(){
							saveBatchDistributionShare("withPost");
						},
						function(){
							 showMessageBox("Distribution has been cancelled!","I");
						});
		}else{
			var shareList = objUW.hidObjGIUWS015.selectedGiuwDistBatch.giuwDistBatchDtlList;
			var sumDistSpct = 0;
			for(var i=0; i<shareList.length; i++){
				if(shareList[i].recordStatus != -1){
					sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(shareList[i].distSpct, 0));
				}
			}

			if(sumDistSpct == 0){
				//fireEvent($("MB_close"), "click");	// replaced by code below : shan 08.07.2014
				overlayBatchDistShare.close();	
				return false;
			}else if(sumDistSpct != 100){
				showMessageBox("Total %Share should be equal to 100.", "E");
				return false;
			}
			if(!checkExistingBinder("withPost")){	// shan 08.07.2014
				return;
			}
			//postBatchDistribution(); // moved inside checkExpiredTreatyShare : shan 08.11.2014
			checkExpiredTreatyShare();
		}
	});

	$("btnClose").observe("click", function(){
		function close(){
			//fireEvent($("MB_close"), "click");	// replaced by code below : shan 08.07.2014
			overlayBatchDistShare.close();	
		}

		if(shareChangeTag == 1){
			showConfirmBox3("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", saveBatchDistributionShare, close);
		}else{
			close();
		}
	});

	//for checking of expired portfolio share shan 08.11.2014
	function checkExpiredTreatyShare (){
		var batchId = objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.batchId;
		
		new Ajax.Request(contextPath+"/GIUWDistBatchController",{
			parameters: {
				action: "getTreatyExpiry",
				batchId: batchId,
				moduleId: "GIUWS015"
			},
			onCreate: function(){
				showNotice("Validating Treaty, please wait");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var comp = JSON.parse(response.responseText);	
						 if(comp.vExpired == "Y"){
							 showMessageBox("Cannot post " + comp.policyNo + ". Treaty " + comp.treatyName +" has already expired. Replace the treaty with another one.", imgMessage.ERROR);
						 }else{
							 postBatchDistribution();
						 }
					}
				}
			}
		});
	}
	//ended shan 08.11.2014
	
	initializeAll();	
	populateDistShare(giuwDistBatch);
	//$("MB_close").hide();
	
</script>
	
