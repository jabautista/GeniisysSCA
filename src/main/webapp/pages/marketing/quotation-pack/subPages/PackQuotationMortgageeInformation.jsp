<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
	request.setAttribute("path", request.getContextPath());
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Mortgagee Information </label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name='gro'>Hide</label>
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="mortgageeInformationSectionDiv" name="mortgageeInformationSectionDiv" style="" changeTagAttr="true">
	<div id="spinLoadingDiv"></div>
	<form action="packMortgageeForm">
		<div class="sectionDiv" id="mortgInfoDiv">
			<div id="packQuotationsInfoDiv" name="packQuotationsInfoDiv" align="center" style="margin: 10px;">
				<div class="tableHeader">
					<label style="width: 50%; padding-left: 20px;">Quotation No.</label>
				</div>
				<input id="selectedQuoteId" name="selectedQuoteId" type="hidden"/>
				<div id="packQuotationListing" name="packQuotationListing" class="tableContainer">
				</div>
			</div>
			
			<div class="tableContainer" id="mortgageeInformationDiv" name="mortgageeInformationDiv" align="center" style="margin: 10px; margin-top: 20px;" >
				<div class="tableHeader">
					<label style="width: 50%; padding-left: 20px;">Mortgagee Name</label>
					<label style="width: 20%; text-align: right;">Amount</label>
					<label style="width: 20%; text-align: center;">Item No.</label>
				</div>
				<div id="mortgageeListingDiv" name="mortgageeListingDiv" class="tableContainer">
				</div>	
				
				<div id="addMortgageeDiv" style="display: none;">
					<input id="selectedMortgCd" type="hidden"/>
					<table align="center" id="addMortgageeForm" style="margin-top:10px; margin-bottom:10px; " >
						<tr>
							<td class="rightAligned">Mortgagee Name </td>
							<td style="padding-left: 10px;">
								<select id="mortgOption" name="mortgOption" style="width: 280px;" class="required">
									<option value=""></option>
									<c:forEach var="mortgageeListing" items="${mortgageeListing}">
										<option value="${fn:replace(mortgageeListing.mortgCd, ' ', '_')}">${mortgageeListing.mortgName}</option>
										
									</c:forEach> 
								</select>
							</td>
						</tr>
						
						<tr>
							<td class="rightAligned">Amount </td>
							<td style="padding-left: 10px;" align="left">
							<input id="amount" name="amount" type="text" class="money" maxlength="17" value="" style="width: 274px;"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Remarks</td>
							<td class="leftAligned" style="padding-left: 10px;">
								<div style="border: 1px solid gray; height: 20px; width: 69.3%;" changeTagAttr="true">
								<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="remarksMortgagee" name="remarksMortgagee" style="width: 70%; border: none; height: 13px;" ></textarea>
								<img class="hover" src="${path}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editMortgageeRemarks" />
							</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Item No. </td>
							<td style="padding-left: 10px;" align="left">
								<input id="newMortgageeItemNo" name="newMortgageeItemNo" type="text" value="0" readonly="readonly" />						
							</td>
						</tr>
						<tr>
							<td></td>
							<td style="padding-left: 10px; text-align: left;">
								<input id="btnAddMortgagee" name="btnAddMortgagee" class="button" type="button" value="Add" style="width: 68px;" />
								<!-- <input id="mortgSave" name="mortgSave" class="button" type="button" value="mortgSave" style="width: 68px;" />	
								<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" class="disabledButton" type="button" value="Delete" style="width: 68px;" /></td> 	-->						
						</tr>
					</table>
				</div>
			</div>
		</div>	
	</form>
</div>

