<!--
Remarks: For deletion
Date : 03-28-2012
Developer: udel
Replacement : /pages/marketing/quotation/quotationWarrCla.jsp
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="wcMainDiv" name="wcMainDiv" style="margin-top: 1px; display: none;">
	<form id="wcMainForm" name="wcMainForm">
		<input type="hidden" name="quoteId"  	id="quoteId" 	value="${gipiQuote.quoteId}" />
		<input type="hidden" name="lineCd" 		id="lineCd" 	value="${gipiQuote.lineCd}" />
		<input type="hidden" name="lineName" 	id="lineName" 	value="${gipiQuote.lineName}" />

		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label id="">Quotation Information</label>  
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>

		<div id="clausesDiv" name="clausesDiv" class="sectionDiv">
			<div id="quoteInfo" name="quoteInfo" style="margin: 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Quotation No. </td>
						<td class="leftAligned"><input type="text" style="width: 250px;" id="quoteNo" name="quoteNo" readonly="readonly" value="${gipiQuote.quoteNo}" />
						<td class="rightAligned">Assured Name </td>
						<td class="leftAligned">
							<input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${gipiQuote.assdName}" />
							<input type="hidden" id="assuredNo" name="assuredNo" value="${gipiQuote.assdNo}" />
						</td>	
					</tr>
				</table>
			</div>
		</div>

		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Warranties and Clauses</label> 
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="refreshList" name="refreshList">Refresh List</label>
				</span>
			</div>
		</div>
		<div id="cwDivAndFormDiv" name="cwDivAndFormDiv" class="sectionDiv" >
			<div id="wcDiv" name="wcDiv" style="margin-top: 10px;" class="tableContainer">
			</div>
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px;" changeTagAttr="true">
				<form id="wcFormHaha" name="wcFormHaha">
					<table align="center" border="0">
						<tr style="display: none;" id="message" name="message">
							<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
						</tr>
						<tr>
							<td class="rightAligned">Warranty Title </td>
							<td colspan="3" class="leftAligned" changeTagAttribute="true">
								<%-- emsy 11.16.2011 ~ select option not needed
								<input type="text" id="warratyTitleDisplay" readonly="readonly" class="required" style="width: 437px; display: none;" />
								<select id="warrantyTitle" name="warrantyTitle" style="width: 445px;" class="required">
									<option value=""></option>
									<c:forEach var="wc" items="${wcTitles}">
										<option value="${wc.wcCd}" lineCd="${wc.lineCd}" printSw="${wc.printSw}" wcTitle="${wc.wcTitle}" changeTag="${wc.changeTag}" wcSw="${wc.wcSw}">${wc.wcTitle}</option>											
									</c:forEach>
								</select>
								--%>

								<span class="required lovSpan" style="width: 430px;">
									<input type="hidden" id="hidWcCd" name="hidWcCd"> 								
									<input type="text" id="warratyTitleDisplay" name="warratyTitleDisplay" readonly="readonly" class="required" style="width: 405px;  float: left; border: medium none; height: 13px; margin: 0pt;" />								
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarrantyTitle" name="searchWarrantyTitle" alt="Go" style="float: right;"/>
								</span>
							</td>
							<td class="leftAligned" colspan="2"><input type="text" id="warrantyTitle2" name="warrantyTitle2" style="width: 190px;" maxlength="100" /></td>
						</tr>
						<tr>
							<td class="rightAligned">Type </td>
							<td class="leftAligned"><input type="text" id="warrantyClauseType" name="warrantyType" readonly="readonly" /></td>
							<td class="rightAligned">Print Sequence No. </td>
							<td class="leftAligned"><input type="text" id="printSeqNumber" name="printSeqNo" maxlength="2" class="required" style="width: 169px;" /></td>
							<!-- grace 10.6.10 remove SWC No. column. column not used anymore. refer to warranties&clauses test case version3 
							<td class="rightAligned">SWC No. </td>
							<td class="leftAligned"><input type="text" id="swcNo" name="swcNo" maxlength="2" class="required" style="width: 61px;" /></td>
							 -->
						</tr>
						<tr>
							<td class="rightAligned">Print Switch </td>
							<td class="leftAligned"><input type="checkbox" id="printSwitch" name="printSwitch" value="Y" /></td>
							<td class="rightAligned">Change Tag </td>
							<td class="leftAligned"><input type="checkbox" id="changeTag" name="changeTag" value="Y" disabled="disabled"/></td>
							<td class="leftAligned"><input type="hidden" id="charactersRemaining" name="charactersRemaining" style="width: 61px;" value="32500" />  </td>
						</tr>
						<tr>
							<td class="rightAligned">Warranty Text</td>
							<td colspan="5" class="leftAligned">
								<div style="border: 1px solid gray; height: 20px; width: 650px;">
									<input type="hidden" id="wTextChanged" name="wTextChanged" value="N" changeTagAttribute="true" /> <!-- emsy 11.16.2011 added this -->
									<input type="hidden" id="hidOrigWarrantyText" name="hidOrigWarrantyText" style="width: 610px; border: none; height: 13px;"></input> <!-- emsy 11.16.2011 added this -->
									<textarea id="warrantyText" name="warrantyText" style="width: 620px; border: none; height: 13px;"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
								</div>
							</td>
						</tr>
						<tr align="center">
							<td colspan="8">
								<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
								<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" class="disabled" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td>
								<input style="width: 650px;" id="origWarrantyText" 		name="origWarrantyText"  	type="hidden" value="" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="buttonsDiv" id="wcButtonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Basic Quotation Info" />
						<input type="button" class="button" style="width: 90px;" id="btnSaveQuotationWC" name="btnSaveQuotationWC" value="Save" />
						<!-- <input type="button" class="disabledButton" style="width: 90px;" id="btnPrintQuotationWC" name="btnPrintQuotationWC" value="Print" /> grace 10.06.10 to apply requested revision in test case version 3-->
					</td>
				</tr>
			</table>
		</div>
		<c:forEach var="w" items="${wcTitles}" varStatus="counter">
			<input type="hidden" name="wcText" id="wcText${counter.count}" value="${w.wcText}" />
		</c:forEach>
	</form>
