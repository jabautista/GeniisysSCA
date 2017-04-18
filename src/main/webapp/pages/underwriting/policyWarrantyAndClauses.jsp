<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="pcMainDiv" name="pcMainDiv" style="margin-top: 1px; display: none;">
	<form id="pcMainForm" name="pcMainForm">
		<jsp:include page="subPages/parInformation.jsp"></jsp:include>

		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Warranties and Clauses</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="refreshList" name="refreshList">Refresh List</label>
				</span>
			</div>
		</div>
		
		<div id="wcDivAndFormDiv" name="wcDivAndFormDiv" class="sectionDiv">
			<div id="wcDiv" name="wcDiv" style="margin: 10px;">
				
			</div>
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px;">
				<table align="center">
					<tr style="display: none;" id="message" name="message">
						<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Title</td>
						<td colspan="4" class="leftAligned">
							<!-- <input type="text" id="warratyTitleDisplay" readonly="readonly" class="required" style="width: 430px; display: none;" />
							<select id="inputWarrantyTitle" name="inputWarrantyTitle" style="width: 438px;" class="required">
								<option value=""></option>
								
								<c:forEach var="wc" items="${wcTitles}">
									<option value="${wc.wcCd}" wcSw="${wc.wcSw}" printSw="${wc.printSw}" wcText="${wc.wcText}" changeTag="${wc.changeTag}" 
										wcText01="${wc.wcText1}" wcText02="${wc.wcText2}" wcText03="${wc.wcText3}" wcText04="${wc.wcText4}" wcText05="${wc.wcText5}"
										wcText06="${wc.wcText6}" wcText07="${wc.wcText7}" wcText08="${wc.wcText8}" wcText09="${wc.wcText9}" wcText10="${wc.wcText10}"
										wcText11="${wc.wcText11}" wcText12="${wc.wcText12}" wcText13="${wc.wcText13}" wcText14="${wc.wcText14}" wcText15="${wc.wcText15}"
										wcText16="${wc.wcText16}" wcText17="${wc.wcText17}">${wc.wcTitle}</option>
								</c:forEach>
								
							</select> -->
							<span class="required lovSpan" style="width: 430px;">
								<input type="hidden" id="hidWcCd" name="hidWcCd"> 								
								<input type="text" id="txtWarrantyTitle" name="txtWarrantyTitle" style="width: 405px; float: left; border: none; height: 13px; margin: 0;" class="required" readonly="readonly"></input>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarrantyTitle" name="btnWarrantyTitle" alt="Go" style="float: right;"/>
							</span>
						</td>
						
						<!-- Marco - text editor for warranty title 2-->
						<!-- <td class="leftAligned" colspan="3"><input type="text" id="inputWarrantyTitle2" name="inputWarrantyTitle2" style="width: 191px;" maxlength="100" /></td> -->
						<td class="leftAligned" colspan="3"">
							<div style="border: 1px solid gray; height: 20px; width: 200px;">
								<textarea id="inputWarrantyTitle2" name="inputWarrantyTitle2" style="width: 171px; border: none; height: 13px; margin: 0px;"/></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyTitle2" />
							</div>
						</td>
						
					</tr>
					<tr>
						<td class="rightAligned">Type </td>
						<td class="leftAligned" width="120px"><input type="text" id="inputWarrantyType" name="inputWarrantyType" style="width: 100px;" readonly="readonly" /></td>
						<td class="rightAligned">Print Sequence No. </td>
						<td class="leftAligned"><input class="required" type="text" id="inputPrintSeqNo" name="inputPrintSeqNo" maxlength="2" style="width: 40px;"/></td>
						<td class="rightAligned">Print Switch </td>
						<td class="leftAligned"><input type="checkbox" id="inputPrintSwitch" name="inputPrintSwitch" value="Y" /></td>
						<td class="rightAligned">Change Tag </td>
						<td class="leftAligned"  width="60px"><input type="checkbox" id="inputChangeTag" name="inputChangeTag" value="Y" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Text </td>
						<td colspan="7" class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 642px;">
								<input type="hidden" id="wTextChanged" name="wTextChanged" value="N" />
								<input type="hidden" id="hidOrigWarrantyText" name="hidOrigWarrantyText" style="width: 610px; border: none; height: 13px;"></input>
								<textarea id="inputWarrantyText" name="inputWarrantyText" style="width: 610px; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
							</div>
						</td>
					</tr>
				</table>
				<div style="width: 100%; margin-bottom: 10px;" align="center" >
					<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
					<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" disabled="disabled" />
				</div>
			</div>
		</div>
		
		<div class="buttonsDiv" id="wcButtonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
						<input type="button" class="button" style="width: 90px;" id="btnSaveWPolWC" name="btnSaveWPolWC" value="Save" />
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>
<script type="text/javascript">
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	var objWarrClause = {};//JSON.parse('${objWarrClause}');//.replace(/\\/g, "\\\\"));
	hideNotice();
	addStyleToInputs();
	initializeAll();
	initializeAccordion();
	parType = '${parType}';	
	changeTag = 0;
	if(parType == "P") {
		setDocumentTitle("Policy - Warranties and Clauses");
		setModuleId("GIPIS024");
	} else if (parType == "E"){
		setDocumentTitle("Warranties and Clauses Entry - Endorsement");
		setModuleId("GIPIS035");
		$("print").hide();  //hides print in the menu
	}
	disableMenu("distribution");
	var riSwitch = $F("globalIssCd") == "RI" ? "Y" : "";
	
	/* $("inputWarrantyTitle").observe("click", function() {
		hideAddedWC();
	}); */
	
	
	/* Marco - changed displayed message */
	$("reloadForm").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", showWPolicyWarrantyAndClausePage, "");
		} else {
			showWPolicyWarrantyAndClausePage();
		}
	});

	$("refreshList").observe("click", function () {
		//loadWPolicyWarrantyAndClausesByPage(1);
		setWarrantyAndClauseForm(null);
	});

	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveWPolicyWarrantyAndClause();
		exitWC();
	}

	function saveAndReload(){
		pAction = pageActions.reload;
		saveWPolicyWarrantyAndClause();
		showWPolicyWarrantyAndClausePage();
	}

