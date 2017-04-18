<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="beneficiaryTable" name="beneficiaryTable" style="width : 100%;">
	<div id="beneficiaryTableGridSectionDiv" class="">
		<div id="gbeneficiaryTableGridDiv" style="padding: 10px;">
			<div id="beneficiaryTableGrid" style="height: 0px; width: 900px;"></div>
		</div>
	</div>	
</div>
<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned" for="beneficiaryNo">No. </td>
			<td class="leftAligned" style="width: 130px;">
				<!-- 
				<input tabindex="2501" type="text" id="beneficiaryNo" name="beneficiaryNo" maxlength="5" style="width: 100px;" class="required" />
				 -->
				<input tabindex="2501" type="text" id="beneficiaryNo" name="beneficiaryNo" maxlength="5" style="width: 100px;" class="required applyWholeNosRegExp" regExpPatt="pDigit05" min="1" max="99999" hasOwnKeyUp="Y" hasOwnBlur="Y" hasOwnChange="Y" />
			</td>
			<td class="rightAligned">Name </td>
			<td class="leftAligned" colspan="3">				
				<input tabindex="2502" id="beneficiaryName" name="beneficiaryName" type="text" style="width: 260px" maxlength="30" class="required" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Address </td>
			<td class="leftAligned" colspan="5">
				<input tabindex="2503" id="beneficiaryAddr" name="beneficiaryAddr" type="text" style="width: 444px" maxlength="50" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
			    	<input tabindex="2504" style="width: 80px; border: none;" id="beneficiaryDateOfBirth" name="beneficiaryDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('beneficiaryDateOfBirth'),this, null);" alt="Birthday" class="hover" />
				</div>
			</td>	
			<td class="rightAligned">Age </td>
			<td class="leftAligned" >	
				<input tabindex="2505" id="beneficiaryAge" name="beneficiaryAge" type="text" style="width: 32px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" readonly="readonly" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" />
			</td>
			<td class="rightAligned" style="width: 70px;">Relation </td>
			<td class="leftAligned">
				<input tabindex="2506" id="beneficiaryRelation" name="beneficiaryRelation" type="text" style="width: 120px;" maxlength="15"/>
			</td>
		</tr>		
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="5">
				<div style="border: 1px solid gray; height: 20px; width: 450px;">
					<textarea tabindex="2507" id="beneficiaryRemarks" name="beneficiaryRemarks" onKeyDown="limitText(this, 4000)" onKeyUp="limitText(this, 4000)" style="width: 424px; border: none; height: 13px; resize: none;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editBenRemarks" class="hover" />
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
				<input tabindex="2508" type="button" class="button" 		id="btnAddBeneficiary" 		name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input tabindex="2509" type="button" class="disabledButton" id="btnDeleteBeneficiary" 	name="btnDeleteBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