<script>
	$("mortgTag").value = "Y";
	$("mortgChanges").value = "N";
	objPackQuoteMortgagee = JSON.parse('${jsonGipiQuoteMortgagee}'.replace(/\\/g, '\\\\'));
	var objMortgageeList = JSON.parse('${jsonMortageeListing}'.replace(/\\/g, '\\\\'));
	loadPackQuotations();

	$$("div[name='rowPackQuotation']").each(function (row){
		row.observe("click", function(){
			if (row.hasClassName("selectedRow")){
				$("mortgageeListingDiv").update("");
				checkTableIfEmpty("rowMortgagee", "mortgageeInformationDiv");
				checkIfToResizeTable("mortgageeListingDiv", "rowMortgagee");
				$("selectedQuoteId").value = '';
				resetFields();
				Effect.Fade("mortgageeInformationDiv", {
					duration: .001
				});
			} else {
				var quoteId = row.down("input", 0).value;
				resetMortgagee();
				loadMortgageeByQuotatation(quoteId);
				$("selectedQuoteId").value = quoteId;
				resetFields();
				Effect.Appear("mortgageeInformationDiv", {
					duration: .001
				});
			} 
		});
	});

	//$("mortgSave").observe("click", savePackQuotationMortgagee);

	function filterMortgagee(){
		try{
			var mortgCds = new Array();
			$$("div[name='rowMortgagee']").each(
				function(row){
					mortgCds.push(row.getAttribute("mortgCd"));
			});
			var mortgOption = $("mortgOption").options;		
			for (var i=0; i<mortgOption.length; i++) {
				for ( var m = 0; m < mortgCds.length; m++) {
					if (mortgCds[m] == mortgOption[i].value) {   
						mortgOption[i].hide();
						mortgOption[i].disabled = true;
					}
				}
			}
			
		}catch(e){
			showErrorMessage("filterMortgagee", e);
		}	
	}

	function resetMortgagee(){
		var mortgOption = $("mortgOption").options;		
		for (var i=0; i<mortgOption.length; i++) {
				if (mortgOption[i].disabled) {   
					mortgOption[i].show();
					mortgOption[i].disabled = false;
			}
		}
	}
	$("btnAddMortgagee").observe("click", function ()	{
		addQuotationMortgagee();
	});

	function addQuotationMortgagee(){
		try{
			if (validateMortgagee()) {
				
				var mortgCd = $F("mortgOption").replace(/ /g, " ");
				var mortgName = $("mortgOption").options[$("mortgOption").selectedIndex].text;
				var replacedMortgName =  mortgName.replace(/\s+/g, "_");
				var amount = $F("amount").replace(/,/g, "");
				var remarks = $F("remarksMortgagee") == '' ? '' : changeSingleAndDoubleQuotes2($F("remarksMortgagee"));
				var quoteId = $F("selectedQuoteId");
				var finalAmount;
				if(amount == null || amount == ''){
					finalAmount = '--';
				}else{
					finalAmount = formatCurrency(amount);
				}
				
				if($F("btnAddMortgagee") == "Add"){
					// adds to the main json obj
					var objMortgagee = new Object();
					objMortgagee.quoteId = 
					objMortgagee.quoteId= quoteId;
					objMortgagee.mortgCd= mortgCd;
					objMortgagee.mortgName= mortgName;
					objMortgagee.amount= amount;
					objMortgagee.remarks= escapeHTML2(remarks);
					objMortgagee.recordStatus = 0;
					objPackQuoteMortgagee.push(objMortgagee);
					
					
					var newDiv 	= new Element("div");
					newDiv.setAttribute("id", "mortgagee"+quoteId+'_'+mortgCd);
					newDiv.setAttribute("name", "rowMortgagee");
					newDiv.setAttribute("quoteId", quoteId);
					newDiv.setAttribute("mortgCd", mortgCd);
					//newDiv.setAttribute("mortgName", mortgName);
					newDiv.setAttribute("amount", amount);
					newDiv.setAttribute("remarks", remarks);
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display: none;");

					var content ='<label style="width: 50%; padding-left: 20px;">'+mortgName+'</label>'+
									'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">'+finalAmount+'</label>'+
									'<label style="width: 20%; text-align: center;">0</label>';
					newDiv.update(content);
					$("mortgageeListingDiv").insert({bottom: newDiv});
					
					Effect.Appear("mortgagee"+quoteId+'_'+mortgCd, {
						duration: .2,
						afterFinish: function () {
							checkTableIfEmpty("rowMortgagee", "mortgageeInformationDiv");
							checkIfToResizeTable("mortgageeListingDiv", "rowMortgagee");
						}
					});

					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});

					newDiv.observe("click", function(){
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow")){
							$$("div[name='rowMortgagee']").each(function (r)	{
								if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
									r.removeClassName("selectedRow");
								}
							});
							displayMortgageeDetails(newDiv,true);
						} else {
							
							displayMortgageeDetails(newDiv,false);
						} 
					});

				}else{//update
					var origMortgCd = $F("selectedMortgCd").replace(/ /g, " ");
					var oldMortgCd;
					//updates the div and display
					var divId = quoteId+'_'+origMortgCd;
					var mortgDiv = $("mortgagee"+divId);
					oldMortgCd = mortgDiv.getAttribute("oldMortgCd"); 
					mortgDiv.setAttribute("mortgCd", mortgCd);
					mortgDiv.setAttribute("amount", amount);
					mortgDiv.setAttribute("remarks", remarks);

					$("mortgName"+divId).innerHTML = unescapeHTML2(mortgName);
					$("lblMoney"+divId).innerHTML = unescapeHTML2(finalAmount);
					mortgDiv.removeClassName("selectedRow");
					mortgDiv.setAttribute("id","mortgagee"+quoteId+'_'+mortgCd);// finally change the div's name
					$("mortgName"+divId).setAttribute("id", "mortgName"+quoteId+'_'+mortgCd);
					$("lblMoney"+divId).setAttribute("id", "lblMoney"+quoteId+'_'+mortgCd);
					//mortgDiv.down("label",0).innerHTML = unescapeHTML2(mortgName);
					//mortgDiv.down("label",1).innerHTML = finalAmount;
					
					//updates the main json obj
					for ( var i = 0; i < objPackQuoteMortgagee.length; i++) {
						
						if (objPackQuoteMortgagee[i].quoteId == quoteId && objPackQuoteMortgagee[i].mortgCd == oldMortgCd ) {
							objPackQuoteMortgagee[i].newMortgCd = mortgCd;
							objPackQuoteMortgagee[i].amount = amount;
							objPackQuoteMortgagee[i].remarks = escapeHTML2(remarks);
							objPackQuoteMortgagee[i].recordStatus = objPackQuoteMortgagee[i].recordStatus == 0 ? 0 :1;
							if (objPackQuoteMortgagee[i].recordStatus == 1) {
								objPackQuoteMortgagee[i].oldMortgCd = oldMortgCd;
							}
						}
					}
				}

				resetFields();
				filterMortgagee();
				changeTag = 1;
				$("mortgChanges").value = "Y";
				// check if the updatated mortgCd is equal to the original mortgCd
				if(origMortgCd != mortgCd){
					var mortgOption = $("mortgOption").options;		
					for (var i=0; i<mortgOption.length; i++) {
						if (origMortgCd == mortgOption[i].value) {   
							mortgOption[i].show();
							mortgOption[i].disabled = false;
						}
					}
				}
				
			}
			
		}catch(e){
			showErrorMessage("addQuotationMortgagee", e);
		}
	}

	function validateMortgagee(){
		var bool = true;
		if ($F("mortgOption") == "")	{
			showMessageBox("Mortgagee Name is required.", imgMessage.ERROR);
			willProceed = false;
			bool =  false;
		}else if(isNaN($F("amount").replace(/,/g, ""))){
			showMessageBox("Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
			willProceed = false;
			bool = false;
		}
		return bool;
	}
	
	function loadMortgageeByQuotatation(quoteId){
		try{
			$("mortgageeListingDiv").update("");
			for ( var i = 0; i < objPackQuoteMortgagee.length; i++) {
				if (objPackQuoteMortgagee[i].quoteId == quoteId) {
					var newDiv 			= new Element("div");
					var mortgName = objPackQuoteMortgagee[i].mortgName;
					var replacedMortgName =  objPackQuoteMortgagee[i].mortgName.replace(/\s+/g, "_");
					var mortgCd = unescapeHTML2(objPackQuoteMortgagee[i].mortgCd.replace(/\s+/g, "_")); 
					var amount = objPackQuoteMortgagee[i].amount;
					var remarks = changeSingleAndDoubleQuotes2(nvl(objPackQuoteMortgagee[i].remarks, ""));
					
					var amount = objPackQuoteMortgagee[i].amount;
					var quoteId = objPackQuoteMortgagee[i].quoteId;
					var finalAmount;
					if(amount == null || amount == ''){
						finalAmount = '--';
					}else{
						finalAmount = formatCurrency(amount);
					}
					
					newDiv.setAttribute("id", "mortgagee"+quoteId+'_'+mortgCd);
					newDiv.setAttribute("name", "rowMortgagee");
					newDiv.setAttribute("quoteId", quoteId);
					newDiv.setAttribute("mortgCd", mortgCd);
					//newDiv.setAttribute("mortgName", mortgName);
					newDiv.setAttribute("amount", amount);
					newDiv.setAttribute("remarks", remarks);
					newDiv.setAttribute("oldMortgCd", mortgCd);
					newDiv.setAttribute("oldRecordIndex",i);
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display: none;");
					var content ='<label style="width: 50%; padding-left: 20px;" id="mortgName'+quoteId+'_'+mortgCd+'">'+mortgName+'</label>'+
								'<label style="width: 20%; text-align: right;" class="money" id="lblMoney'+quoteId+'_'+mortgCd+'" name="lblMoney">'+finalAmount+'</label>'+
								'<label style="width: 20%; text-align: center;">0</label>';
					newDiv.update(content);
					$("mortgageeListingDiv").insert({bottom: newDiv});
					
					Effect.Appear("mortgagee"+quoteId+'_'+mortgCd, {
						duration: .2,
						afterFinish: function () {
							//checkTableIfEmpty("rowMortgagee", "mortgageeInformationDiv");
							checkIfToResizeTable("mortgageeListingDiv", "rowMortgagee");
						}
					});
				}
			}

			$$("div[name='rowMortgagee']").each(function (r){
				r.observe("click", function(){
					if (r.hasClassName("selectedRow")){
						displayMortgageeDetails(r,false);
					} else {
						displayMortgageeDetails(r,true);
					} 
				});
			});
			initializeTable("tableContainer", "rowMortgagee", "", "");
			
			Effect.Appear("addMortgageeDiv", {
				duration: .2
			});
			filterMortgagee();
			}catch(e){
				showErrorMessage("loadMortgageeByQuotatation", e);
			}	
	}

	function displayMortgageeDetails(row,selected){
		if(selected){
			//
			//$("amountText").value = row.getAttribute("amount") == "" ? '---' : formatCurrency(row.getAttribute("amount"));
			$("remarksMortgagee").value = unescapeHTML2(row.getAttribute("remarks"));
			//$("amountText").show();
			$("amount").value =  formatCurrency(row.getAttribute("amount"));
			$("btnAddMortgagee").value = "Update";
			var mn = $("mortgOption");
			var index = 0;
			for (var i=0; i<mn.length; i++)	{
				if ( (mn.options[i].value) == row.getAttribute("mortgCd"))	{
					index = i;
				}
			}
			mn.selectedIndex = index;
			filterMortgagee();
			$("selectedMortgCd").value =  row.getAttribute("mortgCd");
		}else{
			resetFields();
		}
	}
	function resetFields(){
		$("remarksMortgagee").value = '';
		$("btnAddMortgagee").value = "Add";
		$("mortgOption").value = "";
		$("selectedMortgCd").value == "";
		$("amount").value = "";
	};
	
	function loadPackQuotations(){
		try{
			for ( var i = 0; i < objGIPIPackQuotations.length; i++) {
				var quoteId = objGIPIPackQuotations[i].quoteId;
				var newDiv 			= new Element("div");
				var lineCd = objGIPIPackQuotations[i].lineCd;
				var sublineCd = objGIPIPackQuotations[i].sublineCd;
				var issCd = objGIPIPackQuotations[i].issCd;
				var quotationYy = objGIPIPackQuotations[i].quotationYy;
				var quotationNo = objGIPIPackQuotations[i].quotationNo;
				var proposalNo = objGIPIPackQuotations[i].proposalNo;
				var quoteNo = lineCd+'-'+sublineCd+'-'+issCd+'-'+quotationYy+'-'+formatNumberDigits(quotationNo,6)+'-'+formatNumberDigits(proposalNo,3);
				newDiv.setAttribute("id", "packQuotation"+quoteId);
				newDiv.setAttribute("name", "rowPackQuotation");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var content = '<input type="hidden" id="quoteId" value="'+quoteId+'"/>'
							+ '<label style="width: 50%; padding-left: 40%;">'+quoteNo+'</label>';
				newDiv.update(content);
				$("packQuotationListing").insert({bottom: newDiv});
				Effect.Appear("packQuotation"+quoteId, {
					duration: .2,
					afterFinish: function () {
						//checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
						checkIfToResizeTable("packQuotationListing", "rowPackQuotation");
					}
				});
				

				
			}
		}catch(e){
			showErrorMessage("loadPackQuotations", e);
		}	
	}

	$("editMortgageeRemarks").observe("click", function () {
		showEditor("remarksMortgagee", 4000);
	});
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	initializeTable("tableContainer", "rowPackQuotation", "", "");
</script>