<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="contentDiv">
	<input type="hidden" id="issCd" value="${issCd}" />
	<input type="hidden" id="premSeqNo" value="${premSeqNo}" />
	<div id="instNoTableDiv">
		<div class="tableHeader">
			<label style="width: 32%; text-align: left; margin-left: 4px;">Issue Code</label>
			<label style="width: 32%; text-align: left; margin-left: 2px;">Bill No</label>
			<label style="width: 32%; text-align: left; margin-left: 2px;">Installment No</label>
		</div>
		<div class="tableContainer">
			<c:forEach var="inst" items="${gipiInstListing}">
				<div id="instRow${inst.instNo}" name="row" class="tableRow">
					<label style="width: 32%; text-align: left; margin-left: 4px;" id="issCd${inst.instNo}" name="instRowIssCd">${inst.issCd}</label>
					<label style="width: 32%; text-align: left; margin-left: 2px;" id="premSeqNo${inst.instNo}" name="instRowPremSeqNo">${inst.premSeqNo}</label>
					<label style="width: 32%; text-align: left; margin-left: 2px;" id="instNo${inst.instNo}" name="instRowInstNo">${inst.instNo}</label>
				</div>
			</c:forEach>
		</div>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="instListPager">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
</div>
<script>
	var product = 288 - (parseInt($$("div[name='row']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");
	
	$$("div[name='row']").each(function (row){
		row.observe("mouseover", function (){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function (){
			row.removeClassName("lightblue");
		});
	
		row.observe("click", function (){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div[name='row']").each(function (i){
					if (row.id != i.id){
						i.removeClassName("selectedRow");
					}
				});
			}
		});
		
		row.observe("dblclick", function (){
			Modalbox.hide();
			var instNo = row.down("label", 2).innerHTML;
			getPDCDetails($F("issCd"), $F("premSeqNo"), instNo);
		});
	});
	
	$("instListPager").observe("change", function(){
		reloadInstList($F("instListPager"), $F("issCd"), $F("premSeqNo"));
	});

	function getPDCDetails(issCd, premSeqNo, instNo){
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=getPdcPremDtls",{
			method: "POST",
			parameters: {
				issCd: issCd,
				premSeqNo: premSeqNo,
				instNo: instNo
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){

			},
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					var tempValuesObject = JSON.parse(response.responseText);
					fillPDCPremCollnDtlsTableGrid(tempValuesObject);
				}
			}
		});
	}

	function fillPDCPremCollnDtlsTableGrid(pdcObj){
		postDatedCheckDetailsTableGrid.setValueAt(parseInt(nvl(pdcObj.premSeqNo, 0)).toPaddedString(12),postDatedCheckDetailsTableGrid.getIndexOf('premSeqNo'),selectedPDCDtlsIndex,true);
		postDatedCheckDetailsTableGrid.setValueAt(parseInt(nvl(pdcObj.instNo, 0)).toPaddedString(2),postDatedCheckDetailsTableGrid.getIndexOf('instNo'),selectedPDCDtlsIndex,true);
		postDatedCheckDetailsTableGrid.setValueAt(formatCurrency(pdcObj.collnAmt), postDatedCheckDetailsTableGrid.getIndexOf('collnAmt'),selectedPDCDtlsIndex,true);
		postDatedCheckDetailsTableGrid.setValueAt(formatCurrency(pdcObj.premiumAmt), postDatedCheckDetailsTableGrid.getIndexOf('premAmt'),selectedPDCDtlsIndex,true);
		postDatedCheckDetailsTableGrid.setValueAt(formatCurrency(pdcObj.taxAmt), postDatedCheckDetailsTableGrid.getIndexOf('taxAmt'),selectedPDCDtlsIndex,true);

		$("dtlsAmount").value = collectionAmount;
	}
</script>