try{
	function setBeneficiary(){
		try{
			var newObj = new Object();
			
			newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo			= $F("itemNo");
			newObj.beneficiaryNo	= $F("beneficiaryNo");
			//newObj.beneficiaryName	= changeSingleAndDoubleQuotes2($F("beneficiaryName"));
			newObj.beneficiaryName	= escapeHTML2($F("beneficiaryName")); //replaced by: Mark C. 03.30.2015 SR4302
			//newObj.beneficiaryAddr	= changeSingleAndDoubleQuotes2($F("beneficiaryAddr"));
			newObj.beneficiaryAddr	= escapeHTML2($F("beneficiaryAddr")); //replaced by: Mark C. 03.30.2015 SR4302
			newObj.deleteSw			= null;
			//newObj.relation			= changeSingleAndDoubleQuotes2($F("beneficiaryRelation"));
			//newObj.remarks			= changeSingleAndDoubleQuotes2($F("beneficiaryRemarks"));
			newObj.relation			= escapeHTML2($F("beneficiaryRelation")); //replaced by: Mark C. 03.30.2015 SR4302
			newObj.remarks			= escapeHTML2($F("beneficiaryRemarks")); //replaced by: Mark C. 03.30.2015 SR4302		 
			newObj.civilStatus		= null;
			newObj.dateOfBirth		= $F("beneficiaryDateOfBirth").empty() ? null : $F("beneficiaryDateOfBirth");
			newObj.age				= $F("beneficiaryAge");
			newObj.adultSw			= null;
			newObj.sex				= null;
			newObj.positionCd		= null;
			
			return newObj;			
		}catch(e){
			showErrorMessage("setBeneficiary", e);
		}
	}
	
	function addBeneficiary(){
		try{
			var newObj = setBeneficiary();
			
			if($F("btnAddBeneficiary") == "Update"){
				addModedObjByAttr(objBeneficiaries, newObj, "beneficiaryNo");							
				tbgBeneficiary.updateVisibleRowOnly(newObj, tbgBeneficiary.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objBeneficiaries, newObj);
				tbgBeneficiary.addBottomRow(newObj);
			}
			
			setBenFormTG(null);
			($$("div#beneficiaryInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addBeneficiary", e);
		}
	}
	
	$("btnAddBeneficiary").observe("click", function(){
		if(objCurrItem == null){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}else{
			if($F("beneficiaryName").empty()){				
				customShowMessageBox("Please enter beneficiary name.", imgMessage.ERROR, "beneficiaryName");
				return false;
			}else{
				addBeneficiary();						
			}
		}
	});
	
	$("btnDeleteBeneficiary").observe("click", function() {
		var delObj = setBeneficiary();
		addDelObjByAttr(objBeneficiaries, delObj, "beneficiaryNo");			
		tbgBeneficiary.deleteVisibleRowOnly(tbgBeneficiary.getCurrentPosition()[1]);
		setBenFormTG(null);
		updateTGPager(tbgBeneficiary);		
	});
	
	function validateBeneficiaryNo(){
		try{
			if($("beneficiaryNo").getAttribute("executeOnBlur") != "N"){
				var objArrFiltered = objBeneficiaries.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") 
					&& obj.beneficiaryNo == $F("beneficiaryNo");	});
				
				if(objArrFiltered.length > 0 && $F("btnAddBeneficiary") == "Add"){
					customShowMessageBox("Beneficiary No. must be unique.", imgMessage.ERROR, "beneficiaryNo");
					return false;
				}else{
					$("beneficiaryNo").setAttribute("lastValidValue", $F("beneficiaryNo"));
				}				
			}			
		}catch(e){
			showErrorMessage("validateBeneficiaryNo", e);
		}
	}
	
	$("beneficiaryNo").observe("keyup", function(e){		
		var m = $("beneficiaryNo");
		var pattern = m.getAttribute("regExpPatt");
		
		if(pattern.substr(0,1) == "p"){
			if(m.value.include("-")){
				m.setAttribute("executeOnBlur", "N");
				showWaitingMessageBox(getNumberFieldErrMsg(m, false), imgMessage.ERROR, function(){					
					m.value = m.getAttribute("lastValidValue");
					m.focus();
				});
				return false;
			}else{
				m.value = (m.value).match(RegExWholeNumber[pattern])[0];
				m.setAttribute("executeOnBlur", "Y");
			}		 
		}else{
			m.value = (m.value).match(RegExWholeNumber[pattern])[0];
			m.setAttribute("executeOnBlur", "Y");
		}			   						
	});
	
	$("beneficiaryNo").observe("blur", validateBeneficiaryNo);
	$("beneficiaryNo").observe("change", validateBeneficiaryNo);
	
	$("beneficiaryAge").observe("blur", function () {
		if (parseInt($F("beneficiaryAge")) > 999 || parseInt($F("beneficiaryAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("beneficiaryAge").value ="";
			return false;
		} else{
			isNumber("beneficiaryAge","Entered Age is invalid. Valid value is from 0 to 999","");
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
	
	/* $("editBenRemarks").observe("click", function(){
		showEditor("beneficiaryRemarks", 4000);
	}); */
	
	$("editBenRemarks").observe("click", function(){
		showOverlayEditor("beneficiaryRemarks", 4000, $("beneficiaryRemarks").hasAttribute("readonly"));
	});
	
	setBenFormTG(null);
}catch(e){
	showErrorMessage("Beneficiary Page", e);
}
</script>