/**
 * Create div invoiceTaxRow - ADD the object elsewhere! #dontForget - remove
 * IF loading invoice is too slow, elements in this function may be still be NULL
 * @return
 */
function createInvoiceTaxRow(invTaxObj){
	try{
		if(isInvoiceTaxLoaded(invTaxObj)){ // check this before calling this function!
			return false;
		}else{
			var newTaxDiv = new Element('div');
			newTaxDiv.setAttribute("name",	"invoiceTaxRow");
			newTaxDiv.setAttribute("id",	"invoiceTaxRow" + invTaxObj.taxCd);
			newTaxDiv.setAttribute("taxCode", invTaxObj.taxCd);
			newTaxDiv.addClassName("tableRow");
			var taxDescr = "";
			var taxOpts = $("selInvoiceTax").options;
			for(var i=0; i<taxOpts.length; i++){
				if(parseInt(taxOpts[i].getAttribute("value")) == parseInt(invTaxObj.taxCd)){
					taxDescr = taxOpts[i].innerHTML;
				}
				// compute default value
			}
			
			newTaxDiv.update('<label style="width: 40%; margin-left: 10%;">' + taxDescr + '</label>'
					+ '<label style="width: 30%; text-align: right;" 	class="money">' + formatCurrency(invTaxObj.taxAmt) + '</label>');
			
			loadRowMouseOverMouseOutObserver(newTaxDiv);
			
			newTaxDiv.observe("click",function(){
				newTaxDiv.toggleClassName("selectedRow");
				if (newTaxDiv.hasClassName("selectedRow")) {
					// remove select from other invTax
					$$("div[name='invoiceTaxRow']").each(function(li){
						if(newTaxDiv.getAttribute("id") != li.getAttribute("id")){
							li.removeClassName("selectedRow");
							clearChangeAttribute("invoiceInformationDiv");
							clearChangeAttribute("itemInformationDiv");
						}
					});
					
					var t = $("selInvoiceTax");
					for(var i = 0; i < t.length; i++) {
						if (t.options[i].value == invTaxObj.taxCd) {
							t.selectedIndex = i;
							$("selTaxId").selectedIndex = i;
							$("selRateInv").selectedIndex = i;
						}
					}
	
					$("txtTaxValue").value = formatCurrency(invTaxObj.taxAmt);
					
					if($("btnAddInvoice")!=null && $("btnAddInvoice")!=undefined){
						$("btnAddInvoice").value = "Update";
					}
					enableButton("btnDeleteInvoice");
				}else{
					clearInvoiceTaxForm();
					clearChangeAttribute("invoiceInformationDiv");
					clearChangeAttribute("itemInformationDiv");
				}
			});	
			
			$("invoiceTaxListingDiv").insert({
				bottom: newTaxDiv
			});
			
			$("invoiceTaxListingDiv").show();
			updateTaxAmountAndAmountDue();
			hideSelectedTaxDescriptions();
			return true;
		}
	}catch(e){
		return false;
	}
}