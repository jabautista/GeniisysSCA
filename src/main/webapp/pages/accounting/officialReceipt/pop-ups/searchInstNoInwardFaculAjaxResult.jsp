<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div id="tableInwFaculHeader" class="tableHeader">
		<label style="width: 48%; margin-right: 5px; ">Bill No.</label>
		<label style="width: 48%; ">Installment No.</label>
	</div>
	<div style="height:270px; overflow:auto;">
		<c:if test="${empty searchResult}">
			<div id="rowInwFaculInstNoList" name="rowInwFaculInstNoList" class="tableRow">No records available</div>
		</c:if>
		<c:forEach var="instNo" items="${searchResult}">
			<div id="rowInwFaculInstNoList${instNo.instNo}${instNo.b140PremSeqNo}${instNo.issCd}${instno.riCd}" name="rowInwFaculInstNoList" class="tableRow" style="padding: 1px; padding-top: 5px;">
				<label name="billNoInwText" style="width: 48%; margin-right: 5px; ">${empty instNo.issCd ? '---' :instNo.issCd }-<fmt:formatNumber pattern="00000000">${instNo.b140PremSeqNo }</fmt:formatNumber></label>
				<label name="instNoInwText" style="width: 48%; ">${empty instNo.instNo ? '---' :instNo.instNo}</label>
				
				<input type="hidden" id="instNoInstNoList" 			name="instNoInstNoList" 		 value="${instNo.instNo}"/>
				<input type="hidden" id="b140PremSeqNoInstNoList" 	name="b140PremSeqNoInstNoList" 	 value="${instNo.b140PremSeqNo}"/>
				<input type="hidden" id="issCdInstNoList" 			name="issCdInstNoList" 			 value="${instNo.issCd}"/>
				<input type="hidden" id="riCdInstNoList" 			name="riCdInstNoList" 			 value="${instno.riCd}"/>
				<input type="hidden" id="collectionAmtInstNoList" 	name="collectionAmtInstNoList"   value="${instNo.collectionAmt}"/>
				<input type="hidden" id="premiumAmtInstNoList" 		name="premiumAmtInstNoList" 	 value="${instNo.premiumAmt}"/>
				<input type="hidden" id="premTaxInstNoList" 		name="premTaxInstNoList" 		 value="${instNo.premTax}"/>
				<input type="hidden" id="wholdingTaxInstNoList" 	name="wholdingTaxInstNoList" 	 value="${instNo.wholdingTax}"/>
				<input type="hidden" id="commAmtInstNoList" 		name="commAmtInstNoList" 		 value="${instNo.commAmt}"/>
				<input type="hidden" id="foreignCurrAmtInstNoList"  name="foreignCurrAmtInstNoList"  value="${instNo.foreignCurrAmt}"/>
				<input type="hidden" id="taxAmountInstNoList" 		name="taxAmountInstNoList" 	     value="${instNo.taxAmount}"/>
				<input type="hidden" id="commVatInstNoList" 		name="commVatInstNoList" 		 value="${instNo.commVat}"/>
			</div>			
		</c:forEach>
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="instNoInwardFaculPage" name="instNoInwardFaculPage">
		<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
			<option value="${i}"
				<c:if test="${pageNo==i}">
					selected="selected"
				</c:if>
			>${i}</option>
		</c:forEach>
	</select> of ${noOfPages}
</div>
<script type="text/javascript">
	//when PAGE change
	$("instNoInwardFaculPage").observe("change",function(){
		searchInstNoInwardModal($("instNoInwardFaculPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowInwFaculInstNoList]").each(function(row){
		row.observe("mouseover",function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout",function(){
			row.removeClassName("lightblue");
		});
		row.observe("click",function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$("selectedClientId").value = row.getAttribute("id").substring(3);
				$$("div[name=rowInwFaculInstNoList]").each(function(li){
					if (row.getAttribute("id") != li.getAttribute("id")){
						li.removeClassName("selectedRow");
					}
				});
			}else{
				null;
			}		
		});
	});

	//truncate the label text
	$$("label[name='billNoInwText']").each(function (lbl){
		lbl.update((lbl.innerHTML).truncate(20, "..."));
	});
	$$("label[name='instNoInwText']").each(function (lbl){
		lbl.update((lbl.innerHTML).truncate(20, "..."));
	});
	
	if ($$("div[name=rowInwFaculInstNoList]").size() > 10){
		$("tableInwFaculHeader").setStyle("padding-right: 18px");
	}
</script>