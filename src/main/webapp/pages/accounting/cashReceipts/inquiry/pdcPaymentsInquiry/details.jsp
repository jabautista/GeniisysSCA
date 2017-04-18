<div id="detailsDiv" style="width: 98%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 5px;">
		<div style="padding-top: 5px; padding-left: 5px;">
			<div id="detailsTable" style="height: 135px;"></div>
		</div>
	</div>
	<div class="sectionDiv" style="padding: 5px;">
		<div style="text-align: right; margin: 5px 10px 10px;">
			<span>Totals</span>
			<input type="text" id="txtTotCollectionAmt" readonly="readonly" style="width: 120px;" tabindex="1001" />
			<input type="text" id="txtTotPremiumAmt" readonly="readonly" style="width: 120px;" tabindex="1002"/>
			<input type="text" id="txtTotTaxAmt" readonly="readonly" style="width: 120px;" tabindex="1003"/>
		</div>
		<table style="margin: 15px auto 0;">
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="3">
					<input type="text" id="txtAssdName" style="width: 450px;" readonly="readonly" tabindex="1004"/> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Policy/Endorsement No.</td>
				<td colspan="3">
					<input type="text" id="txtPolicyNo" style="width: 450px;" readonly="readonly" tabindex="1005"/> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User Id</td>
				<td>
					<input type="text" id="txtUserId" style="width: 150px;" readonly="readonly" tabindex="1006" /> 
				</td>
				<td class="rightAligned">Last Update</td>
				<td>
					<input type="text" id="txtLastUpdate" style="width: 185px;" readonly="readonly" tabindex="1007"/> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Currency</td>
				<td colspan="3">
					<input type="text" id="txtCurrencyDesc" readonly="readonly" style="width: 450px;" tabindex="1008"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Rate</td>
				<td>
					<input type="text" id="txtCurrencyRt" readonly="readonly" style="text-align: right; width: 150px;" tabindex="1009"/>
				</td>
				<td class="rightAligned">Foreign Curr. Amt</td>
				<td>
					<input type="text" id="txtFCurrencyAmt" readonly="readonly" style="text-align: right; width: 185px;" tabindex="1010" />
				</td>
			</tr>
		</table>
		<center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px; width: 100px;" tabindex="1011"/></center>
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("txtTotCollectionAmt").focus();
		
		var jsonGIACS092Details = JSON.parse('${jsonGIACS092Details}');
		detailsTableModel = {
				url: contextPath+"/GIACInquiryController?action=showGIACS092Details&refresh=1&pdcId="+objGIACS092.pdcId,
				options: {
					width: '677px',
					height: '106px',
					onCellFocus : function(element, value, x, y, id) {
						tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
						tbgDetails.keys.releaseKeys();
						setDetails2(tbgDetails.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
						tbgDetails.keys.releaseKeys();
						setDetails2(null);
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
						id: 'transactionType',
						title : 'Tran Type',
						width: "70",
						align: 'right',
						titleAlign: 'right'
					},
					{
						id: 'issCd',
						title : 'Iss Cd',
						width: "50",
					},
					{
						id: 'premSeqNo',
						title : 'Bill/CM No.',
						width: "90",
						align : 'right',
						titleAlign : 'right',
						renderer : function(value) {
							return value == '' ? '' : formatNumberDigits(value,13); 
						}
					},
					{
						id: 'instNo',
						title : 'Inst No.',
						align : 'right',
						titleAlign : 'right',
						width: "70",
					},
					{
						id: 'collectionAmt',
						title : 'Collection Amount',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'premiumAmt',
						title : 'Premium Amount',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'taxAmt',
						title : 'Tax Amount',
						width: "120px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
				],
				rows : jsonGIACS092Details.rows
			};
		
		tbgDetails = new MyTableGrid(detailsTableModel);
		tbgDetails.pager = jsonGIACS092Details;
		tbgDetails.render('detailsTable');
		tbgDetails.afterRender = function (){
			tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
			tbgDetails.keys.releaseKeys();
			
			if(tbgDetails.geniisysRows.length > 0){
				var rec = tbgDetails.geniisysRows[0];
				tbgDetails.selectRow('0');
				setDetails2(rec);
				$("txtTotCollectionAmt").value = formatCurrency(rec.totCollectionAmt);
				$("txtTotPremiumAmt").value = formatCurrency(rec.totPremiumAmt);
				$("txtTotTaxAmt").value = formatCurrency(rec.totTaxAmt);
			} else {
				$("txtTotCollectionAmt").value = "0.00";
				$("txtTotPremiumAmt").value = "0.00";
				$("txtTotTaxAmt").value = "0.00";
			}
		};
		
		function setDetails2(rec){
			if(rec != null){
				$("txtAssdName").value = unescapeHTML2(rec.assdName);
				$("txtPolicyNo").value = unescapeHTML2(rec.policyNo);
				$("txtUserId").value = rec.userId2;
				$("txtLastUpdate").value = dateFormat(rec.lastUpdate, 'mm-dd-yyyy HH:MM:ss TT');
				$("txtCurrencyDesc").value = unescapeHTML2(rec.currencyDesc);
				$("txtCurrencyRt").value = formatCurrency(rec.currencyRt);
				$("txtFCurrencyAmt").value = formatCurrency(rec.fCurrencyAmt);
			} else {
				$("txtAssdName").clear();
				$("txtPolicyNo").clear();
				$("txtUserId").clear();
				$("txtLastUpdate").clear();
				$("txtCurrencyDesc").clear();
				$("txtCurrencyRt").clear();
				$("txtFCurrencyAmt").clear();
			}
		}
		
		$("btnReturn").observe("click", function(){
			overlayDetails.close();
			delete overlayDetails;
		});
	} catch (e) {
		showErrorMessage("Error : " , e);
	}
</script>