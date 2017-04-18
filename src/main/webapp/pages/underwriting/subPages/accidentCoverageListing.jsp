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
		<div style="margin: 10px;" id="coverageTable" name="coverageTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 13%; margin-right: 6px;">Enrollee Name</label>
				<label style="text-align: left; width: 13%; margin-right: 6px;">Peril Name</label>
				<label style="text-align: right; width: 10%; margin-right: 5px;">Rate</label>
				<label style="text-align: right; width: 15%; margin-right: 5px;">TSI Amount</label>
				<label style="text-align: right; width: 15%; margin-right: 5px;">Premium Amount</label>
				<label style="text-align: right; width: 10%; margin-right: 5px;">No. Of Days</label>
				<label style="text-align: right; width: 15%; margin-right: 5px;">Base Amount</label>
				<label style="text-align: center; width: 3%;">A</label>
			</div>
			
			<div class="tableContainer" id="coverageListing" name="coverageListing" style="display: block;">
				<c:forEach var="cov" items="${gipiWItmperlGrouped}">
					<div id="rowCov${cov.groupedItemNo}${cov.perilCd}" item="${cov.itemNo}" groupedItemNo="${cov.groupedItemNo}" perilCd="${cov.perilCd }" name="cov" class="tableRow" style="padding-left:1px;">
						<input type="hidden" id="coverageParIds" 		    name="coverageParIds" 	        value="${cov.parId }" />
			 	  		<input type="hidden" id="coverageItemNos" 			name="coverageItemNos" 	    	value="${cov.itemNo }" />
						<input type="hidden" id="coveragePerilCds"       	name="coveragePerilCds"     	value="${cov.perilCd }" />
						<input type="hidden" id="coveragePremRts"  	 		name="coveragePremRts"  	 	value="${cov.premRt }<c:if test="${empty cov.premRt}">0</c:if>" />
						<input type="hidden" id="coverageTsiAmts" 	 		name="coverageTsiAmts" 			value="${cov.tsiAmt }" />
						<input type="hidden" id="coveragePremAmts" 			name="coveragePremAmts"  		value="${cov.premAmt }" />
						<input type="hidden" id="coverageNoOfDayss" 		name="coverageNoOfDayss" 		value="${cov.noOfDays }" />
						<input type="hidden" id="coverageBaseAmts"   		name="coverageBaseAmts"  	 	value="${cov.baseAmt }" />
						<input type="hidden" id="coverageAggregateSws"  	name="coverageAggregateSws" 	value="${cov.aggregateSw }" />
						<input type="hidden" id="coverageAnnPremAmts"  		name="coverageAnnPremAmts" 		value="${cov.annPremAmt }" />
						<input type="hidden" id="coverageAnnTsiAmts"  		name="coverageAnnTsiAmts" 	 	value="${cov.annTsiAmt }" />
						<input type="hidden" id="coverageGroupedItemNos"  	name="coverageGroupedItemNos" 	value="${cov.groupedItemNo }" />
						<input type="hidden" id="coverageLineCds"  	 		name="coverageLineCds" 	 		value="${cov.lineCd }" />
						<input type="hidden" id="coverageRecFlags"  	 	name="coverageRecFlags" 	 	value="${cov.recFlag }" />
						<input type="hidden" id="coverageRiCommRts"  	 	name="coverageRiCommRts" 	 	value="${cov.riCommRate }" />
						<input type="hidden" id="coverageRiCommAmts"  		name="coverageRiCommAmts" 	 	value="${cov.riCommAmt }" />
						<input type="hidden" id="coverageWcSws"  			name="coverageWcSws" 	 		value="" />
						<input type="hidden" id="coveragePerilTypes"  		name="coveragePerilTypes" 	 	value="${cov.perilType }" />
						
						<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">${cov.groupedItemTitle }<c:if test="${empty cov.groupedItemTitle}">---</c:if></label>
						<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">${cov.perilName }<c:if test="${empty cov.perilName}">---</c:if></label>
						<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;" class="moneyRate">${cov.premRt }<c:if test="${empty cov.premRt}">---</c:if></label>
						<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">${cov.tsiAmt }<c:if test="${empty cov.tsiAmt}">---</c:if></label>
						<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">${cov.premAmt }<c:if test="${empty cov.premAmt}">---</c:if></label>
						<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;">${cov.noOfDays }<c:if test="${empty cov.noOfDays}">---</c:if></label>
						<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">${cov.baseAmt }<c:if test="${empty cov.baseAmt}">---</c:if></label>
						<label name="textAggregate" style="width: 3%; text-align: center;">
						<c:if test="${'N' eq cov.aggregateSw or empty cov.aggregateSw}">
							<span style='width: 10px; height: 10px; text-align: left; display: block;' ></span>
						</c:if>
						<c:if test="${'Y' eq cov.aggregateSw}">
							<img name='checkedImg' class='printCheck' style='width: 10px; height: 10px; text-align: center; display: block; margin-left: 10px;'/>
						</c:if>
						</label>
					</div>
				</c:forEach>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textCov']").each(function(label){
   		if ((label.innerHTML).length > 15)    {
        	label.update((label.innerHTML).truncate(15, "..."));
    	}
	});
	$$("label[name='textAggregate']").each(function(label){
   		$(label).observe("mouseover",function(){
			label.setAttribute("title","Aggregate");
		});
	});

	changeCheckImageColor();
</script>	