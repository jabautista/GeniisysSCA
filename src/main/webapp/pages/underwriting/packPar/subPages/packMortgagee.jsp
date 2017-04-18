<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packMortgageeMainDiv">
	<div id="packSubPoliciesDiv" style="margin: 200px; margin-bottom: 5px; margin-top: 5px; padding: 10px;">
		<div id="packSubPoliciesHeader" class="tableHeader">
			<label style="width: 90%; text-align: left; margin-left: 5px;">Par No.</label>
		</div>
		<div id="packSubPoliciesContainer" class="tableContainer">
			<c:forEach var="pol" items="${policies}">
				<div id="row${pol.parId}" class="tableRow" name="policies" parId="${pol.parId}">
					<label style="width: 90%; text-align: left; margin-left: 5px;">${pol.parNo}</label>
				</div>
			</c:forEach>
		</div>
	</div>
	
	<div id="packMortgageeDiv" changeTagAttr="true">
		<jsp:include page="/pages/underwriting/subPages/mortgageeTable.jsp"></jsp:include>
		<table align="center" id="packMortgageeForm" border="0">
		<tr>
			<td class="rightAligned" style="width: 100px;">Mortgagee Name</td>
			<td class="leftAligned">
				<input type="text" id="txtMortgageeName" name="txtMortgageeName" class="required" readonly="readonly" style="width: 356px; height: 13px;" />					
				<select id="mortgageeName" name="mortgageeName" style="width: 365px;" class="required">
					<option value=""></option>
					<c:forEach var="mortgageeListing" items="${mortgageeListing}">
						<option value="${fn:replace(mortgageeListing.mortgCd, ' ', '_')}">${mortgageeListing.mortgName}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Amount </td>
			<td class="leftAligned"><input id="mortgageeAmount" type="text" class="money2" maxlength="17" style="width: 356px;" min="0.00" max="99999999999999.99" errorMsg="Invalid Mortgagee amount. Value should be from 0.00 to 99,999,999,999,999.99" /></td>
		</tr>
		<tr align="center">
			<td colspan="2" style="text-align: center;">
				<input id="btnAddMortgagee" name="btnAddMortgagee" type="button" class="button" value="Add" style="width: 60px;" />
				<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" type="button" class="disabledButton" value="Delete" style="width: 60px;" />
			</td>
		</tr>
	</table>
	</div>
