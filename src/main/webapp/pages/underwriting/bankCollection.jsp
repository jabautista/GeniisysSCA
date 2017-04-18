<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="bankCollMainDiv" name="bankCollMainDiv" style="margin-top: 1px; display: none;">
	<form id="bankCollForm" name="bankCollForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Bank Collection</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="bankDiv" name="bankDiv" class="sectionDiv">
			<div id="banksListingDiv" name="banksListingDiv" style="margin: 10px;">
				<div id="searchResultBanks" align="center">
					<div style="width: 100%;" id="banksTable" name="banksTable">
						<div class="tableHeader">
							<label style="width: 5%; text-align: center;">No.</label>
							<label style="width: 20%; text-align: left;">Bank</label>
							<label style="width: 15%; text-align: left;">Address</label>
							<label style="width: 15%; text-align: right;">Cash In Vault</label>
							<label style="width: 15%; text-align: right;">Cash In Transit</label>
							<label style="width: 25%; text-align: left; margin-left: 10px; ">Remarks</label>
						</div>
						<div id="banksDiv" name="banksDiv" class="tableContainer">
							
						</div>
					</div>
					<div id="addBankDiv" name="addBankDiv" style="width: 100%;" >
						<table style="margin-top: 10px; width: 80%;">
							<tr>
								<td class="rightAligned" style="width: 15%;">Bank Item No.</td>
								<td class="leftAligned" style="width: 30%;"><input
									id="bankItemNo" class="leftAligned required" type="text"
									name="bankItemNo" style="width: 50%;" readonly="readonly" /></td>
								<td class="rightAligned" style="width: 20%;">Cash in Vault</td>
								<td class="leftAligned" style="width: 30%;"><input
									id="cashInVault" maxlength="18" type="text" name="cashInVault"
									style="width: 95%; text-align: right;" value="" /></td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 15%;">Bank</td>
								<td class="leftAligned" style="width: 30%;"><input id="bank"
									class="leftAligned required" type="text" maxlength="40" name="bank"
									style="width: 98%;" /></td>
								<td class="rightAligned" style="width: 20%;">Cash in Transit</td>
								<td class="leftAligned" style="width: 30%;"><input
									id="cashInTransit" maxlength="18" type="text" name="cashInTransit"
									style="width: 95%; text-align: right;" value="" /></td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 15%;">Address</td>
								<td class="leftAligned" colspan="3"><input id="address"
									class="leftAligned" type="text" maxlength="60" name="address" style="width: 98%;" />
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 15%;">Remarks</td>
								<td class="leftAligned" colspan="3" style="width: 80%;">
									<div style="border: 1px solid gray; height: 20px; width: 99%;">
										<textarea id="remarks" class="leftAligned" name="remarks" style="width: 95%; border: none; height: 13px;"></textarea>
										<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
									</div>
								</td>
								<!--td class="leftAligned" colspan="3"><textarea id="remarks"
									class="leftAligned" name="remarks"
									style="width: 97.7%; height: 30px;" ></textarea></td-->
							</tr>
							<tr>
								<td colspan="4" align="center"><br />
								<input type="button" id="btnAddBank" name="btnAddBank" class="button" value="Add" style="width: 80px;"/> 
								<input type="button" id="btnDeleteBank" name="btnDeleteBank" class="button" value="Delete" style="width: 80px;"/> 
								</td>
							</tr>
						</table>
					</div>
					<div id="banksForInsert" name="bankForInsert" style="visibility: hidden;">
					
					</div>
					<div id="banksForDelete" name="bankForDelete" style="visibility: hidden;">
					
					</div>
				</div>
			</div>
		</div>
		<div id="buttonsDiv" align="center">
			<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel"  style="margin-top: 5px; width: 100px;"/> 
			<input type="button" id="btnSave" name="btnSave" class="button" value="Save"  style="margin-top: 5px; width: 100px;"/> 
			<!--input type="button" id="btnSurvey" class="button" value="Survey"/-->
			<br/>
			<br/>
			<br/>
			<br/>
		</div>
		<div id="hiddenDetailsDiv" name="hiddenDetailsDiv">
			<input id="selectedBankItemNo" 	name="selectedBankItemNo" 	type="hidden"/>
			<input id="selectedBank" 		name="selectedBank" 		type="hidden"/>
			<input id="selectedCashInVault" name="selectedCashInVault" 	type="hidden"/>
			<input id="selectedCashInTransit" name="selectedCashInTransit" 	type="hidden"/>
			<input id="selectedIncludeTag" 	name="selectedIncludeTag" 	type="hidden"/>
			<input id="selectedBankAddress" name="selectedBankAddress" 	type="hidden"/>
			<input id="selectedRemarks" 	name="selectedRemarks" 		type="hidden"/>
			<input id="includeTag"	name="includeTag"	type="hidden" value="Y"/>
		</div>
	</form>
	
