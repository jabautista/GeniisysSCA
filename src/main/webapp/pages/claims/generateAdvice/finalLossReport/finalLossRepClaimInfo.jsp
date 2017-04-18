<div id="claimInfoDiv" name="claimInfoDiv" class="sectionDiv" style="height: 225px; padding-top: 15px;">
	<div id="claimInfoInnerDiv" name="claimInfoInnerDiv" style="margin-left: 100px;">
		<table>
			<tr>
				<td align="right">Claim No.</td>
				<td colspan="3"><input id="claimNo" name="claimNo" type="text" readonly="readonly" style="width: 225px;"></td>
				<td align="right"><label style="margin-left: 20px;">Loss Category</label></td>
				<td><input id="category" name="category" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Policy No.</td>
				<td colspan="3"><input id="policyNo" name="policyNo" type="text" readonly="readonly" style="width: 225px;"></td>
				<td align="right">Date of Loss</td>
				<td><input id="dateOfLoss" name="dateOfLoss" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Assured Name</td>
				<td colspan="3"><input id="assdName" name="assdName" type="text" readonly="readonly" style="width: 225px;"></td>
				<td align="right">Date Reported</td>
				<td><input id="dateReported" name="dateReported" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Address</td>
				<td colspan="3"><input id="address" name="address" type="text" readonly="readonly" style="width: 225px;"></td>
				<td align="right">Place of Loss</td>
				<td><input id="placeOfLoss1" name="placeOfLoss1" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Issue Date</td>
				<td colspan="3"><input id="issueDate" name="issueDate" type="text" readonly="readonly" style="width: 225px; margin-right: 20px;"></td>
				<td align="right">Agent</td>
				<td><input id="agent" name="agent" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Term of Cover</td>
				<td><input id="fromTerm" name="fromTerm" type="text" readonly="readonly" style="width: 80px;"></td>
				<td>to</td>
				<td><input id="toTerm" name="toTerm" type="text" readonly="readonly" style="width: 80px; margin-left: 20px;"></td>
				<td align="right">Mortgagee</td>
				<td><input id="mortgagee" name="mortgagee" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right"><label style="margin-bottom: 3px; float: right;">Advice No.</label></td>
				<td colspan="3">
					<span class="lovSpan" style="width: 231px;">
						<input id="adviceNo" name="adviceNo" type="text" readonly="readonly" style="border: none; float: left; width: 200px; height: 13px; margin: 0px;" value="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="adviceNoBtn" name="adviceNoBtn" alt="Go" style="float: right;"/>
						<input id="adviceId" name="adviceId" type="hidden" value="">
					</span>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var lineCd = '${lineCd}';

 	$("adviceNoBtn").observe("click", function(){
		showAdviceNoLov('${claimId}');
	});

	function showAdviceNoLov(claimId){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action: "getAdviceNoLov",
								claimId: claimId
							   },
				title: "Advice No.",
				width: 400,
				height: 386,
				columnModel:[
								{	id : "adviceId",
									title: "",
									width: '0px',
									visible: false
								},
								{	id : "adviceNo",
									title: "Advice No",
									width: '385px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("adviceId").value = row.adviceId;
						$("adviceNo").value = row.adviceNo;
						lineCd == "SU" ? null : itemInfoTableGrid._refreshList();
					}
				}
			});
		}catch(e){
			showErrorMessage("showAdviceNoLov",e);
		}
	}
</script>