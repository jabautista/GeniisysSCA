<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : /pages/accounting/officialReceipt/subPages/directTransPremDeposit.jsp
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Collections on Premium Deposits</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div> -->
	

<div class="sectionDiv" id="premiumDepositsDiv" name="premiumDepositsDiv" style="border-top: none;" changeTagAttr="true">
		<!-- module variables -->
		<input type="hidden" id="gaccTranId" 			name="gaccTranId" 		value="${gaccTranId }"/>
		<input type="hidden" id="gaccBranchCd"			name="gaccBranchCd" 	value="${gaccBranchCd }"/> <!-- temporary value -->
		<input type="hidden" id="gaccFundCd" 			name="gaccFundCd" 		value="${gaccFundCd }"/>
		<input type="hidden" id="tranSource"			name="tranSource"		value="${tranSource }"/>
		<input type="hidden" id="moduleName"			name="moduleName"		value="GIACS026"/>
		<input type="hidden" id="orFlag"				name="orFlag"			value="${orFlag }"/>
		<input type="hidden" id="globalCurrencyCd" 		name="globalCurrencyCd" value="${globalCurrencyCd }"/>
		
		<input type="hidden" id="varLovSwitch"			name="varLovSwitch"		 	value="1"/>
		<input type="hidden" id="varPrevTranType"		name="varPrevTranType"	 	value=""/>
		<input type="hidden" id="varTranId"				name="varTranId"	 	 	value=""/>
		<input type="hidden" id="varPckSwitch"			name="varPckSwitch"	 	 	value=""/>
		<input type="hidden" id="varPckTotColl"			name="varPckTotColl" 	 	value=""/>
		<input type="hidden" id="varPckTotColl2"		name="varPckTotColl2" 	 	value=""/>
		<input type="hidden" id="varPckGcbaGti"			name="varPckGcbaGti" 	 	value=""/>
		<input type="hidden" id="varPckGcbaIn"			name="varPckGcbaIn" 	 	value=""/>
		<input type="hidden" id="varPckDefaultValue"	name="varPckDefaultValue"	value=""/>
		<input type="hidden" id="varPckDefaultValue2"	name="varPckDefaultValue2" 	value=""/>
		<input type="hidden" id="varCollectionAmt"		name="varCollectionAmt" 	value=""/>
		<input type="hidden" id="varTempItemNo"			name="varTempItemNo" 	 	value="0"/>
		<input type="hidden" id="varItemGenType"		name="varItemGenType"	 	value="${generationType }"/>
		
		<input type="hidden" id="ctrlCompany"				name="ctrlCompany"		  		value="${ctrlCompany }"/>
		<input type="hidden" id="cgfk$GipdOldItemNo"		name="cgfk$GipdOldItemNo" 		value=""/>
		<input type="hidden" id="cg$ctrlTotalCollections"	name="cg$ctrlTotalCollections"	value=""/>
		
		<input type="hidden" id="dfltCurrencyCd"		name="dfltCurrencyCd" 	  value="${dfltCurrencyCd }"/>
		<input type="hidden" id="dfltCurrencyDesc"		name="dfltCurrencyDesc"   value="${dfltCurrencyDesc }"/>
		<input type="hidden" id="dfltCurrencyRt"		name="dfltCurrencyRt" 	  value="${dfltCurrencyRt }"/>
		<input type="hidden" id="dfltMainCurrencyCd"	name="dfltMainCurrencyCd" value="${dfltMainCurrencyCd }"/>
	
		<!-- misc variables -->
		<input type="hidden" id="premDepListLastNo" 			name="premDepListLastNo" 			value="${premDepositListSize - 1}<c:if test="${empty premDepositListSize }">0</c:if>" />
		<input type="hidden" id="currentRowNo"					name="currentRowNo"		 			value="-1"/> <!-- can also be used to indicate system.record_status -->
		<input type="hidden" id="lastItemNo"					name="lastItemNo"		 			value="0"/>
		<input type="hidden" id="lastTranMonth" 				name="lastTranMonth" 	 			value=""/>
		<input type="hidden" id="lastTranSeqNo" 				name="lastTranSeqNo" 	 			value=""/>
		<input type="hidden" id="lastOldItemNo" 				name="lastOldItemNo" 	 			value=""/>
		<input type="hidden" id="lastOldTranType" 				name="lastOldTranType" 	 			value=""/>
		<input type="hidden" id="lastB140PremSeqNo" 			name="lastB140PremSeqNo" 			value=""/>
		<input type="hidden" id="lastInstNo" 					name="lastInstNo" 		 			value=""/>
		<input type="hidden" id="lastAmtValue"					name="lastAmtValue"		 			value=""/>
		<input type="hidden" id="lastCurrencyCd"				name="lastCurrencyCd"	 			value="1"/>
		<input type="hidden" id="lastConvertRate"				name="lastConvertRate"	 			value="1"/>
		<input type="hidden" id="lastForeignCurrAmt"			name="lastForeignCurrAmt"	 		value="1"/>
		<input type="hidden" id="oldTranTypeOkForValidation"	name="oldTranTypeOkForValidation" 	value="N"/>
		<input type="hidden" id="hidAccTransTranFlag" 			name="hidAccTransTranFlag" 			value="${ accTrans.tranFlag}"/>
	
		<jsp:include page="premiumDepositListingTable.jsp"></jsp:include>
		<div id="premiumDepositTop" name="premiumDepositTop" style="margin: 10px;">
			<!-- GIPD items -->
			<input type="hidden" id="txtOldTranId" 	  			name="txtOldTranId" 		value="" />
			<input type="hidden" id="txtCurrencyDesc" 			name="txtCurrencyDesc" 		value="" />
			<input type="hidden" id="txtDspShortName" 			name="txtDspShortName" 		value="" />
			<input type="hidden" id="txtLineCd"   	  			name="txtLineCd" 			value="" />
			<input type="hidden" id="txtSublineCd"    			name="txtSublineCd" 		value="" />
			<input type="hidden" id="txtIssCd"   	  			name="txtIssCd" 			value="" />
			<input type="hidden" id="txtIssueYy"   	  			name="txtIssueYy" 			value="" />
			<input type="hidden" id="txtPolSeqNo"     			name="txtPolSeqNo" 			value="" />
			<input type="hidden" id="txtRenewNo"   	  			name="txtRenewNo" 			value="" />
			<input type="hidden" id="txtParSeqNo"     			name="txtParSeqNo" 			value="" />
			<input type="hidden" id="txtParLineCd"   			name="txtParLineCd" 		value="" />
			<input type="hidden" id="txtParIssCd"     			name="txtParIssCd" 			value="" />
			<input type="hidden" id="txtParYy"   	  			name="txtParYy" 			value="" />
			<input type="hidden" id="txtQuoteSeqNo"   			name="txtQuoteSeqNo" 		value="" />
			<input type="hidden" id="txtAssdNo"   	  			name="txtAssdNo" 			value="" />
			<input type="hidden" id="txtAssuredName"  			name="txtAssuredName" 		value="" />
			<input type="hidden" id="txtIntmNo"   	  			name="txtIntmNo" 			value="" />
			<input type="hidden" id="txtIntmName"     			name="txtIntmName" 			value=""/>
			<input type="hidden" id="txtDefaultValue" 			name="txtDefaultValue" 		value="" />
			<input type="hidden" id="txtGaccTranId"   			name="txtGaccTranId" 		value="" />
			<input type="hidden" id="txtRiCd"         			name="txtRiCd" 				value="" />
			<input type="hidden" id="txtRiName"		  			name="txtRiName" 			value=""/>
			<input type="hidden" id="txtCommRecNo"    			name="txtCommRecNo" 		value="" />
			<input type="hidden" id="txtDspA150LineCd"   		name="txtDspA150LineCd" 	value="" />
			<input type="hidden" id="txtDspTotalAmountDue"   	name="txtDspTotalAmountDue" value="" />
			<input type="hidden" id="txtDspTotalPayments"   	name="txtDspTotalPayments" 	value="" />
			<input type="hidden" id="txtDspTempPayments"   		name="txtDspTempPayments" 	value="" />
			<input type="hidden" id="txtDspBalanceAmtDue"   	name="txtDspBalanceAmtDue" 	value="" />
			<input type="hidden" id="txtDspA020AssdNo"   		name="txtDspA020AssdNo" 	value="" />
			<input type="hidden" id="txtDspTranClassNo"   		name="txtDspTranClassNo" 	value="" />
			
			<!-- The div to be used for storing deleted records -->
			<div id="deletePremDepList" name="deletePremDepList">
			</div>
			
			<!-- The div to be used for showing message -->
			<div id="messageAssdDiv" name="messageDiv" style="font-size: 11px; text-align: center; display: none;">
				Press Backspace to clear assured name.
			</div>
			
			<div id="messageIntmDiv" name="messageDiv" style="font-size: 11px; text-align: center; display: none;">
				Press Backspace to clear intermediary name.
			</div>
			
			<div id="messageRiDiv" name="messageDiv" style="font-size: 11px; text-align: center; display: none;">
				Press Backspace to clear reinsurer.
			</div>
			
			<!--  
			<c:forEach var="oldItemNo" items="${oldItemNoList }" varStatus="ctr">
				<div id="oldItemRow${oldItemNo.dspTranYear}-${oldItemNo.dspTranMonth}-${oldItemNo.dspTranSeqNo}-${oldItemNo.oldItemNo}-${oldItemNo.oldTranType}" 
						name="rowOldItemNo"/>
					<input type="hidden" id="oldItemNoBranchCd"   		name="rowOldItemNo" value="${oldItemNo.branchCd }" />
					<input type="hidden" id="oldItemNoOldItemNo"   		name="rowOldItemNo" value="${oldItemNo.oldItemNo }" />
					<input type="hidden" id="oldItemNoOldTranType"  	name="rowOldItemNo" value="${oldItemNo.oldTranType }" />
					<input type="hidden" id="oldItemNoOldTranId"    	name="rowOldItemNo" value="${oldItemNo.oldTranId }" />
					<input type="hidden" id="oldItemNoCollectionAmt"   	name="rowOldItemNo" value="${oldItemNo.dspCollectionAmt }" />
					<input type="hidden" id="oldItemNoTranYear"   		name="rowOldItemNo" value="${oldItemNo.dspTranYear }" />
					<input type="hidden" id="oldItemNoTranMonth"   		name="rowOldItemNo" value="${oldItemNo.dspTranMonth }" />
					<input type="hidden" id="oldItemNoTranSeqNo"   		name="rowOldItemNo" value="${oldItemNo.dspTranSeqNo }" />
					<input type="hidden" id="oldItemNoParticulars"   	name="rowOldItemNo" value="${fn:escapeXml(oldItemNo.dspParticulars) }" />
					<input type="hidden" id="oldItemNoTranClass"   		name="rowOldItemNo" value="${oldItemNo.dspTranClass }" />
					<input type="hidden" id="oldItemNoTranClassNo"   	name="rowOldItemNo" value="${oldItemNo.dspTranClassNo }" />
					<input type="hidden" id="oldItemNoAssdNo"   		name="rowOldItemNo" value="${oldItemNo.assdNo }" />
					<input type="hidden" id="oldItemNoDepFlag"   		name="rowOldItemNo" value="${oldItemNo.depFlag }" />
					<input type="hidden" id="oldItemNoRiCd"   			name="rowOldItemNo" value="${oldItemNo.riCd }" />
					<input type="hidden" id="oldItemNoIntmNo"   		name="rowOldItemNo" value="${oldItemNo.intmNo }" />
					<input type="hidden" id="oldItemNoLineCd"   		name="rowOldItemNo" value="${oldItemNo.lineCd }" />
					<input type="hidden" id="oldItemNoSublineCd"   		name="rowOldItemNo" value="${oldItemNo.sublineCd }" />
					<input type="hidden" id="oldItemNoIssCd"   			name="rowOldItemNo" value="${oldItemNo.issCd }" />
					<input type="hidden" id="oldItemNoIssueYy"   		name="rowOldItemNo" value="${oldItemNo.issueYy }" />
					<input type="hidden" id="oldItemNoPolSeqNo"   		name="rowOldItemNo" value="${oldItemNo.polSeqNo }" />
					<input type="hidden" id="oldItemNoRenewNo"   		name="rowOldItemNo" value="${oldItemNo.renewNo }" />
					<input type="hidden" id="oldItemNoB140IssCd"   		name="rowOldItemNo" value="${oldItemNo.b140IssCd }" />
					<input type="hidden" id="oldItemNoB140PremSeqNo"   	name="rowOldItemNo" value="${oldItemNo.b140PremSeqNo }" />
					<input type="hidden" id="oldItemNoCommRecNo"   		name="rowOldItemNo" value="${oldItemNo.commRecNo }" />
					<input type="hidden" id="oldItemNoOldTranId2"  		name="rowOldItemNo" value="${oldItemNo.oldTranId2 }" />
					<input type="hidden" id="oldItemNoOldTranIdFor1"  	name="rowOldItemNo" value="${oldItemNo.oldTranIdForTranType1 }" />
					<input type="hidden" id="oldItemNoOldTranIdFor3"  	name="rowOldItemNo" value="${oldItemNo.oldTranIdForTranType3 }" />
				</div>
			</c:forEach>
			
			<c:forEach var="oldItemNo" items="${oldItemNoListFor4 }" varStatus="ctr">
				<div id="oldItemFor4Row${oldItemNo.dspTranYear}-${oldItemNo.dspTranMonth}-${oldItemNo.dspTranSeqNo}-${oldItemNo.oldItemNo}-${oldItemNo.oldTranType}" 
						name="rowOldItemNoFor4"/>
					<input type="hidden" id="oldItemNoBranchCd"   		name="rowOldItemNo" value="${oldItemNo.branchCd }" />
					<input type="hidden" id="oldItemNoOldItemNo"   		name="rowOldItemNo" value="${oldItemNo.oldItemNo }" />
					<input type="hidden" id="oldItemNoOldTranType"  	name="rowOldItemNo" value="${oldItemNo.oldTranType }" />
					<input type="hidden" id="oldItemNoOldTranId"    	name="rowOldItemNo" value="${oldItemNo.oldTranId }" />
					<input type="hidden" id="oldItemNoCollectionAmt"   	name="rowOldItemNo" value="${oldItemNo.dspCollectionAmt }" />
					<input type="hidden" id="oldItemNoTranYear"   		name="rowOldItemNo" value="${oldItemNo.dspTranYear }" />
					<input type="hidden" id="oldItemNoTranMonth"   		name="rowOldItemNo" value="${oldItemNo.dspTranMonth }" />
					<input type="hidden" id="oldItemNoTranSeqNo"   		name="rowOldItemNo" value="${oldItemNo.dspTranSeqNo }" />
					<input type="hidden" id="oldItemNoParticulars"   	name="rowOldItemNo" value="${fn:escapeXml(oldItemNo.dspParticulars) }" />
					<input type="hidden" id="oldItemNoTranClass"   		name="rowOldItemNo" value="${oldItemNo.dspTranClass }" />
					<input type="hidden" id="oldItemNoTranClassNo"   	name="rowOldItemNo" value="${oldItemNo.dspTranClassNo }" />
					<input type="hidden" id="oldItemNoAssdNo"   		name="rowOldItemNo" value="${oldItemNo.assdNo }" />
					<input type="hidden" id="oldItemNoDepFlag"   		name="rowOldItemNo" value="${oldItemNo.depFlag }" />
					<input type="hidden" id="oldItemNoRiCd"   			name="rowOldItemNo" value="${oldItemNo.riCd }" />
					<input type="hidden" id="oldItemNoIntmNo"   		name="rowOldItemNo" value="${oldItemNo.intmNo }" />
					<input type="hidden" id="oldItemNoLineCd"   		name="rowOldItemNo" value="${oldItemNo.lineCd }" />
					<input type="hidden" id="oldItemNoSublineCd"   		name="rowOldItemNo" value="${oldItemNo.sublineCd }" />
					<input type="hidden" id="oldItemNoIssCd"   			name="rowOldItemNo" value="${oldItemNo.issCd }" />
					<input type="hidden" id="oldItemNoIssueYy"   		name="rowOldItemNo" value="${oldItemNo.issueYy }" />
					<input type="hidden" id="oldItemNoPolSeqNo"   		name="rowOldItemNo" value="${oldItemNo.polSeqNo }" />
					<input type="hidden" id="oldItemNoRenewNo"   		name="rowOldItemNo" value="${oldItemNo.renewNo }" />
					<input type="hidden" id="oldItemNoB140IssCd"   		name="rowOldItemNo" value="${oldItemNo.b140IssCd }" />
					<input type="hidden" id="oldItemNoB140PremSeqNo"   	name="rowOldItemNo" value="${oldItemNo.b140PremSeqNo }" />
					<input type="hidden" id="oldItemNoCommRecNo"   		name="rowOldItemNo" value="${oldItemNo.commRecNo }" />
					<input type="hidden" id="oldItemNoOldTranId2"  		name="rowOldItemNo" value="${oldItemNo.oldTranId2 }" />
					<input type="hidden" id="oldItemNoOldTranIdFor1"  	name="rowOldItemNo" value="${oldItemNo.oldTranIdForTranType1 }" />
					<input type="hidden" id="oldItemNoOldTranIdFor3"  	name="rowOldItemNo" value="${oldItemNo.oldTranIdForTranType3 }" />
				</div>
			</c:forEach>
			
			
			<div id="collectionAmtSumListDiv" name="collectionAmtSumListDiv" style="visibility: hidden">
				<c:forEach var="collectionAmt" items="${collectionAmtSumFor2List }" varStatus="ctr">
					<div id="collectionAmtFor2${collectionAmt.oldTranId }-${collectionAmt.oldItemNo }" 
							name="rowCollectionAmtFor2"/>
						<input type="hidden" id="collnAmtOldTranId"   		name="collnAmtSumRow" value="${collectionAmt.oldTranId }" />
						<input type="hidden" id="collnAmtOldItemNo"   		name="collnAmtSumRow" value="${collectionAmt.oldItemNo }" />
						<input type="hidden" id="collnAmtSum"   			name="collnAmtSumRow" value="${collectionAmt.collectionAmtSum }" />
					</div>
				</c:forEach>
			</div>
			
			<div id="collectionAmtSumListDiv" name="collectionAmtSumListDiv" style="visibility: hidden">
				<c:forEach var="collectionAmt" items="${collectionAmtSumFor4List }" varStatus="ctr">
					<div id="collectionAmtFor4${collectionAmt.gaccTranId }-${collectionAmt.oldTranId }-${collectionAmt.oldItemNo }" 
							name="rowCollectionAmtFor4"/>
						<input type="hidden" id="collnAmtGaccTranId"   		name="collnAmtSumRow" value="${collectionAmt.gaccTranId }" />
						<input type="hidden" id="collnAmtOldTranId"   		name="collnAmtSumRow" value="${collectionAmt.oldTranId }" />
						<input type="hidden" id="collnAmtOldItemNo"   		name="collnAmtSumRow" value="${collectionAmt.oldItemNo }" />
						<input type="hidden" id="collnAmtSum"   			name="collnAmtSumRow" value="${collectionAmt.collectionAmtSum }" />
					</div>
				</c:forEach>
			</div>
			-->
			
			<div id="giisCurrencyListDiv" name="giisCurrencyListDiv" style="visibility: hidden">
				<c:forEach var="giisCurrency" items="${giisCurrencyList }" varStatus="ctr">
					<div id="giisCurrency${giisCurrency.mainCurrencyCd }" 
							name="rowGIISCurrency"/>
						<input type="hidden" id="giisCurrencyCd"   		name="giisCurrencyRow" value="${giisCurrency.mainCurrencyCd }" />
						<input type="hidden" id="giisCurrencyDesc"   	name="giisCurrencyRow" value="${giisCurrency.currencyDesc }" />
						<input type="hidden" id="giisCurrencyRt"   		name="giisCurrencyRow" value="${giisCurrency.currencyRt }" />
						<input type="hidden" id="giisCurrencyShortName" name="giisCurrencyRow" value="${giisCurrency.shortName }" />
					</div>
				</c:forEach>
			</div>
			
			
			<!-- 
			<div id="giacAgingSOAPolicyListDiv" name="giacAgingSOAPolicyListDiv" style="visibility: hidden">
				<c:forEach var="giacAgingSOA" items="${aaagiacAgingSOAPolicyList }" varStatus="ctr">
					<div id="giacAgingSOAPolicy${giacAgingSOA.policyId }" 
							name="rowGIACAgingSOAPolicy"/>
						<input type="hidden" id="giacAgingSOAPolicyPolicyId"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.policyId }" />
						<input type="hidden" id="giacAgingSOAPolicyLineCd"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.lineCd }" />
						<input type="hidden" id="giacAgingSOAPolicySublineCd"   	name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.sublineCd }" />
						<input type="hidden" id="giacAgingSOAPolicyIssCd"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.issCd }" />
						<input type="hidden" id="giacAgingSOAPolicyIssueYy"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.issueYy }" />
						<input type="hidden" id="giacAgingSOAPolicyPolSeqNo"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.polSeqNo }" />
						<input type="hidden" id="giacAgingSOAPolicyRenewNo"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.renewNo }" />
						<input type="hidden" id="giacAgingSOAPolicyB140IssCd"   	name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.b140IssCd }" />
						<input type="hidden" id="giacAgingSOAPolicyPremSeqNo"   	name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.premSeqNo }" />
						<input type="hidden" id="giacAgingSOAPolicyInstNo"   		name="giacAgingSOAPolicyRow" value="${giacAgingSOAPolicy.instNo }" />
					</div>
				</c:forEach>
			</div> -->
			
			<table align="center" style="margin: 10px" >
				<tr>
					<td class="rightAligned" style="width: 190px;">Item No.</td>
					<td class="leftAligned" style="width: 210px;"><input type="text" style="width: 186px; text-align: right" maxlength="9" class="required" id="txtItemNo" name="txtItemNo" value="" tabindex=1/></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Assured Name</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtDrvAssuredName" name="txtDrvAssuredName" readonly="readonly" type="text" value="" tabindex=12/>
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscm" name="oscm" alt="Go" style="float: right;"/>
					    </div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Transaction Type</td>
					<td class="leftAligned" style="width: 210px;">
						<select id="txtTransactionType" name="txtTransactionType" style="width: 193px;" class="required" tabindex=2>
							<option value=""></option>
							<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
								<option value="${transactionType.rvLowValue }">${transactionType.rvMeaning }</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width: 150px">Intermediary Name</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtDrvIntmName" name="txtDrvIntmName" readonly="readonly" type="text" value="" tabindex=13/>
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmIntermediary" name="oscmIntermediary" alt="Go" style="float: right'"/>
					    </div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Old Transaction No.</td>
					<td class="leftAligned" style="width: 210px;">
						<!-- 
						<select id="txtTranYear" name="txtTranYear" style="width: 60px" tabindex=3 disabled="disabled">
							<option value=""></option>
							<c:forEach var="i" begin="1990" end="2010" step="1">
								<option value="${i }">${i }</option>
							</c:forEach>
						</select>
						 -->
						 <input type="text" style="width: 60px;" maxlength="4" id="txtTranYear" name="txtTranYear" value="" readonly="readonly" tabindex=3/>
						<input type="text" style="width: 45px;" maxlength="2" id="txtTranMonth" name="txtTranMonth" value="" readonly="readonly" tabindex=4/>
						<input type="text" style="width: 45px; " maxlength="4" id="txtTranSeqNo" name="txtTranSeqNo" value="" readonly="readonly" tabindex=5/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmOldTransactionNo" name="oscmOldTransactionNo" alt="Go" />
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Reinsurer</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtDrvRiName" name="txtDrvRiName" readonly="readonly" type="text" value="" tabindex=14/>
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmRi" name="oscmRi" alt="Go" style="float: right;"/>
					    </div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Old Item No/Old Tran Type</td>
					<td class="leftAligned" style="width: 210px;">
						<input type="text" style="width: 77px; text-align: right" maxlength="2" id="txtOldItemNo" name="txtOldItemNo" value="" readonly="readonly" tabindex=6/>
						<input type="text" style="width: 77px; text-align: right" maxlength="2" id="txtOldTranType" name="txtOldTranType" value="" readonly="readonly" tabindex=7/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmOldItemNo" name="oscmOldItemNo" alt="Go" />
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Policy No.</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtPolicyNo" name="txtPolicyNo" readonly="readonly" type="text" value="" tabindex=15/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmPolicyNo" name="oscmPolicyNo" alt="Go" style="float: right;"/>
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Issue Source</td>
					<td class="leftAligned" style="width: 210px;">
						<select id="txtB140IssCd" name="txtB140IssCd" style="width: 173px;" disabled="disabled" tabindex=8>
							<option value=""></option>
							<c:forEach var="issueSource" items="${issueSourceList }" varStatus="ctr">
								<option value="${issueSource.issCd }">${issueSource.issName }</option>
							</c:forEach>
						</select>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmB140IssCd" name="oscmB140IssCd" alt="Go" />
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">PAR No.</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtParNo" name="txtParNo" readonly="readonly" type="text" value="" tabindex=16/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmParNo" name="oscmParNo" alt="Go" style="float: right;"/>
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Invoice No.</td>
					<td class="leftAligned" style="width: 210px;"><input type="text" style="width: 186px; text-align: right" maxlength="13" id="txtB140PremSeqNo" name="txtB140PremSeqNo" readonly="readonly" value=""/></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Collection Date</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtCollnDt" name="txtCollnDt" readonly="readonly" type="text" value="" tabindex=17/>
							<img id="hrefCollnDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtCollnDt').focus(); scwShow($('txtCollnDt'),this, null);" alt="Check Date" />
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Installment No.</td>
					<td class="leftAligned" style="width: 210px;"><input type="text" style="width: 186px; text-align: right" maxlength="2" id="txtInstNo" name="txtInstNo" value="" readonly="readonly" tabindex=9/></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Remarks</td>
					<td class="leftAligned" style="width: 220px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; float: left; border: none;" id="txtRemarks" name="txtRemarks" type="text" value="" maxlength="4000" tabindex=18/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarksPremDep" />
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Amount</td>
					<td class="leftAligned" style="width: 210px;"><input type="text" style="width: 186px; text-align: right" maxlength="17" class="required" id="txtCollectionAmt" name="txtCollectionAmt" value="" tabindex=10/></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px"></td>
					<td style="text-align: center; width: 220px" colspan="2">
						<input type="button" style="width: 110px;" id="btnForeignCurrency" class="button" value="Foreign Currency" tabindex=19/>
						<!-- 
						<input type="button" style="width: 110px;" id="btnBreakdown" 	   class="button" value="Breakdown"/> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;">Dep Flag</td>
					<td class="leftAligned" style="width: 210px;">
						<select id="txtDepFlag" name="txtDepFlag" style="width: 193px;" class="required" tabindex=11>
							<option value="1">Overdraft Comm</option>
							<option value="2">Overpayment</option>
							<option value="3">Unapplied</option>
						</select>
					</td>
					<td style="width: 320px" colspan="2"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;"></td>
					<td class="leftAligned" style="width: 210px;"><input type="radio" id="orTagVAT" name="orTag" value="V" /> VAT    <input type="radio" id="orTagNonVAT" name="orTag" value="N" checked="checked"/> Non-VAT</td>
					<td style="width: 320px" colspan="2"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 190px;"></td>
					<td style="text-align: right; width: 180px">
						<input type="button" style="width: 80px;" id="btnSaveRecord" class="button" value="Add" />
						<input type="button" style="width: 80px;" id="btnDelete" 	 class="disabledButton" value="Delete" disabled="disabled"/>
					</td>
					<td style="width: 320px" colspan="2"></td>
				</tr>
			</table>
			<div id="currencyDiv" style="display: none;">
				<jsp:include page="currencyInfoPage.jsp"></jsp:include>
			</div>
		</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">
	<input type="button" style="width: 80px;" id="btnCancel" 		name="btnCancel"		class="button" value="Cancel" />
	<input type="button" style="width: 80px;" id="btnSavePremDep" 	name="btnSavePremDep"	class="button" value="Save" />
