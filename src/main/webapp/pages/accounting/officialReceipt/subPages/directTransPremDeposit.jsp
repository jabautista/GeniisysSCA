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
	

<div class="sectionDiv" id="premiumDepositsDiv" name="premiumDepositsDiv" style="border-top: none;" ><!-- changeTagAttr="true" -->
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
	
		<div id="premDepListingTable" style="height: 200px; margin: 20px"></div>
		
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
			<div id="totalDiv" style="margin-top: 30px; margin-right: 127px; border:solid white 1px;" >
					<table border="0" align="right">
						<tr>
							<td class="leftAligned">Total: </td>
							<td class="leftAligned">
								<input type="text" id="collectionAmtTotal" name="collectionAmtTotal" readonly="readonly" class="money"/>
							</td>
						</tr>
					</table>
				</div>
			<div id ="textFieldDiv" style="margin-top: 50px; border:solid white 1px;" > <!-- changeTagAttr="true" -->
				
				<table align="center">
				<tr>
					<td class="rightAligned" style="width: 160px;">Item No.</td>
					<td class="leftAligned" style="width: 200px;"><input type="text" style="width: 186px; text-align: right" maxlength="9" class="required" id="txtItemNo" name="txtItemNo" value="" tabindex="1" /></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Assured Name</td>
					<td class="leftAligned" style="width: 200px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; height: 12px; float: left; border: none;" id="txtDrvAssuredName" name="txtDrvAssuredName" readonly="readonly" type="text" value="" tabindex="12"/>
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscm" name="oscm" alt="Go" style="float: right;"/>
					    </div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned">Transaction Type</td>
					<td class="leftAligned">
						<select id="txtTransactionType" name="txtTransactionType" style="width: 193px;" class="required" tabindex="2" lastValidValue="">
							<option value=""></option>
							<c:forEach var="transactionType" items="${transactionTypeList}" varStatus="ctr">
								<option value="${transactionType.rvLowValue}" rvMeaning="${transactionType.rvMeaning}">${transactionType.rvLowValue} - ${transactionType.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width: 150px">Intermediary Name</td>
					<td class="leftAligned" style="width: 200px;">
						<%-- <div id="oscmIntermediaryDiv" style="border: 1px solid gray; width: 214px; height: 21px; float: left;" <c:if test="${requirePremDepIntm eq 'Y'}">class="required"</c:if>/> --%>
						<div id="oscmIntermediaryDiv" style="border: 1px solid gray; width: 214px; height: 21px; float: left;"/>
							<%-- <input style="width: 186px; height: 12px; float: left; border: none;" id="txtDrvIntmName" name="txtDrvIntmName" readonly="readonly" type="text" value="" tabindex=13
							<c:if test="${requirePremDepIntm eq 'Y'}">class="required"</c:if>/> --%>
							<input style="width: 186px; height: 12px; float: left; border: none;" id="txtDrvIntmName" name="txtDrvIntmName" readonly="readonly" type="text" value="" tabindex=13 />
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmIntermediary" name="oscmIntermediary" alt="Go" style="float: right"/>
					    </div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Old Transaction No.</td>
					<td class="leftAligned">
						<!-- 
						<select id="txtTranYear" name="txtTranYear" style="width: 60px" tabindex=3 disabled="disabled">
							<option value=""></option>
							<c:forEach var="i" begin="1990" end="2010" step="1">
								<option value="${i }">${i }</option>
							</c:forEach>
						</select>
						 -->
						 <input type="text" style="width: 52px;" maxlength="4" id="txtTranYear" name="txtTranYear" value="" readonly="readonly" tabindex=3/>
						<input type="text" style="width: 45px;" maxlength="2" id="txtTranMonth" name="txtTranMonth" value="" readonly="readonly" tabindex=4/>
						<input type="text" style="width: 45px; " maxlength="4" id="txtTranSeqNo2" name="txtTranSeqNo2" value="" readonly="readonly" tabindex=5/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmOldTransactionNo" name="oscmOldTransactionNo" alt="Go" />
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Reinsurer</td>
					<td class="leftAligned" style="width: 200px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; height:12px; float: left; border: none;" id="txtDrvRiName" name="txtDrvRiName" readonly="readonly" type="text" value="" tabindex=14/>
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmRi" name="oscmRi" alt="Go" style="float: right;"/>
					    </div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned">Old Item No/Old Tran Type</td>
					<td class="leftAligned">
						<input type="text" style="width: 86px; text-align: right" maxlength="2" id="txtOldItemNo" name="txtOldItemNo" value="" readonly="readonly" tabindex=6/>
						<input type="text" style="width: 86px; text-align: right" maxlength="2" id="txtOldTranType" name="txtOldTranType" value="" readonly="readonly" tabindex=7/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmOldItemNo" name="oscmOldItemNo" alt="Go" style="display: none;"/>
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Policy No.</td>
					<td class="leftAligned" style="width: 200px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; height: 12px; float: left; border: none;" id="txtPolicyNo" name="txtPolicyNo" readonly="readonly" type="text" value="" tabindex=15/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmPolicyNo" name="oscmPolicyNo" alt="Go" style="float: right;"/>
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned">Issue Source</td>
					<td class="leftAligned">
						<select id="txtB140IssCd" name="txtB140IssCd" style="width: 193px;" disabled="disabled" tabindex=8>
							<option value=""></option>
							<c:forEach var="issueSource" items="${issueSourceList }" varStatus="ctr">
								<option value="${issueSource.issCd }">${issueSource.issName }</option>
							</c:forEach>
						</select>
						<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmB140IssCd" name="oscmB140IssCd" alt="Go" /> --%>
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">PAR No.</td>
					<td class="leftAligned" style="width: 200px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; height:12px; float: left; border: none;" id="txtParNo" name="txtParNo" readonly="readonly" type="text" value="" tabindex=16/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmParNo" name="oscmParNo" alt="Go" style="float: right;"/>
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned">Invoice No.</td>
					<td class="leftAligned">
						<input type="text" style="width: 167px; text-align: right" maxlength="13" id="txtB140PremSeqNo" name="txtB140PremSeqNo" readonly="readonly" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmB140IssCd" name="oscmB140IssCd" alt="Go" />
					</td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Collection Date</td>
					<td class="leftAligned" style="width: 200px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; height:12px; float: left; border: none;" id="txtCollnDt" name="txtCollnDt" readonly="readonly" type="text" value="" tabindex=17/>
							<img id="hrefCollnDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date" />
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned">Installment No.</td>
					<td class="leftAligned"><input type="text" style="width: 186px; text-align: right" maxlength="2" id="txtInstNo" name="txtInstNo" value="" readonly="readonly" tabindex=9/></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px">Remarks</td>
					<td class="leftAligned" style="width: 200px;">
						<div style="border: 1px solid gray; width: 214px; height: 21px; float: left;">
							<input style="width: 186px; height: 12px; float: left; border: none;" id="txtRemarks" name="txtRemarks" type="text" value="" maxlength="4000" tabindex=18/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarksPremDep" />
						</div>
				   	</td>
				</tr>
				<tr>
					<td class="rightAligned">Amount</td>
					<td class="leftAligned"><input type="text" style="width: 186px; text-align: right" maxlength="17" class="required" id="txtCollectionAmt" name="txtCollectionAmt" value="" tabindex=10/></td>
					<td class="rightAligned" style="font-size: 11px; width: 80px"></td>
					<td style="text-align: center; width: 200px" colspan="2">
						<input type="button" style="width: 130px;" id="btnForeignCurrency" class="button" value="Foreign Currency" tabindex=19/>
						<!-- 
						<input type="button" style="width: 110px;" id="btnBreakdown" 	   class="button" value="Breakdown"/> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Dep Flag</td>
					<td class="leftAligned">
						<select id="txtDepFlag" name="txtDepFlag" style="width: 193px;" class="required" tabindex=11>
							<option value="1">Unapplied</option>							
							<option value="2">Overpayment</option>
							<option value="3">Overdraft Comm</option>
						</select>
					</td>
					<td style="width: 320px" colspan="2"></td>
				</tr>
				<tr>
					<td class="rightAligned"></td>
					<td class="leftAligned">
						<input type="radio" style="float: left;" id="orTagVAT" name="orTag" value="V">
						<label style="float: left; margin: 3px 15px 0px 0px;" for="orTagVAT">VAT</label>
						<input type="radio" style="float: left;" id="orTagNonVAT" name="orTag" value="N" checked="checked">
						<label style="float: left; margin: 3px 10px 0px 0px;" for="orTagNonVAT">Non-VAT</label>
					</td>
					<td style="width: 320px" colspan="2"></td>
				</tr>
			</table>
			</div>
			<div>
				<input type="button" style="width: 80px;" id="btnAddRecord" class="button" value="Add" />
				<input type="button" style="width: 80px;" id="btnDeleteRecord" 	 class="disabledButton" value="Delete" disabled="disabled"/>
			</div>
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
	disableButton($("btnDeleteRecord"));
	//disableButton($("btnSavePremDep"));
	//initializeAll();
	// misc variables
	var saveRecTag = $("btnAddRecord").value;
	var oldItemNo;
	var oldTranType;
	var oldTranId;
	var changed = "N";
	var deleteTag = "N";
	var premDepList = '${premDepositList}';
	var hasPremDepTran34 = '${hasPremDepTran34}';
	
 try{
	 var objTGPremDep = {};
		var objPremDep = [];
		selectedIndex = -1;
		objTGPremDep.objTGPremDepListing = JSON.parse('${premDepTableGridListing}'.replace(/\\/g, '\\\\'));
		objTGPremDep.objTGPremDepList = objTGPremDep.objTGPremDepListing.rows || [];
		
		try{
			var premDepListingTable = {
				url: contextPath+"/GIACPremDepositController?action=showPremDepListing&refresh=1&gaccTranId="+
				 '${gaccTranId}'+"&gaccFundCd="+'${gaccFundCd}'+"&gaccBranchCd="+'${gaccBranchCd}'+"&moduleId="+'GIACS026'
				 +"&orFlag="+'${orFlag}',
				 options: {
					width: '875px',
					height: '200px',
					id: 1,
					onCellFocus : function(element, value, x, y, id){
						var mtgId = premDepTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
							objTGPremDep = premDepTableGrid.getRow(y);
						}
						var row = premDepTableGrid.geniisysRows[y];
						populateDetails(row);
						enableDisableFields();
						premDepTableGrid.keys.releaseKeys();
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(premDepTableGrid);
					},
					onRemoveRowFocus: function(){
						selectedIndex = -1;
						resetFields();
						premDepTableGrid.keys.releaseKeys();
					},
// 					onRowDoubleClick: function(y){
// 						premDepTableGrid.keys.releaseKeys();
// 					},
					beforeSort : function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSavePremDep").focus();
							});
							return false;
						}
					},
					prePager: function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSavePremDep").focus();
							});
							return false;
						}
					},
					checkChanges: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailRequireSaving: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetail: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailSaveFunc: function() {
						return (changeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN],
						onRefresh: function() {
							selectedIndex = -1;
							resetFields();
							premDepTableGrid.keys.releaseKeys();
						},
						onFilter: function() {
							selectedIndex = -1;
							resetFields();
							premDepTableGrid.keys.releaseKeys();
						},
						onSave: function(){
							var ok = true;
						 	var addedRows 	 = premDepTableGrid.getNewRowsAdded();
							var modifiedRows = premDepTableGrid.getModifiedRows();
							var delRows  	 = premDepTableGrid.getDeletedRows();
							var setRows		 = addedRows.concat(modifiedRows);
							 	
							var objParameters = new Object();
							objParameters.delRows = delRows;
							objParameters.setRows = setRows;
							var strParameters = JSON.stringify(objParameters);
							new Ajax.Request(contextPath+"/GIACPremDepositController?action=saveGiacsPremDeposit",{
								method: "POST",
								parameters:{
									globalGaccTranId: objACGlobal.gaccTranId,
									globalGaccBranchCd: objACGlobal.branchCd,
									globalGaccFundCd: objACGlobal.fundCd,
									parameters: strParameters
								},
								asynchronous: false,
								evalScripts: true,
								onCreate: function(){
									showNotice("Saving OR Preview, please wait...");
								},
								onComplete: function(response){
									hideNotice("");
									if(checkCustomErrorOnResponse(response)) {
										if (response.responseText == "SUCCESS"){
											ok = true;
										}
									}else{
										showMessageBox(response.responseText, imgMessage.ERROR);
										ok = false;
									}
								}	 
							});	
							return ok; 	
						}
					}
				},
				columnModel: [
							{   
								id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	
								id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	id: 'itemNo',
								title: 'Item No.',
								titleAlign: 'right',
								align: 'right',
								width: '62',
								visible: true,
								filterOption: true
							},
							{	id: 'tranTypeName',
								title: 'Transaction Type',
								titleAlign: 'left',
								width: '108',
								visible: true,
								filterOption: true
							},
							{	id: 'dspOldTranNo',
								title: 'Old Transaction No.',
								titleAlign: 'left',
								width: '120',
								visible: true,
								filterOption: true
							},
							{	id: 'issName',
								title: 'Issue Source',
								titleAlign: 'left',
								width: '90',
								visible: true,
								filterOption: true
							},
							{	id: 'b140PremSeqNo',
								title: 'Invoice No.',
								titleAlign: 'right',
								align: 'right',
								width: '70',
								visible: true,
								filterOption: true
							},
							{	id: 'instNo',
								title: 'Installment No.',
								titleAlign: 'right',
								align: 'right',
								width: '90',
								visible: true,
								filterOption: true
							},
							{	id: 'collectionAmt',
								title: 'Amount',
								titleAlign: 'right',
								align : 'right',
								width: '120',
								geniisysClass: 'money',
								geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
								maxlength: 30,
								visible: true,
								filterOption: true
							},
							{	id: 'dspDepFlag',
								title: 'Dep Flag',
								titleAlign: 'left',
								width: '90',
								visible: true,
								filterOption: true
								
							},
							{	id: 'assdNo',
								width: '0px',
								visible: false
							},
							{	id: 'assuredName',
								width: '0px',
								visible: false
							},
							{	id: 'intmNo',
								width: '0px',
								visible: false
							},
							{	id: 'intmName',
								width: '0px',
								visible: false
							},
							{	id: 'riCd',
								width: '0px',
								visible: false
							},
							{	id: 'riName',
								width: '0px',
								visible: false
							},
							{	id: 'parSeqNo',
								width: '0px',
								visible: false
							},
							{	id: 'quoteSeqNo',
								width: '0px',
								visible: false
							},
							{	id: 'lineCd',
								width: '0px',
								visible: false
							},
							{	id: 'sublineCd',
								width: '0px',
								visible: false
							},
							{	id: 'issCd',
								width: '0px',
								visible: false
							},
							{	id: 'issueYy',
								width: '0px',
								visible: false
							},
							{	id: 'polSeqNo',
								width: '0px',
								visible: false
							},
							{	id: 'gaccTranId',
								width: '0px',
								visible: false
							},
							{	id: 'remarks',
								width: '0px',
								visible: false
							},
							{	id: 'transactionType',
								width: '0px',
								visible: false
							},
							{	id: 'collnDt',
								type : 'date',
								format : 'mm-dd-yyyy',
								width: '0px',
								visible: false
							},
							{	id: 'renewNo',
								width: '0px',
								visible: false
							},
							{	id: 'parYy',
								width: '0px',
								visible: false
							},
							{	id: 'orPrintTag',
								width: '0px',
								visible: false
							},
							{	id: 'oldTranType',
								width: '0px',
								visible: false
							},
							{	id: 'b140IssCd',
								width: '0px',
								visible: false
							},
							{	id: 'billNo',
								width: '0px',
								visible: false
							},
							{	id: 'lastUpdate',
								width: '0px',
								visible: false
							},
							{
								id:'currencyCd',
								width: '0px',
								visible: false
							},
							{ // added by Kris 02.01.2013
								id:'currencyDesc',
								width: '0px',
								visible: false
							},
							{
								id:'convertRate',
								width: '0px',
								visible: false
							},
							{
								id:'foreignCurrAmt',
								width: '0px',
								visible: false
							},
							{
								id:'orTag',
								width: '0px',
								visible: false
							},
							{
								id:'commRecNo',
								width: '0px',
								visible: false
							},
							{
								id:'depFlag',
								width: '0px',
								visible: false
							},
							{
								id:'dspParYy',
								width: '0px',
								visible: false
							},
							{
								id:'dspParSeqNo',
								width: '0px',
								visible: false
							},
							{
								id:'dspQuoteSeqNo',
								width: '0px',
								visible: false
							},
							{
								id:'tranId',
								width: '0px',
								visible: false
							},
							{
								id:'gfunFundCd',
								width: '0px',
								visible: false
							},
							{
								id:'gibrBranchCd',
								width: '0px',
								visible: false
							},
							{
								id:'tranDate',
								width: '0px',
								visible: false
							},
							{
								id:'tranFlag',
								width: '0px',
								visible: false
							},
							{
								id:'tranClass',
								width: '0px',
								visible: false
							},
							{
								id:'tranClassNo',
								width: '0px',
								visible: false
							},
							{
								id:'particulars',
								width: '0px',
								visible: false
							},
							{
								id:'tranYear',
								width: '0px',
								visible: false
							},
							{
								id:'tranMonth',
								width: '0px',
								visible: false
							},
							{
								id:'tranSeqNo',
								width: '0px',
								visible: false
							}
							
						],
				rows: objTGPremDep.objTGPremDepList
			};
			premDepTableGrid = new MyTableGrid(premDepListingTable);
			premDepTableGrid.pager = objTGPremDep.objTGPremDepListing;
			premDepTableGrid.render('premDepListingTable');
			premDepTableGrid.afterRender = function(){
				objPremDep = premDepTableGrid.geniisysRows;
				checkOrIfPrinted();
			};
			
			
		}catch(e){
			showErrorMessage("directTransPremDep Table Grid",e);
		}
		
		function checkOrIfPrinted(){
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				$("txtItemNo").readOnly = true;
				$("txtTransactionType").disable();
				
				$("txtTranYear").readOnly = true;
				$("txtTranMonth").readOnly = true;
				$("txtTranSeqNo2").readOnly = true;
				$("txtOldItemNo").readOnly = true;
				$("txtOldTranType").readOnly = true;

				$("txtB140IssCd").enable();
				$("txtB140PremSeqNo").readOnly = true;
				$("txtInstNo").readOnly = true;
				$("txtCollectionAmt").readOnly = true;
				$("txtDepFlag").selectedIndex = 0;
				$("txtDepFlag").disable();

				$("orTagVAT").disable();
				$("orTagNonVAT").disable();

				$("txtRemarks").readOnly = true;
				$("hrefCollnDate").style.display = "none";
			} else {
				$("txtDepFlag").selectedIndex = 0;
				$("txtItemNo").value = getMaxItemNo();
				$("lastItemNo").value = getMaxItemNo();
				$("txtCollnDt").value = new Date().format("mm-dd-yyyy");
			}
		}
		function populateDetails(row) {
			try{
				$("txtItemNo").value = row.itemNo;
				$("lastItemNo").value = row.itemNo;
				$("txtTransactionType").value = row.transactionType;
				//$("txtTransactionType").options[$("txtTransactionType").selectedIndex].text = nvl(row.tranTypeName,"");
				$("txtTranYear").value = nvl(row.tranYear,"");
				$("txtTranMonth").value = nvl(row.tranMonth,"");
				$("txtTranSeqNo2").value = nvl(row.tranSeqNo,"");
				$("txtOldItemNo").value = nvl(row.oldItemNo,"");
				$("txtOldTranType").value = nvl(row.oldTranType,"");
				$("txtB140IssCd").enable;
				//$("txtB140IssCd").options[$("txtB140IssCd").selectedIndex].text = nvl(row.issName,"");
				
				/*$$($("txtB140IssCd").options).each(function(e){
					if(e.value == row.b140IssCd){
						e.selected = true;
					}
				});*/
				$("txtB140IssCd").value = row.b140IssCd;
				
				if(nvl(row.b140IssCd, "") == ""){
					$("txtB140IssCd").selectedIndex = 0;
				}
				
				$("txtB140PremSeqNo").value = nvl(row.b140PremSeqNo,"");
				$("txtInstNo").value = nvl(row.instNo,"");
				$("txtCollectionAmt").value = formatCurrency(row.collectionAmt);
				$("txtDepFlag").selectedIndex = row.depFlag -1;
				
				
				$("txtDrvAssuredName").value = nvl(row.assdNo,"") != ""  || nvl(row.assuredName,"") != "" ? unescapeHTML2(row.assdNo + " - " + row.assuredName) : ""; //added by steven 12/18/2012
				$("txtDrvIntmName").value = nvl(row.intmNo,"") != ""  || nvl(row.intmName,"") != ""  ? unescapeHTML2(row.intmNo + " - "  + row.intmName) : ""; //added by steven 12/18/2012
				$("txtDrvRiName").value = nvl(row.riCd,"") != ""  || nvl(row.riName,"") != ""  ? unescapeHTML2(row.riCd + " - "  + row.riName) : ""; //added by steven 12/18/2012
				$("txtPolicyNo").value = nvl(row.lineCd,"") != ""  || nvl(row.sublineCd,"") != "" || nvl(row.issCd,"") != ""  || nvl(row.issueYy,"") != "" || nvl(row.polSeqNo,"") != ""  || nvl(row.renewNo,"") != ""
										? row.lineCd +"-"+ row.sublineCd +"-"+ row.issCd +"-"+ row.issueYy +"-"+ lpad(row.polSeqNo,7,0) +"-"+ lpad(row.renewNo,2,0) : ""; //added by steven 12/18/2012
				//$("txtParNo").value = nvl(row.lineCd,"") != ""  || nvl(row.issCd,"") != "" || nvl(row.parYy,"") != ""  || nvl(row.parSeqNo,"") != "" || nvl(row.quoteSeqNo,"") != ""  
										//? row.lineCd +"-"+ row.issCd +"-"+ row.parYy +"-"+ lpad(row.parSeqNo,6,0) +"-"+ lpad(row.quoteSeqNo,2,0): ""; //added by steven 12/18/2012
				$("txtParNo").value = row.dspParNo == "----" ? "" : unescapeHTML2(row.dspParNo);
				//$("txtDefaultValue").value = formatCurrency(row.collectionAmt); //marco - 09.29.2014 - added
				$("txtCollnDt").value = dateFormat(row.collnDt, "mm-dd-yyyy"); //marco - 09.29.2014 - replaced $("txtCollnDt").value = new Date(row.collnDt).format("mm-dd-yyyy");
				$("txtRemarks").value = unescapeHTML2(nvl(row.remarks,"")); //added by steven 12/18/2012
				$("btnAddRecord").value = "Update";  
				
				// added by Kris 02.01.2013
				$("txtConvertRate").value = formatRate(row.convertRate);
				$("txtCurrencyCd").value = row.currencyCd;
				$("txtForeignCurrAmt").value = formatCurrency(row.foreignCurrAmt);
				$("txtDspCurrencyDesc").value = row.currencyDesc;
				
				//$("txtConvertRate").readOnly = true;
				/*$("txtConvertRate").disabled = row.recordStatus == 0 ? false : true; // kris 02.04.2013
				$("txtCurrencyCd").readOnly = row.recordStatus == 0 ? false :  true;
				$("txtForeignCurrAmt").readOnly = row.recordStatus == 0 ? false :  true;
				$("txtDspCurrencyDesc").readOnly = row.recordStatus == 0 ? false :  true;				
				row.recordStatus == 0 ? enableSearch("oscmCurrency") : disableSearch("oscmCurrency");*/
				
				if((row.recordStatus == "0" || row.recordStatus == "1") /* && row.recordStatus != null || row.recordStatus != "" */ ){ 
					$("txtConvertRate").disabled = false ; // kris 02.04.2013
					$("txtCurrencyCd").readOnly = false;
					$("txtForeignCurrAmt").readOnly = false;
					$("txtDspCurrencyDesc").readOnly = false;				
					enableSearch("oscmCurrency");
				} else {//if(row.recordStatus != null || row.recordStatus != "" ){
					$("txtConvertRate").disabled = true ; // kris 02.04.2013
					$("txtCurrencyCd").readOnly = true;
					$("txtForeignCurrAmt").readOnly =  true;
					$("txtDspCurrencyDesc").readOnly =  true;				
					disableSearch("oscmCurrency");
				}
				// end 
				
				if (row.orTag == "V") {
	  	  			$("orTagVAT").checked = true;
	  			} else {
	  				$("orTagNonVAT").checked = true;
	  			}
				
				
				if(changed=="N"){
					if($("btnAddRecord").value=="Update"){
						disableButton($("btnAddRecord"));
						$("orTagNonVAT").disable();
						$("orTagVAT").disable();
					}else{
						if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
							enableButton($("btnAddRecord"));
						}
					}
					if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR")  && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
						enableButton($("btnDeleteRecord"));
					}
				}else if (changed == "A" && $("btnAddRecord").value=="Update"){
					enableButton($("btnDeleteRecord"));
				}
			}catch(e){
				showErrorMessage("populateDetails",e);
			}
		}
			
		function clearFields() {
			try{
				$("txtTransactionType").enable;
				$("txtItemNo").value = getMaxItemNo();
				$("txtTransactionType").selectedIndex = 0;
				//$("txtTransactionType").options[$("txtTransactionType").selectedIndex].text="";
				$("txtB140IssCd").clear();
				$("txtTranYear").clear();
				$("txtTranMonth").clear();
				$("txtTranSeqNo2").clear();
				$("txtOldItemNo").clear();
				$("txtOldTranType").clear();				
				$("txtB140IssCd").selectedIndex = 0;
				$("txtB140IssCd").options[$("txtB140IssCd").selectedIndex].text="";
				$("txtB140PremSeqNo").clear();
				$("txtInstNo").clear();				
				$("txtCollectionAmt").clear();
				$("txtDepFlag").selectedIndex = 0;				
				$("txtDrvAssuredName").clear();
				$("txtDrvIntmName").clear();
				$("txtDrvRiName").clear();
				$("txtPolicyNo").clear();
				$("txtParNo").clear();
				$("txtCollnDt").value = new Date().format("mm-dd-yyyy"); //marco - 09.29.2014 - replaced $("txtCollnDt").clear();
				$("txtRemarks").clear();
				$("txtRemarks").readOnly =  false; //added by steven 12/19/2012
				$("txtCollectionAmt").readOnly =  false; //added by steven 12/19/2012
				$("orTagNonVAT").checked = true;
				if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
					$("txtB140IssCd").enable();
					$("txtCollectionAmt").enable();
					$("txtDepFlag").enable();
					$("orTagNonVAT").enable();
					$("orTagVAT").enable();
				}
				
				// added by Kris 02.01.2013
				$("txtConvertRate").value = $F("dfltCurrencyRt"); //clear();
				$("txtCurrencyCd").value = $F("dfltCurrencyCd"); //.clear();
				$("txtForeignCurrAmt").clear(); //.value = $("dfltCurrencyCd"); //
				$("txtDspCurrencyDesc").value = $F("dfltCurrencyDesc"); //clear();
				//$("txtConvertRate").readOnly = false;
				$("txtConvertRate").disabled = false;
				$("txtCurrencyCd").readOnly = false;
				$("txtForeignCurrAmt").readOnly = false;
				$("txtDspCurrencyDesc").readOnly = false;				
				enableSearch("oscmCurrency");
				// end
				
				$("txtTranYear").removeClassName("required");
				$("txtTranMonth").removeClassName("required");
				$("txtTranSeqNo2").removeClassName("required");
				$("txtOldItemNo").removeClassName("required");
				$("txtOldTranType").removeClassName("required");
			}catch(e){
				showErrorMessage("clearFields",e);
			}
		}
		
		function computeCollectionAmtTotal(){
			try{
				var collectionAmtTotal = 0;
					
				for (var i=0; i<premDepTableGrid.rows.length; i++){
					var val = premDepTableGrid.rows[i][premDepTableGrid.getColumnIndex('collectionAmt')] == null || premDepTableGrid.rows[i][premDepTableGrid.getColumnIndex('collectionAmt')] == "" ? 0 
							: unformatCurrencyValue(premDepTableGrid.rows[i][premDepTableGrid.getColumnIndex('collectionAmt')]);
					collectionAmtTotal = parseFloat(collectionAmtTotal+val);
				}

				 var delArray = new Object();
				delArray = getDeletedJSONObjects(objPremDep);
				var delTotal = 0;
				for (var i=0; i<delArray.length; i++){
					var val = delArray[i].collectionAmt == null || delArray[i].collectionAmt == "" ? 0 : unformatCurrencyValue(delArray[i].collectionAmt);
					delTotal = parseFloat(delTotal) + parseFloat(val);
				}
				collectionAmtTotal = parseFloat(collectionAmtTotal) - parseFloat(delTotal);
				
				var newRowsAdded = new Object();
				newRowsAdded = getAddedAndModifiedJSONObjects(objPremDep);
				for (var i=0; i<newRowsAdded.length; i++){
					var val = newRowsAdded[i].collectionAmt == null || newRowsAdded[i].collectionAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].collectionAmt);
					collectionAmtTotal = parseFloat(collectionAmtTotal) + parseFloat(val);
				} 

				//to include total amounts in other pages
				//collectionAmtTotal = parseFloat(collectionAmtTotal) + parseFloat(premDepTableGrid.pager.sumCollectionAmt);
				
				$("collectionAmtTotal").value = formatCurrency(collectionAmtTotal);	
				return formatCurrency(collectionAmtTotal);
				
			}catch(e){
				showErrorMessage("computeCollectionAmtTotal",e);
			}
		}	
		
		// set tab indexes and max length for foreign currency fields and enable currency LOV
		function setTabIndices(){
			$("txtCurrencyCd").tabindex = 20;
			$("txtConvertRate").tabindex = 21;
			$("txtDspCurrencyDesc").tabindex = 22;
			$("txtForeignCurrAmt").tabindex = 23;
			$("btnHideCurrPage").tabindex = 24;
			$("txtForeignCurrAmt").maxLength = 17;
			$("txtConvertRate").maxLength = 13;
			$("oscmCurrency").style.display = "inline";
		}
		
		//shan 10.31.2013
		function checkRequiredFieldsForAdd(){
			if($F("txtItemNo").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtItemNo");
				return false;
			}else if($F("txtTransactionType").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtTransactionType");
				return false;
			}if(!$F("txtTransactionType").blank()){
				if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4){
					if($F("txtTranYear").blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtTranYear");
						return false;
					}else if($F("txtTranMonth").blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtTranMonth");
						return false;
					}else if($F("txtTranSeqNo2").blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtTranSeqNo2");
						return false;
					}else if($F("txtOldItemNo").blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtOldItemNo");
						return false;
					}else if($F("txtOldTranType").blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtOldTranType");
						return false;
					}
				}
			}
			if($F("txtCollectionAmt").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtCollectionAmt");
				return false;
			}
			if(nvl('${requirePremDepIntm}', 'N') == 'Y' && $F("txtDrvIntmName") == ""){ //marco - 09.26.2014
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtDrvIntmName");
				return false;
			}
			
			return true;
		}
		
		
		//buttons
		$("btnAddRecord").observe("click", function(){
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				//if (/*checkAllRequiredFieldsInDiv("textFieldDiv")*/ checkRequiredFieldsForAdd()) {
				if(checkAllRequiredFieldsInDiv("textFieldDiv")){
					addRecord();
					clearFields();
					changed="A";
				}
			} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && changed == "N") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else {
				addRecord();
				clearFields();
				changed="A";
			}
			// kris 02.04.2013
			Effect.Fade($("currencyDiv"), {
				duration: .2
			}); 
		});
		
		$("btnDeleteRecord").observe("click", function(){
			deleteRecord();
// 			clearFields();
			selectedIndex = -1; //added by steven 12/19/2012
			resetFields(); //added by steven 12/19/2012
			disableButton($("btnDeleteRecord"));
			enableButton($("btnSavePremDep"));
			$("btnAddRecord").value = "Add";
			deleteTag = "Y";
		});
		
		$("btnSavePremDep").observe("click", function(){
			if(changed == "N" && deleteTag == "N"){ // condition added by: Nica 01.11.2013
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			}else{
				saveGIACPremDep();
				resetFields();				
			}
		});
		
		
		function resetFields(){
			clearFields();
			disableButton($("btnDeleteRecord"));
			$("btnAddRecord").value = "Add";
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
				enableButton($("btnAddRecord"));
				$("txtTransactionType").enable();
			}
			$("oscmIntermediaryDiv").removeClassName("required");
			$("txtDrvIntmName").removeClassName("required");
		}
		//Add new prem dep record or update existing prem dep record
		function addRecord() {
			if (checkGipdGipdFkConstraint()) {
				defCurrency();
				$("premDepListLastNo").value = parseInt($F("premDepListLastNo")) + 1;
				var rowPremDep = setObjPremDep(($("btnAddRecord").value));
				if($("btnAddRecord").value == "Add"){
					addNewPremDepRow(rowPremDep);
				}else if($("btnAddRecord").value == "Update"){
						objPremDep.splice(selectedIndex, 1, rowPremDep);
						premDepTableGrid.updateVisibleRowOnly(rowPremDep, selectedIndex);
						$("btnAddRecord").value = "Add";
						disableButton($("btnDeleteRecord"));
				}
				changeTag = 1;
				computeCollectionAmtTotal();
			} else {
				showMessageBox("This Old Tran Id,Old Item No.,Old Tran. Type does not exist", imgMessage.ERROR);
				clearFields();
			}
			enableButton($("btnSavePremDep"));
		}

		$("btnForeignCurrency").observe("click", function() {
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else if (selectedIndex == "-1") {
				var ok = true;
				
				//ok = checkRequiredFields();
				//if (ok) {
				if(checkAllRequiredFieldsInDiv("textFieldDiv")){	
					//$("currencyDiv").style.display = "block";
					defCurrency();
					
					Effect.Appear($("currencyDiv"), {
						duration: .2
					});
				}
			} else if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && $F("gipdChanged"+selectedIndex) == "N") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			} else {
				var ok = true;
				//ok = checkRequiredFields();
				//if (ok) {
				if(checkAllRequiredFieldsInDiv("textFieldDiv")){
					//$("currencyDiv").style.display = "block";
					defCurrency();
					
					Effect.Appear($("currencyDiv"), {
						duration: .2
					});
				}
			}
			var ok = true;
			
			//ok = checkRequiredFields();
			//if (ok) {
			if(checkAllRequiredFieldsInDiv("textFieldDiv")){
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
		
		function addNewPremDepRow(rowPremDep){
			objPremDep.push(rowPremDep);
			premDepTableGrid.addBottomRow(rowPremDep);
		}
		
		function setObjPremDep(action){
			var obj = new Object();
			obj.lastUpdate = new Date();
			obj.gaccTranId = objACGlobal.gaccTranId;
			obj.transactionType = $F("txtTransactionType");
			if (obj.transactionType == 1){
				obj.tranTypeName = "Collection";
			}else if (obj.transactionType == 2){
				obj.tranTypeName = "Refund";
			}else if (obj.transactionType == 3){
				obj.tranTypeName = "REFUND(NEGATIVE ENDORSEMENT)";
			}else {
				obj.tranTypeName = "RECLASS OF 3";
			}
			
			if($F("txtTranYear")!=""||$F("txtTranMonth")!=""||$F("txtTranSeqNo2")!=""){
				obj.dspOldTranNo = $F("txtTranYear")+"-"+$F("txtTranMonth")+"-"+$F("txtTranSeqNo2");
			}else{
				obj.dspOldTranNo = "";
			}
			obj.tranYear = $F("txtTranYear");
			obj.tranMonth = $F("txtTranMonth");
			obj.tranSeqNo = $F("txtTranSeqNo2");
			obj.oldTranId = $F("txtOldTranId");
			obj.oldItemNo = $F("txtOldItemNo");
			obj.oldTranType = $F("txtOldTranType");
			obj.issName = $("txtB140IssCd").options[$("txtB140IssCd").selectedIndex == -1 ? 0 : $("txtB140IssCd").selectedIndex].text;
			obj.b140PremSeqNo = $F("txtB140PremSeqNo");
			obj.instNo = $F("txtInstNo");
			obj.collectionAmt = $F("txtCollectionAmt");
			obj.remarks = $F("txtRemarks");
			obj.depFlag = $F("txtDepFlag");
			obj.assdNo = $F("txtAssdNo");
			obj.assuredName = $F("txtAssuredName");
			obj.intmNo = $F("txtIntmNo");
			obj.intmName = $F("txtIntmName");
			obj.riCd = $F("txtRiCd");
			obj.riName = $F("txtRiName");
			obj.lineCd = $F("txtLineCd");
			obj.sublineCd = $F("txtSublineCd");
			obj.issCd = $F("txtIssCd");
			obj.issueYy = $F("txtIssueYy");
			obj.polSeqNo = $F("txtPolSeqNo");
			obj.renewNo = $F("txtRenewNo");
			obj.parLineCd = $F("txtParLineCd");
			obj.parIssCd = $F("txtParIssCd");
			obj.parYy = $F("txtParYy");
			obj.parSeqNo = $F("txtParSeqNo");
			obj.quoteSeqNo = $F("txtQuoteSeqNo");
			obj.policyNo = $F("txtPolicyNo");
			obj.parNo = $F("txtParNo");
			obj.collnDt = $F("txtCollnDt");
			obj.currencyCd = $("txtCurrencyCd").value;
			obj.currencyDesc = $("txtDspCurrencyDesc").value;  // kris 02.01.2013
			obj.convertRate = $("txtConvertRate").value;
			obj.foreignCurrAmt = unformatCurrencyValue($("txtForeignCurrAmt").value); //robert
			obj.dspParNo = $("txtParNo").value
			if (obj.depFlag == 1){
				obj.dspDepFlag = "Unapplied";
			}else if (obj.depFlag == 2){
				obj.dspDepFlag = "Overpayment";
			}else{
				obj.dspDepFlag = "Overdraft Comm";
			}
			
			
			if ($("orTagVAT").checked == true){
				obj.orTag = "V";
			}else if($("orTagNonVAT").checked == true){
				obj.orTag = "N";
			}
			 
			if(action == "Add"){
				obj.itemNo = $("txtItemNo").value;
				obj.rowCount = objPremDep.length == 0 ? 1 : objPremDep[objPremDep.length-1].rowCount + 1;
				// robert 07.23.2012
				//obj.orPrintTag = "Y";
				obj.orPrintTag = "N";
				obj.b140IssCd = $("txtB140IssCd").value;
				obj.recordStatus = 0;
			}else{
				obj.itemNo = $("txtItemNo").value;
				obj.rowCount = objPremDep[selectedIndex].rowCount;
				obj.orPrintTag = objPremDep[selectedIndex].orPrintTag;
				obj.b140IssCd = $("txtB140IssCd").value;
				/* obj.cpiRecNo = objPremDep[selectedIndex].cpiRecNo;
				obj.cpiBranchCd = objPremDep[selectedIndex].cpiBranchCd; */
				obj.recordStatus = 1;
				
			}
			return obj;
		}
		
		function deleteRecord(){
			var delObj = delObjPremDep();
			objPremDep.splice(selectedIndex, 1, delObj);
			premDepTableGrid.deleteVisibleRowOnly(selectedIndex);
			computeCollectionAmtTotal();
			changeTag = 1;
		}

		function delObjPremDep(){
			var obj = new Object();
			obj.itemNo = $F("txtItemNo");
			obj.gaccTranId = objACGlobal.gaccTranId;
			obj.transactionType = $F("txtTransactionType");
			if (obj.transactionType == 1){
				obj.tranTypeName = "Collection";
			}else if (obj.transactionType == 2){
				obj.tranTypeName = "Refund";
			}else if (obj.transactionType == 3){
				obj.tranTypeName = "REFUND(NEGATIVE ENDORSEMENT)";
			}else {
				obj.tranTypeName = "RECLASS OF 3";
			}
			obj.tranYear = $F("txtTranYear");
			obj.tranMonth = $F("txtTranMonth");
			obj.tranSeqNo = $F("txtTranSeqNo2");
			obj.oldTranId = $F("txtOldTranId");
			obj.oldItemNo = $F("txtOldItemNo");
			obj.oldTranType = $F("txtOldTranType");
			obj.issName = $("txtB140IssCd").options[$("txtB140IssCd").selectedIndex].text;
			obj.b140PremSeqNo = $F("txtB140PremSeqNo");
			obj.instNo = $F("txtInstNo");
			obj.collectionAmt = $F("txtCollectionAmt");
			obj.remarks = $F("txtRemarks");
			obj.depFlag = $F("txtDepFlag");
			obj.assdNo = $F("txtAssdNo");
			obj.assuredName = $F("txtAssuredName");
			obj.intmNo = $F("txtIntmNo");
			obj.intmName = $F("txtIntmName");
			obj.riCd = $F("txtRiCd");
			obj.riName = $F("txtRiName");
			obj.lineCd = $F("txtLineCd");
			obj.sublineCd = $F("txtSublineCd");
			obj.issCd = $F("txtIssCd");
			obj.issueYy = $F("txtIssueYy");
			obj.polSeqNo = $F("txtPolSeqNo");
			obj.renewNo = $F("txtRenewNo");
			obj.parLineCd = $F("txtParLineCd");
			obj.parIssCd = $F("txtParIssCd");
			obj.parYy = $F("txtParYy");
			obj.parSeqNo = $F("txtParSeqNo");
			obj.quoteSeqNo = $F("txtQuoteSeqNo");
			obj.policyNo = $F("txtPolicyNo");
			obj.parNo = $F("txtParNo");
			obj.collnDt = $F("txtCollnDt");
			
			if (obj.depFlag == 1){
				obj.dspDepFlag = "Overdraft Comm";
			}else if (obj.depFlag == 2){
				obj.dspDepFlag = "Overpayment";
			}else{
				obj.dspDepFlag = "Unapplied";
			}
			
			if ($("orTagVAT").checked == true){
				obj.orTag = "V";
			}else if($("orTagNonVAT").checked == true){
				obj.orTag = "N";
			}
			
			obj.recordStatus = -1;
			
			return obj;
		}
		
		function getMaxItemNo(){
			var maxItemNo = 0;
			for(var i = 0; i < objPremDep.length; i++){
				maxItemNo = objPremDep[i].itemNo > maxItemNo ? objPremDep[i].itemNo : maxItemNo;
				if (objPremDep.length == 0){
					maxItemNo = 0;
				}
			}
			return parseInt(maxItemNo)+1;
		}
		
		function updateObjPremDep(){
			for(var i = 0; i < objPremDep.length; i++){
				if(objPremDep[i].recordStatus == -1){
					objPremDep[i].recordStatus == null;
					delete objPremDep[i];
				}else{
					objPremDep[i].recordStatus == null;
				}
			}
		}
		
		 function saveGIACPremDep(){
			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objPremDep);
			objParams.delRows = getDeletedJSONObjects(objPremDep);
			new Ajax.Request(contextPath+"/GIACPremDepositController?action=saveGIACPremDep",{
				method: "POST",
				parameters:{
					globalGaccTranId: objACGlobal.gaccTranId,
					globalGaccBranchCd: objACGlobal.branchCd,
					globalGaccFundCd: objACGlobal.fundCd,
					genType :$("varItemGenType").value,
					orFlag  :objACGlobal.orFlag,
					tranSource: objACGlobal.tranSource,
					parameters: JSON.stringify(objParams)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving Premuim Deposit Collections, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "S");
							changeTag = 0;
							regenerate = 0;
							updateObjPremDep();
							premDepTableGrid.refresh();
							changed = "N";
							deleteTag = "N";
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
					//disableButton("btnSavePremDep");
				}
			});
		}
		 
		 /* moved to accounting.js : shan 11.04.2013 
		 function validateOldTranType() {
				collectionDefaultAmount($F("txtTransactionType"));
				$("lastOldTranType").value = $F("txtOldTranType");
			}
		 
		// PROCEDURES
		//collection_default_amount or collection_dflt_amt_for_4, depending on the parameter value
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
						dspTranSeqNo: $F("txtTranSeqNo2"),
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
						if (checkCustomErrorOnResponse(response)) {
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
			} */
		
			//validate_tran_type2
			function validateTranType2() {
				new Ajax.Request(contextPath+"/GIACPremDepositController?action=validateTranType2", {
					evalScripts: true,
					asynchronous: true,
					method: "GET",
					parameters: {
						transactionType: $F("txtTransactionType"),
						dspTranYear: $F("txtTranYear"),
						dspTranMonth: $F("txtTranMonth"),
						dspTranSeqNo: $F("txtTranSeqNo2"),
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
						if (checkCustomErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();

							if (result.message != "SUCCESS") {
								showMessageBox(result.message, imgMessage.INFO);
							}

							$("txtTransactionType").value = result.transactionType;
							$("txtTranYear").value = result.dspTranYear;
							$("txtTranMonth").value = result.dspTranMonth;
							$("txtTranSeqNo2").value = result.dspTranSeqNo;
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
			}  else if (getDecimalLength($F("txtItemNo")) > 0) {
				showMessageBox("Invalid value of Item No. Value should be from 1 to 999,999,999", imgMessage.ERROR); 
				$("txtItemNo").value = $F("lastItemNo");
				$("txtItemNo").focus();
				return false;
			} else if (checkIfItemNoExists(parseInt($F("txtItemNo")))) {
				$("txtItemNo").value = $F("lastItemNo");
				showMessageBox("Item no. is already existing", imgMessage.ERROR);
				$("txtItemNo").focus();
				return false;
			}else {
				$("txtItemNo").value = parseInt($F("txtItemNo"));
				$("lastItemNo").value = $F("txtItemNo");
			}
		});
		
		function proceedTranChange(){
			if (checkIfExisting()) {
				$("txtTransactionType").clear();
				showMessageBox("A record with the same item no and transaction type already exists.", imgMessage.ERROR);
				$("txtTransactionType").focus();
			} else {
				if ($F("varLovSwitch") == 1) {
					if ($F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
						$("varPckSwitch").value = 1;
						$("txtOldTranId").value = $F("varTranId");
						
						$("txtPolicyNo").clear();
					} else {
						$("varPckSwitch").clear();
					}
				}
				$("txtCollectionAmt").clear();
				
				enableDisableFields();
				transactionTypeTrigger();
				currencyCdTrigger();
				defCurrency();
			}
		}
		
		$("txtTransactionType").observe("focus", function(){
			$("txtTransactionType").setAttribute("lastValidValue", $F("txtTransactionType"));
		});
		
		$("txtTransactionType").observe("change", function() {
			//marco - 09.26.2014
			var proceed = "Y";
			if(nvl(hasPremDepTran34, "Y") == "N" && ($F("txtTransactionType") == "3" || $F("txtTransactionType") == "4")){
				showConfirmBox("Confirmation", "User is not allowed to enter Premium Deposit Transaction Type 3 or 4. Would you like to override?",
					"Yes", "No",
					function(){
						showGenericOverride("GIACS026", "PD",
							function(ovr, userId, result){
								if(result == "FALSE"){
									showMessageBox("User " + userId + " is not allowed for override.", imgMessage.ERROR);
									$("txtOverrideUserName").clear();
									$("txtOverridePassword").clear();
									$("txtOverrideUserName").focus();
									$("txtTransactionType").value = $("txtTransactionType").getAttribute("lastValidValue");
									return false;
								}else if(result == "TRUE"){
									hasPremDepTran34 = "Y";								
									proceedTranChange();
									ovr.close();
									delete ovr;
								}
							},
							function(){
								$("txtTransactionType").value = $("txtTransactionType").getAttribute("lastValidValue");
							}, "Request for Override");
					},
					function(){
						$("txtTransactionType").value = $("txtTransactionType").getAttribute("lastValidValue");
					}, "1");
			} else{
				proceedTranChange();
			}
		});
		
		$("txtOldTranType").observe("change", function() {
			if (isNaN($F("txtOldTranType"))) {
				$("txtOldTranType").value = $F("lastOldTranType");
				showMessageBox("Field must be of form 09.", imgMessage.ERROR);
			} else if (!$F("txtTranYear").blank() && !$F("txtTranMonth").blank() && !$F("txtTranSeqNo2").blank() &&
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
		
		$("txtB140IssCd").observe("change", function() {
			//marco - 09.26.2014
			deleteRecordForIssCdLOV();
			$("txtB140PremSeqNo").value = "";
			$("txtInstNo").value = "";
			
			premDepIssCdTrigger();
			$("txtB140PremSeqNo").focus();
			
			//john 11.7.2014
			if(nvl('${requirePremDepIntm}', 'N') == 'Y' && $F("txtTransactionType") == "1" && $F("txtB140IssCd") != "RI" && $F("txtB140IssCd") != ""){
				$("oscmIntermediaryDiv").addClassName("required");
				$("txtDrvIntmName").addClassName("required");
			} else {
				$("oscmIntermediaryDiv").removeClassName("required");
				$("txtDrvIntmName").removeClassName("required");
			}
		});

		$("txtB140PremSeqNo").observe("change", function() {
			if ($F("txtB140PremSeqNo") != "") {
				if(($F("txtB140IssCd") == "RI")) {
					showGIACRiIssCdLOV();
				}else{
					deleteRecordForIssCdLOV();
					showGIACIssCdLOV();
				}
			} else if($F("txtB140PremSeqNo") == ""){
				$("txtDrvAssuredName").value = "";
				$("txtDrvIntmName").value = "";
				$("txtDrvRiName").value = "";
				$("txtPolicyNo").value = "";
				$("txtParNo").value = "";
				$("txtInstNo").value = "";
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
	
		
		$("txtCollectionAmt").observe("change",function(){
			var var1;
			$("txtCollectionAmt").value = formatCurrency((parseFloat($F("txtCollectionAmt").replace(/,/g,""))));
			
			if ($F("txtCollectionAmt").blank()) {
				showMessageBox("Required Fields must be entered.", imgMessage.ERROR);
				$("txtCollectionAmt").value = formatCurrency($F("txtDefaultValue"));
				return false;
			}
			if ($F("txtTransactionType") == 1) {
				 if (parseFloat(formatCurrency($F("txtCollectionAmt"))) < 0) {	// moved equal to 0 to 2nd condition : shan 11.04.2013
					$("txtCollectionAmt").value = $F("lastAmtValue");
					showMessageBox("Please enter positive value for tran type 1.", imgMessage.ERROR);
					return false;
				}else if (isNaN($F("txtCollectionAmt").replace(/,/g,"")) || parseFloat($F("txtCollectionAmt").replace(/,/g,"")) > 9999999999.99 || parseFloat($F("txtCollectionAmt").replace(/,/g,"")) == 0) {
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
					if (parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), 0)) <= 0) {
						showMessageBox("Reverting to default value/old value", imgMessage.ERROR);
						if (parseFloat($F("varPckDefaultValue").replace(/,/g,"")) > parseFloat($F("txtDefaultValue").replace(/,/g,"")) && !$F("varPckDefaultValue").blank()) {
							$("txtCollectionAmt").value = $F("varPckDefaultValue");
						} else {
							$("txtCollectionAmt").value = $F("txtDefaultValue");
						}
					}else if (isNaN($F("txtCollectionAmt").replace(/,/g,""))) {
						$("txtCollectionAmt").value = $F("lastAmtValue");
						showMessageBox("Invalid Amount. Value must be in range 0.01 to 9,999,999,999.99", imgMessage.ERROR);
						return false;
					}
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
				//marco - 09.29.2014 - added unformatCurrencyValue
				if (Math.abs(parseFloat(unformatCurrencyValue($F("txtCollectionAmt")))) > Math.abs(parseFloat(unformatCurrencyValue($F("txtDefaultValue"))))){
					if (unformatCurrencyValue($F("varPckDefaultValue")) < unformatCurrencyValue($F("txtDefaultValue"))) {
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
				//marco - 09.29.2014 - added unformatCurrencyValue
				if (Math.abs(parseFloat(unformatCurrencyValue($F("txtCollectionAmt")))) > Math.abs(parseFloat(unformatCurrencyValue($F("txtDefaultValue"))))){
					if (unformatCurrencyValue($F("varPckDefaultValue")) > unformatCurrencyValue($F("txtDefaultValue"))) {		//changed from > to < : shan 11.04.2013
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
			enableDisableFields();
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
 				//$("txtConvertRate").value = $F("varPckDefaultValue2"); // commented out by Kris 01.31.2013 SR 12073
				$("txtConvertRate").value = formatRate($F("txtConvertRate"));
 				if ($F("txtTransactionType") == 1) {
					if (selectedIndex == -1) {
						$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")));
					}
				} else {
					if (selectedIndex == -1) {
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
			if ($F("txtForeignCurrAmt").blank()) {
				showMessageBox("Amount cannot be null", imgMessage.ERROR);
				 $("txtForeignCurrAmt").clear();
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
			if (selectedIndex == -1) {
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
		
		//oscm validations
		$("oscmOldTransactionNo").observe("click", function() {
			if (selectedIndex == "-1") { //added by steven 12/19/2012
				openGipdOldItemNoLOV();
			}else if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					openGipdOldItemNoLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});
		
		$("oscmOldItemNo").observe("click", function() {
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				openGipdOldItemNoLOV();
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					openGipdOldItemNoLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});
			
		// shan 11.04.2013 : delete_record function in CS
		function deleteRecordForIssCdLOV(){
			$("txtAssdNo").clear();
			$("txtAssuredName").clear();
			$("txtDrvAssuredName").clear();
			$("txtIntmNo").clear();
			$("txtIntmName").clear();
			$("txtDrvIntmName").clear();
			$("txtRiCd").clear();
			$("txtRiName").clear();
			$("txtDrvRiName").clear();
			$("txtLineCd").clear();
			$("txtSublineCd").clear();
			$("txtIssCd").clear();
			$("txtIssueYy").clear();
			$("txtPolSeqNo").clear();
			$("txtRenewNo").clear();
			$("txtPolicyNo").clear();
			$("txtParLineCd").clear();
			$("txtParIssCd").clear();
			$("txtParYy").clear();
			$("txtParSeqNo").clear();
			$("txtQuoteSeqNo").clear();
			$("txtParNo").clear();
		}
		
		$("oscmB140IssCd").observe("click", function() {
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				if($F("txtTransactionType") != "" && $F("txtB140IssCd") != ""){
					if(($F("txtB140IssCd") == "RI")) {
						showGIACRiIssCdLOV();
					}else{
						deleteRecordForIssCdLOV();
						showGIACIssCdLOV();
					}
				} else{
					showMessageBox("Please select a transaction type and issue source first.", imgMessage.ERROR);
				}
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					if(($F("txtB140IssCd") == "RI")) {
							showGIACRiIssCdLOV();
						}else{
							deleteRecordForIssCdLOV();
							showGIACIssCdLOV();
						}
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}else{
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		});
		
		$("oscmCurrency").observe("click", function() {
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				showGIISCurrencyLOV();
			}else {
				if (objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") == "O" && changed == "N") {
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				} else {
					showGIISCurrencyLOV();
				}
			}
		});

		$("oscm").observe("click", function ()	{
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				showGIACAssdNameLOV();
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					showGIACAssdNameLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});
		
		$("oscmIntermediary").observe("click", function ()	{
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				showGIACIntmNameLOV();
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					showGIACIntmNameLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});

		$("oscmRi").observe("click", function ()	{
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				showGIACRiLOV();
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					showGIACRiLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});
		
		$("oscmPolicyNo").observe("click", function() {
			if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
				//showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
				var tranType1 =  $("txtTransactionType").options[1].getAttribute("rvMeaning");
				var tranType3 =  $("txtTransactionType").options[3].getAttribute("rvMeaning");
				showMessageBox("Transaction type should be 1 or 3 - "+tranType1+" or "+tranType3+".", imgMessage.INFO);
			}else if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				showGIACPolNoLOV();
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					showGIACPolNoLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});

		$("oscmParNo").observe("click", function() {
			if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
				//showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
				var tranType1 =  $("txtTransactionType").options[1].getAttribute("rvMeaning");
				var tranType3 =  $("txtTransactionType").options[3].getAttribute("rvMeaning");
				showMessageBox("Transaction type should be 1 or 3 - "+tranType1+" or "+tranType3+".", imgMessage.INFO);
			}else if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				showGIACParNoLOV();
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					showGIACParNoLOV();
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});
		
		
		// functions
		function openGipdOldItemNoLOV() {
			if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "1" || $F("txtTransactionType") == "3") {
				//showMessageBox("Transaction type should be 2 or 4 - "+$("txtTransactionType").options[2].text+" or "+$("txtTransactionType").options[4].text+".", imgMessage.INFO);
				var tranType2 =  $("txtTransactionType").options[2].getAttribute("rvMeaning");
				var tranType4 =  $("txtTransactionType").options[4].getAttribute("rvMeaning");
				showMessageBox("Transaction type should be 2 or 4 - "+tranType2+" or "+tranType4+".", imgMessage.INFO);
			} else{
				showGIACOldItemNoLOV();
			}
		}
		
		// texts
		$("editTxtRemarksPremDep").observe("click", function() {
			/* if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
				//showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
				var tranType1 =  $("txtTransactionType").options[1].getAttribute("rvMeaning");
				var tranType3 =  $("txtTransactionType").options[3].getAttribute("rvMeaning");
				showMessageBox("Transaction type should be 1 or 3 - "+tranType1+" or "+tranType3+".", imgMessage.INFO);
			}else*/ if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showOverlayEditor("txtRemarks", 4000, true);
			}else if (selectedIndex == "-1") {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					//showEditor("txtRemarks", 4000);
					showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly")); // andrew - 08.15.2012
				}else{
					showOverlayEditor("txtRemarks", 4000, true);
				}
			}
		});
		
		//img
		$("hrefCollnDate").observe("click", function(){
			/* if ($F("txtTransactionType").blank() || $F("txtTransactionType") == "2" || $F("txtTransactionType") == "4") {
				//showMessageBox("Transaction type should be 1 or 3 - "+$("txtTransactionType").options[1].text+" or "+$("txtTransactionType").options[3].text+".", imgMessage.INFO);
				var tranType1 =  $("txtTransactionType").options[1].getAttribute("rvMeaning");
				var tranType3 =  $("txtTransactionType").options[3].getAttribute("rvMeaning");
				showMessageBox("Transaction type should be 1 or 3 - "+tranType1+" or "+tranType3+".", imgMessage.INFO);
			}else */ //marco - 09.29.2014 - removed condition - SR 2542
			if ((objACGlobal.orFlag == "P" && $F("hidAccTransTranFlag") != "O") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}else if (selectedIndex == "-1") {
				$('txtCollnDt').focus();
				scwShow($('txtCollnDt'),this, null);
			}else if(objACGlobal.orFlag == "N" && $F("hidAccTransTranFlag") == "O") {
				if(changed == "A"){
					$('txtCollnDt').focus();
					scwShow($('txtCollnDt'),this, null);
				}else{
					showMessageBox("This item may not be updated.", imgMessage.INFO);
				}
			}
		});
		
		$("txtDrvAssuredName").observe("keyup", function(e){
			if(e.keyCode == 46 || e.keyCode == 8){
				$("txtAssdNo").value = "";
				$("txtDrvAssuredName").value = "";
				$("txtAssuredName").value = "";
			}
		});
		
		$("txtDrvIntmName").observe("keyup", function(e){
			if(e.keyCode == 46 || e.keyCode == 8){
				$("txtIntmNo").value = "";
				$("txtDrvIntmName").value = "";
				$("txtIntmName").value = "";
			}
		});
		
		$("txtDrvRiName").observe("keyup", function(e){
			if(e.keyCode == 46 || e.keyCode == 8){
				$("txtRiCd").value = "";
				$("txtDrvRiName").value = "";
				$("txtRiName").value = "";
			}
		});
		
		$("txtPolicyNo").observe("keyup", function(e){
			if(e.keyCode == 46 || e.keyCode == 8){
				$w("txtPolicyNo txtLineCd txtSublineCd txtIssCd txtIssueYy txtPolSeqNo txtRenewNo").each(function(e){
					$(e).value = "";
				});
			}
		});
		
		$("txtParNo").observe("keyup", function(e){
			if(e.keyCode == 46 || e.keyCode == 8){
				$w("txtParNo txtParLineCd txtParIssCd txtParYy txtParSeqNo txtQuoteSeqNo").each(function(e){
					$(e).value = "";
				});
			}
		});
			
		function defCurrency() {
			if ($F("txtCurrencyCd").blank()) {
				if (selectedIndex == -1) {
					$("txtDspCurrencyDesc").value = $F("dfltCurrencyDesc");
					$("txtConvertRate").value = truncateDecimal(parseFloat(nvl($F("dfltCurrencyRt"), "0")), 2);
					$("txtCurrencyCd").value = $F("dfltCurrencyCd");
				}
			}

			if (selectedIndex == -1) {
				var foreignCurrAmt = nvl($F("txtCollectionAmt"), 0) / parseFloat($F("txtConvertRate"));

				if (nvl(foreignCurrAmt, 0) != nvl($F("txtForeignCurrAmt").replace(/,/g,""), 0)) {
					$("txtForeignCurrAmt").value = formatCurrency(foreignCurrAmt);
				}
				$("txtForeignCurrAmt").value = formatCurrency((parseFloat(nvl($F("txtCollectionAmt").replace(/,/g,""), "0")) / $F("txtConvertRate")));
			}
		}
		
		function checkTransactionType(){
			$("txtCollectionAmt").readOnly = false;
			if ($F("txtTransactionType") == 1 || $F("txtTransactionType") == 3) {
				$("txtTranYear").clear();
				$("txtTranMonth").clear();
				$("txtTranSeqNo2").clear();
				$("txtOldItemNo").clear();
				$("txtOldTranType").clear();

				$("txtTranYear").readOnly = true;
				$("txtTranMonth").readOnly = true;
				$("txtTranSeqNo2").readOnly = true;
				$("txtOldItemNo").readOnly = true;
				$("txtOldTranType").readOnly = true;
				
				$("txtB140IssCd").enable();
				$("txtB140PremSeqNo").readOnly = false;
				$("txtInstNo").readOnly = false;
				
			} else if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4) {
				//$("txtB140IssCd").clear();
				//$("txtB140PremSeqNo").clear();
				//$("txtInstNo").clear();
				
				$("txtTranYear").readOnly = false;
				$("txtTranMonth").readOnly = false;
				$("txtTranSeqNo2").readOnly = false;
				$("txtOldItemNo").readOnly = false;
				$("txtOldTranType").readOnly = false;

				$("txtB140IssCd").disable();
				$("txtB140PremSeqNo").readOnly = true;
				$("txtInstNo").readOnly = true;
			} else {
				$("txtTranYear").readOnly = true;
				$("txtTranMonth").readOnly = true;
				$("txtTranSeqNo2").readOnly = true;
				$("txtOldItemNo").readOnly = true;
				$("txtOldTranType").readOnly = true;
				
				$("txtB140IssCd").disable();
				$("txtB140PremSeqNo").readOnly = true;
				$("txtInstNo").readOnly = true;
			}
		}
		
		function enableDisableFields() {
			if (changed == "N"){
				if ($("btnAddRecord").value == "Update"){
					$("txtItemNo").readOnly = true;
					$("txtTransactionType").disable();
					$("txtTranYear").readOnly = true;
					$("txtTranMonth").readOnly = true;
					$("txtTranSeqNo2").readOnly = true;
					$("txtOldItemNo").readOnly = true;
					$("txtOldTranType").readOnly = true;
					$("txtB140IssCd").disable();
					$("txtB140PremSeqNo").readOnly = true;
					$("txtInstNo").readOnly = true;
					$("txtCollectionAmt").readOnly = true;
					$("txtDepFlag").disable();
					
					$("txtDrvAssuredName").readOnly = true;
					$("txtDrvIntmName").readOnly = true;
					$("txtDrvRiName").readOnly = true;
					$("txtPolicyNo").readOnly = true;									
					$("txtParNo").readOnly = true;
					$("txtCollnDt").readOnly = true;
					$("txtRemarks").readOnly = true;
					$("btnAddRecord").value = "Update";
					
						
				} else {
					checkTransactionType();
				}
			}else{
					checkTransactionType();
			}

			if ($F("txtCurrencyCd").blank() && selectedIndex == -1) {
				$("txtCurrencyDesc").value = $F("dfltCurrencyDesc");
				$("txtConvertRate").value = truncateDecimal(parseFloat(nvl($F("dfltCurrencyRt"), "0")), 2); 
				$("txtCurrencyCd").value = $F("dfltMainCurrencyCd");
			}

			if ($F("dfltCurrencyCd") == $F("txtCurrencyCd")) {
				$("txtConvertRate").readOnly = true;
			} else {
				$("txtConvertRate").readOnly = false;
			}	
			
			// added by Kris 02.01.2013
			//$("txtConvertRate").disabled = true;
			$("txtCurrencyCd").readOnly = true;
			$("txtForeignCurrAmt").readOnly = true;
			$("txtDspCurrencyDesc").readOnly = true;
			
			if(nvl('${requirePremDepIntm}', 'N') == 'Y' && $F("txtTransactionType") == "1" && $F("txtB140IssCd") != "RI" && $F("txtB140IssCd") != ""){
				$("oscmIntermediaryDiv").addClassName("required");
				$("txtDrvIntmName").addClassName("required");
			} else {
				$("oscmIntermediaryDiv").removeClassName("required");
				$("txtDrvIntmName").removeClassName("required");
			}
			
			if($F("txtTransactionType") != "" && ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4)){
				$("txtTranYear").addClassName("required");
				$("txtTranMonth").addClassName("required");
				$("txtTranSeqNo2").addClassName("required");
				$("txtOldItemNo").addClassName("required");
				$("txtOldTranType").addClassName("required");
			} else {
				$("txtTranYear").removeClassName("required");
				$("txtTranMonth").removeClassName("required");
				$("txtTranSeqNo2").removeClassName("required");
				$("txtOldItemNo").removeClassName("required");
				$("txtOldTranType").removeClassName("required");
			}
		}
		// trigger when transaction type is changed
		function transactionTypeTrigger() {
			if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4) {
				$("txtTranYear").addClassName("required");
				$("txtTranMonth").addClassName("required");
				$("txtTranSeqNo2").addClassName("required");
				$("txtOldItemNo").addClassName("required");
				$("txtOldTranType").addClassName("required");
			} else {
				$("txtTranYear").removeClassName("required");
				$("txtTranMonth").removeClassName("required");
				$("txtTranSeqNo2").removeClassName("required");
				$("txtOldItemNo").removeClassName("required");
				$("txtOldTranType").removeClassName("required");
			}
			$("txtTranYear").value = "";
			$("txtTranMonth").value = "";
			$("txtTranSeqNo2").value = "";
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
			$("txtDrvRiName").value = "";
			$("txtIntmNo").value = "";
			$("txtDrvIntmName").value = "";
			$("txtIntmName").value = "";
			$("txtCollnDt").value = dateFormat(new Date(), "mm-dd-yyyy");
			$("txtB140IssCd").value = "";
			//added john 11.7.2014
			$("txtDrvIntmName").removeClassName("required");
			$("oscmIntermediaryDiv").removeClassName("required");
		}
		
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
		
		// check if item no and transaction type already exists
		function checkIfExisting() {
			exists = false;
			for(var i = 0; i < objPremDep.length; i++){
				 if (objPremDep[i].itemNo == parseInt($F("txtItemNo")) 
						 && objPremDep[i].transactionType == parseInt($F("txtTransactionType"))){
					 exists = true;
				 }
			}
			return exists;
		}
		
		// check if item no already exists
		function checkIfItemNoExists(itemNo) {
			exists = false;
			for(var i = 0; i < objPremDep.length; i++){
				 if (objPremDep[i].itemNo == itemNo){
					 exists = true;
				 }
			}
			return exists;
		}
		
		// check if the entered old tran id, old item no, and old tran type exists.
		// this is to avoid foreign key constraint errors
		function checkGipdGipdFkConstraint() {
			var ok = true;
			if ($F("txtTransactionType").blank() || $F("txtTransactionType") ==  "2" || $F("txtTransactionType") == "4") {
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
						if (checkCustomErrorOnResponse(response)) {
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
		
		setTabIndices();
		computeCollectionAmtTotal();
		setModuleId("GIACS026");
		setDocumentTitle("Collections on Premium Deposit");
		
		window.scrollTo(0,0); 	
		hideNotice("");
		observeCancelForm("btnCancel", saveGIACPremDep, function(){
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;							
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				changeTag = 0;
				showORInfo();
			}
		});
 }catch(e){
	 showErrorMessage("Error in directTransPremDeposit Page",e);
 }
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS026(){
		try {
			$("txtItemNo").readOnly = true;
			$("txtItemNo").removeClassName("required");
			$("txtTransactionType").disable();
			$("txtTransactionType").removeClassName("required");
			//disableSearch("oscmOldItemNo");
			disableSearch("oscmOldTransactionNo");
			disableSearch("oscmB140IssCd");
			$("txtCollectionAmt").readOnly = true;
			$("txtCollectionAmt").removeClassName("required");
			$("txtDepFlag").disable();
			$("txtDepFlag").removeClassName("required");
			$("orTagVAT").disable();
			$("orTagNonVAT").disable();
			disableButton("btnAddRecord");
			disableSearch("oscm");
			disableSearch("oscmIntermediary");
			disableSearch("oscmRi");
			disableSearch("oscmPolicyNo");
			disableSearch("oscmParNo");
			disableDate("hrefCollnDate");
			$("txtRemarks").readOnly = true;
			$("txtCurrencyCd").readOnly = true;
			disableSearch("oscmCurrency");
			$("txtForeignCurrAmt").readOnly = true;
			$("txtConvertRate").readOnly = true; 
			disableButton("btnSavePremDep"); //added by Robert SR 5189 12.22.15
		} catch(e){
			showErrorMessage("disableGIACS026", e);
		}
	}

	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS026();
	} else {
		initializeChangeTagBehavior(saveGIACPremDep);
	}
	
	//shan 11.04.2013
	if ((objACGlobal.orTag == null && (objACGlobal.orStatus == "CANCELLED" || objACGlobal.orStatus == "PRINTED")) || 	//system-generated
			(objACGlobal.orTag == "*" && (objACGlobal.orStatus == "CANCELLED" || objACGlobal.orStatus == "CLOSED"))) { 	//manual
		disableButton("btnSavePremDep");
		disableButton("btnAddRecord");
	}
	
	$("acExit").stopObserving("click"); 
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						//saveOutFaculPremPayts();
						saveGIACPremDep();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS002"){
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS003"){
							if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
								showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}else{
								showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}
							objACGlobal.previousModule = null;							
						}else if(objACGlobal.previousModule == "GIACS071"){
							updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS002"){
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS003"){
							if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
								showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}else{
								showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}
							objACGlobal.previousModule = null;							
						}else if(objACGlobal.previousModule == "GIACS071"){
							updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;							
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});
</script>