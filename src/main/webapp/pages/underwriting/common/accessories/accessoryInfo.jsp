<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="accessoryTable" name="accessoryTable" style="width : 100%;">
	<div id="accessoryTableGridSectionDiv" class="">
		<div id="accessoryTableGridDiv" style="padding: 10px;">
			<div id="accessoryTableGrid" style="height: 0px; width: 900px;"></div>
		</div>
	</div>	
</div>

<table align="center" border="0" id="maintainAccForm">
	<tr>
		<td class="rightAligned">Accessory Name</td>
		<td class="leftAligned">				
			<div style="float: left; border: solid 1px gray; width: 362px; height: 21px; margin-right: 3px;" class="required">
				<input type="hidden" id="accessoryCd" name="accessoryCd" />
				<input type="text" tabindex="5001" style="float: left; margin-top: 0px; margin-right: 3px; width: 335px; border: none;" name="accessoryDesc" id="accessoryDesc" readonly="readonly" class="required" />
				<img id="hrefAccessory" alt="goAccessory" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
			</div>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" for="accessoryAmount">Amount</td>
		<td class="leftAligned">
			<!-- 
			<input tabindex="5002" id="accessoryAmount" name="accessoryAmount" type="text" value="" class="money" style="width: 356px;" maxlength="13" min="0.00" max="9999999999.99" errorMsg="Entered Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99" />
			 -->	
			<input tabindex="5002" id="accessoryAmount" name="accessoryAmount" type="text" value="" class="applyDecimalRegExp" regExpPatt="pDeci1002" style="width: 356px;" maxlength="13" min="0.00" max="9999999999.99" />
		</td>
	</tr>
</table>
<table align="center">
	<tr>
		<td colspan="2" style="text-align:center;">
			<input tabindex="5003" type="button" class="button" 		id="btnAddA" 	name="btnAddA" 		value="Add" />
			<input tabindex="5004" type="button" class="disabledButton" id="btnDeleteA" name="btnDeleteA" 	value="Delete" />
		</td>
	</tr>
</table>

<script type="text/javascript">
try{
	function selectAccessory(){
		try{
			var notIn = "";
			var withPrevious = false;			

			var objArrFiltered = objGIPIWMcAcc.filter(function(obj){	return parseInt(obj.itemNo) == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	});

			for(var i=0, length=objArrFiltered.length; i < length; i++){			
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objArrFiltered[i].accessoryCd + "'";
				withPrevious = true;
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			
			showAccessoryLOV(notIn);
		}catch(e){
			showErrorMessage("selectAccessory", e);
		}
	}
	
	$("hrefAccessory").observe("click", function(){
		if(objCurrItem != null){					
			selectAccessory();
		}else{
			showMessageBox("Please select an item first.", imgMessage.INFO);
			return false;
		}
	});

	function setAccessory(){
		try{
			var newObj = new Object();

			newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo			= $F("itemNo");
			newObj.accessoryCd		= $F("accessoryCd");
			newObj.accessoryDesc	= $F("accessoryDesc");
			newObj.accAmt			= $F("accessoryAmount").empty() ? null : formatCurrency($F("accessoryAmount")).replace(/,/g, "");
			newObj.userId			= $F("userId");

			return newObj;
		}catch(e){
			showErrorMessage("setAccessory", e);
		}
	}

	function addAccessory(){
		try{
			var newObj = setAccessory();

			if($F("btnAddA") == "Update"){									
				addModedObjByAttr(objGIPIWMcAcc, newObj, "accessoryCd");							
				tbgAccessory.updateVisibleRowOnly(newObj, tbgAccessory.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objGIPIWMcAcc, newObj);				
				tbgAccessory.addBottomRow(newObj);													
			}

			setAccessoryFormTG(null);
			($$("div#accessory [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgAccessory);	
		}catch(e){
			showErrorMessage("addAccessory", e);
		}
	}
	
	$("btnAddA").observe("click", function(){
		if(objCurrItem == null){
			showMessageBox("Please select an item first.", imgMessage.INFO);
			return false;					
		}

		if($F("accessoryDesc").blank() && $F("accessoryCd").blank()){
			showMessageBox("Accessory name required.", imgMessage.ERROR);
			return false;			
		}

		addAccessory();	
	});

	function deleteAccessory(){
		try{
			var delObj = setAccessory();
			addDelObjByAttr(objGIPIWMcAcc, delObj, "accessoryCd");			
			tbgAccessory.deleteVisibleRowOnly(tbgAccessory.getCurrentPosition()[1]);
			setAccessoryFormTG(null);
			updateTGPager(tbgAccessory);
		}catch(e){
			showErrorMessage("deleteAccessory", e);
		}
	}

	$("btnDeleteA").observe("click", function(){
		if(objCurrItem == null){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}

		deleteAccessory();
	});
	
	setAccessoryFormTG(null);
}catch(e){
	showErrorMessage("Accessory Page", e);
}	
</script>