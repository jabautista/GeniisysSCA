<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<form id="WinvPerlForm" name="WinvPerlForm">
<div id="invPerilDiv" name="invPerilDiv" style="margin: 5%; width:70%; padding-left:10% ">
	
		<div class="tableHeader">
			<label style="width:40%; padding-left:5%; text-align: left;">Peril Description</label>
			<label style="width:15%; text-align: right;">TSI Amount</label>
			<label style="width:35%; text-align: right;">Premium Amount</label>
		</div>
		
		<div class="tableContainer" id="winvperlListing" name="winvperlListing" style="display: block;">
			<input type="hidden" id="perlParId" name="perlParId" value="${gipiWinvperl[0].parId}" />
			<input type="hidden" id="lineCd" name="lineCd"  />
			<input type="hidden" id="perlTakeupSeqNo" name="perlTakeupSeqNo" value="${gipiWinvperl[0].takeupSeqNo}" />
			<c:forEach var="itemGrp" items="${itemGrpGipiWinvperl}">
				<input type="hidden" id="wpItemGrp" name="wpItemGrp" value="${itemGrp.itemGrp}">
				<c:forEach var="takeup" items="${takeupGipiWinvperl}">		
					<div id="winvPerlList${itemGrp.itemGrp}${takeup.takeupSeqNo}" name="winvPerlList">
		 				<c:forEach var="winvperl" items="${gipiWinvperl}">
							<c:if test="${takeup.takeupSeqNo eq winvperl.takeupSeqNo and itemGrp.itemGrp eq winvperl.itemGrp}">
								<div id="winvPerl" name="winvPerl" class="tableRow">
									<input type="hidden" id="wpPerilCd" name="wpPerilCd" value="${winvperl.perilCd}"/>
									<input type="hidden" id="wpTsiAmt" name="wpTsiAmt" value="${winvperl.tsiAmt}"/>
									<input type="hidden" id="wpPremAmt" name="wpPremAmt" value="${winvPerl.premAmt}" />
									<label style="padding-left: 5%;width:30%; text-align:left" >${winvperl.perilName} </label>
									<label style=" width: 25%;text-align: right; float: left" class="money">${winvperl.tsiAmt} </label>
									<label style="width:35%; text-align: right" class="money">${winvperl.premAmt} </label>
 								</div>
 							</c:if>
 						</c:forEach>	
 					</div>
 				</c:forEach>
 			</c:forEach>	
 		</div>
 	
 	</div>
	

</form>
<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	toggleWinvoicePerils();

	initializeTable("tableContainer", "winvPerl", "", "");

	$$("div[name='winvTax']").each(
			function (tax)	{
				tax.observe("click", function ()	{
				
				}); 
			}
		);	


	function toggleWinvoicePerils()	{
		$$("div[name='winvPerlList']").each(function (p)	{
			p.hide();
		});
		$("winvPerlList"+$F("itemGrp")+$F("selTakeupSeqNo")).show();
	}
	
</script>