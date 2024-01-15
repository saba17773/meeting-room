<?php
$app->get('/food', '\App\Food\FoodController:index');
$app->get('/food/load', '\App\Food\FoodController:load');
$app->get('/food/load/picture', '\App\Food\FoodController:loadpicture');
$app->get('/food/load/picture/dessert', '\App\Food\FoodController:loadpicturedessert');
$app->post('/food/create', '\App\Food\FoodController:create');
$app->post('/food/delete', '\App\Food\FoodController:delete');