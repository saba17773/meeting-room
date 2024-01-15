<?php
$app->get('/dessert', '\App\Dessert\DessertController:index');
$app->get('/dessert/load', '\App\Dessert\DessertController:load');
$app->post('/dessert/create', '\App\Dessert\DessertController:create');
$app->post('/dessert/delete', '\App\Dessert\DessertController:delete');