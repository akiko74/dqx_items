function get_recipe_list(){var e=new Array;return $.each($("#recipe_list tbody th"),function(t,n){e.push($(n).text())}),e}function drow_recipe_list(e){$("#recipe_list tbody").empty();for(var t in e){var n=new Array,r="<tr><th>";r+='<a href="#" class="recipe_name" rel="popover" data-html="true" data-content="',r+="<ul>";for(var i in e[t].items)r+="<li>"+e[t].items[i].name+" × "+e[t].items[i].count,e[t].items[i].unitprice==0&&(n.push(e[t].items[i].name),r+="<span class='label label-warning'>バザー品</span>"),r+="</li>";r+="</ul>",r+='" data-title="',r+=e[t].name+"のレシピ",r+='" data-trigger="hover">',r+=e[t].name,r+="</a></th><td>"+e[t].price+"G",n.length>0&&(r+=' +<span class="label label-warning">バザー品</span>'),console.log(n),r+='</td><td><a href="#" onclick="javascript:drop_recipes(this)" class="btn btn-small btn-danger" style="color:white">削除</a>',r+="</td></tr>",$("#recipe_list tbody").append(r)}$("a[rel=popover].recipe_name").popover()}function add_recipes(){$("#recipes_keyword").attr("disabled","disabled");var e=get_recipe_list();return e.push($("#recipes_keyword").val()),reload_items(e),!1}function drop_recipes(e){return $(e).parents("tr").remove(),reload_items(get_recipe_list()),!1}function reload_items(e){$.getJSON("/recipes.json",{recipes:e},function(e){drow_recipe_list(e.recipe_list),drow_item_list(e.item_list)}),$("#recipes_keyword").val(null),e.length==0?($("#added_contents").hide(),$("#default_contents").show()):($("#added_contents").show(),$("#default_contents").hide()),$("#recipes_keyword").removeAttr("disabled")}function drow_item_list(e){$("#item_list tbody").empty();for(var t in e){var n=e[t].cost;n==0?n='<span class="label label-warning">バザーのみ</a>':n+="G",$("#item_list tbody").append("<tr><th>"+e[t].name+'<a href="/items?keyword='+e[t].name+'" class="label label-warning">レシピ</a></th><td>'+e[t].count+"</td><td>"+n+"</td></tr>")}}$(document).ready(function(){$("#added_contents").hide(),$("#default_contents").show()});