</div> 

<script type="text/javaScript">
	disableButton($("btnDelete"));
	disableButton($("btnSavePremDep"));
	
	
	// misc variables
	var saveRecTag = "Add";
	var oldItemNo;
	var oldTranType;
	var oldTranId;
	
	// check if OR is printed. if yes, disable all fields (emman 06.09.2011)
	if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
		$("txtItemNo").readOnly = true;
		$("txtTransactionType").disable();
		
		$("txtTranYear").readOnly = true;
		$("txtTranMonth").readOnly = true;
		$("txtTranSeqNo").readOnly = true;
		$("txtOldItemNo").readOnly = true;
		$("txtOldTranType").readOnly = true;

		$("txtB140IssCd").enable();
		$("txtB140PremSeqNo").readOnly = true;
		$("txtInstNo").readOnly = true;
		$("txtCollectionAmt").readOnly = true;
		$("txtDepFlag").disable();

		$("orTagVAT").disable();
		$("orTagNonVAT").disable();

		$("txtRemarks").readOnly = true;
		$("hrefCollnDate").style.display = "none";
	} else {
		enableDisableDisp();
		$("txtItemNo").value = getMaxItemNo();
		$("lastItemNo").value = getMaxItemNo();
		$("txtCollnDt").value = new Date().format("mm-dd-yyyy");
	}
	
	checkTableIfEmpty("rowPremDep", "premiumDepositTableMainDiv");
	checkIfToResizeTable("premiumDepositTableContainer", "rowPremDep");
	setModuleId("GIACS026");
	setDocumentTitle("Collection on Premium Deposit");
	initializeChangeTagBehavior(saveGiacs026PremDep);
	window.scrollTo(0,0); 	
	hideNotice("");
	observeCancelForm("btnCancel", saveGiacs026PremDep, showORInfo);

	changeTag = 0;

	// set initial values
	$("lblTotalCollectionAmt").innerHTML = formatCurrency(getTotalCollectionAmt());

	// set tab indexes and max length for foreign currency fields and enable currency LOV
	$("txtCurrencyCd").tabindex = 20;
	$("txtConvertRate").tabindex = 21;
	$("txtDspCurrencyDesc").tabindex = 22;
	$("txtForeignCurrAmt").tabindex = 23;
	$("btnHideCurrPage").tabindex = 24;
	$("txtForeignCurrAmt").maxLength = 17;
	$("txtConvertRate").maxLength = 13;
	$("oscmCurrency").style.display = "inline";

	// buttons
	$("btnSavePremDep").observe("click", function() {
		saveGiacs026PremDep();
	});

	$("oscmCurrency").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			openSearchGIISCurrencyLOV();
		} else {
			if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else {
				openSearchGIISCurrencyLOV();
			}
		}
	});

	$("oscm").observe("click", function ()	{
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			openSearchAssured();
		} else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
			if( $F("gipdChanged"+$F("currentRowNo")) == "N"){
				if(saveRecTag=="Add"){
					openSearchAssured();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}else if($F("gipdChanged"+$F("currentRowNo")) == "A"){
				if(saveRecTag=="Update"){
					openSearchAssured();
				}
			}
			else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			openSearchAssured();
		} 
	});
	
	$("oscmB140IssCd").observe("click", function() {
		if (((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D")){
				showMessageBox("This item may not be updated.", imgMessage.INFO);
		}else if(saveRecTag == "Add"){
			if(($F("txtB140IssCd") == "RI")) {
						Modalbox.show(contextPath+"/GIACPremDepositController?action=showRiListing", 
								  {title: "Giac Aging Soa RI Details", 
								  width: 921,
								  asynchronous: false});
				}else{
						Modalbox.show(contextPath+"/GIACPremDepositController?action=showB140IssCdListing", 
								  {title: "Giac Aging Soa Details", 
								  width: 921,
								  asynchronous: false});
				}
		}else if ($F("currentRowNo") == "-1") {
			if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
				showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
			}else if (($F("txtB140IssCd") == "RI")) {
				Modalbox.show(contextPath+"/GIACPremDepositController?action=showRiListing", 
						  {title: "Giac Aging Soa RI Details", 
						  width: 921,
						  asynchronous: false});
			} else {
				Modalbox.show(contextPath+"/GIACPremDepositController?action=showB140IssCdListing", 
						  {title: "Giac Aging Soa Details", 
						  width: 921,
						  asynchronous: false});
			}
		} else {
			if ((objACGlobal.orFlag == "P" || objACGlobal.orFlag == "N")&& $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else {
				if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
					showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
				} else if (($F("txtB140IssCd") == "RI")) {
					Modalbox.show(contextPath+"/GIACPremDepositController?action=showRiListing", 
							  {title: "Giac Aging Soa RI Details", 
							  width: 921,
							  asynchronous: false});
				} else {
					Modalbox.show(contextPath+"/GIACPremDepositController?action=showB140IssCdListing", 
							  {title: "Giac Aging Soa Details", 
							  width: 921,
							  asynchronous: false});
				}
			}
		}
	});

	$("oscmIntermediary").observe("click", function ()	{
		if((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		}else if ($F("currentRowNo") == "-1") {
			openSearchIntermediary();
		}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			if(saveRecTag == "Add"){
				openSearchIntermediary();
			}else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		}else {
			if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else {
				openSearchIntermediary();
			}
		}
	});

	$("oscmRi").observe("click", function ()	{
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		}else if ($F("currentRowNo") == "-1") {
			openSearchReinsurer();
		}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			if(saveRecTag == "Add"){
				openSearchReinsurer();
			}else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		} else {
			if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else {
				openSearchReinsurer();
			}
		}
	});

	$("oscmOldTransactionNo").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} /* else if ($F("currentRowNo") == "-1") {
			openGipdOldItemNoLOV();
		} */ else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
			if( changed == "N"){
				if(saveRecTag=="Add"){
					openGipdOldItemNoLOV();
				}
			}else if(changed == "A"){
				if(saveRecTag=="Update"){
					openGipdOldItemNoLOV();
				}
			}
			else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			openGipdOldItemNoLOV();
		}
	});


	$("oscmOldItemNo").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			openGipdOldItemNoLOV();
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			openGipdOldItemNoLOV();
		}
	});

	$("oscmPolicyNo").observe("click", function() {
		if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
			showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
		}else if((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if($F("currentRowNo") == "-1") {
			openSearchPolicyNo();
		} else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
			if($F("gipdChanged"+$F("currentRowNo")) == "N"){
				if(saveRecTag=="Add"){
					openSearchPolicyNo();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}else if($F("gipdChanged"+$F("currentRowNo")) == "A"){
				if(saveRecTag=="Update"){
					openSearchPolicyNo();
				}
			}
			else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			openSearchPolicyNo();
		}
	});

	$("oscmParNo").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			showParNoLOV();
		} else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
			if( $F("gipdChanged"+$F("currentRowNo")) == "N"){
				if(saveRecTag=="Add"){
					showParNoLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}else if($F("gipdChanged"+$F("currentRowNo")) == "A"){
				if(saveRecTag=="Update"){
					showParNoLOV();
				}
			}
			else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			showParNoLOV();
		}
	});
	
	// texts
	$("editTxtRemarksPremDep").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			showEditor("txtRemarks", 4000);
		} else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
			if( $F("gipdChanged"+$F("currentRowNo")) == "N"){
				if(saveRecTag=="Add"){
					showEditor("txtRemarks", 4000);
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}else if($F("gipdChanged"+$F("currentRowNo")) == "A"){
				if(saveRecTag=="Update"){
					showEditor("txtRemarks", 4000);
				}
			}
			else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			showEditor("txtRemarks", 4000);
		} 
	});

	/* $("txtDrvAssuredName").observe("focus", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O") || (objACGlobal.orFlag != "P" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D")) {
			if ($F("currentRowNo") == "-1") {
				Effect.Appear($("messageAssdDiv"), {
					duration: 0.2
				});
			} else if ($F("gipdChanged"+$F("currentRowNo")) != "N") {
				Effect.Appear($("messageAssdDiv"), {
					duration: 0.2
				});
			}
		}
	});
	$("txtDrvIntmName").observe("focus", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O") || (objACGlobal.orFlag != "P" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D")) {
			if ($F("currentRowNo") == "-1") {
				Effect.Appear($("messageIntmDiv"), {
					duration: 0.2
				});
			} else if ($F("gipdChanged"+$F("currentRowNo")) != "N") {
				Effect.Appear($("messageIntmDiv"), {
					duration: 0.2
				});
			}
		}
	});
	$("txtDrvRiName").observe("focus", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O") || (objACGlobal.orFlag != "P" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D")) {
			if ($F("currentRowNo") == "-1") {
				Effect.Appear($("messageRiDiv"), {
					duration: 0.2
				});
			} else if ($F("gipdChanged"+$F("currentRowNo")) != "N") {
				Effect.Appear($("messageRiDiv"), {
					duration: 0.2
				});
			}
		}
	});
	$("txtDrvAssuredName").observe("blur", function() {
		Effect.Fade($("messageAssdDiv"), {
			duration: 0.1
		});
	});

	$("txtDrvIntmName").observe("blur", function() {
		Effect.Fade($("messageIntmDiv"), {
			duration: 0.1
		});
	});

	$("txtDrvRiName").observe("blur", function() {
		Effect.Fade($("messageRiDiv"), {
			duration: 0.1
		});
	}); */

	$("txtDrvAssuredName").observe("keydown", function(e) {
		if (e.keyCode == 8 && $F("currentRowNo") == -1) {
			$("txtAssdNo").value = "";
			$("txtAssuredName").value = "";
			$("txtDrvAssuredName").value = "";
		}
	});

	$("txtDrvIntmName").observe("keydown", function(e) {
		if (e.keyCode == 8 && $F("currentRowNo") == -1) {
			$("txtIntmNo").value = "";
			$("txtIntmName").value = "";
			$("txtDrvIntmName").value = "";
		}
	});

	$("txtDrvRiName").observe("keydown", function(e) {
		if (e.keyCode == 8 && $F("currentRowNo") == -1) {
			$("txtRiCd").value = "";
			$("txtRiName").value = "";
			$("txtDrvRiName").value = "";
		}
	});

	//validations
	$("txtItemNo").observe("change", function() {
		if (isNaN($F("txtItemNo"))) {
			showMessageBox("Invalid value of Item No. Value should be from 1 to 999,999,999", imgMessage.ERROR); 
			$("txtItemNo").value = $F("lastItemNo");
			$("txtItemNo").focus();
			return false;
		} else if (parseInt(nvl($F("txtItemNo"), "0")) <= 0  || parseInt(nvl($F("txtItemNo"), "0")) > 999999999) { 
			showMessageBox("Required fields must be entered.", imgMessage.ERROR); 
			$("txtItemNo").value = $F("lastItemNo");
			$("txtItemNo").focus();
			return false;
		} /*else if (checkIfExisting()) {
			$("txtItemNo").value = $F("lastItemNo");
			showMessageBox("Item no. is already existing", imgMessage.ERROR);
			$("txtItemNo").focus();
			return false;
		}*/ else if (getDecimalLength($F("txtItemNo")) > 0) {
			showMessageBox("Invalid value of Item No. Value should be from 1 to 999,999,999", imgMessage.ERROR); 
			$("txtItemNo").value = $F("lastItemNo");
			$("txtItemNo").focus();
			return false;
		} else if (checkIfItemNoExists(parseInt($F("txtItemNo")))) {
			$("txtItemNo").value = $F("lastItemNo");
			showMessageBox("Item no. is already existing", imgMessage.ERROR);
			$("txtItemNo").focus();
			return false;
		} else {
			$("txtItemNo").value = parseInt($F("txtItemNo"));
			$("lastItemNo").value = $F("txtItemNo");
		}
	});

	$("txtTranYear").observe("change", function() {
		if (isNaN($F("txtTranYear"))) {
			$("txtTranYear").value = "";
			showMessageBox("Field must be of form 9999.", imgMessage.ERROR);
		}
		/*if (!$F("txtTranYear").blank()) {
			validateTranType2();
		}*/
	});

	$("txtTranMonth").observe("change", function() {
		if (isNaN($F("txtTranMonth"))) {
			$("txtTranMonth").value = $F("lastTranMonth");
			showMessageBox("Field must be of form 09.", imgMessage.ERROR);
		} else {
			//validateTranType2();
			$("txtTranMonth").value = $F("txtTranMonth").blank() ? "" : parseInt($F("txtTranMonth"), 10).toPaddedString(2);
			$("lastTranMonth").value = $F("txtTranMonth");
		}
	});

	$("txtTranSeqNo").observe("change", function() {
		if (isNaN($F("txtTranSeqNo"))) {
			$("txtTranSeqNo").value = $F("lastTranSeqNo");
			showMessageBox("Field must be of form 09.", imgMessage.ERROR);
		} else {
			//validateTranType2();
			$("lastTranSeqNo").value = $F("txtTranSeqNo");
		}
	});

	$("txtOldItemNo").observe("change", function() {
		if (isNaN($F("txtOldItemNo"))) {
			$("txtOldItemNo").value = $F("lastOldItemNo");
			showMessageBox("Field must be of form 09.", imgMessage.ERROR);
		} else if ($F("txtTranYear").blank() || $F("txtTranMonth").blank() || $F("txtTranSeqNo").blank()) {
			$("txtOldItemNo").value = "";
			showMessageBox("User supplied value is required for old transaction no.", imgMessage.ERROR);
		} else {
			validateTranType2();
			$("txtOldItemNo").value = $F("txtOldItemNo").blank() ? "" : parseInt($F("txtOldItemNo"), 10).toPaddedString(2);
			$("lastOldItemNo").value = $F("txtOldItemNo");
		}
	});

	$("txtOldTranType").observe("change", function() {
		if (isNaN($F("txtOldTranType"))) {
			$("txtOldTranType").value = $F("lastOldTranType");
			showMessageBox("Field must be of form 09.", imgMessage.ERROR);
		} else if (!$F("txtTranYear").blank() && !$F("txtTranMonth").blank() && !$F("txtTranSeqNo").blank() &&
					!$F("txtOldItemNo").blank() && !$F("txtOldTranType").blank() && !$F("txtTransactionType").blank()) {
			validateOldTranType();
		}
	});

	$("txtOldTranType").observe("focus", function() {
		if ($F("oldTranTypeOkForValidation") == "Y") {
			validateOldTranType();
			$("oldTranTypeOkForValidation").value = "N";
		}
	});

	function validateOldTranType() {
		//getParSeqNo();
		collectionDefaultAmount($F("txtTransactionType"));
		//validateTranType2();
		
		$("lastOldTranType").value = $F("txtOldTranType");
	}

	$("txtTransactionType").observe("change", function() {
		if (checkIfExisting()) {
			$("txtTransactionType").value = "";
			showMessageBox("A record with the same item no and transaction type already exists.", imgMessage.ERROR);
			$("txtTransactionType").focus();
		} else {
			if ($F("varLovSwitch") == 1) {
				if ($F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
					$("varPckSwitch").value = 1;
					$("txtOldTranId").value = $F("varTranId");
					
					$("txtPolicyNo").value = "";
					//$("txtPolicyNo").disable();
				} else {
					$("varPckSwitch").value = 2;
					//$("txtPolicyNo").enable();
				}
			}
			$("txtCollectionAmt").value = "";
	
			enableDisableDisp();
			//changeLOVProperty();
			transactionTypeTrigger();
			currencyCdTrigger();
			defCurrency();
		}

	});

	$("txtB140IssCd").observe("change", function() {
		premDepIssCdTrigger();
		$("txtB140PremSeqNo").focus();
	});

	$("txtB140PremSeqNo").observe("change", function() {
		if ($F("txtB140IssCd").blank() && $F("txtB140PremSeqNo").blank() && $F("txtInstNo").blank()) {
			return false;
		} else {
			if (isNaN($F("txtB140PremSeqNo"))) {
				$("txtB140PremSeqNo").value = $F("lastB140PremSeqNo");
				showMessageBox("Invalid invoice no. Value must be from 1 to 999999999999", imgMessage.ERROR);
			} else if (parseInt($F("txtB140PremSeqNo").replace(/,/g,"")) > 999999999999 ||
					parseInt($F("txtB140PremSeqNo").replace(/,/g,"")) < 1) {
				$("txtB140PremSeqNo").value = $F("lastB140PremSeqNo");
				showMessageBox("Invalid invoice no. Value must be from 1 to 999999999999", imgMessage.ERROR);
			} else if (getDecimalLength($F("txtB140PremSeqNo")) > 0) {
				showMessageBox("Invalid invoice no. Value must be from 1 to 999999999999", imgMessage.ERROR);
				$("txtB140PremSeqNo").value = $F("lastB140PremSeqNo");
				$("txtB140PremSeqNo").focus();
				return false;
			} else {
				$("lastB140PremSeqNo").value = $F("txtB140PremSeqNo");
			}
		}
	});

	$("txtInstNo").observe("change", function() {
		premDepInstNoPostText();
	});

	$("txtCollectionAmt").observe("change", function() {
		var var1;
		if ($F("txtCollectionAmt").blank()) {
			showMessageBox("Required Fields must be entered.", imgMessage.ERROR);
			$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
			return false;
		}
		if ($F("txtTransactionType") == 1) {
			 if (parseFloat(formatCurrency($F("txtCollectionAmt"))) <= 0) {
				$("txtCollectionAmt").value = $F("lastAmtValue");
				showMessageBox("Please enter positive value for tran type 1.", imgMessage.ERROR);
				return false;
			}else if (isNaN($F("txtCollectionAmt").replace(/,/g,"")) || parseFloat($F("txtCollectionAmt").replace(/,/g,"")) > 9999999999.99) {
				$("txtCollectionAmt").value = $F("lastAmtValue");
				showMessageBox("Invalid Amount. Value must be in range 0.01 to 9,999,999,999.99", imgMessage.ERROR);
				return false;
			}
		} else if ($F("txtTransactionType") == 2) {
			if (parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 0)) > 0) {
				showMessageBox("Reverting to default value/old value", imgMessage.ERROR);
				if (parseFloat($F("varPckDefaultValue")) > parseFloat($F("txtDefaultValue")) && !$F("varPckDefaultValue").blank()) {
					$("txtCollectionAmt").value = $F("varPckDefaultValue");
				} else {
					$("txtCollectionAmt").value = $F("txtDefaultValue");
				}
			}else if (isNaN($F("txtCollectionAmt").replace(/,/g,""))) {
				$("txtCollectionAmt").value = $F("lastAmtValue");
				showMessageBox("Invalid Amount. Value must be in range -0.01 to -9,999,999,999.99", imgMessage.ERROR);
				return false;
			} else if (parseFloat(formatCurrency($F("txtCollectionAmt"))) == 0) {
				showMessageBox("Zero value is not allowed. Re-enter amount. ", imgMessage.ERROR);
				$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
				return false;
			}
		} else if ($F("txtTransactionType") == 3) {
			if (parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 0)) >= 0) {
				$("txtCollectionAmt").value = $F("lastAmtValue");
				showMessageBox("Please enter negative value for tran type 3.", imgMessage.ERROR);
				return false;
			}else if (isNaN($F("txtCollectionAmt").replace(/,/g,""))) {
				$("txtCollectionAmt").value = $F("lastAmtValue");
				showMessageBox("Invalid Amount. Value must be in range -0.01 to -9,999,999,999.99", imgMessage.ERROR);
				return false;
			}
		} else if ($F("txtTransactionType") == 4) {
			//if ($F("txtTransactionType") != 2) {
				if (parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 0)) <= 0) {
					showMessageBox("Reverting to default value/old value", imgMessage.ERROR);
					if (parseFloat($F("varPckDefaultValue")) > parseFloat($F("txtDefaultValue")) && !$F("varPckDefaultValue").blank()) {
						$("txtCollectionAmt").value = $F("varPckDefaultValue");
					} else {
						$("txtCollectionAmt").value = $F("txtDefaultValue");
					}
				}else if (isNaN($F("txtCollectionAmt").replace(/,/g,""))) {
					$("txtCollectionAmt").value = $F("lastAmtValue");
					showMessageBox("Invalid Amount. Value must be in range 0.01 to 9,999,999,999.99", imgMessage.ERROR);
					return false;
				}
			//}
		}

		$("cg$ctrlTotalCollections").value = parseFloat(nvl($F("cg$ctrlTotalCollections").replace(/,/g,""), 0)) +
		parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 0));

		if (parseFloat($F("txtCollectionAmt")) == 0) {
			$("txtCollectionAmt").value = $F("lastAmtValue");
			showMessageBox("Zero value is not allowed Re-enter amount.", imgMessage.ERROR);
			return false;
		}

		if (Math.round(nvl($F("varCollectionAmt").replace(/,/g,""), 0)) != Math.round(nvl($F("txtCollectionAmt").replace(/,/g,""), 0))) {
			if (!$F("txtConvertRate").blank()) {
				var1 = parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 0)) / parseFloat($F("txtConvertRate"));
				$("txtForeignCurrAmt").value = formatCurrency(var1);
			}
		}

		if ($F("txtTransactionType") == 2 && !$F("txtItemNo").blank()) {
			if (Math.abs(parseFloat($F("txtCollectionAmt"))) > Math.abs(parseFloat($F("txtDefaultValue")))){
				if ($F("varPckDefaultValue") < $F("txtDefaultValue")) {
					$("txtCollectionAmt").value = formatCurrency($F("varPckDefaultValue"));
				} else {
					$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
				}
				showMessageBox("Refund/Reclassification amount cannot be more than the total collected amount of P " + $F("txtDefaultValue"), imgMessage.INFO);
			} else {
				$("varPckDefaultValue").value = $F("txtCollectionAmt");
			}

			if ($F("varPckSwitch") != 1) {
				$("txtCollectionAmt").value = formatCurrency($F("varPckDefaultValue"));
			}
		}

		if ($F("txtTransactionType") == 4 && !$F("txtItemNo").blank()) {
			if (Math.abs(parseFloat($F("txtCollectionAmt"))) > Math.abs(parseFloat($F("txtDefaultValue")))){
				if ($F("varPckDefaultValue") < $F("txtDefaultValue")) {
					$("txtCollectionAmt").value = formatCurrency($F("varPckDefaultValue"));
				} else {
					$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
				}
				showMessageBox("Refund/Reclassification amount cannot be more than the total collected amount of P " + $F("txtDefaultValue"), imgMessage.INFO);
			} else {
				$("varPckDefaultValue").value = $F("txtCollectionAmt");
			}

			if ($F("varPckSwitch") != 1) {
				$("txtCollectionAmt").value = formatCurrency($F("varPckDefaultValue"));
			}
		}

		defCurrency();
		$("txtCollectionAmt").value = formatCurrency($F("txtCollectionAmt"));
		$("lastAmtValue").value = $F("txtCollectionAmt");
	});

	$("txtCurrencyCd").observe("change", function() {
		enableDisableDisp();
		currencyCdTrigger();
	});

	$("txtConvertRate").observe("focus", function() {
		$("varPckDefaultValue2").value = $F("txtConvertRate");
	});

	$("txtConvertRate").observe("change", function() {
		var vForeignCurrAmt;
		if ($F("txtConvertRate").blank()) {
			$("txtConvertRate").value = $F("varPckDefaultValue2");
			return false;
		} else if (isNaN($F("txtConvertRate"))) {
			showMessageBox("Invalid value of Currency Rate. Value must be in range .000000001 to 999.999999999", imgMessage.ERROR);
			$("txtConvertRate").value = $F("varPckDefaultValue2");
		} else if (parseFloat($F("txtConvertRate").replace(/,/g,"")) < 0.000000001) {
			showMessageBox("Please enter a positive value for conversion rate", imgMessage.ERROR);
			$("txtConvertRate").value = $F("varPckDefaultValue2");
		} else if (parseFloat($F("txtConvertRate").replace(/,/g,"")) > 999.999999999) {
			showMessageBox("Invalid value of Currency Rate. Value must be in range .000000001 to 999.999999999", imgMessage.ERROR);
			$("txtConvertRate").value = $F("varPckDefaultValue2");
		} else if (parseFloat(truncateDecimal(parseFloat(nvl($F("txtConvertRate"), "0")), 9)) == 0) {
			showMessageBox("Invalid value of Currency Rate. Value must be in range .000000001 to 999.999999999", imgMessage.ERROR);
			$("txtConvertRate").value = $F("varPckDefaultValue2");
			return false;
		} else {
			$("txtConvertRate").value = $F("varPckDefaultValue2");
			if ($F("txtTransactionType") == 1) {
				if ($F("currentRowNo") == -1) {
					$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")));
				}
			} else {
				if ($F("currentRowNo") == -1) {
					vForeignCurrAmt = parseFloat(nvl($F("txtForeignCurrAmt").replace(/,/g,""), 0)) / parseFloat($F("txtConvertRate"));
					if (!$F("txtDefaultValue").blank()) {
						if (Math.round(vForeignCurrAmt) < Math.round((parseFloat($F("txtDefaultValue")) / parseFloat($F("txtConvertRate")))*100)) {
							$("txtConvertRate").value = truncateDecimal2(nvl($F("varPckDefaultValue2"), "0"), 9);
							$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")));
							showMessageBox("Amount exceeds ceiling.", imgMessage.ERROR);
							return false;
						} else {
							$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")));
							$("varPckDefaultValue2").value = $F("txtConvertRate");
						}
					}
				}
			}
			defCurrency();
			$("lastConvertRate").value = $F("txtConvertRate");
		}
	});

	$("txtForeignCurrAmt").observe("focus", function() {
		$("varPckDefaultValue2").value = $F("txtConvertRate");
	});

	$("txtForeignCurrAmt").observe("change", function() {
		/* var defaultCollAmt = parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), "0")) / $F("txtConvertRate");
		if (parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) > defaultCollAmt){
		} */
		if ($F("txtForeignCurrAmt").blank()) {
			showMessageBox("Amount cannot be null", imgMessage.ERROR);
			 $("txtForeignCurrAmt").value = "";
			return false;
		} 
		var vForeignCurrAmt;
		if ($F("txtTransactionType") == 1) {
			if (parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) < 0) {
				$("txtForeignCurrAmt").value = formatCurrency($F("lastForeignCurrAmt"));
				showMessageBox("Please enter positive value for tran type 1.", imgMessage.ERROR);
				return false;
			}else if(isNaN($F("txtForeignCurrAmt"))){
				showMessageBox("Invalid Amount. Value must be in range 0.01 to 9,999,999,999.99", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if (parseFloat(formatCurrency($F("txtForeignCurrAmt"))) == 0) {
				showMessageBox("Zero value is not allowed. Re-enter amount. ", imgMessage.ERROR);
				defCurrency();
				return false;
			} 
		}else if ($F("txtTransactionType") == 2) {
			if (parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) > 0) {
				showMessageBox("Please enter negative value for tran type 2.", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if(isNaN($F("txtForeignCurrAmt"))){
				showMessageBox("Invalid Amount. Value must be in range -0.01 to -9,999,999,999.99", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if (parseFloat(formatCurrency($F("txtForeignCurrAmt"))) == 0) {
				showMessageBox("Zero value is not allowed Re-enter amount. ", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if (Math.abs(parseFloat($F("txtForeignCurrAmt"))) > Math.abs(parseFloat($F("txtCollectionAmt")))){
				if ($F("varPckDefaultValue") < $F("txtDefaultValue")) {
					$("txtCollectionAmt").value = formatCurrency($F("varPckDefaultValue"));
				} else {
					$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
				}
				showMessageBox("Refund/Reclassification amount cannot be more than the total collected amount of P " + $F("txtDefaultValue"), imgMessage.INFO);
			}
		}
		else if($F("txtTransactionType") == 3){
			if(isNaN($F("txtForeignCurrAmt"))){
				showMessageBox("Invalid Amount. Value must be in range -0.01 to -9,999,999,999.99", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if (parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) > 0) {
				showMessageBox("Please enter negative value for tran type 3.", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if (parseFloat(formatCurrency($F("txtForeignCurrAmt"))) == 0){
				showMessageBox("Reverting to default value/old value", imgMessage.ERROR);
				defCurrency();
			}else if(parseFloat(formatCurrency($F("txtForeignCurrAmt"))) > -9999999999.99){
				showMessageBox("Invalid Amount. Value must be in range -0.01 to -9,999,999,999.99", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if (Math.abs(parseFloat($F("txtForeignCurrAmt"))) > Math.abs(parseFloat($F("txtCollectionAmt")))){
				if ($F("varPckDefaultValue") < $F("txtDefaultValue")) {
					$("txtCollectionAmt").value = formatCurrency($F("varPckDefaultValue"));
				} else {
					$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
				}
				showMessageBox("Refund/Reclassification amount cannot be more than the total collected amount of P " + $F("txtDefaultValue"), imgMessage.INFO);
			}
		}else if ($F("txtTransactionType") == 4) {
			if(isNaN($F("txtForeignCurrAmt"))){
				showMessageBox("Invalid Amount. Value must be in range 0.01 to 9,999,999,999.99", imgMessage.ERROR);
				defCurrency();
				return false;
			}else if ((parseFloat(formatCurrency($F("txtForeignCurrAmt"))) <= 0)){ 
				showMessageBox("Reverting to default value/old value", imgMessage.ERROR);
				defCurrency();
			}
		}
		if (!$F("txtTransactionType") == 1) {
			if (parseFloat($F("txtConvertRate")) < 0) {
				$("txtForeignCurrAmt").value = formatCurrency($F("lastForeignCurrAmt"));
				showMessageBox("Please enter positive value conversion rate", imgMessage.ERROR);
				return false;
			}
		}
		if ($F("currentRowNo") == -1) {
			vForeignCurrAmt = parseFloat(nvl($F("txtForeignCurrAmt").replace(/,/g,""), 0));
			tempProd = parseFloat(nvl($F("txtForeignCurrAmt"), 0)) * parseFloat(nvl($F("txtConvertRate"), 0));

			if (!$F("txtDefaultValue").blank()) {
				if (Math.round(parseFloat(vForeignCurrAmt)) 
						> (Math.round((parseFloat($F("txtDefaultValue")) / parseFloat($F("txtConvertRate"))))) * -1) {
					$("txtConvertRate").value = truncateDecimal2(nvl($F("varPckDefaultValue2"), "0"), 2);
					$("txtForeignCurrAmt").value = formatCurrency(Math.round((parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate").replace(/,/g,"")))));
					$("txtCollectionAmt").value = formatCurrency(Math.round((parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) * parseFloat($F("txtConvertRate").replace(/,/g,"")))));
					showMessageBox("Amount exceeds ceiling.", imgMessage.ERROR);
					return false;
				} else {
					$("txtCollectionAmt").value = formatCurrency((parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) * parseFloat($F("txtConvertRate").replace(/,/g,""))));
				}
			}

			$("txtCollectionAmt").value = formatCurrency((parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) * parseFloat($F("txtConvertRate").replace(/,/g,""))));
		}

		if ($F("txtConvertRate").blank()) {
			$("txtCollectionAmt").value = formatCurrency($F("varCollectionAmt"));
		}

		if (!$F("txtForeignCurrAmt").blank() && $F("txtCurrencyCd").blank()) {
			showMessageBox("Currency code must be entered first", imgMessage.ERROR);
		}
		$("txtForeignCurrAmt").value = formatCurrency($F("txtForeignCurrAmt"));
		$("lastForeignCurrAmt").value = formatCurrency($F("txtForeignCurrAmt"));
	});

	$("btnForeignCurrency").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			var ok = true;
			
			ok = checkRequiredFields();
	
			if (ok) {
				//$("currencyDiv").style.display = "block";
				defCurrency();
				
				Effect.Appear($("currencyDiv"), {
					duration: .2
				});
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else {
			var ok = true;
			
			ok = checkRequiredFields();
	
			if (ok) {
				//$("currencyDiv").style.display = "block";
				defCurrency();
				
				Effect.Appear($("currencyDiv"), {
					duration: .2
				});
			}
		}
		var ok = true;
		
		ok = checkRequiredFields();

		if (ok) {
			//$("currencyDiv").style.display = "block";
			defCurrency();
			
			Effect.Appear($("currencyDiv"), {
				duration: .2
			});
		}
	});

	$("btnHideCurrPage").observe("click", function() {
		//$("currencyDiv").style.display = "none";
		Effect.Fade($("currencyDiv"), {
			duration: .2
		});
	});

	$("btnSaveRecord").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			if (checkRequiredFields()) {
				saveRecord();
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if (checkRequiredFields()) {
			saveRecord();
		}
	});

	$("btnDelete").observe("click", function() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			if (checkRequiredFields()) {
				deleteRecord();
			}
		} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if (checkRequiredFields()) {
			deleteRecord();
		}
	});

	$$("div[name='rowPremDep']").each(function(row) {
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout",	function(){
			row.removeClassName("lightblue");
		});
	
		row.observe("click", function(){
			clickPremDepRow(row);
		});
	});

	$$("label[name='lblPremDep']").each(function(label) {
		if ((label.innerHTML).length > 20)	{
			label.update((label.innerHTML).truncate(15, "..."));
		}
	});

	$$("label[name='lblPremDepInstNo']").each(function(label) {
		if (!label.innerHTML.blank()) {
			label.update(parseInt(label.innerHTML, 10).toPaddedString(2));
		} else {
			label.update("---");
		}
	});

	$$("label[class='money']").each(function(label) {
		label.innerHTML = formatCurrency(parseFloat(label.innerHTML == "" ? "0" : label.innerHTML));
	});

	// module procedures/functions
	
	// PROCEDURE enable_disable_disp
	function enableDisableDisp() {
		if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
			//showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			enableDisableFields();
		} else {
			if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+$F("currentRowNo")) == "N") {
				//showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else {
				enableDisableFields();
			}
		}
	}

	function enableDisableFields() {
		if ($F("txtTransactionType") == 1 || $F("txtTransactionType") == 3) {
			$("txtTranYear").value = "";
			$("txtTranMonth").value = "";
			$("txtTranSeqNo").value = "";
			$("txtOldItemNo").value = "";
			$("txtOldTranType").value = "";

			//$("txtTranYear").disable();
			$("txtTranYear").readOnly = true;
			$("txtTranMonth").readOnly = true;
			$("txtTranSeqNo").readOnly = true;
			$("txtOldItemNo").readOnly = true;
			$("txtOldTranType").readOnly = true;
			
			$("txtB140IssCd").enable();
			$("txtB140PremSeqNo").readOnly = false;
			$("txtInstNo").readOnly = false;
			
			//$("txtCollectionAmt").readOnly = false;
		} else if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4) {
			$("txtB140IssCd").value = "";
			$("txtB140PremSeqNo").value = "";
			$("txtInstNo").value = "";
			
			//$("txtTranYear").enable();
			$("txtTranYear").readOnly = false;
			$("txtTranMonth").readOnly = false;
			$("txtTranSeqNo").readOnly = false;
			$("txtOldItemNo").readOnly = false;
			$("txtOldTranType").readOnly = false;

			$("txtB140IssCd").disable();
			$("txtB140PremSeqNo").readOnly = true;
			$("txtInstNo").readOnly = true;
		} else {
			//$("txtTranYear").disable();
			$("txtTranYear").readOnly = true;
			$("txtTranMonth").readOnly = true;
			$("txtTranSeqNo").readOnly = true;
			$("txtOldItemNo").readOnly = true;
			$("txtOldTranType").readOnly = true;

			$("txtB140IssCd").disable();
			$("txtB140PremSeqNo").readOnly = true;
			$("txtInstNo").readOnly = true;
		}

		if ($F("txtCurrencyCd").blank() && $F("currentRowNo") == -1) {
			$("txtCurrencyDesc").value = $F("dfltCurrencyDesc");
			$("txtConvertRate").value = truncateDecimal(parseFloat(nvl($F("dfltCurrencyRt"), "0")), 2);
			$("txtCurrencyCd").value = $F("dfltMainCurrencyCd");
		}

		if ($F("dfltCurrencyCd") == $F("txtCurrencyCd")) {
			$("txtConvertRate").readOnly = true;
		} else {
			$("txtConvertRate").readOnly = false;
		}
	}

	// PROCEDURE change_lov_property
	function changeLOVProperty() {

		if ($F("txtTransactionType") == 2) {
			$("cgfk$GipdOldItemNo").value = "oldItemRow";
		} else if ($F("txtTransactionType") == 4) {
			$("cgfk$GipdOldItemNo").value = "oldItemFor4Row";
		}
	}

	// PROCEDURE validate_tran_type2
	function validateTranType2() {
		new Ajax.Request(contextPath+"/GIACPremDepositController?action=validateTranType2", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			parameters: {
				transactionType: $F("txtTransactionType"),
				dspTranYear: $F("txtTranYear"),
				dspTranMonth: $F("txtTranMonth"),
				dspTranSeqNo: $F("txtTranSeqNo"),
				dspTranClassNo: $F("txtDspTranClassNo"),
				oldItemNo: $F("txtOldItemNo"),
				oldTranType: $F("txtOldTranType"),
				oldTranId: $F("txtOldTranId"),
				assdNo: $F("txtAssdNo"),
				parSeqNo: $F("txtParSeqNo"),
				parYy: $F("txtParYy"),
				quoteSeqNo: $F("txtQuoteSeqNo"),
				lineCd: $F("txtLineCd"),
				sublineCd: $F("txtSublineCd"),
				issCd: $F("txtIssCd"),
				issueYy: $F("txtIssueYy"),
				polSeqNo: $F("txtPolSeqNo"),
				renewNo: $F("txtRenewNo"),
				b140IssCd: $F("txtB140IssCd"),
				b140PremSeqNo: $F("txtB140PremSeqNo"),
				instNo: $F("txtInstNo"),
				parLineCd : $F("txtParLineCd"),
				parIssCd : $F("txtParIssCd"),
				parNo: $F("txtParNo")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (result.message != "SUCCESS") {
						showMessageBox(result.message, imgMessage.INFO);
					}

					$("txtTransactionType").value = result.transactionType;
					$("txtTranYear").value = result.dspTranYear;
					$("txtTranMonth").value = result.dspTranMonth;
					$("txtTranSeqNo").value = result.dspTranSeqNo;
					$("txtDspTranClassNo").value = result.dspTranClassNo;
					$("txtOldItemNo").value = result.oldItemNo;
					$("txtOldTranType").value = result.oldTranType;
					$("txtOldTranId").value = result.oldTranId;
					$("txtAssdNo").value = result.assdNo;
					$("txtParSeqNo").value = result.parSeqNo;
					$("txtParYy").value = result.parYy;
					$("txtQuoteSeqNo").value = result.quoteSeqNo;
					$("txtLineCd").value = result.lineCd;
					$("txtSublineCd").value = result.sublineCd;
					$("txtIssCd").value = result.issCd;
					$("txtIssueYy").value = result.issueYy;
					$("txtPolSeqNo").value = result.polSeqNo;
					$("txtRenewNo").value = result.renewNo;
					$("txtB140IssCd").value = result.b140IssCd;
					$("txtB140PremSeqNo").value = result.b140PremSeqNo;
					$("txtInstNo").value = result.instNo;
					$("txtParLineCd").value = result.parLineCd;
					$("txtParIssCd").value = result.parIssCd;
					$("txtParNo").value = result.dspParNo;
				} else {
					showMessageBox(response.responseText, imgMessage.INFO);
				}
			}
		});
		currencyCdTrigger();
		premDepUpdatePolicyNo();
		premDepUpdateParNo();
	}

	// PROCEDURE get_par_seq_no
	/* function getParSeqNo() {
		new Ajax.Request(contextPath+"/GIACPremDepositController?action=getParSeqNo", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			parameters: {
				oldItemNo: $F("txtOldItemNo"),
				oldTranType: $F("txtOldTranType"),
				oldTranId: $F("txtOldTranId")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					$("txtParLineCd").value = result.parLineCd;
					$("txtParIssCd").value = result.parIssCd;
					$("txtParYy").value = result.parYy;
					$("txtParSeqNo").value = result.parSeqNo;
					$("txtQuoteSeqNo").value = result.quoteSeqNo;

					premDepUpdateParNo();
				} else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	} */

	// PROCEDURE collection_default_amount or collection_dflt_amt_for_4, depending on the parameter value
	// removed
	/*function collectionDefaultAmt(tranType) {
		var colVar = 0;
		var totalVar = 0;
		var subTotalVar = 0;
		var count = 0;
		var vOldTranId = "";
		var result = true;
		var msg = "";

		$("varPckSwitch").value = 2;

		if ($F("txtOldTranId").blank()) {
			var rowName = $F("cgfk$GipdOldItemNo").blank() ? "" : ($F("cgfk$GipdOldItemNo") == "oldItemRow" ? "rowOldItemNo" : "rowOldItemNoFor4");
			
			$$("div[name='"+rowName+"']").each(function(row) {
				if ($F("txtTranYear") == row.down("input", 5).value && parseInt($F("txtTranMonth"), 10) == row.down("input", 6).value &&
						parseInt($F("txtTranSeqNo")) == row.down("input", 7).value && parseInt($F("txtOldItemNo"), 10) == row.down("input", 1).value) {
					if (tranType == 1) {
						vOldTranId = row.down("input", 25).value;
					} else if (tranType == 3) {
						vOldTranId = row.down("input", 26).value;
					}
				}
				count++;
				return false;
			});

			if (vOldTranId.blank()) {
				//showMessageBox("No Bill Existing", imgMessage.INFO);
				msg = "No Bill Existing";
			} else {
				$("txtOldTranId").value = vOldTranId;
			}
		}

		if (!msg.blank()) {
			showMessageBox(msg, imgMessage.INFO);
			return false;
		}

		count = 0;

		$("varPckSwitch").value = 1;

		msg = "This Old Tran Id, Old Item No., Old Tran. Type does not exist";

		$$("div[id='giacPremDep"+parseInt($F("txtOldTranId"))+"-"+parseInt($F("txtOldItemNo"), 10)+"']").each(function(row) {
			if (row.down("input", 16).value == tranType) {
				msg = "";
				colVar = row.down("input", 17).value;
				count = count + 1;
	  			return false;
			}
		});

		if (count == 0) {
			if (!msg.blank()) {
				showMessageBox(msg, imgMessage.INFO);
			}
			return false;
		}

		$("varPckTotColl").value = colVar;

		if (tranType == 1) {
			$$("div[id='collectionAmtFor2"+parseInt($F("txtOldTranId"))+"-"+parseInt($F("txtOldItemNo"), 10)+"']").each(function(row) {
				totalVar = row.down("input", 2).value;
		  		return false;
			});
		} else if (tranType == 3) {
			$$("div[id='collectionAmtFor4"+$F("txtGaccTranId")+"-"+parseInt($F("txtOldTranId"))+"-"+parseInt($F("txtOldItemNo"), 10)+"']").each(function(row) {
				totalVar = row.down("input", 3).value;
		  		return false;
			});
		}

		$("varPckTotColl2").value = totalVar;
		$("varPckGcbaGti").value = $F("txtOldTranId");
		$("varPckGcbaIn").value = parseInt($F("txtOldItemNo"), 10);
		$("txtDefaultValue").value = (parseFloat(colVar) + parseFloat(totalVar)) * -1;

		if (tranType == 3) {
			$("txtCollectionAmt").value = "";
		}

		if (tranType == 1) {
			$("cg$ctrlTotalCollections").value = ($F("cg$ctrlTotalCollections").blank() ? 0 : parseFloat($F("cg$ctrlTotalCollections").replace(/,/g,""))) +
									($F("txtCollectionAmt").blank() ? 0 : parseFloat($F("txtCollectionAmt").replace(/,/g,"")));
		}

		if ($F("txtDefaultValue") == 0) {
			if (tranType == 1) {
				$F("txtItemNo").value = 0;
			}
			//showMessageBox((tranType == 3) ? "COLLECTION AMT 4 " : "" + "Fully Recovered.", imgMessage.INFO);
			msg = (tranType == 3) ? "COLLECTION AMT 4 " : "" + "Fully Recovered.";
		}

		if (!msg.blank()) {
			showMessageBox(msg, imgMessage.INFO);
		}

		currencyCdTrigger();
		return true;
	}*/

	// PROCEDURE collection_default_amount or collection_dflt_amt_for_4, depending on the parameter value
	function collectionDefaultAmount(tranType) {
		var ok = true;
		
		new Ajax.Request(contextPath+"/GIACPremDepositController?action=collectionDefaultAmount", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			parameters: {
				gaccTranId: objACGlobal.gaccTranId,
				transactionType: tranType,
				dspTranYear: $F("txtTranYear"),
				dspTranMonth: $F("txtTranMonth"),
				dspTranSeqNo: $F("txtTranSeqNo"),
				oldItemNo: $F("txtOldItemNo"),
				defaultValue: $F("txtDefaultValue"),
				oldTranId: $F("txtOldTranId"),
				varPckSwtch: $F("varPckSwitch"),
				varPckTotColl: $F("varPckTotColl"),
				varPckTotColl2: $F("varPckTotColl2"),
				varPckGcbaGti: $F("varPckGcbaGti"),
				varPckGcbaIn: $F("varPckGcbaIn")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (result.message != "SUCCESS") {
						showMessageBox(result.message, imgMessage.INFO);
						ok = false;
					}

					$("txtDefaultValue").value = result.defaultValue;
					$("txtOldTranId").value = result.oldTranId;
					$("varPckSwitch").value = result.varPckSwtch;
					$("varPckTotColl").value = result.varPckTotColl;
					$("varPckTotColl2").value = result.varPckTotColl2;
					$("varPckGcbaGti").value = result.varPckGcbaGti;
					$("varPckGcbaIn").value = result.varPckGcbaIn;
				} else{
					showMessageBox(response.responseText, imgMessage.ERROR);
					ok = false;
				}
			}
		});

		return ok;
	}

	function defCurrency() {
		if ($F("txtCurrencyCd").blank()) {
			if ($F("currentRowNo") == -1) {
				$("txtDspCurrencyDesc").value = $F("dfltCurrencyDesc");
				$("txtConvertRate").value = truncateDecimal(parseFloat(nvl($F("dfltCurrencyRt"), "0")), 2);
				$("txtCurrencyCd").value = $F("dfltCurrencyCd");
			}
		}

		if ($F("currentRowNo") == -1) {
			var foreignCurrAmt = nvl($F("txtCollectionAmt"), 0) / parseFloat($F("txtConvertRate"));

			if (nvl(foreignCurrAmt, 0) != nvl($F("txtForeignCurrAmt").replace(/,/g,""), 0)) {
				$("txtForeignCurrAmt").value = formatCurrency(foreignCurrAmt);
			}
			$("txtForeignCurrAmt").value = formatCurrency((parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), "0")) / $F("txtConvertRate")));
		}
	}

	// page functions
	function clickPremDepRow(row) {
		$$("div#premiumDepositTable div[name='rowPremDep']").each(function(r){
			if(row.getAttribute("id") != r.getAttribute("id")){
				r.removeClassName("selectedRow");
			}
		});
		
		row.toggleClassName("selectedRow");

		var itemFields = ["ItemNo", "TransactionType", "AssuredName", "OldItemNo", "OldTranType",
		      				"InstNo", "CollectionAmt", "PolicyNo", "B140IssCd", "TranYear", "TranMonth", "TranSeqNo",
		      				"OldItemNo", "OldTranType", "B140PremSeqNo", "OldTranId", "CurrencyCd",
		      				"ConvertRate", "LineCd", "SublineCd", "IssCd", "IssueYy", "PolSeqNo",
		      				"RenewNo", "ParSeqNo", "ParYy", "QuoteSeqNo", "AssdNo", "RiCd", "RiName", "GaccTranId",
		      				"ForeignCurrAmt", "Remarks",
		      				"IntmNo", "IntmName", "ParLineCd", "ParIssCd", "DepFlag", "ParNo"
		      			];

		if (row.hasClassName("selectedRow")) {
  			for (var i = 0; i < itemFields.length; i++) {
  	  			$("txt"+itemFields[i]).value = $F("gipd"+itemFields[i]+row.down("input", 0).value);
  			}
			$("txtDrvAssuredName").value = ($F("txtAssdNo").blank() || $F("txtAssuredName").blank()) ? "" : $F("txtAssdNo") + " - " + $F("txtAssuredName");
  			$("txtDrvIntmName").value = ($F("txtIntmNo").blank() || $F("txtIntmName").blank()) ? "" : $F("txtIntmNo") + " - " + $F("txtIntmName");
  			$("txtDrvRiName").value = ($F("txtRiCd").blank() || $F("txtRiName").blank()) ? "" : $F("txtRiCd") + " - " + $F("txtRiName");
  			if (!$F("gipdCollnDt"+row.down("input", 0).value).blank()) {
  				$("txtCollnDt").value = new Date($F("gipdCollnDt"+row.down("input", 0).value).replace(/-/g,"/")).format("mm-dd-yyyy");
			}
  			$("txtCollectionAmt").value = formatCurrency($F("txtCollectionAmt"));// = $F("txtCollectionAmt").blank() ? "" : formatCurrency($F("txtCollectionAmt"));

  			if ($F("gipdOrTag"+row.down("input", 0).value) == "V") {
  	  			$("orTagVAT").checked = true;
  			} else {
  				$("orTagNonVAT").checked = true;
  			}
			
  			if (objACGlobal.orFlag == "P" || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
  	  			if (objACGlobal.orFlag == "P" && $F("gipdChanged"+row.down("input", 0).value) != "N" && $F("hidAccTransTranFlag") == "O") {
		  			$$("select").each(function(row) {
		  	  			row.enable();
		  			});
  	  			} else {
	  	  			$$("select").each(function(row) {
		  	  			row.disable();
		  			});
  	  			}
  			}
  			if($F("gipdChanged"+row.down("input", 0).value) == "N"){
  				$$("input[type='text']").each(function(row) {
	  	  			row.readOnly = true;
	  			});
  			}

  			//format fields
  			$("txtTranMonth").value = $F("txtTranMonth").blank() ? "" : parseInt($F("txtTranMonth"), 10).toPaddedString(2);
  			$("txtOldItemNo").value = $F("txtOldItemNo").blank() ? "" : parseInt($F("txtOldItemNo"), 10).toPaddedString(2);
  			$("txtInstNo").value = $F("txtInstNo").blank() ? "" : parseInt($F("txtInstNo"), 10).toPaddedString(2);

  			$("btnSaveRecord").value = "Update";
  			saveRecTag = "Update";
  			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
  				disableButton($("btnSaveRecord"));
  				disableButton($("btnDelete"));
  			} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+row.down("input", 0).value) == "N") {
  				disableButton($("btnSaveRecord"));
  				disableButton($("btnDelete"));
  			} else if (objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+row.down("input", 0).value) == "N") {
  				disableButton($("btnSaveRecord"));
  				enableButton($("btnDelete"));
  			} else {
  				enableButton($("btnSaveRecord"));
  				enableButton($("btnDelete"));
  			}
  			$("currentRowNo").value = row.down("input", 0).value;
  			premDepUpdateParNo();
  			$("hrefCollnDate").style.display = "none";
		} else {
			resetFields();
		}

		//transactionTypeTrigger();

		if ($F("dfltCurrencyCd") == $F("txtCurrencyCd")) {
			$("txtConvertRate").readOnly = true;
		} else {
			$("txtConvertRate").readOnly = false;
		}
		currencyCdTrigger();
	}

	// Get Max item no.
	function getMaxItemNo() {
		var itemNo = 0;

		$$("div[name='rowPremDep']").each(function(row) {
			var temp = parseInt(row.down("input", 2).value);
			if (temp > itemNo) {
				itemNo = temp;
			}
		});
		return itemNo + 1;
	}

	// Get Max row no. For easy manipulation of record rows
	function getMaxRowNo() {
		var rowNo = -1;

		$$("div[name='rowPremDep']").each(function(row) {
			var temp = parseInt(row.down("input", 0).value);
			if (temp > rowNo) {
				rowNo = temp;
			}
		});
		return rowNo + 1;
	}
	
	$("txtDepFlag").selectedIndex = 2;
	// Resets input fields
	function resetFields() {
		var itemFields = ["ItemNo", "TransactionType", "AssuredName", "OldItemNo", "OldTranType",
		      				"InstNo", "CollectionAmt", "PolicyNo", "B140IssCd", "TranYear", "TranMonth", "TranSeqNo",
		      				"OldItemNo", "OldTranType", "B140PremSeqNo", "OldTranId", "CurrencyCd",
		      				"ConvertRate", "LineCd", "SublineCd", "IssCd", "IssueYy", "PolSeqNo",
		      				"RenewNo", "ParSeqNo", "ParYy", "QuoteSeqNo", "AssdNo", "RiCd", "RiName", "GaccTranId",
		      				"DrvIntmName", "DrvRiName",
		      				"DrvAssuredName", "ForeignCurrAmt", "Remarks", "CollnDt",
		      				"IntmNo", "IntmName", "ParLineCd", "ParIssCd", "ParNo"
		      			];
		
		for (var i = 0; i < itemFields.length; i++) {
			$("txt"+itemFields[i]).value = "";
			/*if ($("txt"+itemFields[i]).readOnly) {
	  				$("txt"+itemFields[i]).readOnly = false;
			}*/

			/*if ($("txt"+itemFields[i]).disabled) {
				$("txt"+itemFields[i]).enable();
			}*/
		
	  		if (itemFields[i] == "CurrencyCd") {
	  	 			$("txt"+itemFields[i]).value = $F("dfltCurrencyCd");
	  		} else if (itemFields[i] == "ConvertRate") {
	  	 			$("txt"+itemFields[i]).value = 1.00;
	  		}
		}

		//$("txtDepFlag").selectedIndex = 0;
		$("txtDepFlag").selectedIndex = 2;

		$$("select").each(function(row) {
	  		row.enable();
		});

		$("txtItemNo").value = getMaxItemNo();
		$("lastItemNo").value = $F("txtItemNo");
		$("txtCollnDt").value = new Date().format("mm-dd-yyyy");
		//$("btnSaveRecord").value = "Add";
		saveRecTag = "Add";
		//if ($("btnSaveRecord").disabled && ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O") || (objACGlobal.orFlag != "P" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"))) {
			enableButton($("btnSaveRecord")); 
		//}
		//if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O") || (objACGlobal.orFlag != "P" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D")) {
			disableButton($("btnDelete"));
			$("btnSaveRecord").value = "Add";
		//}
		$("currentRowNo").value = -1;
		$("currencyDiv").style.display = "none";
		$("orTagNonVAT").checked = true;
		$("hrefCollnDate").style.display = "block";

		// enable fields
		$("txtItemNo").readOnly = false;
		$("txtCollectionAmt").readOnly = false;
		$("txtRemarks").readOnly = false;
		$("txtCurrencyCd").readOnly = false;
		$("txtForeignCurrAmt").readOnly = false;
		
		enableDisableDisp();
	}

	//Add new prem dep record or update existing prem dep record
	function saveRecord() {
		if (checkGipdGipdFkConstraint()) {
			var content = getUpdatedContent();
			defCurrency();
			
			if (saveRecTag == "Add") {
				$("premDepListLastNo").value = parseInt($F("premDepListLastNo")) + 1;
				
				var itemTable = $("premiumDepositTableContainer");
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "row"+$F("premDepListLastNo"));
				newDiv.setAttribute("name", "rowPremDep");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});
				
				newDiv.observe("mouseover",
					function(){
						newDiv.addClassName("lightblue");
				});
	
				newDiv.observe("mouseout",
					function(){
						newDiv.removeClassName("lightblue");
				});
	
				newDiv.observe("click",
					function(){
						clickPremDepRow(newDiv);
				});
	
				Effect.Appear(newDiv, {
					duration: .2
				});
	
				$$("div[name='premDepRowDeleted']").each(function(row) {
					if (row.down("input", 1).value == parseInt(newDiv.down("input",2).value) 
							&& row.down("input", 2).value == parseInt(newDiv.down("input", 6).value)) {
						row.remove();
						return false;
					}
				});
	
				resetFields();
				checkTableIfEmpty("rowPremDep", "premiumDepositTableMainDiv");
				checkIfToResizeTable("premiumDepositTableContainer", "rowPremDep");
			} else {
				$("row"+$F("currentRowNo")).update(content);
			}

			$("lblTotalCollectionAmt").innerHTML = formatCurrency(getTotalCollectionAmt());
		} else {
			showMessageBox("This Old Tran Id,Old Item No.,Old Tran. Type does not exist", imgMessage.ERROR);
		}
		enableButton($("btnSavePremDep"));
	}

	//Delete prem dep record
	function deleteRecord() {
		var row = $("row"+$F("currentRowNo"));
		
		// add the record to delete list, save the gacc_tran_id, item_no, and transaction_type,
		// add only if record is not recently added
		if (row.down("input", 46).value != "A") {
			var deleteDiv = $("deletePremDepList");
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "premDepRowDeleted"+row.down("input", 2).value+"-"+row.down("input",6).value);
			newDiv.setAttribute("name", "premDepRowDeleted");
			newDiv.update(
					'<input type="hidden" id="deletedGipdGaccTranId" 		name="deletedGipdGaccTranId" 	  value="'+$F("gaccTranId")+'" />' +
					'<input type="hidden" id="deletedGipdItemNo" 			name="deletedGipdItemNo" 		  value="'+$F("txtItemNo")+'" />' +
					'<input type="hidden" id="deletedGipdTransactionType" 	name="deletedGipdTransactionType" value="'+$F("txtTransactionType")+'" />'
					);
	
			deleteDiv.appendChild(newDiv);
		}

		// delete the record from the main container div
		Effect.Fade(row, {
			duration: .2,
			afterFinish: function() {
				row.remove();
				resetFields();
				checkTableIfEmpty("rowPremDep", "premiumDepositTableMainDiv");
				$("lblTotalCollectionAmt").innerHTML = formatCurrency(getTotalCollectionAmt());
			}
		});
		enableButton($("btnSavePremDep"));
	}

	//Get contents for updated row
	function getUpdatedContent() {
		var rowNo = (saveRecTag == "Update" ? $F("currentRowNo") : (parseInt($F("premDepListLastNo")) + 1));
		//var rowNo = (parseInt($F("premDepListLastNo")) + 1);
		var content = "";

		if (rowNo >= 0) {
			if (saveRecTag == "Update") {
				var count = rowNo;
				var orPrintTag = $("orTagNonVAT").checked ? "N" : "V";
				var itemNo = $F("txtItemNo");
				var dspTranYear = $F("txtTranYear");
				var dspTranMonth = $F("txtTranMonth").blank() ? "" : parseInt($F("txtTranMonth"), 10);
				var dspTranSeqNo = $F("txtTranSeqNo").blank() ? "" : parseInt($F("txtTranSeqNo"));
				var transactionType = $F("txtTransactionType");
				var tranTypeName = $("txtTransactionType").options[$("txtTransactionType").selectedIndex].text;
				var oldItemNo = $F("txtOldItemNo").blank() ? "" : parseInt($F("txtOldItemNo"), 10);
				var oldTranType = $F("txtOldTranType").blank() ? "" : parseInt($F("txtOldTranType"));
				var b140IssCd = $F("txtB140IssCd");
				var issName = $("txtB140IssCd").options[$("txtB140IssCd").selectedIndex].text;
				var b140PremSeqNo = $F("txtB140PremSeqNo");
				var instNo = $F("txtInstNo").blank() ? "" : parseInt($F("txtInstNo"), 10);
				var collectionAmt = $F("txtCollectionAmt");
				var depFlag = $F("gipdDepFlag"+rowNo).blank() ? "1" : $F("gipdDepFlag"+rowNo);
				var dspDepFlag = $F("gipdDspDepFlag"+rowNo);
				var assdNo = $F("txtAssdNo");
				var assuredName = changeSingleAndDoubleQuotes2($F("txtAssuredName"));
				var drvAssuredName = changeSingleAndDoubleQuotes2($F("txtDrvAssuredName"));
				var intmNo = $F("gipdIntmNo"+rowNo);
				var intmName = changeSingleAndDoubleQuotes2($F("gipdIntmName"+rowNo));
				var riCd = $F("txtRiCd");
				var riName = $F("txtRiName");
				var parSeqNo = $F("txtParSeqNo");
				var quoteSeqNo = $F("txtQuoteSeqNo");
				var lineCd = $F("txtLineCd");
				var sublineCd = $F("txtSublineCd");
				var issCd = $F("txtIssCd");
				var issueYy = $F("txtIssueYy");
				var polSeqNo = $F("txtPolSeqNo");
				var renewNo = $F("txtRenewNo");
				var collnDt = $F("txtCollnDt");
				var gaccTranId = $F("gaccTranId");
				var oldTranId = $F("txtOldTranId");
				var remarks = changeSingleAndDoubleQuotes2($F("txtRemarks"));
				var userId = $F("gipdUserId"+rowNo);
				var lastUpdate = $F("gipdLastUpdate"+rowNo);
				var currencyCd= $F("txtCurrencyCd");
				var convertRate = $F("txtConvertRate");
				var foreignCurrAmt = $F("txtForeignCurrAmt");
				var orTag = $("orTagVAT").checked ? "V" : "N";
				var commRecNo = $F("gipdCommRecNo"+rowNo);
				var billNo = $F("txtB140IssCd").blank() || $F("txtB140PremSeqNo").blank() ? "" : $F("txtB140IssCd") + "-" + parseInt($F("txtB140PremSeqNo")).toPaddedString(8);
				var parYy = $F("txtParYy");
				var policyNo = $F("txtPolicyNo");
				var status = "Y";
			} else {
				var count = rowNo;
				var orPrintTag = $("orTagNonVAT").checked ? "N" : "V";
				var itemNo = $F("txtItemNo");
				var dspTranYear = $F("txtTranYear");
				var dspTranMonth = $F("txtTranMonth").blank() ? "" : $F("txtTranMonth");
				var dspTranSeqNo = $F("txtTranSeqNo").blank() ? "" : $F("txtTranSeqNo");
				var transactionType = $F("txtTransactionType");
				var tranTypeName = $("txtTransactionType").options[$("txtTransactionType").selectedIndex].text;
				var oldItemNo = $F("txtOldItemNo").blank() ? "" : parseInt($F("txtOldItemNo"), 10);
				var oldTranType = $F("txtOldTranType").blank() ? "" : parseInt($F("txtOldTranType"));
				var b140IssCd = $F("txtB140IssCd");
				var issName = $("txtB140IssCd").options[$("txtB140IssCd").selectedIndex].text;
				var b140PremSeqNo = $F("txtB140PremSeqNo");
				var instNo = $F("txtInstNo").blank() ? "" : parseInt($F("txtInstNo"), 10);
				var collectionAmt = $F("txtCollectionAmt");
				var depFlag = $F("txtDepFlag");
				var dspDepFlag = "";
				var assdNo = $F("txtAssdNo");
				var assuredName = changeSingleAndDoubleQuotes2($F("txtAssuredName"));
				var drvAssuredName = ($F("txtAssdNo").blank() || $F("txtAssuredName").blank()) ? "" : $F("txtAssdNo") + " - " + changeSingleAndDoubleQuotes2($F("txtAssuredName"));
				var intmNo = $F("txtIntmNo");
				var intmName = $F("txtIntmName");
				var riCd = $F("txtRiCd");
				var riName = $F("txtRiName");
				var parSeqNo = $F("txtParSeqNo");
				var quoteSeqNo = $F("txtQuoteSeqNo");
				var lineCd = $F("txtLineCd");
				var sublineCd = $F("txtSublineCd");
				var issCd = $F("txtIssCd");
				var issueYy = $F("txtIssueYy");
				var polSeqNo = $F("txtPolSeqNo");
				var renewNo = $F("txtRenewNo");
				var collnDt = $F("txtCollnDt");
				var gaccTranId = $F("gaccTranId");
				var oldTranId = $F("txtOldTranId");
				var remarks = changeSingleAndDoubleQuotes2($F("txtRemarks"));
				var userId = "";//$F("gipdUserId"+rowNo);
				var lastUpdate = "";//$F("gipdLastUpdate"+rowNo);
				var currencyCd= $F("txtCurrencyCd");
				var convertRate = $F("txtConvertRate");
				var foreignCurrAmt = $F("txtForeignCurrAmt");
				var orTag = $("orTagVAT").checked ? "V" : "N";
				var commRecNo = $F("txtCommRecNo");//$F("gipdCommRecNo"+rowNo);
				var billNo = $F("txtB140IssCd").blank() || $F("txtB140PremSeqNo").blank() ? "" : $F("txtB140IssCd") + "-" + parseInt($F("txtB140PremSeqNo")).toPaddedString(8);
				var parYy = $F("txtParYy");
				var policyNo = $F("txtPolicyNo");
				var status = "A";
				var parLineCd = $F("txtParLineCd");
				var parIssCd = $F("txtParIssCd");
				var parNo =  $F("txtParNo");
				

				if (depFlag == "1") {
					dspDepFlag = "Overdraft Comm";
				} else if (depFlag == "2") {
					dspDepFlag = "Overpayment";
				} else {
					dspDepFlag = "Unapplied";
				}
			}
			
			content = 
				'<label id="rowItemNo'+rowNo+'" 						name="lblPremDep" style="width: 79px; text-align: center;">'+itemNo+'</label>' +
				'<label id="rowTransactionType'+rowNo+'"				name="lblPremDep" style="width: 119px; text-align: center;">'+ (tranTypeName.blank() ? '---' : tranTypeName.truncate(15, "...")) +'</label>' +
				'<label id="rowOldTransactionNo'+rowNo+'" 				name="lblPremDep2" style="width: 142px; text-align: center;">'+ (dspTranYear.blank() || dspTranMonth.blank() || dspTranSeqNo.blank() ? '---' : dspTranYear + '-' + parseInt(dspTranMonth).toPaddedString(2) + '-' + parseInt(dspTranSeqNo).toPaddedString(2)) +'</label>' +
				'<label id="rowIssueSource'+rowNo+'" 					name="lblPremDep" style="width: 109px; text-align: center;">'+ (issName.blank() ? '---' : issName.truncate(15, "...")) +'</label>' +
				'<label id="rowInvoiceNo'+rowNo+'" 						name="lblPremDep" style="width: 93px; text-align: center;">'+(billNo.blank() ? '---' : b140PremSeqNo.truncate(15, "..."))+'</label>' +
				'<label id="rowInstallmentNo'+rowNo+'" 					name="lblPremDep" style="width: 103px; text-align: center;">'+ (String(instNo).blank() ? '---' : instNo.toPaddedString(2)) +'</label>' +
				'<label id="rowCollectionAmt'+rowNo+'" 					name="lblPremDep" style="width: 132px; text-align: right;">'+ (collectionAmt.blank() ? '---' : formatCurrency(collectionAmt).truncate(15, "...")) +'</label>' +
				'<label id="rowCollectionAmt'+rowNo+'" 					name="lblPremDep" style="width: 98px; text-align: right;">'+ (dspDepFlag.blank() ? '---' : dspDepFlag.truncate(15, "...")) +'</label>' +
				'<input type="hidden" id="count'+rowNo+'" 				name="count" 						value="'+rowNo+'" />' +
				'<input type="hidden" id="gipdOrPrintTag'+rowNo+'"  	name="gipdOrPrintTag" 				value="'+ orPrintTag +'" />' +
				'<input type="hidden" id="gipdItemNo'+rowNo+'" 			name="gipdItemNo" 					value="'+ itemNo +'" />' +
				'<input type="hidden" id="gipdTranYear'+rowNo+'" 		name="gipdTranYear"					value="'+ dspTranYear +'" />' +
				'<input type="hidden" id="gipdTranMonth'+rowNo+'" 		name="gipdTranMonth"				value="'+ dspTranMonth +'" />' +
				'<input type="hidden" id="gipdTranSeqNo'+rowNo+'" 		name="gipdTranSeqNo"				value="'+ dspTranSeqNo +'" />' +
				'<input type="hidden" id="gipdTransactionType'+rowNo+'" name="gipdTransactionType" 			value="'+ transactionType +'" />' +
				'<input type="hidden" id="gipdTranTypeName'+rowNo+'" 	name="gipdTranTypeName" 			value="'+ tranTypeName+'" />' +
				'<input type="hidden" id="gipdOldItemNo'+rowNo+'" 		name="gipdOldItemNo" 				value="'+ oldItemNo +'" />' +
				'<input type="hidden" id="gipdOldTranType'+rowNo+'" 	name="gipdOldTranType" 				value="'+ oldTranType +'" />' +
				'<input type="hidden" id="gipdB140IssCd'+rowNo+'" 		name="gipdB140IssCd" 				value="'+ b140IssCd +'" />' +
				'<input type="hidden" id="gipdIssName'+rowNo+'" 		name="gipdIssName" 					value="'+ issName + '" />' +
				'<input type="hidden" id="gipdB140PremSeqNo'+rowNo+'" 	name="gipdB140PremSeqNo" 			value="'+ b140PremSeqNo +'" />' +
				'<input type="hidden" id="gipdInstNo'+rowNo+'" 			name="gipdInstNo" 					value="'+ instNo +'" />' +
				'<input type="hidden" id="gipdCollectionAmt'+rowNo+'" 	name="gipdCollectionAmt" 			value="'+ collectionAmt.replace(/,/g,"") +'" />' +
				'<input type="hidden" id="gipdDepFlag'+rowNo+'" 		name="gipdDepFlag" 					value="'+ depFlag +'" />' +
				'<input type="hidden" id="gipdDspDepFlag'+rowNo+'" 		name="gipdDspDepFlag" 				value="'+ dspDepFlag +'" />' +
				'<input type="hidden" id="gipdAssdNo'+rowNo+'" 			name="gipdAssdNo" 					value="'+ assdNo +'" />' +
				'<input type="hidden" id="gipdAssuredName'+rowNo+'" 	name="gipdAssuredName" 				value="'+ assuredName +'" />' +
				'<input type="hidden" id="gipdDrvAssuredName'+rowNo+'" 	name="gipdDrvAssuredName" 			value="'+ assuredName +'" />' +
				'<input type="hidden" id="gipdIntmNo'+rowNo+'" 			name="gipdIntmNo" 					value="'+ intmNo +'" />' +
				'<input type="hidden" id="gipdIntmName'+rowNo+'" 		name="gipdIntmName"					value="'+ intmName +'" />' +
				'<input type="hidden" id="gipdRiCd'+rowNo+'" 			name="gipdRiCd" 					value="'+ riCd +'" />' +
				'<input type="hidden" id="gipdRiName'+rowNo+'" 			name="gipdRiName" 					value="'+ riName +'" />' +
				'<input type="hidden" id="gipdParSeqNo'+rowNo+'" 		name="gipdParSeqNo" 				value="'+ parSeqNo +'" />' +
				'<input type="hidden" id="gipdQuoteSeqNo'+rowNo+'" 		name="gipdQuoteSeqNo" 				value="'+ quoteSeqNo +'" />' +
				'<input type="hidden" id="gipdLineCd'+rowNo+'" 			name="gipdLineCd" 					value="'+ lineCd +'" />' +
				'<input type="hidden" id="gipdSublineCd'+rowNo+'" 		name="gipdSublineCd" 				value="'+ sublineCd +'" />' +
				'<input type="hidden" id="gipdIssCd'+rowNo+'" 			name="gipdIssCd" 					value="'+ issCd +'" />' +
				'<input type="hidden" id="gipdIssueYy'+rowNo+'" 		name="gipdIssueYy" 					value="'+ issueYy +'" />' +
				'<input type="hidden" id="gipdPolSeqNo'+rowNo+'" 		name="gipdPolSeqNo" 				value="'+ polSeqNo +'" />' +
				'<input type="hidden" id="gipdRenewNo'+rowNo+'" 		name="gipdRenewNo" 					value="'+ renewNo +'" />' +
				'<input type="hidden" id="gipdCollnDt'+rowNo+'" 		name="gipdCollnDt" 					value="'+ collnDt +'" />' +
				'<input type="hidden" id="gipdGaccTranId'+rowNo+'" 		name="gipdGaccTranId" 				value="'+ gaccTranId +'" />' +
				'<input type="hidden" id="gipdOldTranId'+rowNo+'" 		name="gipdOldTranId" 				value="'+ oldTranId +'" />' +
				'<input type="hidden" id="gipdRemarks'+rowNo+'" 		name="gipdRemarks" 					value="'+ remarks +'" />' +
				'<input type="hidden" id="gipdUserId'+rowNo+'" 			name="gipdUserId" 					value="'+ userId +'" />' +
				'<input type="hidden" id="gipdLastUpdate'+rowNo+'" 		name="gipdLastUpdate" 				value="'+ lastUpdate +'" />' +
				'<input type="hidden" id="gipdCurrencyCd'+rowNo+'" 		name="gipdCurrencyCd" 				value="'+ currencyCd +'" />' +
				'<input type="hidden" id="gipdConvertRate'+rowNo+'" 	name="gipdConvertRate" 				value="'+ convertRate +'" />' +
				'<input type="hidden" id="gipdForeignCurrAmt'+rowNo+'" 	name="gipdForeignCurrAmt" 			value="'+ foreignCurrAmt.replace(/,/g,"") +'" />' +
				'<input type="hidden" id="gipdOrTag'+rowNo+'" 			name="gipdOrTag" 					value="'+ orTag +'" />' +
				'<input type="hidden" id="gipdCommRecNo'+rowNo+'" 		name="gipdCommRecNo" 				value="'+ commRecNo +'" />' +
				'<input type="hidden" id="gipdBillNo'+rowNo+'" 			name="gipdBillNo"	 				value="'+ billNo +'" />' +
				'<input type="hidden" id="gipdParYy'+rowNo+'" 			name="gipdParYy"	 				value="'+ parYy +'" />' +
        		'<input type="hidden" id="gipdPolicyNo'+rowNo+'" 		name="gipdPolicyNo" 				value="'+ policyNo +'" />' +
        		'<input type="hidden" id="gipdChanged'+rowNo+'" 		name="gipdChanged"	 				value="'+ status +'" />' +
        		'<input type="hidden" id="gipdParLineCd'+rowNo+'"	 	name="gipdParLineCd"	 			value="'+ parLineCd +'" />' +
        		'<input type="hidden" id="gipdParIssCd'+rowNo+'"	 	name="gipdParIssCd"	 				value="'+ parIssCd +'" />' +
        		'<input type="hidden" id="gipdParNo'+rowNo+'"	 		name="gipdParNo"	 				value="'+ parNo +'" />';
        		
        		// gipdChanged is the tag to check if this is a new or an updated record.
    			// 'Y' if changed, 'N' if there is no change, 'A' if recently added
		}

		return content;
	}

	// check if required fields have values
	

	// check if item no and transaction type already exists
	function checkIfExisting() {
		exists = false;
		$$("div[name='rowPremDep']").each(function(row) {
			if (row.down("input", 2).value == parseInt($F("txtItemNo")) && row.down("input", 6).value == parseInt($F("txtTransactionType"))) {
				exists = true;
				return false;
			}
		});
		return exists;
	}

	// check if item no already exists
	function checkIfItemNoExists(itemNo) {
		exists = false;
		$$("div[name='rowPremDep']").each(function(row) {
			if (row.down("input", 2).value == itemNo) {
				exists = true;
				return false;
			}
		});

		return exists;
	}
	// others
	
	// trigger when currency_cd is changed
	function currencyCdTrigger() {
		var count = 0;

		$$("div[id='giisCurrency"+$F("txtCurrencyCd")+"']").each(function(row) {
			$("txtConvertRate").value = truncateDecimal(parseFloat(nvl(row.down("input", 2).value, "0")), 2);
			$("txtDspCurrencyDesc").value = row.down("input", 1).value;
			$("txtDspShortName").value = row.down("input", 3).value;
			count = 1;
		});

		if (count == 0) {
			showMessageBox("Currency cd does not exist.", imgMessage.ERROR);
			$("txtCurrencyCd").value = $F("lastCurrencyCd");
		} else {
			$("txtForeignCurrAmt").value = formatCurrency(parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 1)) / parseFloat(nvl($F("txtConvertRate"), 1)));
			$("lastCurrencyCd").value = $F("txtCurrencyCd");
			$("lastForeignCurrAmt").value = formatCurrency($F("txtForeignCurrAmt"));
			$("lastConvertRate").value = $F("txtConvertRate");
		}
	}

	// trigger when transaction type is changed
	function transactionTypeTrigger() {
		if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4) {
			$("txtTranYear").addClassName("required");
			$("txtTranMonth").addClassName("required");
			$("txtTranSeqNo").addClassName("required");
			$("txtOldItemNo").addClassName("required");
			$("txtOldTranType").addClassName("required");
		} else {
			$("txtTranYear").removeClassName("required");
			$("txtTranMonth").removeClassName("required");
			$("txtTranSeqNo").removeClassName("required");
			$("txtOldItemNo").removeClassName("required");
			$("txtOldTranType").removeClassName("required");
		}
		$("txtTranYear").value = "";
		$("txtTranMonth").value = "";
		$("txtTranSeqNo").value = "";
		$("txtOldItemNo").value = "";
		$("txtOldTranType").value = "";

		$("txtDspA150LineCd").value = "";
		$("txtAssdNo").value = "";
		$("txtAssuredName").value = "";
		$("txtDrvAssuredName").value = "";
		$("txtRiCd").value = "";
		$("txtRiName").value = "";
		$("txtLineCd").value = "";
		$("txtSublineCd").value = "";
		$("txtIssCd").value = "";
		$("txtIssueYy").value = "";
		$("txtPolSeqNo").value = "";
		$("txtRenewNo").value = "";
		$("txtPolicyNo").value = "";
		$("txtParNo").value = "";
		$("txtParLineCd").value = "";
		$("txtParIssCd").value = "";
		$("txtRemarks").value = "";
	}

	// check if the entered old tran id, old item no, and old tran type exists.
	// this is to avoid foreign key constraint errors
	function checkGipdGipdFkConstraint() {
		var ok = true;
		if (!$F("txtTransactionType").blank() && $F("txtTransactionType") ==  "2" || $F("txtTransactionType") == "4") {
			new Ajax.Request(contextPath+"/GIACPremDepositController?action=checkGipdGipdFkConstraint", {
				method: "GET",
				asynchronous: false,
				evalScripts: true,
				parameters: {
					oldTranId: $F("txtOldTranId"),
					oldItemNo: $F("txtOldItemNo"),
					oldTranType: $F("txtOldTranType")
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						if (nvl(response.responseText, "N") == "N") {
							ok = false;
						}
					} else {
						showMessageBox("An error has occured.", imgMessage.ERROR);
					}
				}
			});
		}
		return ok;
	}

	/* function openGipdLineCdLovModal() {
		if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
			showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			openSearchPolicyNo();
		}else if ($F("currentRowNo") != "-1") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		}
	} 
 	*/
	function getTotalCollectionAmt() {
		var total = 0;
		$$("div[name='rowPremDep']").each(function(row) {
			total = total + parseFloat(nvl(row.down("input", 14).value, "0"));
		});
		return total;
	}

	function openGipdOldItemNoLOV() {
		if ($F("currentRowNo") != "-1") {
			showMessageBox("This item may not be updated.", imgMessage.INFO);
		} else if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "1" || $F("txtTransactionType") == "3") {
			showMessageBox("Transaction type should be 2 or 4 - "+$("txtTransactionType").options[2].text+" or "+$("txtTransactionType").options[4].text+".", imgMessage.INFO);
		} else if ($F("currentRowNo") == "-1") {
			searchOldItemNo();
		}
	}

	function saveGiacs026PremDep() {
		//if ($F("hidAccTransTranFlag") == "O" || (objACGlobal.orFlag != "P" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D")) {
			var count = 0;
			$$("div[name='rowPremDep']").each(function(row) {
				if (row.down("input", 46).value != "N") {
					count = count + 1;
					return false;
				}
			});
			if ($$("div[name='premDepRowDeleted']").size() == 0 && count == 0) {
				showMessageBox("No changes to save.", imgMessage.INFO);
				return false;
			} else{
				new Ajax.Request(contextPath + "/GIACPremDepositController?action=saveGIACPremDeposit", {
					method: "POST",
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						//showNotice("Saving. Please wait...");
					},
					onComplete : function(response) {
						//hideNotice("");
						if (nvl(response.responseText, "SUCCESS") == "SUCCESS") {
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);

							changeTag = 0;
							
							if ($F("varItemGenType").blank()) {
								showMessageBox("This module does not exist in giac_modules.", imgMessage.INFO);
							}
			
							$$("div[name='rowPremDep']").each(function(row) {
								row.down("input", 46).value = "N";
							});
			
							while (child = $("deletePremDepList").firstChild) {
								$("deletePremDepList").removeChild(child);
							}
			
							$("deletePremDepList").removeChild();
						} else {
							showMessageBox(response.responseText,imgMessage.ERROR);
						}
					}
				});
			}
		//}
		disableButton($("btnSavePremDep"));
	}
	
</script>