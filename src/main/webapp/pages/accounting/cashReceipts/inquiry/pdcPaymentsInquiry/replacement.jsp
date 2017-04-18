<div id="detailsDiv" style="width: 98%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 5px;">
		<table align="center" style="width: 98.5%">
			<tr>
				<td>Bank</td>
				<td class="rightAligned">Check Number</td>
				<td class="rightAligned">Amount</td>
				<td style="width : 100px;"></td>
				<td>Replace Date</td>
			</tr>
			<tr>
				<td><input type="text" readonly="readonly" id="txtBankSname" tabindex="1001"/></td>
				<td><input type="text" readonly="readonly" id="txtCheckNo" tabindex="1002"/></td>
				<td><input type="text" readonly="readonly" id="txtCheckAmt" style="text-align: right;" tabindex="1003"/></td>
				<td></td>
				<td><input type="text" readonly="readonly" id="txtReplaceDate" tabindex="1004"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="padding: 5px;">
		<div style="padding-top: 5px; padding-left: 5px;">
			<div id="replacementTable" style="height: 135px;"></div>
		</div>
		<div>
			<input type="text" id="txtTotAmt" readonly="readonly" style="text-align: right; float: right; margin-right: 20px;" tabindex="1005"  />
			<label style="float: right; margin: 7px;">Net Total</label>
		</div>
		<center style=" clear: both;"><input type="button" class="button" id="btnReturn" value="Return" style=" margin-top: 10px; width: 100px;" tabindex="1006"/></center>
	</div>
</div>
<script type="text/javascript">
	try {
		$("txtBankSname").focus();
		
		var jsonGIACS092Replacement = JSON.parse('${jsonGIACS092Replacement}');
		replacementTableModel = {
				url: contextPath+"/GIACInquiryController?action=showGIACS092Replacement&refresh=1&pdcId="+objGIACS092.pdcId,
				options: {
					width: '677px',
					height: '106px',
					onCellFocus : function(element, value, x, y, id) {
						tbgReplacement.keys.removeFocus(tbgReplacement.keys._nCurrentFocus, true);
						tbgReplacement.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgReplacement.keys.removeFocus(tbgReplacement.keys._nCurrentFocus, true);
						tbgReplacement.keys.releaseKeys();
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: 'itemNo',
						title : 'Item No',
						width: "70",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
							return formatNumberDigits(value, 4);
						}
					},
					{
						id: 'payMode',
						title : 'Pay Mode',
						width: "65",
					},
					{
						id: 'bankSname2',
						title : 'Bank',
						width: "90"
					},
					{
						id: 'checkClass',
						title : 'Check Class',
						width: "90",
						renderer : function(value) {
							if(value == 'L')
								return "Local Clearing";
							else if(value == 'M')
								return "Manager's Check";
							else if(value == 'O')
								return "On-us";
							else if(value == 'R')
								return "Regional";
							else
								return '';
							
						}
					},
					{
						id: 'checkNo2',
						title : 'Check/Crdt Crd No.',
						width: "120px"
					},
					{
						id: 'checkDate',
						title : 'Check Date',
						width: "100px",
						align: 'center',
						titleAlign : 'center',
						renderer : function(value) {
					    	return dateFormat(value, 'mm-dd-yyyy');
					    }
					},
					{
						id: 'amount',
						title : 'Local Currency Amt',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'currencyDesc',
						title : 'Currency',
						width: "100px"
					},
					{
						id: '',
						title : 'OR No./APDC No.',
						width: "100px"
					},
					{
						id: 'grossAmt',
						title : 'Gross Amt',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'commissionAmt',
						title : 'Commission Amt',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'vatAmt',
						title : 'Vat Amt',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
					
				],
				rows : jsonGIACS092Replacement.rows
			};
		
		tbgReplacement = new MyTableGrid(replacementTableModel);
		tbgReplacement.pager = jsonGIACS092Replacement;
		tbgReplacement.render('replacementTable');
		tbgReplacement.afterRender = function (){
			tbgReplacement.keys.removeFocus(tbgReplacement.keys._nCurrentFocus, true);
			tbgReplacement.keys.releaseKeys();
			
			if(tbgReplacement.geniisysRows.length > 0){
				var rec = tbgReplacement.geniisysRows[0];
				$("txtBankSname").value = unescapeHTML2(rec.bankSname);
				$("txtCheckNo").value = rec.checkNo;
				$("txtCheckAmt").value = formatCurrency(rec.checkAmt);
				
				$("txtReplaceDate").value = rec.replaceDate == null ? null : dateFormat(rec.replaceDate, 'mm-dd-yyyy');
				$("txtTotAmt").value = formatCurrency(rec.totAmount);
			}
		};
		
		$("btnReturn").observe("click", function(){
			overlayReplacement.close();
			delete overlayReplacement;
		});
		
	} catch (e) {
		showErrorMessage("Error : " , e);
	}
</script>