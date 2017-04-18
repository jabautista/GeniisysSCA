<!-- Remarks: For deletion
Date : 05-02-2012
Developer: Steven P. Ramirez
Replacement : /pages/underwriting/par/warrantyAndClauses/warrantyAndClausesTableGrid.jsp
 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="warrantyAndClauseMainDiv" name="warrantyAndClauseMainDiv"	style="margin-top: 1px; display: none;">
	<div id="message" style="display: none;">${message}</div>
	<div></div>
	<form id="warrantyAndClauseForm" name="warrantyAndClauseForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv"	name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label>Warranties and Clauses</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="warrantyAndClauseDiv" name="warrantyAndClauseDiv" class="sectionDiv">
			<jsp:include page="/pages/underwriting/par/warrantyAndClauses/warrantyAndClausesTable.jsp"></jsp:include>
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px;" changeTagAttr="true">
				<table align="center">
					<tr style="display: none;" id="message" name="message">
						<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Title</td>
						<td colspan="4" class="leftAligned">
							<span class="required lovSpan" style="width: 430px;">
								<input type="hidden" id="hidWcCd" name="hidWcCd"> 								
								<input type="text" id="txtWarrantyTitle" name="txtWarrantyTitle" style="width: 405px; float: left; border: none; height: 13px; margin: 0;" class="required" readonly="readonly"></input>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarrantyTitle" name="btnWarrantyTitle" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td class="leftAligned" colspan="3"><input type="text" id="inputWarrantyTitle2" name="inputWarrantyTitle2" style="width: 191px;" maxlength="100"></input></td>
					</tr>
					<tr>
						<td class="rightAligned">Type</td>
						<td class="leftAligned" width="120px;"><input type="text" id="inputWarrantyType" name="inputWarrantyType" style="width: 100px;" readonly="readonly"></input></td>
						<td class="rightAligned">Print Sequence No. </td>
						<td class="leftAligned"><input type="text" id="inputPrintSeqNo" class="required integerNoNegativeUnformatted" maxlength="2" style="width: 40px;" errorMsg="Invalid Print Sequence No. Value should be from 1 to 99."/></td>
						<td class="rigthAligned">Print Switch</td>
						<td class="leftAligned"><input type="checkbox" id="inputPrintSwitch" name="inputPrintSwitch" value="Y"></td>
						<td class="rightAligned">Change Tag</td>
						<td class="leftAligned" width="60px;"><input type="checkbox" id="inputChangeTag" name="inputChangeTag" value="Y"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Text</td>
						<td colspan="7" class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 642px;">
								<input type="hidden" id="hidOrigWarrantyText" name="hidOrigWarrantyText" style="width: 610px; border: none; height: 13px;"></input>
								<textarea id="inputWarrantyText" name="inputWarrantyText" style="width: 610px; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="7" class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 642px;">
								<textarea id="inputWcRemarks" name="inputWcRemarks" style="width: 610px; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWcRemarks" />
							</div>
						</td>
					</tr>
				</table>
				<div style="width: 100%; margin: 10px 0;" align="center" >
					<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
					<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" disabled="disabled" />
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnCancel" value="Cancel">
						<input type="button" class="button" id="btnSave" value="Save">
					</td>
				</tr>
			</table>		
		</div>
	</form>
</div>

