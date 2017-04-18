<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="popGrpItemsInfo" class="sectionDiv" style="display: block;  background-color:white; width: 598px; height: 265px;">
	<div style="margin : 10px; width: 350px; float: left;" id="accidentRetGrpItemsTable" name="accidentRetGrpItemsTable">	
		<div class="tableHeader" style="margin-top: 5px;">			
			<label style="text-align: left; width: 120px; margin-right: 5px; margin-left: 5px;">Grouped Item No.</label>
			<label style="text-align: left; width: 190px; margin-right: 5px;">Grouped Item Title</label>
		</div>
		<div class="tableContainer" id="retrievedGroupedItemsListing" style="display: block; height: 217px; overflow: auto;">			
		</div>		
	</div>
	
	<div id="subButtonDiv" style="display: block; border : 1px solid gray; width: 215px; float: left; margin : 15px 10px 10px 0px;">		
		<table border="0" style="float : left; margin-top: 5px;">
			<tr>
				<td style="padding : 5px;">
					<input type="radio" id="radioRetSelectGroupedItems" name="radioRetSelectGroupedItems" value="1" style="margin-left: 5px;" />
				</td>
				<td class="leftAligned">Selected Grouped Items</td>
			</tr>
			<tr>
				<td style="padding : 5px;">
					<input type="radio" id="radioRetAllGroupedItems" name="radioRetSelectGroupedItems" value="2" style="margin-left: 5px;" />
				</td>
				<td class="leftAligned">All Grouped Items</td>
			</tr>			
		</table>
		
		<div style="width: 100%; float : left;">
			<table align="center" style="margin-top:10px; margin-bottom:10px;">
				<tr>
					<td>
						<input type="button" class="button"	id="btnOkPopRetGrpItems" 	    name="btnOkPopRetGrpItems"		value="OK"		style="width: 70px" />
						<!-- <input type="button" class="button"	id="btnCancelPopRetGrpItems" 	name="btnCancelPopRetGrpItems" 	value="Cancel" 	style="width: 130px" />  -->
					</td>
				</tr>
			</table>
		</div>			
	 </div>
</div>

