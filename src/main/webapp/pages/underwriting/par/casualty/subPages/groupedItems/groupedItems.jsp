<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/endt/casualty/subPages/groupedItems/groupedItemListing.jsp"></jsp:include>
<table align="center" width="920px" border="0" cellspacing="0" style="margin-bottom: 5px;">
	<tr>
		<td class="rightAligned" style="width:283px;">Grouped Item No </td>
		<td class="leftAligned">
			<input id="txtGroupedItemNo" name="txtGroupedItemNo" type="text" style="width: 357px;" maxlength="10" class="required integerUnformattedOnBlur" errorMsg="Invalid Grouped Item No. Valid value should be from 1 to 999999999." min="1" max="999999999" /><!-- changed -999999999 to 1 by reymon 02262013 -->
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Grouped Item Title </td>
		<td class="leftAligned" >			
			<input id="txtGroupedItemTitle" name="txtGroupedItemTitle" type="text" style="width: 357px;" maxlength="50" class="required"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Amount Covered </td>
		<td class="leftAligned" >
			<input id="txtAmountCovered" name="txtAmountCovered" type="text" style="width: 357px;" maxlength="17" class="money2" min="-99999999999999.99" max="99999999999999.99" errorMsg="Invalid Amount Covered. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99."/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Group</td>
		<td class="leftAligned">
			<select id="selGroupedItemCd" name="selGroupedItemCd" style="width: 365px;">
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
				<textarea onKeyDown="limitText(this, 4000)" onKeyUp="limitText(this, 4000)" id="txtRemarks" name="txtRemarks" style="width: 90%; border: none; height: 13px;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editRemarks">
			</div>			
		</td>
	</tr>	
</table>
<table style="margin: auto; width: 100%;" border="0">
	<tr>
		<td style="text-align: center;">
			<input type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 		style="width: 60px;" />
			<input type="button" class="disabledButton" id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 		style="width: 60px;" />
			<input type="button" id="caEndtItmNo" value="" style="display: none;"/> <!-- Deo [01.26.2017]: SR-23702 -->
		</td>
	</tr>
</table>