/*	$("inputPrintSwitch").observe("change", function () {
		var wcPrintSw 	 	= $("inputPrintSwitch").checked ? "Y" : "N";
		if(wcPrintSw == "N") {
			$("inputPrintSeqNo").setAttribute("readonly", "readonly");
		} else {
			$("inputPrintSeqNo").removeAttribute("readonly");
		}
	});*/
	
	$("btnAdd").observe("click", function () {
		var wcCd 		    = $F("hidWcCd");
		var wcTitle 	 	= escapeHTML2($F("txtWarrantyTitle"));
		var wcTitle2 	 	= escapeHTML2($F("inputWarrantyTitle2"));
		var wcType 		 	= $F("inputWarrantyType");
		var wcPrintSeqNo 	= $F("inputPrintSeqNo");
		var wcPrintSw 	 	= $("inputPrintSwitch").checked ? "Y" : "N";
		var wcChangeTag  	= $("inputChangeTag").checked ? "Y" : "N";
		var wcWarrantyText1 = "";
		var wcWarrantyText2 = "";
		var wcWarrantyText3 = "";
		var wcWarrantyText4 = "";
		var wcWarrantyText5 = "";
		var wcWarrantyText6 = "";
		var wcWarrantyText7 = "";
		var wcWarrantyText8 = "";
		var wcWarrantyText9 = "";
		var wcWarrantyText10 = "";
		var wcWarrantyText11 = "";
		var wcWarrantyText12 = "";
		var wcWarrantyText13 = "";
		var wcWarrantyText14 = "";
		var wcWarrantyText15 = "";
		var wcWarrantyText16 = "";
		var wcWarrantyText17 = "";
		
		if (wcCd == "" || wcCd == null) {
			showMessageBox("Warranty Title is required.", imgMessage.INFO);
			$("txtWarrantyTitle").focus();
			return false;
		} else {
			//var selectedOption = $("inputWarrantyTitle").options[$("inputWarrantyTitle").selectedIndex];
			if(wcChangeTag == "N") {	
				wcWarrantyText1 	= nvl($F("hidOrigWarrantyText").substring(0, 4000), "").escapeHTML();
				wcWarrantyText2 	= nvl($F("hidOrigWarrantyText").substring(4000, 8000), "").escapeHTML();
				wcWarrantyText3 	= nvl($F("hidOrigWarrantyText").substring(8000, 12000), "").escapeHTML();
				wcWarrantyText4 	= nvl($F("hidOrigWarrantyText").substring(12000, 16000), "").escapeHTML();
				wcWarrantyText5 	= nvl($F("hidOrigWarrantyText").substring(16000, 20000), "").escapeHTML();
				wcWarrantyText6 	= nvl($F("hidOrigWarrantyText").substring(20000, 24000), "").escapeHTML();
				wcWarrantyText7 	= nvl($F("hidOrigWarrantyText").substring(24000, 28000), "").escapeHTML();
				wcWarrantyText8 	= nvl($F("hidOrigWarrantyText").substring(28000, 32000), "").escapeHTML();
				wcWarrantyText9 	= nvl($F("hidOrigWarrantyText").substring(32000, 36000), "").escapeHTML();
				wcWarrantyText10 	= nvl($F("hidOrigWarrantyText").substring(36000, 40000), "").escapeHTML();
				wcWarrantyText11 	= nvl($F("hidOrigWarrantyText").substring(40000, 44000), "").escapeHTML();
				wcWarrantyText12 	= nvl($F("hidOrigWarrantyText").substring(48000, 52000), "").escapeHTML();
				wcWarrantyText13 	= nvl($F("hidOrigWarrantyText").substring(52000, 56000), "").escapeHTML();
				wcWarrantyText14 	= nvl($F("hidOrigWarrantyText").substring(56000, 60000), "").escapeHTML();
				wcWarrantyText15 	= nvl($F("hidOrigWarrantyText").substring(60000, 64000), "").escapeHTML();
				wcWarrantyText16 	= nvl($F("hidOrigWarrantyText").substring(64000, 68000), "").escapeHTML();
				wcWarrantyText17 	= nvl($F("hidOrigWarrantyText").substring(68000), "").escapeHTML();
				/* wcWarrantyText1 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(0, 4000), "").escapeHTML();
				wcWarrantyText2 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(4000, 8000), "").escapeHTML();
				wcWarrantyText3 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(8000, 12000), "").escapeHTML();
				wcWarrantyText4 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(12000, 16000), "").escapeHTML();
				wcWarrantyText5 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(16000, 20000), "").escapeHTML();
				wcWarrantyText6 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(20000, 24000), "").escapeHTML();
				wcWarrantyText7 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(24000, 28000), "").escapeHTML();
				wcWarrantyText8 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(28000, 32000), "").escapeHTML();
				wcWarrantyText9 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(32000, 36000), "").escapeHTML();
				wcWarrantyText10 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(36000, 40000), "").escapeHTML();
				wcWarrantyText11 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(40000, 44000), "").escapeHTML();
				wcWarrantyText12 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(48000, 52000), "").escapeHTML();
				wcWarrantyText13 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(52000, 56000), "").escapeHTML();
				wcWarrantyText14 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(56000, 60000), "").escapeHTML();
				wcWarrantyText15 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(60000, 64000), "").escapeHTML();
				wcWarrantyText16 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(64000, 68000), "").escapeHTML();
				wcWarrantyText17 	= nvl(changeSingleAndDoubleQuotes(selectedOption.getAttribute("wcText"), "").substring(68000), "").escapeHTML(); */				
			} else {
				wcWarrantyText1 	= nvl($F("inputWarrantyText").substring(0, 4000), "").escapeHTML();
				wcWarrantyText2 	= nvl($F("inputWarrantyText").substring(4000, 8000), "").escapeHTML();
				wcWarrantyText3 	= nvl($F("inputWarrantyText").substring(8000, 12000), "").escapeHTML();
				wcWarrantyText4 	= nvl($F("inputWarrantyText").substring(12000, 16000), "").escapeHTML();
				wcWarrantyText5 	= nvl($F("inputWarrantyText").substring(16000, 20000), "").escapeHTML();
				wcWarrantyText6 	= nvl($F("inputWarrantyText").substring(20000, 24000), "").escapeHTML();
				wcWarrantyText7 	= nvl($F("inputWarrantyText").substring(24000, 28000), "").escapeHTML();
				wcWarrantyText8 	= nvl($F("inputWarrantyText").substring(28000, 32000), "").escapeHTML();
				wcWarrantyText9 	= nvl($F("inputWarrantyText").substring(32000, 36000), "").escapeHTML();
				wcWarrantyText10 	= nvl($F("inputWarrantyText").substring(36000, 40000), "").escapeHTML();
				wcWarrantyText11 	= nvl($F("inputWarrantyText").substring(40000, 44000), "").escapeHTML();
				wcWarrantyText12 	= nvl($F("inputWarrantyText").substring(48000, 52000), "").escapeHTML();
				wcWarrantyText13 	= nvl($F("inputWarrantyText").substring(52000, 56000), "").escapeHTML();
				wcWarrantyText14 	= nvl($F("inputWarrantyText").substring(56000, 60000), "").escapeHTML();
				wcWarrantyText15 	= nvl($F("inputWarrantyText").substring(60000, 64000), "").escapeHTML();
				wcWarrantyText16 	= nvl($F("inputWarrantyText").substring(64000, 68000), "").escapeHTML();
				wcWarrantyText17 	= nvl($F("inputWarrantyText").substring(68000), "").escapeHTML();
			}
		}
		var origWarrantyText = $F("hidOrigWarrantyText");
		var exists = false;
		$$("input[type='hidden']").each(function (h){
			if (h.getAttribute("name") == "wcCd"){
				if (h.value == wcCd){
					exists = true;
				}
			}
		});

		var selectedPrintSeqNo = 0;
		$$("div[name='row']").each(function (row) {
			if (row.hasClassName("selectedRow")) {
				selectedPrintSeqNo = row.down("input", 4).value;
			}
		});
		
		var printSeqNoExists = false;
		$$("input[type='hidden']").each(function (h){
			if (h.getAttribute("name") == "printSeqNo")	{
				if (h.value == parseInt(wcPrintSeqNo, 10) && parseInt(wcPrintSeqNo, 10) != selectedPrintSeqNo){		//Marco - parse to base 10
					printSeqNoExists = true;
				}
			}
		});
		
	/*	if (wcCd == "" || wcCd == null) {
			showMessageBox("Warranty Title is required.", imgMessage.INFO);
			$("inputWarrantyTitle").focus();
			return false;
		} else*/ 
		if (wcPrintSeqNo == ""){
			showMessageBox("Print Sequence No. is required.", imgMessage.INFO);
			$("inputPrintSeqNo").focus();
			return false;
		} else if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".")) {
			showMessageBox("Invalid Print Sequence No. <br />Value should be from 1 to 99.");
			$("inputPrintSeqNo").focus();
			return false; 
		} else if ($("inputWarrantyText").value.length > 34000) {
			showMessageBox("Warranty Text should have a maximum of 34,000 characters only.", imgMessage.INFO);
			$("inputWarrantyText").focus();
			return false;
		} else if (exists && ($F("btnAdd") != "Update"))	{
			showMessageBox("Warranty and Clause entry already exists.", imgMessage.INFO);
			$("txtWarrantyTitle").focus();
			return false;
		} else if (printSeqNoExists){
			showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
			$("inputPrintSeqNo").focus();
			return false;
		}
		
		var wcDiv = $("wpolicyWCList");
		var content = 	'<input type="hidden" id="wcCd'+wcCd+'" 		 name="wcCd" 		    value="'+wcCd+'" />'+
						'<input type="hidden" id="wcTitle'+wcCd+'"  	 name="wcTitle" 		value="'+wcTitle+'" />'+
						'<input type="hidden" id="wcTitle2'+wcCd+'" 	 name="wcTitle2" 		value="'+wcTitle2+'" />'+
						'<input type="hidden" id="warrantyType'+wcCd+'"  name="warrantyType" 	value="'+wcType+'" />'+
						'<input type="hidden" id="printSeqNo'+wcCd+'" 	 name="printSeqNo" 		value="'+parseInt(wcPrintSeqNo)+'" />'+
						'<input type="hidden" id="printSw'+wcCd+'" 	 	 name="printSw" 		value="'+wcPrintSw+'" />'+
						'<input type="hidden" id="changeTag'+wcCd+'" 	 name="changeTag" 		value="'+wcChangeTag+'" />'+
						'<input type="hidden" id="wcText1'+wcCd+'"		 name="wcText1" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText1)), "")+'" />'+	
						'<input type="hidden" id="wcText2'+wcCd+'" 		 name="wcText2"			value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText2)), "")+'"' +
						'<input type="hidden" id="wcText3'+wcCd+'"		 name="wcText3" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText3)), "")+'" />'+	
						'<input type="hidden" id="wcText4'+wcCd+'" 		 name="wcText4"			value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText4)), "")+'"' +
						'<input type="hidden" id="wcText5'+wcCd+'"		 name="wcText5" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText5)), "")+'" />'+	
						'<input type="hidden" id="wcText6'+wcCd+'" 		 name="wcText6"			value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText6)), "")+'"' +
						'<input type="hidden" id="wcText7'+wcCd+'"		 name="wcText7" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText7)), "")+'" />'+	
						'<input type="hidden" id="wcText8'+wcCd+'" 		 name="wcText8"			value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText8)), "")+'"' +
						'<input type="hidden" id="wcText9'+wcCd+'"		 name="wcText9" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText9)), "")+'" />'+	
						'<input type="hidden" id="wcText10'+wcCd+'"		 name="wcText10" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText10)), "")+'" />'+
						'<input type="hidden" id="wcText11'+wcCd+'"		 name="wcText11" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText11)), "")+'" />'+
						'<input type="hidden" id="wcText12'+wcCd+'"		 name="wcText12" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText12)), "")+'" />'+
						'<input type="hidden" id="wcText13'+wcCd+'"		 name="wcText13" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText13)), "")+'" />'+
						'<input type="hidden" id="wcText14'+wcCd+'"		 name="wcText14" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText14)), "")+'" />'+
						'<input type="hidden" id="wcText15'+wcCd+'"		 name="wcText15" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText15)), "")+'" />'+
						'<input type="hidden" id="wcText16'+wcCd+'"		 name="wcText16" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText16)), "")+'" />'+
						'<input type="hidden" id="wcText17'+wcCd+'"		 name="wcText17" 		value="'+nvl(changeSingleAndDoubleQuotes2(fixTildeProblem(wcWarrantyText17)), "")+'" />'+						
						
						'<label style="width: 28%; text-align: left; margin-left: 5px;" title="'+wcTitle+(wcTitle2 == "" ? "" : " - ")+wcTitle2+'" name="title" id="title'+wcCd+'">'+(wcTitle+(wcTitle2 == "" ? "" : " - ")+wcTitle2).truncate(35, "...")+'</label>'+
						'<label style="width: 11%; text-align: left;">'+wcType+'</label>'+
				   		'<label style="width: 8%; text-align: left; margin-right: 15px;">'+parseInt(wcPrintSeqNo)+'</label>'+
						'<label style="width: 42%; text-align: left;" id="text'+wcCd+'" name="text" title="Click to view complete text.">'+(wcWarrantyText1== "" ? "-" : (wcWarrantyText1+wcWarrantyText2).truncate(50, "..."))+'</label>'+
						'<label style="width: 3%; text-align: left;">';
						
						if (wcPrintSw == 'Y') {
							content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
						} else {
							content += '<span style="float: left; width: 10px; height: 10px; margin-left: 10px;">-</span>';
						}
						
						content += '</label><label style="width: 3%; text-align: center;">';

						if (wcChangeTag == 'Y') {
							content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
						} else {
							content += '<span style="float: left; width: 10px; height: 10px; margin-left: 10px;">-</span>';
						}
							content += '</label>';
		
		if ($F("btnAdd") == "Update")	{
			$("wc"+wcCd).update(content);
			setWarrantyAndClauseForm(null);
		} else {
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "wc"+wcCd);
			newDiv.setAttribute("name", "row");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			newDiv.update(content);

			wcDiv.insert({bottom: newDiv});
			
			newDiv.observe("mouseover", function ()	{
				newDiv.addClassName("lightblue");
			});
			
			newDiv.observe("mouseout", function ()	{
				newDiv.removeClassName("lightblue");
			});
			
			newDiv.observe("click", function ()	{
				newDiv.toggleClassName("selectedRow");
				if (newDiv.hasClassName("selectedRow"))	{
					$$("div[name='row']").each(function (r)	{
						if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
					setWarrantyAndClauseForm(newDiv);
				} else { 
					setWarrantyAndClauseForm(null);
				}
			});
			
			Effect.Appear(newDiv, {
				duration: .5
			});
			checkTableIfEmpty("row", "wcDiv");

			$$("label[name='title']").each(function (label)	{
				var id = label.getAttribute("id");
				$(id).update($(id).innerHTML.truncate(35, "..."));
			});
		}
		changeTag = 1;
		//hideAddedWC();
		$("wc"+wcCd).writeAttribute("origWarrantyText", wcWarrantyText1 + wcWarrantyText2 + wcWarrantyText3 + wcWarrantyText4 + wcWarrantyText5 + 
														wcWarrantyText6 + wcWarrantyText7 + wcWarrantyText8 + wcWarrantyText9 + wcWarrantyText10 + 
														wcWarrantyText11 + wcWarrantyText12 + wcWarrantyText13 + wcWarrantyText14 + wcWarrantyText15 +
														wcWarrantyText16 + wcWarrantyText17);
		setWarrantyAndClauseForm(null);
		checkIfToResizeTable("wpolicyWCList", "row");
	});
	
	$("btnDelete").observe("click", function ()	{
		$$("div[name='row']").each(function (row)	{
			//showDeletedWC(row);	
			if (row.hasClassName("selectedRow"))	{
				Effect.Fade(row, {
					duration: .5,
					afterFinish: function () {
						row.remove();
						changeTag = 1;
						setWarrantyAndClauseForm(null);
						checkTableIfEmpty("row", "wcDiv");
						checkIfToResizeTable("wpolicyWCList", "row");
					}
				});
			}
		});
	});

	$("inputWarrantyText").observe("change", function() {
		try {
			if($F("txtWarrantyTitle") != null) {
				$("inputChangeTag").checked = true;
				$("wTextChanged").value = "Y";
			}
		} catch(e) {
			showErrorMessage("policyWarrantyAndClauses.jsp - inputWarrantyText", e);
			//showMessageBox("toggle change tag: " + e.message);
		}	
	});

	$("inputWarrantyText").observe("blur", function() {
		if($F("wTextChanged") == "Y" &&	$F("txtWarrantyTitle") != null) {
			showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No", 
					function() {
					$("inputChangeTag").checked = true;
					}, synchDetailsInWarrantyList
			);
		}
	});

	$("inputPrintSeqNo").observe("blur", function() {
		var wcPrintSeqNo 	= $F("inputPrintSeqNo");
		if (wcPrintSeqNo == "" || wcPrintSeqNo == null){
			showMessageBox("Print Sequence No. is required.", imgMessage.INFO);
			$("inputPrintSeqNo").focus();
		} else if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".") || isNaN(parseFloat(wcPrintSeqNo))) {
			showMessageBox("Invalid Print Sequence No. <br />Value should be from 1 to 99.");
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}
	});
	
	//$("inputWarrantyTitle").observe("keypress", synchDetailsInWarrantyList);
	//$("inputWarrantyTitle").observe("change", synchDetailsInWarrantyList);

