<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="beneficiaryMainDiv" name="beneficiaryMainDiv">
	<div style="margin: 10px;" id="benefeciaryTable" name="benefeciaryTable">	
		<div class="tableHeader" style="margin-top: 5px;">
			<label style="text-align: right; width: 40px;">No. </label>
			<label style="text-align: left; width: 200px; margin-left: 10px;">Name</label>
			<label style="text-align: left; width: 200px; margin-right: 10px;">Address</label>
			<label style="text-align: left; width: 70px; margin-right: 10px;">Birthday</label>
			<label style="text-align: left; width: 35px; margin-right: 10px;">Age</label>
			<label style="text-align: left; width: 100px; margin-right: 10px;">Relation</label>
			<label style="text-align: left; width: 200px;">Remarks</label>
		</div>
		<div id="beneficiaryListing" name="beneficiaryListing" style="display: block;"></div>
	</div>

	<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned">No. </td>
			<td class="leftAligned" style="width: 130px;">				
				<input type="text" id="beneficiaryNo" name="beneficiaryNo" maxlength="5" style="width: 100px;" class="required" />
			</td>
			<td class="rightAligned">Name </td>
			<td class="leftAligned" colspan="3">				
				<input id="beneficiaryName" name="beneficiaryName" type="text" style="width: 260px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Address </td>
			<td class="leftAligned" colspan="5">
				<input id="beneficiaryAddr" name="beneficiaryAddr" type="text" style="width: 444px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
			    	<input style="width: 80px; border: none;" id="beneficiaryDateOfBirth" name="beneficiaryDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('beneficiaryDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td class="rightAligned">Age </td>
			<td class="leftAligned" >	
				<input id="beneficiaryAge" name="beneficiaryAge" type="text" style="width: 32px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" readonly="readonly" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" />
			</td>
			<td class="rightAligned" style="width: 70px;">Relation </td>
			<td class="leftAligned">
				<input id="beneficiaryRelation" name="beneficiaryRelation" type="text" style="width: 120px;" maxlength="15"/>
			</td>
		</tr>		
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="5">
				<div style="border: 1px solid gray; height: 20px; width: 450px;">
					<textarea id="beneficiaryRemarks" name="beneficiaryRemarks" onKeyDown="limitText(this, 4000)" onKeyUp="limitText(this, 4000)" style="width: 424px; border: none; height: 13px; resize: none;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editBenRemarks" class="hover" />
				</div>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="nextItemNoBen" 	name="nextItemNoBen" 	type="hidden" style="width: 220px;" value="" readonly="readonly"/>
				<input id="nextItemNoBen2"  name="nextItemNoBen2"   type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiary" 		name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiary" 	name="btnDeleteBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
</div>
	
