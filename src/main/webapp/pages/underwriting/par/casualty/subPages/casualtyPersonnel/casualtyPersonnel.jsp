<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");	
%>

<jsp:include page="/pages/underwriting/endt/casualty/subPages/casualtyPersonnel/casualtyPersonnelInformationListing.jsp"></jsp:include>
<table align="center" width="920px;" border="0" cellspacing="0" style="margin-bottom: 5px;">
	<tr>
		<td class="rightAligned" style="width: 283px;">Personnel No.</td>
		<td class="leftAligned">
			<input id="txtPersonnelNo" name="txtPersonnelNo" type="text" style="width: 357px;" maxlength="5" class="required integerUnformattedOnBlur" errorMsg="Invalid Personnel No. Value should be from 1 to 9999." min="1" max="9999" /><!-- changed -9999 to 1 by reymon 02262013 -->
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Personnel Name </td>
		<td class="leftAligned" >			
			<input id="txtPersonnelName" name="txtPersonnelName" type="text" style="width: 357px;" maxlength="50" class="required"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Amount Covered </td>
		<td class="leftAligned" >
			<input id="txtAmountCoveredP" name="txtAmountCoveredP" type="text" style="width: 357px;" maxlength="18" class="money2" errorMsg="Invalid Amount Covered. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." min="-99999999999999.99" max="99999999999999.99" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Capacity</td>
		<td class="leftAligned">
			<select id="selCapacityCdP" name="selCapacityCdP" style="width: 365px;" >
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
				<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarksP" name="txtRemarksP" style="width: 90%; border: none; height : 13px;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editRemarksP">
			</div>			
		</td>
	</tr>	
</table>
<table style="margin: auto; width: 100%;" border="0">
	<tr>
		<td style="text-align: center;">
			<input type="button" class="button" 		id="btnAddPersonnel" 		name="btnAddPersonnel" 		value="Add" 		style="width: 60px;" />
			<input type="button" class="disabledButton" id="btnDeletePersonnel" 	name="btnDeletePersonnel" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>

