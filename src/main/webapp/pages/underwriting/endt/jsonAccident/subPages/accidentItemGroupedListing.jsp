<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- <div id="spinLoadingDiv"></div>  -->
<div style="width: 100%;">
	<div style="margin: 10px;" id="accidentGroupedItemsTable" name="accidentGroupedItemsTable">	
		<div class="tableHeader" style="margin-top: 5px; font-size: 10px;">
			<label style="text-align: right; width: 20px; margin-right: 2px;">&nbsp;</label>
			<label style="text-align: left; width: 100px; margin-right: 2px;">Enrollee Code</label>
			<label style="text-align: left; width: 210px; margin-right: 2px;">Enrollee Name</label>
			<label style="text-align: left; width: 100px; margin-right: 0px;">Principal Code</label>
			<label style="text-align: left; width: 100px; margin-right: 4px;">Plan</label>
			<label style="text-align: left; width: 100px; margin-right: 2px;">Payment Mode</label>
			<label style="text-align: left; width: 100px; margin-right: 2px;">Effectivity Date</label>
			<label style="text-align: left; width: 100px;">Expiry Date</label>				
		</div>		
		<div class="tableContainer" id="accidentGroupedItemsListing" name="accidentGroupedItemsListing">			
		</div>
	</div>
</div>		
		
<script type="text/javascript">
	/*
	objGIPIWGroupedItems = [];
	//objGIPIWGroupedItems = eval(('${objGIPIWGroupedItems}').replace(/&#62;/g, ">")).replace(/&#60;/g, "<");
	objGIPIWGroupedItems = JSON.parse('${objGIPIWGroupedItems}'.replace(/\\/g, '\\\\'));

	function prepareAccGroupedItemsDisplay(obj){
		try{

		}catch(e){
			showErrorMessage("prepareAccGroupedItemsDisplay", e);
		}
	}

	function showAccidentGroupedItems(){
		try{			
			for(var i=0, length=objGIPIWGroupedItems.length; i < length; i++){
				var content = prepareAccGroupedItemsDisplay(objGIPIWGroupedItems[i]);
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowGroupedItems"+objGIPIWGroupedItems[i].itemNo);
				newDiv.setAttribute("name", "rowGroupedItems");				
				newDiv.setAttribute("item", objArray[i].itemNo);
				newDiv.addClassName("tableRow");				
				
				newDiv.update(content);
				$("accidentGroupedItemsListing").insert({bottom : newDiv});						
			}
			
			checkIfToResizeTable("accidentGroupedItemsListing", "rowGroupedItems");
			checkTableIfEmpty("rowGroupedItems", "accidentGroupedItemsTable");			
		}catch(e){
			showErrorMessage("showAccidentGroupedItems", e);
		}
	}
	*/
	
	$$("label[name='textG']").each(function (label)    {
   		if ((label.innerHTML).length > 10)    {
        	label.update((label.innerHTML).truncate(10, "..."));
    	}
	});
	$$("label[name='textG2']").each(function (label)    {
   		if ((label.innerHTML).length > 15)    {
        	label.update((label.innerHTML).truncate(15, "..."));
    	}
	});
	$$("label[name='textG3']").each(function (label)    {
		if (label.innerHTML != "---"){
        	label.update((label.innerHTML).truncate(1, "..."));
    	}
	});
	$$("label[id='num']").each(function (label)    {
		if (label.innerHTML != "---"){
        	label.update(formatNumberDigits(label.innerHTML,7));
		}
	});
	$$("div[name='grpItem']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowGroupedItems"+$F("itemNo")+formatNumberDigits(no,7));
	});
		
</script>	