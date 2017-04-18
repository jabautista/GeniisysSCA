<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="groupedItemsTable" name="groupedItemsTable" style="width : 100%;">
	<div id="groupedItemsTableGridSectionDiv" class="">
		<div id="groupedItemsTableGridDiv" style="padding: 10px;">
			<div id="groupedItemsTableGrid" style="height: 0px; width: 900px;"></div>
		</div>
	</div>	
</div>
<table align="center" width="920px" border="0" cellspacing="0" style="margin-bottom: 5px;">
	<tr>
		<td class="rightAligned" style="width:283px;" for="txtGroupedItemNo">Grouped Item No </td>
		<td class="leftAligned">
			<input tabindex="4001" id="txtGroupedItemNo" name="txtGroupedItemNo" type="text" style="width: 357px;" maxlength="10" class="required applyWholeNosRegExp" regExpPatt="nDigit09" min="1" max="999999999" /><!-- changed min value from -999999999 to 1 reymon 02222013 -->
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Grouped Item Title </td>
		<td class="leftAligned" >			
			<input tabindex="4002" id="txtGroupedItemTitle" name="txtGroupedItemTitle" type="text" style="width: 357px;" maxlength="50" class="required"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" for="txtAmountCovered">Amount Covered </td>
		<td class="leftAligned" >
			<!-- 
			<input tabindex="4003" id="txtAmountCovered" name="txtAmountCovered" type="text" style="width: 357px;" maxlength="17" class="applyDecimalRegExp" min="1" max="99999999999999.99" regExpPatt="pDeci1402" errorMsg="Invalid Amount Covered. Valid value is from 1 to 99,999,999,999,999.99."/>
			 -->
			<input tabindex="4003" id="txtAmountCovered" name="txtAmountCovered" type="text" style="width: 357px;" maxlength="17" class="applyDecimalRegExp" min="1" max="99999999999999.99" regExpPatt="pDeci1402" errorMsg="Invalid Amount Covered. Valid value is from 1 to 99,999,999,999,999.99."/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Group</td>
		<td class="leftAligned">
			<select tabindex="4004" id="selGroupedItemCd" name="selGroupedItemCd" style="width: 365px;">
				<option value=""></option>
				<c:forEach var="group" items="${groups}">
					<option value="${group.groupCd}">${group.groupDesc}</option>				
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Remarks </td>
		<td class="leftAligned" >
			<div style="border: 1px solid gray; height: 20px; width: 364px;">
				<textarea tabindex="4005" onKeyDown="limitText(this, 4000)" onKeyUp="limitText(this, 4000)" id="txtRemarks" name="txtRemarks" style="width: 90%; border: none; height: 13px; resize : none;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editRemarks">
			</div>			
		</td>
	</tr>	
</table>
<table style="margin: auto; width: 100%;" border="0">
	<tr>
		<td style="text-align: center;">
			<input tabindex="4006" type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 		style="width: 60px;" />
			<input tabindex="4007" type="button" class="disabledButton" id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>
<script type="text/javascript">
try{
	function addGroupedItem(){
		try{
			var newObj 	= setGroupedItems();			
			
			if($F("btnAddGroupedItems") == "Update"){				
				addModedObjByAttr(objGIPIWGroupedItems, newObj, "groupedItemNo");							
				tbgGroupedItems.updateVisibleRowOnly(newObj, tbgGroupedItems.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objGIPIWGroupedItems, newObj);
				tbgGroupedItems.addBottomRow(newObj);			
			}			
			
			//checkPopupsTableWithTotalAmountbyObject(objGIPIWGroupedItems, "groupedItemsTable", "groupedItemListing",
			//		"rowGroupedItem", "amountCovered", "groupedItemTotalAmountDiv", "groupedItemTotalAmount");
			
			setGroupedItemsFormTG(null);
			($$("div#groupedItemsInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addGroupedItem", e);			
		}
	}

	function setGroupedItems(){
		try{
			var newObj = new Object();

			newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo			= $F("itemNo");
			newObj.groupedItemNo	= $F("txtGroupedItemNo");
			//newObj.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("txtGroupedItemTitle"));
			newObj.groupedItemTitle	= escapeHTML2($F("txtGroupedItemTitle")); //replaced by: Mark C. 04162015 SR4302
			newObj.groupCd			= $F("selGroupedItemCd");
			newObj.lineCd			= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
			newObj.sublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
			newObj.amountCovered	= ($F("txtAmountCovered")).empty() ? null : formatCurrency($F("txtAmountCovered"));
			//newObj.remarks			= changeSingleAndDoubleQuotes2($F("txtRemarks"));
			newObj.remarks			= escapeHTML2($F("txtRemarks")); //replaced by: Mark C. 04162015 SR4302
			newObj.includeTag		= "Y";					
			
			return newObj;
		}catch(e){
			showErrorMessage("setGroupedItems", e);			
		}
	}

	$("btnAddGroupedItems").observe("click", function(){
		if(objCurrItem == null){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}else{
			if($F("txtGroupedItemNo").empty() || $F("txtGroupedItemTitle").empty()){				
				customShowMessageBox("Please complete required fields.", imgMessage.ERROR, 
						($F("txtGroupedItemNo")).empty() ? "txtGroupedItemNo" : "txtGroupedItemTitle");
				return false;
			}else{
				addGroupedItem();				
			}
		}
	});

	$("btnDeleteGroupedItems").observe("click", function(){	
		var delObj = setGroupedItems();
		addDelObjByAttr(objGIPIWGroupedItems, delObj, "groupedItemNo");			
		tbgGroupedItems.deleteVisibleRowOnly(tbgGroupedItems.getCurrentPosition()[1]);
		setGroupedItemsFormTG(null);
		updateTGPager(tbgGroupedItems);		
	});
	
	$("txtGroupedItemNo").observe("blur", function(){		
		var objArrFiltered = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") 
			&& obj.groupedItemNo == $F("txtGroupedItemNo");	});
		
		if(objArrFiltered.length > 0 && $F("btnAddGroupedItems") == "Add"){
			customShowMessageBox("Grouped Item No. must be unique.", imgMessage.ERROR, "txtGroupedItemNo");
			return false;
		}
	});
	
	$("txtGroupedItemTitle").observe("blur", function(){
		if(!($F("txtGroupedItemTitle").blank())/* && $F("btnAddGroupedItems") == "Add"*/){
			var objArrFiltered = objGIPIWGroupedItems.filter(
					function(obj){	
						return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") &&
							obj.groupedItemNo == $F("txtGroupedItemNo") && unescapeHTML2(obj.groupedItemTitle) == $F("txtGroupedItemTitle");
					});
			
			if(objArrFiltered.length < 1){
				objArrFiltered = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo");	});			

				if((objArrFiltered.filter(function(obj){	return unescapeHTML2(obj.groupedItemTitle) == $F("txtGroupedItemTitle");	})).length > 0){
					customShowMessageBox("Grouped Item Title must be unique.", imgMessage.ERROR, "txtGroupedItemTitle");
				}
			}			
		}		
	});
	
	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});

	setGroupedItemsFormTG(null);	
}catch(e){
	showErrorMessage("Grouped Items Page", e);
}
</script>