</div>
<script type="text/JavaScript">
	/*$("btnEditRemarks").observe("click", function () {
		showWysiwyg("warrantyText");
	});*/
	changeTag = 0;
	setModuleId("GIIMM008"); // andrew - 11.22.2010 - added this line

	if (isMakeQuotationInformationFormsHidden == 1) {
		$("wcFormDiv").hide();
		$("wcButtonsDiv").hide();
	}
	/* emsy 11.29.2011 ~ removed this, validation for reloadForm found in line 579
	$("reloadForm").observe("click", function (){
		showClausesPage();
	});
	*/

	$("refreshList").observe("click", function ()	{
		loadWarrantyAndClausesByPage(1);
	});


	$("btnAdd").observe("click", function ()	{
		addWarranties();
	});
	// Patrick
	function validatePrintSeqNo(){
		if($F("printSeqNumber") < 1 || isNaN($F("printSeqNumber")) || checkDecimal()){
			return true;
		}
		return false;
	}

	function checkDecimal(){
		for(i = 0; i < $("printSeqNumber").value.length; i++){
			if ($("printSeqNumber").value.charAt(i)=='.'){
				  return true;
			}
		}
		return false;
	}
	
	$("printSeqNumber").observe("change", function(){ //Steven 3.6.12
		if(validatePrintSeqNo()){
			showMessageBox("Invalid Print Sequence No. <br />Value should be from 1 to 99.", imgMessage.ERROR);
			$("printSeqNumber").clear();
			$("printSeqNumber").focus();
		}
		$$("div[name='row']").each(function(a){
			if ((a.down("input", 4).value)== $F("printSeqNumber") && (a.down("input", 0).value)!= $F("hidWcCd")) {
				showMessageBox("Print Sequence No. must be unique", imgMessage.ERROR);
				$("printSeqNumber").clear();
				$("printSeqNumber").focus();
			}
		});
	});
	
	//end
	function addWarranties() {
		try{
			/* emsy 11.16.2011 ~ remove all  references to warrantyTitle
			var wcCd = $F("warrantyTitle");							// required
			var wcTitle = $("warrantyTitle").options[$("warrantyTitle").selectedIndex].text;
			*/
			var wcCd 		   = $F("hidWcCd");		// required
			var wcTitle	 	   = $("warratyTitleDisplay").value;
			var wcTitle2 	   = $F("warrantyTitle2");
			var wcType 		   = $F("warrantyClauseType");
			var wcPrintSeqNo   = ($F("printSeqNumber") == "") ? "" : $F("printSeqNumber"); // Patrick - removed "0" for validation
		//	var wcSwcNo = ($F("swcNo") == "") ? "0" : $F("swcNo"); --grace 10.6.10 remove all references to SWC no.								
			var wcPrintSw 	   = $("printSwitch").checked ? "Y" : "N";
			var wcChangeTag    = $("changeTag").checked ? "Y" : "N";
			var wcWarrantyText = $F("warrantyText");
			
			var exists = false;			
			$$("input[type='hidden']").each(function (h)	{
				if (h.getAttribute("name") == "wcCd")	{
					if (h.value == wcCd)	{
						exists = true;
					}
				}
		    });

			/* added by grace 10.8.10
			** add validation if the print sequence no. exists in other records
			*/
			
		 	printSeqExists = false;	
			$$("div[name='row']").each(function(a){
			  //if ((a.down("input", 4).value)== $F("printSeqNumber") && (a.down("input", 0).value)!= $F("warrantyTitle")) { emsy - 11.16.2011
				if ((a.down("input", 4).value)== $F("printSeqNumber") && (a.down("input", 0).value)!= $F("hidWcCd")) {
					printSeqExists = true;
				}
			});
			/*emsy 11.16.2011 ~ remove all references to warrantyTitle
			if ($F("warrantyTitle").blank())	{
				showMessageBox("Warranty title is required.", imgMessage.ERROR);
			}
			*/ 
			if ($F("hidWcCd").blank())	{
				showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
				return false;
			} else if(wcPrintSeqNo == ""){
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 
					function(){
						$("printSeqNumber").focus();
					});
				return false; // Patrick
			}else if(wcTitle == ""){
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 
						function(){
							$("warratyTitleDisplay").focus();
						});
					return false; // Steven 3.2.2012
				}
			/* else if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".")) {
				showMessageBox("Invalid Print Sequence No. <br />Value should be from 1 to 99.", imgMessage.ERROR);
				$("printSeqNumber").clear();
				$("printSeqNumber").focus();
				return false; */ // --PATRICK
		
			/* --grace 10.6.10 remove all references to SWC no.
			} else if (parseInt(wcSwcNo) > 99 || parseInt(wcSwcNo) < 1 || wcSwcNo.include(".")) {
				showMessageBox("Invalid SWC No. <br />Value should be from 1 to 99.", imgMessage.ERROR);
				return false;
			*/	

			  /* else if (parseInt(wcPrintSeqNo) == "0" || isNaN($F("printSeqNumber"))) {
				showMessageBox("Invalid Print Sequence No. <br /> Value should be from 1 to 99.", imgMessage.ERROR);
				$("printSeqNumber").value = "";
				return false; 
			} */
			/* --grace 10.6.10 remove all references to SWC no.	
			 else if (parseInt(wcSwcNo) == "0" || isNaN($F("swcNo"))) {
				showMessageForForm("SWC Number Required.");
				$("swcNo").value = "";
				return false;
			} else */
			if (wcWarrantyText.length > 32500) {
				showMessageForForm("Warranty Text should have a maximum of 32,500 characters only.");
			} else if (wcWarrantyText.length > 32500) {
				showMessageBox("Warranty Text should have a maximum of 32,500 characters only.", imgMessage.ERROR);
			} else if (exists && ($F("btnAdd") != "Update"))	{
				showMessageBox("Warranty and clauses entry already exists.", imgMessage.ERROR);
				return false;
			} else if (printSeqExists){
				// emsy 11.16.2011 ~ showMessageBox("Print Sequence no. must be unique", imgMessage.ERROR); 
				showMessageBox("Print Sequence No. must be unique", imgMessage.ERROR);
				$("printSeqNumber").clear();
				$("printSeqNumber").focus();
				return false;
			}
			$("searchWarrantyTitle").show();//steven 3.5.2012  
			  
			  
			var wcDiv = $("wcTableContainerDiv");
			
			if ($("btnAdd").value == "Update")	{
				var content = '<input type="hidden" id="wcCd'+wcCd+'" name="wcCd" value="'+wcCd+'" />'+
				  '<input type="hidden" id="wcTitle'+wcCd+'" name="wcTitle" value="'+wcTitle+'" />'+
				  '<input type="hidden" id="wcTitle2'+wcCd+'" name="wcTitle2" value="'+changeSingleAndDoubleQuotes(wcTitle2)+'" />'+
				  '<input type="hidden" id="warrantyType'+wcCd+'" name="warrantyType" value="'+wcType+'" />'+
				  '<input type="hidden" id="printSeqNo'+wcCd+'" name="printSeqNo" value="'+wcPrintSeqNo+'" />'+
				  /* --grace 10.6.10 remove all references to SWC no.
				  '<input type="hidden" id="swcSeqNo'+wcCd+'" name="swcSeqNo" value="'+wcSwcNo+'" />'+ */ 
				  '<input type="hidden" id="printSw'+wcCd+'" name="printSw" value="'+wcPrintSw+'" />'+
				  '<input type="hidden" id="changeTag'+wcCd+'" name="changeTag" value="'+wcChangeTag+'" />'+
				  '<input type="hidden" id="wcText'+wcCd+'" name="wcText" value="'+wcWarrantyText.replace(/"/g, "&quot;")+'" />'+
				  '<label style="width: 300px; text-align: left; margin-left: 5px;" title="'+wcTitle+'-'+wcTitle2+'" name="title" id="'+wcTitle+'">'+(wcTitle+' - '+wcTitle2).truncate(40, "...")+'</label>'+
				  '<label style="width: 150px; text-align: center;">'+wcType+'</label>'+
		   		  '<label style="width: 70px; text-align: center;">'+(wcPrintSeqNo.blank() ? "-" : wcPrintSeqNo)+'</label>'+
		   		/* --grace 10.6.10 remove all references to SWC no.	
				  '<label style="width: 70px; text-align: center;">'+(wcSwcNo.blank() ? "-" : wcSwcNo)+'</label>'+ */
				  '<label style="width: 203px; text-align: left;" id="text'+wcCd+'" name="text" title="Click to view complete text.">'+(wcWarrantyText.blank() ? "-" : wcWarrantyText).truncate(26, "...")+'</label>'+
				  '<div style="display: none;">'+wcWarrantyText+'</div>'+
				  '<label style="width: 20px; text-align: center;">';
				if (wcPrintSw == 'Y') {
					content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />';
				} else {
					content += '<span style="float: left; width: 10px; height: 10px;">-</span>';
				}
				content += '</label><label style="width: 20px; text-align: center;">';
				if (wcChangeTag == 'Y') {
					content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />';
				} else {
					content += '<span style="float: left; width: 10px; height: 10px;">-</span>';
				}
				content += '</label>';
				$("wc"+wcCd).update(content);
				($$("div#cwDivAndFormDiv [changed=changed]")).invoke("removeAttribute", "changed");
			}else {
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "wc"+wcCd);
				newDiv.setAttribute("name", "row");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var content = '<input type="hidden" id="wcCd'+wcCd+'" name="wcCd" value="'+wcCd+'" />'+
							  '<input type="hidden" id="wcTitle'+wcCd+'" name="wcTitle" value="'+wcTitle+'" />'+
							  '<input type="hidden" id="wcTitle2'+wcCd+'" name="wcTitle2" value="'+changeSingleAndDoubleQuotes(wcTitle2)+'" />'+
							  '<input type="hidden" id="warrantyType'+wcCd+'" name="warrantyType" value="'+wcType+'" />'+
							  '<input type="hidden" id="printSeqNo'+wcCd+'" name="printSeqNo" value="'+wcPrintSeqNo+'" />'+
							  /* --grace 10.6.10 remove all references to SWC no.
							  '<input type="hidden" id="swcSeqNo'+wcCd+'" name="swcSeqNo" value="'+wcSwcNo+'" />'+ */
							  '<input type="hidden" id="printSw'+wcCd+'" name="printSw" value="'+wcPrintSw+'" />'+
							  '<input type="hidden" id="changeTag'+wcCd+'" name="changeTag" value="'+wcChangeTag+'" />'+
							  '<input type="hidden" id="wcText'+wcCd+'" name="wcText" value="'+wcWarrantyText.replace(/"/g, "&quot;")+'" />'+
							  '<label style="width: 300px; text-align: left; margin-left: 5px;" title="'+wcTitle+'-'+wcTitle2+'" name="title" id="'+wcTitle+'">'+(wcTitle+' - '+wcTitle2).truncate(40, "...")+'</label>'+
							  '<label style="width: 150px; text-align: center;">'+wcType+'</label>'+
					   		  '<label style="width: 70px; text-align: center;">'+(wcPrintSeqNo.blank() ? "-" : wcPrintSeqNo)+'</label>'+
					   		  /* --grace 10.6.10 remove all references to SWC no.	
							  '<label style="width: 70px; text-align: center;">'+(wcSwcNo.blank() ? "-" : wcSwcNo)+'</label>'+*/
							  '<label style="width: 203px; text-align: left;" id="text'+wcCd+'" name="text" title="Click to view complete text.">'+(wcWarrantyText.blank() ? "-" : wcWarrantyText).truncate(26, "...")+'</label>'+
							  '<div style="display: none;">'+wcWarrantyText+'</div>'+
							  '<label style="width: 20px; text-align: center;">';
				if (wcPrintSw == 'Y') {
					content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />';
				} else {
					content += '<span style="float: left; width: 10px; height: 10px;">-</span>';
				}
				content += '</label><label style="width: 20px; text-align: center;">';
				if (wcChangeTag == 'Y') {
					content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />';
				} else {
					content += '<span style="float: left; width: 10px; height: 10px;">-</span>';
				}
				content += '</label>';
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
						
						/* emsy 11.16.2011 ~ remove all reference to select option
						var s = $("warrantyTitle");
						for (var i=0; i<s.length; i++)	{
							if (s.options[i].value==newDiv.down("input", 0).value)	{
								s.selectedIndex = i;
							}
						}

						s.hide(); 
						$("warratyTitleDisplay").value = s.options[s.selectedIndex].text;
						*/
						$("warratyTitleDisplay").show();
						$("hidWcCd").value = newDiv.down("input", 0).value; // ~ emsy 11.29.2011
						$("warratyTitleDisplay").value = newDiv.down("input", 1).value;
						$("warrantyTitle2").value = newDiv.down("input", 2).value;
						$("warrantyClauseType").value = newDiv.down("input", 3).value;
						$("printSeqNumber").value = newDiv.down("input", 4).value;
						// --grace 10.6.10 remove all references to SWC no.
						//$("swcNo").value = newDiv.down("input", 5).value;
						$("printSwitch").checked = newDiv.down("input", 5).value == "Y" ? true : false;
						$("changeTag").checked = newDiv.down("input", 6).value == "Y" ? true : false;
						$("warrantyText").value = newDiv.down("input", 7).value;
						$("btnDelete").enable();
						$("searchWarrantyTitle").hide();// ~ emsy 11.29.2011
						$("btnAdd").value = "Update";
						/*$("btnDelete").enable();
						$("btnDelete").removeClassName("disabledButton");
						$("btnDelete").addClassName("button");*/
						enableButton("btnDelete");
					}	else	{ 
						/* emsy 11.16.2011 ~ remove all reference to warrantyTitle
						$("warrantyTitle").show(); 
	 					*/
						$("warratyTitleDisplay").clear(); 
						$("warratyTitleDisplay").hide();
						$("searchWarrantyTitle").show();// ~ emsy 11.29.2011
						$("hidWcCd").show();// ~ emsy 11.24.2011
						$("hidWcCd").value = "";
						resetWCForm();
					}
				});
				
				Effect.Appear(newDiv, {
					duration: .5,
					afterFinish: function () {					
						resizeTableBasedOnVisibleRows("wcDiv", "wcTableContainerDiv");
						checkTableIfEmpty("row", "wcDiv");
					}
				});
				$("message").hide(); 
				//hideAddedWarranties(); ~ emsy 11.18.2011 
			}
			
			resetWCForm();
			changeTag = 1;
			
			//checkIfWillPrint(); -- grace 10.6.10 not needed anymore since print button is remove from page
		}catch(e){ 
			showErrorMessage("addWarranties", e);
		}
		
	}

	/**
	* Shows the Warranties that have been deleted from the user's choices 
	*	  and sends them back to the available options 
	* @author rencela
	*/	
	/*  emsy 11.28.2011 ~ function not used
	function unhideDeletedWarranties(row){
		row.childElements().findAll(function(a){
			if(a.type != "hidden" && a.id != "" && !isNaN(a.id.substring(5,6))){
				var ind = parseInt(a.id.substring(5,6));
				if(ind != 0){
					//var wcSelOpts = $("warrantyTitle").options; ~ emsy 11.16.2011
					var wcSelOpts = $("hidWcCd").options;	
					wcSelOpts[ind].show();
				}
			}
		});
	}
 */
	/**
	* Hide Warranties that have been added to the table
	*/
	/* emsy 11.28.2011 ~ function not used
	function hideAddedWarranties(){
		try{
			//var wcSelOpts = $("warrantyTitle").options; ~ emsy 11.16.2011 
			var wcSelOpts = $("hidWcCd").options;
			$$("div[name='row']").pluck("id").findAll(function (a) {
				for (var i=0; i<wcSelOpts.length; i++) {
					if (a.substring(2) == wcSelOpts[i].value) { 
						wcSelOpts[i].hide();
					}
				}
			});			
		}catch(e){
			showErrorMessage("hideAddedWarranties", e);
		}
	} */
		
	$("btnDelete").observe("click", function ()	{
		$$("div[name='row']").each(function (row){ 
			if (row.hasClassName("selectedRow")){		
				Effect.Fade(row, {
					duration: .5,
					afterFinish: function ()	{
						row.remove();
						//unhideDeletedWarranties(row); ~ emsy 11.23.2011 function not needed
						resetWCForm();
						resizeTableBasedOnVisibleRows("wcDiv", "wcTableContainerDiv");
						//checkIfToResizeTable("wcDiv", "row");
						checkTableIfEmpty("row", "wcDiv");
						//checkIfWillPrint(); -- grace 10.6.10 not needed anymore since print button is remove from page
						changeTag = 1; //emsy 11.22.2011 ~ added this
						$("searchWarrantyTitle").show();
					}
				});
			}
		});
	});
	
	
	/*try {
		var wcTitles = ($("wcTitlesDiv").innerHTML).evalJSON(); 
	} catch (e) {
		showErrorMessage("wcTitles", e);
	}*/

	/* emsy 11.16.2011 ~ remove all references to warrantyTitle
		$("warrantyTitle").observe("change", function (s)	{
		var id = $("warrantyTitle").selectedIndex;
	*/ 
	$("hidWcCd").observe("change", function (s)	{
		var id = $("hidWcCd").value;
		if (id == "" || id == 0)	{
			resetWCForm();
		} else{
			/* emsy 11.16.2011 ~ remove all references to select option
			$("warrantyClauseType").value = $("warrantyTitle").options[$("warrantyTitle").selectedIndex].readAttribute("wcSw");
			$("warrantyText").value 	= $F("wcText"+id);
			$("printSwitch").checked 	= $("warrantyTitle").options[$("warrantyTitle").selectedIndex].readAttribute("printSw") == 'Y' ? true : false; 
			$("changeTag").checked 		= $("warrantyTitle").options[$("warrantyTitle").selectedIndex].readAttribute("changeTagSw")== 'Y' ? true : false;
			*/
			$("warratyTitleDisplay").value = $("wcTitle"+id).value;
			$("warrantyText").value 	= $F("wcText"+id);
		}
	});

	$("warrantyText").observe("focus", function () {	
		$("origWarrantyText").value = $("warrantyText").value;
	});

	/* Added by grace 10.8.2010
	** To display confirmation message whenever the warranties text is changed
	*/ 			
	$("warrantyText").observe("change", function (s)	{
		showConfirmBox("Message", "Do you really want to change this text?", "Yes", "No", function(){$("changeTag").checked = true;}, onCancelFunc);
	});	

	/* function onOkFunction() {
		$("changeTag").checked = true;
		addWarranties();
	} */	
	function onCancelFunc() {
		$("warrantyText").value = $("origWarrantyText").value;
	}	

	/**
	* Show the current number of characters written in the TextArea
	* Works even for pasted letters in the TextArea
	* Reusable
	*/
	function limitTextArea(limitField, limitCount, limitNum) {
		limitNum = parseInt(limitNum);
		if ($F(limitField).length > limitNum) {
			$(limitField).value = $F(limitField).substring(0, limitNum);
		} else {
			$(limitCount).value = limitNum - $F(limitField).length;
		}
	}

	$("warrantyText").observe("keyup", function(){		limitTextArea("warrantyText","charactersRemaining",32500);});	
	$("warrantyText").observe("keydown", function(){	limitTextArea("warrantyText","charactersRemaining",32500);});

	/* grace 10.6.10 remove all references to SWC No.
	$("swcNo").observe("keypress", function(){
		isWithinBounds("swcNo", 1, 99, "Invalid SWC No. Value should be from 1 to 99.", false);
	});*/
	
	//$("swcNo").observe("blur", function(){ --grace 
		//var swc = $F("swcNo");--grace
		//$("swcNo").value = swc.replace(' ','');
		//$("swcNo").value = swc.replace('  ','');
		
		//isWithinBounds("swcNo", 1, 99, "Invalid SWC No. Value should be from 1 to 99.", false);
	//}); -- grace
	

	/* ~ emsy 11.28.2011
	$("printSeqNumber").observe("keydown", function(){
		isWithinBounds("printSeqNumber", 1, 99, "Invalid Print Sequence No. Value should be from 1 to 99.", false);
	});
	*/

	/* $("btnEditQuotation").observe("click", function () {
		
		editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
	
	}); */
	function goToEnterQuotationInfo(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", "Do you want to save the changes you have made?", "Yes", "No", "Cancel", 
							function(){
								saveWarrantyAndClause();
								changeTag = 0;
								setModuleId("GIIMM002");
								setDocumentTitle("Enter Quotation Information");
								editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");},
							function(){
								changeTag = 0;
								setModuleId("GIIMM002");
								setDocumentTitle("Enter Quotation Information");
								editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");},
							"" );		
		}else{
			setModuleId("GIIMM002");
			setDocumentTitle("Enter Quotation Information");
			editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
		}
	}
	observeAccessibleModule(accessType.TOOLBUTTON, "GIIMM002", "btnEditQuotation", goToEnterQuotationInfo);
