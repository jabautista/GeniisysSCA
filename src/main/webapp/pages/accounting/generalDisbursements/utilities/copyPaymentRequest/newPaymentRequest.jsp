<div class="sectionDiv" style="width: 300px; padding: 10px auto; margin: 10px auto;">
	<table align="center" cellspacing="5px" style="margin: 0 auto;">
		<tr>
			<td style="text-align: center;">
				<span>This Payment Request No. :</span>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;">
				<span id="oldPaytReqNoSpan"></span>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;">
				<span>Had Been Copied To Payment Request No. :</span>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;">
				<span id="newPaytReqNoSpan"></span>
			</td>
		</tr>
	</table>
	<center><input type="button" class="button" id="btnOk" value="Ok" style="margin: 10px;" /></center>
</div>
<script type="text/javascript" >
	try {
		
		$("oldPaytReqNoSpan").innerHTML = 	"<strong>" + 
											objGIACS045.documentCdFrom + " - " + 
											objGIACS045.branchCdFrom + " - " + 
											objGIACS045.lineCdFrom + " - " + 
											objGIACS045.docYearFrom + " - " + 
											formatNumberDigits(objGIACS045.docMmFrom, 6) + " - " + 
											formatNumberDigits(objGIACS045.docSeqNoFrom, 6) +
										  	"</strong>";
	  	
	  	$("newPaytReqNoSpan").innerHTML = 	"<strong>" + 
											objGIACS045.documentCdTo + " - " + 
											objGIACS045.branchCdTo + " - " + 
											objGIACS045.lineCdTo + " - " + 
											objGIACS045.docYearTo + " - " + 
											formatNumberDigits(objGIACS045.docMmTo, 6) + " - " + 
											formatNumberDigits(objGIACS045.docSeqNoTo, 6) +
										  	"</strong>";
										  	
		function resetForm() {
			$('chkAcctgEntries').checked = true;
			$('txtDocumentCdFrom').clear();
			$('txtBranchCdTo').clear();
			$('txtLineCdFrom').enable();
			$('lineCdFromSpan').setStyle({background : 'white'});
			$('txtDocumentCdTo').clear();
			$('txtBranchCdFrom').clear();
			$('txtLineCdFrom').clear();
			$('txtDocYearFrom').clear();
			$('txtDocMmFrom').clear();
			$('txtDocSeqNoFrom').clear();
			$('txtBranchCdFrom').readOnly = true;
			$('txtLineCdFrom').readOnly = true;
			$('txtDocYearFrom').readOnly = true;
			$('txtDocMmFrom').readOnly = true;
			$('txtDocSeqNoFrom').readOnly = true;
			checkDocumentCd = '';
			checkBranchCd = '';
			checkLineCd = '';
			checkDocYear = '';
			checkDocSeqNo = '';
			disableSearch('imgBranchCdFrom');
			disableSearch('imgLineCdFrom');
			disableSearch('imgDocYearFrom');
			disableSearch('imgDocSeqNoFrom');
			disableButton('btnCopy');
			$('txtLineCdTo').clear();
			$('txtDocYearTo').clear();
			$('txtDocMmTo').clear();
			$('txtDocSeqNoTo').clear();
			$('txtTranDateFrom').clear();
			disableDate('imgTranDate');
			$('btnCopy').disable();
			$('txtDocumentCdFrom').focus();
		}
										  	
	  	$("btnOk").focus();
		$("btnOk").observe("click", function() {
			resetForm();
			overlayNewPmaymentRequest.close();
			delete overlayNewPmaymentRequest;
		});
		 
	} catch(e) {
		showErrorMessage("overlay error: " , e);
	}
</script>