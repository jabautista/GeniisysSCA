<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/endt/casualty/subPages/groupedItems/groupedItemListing.jsp"></jsp:include>
<table align="center" width="520px;" border="0">
	<tr>
		<td class="rightAligned" style="width: 150px;">Grouped Item No </td>
		<td class="leftAligned">
			<input id="txtGroupedItemNo" name="txtGroupedItemNo" type="text" style="width: 357px;" maxlength="10" class="required integerUnformattedOnBlur" errorMsg="Invalid Grouped Item No. Valid value should be from -999999999 to 999999999." min="-999999999" max="999999999" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Grouped Item Title </td>
		<td class="leftAligned" >			
			<input id="txtGroupedItemTitle" name="txtGroupedItemTitle" type="text" style="width: 357px;" maxlength="50" class="required"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Amount Covered </td>
		<td class="leftAligned" >
			<input id="txtAmountCovered" name="txtAmountCovered" type="text" style="width: 357px;" maxlength="21" class="money2" min="-99999999999999.99" max="99999999999999.99" errorMsg="Invalid Amount Covered. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99."/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Group</td>
		<td class="leftAligned">
			<select id="selGroupedItemCd" name="selGroupedItemCd" style="width: 365px;">
				<option value=""></option>
				<c:forEach var="groupCdList" items="${groupListing}">
					<option value="${groupCdList.groupCd}">${groupCdList.groupDesc}</option>				
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Remarks </td>
		<td class="leftAligned" >
			<div style="border: 1px solid gray; height: 20px; width: 364px;">
				<textarea onKeyDown="limitText(this, 4000)" onKeyUp="limitText(this, 4000)" id="txtRemarks" name="txtRemarks" style="width: 90%; border: none; height: 13px;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editRemarks">
			</div>			
		</td>
	</tr>	
	<tr>
		<td>
			<input id="hidIncludeTag" name="hidIncludeTag" type="hidden" style="width: 220px;" value="Y" maxlength="1" readonly="readonly"/>
			<input id="hidNextItemNo" name="hidNextItemNo" type="hidden" style="width: 220px;" value="" readonly="readonly"/>
		</td>
	</tr>
