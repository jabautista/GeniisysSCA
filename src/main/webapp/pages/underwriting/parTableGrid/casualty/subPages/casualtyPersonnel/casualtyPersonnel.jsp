<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<% 
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="casualtyPersonnelTable" name="casualtyPersonnelTable" style="width : 100%;">
	<div id="casualtyPersonnelTableGridSectionDiv" class="">
		<div id="casualtyPersonnelTableGridDiv" style="padding: 10px;">
			<div id="casualtyPersonnelTableGrid" style="height: 0px; width: 900px;"></div>
		</div>
	</div>	
</div>
<table align="center" width="920px;" border="0" cellspacing="0" style="margin-bottom: 5px;">
	<tr>
		<td class="rightAligned" style="width: 283px;" for="txtPersonnelNo">Personnel No.</td>
		<td class="leftAligned">
			<!-- 
			<input tabindex="5001" id="txtPersonnelNo" name="txtPersonnelNo" type="text" style="width: 357px;" maxlength="5" class="required integerUnformattedOnBlur" errorMsg="Invalid Personnel No. Value should be from -9999 to 9999." min="-9999" max="9999" />
			 -->
			<input tabindex="5001" id="txtPersonnelNo" name="txtPersonnelNo" type="text" style="width: 357px;" maxlength="5" class="required applyWholeNosRegExp" regExpPatt="nDigit04" min="1" max="9999" /><!-- changed min value from -9999 to 1 reymon 02222013 -->
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Personnel Name </td>
		<td class="leftAligned" >			
			<input tabindex="5002" id="txtPersonnelName" name="txtPersonnelName" type="text" style="width: 357px;" maxlength="50" class="required"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;" for="txtAmountCoveredP">Amount Covered </td>
		<td class="leftAligned" >
			<!-- 
			<input tabindex="5003" id="txtAmountCoveredP" name="txtAmountCoveredP" type="text" style="width: 357px;" maxlength="18" class="money2" errorMsg="Invalid Amount Covered. Value should be from 1 to 99,999,999,999,999.99." min="1" max="99999999999999.99" />
			 -->
			<input tabindex="5003" id="txtAmountCoveredP" name="txtAmountCoveredP" type="text" style="width: 357px;" maxlength="18" class="applyDecimalRegExp" regExpPatt="pDeci1402" min="1" max="99999999999999.99" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Capacity</td>
		<td class="leftAligned">
			<select tabindex="5004" id="selCapacityCdP" name="selCapacityCdP" style="width: 365px;" >
				<option value=""></option>
				<c:forEach var="capacity" items="${capacityListing}">
					<option value="${capacity.positionCd}">${capacity.position}</option>				
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Remarks </td>
		<td class="leftAligned" >
			<div style="border: 1px solid gray; height: 20px; width: 364px;">
				<textarea tabindex="5005" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarksP" name="txtRemarksP" style="width: 90%; border: none; height : 13px; resize : none;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editRemarksP">
			</div>			
		</td>
	</tr>	
</table>
<table style="margin: auto; width: 100%;" border="0">
	<tr>
		<td style="text-align: center;">
			<input tabindex="5006" type="button" class="button" 		id="btnAddPersonnel" 		name="btnAddPersonnel" 		value="Add" 		style="width: 60px;" />
			<input tabindex="5007" type="button" class="disabledButton" id="btnDeletePersonnel" 	name="btnDeletePersonnel" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>
<script type="text/javascript">
try{
	function addPersonnel(){
		try{
			var newObj		= setCasualtyPersonnel();			
	
			if($F("btnAddPersonnel") == "Update"){				
				addModedObjByAttr(objGIPIWCasualtyPersonnel, newObj, "personnelNo");							
				tbgCasualtyPersonnel.updateVisibleRowOnly(newObj, tbgCasualtyPersonnel.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objGIPIWCasualtyPersonnel, newObj);
				tbgCasualtyPersonnel.addBottomRow(newObj);				
			}			

			//checkPopupsTableWithTotalAmountbyObject(objGIPIWCasualtyPersonnel, "casualtyPersonnelTable", "casualtyPersonnelListing",
			//		"rowCasualtyPersonnel", "amountCovered", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount");

			setCasualtyPersonnelFormTG(null);
			($$("div#personnelInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addPersonnel", e);			
		}
	}

	function setCasualtyPersonnel(){
		try{
			var newObj = new Object();
	
			newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo 			= $F("itemNo");
			newObj.personnelNo 		= $F("txtPersonnelNo");
			//newObj.personnelName 	= changeSingleAndDoubleQuotes2($F("txtPersonnelName")); SR4302
			newObj.personnelName 	= escapeHTML2($F("txtPersonnelName")); //replaced by: Mark C. 04162015
			newObj.amountCovered 	= ($F("txtAmountCoveredP")).empty() ? null : formatCurrency($F("txtAmountCoveredP"));
			newObj.capacityCd 		= $F("selCapacityCdP");
			newObj.capacityDesc		= escapeHTML2($("selCapacityCdP").options[$("selCapacityCdP").selectedIndex].text);	//Gzelle 05282015 SR4302
			//newObj.remarks 			= changeSingleAndDoubleQuotes2($F("txtRemarksP")); SR4302
			newObj.remarks 			= escapeHTML2($F("txtRemarksP")); //replaced by: Mark C. 04162015
			newObj.includeTag 		= "Y";			
			
			return newObj;
		}catch(e){
			showErrorMessage("setCasualtyPersonnel", e);			
		}
	}
	
	$("btnAddPersonnel").observe("click", function(){
		if(objCurrItem == null){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}else{
			if($F("txtPersonnelNo").empty() || $F("txtPersonnelName").empty()){
				customShowMessageBox("Please complete required fields.", imgMessage.ERROR, 
						($F("txtPersonnelNo")).empty() ? "txtPersonnelNo" : "txtPersonnelName");
				return false;
			}else{
				var objArrFiltered = objGIPIWCasualtyPersonnel.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") 
					&& obj.personnelNo == $F("txtPersonnelNo");	});
				
				if(objArrFiltered.length > 0 && $F("btnAddPersonnel") == "Add"){
					customShowMessageBox("Personnel No. must be unique.", imgMessage.ERROR, "txtPersonnelNo");
					return false;
				}else if(objArrFiltered.filter(function(obj){	return unescapeHTML2(obj.personnelName) == $F("txtPersonnelName");	}).length > 0  && $F("btnAddPersonnel") == "Add"){
					showMessageBox("Record already exists.", imgMessage.ERROR);
					return false;
				}else{
					addPersonnel();
				}							
			}
		}
	});

	$("btnDeletePersonnel").observe("click", function(){
		var delObj = setCasualtyPersonnel();
		addDelObjByAttr(objGIPIWCasualtyPersonnel, delObj, "personnelNo");			
		tbgCasualtyPersonnel.deleteVisibleRowOnly(tbgCasualtyPersonnel.getCurrentPosition()[1]);
		setCasualtyPersonnelFormTG(null);
		updateTGPager(tbgCasualtyPersonnel);
	});
	
	$("editRemarksP").observe("click", function() {
		showOverlayEditor("txtRemarksP", 4000, $("txtRemarksP").hasAttribute("readonly"));
	});
	
	setCasualtyPersonnelFormTG(null);
}catch(e){
	showErrorMessage("Casualty Personnel Page", e);
}
</script>
