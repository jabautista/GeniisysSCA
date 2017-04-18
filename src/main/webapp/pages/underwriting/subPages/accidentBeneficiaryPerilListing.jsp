<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="spinLoadingDiv"></div>
		<div style="margin:auto; margin-top:0px; width:75%;" id="benPerilTable" name="benPerilTable">	
			<div class="tableHeader" style="margin-top:5px;">
				<label style="text-align: left; width: 49%; margin-right: 10px;">Peril Name</label>
				<label style="text-align: right; width: 49%;">Tsi Amount</label>
			</div>
			
			<div class="tableContainer" id="benPerilListing" name="benPerilListing" style="display: block; margin:auto; ">
				<c:forEach var="benPeril" items="${gipiWItmperlBeneficiary}">
					<div id="rowBenPeril${benPeril.groupedItemNo}${benPeril.beneficiaryNo}" item="${benPeril.itemNo}" beneficiaryNo="${benPeril.beneficiaryNo }" groupedItemNo="${benPeril.groupedItemNo }" itemSeqNo="" name="benPeril" class="tableRow" style="padding-left:1px; margin:auto;">
						<input type="hidden" id="bpParIds" 		    	name="bpParIds" 	        value="${benPeril.parId }" />
			 	  		<input type="hidden" id="bpItemNos" 		    name="bpItemNos" 	        value="${benPeril.itemNo }" />
						<input type="hidden" id="bpPerilCds"      		name="bpPerilCds"   	 	value="${benPeril.perilCd }" />
						<input type="hidden" id="bpTsiAmts"  			name="bpTsiAmts"  			value="${benPeril.tsiAmt }" />
						<input type="hidden" id="bpGroupedItemNos" 		name="bpGroupedItemNos" 	value="${benPeril.groupedItemNo }" />
						<input type="hidden" id="bpBeneficiaryNos" 		name="bpBeneficiaryNos"  	value="${benPeril.beneficiaryNo }" />
						<input type="hidden" id="bpLineCds" 			name="bpLineCds" 		 	value="${benPeril.lineCd }" />
						<input type="hidden" id="bpRecFlags"   			name="bpRecFlags"  	 		value="${benPeril.recFlag }" />
						<input type="hidden" id="bpPremRts"  	 		name="bpPremRts" 	 		value="${benPeril.premRt }" />
						<input type="hidden" id="bpPremAmts"  			name="bpPremAmts" 			value="${benPeril.premAmt }" />
						<input type="hidden" id="bpAnnTsiAmts"  		name="bpAnnTsiAmts" 		value="${benPeril.annTsiAmt }" />
						<input type="hidden" id="bpAnnPremAmts"  		name="bpAnnPremAmts" 		value="${benPeril.annPremAmt }" />
						
						<label name="textBenPeril" style="text-align: left; width: 49%; margin-right: 10px;">${benPeril.perilName }<c:if test="${empty benPeril.perilName}">---</c:if></label>
						<label name="textBenPeril" style="text-align: right; width: 49%;" class="money">${benPeril.tsiAmt }<c:if test="${empty benPeril.tsiAmt}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textBenPeril']").each(function (label)    {
   		if ((label.innerHTML).length > 20)    {
        	label.update((label.innerHTML).truncate(20, "..."));
    	}
	});
	var ctr = 0;
	$$("div[name='benPeril']").each(function(newDiv){
		ctr++;
		newDiv.setAttribute("itemSeqNo",ctr); 
	});
</script>	