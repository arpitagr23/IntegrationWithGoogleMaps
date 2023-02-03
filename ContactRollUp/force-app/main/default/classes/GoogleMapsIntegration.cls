public with sharing class GoogleMapsIntegration {
    @future(callout=true)
    public static void getAuthorization(Set<Id> accIds){
        //* Setup your http request
        List<Account> accWithCoordinates = [SELECT Id, Name, Coordinates__latitude__s, Coordinates__longitude__s FROM Account WHERE Coordinates__latitude__s!=NULL AND Coordinates__longitude__s!=NULL AND ID IN:accIds];
        List<Account> updateAcc = new List<Account>();
        for(Account acc : accWithCoordinates){
            HttpRequest request = new HttpRequest();
            request.setMethod('GET'); 
            String APIKey = 'AIzaSyAdaOHokyRwndivibQQvZr2UHyl5m-Bh1s';
            String key = '&key=' + APIKey;
            // https://maps.googleapis.com/maps/api/geocode/json?latlng=17.4577589,78.3610649&key=AIzaSyAdaOHokyRwndivibQQvZr2UHyl5m-Bh1s
            String billingLatitude = String.valueOf(acc.Coordinates__latitude__s);
            String billingLongitude = String.valueOf(acc.Coordinates__longitude__s);
            String endPoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=';
            request.setEndpoint(endPoint + billingLatitude + ',' + billingLongitude + key);
            Http http = new Http();
            HttpResponse response = http.send(request);
            Map<String,Object> jsonParse = (Map<String,Object>)Json.deserializeUntyped(response.getBody());
            List<Object> results = (List<Object>)jsonParse.get('results');
            Map<String,Object> firstResult = (Map<String,Object>)results[0];
            List<Object> firstAddressComponents = (List<Object>)firstResult.get('address_components');
            String tempAddress = ''; 
            String pCode = '';
            String cCode = '';
            String state = '';
            for(Integer i=0; i<firstAddressComponents.size();i++){
                Map<String, Object> tempAdd = (Map<String, Object>)firstAddressComponents[i];
                String type = String.valueOf(tempAdd.get('types'));
                type = type.replaceAll('[^\\w\\s]', '');
                String[] newType = type.split('\\ ');
                //System.debug(postalCode);
                if(newType[0].equalsIgnoreCase('postal_code'))
                    pCode = String.valueOf(tempAdd.get('long_name'));
                    
                if(newType[0].equalsIgnoreCase('country'))
                    cCode = String.valueOf(tempAdd.get('long_name'));

                if(newType[0].equalsIgnoreCase('administrative_area_level_1'))
                    state = String.valueOf(tempAdd.get('short_name'));

                if(!newType[0].equalsIgnoreCase('postal_code') && !newType[0].equalsIgnoreCase('country') && !newType[0].equalsIgnoreCase('administrative_area_level_1') && !newType[0].equalsIgnoreCase('postal_code_suffix'))
                    tempAddress = tempAddress + String.valueOf(tempAdd.get('long_name')) + ' ';
                
            } 
            acc.BillingStreet = tempAddress;
            acc.BillingState = state;
            acc.BillingPostalCode = pCode;
            acc.BillingCountry = cCode;
            
            updateAcc.add(acc);
        }
        update updateAcc;
    }
}

//GoogleMapsIntegration.getAuthorization();