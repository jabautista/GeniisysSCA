<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="lpItemGrpSectionDiv" name="lpItemGrpSectionDiv">
	<div style="margin : 10px;" id="lpItemGrpTable" name="lpItemGrpTable">
		<div class="tableHeader">
			<label style="width: 130px; text-align: left; margin-left: 5px;">Item Group</label>
			<label style="width: 300px; text-align: left;">Name</label>
			<label style="width: 330px; text-align: left;">Property / Item</label>			
		</div>
		<div id="lpItemGrpTableContainer" class="tableContainer">
			<c:forEach var="itemGrp" items="${list}">
				<div id="lpItemGrpRow${itemGrp.itemGrp}" class="tableRow" name="lpItemGrpRow" itemGrp="${itemGrp.itemGrp}">
					<label style="width: 130px; text-align: left; margin-left: 5px;"><fmt:formatNumber value="${itemGrp.itemGrp}" pattern="000000000"/></label>
					<label style="width: 300px; text-align: left;">${itemGrp.insured}</label>
					<label style="width: 330px; text-align: left;">${itemGrp.property}</label>
				</div>
			</c:forEach>			
		</div>
	</div>
</div>

<script type="text/javascript">

	objGipiWInvoice = JSON.parse('${gipiWInvoiceList}'.replace(/\\/g, '\\\\'));
	checkIfToResizeTable("lpItemGrpTableContainer", "lpItemGrpRow");
	initializeAllMoneyFields();

	$$("div#lpItemGrpSectionDiv div[name='lpItemGrpRow']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			resetLeadPolicyItemGrpDependentRecords();
			if(row.hasClassName("selectedRow")){
				$$("div#lpItemGrpSectionDiv div[name='lpItemGrpRow']").each(function(r){
					if(row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}
				});
				populateItemGrpDependentRecords(row);
			}
		});
	});

	function populateItemGrpDependentRecords(row){
		$("hidSelectedItemGrp").value = row.getAttribute("itemGrp");
		populateInvoiceInfoFields(row);
		if($("lpTaxesDiv").innerHTML != ""){
			showTableGridRowsPerItemGrp(lpTaxesTableGrid, row.getAttribute("itemGrp"));
			showTableGridRowsPerItemGrp(lpTaxesTableGrid2, row.getAttribute("itemGrp"));
		}
		if($("lpPerilDistDiv").innerHTML != ""){
			showTableGridRowsPerItemGrp(lpInvPerlTableGrid, row.getAttribute("itemGrp"));
			showTableGridRowsPerItemGrp(lpInvPerlTableGrid2, row.getAttribute("itemGrp"));
		}
		if($("lpInvCommDiv").innerHTML != ""){
			showTableGridRowsPerItemGrp(lpIntrmdryTableGrid, row.getAttribute("itemGrp"));
		}
	}

	function populateInvoiceInfoFields(row){
		for(i=0; i<objGipiWInvoice.length; i++){
			var inv = objGipiWInvoice[i];
			if(row.getAttribute("itemGrp") == inv.itemGrp){
				setLeadPolicyInvoiceFieldValues(inv);
			}
		}
	}

	function showTableGridRowsPerItemGrp(tableGrid, itemGrp){
		var id = tableGrid._mtgId;
		var rows = tableGrid.rows;
		var x = tableGrid.getColumnIndex('itemGrp');
		var firstRowId = "";

		var ctr = 0;
		for (y = 0; y < rows.length; y++) {
			var itemGroup = tableGrid.getValueAt(x, y);
			$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
			$('mtgRow'+id+'_'+y).hide();
			if(itemGrp == itemGroup){
				$('mtgRow'+id+'_'+y).show();
				ctr++;
				if(ctr == 1){
					firstRowId = 'mtgC'+id+'_'+x+','+ y;
				}
			}
		}

		if(firstRowId != "" && $(firstRowId) != null){
			fireEvent($(firstRowId), 'click');
		}
		removeTableGridCellClassSelectedRow(tableGrid);
		tableGrid.scrollTop = tableGrid.bodyDiv.scrollTop = 0;
	}

</script>