<script type="text/javascript">
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	var currentRow = -1;
	var changeTextSw = "N";
	var lastRowNo = 0;
	//var objWC = JSON.parse('${warrClauses}'.replace(/\\/g, '\\\\'));
	var objWC = JSON.parse('${warrClauses}');
	
	disableMenu("distribution");
	var riSwitch = $F("globalIssCd") == "RI" ? "Y" : "";
	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	parType = '${parType}';
	changeTag = 0;
	initializeChangeTagBehavior(saveGIPIWPolWC);
	initializeChangeAttribute();
	hideNotice();
	
	if(parType == "P") {
		setDocumentTitle("Policy - Warranties and Clauses");
		setModuleId("GIPIS024");
	} else if (parType == "E"){
		setDocumentTitle("Warranties and Clauses Entry - Endorsement");
		setModuleId("GIPIS035");
		$("print").hide();  //hides print in the menu
	}
	
	if(objWC.length > 0){
		for(var i=0; i<objWC.length; i++){
			var rowContent = generateWCRow(objWC[i], i);
			addTableRow("wcRow"+objWC[i].parId+objWC[i].wcCd, "wcRow","wcList", rowContent, clickWCRow);
			$("wcRow"+objWC[i].parId+objWC[i].wcCd).writeAttribute("wcCd", objWC[i].wcCd);
			$("wcRow"+objWC[i].parId+objWC[i].wcCd).writeAttribute("printSeqNo", objWC[i].printSeqNo);
			$("wcRow"+objWC[i].parId+objWC[i].wcCd).writeAttribute("origWarrantyText", getWarrantyText(objWC[i]));
			$("wcRow"+objWC[i].parId+objWC[i].wcCd).writeAttribute("index", i); // added by: Nica 11.21.2011
			lastRowNo = i + 1;
		}
		checkIfToResizeTable2("wcList", "wcRow");
	}else{
		checkTableIfEmpty2("wcRow", "wcList");
	}

	function getWarrantyText(obj){
		var text =  nvl(obj.wcText1,"")+nvl(obj.wcText2,"")+nvl(obj.wcText3,"")+nvl(obj.wcText4,"")+nvl(obj.wcText5,"")+
		  			nvl(obj.wcText6,"")+nvl(obj.wcText7,"")+nvl(obj.wcText8,"")+nvl(obj.wcText9,"")+nvl(obj.wcText10,"")+
	      			nvl(obj.wcText11,"")+nvl(obj.wcText12,"")+nvl(obj.wcText13,"")+nvl(obj.wcText14,"")+nvl(obj.wcText15,"")+ 
		  			nvl(obj.wcText16,"")+nvl(obj.wcText17,"");
		return text;
	}
	
	function generateWCRow(objWC, index){
		try{
			var wcTitle = objWC.wcTitle == null ? "" : objWC.wcTitle;
			var wcTitle2 = objWC.wcTitle2 == null ? "" : objWC.wcTitle2;
			var printSeqNo = objWC.printSeqNo == null ? "0" : objWC.printSeqNo;
			var wcText1 = objWC.wcText1 == null ? "" : changeSingleAndDoubleQuotes(objWC.wcText1);
			var wcText2 = objWC.wcText2 == null ? "" : changeSingleAndDoubleQuotes(objWC.wcText2);
			
			var content = '<input type="hidden" value="'+index+'"/>' + 
			'<input type="hidden" id="recFlag" value="'+objWC.recFlag+'"/>' +
			'<input type="hidden" id="swcSeqNo" value="'+nvl(objWC.swcSeqNo, 0)+'"/>' + 	
			'<label style="width: 28%; text-align: left; margin-left: 5px;" title="'+wcTitle+(wcTitle2 == "" ? "" : " - ")+wcTitle2+'" name="title" id="title'+objWC.wcCd+'">'+(changeSingleAndDoubleQuotes(wcTitle)+(wcTitle2 == "" ? "" : " - ")+changeSingleAndDoubleQuotes(wcTitle2)).truncate(30, "...")+'</label>'+
			'<label style="width: 9.5%; text-align: left;">'+objWC.wcSw+'</label>'+
	   		'<label style="width: 7.5%; text-align: right; margin-right: 30px;">'+parseInt(printSeqNo)+'</label>'+
			'<label style="width: 40%; text-align: left;" id="text'+objWC.wcCd+'" name="text" title="Click to view complete text.">'+(wcText1== "" ? "-" : (wcText1+wcText2).truncate(50, "..."))+'</label>'+
			'<label style="width: 3%; text-align: left;">';
			
			if (objWC.printSw == 'Y') {
				content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
			} else {
				content += '<span style="float: left; width: 10px; height: 10px; margin-left: 10px;">-</span>';
			}
			
			content += '</label><label style="width: 3%; text-align: center;">';
	
			if (objWC.changeTag == 'Y') {
				content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
			} else {
				content += '<span style="float: left; width: 10px; height: 10px; margin-left: 10px;">-</span>';
			}
				content += '</label>';
	
			return content;
		}catch(e){
			showErrorMessage("generateWCRow", e);
		}
	}

	function clickWCRow(row){
		try{
			$$("div[name='wcRow']").each(function(r){
				if(row.id != r.id){
					r.removeClassName("selectedRow");
				}
			});
	
			currentRow = row.getAttribute("index");
	
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				populateWarrantyAndClauseForm(objWC[currentRow]);
				enableButton("btnDelete");
				$("searchWarrantyTitle").hide();
				$("btnAdd").value = "Update";
			}else{
				resetWarrAndClauseFormFields();
				($$("div#warrantyAndClauseDiv [changed=changed]")).invoke("removeAttribute", "changed");
			}
		}catch(e){
			showErrorMessage("clickWCRow", e);
		}
	}

	function populateWarrantyAndClauseForm(objWC){
		try{
			$("hidWcCd").value = objWC.wcCd == null ? "" : objWC.wcCd;
			$("txtWarrantyTitle").value 	= objWC.wcTitle == null ? "" : objWC.wcTitle;
			$("inputWarrantyTitle2").value 	= objWC.wcTitle2 == null ? "" : changeSingleAndDoubleQuotes(objWC.wcTitle2);
			$("inputWarrantyType").value 	= objWC.wcSw == null ? "" : changeSingleAndDoubleQuotes(objWC.wcSw);
			$("inputPrintSeqNo").value 		= objWC.printSeqNo == null ? "" : objWC.printSeqNo;
			$("inputPrintSwitch").checked 	= (objWC.printSw == 'Y' ? true : false);
			$("inputChangeTag").checked 	= (objWC.changeTag == 'Y' ? true : false);
			$("inputWarrantyText").value 	= (objWC.wcText1 == null ? "" : changeSingleAndDoubleQuotes(objWC.wcText1))+ (objWC.wcText2 == null ? "" : changeSingleAndDoubleQuotes(objWC.wcText2));
			$("inputWcRemarks").value		= objWC.wcRemarks == null ? "" : changeSingleAndDoubleQuotes(objWC.wcRemarks);
			$("hidOrigWarrantyText").value  = getWarrantyText(objWC);  
		}catch(e){
			showErrorMessage("populateWarrantyAndClauseForm", e);
		}
	}

	function synchWCListDetails(){
		try{
			var title = $F("txtWarrantyTitle");
			$("inputWarrantyType").value 	= title.getAttribute("wcSw") == null ? "" : title.getAttribute("wcSw");
			$("inputPrintSwitch").checked 	= title.getAttribute("printSw") == 'Y' ? true : false;
			$("inputWarrantyText").value 	= title.getAttribute("wcText") == null ? "" : title.getAttribute("wcText");
	
			var max = 0;
	
			if(title.value != null || title.value != ""){
				for(var i=0; i<objWC.length; i++){
					if(parseInt(objWC[i].printSeqNo) > max && objWC[i].recordStatus != -1){
						max = parseInt(objWC[i].printSeqNo);
					}
				}
				
				$("inputPrintSeqNo").value = max + 1;
			}
		}catch(e){
			showErrorMessage("synchWCListDetails", e);
		}
	}

	function setWCObject(recStatus, recFlag){
		try{
			var objWarrCla = new Object();
			var wcText = $("inputChangeTag").checked ? $F("inputWarrantyText"): $F("hidOrigWarrantyText");
			
			objWarrCla.wcCd 	= changeSingleAndDoubleQuotes2($F("hidWcCd"));
			objWarrCla.parId	= parseInt(objUWGlobal.parId != null ? objUWGlobal.parId :  $F("globalParId"));
			objWarrCla.lineCd 	= changeSingleAndDoubleQuotes2(objUWGlobal.lineCd != null ? objUWGlobal.lineCd :  $F("globalLineCd"));
			objWarrCla.wcSw 	= changeSingleAndDoubleQuotes2($("inputWarrantyType").value);
			objWarrCla.wcTitle 	= changeSingleAndDoubleQuotes2($F("txtWarrantyTitle"));
			objWarrCla.wcTitle2 = changeSingleAndDoubleQuotes2($("inputWarrantyTitle2").value);
			objWarrCla.wcRemarks = changeSingleAndDoubleQuotes2($("inputWcRemarks").value);
			objWarrCla.wcText1 	= changeSingleAndDoubleQuotes2(wcText.substring(0, 4000));
			objWarrCla.wcText2 	= changeSingleAndDoubleQuotes2(wcText.substring(4000, 8000));
			objWarrCla.wcText3 	= changeSingleAndDoubleQuotes2(wcText.substring(8000, 12000));
			objWarrCla.wcText4 	= changeSingleAndDoubleQuotes2(wcText.substring(12000, 16000));
			objWarrCla.wcText5	= changeSingleAndDoubleQuotes2(wcText.substring(16000, 20000));
			objWarrCla.wcText6 	= changeSingleAndDoubleQuotes2(wcText.substring(20000, 24000));
			objWarrCla.wcText7 	= changeSingleAndDoubleQuotes2(wcText.substring(24000, 28000));
			objWarrCla.wcText8 	= changeSingleAndDoubleQuotes2(wcText.substring(28000, 32000));
			objWarrCla.wcText9 	= changeSingleAndDoubleQuotes2(wcText.substring(32000));
			objWarrCla.changeTag= $("inputChangeTag").checked ? "Y" : "N";
			objWarrCla.printSw 	= $("inputPrintSwitch").checked ? "Y" : "N";
			objWarrCla.printSeqNo= $("inputPrintSeqNo").value;
			objWarrCla.swcSeqNo	= 0;
			objWarrCla.recFlag  = recFlag;
			objWarrCla.recordStatus = recStatus;
		
			return objWarrCla;
		}catch(e){
			showErrorMessage("setWCObject", e);
		}
	}

	$("editWarrantyText").observe("click", function () {
		showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", resetText, checkChangeTag);
	});

	function checkChangeTag() {
		$("inputChangeTag").checked = true;
	}

	function resetText() {
		try{
			var defaultText = "";
			if($F("inputWarrantyText") != ""){
				defaultText = $F("hidOrigWarrantyText");
			}
			$("inputWarrantyText").value = defaultText;
			$("inputChangeTag").checked = false;
		}catch(e){
			showErrorMessage("resetText", e);
		}
	}

	$("editWcRemarks").observe("click", function(){
		showEditor("inputWcRemarks", 2000);
	});

	$("inputWarrantyText").observe("keyup", function(){
		limitText(this, 34000);
	});

	$("inputWcRemarks").observe("keyup", function(){
		limitText(this, 2000);
	});

	$("inputWcRemarks").observe("change", function(){
		limitText(this, 2000);
	});

	$("inputWarrantyText").observe("change", function(){
		if(!$("inputChangeTag").checked){
			showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No",
						    function(){
			    				$("inputChangeTag").checked = true;
			    				limitText($("inputWarrantyText"), 34000);
							},
							function(){
								$("inputWarrantyText").value = $F("hidOrigWarrantyText");
								limitText($("inputWarrantyText"), 34000);
							});
		}else{
			limitText($("inputWarrantyText"), 34000);
		}
	});

	$("inputPrintSeqNo").observe("blur", function(){
		var wcPrintSeqNo 	= this.value;
	
		if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".") || isNaN(parseFloat(wcPrintSeqNo))) {
			showMessageBox("Invalid Print Sequence No. Value should be from 1 to 99.");
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}else if(checkIfPrintSeqNoExist(wcPrintSeqNo)){
			showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}
	});

	$("btnAdd").observe("click", function(){
		var rowContent = "";
		
		if(checkWCRequiredFields() && checkRemarksLength() && checkWarrantyTextLength()){
			changeTag = 1;
			if(this.value == "Add"){
				var recFlag = "A";
				var objAdded = setWCObject(0, recFlag);
				if(checkIfWarrantyTitleExist(objAdded.wcCd)){
					if(checkIfPrintSeqNoExist(objAdded.printSeqNo)){
						showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
						$("inputPrintSeqNo").clear();
						$("inputPrintSeqNo").focus();
						return false;
					}
					
					objWC.push(objAdded);
					rowContent = generateWCRow(objAdded,lastRowNo);
					addTableRow("wcRow"+objAdded.parId+objAdded.wcCd, "wcRow","wcList", rowContent, clickWCRow);
					$("wcRow"+objAdded.parId+objAdded.wcCd).writeAttribute("wcCd", objAdded.wcCd);
					$("wcRow"+objAdded.parId+objAdded.wcCd).writeAttribute("printSeqNo", objAdded.printSeqNo);
					$("wcRow"+objAdded.parId+objAdded.wcCd).writeAttribute("origWarrantyText", getWarrantyText(objAdded));
					$("wcRow"+objAdded.parId+objAdded.wcCd).writeAttribute("index", lastRowNo); // added by: Nica 11.21.2011
					lastRowNo = lastRowNo + 1;
				}
			
				
			}else if(this.value == "Update"){
				var objModified = setWCObject(1, "");
					
				for(var i=0; i<objWC.length; i++){
					if(objModified.wcCd == objWC[i].wcCd){
						var recFlag = objWC[i].recFlag; // this saves the original rec_flag value
						objWC.splice(i, 1, objModified);
						objWC[i].recFlag = recFlag; // returns the value of the recFlag
						rowContent = generateWCRow(objModified,i);
						$("wcRow"+objModified.parId+objModified.wcCd).update(rowContent);
						$("wcRow"+objModified.parId+objModified.wcCd).removeClassName("selectedRow");
						$("wcRow"+objModified.parId+objModified.wcCd).writeAttribute("wcCd",objModified.wcCd);
						$("wcRow"+objModified.parId+objModified.wcCd).writeAttribute("printSeqNo", objModified.printSeqNo);
						$("wcRow"+objModified.parId+objModified.wcCd).writeAttribute("origWarrantyText", getWarrantyText(objModified));
						$("wcRow"+objModified.parId+objModified.wcCd).writeAttribute("index", i); // added by: Nica 11.21.2011
					}
				}
			}			
			($$("div#warrantyAndClauseDiv [changed=changed]")).invoke("removeAttribute", "changed");
			checkTableIfEmpty2("wcRow", "wcList");
			checkIfToResizeTable2("wcList", "wcRow");
			resetWarrAndClauseFormFields();
		}
	});

	$("btnDelete").observe("click", function(){
		var row = $("wcRow"+objWC[currentRow].parId+objWC[currentRow].wcCd);

		changeTag = 1;
		objWC[currentRow].recordStatus = -1;
		Effect.Fade(row, {
			duration: .001,
			afterFinish: function() {
				row.remove();
				row.removeClassName("selectedRow");
				checkTableIfEmpty2("wcRow", "wcList");
				checkIfToResizeTable2("wcList", "wcRow");
				resetWarrAndClauseFormFields();
			}
		});
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			pAction = pageActions.save;
			saveGIPIWPolWC();
		}
	});

	$("btnCancel").observe("click", function(){
		pAction = pageActions.cancel;
		fireEvent($("parExit"), "click");
	});

	$("reloadForm").observe("click", function(){
		if(changeTag == 1){
			pAction = pageActions.reload;
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					showWPolicyWarrantyAndClausePage, "");
		}else{
			showWPolicyWarrantyAndClausePage();
		}
	});

	function checkWCRequiredFields(){
		try{
			var isOk = true;
			var fields = ["txtWarrantyTitle", "inputPrintSeqNo"];
			var msgFields = ["Warranty Title", "Print Sequence No."];
	
			for(var i=0; i<fields.length; i++){
				if($(fields[i]).value.blank()){
					showMessageBox(msgFields[i] + " is required.", imgMessage.INFO);
					isOk = false;
				}
			}
	
			return isOk;
		}catch(e){
			showErrorMessage("checkWCRequiredFields", e);
		}
	}

	function checkRemarksLength(){
		try{
			var isNotLimit = true;
			if($("inputWcRemarks").value.length > 2000){
				showMessageBox('You have exceeded the maximum number of allowed characters (2000) for Remarks field.', imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		}catch(e){
			showErrorMessage("checkRemarksLength", e);
		}
	}

	function checkWarrantyTextLength(){
		try{
			var isNotLimit = true;
			if($("inputWarrantyText").value.length > 34000){
				showMessageBox('You have exceeded the maximum number of allowed characters (34000) for Warranty Text field.', imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		}catch(e){
			showErrorMessage("checkWarrantyTextLength", e);
		}
	}

	function checkIfPrintSeqNoExist(printSeqNo){
		try{
			var exist = false;
	
			for(var i=0; i<objWC.length; i++){
				if(printSeqNo == objWC[i].printSeqNo && objWC[i].recordStatus != -1){
					exist = true;
				}
			}
			return exist;
		}catch(e){
			showErrorMessage("checkIfPrintSeqNoExist", e);
		}
	}

	function checkIfWarrantyTitleExist(wcCd){
		try{
			isNotExist = true;
			
			for(var i=0; i<objWC.length; i++){
				if(objWC[i].wcCd == wcCd && objWC[i].recordStatus != -1){
					showMessageBox("Warranty Title ( " + (objWC[i].wcTitle).trim() +" ) already exists in Policy/Endorsement.", imgMessage.ERROR);
					resetWarrAndClauseFormFields();
					isNotExist = false;
				}
			}
			return isNotExist;
		}catch(e){
			showErrorMessage("checkIfWarrantyTitleExist", e);
		}
	}

	function saveGIPIWPolWC(){
		try{
			var addedRows = getAddedJSONObjects(objWC);
			var modifiedRows = getModifiedJSONObjects(objWC);
			var delRows = getDeletedJSONObjects(objWC);
			var setRows = addedRows.concat(modifiedRows);
			
			if(checkPendingRecordChanges()){
				new Ajax.Request(contextPath+"/GIPIWPolicyWarrantyAndClauseController?action=saveGIPIWPolWC",{
					method: "POST",
					asynchronous: true,
					parameters:{
						setRows: prepareJsonAsParameter(setRows),
						delRows: prepareJsonAsParameter(delRows)
					},
					onCreate:function(){
						showNotice("Saving Warranties and Clauses, please wait...");
					},
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)){
							if(response.responseText == "SUCCESS"){
								if(pAction == pageActions.save){
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showWPolicyWarrantyAndClausePage);
								}else if(pAction == pageActions.reload){
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showWPolicyWarrantyAndClausePage);
								}else{
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, getLineListingForPAR(riSwitch));
								}
								clearObjectRecordStatus(objWC);
								changeTag = 0;
								pAction = pageActions.none;
							}else{
								showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
							}
						}
					}
				});				
			}
		}catch(e){
			showErrorMessage("saveGIPIWPolWC", e);
		}
	}

	$("searchWarrantyTitle").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		$$("div#wcList div[name='wcRow']").each(function(row){
			if(withPrevious) notIn += ",";
			notIn += "'"+(row.readAttribute("wcCd")).replace(/&#38;/g,'&')+"'";
			withPrevious = true;
		});

		notIn = (notIn != "" ? "("+notIn+")" : "");
		showWarrantyAndClauseLOV(objUWGlobal.lineCd, notIn);		
	});
	
	$("btnCancel").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("btnCancel").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGIPIWPolWC();
						goBackToPackagePARListing();
					}, function(){
						goBackToPackagePARListing();
						changeTag = 0;
					}, "");
		}else{
			goBackToPackagePARListing();
		}
	});
	
	$("parExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("parExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGIPIWPolWC();
						goBackToPackagePARListing();
					}, function(){
						goBackToPackagePARListing();
						changeTag = 0;
					}, "");
		}else{
			goBackToPackagePARListing();
		}
	});
</script>	
	
</script>


