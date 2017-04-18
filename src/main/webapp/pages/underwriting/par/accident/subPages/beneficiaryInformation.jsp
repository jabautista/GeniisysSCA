<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="beneficiaryMainDiv" name="beneficiaryMainDiv" changeTagAttr="true" >
	<div style="margin: 10px;" id="benefeciaryTable" name="benefeciaryTable">	
		<div class="tableHeader" style="margin-top: 5px;">
			<label style="text-align: left; width: 19%; margin-left: 10px;">Name</label>
			<label style="text-align: left; width: 15%; margin-right: 10px;">Address</label>
			<label style="text-align: left; width: 14%; margin-right: 10px;">Birthday</label>
			<label style="text-align: left; width: 8%; margin-right: 10px;">Age</label>
			<label style="text-align: left; width: 14%; margin-right: 10px;">Relation</label>
			<label style="text-align: left; width: 20%;">Remarks</label>
		</div>
		<div id="beneficiaryListing" name="beneficiaryListing" style="display: block;"></div>
	</div>

	<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned" style="width:100px;">Name </td>
			<td class="leftAligned" colspan="3">
				<input id="beneficiaryNo" name="beneficiaryNo" type="hidden" style="width: 180px;" maxlength="5" readonly="readonly"/>
				<input id="beneficiaryName" name="beneficiaryName" type="text" style="width: 462px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Address </td>
			<td class="leftAligned" colspan="3">
				<input id="beneficiaryAddr" name="beneficiaryAddr" type="text" style="width: 462px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none;" id="beneficiaryDateOfBirth" name="beneficiaryDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('beneficiaryDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td style="width:79px;" class="rightAligned">Age</td>
			<td class="leftAligned" >	
				<input id="beneficiaryAge" name="beneficiaryAge" type="text" style="width: 180px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" readonly="readonly" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Relation </td>
			<td class="leftAligned" colspan="3">
				<input id="beneficiaryRelation" name="beneficiaryRelation" type="text" style="width: 180px;" maxlength="15"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
				<div style="border: 1px solid gray; height: 20px; width: 100%; ">
					<textarea id="beneficiaryRemarks" name="beneficiaryRemarks" style="width: 91% ; border: none; height: 13px;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editBenRemarks" />
				</div>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="nextItemNoBen" name="nextItemNoBen" type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiary" 	name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
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

	$("beneficiaryAge").observe("blur", function () {
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

	$("btnAddBeneficiary").observe("click", function() {
		try {
			if($F("beneficiaryName").trim() == ""){
				showWaitingMessageBox("Please enter beneficiary name.", imgMessage.INFO, function(){$("beneficiaryName").focus();});
				return;
			}
			var newBenObj = setBenObj();
			var newContent = prepareBenInfo(newBenObj);
			var tableContainer = $("beneficiaryListing");
			if($F("btnAddBeneficiary") == "Update") {
				$("rowBen"+$F("itemNo")+$F("beneficiaryNo")).update(newContent);
				addModifiedJSONObject(objBeneficiaries, newBenObj);
				$("rowBen"+$F("itemNo")+$F("beneficiaryNo")).removeClassName("selectedRow");
			} else {
				newBenObj.recordStatus = 0;
				objBeneficiaries.push(newBenObj);
				
				var newDiv = new Element('div');
				newDiv.setAttribute("id", "rowBen"+newBenObj.itemNo+newBenObj.beneficiaryNo);
				newDiv.setAttribute("name", "rowBen");
				newDiv.setAttribute("item", newBenObj.itemNo);
				newDiv.setAttribute("benNo", newBenObj.beneficiaryNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(newContent);
				tableContainer.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);
				clickBenRow(newBenObj, newDiv);

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
			newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo 			= $F("itemNo");
			newObj.beneficiaryNo 	= ($F("beneficiaryNo") == null || $F("beneficiaryNo") == "") ? setBeneficiaryNo() : $F("beneficiaryNo");
			newObj.beneficiaryName 	= nvl($F("beneficiaryName"), null);
			newObj.beneficiaryAddr 	= nvl($F("beneficiaryAddr"), null);
			newObj.deleteSw 		= "";
			newObj.relation 		= nvl($F("beneficiaryRelation"), null);
			newObj.remarks 			= nvl($F("beneficiaryRemarks"), null);
			newObj.adultSw 			= "";
			newObj.age 				= nvl($F("beneficiaryAge"));
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
			showErrorMessage("beneficiaryInformation.jsp - btnDeleteBeneficiary", e);
		}
	});
	
</script>