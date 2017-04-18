<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="prelimClaimInfoDiv" name="prelimClaimInfoDiv" class="sectionDiv" style="height: 225px; padding-top: 15px;">
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
				<td></td>
				<td><input id="placeOfLoss2" name="placeOfLoss2" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Term of Cover</td>
				<td><input id="fromTerm" name="fromTerm" type="text" readonly="readonly" style="width: 80px;"></td>
				<td>to</td>
				<td><input id="toTerm" name="toTerm" type="text" readonly="readonly" style="width: 80px; margin-left: 20px;"></td>
				<td></td>
				<td><input id="placeOfLoss3" name="placeOfLoss3" type="text" readonly="readonly" style="width: 225px;"></td>
			</tr>
			<tr>
				<td align="right">Agent</td>
				<td colspan="3">
					<select id="agent" name="agent" style="width: 233px;">
						<c:forEach var="a" items="${agentList}">
							<option value="${a}">${a}</option>
						</c:forEach>
					</select>
				</td>
				<td align="right">Mortgagee</td>
				<td>
					<select id="mortgagee" name="mortgagee" style="width: 233px;">
						<c:forEach var="m" items="${mortgageeList}">
							<option value="${m}">${m}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</div>
</div>