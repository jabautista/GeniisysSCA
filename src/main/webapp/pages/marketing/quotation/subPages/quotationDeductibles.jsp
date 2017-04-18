<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!--nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles -->
<!--nieko new JSP-->

<div id="hidPerilListDiv">
	<c:forEach var="peril" items="${dedPerilsList}">
		<div id="hidPeril${peril.perilCd}" name="hidPeril">
			<input type="hidden" id="hidItemNo${peril.perilCd}" 	name="hidItemNo" 	value="${peril.itemNo}">
			<input type="hidden" id="hidPerilCd${peril.perilCd}" 	name="hidPerilCd" 	value="${peril.perilCd}">
			<input type="hidden" id="hidTsiAmt${peril.perilCd}" 	name="hidTsiAmt" 	value="${peril.tsiAmt}">
			<input type="hidden" id="hidPerilType${peril.perilCd}"  name="hidPerilType"	value="${peril.perilType}">
		</div>
	</c:forEach>
</div>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="">Quotation Deductibles</label>
		<span class="refreshers" style="margin-top: 0;"> 
			<label name="gro">Hide</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="quotationDeductDiv">
	<jsp:include page="/pages/marketing/quotation/subPages/quotationDeductiblesTableGridListing.jsp"></jsp:include>
	<%-- <jsp:include page="/pages/marketing/quotation/subPages/quotationDeductiblesTableGrid2.jsp"></jsp:include> --%>
	
	<table align="center" width="60%" style="margin-top: 10px;">
	 	<tr>
			<td class="rightAligned">Deductible Title </td>
			<td class="leftAligned" colspan="3">
				<div style="float: left; border: solid 1px gray; width: 100%; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="txtDeductibleCd1" name="txtDeductibleCd1" />
					<input class="required" type="text" tabindex="5001" style="float: left; margin-top: 0px; margin-right: 3px; width: 93.5%; border: none;" name="txtDeductibleDesc1" id="txtDeductibleDesc1" readonly="readonly" value="" />
					<img id="hrefDeductible1" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>				
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="13%">Rate </td>
			<td class="leftAligned" width="25%"><input tabindex="5002" id="deductibleRate1" name="deductibleRate1" type="text" style="width: 96%; text-align: right;" maxlength="13" readonly="readonly"/></td>		
			<td class="rightAligned" width="13%">Amount </td>
			<td class="leftAligned" width="25%"><input tabindex="5003" id="inputDeductibleAmount1" name="inputDeductibleAmount1" type="text" style="width: 96%; text-align: right;" class="" maxlength="17" readonly="readonly"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Deductible Text </td>
			<td class="leftAligned" colspan="3"><textarea tabindex="5004" id="deductibleText1" name="deductibleText1" style="width: 98.5%; resize: none;" maxlength="2000" rows="2" readonly="readonly"></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td colspan="3">
				<table>
					<tr>
						<td><input tabindex="5005" type="checkbox" id="aggregateSw1" name="aggregateSw1" /></td>
						<td class="rightAligned">Aggregate</td>					
						<td class="rightAligned" width="20%">
							<input tabindex="5006" type="checkbox" id="ceilingSw1" name="ceilingSw1" />
						</td>
						<td class="rightAligned">Ceiling Switch</td>					
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<div style="width: 100%; margin-bottom: 10px;" align="center" id="dedButtonsDiv1">
		<input tabindex="5007" id="btnAddDeductible1" class="button" type="button" value="Add" style="width: 60px; margin: 5px 0px 5px 0px;" />
		<input tabindex="5008" id="btnDeleteDeductible1" class="button" type="button" value="Delete" style="width: 60px;" />
	</div>
</div>

