<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="tableHeader" style="width: 100%;">
	<label style="width: 25%; text-align: center; margin-left: 56px;">Quotation No.</label>
	<label style="width: 15%; text-align: center;">Assured No.</label>
	<label style="text-align: center;">Assured Name</label>
</div>
<div id="packQuoteTableDiv" name="packQuoteTableDiv" class="tableContainer">
	<c:forEach var="quote" items="${quoteList}" varStatus="ctr">
		<div id="row2${quote.packQuoteId}" name="row2" class="tableRow" style="width: 99.7%;">
			<label style="width: 25%; text-align: left; display: block; margin-left: 50px;">${quote.lineCd}-${quote.sublineCd}-${quote.issCd}-${quote.quotationYy}-${quote.quotationNo}-${quote.proposalNo}</label>
			<label style="width: 15%; text-align: left; display: block; margin-left: 10px;" title="${quote.assdNo}">${quote.assdNo}<c:if test="${empty quote.assdNo}">---</c:if></label>
   			<label style="text-align: left; display: block;" name="text">${quote.assdName}<c:if test="${empty quote.assdName}">---</c:if></label>
   			<input type="hidden" id="packQuoteId${quote.packQuoteId}"	name="packQuoteId"		value="${quote.packQuoteId}">
   			<input type="hidden" id="issCd${quote.packQuoteId}"			name="issCd"			value="${quote.issCd}">
   			<input type="hidden" id="lineCd${quote.packQuoteId}"		name="lineCd"			value="${quote.lineCd}">
   			<input type="hidden" id="sublineCd${quote.packQuoteId}"		name="sublineCd"		value="${quote.sublineCd}">
   			<input type="hidden" id="quotationYy${quote.packQuoteId}" 	name="quotationYy" 		value="${quote.quotationYy}">
   			<input type="hidden" id="quotationNo${quote.packQuoteId}"	name="quotationNo"		value="${quote.quotationNo}">
   			<input type="hidden" id="proposalNo${quote.packQuoteId}" 	name="proposalNo"		value="${quote.proposalNo}">
   			<input type="hidden" id="assdNo${quote.packQuoteId}"		name="assdNo"			value="${quote.assdNo}">
   			<input type="hidden" id="assdName${quote.packQuoteId}"		name="assdName"			value="${quote.assdName}">
   			<input type="hidden" id="assured${quote.packQuoteId}"		name="assured"			value="${quote.assured}">
   			<input type="hidden" id="assdActiveTag${quote.packQuoteId}"	name="assdActiveTag"	value="${quote.assdActiveTag}">
   			<input type="hidden" id="validDate${quote.packQuoteId}"		name="validDate"		value="${quote.validDate}">
		</div>
	</c:forEach>
</div>
<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
		