</div>

<script type="text/javaScript">
	changeTag = 0;
	var objBankList = JSON.parse('${bankSched}'.replace(/\\/g, '\\\\'));
	showBankList();

	function showBankList(){
		for (var i = 0; i < objBankList.length; i++){
			var bankItemNo 		= objBankList[i].bankItemNoC;
			var bank 			= changeSingleAndDoubleQuotes2(objBankList[i].bank);
			var cashInVault 	= objBankList[i].cashInVault == null ? "---" : formatCurrency(objBankList[i].cashInVault);
			var cashInTransit 	= objBankList[i].cashInTransit == null ? "---" : formatCurrency(objBankList[i].cashInTransit);
			var address 		= changeSingleAndDoubleQuotes2(nvl(objBankList[i].bankAddress, "---"));
			var includeTag 		= objBankList[i].includeTag;
			var remarks 		= changeSingleAndDoubleQuotes2(nvl(objBankList[i].remarks, "---"));
			var newDiv 			= new Element("div");
			newDiv.setAttribute("id", "row"+bankItemNo);
			newDiv.setAttribute("name", "rowBank");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			
			var content = "<label style='width: 5%; text-align:center;'>"+bankItemNo+"</label>"
				+"<label style='width: 20%; text-align: left;'name='bankText'>"+bank+"</label>"
				+"<label style='width: 15%; text-align: left;'name='remarksText'>"+address+"</label>"
				+"<label style='width: 15%; text-align: right;'class='money'>"+cashInVault+"</label>"
				+"<label style='width: 15%; text-align: right;'class='money'>"+cashInTransit+"</label>"
				+"<label style='width: 25%; text-align: left; margin-left: 12px; 'name='remarksText'>"+remarks+"</label>"
				+"<input id='bankItemNo"+bankItemNo+"'		name='bankItemNo"+bankItemNo+"' 	type='hidden' value='"+bankItemNo+"'/>"
				+"<input id='bank"+bankItemNo+"'			name='bank"+bankItemNo+"'			type='hidden' value='"+bank+"'/>"
				+"<input id='cashInVault"+bankItemNo+"'		name='cashInVault"+bankItemNo+"' 	type='hidden' value='"+cashInVault+"'/>"
				+"<input id='cashInTransit"+bankItemNo+"'	name='cashInTransit"+bankItemNo+"' 	type='hidden' value='"+cashInTransit+"'/>"
				+"<input id='includeTag"+bankItemNo+"'		name='includeTag"+bankItemNo+"' 	type='hidden' value='Y'/>"
				+"<input id='bankAddress"+bankItemNo+"'		name='bankAddress"+bankItemNo+"' 	type='hidden' value='"+address+"'/>"
				+"<input id='remarks"+bankItemNo+"'			name='remarks"+bankItemNo+"' 		type='hidden' value='"+remarks+"'/>"
				+"<input type='hidden' 	id='bankItemNumber'	name='bankItemNumber' 	value='"+bankItemNo+"'/>";
			newDiv.update(content);
			$("banksDiv").insert({bottom: newDiv});
			initializeBankRow(newDiv);
			Effect.Appear("row"+bankItemNo, {
				duration: .2,
				afterFinish: function () {
				//clearAddBankFields();
				checkIfToResizeTable("banksDiv", "rowBank");
				checkTableIfEmpty("rowBank", "banksDiv");
				}
			});
		}
	}

	setModuleId("GIPIS089");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	//initializeAllMoneyFields();
	clearAddBankFields();
	disableButton("btnDeleteBank");
	//initializePARBasicMenu();
	checkIfToResizeTable("banksDiv", "rowBank");
	checkTableIfEmpty("rowBank", "banksDiv");
	trimLabelTexts();

	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});

	$("editRemarks").observe("click", function () {
		//showEditor("remarks", 4000); remove by jdiago 07.17.2014
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly")); // added by jdiago 07.17.2014
	});

	function trimLabelTexts(){
		$$("label[name='bankText']").each(function (label)	{
			if ((label.innerHTML).length > 30)	{
				label.update((label.innerHTML).truncate(30, "..."));
			}
		});
		
		$$("label[name='remarksText']").each(function (label)	{
			if ((label.innerHTML).length > 20)	{
				label.update((label.innerHTML).truncate(20, "..."));
			}
		});
	}
	
	function validateBankBeforeSave(){
		var result = true;
		if ("" == $F("bank")){
			showMessageBox("Bank name must be entered.", "error");
			result = false;
			}
		return result;
	}

	function setObjBank(){
		var objBank 			= new Object();
		objBank.parId 		 	= $F("globalParId");
		objBank.bankItemNo 	 	= parseFloat($F("bankItemNo"));
		objBank.bankItemNoC 	= $F("bankItemNo");
		objBank.bank 		 	= $F("bank");
		objBank.includeTag 	 	= $F("includeTag");
		objBank.bankAddress 	= nvl($F("address"), "---");
		objBank.cashInVault 	= $F("cashInVault") == "" ? "" : formatCurrency($F("cashInVault"));
		objBank.cashInTransit 	= $F("cashInTransit") == "" ? "" : formatCurrency($F("cashInTransit"));
		objBank.remarks 	 	= $F("remarks");
		return objBank;
	}

	function getRowBankContent(){

		var bankItemNo 		= $F("bankItemNo");
		var bank 			= changeSingleAndDoubleQuotes2($F("bank"));
		var cashInVault 	= $F("cashInVault") == "" ? "---" : formatCurrency($F("cashInVault"));
		var cashInTransit 	= $F("cashInTransit") == "" ? "---" : formatCurrency($F("cashInTransit"));
		var address 		= changeSingleAndDoubleQuotes2(nvl($F("address"), "---"));
		var includeTag 		= $F("includeTag");
		var remarks 		= changeSingleAndDoubleQuotes2(nvl($F("remarks"), "---"));
		
		var content = "<label style='width: 5%; text-align:center;'>"+bankItemNo+"</label>"
			+"<label style='width: 20%; text-align: left;'name='bankText'>"+bank+"</label>"
			+"<label style='width: 15%; text-align: left;'name='remarksText'>"+address+"</label>"
			+"<label style='width: 15%; text-align: right;'class='money'>"+cashInVault+"</label>"
			+"<label style='width: 15%; text-align: right;'class='money'>"+cashInTransit+"</label>"
			+"<label style='width: 25%; text-align: left; margin-left: 12px; 'name='remarksText'>"+remarks+"</label>"
			+"<input id='bankItemNo"+bankItemNo+"'	name='bankItemNo"+bankItemNo+"' 		type='hidden' value='"+bankItemNo+"'/>"
			+"<input id='bank"+bankItemNo+"'		name='bank"+bankItemNo+"'				type='hidden' value='"+bank+"'/>"
			+"<input id='cashInVault"+bankItemNo+"'	name='cashInVault"+bankItemNo+"' 		type='hidden' value='"+cashInVault+"'/>"
			+"<input id='cashInTransit"+bankItemNo+"'name='cashInTransit"+bankItemNo+"' 	type='hidden' value='"+cashInTransit+"'/>"
			+"<input id='includeTag"+bankItemNo+"'	name='includeTag"+bankItemNo+"' 		type='hidden' value='"+includeTag+"'/>"
			+"<input id='bankAddress"+bankItemNo+"'	name='bankAddress"+bankItemNo+"' 		type='hidden' value='"+address+"'/>"
			+"<input id='remarks"+bankItemNo+"'		name='remarks"+bankItemNo+"' 			type='hidden' value='"+remarks+"'/>"
			+"<input type='hidden' 	id='bankItemNumber'name='bankItemNumber' 	value='"+bankItemNo+"'/>";
		
		return content;
	}

	$("cashInVault").observe("change", function(){
		validateCashField("cashInVault");
	});

	$("cashInTransit").observe("change", function(){
		validateCashField("cashInTransit");
	});

	function validateCashField(elementId){
		var cashValue = $F(elementId).replace(/,/g, "");
		if (cashValue == ""){
			return false;
		}

		if (isNaN(cashValue) || cashValue.split(".").length > 2){
			$(elementId).value = "";
			$(elementId).focus();
			showMessageBox("Field must be of form 999,999,999,999.99.", imgMessage.ERROR);
		} else if ((cashValue.split(".").length == 2) && ((cashValue.split(".")[1]).length > 2)){
			$(elementId).value = "";
			$(elementId).focus();
			showMessageBox("Field must be of form 999,999,999,999.99.", imgMessage.ERROR);
		} else if ((parseFloat(cashValue) > 999999999999.99) || (parseFloat(cashValue) < -99999999999.99)){
			$(elementId).value = "";
			$(elementId).focus();
			showMessageBox("Must be in range -99,999,999,999.99 to 999,999,999,999.99.", imgMessage.ERROR);
		} else {
			$(elementId).value = formatCurrency(cashValue);
		}
	}

	$("btnAddBank").observe("click", function(){
		if (validateBankBeforeSave()) {
			var bankExists		= false;
			var bankItemNo 		= $F("bankItemNo");
			var bank 			= changeSingleAndDoubleQuotes2($F("bank"));
			var cashInVault 	= formatCurrency($F("cashInVault"));
			var cashInTransit 	= formatCurrency($F("cashInTransit"));
			var address 		= changeSingleAndDoubleQuotes2(nvl($F("address"), "---"));
			var includeTag 		= $F("includeTag");
			var remarks 		= changeSingleAndDoubleQuotes2(nvl($F("remarks"), "---"));
			
			changeTag = 1;

			$$("div[name='rowBank']").each(function(a){
				if (((a.down("input", 1).value)== bank) && ($("btnAddBank").value != "Update")) {
					showMessageBox("Bank name must be unique", "error");
					bankExists = true;
					return false;
				}
			});
			
			if (!bankExists){
				if ($F("btnAddBank") == "Update"){
					$("bankItemNo").value = $F("selectedBankItemNo");
					//var includeTag = $F("includeTag"+bankItemNo);
					//update html
					$("row"+bankItemNo).update(getRowBankContent());
					//update json object
					for (var i=0; i<objBankList.length; i++){
						if (objBankList[i].bankItemNoC == $F("bankItemNo")){
							objBankList[i] = setObjBank();
							objBankList[i].recordStatus	 = 1;
						}
					}
				} else { //if add
					$("bankItemNo").value 		= getNewBankItemNo();

					//update html
					var newDiv 		= new Element("div");
					newDiv.setAttribute("id", "row"+bankItemNo);
					newDiv.setAttribute("name", "rowBank");
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display: none;");
					newDiv.update(getRowBankContent());
					$("banksDiv").insert({bottom: newDiv});

					//add to JSON
					if (!(isPreviouslyDeletedBank())){
						var objBank 			= new Object();
						objBank 				= setObjBank();
						objBank.recordStatus	= 0;
						objBankList.push(objBank);
					} else {
						for (var i=0; i<objBankList.length; i++){
							if (objBankList[i].bankItemNoC == $F("bankItemNo")){
								objBankList[i] = setObjBank();
								objBankList[i].recordStatus	 = 1;
							}
						}
					}
					
					initializeBankRow(newDiv);
					
					Effect.Appear("row"+bankItemNo, {
						duration: .2,
						afterFinish: function () {
						//clearAddBankFields();
						checkIfToResizeTable("banksDiv", "rowBank");
						checkTableIfEmpty("rowBank", "banksDiv");
						}
					});
				}
				clearAddBankFields();
				trimLabelTexts();
			}
		}
	});

	function isPreviouslyDeletedBank(){
		var previouslyDeleted = false;
		for (var i=0; i<objBankList.length; i++){
			if ((objBankList[i].bankItemNoC == $F("bankItemNo")) && (objBankList[i].recordStatus == -1)){
				previouslyDeleted = true;
			}
		}
		return previouslyDeleted;
	}

	function initializeBankRow(row){
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});

		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});

		row.observe("click", function ()	{
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				try {
					$$("div[name='rowBank']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});

					var bankItemNo 		= row.down("input", 0).value;
					var bank 			= row.down("input", 1).value;
					var cashInVault 	= row.down("input", 2).value;
					var cashInTransit 	= row.down("input", 3).value;
					var includeTag 		= row.down("input", 4).value;
					var bankAddress 	= row.down("input", 5).value;
					var remarks 		= row.down("input", 6).value;

					$("selectedBankItemNo").value = bankItemNo;
					$("selectedBank").value = bank;
					$("selectedCashInVault").value = cashInVault;
					$("selectedCashInTransit").value = cashInTransit;
					$("selectedIncludeTag").value = includeTag;
					$("selectedBankAddress").value = bankAddress;
					$("selectedRemarks").value = remarks;

					$("bankItemNo").value = bankItemNo;
					$("bank").value = bank;
					$("cashInVault").value = cashInVault == "---" ? "" : cashInVault;
					$("cashInTransit").value = cashInTransit == "---" ? "" : cashInTransit;
					$("address").value = bankAddress == "---" ? "" : bankAddress;
					$("remarks").value = remarks == "---" ? "" : remarks;
					$("btnAddBank").value = "Update";
					enableButton("btnDeleteBank");
				} catch (e){
					showErrorMessage("initializeBankRow", e);
				}
			} else {
				clearSelected();
				clearAddBankFields();
				$("btnAddBank").value = "Add";
				disableButton("btnDeleteBank");
			}
		});
	}
	
	$("btnDeleteBank").observe("click", function(){
		disableButton("btnDeleteBank");
		var isSelectedExist = false;
		$$("div[name='rowBank']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				isSelectedExist = true;
				var bankItemNo 	= $F("bankItemNo");
				
				changeTag = 1; // added by jdiago 07.17.2014 - to be able to save deleted record.

				//updating JSON
				for (var i=0; i<objBankList.length; i++){
					if (objBankList[i].bankItemNoC == bankItemNo){
						objBankList[i].recordStatus = -1;
					}
				}
				
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function ()	{
						row.remove();
						clearAddBankFields();
						clearSelected();
						checkIfToResizeTable("banksDiv", "rowBank");
						checkTableIfEmpty("rowBank", "banksDiv");
						$("btnAddBank").value = "Add";
					}
				});
			}
		});
		if (!isSelectedExist) {
			showMessageBox("Please select bank to be deleted.", "error");
		}
		enableButton("btnDeleteBank");
	});
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		saveBankCollectionChanges();
	});
	
	function saveBankCollectionChanges(){

		var setRows = getAddedAndModifiedJSONObjects(objBankList);
		var delRows = getDeletedJSONObjects(objBankList);
		var objParameters = new Object();

		objParameters.setRows = setRows;
		objParameters.delRows = delRows;

		var strParameters = JSON.stringify(objParameters);

		new Ajax.Request(contextPath+"/GIPIWBankScheduleController?action=saveBankPageChanges&globalParId="+$F("globalParId"), {
			method: "POST",
			evalScripts: true,
			asynchronous: true,
			parameters: {
				parameter: strParameters
			},
			onCreate: function(){
				showNotice("Saving changes...");
				$("bankCollForm").disable();
			},
			onComplete: function (response)	{
				if (checkErrorOnResponse(response)) {
					hideNotice(response.responseText);
					$("bankCollForm").enable();
					changeTag = 0;
					//showMessageBox(response.responseText, imgMessage.SUCCESS);
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(exitVar) {
							exit();
						}
						if(reload){
							showBankCollectionPage();
						}
						if(logout){
							showConfLogOut();
						}
					});
				}
			}
		});
	}
	
	function getNewBankItemNo(){
		var maxBankItemNo = parseFloat("0");
		var newBankItemNo = parseFloat("1");
		$$("div[name='rowBank']").each(function(row) {
			var rowBankItemNo = parseFloat(row.readAttribute("id").substring(3));
			if (rowBankItemNo > maxBankItemNo){
				maxBankItemNo = rowBankItemNo;
			}
		});
		newBankItemNo = maxBankItemNo + 1;
		return newBankItemNo.toPaddedString(3);
	}
	
	function clearSelected(){
		$("selectedBankItemNo").value 			= "";
		$("selectedBank").value 				= "";
		$("selectedCashInVault").value 			= "";
		$("selectedCashInTransit").value 		= "";
		$("selectedIncludeTag").value 			= "";
		$("selectedBankAddress").value 			= "";
		$("selectedRemarks").value 				= "";
	}
	
	function clearAddBankFields(){
		$("bankItemNo").value					= getNewBankItemNo();
		$("bank").value 						= "";
		$("cashInVault").value 					= "";
		$("cashInTransit").value 				= "";
		$("address").value 						= "";
		$("remarks").value 						= "";
		$("includeTag").value					= "Y";
		disableButton("btnDeleteBank");
		$("btnAddBank").value = "Add";
		$$("div[name='rowBank']").each(function(row){
			row.removeClassName("selectedRow");
		});
	}
	
	reload = false;
	$("reloadForm").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						reload = true;
						saveBankCollectionChanges();
					}, function() {
						changeTag = 0;
						showBankCollectionPage();
					}, "");
		} else {
			showBankCollectionPage();
		}
	});
	
	$("bankCollMainDiv").show();

	$("parExit").stopObserving("click");
	exitVar = false;
	
	$("parExit").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						exitVar = true;
						saveBankCollectionChanges();
					}, function() {
						changeTag = 0;
						exit();
					}, "");
		} else {
			exit();
		}
	});
	
	$("btnCancel").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						exitVar = true;
						saveBankCollectionChanges();
					}, function() {
						changeTag = 0;
						exit();
					}, "");
		} else {
			exit();
		}
	});
	
	function exit(){
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
			showErrorMessage("bankCollection.jsp - btnCancel", e);
		}
	}
	
	$("logout").stopObserving("click");
	logout = false;
	$("logout").observe("click",function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						logout = true;
						saveBankCollectionChanges();
					}, function(){
						changeTag = 0;
						showConfLogOut();
					}, "");
		}else{
			showConfLogOut();
		}
	});
	
</script>