</div>
<script type="text/javascript">
	var mortgLevel = $F("mortgageeLevel");
	var selectedPolicy = "";
	objMortgagees = null;
	objMortgagees = JSON.parse('${objMortgagees}');		
	
	setPackMortgageeList();
	hideAllMortgagees();
	setMortgageeForm(null);
	/*checkPopupsTableWithTotalAmount("mortgageeTable", "mortgageeListing", "rowMortg",
									  "mortgageeTotalAmountDiv", "mortgageeTotalAmount", 2);*/
	checkPopupsTableWithTotalAmountbyObjectWithCond(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
			"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "parId", "");
	checkPopupsTable("packSubPoliciesDiv", "packSubPoliciesContainer", "policies");
	initializeAll();
	initializeAllMoneyFields();
	addStyleToInputs();
	initializeChangeTagBehavior(changeTagFunc);

	$$("div[name='policies']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			setMortgageeForm(null);
			if (row.hasClassName("selectedRow")){				
				($$("div#packSubPoliciesContainer div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				selectedPolicy = row.getAttribute("parId");
				showMortgageePerPolicy(row);
			}else{										
				hideAllMortgagees();
			}
		});
	});

	$("btnAddMortgagee").observe("click", function(){
		if($F("mortgageeName").blank()){
			showMessageBox("Mortgagee name required.", imgMessage.ERROR);
			return false;
		}
		addPackMortgagee();
	});

	$("btnDeleteMortgagee").observe("click", function(){
		deletePackMortgagee();
	});

	function showMortgageePerPolicy(row){
		try{
		$$("div[name='rowMortg']").each(function(rowMortg){
			rowMortg.removeClassName("selectedRow");
			if(row.getAttribute("parId") != rowMortg.getAttribute("parId")){
				rowMortg.hide();
			}else{
				rowMortg.show();
			}
		});
		filterLOV3("mortgageeName", "rowMortg", "mortgCd", "parId", row.getAttribute("parId"));
		/*checkPopupsTableWithTotalAmount("mortgageeTable", "mortgageeListing", "rowMortg",
				"mortgageeTotalAmountDiv", "mortgageeTotalAmount", 2);*/
		checkPopupsTableWithTotalAmountbyObjectWithCond(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
				"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "parId", row.getAttribute("parId"));
		}catch(e){
			showErrorMessage("showMortgageePerPolicy", e);
		}
	}

	function hideAllMortgagees(){
		$$("div[name='rowMortg']").each(function(rowMortg){
			rowMortg.removeClassName("selectedRow");
			rowMortg.hide();
		});
		hideAllMortgageeOptions();
		/*checkPopupsTableWithTotalAmount("mortgageeTable", "mortgageeListing", "rowMortg",
				"mortgageeTotalAmountDiv", "mortgageeTotalAmount", 2);*/
		checkPopupsTableWithTotalAmountbyObjectWithCond(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
				"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "parId", "");
	}

	function hideAllMortgageeOptions(){
		$("mortgageeName").childElements().each(function(o){
			o.hide(); o.disabled = true;
		});
	}

	function setMortgagee(){
		try{
			var newObj = new Object();
			newObj.parId		= selectedPolicy;
			newObj.itemNo		= "0";
			newObj.mortgCd		= ($F("mortgageeName")).replace(/ /g, "_");
			newObj.mortgName	= ($("mortgageeName").options[$("mortgageeName").selectedIndex].text);
			newObj.amount		= $F("mortgageeAmount").empty() ? null : formatCurrency($F("mortgageeAmount").replace(/,/g, ""));
			newObj.issCd		= objUWGlobal.issCd;
			newObj.userId		= userId;
			
			return newObj;
		}catch(e){
			showErrorMessage("setMortgagee", e);
		}
	}

	function addPackMortgagee(){
		try{			
			var obj 	= setMortgagee();
			var content = prepareMortgagee(obj);			
			
			if($F("btnAddMortgagee") == "Update"){				
				$("rowMortg" + obj.parId + "_" + obj.itemNo + "_" + obj.mortgCd).update(content);
				$("rowMortg" + obj.parId + "_" + obj.itemNo + "_" + obj.mortgCd).removeClassName("selectedRow");								
				addModedObjByAttr(objMortgagees, obj, "mortgCd");
				/*checkPopupsTableWithTotalAmount("mortgageeTable", "mortgageeListing", "rowMortg",
						"mortgageeTotalAmountDiv", "mortgageeTotalAmount", 2);*/
				checkPopupsTableWithTotalAmountbyObjectWithCond(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
						"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "parId", obj.parId);
			}else{
				var table 	= $("mortgageeListing");
				var newDiv 	= new Element("div");
				
				newDiv.setAttribute("id", "rowMortg" + obj.parId + "_" + obj.itemNo + "_" + obj.mortgCd);
				newDiv.setAttribute("name", "rowMortg");
				newDiv.setAttribute("parId", obj.parId);
				newDiv.setAttribute("item", obj.itemNo);
				newDiv.setAttribute("mortgCd", obj.mortgCd);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				table.insert({bottom : newDiv});
				
				loadPackMortgageeRowObserver(newDiv);
				
				new Effect.Appear("rowMortg" + obj.parId + "_" + obj.itemNo + "_" + obj.mortgCd, {
					duration : 0.2
				});

				addNewJSONObject(objMortgagees, obj);
				
				showMortgageePerPolicy($("row"+obj.parId));
			}			
			setMortgageeForm(null);
	
		}catch(e){
			showErrorMessage("addPackMortgagee", e);
		}		
	}

	function deletePackMortgagee(){
		try{			
			$$("div#mortgageeTable .selectedRow").each(function(row){				
				Effect.Fade(row, {
					duration : .3,
					afterFinish : function(){
						var delObj = setMortgagee();														
						addDelObjByAttr(objMortgagees, delObj, "mortgCd");							
						row.remove();
						setMortgageeForm(null);
						filterLOV3("mortgageeName", "rowMortg", "mortgCd", "parId", delObj.parId);
						/*checkPopupsTableWithTotalAmount("mortgageeTable", "mortgageeListing", "rowMortg",
								"mortgageeTotalAmountDiv", "mortgageeTotalAmount", 2);*/
						checkPopupsTableWithTotalAmountbyObjectWithCond(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
								"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "parId", delObj.parId);
					}
				});				
			});
		}catch(e){
			showErrorMessage("deletePackMortgagee", e);
		}
	}
		
</script>