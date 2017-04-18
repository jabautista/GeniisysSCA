<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<script type="text/javascript">
	inspectionReportObj.currentItems = eval('${inspItemInfoListing}');
	createItemInfoRows();
	
	function getItemNo(){ //edited by steven 12/11/2012
		var exist = true;
		var itemNoTemp = 1;
		if (inspectionReportObj.currentItems.length > 0) {
			for ( var i = 1; i < 1000000000; i++) {
				if (exist) {
					for ( var j = 0; j < inspectionReportObj.currentItems.length; j++) {
						if (inspectionReportObj.currentItems[j].itemNo == i) {
							exist = true;
							break;
						}else{
							itemNoTemp = i;
							exist = false;
						}
					}
				}else{
					break;
				}
			}
		}
		return lpad(itemNoTemp, 10, 0); 
	}
	$("itemNo").value = getItemNo();
	
	function createItemInfoRows(){
		var itemInfoList = inspectionReportObj.currentItems;
		for (var i = 0 ; i < itemInfoList.length; i++){
			var content = fillInspItemInfo(itemInfoList[i]);
			var newRow = new Element("div");
			newRow.setAttribute("id", "inspItemInfo"+itemInfoList[i].inspNo+itemInfoList[i].itemNo);
			newRow.setAttribute("name", "inspItemInfo");
			newRow.setAttribute("class", "tableRow");
			newRow.setAttribute("inspNo", itemInfoList[i].inspNo);
			newRow.setAttribute("itemNo", itemInfoList[i].itemNo);
			newRow.setAttribute("status", "C");
			newRow.setAttribute("recordStatus", 0);
			newRow.update(content);
			$("inspItemInfoContainer").insert(newRow);
			checkIfToResizeTable("inspItemInfoContainer", "inspItemInfo");
		}
	}

	function setUpdateables(){
		if ($("approvedTag").checked){
			disableButton("btnDeleteItem");
			$("itemNo2").readOnly = true;
		} else {
			$("btnAddItem").value = "Update";
			enableButton("btnDeleteItem");
			$("itemNo2").readOnly = false;
		}
	}

	$$("div[name='inspItemInfo']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		inspectionReportObj.selectedItem = "";

		row.observe("click", function (){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div[name='inspItemInfo']").each(function (row2){
					if (row.id != row2.id){
						row2.removeClassName("selectedRow");
					}
				});
				if (row.getAttribute("status") == "C"){
					itemObject = inspectionReportObj.currentItems;
				} else {
					itemObject = inspectionReportObj.addedItems;
				}
				fillInspItemInformation(row.getAttribute("inspNo"), row.getAttribute("itemNo"), itemObject);
				if ($("approvedTag").getAttribute("disabled") == "disabled"){
					disableButton("btnDeleteItem");
					$("itemNo2").readOnly = true;
				} else {
					$("btnAddItem").value = "Update";
					enableButton("btnDeleteItem");
					$("itemNo2").readOnly = false;
				}
				$("itemNo").readOnly = true; //added by steven 12/11/2012
				/*
				if ($("approvedTag").checked){
					disableButton("btnDeleteItem");
				} else {
					$("btnAddItem").value = "Update";
					enableButton("btnDeleteItem");
				}*/
				inspectionReportObj.selectedItem = row.getAttribute("itemNo");
			} else {
				clearInspItemInformation();
				$("itemNo").value = objUW.hidObjGIPIS197.generateItemNo(); //added by steven 12/11/2012
				$("approvedTag").checked ? $("itemNo").readOnly = true : $("itemNo").readOnly = false; //added by steven 12/11/2012
				$("itemNo2").focus();
				$("btnAddItem").value = "Add";
				disableButton($("btnDeleteItem"));
				inspectionReportObj.selectedItem = "";
			}
		});
	});

	/*
	function fillInspItemInformation(inspNo, itemNo){
		var selectedObj;
		for (var i = 0; i < itemInfoList.length; i++){
			if (itemInfoList[i].inspNo == inspNo &&
				itemInfoList[i].itemNo == itemNo){
				selectedObj = itemInfoList[i];
			}
		}

		fillItemInfoUsingObject(selectedObj);
	}*/
	$("approvedTag").observe("change", function (){
		if ($("approvedTag").checked){
			//$("itemNo2").readOnly = true;
			for (var i = 0; i < inspectionReportObj.currentItems.length; i++){
				var obj = inspectionReportObj.currentItems[i];
				obj.approvedBy = $F("currentUser");
				obj.dateApproved = new Date();
				var newCurrObj = cloneObject(inspectionReportObj.currentItems[i]);
				newCurrObj.inspNo = parseInt($F("inspNo"));
				newCurrObj.inspCd = $F("inspectorCd");
				//newCurrObj.assdNo = $F("txtAssdNo");
				//newCurrObj.assdName = $F("txtAssuredName");
				newCurrObj.assdNo = $F("assuredNo");
				newCurrObj.assdName = $F("assuredName");
				newCurrObj.intmNo = $F("txtIntmNo");
				newCurrObj.dateInsp = $F("dateInspected");
				newCurrObj.status = nvl($F("approvedTag"), "N");
				inspectionReportObj.addedItems.push(newCurrObj);
			}
			for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
				var obj = inspectionReportObj.addedItems[i];
				obj.approvedBy = $F("currentUser");
				obj.dateApproved = new Date();
			}
		} else {
			$("itemNo2").readOnly = false;
			for (var i = 0; i < inspectionReportObj.currentItems.length; i++){
				var obj = inspectionReportObj.currentItems[i];
				obj.approvedBy = "";
				obj.dateApproved = "";
			}
			for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
				var obj = inspectionReportObj.addedItems[i];
				obj.approvedBy = "";
				obj.dateApproved = "";
			}
		}
	});
	
	function itemNoField(){
		if ($F("itemNo") == ""){
			var itemNo = objUW.hidObjGIPIS197.generateItemNo(); //added by steven 12/11/2012
			$("itemNo").value = itemNo;
			$("itemNo2").focus();
		}
	}
	
	function generateItemNo(){
		var newItemNo = "";
		var lastItemNo = 0;
		$$("div[name='inspItemInfo']").each(function (row){
			lastItemNo = parseInt(row.down("label", 0).innerHTML);
		});
		newItemNo = lastItemNo + 1;
		return newItemNo.toPaddedString(10);
	}
	
	
		try{ //added by steven 9/3/2012
			if ($("approvedTag").checked){
				disableSearch("searchProvince"); 
				disableSearch("searchCity");
				disableSearch("searchDistrict");
				disableSearch("searchBlock");	
			} 
		}catch (e) {
			showErrorMessage("Disable SearchIcon",e);
		}
	
	itemNoField();
</script>