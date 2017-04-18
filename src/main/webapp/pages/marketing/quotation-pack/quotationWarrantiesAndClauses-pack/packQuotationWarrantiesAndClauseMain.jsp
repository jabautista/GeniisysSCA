<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packQuotationWarrantiesAndClausesMainDiv" name="packQuotationWarrantiesAndClausesMainDiv"	style="margin-top: 1px;">
	<form id="packQuotationWarrantiesAndClausesForm" name="packQuotationWarrantiesAndClausesForm">
		<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationInfoHeader.jsp"></jsp:include>
		<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationSubQuotesTable.jsp"></jsp:include>
		<div id="outerDiv"	name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label>Warranties and Clauses</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="packQuotationWarrantiesAndClausesDiv" name="packQuotationWarrantiesAndClausesDiv" class="sectionDiv">
			<jsp:include page="/pages/marketing/quotation-pack/quotationWarrantiesAndClauses-pack/packQuotationWarrantiesAndClausesTable.jsp"></jsp:include>
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px;">
				<table align="center">
					<tr style="display: none;" id="message" name="message">
						<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Title</td>
						<td colspan="4" class="leftAligned">
							<input type="text" id="warrantyTitleDisplay" readonly="readonly" class="required" style="width: 430px; display: none;"></input>
							<select id="selectWarrantyTitle" name="selectWarrantyTitle" style="width: 438px;" class="required">
								<option value=""></option>
							</select>
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
				<div style="width: 100%; margin: 10px 0;" align="center" changeTagAttr="true">
					<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
					<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" disabled="disabled" />
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Package Quotation" />
						<input type="button" class="button" id="btnSave" value="Save">
					</td>
				</tr>
			</table>		
		</div>
	</form>
</div>