<script type="text/javascript">

	function quoteDeductibleLOV(tableGrid){
		try {			
			var notIn = "";
			var withPrevious = false;
			var itemNo = (1 < 1 ? $F("itemNo") : 0);
			var perilCd = (3 == 1 ? $F("perilCd") : 0);		
			
			for(var i=0, length=tableGrid.geniisysRows.length; i < length; i++){
				if(nvl(tableGrid.geniisysRows[i].recordStatus, 0) != -1){
					if(withPrevious){
						notIn += ",";
					}
					notIn += "'" + tableGrid.geniisysRows[i].dedDeductibleCd + "'";
					withPrevious = true;
				}
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			var lineCd = $("lineCd").value;
			var sublineCd = nvl($("subline").getAttribute("sublineCd"), $F("subline"));

			showDeductibleLOV1(lineCd, sublineCd, 1, notIn);
		} catch (e){
			showErrorMessage("quoteDeductibleLOV1", e);
		}
	}
	

	function showDeductibleLOV1(lineCd, sublineCd, dedLevel, notIn) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISDeductibleLOV",
					lineCd : lineCd,
					sublineCd : sublineCd,
					notIn : notIn,
					page : 1
				},
				title : "Deductibles",
				width : 660,
				height : 320,
				columnModel : [ {
					id : "deductibleCd",
					title : "Code",
					width : '80px',
					renderer: function(value){
					       var str = value;
					       var dedCd = str.replace("slash", "/");
	         		   return  dedCd;}
				}, {
					id : "deductibleTitle",
					title : "Title",
					width : '220px'
				}, {
					id : "deductibleTypeDesc",
					title : "Type",
					width : '150px'
				}, {
					id : "deductibleRate",
					title : "Rate",
					width : '100px',
					align : 'right',
					geniisysClass : 'money'
				}, {
					id : "deductibleAmt",
					title : "Amount",
					width : '100px',
					align : 'right',
					geniisysClass : 'money'
				}, ],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						onDeductibleSelected1(row, dedLevel);
						$("deductibleText" + dedLevel).setAttribute("changed",
								"changed");
						changeTag = 1;
					}
				}
			});
		} catch (e) {
			showErrorMessage("showDeductibleLOV1", e);
		}
	}
	
	function onDeductibleSelected1(deductible, dedLevel) {
		var amount = deductible.deductibleAmt;
		var rate = deductible.deductibleRate;
		
		$("txtDeductibleCd" + dedLevel).value = deductible.deductibleCd.replace("slash", "/"); //[09.09.16] SR-22912 (.replace("slash", "/") added by: june mark
		
		$("txtDeductibleCd" + dedLevel).writeAttribute("deductibleType",
				deductible.deductibleType);
		$("txtDeductibleCd" + dedLevel).writeAttribute("minAmt",
				deductible.minimumAmount);
		
		$("txtDeductibleCd" + dedLevel).writeAttribute("maxAmt",
				deductible.maximumAmount);
		$("txtDeductibleCd" + dedLevel).writeAttribute("rangeSw",
				deductible.rangeSw);
		$("txtDeductibleDesc" + dedLevel).value = unescapeHTML2(deductible.deductibleTitle);
		$("inputDeductibleAmount" + dedLevel).value = (amount == null
				|| amount == "" ? "" : formatCurrency(amount));
		$("deductibleRate" + dedLevel).value = (rate == null || rate == "" ? ""
				: formatToNineDecimal(rate));
		$("deductibleText" + dedLevel).value = (unescapeHTML2(deductible.deductibleText)
				.replace(/\\n/g, "\n"));
		
		if (deductible.deductibleType == "T") {
			var itemNum = 1 < dedLevel ? $F("itemNo") : 0;
			var minAmt = deductible.minimumAmount;
			var maxAmt = deductible.maximumAmount;
			var rangeSw = deductible.rangeSw;
			var amount = parseFloat(getAmount1(dedLevel, itemNum))
					* (parseFloat(rate) / 100);

			if (rate != null) {
				if (minAmt != null && maxAmt != null) {
					if (rangeSw == "H") {
						$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
								.min(Math.max(amount, minAmt), maxAmt));
					} else if (rangeSw == "L") {
						$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
								.min(Math.max(amount, minAmt), maxAmt));
					} else {
						$("inputDeductibleAmount" + dedLevel).value = formatCurrency(maxAmt);
					}
				} else if (minAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
							.max(amount, minAmt));
				} else if (maxAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
							.min(amount, maxAmt));
				} else {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(amount);
				}
			} else {
				if (minAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(minAmt);
				} else if (maxAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(maxAmt);
				}
			}				
		}
	}

	function getAmount1(dedLevel, itemNo){
		try {
			var amount = 0;
			
			if (dedLevel == 1){
				$$("div[name='hidPeril']").each(function(peril){
					if(peril.down("input", 3).value == "B"){
						amount+= parseFloat(peril.down("input", 2).value.replace(/,/g, ""));
					}
				});
			} else if (dedLevel == 2){
				amount = parseFloat($F("txtTsiAmt").replace(/,/g, ""));	
			} else if (dedLevel == 3){
				amount = parseFloat(objQuote.selectedPerilInfoRow.perilTsiAmt);	
			}
			return amount;
		} catch (e){
			showErrorMessage("getAmount1", e);
		}
	} 
	$("hrefDeductible1").observe("click", function(){
		quoteDeductibleLOV(tbgQuotationDeductible);
	});
	
</script>