<script type="text/javascript">
	/*
	setTableList(objGIPIWCasualtyPersonnel, "casualtyPersonnelListing", "rowCasualtyPersonnel", "casualtyPersonnelTable",
			 "itemNo personnelNo", "casualtyPersonnel");
	
	$$("div#casualtyPersonnelTable div[name='rowCasualtyPersonnel']").each(function(row){
		loadRowObserver(row);
	});
	*/
	showCasualtyPersonnelListing();

	function loadRowObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);
	
			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){
					var id = row.getAttribute("id");
					$$("div#casualtyPersonnelTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");
					loadSelectedCasualtyPersonnel("rowCasualtyPersonnel", row);					
				}else{
					setCasualtyPersonnelForm(null);
				}
			});
		}catch(e){
			showErrorMessage("loadRowObserver", e);
			//showMessageBox("loadRowObserver : " + e.message);
		}
	}	

	function addPersonnel(){
		try{
			var obj		= setCasualtyPersonnel();	
			var content = prepareCasualtyPersonnel(obj);
	
			if($F("btnAddPersonnel") == "Update"){
				addModedObjByAttr(objGIPIWCasualtyPersonnel, obj, "personnelNo");
				$("rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo).update(content);
				$("rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo).removeClassName("selectedRow");
			}else{
				addNewJSONObject(objGIPIWCasualtyPersonnel, obj);

				var table = $("casualtyPersonnelListing");
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", "rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo);
				newDiv.setAttribute("name", "rowCasualtyPersonnel");
				newDiv.setAttribute("item", obj.itemNo);
				newDiv.setAttribute("personnelNo", obj.personnelNo);		
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				table.insert({bottom : newDiv});

				loadRowObserver(newDiv);				
				
				new Effect.Appear("rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo, {
					duration : 0.2
				});							
			}			

			checkPopupsTableWithTotalAmountbyObject(objGIPIWCasualtyPersonnel, "casualtyPersonnelTable", "casualtyPersonnelListing",
					"rowCasualtyPersonnel", "amountCovered", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount");

			setCasualtyPersonnelForm(null);
			($$("div#personnelInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addPersonnel", e);
			//showMessageBox("addPersonnel : " + e.message);
		}
	}

	function setCasualtyPersonnel(){
		try{
			var newObj = new Object();
	
			newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo 			= $F("itemNo");
			newObj.personnelNo 		= $F("txtPersonnelNo");
			newObj.personnelName 	= changeSingleAndDoubleQuotes2($F("txtPersonnelName"));
			newObj.amountCovered 	= ($F("txtAmountCoveredP")).empty() ? null : formatCurrency($F("txtAmountCoveredP"));
			newObj.capacityCd 		= $F("selCapacityCdP");
			newObj.capacityDesc		= $("selCapacityCdP").options[$("selCapacityCdP").selectedIndex].text;
			newObj.remarks 			= changeSingleAndDoubleQuotes2($F("txtRemarksP"));
			newObj.includeTag 		= "Y";
			//newObj.origRecord		= isOriginalRecord('${casualtyPersonnels}', newObj, "itemNo personnelNo");
			
			return newObj;
		}catch(e){
			showErrorMessage("setCasualtyPersonnel", e);
			//showMessageBox("setCasualtyPersonnel : " + e.message);
		}
	}
	
	$("btnAddPersonnel").observe("click", function(){
		if(($$("div#itemTable .selectedRow")).length < 1){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}else{
			if($F("txtPersonnelNo").empty() || $F("txtPersonnelName").empty()){
				customShowMessageBox("Please complete required fields.", imgMessage.ERROR, 
						($F("txtPersonnelNo")).empty() ? "txtPersonnelNo" : "txtPersonnelName");
				return false;
			}else{
				var id = "rowCasualtyPersonnel" + $F("itemNo") + "_" + $F("txtPersonnelNo");
				if($(id) != null && $F("btnAddPersonnel") == "Add"){
					showMessageBox("Record already exists.", imgMessage.ERROR);
					return false;
				}else{
					addPersonnel();
				}				
			}
		}
	});

	$("btnDeletePersonnel").observe("click", function(){
		$$("div#casualtyPersonnelTable .selectedRow").each(function(row){			
			Effect.Fade(row, {
				duration : 0.3,
				afterFinish : function(){
					var deleteObject = setCasualtyPersonnel();						
					addDelObjByAttr(objGIPIWCasualtyPersonnel, deleteObject, "personnelNo");
					row.remove();
					setCasualtyPersonnelForm(null);
					checkPopupsTableWithTotalAmountbyObject(objGIPIWCasualtyPersonnel, "casualtyPersonnelTable", "casualtyPersonnelListing",
							"rowCasualtyPersonnel", "amountCovered", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount");
				}
			});			
		});
	});

	$("editRemarksP").observe("click", function(){
		showEditor("txtRemarksP", 4000);
	});

	/*
	 *	Not yet implemented in oracle forms
	
	$("txtPersonnelNo").observe("blur", function(){
		if($("rowCasualtyPersonnel" + $F("itemNo") + "_" + $F("txtPersonnelNo")) != null && $F("btnAddPersonnel") == "Add"){
			customShowMessageBox("Personnel No. must be unique.", imgMessage.ERROR, "txtGroupedItemNo");			
		}
	});

	$("txtPersonnelName").observe("blur", function(){
		if(!($F("txtPersonnelName").blank()) && $F("btnAddPersonnel") == "Add"){
			var objArrFiltered = objGIPIWCasualtyPersonnel(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo");	});			

			if((objArrFiltered.filter(function(obj){	return unescapeHTML2(obj.personnelName) == $F("txtPersonnelName");	})).length > 0){
				customShowMessageBox("Personnel Name must be unique.", imgMessage.ERROR, "txtPersonnelName");
			}
		}
	});
	*/

	setCasualtyPersonnelForm(null);
</script>