

/**
 * Prepare parameters for servlet
 * 
 * @author rencela 09/21/2010
 * @param formToBeSerialized -
 *            id of form
 * @param otherPreSerializedParameters -
 *            string of preformated parameters (e.g.
 *            "&aParameter=value1&aParameter=value2")
 * @return complete parameters
 */
function serializeParameters(formToBeSerialized, otherPreSerializedParameters) {
	var serializedParameters = Form.serialize(formToBeSerialized);
	serializedParameters += otherPreSerializedParameters;
	return serializedParameters;
}