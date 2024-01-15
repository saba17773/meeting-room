<?php
$app->get('/layout', '\App\Layout\LayoutController:index');
$app->get('/layout/load', '\App\Layout\LayoutController:load');
$app->get('/layout/load/picture', '\App\Layout\LayoutController:loadpicture');
$app->post('/layout/create', '\App\Layout\LayoutController:create');
$app->post('/layout/delete', '\App\Layout\LayoutController:delete');