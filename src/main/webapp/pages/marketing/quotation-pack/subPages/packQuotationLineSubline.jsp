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

<div id=lineSublineMainDiv name="lineSublineMainDiv" style="margin-top: 1px;" >
	<form id="lineSublineForm" name="lineSublineForm">

		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Line and Subline Coverages</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
		<div id="lineSublineFormDiv" name="lineSublineFormDiv" class="sectionDiv"  align="center" >
			<div id="lineSublineInfoDiv" name=lineSublineInfoDiv style="margin: 10px; width: 500px;" changeTagAttr="true">
				<div class="tableHeader" id="lineSublineInfoTable" name="lineSublineInfoTable">
					<label style="width: 80px; text-align: left; margin-left: 20px;">Line</label>
					<label style="width: 80px; text-align: left; ">Subline</label>
					<label style="width: 80px; text-align: left; ">Code</label>
					<label style="width: 80px; text-align: left; ">Year</label>
					<label style="width: 70px; text-align: left; ">Quote</label>
					<label style="width: 80px; text-align: left; ">No</label>
					<!-- <label style="width: 130px; text-align: left; margin-left: 5px;">Remarks</label> -->
				</div>
				<input type="hidden" id="selectedRow" value=""/>
				<div class="tableContainer" id="lineSublineList" name="lineSublineList">
				</div>
			</div>
			
			<div id="lineSublineInfoFormDiv" name="lineSublineInfoFormDiv" style="width: 100%; margin: 10px 0px 5px 0px" >
				<table align="center" width="70%">
					<tr>
						<td class="rightAligned" width="20%">Line</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displayLine" readonly="readonly" class="required" style="width: 68%; display: none;" />
							<select id="packLineCdOpt" name="packLineCdOpt" style="width: 70%;" class="required">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="20%">Subline</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displaySubline" readonly="readonly" class="required" style="width: 68%; display: none;" />
							<select id="packSublineCdOpt" name="packSublineCdOpt" style="width: 70%;" class="required" moduleType = "marketing"> <!-- added by steven 11/5/2012 -> moduleType = "marketing": this is for the function setPackSublineCd -->
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
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="infoButtonsDiv">
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
	if (objMKGlobal.proposalNo != 0){ // V0708 WHEN-NEW-BLOCK-INSTANCE
		$("btnAdd").hide();
		$("btnDelete").hide();
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnSave");
		$("lineSublineForm").disable();
	}
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);
		}else if(getAddedJSONObjects(objPackQuotations).length == 0 && getDeletedJSONObjects(objPackQuotations).length == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);		//Gzelle 10.03.2013 - when Add/Delete button is clicked without any records
		}else{
			savePackLineSubline();
		}
	});

	function savePackLineSubline(){
		try{
			var addRows = getAddedJSONObjects(objPackQuotations);
			var delRows = getDeletedJSONObjects(objPackQuotations);
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
						//showWaitingMessageBox(response.responseText, imgMessage.SUCCESS, showPackQuoteLineSubline);
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

	function reloadQuotation(){
		Modalbox.hide();
		if ($$("div[name='rowLineSubline']").size() < 1) {	//Gzelle 10.03.2013 - disable mortgagee button if all lineSublines are deleted
			disableButton("btnMortgageeInformation");
			$("quotePackMortgagee").hide();
		}else {
			enableButton("btnMortgageeInformation");
		}
// 		editPackQuotation(objMKGlobal.lineName,objMKGlobal.lineCd,objMKGlobal.packQuoteId); //remove by steven 11/6/2012 - it causes an error when you click the save and cancel button. 
	}
	
	$("packLineCdOpt").observe("change", function(){
		setPackSublineCd(objLineSubline);
	});

	$("btnAdd").observe("click", validateLineSubline);
	$("btnDelete").observe("click", function(){
		deleteLineSubline();
	});
	showPackQuotations();
	function showPackQuotations(){
		try{
			var objItems =objPackQuotations;
			
			for(var i =0;i<objItems.length ; i++){
				var quoteId =  objItems[i].quoteId;
				var lineCd =  objItems[i].lineCd;
				var lineName = objItems[i].lineName;
				var sublineCd = objItems[i].sublineCd;
				var sublineName = objItems[i].sublineName;
				var issCd = objItems[i].issCd;
				var quotationYy = objItems[i].quotationYy;
				var quotationNo = objItems[i].quotationNo;
				var proposalNo = objItems[i].proposalNo;
				var remarks 		= changeSingleAndDoubleQuotes2(nvl(objItems[i].remarks, "---"));
				
				var dspTag = objItems[i].dspTag;
				var newDiv 			= new Element("div");
				newDiv.setAttribute("id", "lineSublineItem"+lineCd+sublineCd+quoteId);
				newDiv.setAttribute("name", "rowLineSubline");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var content = '<input type="hidden" id="lineCd'+lineCd+sublineCd+quoteId+'" name="lineCd" value="'+lineCd+'"/>'
					+'<input type="hidden" id="lineName'+lineCd+sublineCd+quoteId+'" name="lineName" value="'+lineName+'"/>'
					+'<input type="hidden" id="sublineCd'+lineCd+sublineCd+quoteId+'" name="sublineCd" value="'+sublineCd+'"/>'
					+'<input type="hidden" id="sublineName'+lineCd+sublineCd+quoteId+'" name="sublineName" value="'+sublineName+'"/>'
					+'<input type="hidden" id="issCd'+lineCd+sublineCd+quoteId+'" name="issCd" value="'+issCd+'"/>'
					+'<input type="hidden" id="quotationYy'+lineCd+sublineCd+quoteId+'" name="quotationYy" value="'+quotationYy+'"/>'
					+'<input type="hidden" id="quotationNo'+lineCd+sublineCd+quoteId+'" name="quotationNo" value="'+quotationNo+'"/>'
					+'<input type="hidden" id="proposalNo'+lineCd+sublineCd+quoteId+'" name="proposalNo" value="'+proposalNo+'"/>'
					+'<input type="hidden" id="quoteId'+lineCd+sublineCd+quoteId+'" name="quoteId" value="'+quoteId+'"/>'					
					+'<input type="hidden" id="remarks'+lineCd+sublineCd+quoteId+'" name="remarks" value="'+changeSingleAndDoubleQuotes2(nvl(objItems[i].remarks,''))+'"/>'
					+'<input type="hidden" id="newRec'+lineCd+sublineCd+quoteId+'" value="N"/>'
					+'<label style="width: 80px; text-align: left; margin-left: 20px;" name="lineName" id="lineName">'+lineCd+'</label>'
					+'<label style="width: 81px; text-align: left; " name="sublineText" >'+sublineCd+'</label>'
					+'<label style="width: 81px; text-align: left; " name="issText" id="issText'+lineCd+sublineCd+quoteId+'">'+issCd+'</label>'
					+'<label style="width: 81px; text-align: left; " name="quotationYyText" id="quotationYyText'+lineCd+sublineCd+quoteId+'">'+quotationYy+'</label>'
					+'<label style="width: 70px; text-align: left; " name="quotationNoText" id="quotationNoText'+lineCd+sublineCd+quoteId+'">'+quotationNo+'</label>'
					+'<label style="width: 60px; text-align: left; " name="proposalNoText" id="proposalNoText'+lineCd+sublineCd+quoteId+'">'+proposalNo+'</label>';
				newDiv.update(content);
				$("lineSublineList").insert({bottom: newDiv});
				Effect.Appear("lineSublineItem"+lineCd+sublineCd+quoteId, {
					duration: .2,
					afterFinish: function () {
						checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
						checkIfToResizeTable("lineSublineList", "rowLineSubline");
					}
				});
			}
		}catch(e){
			showMessageBox("ERROR addLineSubline. "+e);
		}	
	}

	function deleteLineSubline(){
		try{
			$$("div[name='rowLineSubline']").each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					var lineCd = row.down("input", 0).value;
					var sublineCd = row.down("input", 2).value;
					var issCd = row.down("input", 4).value;
					var quotationYy = row.down("input", 5).value;
					var quotationNo = formatNumberDigits(row.down("input", 6).value,6);
					var proposalNo = formatNumberDigits(row.down("input", 7).value,3);
					var quoteId = row.down("input", 8).value;
					var newRec = row.down("input", 10).value;
					var subQuotationNo = lineCd+"-"+sublineCd +"-"+issCd +"-"+quotationYy +"-"+quotationNo +"-"+proposalNo;
					
					if(newRec == 'Y'){
						for (var i=0; i<objPackQuotations.length; i++){
							if (objPackQuotations[i].quoteId == quoteId ){
								 if(objPackQuotations[i].recordStatus == 0){
									 objPackQuotations.splice(i, 1); //added second condition for newly-added record so no need to send object to database 
								}
							}	
						}	
					}else{
						var objPackQuotation = new Object();
						objPackQuotation.quoteId = quoteId;
						objPackQuotation.recordStatus = -1;
						objPackQuotations.push(objPackQuotation);
						changeTag =1;
					}
					
					showConfirmBox("Confirm", "Are you sure you want to delete quotation number " + subQuotationNo + "?", 
							"Yes", "No", function() {
											Effect.Fade(row, {
												duration: .2,
												afterFinish: function ()	{
													row.remove();
													resetFields();
													checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
													checkIfToResizeTable("lineSublineList", "rowLineSubline");
													$("btnAdd").value = "Add";
												}
											});
											selectedIndex = false; 
											enableButton("btnAdd") ;
											disableButton("btnDelete");
										}, "","");
				}	
			});	
			
		}catch(e){
			showErrorMessage("deleteLineSubline", e);
		}
	}

	function addLineSubline(){
		try{
			var lineCd 		= selectedIndex ? lineCdTemp : $F("packLineCdOpt");
			var lineName 	= selectedIndex ? lineNameTemp : $("packLineCdOpt").options[$("packLineCdOpt").selectedIndex].getAttribute("lineName");
			var sublineCd 	= selectedIndex ? sublineCdTemp : $F("packSublineCdOpt");
			var sublineName = selectedIndex ? sublineNameTemp : $("packSublineCdOpt").options[$("packSublineCdOpt").selectedIndex].getAttribute("packSubLineName"); //change by steven 11/5/2012 from: "text"  to: "getAttribute("packSubLineName")"
			var remarks 	= $F("remarks");

			changeTag =1;

			var objPackQuotation = new Object();
			objPackQuotation.quoteId = newItemIndex; //  adds temp quoteId(index)
			objPackQuotation.packQuoteId = objMKGlobal.packQuoteId;
			objPackQuotation.lineCd = lineCd;
			objPackQuotation.lineName = lineName;
			objPackQuotation.sublineCd = sublineCd;
			objPackQuotation.sublineName = sublineName;
			objPackQuotation.issCd = objMKGlobal.issCd;
			objPackQuotation.issName= objMKGlobal.issName;
			objPackQuotation.proposalNo = objMKGlobal.proposalNo;
			objPackQuotation.quotationYy = objMKGlobal.quotationYy;
			objPackQuotation.remarks = remarks;
			objPackQuotation.assdNo = objMKGlobal.assdNo;
			objPackQuotation.assdName = objMKGlobal.assdName;
			objPackQuotation.inceptDate = objMKGlobal.inceptDate;
			objPackQuotation.expiryDate = objMKGlobal.expiryDate;
			objPackQuotation.credBranch = objMKGlobal.credBranchName;
			objPackQuotation.userId = objMKGlobal.userId;
			objPackQuotation.address1 = objMKGlobal.address1;
			objPackQuotation.address2 = objMKGlobal.address2;
			objPackQuotation.address3 =objMKGlobal.address3;
			objPackQuotation.acctOfCd = objMKGlobal.acctOfCd;
			objPackQuotation.underwriter = objMKGlobal.underwriter;
			objPackQuotation.inceptTag = objMKGlobal.inceptTag;
			objPackQuotation.expiryTag = objMKGlobal.expiryTag;
			objPackQuotation.header = objMKGlobal.expiryTag;
			objPackQuotation.footer = objMKGlobal.footer;
			objPackQuotation.reasonCd = objMKGlobal.reasonCd;
			objPackQuotation.compSw = objMKGlobal.compSw;
			objPackQuotation.prorateFlag =objMKGlobal.prorateFlag;
			objPackQuotation.shortRatePercent = objMKGlobal.shortRatePercent;
			objPackQuotation.bankRefNo = objMKGlobal.bankRefNo;
			objPackQuotation.acceptDate =objMKGlobal.acceptDate;
			objPackQuotation.validDate = objMKGlobal.validDate;
			objPackQuotation.recordStatus = 0;
			
			//var quoteId = '';	
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "lineSublineItem"+lineCd+sublineCd+newItemIndex);
			newDiv.setAttribute("name", "rowLineSubline");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			var content = '<input type="hidden" id="lineCd'+lineCd+sublineCd+newItemIndex+'" name="lineCd" value="'+lineCd+'"/>'
				+'<input type="hidden" id="lineName'+lineCd+sublineCd+newItemIndex+'" name="lineName" value="'+lineName+'"/>'
				+'<input type="hidden" id="sublineCd'+lineCd+sublineCd+newItemIndex+'" name="sublineCd" value="'+sublineCd+'"/>'
				+'<input type="hidden" id="sublineName'+lineCd+sublineCd+newItemIndex+'" name="sublineName" value="'+sublineName+'"/>'
				+'<input type="hidden" id="issCd'+lineCd+sublineCd+newItemIndex+'" name="issCd" value="'+objMKGlobal.issCd+'"/>'
				+'<input type="hidden" id="quotationYy'+lineCd+sublineCd+newItemIndex+'" name="quotationYy" value="'+year+'"/>'
				+'<input type="hidden" id="quotationNo'+lineCd+sublineCd+newItemIndex+'" name="quotationNo" value=""/>'
				+'<input type="hidden" id="proposalNo'+lineCd+sublineCd+newItemIndex+'" name="proposalNo" value="'+objMKGlobal.proposalNo+'"/>'
				+'<input type="hidden" id="quoteId'+lineCd+sublineCd+newItemIndex+'" name="quoteId" value="'+newItemIndex+'"/>'					
				//+'<input type="hidden" id="remarks'+lineCd+sublineCd+newItemIndex+'" name="remarks" value="'+remarks+'"/>'
				+'<input type="hidden" id="newRec'+lineCd+sublineCd+newItemIndex+'" value="Y"/>'
				+'<label style="width: 80px; text-align: left; margin-left: 20px;" name="lineName" id="lineName">'+lineCd+'</label>'
				+'<label style="width: 81px; text-align: left; " name="sublineText" >'+sublineCd+'</label>'
				+'<label style="width: 81px; text-align: left; " name="issText" id="issText'+lineCd+sublineCd+newItemIndex+'">'+objMKGlobal.issCd+'</label>'
				+'<label style="width: 81px; text-align: left; " name="quotationYyText" id="quotationYyText'+lineCd+sublineCd+newItemIndex+'">'+year+'</label>'
				+'<label style="width: 70px; text-align: left; " name="quotationNoText" id="quotationNoText'+lineCd+sublineCd+newItemIndex+'">---</label>'
				+'<label style="width: 60px; text-align: left; " name="proposalNoText" id="proposalNoText'+lineCd+sublineCd+newItemIndex+'">'+objMKGlobal.proposalNo+'</label>';

			if ($F("btnAdd") == "Update"){ //added by steven -> for update
				$$("div[name='rowLineSubline']").each(function(div){
					if (div.hasClassName("selectedRow")){
						$$("div[name='rowLineSubline']").each(function (r)	{
							if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						for ( var i = 0; i < objPackQuotations.length; i++) {
							if(lineCd == objPackQuotations[i].lineCd && sublineCd == objPackQuotations[i].sublineCd && objPackQuotations[i].recordStatus == 0){
								objPackQuotations.splice(i, 1, objPackQuotation);
							}
						}
						newDiv = div;
						$("btnAdd").value = "Add";
						selectedIndex = false; 
					}
				});
				newDiv.update(content);
			}else{ //-> for add
				objPackQuotations.push(objPackQuotation);  // adds the new object to the main obj array
				newDiv.update(content);
				$("lineSublineList").insert({bottom: newDiv});
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});
		
				newDiv.observe("click", function(){
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow")){
						$$("div[name='rowLineSubline']").each(function (r)	{
							if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						displayLineSublineItemInfo(true, newDiv);
					} else {
						displayLineSublineItemInfo(false, null);
					} 
				});
		
				Effect.Appear("lineSublineItem"+lineCd+sublineCd+newItemIndex, {
					duration: .2,
					afterFinish: function () {
						//checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
						checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
						checkIfToResizeTable("lineSublineList", "rowLineSubline");
						trimLabelTexts();
					}
				});
				//increments the newItemIndex
				newItemIndex++;
			}
			resetFields();
		}catch(e){
			showErrorMessage("addLineSubline", e);
		}	

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
		var packLineCd = $F("packLineCdOpt");
		var packSublineCd = $F("packSublineCdOpt");
		var lineExist = false;
		var sublineExist = false;
		
		$$("input[name='lineCd']").any(function(v){
			if(v.value == packLineCd){
				lineExist = true;
			}
		});
		$$("input[name='sublineCd']").any(function(v){
			if(v.value == packSublineCd){
				sublineExist = true;
			}
		});
		
		if(lineExist && sublineExist){
			showMessageBox("Cannot create same record.");
			return false;
		}
		
		return true;
	}

	function displayLineSublineItemInfo(bool, row){
		try {
			(row == null ? enableButton("btnAdd") : disableButton("btnAdd"));
			if(!bool){
				resetFields();
				$("btnAdd").value = "Add";
				$("selectedRow").value = "";
				enableEditRemarks = true; // added by steven 11/5/2012
				selectedIndex = false; 
			} else {
				var packLineCdOpt = $("packLineCdOpt");
				var packSublineCdOpt = $("packSublineCdOpt");
				var lineDisplay = row.down("input", 0).value+' - '+row.down("input", 1).value;
				var sublineDisplay = row.down("input", 2).value+' - '+row.down("input", 3).value;
				
				lineCdTemp = row.down("input", 0).value;
				lineNameTemp = row.down("input", 1).value;
				sublineCdTemp = row.down("input", 2).value;
				sublineNameTemp = row.down("input", 3).value;
				packLineCdOpt.hide();
				packSublineCdOpt.hide();
				$("btnAdd").value = "Update";
				$("displayLine").value = lineDisplay;
				$("displayLine").show();
				$("displaySubline").value = sublineDisplay;
				$("displaySubline").show();
// 				$("editRemarks").hide(); // remove by steven 11/5/2012
				$("remarks").value = unescapeHTML2(nvl(row.down("input",9).value,"")); //added by steven 11/5/2012
				selectedIndex = true; 
				if(row.down("input",6).value == ""){// added by steven 11/5/2012
					enableEditRemarks = true; 
					$("remarks").disabled = false;
					enableButton("btnAdd");
				}else{
					enableEditRemarks = false; 
					$("remarks").disabled = true;
					disableButton("btnAdd");
				}
				//$("displayRemarks").show();
			//	$("btnAdd").value = "Update";
				$("selectedRow").value = row.down("input", 0).value+row.down("input", 2).value+row.down("input", 5).value;// sets the selected row
			}
			(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));
		} catch(e){
			showErrorMessage("displayLineSublineItemInfo", e);
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

	$$("div[name='rowLineSubline']").each(function (row){
		row.observe("click", function(){
			if (row.hasClassName("selectedRow")){
				displayLineSublineItemInfo(false, null);
			} else {
				displayLineSublineItemInfo(true, row);
			} 
		});
	});
	$("editRemarks").observe("click", function () {
		if (enableEditRemarks){ //added by steven 11/5/2012
			showEditor("remarks", 4000,"false");
		}else{
			showEditor("remarks", 4000,"true");
		}
	});

	addStyleToInputs();
	initializeAll();
	initializeAccordion();
	initializeTable("tableContainer", "rowLineSubline", "", "");
	checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
	checkIfToResizeTable("lineSublineList", "rowLineSubline");
	//observeReloadForm("reloadForm", showPackQuoteLineSubline);
	setDocumentTitle("Line and Subline Coverages");
	trimLabelTexts();
	initializeChangeTagBehavior(savePackLineSubline);
	observeCancelForm("btnCancel", savePackLineSubline, function(){
		Modalbox.hide();
	});
</script>