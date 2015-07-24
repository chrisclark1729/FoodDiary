
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define('updateRecurringMeal', function(request, response) {
	
	var FoodDiaryEntries = Parse.Object.extend('FoodDiaryEntries');
	
   //Get the most recently updated food diary entry where calories aren't set
	var query = new Parse.Query(FoodDiaryEntries);
	
	// query.equalTo('user', Parse.User.current());
	query.equalTo('user', "chris test")
	query.equalTo('calories', 0)
	query.descending(updatedAt)
	query.limit(1);
	
	var query2 = new Parse.Query(FoodDiaryEntries);
	query.find({
		success: function(results) {
			if (results.length >0) {
				query2.equalTo('user', "chris test")
				query2.equalTo('mealName', results.get('FoodDiaryEntries').mealName) }
				query2.limit(1);
				response.success();
			} else {
				response.error('No match')
			}
			
		}

		
	})

	
	query.find
	
	
}
