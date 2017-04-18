<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
	request.setAttribute("path", request.getContextPath());
%>

<div id=lineSublineMainDiv name="lineSublineMainDiv" style="margin-top: 1px; height: 400px;" >
	<form id="lineSublineForm" name="lineSublineForm">
		<div id="lineSublineFormDiv" name="lineSublineFormDiv" class="sectionDiv"  align=""  style="width: 540px;">
			<div id="lineSublineInfoTableTG" style="height: 230px; margin-top: 10px; margin-left: 10px; "></div>
			
			<div id="lineSublineInfoFormDiv" name="lineSublineInfoFormDiv" style=" margin: 10px 0px 5px 0px" >
				<table align="center" width="70%">
					<tr>
						<td class="rightAligned" width="20%">Line</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displayLine" readonly="readonly" class="required" style="width: 67%; display: none; height: 14px;" />
							<select id="packLineCdOpt" name="packLineCdOpt" style="width: 70%;" class="required">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="20%">Subline</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displaySubline" readonly="readonly" class="required" style="width: 67%; display: none; height: 14px;" />
							<select id="packSublineCdOpt" name="packSublineCdOpt" style="width: 70%;" class="required" moduleType="marketing" lastValidValue="">
								<option value=""></option>
								
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 69.3%; background-color: #FFFFFF" changeTagAttr="true">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);"  id="remarks" name="remarks" style="width: 87%; border: none; height: 13px; background-color: transparent;" ></textarea>
							<img class="hover" src="${path}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
						</td>
					</tr>
				</table>				
			</div>		
			<div style="margin-bottom: 10px;" changeTagAttr="true" align="center">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="infoButtonsDiv" style="width: 545px;">
			<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
		</div>
		
	</form>
</div>

