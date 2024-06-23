public without sharing class Utility {

    /**
     * Receives list of SObjects which are have a field in common and return a map of those SObjects
     * grouped by the field in common.
     * 
     * For example, if you have a list of Cases and you want to have a map of Cases by AccountId,
     * you could use this function.
     * @param sObjectList list of SObjects which are needed to be clasified
     * @param parentField API name of the field by that is needed to be clasified
     * @return a map of the SObjects where the keys are the values of the field received in parentField 
     * and for each key, a list with the records that have the same value in the field in parentField
     * 
     * parentField can also be a relative field, such as.
     * For instance: a list of cases that are needed to be clasified by the parent Account of the related account
     * parentField would be Account.ParentId
     * 
     */
    public static map<string, List<SObject>> clasifyChildByParent(list<SObject> sObjectList, string parentField){
        map<String, List<SObject>> retMap = new map<String, List<SObject>>();
        for(SObject i : sObjectList){
            String newValue = (String)GetFieldValue(i, parentField);
            if(!retMap.containsKey(newValue)){
                retMap.put(newValue, new list<SObject>());
            }
            retMap.get(newValue).add(i);
        }
        return retMap;
    }

    /**
     * Receives an object and the API name of a field in the object and returns the value of the field.
     * The field can be a relative field, For instance, if you need to get the ParentId of the Account related to a case,
     * You can pass the Case in obj and Account.ParentId in fieldName
     * 
     * This function is useful if you do not have the SObject in your hand and you need to extract a field value
     * from a relation of the object.
     * 
     */

    public static Object getFieldValue(SObject obj, String fieldName) {
        if(fieldName.indexOf('.') == -1) {
            return obj.get(fieldName);
        }else{
            List<String> split = fieldName.split('\\.');
            String directField = split[0];
            String indirectField = split.size() == 2 ? split[1] : fieldName.substring(fieldName.indexOf('.') + 1);
            SObject relatedObject = obj.getSObject(directField);
            if(relatedObject != null){
                return GetFieldValue(relatedObject, indirectField);
            }
        }

        return null;
    }
}