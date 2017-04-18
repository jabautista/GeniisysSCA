<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="origSeqNo" name="origSeqNo" value=""/>
<c:forEach var="basic" items="${listBasic}">
	<div id="rowBasic${basic.sequenceNo}" name="rowBasic" class="tableRow">
		<input type='hidden' name="sequenceNos" value="${basic.sequenceNo}" />
		<input type='hidden' name="origPremAmts" value="${basic.netPremAmt}" />
		<input type='hidden' name="discountAmts" value="${basic.discountAmt}" />
		<input type='hidden' name="discountRts" value="${basic.discountRt}" />
		<input type='hidden' name="surchargeAmts" value="${basic.surchargeAmt}" />
		<input type='hidden' name="surchargeRts" value="${basic.surchargeRt}" />
		<input type='hidden' name="netGrossTags" value="${basic.netGrossTag}" />
		<input type='hidden' name="remarks" value="${basic.remarks}" />		
		<label style="width: 140px; text-align: center;">${basic.sequenceNo}
		<c:if test="${empty basic.sequenceNo}">-</c:if></label>
		<label style="width: 120px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${basic.netPremAmt}</fmt:formatNumber>		
		<c:if test="${empty basic.netPremAmt}">-</c:if></label>
		<label style="width: 130px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${basic.discountAmt}</fmt:formatNumber>
		<c:if test="${empty basic.discountAmt}">-</c:if></label>
		<label style="width: 120px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${basic.discountRt}</fmt:formatNumber>
		<c:if test="${empty basic.discountRt}">-</c:if></label>
		<label style="width: 140px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${basic.surchargeAmt}</fmt:formatNumber>
		<c:if test="${empty basic.surchargeAmt}">-</c:if></label>
		<label style="width: 130px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${basic.surchargeRt}</fmt:formatNumber>
		<c:if test="${empty basic.surchargeRt}">-</c:if></label>
		<c:if test="${basic.netGrossTag eq 'G'}">
			<label style="width: 50px; text-align: center;">
				<img style="width: 10px; height: 10px;" name="checkedImg"/>
			</label>
		</c:if>		
	</div>
</c:forEach>