/* 	function synchDetailsInWarrantyList() {
		var selectedIndex = -1;
		var selectedOption;
		
		//selectedIndex = $("inputWarrantyTitle").selectedIndex;

		if(selectedIndex > -1){
			//selectedOption = $("inputWarrantyTitle").options[selectedIndex];
		}
		
		//$("inputWarrantyType").value 	= $("inputWarrantyTitle").options[$("inputWarrantyTitle").selectedIndex].getAttribute("wcSw");
		//$("inputWarrantyText").value 	= $("inputWarrantyTitle").options[$("inputWarrantyTitle").selectedIndex].getAttribute("wcText");
		$("inputWarrantyText").value	= unescapeHTML2(
			selectedOption.getAttribute("wcText01") +
			selectedOption.getAttribute("wcText02") +
			selectedOption.getAttribute("wcText03") +
			selectedOption.getAttribute("wcText04") +
			selectedOption.getAttribute("wcText05") +
			selectedOption.getAttribute("wcText06") +
			selectedOption.getAttribute("wcText07") +
			selectedOption.getAttribute("wcText08") +
			selectedOption.getAttribute("wcText09") +
			selectedOption.getAttribute("wcText10") +
			selectedOption.getAttribute("wcText11") +
			selectedOption.getAttribute("wcText12") +
			selectedOption.getAttribute("wcText13") +
			selectedOption.getAttribute("wcText14") +
			selectedOption.getAttribute("wcText15") + 
			selectedOption.getAttribute("wcText16") + 
			selectedOption.getAttribute("wcText17"));
		//$("inputPrintSwitch").checked 	= $("inputWarrantyTitle").options[$("inputWarrantyTitle").selectedIndex].getAttribute("printSw") == 'Y' ? true : false;
		//$("inputChangeTag").checked 	= $("inputWarrantyTitle").options[$("inputWarrantyTitle").selectedIndex].getAttribute("changeTag") == 'Y' ? true : false;	
		var max = 0;
		$$("div[name='row']").each(function (row) {
			if (parseInt(row.down("input", 4).value) > max) {
				max = parseInt(row.down("input", 4).value);
			}
		});
		$("inputPrintSeqNo").value = max+1;	
	} */
	/* commented by D. Alcantara 10/28/2010
	$("inputWarrantyText").observe("keypress", function () {
		var id = $("inputWarrantyTitle").selectedIndex;
		
		if($F("inputWarrantyText") != $F("wcText"+id)) {
			$("inputChangeTag").checked = true;
		} else {
			$("inputChangeTag").checked = false;
		}
	});*/

	/* $("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", saveAndCancel, 
					function() {getLineListingForPAR(riSwitch);});
		} else {
			//getLineListingForPAR();
			exitWC();
		}
	}); */
	
	/* Marco - confirm box with added cancel button*/
	$("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, 
					exitWC, "");
		} else {
			//getLineListingForPAR();
			exitWC();
		}
	});

	$("btnSaveWPolWC").observe("click", function()	{
		if(changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);
		} else {
			saveWPolicyWarrantyAndClause();
		}
	});

	function saveWPolicyWarrantyAndClause()	{
		try {
			new Ajax.Request("GIPIWPolicyWarrantyAndClauseController?action=saveWPolWC&globalParId="+$F("globalParId")+"&globalLineCd="+$F("globalLineCd"), {
				method: "POST",
				postBody: Form.serialize("pcMainForm").replace(/"/g, "\""),
				onCreate: function () {
					$("pcMainForm").disable();
					$("btnSaveWPolWC").disable();
					$("btnCancel").disable();
					showNotice("Saving, please wait...");
				}, 
				onComplete: function (response)	{
					changeTag = 0;
					if (response.responseText == "SUCCESS")	{
						setWarrantyAndClauseForm(null);
					}
					$("pcMainForm").enable();
					$("btnSaveWPolWC").enable();
					$("btnCancel").enable();
					if (checkErrorOnResponse(response)) {
						//hideNotice(response.responseText);
						setCursor("default");
						pAction = pageActions.none;	 
						if (checkErrorOnResponse(response))	{							
							setWarrantyAndClauseForm(null);
							//changeTag = 0;
							if (pAction == pageActions.reload){
								showWPolicyWarrantyAndClausePage();
							} else if (pAction == pageActions.cancel){
								getLineListingForPAR(riSwitch);
							} else {
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								showWPolicyWarrantyAndClausePage();
							}
						}
					}
				}
			});
		} catch(e) {
			showErrorMessage("saveWPolicyWarrantyAndClause", e);
			//showMessageBox("saveWarrantyAndClause : " + e.message);
		} finally {
			hideNotice();
		}
		
	}

	function setWarrantyAndClauseForm(row){
		//var s = $("inputWarrantyTitle");
		if (row == null){
			$("txtWarrantyTitle").clear();
			//s.show();
			//$("warratyTitleDisplay").clear();
			//$("warratyTitleDisplay").hide();
			$("searchWarrantyTitle").show();
			$("inputWarrantyTitle2").clear();
			$("inputWarrantyType").clear();
			$("inputPrintSeqNo").clear();
			$("inputPrintSwitch").checked = false;
			$("inputChangeTag").checked = false;
			$("inputWarrantyText").clear();
			$("hidOrigWarrantyText").clear();
		} else {
			/* for (var i=0; i<s.length; i++)	{
				if (s.options[i].value==row.down("input", 0).value)	{
					s.selectedIndex = i;
				}
			} */

			// added to hide warranty dropdown and make it readonly field
			//s.hide();
			//$("warratyTitleDisplay").value = s.options[s.selectedIndex].text;
			//$("warratyTitleDisplay").show();
			$("searchWarrantyTitle").hide();
			$("hidWcCd").value = (row == null ? "" : row.down("input", 0).value);
			$("txtWarrantyTitle").value = (row == null ? "" : row.down("input", 1).value);
			$("inputWarrantyTitle2").value 	= (row == null ? "" : row.down("input", 2).value);
			$("inputWarrantyType").value 	= (row == null ? "" : row.down("input", 3).value);
			$("inputPrintSeqNo").value 		= (row == null ? "" : row.down("input", 4).value);
			$("inputPrintSwitch").checked 	= (row == null ? false : (row.down("input", 5).value == "Y" ? true : false));
			$("inputChangeTag").checked 	= (row == null ? false : (row.down("input", 6).value == "Y" ? true : false));
			$("inputWarrantyText").value 	= (row == null ? "" : nvl(row.down("input", 7).value, ""))+(row == null ? "" : nvl(row.down("input", 8).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 9).value, ""))+(row == null ? "" : nvl(row.down("input", 10).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 11).value, ""))+(row == null ? "" : nvl(row.down("input", 12).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 13).value, ""))+(row == null ? "" : nvl(row.down("input", 14).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 15).value, ""))+(row == null ? "" : nvl(row.down("input", 16).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 17).value, ""))+(row == null ? "" : nvl(row.down("input", 18).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 19).value, ""))+(row == null ? "" : nvl(row.down("input", 20).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 21).value, ""))+(row == null ? "" : nvl(row.down("input", 22).value, ""))
											  +(row == null ? "" : nvl(row.down("input", 23).value, ""));
			$("hidOrigWarrantyText").value = row.readAttribute("origWarrantyText");
		}
		$("btnAdd").value 				= (row == null ? "Add" : "Update");
		
		//(row == null ? $("inputWarrantyTitle").enable() : $("inputWarrantyTitle").disable());
		(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));		
	}

	/* function hideAddedWC() {
		var wcOpt = $("inputWarrantyTitle").options;
		$$("div[name='row']").pluck("id").findAll(function(row) {
			for (var i=0; i<wcOpt.length; i++) {
				if (row.substring(2) == wcOpt[i].value) {
					wcOpt[i].hide();
					wcOpt[i].disabled = true;
				}
			}
		});		
	} */

	/* function showDeletedWC(row) {
		var wcOpt = $("inputWarrantyTitle").options;
		for(var i=0; i<wcOpt.length; i++) {
			if (row.id.substring(2) == wcOpt[i].value) {
				wcOpt[i].disabled = false;
				wcOpt[i].show();
			}
		}	
	} */
	
	$("editWarrantyText").observe("click", function () {
		//showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", defaultText, "inputChangeTag");		
		showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", resetText, checkChangeTag);
	});
	
	/* Marco - text editor for warranty title 2*/
	$("editWarrantyTitle2").observe("click", function () {
		//showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", defaultText, "inputChangeTag");		
		//showEditor2("inputWarrantyText", 34000, "Confirm", "Do you really want to change this text?", resetText, checkChangeTag);
		showEditor2("inputWarrantyTitle2", 100, "Confirm", "Do you really want to change this text?", resetText, checkChangeTag);
	});

	function checkChangeTag() {
		$("inputChangeTag").checked = true;
	}

	function resetText() {
		var defaultText = "";
		if($F("inputWarrantyTitle") != "") {
			defaultText = $("inputWarrantyTitle").options[$("inputWarrantyTitle").selectedIndex].getAttribute("wcText");
		}
		
		$("inputWarrantyText").value = defaultText;
		$("inputChangeTag").checked = false;
	}

	$("inputWarrantyText").observe("keyup", function () {
		limitText(this, 34000);
	});

	function exitWC() {
		try {
			Effect.Fade("parInfoDiv", {
				duration: .001,
				afterFinish: function () {				
					if ($("parListingMainDiv").down("div", 0).next().innerHTML.blank()) {
						if($F("globalParType") == "E"){
							showEndtParListing();
						}else{							
							showParListing();
						}
					} else {
						$("parInfoMenu").hide();
						Effect.Appear("parListingMainDiv", {duration: .001});
					}
					$("parListingMenu").show();
				}
			});
		} catch (e) {
			showErrorMessage("exitWC", e);
		}
	}

	function createWarrantyTitleList(){
		try{
			var select = $("inputWarrantyTitle");
			var option = new Element("option");

			for(var i=1, length=objWarrClause.length; i < length; i++){				
				var option = new Element("option");
				
				option.setAttribute("value", objWarrClause[i].wcCd);
				option.setAttribute("wcSw", objWarrClause[i].wcSw);
				option.setAttribute("printSw", objWarrClause[i].printSw);
				option.setAttribute("changeTag", objWarrClause[i].changeTag);
				option.setAttribute("wcText", objWarrClause[i].wcText);
				option.setAttribute("wcText01", nvl(objWarrClause[i].wcText1, ""));
				option.setAttribute("wcText02", nvl(objWarrClause[i].wcText2, ""));
				option.setAttribute("wcText03", nvl(objWarrClause[i].wcText3, ""));
				option.setAttribute("wcText04", nvl(objWarrClause[i].wcText4, ""));
				option.setAttribute("wcText05", nvl(objWarrClause[i].wcText5, ""));
				option.setAttribute("wcText06", nvl(objWarrClause[i].wcText6, ""));
				option.setAttribute("wcText07", nvl(objWarrClause[i].wcText7, ""));
				option.setAttribute("wcText08", nvl(objWarrClause[i].wcText8, ""));
				option.setAttribute("wcText09", nvl(objWarrClause[i].wcText9, ""));
				option.setAttribute("wcText10", nvl(objWarrClause[i].wcText10, ""));
				option.setAttribute("wcText11", nvl(objWarrClause[i].wcText11, ""));
				option.setAttribute("wcText12", nvl(objWarrClause[i].wcText12, ""));
				option.setAttribute("wcText13", nvl(objWarrClause[i].wcText13, ""));
				option.setAttribute("wcText14", nvl(objWarrClause[i].wcText14, ""));
				option.setAttribute("wcText15", nvl(objWarrClause[i].wcText15, ""));
				option.setAttribute("wcText16", nvl(objWarrClause[i].wcText16, ""));
				option.setAttribute("wcText17", nvl(objWarrClause[i].wcText17, ""));

				option.text = unescapeHTML2(nvl(objWarrClause[i].wcTitle, ""));

				select.add(option, null);
			} 
		}catch(e){
			showErrorMessage("createWarrantyTitleList", e);
		}
	}

	//createWarrantyTitleList();
	
	initializeChangeTagBehavior(saveWPolicyWarrantyAndClause);
	
	$("searchWarrantyTitle").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		$$("div#wpolicyWCList div[name='row']").each(function(row){
			if(withPrevious) notIn += ",";
			notIn += "'"+row.down("input", 0).value+"'";
			withPrevious = true;
		});

		notIn = (notIn != "" ? "("+notIn+")" : "");
		showWarrantyAndClauseLOV(objUWGlobal.lineCd, notIn);		
	});
</script>