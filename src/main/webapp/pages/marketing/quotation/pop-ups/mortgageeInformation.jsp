<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="mortgageeInformationSectionDiv" name="mortgageeInformationSectionDiv" style="">
	<div id="spinLoadingDiv"></div>
	<div id="contentsDiv">
		<form id="mortgageeForm" name="mortgageeForm">
			<input id="quoteId" name="quoteId" type="hidden" value="${gipiQuote.quoteId}" />
			<input id="mortgItemNo" name="mortgItemNo" type="hidden" value="${mortgItemNo}" />
			<div class="sectionDiv" id="mortgInfoDiv">
				<div class="tableContainer" id="mortgageeInformationDiv" name="mortgageeInformationDiv" align="center" style="margin: 10px;">
					<span id="noticePopup" name="noticePopup" style="display: none;" class="notice">Saving, please wait...</span>
					<div class="tableHeader">
						<label style="width: 50%; padding-left: 20px;">Mortgagee Name</label>
						<label style="width: 20%; text-align: right;">Amount</label>
						<label style="width: 20%; text-align: center;">Item No.</label>
					</div>
					<div id="mortgageeListingDiv" name="mortgageeListingDiv" class="tableContainer">
						<c:forEach var="mortgagee" items="${mortgagees}">
							<div id="row${mortgagee.itemNo}${mortgagee.mortgCd}" name="rowMortg" class="tableRow">
								<input type="hidden" name="mortgageeCodes" 			value="${mortgagee.mortgCd}"/>
								<input type="hidden" name="mortgageeAmounts" 			value="${mortgagee.amount}" />
								<input type="hidden" name="mortgageeItemNos" 	value="${mortgagee.itemNo}" />
								<label style="width: 50%; padding-left: 20px;">${mortgagee.mortgName}</label>
								<label style="width: 20%; text-align: right;" class="money" name="lblMoney">${mortgagee.amount}</label>
								<label style="width: 20%; text-align: center;">${mortgagee.itemNo}</label>
							</div>
						</c:forEach>
					</div>
					<div style="display: none;">
						<div id="mortgageesForDbUpdate" name="mortgageesForDbUpdate"></div>
					</div>
				</div>
			
				<table align="center" id="addMortgageeForm" style="margin-top:10px; margin-bottom:10px;" >
					<tr>
						<td class="rightAligned">Mortgagee Name </td>
						<td style="padding-left: 10px;">
							<input type="text" id="txtMortgagee" name="txtMortgagee" class="required" readonly="readonoly" style="width: 272px; display: none;" /><br/>
							<select id="mortgageeName" name="mortgageeName" style="width: 280px;" class="required">
								<option value=""></option>
								<c:forEach var="mortgageeListing" items="${mortgageeListing}">
									<option value="${mortgageeListing.mortgCd}">${mortgageeListing.mortgName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Amount </td>
						<td style="padding-left: 10px;" align="left">
							<!-- <input id="amount" name="amount" type="text" class="money required" maxlength="17" style="width: 272px;"/> -->
							<input id="amount" name="amount" type="text" class="money2" maxlength="17" style="width: 272px;" min="0.00" max="99999999999999.99" errorMsg="Invalid Mortgagee amount. Value should be from 0.00 to 99,999,999,999,999.99" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Item No. </td>
						<td style="padding-left: 10px;" align="left">
							<input id="newMortgageeItemNo" name="newMortgageeItemNo" type="text" readonly="readonly" />						
						</td>
					</tr>
					<tr>
						<td></td>
						<td style="padding-left: 10px; text-align: left;">
							<input id="btnAddMortgagee" name="btnAddMortgagee" class="button" type="button" value="Add" style="width: 68px;" />
							<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" class="disabledButton" type="button" value="Delete" style="width: 68px;" /></td>								
					</tr>
				</table>
			</div>
		</form>
	</div>
</div>
<!--<input type="hidden" id="saveMortTag gipiQuote.quoteId}" name="saveMortTag" value="N"/>-->

<script type="text/javascript">
	if (isMakeQuotationInformationFormsHidden == 1) {
		$("addMortgageeForm").hide();
		$("mortageeInformationButtons2").hide();
	}

	$$("div[name='rowMortg']").each(
		function (row)	{						
			loadRowMouseOverMouseOutObserver(row);
			
			row.observe("click", function(){
				row.toggleClassName("selectedRecord");
				if(row.hasClassName("selectedRecord")){
					($$("div#mortgageeInformationDiv div:not([id=" + row.id + "])")).invoke("removeClassName", "selectedRow");
					setMortgageeForm(row);
				}else{
					setMortgageeForm(null);
				}
			});
			/*	commented by mark jm 04.08.2011 @UCPBGen
			//	see above code
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){						
					$$("div[name='rowMortg']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});					
					
					var mn = $("mortgageeName");
					var ctr = 0;
					var mcd;
					var amt;
					var itm;
						
					row.childElements().each(function(child){
						if(ctr==0){	mcd = child.value;	}
						if(ctr==1){	amt = child.value;	}
						if(ctr==2){	itm = child.value;	}
						ctr++;
					});						
					
					mcd = row.down("input", 0).value;
					amt = row.down("input", 1).value;
					itm = row.down("input", 2).value;
					
					var index = 0;
					for (var i=0; i<mn.length; i++)	{
						if ( (mn.options[i].value) == mcd)	{	//(row.down("input", 0).value)
							index = i;
						}
					}
					
					$("mortgageeName").selectedIndex = index;						
					$("txtMortgagee").value = $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
					$("amount").value = formatCurrency(amt);	//row.down("input", 1).value
					$("newMortgageeItemNo").value = itm;	//row.down("input", 2).value
					
					// mark jm 04.07.2011 @UCPBGen
					// hide the select and show the text field						
					$("mortgageeName").hide();
					$("txtMortgagee").show();
					
					enableButton("btnDeleteMortgagee");
					$("btnAddMortgagee").value = "Update";
					
					setMortgageeForm(row);
				} else{
					resetMortgageeForm();					
				}
			});
			*/
		}
	);
	
	/* 	commented by mark jm 04.08.2011 @UCPBGen 
	//	used class money2 instead oh having onBlur observer
	$("amount").observe("blur", function(){
		var amount = $F("amount").replace(/,/g, "");
		var amt = amount.split(".");
		var willProceed = true;
		amt[1] = amt[1] == null ? "00" : amt[1]; 
		if (amt[1].length >= 3){
			showMessageBox("Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99.",imgMessage.ERROR);
			willProceed = false;
			return false;
		}else{		
			validateCurrency("amount", "Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99", "NOTpopup", 0.01, 99999999999999.99);
		}
	});
	*/
	
	/*	Created by 	: mark jm 04.08.2011 @UCPBGen
	*	Description	: add/update records to mortgagee
	*/
	function addMortgagee(){
		try{			
			var obj = setMortgageeObj();
			var content = prepareMortgageeDisplay(obj);
			
			if($F("btnAddMortgagee") == "Update"){
				prepareMortgagees("Update");
				$("row" + obj.itemNo.concat(obj.mortgCd)).update(content);
				$("row" + obj.itemNo.concat(obj.mortgCd)).removeClassName("selectedRow");
			}else{
				prepareMortgagees("Add");
				var tableListing 	= $("mortgageeListingDiv");
				var newDiv			= new Element("div");
				
				newDiv.setAttribute("id", "row" + obj.itemNo.concat(obj.mortgCd));
				newDiv.setAttribute("name", "rowMortg");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				
				newDiv.update(content);
				
				tableListing.insert({bottom : newDiv});
				
				loadRowMouseOverMouseOutObserver(newDiv);
				
				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if(newDiv.hasClassName("selectedRow")){					
						($$("div#mortgageeInformationDiv div:not([id=" + newDiv.id + "])")).invoke("removeClassName", "selectedRow");					
						setMortgageeForm(newDiv);
					}else{					
						setMortgageeForm(null);
					}
				});
				
				Effect.Appear(newDiv, {
					duration: .2,
					afterFinish: function (){					
						checkTableIfEmpty("rowMortg", "mortgageeInformationDiv");
						checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
					}
				});
			}
			
			setMortgageeForm(null);
		}catch(e){
			showErrorMessage("addMortgagee", e);
		}		
	}
	
	$("btnAddMortgagee").observe("click", function(){
		var mortgCd = $F("mortgageeName");
		var amount = $F("amount").replace(/,/g, "");
		/*	commented by mark jm 04.08.2011 @UCPBGen
		//	not sure if this code is needed since we hide the select and show the text field
		$$("div[name='rowMortg']").each(function (d)	{
			if("row"+itemNo+mortgCd == d.getAttribute("id") && $F("btnAddMortgagee") != "Update")	{
				showMessageBox("Mortgagee already exists!", imgMessage.ERROR);				
				return false;
			}
		});
		*/
		if (mortgCd == "")	{
			showMessageBox("Mortgagee Name is required.", imgMessage.ERROR);			
			return false;
		}//dependent
		
		if(amount == "0.00"  || isNaN(amount) || amount == ""){
			showMessageBox("Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);			
			return false;
		}
		
		addMortgagee();
	});
	
	/*	commented by mark jm 04.08.2011 @UCPBGen
	//	create another observer. see code above
	$("btnAddMortgagee").observe("click", function ()	{
		try {			
			var mortgCd = $F("mortgageeName");
			var mortgName = $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
			var amount = $F("amount").replace(/,/g, "");
			var itemNo = $F("itemNo");
			var exists = false;
			var willProceed = true;
			$$("div[name='rowMortg']").each(function (d)	{
				if("row"+itemNo+mortgCd == d.getAttribute("id") && $F("btnAddMortgagee") != "Update")	{
					showMessageBox("Mortgagee already exists!", imgMessage.ERROR);
					exists = true;
					willProceed = false;
					return false;
				}
			});
	
			if (mortgCd == "")	{
				showMessageBox("Mortgagee Name is required.", imgMessage.ERROR);
				willProceed = false;
				return false;
			}//dependent
	
	        if(amount == "0.00"  || isNaN(amount) || amount == ""){
				showMessageBox("Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				willProceed = false;
				return false;
			}
	
			if(willProceed){	
				$("noticePopup").hide();
				hideNotice();
				var mid = $("mortgageeListingDiv");
				if ($F("btnAddMortgagee") == "Update")	{
					prepareMortgagees("Update");
					
					var selectedRow = getSelectedRowId_noSubstring("rowMortg");
					$(selectedRow).update(
							'<input type="hidden" name="mortgageeCodes" value="'+mortgCd+'" />'+
							'<input type="hidden" name="mortgageeAmounts" value="'+amount +'" />'+
							'<input type="hidden" name="mortgageeItemNos" value="'+itemNo +'" />'+
							'<label style="width: 50%; padding-left: 20px;">' + mortgName + '</label>'+
							'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">' + formatCurrency(amount) + '</label>'+
							'<label style="width: 20%; text-align: center;">' + itemNo + '</label>');
				} else {
					prepareMortgagees("Add");
					if (!exists)
					var newDiv = new Element("div");		
					newDiv.setAttribute("id", "row"+itemNo+mortgCd);
					newDiv.setAttribute("name", "rowMortg");
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display: none;");
					newDiv.update('<input type="hidden" name="mortgageeCodes" 	value="'+mortgCd+'" />'+
							'<input type="hidden" name="mortgageeAmounts" 			value="'+amount +'" />'+
							'<input type="hidden" name="mortgageeItemNos" 	value="'+itemNo +'" />'+
							'<label style="width: 50%; padding-left: 20px;">'+mortgName+'</label>'+
							'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">'+formatCurrency(amount)+'</label>'+
							'<label style="width: 20%; text-align: center;">'+itemNo+'</label>');
					mid.insert({bottom: newDiv});
			
					loadRowMouseOverMouseOutObserver(newDiv);
			
					newDiv.observe("click", function ()	{
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{							
							$$("div[name='rowMortg']").each(function (r)	{
								if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
									r.removeClassName("selectedRow");
								}
							});							
							
							var xmortcd = "";
							var xmortamts = "";
							var xmortitemno = "";
							
							
							newDiv.childElements().each(function(aChild){
								if(aChild.name == "mortgageeCodes"){					
									xmortcd 	= aChild.value;
								}else if(aChild.name == "mortgageeItemNos"){	
									xmortitemno = aChild.value;
								}else if(aChild.name == "mortgageeAmounts"){				
									xmortamts 	= aChild.value;
								}
							});							
							
							var tempMortCd 		= 0;
							var tempMortAmt 	= 0;
							var tempMortItemNo 	= 0;
							
							var mn = $("mortgageeName");
							var i  = 0, index = 0;
							$("mortgageeName").childElements().each(function(options){
								if(options.value == xmortcd){
									index = i;
									$continue;
								}
								i++;
							});
						
							$("mortgageeName").selectedIndex	= index;
							$("txtMortgagee").value				= $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
							$("amount").value 					= formatCurrency(xmortamts);
							$("newMortgageeItemNo").value 		= xmortitemno;
							
							// mark jm 04.07.2011 @UCPBGen
							// hide the select and show the text field							
							$("mortgageeName").hide();
							$("txtMortgagee").show();
							
							enableButton("btnDeleteMortgagee");
							$("btnAddMortgagee").value = "Update";
							
							setMortgageeForm(newDiv);
						}	else	{
							resetMortgageeForm();							
						}
					});
			
					Effect.Appear(newDiv, {
						duration: .2,
						afterFinish: function ()	{
							resetMortgageeForm();
							checkTableIfEmpty("rowMortg", "mortgageeInformationDiv");
							checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
						}
					});
					resetMortgageeForm();
				}
			}
			
			hideSelectedMortgagees();
		} catch (e) {
			showErrorMessage("mortgageeInformation.jsp - btnAddMortgagee", e);
		}
	});
	*/
	function resetMortgageeForm(){
		disableButton("btnDeleteMortgagee");

		$("newMortgageeItemNo").value = $F("itemNo");
		$("mortgageeName").selectedIndex = 0;
		$("amount").value = "";//formatCurrency("0.00"); leave blank accdg to QA
		$("btnAddMortgagee").value = "Add";
		$("noticePopup").hide();
	}
	
	/*	Created by 	: mark jm 04.08.2011 @UCPBGen
	*	Description	: create an object thatt will contain the details of a mortgagee
	*/
	function setMortgageeObj(){
		try{
			var newObj = new Object();
			
			newObj.mortgCd 		= $F("mortgageeName");
			newObj.mortgName 	= $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
			newObj.amount		= $F("amount").replace(/,/g, "");
			newObj.itemNo 		= $F("itemNo");
			
			return newObj;
		}catch(e){
			showErrorMessage("setMortgageeObj", e);
		}		
	}
	
	/*	Created by 	: mark jm 04.08.2011 @UCPBGen
	*	Description	: create the content of the div
	*	Parameters	: obj - data-holder
	*/
	function prepareMortgageeDisplay(obj){
		try{
			var itemNo 		= (obj == null ? "---" : obj.itemNo);
			var mortgCd		= (obj == null ? null : obj.mortgCd);
			var mortgName 	= (obj == null ? "---" : (obj.mortgName));
			var amount 		= (obj == null ? "---" : (obj.amount == null) ? "" : formatCurrency(obj.amount));
			
			var content =
				'<input type="hidden" name="mortgageeCodes" 	value="' + mortgCd + '" />' +
				'<input type="hidden" name="mortgageeAmounts"	value="' + amount + '" />' +
				'<input type="hidden" name="mortgageeItemNos" 	value="' + itemNo + '" />' +
				'<label style="width: 50%; padding-left: 20px;">' + mortgName + '</label>' +
				'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">' + formatCurrency(amount) + '</label>' +
				'<label style="width: 20%; text-align: center;">' + itemNo + '</label>';
			
			return content;
		}catch(e){
			showErrorMessage("prepareMortgageeDisplay", e);
		}		
	}
	
	/*	Created by 	: mark jm 04.08.2011 @UCPBGen
	*	Description	: set the mortgagee form based on the parameter
	*	Parameters	: row - the selected record
	*/
	function setMortgageeForm(row){
		try{			
			$("newMortgageeItemNo").value		= row == null ? $F("itemNo") : row.down("input", 2).value;
			$("mortgageeName").selectedIndex	= row == null ? 0 : getIndexInSelectListByValue("mortgageeName", row.down("input", 0).value);
			$("amount").value					= row == null ? "" : formatCurrency(row.down("input", 1).value);
			$("btnAddMortgagee").value			= row == null ? "Add" : "Update";
			$("txtMortgagee").value				= row == null ? "" : $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
			
			if(row == null){
				disableButton("btnDeleteMortgagee");
				$("txtMortgagee").hide();
				$("mortgageeName").show();
			}else{
				enableButton("btnDeleteMortgagee");
				$("txtMortgagee").show();
				$("mortgageeName").hide();
			}			
		}catch(e){
			showErrorMessage("setMortgageeForm", e);
		}	
	}

	$("btnDeleteMortgagee").observe("click", function ()	{
		prepareMortgagees("Delete");
		$$("div[name='rowMortg']").each(function (d)	{
			if (d.hasClassName("selectedRow"))	{
				Effect.Fade(d, {
					duration: .5,
					afterFinish: function () {  
						unhideDeletedMortgagees(d);
						d.remove();
						resetMortgageeForm();
						checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
						checkTableIfEmpty("rowMortg", "mortgageeInformationDiv");
					}	
				});
			}
		});
	});

	// hides the already selected Mortgagees from the options to 
	//		prevent the user from selecting it again
	function hideSelectedMortgagees(){
		var mortgageeOptions = $("mortgageeName").options;				
		$$("div[name='rowMortg']").pluck("id").findAll(function (a) {
			for (var i=0; i<mortgageeOptions.length; i++) {
				if (a.substring(4) == mortgageeOptions[i].value) {   
					mortgageeOptions[i].hide();
				}
			}
		});
	}

	/**
	* Shows the Mortgagees that have been deleted from the user's choices 
	*	  and sends them back to the available options 
	* @author rencela
	*/	
	function unhideDeletedMortgagees(row){
		var indexToBeShown = row.id.substring(4);
		row.childElements().findAll(function(a){
			var mortgageeOptions = $("mortgageeName").options;
			for(var i = 0; i < mortgageeOptions.length; i++){
				if(mortgageeOptions[i].value == indexToBeShown){
					mortgageeOptions[i].show();
				}
			}
		});
	}

	function prepareMortgagees(mortgageeCaller){
		var itemNo = $F("itemNo");
		var mortgageeDesc = $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
		var mortgageeCode = $F("mortgageeName");
		var mortgageeAmount	= $F("amount").replace(/,/g, "");
		var selectedItemNo = $F("itemNo");
		var dbUpdateDiv	= $("mortgageesForDbUpdate");
		var rowPostfix = getSelectedMortgageeRow();
		
		if(mortgageeCaller == "Add"){				
			var tempID = "mortDbUpdateRow" + selectedItemNo + "" +mortgageeCode;
			var tempPostFix = selectedItemNo + "" +mortgageeCode;
			
			if($(tempID) != null && $(tempID) != undefined ){
				updateMortgageeDbUpdate(tempPostFix, tempPostFix, mortgageeCode, mortgageeAmount, selectedItemNo, "insert");
			}else{
				createMortgageeDbUpdate(selectedItemNo + "" +mortgageeCode, mortgageeCode, mortgageeAmount, selectedItemNo, "insert");
			}
		}else if(mortgageeCaller == "Update"){		
			if($("mortDbUpdateRow" + rowPostfix) != null){ 	// DERIVED FROM DB
				updateMortgageeDbUpdate(rowPostfix, mortgageeCode + selectedItemNo, mortgageeCode, mortgageeAmount, selectedItemNo, "insert");
			}else{
				// variables in selected row
				var oldMortgCode, oldMortgValue, oldMortgItemNo;
				// variables in the Form
				var selectedMortgageeCode	= $F("mortgageeName");
				var selectedItemNo			= $F("newMortgageeItemNo");
				var rowId = selectedItemNo + "" + selectedMortgageeCode;
				
				$$("div[name='rowMortg']").each(function(aRow){		// get values from selected row
					if(aRow.hasClassName("selectedRow")){
						oldMortgCode    = aRow.down("input",0).value;
						oldMortgValue   = aRow.down("input",1).value;
						oldMortgItemNo  = aRow.down("input",2).value;
						itemThenCode = oldMortgItemNo + "" + oldMortgCode;
						$continue;
					}
				});

				if(oldMortgCode == selectedMortgageeCode && oldMortgItemNo == selectedItemNo){ 	// WHEN NO CHANGE IN MORTGAGEE CODE
					createMortgageeDbUpdate(selectedItemNo+""+mortgageeCode, mortgageeCode, mortgageeAmount, selectedItemNo, "insert");
				}else{																			// WHEN MORTGAGEE CODE HAS BEEN CHANGED
					var oldPostFix = "" + oldMortgItemNo + oldMortgCode;						// create new DELETE ROW for the existing

					if($("mortDbUpdateRow" + oldMortgItemNo+oldMortgCode) != null && 
							$("mortDbUpdateRow" + oldMortgItemNo+oldMortgCode) != undefined ){ // IF A DELETE MORTGAGEE ALREADY EXISTS
						deleteMortgageeDbUpdate(oldPostFix);
					}else{
						createMortgageeDbUpdate(oldPostFix, oldMortgCode, oldMortgValue, oldMortgItemNo, "delete");
					} 

					// CREATE NEW ADD ROW
					createMortgageeDbUpdate(rowPostfix, mortgageeCode, mortgageeAmount, selectedItemNo, "insert");
				}
			}
		}else if(mortgageeCaller == "Delete"){
			if($("mortDbUpdateRow" + rowPostfix) != null && $("mortDbUpdateRow" + rowPostfix) != undefined ){
				deleteMortgageeDbUpdate(rowPostfix);
			}else{
				createMortgageeDbUpdate(rowPostfix, mortgageeCode, mortgageeAmount, selectedItemNo, "delete");
			}
		}
	}

	function createMortgageeDbUpdate(rowIdPostFix, mortgageeCd, mortgageeAmount, mortgageeItemNo, action){
		var newDiv = new Element("div");
		newDiv.setAttribute("id", "mortDbUpdateRow"+rowIdPostFix);
		newDiv.setAttribute("name", "aMortgageeRow");
		newDiv.setStyle("display: none;");
		newDiv.update(
				'<input id="dbMortgageeCodes'		+ rowIdPostFix + '" type="hidden" name="dbMortgageeCodes" 	    value="'+mortgageeCd+'"  />'+
				'<input id="dbMortgageeAmounts'     + rowIdPostFix + '" type="hidden" name="dbMortgageeAmounts" 	value="'+mortgageeAmount+'"/>'+
				'<input id="dbMortgageeItemNumbers' + rowIdPostFix + '" type="hidden" name="dbMortgageeItemNumbers" value="'+mortgageeItemNo+'" />'+
				'<input id="dbMortgageeAction' 		+ rowIdPostFix + '" type="hidden" name="dbMortgageeAction" 	    value="'+action+'" />');
		$("mortgageesForDbUpdate").insert({bottom: newDiv});
	}

	function updateMortgageeDbUpdate(oldRowIdPostFix, newRowIdPostFix, mortgageeCd, mortgageeAmount, mortgageeItemNo, action){
		var rowToBeEdited = $("mortDbUpdateRow" + oldRowIdPostFix);
		rowToBeEdited.setAttribute("name", "aMortgageeRow");
		rowToBeEdited.setStyle("display: none;");
		rowToBeEdited.update(
				'<input id="dbMortgageeCodes'		+ newRowIdPostFix + '" type="hidden" name="dbMortgageeCodes" 	    value="'+mortgageeCd+'"  />'+
				'<input id="dbMortgageeAmounts'     + newRowIdPostFix + '" type="hidden" name="dbMortgageeAmounts" 		value="'+mortgageeAmount+'"/>'+
				'<input id="dbMortgageeItemNumbers' + newRowIdPostFix + '" type="hidden" name="dbMortgageeItemNumbers"  value="'+mortgageeItemNo+'" />'+
				'<input id="dbMortgageeAction' 		+ newRowIdPostFix + '" type="hidden" name="dbMortgageeAction" 	    value="'+action+'" />');
		rowToBeEdited.setAttribute("id", "mortDbUpdateRow"+newRowIdPostFix);
	}
	
	function deleteMortgageeDbUpdate(rowIdPostFix){
		$("mortDbUpdateRow" + rowIdPostFix).remove();
	}
	
	
	/**
	* This method retrieves the postfix id's of the rows displayed(visible) in screen
	*/
	function getSelectedMortgageeRow(){
		var itemThenCode = " ";
		$$("div[name='rowMortg']").each(function(aRow){
			if(aRow.hasClassName("selectedRow")){
				var mCode  	= aRow.down("input",0).value;
				var mValue  = aRow.down("input",1).value;
				var itemNo 	= aRow.down("input",2).value;
				
				itemThenCode = itemNo + "" + mCode;
				$continue;
			}
		});
		return itemThenCode;
	}

	// unused
	function findSelectedMortgageeRowId(){
		var selectedMortgageeDesc   = $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
		var selectedMortgageeCode	= $F("mortgageeName"); 
		var selectedItemNo			= $F("newMortgageeItemNo");
		var rowId = selectedItemNo + "" + selectedMortgageeCode;
		return rowId;
	}

	hideSelectedMortgagees();
	checkTableIfEmpty("rowMortg", "mortgageeInformationDiv");
	checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
	resetMortgageeForm();
	initializeAll();
	initializeAllMoneyFields();
</script>