<script type="text/javascript">
	hideNotice();
	setModuleId("GIIMM008");
	var lastRowNo = 0;
	var currentRow = -1;
	changeTag = 0;
	
	var objPackQuoteWCList = JSON.parse('${objPackQuoteWCList}'.replace(/\\/g, '\\\\'));
	
	for(var i=0; i<objPackQuoteWCList.length; i++){
		var objWC = objPackQuoteWCList[i];
		var rowContent = generatePackQuoteWCRow(objWC, i);
		addTableRow("quoteWCRow"+objWC.quoteId+objWC.wcCd, "quoteWCRow", "packQuotationWCList", rowContent, clickPackQuoteWCRow);
		$("quoteWCRow"+objWC.quoteId+objWC.wcCd).setAttribute("quoteId", objWC.quoteId);
		lastRowNo = i + 1;
	}
	
	($$("div#packQuotationWCList div[name='quoteWCRow']")).invoke("hide");
	resizeTableBasedOnVisibleRows("packQuoteWCDiv", "packQuotationWCList");
	resetPackQuoteWCFormFields();

	$$("div[name='quoteRow']").each(function(row){
		setQuoteListForWCRowObserver(row);
	});

	function generatePackQuoteWCRow(objWC, index){
		try{
			var wcTitle = objWC.wcTitle == null ? "" : objWC.wcTitle;
			var wcTitle2 = objWC.wcTitle2 == null ? "" : objWC.wcTitle2;
			var printSeqNo = objWC.printSeqNo == null ? "0" : objWC.printSeqNo;
			var wcText = objWC.wcText == null ? "" : unescapeHTML2(objWC.wcText);
			
			var content = '<input type="hidden" value="'+index+'"/>' + 
			'<label style="width: 28%; text-align: left; margin-left: 5px;" title="'+wcTitle+(wcTitle2 == "" ? "" : " - ")+wcTitle2+'" name="title" id="title'+objWC.wcCd+'">'+(changeSingleAndDoubleQuotes(wcTitle)+(wcTitle2 == "" ? "" : " - ")+changeSingleAndDoubleQuotes(wcTitle2)).truncate(30, "...")+'</label>'+
			'<label style="width: 9.5%; text-align: left;">'+objWC.wcSw+'</label>'+
	   		'<label style="width: 7.5%; text-align: center; margin-right: 30px;">'+parseInt(printSeqNo)+'</label>'+
			'<label style="width: 40%; text-align: left;" id="text'+objWC.wcCd+'" name="text" title="Click to view complete text.">'+(wcText == "" ? "-" : (wcText).truncate(50, "..."))+'</label>'+
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
			showErrorMessage("generatePackQuoteWCRow", e);
		}
	}

	function clickPackQuoteWCRow(row){
		try{
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				currentRow = parseInt(row.down("input", 0).value);
				($$("div#packQuotationWCList div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				populatePackQuotationWarrantyAndClauseForm(objPackQuoteWCList[currentRow]);
				enableButton("btnDelete");
				$("warrantyTitleDisplay").show();
				$("selectWarrantyTitle").hide();
				$("btnAdd").value = "Update";
			}else{
				resetPackQuoteWCFormFields();
				currentRow = -1;
			}
		}catch(e){
			showErrorMessage("clickPackQuoteWCRow", e);
		}
	} 

	function populatePackQuotationWarrantyAndClauseForm(objWC){
		try{
			$("selectWarrantyTitle").value 	= objWC.wcCd == null ? "" : objWC.wcCd;
			$("warrantyTitleDisplay").value = objWC.wcTitle == null ? "" : unescapeHTML2(objWC.wcTitle);
			$("inputWarrantyTitle2").value 	= objWC.wcTitle2 == null ? "" : unescapeHTML2(objWC.wcTitle2);
			$("inputWarrantyType").value 	= objWC.wcSw == null ? "" : unescapeHTML2(objWC.wcSw);
			$("inputPrintSeqNo").value 		= objWC.printSeqNo == null ? 0 : objWC.printSeqNo;
			$("inputPrintSwitch").checked 	= (objWC.printSw == 'Y' ? true : false);
			$("inputChangeTag").checked 	= (objWC.changeTag == 'Y' ? true : false);
			$("inputWarrantyText").value 	= (objWC.wcText == null ? "" : unescapeHTML2(objWC.wcText));
			$("inputWcRemarks").value		= objWC.wcRemarks == null ? "" : unescapeHTML2(objWC.wcRemarks);
		}catch(e){
			showErrorMessage("populatePackQuotationWarrantyAndClauseForm", e);
		}
	}

	function resetPackQuoteWCFormFields(){
		disableButton("btnDelete");
		$("warrantyTitleDisplay").hide();
		$("selectWarrantyTitle").show();
		$("btnAdd").value = "Add";
		
		$("warrantyTitleDisplay").value = "";
		$("selectWarrantyTitle").value 	= "";
		$("inputWarrantyTitle2").value  = "";
		$("inputWarrantyType").value    = "";
		$("inputPrintSeqNo").value 		= "";
		$("inputPrintSwitch").checked 	= false;
		$("inputChangeTag").checked 	= false;
		$("inputWarrantyText").value 	= "";
		$("inputWcRemarks").value		= "";
	}

	function getPackQuotationWarrantyListing(lineCd){
		new Ajax.Request(contextPath+"/GIPIQuotationWarrantyAndClauseController", {
			method: "GET",
			parameters: {
				action: "getQuotationWarrantyListing",
				lineCd: lineCd
			},
			onCreate:function(){
				setCursor("wait");
			},
			onComplete:function(response){
				setCursor("default");
				optList = JSON.parse(response.responseText);
				generatePackQuotationWCTitleOptions(optList);
			}
		});
	}

	function generatePackQuotationWCTitleOptions(list){
		$("selectWarrantyTitle").update("");
		var opt = '<option value=""/>';
		for(var i=0; i<list.length; i++){
			var wcCd = changeSingleAndDoubleQuotes(nvl(list[i].wcCd, ""));
			var wcSw = changeSingleAndDoubleQuotes(nvl(list[i].wcSw, ""));
			var printSw = changeSingleAndDoubleQuotes(nvl(list[i].printSw, "N"));
			var wcText = changeSingleAndDoubleQuotes(nvl(list[i].wcText, ""));
			var changeTag = nvl(list[i].changeTag, "N");
			var wcTitle = changeSingleAndDoubleQuotes(nvl(list[i].wcTitle, ""));
			
			opt+= '<option value="'+wcCd+'" wcSw="'+wcSw+'" printSw="'+printSw+'" wcText="'+wcText+'" changeTag="'+changeTag+'">'+wcTitle+'</option>';
		}
		
		$("selectWarrantyTitle").insert({bottom: opt});
		$("selectWarrantyTitle").value = "";
	}

	function setQuoteListForWCRowObserver(row){
		row.observe("click", function(){
			$("selectWarrantyTitle").update("");
			row.toggleClassName("selectedRow");
			($$("div#packQuotationWCList div[name='quoteWCRow']")).invoke("removeClassName", "selectedRow");
			
			if(row.hasClassName("selectedRow")){												
				($$("div#packQuotationTableDiv div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				($$("div#packQuotationWCList div[name='quoteWCRow']")).invoke("show");				
				($$("div#packQuotationWCList div:not([quoteId='" + row.getAttribute("quoteId") + "'])")).invoke("hide");
				getPackQuotationWarrantyListing(row.getAttribute("lineCd"));
			}else{
				($$("div#packQuotationWCList div[name='quoteWCRow']")).invoke("hide");
			}
			resetPackQuoteWCFormFields();
			resizeTableBasedOnVisibleRows("packQuoteWCDiv", "packQuotationWCList");
		});
	}

	function synchPackQuoteWCListDetails(){
		try{
			var title = $("selectWarrantyTitle").options[$("selectWarrantyTitle").selectedIndex];
			$("inputWarrantyType").value 	= title.getAttribute("wcSw") == null ? "" : title.getAttribute("wcSw");
			$("inputPrintSwitch").checked 	= title.getAttribute("printSw") == 'Y' ? true : false;
			$("inputWarrantyText").value 	= title.getAttribute("wcText") == null ? "" : title.getAttribute("wcText");
	
			var selectedQuote = getSelectedQuoteAttribute("quoteId");
			var max = 0;
	
			if(title.value != null || title.value != ""){
				for(var i=0; i<objPackQuoteWCList.length; i++){
					if(selectedQuote == objPackQuoteWCList[i].quoteId && parseInt(objPackQuoteWCList[i].printSeqNo) > max && objPackQuoteWCList[i].recordStatus != -1){
						max = parseInt(objPackQuoteWCList[i].printSeqNo);
					}
				}
				
				$("inputPrintSeqNo").value = max + 1;
			}
		}catch(e){
			showErrorMessage("synchPackQuoteWCListDetails", e);
		}
	}

	function getSelectedQuoteAttribute(attr){
		var selectedQuote = getSelectedRow("quoteRow");
		var value;
		
		if(selectedQuote == null){
			showMessageBox("There is no quotation selected.", imgMessage.ERROR);
		}else{
			value = selectedQuote.getAttribute(attr);
		}
		return value;
	}

	function checkQuoteWCChangeTag() {
		$("inputChangeTag").checked = true;
	}

	function resetQuoteWCText() {
		try{
			var defaultText = "";
			if($F("inputWarrantyText") != ""){
				defaultText = $("selectWarrantyTitle").options[$("selectWarrantyTitle").selectedIndex].getAttribute("wcText");
			}
			$("inputWarrantyText").value = defaultText;
			$("inputChangeTag").checked = false;
		}catch(e){
			showErrorMessage("resetText", e);
		}
	}

	function checkIfPackQuoteWCPrintSeqNoExist(printSeqNo){
		try{
			var exist = false;
			var quoteId = getSelectedQuoteAttribute("quoteId");
			
			for(var i=0; i<objPackQuoteWCList.length; i++){
				if(objPackQuoteWCList[i].quoteId == quoteId && 
				   objPackQuoteWCList[i].printSeqNo == printSeqNo && 
				   objPackQuoteWCList[i].recordStatus != -1){
					exist = true;
				}
			}
			return exist;
		}catch(e){
			showErrorMessage("checkIfPackQuoteWCPrintSeqNoExist", e);
		}
	}

	function checkIfPackQuoteWarrantyTitleExist(wcCd){
		try{
			isNotExist = true;
			var quoteId = getSelectedQuoteAttribute("quoteId");
			
			for(var i=0; i<objPackQuoteWCList.length; i++){
				if(objPackQuoteWCList[i].quoteId == quoteId && objPackQuoteWCList[i].wcCd == wcCd && objPackQuoteWCList[i].recordStatus != -1){
					showMessageBox("Warranty Title ( " + (objPackQuoteWCList[i].wcTitle).trim() +" ) already exists.", imgMessage.ERROR);
					$("selectWarrantyTitle").value = "";
					isNotExist = false;
				}
			}
			return isNotExist;
		}catch(e){
			showErrorMessage("checkIfPackQuoteWarrantyTitleExist", e);
		}
	}

	function hideAddedPackQuoteWCOpt(){
		try{
			var wcOpt = $("selectWarrantyTitle").options;
			var quoteId = getSelectedQuoteAttribute("quoteId");
			
			$$("div[name='quoteWCRow']").pluck("id").each(function(row){
				for(var i=0; i<wcOpt.length; i++){
					if(row.substring(10) == (quoteId+wcOpt[i].value)){
						wcOpt[i].hide();
						wcOpt[i].disabled = true;
					}
				}
			});
		}catch(e){
			showErrorMessage("hideAddedPackQuoteWCOpt", e);
		}
	}

	function showDeletedPackQuoteWCOpt(rowId){
		try{
			var wcOpt = $("selectWarrantyTitle").options;
			var quoteId = getSelectedQuoteAttribute("quoteId");;
			
			for(var i=0; i<wcOpt.length; i++){
				if(rowId.substring(5) == (quoteId+wcOpt[i].value)){
					wcOpt[i].show();
					wcOpt[i].disabled = false;
				}
			}
		}catch(e){
			showErrorMessage("showDeletedPackQuoteWCOpt", e);
		}
	}

	function checkPackQuoteWCRequiredFields(){
		try{
			var isOk = true;
			var fields = ["selectWarrantyTitle", "inputPrintSeqNo"];
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

	function setPackQuoteWCObject(recStatus){
		try{
			var objWarrCla = new Object();
			var quoteId   = getSelectedQuoteAttribute("quoteId");
			var lineCd	= getSelectedQuoteAttribute("lineCd");
			var selectedWCTitle = $("selectWarrantyTitle").options[$("selectWarrantyTitle").selectedIndex];
			var wcText = $("inputChangeTag").checked ? $F("inputWarrantyText"): selectedWCTitle.getAttribute("wcText");  
			
			objWarrCla.packQuoteId = objMKGlobal.packQuoteId;
			objWarrCla.wcCd 	= escapeHTML2(selectedWCTitle.value);
			objWarrCla.quoteId	= parseInt(quoteId);
			objWarrCla.lineCd 	= escapeHTML2(lineCd);
			objWarrCla.wcSw 	= escapeHTML2($("inputWarrantyType").value);
			objWarrCla.wcTitle 	= escapeHTML2($("selectWarrantyTitle").options[$("selectWarrantyTitle").selectedIndex].text);
			objWarrCla.wcTitle2 = escapeHTML2($("inputWarrantyTitle2").value);
			objWarrCla.wcRemarks = escapeHTML2($("inputWcRemarks").value);
			objWarrCla.wcText   = escapeHTML2(wcText);
			objWarrCla.wcText1 	= escapeHTML2(wcText.substring(0, 2000));
			objWarrCla.wcText2 	= escapeHTML2(wcText.substring(2000, 4000));
			objWarrCla.wcText3 	= escapeHTML2(wcText.substring(4000, 6000));
			objWarrCla.wcText4 	= escapeHTML2(wcText.substring(6000, 8000));
			objWarrCla.wcText5	= escapeHTML2(wcText.substring(8000, 10000));
			objWarrCla.wcText6 	= escapeHTML2(wcText.substring(10000, 12000));
			objWarrCla.wcText7 	= escapeHTML2(wcText.substring(12000, 14000));
			objWarrCla.wcText8 	= escapeHTML2(wcText.substring(14000, 16000));
			objWarrCla.wcText9 	= escapeHTML2(wcText.substring(16000, 18000));
			objWarrCla.wcText10	= escapeHTML2(wcText.substring(18000, 20000));
			objWarrCla.wcText11	= escapeHTML2(wcText.substring(20000, 22000));
			objWarrCla.wcText12	= escapeHTML2(wcText.substring(22000, 24000));
			objWarrCla.wcText13	= escapeHTML2(wcText.substring(24000, 26000));
			objWarrCla.wcText14	= escapeHTML2(wcText.substring(26000, 28000));
			objWarrCla.wcText15	= escapeHTML2(wcText.substring(28000, 30000));
			objWarrCla.wcText16	= escapeHTML2(wcText.substring(30000, 32000));
			objWarrCla.wcText17	= escapeHTML2(wcText.substring(32000));
			objWarrCla.changeTag= $("inputChangeTag").checked ? "Y" : "N";
			objWarrCla.printSw 	= $("inputPrintSwitch").checked ? "Y" : "N";
			objWarrCla.printSeqNo= $("inputPrintSeqNo").value;
			objWarrCla.swcSeqNo	= 0;
			objWarrCla.recordStatus = recStatus;
			
			return objWarrCla;
			
		}catch(e){
			showErrorMessage("setPackQuoteWCObject", e);
		}
	}

	function savePackQuoteWarrantiesAndClauses(){
		try{
			var addedRows = getAddedJSONObjects(objPackQuoteWCList);
			var modifiedRows = getModifiedJSONObjects(objPackQuoteWCList);
			var delRows = getDeletedJSONObjects(objPackQuoteWCList);
			var setRows = addedRows.concat(modifiedRows);
			
			new Ajax.Request(contextPath+"/GIPIQuotationWarrantyAndClauseController",{
				method: "POST",
				asynchronous: true,
				parameters:{
					action: "saveWarrAndClausesForPackQuotation",
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
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							changeTag = 0;
						}else{
							showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
						}
					}else{
						showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
					}
				}
			});
			
		}catch(e){
			showErrorMessage("savePackQuoteWarrantiesAndClauses", e);
		}
	}

	$("editWarrantyText").observe("click", function () {
		showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", resetQuoteWCText, checkQuoteWCChangeTag);
	});

	$("editWcRemarks").observe("click", function(){
		showEditor("inputWcRemarks", 2000);
	});

	$("selectWarrantyTitle").observe("change", function(){
		if(checkIfPackQuoteWarrantyTitleExist(this.value)){
			synchPackQuoteWCListDetails();
		}
	});

	$("selectWarrantyTitle").observe("keypress", function(evt){
		if(evt.keyCode == 40 || evt.keyCode == 38){
			synchPackQuoteWCListDetails();
		}
	});

	$("selectWarrantyTitle").observe("click", function(){
		hideAddedPackQuoteWCOpt();
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
								$("inputWarrantyText").value = $("selectWarrantyTitle").options[$("selectWarrantyTitle").selectedIndex].getAttribute("wcText");
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
		}else if(checkIfPackQuoteWCPrintSeqNoExist(wcPrintSeqNo)){
			showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}
	});

	$("btnAdd").observe("click", function(){
		var rowContent = "";
		
		if(checkPackQuoteWCRequiredFields()){
			if(this.value == "Add"){
				var objAdded = setPackQuoteWCObject(0);

				objPackQuoteWCList.push(objAdded);
				rowContent = generatePackQuoteWCRow(objAdded,lastRowNo);
				addTableRow("quoteWCRow"+objAdded.quoteId+objAdded.wcCd, "quoteWCRow", "packQuotationWCList", rowContent, clickPackQuoteWCRow);
				$("quoteWCRow"+objAdded.quoteId+objAdded.wcCd).setAttribute("quoteId", objAdded.quoteId);
				lastRowNo = lastRowNo + 1;
				hideAddedPackQuoteWCOpt();
				
			}else if(this.value == "Update"){
				var objModified = setPackQuoteWCObject(1);
					
				for(var i=0; i<objPackQuoteWCList.length; i++){
					if(objModified.quoteId == objPackQuoteWCList[i].quoteId && objModified.wcCd == objPackQuoteWCList[i].wcCd){
						objPackQuoteWCList.splice(i, 1, objModified);
						rowContent = generatePackQuoteWCRow(objModified,i);
						$("quoteWCRow"+objModified.quoteId+objModified.wcCd).update(rowContent);
						$("quoteWCRow"+objModified.quoteId+objModified.wcCd).removeClassName("selectedRow");
						$("quoteWCRow"+objModified.quoteId+objModified.wcCd).setAttribute("quoteId", objModified.quoteId);
					}
				}
			}
			
			resetPackQuoteWCFormFields();
			resizeTableBasedOnVisibleRows("packQuoteWCDiv", "packQuotationWCList");
		}
	});

	$("btnDelete").observe("click", function(){
		var row = getSelectedRow("quoteWCRow");

		objPackQuoteWCList[currentRow].recordStatus = -1;
		objPackQuoteWCList[currentRow].packParId = objMKGlobal.packQuoteId;
		row.remove();
		row.removeClassName("selectedRow");
		resetPackQuoteWCFormFields();
		resizeTableBasedOnVisibleRows("packQuoteWCDiv", "packQuotationWCList");
		showDeletedPackQuoteWCOpt(row.id);
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES);
		}else{
			savePackQuoteWarrantiesAndClauses();
		}
	});

	$("btnEditQuotation").observe("click", function(){
		function goToBasicQuotationInfo(){
			editPackQuotation(objMKGlobal.lineName, objMKGlobal.lineCd, objMKGlobal.packQuoteId);
		}
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", savePackQuoteWarrantiesAndClauses, goToBasicQuotationInfo, "");
		}else{
			goToBasicQuotationInfo();
		}
	});

	observeReloadForm($("reloadForm"), showPackWarrantiesAndClausesPage);
	initializeChangeTagBehavior(savePackQuoteWarrantiesAndClauses);
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		showPackQuotationListing();
	});
</script>