<script type="text/javaScript">
	try{
		$$("div[name='row2']").each(
			function (row)	{
				row.observe("mouseover", function ()	{
					row.addClassName("lightblue");
				});
				
				row.observe("mouseout", function ()	{
					row.removeClassName("lightblue");
				});
		
				row.observe("click", function ()	{
					row.toggleClassName("selectedRow");
					if (row.hasClassName("selectedRow")){
						$$("div[name='row2']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
	
						var packQuoteId		= row.down("input", 0).value;
						var issCd			= row.down("input", 1).value;
						var	lineCd 			= row.down("input", 2).value;
						var sublineCd		= row.down("input", 3).value;
						var quotationYy		= row.down("input", 4).value;
						var	quoteNo 		= row.down("input", 5).value;
						var proposalNo		= row.down("input", 6).value;
						var assdNo			= row.down("input", 7).value;
						var assdName		= row.down("input", 8).value;
						var assd			= row.down("input", 9).value;
						var assdActiveTag	= row.down("input", 10).value;
						var validDate		= row.down("input", 11).value;

						$("packQuoteId").value = packQuoteId;
						$("selectedPackQuoteId").value = packQuoteId;
						$("selectedIssCd").value = issCd;
						$("selectedLineCd").value = lineCd;
						$("selectedSublineCd").value = sublineCd;
						$("selectedQuotationYy").value = quotationYy;
						$("selectedQuotationNo").value = quoteNo;
						$("selectedProposalNo").value = proposalNo;
						$("selectedAssdNo").value = assdNo;
						$("selectedAssdName").value = assdName;
						$("selectedAssd").value = assd;
						$("selectedAssdActiveTag").value = assdActiveTag;
						$("selectedValidDate").value = validDate;
					}else{
						
						clearSelectedPackDiv();
					}		
				});
			

				row.observe("dblclick", function(){
					var packQuoteId		= row.down("input", 0).value;
					var issCd			= row.down("input", 1).value;
					var	lineCd 			= row.down("input", 2).value;
					var sublineCd		= row.down("input", 3).value;
					var quotationYy		= row.down("input", 4).value;
					var	quoteNo 		= row.down("input", 5).value;
					var proposalNo		= row.down("input", 6).value;
					var assdNo			= row.down("input", 7).value;
					var assdName		= row.down("input", 8).value;
					var assd			= row.down("input", 9).value;
					var assdActiveTag	= row.down("input", 10).value;
					var validDate		= row.down("input", 11).value;

					$("packQuoteId").value = packQuoteId;
					$("selectedPackQuoteId").value = packQuoteId;
					$("selectedIssCd").value = issCd;
					$("selectedLineCd").value = lineCd;
					$("selectedSublineCd").value = sublineCd;
					$("selectedQuotationYy").value = quotationYy;
					$("selectedQuotationNo").value = quoteNo;
					$("selectedProposalNo").value = proposalNo;
					$("selectedAssdNo").value = assdNo;
					$("selectedAssdName").value = assdName;
					$("selectedAssd").value = assd;
					$("selectedAssdActiveTag").value = assdActiveTag;
					$("selectedValidDate").value = validDate;
					checkIfValidDatePack();
				});
			}
		);
		
		function checkIfValidDatePack(){
			var packQuoteId = $F("packQuoteId");
			if ((packQuoteId == null)||(packQuoteId == "0")){
				showMessageBox("Please select a quotation.", imgMessage.ERROR);
			} else {
				var today = new Date();
				var validDate = new Date();
				validDate = 	Date.parse($F("selectedValidDate"));
				if (validDate < today){
					showConfirmBox("Validity Date Verification", "Validity Date has expired.  Would you like to continue?", "OK", "Cancel", checkUserOverride, "");
				} else {
					//$("override").value = "TRUE";
					//turnQuoteToPAR();
					//getIssCdForSelectedQuote("save");\
					prepareQuotation();
				}
			} 
		}

		function prepareQuotation(){
			var packLineCdSel = $("packLineCdSel");
			var packIssCd = $("packIssCd");

			$("packIssCd").value = $F("selectedIssCd");
			$("packLineCdSel").value = $F("selectedLineCd");

			$("packIssCd").disabled = true;
			$("packLineCdSel").disabled = true;
			/*
			$("packIssCd").childElements().each(function(o){
				o.hide(); o.disabled = true;
			});

			$("packLineCdSel").childElements().each(function(o){
				o.hide(); o.disabled = true;
			});*/
			showConfirmBox3("Create PAR from Quote ", "This option will automatically create a PAR record with all the information entered in the quotation after you save the par. Do you want to continue?", "Yes", "Cancel", turnPackQuoteToParTemp, /*checkIfCancelPARCreation*/"");
		}
		function turnPackQuoteToParTemp(){
			var selectedPackQuoteId			= $("selectedPackQuoteId").value;
			var issCd			= $("selectedIssCd").value;
			var lineCd			= $("selectedLineCd").value;
			var sublineCd		= $("selectedSublineCd").value;
			var quotationYy		= $("selectedQuotationYy").value;
			var quoteNo			= $("selectedQuotationNo").value;
			var proposalNo		= $("selectedProposalNo").value;
			var assdNo			= $("selectedAssdNo").value;
			var assdName		= $("selectedAssdName").value;
			var assdActiveTag	= $("selectedAssdActiveTag").value;
			var vAssdFlag		= false;
			
			// assign values to hiddent fields
			$("packQuoteId").value = selectedPackQuoteId;
			$("vlineCd").value = lineCd;
			$("vissCd").value = issCd;
			$("assuredName").value			= assdName;
			$("assuredNo").value			= assdNo;
			$("quoteSeqNo").value = "00";
			$("year").value = $("parYy").value;
			$("fromPackQuotation").value = "Y";
			if (($F("globalParId") == "0")||($F("globalParId") == "")){
				assuredListingFromPAR = 2;
				if (assdActiveTag == "N"){
					if ((assdNo == "") && (assdName == "")){
						showWaitingMessageBox("Assured is required, please choose from the list.", "info", function(){
							hideOverlay(); 
							openSearchClientModal2();
						});
					} else {
						showWaitingMessageBox("The assured that was assigned in the quotation cannot be found, please assign a new one.", "info", function(){
							hideOverlay(); 
							openSearchClientModal();
						});
					}
				} else { //if assdActiveTag is Y
					getPackAssuredValues();
				}
			}	
		}
		function checkUserOverride(){
			if ("TRUE" == $F("userOverrideAuthority")){
				prepareQuotation();
			} else {
				showMessageBox("User has no override authority.", imgMessage.INFO);
			}
		}

		$$("label[name='text']").each(function (label)	{
			if ((label.innerHTML).length > 60)	{
				label.update((label.innerHTML).truncate(60, "..."));
			}
		});
		
		if (!$("pager").innerHTML.blank()) {
			try {
				initializePagination("selectPackQuotationListingDiv", "/GIPIPackQuoteController?"+Form.serialize("createPackPARForm"), "filterPackQuoteListing");
			} catch (e) {
				showErrorMessage("selectPackQuotationListingTable1 - pager", e);
			}
		}
		
		$("pager").setStyle("margin-top: 10px;");
	}catch(e){
		showErrorMessage("selectPackQuotationListingTable - pager", e);
	}	

</script>