</table>
<table align="center">
	<tr>
		<td class="rightAligned" style="text-align: left; padding-left: 5px;">
			<input type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 		style="width: 60px;" />
			<input type="button" class="disabledButton" id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();	

	setTableList(objEndtGroupedItems, "groupedItemListing", "rowGroupedItem", "groupedItemsTable",
			 "itemNo groupedItemNo", "groupedItems");
	//checkTableItemInfoAdditional("groupedItemsTable","groupedItemListing","rowGroupedItem","item",$F("itemNo"));
	
	truncateLongDisplayTexts2("label", "txtGroupItem", 15);

	$$("div#groupedItemsTable div[name='rowGroupedItem']").each(function(row){
		loadRowObserver(row);
	});

	function loadRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				var id = row.getAttribute("id");
				$$("div#groupedItemsTable div[name='rowGroupedItem']").each(function(r){
					if(id != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}
				});

				loadSelectedGroupedItem("rowGroupedItem", row, id);
				setUnsetPrimaryKeyFieldsToReadOnly(true);			
			}else{
				setFormValues(null);
			}
		});
	}

	$("btnAddGroupedItems").observe("click", function(){
		if(objItemNoList[$F("itemNo")] == undefined){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
		}else{
			if($F("txtGroupedItemNo").empty() || $F("txtGroupedItemTitle").empty()){				
				customShowMessageBox("Please complete required fields.", imgMessage.ERROR, 
						($F("txtGroupedItemNo")).empty() ? "txtGroupedItemNo" : "txtGroupedItemTitle");
			}else{
				var id = "rowGroupedItem" + $F("itemNo") + "_" + $F("txtGroupedItemNo");
				if($(id) != null && $F("btnAddGroupedItems") == "Add"){
					showMessageBox("Record already exists.", imgMessage.ERROR);
				}else{
					addGroupedItem();
				}
			}
		}
	});

	$("btnDeleteGroupedItems").observe("click", function(){		
		$$("div#groupedItemsTable div[name='rowGroupedItem']").each(function(row){
			if(row.hasClassName("selectedRow")){
				Effect.Fade(row, {
					duration : 0.5,
					afterFinish : function(){
						var deleteObject = setGroupedItems();						
						addDelObjByAttr(objEndtGroupedItems, deleteObject, "groupedItemNo");
						row.remove();
						objFormParameters[0].paramPostRecordSw = "Y";
						setFormValues(null);
						//checkPopupsTableWithTotalAmount("groupedItemsTable", "groupedItemListing", 
						//		"rowGroupedItem", "groupedItemTotalAmountDiv", 
						//		"groupedItemTotalAmount", 4);
						checkPopupsTableWithTotalAmountbyObject(objEndtGroupedItems, "groupedItemsTable", "groupedItemListing",
								"rowGroupedItem", "amountCovered", "groupedItemTotalAmountDiv", "groupedItemTotalAmount");
					}
				});
			}
		});
	});
	
	function setFormValues(obj){
		try{
			$("txtGroupedItemNo").value		= obj == null ? "" : obj.groupedItemNo;
			$("txtGroupedItemTitle").value	= obj == null ? "" : obj.groupedItemTitle;
			$("txtAmountCovered").value		= obj == null ? "" : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
			$("selGroupedItemCd").value		= obj == null ? "" : obj.groupCd;
			$("txtRemarks").value			= obj == null ? "" : obj.remarks == null ? "" : changeSingleAndDoubleQuotes(obj.remarks);

			$("btnAddGroupedItems").value	= obj == null ? "Add" : "Update";
			(obj == null) ? disableButton($("btnDeleteGroupedItems")) : enableButton($("btnDeleteGroupedItems"));
			setUnsetPrimaryKeyFieldsToReadOnly(obj == null ? false : true);
			
		}catch(e){
			showErrorMessage("setFormValues", e);
			//showMessageBox("setFormValues : " + e.message);
		}
	}

	function addGroupedItem(){
		try{
			var obj 	= setGroupedItems();
			var content	= prepareGroupedItems(obj);
			var id 		= "rowGroupedItem" + obj.itemNo + "_" + obj.groupedItemNo;
			if($F("btnAddGroupedItems") == "Update"){
				addModedObjByAttr(objEndtGroupedItems, obj, "groupedItemNo");
				$(id).update(content);
				$(id).removeClassName("selectedRow");				
			}else{
				addNewJSONObject(objEndtGroupedItems, obj);

				var table = $("groupedItemListing");
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", id);
				newDiv.setAttribute("name", "rowGroupedItem");
				newDiv.setAttribute("itemNo", obj.itemNo);
				newDiv.setAttribute("groupedItemNo", obj.groupedItemNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				table.insert({bottom : newDiv});

				loadRowObserver(newDiv);

				new Effect.Appear(id, {
					duration : 0.2
				});
			}

			//truncateLongDisplayTexts2("label", "txtGroupItem", 15);
			//checkPopupsTableWithTotalAmount("groupedItemsTable", "groupedItemListing", 
			//		"rowGroupedItem", "groupedItemTotalAmountDiv", 
			//		"groupedItemTotalAmount", 4);
			
			checkPopupsTableWithTotalAmountbyObject(objEndtGroupedItems, "groupedItemsTable", "groupedItemListing",
					"rowGroupedItem", "amountCovered", "groupedItemTotalAmountDiv", "groupedItemTotalAmount");
			
			setFormValues(null);
		}catch(e){
			showErrorMessage("addGroupedItem", e);
			//showMessageBox("addGroupedItem : " + e.message);
		}
	}

	function setGroupedItems(){
		try{
			var newObj = new Object();

			newObj.parId			= $F("globalParId");
			newObj.itemNo			= $F("itemNo");
			newObj.groupedItemNo	= $F("txtGroupedItemNo");
			newObj.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("txtGroupedItemTitle"));
			newObj.groupCd			= $F("selGroupedItemCd");
			newObj.sublineCd		= $F("globalSublineCd");
			newObj.amountCovered	= ($F("txtAmountCovered")).empty() ? null : formatCurrency($F("txtAmountCovered"));
			newObj.remarks			= changeSingleAndDoubleQuotes2($F("txtRemarks"));
			newObj.includeTag		= "Y";
			newObj.origRecord		= isOriginalRecord('${groupedItems}', newObj, "itemNo groupedItemNo");		
			
			return newObj;
		}catch(e){
			showErrorMessage("setGroupedItems", e);
			//showMessageBox("setGroupedItems : " + e.message);
		}
	}

	function setUnsetPrimaryKeyFieldsToReadOnly(property){
		if(property){
			$("txtGroupedItemNo").setAttribute("readonly", "readonly");
			//$("txtGroupedItemTitle").setAttribute("readonly", "readonly");
		}else{
			$("txtGroupedItemNo").removeAttribute("readonly");
			//$("txtGroupedItemTitle").removeAttribute("readonly");
		}		
	}	
	$("txtGroupedItemNo").observe("blur", function(){
		if($("rowGroupedItem" + $F("itemNo") + "_" + $F("txtGroupedItemNo")) != null && $F("btnAddGroupedItems") == "Add"){
			customShowMessageBox("Grouped Item No. must be unique.", imgMessage.ERROR, "txtGroupedItemNo");			
		}		
	});
	
	$("editRemarks").observe("click", function(){
		showEditor("txtRemarks", 4000);
	});
</script>