//	checkIfWillPrint();		

	initializeAccordion();

	addStyleToInputs();
	initializeAll();

	setDocumentTitle("Warranties and Clauses");
	loadWarrantyAndClausesByPage(1);

	$("editWarrantyText").observe("click", function () {
		showEditor11("warrantyText", 34000);
	});

	$("warrantyText").observe("keyup", function () {
		limitText(this, 34000);
	});
	
	//added observe to searchWarrantyTitle ~ emsy 11.16.2011
	$("searchWarrantyTitle").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		$$("div#wcTableContainerDiv div[name='row']").each(function(row){
			if(withPrevious) notIn += ",";
			notIn += "'"+row.down("input", 0).value+"'";
			withPrevious = true;
		});
		notIn = (notIn != "" ? "("+notIn+")" : "");
		showQuoteWarrantyAndClauseLOV($("lineCd").value, notIn);		
	});
	
	function showEditor11(textId, charLimit, readonly) {
		var zIndex = Windows.maxZIndex + 2000001;
		var margin = (screen.width - (610 + (screen.width*.1)))/2;
		Effect.ScrollTo("notice", {duration: .001});
		document.getElementById("textareaOpaqueOverlay").style.left = "0";
		document.getElementById("textareaOpaqueOverlay").style.display = "block";
		document.getElementById("textareaOpaqueOverlay").style.zIndex = zIndex-1; 
		
		document.getElementById("textareaContentHolder").style.zIndex = zIndex; 
		document.getElementById("textareaContentHolder").style.marginLeft = (margin)+"px";
		document.getElementById("textareaContentHolder").style.marginRight = margin+"px";
		document.getElementById("textareaContentHolder").style.top = "150px";
		document.getElementById("textareaContentHolder").style.display = "block";
		document.getElementById("textareaContentHolder").style.width = "600px";
		document.getElementById("textareaContentHolder").innerHTML = $("textareaDiv").innerHTML;
		
		document.getElementById("textarea1").style.fontFamily = 'courier';
		
		$("textarea1").value = $(textId).value;	
		$("textarea1").focus();
		$("overlayTextEditorTitle").update("Textarea Editor");
		
		$("textarea1").observe("keydown", function(){
			if(this.value.length <= charLimit){
				this.setAttribute("lastValue", this.value);
			}		
		});
		
		$("textarea1").observe("keyup", function () {
			if (this.value.length > charLimit) {
				this.value = this.getAttribute("lastValue");
				this.blur();
		    	showMessageBox('You have exceeded the maximum number of allowed characters ('+charLimit+') for this field.', imgMessage.INFO);
		    	return false;
		    }
		});
				
		try {
			//$("btnSubmitText").stopObserving("click");
			$("btnSubmitText").observe("click", function () {
				changeTag = 0;
				function onOk(){$(textId).value = $("textarea1").value;
				hideEditor(textId);
				if(readonly != undefined && readonly == 'true'){ //to avoid tagging of changeTag if readOnly
					null;
				}else{
					changeTag = 1;
					$("changeTag").checked = true;
					}
				}
				showConfirmBox("Message", "Do you really want to change this text?", "Yes", "No", onOk, function(){$("textarea1").value = $("origWarrantyText").value;});
			});

			$("btnCancelText").stopObserving("click");
			$("btnCancelText").observe("click", function () {
				hideEditor(textId);
			});
			
			$("closeEditor").stopObserving("click");
			$("closeEditor").observe("click", function () {
				hideEditor(textId);
			});
			//initializeChangeAttribute(showEditor11); -- removed
			initializeChangeAttribute();
		} catch (e) {
			showErrorMessage("showEditor11", e);
		}
	}
	
	function saveWarrantyAndClause() { // edited - irwin Feb. 9,2012
		if(checkPendingRecordChanges()){
	
			new Ajax.Request('GIPIQuotationWarrantyAndClauseController?action=saveWC',
			{	method : 'POST',
				postBody : Form.serialize("wcMainForm").replace(/"/g, "\""),
				onCreate : function() {
					/* $("wcMainForm").disable();
					$("btnSaveQuotationWC").disable(); */
				//	$("btnPrintQuotationWC").disable(); --grace 10.6.10 remove print button in page
					showNotice("Saving, please wait...");
				},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						/* $("wcMainForm").enable();
						$("btnSaveQuotationWC").enable(); */
						//$("btnPrintQuotationWC").enable();--grace 10.6.10 remove print button in page
						hideNotice(response.responseText);
						if (response.responseText == "SUCCESS") {
							//resetWCForm();
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS); //, showClausesPage);  --Patrick commented out showClausesPage
							changeTag = 0;
							lastAction();
							lastAction = ""; // Patrick
						}
					}
				}
			});
		}	
	}
	
	$("btnSaveQuotationWC").observe("click", function()	{
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveWarrantyAndClause();
		}
	});
	//observeSaveForm("btnSaveQuotationWC",saveWarrantyAndClause); //emsy 11.29.2011 ~ added validation to btnSaveQuotationWC - removed muna
	initializeChangeAttribute();
	observeReloadForm("reloadForm", showClausesPage); //emsy 11.29.2011 ~ added validation to reloadForm
	
	initializeChangeTagBehavior(saveWarrantyAndClause);
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){ // Patrick
		if(changeTag == 1){
			if(checkPendingRecordChanges()){
				showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveWarrantyAndClause();
									showQuotationListing();
				}, function(){showQuotationListing(); changeTag = 0;}, "");
			}
		}else {
			showQuotationListing();
		}
	});
</script>