<script type="text/javascript">
	/*
	setTableList(objGIPIWGroupedItems, "groupedItemListing", "rowGroupedItem", "groupedItemsTable",
			 "itemNo groupedItemNo", "groupedItems");

	$$("div#groupedItemsTable div[name='rowGroupedItem']").each(function(row){
		loadRowObserver(row);
	});
	*/

	showGroupedItemsListing();

	function loadRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){				
				var id = row.getAttribute("id");				
				$$("div#groupedItemsTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");
				loadSelectedGroupedItem("rowGroupedItem", row);				
			}else{
				setGroupedItemsForm(null);
			}
		});
	}

	function addGroupedItem(){
		try{
			var obj 	= setGroupedItems();
			var content	= prepareGroupedItems(obj);
			var id 		= "rowGroupedItem" + obj.itemNo + "_" + obj.groupedItemNo;
			
			if($F("btnAddGroupedItems") == "Update"){
				addModedObjByAttr(objGIPIWGroupedItems, obj, "groupedItemNo");
				$(id).update(content);
				$(id).removeClassName("selectedRow");				
			}else{
				addNewJSONObject(objGIPIWGroupedItems, obj);

				var table = $("groupedItemListing");
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", id);
				newDiv.setAttribute("name", "rowGroupedItem");
				newDiv.setAttribute("item", obj.itemNo);
				newDiv.setAttribute("groupedItemNo", obj.groupedItemNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				table.insert({bottom : newDiv});

				loadRowObserver(newDiv);
				
				new Effect.Appear(id, {
					duration : 0.2
				});
			}			
			
			checkPopupsTableWithTotalAmountbyObject(objGIPIWGroupedItems, "groupedItemsTable", "groupedItemListing",
					"rowGroupedItem", "amountCovered", "groupedItemTotalAmountDiv", "groupedItemTotalAmount");
			
			setGroupedItemsForm(null);
			($$("div#groupedItemsInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addGroupedItem", e);
			//showMessageBox("addGroupedItem : " + e.message);
		}
	}

	function setGroupedItems(){
		try{
			var newObj = new Object();

			newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo			= $F("itemNo");
			newObj.groupedItemNo	= $F("txtGroupedItemNo");
			newObj.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("txtGroupedItemTitle"));
			newObj.groupCd			= $F("selGroupedItemCd");
			newObj.lineCd			= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
			newObj.sublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
			newObj.amountCovered	= ($F("txtAmountCovered")).empty() ? null : formatCurrency($F("txtAmountCovered"));
			newObj.remarks			= changeSingleAndDoubleQuotes2($F("txtRemarks"));
			newObj.includeTag		= "Y";
			//newObj.origRecord		= isOriginalRecord('${groupedItems}', newObj, "itemNo groupedItemNo");		
			
			return newObj;
		}catch(e){
			showErrorMessage("setGroupedItems", e);
			//showMessageBox("setGroupedItems : " + e.message);
		}
	}

	$("btnAddGroupedItems").observe("click", function(){
		if(($$("div#itemTable .selectedRow")).length < 1){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}else{
			if($F("txtGroupedItemNo").empty() || $F("txtGroupedItemTitle").empty()){				
				customShowMessageBox("Please complete required fields.", imgMessage.ERROR, 
						($F("txtGroupedItemNo")).empty() ? "txtGroupedItemNo" : "txtGroupedItemTitle");
				return false;
			}else{
				var id = "rowGroupedItem" + $F("itemNo") + "_" + $F("txtGroupedItemNo");
				if($(id) != null && $F("btnAddGroupedItems") == "Add"){
					showMessageBox("Record already exists.", imgMessage.ERROR);
					return false;
				}else{
					addGroupedItem();
				}
			}
		}
	});

	$("btnDeleteGroupedItems").observe("click", function(){		
		$$("div#groupedItemsTable .selectedRow").each(function(row){			
			Effect.Fade(row, {
				duration : 0.3,
				afterFinish : function(){
					var deleteObject = setGroupedItems();						
					addDelObjByAttr(objGIPIWGroupedItems, deleteObject, "groupedItemNo");
					row.remove();						
					setGroupedItemsForm(null);						
					checkPopupsTableWithTotalAmountbyObject(objGIPIWGroupedItems, "groupedItemsTable", "groupedItemListing",
							"rowGroupedItem", "amountCovered", "groupedItemTotalAmountDiv", "groupedItemTotalAmount");
				}
			});			
		});
	});

	$("txtGroupedItemNo").observe("blur", function(){		
		if($("rowGroupedItem" + $F("itemNo") + "_" + $F("txtGroupedItemNo")) != null && $F("btnAddGroupedItems") == "Add"){
			customShowMessageBox("Grouped Item No. must be unique.", imgMessage.ERROR, "txtGroupedItemNo");			
		}		
	});

	$("txtGroupedItemTitle").observe("blur", function(){
		if(!($F("txtGroupedItemTitle").blank()) && $F("btnAddGroupedItems") == "Add"){
			var objArrFiltered = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo");	});			

			if((objArrFiltered.filter(function(obj){	return unescapeHTML2(obj.groupedItemTitle) == $F("txtGroupedItemTitle");	})).length > 0){
				customShowMessageBox("Grouped Item Title must be unique.", imgMessage.ERROR, "txtGroupedItemTitle");
			}
		}		
	});
	
	$("editRemarks").observe("click", function(){
		showEditor("txtRemarks", 4000);
	});

	setGroupedItemsForm(null);
	
	$("caEndtItmNo").observe("click", function() { //Deo [01.26.2017]: SR-23702
		showGroupedItemsListing();
	});
</script>