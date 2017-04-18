<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="groupedItemsBeneficiaryInfo" class="sectionDiv" style="display: block; width: 872px; background-color: white;">
	<div id="grpItemsBeneficiaryTable" name="grpItemsBeneficiaryTable" style="width : 100%;">
		<div id="grpItemsBeneficiaryTableGridSectionDiv" class="">
			<div id="grpItemsBeneficiaryTableGridDiv" style="padding: 10px;">
				<div id="grpItemsBeneficiaryTableGrid" style="height: 0px; width: 872px;"></div>
			</div>
		</div>	
	</div>
	<table align="center" width="500px;" border="0">
		<tr>
			<td class="rightAligned" for="bBeneficiaryNo">No. </td>
			<td class="leftAligned" style="width : 90px;">
				<!-- 
				<input tabindex="12001" id="bBeneficiaryNo" name="bBeneficiaryNo" type="text" style="width: 120px;" maxlength="5" class="required"/>
				 -->
				<input tabindex="12001" id="bBeneficiaryNo" name="bBeneficiaryNo" type="text" style="width: 120px;" maxlength="5" class="required applyWholeNosRegExp" regExpPatt="pDigit05" min="1" max="99999" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" />
			</td>
			
			<td class="rightAligned" style="width: 70px;">Name </td>
			<td class="leftAligned" colspan="3">				
				<input tabindex="12002" id="bBeneficiaryName" name="bBeneficiaryName" type="text" style="width: 205px" maxlength="30" class="required allCaps"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Address </td>
			<td class="leftAligned" colspan="5">
				<input tabindex="12003" id="bBeneficiaryAddr" name="bBeneficiaryAddr" type="text" style="width: 418px" maxlength="50" class="allCaps" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 126px; height: 21px; margin-right:3px;">
			    	<input tabindex="12004" style="width: 99px; border: none;" id="bDateOfBirth" name="bDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img name="accModalDate" id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bDateOfBirth'),this, null);" alt="Birthday" class="hover" />
				</div>
			</td>	
			<td class="rightAligned">Age </td>
			<td class="leftAligned" style="width: 55px;">
				<input tabindex="12005" id="bAge" name="bAge" type="text" style="width: 55px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 30px;">Sex </td>
			<td class="leftAligned" style="width: 100px;">	
				<select tabindex="12005" id="bSex" name="bSex" style="width: 106px;">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Relation </td>
			<td class="leftAligned">
				<input tabindex="12006" id="bRelation" name="bRelation" type="text" style="width: 120px;" maxlength="15" class="allCaps" />
			</td>
			<td class="rightAligned">Civil Status </td>
			<td class="leftAligned" colspan="5">
				<select tabindex="12006" id="bCivilStatus" name="bCivilStatus" style="width: 212px">
					<option value=""></option>
					<c:forEach var="civilStat" items="${civilStatus}">
						<option value="${civilStat.rvLowValue}">${civilStat.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
		</tr>		
	</table>
	<table align="center" style="margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input tabindex="12007" type="button" class="button" 		id="btnAddGrpBeneficiary" 		name="btnAddGrpBeneficiary" 	value="Add" 		style="width: 60px;" />
				<input tabindex="12008" type="button" class="disabledButton" id="btnDeleteGrpBeneficiary" 	name="btnDeleteGrpBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
	
	<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGrpItemBenPerils.jsp"></jsp:include>
</div>
<script type="text/javascript">
try{
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("bDateOfBirth"));
		if (bday>today){
			$("bDateOfBirth").value = "";
			$("bAge").value = "";			
		}	
	}
	
	$("bDateOfBirth").observe("blur", function(){
		if($F("bDateOfBirth") != ""){
			$("bAge").value = computeAge($("bDateOfBirth").value);
			checkBday();
		}		
	});
	
	function addGrpItemBeneficiary(){
		try{
			var newObj = setGrpItemBeneficiaryObj();
			
			if($F("btnAddGrpBeneficiary") == "Update"){
				addModedObjByAttr(objGIPIWGrpItemsBeneficiary, newObj, "beneficiaryNo");							
				tbgGrpItemsBeneficiary.updateVisibleRowOnly(newObj, tbgGrpItemsBeneficiary.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objGIPIWGrpItemsBeneficiary, newObj);
				tbgGrpItemsBeneficiary.addBottomRow(newObj);			
			}
			changeTag = 1; //marco - 05.24.2013
			setGrpItemBeneficiaryFormTG(null);
			($$("div#accBeneficiaryInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addGrpItemBeneficiary", e);
		}
	}
	
	$("btnAddGrpBeneficiary").observe("click", function(){
		if($$("#accGroupedItemsTable .selectedRow").length > 0){
			if($F("bBeneficiaryNo") == ""){
				//customShowMessageBox("Beneficiary No. is required.", imgMessage.ERROR, "bBeneficiaryNo");
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "bBeneficiaryNo");
				return false;
			}else if($F("bBeneficiaryName") == ""){
				//customShowMessageBox("Beneficiary Name is required.", imgMessage.ERROR, "bBeneficiaryName");
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "bBeneficiaryName");
				return false;
			}
			
			addGrpItemBeneficiary();
		}else{
			showMessageBox("Please select an Enrollee in Group Items first.", imgMessage.INFO);
			return false;
		}		
	});
	
	$("btnDeleteGrpBeneficiary").observe("click", function(){
		var delObj = setGrpItemBeneficiaryObj();
		addDelObjByAttr(objGIPIWGrpItemsBeneficiary, delObj, "beneficiaryNo");			
		tbgGrpItemsBeneficiary.deleteVisibleRowOnly(tbgGrpItemsBeneficiary.getCurrentPosition()[1]);
		deleteParItemTG(tbgItmperlBeneficiary);
		setGrpItemBeneficiaryFormTG(null);
		updateTGPager(tbgGrpItemsBeneficiary);	
		changeTag = 1;
	});
	/* Added by MarkS 04.29.2016 SR-21720 to handle if beneficiaryNo is already existing */
	$("bBeneficiaryNo").observe("change", function(){
		var newObj = setGrpItemBeneficiaryObj();
		if($F("bBeneficiaryNo") != ""){
			if(preValidateBenNo(newObj)){
				
				validateBenNo(newObj);
			}else{
				clearFocusElementOnError("bBeneficiaryNo", "Beneficiary must be unique.");
			}
		}
	});
	function validateBenNo(newObj){
		 new Ajax.Request(contextPath + "/GIPIWGrpItemsBeneficiaryController?action=validateBenNo2",{
			parameters : {
				parId  	      : newObj.parId,
				itemNo 		  : newObj.itemNo,
				groupedItemNo : newObj.groupedItemNo,
				beneficiaryNo : $F("bBeneficiaryNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						clearFocusElementOnError("bBeneficiaryNo", obj.message);
					}
				}
			}
		}); 
	} 
	function preValidateBenNo(newObj){
		for(var i = 0; i < objGIPIWGrpItemsBeneficiary.length; i++){
			if((objGIPIWGrpItemsBeneficiary[i].recordStatus != -1) && (parseInt(objGIPIWGrpItemsBeneficiary[i].groupedItemNo) == parseInt(parseInt(newObj.groupedItemNo))) && (parseInt(objGIPIWGrpItemsBeneficiary[i].beneficiaryNo) == parseInt($F("bBeneficiaryNo")))){
				return false;
			}
		}
		return true;
	}
	/* END SR-21720 */
	setGrpItemBeneficiaryFormTG(null);
}catch(e){
	showErrorMessage("Accident Grouped Items Beneficiary Page", e);
}
</script>