      $(document).ready(function(){
        $("#added_contents").hide();
        $("#default_contents").show();
      });

      function get_recipe_list() {
        var _recipes = new Array();
        $.each( 
          $("#recipe_list tbody th"),
          function(key,val) {
            _recipes.push($(val).text());
          }
        );
        return _recipes;
      }
      function drow_recipe_list(recipe_list) {
        $("#recipe_list tbody").empty();
        for(var i in recipe_list) {
          $("#recipe_list tbody").append("<tr><th>" + recipe_list[i].name + "</th><td>" + recipe_list[i].price + "G</td><td><a href=\"#\" onclick=\"javascript:drop_recipes(this)\" class=\"btn\">削除</a></td></tr>");
        }
      }
      function add_recipes() {
	      $('#recipes_keyword').attr("disabled", "disabled");
        var _recipes = get_recipe_list();
        _recipes.push($('#recipes_keyword').val());
        reload_items(_recipes);
        return false;
      }
      function drop_recipes(elm) {
        $(elm).parents('tr').remove();
        reload_items(get_recipe_list());
        return false;
      }
      function reload_items(recipes) {
        $.getJSON("/recipes.json", { recipes : recipes }, function(json){
          drow_recipe_list(json.recipe_list);
          drow_item_list(json.item_list);
        });
        $('#recipes_keyword').val(null);
        if (recipes.length == 0) {
          $("#added_contents").hide();
          $("#default_contents").show();
        } else {
          $("#added_contents").show();
          $("#default_contents").hide();
        }
	$('#recipes_keyword').removeAttr("disabled");
      }
      function drow_item_list(item_list) {
        $("#item_list tbody").empty();
        for(var i in item_list) {
          var _cost = item_list[i].cost;
          if (_cost == 0) {
            _cost = '<span class="label label-warning">バザーのみ</a>';
          } else {
            _cost += "G";
	  }
          $("#item_list tbody").append('<tr><th>' + item_list[i].name + '<a href="/items?keyword=' + item_list[i].name + '" class="label label-warning">レシピ</a></th><td>' + item_list[i].count + "</td><td>" + _cost + "</td></tr>");
        }
      }
