<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="grpItemsBenPerilsInfo">
	<div id="grpItemsBenPerilsTable" name="grpItemsBenPerilsTable" style="width : 100%;">
		<div id="grpItemsBenPerilsTableGridSectionDiv" class="">
			<div id="grpItemsBenPerilsTableGridDiv" style="padding: 10px;">
				<div id="grpItemsBenPerilsTableGrid" style="height: 0px; width: 872px;"></div>
			</div>
		</div>	
	</div>
	<table align="center" border="0">
		<tr> 
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >				
				<div style="float: left; border: solid 1px gray; width: 220px; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="bpPerilCd" name="bpPerilCd" />
					<input tabindex="12501" type="text" tabindex="6002" style="float: left; margin-top: 0px; margin-right: 3px; width: 192px; border: none;" name="bpPerilName" id="bpPerilName" readonly="readonly" class="required" />
					<img id="hrefBPPeril" alt="goBPPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div> 
				<!-- 
				<select  id="bpPerilCd" name="bpPerilCd" style="width: 223px" class="required">
					<option value=""></option>
					<c:forEach var="bPerils" items="${beneficiaryPerils}">
						<option value="${bPerils.perilCd}">${bPerils.perilName}</option>
					</c:forEach>
				</select>
				 -->
			</td>
			<td class="rightAligned" for="bpTsiAmt">TSI Amt. </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="12502" id="bpTsiAmt" name="bpTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="money2" min="0.01" max="99999999999999.99" errorMsg="Entered TSI Amount is invalid. Valid value is from 0.01 to 99,999,999,999,999.99. " />
				 -->
				<input tabindex="12502" id="bpTsiAmt" name="bpTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="applyDecimalRegExp" regExpPatt="pDeci1402" min="0.01" max="99999999999999.99" />
				<input id="bpPerilType" 	name="bpPerilType" 	type="hidden" />
				<input id="bpRiCommAmt" 	name="bpRiCommAmt" 	type="hidden" />
				<input id="bpBascPerlCd"	name="bpBascPerlCd"	type="hidden" />
				<input id="bpBasicPeril"	name="bpBasicPeril"	type="hidden" />
				<input id="bpIntmCommRt"	name="bpIntmCommRt"	type="hidden" />
				<input id="bpPrtFlag"		name="bpPrtFlag"	type="hidden" />				
				<input id="bpLineCd" 		name="bpLineCd" 	type="hidden" />				
			</td>
		</tr>		
	</table>
	<table align="center" border="0" style="margin-bottom:10px;">	
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input tabindex="12503" type="button" class="button" 		id="btnAddBeneficiaryPerils" 	name="btnAddBeneficiaryPerils" 		value="Add" 	style="width: 85px;" />
				<input tabindex="12504" type="button" class="disabledButton" id="btnDeleteBeneficiaryPerils" name="btnDeleteBeneficiaryPerils" 	value="Delete" 	style="width: 85px;" />
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">
try{
	$("hrefBPPeril").observe("click", function(){
		if($$("#grpItemsBeneficiaryTable .selectedRow").length > 0){
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
			var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));			
			var notIn = "";

			notIn = createNotInParamInObj(objGIPIWItmperlBeneficiary, 
					function(o){	
						return nvl(o.recordStatus, 0) != -1 && o.groupedItemNo == $F("groupedItemNo") && o.beneficiaryNo == $F("bBeneficiaryNo");	
					}, "perilCd");		
			
			showBeneficiaryPerilLOV(lineCd, sublineCd, notIn);
		}else{
			showMessageBox("Please select a Beneficiary Item first.", imgMessage.INFO);
			return false;
		}		
	});
	
	function addGroupedBenPerils(){
		try{
			var newObj = setItmperlBeneficiaryObj();
			
			if($F("btnAddBeneficiaryPerils") == "Update"){				
				addModedObjByAttr(objGIPIWItmperlBeneficiary, newObj, "beneficiaryNo perilCd");							
				tbgItmperlBeneficiary.updateVisibleRowOnly(newObj, tbgItmperlBeneficiary.getCurrentPosition()[1]);				
			}else{				
				addNewJSONObject(objGIPIWItmperlBeneficiary, newObj);
				tbgItmperlBeneficiary.addBottomRow(newObj);			
			}
			changeTag = 1;
			setItmperlBeneficiaryFormTG(null);
			($$("div#grpItemsBenPerilsInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addGroupedBenPerils", e);
		}
	}
	
	$("btnAddBeneficiaryPerils").observe("click", function() {
		if($$("#grpItemsBeneficiaryTable .selectedRow").length > 0){
			if($F("bpPerilCd") == "" && $F("bpPerilName") == ""){
				//showMessageBox("Peril is required.", imgMessage.ERROR);
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "bpPerilName");
				return false;
			}
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			addGroupedBenPerils();
		}else{
			showMessageBox("Please select a Beneficiary Item first.", imgMessage.INFO);
			return false;
		}		
	});
	
	$("btnDeleteBeneficiaryPerils").observe("click", function(){
		if (objUWParList.binderExist == "Y"){
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
			return false;
		}
		
		var delObj = setItmperlBeneficiaryObj();
		addDelObjByAttr(objGIPIWItmperlBeneficiary, delObj, "beneficiaryNo perilCd");			
		tbgItmperlBeneficiary.deleteVisibleRowOnly(tbgItmperlBeneficiary.getCurrentPosition()[1]);
		setItmperlBeneficiaryFormTG(null);
		updateTGPager(tbgItmperlBeneficiary);	
		changeTag = 1;
	});
	
	setItmperlBeneficiaryFormTG(null);
}catch(e){
	showErrorMessage("Accident Grouped Items Beneficiary Peril Page", e);
}
</script>