<script>
try{
	var selectedRowId = '';
	objUW.hid3GIPIS143 = {}; //added by steven 10/01/2012
	objUW.hid3GIPIS143.perilSelected = false;
	$$("div[name='rowBasic']").each(
		function(row){
			row.observe("mouseover", function(){
				row.addClassName("lightblue");
			});
			row.observe("mouseout", function(){
				row.removeClassName("lightblue");
			});
			row.observe("click", function(){
				resetItemDiscountForm();
				resetPerilDiscountForm();
				selectedRowId = row.getAttribute("id");
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow")){
					$$("div[name='rowBasic']").each(function(r){
						if (row.getAttribute("id") != r.getAttribute("id")){
							r.removeClassName("selectedRow");
						}	
				     });
					$("sequenceNo").value = row.down("input", 0).value;
					$("premAmt").value = formatCurrency(row.down("input", 1).value);
					$("discountAmt").value = formatCurrency(row.down("input", 2).value);
					$("discountRt").value = formatRate(row.down("input", 3).value);
					$("surchargeAmt").value = formatCurrency(row.down("input", 4).value);
					$("surchargeRt").value = formatRate(row.down("input", 5).value);
					var gtag = row.down("input", 6).value;
					if(gtag == 'G'){
						$("grossTag").checked = true;
					}else{
						$("grossTag").checked = false;
					}		
					$("remark").value = row.down("input", 7).value;	
					showBasicButton(true);
					isLastRecord(row.down("input", 0).value);	
				}else{
					showBasicButton(false);
					objUW.hid3GIPIS143.perilSelected = false;
				}	    
			});			
		}	
	);

	$$("div[name='rowBasic']").each(function(div){
		if ((div.down("label", 1).innerHTML).length > 30){
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
	});

	$("btnDelDiscount").observe("click", function(){
		var seqNoForm = $("hiddenSequence").value; 
		if ($F("sequenceNo") != seqNoForm - 1){
			showMessageBox("Deleting of this record is not allowed. Last Sequence should be deleted first.", imgMessage.ERROR);
			return;
		}
		
		$$("div[name='rowBasic']").each(function(row){
			if (row.hasClassName("selectedRow")){
				var seqNoSelect = row.down("input", 0).value;
				var seqNoForm = $("sequenceNo").value; 
				if (seqNoSelect == seqNoForm){
					Effect.Fade(row,{
						duration: .2,
						afterFinish: function(){
							changeTag = 1;
							row.remove();		
							resetBasicDiscountForm1();
							resetItemDiscountForm();
							resetPerilDiscountForm();
							checkIfToResizeTable("billPolicyBasicDiscountTableList", "rowBasic");
							checkTableIfEmpty("rowBasic", "billPolicyBasicDiscountTable");
							showBasicButton(false);			
						}
					});
				}else{
					return false;
				}	
			}
		});
	});

	
	$("btnAddDiscount").observe("click", function(){
		if (validateBasicAdd()){
			var sequenceNo = $F('sequenceNo');
			var premAmt = formatCurrency($F("premAmt"));
			var discountAmt = formatCurrency($F("discountAmt"));
			var discountRt = formatRate($F("discountRt"));
			var surchargeAmt = formatCurrency($F("surchargeAmt"));
			var surchargeRt = formatRate($F("surchargeRt"));
			var grossTag = $("grossTag").checked==true?'G':'';
			var remark = changeSingleAndDoubleQuotes2($F("remark"));
			var itemTable = $("billPolicyBasicDiscountTableList");
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "rowBasic"+sequenceNo);
			newDiv.setAttribute("name", "rowBasic");
			newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");

			var strDiv = ''+
				'<input type="hidden" name="sequenceNos" value="'+sequenceNo+'" />'+
				'<input type="hidden" name="origPremAmts" value="'+premAmt+'" />'+
				'<input type="hidden" name="discountAmts" value="'+discountAmt+'" />'+
				'<input type="hidden" name="discountRts" value="'+discountRt+'" />'+
				'<input type="hidden" name="surchargeAmts" value="'+surchargeAmt+'" />'+
				'<input type="hidden" name="surchargeRts" value="'+surchargeRt+'" />'+
				'<input type="hidden" name="netGrossTags" value="'+grossTag+'" />'+
				'<input type="hidden" name="remarks" value="'+remark+'" />';		
			if(nvl(sequenceNo,'-') != '-'){
				strDiv += '<label style="width: 140px; text-align: center;">'+sequenceNo+'</label>';
			} else {
				strDiv += '<label style="width: 140px; text-align: center;">-</label>';
			}	
			if(nvl(premAmt,'-') != '-'){
				strDiv += '<label style="width: 120px; text-align: right;">'+
				formatCurrency(premAmt)+'</label>';
			} else {
				strDiv += '<label style="width: 120px; text-align: right;">-</label>';
			}	 	
			if(nvl(discountAmt,'-') != '-'){
				strDiv += '<label style="width: 130px; text-align: right;">'+
				formatCurrency(discountAmt)+'</label>';
			} else {
				strDiv += '<label style="width: 130px; text-align: right;">-</label>';
			}			
			if(nvl(discountRt,'-') != '-'){
				strDiv += '<label style="width: 120px; text-align: right;">'+
				formatRate(discountRt)+'</label>';
			} else {
				strDiv += '<label style="width: 120px; text-align: right;">-</label>';
			}	
			if(nvl(surchargeAmt,'-') != '-'){
				strDiv += '<label style="width: 140px; text-align: right;">'+
				formatCurrency(surchargeAmt)+'</label>';
			} else {
				strDiv += '<label style="width: 140px; text-align: right;">-</label>';
			}			
			if(nvl(surchargeRt,'-') != '-'){
				strDiv += '<label style="width: 130px; text-align: right;">'+
				formatRate(surchargeRt)+'</label>';
			} else {
				strDiv += '<label style="width: 130px; text-align: right;">-</label>';
			}	
			strDiv += '<label style="text-align: center; width: 50px;"><img style="width: 10px; height: 10px;" ';
			if(grossTag == 'G'){
				strDiv += 'name="checkedImg" src="'+checkImgSrc+'"';
			}	
			strDiv += '></img></label>';
	
			if ("Update" == $F("btnAddDiscount")){
				$$("div[name='rowBasic']").each(function(div){
					if (div.hasClassName("selectedRow")){
						newDiv = div;
					}
				});
				newDiv.update(strDiv);
			}else{
				newDiv.update(strDiv);
				itemTable.insert({bottom: newDiv});

				newDiv.observe("mouseover", function(){
					newDiv.addClassName("lightblue");
				});
			
				newDiv.observe("mouseout", function(){
					newDiv.removeClassName("lightblue");
				});

				newDiv.observe("click", function(){
					resetItemDiscountForm();
					resetPerilDiscountForm();
					selectedRowId = newDiv.getAttribute("id");
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow")){
						$$("div[name='rowBasic']").each(function(r){
							if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
				    	});
						$("sequenceNo").value = newDiv.down("input", 0).value;
						$("premAmt").value = formatCurrency(newDiv.down("input", 1).value);
						$("discountAmt").value = formatCurrency(newDiv.down("input", 2).value);
						$("discountRt").value = formatRate(newDiv.down("input", 3).value);
						$("surchargeAmt").value = formatCurrency(newDiv.down("input", 4).value);
						$("surchargeRt").value = formatRate(newDiv.down("input", 5).value);
						var gtag = newDiv.down("input", 6).value;
						if(gtag == 'G'){
							$("grossTag").checked = true;
						}else{
							$("grossTag").checked = false;
						}	
						$("remark").value = newDiv.down("input", 7).value;	
						showBasicButton(true);
						isLastRecord(newDiv.down("input", 0).value);			
					}else{
						showBasicButton(false);
					}
				});

				new Effect.Appear(newDiv,{
					duration: .2, 
					afterFinish: function(){
						checkTableIfEmpty("rowBasic", "billPolicyBasicDiscountTable");
					}
				});
			}
			resetBasicDiscountForm1();
			resetItemDiscountForm();
			resetPerilDiscountForm();
			checkIfToResizeTable("billPolicyBasicDiscountTableList", "rowBasic"); 
			changeTag = 1;
		}
	});

	function isLastRecord(seqNoSelect){
		var seqNoSelect = seqNoSelect;
		var seqNoForm = $("hiddenSequence").value; 
		if (seqNoSelect == seqNoForm - 1){
			$("sequenceNo").enable();
			$("premAmt").enable();
			$("discountAmt").enable();
			$("discountRt").enable();
			$("surchargeAmt").enable();
			$("surchargeRt").enable();
			$("grossTag").enable();
			$("remark").enable();
			enableButton("btnAddDiscount"); //change by steven 10/02/2012 from disableButton
			enableButton("btnDelDiscount");
			objUW.hid3GIPIS143.perilSelected = false;
		}else{
			$("sequenceNo").disable();
			$("premAmt").disable();
			$("discountAmt").disable();
			$("discountRt").disable();
			$("surchargeAmt").disable();
			$("surchargeRt").disable();
			$("grossTag").disable();
			$("remark").disable();
			disableButton("btnAddDiscount"); 
			enableButton("btnDelDiscount");
			objUW.hid3GIPIS143.perilSelected = true;
		}
	}	
	
	function validateBasicAdd(){
		var result = true;
		if (($("discountAmt").value == "0.00" || $("discountAmt").value == "") && ($("surchargeAmt").value == "0.00" || $("surchargeAmt").value == "")){
			showMessageBox("Please enter complete information before proceeding to the next record.");
			result = false;
			return false;
		}else if (parseFloat($F("discountAmt").replace(/,/g, "")) > parseFloat($F("premAmt").replace(/,/g, ""))) {
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmt");
			result = false;
			return false;
		}else if (parseFloat($F("surchargeAmt").replace(/,/g, "")) > parseFloat($F("premAmt").replace(/,/g, ""))) {
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmt");
			result = false;
			return false;
		}else if (unformatCurrency("discountAmt") > (parseFloat(computeNetPremPolDisc()) + unformatCurrency("surchargeAmt"))){
			function ok(){
				$("discountAmt").focus();
				clearPreTextValue("discountAmt");
			}
			showWaitingMessageBox("Invalid discount amount. Adding of discount will result to negative Net Premium Amount.", imgMessage.ERROR, ok);
			result = false;
			return false;
		}else{
			if ($F("discountAmt").replace(/,/g, "") != ""){
				function ok(){
					$("discountAmt").focus();
					clearPreTextValue("discountAmt");
				}	
				createTempBasic();
				var validate = validateSurchargeAmt();
				if (validate=="1"){
					showWaitingMessageBox("Invalid discount amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}else if (validate=="2"){
					showWaitingMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}		
				
				$$("div[name='rowBasicTempOnly']").each(function(row){
					row.remove();		 
				});
			}	
			if ($("surchargeAmt").value != ""){
				function ok(){
					$("surchargeAmt").focus();
					clearPreTextValue("surchargeAmt");
				}	
				createTempBasic();
				var validate = validateSurchargeAmt();
				if (validate=="1"){
					showWaitingMessageBox("Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}else if (validate=="2"){
					showWaitingMessageBox("Cannot add surcharge. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}		
				
				$$("div[name='rowBasicTempOnly']").each(function(row){
					row.remove();		 
				});	
				
				$$("div[name='rowBasicTempOnly']").each(function(row){
					row.remove();		
				});
			}
		}	
		return result;	
	}	
	
	function showBasicButton(param){
		if(param){
			$('btnAddDiscount').value = "Update"; //change by steven 10/01/2012 from "Add"
			enableButton("btnAddDiscount");		  //change by steven 10/02/2012 from disableButton
			enableButton("btnDelDiscount");
		}else{
			resetBasicDiscountForm1();
		}
	}
	
	generateSequenceGIPIS143();
}catch (e) {
	showErrorMessage("basicDiscountListing.jsp", e);
	//showMessageBox("Policy discount listing - "+e.message, imgMessage.ERROR);
}	
</script>