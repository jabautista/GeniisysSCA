<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;" id= "installmentList">
	<div class="tableHeader">
		<label style="width: 60px; margin-left: 5px; ">Issue Cd</label>
		<label style="width: 50px; margin-left: 5px; ">Bill No.</label>
		<label style="width: 60px; margin-left: 15px; ">Inst. No.</label>
		<label style="width: 100px; text-align: right; margin-left: 15px; ">Collection Amt</label>
		<label style="width: 100px; text-align: right; margin-left: 15px; ">Premium Amt</label>
		<label style="width: 100px; text-align: right; margin-left: 15px; ">Tax Amt</label>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfpages>1}">
		<div align="right">
		Page:
			<select onChange="goToPageSearchInvoiceModal2(this)">
				<c:forEach var="i" begin="1" end="${noOfpages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageIndex==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfpages}
		</div>
	</c:if>
</div>
<script type="text/JavaScript"><!--
	//position page div correctly
	var jsonInstNoDetail = JSON.parse('${searchResults}'); //added by alfie 03/11/2011
    objAC.selectedInstallment = {};
	var product = 288 - (parseInt($$("div[name='row']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

	/*$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				try {
					if (row.hasClassName("selectedRow"))	{
						$("selectedClientId").value = row.getAttribute("id").substring(3);
						$$("div[name='row']").each(function (r)	{							
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}else{
								$("instNo").value = r.down("input", 0).value;
								if ($F("tranType") == 1 || $F("tranType") == 4) {
									$("premCollectionAmt").value = formatCurrency(r.down("input", 3).value);
									$("directPremAmt").value = formatCurrency(r.down("input", 4).value);
									$("taxAmt").value = formatCurrency(r.down("input", 5).value);
									$("origCollAmt").value = formatCurrency(r.down("input", 3).value);
									$("origPremAmt").value = formatCurrency(r.down("input", 4).value);
									$("origTaxAmt").value = formatCurrency(r.down("input", 5).value);
								}else{
									$("premCollectionAmt").value = formatCurrency(r.down("input", 6).value);
									$("directPremAmt").value = formatCurrency(r.down("input", 7).value);
									$("taxAmt").value = formatCurrency(r.down("input", 8).value);
									$("origCollAmt").value = formatCurrency(r.down("input", 6).value);
									$("origPremAmt").value = formatCurrency(r.down("input", 7).value);
									$("origTaxAmt").value = formatCurrency(r.down("input", 8).value);
								}
							}
						});
					}	
				} catch (e){
					showErrorMessage("searchInstNoDetailsAjaxResult.jsp", e);
					//showMessageBox("error : " + e.message);
				}
			});
		}
	);*/

	createDivTableRows(jsonInstNoDetail, "installmentList", "rowInst", "rowInst", "issCd premSeqNo instNo",prepareInstallmentsListing);

	addRecordEffects("rowInst", rowInstNoSelectedFunc, rowInstNoDeselectedFunc, "onPageLoad", null);
	
	//added by alfie 03/11/2011
	function prepareInstallmentsListing(obj) {
		try {
			var installments = 
				'<label style="width: 20px; margin-left: 20px;" id="' + obj.instNo + 'lblIssCd" name="issCd" title="' + obj.issCd + '">' + obj.issCd + '</label>' +
				'<label style="width: 60px; margin-left: 38px;" id="' + obj.instNo + 'lblPremSeqNo" name="premSeqNo" title="' + obj.premSeqNo + '">' + obj.premSeqNo + '</label> ' + 
				'<label style="width: 10px; margin-left: 15px;" id="' + obj.instNo + 'lblInstNo" name="instNo" title="' + obj.instNo + '">' + obj.instNo + '</label>' +
				'<label style="text-align: right; width: 100px; margin-left: 46px;" id="' + obj.instNo + 'lblCollnsAmt" name="amts" title="' + obj.collectionAmt +'">' + obj.collectionAmt + '</label>' +
				'<label style="text-align: right; width: 100px; margin-left: 15px;" id="' + obj.instNo + 'lblPremAmt" name="amts" title="' + obj.premAmt + '">' + obj.premAmt + '</label>' +
				'<label style="text-align: right; width: 100px; margin-left: 15px;" id="' + obj.instNo + 'lblTaxAmt" name="amts" title="' + obj.taxAmt + '">' + obj.taxAmt + '</label>';
			return installments;
		}  catch (e) {
			
			showErrorMessage("prepareInstallmentsListing", e);
		}
		
	}

	function rowInstNoSelectedFunc(row) {

		objAC.selectedInstallment = getObjectFromArrayOfObjects(jsonInstNoDetail, 
		        											  "issCd premSeqNo instNo",
							        						  row.down("label",0).innerHTML + // issCd/Issource
								        					  row.down("label",1).innerHTML + // premSeqNo/billCmNo
								        					  row.down("label",2).innerHTML); // instNo
	}

	function rowInstNoDeselectedFunc(row) {
		selectedInstallment = null;
	}

	$$("label[name='amts']").each(function (lbl) {
		//lbl.update((lbl.innerHTML).truncate(70, "..."));
		lbl.update(formatCurrency((lbl.innerHTML)));
	});
--></script>