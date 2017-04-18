<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformation" name="itemInformationMainDiv" style="width: 100%;">   
    <div id="searchResultParItem" align="center" style="margin: 10px;">
        <div style="width: 100%; " id="itemTable" name="itemTable">
            <div class="tableHeader">
                <label style="width: 5%; text-align: right; margin-right: 10px;">No.</label>
                <label style="width: 20%; text-align: left;">Item Title</label>
                <label style="width: 20%; text-align: left;">Description 1</label>
                <label style="width: 20%; text-align: left;">Description 2</label>
                <label style="width: 10%; text-align: left;">Currency</label>
                <label style="width: 10%; text-align: right; margin-right: 10px;">Rate</label>
                <label style="text-align: left;">Coverage</label>
            </div>
            <div id="parItemTableContainer" class="tableContainer">
            	<input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
                <c:forEach var="item" items="${items}" varStatus="ctr">
                    <div id="row${item.itemNo}" name="row" class="tableRow" style="height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;">
                    	<input type="hidden"	name="parIds"				value="${item.parId}" />                    	
                        <input type="hidden"	name="masterItemNos"		value="${item.itemNo}" />
                        <input type="hidden"	name="masterItemTitles"		value="${item.itemTitle}" />
                        <input type="hidden"	name="masterItemDescs"		value="${item.itemDesc}" />
                        <input type="hidden"	name="masterItemDescs2"		value="${item.itemDesc2}" />
                        <input type="hidden"	name="masterCurrencys"		value="${item.currencyCd}" />
                        <input type="hidden"	name="masterRates"			value="${item.currencyRate}" />
                        <input type="hidden"	name="masterCoverages"		value="${item.coverageCd}" />
                        <input type="hidden"	name="masterPackLineCd"		value="${item.packLineCd}" />
                        <input type="hidden"	name="masterPackSublineCd"	value="${item.packSublineCd}" />
                        <input type="hidden"	name="masterItemGroup"		value="${item.itemGroup}" />
                        <input type="hidden"	name="masterRecFlag"		value="${item.recFlag}" />
                        <input type="hidden"	name="masterFromDate"		value="${item.fromDate}" />
                        <input type="hidden"	name="masterToDate"			value="${item.toDate}" />                 
                       
                       	<c:if test="${lineCd == 'MC'}">
                       		<input type="hidden"    name="detailAssignees"			value="${item.assignee}" />
	                        <input type="hidden"    name="detailAcquiredFroms"		value="${item.acquiredFrom}" />
	                        <input type="hidden"    name="detailMotorNos"			value="${item.motorNo}" />
	                        <input type="hidden"    name="detailOrigins"			value="${item.origin}" />
	                        <input type="hidden"    name="detailDestinations"       value="${item.destination}" />
	                        <input type="hidden"    name="detailTypeOfBodyCds"		value="${item.typeOfBodyCd}" />
	                        <input type="hidden"    name="detailPlateNos"			value="${item.plateNo}" />
	                        <input type="hidden"    name="detailModelYears"			value="${item.modelYear}" />
	                        <input type="hidden"    name="detailCarCompanyCds"		value="${item.carCompanyCd}" />
	                        <input type="hidden"    name="detailMVFileNos"			value="${item.mvFileNo}" />
	                        <input type="hidden"    name="detailNoOfPass"			value="${item.noOfPass}" />
	                        <input type="hidden"    name="detailMakeCds"			value="${item.makeCd}" />
	                        <input type="hidden"    name="detailBasicColorCds"		value="${item.basicColorCd}" />
	                        <input type="hidden"    name="detailColors"				value="${item.color}" />
	                        <input type="hidden"    name="detailColorCds"			value="${item.colorCd}" />
	                        <input type="hidden"    name="detailSeriesCds"			value="${item.seriesCd}" />
	                        <input type="hidden"    name="detailMotorTypes"			value="${item.motType}" />
	                        <input type="hidden"    name="detailUnladenWts"			value="${item.unladenWt}" />
	                        <input type="hidden"    name="detailTowings"			value="${item.towing}" />
	                        <input type="hidden"    name="detailSerialNos"			value="${item.serialNo}" />
	                        <input type="hidden"    name="detailSublineTypeCds"		value="${item.sublineTypeCd}" />
	                        <input type="hidden"    name="detailDeductibleAmounts"	value="${item.deductibleAmount}" />
	                        <input type="hidden"    name="detailCOCTypes"			value="${item.cocType}" />
	                        <input type="hidden"    name="detailCOCSerialNos"		value="${item.cocSerialNo}" />
	                        <input type="hidden"    name="detailCOCYYs"				value="${item.cocYY}" />
	                        <input type="hidden"    name="detailCTVTags"			value="${item.ctvTag}" />
	                        <input type="hidden"    name="detailRepairLims"			value="${item.repairLim}" />
                       	</c:if>                        
                        
                        <input type="hidden"	name="sublineCds"				value="${item.sublineCd}">                                    
                       
                        <label style="width: 5%; text-align: right; margin-right: 10px;">${item.itemNo}<!--<fmt:formatNumber value='${item.itemNo}' pattern='000' />--></label>
                        <label name="text" style="width: 20%; text-align: left;">${item.itemTitle}<c:if test="${empty item.itemTitle}">---</c:if></label>
                        <label name="text" style="width: 20%; text-align: left;">${item.itemDesc}<c:if test="${empty item.itemDesc}">---</c:if></label>
                        <label name="text" style="width: 20%; text-align: left;">${item.itemDesc2}<c:if test="${empty item.itemDesc2}">---</c:if></label>
                        <label name="text" style="width: 10%; text-align: left;">${item.currencyDesc}<c:if test="${empty item.currencyDesc}"></c:if>---</label>
                        <label name="text" style="width: 10%; text-align: right; margin-right: 10px;"><fmt:formatNumber value='${item.currencyRate}' pattern='##0.000000000'/><c:if test="${empty item.currencyRate}">---</c:if></label>
                        <label name="text" style="text-align: left;">${item.coverageDesc}<c:if test="${empty item.coverageDesc}">---</c:if></label>
                    </div>
                </c:forEach>               
            </div>                    
        </div>       
    </div>
</div>

<script type="text/javascript">
    $$("label[name='text']").each(function (label)    {
        if ((label.innerHTML).length > 15)    {
            label.update((label.innerHTML).truncate(15, "..."));
        }
    });

   
	/*
    $$("div[name='row']").each(function (div)    {        
        if ((div.down("label", 1).innerHTML).length > 30)    {
            div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
        }
    });
    */

    setDocumentTitle("Item Information");
</script>