<script type="text/javascript">
	var objRetrievedGIPIGroupedItems = JSON.parse('${gipiGroupedItems}'.replace(/\\/g, "\\\\"));
	var objRetrievedGIPIItmPerilGrouped = JSON.parse('${gipiItmPerilGrouped}'.replace(/\\/g, "\\\\"));
	var objRetrievedGIPIGrpItemsBeneficiary = JSON.parse('${gipiGrpItemsBeneficiary}'.replace(/\\/g, "\\\\"));

	function prepareRetrievedGroupedItemsDisplay(obj){
		try{
			var groupedItemNo 		= obj == null ? "---" : obj.groupedItemNo;
			var groupedItemTitle	= obj == null ? "---" : escapeHTML2(nvl(obj.groupedItemTitle, "---")).truncate(20, "...");
			var content =				
				'<label style="text-align: left; width: 120px; margin-right: 5px; margin-left: 5px;">' + groupedItemNo + '</label>' +
				'<label style="text-align: left; width: 190px; margin-right: 5px;">' + groupedItemTitle + '</label>';			

			return content;
		}catch(e){
			showErrorMessage("prepareRetrievedGroupedItemsDisplay", e);
		}
	}

	function setRowObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				row.toggleClassName("selectedRow");

				var rowCount 	= ($$("div#accidentRetGrpItemsTable div[name='rowRetrievedGrpItems']")).length;
				var rowSelected	= ($$("div#retrievedGroupedItemsListing .selectedRow")).length;
				
				if(rowCount == rowSelected){
					$("radioRetAllGroupedItems").checked = true;
				}else if(rowCount > rowSelected){
					$("radioRetSelectGroupedItems").checked = true;
				}else{
					$("radioRetAllGroupedItems").checked = false;
					$("radioRetSelectGroupedItems").checked = false;
				}				
			});
		}catch(e){
			showErrorMessage("setRowObserver", e);
		}
	}

	function showRetrievedGroupedItems(){
		try{
			for(var i=0, length=objRetrievedGIPIGroupedItems.length; i < length; i++){
				var obj = objRetrievedGIPIGroupedItems[i];
				var content = prepareRetrievedGroupedItemsDisplay(obj);
				var row = new Element("div");
				var rowId = obj.itemNo.toString().concat(obj.groupedItemNo);

				row.setAttribute("id", "rowRetrievedGrpItems" + rowId);
				row.setAttribute("name", "rowRetrievedGrpItems");
				row.setAttribute("policyId", obj.policyId);
				row.setAttribute("item", obj.itemNo);
				row.setAttribute("grpItem", obj.groupedItemNo);
				row.addClassName("tableRow");				

				row.update(content);

				setRowObserver(row);

				if(i == 0){
					row.toggleClassName("selectedRow");
					$("radioRetSelectGroupedItems").checked = true;
				}

				$("retrievedGroupedItemsListing").insert({bottom : row});				
			}
		}catch(e){
			showErrorMessage("showRetrievedGroupedItems", e);
		}
	}

	$("radioRetSelectGroupedItems").observe("click", function(){
		var rowCount 	= ($$("div#accidentRetGrpItemsTable div[name='rowRetrievedGrpItems']")).length;
		var rowSelected	= ($$("div#retrievedGroupedItemsListing .selectedRow")).length;

		if(rowCount == rowSelected){
			($$("div#accidentRetGrpItemsTable div[name='rowRetrievedGrpItems']")).invoke("removeClassName", "selectedRow");
			if($("retrievedGroupedItemsListing").down("div", 0) != null){				
				$("retrievedGroupedItemsListing").down("div", 0).addClassName("selectedRow");
			}
		}
	})

	$("radioRetAllGroupedItems").observe("click", function(){
		($$("div#accidentRetGrpItemsTable div[name='rowRetrievedGrpItems']")).invoke("addClassName", "selectedRow");
	});

	$("btnOkPopRetGrpItems").observe("click", function(){
		var groupedItemNos = [];
		
		($$("div#accidentRetGrpItemsTable .selectedRow")).each(function(row){
			groupedItemNos.push(row.getAttribute("grpItem"));			
		});

		var tempArr = [];
		var tempObj = null;
		for(var i=0, length=groupedItemNos.length; i < length; i++){

			tempObj = (objRetrievedGIPIGroupedItems.filter(function(obj){	return obj.groupedItemNo == groupedItemNos[i];	}))[0];
			
			if(tempObj != null){
				tempObj.parId = objUWParList.parId;
				tempObj.deleteSw = nvl(tempObj.deleteSw, "N");
				tempObj.dateOfBirth = tempObj.dateOfBirth != null ? dateFormat(tempObj.dateOfBirth, "mm-dd-yyyy") : null;
				tempObj.fromDate = tempObj.fromDate != null ? dateFormat(tempObj.fromDate, "mm-dd-yyyy") : null;
				tempObj.toDate = tempObj.toDate != null ? dateFormat(tempObj.toDate, "mm-dd-yyyy") : null;
				tempObj.recordStatus = 0;
				tempArr.push(tempObj);
				
				showAccidentGroupedItemsList(tempArr);				
				objGIPIWGroupedItems.push(tempObj);
				tempObj = null;
				tempArr = [];
			}

			tempObj = (objRetrievedGIPIItmPerilGrouped.filter(function(obj){	return obj.groupedItemNo == groupedItemNos[i];	}))[0];
			if(tempObj != null){
				//tempObj.parId = objUWParList.parId;
				//tempObj.recordStatus = 0;

				//tempArr.push(tempObj);
				
				tempArr = (objRetrievedGIPIItmPerilGrouped.filter(function(obj){	return obj.groupedItemNo == groupedItemNos[i];	}));
				for(var c=0; c<tempArr.length; c++){
					tempArr[c].parId = objUWParList.parId;
					tempArr[c].tsiAmt = null;
					tempArr[c].premAmt = null;
					tempArr[c].origAnnTsiAmt = tempArr[c].annTsiAmt;
					tempArr[c].origAnnPremAmt = tempArr[c].annPremAmt; 
					tempArr[c].recordStatus = 0;
					objGIPIWItmperlGrouped.push(tempArr[c]);
				}
				showCoverageList(tempArr);
				tempObj = null;
			}
			
			tempArr = [];

			tempObj = (objRetrievedGIPIGrpItemsBeneficiary.filter(function(obj){	return obj.groupedItemNo == groupedItemNos[i];	}))[0];
			if(tempObj != null){
				tempObj.parId = objUWParList.parId;
				tempObj.dateOfBirth = tempObj.dateOfBirth != null ? dateFormat(tempObj.dateOfBirth, "mm-dd-yyyy") : null;
				tempObj.recordStatus = 0;

				tempArr.push(tempObj);
				showEnrolleeBeneficiary(tempArr);				
				objGIPIWGrpItemsBeneficiary.push(tempObj);
				tempObj = null;
				tempArr = [];
			}
		}

		if(groupedItemNos.length > 0){			
			resizeTableBasedOnVisibleRows("accidentGroupedItemsTable", "accidentGroupedItemsListing");			

			cascadeAccidentGroup(objGIPIWItmperlGrouped, "coverageTable", "coverageListing", null, null);
			cascadeAccidentGroup(objGIPIWGrpItemsBeneficiary, "bBeneficiaryTable", "bBeneficiaryListing", null, null);
			//cascadeAccidentGroup(objGIPIWItmperlBeneficiary, "benPerilTable", "benPerilListing", null, null);
			changeTag = 1;
		}		

		showWaitingMessageBox("Grouped Items Retrieval Finished Successfully", imgMessage.INFO, function(){	overlatAccidentRetrieveGroupedItems.close();});
	});

	showRetrievedGroupedItems();
</script>