<script type="text/javascript">
	//moved from /underwriting/pop-ups...	
	
	$("beneficiaryAge").observe("blur", function () {
		if (parseInt($F("beneficiaryAge")) > 999 || parseInt($F("beneficiaryAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("beneficiaryAge").value ="";
			return false;
		} else{
			isNumber("beneficiaryAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("beneficiaryDateOfBirth").observe("blur", function () {
		if (!$F("beneficiaryDateOfBirth").blank()){
			$("beneficiaryAge").value = computeAge($("beneficiaryDateOfBirth").value);
			checkBday();
		}
	});

	$("beneficiaryDateOfBirth").observe("blur", function () {
		if ($("beneficiaryDateOfBirth").value != ""){
			if ($("beneficiaryAge").value != ""){
				$("beneficiaryAge").value = computeAge($("beneficiaryDateOfBirth").value);
			}
		}
	});
			
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("beneficiaryDateOfBirth"));
		if (bday>today){
			$("beneficiaryDateOfBirth").value = "";
			$("beneficiaryAge").value = "";
			hideNotice("");
		}	
	}
	
	function prepareBenInfo1(obj) {
		try {
			var benRow = "";
			if(obj != null) {
				var bName		= obj.beneficiaryName == null ? "---" : escapeHTML2(obj.beneficiaryName).truncate(20, "...");
				var bAddress 	= obj.beneficiaryAddr == null ? "---" : escapeHTML2(obj.beneficiaryAddr).truncate(20, "...");
				var bBirthDate 	= obj.dateOfBirth == null ? "---" : obj.dateFormatted == "Y" ? 
									obj.dateOfBirth : dateFormat(obj.dateOfBirth, "mm-dd-yyyy");
				var bAge 		= obj.age == null ? "---" : obj.age;
				var bRelation 	= obj.relation == null ? "---" : obj.relation;
				var bRemarks 	= obj.remarks == null ? "---" : escapeHTML2(obj.remarks).truncate(20, "...");
				var bNum 		= obj.beneficiaryNo == null ? "" : obj.beneficiaryNo;
				
				benRow 	=	'<label style="text-align: right; width: 40px;">' + bNum + '</label>' + 
						 	'<label style="text-align: left; width: 200px; margin-left: 10px;">'+bName+'</label>' + 
							'<label style="text-align: left; width: 200px; margin-right: 10px;">'+bAddress+'</label>' +
							'<label style="text-align: left; width: 70px; margin-right: 10px;">'+bBirthDate+'</label>' +
							'<label style="text-align: left; width: 35px; margin-right: 10px;">'+bAge+'</label>' +
							'<label style="text-align: left; width: 100px; margin-right: 10px;">'+bRelation+'</label>' +
							'<label style="text-align: left; width: 200px;">'+bRemarks+'</label>';
			}
			return benRow; 
		} catch(e) {
			showErrorMessage("prepareBenInfo1", e);
		}
	}
	
	function loadRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){				
				var id = row.getAttribute("id");				
				$$("div#benefeciaryTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");						

				var objArr = objBeneficiaries.filter(function(obj){	
					return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && 
						obj.beneficiaryNo == row.getAttribute("benNo");	});
				for(var i=0, length=objArr.length; i < length; i++){
					setBenForm(objArr[i]);
					break;
				}
			}else{
				setBenForm(null);
			}
		});
	}

	$("btnAddBeneficiary").observe("click", function() {
		try {
			if(($F("itemNo").empty() || objCurrItem == null)){
				showMessageBox("Select an item first.", "I");
				return;	
			}
			
			if($F("beneficiaryName").trim() == ""){
				showWaitingMessageBox("Please enter beneficiary name.", imgMessage.INFO, function(){$("beneficiaryName").focus();});
				return;
			}
			var newBenObj = setBenObj();
			var newContent = prepareBenInfo(newBenObj);
			var tableContainer = $("beneficiaryListing");
			var id = "rowBen" + newBenObj.itemNo + newBenObj.beneficiaryNo;
			
			if($F("btnAddBeneficiary") == "Update") {
				$(id).update(newContent);
				//addModifiedJSONObject(objBeneficiaries, newBenObj);
				addModedObjByAttr(objBeneficiaries, newBenObj, "beneficiaryNo");
				$(id).removeClassName("selectedRow");				
			} else {
				newBenObj.recordStatus = 0;
				objBeneficiaries.push(newBenObj);
				
				var newDiv = new Element('div');
				newDiv.setAttribute("id", id);
				newDiv.setAttribute("name", "rowBen");
				newDiv.setAttribute("item", newBenObj.itemNo);
				newDiv.setAttribute("benNo", newBenObj.beneficiaryNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(newContent);
				tableContainer.insert({bottom:newDiv});
				
				loadRowObserver(newDiv);

				new Effect.Appear("rowBen"+newBenObj.itemNo+newBenObj.beneficiaryNo, {
					duration: 0.2,
					afterFinish: function ()	{
						//checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","benRow","item",$F("itemNo"));
					}
				});
			}
			clearChangeAttribute("beneficiaryMainDiv");
			setBenForm(null);
			checkIfToResizeTable("beneficiaryListing", "rowBen");
			checkTableIfEmpty("rowBen", "benefeciaryTable");
		} catch(e) {
			showErrorMessage("beneficiaryInformation.jsp - btnAddBeneficiary", e);
			//showMessageBox("add beneficiary : "+e.message);
		}
	});

	function setBenObj() {
		try {
			var newObj = new Object();
			newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
			newObj.itemNo 			= $F("itemNo");
			newObj.beneficiaryNo 	= ($("beneficiaryNo") == null || $F("beneficiaryNo") == "") ? setBeneficiaryNo() : $F("beneficiaryNo");
			newObj.beneficiaryName 	= nvl($F("beneficiaryName"), null);
			newObj.beneficiaryAddr 	= nvl($F("beneficiaryAddr"), null);
			newObj.deleteSw 		= "";
			newObj.relation 		= nvl($F("beneficiaryRelation"), null);
			newObj.remarks 			= nvl($F("beneficiaryRemarks"), null);
			newObj.adultSw 			= "";
			newObj.age 				= nvl($F("beneficiaryAge"), null);
			newObj.civilStatus 		= "";
			newObj.dateOfBirth 		= $F("beneficiaryDateOfBirth").empty() ? null : $F("beneficiaryDateOfBirth");
			newObj.positionCd 		= "";
			newObj.sex 				= "";
			newObj.dateFormatted	= "Y";
			return newObj;
		} catch(e) {
			showErrorMessage("setBenObj", e);
		}
	}

	function setBeneficiaryNo() {
		var max = 0;
		if(objBeneficiaries != null) {
			for(var i=0; i<objBeneficiaries.length; i++) {
				if(objBeneficiaries[i].itemNo == $F("itemNo")) {
					if(max < parseInt(objBeneficiaries[i].beneficiaryNo)) {
						max = parseInt(objBeneficiaries[i].beneficiaryNo);
					}
				}
			}
		}
		return max + 1;
	}

	$("btnDeleteBeneficiary").observe("click", function() {
		try {
			var itemNum = $F("itemNo");
			var delObj = setBenObj();
			$$("div#beneficiaryListing .selectedRow").each(function(r) {
				Effect.Fade(r, {
					duration : .2,
					afterFinish : function() {
						//addDeletedJSONObject(objBeneficiaries, delObj);
						addDelObjByAttr(objBeneficiaries, delObj, "beneficiaryNo");	
						r.remove();
						checkIfToResizeTable("beneficiaryListing", "rowBen");
						checkTableIfEmpty("rowBen", "benefeciaryTable");
						setBenForm(null);
					}
				});
			});
		} catch(e) {
			showErrorMessage("Delete Beneficiary", e);
		}
	});
	
	$("editBenRemarks").observe("click", function(){
		showEditor("beneficiaryRemarks", 4000);
	});

	$("beneficiaryName").observe("keyup", function(){	
		if(($F("beneficiaryNo").empty()) || objCurrItem == null){
			$("beneficiaryName").value = "";
			showWaitingMessageBox("Beneficiary No. must be entered.", imgMessage.ERROR, function(){$("beneficiaryNo").focus();});
		}
	});

	$("beneficiaryName").observe("focus", function(){
		if(($F("itemNo").empty() || objCurrItem == null)){
			showMessageBox("Select an item first.", "I");	
		}
	});

	$("beneficiaryNo").observe("focus", function(){
		if(($F("itemNo").empty() || objCurrItem == null)){
			showMessageBox("Select an item first.", "I");	
		}
	});
	
	
	$("beneficiaryNo").observe("blur", function(){
		if(($F("itemNo").empty()) || objCurrItem == null){
			showMessageBox("Select an item first.", "I");
			return;	
		}
		
		if(!($F("beneficiaryNo").empty())){
			var objArrFiltered = objBeneficiaries.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") 
				&& obj.beneficiaryNo == $F("beneficiaryNo");	});
			
			if(objArrFiltered.length > 0 && $F("btnAddBeneficiary") == "Add"){
				customShowMessageBox("Beneficiary No. must be unique.", imgMessage.ERROR, "beneficiaryNo");
				return false;
			}
			
			if($F("beneficiaryName").empty()){
				new Ajax.Request(contextPath + "/GIPIBeneficiaryController", {
					parameters : {
						action : "getGIPIBeneficiary",
						parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId),
						itemNo : $F("itemNo"),
						beneficiaryNo : $F("beneficiaryNo")
					},
					evalScripts : true,
					asynchronous : false,
					onCreate : function(){
						showNotice("Getting beneficiary record ...");
					},
					onComplete : function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText.replace(/\\/g, "\\\\"));
							
							$("beneficiaryName").value = unescapeHTML2(obj.beneficiaryName);
							$("beneficiaryAddr").value = unescapeHTML2(obj.beneficiaryAddr);
							$("beneficiaryRelation").value = unescapeHTML2(obj.relation);
						}
					}
				});
			}
		}
	});
	
</script>