<script>
	var objLineSubline =  JSON.parse('${objLineSubline}'.replace(/\\/g, '\\\\'));
	var year = "${year}";
	setPackLineCd2(objLineSubline);
	var objPackQuotations = JSON.parse('${jsonPackQuotations}'.replace(/\\/g, '\\\\'));
	var newItemIndex = 0;
	var enableEditRemarks = true; // added by steven 11/5/2012
	var selectedIndex = false; // added by steven 11/5/2012
	var lineCdTemp = "";
	var lineNameTemp = "";
	var sublineCdTemp = "";
	var sublineNameTemp = "";
	var rowIndex = -1;
	var subQuotationNo = "";
	
	if (objMKGlobal.proposalNo != 0){ // V0708 WHEN-NEW-BLOCK-INSTANCE
		$("btnAdd").hide();
		$("btnDelete").hide();
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnSave");
		$("lineSublineForm").disable();
	}

	function reloadQuotation(){
		tbgLineSublinePack._refreshList();
		if (tbgLineSublinePack.geniisysRows.length == 0) {	//Gzelle 10.03.2013 - disable mortgagee button if all lineSublines are deleted
			disableButton("btnMortgageeInformation");
			$("quotePackMortgagee").hide();
		}else {
			enableButton("btnMortgageeInformation");
		}
		overlayPackQuoteLineSubline.hide();
	}

	var objCurrlineSublinePack = null;
	var lineSublinePackQuoteTable = {
			url : contextPath + "/GIPIQuotationController?action=getPackLineSublineTG&lineCd="+$F("lineCd")+"&packQuoteId="+$F("globalPackQuoteId")+"&userId="+objGIPIPackQuote.userId,
			options : {
				width : '520px',
				hideColumnChildTitle : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objCurrlineSublinePack = tbgLineSublinePack.geniisysRows[y];
					setFieldValues(objCurrlineSublinePack);
					tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
					tbgLineSublinePack.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
					tbgLineSublinePack.keys.releaseKeys();
					$("packLineCdOpt").focus();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						rowIndex = -1;
						setFieldValues(null);
						tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
						tbgLineSublinePack.keys.releaseKeys();
					}
				},
				beforeSort : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
					tbgLineSublinePack.keys.releaseKeys();
				},
				onRefresh : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
					tbgLineSublinePack.keys.releaseKeys();
				},
				prePager : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
					tbgLineSublinePack.keys.releaseKeys();
				},
				checkChanges : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetail : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc : function() {
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [ 
				{ 						 // this column will only use for deletion
					id : 'recordStatus', // 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				}, 
				{
					id : 'lineCd',
					title : 'Line',
					filterOption : true,
					width : '80px'
				},
				{
					id : 'sublineCd',
					title : 'Subline',
					filterOption : true,
					width : '80px'
				},
				{
					id : 'issCd',
					title : 'Code',
					filterOption : true,
					width : '80px'
				},
				{
					id : 'quotationYy',
					title : 'Year',
					filterOption : true,
					width : '80px'
				},
				{
					id : 'quotationNo',
					title : 'Quote',
					filterOption : true,
					width : '80px'
				},
				{
					id : 'proposalNo',
					title : 'No',
					filterOption : true,
					width : '80px'
				}
			],
			rows : objPackQuotations.rows
		};
		
		tbgLineSublinePack = new MyTableGrid(lineSublinePackQuoteTable);
	 	tbgLineSublinePack.pager = objPackQuotations;
		tbgLineSublinePack.render("lineSublineInfoTableTG");	
		
	function setFieldValues(rec){
		try{
			$("displayLine").value 	  = (rec == null ? "" : unescapeHTML2(rec.lineCd) + "-" + unescapeHTML2(rec.lineName));
			$("displaySubline").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd) + "-" + unescapeHTML2(rec.sublineName));
			$("remarks").value 	 	  = (rec == null ? "" : unescapeHTML2(rec.remarks));
			subQuotationNo 			  = (rec == null ? "" : (unescapeHTML2(rec.lineCd)+"-"+unescapeHTML2(rec.sublineCd) +"-"+unescapeHTML2(rec.issCd) +"-"+
	  									 rec.quotationYy +"-"+formatNumberDigits(rec.quotationNo,6) +"-"+formatNumberDigits(rec.proposalNo,3)));
			
			//rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? enableButton("btnAdd") : disableButton("btnAdd");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableInputField("remarks") : disableInputField("remarks") ;
			rec == null ? enableEditRemarks = true : enableEditRemarks = false; 
			rec == null ? $("displayLine").hide() : $("displayLine").show();
			rec == null ? $("displaySubline").hide() : $("displaySubline").show();
			rec == null ? $("packLineCdOpt").show() : $("packLineCdOpt").hide();
			rec == null ? $("packSublineCdOpt").show() : $("packSublineCdOpt").hide();
			objCurrlineSublinePack = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
		
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.quoteId 			= newItemIndex; //  adds temp quoteId(index)
			obj.packQuoteId 		= objMKGlobal.packQuoteId;
			obj.lineCd 				= $F("packLineCdOpt");
			obj.lineName 			= $("packLineCdOpt").options[$("packLineCdOpt").selectedIndex].getAttribute("lineName");
			obj.sublineCd 			= $F("packSublineCdOpt");
			obj.sublineName 		= $("packSublineCdOpt").options[$("packSublineCdOpt").selectedIndex].getAttribute("packSubLineName");
			obj.issCd 				= objMKGlobal.issCd;
			obj.issName 			= objMKGlobal.issName;
			obj.proposalNo 			= objMKGlobal.proposalNo;
			obj.quotationYy 		= objMKGlobal.quotationYy;
			obj.remarks 			= $F("remarks");
			obj.assdNo 				= objMKGlobal.assdNo;
			obj.assdName 			= objMKGlobal.assdName;
			obj.inceptDate	 		= objMKGlobal.inceptDate;
			obj.expiryDate 			= objMKGlobal.expiryDate;
			obj.credBranch 			= objMKGlobal.credBranchName;
			obj.userId 				= objMKGlobal.userId;
			obj.address1 			= objMKGlobal.address1;
			obj.address2 			= objMKGlobal.address2;
			obj.address3 			= objMKGlobal.address3;
			obj.acctOfCd 			= objMKGlobal.acctOfCd;
			obj.underwriter 		= objMKGlobal.underwriter;
			obj.inceptTag 			= objMKGlobal.inceptTag;
			obj.expiryTag 			= objMKGlobal.expiryTag;
			obj.header 				= objMKGlobal.expiryTag;
			obj.footer 				= objMKGlobal.footer;
			obj.reasonCd 			= objMKGlobal.reasonCd;
			obj.compSw 				= objMKGlobal.compSw;
			obj.prorateFlag 		= objMKGlobal.prorateFlag;
			obj.shortRatePercent 	= objMKGlobal.shortRatePercent;
			obj.bankRefNo  			= objMKGlobal.bankRefNo;
			obj.acceptDate  		= objMKGlobal.acceptDate;
			obj.validDate   		= objMKGlobal.validDate;
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function savePackLineSubline(){
		try{
			if(changeTag == 0) {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			var addRows = getAddedAndModifiedJSONObjects(tbgLineSublinePack.geniisysRows);
			var delRows = getDeletedJSONObjects(tbgLineSublinePack.geniisysRows);
			var objParameters = new Object();
			objParameters.addRows = addRows;
			objParameters.delRows = delRows;
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath+"/GIPIQuotationController?action=savePackLineSubline", {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					packQuoteId: objMKGlobal.packQuoteId,
					lineCd: objMKGlobal.lineCd,
					issCd: objMKGlobal.issCd,
					parameter: strParameters
				},
				onCreate: function(){
					showNotice("Saving changes...");
					$("lineSublineForm").disable();
				},
				onComplete: function (response)	{
					if (checkErrorOnResponse(response)) {
						hideNotice(response.responseText);
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, reloadQuotation);
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
						$("lineSublineForm").enable();
						changeTag = 0;
					}
				}
			});
		}catch(e){
			showErrorMessage("savePackLineSubline",e);
		}	
	}	

	
	function addLineSubline(){
		try{
			var rec = setRec(objCurrlineSublinePack);
			if($F("btnAdd") == "Add"){
				tbgLineSublinePack.addBottomRow(rec);
			} else {
				tbgLineSublinePack.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
	 		setFieldValues(null);
	 		resetFields();
			tbgLineSublinePack.keys.removeFocus(tbgLineSublinePack.keys._nCurrentFocus, true);
			tbgLineSublinePack.keys.releaseKeys();
		}catch(e){
			showErrorMessage("addLineSubline", e);
		}	

	}
	
	function deleteRec(){
		objCurrlineSublinePack.recordStatus = -1;
		tbgLineSublinePack.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function validateLineSubline(){
		if ($F("btnAdd") == "Add"){
			if($F("packLineCdOpt") == ""){	//modified message and message type - Gzelle 10.03.2013
				showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
				return false;
			}else if($F("packSublineCdOpt") == ""){
				showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
				return false;
			}else if(!checkExistLineSubline()){ // added by: Nica 05.30.2012 - to check if line-subline is already existing
				$("packLineCdOpt").value = "";
				$("packSublineCdOpt").value = "";
			}else{
				addLineSubline();
			}
		}else{
			addLineSubline();
		}	
	}
	
	function checkExistLineSubline(){
		try {
			var packLineCd = $F("packLineCdOpt");
			var packSublineCd = $F("packSublineCdOpt");
			var lineExist = false;
			var sublineExist = false;
			if($F("btnAdd") == "Add") {
				for(var i=0; i<tbgLineSublinePack.geniisysRows.length; i++){
					if(tbgLineSublinePack.geniisysRows[i].recordStatus == 0 || tbgLineSublinePack.geniisysRows[i].recordStatus == 1){								
						if(tbgLineSublinePack.geniisysRows[i].lineCd == packLineCd){
							lineExist = true;		
						}	
						if(tbgLineSublinePack.geniisysRows[i].sublineCd == packSublineCd){
							sublineExist = true;		
						}
					}
				}
				
				if(lineExist && sublineExist){
					showMessageBox("Cannot create same record.");
					return;
				}else {
					addLineSubline();
				}
			}else {
				addLineSubline();
			}
		} catch (e) {
			showErrorMessage("checkExistLineSubline", e);
		}
	}
	
	
	function deleteLineSubline(){
		try{
			showConfirmBox("Confirm", "Are you sure you want to delete quotation number " + subQuotationNo + "?", 
					"Yes", "No", deleteRec, "","");
		}catch(e){
			showErrorMessage("deleteLineSubline", e);
		}
	}

	function resetFields(){
		$("packLineCdOpt").selectedIndex = 0;
		$("displayLine").clear();
		$("displayLine").hide();
		$("packSublineCdOpt").selectedIndex = 0;
		$("displaySubline").clear();
		$("displaySubline").hide();
		$("packLineCdOpt").show();
		$("packSublineCdOpt").show();
		$("packSublineCdOpt").update("");
		$("remarks").clear();
		$("remarks").show();
		$("remarks").disabled = false;
		$("editRemarks").show();
	}
	
	$("packLineCdOpt").observe("change", function(){
		setPackSublineCd(objLineSubline);
	});
	
	$("packSublineCdOpt").observe("change", function(){
		$("packSublineCdOpt").setAttribute("lastValidValue", $("packSublineCdOpt").options[$("packSublineCdOpt").selectedIndex].getAttribute("packSubLineName"));
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);
		}else if(getAddedJSONObjects(tbgLineSublinePack.geniisysRows).length == 0 && getDeletedJSONObjects(tbgLineSublinePack.geniisysRows).length == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);		//Gzelle 10.03.2013 - when Add/Delete button is clicked without any records
		}else{
			savePackLineSubline();
		}
	});

	$("btnAdd").observe("click", validateLineSubline);
	
	$("btnDelete").observe("click", deleteLineSubline);

	$("editRemarks").observe("click", function () {
		if (enableEditRemarks){ //added by steven 11/5/2012
			showOverlayEditor("remarks", 4000, false);
		}else{
			showOverlayEditor("remarks", 4000, true);
		}
	});

	addStyleToInputs();
	initializeAll();
	setDocumentTitle("Line and Subline Coverages");
	observeCancelForm("btnCancel", savePackLineSubline, function(){
		overlayPackQuoteLineSubline.hide();
	});
</script>