<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="leadPolicyMainDiv">
	<form id="leadPolForm">
		<div id="message" style="display:none;">${message}</div>
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv"	name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label>Lead Policy Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="leadPolItemTableDiv" name="leadPolItemTableDiv" class="sectionDiv">
			<input type="hidden" id="selectedItemNo" name="selectedItemNo" value=""/>
			<div style="width: 60%; margin: 10px 20%;" align="center">
				<div id="leadPolItemsTableHeader" class="tableHeader">
					<label style="width: 25%; text-align: left; margin-left: 5px;">Item No.</label>
					<label style="width: 70%;">Item Title</label>
				</div>
				<div id="leadPolItemsContainer" class="tableContainer">
					<c:forEach var="item" items="${items}">
						<div id="leadPolRow${item.parId}${item.itemNo}" class="tableRow" name="leadPolItemRow" itemNo="${item.itemNo}">
							<label style="width: 25%; text-align: left; margin-left: 5px;"><fmt:formatNumber value="${item.itemNo}" pattern="000000000"/></label>
							<label style="width: 70%; text-align: left;">${item.itemTitle}</label>
							<input type="hidden" id="lpTsiAmt${item.parId}${item.itemNo}" value="${item.tsiAmt}"/>
							<input type="hidden" id="lpPremAmt${item.parId}${item.itemNo}" value="${item.premAmt}"/>
							<input type="hidden" id="lpCurrDesc${item.parId}${item.itemNo}" value="${item.currencyDesc}"/>
						</div>
					</c:forEach>
				</div>
			</div>
			<div id="leadPolSectionDiv" class="sectionDiv" style="border-left: none; border-right: none;">
				<div id="leadPolDiv1" class="sectionDiv" style="width: 49.78%; float: left; padding: 0; border-bottom: none; border-left: none; border-top: none">
					<input type="hidden" id="lpShareRate" name="lpShareRate" value="${rate}">
					<table width="100%" cellspacing="1" cellpadding="5px 0">
						<tr>
							<td colspan="4" align="center" style="font-weight: bolder; padding-top: 10px;">Your Share ${dspRate}</td>
						</tr>
						<tr>
							<td class="rightAligned">TSI:</td>
							<td class="leftAligned"><input type="text" id="compShareTsiAmt" readonly="readonly" class="money"/></td>
							<td class="rightAligned">Premium:</td>
							<td class="leftAligned"><input type="text" id="compSharePremAmt" readonly="readonly" class="money"/></td>
						</tr>
						<tr>
							<td colspan="4" style="font-weight: bolder; padding-left: 10%;" id="compShareCurrDesc"></td>
						</tr>
					</table>
				</div>
				<div id="leadPolDiv2" style="width: 49.78%; float: left; padding: 0;">
					<table width="100%" cellspacing="1" cellpadding="5px 0">
						<tr>
							<td colspan="4" align="center" style="font-weight: bolder; padding-top: 10px;">Full Share (100%)</td>
						</tr>
						<tr>
							<td class="rightAligned">TSI:</td>
							<td class="leftAligned"><input type="text" id="fullShareTsiAmt" readonly="readonly"  class="money"/></td>
							<td class="rightAligned">Premium:</td>
							<td class="leftAligned"><input type="text" id="fullSharePremAmt" readonly="readonly" class="money"/></td>
						</tr>
						<tr>
							<td colspan="4" style="font-weight: bolder; padding-left: 10%;" id="fullShareCurrDesc"></td>
						</tr>
					</table>
				</div>
			</div>
			<div id="leadPolicyPerilDiv1" style="width: 100%; border: none;;" class="sectionDiv"></div>
			<div id="leadPolPerilDiv" style="padding: 10px 0; margin-top: 10px;" align="center">
				<table cellspacing="1" style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Peril Description</td>
						<td colspan="5" class="leftAligned"><input id="perilDescLbl" type="text" style="width: 500px;" readonly="readonly"></td>
						<td rowspan="2" style="padding-left: 20px;"><input type="button" id="lpInvoiceBtn" value="Invoice" class="button"></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="5" class="leftAligned"><input id="perilRemarksLbl" type="text" style="width: 500px;" readonly="readonly"></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
	setModuleId("GIPIS154");
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	checkIfToResizeTable2("leadPolItemsContainer", "leadPolItemRow");
	var rate = nvl($("lpShareRate").value, 0);

	$$("div#leadPolItemTableDiv div[name='leadPolItemRow']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			clearShareTsiAndPremAmtFields();
			if(row.hasClassName("selectedRow")){
				$$("div#leadPolItemTableDiv div[name='leadPolItemRow']").each(function(r){
					if(row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}
				});
				populateShareTsiAndPremAmt(row);
				showTableGridRowsPerItem(lpPerilTableGrid, row);
				showTableGridRowsPerItem(lpPerilTableGrid2, row);
			}
		});
	});

	$("lpInvoiceBtn").observe("click", function(){
		Modalbox.show(contextPath+"/GIPILeadPolicyController?action=showLeadPolicyInvoiceModal&parId="+$F("globalParId"), {
			title: "Invoice Information",
			width: 935,
			asynchronous:false,
			height: 580
		});
	});

	function populateShareTsiAndPremAmt(row){
		$("compShareTsiAmt").value = formatCurrency(row.down("input", 0).value);
		$("compSharePremAmt").value = formatCurrency(row.down("input", 1).value);
		$("compShareCurrDesc").innerHTML = row.down("input", 2).value;
		$("fullShareCurrDesc").innerHTML = row.down("input", 2).value;
		$("fullShareTsiAmt").value = (rate != 0 ? formatCurrency(nvl(row.down("input", 0).value, 0) * 100/rate) : "");
		$("fullSharePremAmt").value =(rate != 0 ? formatCurrency(nvl(row.down("input", 1).value, 0) * 100/rate) : "");
		$("selectedItemNo").value = row.getAttribute("itemNo");
	}

	function clearShareTsiAndPremAmtFields(){
		$("compShareTsiAmt").value = "";
		$("compSharePremAmt").value = "";
		$("compShareCurrDesc").innerHTML = "";
		$("fullShareCurrDesc").innerHTML = "";
		$("fullShareTsiAmt").value = "";
		$("fullSharePremAmt").value = "";
		$("perilDescLbl").value = "";
		$("perilRemarksLbl").value = "";
		$("selectedItemNo").value = "";
		hideAllTableGridRows(lpPerilTableGrid);
		hideAllTableGridRows(lpPerilTableGrid2);
	}

	function showTableGridRowsPerItem(tableGrid, row){
		var itemNo = row.getAttribute("itemNo");
		var id = tableGrid._mtgId;
		var rows = tableGrid.rows;
		var x = tableGrid.getColumnIndex('itemNo');

		var ctr = 0;
		for (y = 0; y < rows.length; y++) {
			var itemNum = tableGrid.getValueAt(x, y);
			$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
			if(itemNum == itemNo){
				$('mtgRow'+id+'_'+y).show();
				ctr++;
				if(ctr==1){
					tableGrid.selectRow(y);
					fireEvent($('mtgC'+id+'_'+x+','+ y), 'click');
				}
			}
		}
		removeTableGridCellClassSelectedRow(tableGrid);
	}

</script>